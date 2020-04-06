#!/usr/bin/env ruby

require 'arg0'
require 'rss-motor'
require 'yaml'

module Rss
  module Fanatic
    def self.help
      puts "
      RSS Fanatic

      to read rss from all sources in yaml use like
      $ rss-fanatic <-yaml /path/to/rss.yaml>

      to read rss from url
      $ rss-fanatic <-rss url-to-yaml>

      for this help
      $ rss-fanaitc <-h>
      "
    end
    def self.get_default_rss_yaml_path
        File.join File.dirname(File.expand_path __FILE__), 'rss.yaml'
    end

    def self.get_rss_yaml_path
      rss_yaml_path = Arg0::Console.value(['-yaml', '--rss-yaml']) || get_default_rss_yaml_path
      File.file?(rss_yaml_path) ? rss_yaml_path : nil
    end

    def self.get_rss_feed_url
      Arg0::Console.value_for(['-rss', '--rss-feed'])
    end

    def self.get_rss_feed(rss)
      url, elements, attribs = rss['source'], nodes_value(rss), nodes_attrib(rss)
      log_me "Running #{url} with RSS Motor and fetching required data..."
      items = Rss::Motor.rss_items url, elements, attribs
      download({'items' => items, 'url' => url,
                'elements' => elements, 'attribs' => attribs})
    end

    def self.get_rss_from_yaml(rss_yaml_path)
      rss_yaml = YAML.load_file(rss_yaml_path)['rss']
      rss_yaml.each_value.collect {|rss|
        get_rss_feed(rss)
      }
    end

    def self.fanaticize
      if Arg0::Console.switch?(['-h', '--help']) then
        help
        return
      end
      if (rss_yaml_path = get_rss_yaml_path) then
        get_rss_from_yaml(rss_yaml_path)
      end
      if (rss_urls = get_rss_feed_url) then
        attribs = Arg0::Console.value(['-na', '--attribs'])
        value = Arg0::Console.value(['-nv', '--value'])
        rss_urls.each{|url|
          rss = {"source" => url, "nodes_attrib" => attribs, "nodes_value" => value}
          get_rss_feed(rss)
        }
      end
    end

    def self.log_me(msg, caps='')
      puts "[+]#{caps.upcase} #{msg}"
    end

    def self.download(data)
      data['elements'] = ['enclosure'] if data['elements'].empty? &&
                                          data['attribs'].empty?
      puts "For #{data['url']}, downloading..."
      puts "\nData for elements:"
      data['elements'].each{|elem|
        items = data['items'].collect{|item|
          puts item['title']
          puts "enclosure: #{item[elem]}"
          puts "-"*25
          item[elem]
        }
        #puts items.join("\n")
        #puts ">>> #{data['items'][0]}"
      }
      puts "\nData for attribs:"
      data['attribs'].each{|elem_attrib|
        items = data['items'].collect{|item|
          item[elem_attrib.join(':')]
        }
        puts items.join("\n")
      }
    end

    def self.nodes_value(rss_yaml)
      nodes_value = rss_yaml['nodes_value'] || ''
      nodes_value.split(',').collect{|node| node.strip}
    end

    def self.nodes_attrib(rss_yaml)
      nodes_attrib_list = rss_yaml['nodes_attrib'] || ''
      _nodes_attrib      = {}
      nodes_attrib_list.split(',').collect{|node_dot_attrib|
        node_dot_attrib = node_dot_attrib.strip.split('.')
        _nodes_attrib[ node_dot_attrib[0] ] = node_dot_attrib[1]
      }
      _nodes_attrib
    end
  end
end

#!/usr/bin/env ruby

require 'rss-motor'
require 'yaml'

module Rss
  module Fanatic

    def self.get_rss_yaml
      fyl_yaml = File.join File.dirname(File.expand_path __FILE__), 'rss.yaml'
      YAML.load_file(fyl_yaml)['rss']
    end

    def self.fanaticize
      get_rss_yaml.each_value.collect {|rss|
        url, elements, attribs = rss['source'], nodes_value(rss),
                                  nodes_attrib(rss)
        log_me "Running #{url} with RSS Motor and fetching required data..."
        items = Rss::Motor.rss_items url, elements, attribs
        download({'items' => items, 'url' => url,
                  'elements' => elements, 'attribs' => attribs})
      }
    end

    def self.log_me(msg, caps='')
      puts "[+]#{caps.upcase} #{msg}"
    end

    def self.download(data)
      puts "For #{data['url']}, downloading..."
      data['elements'].each{|elem|
        items = data['items'].collect{|item| item[elem]}
        #puts ">>> #{items}"
        puts ">>> #{data['items'][0]}"
      }
      data['attribs'].each{|elem_attrib|
        items = data['items'].collect{|item| item[elem_attrib.join(':')]}
        puts items.join(", ")
      }
    end

    def self.nodes_value(rss_yaml)
      return ['enclosure'] if rss_yaml['nodes_value'].nil? &&
                        rss_yaml['nodes_attrib'].nil?
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

Rss::Fanatic.fanaticize

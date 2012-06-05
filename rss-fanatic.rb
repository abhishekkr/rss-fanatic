#!/usr/bin/env ruby

require 'rss-motor'
require 'yaml'

module Rss
  module Fanatic

    def self.urls_from_yml
      fyl_yaml = File.join File.dirname(File.expand_path __FILE__), 'rss.yaml'
      rss_yaml = YAML.load_file(fyl_yaml)['rss']
      rss_yaml.each_value.collect{|rss| rss['source']}
    end

    def self.items
      urls_from_yml.each do |url|
        items = Rss::Motor.rss_items url
        puts items
      end
    end
  end
end

Rss::Fanatic.items

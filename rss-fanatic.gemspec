# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rss-fanatic/version'

Gem::Specification.new do |spec|
  spec.name          = "rss-fanatic"
  spec.version       = Rss::Fanatic::VERSION
  spec.authors       = ["AbhishekKr"]
  spec.email         = ["abhikumar163@gmail.com"]
  spec.description   = %q{rss fanatic deals with your fanaticism for content from rss feed}
  spec.summary       = %q{it will let you maintain a list of RSS Feeds and grab whatever content web-page, enclosures, media-content, etc from it regularly}
  spec.homepage      = "http://github.com/abhishekkr/rss-fanatic"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'rss-motor', '>= 0.1.1'
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end

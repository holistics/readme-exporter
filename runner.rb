#!/usr/bin/env ruby

require './lib/readme_converter'
require 'json'

configs = JSON.parse(File.read('./config.json'))
README_API = configs['README_APIKEY']
IMAGE_PATH_PREFIX = configs['IMAGE_PATH_PREFIX']

SLUGS = %w(
  tunnel-setup
)

if __FILE__ == $0
  converter = ReadmeConverter.new(README_API, image_path_prefix: IMAGE_PATH_PREFIX)
  converter.run(SLUGS.uniq)
end

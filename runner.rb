#!/usr/bin/env ruby

require './lib/readme_converter'
require 'json'

configs = JSON.parse(File.read('./config.json'))
README_API = configs['README_APIKEY']

SLUGS = %w(
  faqs
  amazon-rds-setup
  cohort-retention
  amazon-aws-athena-setup
  tunnel-setup
  friendly-loading-messages
  geo-heatmap
  pie-chart-donut-chart
  bubble-chart
  connect-database
  query-syntax
  visualizations
  introduction
  embedded-analytics
)

if __FILE__ == $0
  converter = ReadmeConverter.new(README_API)
  converter.run(SLUGS.uniq)
end
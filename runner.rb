#!/usr/bin/env ruby

require './lib/readme_converter'
require 'json'

configs = JSON.parse(File.read('./config.json'))
README_API = configs['README_APIKEY']

TEMP = %w(
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
  whitelist-ip-addresses
  email-schedules
  job-queue-management
  manage-users
  datasets
  drill-through
  slack-schedules
  get-data-via-api
  export-google-sheet
  data-model
  bigquery-setup
  explore-data
  pivot-table
  dashboards
  create-holistics-db-user
  filters
  data-modeling-syntax
  working-with-dates
  connection-timeout-setting
  data-security
  line-chart
  shareable-links
  import-data
  mongodb-setup
  permission-system
  date-filters
  column-chart
  data-connections
  data-warehouses
  transform-models
  model-fields
  reporting
  map
  google-analytics-setup
  commenting-on-reports-and-dashboards
  facebook-ads-setup
  data-modeling
  sftp-schedules
  table
  radar-chart
  date-drill
  combination-chart
  scatter-chart
  export-data
  import-models
  data-manager
  themes-and-colors
  whitelist-holistics-ip-addresses
  annotations
  filter-suggestions
  area-chart
  query-editor
  bar-chart
  relationships
  transform-data
  data-types
  base-models
  data-source-management
  holistics-mechanism
  csv-setup
  conversion-funnel
  data-format
  gauge-chart
  word-cloud
  storage-settings
  metric-kpi
  google-spreadsheets-setup
  integrations
  private-workspace
  widgets
  pipedrive-setup
  google-analytics-setup
  text-filters
  fan-out-issue
  data-exploration
  drill-data
  data-schedules
  allow-external-connections
  settings
  holistics-cli
  enterprise-features
  field-filters
  truefalse-filters
  how-holistics-works
  troubleshooting
  sql-query-templates
  number-filters
  holistics-support-and-feature-requests
  import-latest-file-from-google-drive-folder
  data-caching
  user-attributes
  supported-location-formats
  datasets
  drilldowns
  view-and-edit-as-other-users
  row-level-permission
  product-versions
  metric-sheets
  embedded-analytics
  import-latest-file-from-google-drive-folder
)

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
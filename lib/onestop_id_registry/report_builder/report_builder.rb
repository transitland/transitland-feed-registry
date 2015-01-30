require 'mustache'
require 'sass'
require 'bootstrap-sass'

require_relative '../entities/feed'
require_relative '../entities/operator'
require_relative '../comparison_sources/gtfs_data_exchange'
require_relative '../comparison_sources/us_ntd'

module OnestopIdRegistry
  module ReportBuilder
    def self.build
      render
    end

    def self.hash_for_html_template
      {
        report_datetime: Time.now,
        feeds: Entities::Feed.all,
        operators: Entities::Operator.all,
        gtfs_data_exchange_comparison: ComparisonSources::GtfsDataExchange.compare_against_onestop_feeds,
        us_ntd_comparison: ComparisonSources::UsNtd.compare_against_onestop_operators
      }
    end

    def self.render
      File.open(File.join(__dir__, 'css', 'onestop-id-registry.scss'), 'r') do |template_file|
        engine = Sass::Engine.new(template_file.read, syntax: :scss)
        template_output = engine.render
        File.open(File.join(__dir__, '..', '..', '..', 'report', 'onestop-id-registry.css'), 'w') do |output_file|
          output_file.write(template_output)
        end
      end

      File.open(File.join(__dir__, 'html', 'index.html.mustache'), 'r') do |template_file|
        template_output = Mustache.render(template_file.read, hash_for_html_template)
        File.open(File.join(__dir__, '..', '..', '..', 'report', 'index.html'), 'w') do |output_file|
          output_file.write(template_output)
        end
      end
    end
  end
end

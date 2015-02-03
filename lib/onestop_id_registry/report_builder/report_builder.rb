require 'erb'
require 'ostruct'
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
        gtfs_data_exchange_comparisons: ComparisonSources::GtfsDataExchange.compare_against_onestop_feeds,
        us_ntd_comparisons: ComparisonSources::UsNtd.compare_against_onestop_operators
      }
    end

    def self.render
      # SASS --> CSS
      File.open(File.join(__dir__, 'css', 'onestop-id-registry.scss'), 'r') do |template_file|
        engine = Sass::Engine.new(template_file.read, syntax: :scss)
        template_output = engine.render
        File.open(File.join(__dir__, '..', '..', '..', 'report', 'onestop-id-registry.css'), 'w') do |output_file|
          output_file.write(template_output)
        end
      end

      # JS
      FileUtils::mkdir_p(report_build_file_path('js'))
      FileUtils.cp_r(Dir.glob(File.join(__dir__, 'js', '*.js')), report_build_file_path('js'))
      FileUtils.cp(File.join(Bootstrap::javascripts_path, 'bootstrap.min.js'), report_build_file_path('js/bootstrap.js'))

      # HTML
      File.open(File.join(__dir__, 'html', 'index.html.erb'), 'r') do |template_file|
        template = ERB.new(template_file.read)
        template_output = template.result(OpenStruct.new(hash_for_html_template).instance_eval { binding })
        # template_output = Mustache.render(template_file.read, hash_for_html_template)
        File.open(File.join(__dir__, '..', '..', '..', 'report', 'index.html'), 'w') do |output_file|
          output_file.write(template_output)
        end
      end
    end

    private

    def self.report_build_file_path(file_name)
      File.join(__dir__, '..', '..', '..', 'report', file_name)
    end
  end
end

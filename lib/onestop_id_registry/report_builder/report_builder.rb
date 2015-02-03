<<<<<<< Updated upstream
require 'erb'
require 'ostruct'
=======
>>>>>>> Stashed changes
require 'sass'
require 'bootstrap-sass'

require_relative '../entities/feed'
require_relative '../entities/operator'
require_relative '../comparison_sources/gtfs_data_exchange'
require_relative '../comparison_sources/us_ntd'

module OnestopIdRegistry
  module ReportBuilder
    def self.build
      dump_data_as_json
      assemble_static_assets
    end

<<<<<<< Updated upstream
    def self.hash_for_html_template
      {
        report_datetime: Time.now,
        feeds: Entities::Feed.all,
        operators: Entities::Operator.all,
        gtfs_data_exchange_comparisons: ComparisonSources::GtfsDataExchange.compare_against_onestop_feeds,
        us_ntd_comparisons: ComparisonSources::UsNtd.compare_against_onestop_operators
=======
    def self.dump_data_as_json
      report_data = {
        report_datetime: Time.now
>>>>>>> Stashed changes
      }
      FileUtils::mkdir_p(report_build_file_path('json'))
      File.open(report_build_file_path('json/report.json'), 'w') { |f| f.write(report_data.to_json) }
      File.open(report_build_file_path('json/feeds.json'), 'w') { |f| f.write(Entities::Feed.all(format: :json)) }
      File.open(report_build_file_path('json/operators.json'), 'w') { |f| f.write(Entities::Operator.all(format: :json)) }
      File.open(report_build_file_path('json/us_ntd_comparison.json'), 'w') { |f| f.write(JSON.generate(ComparisonSources::UsNtd.compare_against_onestop_operators)) }
      File.open(report_build_file_path('json/gtfs_data_exchange_comparison.json'), 'w') { |f| f.write(ComparisonSources::GtfsDataExchange.compare_against_onestop_feeds(format: :json)) }
    end

<<<<<<< Updated upstream
    def self.render
      # SASS --> CSS
=======
    def self.assemble_static_assets
>>>>>>> Stashed changes
      File.open(File.join(__dir__, 'css', 'onestop-id-registry.scss'), 'r') do |template_file|
        engine = Sass::Engine.new(template_file.read, syntax: :scss)
        template_output = engine.render
        File.open(report_build_file_path('onestop-id-registry.css'), 'w') do |output_file|
          output_file.write(template_output)
        end
      end

<<<<<<< Updated upstream
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
=======
      FileUtils::mkdir_p(report_build_file_path('js'))
      FileUtils.cp_r(Dir.glob(File.join(__dir__, 'js', '*.js')), report_build_file_path('js'))
      File.open(report_build_file_path('js/app.js'), 'w') do |app_js_file|
        Dir.glob(File.join(__dir__, 'js', 'app', '**', '*.js')).each do |individual_js_file_path|
          next if individual_js_file_path.include?('app/app.js') # leave to the end
          app_js_file.write(File.open(individual_js_file_path).read)
>>>>>>> Stashed changes
        end
        app_js_file.write(File.open(File.join(__dir__, 'js', 'app', 'app.js')).read)
      end

      FileUtils.cp(File.join(Bootstrap::javascripts_path, 'bootstrap.min.js'), report_build_file_path('js/bootstrap.js'))
      FileUtils.copy(File.join(__dir__, 'index.html'), report_build_file_path('index.html'))
    end

    private

    def self.report_build_file_path(file_name)
      File.join(__dir__, '..', '..', '..', 'report', file_name)
    end

    private

    def self.report_build_file_path(file_name)
      File.join(__dir__, '..', '..', '..', 'report', file_name)
    end
  end
end

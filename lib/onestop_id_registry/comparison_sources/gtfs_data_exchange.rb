require 'open-uri'
require 'json'

require_relative '../entities/feed'

module OnestopIdRegistry
  module ComparisonSources
    module GtfsDataExchange
      DOWNLOAD_URL = 'http://www.gtfs-data-exchange.com/api/agencies'
      LOCAL_PATH = File.join(File.dirname(__FILE__), '..', '..', '..', 'comparison_sources', 'gtfs_data_exchange.json') 

      def self.fetch
        File.open(LOCAL_PATH, 'w') do |file|
          file.write(open(DOWNLOAD_URL).read)
        end
      end

      def self.post_process
        parsed_json = JSON.parse(File.open(LOCAL_PATH).read)
        parsed_json = parsed_json['data'] # remove the "status_code" property and "data" wrapper
        prettier_json = JSON.pretty_generate(parsed_json)
        File.open(LOCAL_PATH, 'w').write(prettier_json)
      end
    end
  end
end

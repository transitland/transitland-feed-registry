require 'open-uri'
require 'json'

require_relative '../entities/feed'

module OnestopIdRegistry
  module ComparisonSources
    module GtfsDataExchange
      DOWNLOAD_URL = 'http://www.gtfs-data-exchange.com/api/agencies'
      LOCAL_PATH = File.join(File.dirname(__FILE__), '..', '..', '..', 'comparison_sources', 'gtfs_data_exchange.json') 

      def self.fetch_and_post_process
        File.open(LOCAL_PATH, 'w') do |file|
          raw_json = open(DOWNLOAD_URL).read
          parsed_json = JSON.parse(raw_json)
          parsed_json = parsed_json['data'] # remove the "status_code" property and "data" wrapper
          prettier_json = JSON.pretty_generate(parsed_json)
          file.write(prettier_json)
        end
      end

      def self.feeds(force_reload: false)
        if force_reload || !defined?(@feeds)
          @feeds = JSON.parse(File.open(LOCAL_PATH).read)
          @feeds.map do |feed_json|
            # standardize all of the JSON property names as Ruby symbols (rather than strings)
            feed_json.keys.each { |key| feed_json[(key.to_sym rescue key) || key] = feed_json.delete(key) }
            feed_json
          end
        else
          @feeds
        end
      end

      def self.compare_against_onestop_feeds(format: :ruby_objects)
        comparisons = []
        feeds.each do |gtfs_data_exchange_feed|
          feed = OnestopIdRegistry::Entities::Feed.find_by(gtfs_data_exchange_id: gtfs_data_exchange_feed[:dataexchange_id])
          comparisons << {
            gtfs_data_exchange_feed: gtfs_data_exchange_feed,
            onestop_id: feed ? feed.onestop_id : nil
          }
        end
        if format == :ruby_objects
          comparisons
        elsif format == :json
          JSON.generate(comparisons)
        end
      end
    end
  end
end

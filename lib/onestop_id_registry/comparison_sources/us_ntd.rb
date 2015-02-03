require 'mechanize'
require 'roo'
require 'roo-xls'

require_relative '../entities/operator'

module OnestopIdRegistry
  module ComparisonSources
    module UsNtd
      NTD_DOWNLOAD_PATH = 'http://www.ntdprogram.gov/ntdprogram/'
      NTD_DOWNLOAD_PAGE = 'data.htm'
      NTD_LOCAL_PATH = File.join(File.dirname(__FILE__), '..', '..', '..', 'comparison_sources', 'us_national_transportation_database.xls') 

      def self.fetch
        File.delete(NTD_LOCAL_PATH) if File.exist?(NTD_LOCAL_PATH)
        agent = Mechanize.new
        agent.pluggable_parser['application/vnd.ms-excel'] = Mechanize::Download
        ntd_page = agent.get(NTD_DOWNLOAD_PATH + NTD_DOWNLOAD_PAGE)
        ntd_page.links.find { |l| l.text == 'Monthly Module Raw Data Release' }.click.save(NTD_LOCAL_PATH)
      end

      def self.agencies
        agencies = []
        ntd_spreadsheet = Roo::Excel.new(NTD_LOCAL_PATH) 
        ntd_spreadsheet.default_sheet = 'MASTER'
        ntd_spreadsheet.each(ntd_id: 'NTDID', name: 'Agency', city: 'HQ City', state: 'HQ State', uza: 'UZA') do |row|
          next if row[:ntd_id] == 'NTDID' # skip the first row
          agencies << {
            name: row[:name],
            ntd_id: row[:ntd_id]
          }
        end
        agencies.uniq! { |agency| agency[:ntd_id] }
        agencies
      end

      def self.compare_against_onestop_operators
        comparisons = []
        agencies.each do |ntd_agency|
          operator = OnestopIdRegistry::Entities::Operator.find_by(us_ntd_id: ntd_agency[:ntd_id].to_i)
          comparisons << {
            ntd_agency: ntd_agency,
            onestop_id: operator ? operator.onestop_id : nil
          }
        end
      end
    end
  end
end

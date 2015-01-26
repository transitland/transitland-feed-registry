require 'mechanize'

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
    end
  end
end

require 'tempfile'
require 'roo'
require 'roo-xls'

require_relative '../../../lib/onestop_id_registry/comparison_sources/us_ntd'

describe OnestopIdRegistry::ComparisonSources::UsNtd do
  before(:each) do
    @tempfile = Tempfile.new(['us_ntd', '.xls'])
    stub_const('OnestopIdRegistry::ComparisonSources::UsNtd::NTD_LOCAL_PATH', @tempfile.path)
  end

  after(:each) do
    @tempfile.close
    @tempfile.unlink
  end

  it 'should be able to fetch' do
    VCR.use_cassette("us_ntd_fetch") do
      OnestopIdRegistry::ComparisonSources::UsNtd.fetch
      ntd_spreadsheet = Roo::Excel.new(@tempfile.path) 
      ntd_spreadsheet.default_sheet = 'MASTER'
      expect(ntd_spreadsheet.count).to eq 2058 # number of rows on that spreadsheet page
    end
  end
end

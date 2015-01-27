require 'tempfile'
require 'roo'
require 'roo-xls'

require_relative '../../../lib/onestop_id_registry/comparison_sources/us_ntd'

describe OnestopIdRegistry::ComparisonSources::UsNtd do
  before(:each) do
    @tempfile = Tempfile.new(['us_ntd', '.xls'])
    stub_const('OnestopIdRegistry::ComparisonSources::UsNtd::NTD_LOCAL_PATH', @tempfile.path)
    VCR.use_cassette("us_ntd_fetch") do
      OnestopIdRegistry::ComparisonSources::UsNtd.fetch
      @ntd_spreadsheet = Roo::Excel.new(@tempfile.path)
    end
  end

  after(:each) do
    @tempfile.close
    @tempfile.unlink
  end

  it 'should be able to fetch the XLS' do
    @ntd_spreadsheet.default_sheet = 'MASTER'
    expect(@ntd_spreadsheet.count).to eq 2058 # rows in that spreadsheet page
  end

  it 'should be able to parse agencies from the XLS' do
    expect(OnestopIdRegistry::ComparisonSources::UsNtd.agencies.count).to eq 769 # unique NTD IDs
  end

  it 'can be compared against Onestop IDs for operators' do
    all_comparisons = OnestopIdRegistry::ComparisonSources::UsNtd.compare_against_onestop_operators
    bart = all_comparisons.find { |comparison| comparison[:onestop_id] == 'o-9q9-BART' }
    expect(bart[:ntd_agency][:name]).to eq 'San Francisco Bay Area Rapid Transit District'
  end
end

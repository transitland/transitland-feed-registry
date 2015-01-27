require_relative '../../../lib/onestop_id_registry/entities/operator'

describe OnestopIdRegistry::Entities::Operator do
  context 'all' do
    it 'can be found by US NTD ID' do
      operator = OnestopIdRegistry::Entities::Operator.find_by(us_ntd_id: 9003)
      expect(operator.onestop_id).to eq 'o-9q9-BART'
    end
  end

  context 'individual' do
    it 'can be initialized from a JSON file, by providing the appropriate Onestop ID' do
      operator = OnestopIdRegistry::Entities::Operator.new(onestop_id: 'o-9q9-BART')
      expect(operator.onestop_id).to eq 'o-9q9-BART'
      expect(operator.name).to eq 'San Francisco Bay Area Rapid Transit District'
      expect(operator.tags['us_national_transit_database_id']).to eq 9003
    end
  end
end

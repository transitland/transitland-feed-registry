require_relative '../../lib/onestop_id_registry/onestop_id'

describe OnestopIdRegistry::OnestopId do
  context 'initializes as an object' do
    it 'from a string' do
      good_onestop_id = OnestopIdRegistry::OnestopId.new(string: 'o-9q8y-SFMTA')
      expect(good_onestop_id.entity_prefix).to eq 'o'
      expect(good_onestop_id.geohash).to eq '9q8y'
      expect(good_onestop_id.name).to eq 'SFMTA'

      expect {
        OnestopIdRegistry::OnestopId.new(string: 'o-9q8y-S&FMTA')
      }.to raise_error(ArgumentError)
    end

    it 'from components as arguments' do
      good_onestop_id = OnestopIdRegistry::OnestopId.new(entity_prefix: 'o', geohash: '9q8y', name: 'SFMTA')
      expect(good_onestop_id.entity_prefix).to eq 'o'
      expect(good_onestop_id.geohash).to eq '9q8y'
      expect(good_onestop_id.name).to eq 'SFMTA'

      expect {
        OnestopIdRegistry::OnestopId.new(entity_prefix: 'a', geohash: '9q8y', name: 'SFMTA')
      }.to raise_error(ArgumentError)

      expect {
        OnestopIdRegistry::OnestopId.new(entity_prefix: 'o', geohash: '9q8y')
      }.to raise_error(ArgumentError)

      expect {
        OnestopIdRegistry::OnestopId.new(entity_prefix: 'o', geohash: '', name: 'SFMTA')
      }.to raise_error(ArgumentError)

      expect {
        OnestopIdRegistry::OnestopId.new(entity_prefix: 'o', geohash: '9q8y', name: 'SF#MTA')
      }.to raise_error(ArgumentError)
    end
  end

  context 'validates' do
    context 'by string' do
      it 'without an expected entity type' do
        expect(OnestopIdRegistry::OnestopId.validate_onestop_id_string('o-9q8y-SFMTA')).to eq [true, []]
        expect(OnestopIdRegistry::OnestopId.validate_onestop_id_string('f-9q9-VTA')).to eq [true, []]
        expect(OnestopIdRegistry::OnestopId.validate_onestop_id_string('9q9-VTA')).to eq [
          false, [
            "must include 3 components separated by hyphens (\"-\")",
            "must start with \"s or o or f\" as its 1st component",
            "must include a valid geohash as its 2nd component",
            "must include only letters and digits in its abbreviated name (the 3rd component)"
          ]
        ]
        expect(OnestopIdRegistry::OnestopId.validate_onestop_id_string('o-VTA')).to eq [
          false, [
            "must include 3 components separated by hyphens (\"-\")",
            "must include a valid geohash as its 2nd component",
            "must include only letters and digits in its abbreviated name (the 3rd component)"
          ]
        ]
        expect(OnestopIdRegistry::OnestopId.validate_onestop_id_string("o-9q9-VT'A")).to eq [
          false, ["must include only letters and digits in its abbreviated name (the 3rd component)"]
        ]
      end

      it 'with an expected entity type' do
        expect(OnestopIdRegistry::OnestopId.validate_onestop_id_string("o-9q9-VTA", expected_entity_type: 'operator')).to eq [true, []]
        expect(OnestopIdRegistry::OnestopId.validate_onestop_id_string("o-9q9-VTA", expected_entity_type: 'feed')).to eq [false, ["must start with \"f\" as its 1st component"]]
      end
    end

    context 'by component' do
      it 'for entity prefix' do
        expect(OnestopIdRegistry::OnestopId.send(:valid_component?, :entity_prefix, 's')).to eq true
        expect(OnestopIdRegistry::OnestopId.send(:valid_component?, :entity_prefix, 'o')).to eq true
        expect(OnestopIdRegistry::OnestopId.send(:valid_component?, :entity_prefix, 'f')).to eq true
        expect(OnestopIdRegistry::OnestopId.send(:valid_component?, :entity_prefix, '')).to eq false
        expect(OnestopIdRegistry::OnestopId.send(:valid_component?, :entity_prefix, 'a')).to eq false
      end

      it 'for geohash component' do
        expect(OnestopIdRegistry::OnestopId.send(:valid_component?, :geohash, '9q9')).to eq true
        expect(OnestopIdRegistry::OnestopId.send(:valid_component?, :geohash, 'dr72js3')).to eq true
        expect(OnestopIdRegistry::OnestopId.send(:valid_component?, :geohash, '')).to eq false
        expect(OnestopIdRegistry::OnestopId.send(:valid_component?, :geohash, '9zq@')).to eq false
      end

      it 'for name component' do
        expect(OnestopIdRegistry::OnestopId.send(:valid_component?, :name, 'SFMTA')).to eq true
        expect(OnestopIdRegistry::OnestopId.send(:valid_component?, :name, 'SamTrans')).to eq true
        expect(OnestopIdRegistry::OnestopId.send(:valid_component?, :name, 'San Francisco Muni')).to eq false
        expect(OnestopIdRegistry::OnestopId.send(:valid_component?, :name, '')).to eq false
        expect(OnestopIdRegistry::OnestopId.send(:valid_component?, :name, '@ctransit')).to eq false
      end

      it 'fails gracefully when given bad parameters' do
        expect(OnestopIdRegistry::OnestopId.send(:valid_component?, :thing, 'SFMTA')).to eq false
      end
    end
  end
end

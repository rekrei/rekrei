require 'rails_helper'

describe GeoTools do
  describe 'Get coordinates' do
    it 'should do something' do
      expect(GeoTools.get_coordinates('blah')).to eq('blah')
    end
  end
end

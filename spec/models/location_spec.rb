require 'rails_helper'

describe Location do
  it { should respond_to(:name) }
  it { should respond_to(:lat) }
  it { should respond_to(:long) }
  it { should respond_to(:uuid) }
  it { should have_many(:reconstructions) }

  describe '.find' do
    let!(:location) { FactoryGirl.create(:location, name: 'test location') }

    it 'should find location by id' do
      expect(Location.find(location.id)).to eq(location)
    end

    it 'should set slug' do
      expect(location.slug).to eq('test-location')
    end

    it 'should find location by slug' do
      expect(Location.friendly.find('test-location')).to eq(location)
    end
  end
end

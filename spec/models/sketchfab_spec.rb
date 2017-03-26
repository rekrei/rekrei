require 'rails_helper'

describe Sketchfab do
  it { should respond_to(:bbcode) }

  context 'validation bbcode presence' do
    let(:sketchfab) { Sketchfab.new }
    subject { sketchfab }
    it { should_not be_valid }
  end

  context 'validation bbcode format' do
    let(:sketchfab) { FactoryGirl.create :sketchfab }
    subject { sketchfab }
    it { should be_valid }
  end
end

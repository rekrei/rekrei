require 'rails_helper'

describe Artefact do

  it { should respond_to(:name) }
  it { should respond_to(:description) }
  it { should respond_to(:museum_identifier) }
  it { should have_many(:assets).dependent(:destroy) }

  describe ".new" do
    let(:artefact){Artefact.new}

    it "sets an UUID" do
      expect(artefact.uuid).to_not be_nil
    end
  end
end
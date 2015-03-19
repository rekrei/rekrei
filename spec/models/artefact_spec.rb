require 'rails_helper'

describe Artefact do

  it { should respond_to(:name) }
  it { should respond_to(:description) }
  it { should respond_to(:museum_identifier) }
  it { should have_many(:images).dependent(:destroy) }
  it { should have_many(:sketchfabs).dependent(:destroy) }

  describe ".new" do
    let(:artefact){Artefact.new}

    it "sets an UUID" do
      expect(artefact.uuid).to_not be_nil
    end
  end

  describe "artefact has many models" do
    let(:artefact){create(:artefact)}
    let(:sketchfab){create(:sketchfab, :with_artefact)}

    it "should find artefacts without models" do
      expect(Artefact.sketchfabless).to_not include(sketchfab.artefact)
    end

    it "should find artefacts with models" do
      expect(Artefact.with_sketchfabs).to include(sketchfab.artefact)
    end

  end

end
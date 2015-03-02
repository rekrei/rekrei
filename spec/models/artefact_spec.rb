require 'rails_helper'

describe Artefact do

  it { should respond_to(:name) }
  it { should respond_to(:description) }
  it { should respond_to(:museum_identifier) }
  it { should have_many(:attachments).dependent(:destroy) }

end
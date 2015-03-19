class Sketchfab < ActiveRecord::Base
  belongs_to :artefact
  validates_presence_of :bbcode, :on => :create, :message => "can't be blank"
end

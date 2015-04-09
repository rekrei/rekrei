# Sketchfab model for storing the 3D models
class Sketchfab < ActiveRecord::Base
  belongs_to :artefact
  validates :bbcode, presence: {
    on: :create, message: "can't be blank"
  }
end

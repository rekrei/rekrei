# Sketchfab model for storing the 3D models
class Sketchfab < ActiveRecord::Base
  belongs_to :artefact
  belongs_to :user

  validates :bbcode, presence: {
    on: :create, message: "can't be blank"
  }
  validates :bbcode, format: { with: /\[sketchfab\][a-zA-Z0-9]{32}\[\/sketchfab\](\r\n|\r|\n)\[url=https:\/\/sketchfab.com\/models\/[a-zA-Z0-9]{32}\].*\[\/url\]\sby\s\[url=https:\/\/sketchfab.com\/[a-zA-Z0-9]*\][a-zA-Z0-9]*\[\/url\]\son\s\[url=https:\/\/sketchfab.com\]Sketchfab\[\/url\]/}

  def bbcode_to_html(width: 640, height: 480)
    model = Sketchfably.get_model_from_bbcode(self.bbcode)
    html = Sketchfably.get_html_for_model(sketchfab_model: model, width: width, height: height)
    return html
  end
end

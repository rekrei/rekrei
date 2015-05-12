class ImageMatch < ActiveRecord::Base
  belongs_to :parent_image, class: Image
  belongs_to :comparison_image, class: Image

  def self.compare_images(images)
    matches = []
    if images.empty?
      return false
    else
      matches << update_or_create_comparison(images)
      matches << update_or_create_comparison(images.reverse)
    end
    return matches
  end

  private
  def self.update_or_create_comparison(images)
    self.where(parent_image: images.first, comparison_image: images.last).first_or_create do |image_match|
      if image_match.new_record?
        results = ImageTester.compare(images)
        image_match.matches = results[:matches]
        image_match.has_error = results[:error]
        image_match.time_to_match = results[:time].to_s
      end
    end
  end
end

class QueueUnmatchedImagesJob < ActiveJob::Base
  queue_as :default

  def perform(image:)
    image.unmatched_images.each do |unmatched_image|
      MatchImageJob.perform_later image: image, unmatched_image: unmatched_image
    end
  end
end

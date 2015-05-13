class MatchImageJob < ActiveJob::Base
  queue_as :default

  def perform(image:, unmatched_image:)
    image.compare(unmatched_image)
  end
end

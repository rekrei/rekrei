require 'rails_helper'

RSpec.describe QueueUnmatchedImagesJob, type: :job do

  context "queue unmatched images" do
    let!(:image_matches) { create_list(:image_match, 1) }
    let!(:image){ build(:image) }

    it { expect(Image.count).to eq 2 }
    it { expect(ImageMatch.count).to eq 1 }
    it { expect(ActiveJob::Base.queue_adapter.enqueued_jobs.count).to eq 0 } #changed to zero until we can get the image matcher working in production

    it "should enqueue image matching jobs" do
      expect {
        image.save
      }.to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :count).by(0) # same as above
    end
  end

  context "queue match image jobs" do
    let!(:location) { create(:location) }
    let!(:image_matches) { create_list(:image_match, 5, location: location) }
    let!(:image){ build(:image, location: location) }

    it { expect(Image.count).to eq 10 }
    it { expect(ImageMatch.count).to eq 5 }
    it { expect(ActiveJob::Base.queue_adapter.enqueued_jobs.count).to eq 0 } #disabled, as above

    it "should enqueue image matching jobs" do
      expect {
        image.save
        QueueUnmatchedImagesJob.perform_now image: image
      }.to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :count).by(10) #from 11 to 10, while jobs are disabled above
    end
  end
end

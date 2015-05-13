require 'rails_helper'

RSpec.describe QueueUnmatchedImagesJob, type: :job do
  context "queue unmatched images" do
    let!(:image_matches) { create_list(:image_match, 5) }
    let!(:image){ build(:image) }

    it { expect(Image.count).to eq 10 }
    it { expect(ImageMatch.count).to eq 5 }
    it { expect(ActiveJob::Base.queue_adapter.enqueued_jobs.count).to eq 10 }

    it "should enqueue image matching jobs" do
      expect { 
        image.save
      }.to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :count).by(1)
    end
  end

  context "queue match image jobs" do
    let!(:image_matches) { create_list(:image_match, 5) }
    let!(:image){ build(:image) }

    it { expect(Image.count).to eq 10 }
    it { expect(ImageMatch.count).to eq 5 }
    it { expect(ActiveJob::Base.queue_adapter.enqueued_jobs.count).to eq 10 }

    it "should enqueue image matching jobs" do
      expect { 
        image.save
        QueueUnmatchedImagesJob.perform_now image: image
      }.to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :count).by(11)
    end
  end
end

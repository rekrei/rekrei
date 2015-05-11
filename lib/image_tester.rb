require 'json'
module ImageTester

  def self.compare(images = [])
    matches = ""
    if images.empty?
      return false
    else
      matches = IO::popen(['python', Rails.root.join("lib","python","image_test.py").to_s, images[0].image.path.to_s, images[1].image.path.to_s])
    end
    data = JSON.parse(matches.read, symbolize_names: true)
    return data
  end

end
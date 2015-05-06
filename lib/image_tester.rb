module ImageTester

  def self.compare(images = [])
    matches = ""
    if images.empty?
      return false
    else
      cmd = "python #{Rails.root.join("lib","python","image_test.py")} #{images[0].image.path} #{images[0].uuid} #{images[1].image.path} #{images[1].uuid}"
      matches = IO::popen "python #{Rails.root.join("lib","python","image_test.py")} #{images[0].image.path} #{images[0].uuid} #{images[1].image.path} #{images[1].uuid}"
      matches = system 'python', Rails.root.join("lib","python","image_test.py").to_s, images[0].image.path, images[0].uuid, images[1].image.path, images[1].uuid
    end
    return matches
  end

end
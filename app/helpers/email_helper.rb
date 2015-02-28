module EmailHelper
  def line_break(s)
    s.gsub("\n", "<br/>")
  end
end

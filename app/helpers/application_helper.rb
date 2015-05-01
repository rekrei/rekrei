# General application helpers here
module ApplicationHelper
  def title(value)
    @title = "#{value} | Project Mosul" unless value.nil?
  end
end

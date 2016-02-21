# General application helpers here
module ApplicationHelper
  def title(value)
    @title = "#{value} | Rekrei" unless value.nil?
  end
end

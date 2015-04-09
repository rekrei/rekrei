# General application helpers here
module ApplicationHelper
  def title(value)
    @title = "#{value} | Projectmosul" unless value.nil?
  end
end

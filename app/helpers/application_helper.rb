module ApplicationHelper
  def title(value)
    unless value.nil?
      @title = "#{value} | Projectmosul"
    end
  end
end

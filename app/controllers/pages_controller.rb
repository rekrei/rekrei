class PagesController < ApplicationController
  before_action :authenticate_user!, only: [
    :inside
  ]

  def home
    @locations = Location.all
    @hash = Gmaps4rails.build_markers(@locations) do |location, marker|
      marker.lat location.lat
      marker.lng location.long
      marker.title location.name
      marker.infowindow view_context.link_to location.name, location_path(location)
    end
  end

  def acknowledgements
  end

  def gallery
    # @models = Sketchfably.get_models_by_tag("projectmosul")
  end

  def press
  end

  def about
    cookies[:has_visited_about] = "true"
  end

  def email
    @name = params[:name]
    @email = params[:email]
    @message = params[:message]

    if @name.blank?
      flash[:alert] = 'Please enter your name before sending your message. Thank you.'
      render :contact
    elsif @email.blank? || @email.scan(/\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i).size < 1
      flash[:alert] = 'You must provide a valid email address before sending your message. Thank you.'
      render :contact
    elsif @message.blank? || @message.length < 10
      flash[:alert] = 'Your message is empty. Requires at least 10 characters. Nothing to send.'
      render :contact
    elsif @message.scan(/<a href=/).size > 0 || @message.scan(/\[url=/).size > 0 || @message.scan(/\[link=/).size > 0 || @message.scan(/http:\/\//).size > 0
      flash[:alert] = "You can't send links. Thank you for your understanding."
      render :contact
    else
      ContactMailer.contact_message(@name, @email, @message).deliver_now
      redirect_to root_path, notice: 'Your message was sent. Thank you.'
    end
  end
end

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :reject_locked!, if: :devise_controller?

  after_filter :store_location
  after_filter :set_csrf_cookie_for_ng

  respond_to :html, :json

  def set_csrf_cookie_for_ng
    cookies['XSRF-TOKEN'] = form_authenticity_token if protect_against_forgery?
  end

  def not_found
    render :file => 'public/404.html', :status => :not_found, :layout => false
  end

  def store_location
    # store last url - this is needed for post-login redirect to whatever the user last visited.
    return unless request.get?
    if (request.path != "/users/sign_in" &&
        request.path != "/users/sign_up" &&
        request.path != "/users/password/new" &&
        request.path != "/users/password/edit" &&
        request.path != "/users/confirmation" &&
        request.path != "/users/sign_out" &&
        !request.format.json? &&
        !request.xhr?) # don't store ajax calls
      session[:previous_url] = request.original_url

    end
  end

  def after_sign_in_path_for(resource)
    session[:previous_url] || root_path
  end

  # Devise permitted params
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_in) do |u|
      u.permit(
        :login,
        :username,
        :email,
        :password,
        :password_confirmation)
    end
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(
        :username,
        :email,
        :password,
        :password_confirmation)
    end
    devise_parameter_sanitizer.for(:account_update) do |u|
      u.permit(
        :username,
        :email,
        :password,
        :password_confirmation,
        :current_password
      )
    end
  end

  # Auto-sign out locked users
  def reject_locked!
    if current_user && current_user.locked?
      sign_out current_user
      user_session = nil
      current_user = nil
      flash[:alert] = 'Your account is locked.'
      flash[:notice] = nil
      redirect_to root_url
    end
  end
  helper_method :reject_locked!

  # Only permits admin users
  def require_admin!
    authenticate_user!
    respond_to do |format|
      format.html { redirect_to root_path if current_user && !current_user.admin? }
      format.js { render json: { error: "User not an admin!" }, status: 401 }
    end
  end

  helper_method :require_admin!

  def require_user!
    unless current_user
      render json: { error: "Authentication failure!" }, status: 401
    end
  end

  helper_method :require_user!

  protected
  def verified_request?
    super || valid_authenticity_token?(session, request.headers['X-XSRF-TOKEN'])
  end
end

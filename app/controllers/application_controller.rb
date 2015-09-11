class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  rescue_from SecurityError, with: :not_signed_in

  def current_user
    if not cookies[:chalmersItAuth].present?
      raise SecurityError, "Missing cookie"
    end
    if session[:cookie] == cookies[:chalmersItAuth] && session[:user].present?
      User.find(session[:user])
    else
      reset_session
      user = User.find_by_token cookies[:chalmersItAuth]
      session[:cookie] = cookies[:chalmersItAuth]
      session[:user] = user.id
      user
    end
  end
  helper_method :current_user

  private
    def not_signed_in
      redirect_to "https://account.chalmers.it"
    end

end

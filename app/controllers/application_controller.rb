class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :require_login if :logged_out
  before_filter :prepare_lang
  before_filter :set_current_user
  before_filter :check_global_authorization
  rescue_from ActionController::RoutingError, ActionController::UnknownController, ::AbstractController::ActionNotFound,
              ActiveRecord::RecordNotFound, with: lambda { |exception| not_found exception }

  LANGS = [
      ['fr', 'Français'],
      ['en', 'English']
  ]

  def set_current_user
    if ldap
      @current_user = User.find session[:ldap_user]
      if !@current_user.login and session[:ldap_user]
        session.delete(:ldap_user)
        redirect_to root_path
      end
      if @current_user.admin
        @read_only = false
      else
        @read_only = @current_user.read_only
      end
    end
  end

  def check_global_authorization
    if [SessionsController, InventoriesController].include? self.class
      return true
    else
      if @current_user.is_admin? or @current_user.read_only?
        return true
      else
        flash[:warning] = t(:no_auth_to_action)
        redirect_to inventories_path
      end
    end
  end

  def not_found(exception=nil)
    #we can handle exception here...
    render 'errors/error_404', status: 404
  end

  private
  def not_authenticated
    redirect_to login_path, alert: t(:please_login_first) unless ldap
  end

  def logged_out
    logged_in? or ldap ? true : false
  end

  def ldap
    session[:ldap_user] ? true : false
  end

  def prepare_lang
    lang = params[:lang] || cookies[:lang] || 'fr'
    cookies[:lang] = lang_by_tag(lang)
    I18n.locale = lang
  end

  def lang_by_tag(lng)
    language = LANGS.detect{|lang| lang.first == lng.downcase}
    language ? language.first : LANGS.first.first
  end
end

class SessionsController < ApplicationController
  layout 'session'
  skip_before_filter :require_login, only: [:new, :create, :create_ldap]

  def new
  end

  def create
    user = login(params[:email], params[:password], params[:remember_me])
    if user
      redirect_back_or_to root_url, notice: t(:logged_in)
    else
      flash[:error] = t(:email_or_password_invalid)
      render :new
    end
  end

  def create_ldap
    user = User.find_by(username: params[:username])
    if user and user.login
      ldap = Net::LDAP.new
      ldap.host = "ldap.multitel.be"
      ldap.base = "dc=multitel,dc=be"
      ldap.port = 636
      ldap.encryption :simple_tls
      ldap.auth "cn=#{user.username},ou=people,dc=multitel,dc=be", params[:password]
      begin
        if ldap.bind
          session[:ldap_user] = user.id
          redirect_back_or_to root_url, notice: t(:logged_in)
        else
          flash[:error] = t(:username_or_password_inbalid)
          render :new
        end
      rescue => e
        flash[:error] = e.message
        render :new
      end
    else
      flash[:error] = t(:no_permission_to_login)
      render :new
    end
  end

  def destroy
    reset_sorcery_session
    logout
    session.delete(:ldap_user)
    redirect_to root_url, notice: t(:logged_out)
  end

  def destroy_ldap
    logout
    redirect_to root_url, notice: t(:logged_out)
  end

  private
  def current_user
    unless defined?(@current_user)
      @current_user = login_from_session || login_from_other_sources || nil
    end
    @current_user
  end

  def current_user=(user)
    @current_user = user
  end
end

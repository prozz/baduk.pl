class AccountController < ApplicationController
  layout 'core'

  before_filter :login_required, :only => [ "logout", "password_changed" ]

  def login
    @page_title = "Logowanie"
    case request.method
    when :post
      if session[:user] = User.authenticate(params['user']['login'], params['user']['password'])

        # autologin feature
        if params[:save_login] == "1"
          session[:user].remember_me
          cookies[:auth_token] = { :value => session[:user].remember_token, :expires => session[:user].remember_token_expires }
        end

        redirect_back_or_default :controller => "games", :action => "my"
      else
      	@user = User.new
      	@user.login = params['user']['login']
      	@user.errors.add('login', 'Wprowadzone dane są niepoprawne.')
      end
    end
  end
  
  def signup
    @page_title = "Rejestracja"
    case request.method
    when :post
      @user = User.new(params['user'])
      if @user.save      
        session[:user] = User.authenticate(@user.login, params['user']['password'])
        redirect_back_or_default :controller => "games", :action => "my"
      end
    when :get
      @user = User.new
    end      
  end  

  def password_changed
    @page_title = "Hasło zostało zmienione"
  end

  def change_password
    @page_title = "Zmiana hasła"
    @user = session[:user]

    case request.method
    when :post
      @profile = Profile.new(params[:profile])
      if @profile.save
        @user.change_password(@profile.password)
        @user.save
        redirect_to :action => "password_changed"
      end
    when :get
      @profile = Profile.new
    end
  end

  def forgotten_password
    @page_title = "Przypomnij hasło"
    case request.method
    when :post
      @user = User.find_by_email(params['user']['email'])
      if @user.nil?
      	@user = User.new
      	@user.email = params['user']['email']
      	@user.errors.add('email', 'Adres email jest nieprawidłowy.')
      else
        password = String.random(8, /[A-Za-z0-9]/)
        @user.change_password(password)
        Notifictions.deliver_forgotten_password(@user.email, password)
        redirect_to :action => "password_sent"
      end
    end
  end
 
  def password_sent 
    @page_title = 'Hasło zostało wysłane'
  end

  def profile
    model_for_profile
  end

  def logout
    @page_title = "Wylogowałeś się"
    session[:user].forget_me if session[:user]
    session[:user] = nil
    cookies.delete :auth_token
  end
     
  protected
  def model_for_profile
    @page_title = "Profil"
    @user = User.find_by_login(params[:id]);
    @user_not_found = @user.nil?

    if not @user_not_found
      @recent_games = Game.find_recent_for_user @user.id 
      @recent_comments = Comment.find_recent_for_user @user.id
      @page_title += " użytkownika '#{@user.login}'"
      @profile = Profile.new
    end	  
  end
end

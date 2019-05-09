require File.dirname(__FILE__) + '/../spec_helper'

include SpecHelper

describe AccountController, "while logged out" do

  before :each do
    session[:user] = nil
  end

  it "should not allow to go to profile page" do
    get 'profile'
    response.should redirect_to(:action => 'login')
  end

  it "should not allow to go to logout page" do
    get 'logout'
    response.should redirect_to(:action => 'login')
  end

  it "should allow to go to login page" do
    get 'login'
    response.should be_success
  end

  describe "on login page" do # {{{

    before(:each) do 
      @user = User.new
      @user.login = 'prozz'
      @user.password = 'secret!'
    end

    it "should allow to log in in case of passing right credentials" do
      User.should_receive(:authenticate).with(@user.login, @user.password).and_return(@user)
      post 'login', { 'user' => { 'login' => @user.login, 'password' => @user.password} }
      response.should redirect_to(:controller => 'games', :action => 'my')
      session[:user].should_not be_nil
      session[:user].should equal(@user)
    end

    it "should not allow to log in if credentials are wrong" do
      User.should_receive(:authenticate).with(@user.login, 'bad pass').and_return(nil)
      post 'login', { 'user' => { 'login' => @user.login, 'password' => 'bad pass'} }
      response.should render_template(:login)
      assigns[:login].should equal(@user.login) 
      assigns[:login_error].should be_true 
    end

  end # }}}

  it "should allow to go to signup page" do
    get 'signup'
    response.should be_success
  end

  describe "on signup page" do
    # TODO
  end

  it "should allow to go to forgotten password page" do
    get 'forgotten_password'
    response.should be_success
  end

  describe "on forgotten password page" do
    # TODO
  end

end

describe AccountController, " while logged in" do

  before :each do
    @user = User.new
    @user.attributes = valid_user_attributes
    session[:user] = @user 
  end

  it "should allow to go to profile page" do
    get 'profile'
    response.should be_success
  end

  it "should allow to go to logout page and remove user from session" do
    get 'logout'
    response.should be_success
    session[:user].should be_nil
  end

  describe "on profile page" do # {{{

    it "should allow to change password" do
      @user.should_receive(:change_password).with('new pass').and_return('some hashed value')
      post 'profile', { 
        :profile => { :password => 'new pass', :password_confirmation => 'new pass' }
      }
      response.should redirect_to(:action => 'password_changed')
    end

    it "should show errors in case of wrong password" do
      post 'profile', { 
        :profile => { :password => 'new', :password_confirmation => 'now' }
      }
      response.should render_template(:profile)
      assigns[:profile].should have_at_least(1).error_on(:password)
    end
  end # }}}
end

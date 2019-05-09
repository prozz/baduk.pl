require File.dirname(__FILE__) + '/../test_helper'
require 'account_controller'

# Raise errors beyond the default web-based presentation
class AccountController; def rescue_action(e) raise e end; end

class AccountControllerTest < Test::Unit::TestCase
  self.use_instantiated_fixtures  = true
  
  fixtures :users
  
  def setup
    @controller = AccountController.new
    @request, @response = ActionController::TestRequest.new, ActionController::TestResponse.new
    @request.host = "localhost"
  end
  
  def test_auth_bob
    time_before_login = Time.now
    @request.session['return-to'] = "/bogus/location"

    post :login, "user_login" => "bob", "user_password" => "test"
    assert @response.has_session_object?(:user)

    assert_equal @bob, @response.session[:user]
    
    assert_redirected_to "/bogus/location"
    assert @bob.last_login.after(time_before_login)
  end
  
  def test_signup
    @request.session['return-to'] = "/bogus/location"

    post :signup, "user" => { "login" => "newbob", "password" => "newpassword", "password_confirmation" => "newpassword", "email" => "bob@test.com" }
    assert @response.has_session_object?(:user)
    
    assert_redirected_to "/bogus/location"
  end

  def test_bad_signup
    @request.session['return-to'] = "/bogus/location"

    post :signup, "user" => { "login" => "newbob", "password" => "newpassword", "password_confirmation" => "wrong" }
    assert @response.template_objects['user'].errors.invalid?("password")
    assert @response.template_objects['user'].errors.invalid?("email")
    assert_response(:success)
    
    post :signup, "user" => { "login" => "yo", "password" => "newpassword", "password_confirmation" => "newpassword" }
    assert @response.template_objects['user'].errors.invalid?("login")
    assert @response.template_objects['user'].errors.invalid?("email")
    
    assert_response(:success)

    post :signup, "user" => { "login" => "yo", "password" => "newpassword", "password_confirmation" => "wrong" }
    assert @response.template_objects['user'].errors.invalid?("login")
    assert @response.template_objects['user'].errors.invalid?("password")
    assert @response.template_objects['user'].errors.invalid?("email")
    assert_response(:success)
  end

  def test_invalid_login
    post :login, "user_login" => "bob", "user_password" => "not_correct"
     
    assert !@response.has_session_object?(:user)
    
    assert @response.has_template_object?("login_error")
    assert @response.has_template_object?("login")
  end
  
  def test_login_logoff

    post :login, "user_login" => "bob", "user_password" => "test"
    assert @response.has_session_object?(:user)

    get :logout
    assert !@response.has_session_object?(:user)

  end
  
end

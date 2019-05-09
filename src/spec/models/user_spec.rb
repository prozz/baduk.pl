require File.dirname(__FILE__) + '/../spec_helper'

include SpecHelper

describe User, "attributes" do

  before :each do
    @user = User.new
  end

  it "should contain login" do
    @user.attributes = valid_user_attributes.except(:login)
    @user.should have_at_least(1).error_on(:login)

    @user.login = "prozz"
    @user.should have(:no).errors_on(:login)
  end

  it "should contain email" do
    @user.attributes = valid_user_attributes.except(:email)
    @user.should have_at_least(1).error_on(:email)

    @user.email = "prozz@baduk.pl"
    @user.should have(:no).errors_on(:email)
  end

  it "should contain password" do
    @user.attributes = valid_user_attributes.except(:password)
    @user.should have_at_least(1).error_on(:password)

    @user.password = "secret!"
    @user.should have(:no).errors_on(:password)
  end

  it "should contain date of creation" do
    @user.should respond_to(:created_at)
  end

  it "should contain date of last login" do
    @user.should respond_to(:last_login_at)
  end

  it "should contain number of logins" do
    @user.should respond_to(:number_of_logins)
  end

  it "should contain users owns games" do
    @user.should respond_to(:games)
  end

end

describe User, "while creating" do

  before :each do
    @user = User.new valid_user_attributes
  end

  it "should have valid length of login (between 3 and 40 chars)" do
    @user.should have(:no).errors_on(:login)
    lambda { @user.save! }.should_not raise_error

    @user.login = "jo"
    @user.should have_at_least(1).error_on(:login)

    @user.login = ("12345" * 8) + "1" # 41 chars :)
    @user.should have_at_least(1).error_on(:login)
  end

  it "should have valid email (regexp)" do
    @user.should have(:no).errors_on(:email)
    lambda { @user.save! }.should_not raise_error

    @user.email = "prozz at baduk.pl"
    lambda { @user.save! }.should raise_error
    @user.should have_at_least(1).error_on(:email)
  end 

  it "should have valid length of email (between 5 and 40 chars)" do
    @user.should have(:no).errors_on(:email)
    lambda { @user.save! }.should_not raise_error
    
    @user.email = "1@pl"
    lambda { @user.save! }.should raise_error
    @user.should have_at_least(1).error_on(:email)
    
    @user.email = "12345@asdf.qwer.asdf.zxcv.qwer.asdf.zxcv.qwer.pl"
    lambda { @user.save! }.should raise_error
    @user.should have_at_least(1).error_on(:email)
  end

  it "should have valid length of password (between 5 and 40 chars)" do
    @user.should have(:no).errors_on(:password)
    lambda { @user.save! }.should_not raise_error
    
    @user.password = "1234"
    @user.password_confirmation = "1234"
    lambda { @user.save! }.should raise_error
    @user.should have_at_least(1).error_on(:password)
    
    @user.password = "12345@asdf.qwer.asdf.zxcv.qwer.asdf.zxcv.qwer.pl"
    @user.password_confirmation = "12345@asdf.qwer.asdf.zxcv.qwer.asdf.zxcv.qwer.pl"
    lambda { @user.save! }.should raise_error
    @user.should have_at_least(1).error_on(:password)
  end

  it "should have password confirmation" do
    @user.password_confirmation = "not match" 
    lambda { @user.save! }.should raise_error
    @user.should have_at_least(1).error_on(:password)

    @user.password_confirmation = "secret!" 
    @user.should have(:no).errors_on(:password)
    lambda { @user.save! }.should_not raise_error
  end

  it "should not allow same email as existing user" do
    lambda { @user.save! }.should_not raise_error
    @same_user = User.new @user.attributes
    lambda { @same_user.save! }.should raise_error
    @same_user.should have(1).error_on(:email)
  end

  it "should not allow same login as existing user" do
    lambda { @user.save! }.should_not raise_error
    @same_user = User.new @user.attributes
    lambda { @same_user.save! }.should raise_error
    @same_user.should have(1).error_on(:login)
  end

  it "should have crypted password" do
    @user.save!
    @user.password.should == "49518585317fba4666dba078f4fe2e7e2ca3afdd"
  end

end

describe User, "after creation" do

  before :each do
    @user = User.new valid_user_attributes
  end

  it "should have ability to change password" do
    @user.should respond_to(:change_password)
    
    old_password = @user.password

    lambda {
      @user.change_password("some valid password")
    }.should_not raise_error

    old_password.should_not == @user.password
  end

  it "should have ability to authenticate" do
    login = @user.login
    password = @user.password

    # nil when no such user in database
    User.authenticate(login, password).should be_nil 

    # user object after inserting user to database
    @user.save!
    User.authenticate(login, password).should eql(@user)
  end

end

describe User, "just after login" do

  before :each do
    User.create! valid_user_attributes
    
    @time_before_login = Time.now 
    @user = User.authenticate('prozz', 'secret!')
    @user.should_not be_nil
  end

  it "should have incremented number of logins" do
    @user.number_of_logins.should eql(1)
  end

  it "should have newer last login date" do
    @user.last_login_at.should > @time_before_login
  end

end

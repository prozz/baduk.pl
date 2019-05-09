require File.dirname(__FILE__) + '/../spec_helper'

include SpecHelper

describe TournamentController do

  it "should show tournament details with list of confirmed players" do
    Player.should_receive(:find_confirmed).and_return(Array.new)
    get 'index'
    response.should be_success
    response.should render_template('index') 
    assigns[:players].should_not be_nil
  end

  def post_player_registration player # {{{
    post 'register', { 
      :player => { 
        :name => @player.name,
        :surname => @player.surname,
        :email => @player.email,
        :rank => @player.rank
    }}
  end # }}}

  it "should allow registration of new players" do
    @player = Player.new valid_player_attributes
    Player.should_receive(:new).with(valid_player_attributes).and_return(@player)
    @player.should_receive(:save).and_return(true)
    controller.expect_render(:partial => 'confirmation', :object => @player)
    post_player_registration @player
  end

  it "should send email after successful registration" do
    @player = Player.new valid_player_attributes
    Player.should_receive(:new).with(valid_player_attributes).and_return(@player)
    @player.should_receive(:save).and_return(true)
    Notifictions.should_receive(:deliver_tournament_registration).with(@player.email, @player)
    post_player_registration @player
  end

  it "should allow registration of new players and show errors if needed" do
    wrong_attributes = valid_player_attributes.except(:email)
    wrong_attributes['email'] = "bad mail!"
    @player = Player.new wrong_attributes
    Player.should_receive(:new).with(wrong_attributes).and_return(@player)
    @player.should_receive(:save).and_return(false)
    controller.expect_render(:partial => 'form', :object => @player)
    post_player_registration @player
  end

  it "should allow unregistering form the tournament" do
    @player = Player.new valid_player_attributes
    Player.should_receive(:find_by_secret_code).with('dummy uuid').and_return(@player)
    @player.should_receive(:destroy)
    get 'unregister', :id => 'dummy uuid'
    response.should be_success
    response.should render_template('unregister') 
  end

  it "should show 404 for invalid unregistration link" do
    Player.should_receive(:find_by_secret_code).with('dummy uuid').and_return(nil)
    get 'unregister', :id => 'dummy uuid'
    response.should_not be_success
    response.code.should eql("404")
  end

  it "should allow confirmation of participation in the tournament" do
    @player = Player.new valid_player_attributes
    Player.should_receive(:find_by_secret_code).with('dummy uuid').and_return(@player)
    @player.should_receive(:save!).and_return(true)
    get 'confirm', :id => 'dummy uuid'
    response.should be_success
    response.should render_template('confirm') 
    assigns[:player].should equal(@player)
    @player.is_confirmed.should be_true
  end

  it "should show 404 for invalid confirmation links" do
    Player.should_receive(:find_by_secret_code).with('dummy uuid').and_return(nil)
    get 'confirm', :id => 'dummy uuid'
    response.should_not be_success
    response.code.should eql("404")
  end
end

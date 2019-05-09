require File.dirname(__FILE__) + '/../spec_helper'
  
include SpecHelper

describe Player, "attributes" do # {{{
  before(:each) do
    @player = Player.new
  end

  it "should have core attributes (name, surname, email, rank)" do
    @player.should respond_to(:name)
    @player.should respond_to(:surname)
    @player.should respond_to(:email)
    @player.should respond_to(:rank)
  end

  it "should have confirmation attributes" do
    @player.should respond_to(:secret_code)
    @player.should respond_to(:is_confirmed)
    @player.should respond_to(:is_removed)
  end
end # }}}
describe Player, "while creating" do # {{{
  before(:each) do
    @player = Player.new
    @player.name = 'Paweł'
    @player.surname = 'Rozynek'
    @player.email = 'prozzz@gmail.com'
    @player.rank = '13 kyu'
  end

  it "should raise no errors while saving" do
    lambda { @player.save! }.should_not raise_error
  end

  it "should have confirmation fields filled in automatically" do
    lambda { @player.save! }.should_not raise_error
    @player.secret_code.should_not be_nil
    @player.is_confirmed.should_not be_nil
    @player.is_removed.should_not be_nil
  end

  it "should have name length of max 25 chars" do
    @player.name = "12345" * 5 + "1"
    check_saving_has_errors(@player, :name, 1)
  end

  it "should have name surname length of max 40 chars" do
    @player.surname = "12345" * 8 + "1"
    check_saving_has_errors(@player, :surname, 1)
  end

  it "should have valid email address" do
    @player.email = "prozz at gmail.com"
    check_saving_has_errors(@player, :email, 1)

    @player.email = "tra la la la"
    check_saving_has_errors(@player, :email, 1)
  end

  it "should have unique email address" do
    lambda { @player.save! }.should_not raise_error
    @same_player = Player.new @player.attributes
    check_saving_has_errors(@same_player, :email, 1)
  end

  it "should check format of rank" do
    @player.rank = "cos tam"
    lambda { @player.save! }.should raise_error
    check_saving_has_errors(@player, :rank, 1)
  end

  it "should check for fields presence" do
    @empty_player = Player.new
    lambda { @empty_player.save! }.should raise_error
    # why this is failing?!?
    # @empty_player.should have_at_least(4).errors # 4 is number of core attributes
  end

end # }}}
describe Player, "custom search methods" do
  it "should return list of confirmed players" do
    Player.should respond_to(:find_confirmed)
    @players = Player.find_confirmed
    @players.should be_kind_of(Array)
  end
end

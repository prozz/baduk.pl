require File.dirname(__FILE__) + '/../spec_helper'

include SpecHelper

describe Game, "attributes" do # {{{

  before :each do
    @game = Game.new
  end

  it "should contain sgf game record" do
    @game.attributes = valid_game_attributes.except(:sgf)
    @game.should have_at_least(1).error_on(:sgf)

    @game.sgf = valid_game_attributes.only_value(:sgf)
    @game.should have(:no).errors_on(:sgf)
  end

  it "should contain owner" do
    @game.attributes = valid_game_attributes.except(:owner)
    @game.should have_at_least(1).error_on(:owner)
    
    @game.owner = valid_game_attributes.only_value(:owner)
    @game.should have(:no).error_on(:owner)
  end

  it "should contain description" do
    @game.attributes = valid_game_attributes.except(:description)
    @game.should have_at_least(1).error_on(:description)

    @game.description = valid_game_attributes.only_value(:description)
    @game.should have(:no).error_on(:description)
  end

  it "should contain comments" do
    @game.should respond_to(:comments)
  end
end # }}}

describe Game, "while creating" do # {{{

  before :each do
    @time_before_saving = Time.now
    @game = Game.new valid_game_attributes
  end

  it "should have sgf data and its length should be valid" do end

  it "should have description and its length should be valid" do end

  it "should have owner" do end 

  it "should have uploaded at attribute filled with correct date" do
    lambda { @game.save! }.should_not raise_error
    @game.uploaded_at.should > @time_before_saving
  end

  it "should allow sgf data from uploaded file" do # TODO: do StringIO from it
#    @game.sgf_from_file = @game.sgf
#    @game.sgf = nil
#    lambda { @game.save! }.should_not raise_error
  end

end # }}}

describe Game do
  it "should have ability to deal with tags" do
    @game = Game.new
    @game.tag_list.should be_empty
  end

  it "should allow finding recent games" do
    Game.should respond_to(:find_recent)
    # TODO: deal with fixtures and add something here
  end

end

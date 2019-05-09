require File.dirname(__FILE__) + '/../spec_helper'

describe Comment, "attributes" do
  before(:each) do
    @comment = Comment.new
    @comment.comment = "this is pretty standard comment"
  end

  it "should contain author" do
    @comment.should respond_to(:author) 
  end
  it "should contain comment" do
    @comment.should respond_to(:comment) 
  end
  it "should belong to game" do
    @comment.should respond_to(:game)
  end
  it "should have creation timestamp" do
    @comment.should respond_to(:created_at)
  end
  it "should have no empty comment" do
    @comment.should have(:no).errors_on(:comment)
    @comment.comment = nil
    @comment.should have(1).error_on(:comment)
    @comment.comment = ""
    @comment.should have(1).error_on(:comment)
  end
  it "should have comment no more than 6000 chars long" do
    @comment.should have(:no).errors_on(:comment)
    @comment.comment = "x" * 6000 + "y"
    @comment.should have(1).error_on(:comment)
  end
end
describe Comment do
  it "should allow finding recent comments" do
    Comment.should respond_to(:find_recent)
    # TODO: deal with fixtures and add something here
  end
end

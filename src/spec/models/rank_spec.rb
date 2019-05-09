require File.dirname(__FILE__) + '/../spec_helper'

describe Rank do
  before(:each) do
    @rank = Rank.new
  end

  it "should allow finding ranks correctly ordered" do
    Rank.should respond_to(:find_ordered)
    # TODO add something here if fixtures will be ready
  end

  it "should have to_s correctly overriden" do
    @rank.should respond_to(:to_s)
    @rank.value = "7 dan"
    @rank.to_s.should eql("7 dan")
  end
end

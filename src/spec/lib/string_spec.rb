require File.dirname(__FILE__) + '/../spec_helper'

describe String do

  it "should tidy up any string by removing white spaces, \\n and \\r" do
    " asdf ".tidy_eols.should eql("asdf")
    " asdf\n ".tidy_eols.should eql("asdf")
    " as\ndf".tidy_eols.should eql("asdf")
    "as\rdf ".tidy_eols.should eql("asdf")
  end

  it "should give random strings with default length of 8" do
    String.random.length.should eql(8)
    String.random.should match(/[\w\d]/)
    String.random(20).should match(/[\w\d]/)
    String.random(20).length.should eql(20)
  end

end


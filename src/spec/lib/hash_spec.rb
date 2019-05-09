require File.dirname(__FILE__) + '/../spec_helper'

describe Hash do
  it "should change symbol keys to string keys" do
    { :a => "1" }.with_stringified_keys.should == { "a" => "1" }
  end
end

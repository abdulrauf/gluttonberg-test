#require File.join( File.dirname(__FILE__), '..', "spec_helper" )
require 'spec_helper'

module Gluttonberg
  
  Library.setup
  
  describe Library do
    it "should have asset root set" do
      Library.root.should == Rails.dir_for(:public) / "assets"
    end
  end
end
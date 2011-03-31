#require File.dirname(__FILE__) + '/../spec_helper'
require 'spec_helper'

module Gluttonberg
  
  describe AssetCategory do
    
    before :all do
      AssetCategory.build_defaults
    end  

    it "should have 4 categories" do
      @categories = AssetCategory.all      
      @categories.length.should == 4
    end
    
    it "should have 3 known categories" do
      @categories = AssetCategory.find(:all , :conditions => {:unknown => false})      
      @categories.length.should == 3
    end
    
    it "should have 1 unknown category" do
      @categories = AssetCategory.find(:all , :conditions => {:unknown => true})      
      @categories.length.should == 1      
    end
    
    it "should have 1 unknown category named 'uncategorised' " do
      @category = AssetCategory.find(:first , :conditions => {:unknown => true})    
      @category.name.should == "uncategorised"
    end
    
    

  end
end  
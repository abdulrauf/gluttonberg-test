require File.join( File.dirname(__FILE__), '..', '..', "spec_helper" )

module Gluttonberg
  
  describe Content::Publishable do
    
    class TestPage
      include DataMapper::Resource
      include Gluttonberg::Content::Publishable

      property :id,               Integer,  :serial => true, :key => true
      property :name,             String,   :length => 1..100
    end
    
    before :all do 
      TestPage.auto_migrate!      
      test1 = TestPage.create(:name=>"Test1")
      test2 = TestPage.create(:name=>"Test2")
      test3 = TestPage.create(:name=>"Test3")
      test2.publish!
      test3.publish!  
    end
      
    
    it "should have registered two TestPage" do
      TestPage.all.length.should == 3
    end

    it "should have Test1 as first published TestPage" do
      TestPage.published.name.should == "Test2"
    end
    
    it "should have published" do
      TestPage.published(:name=>"Test3").name.should == "Test3"
    end
    
    it "should have 1 published TestPage" do
      TestPage.all_published(:published=>true).length.should == 2
    end
    
    it "should be published" do
      TestPage.first(:name=>"Test1").published?.should == false
    end
        
    it "should be unpublished" do
      test2 = TestPage.first(:name=>"Test2")
      test2.unpublish!
      test2.published?.should == false
    end
      
 
  end
end

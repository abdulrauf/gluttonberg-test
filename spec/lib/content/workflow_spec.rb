require File.join( File.dirname(__FILE__), '..', '..', "spec_helper" )

module Gluttonberg
  
  describe Content::Workflow do
    
    class TestPage
      include DataMapper::Resource
      include Gluttonberg::Content::Publishable
      include Gluttonberg::Content::Workflow
      
      property :id,               Integer,  :serial => true, :key => true
      property :name,             String,   :length => 1..100
    end
    
    before :all do 
      TestPage.auto_migrate!      
      test1 = TestPage.create(:name=>"Test1")
      test2 = TestPage.create(:name=>"Test2")
      test3 = TestPage.create(:name=>"Test3")
      
      test2.reject!
      test3.approve!  
    end
      
    
    it "should have registered three TestPage" do
      TestPage.all.length.should == 3
    end

    it "should have Test2 as first rejected TestPage" do
      TestPage.all_rejected.first.name.should == "Test2"
    end

    it "should in_progress" do
      TestPage.all(:name=>"Test1").first.state.should == :in_progress
    end
    
    
    it "should have Test1 as first pending TestPage" do
      test1 = TestPage.first(:name=>"Test1")
      test1.submit!
      TestPage.all_pending.first.name.should == "Test1"
    end
    
    
    
    it "should rejected" do
      TestPage.all(:name=>"Test2").first.state.should == :rejected
    end
   
    it "should approved" do
      TestPage.all(:name=>"Test3").first.state.should == :approved
    end
        
    it "should approved" do
      test1 = TestPage.first(:name=>"Test1")
      test1.approve!
      test1.publish!
      result = TestPage.all_approved_and_published()
      result.length.should == 1
      result.first.state.should == :approved
      result.first.published?.should == true
    end  
 
  end
end

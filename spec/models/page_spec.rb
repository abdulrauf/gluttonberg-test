# encoding: utf-8

require 'spec_helper'

module Gluttonberg 
  describe Page do
  
    before(:all) do
        @page = Page.create! :name => 'first name', :description_name => 'newsletter'
  
  
    end
    
    it "should load specified localization"
    
    it "should load children with specified localization preloaded"

    it "should return correct localization"

    it "should raise error if localization is missing"

    it "should return application as layout name" do
      @page.layout.should == "application"
    end
    
    it "should return newsletter as view name" do
      @page.view.should == "newsletter"
    end
    

    it "should have only one home page at a time" do
      
      current_home = Page.create(:name => "Page1" , :home => true , :description_name => 'home')
      
      page2 = Page.create(:name => "Page2" , :description_name => 'home')
      
      page2.reload
      current_home.reload
      current_home.home.should be_true
      page2.home.should be_false
            
      page3 = Page.create(:name => "Page3" , :description_name => 'home')
      
      page4 = Page.create(:name => "Page4" , :home => true, :description_name => 'home')

      current_home.reload
      page4.reload
      page4.home.should be_true
      current_home.home.should be_false
            
      
      page5 = Page.create(:name => "Page5" , :description_name => 'home')
      new_home = Page.create(:name => "New Home", :description_name => 'home')
    
      new_home.update_attributes(:home => true)
    
      new_home.reload
      current_home.reload
    
      new_home.home.should be_true
      current_home.home.should be_false
    end
    

     
    it "should load contents (html_contents, image_contents, plain_text_contents)" do
        @page.respond_to?(:html_contents).should == true
        @page.respond_to?(:image_contents).should == true
        @page.respond_to?(:plain_text_contents).should == true
        
        #in my example newsletter has one content for each type
        @page.html_contents.length.should == 1
        @page.image_contents.length.should == 1
        @page.plain_text_contents.length.should == 1        
    end
    
    it "should have parent and children assoications" do
      p1 = Page.create(:name => "P1" , :description_name => 'home' )
      p2 = Page.create(:name => "P2" , :description_name => 'home' , :parent => p1)
      p1.children.length.should == 1
      p2.parent.id.should == p1.id 
    end
    
    
    it "should do slug management. If slug is not available it should make slug from title of the page by cleaning it. It should work with ruby 1.9.2" do
        page = Page.new(:name => "Page ”Slug Test" , :description_name => 'home')
        
        page.slug.blank?.should == true
        
        page.valid?
        page.slug.blank?.should == false
        page.slug.should == "page_slug_test"
        
        page.slug = "Page \t Slug ′‟‛„‚”“”˝\(\)\;\:\@\&\=\+\$\,\/?\%\#\[\]] Test"
        page.slug.should == "page___slug__test"        
    end
    
        
    it "should position new page at bottom of the list" do
        
    end
    
    it "should manage position properly when we are rearranging items"
    
    it "should change parent if we are moving out"
  
    it "should have nav_label"
    
    it "should have title"
    
    it "should have path"
    
    it "should have template_paths"
    
    it "should set_depth of the page"
    
    it "should remove its all depdendents if destroyed."
      
    end
    
  
    # it "test_saves_versioned_copy" do
    #     p = Page.create! :name => '2nd name', :description_name => 'newsletter'
    #     p.new_record?.should == false 
    #     p.versions.size.should == 1
    #     p.version.should == 1
    #     Page.versioned_class.should == p.versions.first.class
    # end
    # 
    #   
    # it "test_saves_without_revision" do
    #     p = Page.find_by_name('first name')
    #     old_versions = p.versions.count
    # 
    #     p.save_without_revision
    # 
    #     p.without_revision do
    #       p.update_attributes :name => 'changed'
    #     end
    # 
    #     assert_equal old_versions, p.versions.count
    #   end
    # 
    #   it "test_rollback_with_version_number" do
    #       p = Page.find_by_name('first name')
    #             
    #       p.version.should == 1
    #     
    #       p.name = "first name v2"
    #       p.save
    #     
    #       p.version.should == 2
    #       p.name.should == 'first name v2'
    # 
    #       p.revert_to!(1)
    #       p.version.should == 1
    #       p.name.should == 'first name'
    #       p.versions.size.should == 2
    #     
    #       p.revert_to!(2)
    #       p.version.should == 2
    #       p.name.should == 'first name v2'
    #       p.versions.size.should == 2
    #   end
    # 
    #   it "should not cross version limit, at the moment i put it 5" do
    #       p = Page.find_by_name('first name')
    #             
    #       p.version.should == 1
    #     
    #       p.name = "first name v2"
    #       p.save
    #     
    #       p.version.should == 2
    #       p.name.should == 'first name v2'
    #     
    #       p.name = "first name v3"
    #       p.save
    #     
    #       p.version.should == 3
    #       p.name.should == 'first name v3'
    #     
    #       p.versions.size.should == 3
    #     
    #       p.name = "first name v4"
    #       p.save
    #     
    #       p.version.should == 4
    #       p.name.should == 'first name v4'
    #     
    #       p.versions.size.should == 4
    #     
    #       p.name = "first name v5"
    #       p.save
    #     
    #       p.version.should == 5
    #       p.name.should == 'first name v5'
    #     
    #       p.versions.size.should == 5
    #     
    #       p.name = "first name v6"
    #       p.save
    #     
    #       p.version.should == 6
    #       p.name.should == 'first name v6'
    # 
    #       p.versions.size.should == 5
    #   end
    # 
    #   it "test transitions " do
    #       p = Page.find_by_name('first name')
    #     
    #       p.version.should == 1
    #     
    #       p.current_state.should == :draft
    #     
    #       p.reviewed!
    #       p.current_state.should == :reviewed
    #     
    #       # if state in ignore list then it should not create new version
    #       p.version.should == 1
    #   end
    
  
  end
end
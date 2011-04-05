#require File.join( File.dirname(__FILE__), '..', "spec_helper" )
require 'spec_helper'


# this test is considering page_descriptions file in config folder
# and its test is based on newsletter page type
# page :newsletter do
#   label "Newsletter"
#   description "Newsletter Page"
#   view "newsletter"
#   layout "application"
#   
#   section :title do
#     label "Title"
#     type :plain_text_content
#   end
#   
#   section :description do
#     label "Description"
#     type :html_content
#   end
#   
#   section :image do
#     label "Image"
#     type  :image_content
#   end
#   
# end


module Gluttonberg 
  describe PageObserver do
      
      before(:all) do
          @page = Page.create! :name => 'first name', :description_name => 'newsletter'
          
          dialect = Gluttonberg::Dialect.create( :code => "en" , :name => "English" , :default => true)
          locale = Gluttonberg::Locale.new( :slug => "au" , :name => "Australia" , :default => true)      
          locale.dialect_ids = [dialect.id]
          locale.save!
          
          @observer = PageObserver.instance
          
          @page2 = Page.create! :name => 'Page2', :description_name => 'newsletter'
      end
      
      
    it "should create localization when we create locale" do
      @page.reload
      @page.localizations.length.should == 1
      
      @observer.after_create(@page)
      
      @page.localizations.length.should == 2      
    end
      
    it "should create page localization when page is created given that locale and dialect exist." do
      @page2.localizations.length.should == 1            
    end
    
    it "should create muliple page localization when page is created given that there are multiple locales and dialects exist." do      
      dialect = Gluttonberg::Dialect.create( :code => "urdu" , :name => "Urdu" )
      locale = Gluttonberg::Locale.new( :slug => "pk" , :name => "Pakistan" )      
      locale.dialect_ids = [dialect.id]
      locale.save!
            
      @page3 = Page.create! :name => 'Page3', :description_name => 'newsletter'
      @page3.localizations.length.should == 2                  
    end
    
    it "should create page sections and their localizations when page is created given that locale and dialect exist. This is also testing their associations" do
      
      @page2.localizations.length.should == 1            
      
      @page2.localizations.first.contents.length.should == 3
      
      @page2.respond_to?(:plain_text_contents).should == true
      @page2.respond_to?(:html_contents).should == true
      @page2.respond_to?(:image_contents).should == true
      
      @page2.plain_text_contents.length.should == 1
      @page2.html_contents.length.should == 1
      @page2.image_contents.length.should == 1
      
      @page2.plain_text_contents.first.localizations.length.should == 1
      @page2.html_contents.first.localizations.length.should == 1
      @page2.image_contents.first.respond_to?(:localizations).should == false #Images are not localized
    end
    
    
    it "before_update(page) should set path_needs_recaching true if page.parent_id or slug is changed" do
      @page2.paths_need_recaching.should be_nil
      @observer.before_update(@page2)
      @page2.paths_need_recaching.should be_nil
      
      @page2.parent_id = @page.id 
      
      @observer.before_update(@page2)
      @page2.paths_need_recaching.should == true
      
      @page2.paths_need_recaching = false
      @page2.paths_need_recaching.should == false
      
      @page2.slug << "_changed"  
      
      @observer.before_update(@page2)
      @page2.paths_need_recaching.should == true
    end  
    
    it "after_update(page) should regenerate_paths for page_localizations if page.paths_need_recaching? is true." do
      
      @page4 = Page.create! :name => 'Page4', :description_name => 'newsletter'
      previous_path_of_localization = @page4.localizations.first.path 
      new_path_of_localization = previous_path_of_localization + "_changed"
      
      @page4.slug.should == "page4"
      @page4.update_attributes(:slug => @page4.slug + "_changed")
      
      @page4.reload
      
      @page4.slug.should == "page4_changed"
      
      @page4.localizations.first.path.should == new_path_of_localization
    end  
    
    
    
    


  end
end
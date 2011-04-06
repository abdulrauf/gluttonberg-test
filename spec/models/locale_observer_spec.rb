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
  describe LocaleObserver do
      
      before(:all) do
          @page = Page.create! :name => 'first name', :description_name => 'newsletter'
          
          @dialect = Gluttonberg::Dialect.create( :code => "en" , :name => "English" , :default => true)
          @locale = Gluttonberg::Locale.new( :slug => "au" , :name => "Australia" , :default => true)      
          @locale.dialect_ids = [@dialect.id]
          @locale.save!
          
          @observer = LocaleObserver.instance
      end
      
      
    it "should create localizations for existing pages when we create locale" do
      @page.reload
      @page.localizations.length.should == 1
    end

    it "should create localizations for new pages when we create locale" do
      page2 = Page.create! :name => 'Page2', :description_name => 'newsletter'
      page2.localizations.length.should == 1
    end
    
    it "should create content localizations for existing pages when we create locale" do
      page = Page.create! :name => 'Page2', :description_name => 'newsletter'
      page.localizations.first.html_content_localizations.length.should == 1
      page.localizations.first.plain_text_content_localizations.length.should == 1
    end
    
    it "should create content localizations for new pages when we create locale" do
      page2 = Page.create! :name => 'Page2', :description_name => 'newsletter'
      page2.localizations.first.html_content_localizations.length.should == 1
      page2.localizations.first.plain_text_content_localizations.length.should == 1
    end
    
    
    it "should create more page localizations when number of dialects are increased  for locale" do      
      dialect2 = Gluttonberg::Dialect.create( :code => "urdu" , :name => "Urdu" )
      @locale.dialect_ids = [@dialect.id , dialect2.id]
      @locale.save!
            
      @page.reload
      @page.localizations.length.should == 2
    end
    
    it "should delete page localizations when number of dialects are decreased  for locale" do      
      dialect2 = Gluttonberg::Dialect.create( :code => "urdu" , :name => "Urdu" )
      @locale.dialect_ids = [ dialect2.id]
      @locale.save!
            
      @page.reload
      @page.localizations.length.should == 1
    end
    
    
    
    
    
    


  end
end
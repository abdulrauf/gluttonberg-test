#require File.join( File.dirname(__FILE__), '..', "spec_helper" )
require 'spec_helper'

module Gluttonberg
  describe PageDescription do
    describe "Clearing page descriptions" do
      it "should clear all definitions" do
        PageDescription.add do
          page(:lala)     { label "One" }
          page(:wubwub)   { label "Two" }
          page(:donkdonk) { label "Three" }
        end
        
        PageDescription.all.length.should == 3
        PageDescription.clear!
        PageDescription.all.empty?.should be_true
      end
    end
    
    describe "Accessing descriptions" do
      before :all do
        PageDescription.add do
          page(:lala)     { label "One" }
          page(:wubwub)   { label "Two" }
        end
      end
      
      it "should return the correct descriptions" do
        PageDescription.behaviour(:default).length.should == 2
      end
      
      it "should return the correct names" do
        PageDescription.names_for(:default).length.should == 2
        [:lala, :wubwub].each do |name|
          PageDescription.names_for(:default).include?(name).should be_true
        end
      end
      
      after :all do
        PageDescription.clear!
      end
    end
    
    describe "Standard page with defaults" do
      before :all do
        PageDescription.add do
          page(:simple) { label "Simple Page" }
        end
      end
      
      it "should create a page description" do
        PageDescription[:simple].should_not be_nil
      end
      
      it "should have a default view template" do
        PageDescription[:simple][:view].should == "default"
      end
      
      it "should have a default layout template" do
        PageDescription[:simple][:layout].should == "default"
      end
      
      it "should have default behaviour" do
        PageDescription[:simple][:behaviour].should == :default
      end
      
      it "should not be the home page" do
        PageDescription[:simple][:home].should_not be_true
      end
      
      it "should have a label" do
        PageDescription[:simple][:label].should == "Simple Page"
      end
    end
    
    describe "Defining the homepage" do
      before(:all) do
        PageDescription.add do
          page :home do
            label "Home Page"
            home true
          end
        end
      end
      
      it "should be set to the home page" do
        PageDescription[:home].home?.should be_true
      end
      
      it "should automatically have it's limit set to on" do
        PageDescription[:home][:limit].should == 1
      end
    end
    
    describe "A page with full options" do
      before(:all) do
        PageDescription.add do
          page :full do
            label       "Full Page"
            description "Explicit, no defaults."
            view        "full"
            layout      "very_full"
            limit       4
          end
        end
      end
      
      it "should have a description" do
        PageDescription[:full][:description].should == "Explicit, no defaults."
      end
      
      it "should have the specified view" do
        PageDescription[:full][:view].should == "full"
      end
      
      it "should have the specified layout" do
        PageDescription[:full][:layout].should == "very_full"
      end
      
      it "should have the specified limit" do
        PageDescription[:full][:limit].should == 4
      end
    end
    
    describe "A page with simple sections defined" do
      before :all do
        PageDescription.add do
          page :has_sections do
            label "This page has sections, weeee!"
            
            section :main do
              label "Main Content"
              type  :rich_text
              limit 1..2
            end
            
            section :side do
              label "Sidebar"
              type  :rich_text
              limit 1
            end
          end
        end
        @desc = PageDescription[:has_sections]
      end
      
      it "should have two sections" do
        @desc.sections.length.should == 2
      end
      
      it "should set the label" do
        @desc.sections[:main][:label].should == "Main Content"
      end
      
      it "should set the type" do
        @desc.sections[:main][:type].should == :rich_text
      end
      
      it "should set the limit" do
        @desc.sections[:main][:limit].should == (1..2)
      end
    end
    
    describe "A page with extra options in it's sections" do
      before :all do
        PageDescription.add do
          page :crazy do
            label "Weeee!"
            
            section :profile do
              label "User Profile"
              type  :profile
              configure :width => 80, :height => 100, :formats => [:jpg, :png, :gif]
            end
          end
        end
        
        @desc = PageDescription[:crazy]
      end
      
      it "should have all config options" do
        @desc.sections[:profile].config.length.should == 3
      end
      
      it "should have width configured" do
        @desc.sections[:profile].config[:width].should == 80
      end
      
      it "should have height configured" do
        @desc.sections[:profile].config[:height].should == 100
      end
      
      it "should have formats configured" do
        @desc.sections[:profile].config[:formats].should == [:jpg, :png, :gif]
      end
    end
    
    describe "A page with a rewrite" do
      before :all do
        PageDescription.add do
          page :rewrite do
            label "Rewrite"
            rewrite_to :test_url
          end
        end
        
        @desc = PageDescription[:rewrite]
      end
      
      it "should return the correct named route" do
        @desc.rewrite_route.should == :test_url
      end
      
      it "should have the rewrite behaviour" do
        @desc[:behaviour].should == :rewrite
      end
    end
        
    describe "A page with a redirect" do
      before :all do
        PageDescription.add do
          page :remote_redirect do
            label       "Simple Redirect"
            redirect_to :remote, "http://freerangefuture.com"
          end
          
          page :local_redirect do
            label       "Simple Redirect"
            redirect_to :path, "/simple"
          end
          
          page :local_block_redirect do
            label "Local Block redirect"
            redirect_to(:path) {|params| "/block" }
          end
          
          page :remote_block_redirect do
            label "Remote Block redirect"
            redirect_to(:remote) {|params| "http://google.com" }
          end
          
          page :page_redirect do 
            label "Page redirect"
            redirect_to :page
          end
        end
      end
      
      it "should be a redirect" do
        PageDescription[:remote_redirect][:behaviour].should == :redirect
      end
      
      it "should return a local path for simple redirects" do
        Router.should_receive(:localized_url).with("/simple", {})
        PageDescription[:local_redirect].redirect_url(nil, {})
      end
      
      it "should return remote url" do
        path = PageDescription[:remote_redirect].redirect_url(nil, {})
        path.should == "http://freerangefuture.com"
      end
      
      it "should return a remote url from a block" do
        path = PageDescription[:remote_block_redirect].redirect_url(nil, {})
        path.should == "http://google.com"
      end
      
      it "should return a local path from a block" do
        Router.should_receive(:localized_url).with("/block", {})
        PageDescription[:local_block_redirect].redirect_url(nil, {})
      end
      
      it "should redirect to a page"
    end
    
  end
end

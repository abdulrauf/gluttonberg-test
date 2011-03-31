require File.join( File.dirname(__FILE__), '..', '..', "spec_helper" )

module Gluttonberg
  describe Content::TextFilters do
    before :all do
      class JamFilter < Merb::PartController
        is_text_filter :jam
        
        def index
          "This is the index."
        end
      end
      
      class MelonFilter < Merb::PartController
        is_text_filter :melon
        
        def squeeze
          "You squeezed my melon!"
        end
      end
      
      class HelperTest
        include Gluttonberg::Content::TextFilters::Helpers
        attr_accessor :part_args
        
        def part(opts)
          @part_args = opts
        end
      end
    end
    
    it "should have registered two filters" do
      Content::TextFilters.all.length.should == 2
    end
    
    it "should return the correct part" do
      Content::TextFilters.get(:jam).should == JamFilter
    end
    
    it "should call part on the correct class" do
      content = "This is some content {{jam/index/1}}"
      helper = HelperTest.new
      helper.filter_text(content)
      helper.part_args[:id].should == "1"
      helper.part_args[JamFilter].should == :index
    end
  end
end

#require File.dirname(__FILE__) + '/../spec_helper'
require 'spec_helper'

# i have added some attributes to file class. because rails adds these attributes when file is uploaded through form.
class File
  attr_accessor :original_filename  , :content_type , :size
  
  def tempfile
    self
  end
end


module Gluttonberg

  
  describe Asset, "file upload" do

    
      before :all do
      
        @file = File.new(::Rails.root.to_s +  "/spec/fixtures/assets/gluttonberg_logo.jpg")
        @file.original_filename = "gluttonberg_logo.jpg"
        @file.content_type = "image/jpeg"
        @file.size = 300
      
        @collection1 = AssetCollection.create(:name => "Collection1")
        @collection2 = AssetCollection.create(:name => "Collection2")
        @collection3 = AssetCollection.create(:name => "Collection3")
            
        @param = {
            :name=>"temp file", 
            :asset_collection_ids => [ @collection1.id , @collection3.id ], 
            :file=> @file, 
            :description=>"<p>test</p>"
            }
      
        Library.build_default_asset_types    
            
        @asset = Asset.new(  @param )
      
      end

      it "should generate filename" do
        @asset.file_name.should_not be_nil
      end
    
      it "should format filename correctly" do
        @asset.file_name.should == "gluttonberg_logo.jpg"
      end
    
      it "should set size" do
        @asset.size.should_not be_nil
      end
    
      it "should set type name" do
        @asset.valid?  
        @asset.type_name.should_not be_nil
      end
    
      it "should set category" do
        @asset.valid?
        @asset.category.should_not be_nil
      end

      it "should set the correct type" do
        @asset.valid?      
        @asset.type_name.should == "Jpeg Image"
      end
    
      it "should set the correct category" do
        @asset.valid?
        @asset.category.should == "image"
      end
    
      it "should set the correct collection" do
        @asset.valid?
        @asset.asset_collections.first.name.should == "Collection1"
        @asset.asset_collections[1].name.should == "Collection3"      
      end
    

    
  end

end
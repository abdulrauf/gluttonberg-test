require File.join( File.dirname(__FILE__), '..', '..', "spec_helper" )

module Gluttonberg
  describe Content::Localization do
    before :all do
      class NonLocalized
        include DataMapper::Resource
        include Content::Localization
        
        property :id, Serial
      end
      
      class StaffProfile
        include DataMapper::Resource
        include Content::Localization
        
        property :id,   Serial
        property :name, String, :nullable => false
        
        is_localized do
          property :title,      String, :nullable => false
          property :biography,  Text,   :nullable => false
        end
      end
      
      # Upgrade em
      StaffProfile.auto_upgrade!
      
      # Generate some dummy records
      shared = {:title => /\w+{2}/.gen.capitalize, :biography  => (1..2).of { /[:paragraph:]/.generate }.join("\n\n")}
      StaffProfileLocalization.fixture(:one) { {:dialect_id => 1, :locale_id => 1}.merge!(shared) }
      StaffProfileLocalization.fixture(:two) { {:dialect_id => 1, :locale_id => 2}.merge!(shared) }
      StaffProfile.fixture { {:name => /\w+{2}/.gen.capitalize} }
      
      10.of { 
        profile = StaffProfile.generate 
        StaffProfileLocalization.generate(:one, :parent => profile)
        StaffProfileLocalization.generate(:two, :parent => profile)
      }
    end
    
    it "should have a localization" do
      StaffProfile.localized_model.should_not be_nil
    end
    
    it "should correctly indicate the presence of a localization" do
      StaffProfile.localized?.should be_true
      NonLocalized.localized?.should be_false
    end
    
    it "should set the correct table name for the localization" do
      StaffProfile.localized_model.storage_name.should == "gluttonberg_staff_profile_localizations"
    end
    
    it "should generate the correct localized class name" do
      StaffProfile.localized_model.name.should == "Gluttonberg::StaffProfileLocalization"
    end
    
    it "should generate properties for the localization" do
      StaffProfile.localized_model.properties[:id].should_not be_nil
      StaffProfile.localized_model.properties[:created_at].should_not be_nil
      StaffProfile.localized_model.properties[:updated_at].should_not be_nil
    end
    
    it "should associate the localization to the dialect and locale" do
      StaffProfile.localized_model.relationships[:dialect].should_not be_nil
      StaffProfile.localized_model.relationships[:locale].should_not be_nil
    end
    
    it "should associate the model to it's localizations" do
      StaffProfile.relationships[:localizations].should_not be_nil
    end
    
    it "should associate the localization to it's model" do
      StaffProfile.localized_model.relationships[:parent].should_not be_nil
    end
    
    it "should return a collection of models with the correct localizations" do
      collection = StaffProfile.all_with_localization(:dialect => 1, :locale => 1)
      collection.each do |model|
        model.should_not be_nil
        model.current_localization.dialect_id.should == 1
        model.current_localization.locale_id.should == 1
      end
    end
    
    it "should not overwrite the current localization if it exists" do
      profile = StaffProfile.first_with_localization(:locale => 1, :dialect => 1)
      profile.ensure_localization!
      profile.current_localization.new_record?.should be_false
    end
    
    describe "A model with a localization loaded" do
      before :all do
        @model = StaffProfile.first_with_localization(:dialect => 1, :locale => 2)
      end
      
      it "should return a model with the correct localization" do
        @model.should_not be_nil
        @model.current_localization.dialect_id.should == 1
        @model.current_localization.locale_id.should == 2
      end
      
      it "should return the localized_attributes" do
        @model.localized_attributes.should == @model.current_localization.attributes
      end
    end
    
    describe "Creating a new model with localization" do
      before :all do
        attrs = {
          :name => "Stonking", 
          :localized_attributes => {:title => "Le Manager", :biography => "Full of biographical wonderment."}
        }
        @model = StaffProfile.new_with_localization(attrs)
      end
      
      it "should return a new model" do
        @model.class.should == StaffProfile
        @model.new_record?.should be_true
      end
      
      it "should create a localization" do
        @model.current_localization.should_not be_nil
      end
      
      it "should set attributes on the model" do
        @model.attributes[:name].should == "Stonking"
      end
      
      it "should set attributes on the localization" do
        @model.localized_attributes[:title].should == "Le Manager"
        @model.localized_attributes[:biography].should == "Full of biographical wonderment."
      end
    end
    
    describe "Updating a valid model" do
      before :all do
        @model = StaffProfile.first_with_localization(:dialect => 1, :locale => 1)
        attrs = {:name => "Mungo", :localized_attributes => {:title => "Monster Wrangler", :biography => "Lives on beetles."}}
        @model.update_attributes(attrs)
        @model.reload
      end
      
      it "should update the model" do
        @model.name.should == "Mungo"
      end
      
      it "should update the localization" do
        @model.localized_attributes[:title].should == "Monster Wrangler"
        @model.localized_attributes[:biography].should == "Lives on beetles."
      end
    end
    
    describe "Validating updates" do
      before :all do
        attrs = {:localized_attributes => {:title => "Paifu!"}}
        @model = StaffProfile.new_with_localization(attrs)
      end
      
      it "should be invalid" do
        @model.valid?.should be_false
      end
      
      it "should have errors for the localization" do
        @model.errors[:biography].should_not be_nil
      end
      
      it "should have an invalid localization" do
        @model.current_localization.valid?.should be_false
      end
    end
  end
end

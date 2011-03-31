require File.join( File.dirname(__FILE__), '..', '..', "spec_helper" )

module Gluttonberg
  
  describe Content::Versioning do
    
    before :all do
      
          class NonLocalized
            include DataMapper::Resource
            include Content::Versioning
            
            property :id, Serial
          end
      
          class StaffProfile
            include DataMapper::Resource
            include Content::Versioning
            
            property :id,   Serial            
            property :title,      String
              
            is_versioned do              
              property :title,    String
            end
          end
      
          # Upgrade em
          StaffProfile.auto_migrate!
          
          # Generate some dummy records
          shared = {:title => "t1" , :versioned_attributes=> {:title => "t1"} }
          @profile = StaffProfile.new_with_version(shared)
          @profile.save!
          
          shared2 = {:title => "t2" , :versioned_attributes=> {:title => "t2"} }
          @profile2 = StaffProfile.new_with_version(shared2)
          @profile2.save!
          
            #@profile_v = StaffProfile.create(shared.merge(:parent_id => @profile.id) )
            #StaffProfileVersion.generate(:one, :parent => profile)
            #StaffProfileVersion.generate(:two, :parent => profile)
          
    end #bfr all
    
  #  it "should have a Version" do
  #    StaffProfile.versioned_model.should_not be_nil
  #  end
    
    it "should correctly indicate the presence of a Version" do
      StaffProfile.versioned?.should be_true
      NonLocalized.versioned?.should be_false
    end
    
    
    
    it "should set the correct table name for the version" do
      StaffProfile.versioned_model.storage_name.should == "gluttonberg_staff_profile_versions"
    end
    
    it "should generate the correct versioned class name" do
      StaffProfile.versioned_model.name.should == "Gluttonberg::StaffProfileVersion"
    end
    
    it "should generate properties for the version" do
      StaffProfile.versioned_model.properties[:id].should_not be_nil
      StaffProfile.versioned_model.properties[:created_at].should_not be_nil
      StaffProfile.versioned_model.properties[:updated_at].should_not be_nil
      StaffProfile.versioned_model.properties[:title].should_not be_nil      
      StaffProfile.versioned_model.properties[:parent_id].should_not be_nil
    end
        
    
    it "should associate the model to it's versions" do
      StaffProfile.relationships[:versions].should_not be_nil
    end
    
    it "should associate the version to it's model" do
      StaffProfile.versioned_model.relationships[:parent].should_not be_nil
    end
    
    it "should return a collection of models with the correct versions" do
      collection = StaffProfile.all_with_version#(:created_at => Time.now)
      collection.each do |model|
        model.should_not be_nil
        model.current_version.created_at.to_s.should == Time.now.to_s
      end
    end
    
    it "should not overwrite the current version if it exists" do
      profile = StaffProfile.first_with_version()
      profile.ensure_version!
      profile.current_version.new_record?.should be_false
    end
    
    it "should create the new version and make it current" do
      profile = StaffProfile.first_with_version()
      profile.create_new_version!
      profile.current_version.new_record?.should be_false
    end
    
          describe "A model with a version loaded" do
                before :all do
                  @model = StaffProfile.first_with_version(:title => "t1")
                end
                
                it "should return a model with the correct version" do
                  @model.should_not be_nil
                  @model.current_version.should_not be_nil
                  @model.latest_version.should_not be_nil
                  @model.current_version.title.should == "t1"
                end
                
              it "should return the localized_attributes" do
                  @model.versioned_attributes.should == @model.current_version.attributes
              end
          
          end  #describe Content::Versioning 
    
          describe "Creating a new model with version" do
          before :all do
            attrs = {
              :title => "Stonking", 
              :versioned_attributes => {:title => "Le Manager"}
            }
            @model = StaffProfile.new_with_version(attrs)            
          end
            
          it "should return a new model" do
            @model.class.should == StaffProfile
            @model.new_record?.should be_true
          end
            
          it "should create a version" do
            @model.current_version.should_not be_nil
          end
          
          it "should be vnumber 1" do
            @model.vnumber.should == 1            
          end
          
          it "should set attributes on the model" do
            @model.attributes[:title].should == "Le Manager"
            @model.title.should == "Stonking"
          end
             
           it "should set attributes on the version" do
             @model.versioned_attributes[:title].should == "Le Manager"
           end
           
           it "should set attributes on the version" do
             @model.save!
             @model.create_new_version!(:title=>"Abdul")
             @model.versioned_attributes[:title].should == "Abdul"
             @model.attributes[:title].should == "Abdul"
             @model.vnumber.should == 2
             @model.versions.length.should == 2
             @model.save!#  describe "Updating a valid model" do
 
           end
           
           it "should set attributes on the version" do
             #@model1= StaffProfile.first_with_version(:title => "Stonking", :versioned_attributes => { :title => "Abdul" })            
             @model1= StaffProfile.first_with_version(:title => "Stonking", :vnumber => 2)             
             @model1.versioned_attributes[:title].should == "Abdul"
             @model1.attributes[:title].should == "Abdul"
             @model1.versions.length.should == 2
           end
        end
    
  
  end
end

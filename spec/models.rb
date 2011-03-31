class NonLocalized
  include Content::Localization
  
  property :id, Serial
end

class StaffProfile
  include Content::Localization
  
  property :id,   Serial
  property :name, String, :nullable => false
  
  is_localized do
    property :title,      String, :nullable => false
    property :biography,  Text,   :nullable => false
  end
end

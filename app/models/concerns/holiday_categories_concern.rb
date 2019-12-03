module HolidayCategoriesConcern
	extend ActiveSupport::Concern
  included do
  	enum category: {"除夕早上" => 1, "除夕下午" => 2, "除夕晚上" => 3, 
  		"初一" => 11, "初二" => 12, "初三" => 13, "初四" => 14, "初五" => 15, 
  		"初六" => 16, "國定假日" => 20}
  end

end


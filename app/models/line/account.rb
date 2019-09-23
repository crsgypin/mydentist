class Line::Account < ApplicationRecord
	blongs_to :user, class_name: "User"

end

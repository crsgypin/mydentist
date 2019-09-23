class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_one :line_account, class_name: "Line::Account"
  has_one :user_profile, class_name: "User::Profile"
  
  
end

class Member < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  belongs_to :clinic, optional: true
  enum role: {clinic_admin: 10, doctor: 20}
  enum level: {"訪客" => 0,"操作人員" => 100,"管理者" => 200,"後台管理者" => 500} 
  #validates_inclusion_of :level, in: [0, 100, 200, 500]
  has_one :doctor

  def level_number
    self.class.levels[self.level]
  end

  def email_required?
    #for devised, noted at 2019/9/16
    false
  end

  def email_changed?
    #for devised, noted at 2019/9/16
    false
  end


end

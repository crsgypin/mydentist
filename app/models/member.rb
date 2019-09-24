class Member < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  belongs_to :clinic, optional: true
  enum role: {clinic_admin: 10, doctor: 20}
  validates_inclusion_of :level, in: [0, 100, 200, 500]
  has_one :doctor

  def email_required?
    #for devised, noted at 2019/9/16
    false
  end

  def email_changed?
    #for devised, noted at 2019/9/16
    false
  end


end
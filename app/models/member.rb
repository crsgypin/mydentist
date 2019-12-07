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
  before_destroy :check_level_for_destroy
  mount_uploader :photo, PhotoUploader
  validates_presence_of :level
  include Clinic::StaticImageHelper

  def photo_url
    if self.photo.present?
      self.photo.url
    else
      clinic_static_image_url(:doctor)
    end
  end

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

  private

  def check_level_for_destroy
    if self.level_number > 100
      raise "無權限刪除"
    end
  end


end

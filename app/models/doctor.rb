class Doctor < ApplicationRecord
	belongs_to :clinic
	has_many :doctor_durations, class_name: "Dorctor::Duration"
	has_many :events
	enum status: {"在職" => 1, "離職" => 2}
	before_validation :set_friendly_id, on: :create
	validates_presence_of :friendly_id
	validates_uniqueness_of :friendly_id

  private

  def set_friendly_id
  	if self.friendly_id.nil?
  		self.friendly_id = "d#{rand(10**8)}"
  	end
  	true
  end

end

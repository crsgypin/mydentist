class Patient < ApplicationRecord
	belongs_to :clinic
	has_many :events
  has_one :line_account, class_name: "Line::Account"
	before_validation :set_friendly_id, on: :create
	validates_presence_of :friendly_id
	validates_uniqueness_of :friendly_id

  private

  def set_friendly_id
  	if self.friendly_id.nil?
  		self.friendly_id = "p#{rand(10**8)}"
  	end
  	true
  end

end

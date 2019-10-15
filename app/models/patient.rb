class Patient < ApplicationRecord
	belongs_to :clinic
	has_many :events
  has_one :line_account, class_name: "Line::Account"
  enum :gender => {"難" => 1, "女" => 2}
	before_validation :set_friendly_id, on: :create
  before_validation :set_birthday
	validates_presence_of :friendly_id
	validates_uniqueness_of :friendly_id
  attr_accessor :year, :month, :day

  private

  def set_birthday
    if self.year.present? && self.month.present? && self.day.present?
      self.birthday = Date.parse("#{self.year}/#{self.month}/#{self.day}") rescue nil
    end
  end

  def set_friendly_id
  	if self.friendly_id.nil?
  		self.friendly_id = "p#{rand(10**8)}"
  	end
  	true
  end

end

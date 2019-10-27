module ClinicLineConcern::LineKeyword

	extend ActiveSupport::Concern
  included do
  end
	
  def add_line_keyword(args)
  	line_keyword = self.line_keywords.create(name: args[:name])
  	
  end

  private

  def check_keywords

  end



end
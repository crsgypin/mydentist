
module DoctorMethod
	def photo_url=(path)
		self.photo = File.open(path)
	end
end


def load_excel

	Doctor.include(DoctorMethod)

	class_row_index = 1
	title_row_index = 2
	primary_col_index = 0

	seed_file = Roo::Spreadsheet.open("db/seed/load_excel/seed.xlsx")
	(0..(seed_file.sheets.length-1)).each do |index|
		sheet = seed_file.sheet(index)
		class_name = sheet.row(class_row_index)[0]
		title_cols = sheet.row(title_row_index)

		((title_row_index+1)..sheet.last_row).each do |row_index|
			cols = sheet.row(row_index)
			primary_key = title_cols[primary_col_index]
			primary_value = cols[primary_col_index]
			if primary_value.present?
				record = eval(class_name).find_or_initialize_by(primary_key => primary_value)
				((primary_col_index+1)..(title_cols.length-1)).each do |index|
					key = title_cols[index]
					value = cols[index]
					record.send("#{key}=",value)
				end
				record.save!
			end
		end

		puts "done for #{class_name}, count: #{eval(class_name).count}"
	end
	puts "done!!"
end

load_excel

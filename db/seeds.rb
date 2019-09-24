# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

#admin
begin
	[
		"clinics",
		"doctors",
		"members",
		"patients",
		"services",
	].each do |filename|
		path = File.join("db", "seed", "#{filename}.yml")

		content = YAML.load_file(path)
		class_name = content["class_name"]
		data = content["data"]
		c = eval(class_name)
		data.each do |d|
			primary_key = d["primary_key"]
			attributes = d["attributes"]
			resource = c.find_or_initialize_by(primary_key)
			resource.assign_attributes(attributes)
			resource.save!
			puts "#{resource.inspect}"
		end	
	end

rescue Exception => e
	puts e.record.errors.full_messages if e.try(:record).present?
	puts e.to_s
	puts e.backtrace.first(5)
end


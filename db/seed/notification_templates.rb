

def notification_templates
	puts "notification_templates"
	Clinic.all.each do |clinic|
		puts "clinic: #{clinic.id}"
		Event::NotificationTemplate.init_content(clinic)
	end
	puts "done!!"
end

notification_templates

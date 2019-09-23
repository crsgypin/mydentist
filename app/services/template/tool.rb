module Template::Tool

	private

	def abs_controller_dir(dir)
		base_dir = File.join("app/controllers", dir)
		mkdir_p base_dir
		base_dir
	end	

	def convert_class_name_to_resource_name(class_name)
		c = class_name.gsub("::", "").underscore
		c
	end

	def find_class_name(source_class_name, associated_resource_names)
		current_class_name = source_class_name
		associated_resource_names.each do |name|
			r = current_class_name.constantize.reflect_on_all_associations.find do |a|
				a.name.to_s == name
			end
			raise "invalid associated name, #{name}, for #{current_class_name}" if r.nil?
			current_class_name = r.class_name
		end
		current_class_name
	end
	
end
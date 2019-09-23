module Template::ResourcesApplicationController
	include Template::Tool

	def render_application_controller(args)
		puts "render_application_controller: #{args}"
		base_dir = args[:base_dir]
		class_name = args[:class_name] #optional
		associated_resource_names = args[:associated_resource_names] || [] #optional
		layout = args[:layout]

		resource_name = class_name ? convert_class_name_to_resource_name(class_name) : nil
		controller_dirs = proc do
			dirs = []
			dirs.push(base_dir) if base_dir.present?
			dirs.push(resource_name.pluralize) if resource_name.present?
			dirs.concat(associated_resource_names) if associated_resource_names.present?
			dirs
		end.call
		controller_dir = File.join(controller_dirs)
		parent_controller_dir = File.join(controller_dirs.reverse.drop(1).reverse)
		abs_path = File.join(abs_controller_dir(controller_dir), "application_controller.rb")
		application_name = File.join(controller_dir, "application_controller").camelize
		parent_application_name = File.join(parent_controller_dir, "application_controller").camelize
		!File.exist?(abs_path) && File.open(abs_path, "w") do |f|
			s = []
			if resource_name.nil?
				s << "class #{application_name} < #{parent_application_name}"
				s << "  before_action {@embedded = 1}" if layout == false
				s << ""
				s << ""
				s << "end"			
			elsif associated_resource_names.length == 0
				target_resource_name = resource_name
				s << "class #{application_name} < #{parent_application_name}"
				s << "  before_action {@embedded = 1}" if layout == false
				s << "  before_action :find_#{target_resource_name}"
				s << ""
				s << "  def find_#{target_resource_name}"
				s << "    @#{target_resource_name} = #{class_name}.find(params[:#{target_resource_name}_id])"
				s << "  end"
				s << "end"				
			elsif associated_resource_names.length > 0
				if associated_resource_names.length == 1
					parent_resource_name = resource_name
					target_resource_name = associated_resource_names[0].singularize
				else
					parent_resource_name = associated_resource_names[-2].singularize
					target_resource_name = associated_resource_names[-1].singularize
				end
				s << "class #{application_name} < #{parent_application_name}"
				s << "  before_action {@embedded = 1}" if layout == false
				s << "  before_action :find_#{target_resource_name}"
				s << ""
				s << "  def find_#{target_resource_name}"
				s << "    @#{target_resource_name} = @#{parent_resource_name}.#{target_resource_name.pluralize}.find(params[:#{target_resource_name}_id])"
				s << "  end"
				s << "end"
			end
			f.puts s.join("\n")
		end

	end


end
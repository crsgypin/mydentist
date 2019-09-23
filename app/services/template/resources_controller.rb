module Template::ResourcesController
	include Template::Tool

	def render_resources_controller(args)
		puts "render_resources_controller: #{args}"
		base_dir = args[:base_dir]
		class_name = args[:class_name]
		associated_resource_names = args[:associated_resource_names]

		source_resource_name = convert_class_name_to_resource_name(class_name)
		chain_resource_names = [source_resource_name] + associated_resource_names.map(&:singularize)
		target_resource_name = chain_resource_names.last
		target_class = find_class_name(class_name, associated_resource_names).constantize
		controller_dirs = [base_dir] + chain_resource_names.map(&:pluralize)
		controller_dir = File.join(controller_dirs.reverse.drop(1).reverse)
		abs_resources_path = File.join(abs_controller_dir(controller_dir), "#{target_resource_name.pluralize}_controller.rb")

		File.open(abs_resources_path, "w") do |f|
			s = []
			controller_name = File.join(controller_dir, "#{target_resource_name.pluralize}_controller").camelize
			application_name = File.join(controller_dir, "application_controller").camelize
			if associated_resource_names.length == 0
				s << "class #{controller_name} < #{application_name}"
				s << "  before_action -> {"
				s << "    access_config({"
				s << "      variable_name: \"#{target_resource_name}\","
				s << "      new_resource: proc { ::#{class_name}.new},"
				s << "      find_resource: proc { ::#{class_name}.find(params[:id])},"
				s << "      resource_params: proc { params.require(:#{target_resource_name}).permit(#{class_name}.accessable_atts)}"
				s << "    })"
				s << "  }"
				s << ""
				s << "  def index"
				s << "    @#{target_resource_name.pluralize} = ::#{class_name}.all"
				s << "    @#{target_resource_name.pluralize} = @#{target_resource_name.pluralize}.page(params[:page]).per(20)"
				s << "  end"
				s << ""
				s << "end"
			elsif associated_resource_names.length > 0
				parent_resource_name = chain_resource_names[-2]
				s << "class #{controller_name} < #{application_name}"
				s << "  before_action -> {"
				s << "    access_config({"
				s << "      variable_name: \"#{target_resource_name}\","
				s << "      new_resource: proc { @#{parent_resource_name}.#{target_resource_name.pluralize}.new},"
				s << "      find_resource: proc { @#{parent_resource_name}.#{target_resource_name.pluralize}.find(params[:id])},"
				s << "      resource_params: proc { params.require(:#{target_resource_name}).permit(@#{target_resource_name}.class.accessable_atts)}"
				s << "    })"
				s << "  }"
				s << ""
				s << "  def index"
				s << "    @#{target_resource_name.pluralize} = @#{parent_resource_name}.#{target_resource_name.pluralize}"
				s << "    @#{target_resource_name.pluralize} = @#{target_resource_name.pluralize}.page(params[:page]).per(20)"
				s << "  end"
				s << ""
				s << "end"
			end
			f.puts s.join("\n")
		end
	end	

	def render_resource_info_controller(args)
		puts "render_resources_controller: #{args}"
		base_dir = args[:base_dir]
		class_name = args[:class_name]
		associated_resource_names = args[:associated_resource_names]

		source_resource_name = convert_class_name_to_resource_name(class_name)
		chain_resource_names = [source_resource_name] + associated_resource_names.map(&:singularize)
		target_resource_name = chain_resource_names.last
		target_class = find_class_name(class_name, associated_resource_names).constantize
		controller_dirs = [base_dir] + chain_resource_names.map(&:pluralize)

		controller_dir = File.join(controller_dirs) #difference
		abs_resources_path = File.join(abs_controller_dir(controller_dir), "info_controller.rb") #difference

		File.open(abs_resources_path, "w") do |f|
			s = []
			controller_name = File.join(controller_dir, "info_controller").camelize
			application_name = File.join(controller_dir, "application_controller").camelize
			s << "class #{controller_name} < #{application_name}"
			s << "  before_action -> {"
			s << "    access_config({"
			s << "      variable_name: \"#{target_resource_name}\","
			s << "      find_resource: proc { @#{target_resource_name}},"
			s << "      resource_params: proc { params.require(:#{target_resource_name}).permit(@#{target_resource_name}.class.accessable_atts)}"
			s << "    })"
			s << "  }"
			s << ""
			s << ""
			s << "end"
			f.puts s.join("\n")
		end

	end
 

end

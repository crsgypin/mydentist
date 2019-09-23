module Template::ShowView
	include Template::Tool

	def render_show_view(args)
		puts "render_show_view: #{args}"
		base_dir = args[:base_dir]
		class_name = args[:class_name]
		associated_resource_names = args[:associated_resource_names]
		except_show_columns = args[:except_show_columns]
		for_info = args[:for_info] || false

		source_resource_name = convert_class_name_to_resource_name(class_name)
		chain_resource_names = [source_resource_name] + associated_resource_names.map(&:singularize)
		self_resource_name = chain_resource_names.last
		self_class = find_class_name(class_name, associated_resource_names).constantize
		view_dirs = [base_dir] + chain_resource_names.map(&:pluralize)
		view_dirs += ["info"] if for_info
		view_dir = view_dirs.join("/")

		abs_view_dir = File.join("app/views", view_dir)
		mkdir_p abs_view_dir 

		carrierwave_cols = self_class.uploaders.keys
		foreign_key_cols = self_class.reflect_on_all_associations(:belongs_to).map{|a| a.foreign_key}
		class_columns = self_class.column_names
		show_columns = class_columns - except_show_columns
		File.open(File.join(abs_view_dir, "show.html.erb"), "w") do |f|
			s = []
			s << "<%= render partial: \"admin/common/show_table\" , locals: {"
			s << "  id: \"#{self_resource_name}\","
			s << "  resource: @#{self_resource_name},"
		  s << "  fields: ["
		  c = []
		  show_columns.each do |col|
		  	if foreign_key_cols.exclude?(col)
		  		if carrierwave_cols.exclude?(col)
			  		c << "    {k: \"#{col}\", v: proc{|a| a.#{col} }}"
			  	else
			  		c << "    {k: \"#{col}\", v: proc{|a| a.#{col}.url }}"
			  	end
		  	end
		  end
		  s << c.join(",\n")
		  s << "  ]"
			s << "}"
			s << "%>"
			f.puts s.join("\n")
		end
	end

	def render_show_tabs_view(args)
		puts "render_show_tabs_view: #{args}"
		base_dir = args[:base_dir]
		class_name = args[:class_name]
		associated_resource_names = args[:associated_resource_names]
		child_associated_resource_names = args[:child_associated_resource_names]

		source_resource_name = convert_class_name_to_resource_name(class_name)
		chain_resource_names = [source_resource_name] + associated_resource_names.map(&:singularize)
		self_resource_name = chain_resource_names.last
		self_class = find_class_name(class_name, associated_resource_names).constantize
		view_dirs = [base_dir] + chain_resource_names.map(&:pluralize)
		view_dir = view_dirs.join("/")

		abs_view_dir = File.join("app/views", view_dir)
		mkdir_p abs_view_dir
		File.open(File.join(abs_view_dir, "show.html.erb"), "w") do |f|
			s = []
			s << "<%= render :partial => \"common/tabs_iframe\", locals: {"
			s << "  id: \"#{self_resource_name}\","
			s << "  sel_tab_index: 0,"
			s << "  tabs: ["
			child_associated_resource_names.each do |name|
				variable_names = chain_resource_names.map{|a| "@#{a}"}.join(",")
				child_url = "#{File.join(base_dir, File.join(chain_resource_names), name, "path").gsub("/","_")}(#{variable_names})"
				s << "    {name: \"#{name}\", url: #{child_url}}"
			end
			s << "  ]"
			s << " } %>"
			f.puts s.join("\n")			
		end
	end	
	
end

module Template::IndexView
	include Template::Tool

	def render_index_view(args)
		puts "render_index_view: #{args}"
		base_dir = args[:base_dir]
		class_name = args[:class_name]
		associated_resource_names = args[:associated_resource_names] || []
		index_columns = args[:index_columns]

		source_resource_name = convert_class_name_to_resource_name(class_name)
		chain_resource_names = [source_resource_name] + associated_resource_names.map(&:singularize)
		target_resource_name = chain_resource_names.last
		target_class = find_class_name(class_name, associated_resource_names).constantize
		view_dirs = [base_dir] + chain_resource_names.map(&:pluralize)
		view_dir = view_dirs.join("/")
		index_columns = index_columns

		abs_view_dir = File.join("app/views", view_dir)
		mkdir_p abs_view_dir 

		carrierwave_cols = target_class.uploaders.keys
		foreign_key_cols = target_class.reflect_on_all_associations(:belongs_to).map{|a| a.foreign_key}
		File.open(File.join(abs_view_dir, "index.html.erb"), "w") do |f|
			s = []
			s << "<%= render partial: \"admin/common/index_table\" , locals: {"
			s << "  id: \"#{target_resource_name.pluralize}\","
			s << "  resources: @#{target_resource_name.pluralize},"
		  s << "  cols: ["
		  c = []
		  index_columns.each do |col|
		  	if foreign_key_cols.exclude?(col)
		  		if carrierwave_cols.exclude?(col)
			  		c << "    {k: \"#{col}\", v: proc{|a| a.#{col} }}"
			  	else
			  		c << "    {k: \"#{col}\", v: proc{|a| a.#{col}.url }}"
			  	end
		  	end
		  end
		  s << c.join(",\n")
		  s << "  ],"
			s << "  row: {"
			s << "	  default_sel_index: 0,"
			s << "  	iframe_link_url: proc {|a| url_for(action: :show, id: a)}"
			s << "  }"
			s << "}"
			s << "%>"
			f.puts s.join("\n")
		end
	end

	
end

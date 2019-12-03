class Template
	include FileUtils
	include Template::ResourcesController
	include Template::ResourcesApplicationController
	include Template::IndexView
	include Template::ShowView

	def self.load1
		Template.new({
			base_dir: "admin/dentists",
			resources: [
				{
					class_name: "Clinic",
					index_columns: %w(id),
					except_show_columns: %w(uploaded_at),
					associated_resources: [
						{
							associated_name: "clinic_holidays",
							index_columns: %w(id),
							except_show_columns: [],
						},
					]
				},
				# {
				# 	class_name: "Event::Notification",
				# 	index_columns: %w(id),
				# 	except_show_columns: %w(uploaded_at),
				# }
			],
		})
	end

	def self.load
		Template.new({
			base_dir: "admin",
			resources: [
				# {
				# 	class_name: "Clinic",	
				# 	index_columns: %w(id),
				# 	except_show_columns: %w(uploaded_at),
				# 	associated_resources: [
				# 		{
				# 			associated_name: "members",
				# 			index_columns: %w(id),
				# 			except_show_columns: [],
				# 		},
				# 		{
				# 			associated_name: "doctors",
				# 			index_columns: %w(id),
				# 			except_show_columns: [],
				# 			associated_resources: [
				# 				{
				# 					associated_name: "events",
				# 					index_columns: %w(id status),
				# 					except_show_columns: []
				# 				}
				# 			]
				# 		},
				# 		{
				# 			associated_name: "services",
				# 			index_columns: %w(id),
				# 			except_show_columns: []
				# 		},
				# 		{
				# 			associated_name: "patients",
				# 			index_columns: %w(id),
				# 			except_show_columns: [],
				# 			associated_resources: [
				# 				{
				# 					associated_name: "events",
				# 					index_columns: %w(id status),
				# 					except_show_columns: []
				# 				}
				# 			]
				# 		},
				# 		{
				# 			associated_name: "events",
				# 			index_columns: %w(id),
				# 			except_show_columns: []
				# 		}
				# 	]
				# },
				# {
				# 	class_name: "Member",
				# 	index_columns: %w(id),
				# 	except_show_columns: %w(uploaded_at),
				# 	# associated_resources: []
				# },
				{
					class_name: "Doctor",
					index_columns: %w(id),
					except_show_columns: [],
					associated_resources: [
						{
							associated_name: "doctor_durations",
							index_columns: %w(id),
							except_show_columns: []
						}
					]
				},
				# {
				# 	class_name: "Service",
				# 	index_columns: %w(id),
				# 	except_show_columns: []
				# },
				# {
				# 	class_name: "Patient",
				# 	index_columns: %w(id),
				# 	except_show_columns: [],
				# 	associated_resources: [
				# 		{
				# 			associated_name: "events",
				# 			index_columns: %w(id status),
				# 			# except_show_columns: []
				# 		}
				# 	]
				# },
				# {
				# 	class_name: "Event",
				# 	index_columns: %w(id),
				# 	# except_show_columns: []
				# }
				# {
				# 	class_name: "Tp::Post",
				# 	index_columns: %w(id source title),
				# 	except_show_columns: %w(uploaded_at),
					# associated_resources: [
					# 	{
					# 		associated_name: "members",
					# 		index_columns: %w(id name phone gender),
					# 		except_show_columns: [],
					# 		associated_resources: [
					# 			{
					# 				associated_name: "agent_objs",
					# 				index_columns: %w(contract_id),
					# 				except_show_columns: []
					# 			}
					# 		]
					# 	},
					# ]
				# },
			]
		})
	end

	def initialize(config)
		resources = config[:resources]
		base_dir = config[:base_dir]

		resources.each do |resource|
			render_level0_files({
				base_dir: base_dir,
				class_name: resource[:class_name],
				resource: resource
			})
		end	
	end

	private

	def render_level0_files(args)
		base_dir = args[:base_dir]
		class_name = args[:class_name]
		resource = args[:resource]

		render_application_controller({
			base_dir: base_dir
		})
		render_resources_controller({
			base_dir: base_dir,
			class_name: class_name,
			associated_resource_names: []
		})
		render_index_view({
			base_dir: base_dir,
			class_name: class_name,
			associated_resource_names: [],
			index_columns: resource[:index_columns]
		})
		if !resource[:associated_resources]
			render_show_view({
				base_dir: base_dir,
				class_name: class_name,
				associated_resource_names: [],
				except_show_columns: resource[:except_show_columns]
			})
		else
			render_show_tabs_view({
				base_dir: base_dir,
				class_name: class_name,
				associated_resource_names: [],
				child_associated_resource_names: resource[:associated_resources].map{|a| a[:associated_name]}
			})
			resource[:associated_resources].each do |associated_resource|
				parent_resource_name = convert_class_name_to_resource_name(resource[:class_name])
				render_resource_files({
					base_dir: base_dir,
					class_name: class_name,
					parent_associated_resource_names: [],
					associated_resource: associated_resource,
					except_parent_show_columns: resource[:except_show_columns]
				})
			end
		end
	end

	def render_resource_files(args)
		base_dir = args[:base_dir]
		class_name = args[:class_name]
		parent_associated_resource_names = args[:parent_associated_resource_names]
		associated_resource = args[:associated_resource]
		associated_resource_names = parent_associated_resource_names + [associated_resource[:associated_name]]
		except_parent_show_columns = args[:except_parent_show_columns]

		render_application_controller({
			layout: false,
			base_dir: base_dir,
			class_name: class_name,
			associated_resource_names: parent_associated_resource_names
		})
		render_resource_info_controller({
			base_dir: base_dir,
			class_name: class_name,
			associated_resource_names: parent_associated_resource_names
		})
		render_show_view({
			base_dir: base_dir,
			class_name: class_name,
			associated_resource_names: parent_associated_resource_names,
			except_show_columns: associated_resource[:except_show_columns],
			for_info: true
		})
		render_resources_controller({
			base_dir: base_dir,
			class_name: class_name,
			associated_resource_names: associated_resource_names
		})
		render_index_view({
			base_dir: base_dir,
			class_name: class_name,
			associated_resource_names: associated_resource_names,
			index_columns: associated_resource[:index_columns]
		})

		if !associated_resource[:associated_resources]
			render_show_view({
				base_dir: base_dir,
				class_name: class_name,
				associated_resource_names: associated_resource_names,
				except_show_columns: associated_resource[:except_show_columns]
			})
		else
			render_show_tabs_view({
				base_dir: base_dir,
				class_name: class_name,
				associated_resource_names: associated_resource_names,
				child_associated_resource_names: associated_resource[:associated_resources].map{|a| a[:associated_name]}
			})
			associated_resource[:associated_resources].each do |child_associated_resource|
				render_resource_files({
					base_dir: base_dir,
					class_name: class_name,
					parent_associated_resource_names: associated_resource_names,
					associated_resource: child_associated_resource,
					except_parent_show_columns: associated_resource[:except_show_columns]
				})
			end
		end
	end

end



module LinebotWebhook::Replies::ClinicLineKnowledgeCategoriesReply

	def reply_clinic_line_knowledge_categories
		reply_message({
			type: "carousel",
			text: "請選擇內容",
			columns: @clinic_line_knowledge_categories.map do |clinic_line_knowledge_category|
				r = {
					# image_url: doctor.photo.url,
					title: clinic_line_knowledge_category.name,
					text: clinic_line_knowledge_category.name,
					name: clinic_line_knowledge_category.name,
					actions: clinic_line_knowledge_category.knowledges.map do |knowledge|
						r = {
							type: "postback",
							label: knowledge.line_template.title,
							data: {
								controller: "clinic_line_knowledges",
								action: "show",
								id: knowledge.id
							}
						}
					end
				}
			end
		})				
	end

end




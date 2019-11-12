class Event::NotificationTemplate < ApplicationRecord
	init_categories = proc do
		puts "33"
	  enum category: self.category_contents.keys
	end

  def arg_content(options)
  	c = self.content
  	self.args.each do |key, name|
  		value = options[key.to_sym]
  		c = c.gsub("{#{key}}", value)
  	end
  	c
  end

  def args
  	self.class.category_contents[self.category][:args]
  end

	def self.category_contents
		{
			"回診推播" => {
				init_content: "您好，{patient_name}君，您已經可以進行例行的洗牙檢查囉～歡迎預約時間，並抽空檢查。{clinic_name}關心您～",
				args: {
					clinic_name: "診所名稱",
					patient_name: "病患名稱"
				}		
			},
			"回診修改掛號" => {
				init_content: "您好，您預約時間，在{new_clinic_time}有時間可以進行選擇，請問您是否要將時間移至{new_clinic_time}嗎？。{clinic_name}關心您~",
				args: {
					clinic_name: "診所名稱",
					new_clinic_time: "建議預約時間"
				}
			},
			"診所休假修改掛號" => {
				init_content: "您好，由於診所看診時段臨時變動，請您重新預約新的時段。造成不便，敬請見諒。謝謝。{clinic_name}關心您～",
				args: {
					clinic_name: "診所名稱"
				}
			},
			"醫生休假修改掛號" => {
				init_content: "您好，由於醫生{doctor_name}看診時段臨時變動，請您重新預約新的時段。造成不便，敬請見諒。謝謝。{clinic_name}關心您～",
				args: {
					doctor_name: "醫生名稱",
					clinic_name: "診所名稱"
				}
			}
		}
	end

	def self.init_content
		self.category_contents.map do |category, v|
			c = self.find_by(category: category)
			if c.nil?
				c = self.create!({
					category: category,
					content: v[:init_content]
				})
			end
			c
		end
	end

	init_categories.call
end

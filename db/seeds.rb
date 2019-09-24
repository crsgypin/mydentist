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
puts "sss: #{class_name}, #{filename}"
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

# proc do 
# 	m = Member.find_or_initialize_by(account: "admin")
# 	m.assign_attributes({password: "qwerty1234", level: 500})
# 	m.save!
# end.call


# #clinic
# proc do
# 	clinics = [
# 		{
# 			attributes: {
# 				friendly_id: "cfv",
# 				name: "宏麗牙醫", 
# 			  phone: "02-2555-3285",
# 			  address: "台北市中山區南京西路65號2樓",
# 			  description: "美麗自信笑容，盡在宏麗牙醫",
# 			  name_en: "cfv",
# 			  channel_secret: "",
# 			  channel_token: "",			
# 			},
# 		  association: {
# 				doctors: [
# 					{ 
# 						attributes: {
# 							friendly_id: "cfv_d1", 
# 							name: "吳明遠", 
# 							title: "院長", 
# 							pro: "全⼝口重建、咬合重建、植牙專科、美容牙科、數位全瓷美學重建、雷射治療、⿒齒顎矯正、牙周治療",
# 							experience: "台北醫學⼤大學牙醫學⼠士\n台灣⼤大學臨臨床牙醫研究所牙周病組碩⼠士\n台⼤大醫院牙科部牙周病牙科部主治醫師\n輔仁⼤大學附醫院牙科部主治醫師\n中華⺠民國⼝口腔植體學會會員醫師\n中華⺠民國植牙醫學會會員醫師\n台灣牙周病醫學會會員醫師\n中華⺠民國家庭牙醫學會專科醫師"
# 						},
# 					},
# 					{
# 						attributes: {
# 							friendly_id: "cfv_d2", 
# 							name: "張祿靈", 
# 							title: "副院長", 
# 							pro: "全⼝口重建、咬合重建、植牙專科、美容牙科、數位全瓷美學重建、雷射治療、⿒齒顎矯正、牙周治療",
# 							experience: "台北醫學⼤大學牙醫學⼠士\n台灣⼤大學臨臨床牙醫研究所牙周病組碩⼠士\n台⼤大醫院牙科部牙周病牙科部主治醫師\n輔仁⼤大學附醫院牙科部主治醫師\n中華⺠民國⼝口腔植體學會會員醫師\n中華⺠民國植牙醫學會會員醫師\n台灣牙周病醫學會會員醫師\n中華⺠民國家庭牙醫學會專科醫師"
# 						},
# 					},
# 					{
# 						attributes: {
# 							friendly_id: "cfv_d3", 
# 							name: "林桂格", 
# 							title: "主治醫⽣", 
# 							pro: "全⼝口重建、咬合重建、數位微笑設計、全瓷美學重建、陶瓷貼片、陶瓷嵌體",
# 							experience: "台北醫學⼤大學牙醫學⼠士\n台灣⼤大學臨臨床牙醫研究所牙周病組碩⼠士\n台⼤大醫院牙科部牙周病牙科部主治醫師\n輔仁⼤大學附醫院牙科部主治醫師\n中華⺠民國⼝口腔植體學會會員醫師\n中華⺠民國植牙醫學會會員醫師\n台灣牙周病醫學會會員醫師\n中華⺠民國家庭牙醫學會專科醫師"
# 						},
# 					},
# 					{
# 						attributes: {
# 							friendly_id: "cfv_d4", 
# 							name: "謝佳祐", 
# 							title: "主治醫⽣", 
# 							pro: "數位全瓷美學、美容牙科、微笑曲線設計、家庭牙科",
# 							experience: "台北醫學⼤大學牙醫學⼠士\n台灣⼤大學臨臨床牙醫研究所牙周病組碩⼠士\n台⼤大醫院牙科部牙周病牙科部主治醫師\n輔仁⼤大學附醫院牙科部主治醫師\n中華⺠民國⼝口腔植體學會會員醫師\n中華⺠民國植牙醫學會會員醫師\n台灣牙周病醫學會會員醫師\n中華⺠民國家庭牙醫學會專科醫師"
# 						},
# 					},
# 					{
# 						attributes: {
# 							friendly_id: "cfv_d5", 
# 							name: "方律昀", 
# 							title: "主治醫⽣", 
# 							pro: "活動假牙、數位全瓷美學、活動假牙、家庭牙科、兒童牙科、牙周治療",
# 							experience: "台北醫學⼤大學牙醫學⼠士\n台灣⼤大學臨臨床牙醫研究所牙周病組碩⼠士\n台⼤大醫院牙科部牙周病牙科部主治醫師\n輔仁⼤大學附醫院牙科部主治醫師\n中華⺠民國⼝口腔植體學會會員醫師\n中華⺠民國植牙醫學會會員醫師\n台灣牙周病醫學會會員醫師\n中華⺠民國家庭牙醫學會專科醫師"
# 						},
# 					},
# 						{
# 						attributes: {
# 							friendly_id: "cfv_d6", 
# 							name: "林雅芬", 
# 							title: "主治醫⽣", 
# 							pro: "美容牙科、數位全瓷冠、植牙、牙周治療",
# 							experience: "台北醫學⼤大學牙醫學⼠士\n台灣⼤大學臨臨床牙醫研究所牙周病組碩⼠士\n台⼤大醫院牙科部牙周病牙科部主治醫師\n輔仁⼤大學附醫院牙科部主治醫師\n中華⺠民國⼝口腔植體學會會員醫師\n中華⺠民國植牙醫學會會員醫師\n台灣牙周病醫學會會員醫師\n中華⺠民國家庭牙醫學會專科醫師"
# 						},
# 					}
# 				],
# 				patients: [
# 					{friendly_id: "cfv_p1", name: "王大明", phone: "0912345678", birthday: "1984/2/1"
# 					},
# 					{friendly_id: "cfv_p2", name: "李小文", phone: "0914434678", birthday: "1988/12/1"
# 					},
# 					{friendly_id: "cfv_p3", name: "陳文安", phone: "0915534678", birthday: "1981/3/28"
# 					},
# 					{friendly_id: "cfv_p4", name: "Michael Jordan", phone: "0932534678", birthday: "1981/3/28"
# 					},
# 				],
# 				services: [
# 					{name: "檢查牙齒"
# 					},
# 					{name: "洗牙"
# 					},
# 					{name: "兒童牙齒"
# 					},
# 					{name: "牙齒矯正"
# 					},
# 					{name: "拔智齒"}
# 				],
# 				members:[
# 					{account: "cfvadmin", password: "12345678", username: "管理帳號", level: 200}
# 				]
# 			}
# 		}
# 	]
# 	clinics.each do |key, values|
# 			values.each do |value|
# 				k1 = value.first[0]
# 				a = clinic.send(key).find_or_initialize_by(k1 => value[k1])
# 				a.assign_attributes(value)
# 				a.save!
# 				puts "#{key}: #{a.inspect}"
# 			end
# 		end
# 	end
# end.call

rescue Exception => e
	puts e.record.errors.full_messages if e.try(:record).present?
	puts e.to_s
	puts e.backtrace.first(5)
end


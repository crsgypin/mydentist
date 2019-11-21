class LinebotWebhook::Controllers::PatientController < LinebotWebhook::Controllers::ApplicationController
	include LinebotWebhook::Replies::PatientReply

	def show
		@patient = @line_account.patient
		if !@patient.present? || !@patient.filled_in_web
			@line_account.update({
				dialog_status: "填寫個人資料",
				dialog_status_step: 1 
			})
			reply_to_fill_name
		else
			reply_to_check_patient
		end
	end

	def update
		@patient = @line_account.patient || @clinic.patients.new(line_account: @line_account)
		if (1..3).include?(@line_account.dialog_status_step)
			update_for_new_patient
		elsif (11..13).include?(@line_account.dialog_status_step)
			update_for_modify_patient
		end
	end

	def update_note
		if @message[:data][:type] == "name"
			@line_account.update(dialog_status: "填寫個人資料", dialog_status_step: 11)
			reply_to_fill_name
		elsif @message[:data][:type] == "birthday"
			@line_account.update(dialog_status: "填寫個人資料", dialog_status_step: 12)
			reply_to_fill_birthday
		elsif @message[:data][:type] == "phone"
			@line_account.update(dialog_status: "填寫個人資料", dialog_status_step: 13)
			reply_to_fill_phone
		end
	end

	private

	def update_for_new_patient
		if @line_account.dialog_status_step == 1
			if !fill_name
				return reply_invalid_name_format
			end
			@line_account.update(dialog_status_step: 2)
			reply_to_fill_birthday
		elsif @line_account.dialog_status_step == 2
			if !fill_birthday
				return reply_invalid_birthday_format
			end
			@line_account.update(dialog_status_step: 3)
			reply_to_fill_phone
		elsif @line_account.dialog_status_step == 3
			if !fill_phone
				return reply_invalid_phone_format
			end
			@line_account.update(dialog_status: nil, dialog_status_step: nil)

			@event = @line_account.events.where(status: "缺少病患資料").last
			if @event.present?
				@event.update(status: "已預約", patient: @line_account.patient)
				reply_finished_with_event
			else
				reply_finished
			end
		end
	end

	def update_for_modify_patient
		#for update
		if @line_account.dialog_status_step == 11
			if !fill_name
				return reply_invalid_name_format
			end
		elsif @line_account.dialog_status_step == 12
			if !fill_birthday
				return reply_invalid_birthday_format
			end
		elsif @line_account.dialog_status_step == 13
			if !fill_phone
				return reply_invalid_phone_format
			end
		end
		@line_account.update(dialog_status: nil, dialog_status_step: nil)
		reply_to_check_patient
	end

	def fill_name
		#name
		name = @message[:text]
		if name.length < 2
			return false
		end
		@patient.name = name
		@patient.save
	end

	def fill_birthday
		date = Date.parse(@message[:text]) rescue nil
		if date.nil?
			return false
		end
		@patient.birthday = date
		@patient.save
	end

	def fill_phone
		phone = @message[:text].to_s
		phone = phone.gsub("-", "")
		if phone.scan(/[^0-9]).length > 0
			return false
		end
		if phone[0..1] == "09" && phone.length != 10
			return false
		end
		@patient.phone = phone
		@patient.save
	end

end


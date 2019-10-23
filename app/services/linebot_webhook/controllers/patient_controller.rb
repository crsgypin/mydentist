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
			#for create
			if @line_account.dialog_status_step == 1
				fill_name
				@line_account.update(dialog_status_step: 2)
				reply_to_fill_birthday
			elsif @line_account.dialog_status_step == 2
				fill_birthday
				@line_account.update(dialog_status_step: 3)
				reply_to_fill_phone
			elsif @line_account.dialog_status_step == 3
				fill_phone
				@line_account.update(dialog_status: nil, dialog_status_step: nil)
				reply_finished
			end
		elsif (11..13).include?(@line_account.dialog_status_step)
			#for update
			if @line_account.dialog_status_step == 11
				fill_name
			elsif @line_account.dialog_status_step == 12
				fill_birthday
			elsif @line_account.dialog_status_step == 13
				fill_phone
			end
			@line_account.update(dialog_status: nil, dialog_status_step: nil)
			reply_to_check_patient
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

	def fill_name
		#name
		name = @message[:text]
		if name.length < 2
			return reply_invalid_name_format
		end
		@patient.name = name
		@patient.save
	end

	def fill_birthday
		date = Date.parse(@message[:text]) rescue nil
		if !date.present?
			return reply_invalid_birthday_format
		end
		@patient.birthday = date
		@patient.save
	end

	def fill_phone
		phone = @message[:text].to_s
		if phone.length < 6
			return reply_invalid_phone_format
		end
		@patient.phone = phone
		@patient.save
	end

end


module ClinicNotificationConcern
	include Common::DateHelper

	def on_line_account_add_patient(line_account)
  	t = Time.now
  	n = line_account.clinic.clinic_notifications.create({
  		category: "已綁定", 
  		patient: line_account.patient,
  		args_json: {
  			date: roc_format(t, 5)
  		}
  	})  		
	end

	def on_change_event_notification(event_notification)
    clinic = event_notification.notification_template.clinic
    event = event_notification.event
    if event_notification.status == "同意"
      n = clinic.clinic_notifications.create({
        category: "回覆同意", 
        patient: event.patient,
        args_json: {
          doctor_name: event.doctor.name,
          date: roc_format(event.date_time , 5),
          service_name: event.service.name
        }
      })
    elsif event_notification.status == "取消"
      n = clinic.clinic_notifications.create({
        category: "回覆取消",
        patient: event.patient,
        args_json: {
          date: roc_format(Time.now, 5)
        }
      })
    end
  end

end

module EventNotificationScheduleConcern
	#for 排成

	def create_broadcast_event
    self.event = Event.create!({
      clinic: self.clinic,
      status: "推播中",
      doctor_id: self.doctor_id,
      date: self.date,
      hour: self.hour,
      minute: self.minute,
      duration: self.duration,
      service_id: self.service_id || self.clinic.services.first.id
    })		
	end

  #以下為『排成發送』的方法
  def check_schedule_messages
  	#called by schedule
    if self.schedule_type != "排程發送"
      return
    end
    if self.status == "已取消" || self.status == "推播逾期"
      return
    end
    if self.expired?
      self.update(status: "推播逾期")
      return
    end
    if self.occupied?
    	self.update(status: "已佔滿")
    	return
    end
 		self.clinic.patients.includes(:current_event_notification, :line_account).select do |patient|
			patient.line_account.present? && !patient.current_event_notification.present?
		end.each do |patient|
			n = self.notifications.find_or_initialize_by({
				notification_template: self.notification_template,
				patient: patient
      })
      n.assign_attributes({
        doctor_id: self.doctor_id,
        service_id: self.service_id,
        hour: self.hour,
        minute: self.minute,
        duration: self.duration,
				args_json: {
					clinic_name: self.clinic.name,
 					patient_name: patient.name
				}
 			})
      n.save
		end
    self.update(status: "發送中")
    self.notifications.where(status: "尚未發送").each do |notification|
      notification.send_message
    end
  end	

	def start_date_time
		if self.schedule_type != "排程發送"
			return nil
		end
		self.date + self.hour.hour + self.minute.minute
	end

	def end_date_time
		if self.schedule_type != "排程發送"
			return nil
		end
		self.start_date_time + self.duration.minute
	end

  def expired?
		if self.schedule_type != "排程發送"
			return nil
		end
  	Time.now >= self.end_date_time
  end

  def occupied?
    if self.schedule_type != "排程發送"
      return nil
    end
    occupied = true
    hour = self.hour
    minute = self.minute
    events = self.doctor.events.where(date: self.date).select{|e| e.is_valid_in_line?}
    (self.duration / Clinic.default_duration).times do |time|
      duration = time * Clinic.default_duration
      time = self.date + self.hour.hour + self.minute.minute + duration.minute
      e = events.find{|e| e.in_range?(time)}
      if !e.present?
        occupied = false
        break
      end
    end
    occupied
  end

end


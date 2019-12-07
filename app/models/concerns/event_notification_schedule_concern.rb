module EventNotificationScheduleConcern
  #以下方法，都是針對 schedule_type = 排程發送 的情況
  extend ActiveSupport::Concern
  included do
    attr_accessor :trigger_schedule
    after_save :check_trigger_schedule
  end

  def check_trigger_schedule
    if self.trigger_schedule.present?
      self.trigger_schedule = nil
      self.check_and_send_schedule_messages
    end
  end

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

  def notifications_count_per_duration
    #30
    # count = duration / Clinic.default_duration
    # 1 * count
    1
  end

  def notifications_schedule_time
    #unit: minute
    #15
    2
  end

  def get_expected_pushed_count
    #計算應推播的人次數
    time_count = ((Time.now - self.created_at) / (self.notifications_schedule_time * 60)).to_i
    expected_pushed_count = time_count * self.notifications_count_per_duration
  end

  def get_valid_pushed_count
    #計算可推播的人次數 = 應推播的人次數 - 推播的人次數
    if self.expired? || self.schedule_type != "排程發送"
      return 0
    end
    expected_pushed_count = get_expected_pushed_count
    pushed_count = self.notifications.where(status: "尚未回覆").count
    expected_pushed_count - pushed_count    
  end

  #以下為『排成發送』的方法
  def check_and_send_schedule_messages
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
    self.update(status: "推播中")
 		valid_patients = self.clinic.patients.includes(:current_event_notification, :line_account).select do |patient|
      #取沒有現在回診推播的病患
			patient.line_account.present? && !patient.current_event_notification.present?
		end
    valid_count = self.get_valid_pushed_count
    valid_patients.sample(valid_count).each do |patient|
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
    r = {pass: 0, fail: 0}
    self.notifications.where(status: "尚未發送").each do |notification|
      s = notification.send_message
      if s
        r[:pass] += 1
      else
        r[:fail] += 1
      end
    end
    r
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


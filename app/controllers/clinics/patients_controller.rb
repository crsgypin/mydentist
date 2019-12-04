class ::Clinics::PatientsController < ::Clinics::ApplicationController
  before_action -> {
    access_config({
      variable_name: "patient",
      new_resource: proc { @clinic.patients.new},
      find_resource: proc { @clinic.patients.find(params[:id])},
      # resource_params: proc { params.require(:patient).permit(:name, :gender, :person_id, :default_doctor_id, :health_insurance_status, :roc_year, :month, :day, :phone, :phone2, :address, :note)}
    })
  }

  def index
    @category = params[:category].present? ? params[:category] : "all"
    if @category == "all"
      @patients = @clinic.patients
    elsif @category == "notification"
      @patients = @clinic.clinic_notification_patients
    else
      raise "invalid category"
    end

    @patients = @patients.includes(:line_account, :clinic_patient_notification, :default_doctor, :current_event, :last_tooth_cleaning_event, :current_event_notification => [:notification_template])
    if params[:key].present?
      @patients = @patients.where("name like ?", "%#{params[:key]}%")
    end
    @has_patient_notification = params[:has_patient_notification]
    if @has_patient_notification.present?
      if @has_patient_notification == '1'
        ids = @patients.joins(:clinic_patient_notification).pluck(:id).uniq
        @patients = @patients.where(id: ids)
      else
        ids = @patients.joins(:clinic_patient_notification).pluck(:id)
        @patients = @patients.where.not(id: ids)
      end
    end
    @event_notification_status = params[:event_notification_status]
    if @event_notification_status.present?
      if @event_notification_status == '1'
        ids = @patients.joins(:current_event_notification).where("event_notifications.status = ?", Event::Notification.statuses["尚未回覆"])
        @patients = @patients.where(id: ids)
      elsif @event_notification_status == '2'
        ids = @patients.joins(:current_event_notification).where("event_notifications.status = ?", Event::Notification.statuses["同意"])
        @patients = @patients.where(id: ids)
      elsif @event_notification_status == '3'
        ids = @patients.joins(:current_event_notification).where("event_notifications.status = ?", Event::Notification.statuses["取消"])
        @patients = @patients.where(id: ids)
      end
    end
    @patients = @patients.page(params[:page]).per(10)
  end

  def create
    @patient = @clinic.patients.new(patient_params)
    @patient.source = "現場"
    !@patient.save
  end

  def update
    @patient = @clinic.patients.find(params[:id])
    @patient.tmp_source = "現場"
    !@patient.update(patient_params)
  end

  private

  def patient_params
    params.require(:patient).permit(:name, :gender, :person_id, :default_doctor_id, :health_insurance_status, :roc_year, :month, :day, :phone, :phone2, :address, :note)
  end

end

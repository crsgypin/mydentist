class ::Clinics::Patients::NotificationController < ::Clinics::Patients::ApplicationController

	def create
		@clinic_patient_notification = @patient.build_clinic_patient_notification(category: "回診推播", clinic: @clinic)
		if !@clinic_patient_notification.save
			return js_render_model_error @clinic_patient_notification
		end
	end

	def destroy
		@clinic_patient_notification = @patient.clinic_patient_notification
		if !@clinic_patient_notification.destroy
			return js_render_model_error @clinic_patient_notification
		end
		@patient.reload
	end

end

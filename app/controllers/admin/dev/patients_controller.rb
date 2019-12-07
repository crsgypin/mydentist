class Admin::Dev::PatientsController < Admin::Dev::ApplicationController
  before_action -> {@embedded = 1}, only: [:show]
  before_action -> {
    access_config({
      variable_name: "patient",
      new_resource: proc { ::Patient.new},
      find_resource: proc { ::Patient.find(params[:id])},
      resource_params: proc { params.require(:patient).permit(Patient.accessable_atts)}
    })
  }

  def index
    @patients = ::Patient.all
    if params[:name].present?
      @patiens = @patients.where("name like ?", "%#{params[:name]}%")
    end
    if params[:has_line_account].present?
      if params[:has_line_account] == '0'
        ids = @patients.joins(:line_account).pluck(:id)
        @patients = @patients.where.not(id: ids)
      elsif params[:has_line_account] == '1'
        ids = @patients.joins(:line_account).pluck(:id)
        @patients = @patients.where(id: ids)
      end
    end
    @patients = @patients.page(params[:page]).per(20)
  end

end

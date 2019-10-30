class ::Clinics::MembersController < ::Clinics::ApplicationController
  before_action -> {
    access_config({
      variable_name: "member",
      new_resource: proc { @clinic.members.new},
      find_resource: proc { @clinic.members.find(params[:id])},
      resource_params: proc { params.require(:member).permit(@member.class.accessable_atts)}
    })
  }

  def index
    @members = @clinic.members
    if params[:key].present?
      @members = @members.where("name like ?", "%#{params[:key]}%")
    end
    @members = @members.page(params[:page]).per(20)
  end

end

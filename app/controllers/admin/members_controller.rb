class Admin::MembersController < Admin::ApplicationController
  before_action -> {
    access_config({
      variable_name: "member",
      new_resource: proc { ::Member.new},
      find_resource: proc { ::Member.find(params[:id])},
      resource_params: proc { params.require(:member).permit(Member.accessable_atts)}
    })
  }

  def index
    @members = ::Member.all
    @members = @members.page(params[:page]).per(20)
  end

end

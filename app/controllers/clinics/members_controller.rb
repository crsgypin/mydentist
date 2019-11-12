class ::Clinics::MembersController < ::Clinics::ApplicationController

  def index
    @members = @clinic.members
    if params[:key].present?
      @members = @members.where("name like ?", "%#{params[:key]}%")
    end
    @members = @members.page(params[:page]).per(20)
  end

  def create
    @member = @clinic.members.new(member_params)
    if !@member.save
      return js_render_model_error(@member)
    end
  end

  def update
    @member = @clinic.members.find(params[:id])
    if @member.update(member_params)
      return js_render_model_error(@member)      
    end
  end

  private

  def member_params
    params.require(:member).permit(:level, :username, :email, :password)
  end

end

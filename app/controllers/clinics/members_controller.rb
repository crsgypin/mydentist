class ::Clinics::MembersController < ::Clinics::ApplicationController
  before_action -> {@member_sidemenu = 1 }, only: [:show, :edit, :new]

  def index
    @members = @clinic.members
    if params[:key].present?
      @members = @members.where("name like ?", "%#{params[:key]}%")
    end
    @members = @members.page(params[:page]).per(20)
  end

  def show
    @member = @clinic.members.find(params[:id])

  end

  def new
    @member = @clinic.members.new
  end

  def edit
    @member = @clinic.members.find(params[:id])

  end

  def create
    @member = @clinic.members.new(member_params)
    if !@member.save
      return js_render_model_error(@member)
    end
  end

  def update
    @member = @clinic.members.find(params[:id])

    if params[:target] == "username"
      #do nothing
    elsif params[:target] == "password"
      if !@member.valid_password? params[:ori_password]
        return js_render_error "錯誤密碼"
      end      
    end
    if !@member.update(member_params)
      return js_render_model_error(@member)      
    end
    if params[:target] == "password"
      sign_out :member
      sign_in :member, @member
    end
  end

  def destroy
    @member = @clinic.members.find(params[:id])
    if !@member.destroy
      return js_render_model_error @member
    end
  end

  private

  def member_params
    params.require(:member).permit(:level, :username, :email, :password, :password_confirmation)
  end

end

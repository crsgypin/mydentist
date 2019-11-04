class Admin::Dev::LineAccounts::LineSendingsController < Admin::Dev::LineAccounts::ApplicationController
  before_action -> {
    access_config({
      variable_name: "line_sending",
      find_resource: proc { @line_sending = @line_account.sendings.find(params[:id])},
      resource_params: proc { params.require(:line_sending).permit(@line_sending.class.accessable_atts)}
    })
  }

  def index
  	@line_sendings = @line_account.sendings
  	@line_sendings = @line_sendings.order(id: :desc)
  	@line_sendings = @line_sendings.page(params[:page]).per(20)
  end

end

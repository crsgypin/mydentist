class Admin::Dev::LineAccountsController < Admin::Dev::ApplicationController
  before_action -> {@embedded = 1}, only: [:show]
  before_action -> {
    access_config({
      variable_name: "line_account",
      new_resource: proc { ::Line::Account.new},
      find_resource: proc { ::Line::Account.find(params[:id])},
      resource_params: proc { params.require(:line_account).permit(Line::Account.accessable_atts)}
    })
  }

  def index
    @line_accounts = ::Line::Account.all
    @line_accounts = @line_accounts.page(params[:page]).per(20)
  end

end

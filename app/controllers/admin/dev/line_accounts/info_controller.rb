class Admin::Dev::LineAccounts::InfoController < Admin::Dev::LineAccounts::ApplicationController
	before_action -> {@embedded = 1}
  before_action -> {
    access_config({
      variable_name: "line_account",
      find_resource: proc { @line_account},
      resource_params: proc { params.require(:line_account).permit(@line_account.class.accessable_atts)}
    })
  }


end

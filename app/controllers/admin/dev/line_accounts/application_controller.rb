class Admin::Dev::LineAccounts::ApplicationController < Admin::Dev::ApplicationController
  before_action {@embedded = 1}
  before_action :set_line_account

  def set_line_account
    @line_account = Line::Account.find(params[:line_account_id])
  end
end

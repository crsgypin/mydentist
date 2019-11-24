# frozen_string_literal: true

class Accounts::PasswordsController < Devise::PasswordsController
  layout 'accounts'
  # GET /resource/password/new
  def new
    super
  end

  # POST /resource/password
  def create
    # super
    @member = Member.find_by(email: params[:member][:email])
    if !@member.present?
      @result = 1
      return
    end
    if @member.level_number <= 100
      @result = 2
      return
    end
    @result = 3
  end

  # GET /resource/password/edit?reset_password_token=abcdef
  # def edit
  #   super
  # end

  # PUT /resource/password
  # def update
  #   super
  # end

  # protected

  # def after_resetting_password_path_for(resource)
  #   super(resource)
  # end

  # The path used after sending reset password instructions
  # def after_sending_reset_password_instructions_path_for(resource_name)
  #   super(resource_name)
  # end
end

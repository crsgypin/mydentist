class Admin::ApplicationController < ApplicationController
  layout 'admin_digggest'

  include JsCrudConcern


end
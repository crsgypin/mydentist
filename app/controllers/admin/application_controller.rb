class Admin::ApplicationController < ApplicationController
  layout 'admin'

  include JsCrudConcern


end
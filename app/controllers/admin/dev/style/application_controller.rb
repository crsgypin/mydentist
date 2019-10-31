class Admin::Dev::Style::ApplicationController < Admin::Dev::ApplicationController
  before_action -> {@embedded = 1}, only: [:show]


end


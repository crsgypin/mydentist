module JsCrudConcern

	def access_config(option)
    @variable_name = option[:variable_name]
    @find_resource = option[:find_resource]
    @new_resource = option[:new_resource]
    @resource_params = option[:resource_params]
  end

  def show
    eval("@#{@variable_name}=@find_resource.call")
  end

  def new
    eval("@#{@variable_name}=@new_resource.call")
  end

  def edit
    eval("@#{@variable_name}=@find_resource.call")
  end

  def create
    eval("@#{@variable_name}=@new_resource.call")
    begin
      path = url_for(action: :index)
    rescue
      path = ""
    end
    js_handle_resource(eval("@#{@variable_name}"), @resource_params.call, url_for(action: :index))
  end

  def update
    eval("@#{@variable_name}=@find_resource.call")
    js_handle_resource(eval("@#{@variable_name}"), @resource_params.call, url_for(action: :show))
  end

  def destroy
    eval("@#{@variable_name}=@find_resource.call")
    begin
      path = url_for(action: :index)
    rescue
      path = ""
    end
    js_handle_resource(eval("@#{@variable_name}"), path)
  end


end


module JsConcern

  def js_render_model_error(resource)
    message = resource.errors.full_messages.join(",")
    js_render_error(message)
  end

  def render_error(message)
    render :json => {result: 0, message: message}
  end

  def js_render_message(message)
    render :js => "alert(\"#{message.gsub('\"',"'")}\")"
  end

  def js_render_error(message)
  	render :js => "alert(\"錯誤:#{message}\")"
  end

  def js_redirect_to(path, option={})
    if option[:message].present?
      render :js => "alert(\"#{option[:message]}\");window.location.href=\"#{path}\";"
    else
      render :js => "window.location.href=\"#{path}\""
    end
  end

  def js_handle_event(event_name)
    render js: "$.callEvt('#{event_name}')"
  end

  def js_handle_resource(resource, v1, v2=nil, &block)
    if params[:action] == "create"
      parameters = v1
      pass_path = v2
      resource.assign_attributes(parameters)
      if !resource.save
        return js_render_model_error(resource)
      end
      if params[:complete_event].present?
        js_handle_event(params[:complete_event])
      else
        js_redirect_to pass_path, {message: "新增成功"}
      end

    elsif params[:action] == "update"
      parameters = v1
      pass_path = v2
      # if parameters.present?
      #   resource.assign_attributes(parameters)
      # end
      if !resource.update(parameters)
        return js_render_model_error(resource)
      end
      if params[:complete_event].present?
        js_handle_event(params[:complete_event])
      else
        js_redirect_to pass_path, {message: "更新成功"}
      end

    elsif params[:action] == "destroy"
      pass_path = v1
      if !resource.destroy
        return js_render_model_error(resource)
      end
      if params[:complete_event].present?
        js_handle_event(params[:complete_event])
      else
        js_redirect_to pass_path, {message: "移除成功"}
      end

    end
  end

end

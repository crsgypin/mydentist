$.fn.extend(function(){
	var evtHandlers = {};
	var containerName = "body";

	$.evton = function(){
		if(arguments[1] === undefined){
			//multiple events
			var object = arguments[0];
			Object.keys(object).forEach(function(eventName){
				var handler = object[eventName];
				var eventName = eventName.toLowerCase(); //save event_name by lower case
				if(!evtHandlers[eventName]){evtHandlers[eventName]=[]};
				evtHandlers[eventName].push(handler);
			});
		} else {
			//single event
			var eventName = arguments[0].toLowerCase();
			var handler = arguments[1];
			if(!evtHandlers[eventName]){evtHandlers[eventName]=[]};
			evtHandlers[eventName].push(handler);
		}
	}
	$.callEvt = function(eventName, params){
		var eventName = eventName.toLowerCase();

		//merge params
		var event = window.event || {};
		var params = params	|| {};
		Object.keys(params).forEach(function(key){
			event[key] = params[key];
		});

		var target = $(params.target || containerName);

		//check callback name
		if(params.handler){
			var handlerNames = params.handlerName.split(" ");
			handlerNames.forEach(function(handlerName){
				var elm = target.find("[evt-"+eventName+"\\." + handlerName + "]");
				if(elm.length > 0){
					var action = elm.attr("evt-" + eventName + "." + handlerName);
					event[handlerName] = function(callbackParams){
						//merge callbackParams
						var event = window.event || {};
						var callbackParams = callbackParams	|| {};
						Object.keys(callbackParams).forEach(function(key){
							event[key] = callbackParams[key];
						});
						!function(){
							eval(action);
							event[handlerName] = null; //make sure not call twice
						}.bind(elm[0])();
					}
				}
			});
		}

		//trigger event
		if(target.attr("evt-" + eventName)){
			var evtDoms = target.find("[evt-" + eventName + "]").addBack();
		} else {
			var evtDoms = target.find("[evt-" + eventName + "]");
		}
		if(evtDoms.length==0&&!evtHandlers[eventName]){console.error('no event receive: ' + eventName);return}
		if(evtHandlers[eventName]){
			evtHandlers[eventName].forEach(function(cb){
				cb(event);
			});
		};
		if(evtDoms.length>0){
			evtDoms.each(function(i, elm){
				var action = $(elm).evt(eventName);
				!function(){
					eval(action);
				}.bind(elm)();
				// try{
				// }catch(e){
				// 	console.error("execute evt- fail: ", elm);
				// 	throw e;
				// }
			});
		};
	};

	//auto init
	$(document).ready(function(){
		$(containerName).callEvt("onInit")
	});

	return {
		evt: function(){
			var _this = this;
			var keyword = "evt-";
			if(arguments[0] === undefined){
				//get all events
				var result = {};
				var atts = _this[0].attributes;
				for(var i=0;i<atts.length;i++){
					var att = atts[i];
					var name = att.name;
					var value = att.value;
					if(name.indexOf(keyword) == 0){
						var eventName = name.substring(keyword.length, name.length);
						result[eventName] = value;
					}
				}
				return result;
			} else if(arguments[1] === undefined){
				//get value
				var eventName = arguments[0];
				return _this.evt()[eventName];
			} else {
				//set value
				var eventName = arguments[0];
				var action = arguments[1];
				var isInit = arguments[2];
				(!isInit)&&_this.attr(keyword + eventName, action);
			}
		},
		callEvt: function(eventName, params){
			var eventName = eventName.toLowerCase();
			var params = params || {};
			params.target = this[0];
			//call the event
			$.callEvt(eventName, params);
		},
		removeEvt: function(eventName){
			var _this = this;
			_this.removeAttr("evt-" + eventName);
		},
		clickOnce: function(callback){
			if('function' != typeof callback){
				console.error('argument is not a function');
				return;
			}
			var id = "t"+(new Date).getTime();
			$(this).on("click."+id, function(e){
				callback(e);
				$("body").off("click."+id);
			})
		},
		loadFrame: function(){
			var _this = this;
			var url = $(this).data('url');
			var method = $(this).data('method') || 'get';
			var data = $(this).data('data') || {};
			var onLoad = $(this).attr('onload');
			$.ajax({
				url: url,
				method: method,
				data: data,
				success: function(template){
					if(template.indexOf("<body>") > -1){
						var content = template.split("<body>")[1].split("</body>")[0];
						$(_this).html(content);
					} else {
						$(_this).html(template);
					}
					if(onLoad){
						!function(){
							eval(onLoad)
						}.bind(_this)();
					}
				}
			})
		}		
	}
}());

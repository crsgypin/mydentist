
var OkCancelLightbox = function(){
  var comp, callback, backgroundClickable;
  var initView = function(){
    callback = {
      ok: function(){},
      cancel: function(){}
    };
  };
  var setEvent = function(){
    comp.click(function(e){
      if( $(e.target).is('.lightbox')){
        backgroundClickable&&action.hide();
      }
    });
    comp.find('.cancel_btn').click(function(e){
      e.preventDefault();
      callback['cancel']();
      action.hide();
    });
    comp.find('.ok_btn').click(function(e){
      e.preventDefault();
      callback['ok']();
      action.hide();
    });
  };
  var action = {
    getView: function(){
      var layout = '<div id="ok_cancel_lightbox" class="lightbox" style="display: hidden;">'
          layout += '  <div class="inbox">'
          layout += '    <div class="content_box highlight">'
          layout += '      <p class="content"></p>'
          layout += '    </div>'
          layout += '    <div class="buttons_box alignC mt2 mb6">'
          layout += '      <a class="cancel_btn btnW" href="">取消</a>'
          layout += '      <a class="ok_btn btnBu" href="">確認</a></div>'
          layout += '    </div>'
          layout += '  </div>'
          layout += '</div>'
      $('body').append(layout);
      comp = $('#ok_cancel_lightbox');
      setEvent();
    },
    show: function(hash){
      (!$('#ok_cancel_lightbox').length)&&action.getView();
      var option = {
        content: hash.content,
        ok: hash.ok||function(){},
        cancel: hash.cancel||function(){},
        backgroundClickable: hash.backgroundClickable || 0
      }
      backgroundClick = option.backgroundClick;
      comp.find('.content').html(option.content);
      callback['ok'] = option.ok || function(){};
      callback['cancel'] = option.cancel || function(){};
    },
    hide: function(callback){
      comp.fadeOut(400, function(){
        (typeof callback == "function")&& callback();
      });
    }
  };
  initView();
  return {
    show: action.show,
    hide: action.hide
  }
}();



var OKLightbox = function(){
  var callback = function(){};
  var container;
  var handlers = {
    onInit: null
  }
  var controller = function(){
    handlers.onInit = function(){
      container.find("#ok_lightbox_ok").click(function(e){
        e.preventDefault();
        action.hide();
      });
    }
  }
  var action = {
    getView: function(){
      var layout = '<div id="ok_lightbox" class="lightbox" style="display: hidden">'
          layout += '  <div class="inbox">'
          layout += '    <div class="content_box highlight">'
          layout += '      <p class="content"></p>'
          layout += '    </div>'
          layout += '    <div class="buttons_box alignC mt2 mb6">'
          layout += '      <a id="ok_lightbox_ok" class="btnBu" href="#ok_lightbox_ok">OK</a>'
          layout += '    </div>'
          layout += '  </div>'
          layout += '</div>'
      $('body').append(layout);
      container = $('#ok_lightbox');
      handlers.onInit();
    },
    show: function(content,cb){
      (!$("#ok_lightbox").length)&&action.getView();
      container.find('.content').html(content);
      container.fadeIn(400);
      callback = cb;
    },
    hide: function(){
      container&&container.fadeOut(400);
      (typeof callback == "function")&& callback();
    }
  };
  controller();
  return {
    show: action.show,
    hide: action.hide
  }
}();

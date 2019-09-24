var LoadingLightbox = function(params){
  var container, viewInited = 0;
  var controller = function(){

  }
  var action = {
    show: function(note){
      if(viewInited == 0){
        action.initView();
      }
      container.find('.note').text(note);
      container.addClass('select');
      container.css('display', 'block');
    },
    hide: function(){
      container.fadeOut(1000, function() {
        container.removeClass('select');
      })
      // setTimeout(function(){
      //   container.removeClass('select');
      // },2000);
    },
    initView: function(){
      var elm = "";
      elm += '<div id="loading_lightbox" class="lightbox">'
      elm += '  <div class="loading_circle loading_center">'
      elm += '    <div class="single_block"></div>'
      elm += '    <div class="note mt2 colorW"></div>'
      elm += '  </div>'
      elm += '</div>'
      $('body').append(elm);
      container = $('#loading_lightbox');
      viewInited = 1;
    }
  }
  controller();
  return {
    show: action.show,
    hide: action.hide
  }
}()

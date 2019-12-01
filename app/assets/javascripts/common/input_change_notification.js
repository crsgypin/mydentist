
window.listenerInputChangeNotification = function(args){
  //change to alert to save
  var woSave = false;
  args.inputs.on("change", function(){
    if(!woSave){
      woSave = true;
    }
  });
  args.leaveLinks.on("click", function(e){
    if(woSave && !$(this).attr("data-remote")){
      e.preventDefault();
      var r = confirm("您尚未儲存, 是否離開?");
      if(r){
        window.location.href = $(this).attr("href");
      }        
    }
  });
	args.saveBtn.click(function(){
    woSave = false;
  });	
}

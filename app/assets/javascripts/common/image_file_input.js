
function showFileImage(fileInput, targetImageElm, isBg){
	var file = fileInput.files[0];
	var url = URL.createObjectURL(file);
	if(!isBg){
		targetImageElm.attr('src', url);
	} else {
		console.log("url(" + url + ")");
		targetImageElm.css("background-image", "url('" + url + "')")
	}
}

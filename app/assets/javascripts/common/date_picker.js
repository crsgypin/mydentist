$(function(){
	$.datepicker.regional[ "zh-TW" ] = {
		closeText: "關閉",
		prevText: "&#x3C;上個月",
		nextText: "下個月&#x3E;",
		currentText: "今天",
		monthNames: [ "1月","2月","3月","4月","5月","6月",
			"7月","8月","9月","10月","11月","12月" ],
		monthNamesShort: [ "1月","2月","3月","4月","5月","6月",
			"7月","8月","9月","10月","11月","12月" ],
		dayNames: [ "星期日","星期一","星期二","星期三","星期四","星期五","星期六" ],
		dayNamesShort: [ "週日","週一","週二","週三","週四","週五","週六" ],
		dayNamesMin: [ "日","一","二","三","四","五","六" ],
		weekHeader: "週",
		dateFormat: "yy/mm/dd",
		firstDay: 1,
		isRTL: false,
		showMonthAfterYear: true,
		yearSuffix: "年" 
	};
	$.datepicker.setDefaults( $.datepicker.regional[ "zh-TW" ] );

	var box, input;
	$("input.date_picker").datepicker({
		beforeShow: function(a,b){
			input = a;
			box = b.dpDiv;
			$(box).css("font-size", "12px");
			changeToRocYear();
		},
		onChangeMonthYear: function(year,month){
			changeToRocYear();
		},
		// onSelect: function(date){
		// 	var rocDate = date.split("-").map(function(a,i){
		// 		if(i==0){
		// 			return a - 1911;
		// 		} else {
		// 			return a;
		// 		}
		// 	}).join("-");
		// 	$(input).val(rocDate);
		// },
		dateFormat: "yy-mm-dd",
		changeMonth: true,
		changeYear: true,
		yearRange: "1950:2070"
	});

	function changeToRocYear(){
		setTimeout(function(){
			console.log('convert');
			$(box).find(".ui-datepicker-year option").each(function(i,o){
				var year = $(o).attr('value');
				var rocYear = year - 1911;
				$(o).text(rocYear);
			});			
		}, 10);
	}

});


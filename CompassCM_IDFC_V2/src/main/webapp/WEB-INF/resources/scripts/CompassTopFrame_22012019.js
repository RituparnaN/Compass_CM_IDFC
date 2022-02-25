var compassTopFrame = compassTopFrame || (function(){
	var _dateFormat;
		
	return {
		getDate : function(date, type, amount){
			var l_dateSysDate = new Date(date);
			if(type == "Y"){
				l_dateSysDate.setDate(l_dateSysDate.getFullYear() - amount);
		    };
		    if(type == "M"){
		    	l_dateSysDate.setDate(l_dateSysDate.getMonth() +1 - amount);
		    };
		    if(type == "D"){
		    	l_dateSysDate.setDate(l_dateSysDate.getDate() - amount);
		    };
		    
		    var l_strYear = l_dateSysDate.getFullYear();
	        var	l_strMonth = l_dateSysDate.getMonth()+1;

			if(l_strMonth.toString().length == 1){
				l_strMonth = "0"+l_strMonth;
			}

	        var	l_strDay = l_dateSysDate.getDate();

			if(l_strDay.toString().length == 1){
				l_strDay = "0"+l_strDay;
			}
	        var fullDate = l_strDay+"/"+l_strMonth+"/"+l_strYear;
			return fullDate;
		},
		fromDate : function(compassDateFormat){
			var date = new Date();
			return compassTopFrame.getDate(date,"D","15");
		},
		toDate : function(compassDateFormat){
			return $.datepicker.formatDate(compassDateFormat, new Date());
		},
		init : function(unqId, searchTable, compassDateFormat){
			_dateFormat = compassDateFormat;
			
			$("table."+searchTable+" > tbody> tr> td> select").select2();
			
			$(".datepicker").datepicker({
				changeMonth: true,
				changeYear: true,
				dateFormat: _dateFormat
			});
			
			$(".datepickerText").datepicker({
				changeMonth: true,
				changeYear: true,
				dateFormat: _dateFormat,
				constrainInput : false
			});
			
			// alert($("table."+searchTable).find("input[id^='FROMDATE']").val());
			$("table."+searchTable).find("input[id^='FROMDATE']").val(compassTopFrame.fromDate(compassDateFormat));
			$("table."+searchTable).find("input[id^='TODATE']").val(compassTopFrame.toDate(compassDateFormat));
			
			$("table."+searchTable).find("input[id^='FROMDATE']").blur(function(){
				var enteredDate = $(this).val();
				var dateArr = enteredDate.split("/");
				var arrLen = enteredDate.split("/").length;
				if(arrLen == 3){
					if((dateArr[2].length == 4) && (dateArr[0].length == 2) && (dateArr[1].length == 2)){
						var formattedDate = $.datepicker.formatDate(compassDateFormat, new Date(dateArr[2], dateArr[1]-1, dateArr[0]));
						$("table."+searchTable).find("input[id^='FROMDATE']").val(formattedDate);
					}else{
						$("table."+searchTable).find("input[id^='FROMDATE']").val(compassTopFrame.fromDate(compassDateFormat));
					}
				}else if(arrLen == 2){
					$("table."+searchTable).find("input[id^='FROMDATE']").val(compassTopFrame.fromDate(compassDateFormat));
				}else if(arrLen == 1 && enteredDate.length == 8){
					var modifiedDate = "";
					for(var i = 0; i < enteredDate.length; i++){
						modifiedDate = modifiedDate + enteredDate.charAt(i);
						if(i == 1 || i == 3)
							modifiedDate = modifiedDate + "/";						
					}
					
					var modDateArr = modifiedDate.split("/");
					modifiedDate = $.datepicker.formatDate(compassDateFormat, new Date(modDateArr[2], modDateArr[1]-1, modDateArr[0]));
					$("table."+searchTable).find("input[id^='FROMDATE']").val(modifiedDate);
				}else{
					$("table."+searchTable).find("input[id^='FROMDATE']").val(compassTopFrame.fromDate(compassDateFormat));
				}
			});
			
			$("table."+searchTable).find("input[id^='TODATE']").blur(function(){
				var enteredDate = $(this).val();
				var dateArr = enteredDate.split("/");
				var arrLen = enteredDate.split("/").length;
				if(arrLen == 3){
					if((dateArr[2].length == 4) && (dateArr[0].length == 2) && (dateArr[1].length == 2)){
						var formattedDate = $.datepicker.formatDate(compassDateFormat, new Date(dateArr[2], dateArr[1]-1, dateArr[0]));
						$("table."+searchTable).find("input[id^='TODATE']").val(formattedDate);
					}else{
						$("table."+searchTable).find("input[id^='TODATE']").val(compassTopFrame.toDate(compassDateFormat));
					}
				}else if(arrLen == 2){
					$("table."+searchTable).find("input[id^='TODATE']").val(compassTopFrame.toDate(compassDateFormat));
				}else if(arrLen == 1 && enteredDate.length == 8){
					var modifiedDate = "";
					for(var i = 0; i < enteredDate.length; i++){
						modifiedDate = modifiedDate + enteredDate.charAt(i);
						if(i == 1 || i == 3)
							modifiedDate = modifiedDate + "/";						
					}
					
					var modDateArr = modifiedDate.split("/");
					modifiedDate = $.datepicker.formatDate(compassDateFormat, new Date(modDateArr[2], modDateArr[1]-1, modDateArr[0]));
					$("table."+searchTable).find("input[id^='TODATE']").val(modifiedDate);
				}else{
					$("table."+searchTable).find("input[id^='TODATE']").val(compassTopFrame.toDate(compassDateFormat));
				}
			});
		},
		searchPanelSliding : function(unqId, mainRow, moduleSearchResultPanel){
			if($(mainRow).children().find("#"+moduleSearchResultPanel+unqId).css("display") != "none"){
				var slidingDiv = $(mainRow).children().children().children();
				var panelBody = $(mainRow).children().children().find(".panelSearchForm");
				if($(slidingDiv).hasClass("card-collapsed")){
					$(panelBody).slideDown();
					$(slidingDiv).removeClass('card-collapsed');
					$(slidingDiv).find("i.collapsable").removeClass("fa-chevron-down").addClass("fa-chevron-up");
					$(mainRow).next().find(".compassrow"+unqId).find(".card-header").next().slideUp();
				}else{
					$(panelBody).slideUp();
					$(slidingDiv).addClass('card-collapsed');
					$(slidingDiv).find('i.collapsable').removeClass('fa-chevron-up').addClass('fa-chevron-down');
					$(mainRow).next().find(".compassrow"+unqId).find(".card-header").next().slideDown();
				}
			}
		},
		submitForm : function(unqId, event, submitButton, moduleSearchResultPanel, moduleSearchResult, searchUrl, preloaderUrl){
			if($(submitButton).parents("div.panelSearchForm").find("input[id^='FROMDATE']").val() != undefined && 
					$(submitButton).parents("div.panelSearchForm").find("input[id^='FROMDATE']").val().trim == "")
				$(submitButton).parents("div.panelSearchForm").find("input[id^='FROMDATE']").val(compassTopFrame.fromDate(compassDateFormat));
			
			if($(submitButton).parents("div.panelSearchForm").find("input[id^='TODATE']").val() != undefined && 
					$(submitButton).parents("div.panelSearchForm").find("input[id^='TODATE']").val().trim == "")
				$(submitButton).parents("div.panelSearchForm").find("input[id^='TODATE']").val(compassTopFrame.toDate(compassDateFormat));
			

			var validationPass = true;
			
			$("#searchMasterForm"+unqId).find("table").children("tbody").children("tr").each(function(){
				var labelName = $(this).children("td:nth-child(1)").text().replace("*","").replace("\n","");
				var elm = $(this).children("td:nth-child(2)").find("input,select");
				var elmVal = $(elm).val();
				var validation = $(elm).attr("validation");
				
				if(validation == "Y" && elmVal == ""){
					validationPass = false;
					alert("Please Enter Value in "+labelName);
				}
				
				labelName = $(this).children("td:nth-child(4)").text().replace("*","").replace("\n","");
				elm = $(this).children("td:nth-child(5)").find("input,select");
				elmVal = $(elm).val();
				validation = $(elm).attr("validation");
				
				if(validation == "Y" && elmVal == ""){
					validationPass = false;
					alert("Please Enter Value in "+labelName);
				}
			});
			
			if(validationPass){
				var button = submitButton;
				var mainRow = $(button).parents("div.compassrow"+unqId);
				var slidingDiv = $(mainRow).children().children().children();
				var panelBody = $(mainRow).children().children().find(".panelSearchForm");
				
				$(button).html("Searching...");
				$(button).attr("disabled","disabled");
				$("#"+moduleSearchResultPanel+unqId).css("display",'block');
				$("#"+moduleSearchResult+unqId).html("<br/><center> <img src='"+preloaderUrl+"' alt='Loading...'/></center>");
				var formObj = $("#searchMasterForm"+unqId);
				var formData = (formObj).serialize();
				var formData = formData + '&submitButton='+button.attr('id');
			
				$.ajax({
					url : searchUrl,
					cache : false,
					data : formData,
					type : 'POST',
					success : function(resData){
						$("#"+moduleSearchResult+unqId).html(resData);
						$(button).html("Search");
						$(button).removeAttr("disabled");
						$(panelBody).slideUp();
						$(slidingDiv).addClass('card-collapsed');
						$(slidingDiv).find('i.collapsable').removeClass('fa-chevron-up').addClass('fa-chevron-down');
						$(mainRow).next().find(".compassrow"+unqId).find(".card-header").next().slideDown();
						
					},
					error : function(a,b,c){
						alert("Something went wrong");
					}
				});
			}
			event.preventDefault();
		},
		moduleSearch : function(searchFieldId, serachFor, viewName, isMultipleSelect, contextPath){
			$("#compassSearchModuleModal").modal("show");
			$("#compassSearchModuleModal-title").html("Search for "+serachFor);
			$("#compassSearchModuleModal-body").html("<br/><center> <img src='"+contextPath+"/includes/images/qde-loadder.gif' alt='Loading...'/></center>");
			$.ajax({
				url : contextPath+"/common/genericModuleFieldsSearch",
				cache : false,
				data : "searchFieldId="+searchFieldId+"&serachFor="+serachFor+"&viewName="+viewName+"&isMultipleSelect="+isMultipleSelect,
				type : 'POST',
				success : function(resData){
					$("#compassSearchModuleModal-body").html(resData);
				},
				error : function(a,b,c){
					alert("Something went wrong");
				}
			});
			
		},		
		submitFormInsteadOfSearch : function(unqId, event, submitButton, moduleSearchResultPanel, moduleSearchResult, searchUrl, preloaderUrl,buttonTextDuringOperation){
			if($(submitButton).parents("div.panelSearchForm").find("input[id^='FROMDATE']").val() != undefined && 
					$(submitButton).parents("div.panelSearchForm").find("input[id^='FROMDATE']").val().trim == "")
				$(submitButton).parents("div.panelSearchForm").find("input[id^='FROMDATE']").val(compassTopFrame.fromDate(compassDateFormat));
			
			if($(submitButton).parents("div.panelSearchForm").find("input[id^='TODATE']").val() != undefined && 
					$(submitButton).parents("div.panelSearchForm").find("input[id^='TODATE']").val().trim == "")
				$(submitButton).parents("div.panelSearchForm").find("input[id^='TODATE']").val(compassTopFrame.toDate(compassDateFormat));
			

			var validationPass = true;
			
			$("#searchMasterForm"+unqId).find("table").children("tbody").children("tr").each(function(){
				var labelName = $(this).children("td:nth-child(1)").text().replace("*","").replace("\n","");
				var elm = $(this).children("td:nth-child(2)").find("input,select");
				var elmVal = $(elm).val();
				var validation = $(elm).attr("validation");
				
				if(validation == "Y" && elmVal == ""){
					validationPass = false;
					alert("Please Enter Value in "+labelName);
				}
				
				labelName = $(this).children("td:nth-child(4)").text().replace("*","").replace("\n","");
				elm = $(this).children("td:nth-child(5)").find("input,select");
				elmVal = $(elm).val();
				validation = $(elm).attr("validation");
				
				if(validation == "Y" && elmVal == ""){
					validationPass = false;
					alert("Please Enter Value in "+labelName);
				}
			});
			
			if(validationPass){
				var button = submitButton;
				var buttonText = $(button).text();
				var mainRow = $(button).parents("div.compassrow"+unqId);
				var slidingDiv = $(mainRow).children().children().children();
				var panelBody = $(mainRow).children().children().find(".panelSearchForm");
				
				$(button).html(buttonTextDuringOperation);
				$(button).attr("disabled","disabled");	
				$("#"+moduleSearchResultPanel+unqId).css("display",'block');
				$("#"+moduleSearchResult+unqId).html("<br/><center> <img src='"+preloaderUrl+"' alt='Loading...'/></center>");
				var formObj = $("#searchMasterForm"+unqId);
				var formData = (formObj).serialize();
			
				$.ajax({
					url : searchUrl,
					cache : false,
					data : formData,
					type : 'POST',
					success : function(resData){
						$("#"+moduleSearchResult+unqId).html(resData);
						$(button).html(buttonText);
						$(button).removeAttr("disabled");
						$(panelBody).slideUp();
						$(slidingDiv).addClass('card-collapsed');
						$(slidingDiv).find('i.collapsable').removeClass('fa-chevron-up').addClass('fa-chevron-down');
						$(mainRow).next().find(".compassrow"+unqId).find(".card-header").next().slideDown();
						
					},
					error : function(a,b,c){
						alert("Something went wrong");
					}
				});
			}
			event.preventDefault();
		}
	};
}());
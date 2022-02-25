<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../tags/tags.jsp"%>
<%
String CURRENTROLE = (String) request.getSession(false).getAttribute("CURRENTROLE");
String prefix = CURRENTROLE+"_CN_";
%>
<script type="text/javascript">
	
	var viewType = '${viewType}';
	var alertId = '${alertId}';
	var alertSerialNo = '${alertSerialNo}';
	var id = '${UNQID}';
	var benchMarkStatusList = '${BENCHMARKSTATUS}'
	
	
	function getFormData(){
		var formDataList = []
		$("input[type=checkbox]:checked").each(function(){
			if($(this).prop("value") != 'headerRow'){
		
	            var $row = $(this).closest('tr');
	            var formData = "moduleType=&bottomPageUrl=OfflineAlerts%2FAlertResult"
	            var rowId;
	            $('td:not(:first-child)', $row).each(function(i){
	            	if(i == 0){
	            		if(i == 0){
	                		rowId = $(this).text();
	                		
	                	}
	            		
	            	}
	            	
	                if($(this).children(":first").attr('value') == null && $(this).children().length == 1 &&  $(this).children(":first").children().length == 2){
	                	var attributeName = $(this).children(":first").children(":first").attr('name');
	                    var attributeValue = $(this).children(":first").children(":first").attr('value');
	                    formData = formData+"&"+attributeName+"="+attributeValue.replaceAll("/","%2F").replaceAll(" ","+");
	                }
	                else{
	                	if($(this).children(":first").prop('nodeName') == "SELECT"){
	                		var attributeName = $(this).children(":first").attr('name');
	                        var attributeValue = $( "#"+$(this).children(":first").prop('id') ).val();
	                        formData = formData+"&"+attributeName+"="+attributeValue.replaceAll("/","%2F").replaceAll(" ","+");
	                	}
	                	else{
	                		if($(this).children(":first").attr('name') != null && $(this).children(":first").attr('value') != null){
			                	var attributeName = $(this).children(":first").attr('name');
			                    var attributeValue = $(this).children(":first").attr('value');
			                    formData = formData+"&"+attributeName+"="+attributeValue.replaceAll("/","%2F").replaceAll(" ","+");
	                		}
	                	}
	                }
	            })
	            if(rowId != 'default'){
            		
		            formData = formData+"&19_AlertSerialId="+rowId;
		            var data= {};
		    		data['formData'] = formData;
		    		data['alertSerialNo'] = rowId;
		            formDataList.push(data);
            	}
	         }
		});
		console.log(formDataList);
		return formDataList; 
	}
	
	function saveAlertBenchMarkDtls(){
			var button = $(this);
			button.attr("disabled","disabled");
			var userLogcomments = prompt("Please enter your comments before saving."); 
			if(userLogcomments != null){
				/* $("#compassMediumGenericModal").modal("show");
				$("#compassMediumGenericModal-title").html("Put Comments");
				$("#compassMediumGenericModal-body").html("<br/><center><img alt='Loading...' src='${pageContext.request.contextPath}/includes/images/qde-loadder.gif'><center><br/>");
				*/
				var formObj = $("#searchalertBenchMarkDtlsForm"+id);
				 /*var formData = (formObj).serialize();*/ 
				 /* var data = getFormData();
				 var formData = data['formData'];
				 var alertSerialNo = data['alertSerialNo']; */
				
				 var data = getFormData();
					for(var x = 0 ; x < data.length; x++){
						var formData = data[x]['formData'];
						var alertSerialNo = data[x]['alertSerialNo'];
				 
						$.ajax({
							url: "${pageContext.request.contextPath}/admin/saveAlertBenchMarkParameters" ,
							cache: false,
							data: formData+"&alertId="+alertId+"&id="+id+"&viewType="+viewType+"&alertSerialNo="+alertSerialNo+"&userLogcomments="+userLogcomments,
							type: 'POST',
							success: function(res){
								alert('Successfully Saved.');
								$("#compassGenericModal").modal("hide");
								$(".offlineAlertsListTable"+id).children("tbody").children("tr").each(function(){
									var td = $(this).children("td:first-child");
									if($(td).html() == alertId)
										$(td).click();
								});
							},
							error: function(a,b,c){
								alert(a+b+c);
							},complete: function(){
								button.removeAttr("disabled");
							}
						});
				}
			}else{
				button.removeAttr("disabled");
			}
		}
	
		function approveAlertBenchMarkDtls(){
			var userLogcomments = prompt("Please enter your comments before saving."); 
			if(userLogcomments != null){
				var formObj = $("#searchalertBenchMarkDtlsForm"+id);
				/*var formData = (formObj).serialize();*/ 
				
				/* var data = getFormData();
				var formData = data['formData'];
				var alertSerialNo = data['alertSerialNo'];
				
				var formObj = $("#searchalertBenchMarkDtlsForm"+id);
				var benchMarkStatus = "";
				var requestType="";
				
				 $("input[type=checkbox]:checked").each(function(){
					 var tempVal = $(this).prop("value")
					 var tempArr = tempVal.split("|^|")
					 benchMarkStatus = tempArr[0]
					 requestType = tempArr[1]
				 });    */
				 
				var benchMarkStatusList = [];
				var requestTypeList =[];
				
				 $("input[type=checkbox]:checked").each(function(){
					 if($(this).prop("value") != 'headerRow'){
						 
						 var tempVal = $(this).prop("value");
						 var tempArr = tempVal.split("|^|");
						 benchMarkStatusList.push(tempArr[0]);
						 requestTypeList.push(tempArr[1]);
					 }
				 });   
				
				/*var formData = (formObj).serialize();*/ 
				/* var data = getFormData();
				var formData = data['formData'];
				var alertSerialNo = data['alertSerialNo']; */
				
				var data = getFormData();
				var testArr = [];
				var testCounter = 0;
				for(var x = 0 ; x < data.length; x++){
					var formData = data[x]['formData'];
					var alertSerialNo = data[x]['alertSerialNo'];
					var requestType = requestTypeList[x];
					var benchMarkStatus = benchMarkStatusList[x];
				
					$.ajax({
						url: "${pageContext.request.contextPath}/admin/approveAlertBenchMarkParameters" ,
						cache: false,
						data: formData+"&alertId="+alertId+"&id="+id+"&viewType="+viewType+"&alertSerialNo="+alertSerialNo+"&requestType="+requestType+"&benchMarkStatus="+benchMarkStatus+"&userLogcomments="+userLogcomments,
						type: 'POST',
						success: function(res){
							/* alert('Successfully Saved.');
							$("#compassGenericModal").modal("hide");
							$(".offlineAlertsListTable"+id).children("tbody").children("tr").each(function(){
								var td = $(this).children("td:first-child");
								if($(td).html() == alertId)
									$(td).click();
							}); */
							testArr.push(0);
							testCounter +=1;
							checkCheck('Successfully Saved.',testArr,data.length,testCounter);
							 
						},
						error: function(a,b,c){
							 /* alert(a+b+c);   */
							 testCounter += 1;
							 checkCheck(a+b+c,testArr,data.length,testCounter);
							 
						}
					});
				}
			}			
		}
	
		function rejectAlertBenchMarkDtls(){
			var userLogcomments = prompt("Please enter your comments before saving."); 
			if(userLogcomments != null){
			// if(confirm("Are you sure you want to Save?")){
				var formObj = $("#searchalertBenchMarkDtlsForm"+id);
				var benchMarkStatusList = [];
				var requestTypeList =[];
				
				 $("input[type=checkbox]:checked").each(function(){
					 if($(this).prop("value") != 'headerRow'){
						 
						 var tempVal = $(this).prop("value")
						 var tempArr = tempVal.split("|^|")
						 benchMarkStatusList.push(tempArr[0])
						 requestTypeList.push(tempArr[1])
					 }
				 });   
				
				/*var formData = (formObj).serialize();*/ 
				/* var data = getFormData();
				var formData = data['formData'];
				var alertSerialNo = data['alertSerialNo']; */
				
				var data = getFormData();
				var testArr = [];
				var testCounter = 0;
				for(var x = 0 ; x < data.length; x++){
					var formData = data[x]['formData'];
					var alertSerialNo = data[x]['alertSerialNo'];
					var requestType = requestTypeList[x];
					var benchMarkStatus = benchMarkStatusList[x];
				
					 
					 $.ajax({
						url: "${pageContext.request.contextPath}/admin/rejectAlertBenchMarkParameters" ,
						cache: false,
						data: formData+"&alertId="+alertId+"&id="+id+"&viewType="+viewType+"&alertSerialNo="+alertSerialNo+"&requestType="+requestType+"&benchMarkStatus="+benchMarkStatus+"&userLogcomments="+userLogcomments,
						type: 'POST',
						success: function(res){
							/* alert('Successfully Saved.');
							$("#compassGenericModal").modal("hide");
							$(".offlineAlertsListTable"+id).children("tbody").children("tr").each(function(){
								var td = $(this).children("td:first-child");
								if($(td).html() == alertId)
									$(td).click();
							}); */
							testArr.push(0);
							testCounter +=1;
							checkCheck('Successfully Saved.',testArr,data.length,testCounter);
							 
						},
						error: function(a,b,c){
							 /* alert(a+b+c);   */
							 testCounter += 1;
							 checkCheck(a+b+c,testArr,data.length,testCounter);
							 
						}
						
					});  
				}
			}			
		}
		
		function generateAlertBenchMarkDtls(){
			var button = $(this);
			button.attr("disabled","disabled");
			var mainRow = $(this).parents("div.compassmodalrow"+id);
			var slidingDiv = $(mainRow).children().children().children();
			var panelBody = $(mainRow).children().children().find(".panelSearchForm");
			var generationType = "ALERTDATA";
			if(confirm("Are you sure you want to Generate Alert?")){
				var formObj = $("#searchalertBenchMarkDtlsForm"+id);
				/*var formData = (formObj).serialize();*/ 
				/* var data = getFormData();
				var formData = data['formData'];
				var alertSerialNo = data['alertSerialNo']; */
				var data = getFormData();
				for(var x = 0 ; x < data.length; x++){
					var formData = data[x]['formData'];
					var alertSerialNo = data[x]['alertSerialNo'];
					$.ajax({
						url: "${pageContext.request.contextPath}/admin/generateAlertWithBenchMarks" ,
						cache: false,
						data: formData+"&alertId="+alertId+"&id="+id+"&viewType="+viewType+"&alertSerialNo="+alertSerialNo+"&generationType="+generationType,
						type: 'POST',
						success: function(res){
							$("#alertBenchMarkDtlsSerachResultPanel"+id).css("display", "block");
							$("#alertBenchMarkDtlsSerachResult"+id).html(res);
							$(panelBody).slideUp();
							$(slidingDiv).addClass('card-collapsed');
							$(slidingDiv).find('i.collapsable').removeClass('fa-chevron-up').addClass('fa-chevron-down');
							$(mainRow).next().find(".compassmodalrow"+id).find(".card-header").next().slideDown();
						},
						error: function(a,b,c){
							alert(a+b+c);
						},complete: function (){
							button.removeAttr("disabled");
						}
					});
				}
			}else{
				button.removeAttr("disabled");
			}			
		}
	
		function simulateAlertBenchMarkDtls(){
			var mainRow = $(this).parents("div.compassmodalrow"+id);
			var slidingDiv = $(mainRow).children().children().children();
			var panelBody = $(mainRow).children().children().find(".panelSearchForm");
			var generationType = "ALERTDATA";
			if(confirm("Are you sure you want to Generate Alert?")){
				var formObj = $("#searchalertBenchMarkDtlsForm"+id);
				/*var formData = (formObj).serialize();*/ 
				/* var data = getFormData();
				var formData = data['formData'];
				var alertSerialNo = data['alertSerialNo']; */
				
				var data = getFormData();
				for(var x = 0 ; x < data.length; x++){
					var formData = data[x]['formData'];
					var alertSerialNo = data[x]['alertSerialNo'];
					$.ajax({
						url: "${pageContext.request.contextPath}/admin/simulateAlertWithBenchMarks" ,
						cache: false,
						data: formData+"&alertId="+alertId+"&id="+id+"&viewType="+viewType+"&alertSerialNo="+alertSerialNo+"&generationType="+generationType,
						type: 'POST',
						success: function(res){
							$("#alertBenchMarkDtlsSerachResultPanel"+id).css("display", "block");
							$("#alertBenchMarkDtlsSerachResult"+id).html(res);
							$(panelBody).slideUp();
							$(slidingDiv).addClass('card-collapsed');
							$(slidingDiv).find('i.collapsable').removeClass('fa-chevron-up').addClass('fa-chevron-down');
							$(mainRow).next().find(".compassmodalrow"+id).find(".card-header").next().slideDown();
						},
						error: function(a,b,c){
							alert(a+b+c);
						}
					});
				}
			}			
		}
	
		function deleteAlertBenchMarkDtls(){
			var button = $(this);
			button.prop("disabled", true);
			var formObj = $("#searchalertBenchMarkDtlsForm"+id);
			/*var formData = (formObj).serialize();*/ 
			/* var data = getFormData();
			var formData = data['formData'];
			var alertSerialNo = data['alertSerialNo']; */
			
			var data = getFormData();
			var testArr = [];
			var testCounter = 0;
			for(var x = 0 ; x < data.length; x++){
				var formData = data[x]['formData'];
				var alertSerialNo = data[x]['alertSerialNo'];
			
			//alert(parameterType);
				if(parameterType == 'SIMULATION'){
					$.ajax({
						url: "${pageContext.request.contextPath}/admin/deleteAlertBenchMarkParamsForSimulation",
						cache: false,
						data: "alertId="+alertId+"&id="+id+"&viewType="+viewType+"&alertSerialNo="+alertSerialNo+"&userLogcomments="+userLogcomments,
						type: 'POST',
						success: function(res){
							/* alert('Successfully Deleted');
							$("#compassGenericModal").modal("hide");
							$(".offlineAlertsListTable"+id).children("tbody").children("tr").each(function(){
								var td = $(this).children("td:first-child");
								if($(td).html() == alertId)
									$(td).click();
							}); */
							testArr.push(0);
							testCounter +=1;
							checkCheck('Successfully Saved for Configuration.',testArr,data.length,testCounter);
							 
						},
						error: function(a,b,c){
							 /* alert(a+b+c);   */
							 testCounter += 1;
							 checkCheck(a+b+c,testArr,data.length,testCounter);
							 
						}
					});
				}else{
					var userLogcomments = prompt("Please enter your comments before deleting."); 
					if(userLogcomments != null){
					// if(confirm("Are you sure you want to delete?")){
						$.ajax({
							url: "${pageContext.request.contextPath}/admin/deleteAlertBenchMarkParameters",
							cache: false,
							data: "alertId="+alertId+"&id="+id+"&viewType="+viewType+"&alertSerialNo="+alertSerialNo+"&userLogcomments="+userLogcomments,
							type: 'POST',
							success: function(res){
								/* alert('Successfully Deleted');
								$("#compassGenericModal").modal("hide");
								$(".offlineAlertsListTable"+id).children("tbody").children("tr").each(function(){
									var td = $(this).children("td:first-child");
									if($(td).html() == alertId)
										$(td).click();
								}); */
								testArr.push(0);
								testCounter +=1;
								checkCheck('Successfully Saved for Configuration.',testArr,data.length,testCounter);
								 
							},
							error: function(a,b,c){
								 /* alert(a+b+c);   */
								 testCounter += 1;
								 checkCheck(a+b+c,testArr,data.length,testCounter);
								 
							}
						});
					}
				}
			}
		}
		
	function saveForConfiguration(){
		
		var userLogcomments = prompt("Please enter your comments before saving."); 
		if(userLogcomments != null){
			var formObj = $("#searchalertBenchMarkDtlsForm"+id);
			/*var formData = (formObj).serialize();*/ 
			/* var data = getFormData(); */
			var data = getFormData();
			var testArr = [];
			var testCounter = 0;
			for(var x = 0 ; x < data.length; x++){
				var formData = data[x]['formData'];
				var alertSerialNo = data[x]['alertSerialNo'];
				
				$.ajax({
					url: "${pageContext.request.contextPath}/admin/saveAlertBenchMarkParameters" ,
					cache: false,
					data: formData+"&alertId="+alertId+"&id="+id+"&viewType="+viewType+"&alertSerialNo="+alertSerialNo+"&userLogcomments="+userLogcomments,
					type: 'POST',
					success: function(res){
						 /* alert('Successfully Saved for Configuration.'); */
						/* $("#compassGenericModal").modal("hide");
						$(".offlineAlertsListTable"+id).children("tbody").children("tr").each(function(){
							var td = $(this).children("td:first-child");
							if($(td).html() == alertId)
								$(td).click();
						});  */
						testArr.push(0);
						testCounter +=1;
						checkCheck('Successfully Saved for Configuration.',testArr,data.length,testCounter);
						 
					},
					error: function(a,b,c){
						 /* alert(a+b+c);   */
						 testCounter += 1;
						 checkCheck(a+b+c,testArr,data.length,testCounter);
						 
					}
				});
				
			}
			
		}
	}
	
	function checkCheck(msg,a,b,c){
		if(a.length == b && c == b){
			alert(msg);
			reloadTabContent();

		}
		else if(a.length != b && c == b){
			alert(msg);
			reloadTabContent();

		}
	}
	
	function saveForSimulation(){
		var id = '${UNQID}';
		/* var formObj = $("#searchalertBenchMarkDtlsForm"+id);*/
		var data = getFormData();
		var testArr = [];
		var testCounter = 0;
		for(var x = 0 ; x < data.length; x++){
			var formData = data[x]['formData'];
			var alertSerialNo = data[x]['alertSerialNo'];
			/* alert("&alertId="+alertId+"&id="+id+"&viewType="+viewType+"&alertSerialNo="+alertSerialNo); */
			$.ajax({
				url: "${pageContext.request.contextPath}/admin/saveAlertBenchMarkParamsForSimulation" ,
				cache: false,
				data: formData+"&alertId="+alertId+"&id="+id+"&viewType="+viewType+"&alertSerialNo="+alertSerialNo,
				type: 'POST',
				success: function(res){
					/* alert('Successfully Saved for Simulation.');
					 $("#compassGenericModal").modal("hide");
					$(".offlineAlertsListTable"+id).children("tbody").children("tr").each(function(){
						var td = $(this).children("td:first-child");
						if($(td).html() == alertId)
							$(td).click();
					}); */ 
					testArr.push(0);
					testCounter +=1;
					checkCheck('Successfully Saved for Simulation.',testArr,data.length,testCounter);
					 
				},
				error: function(a,b,c){
					 /* alert(a+b+c);   */
					 testCounter += 1;
					 checkCheck(a+b+c,testArr,data.length,testCounter);
					 
				}
			});
		}
	}

	$(document).ready(function() {
		var id = '${UNQID}';
		var tableClass = 'alertBenchMarksListTable'+id;
		compassDatatable.construct(tableClass, "AlertBenchMarksList", true);
		compassDatatable.enableCheckBoxSelection();
		
	});
	
	function openAlertSerialIdDetails(elm, alertSerialNo, alertApprovalStatus, parameterType){
		var id = '${UNQID}';
		var viewType = '${viewType}';
		var alertId = '${alertId}';
		var alertName = '${alertName}';
		/*
		var alertSerialNo = $(elm).html();
		var alertApprovalStatus = '';		
		$(".alertBenchMarksListTable"+id).children("tbody").children("tr").each(function(){
			alertApprovalStatus = $(this).children("td:nth-child(2)").html();
		});
		*/
		$("#compassGenericModal").modal("show");

		$("#compassGenericModal-title").html(alertId + " - "+"Save/Generate Alert Parameters");
		$("#compassGenericModal-body").html("<br/><br/><center><img alt='Loading...' src='${pageContext.request.contextPath}/includes/images/qde-loadder.gif'></center>");

		$.ajax({
			url: "${pageContext.request.contextPath}/admin/getAlertBenchMarkDetails" ,
			cache: false,
			data: "alertId="+alertId+"&id="+id+"&viewType="+viewType+"&alertSerialNo="+alertSerialNo+"&alertApprovalStatus="+alertApprovalStatus+"&parameterType="+parameterType,
			type: 'POST',
			success: function(res){
				$("#compassGenericModal-body").html(res);
			},
			error: function(a,b,c){
				alert(a+b+c);
			}
		});
	}
	
	function openAlertApprovalStatusDetails(elm, alertSerialNo, alertApprovalStatus){
		var id = '${UNQID}';
		var viewType = '${viewType}';
		var alertId = '${alertId}';
		var alertName = '${alertName}';
		/*
		var alertApprovalStatus = $(elm).html();
		var alertSerialNo = '';		
		$(".alertBenchMarksListTable"+id).children("tbody").children("tr").each(function(){
			alertSerialNo = $(this).children("td:nth-child(1)").html();
		});
		*/
		
		$("#compassGenericModal").modal("show");

		$("#compassGenericModal-title").html("Alert Approval Status");
		$("#compassGenericModal-body").html("<br/><br/><center><img alt='Loading...' src='${pageContext.request.contextPath}/includes/images/qde-loadder.gif'></center>");

		$.ajax({
			url: "${pageContext.request.contextPath}/admin/getAlertBenchMarkStatusDetails" ,
			cache: false,
			data: "alertId="+alertId+"&id="+id+"&viewType="+viewType+"&alertSerialNo="+alertSerialNo+"&alertApprovalStatus="+alertApprovalStatus,
			type: 'POST',
			success: function(res){
				$("#compassGenericModal-body").html(res);
			},
			error: function(a,b,c){
				alert(a+b+c);
			}
		});
	}
	
	
	function checkedHandle(){
		$(".datepickerText").datepicker();
	
  	 	$("input[type=checkbox]:not(:checked)").each(function(){
            var $row = $(this).closest('tr');
            
            $('td:not(:first-child)', $row).each(function(i){
                 
                 if($(this).children(":first").attr('value') == null && $(this).children().length == 1 && $(this).children(":first").children().length == 2){
                	 $(this).children(":first").children(":first").attr('disabled','disabled');
                    $(this).children(":first").children(":last").css('visibility','hidden');
                 }
                 else{
                 	
                	 $(this).children(":first").attr('disabled','disabled');
                 }
            })
            
           });
        
         $("input[type=checkbox]:checked").each(function(){
            var $row = $(this).closest('tr');
            
            $('td:not(:first-child)', $row).each(function(i){
                if($(this).children(":first").attr('value') == null && $(this).children().length == 1 &&  $(this).children(":first").children().length == 2){
                	$(this).children(":first").children(":first").removeAttr('disabled');
                    $(this).children(":first").children(":last").css('visibility','visible');
                }
                else{
                 	$(this).children(":first").removeAttr('disabled');
                }
            })
            
            
         });  
         
         if($("input[type=checkbox]:checked").length > 0){
        	 
	         $("#recordActionSection").css("display","block")
	         if($("input[type=checkbox]:checked").length == 1 || $("input[type=checkbox]:checked").length == 2){
	        	 var rowId;
	        	 $("input[type=checkbox]:checked").each(function(){
	        		 	var $row = $(this).closest('tr');
		 	            
		 	            $('td:not(:first-child)', $row).each(function(i){
		 	            	if(i == 0){
		 	            		if(i == 0){
		 	                		rowId = $(this).text();
		 	                		
		 	                	}
		 	            		
		 	            	}
		 	            })
		 	            
	        	 })
	        	 
	        	 if(rowId == "default"){
	        		 $("#recordActionSection").css("display","none");
	        	 }
	         }
         }
         else{
        	 $("#recordActionSection").css("display","none");
         }
         
    }
	
	function showActionPanel(){
		$(".datepickerText").datepicker();
			
		if($("#recordActionSection").css("display") =="none"){
		
			$("#recordActionSection").css("display","block");
		}
		else{
			if($("input[type=checkbox]:checked").length == 0)
				$("#recordActionSection").css("display","none");
		}
		
		$("input[type=checkbox]:not(:checked)").each(function(){
            var $row = $(this).closest('tr');
            
            $('td:not(:first-child)', $row).each(function(i){
                 
                 if($(this).children(":first").attr('value') == null && $(this).children().length == 1 && $(this).children(":first").children().length == 2){
                	 $(this).children(":first").children(":first").attr('disabled','disabled');
                    $(this).children(":first").children(":last").css('visibility','hidden');
                 }
                 else{
                 	
                	 $(this).children(":first").attr('disabled','disabled');
                 }
            })
            
           });
        
         $("input[type=checkbox]:checked").each(function(){
            var $row = $(this).closest('tr');
            
            $('td:not(:first-child)', $row).each(function(i){
                if($(this).children(":first").attr('value') == null && $(this).children().length == 1 &&  $(this).children(":first").children().length == 2){
                	$(this).children(":first").children(":first").removeAttr('disabled');
                    $(this).children(":first").children(":last").css('visibility','visible');
                }
                else{
                 	$(this).children(":first").removeAttr('disabled');
                }
            })
            
            
         });
		
	}
	
	
</script>
<style type="text/css">
	.alertSerialIdHyperlink{
		text-decoration: underline;
		color: blue;
		cursor: pointer;
	}
	.alertApprovalStatusHyperlink{
		text-decoration: underline;
		color: blue;
		cursor: pointer;
	}
</style>
<div id="searchResultGenericDiv">
	<div id = "tempDiv" style="display:none"></div>
	<table class="table table-striped table-bordered alertBenchMarksListTable${UNQID}" id ="alertBenchMarksListTable${UNQID}" style="margin-bottom: 0px;">
		<thead>
			<tr>
				<th class="info no-sort"><input type = "checkbox" class="checkbox-check-all" value = "headerRow" onchange= "showActionPanel()" ></th>
				<c:forEach var="colHeader" items="${resultData['HEADER']}" >
					<th class="info" id="${colHeader}">${colHeader}</th>
				</c:forEach>
			</tr>
		</thead>
		<tbody>
			<c:forEach var="record" items="${resultData['DATA']}" varStatus = "IndexCount" >
				<%-- <c:if test="${f:length(record) > 0}"> --%>
				<c:if test="${record[1] eq 'EXISTING'}">
					<!-- <tr style="background-color:#87CEFA; "> -->
					<tr id = "tableRow${IndexCount.index }">			
						<c:if test="${f:length(listData[ IndexCount.index-1])-2 > 0}">
							<c:set var = "BENCHSTATUSDTLS" value = "${BENCHMARKSTATUS[IndexCount.index-1]['STATUS']}|^|${BENCHMARKSTATUS[IndexCount.index-1]['REQUESTTYPE']}"/>
							<c:if test="${record[0] eq 'default'}">
							
								<td><input type = "checkbox" id = "recordCheckBox" class="checkbox-check-many" onchange="checkedHandle()" value = "${BENCHSTATUSDTLS }" disabled></td>
							</c:if>
							<c:if test = "${record[0] != 'default'}">
								<td><input type = "checkbox" id = "recordCheckBox" class="checkbox-check-many" onchange="checkedHandle()" value = "${BENCHSTATUSDTLS }" ></td>
							
							</c:if>
							<c:forEach var="field" items="${record}" begin="0" end = "2">	
								<td data-toggle="tooltip" data-placement="auto"  title="${field}" data-container="body">${field}</td>
							</c:forEach>
							
							<%-- <c:out value = "${listData[IndexCount.count - 1][0] }"/> --%>
								<c:forEach var= "ALLLABELSMAP" items= "${listData[ IndexCount.index-1]  }" begin = "0" end="${f:length(listData[ IndexCount.index-1])-2 }" varStatus = "tdCount">
									<%-- <td data-toggle="tooltip" data-placement="auto"  title="${field}" data-container="body">${field["MODULEPARAMDEFAULTVALUE"] }</td> --%>
									<c:set var = "ROWNUMBER" value = "${IndexCount.index}"/>
									<c:set var = "COLNUMBER" value = "${tdCount.index}"/>
									<td style="min-width:150px">
										<c:if test="${ALLLABELSMAP['MODULEPARAMDATATYPE'] eq 'date'}">
											<input type="text" disabled value="${ALLLABELSMAP['MODULEPARAMDEFAULTVALUE']}" class="form-control input-sm datepickerText " id="${ALLLABELSMAP['MODULEPARAMIDNAME']}_${UNQID}_${ROWNUMBER}_${COLNUMBER}" name="${ALLLABELSMAP['MODULEPARAMINDEX']}_${ALLLABELSMAP['MODULEPARAMIDNAME']}" />
										</c:if>
										<c:if test="${ALLLABELSMAP['MODULEPARAMDATATYPE'] eq 'select'}">
											<c:set var="SELECTOPTIONNAMEVALUE" value="${ALLLABELSMAP['MODULEPARAMSELECTNAMEVALUES']}"/>
											
											<select class="form-control input-sm" disabled  id="${ALLLABELSMAP['MODULEPARAMIDNAME']}_${UNQID}_${ROWNUMBER}_${COLNUMBER}" name="${ALLLABELSMAP['MODULEPARAMINDEX']}_${ALLLABELSMAP['MODULEPARAMIDNAME']}">
												<c:forEach var="NAMEVALUE" items="${SELECTOPTIONNAMEVALUE}">
													<!-- <option value="${NAMEVALUE.key}">${NAMEVALUE.value}</option>-->
													<option value="${NAMEVALUE.key}"<c:if test="${ALLLABELSMAP['MODULEPARAMDEFAULTVALUE'] eq NAMEVALUE.key}">selected</c:if>>${NAMEVALUE.value}</option>
												</c:forEach>
											</select>
										</c:if>
										<c:if test="${ALLLABELSMAP['MODULEPARAMDATATYPE'] eq 'string'}">
											<input type="text" disabled value="${ALLLABELSMAP['MODULEPARAMDEFAULTVALUE']}" class="form-control input-sm" id="${ALLLABELSMAP['MODULEPARAMIDNAME']}_${UNQID}_${ROWNUMBER}_${COLNUMBER}" name="${ALLLABELSMAP['MODULEPARAMINDEX']}_${ALLLABELSMAP['MODULEPARAMIDNAME']}"/>
										</c:if>
										<c:if test="${ALLLABELSMAP['MODULEPARAMDATATYPE'] eq 'numeric'}">
											<input type="text" disabled value="${ALLLABELSMAP['MODULEPARAMDEFAULTVALUE']}" class="form-control input-sm" id="${ALLLABELSMAP['MODULEPARAMIDNAME']}_${UNQID}_${ROWNUMBER}_${COLNUMBER}" name="${ALLLABELSMAP['MODULEPARAMINDEX']}_${ALLLABELSMAP['MODULEPARAMIDNAME']}"/>
										</c:if>
										<c:if test="${ALLLABELSMAP['MODULEPARAMDATATYPE'] eq 'search'}">
											<div class="input-group"  style="z-index: 1">
												<input type="text" disabled value="${ALLLABELSMAP['MODULEPARAMDEFAULTVALUE']}" class="form-control input-sm" aria-describedby="basic-addon${UNQID}" id="${ALLLABELSMAP['MODULEPARAMIDNAME']}_${UNQID}_${ROWNUMBER}_${COLNUMBER}" name="${ALLLABELSMAP['MODULEPARAMINDEX']}_${ALLLABELSMAP['MODULEPARAMIDNAME']}"/>
												<span class="input-group-addon formSearchIcon" style="visibility:hidden" id="basic-addon${UNQID}" onclick="compassTopFrame.moduleSearch('${ALLLABELSMAP['MODULEPARAMIDNAME']}_${UNQID}_${ROWNUMBER}_${COLNUMBER}','${ALLLABELSMAP['MODULEPARAMIDNAME']}','${ALLLABELSMAP['MODULEPARAMVIEWNAME']}','${ALLLABELSMAP['MODULEPARAMVALIDATIONFIELD']}','${pageContext.request.contextPath}')"  style="cursor: pointer;" title="Search">
													<i class="fa fa-search"></i>
												</span>
											</div>
										</c:if>
									</td>
								</c:forEach>
							 </c:if>
						
					</tr>
				</c:if>
				<c:if test="${f:contains(record[1],'PENDING')}">
					<tr style="background-color: #F0E68C; " id = "tableRow${IndexCount.index }">
						 <c:if test="${f:length(listData[ IndexCount.index-1])-2 > 0}">
							 <c:set var = "BENCHSTATUSDTLS" value = "${BENCHMARKSTATUS[IndexCount.index-1]['STATUS']}|^|${BENCHMARKSTATUS[IndexCount.index-1]['REQUESTTYPE']}"/>
							 	<c:if test="${record[0] eq 'default'}">
								
									<td><input type = "checkbox" id = "recordCheckBox" class="checkbox-check-many" onchange="checkedHandle()" value = "${BENCHSTATUSDTLS }" disabled></td>
								</c:if>
								<c:if test = "${record[0] != 'default'}">
									<td><input type = "checkbox" id = "recordCheckBox" class="checkbox-check-many" onchange="checkedHandle()" value = "${BENCHSTATUSDTLS }" ></td>
								
								</c:if>
								<%-- <td><input type = "checkbox" id="recordCheckBox${IndexCount.index }" onchange="checkedHandle()" value = "${BENCHSTATUSDTLS }"></td>		 --%>	
								<c:forEach var="field" items="${record}" begin="0" end = "2">	
									<td data-toggle="tooltip" data-placement="auto"  title="${field}" data-container="body">${field}</td>
								</c:forEach>
								<c:forEach var= "ALLLABELSMAP" items= "${listData[IndexCount.index -1]  }" end="${f:length(listData[ IndexCount.index-1])-2 }" varStatus = "tdCount">
									<c:set var = "ROWNUMBER" value = "${IndexCount.index}"/>
									<c:set var = "COLNUMBER" value = "${tdCount.index}"/>
									<td style="min-width:150px">
											<c:if test="${ALLLABELSMAP['MODULEPARAMDATATYPE'] eq 'date'}">
												<input type="text" disabled value="${ALLLABELSMAP['MODULEPARAMDEFAULTVALUE']}"  class="form-control input-sm datepickerText" id="${ALLLABELSMAP['MODULEPARAMIDNAME']}_${UNQID}_${ROWNUMBER}_${COLNUMBER}" name="${ALLLABELSMAP['MODULEPARAMINDEX']}_${ALLLABELSMAP['MODULEPARAMIDNAME']}" />
											</c:if>
											<c:if test="${ALLLABELSMAP['MODULEPARAMDATATYPE'] eq 'select'}">
												<c:set var="SELECTOPTIONNAMEVALUE" value="${ALLLABELSMAP['MODULEPARAMSELECTNAMEVALUES']}"/>
												
												<select class="form-control input-sm" disabled   id="${ALLLABELSMAP['MODULEPARAMIDNAME']}_${UNQID}_${ROWNUMBER}_${COLNUMBER}" name="${ALLLABELSMAP['MODULEPARAMINDEX']}_${ALLLABELSMAP['MODULEPARAMIDNAME']}">
													<c:forEach var="NAMEVALUE" items="${SELECTOPTIONNAMEVALUE}">
														<!-- <option value="${NAMEVALUE.key}">${NAMEVALUE.value}</option>-->
														<option value="${NAMEVALUE.key}"<c:if test="${ALLLABELSMAP['MODULEPARAMDEFAULTVALUE'] eq NAMEVALUE.key}">selected</c:if>>${NAMEVALUE.value}</option>
													</c:forEach>
												</select>
											</c:if>
											<c:if test="${ALLLABELSMAP['MODULEPARAMDATATYPE'] eq 'string'}">
												<input type="text" disabled value="${ALLLABELSMAP['MODULEPARAMDEFAULTVALUE']}" class="form-control input-sm" id="${ALLLABELSMAP['MODULEPARAMIDNAME']}_${UNQID}_${ROWNUMBER}_${COLNUMBER}" name="${ALLLABELSMAP['MODULEPARAMINDEX']}_${ALLLABELSMAP['MODULEPARAMIDNAME']}"/>
											</c:if>
											<c:if test="${ALLLABELSMAP['MODULEPARAMDATATYPE'] eq 'numeric'}">
												<input type="text" disabled value="${ALLLABELSMAP['MODULEPARAMDEFAULTVALUE']}" class="form-control input-sm" id="${ALLLABELSMAP['MODULEPARAMIDNAME']}_${UNQID}_${ROWNUMBER}_${COLNUMBER}" name="${ALLLABELSMAP['MODULEPARAMINDEX']}_${ALLLABELSMAP['MODULEPARAMIDNAME']}"/>
											</c:if>
											<c:if test="${ALLLABELSMAP['MODULEPARAMDATATYPE'] eq 'search'}">
												<div class="input-group" style="z-index: 1">
													<input type="text" disabled value="${ALLLABELSMAP['MODULEPARAMDEFAULTVALUE']}" class="form-control input-sm" aria-describedby="basic-addon${UNQID}" id="${ALLLABELSMAP['MODULEPARAMIDNAME']}_${UNQID}_${ROWNUMBER}_${COLNUMBER}" name="${ALLLABELSMAP['MODULEPARAMINDEX']}_${ALLLABELSMAP['MODULEPARAMIDNAME']}"/>
													<span class="input-group-addon formSearchIcon" style="visibility:hidden" id="basic-addon${UNQID}" onclick="compassTopFrame.moduleSearch('${ALLLABELSMAP['MODULEPARAMIDNAME']}_${UNQID}_${ROWNUMBER}_${COLNUMBER}','${ALLLABELSMAP['MODULEPARAMIDNAME']}','${ALLLABELSMAP['MODULEPARAMVIEWNAME']}','${ALLLABELSMAP['MODULEPARAMVALIDATIONFIELD']}','${pageContext.request.contextPath}')"  style="cursor: pointer;" title="Search">
														<i class="fa fa-search"></i>
													</span>
												</div>
											</c:if>
										</td>
								</c:forEach>
					 </c:if> 
					</tr>
				</c:if>
				<%-- </c:if> --%>
			</c:forEach>
			<div class="card-footer clearfix" id = "recordActionSection" style="display:none">
				<div class="pull-${dirR}">
					<c:if test="${(CURRENTROLE eq 'ROLE_ADMIN' || CURRENTROLE eq 'ROLE_AMLO' || CURRENTROLE eq 'ROLE_AMLUSERL3')}">
					<%-- <button type="button" id="savealertBenchMarkDtls${UNQID}" class="btn btn-success btn-sm"><spring:message code="app.common.SAVEBUTTON"/></button> --%>
					<div class="btn-group dropup" role="group">
						<button type="button" class="btn btn-success btn-sm dropdown-toggle" data-toggle="dropdown" aria-expanded="false">
							<spring:message code="app.common.SAVEBUTTON"/>
							<span class="caret"></span>
						</button>
						<ul class="dropdown-menu" role="menu">
							<li><a class="nav-link" href="javascript:void(0)" onclick="saveForConfiguration()">For Configuration</a></li>
							<li><a class="nav-link" href="javascript:void(0)" onclick="saveForSimulation()">For Simulation</a></li>
						</ul>
					</div>
					<%-- <button type="button" id="generatealertBenchMarkDtls${UNQID}" onclick = "generateAlertBenchMarkDtls()" class="btn btn-primary btn-sm"><spring:message code="app.common.GENERATEBUTTON"/></button> --%>
					<button type="button" id="deletealertBenchMarkDtls${UNQID}" onclick = "deleteAlertBenchMarkDtls()" class="btn btn-danger btn-sm"><spring:message code="app.common.DELETEBUTTON"/></button>
					<%-- <button type="button" id="simulateAlertBenchMarkDtls${UNQID}" onclick = "simulateAlertBenchMarkDtls()" class="btn btn-primary btn-sm"><spring:message code="app.common.SIMULATEBUTTON"/></button> --%>
					</c:if>
					<c:if test="${(CURRENTROLE eq 'ROLE_MLRO' || CURRENTROLE eq 'ROLE_MLROL1' || CURRENTROLE eq 'ROLE_MLROL2')}">
					<button type="button" id="approvealertBenchMarkDtls${UNQID}" onclick = "approveAlertBenchMarkDtls()" class="btn btn-success btn-sm"><spring:message code="app.common.APPROVEBUTTON"/></button>
					<button type="button" id="rejectalertBenchMarkDtls${UNQID}" onclick = "rejectAlertBenchMarkDtls()" class="btn btn-primary btn-sm"><spring:message code="app.common.REJECTBUTTON"/></button>
					</c:if>
				</div>
			</div>
		</tbody>
	</table>
</div>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="java.util.*"%>
<%@ include file="../tags/tags.jsp"%>

<%
String contextPath = request.getContextPath()==null?"":request.getContextPath();
List<Map<String, Object>> businessObjects = (List<Map<String, Object>>) request.getAttribute("BUSINESSOBJECTS");
String message = (String) request.getAttribute("message");
String reportID = (String) request.getAttribute("reportID");
%>
    <HTML>
    	<head>
    	<title>Create New Report</title>
    		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<!--[if lt IE 9]>
	<script src="${pageContext.request.contextPath}/scripts/oldBuilds/html5shiv.js"></script>
	<script src="${pageContext.request.contextPath}/scripts/oldBuilds/html5shiv.min.js"></script>
	<script src="${pageContext.request.contextPath}/scripts/respond.min.js"></script>
<![endif]-->
<script type="text/javascript" src="${pageContext.request.contextPath}/includes/scripts/oldBuilds/jquery-1.9.1.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/includes/scripts/jquery-ui.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/includes/scripts/bootstrap.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/includes/scripts/jquery.dataTables.min.js"></script>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/includes/styles/bootstrap.min.css" />
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/includes/styles/oldBuilds/bootstrap-responsive.min.css" />
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/includes/styles/oldBuilds/dataTables.bootstrap.css" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/includes/styles/oldBuilds/jquery-ui.css"/>

<style type="text/css">
	body{
		font-size : 13px !important;
	}
	.table{
		font-size : 12px !important;
		}
</style>
<script type="text/javascript">
	$(document).ready(function(){
		 $("#BusinessObjectsTab").tab();
		 $("#setJoinButton").hide();
		 $("#setConditionButton").hide();
		 $("#setAggregateConditionButton").hide();
		 $("#builtJoin").hide();
		 $("#builtReportColumn").hide();
		 $("#builtConditionColumn").hide();
		 $("#builtAggregateConditionColumn").hide();
		 $("#reportSaveFooter").hide();
		 $("#reportParamDetails").hide();

		 $(document).keyup(function(evt){
			 var elm = evt.target;
			 var val = $(elm).val();
			 $(elm).attr("value",val);
		 });

		 $(document).change(function(evt){
			 var elm = evt.target;
			 var val = $(elm).val();
			 $(elm).children("option").each(function(){
				 if(val == $(this).attr("value")){
					 $(this).attr("selected","selected");
				 }else{
					 $(this).removeAttr("selected")
				 }
			 });
		//	 alert($(elm).children(':option[value='+val+']').html());
		 });
		 
		 var oTable = $("#businessObjects").dataTable({
			 "bInfo" : false,
		//	 "bFilter" : false,
			 "bSort" : false,
			 "bPaginate" : false
 		 });
		 $("#searchBO").keyup(function(){
			 $("#businessObjects_filter input").val(this.value);
			 $("#businessObjects_filter input").keyup();
	 	 });

	 	 $("#startCreateRule").click(function(){
		 	 var count = 0;
		 	 var values = "";
		 	 $("#JoinDisplay").html("Selected Objects : ");
		 	 $("#ConditionDisplay").html("Selected Objects : ");
		 	$("#AggregateConditionDisplay").html("Selected Objects : ");
		 	 $("#businessObjects > tbody > tr").each(function(){
		 		//alert($(this).children("td").children("input").val());
		 		var elm = $(this).children("td").children("input");
			 	if(elm.is(":checked")){
				 	count++;
				 	values = values + elm.val()+"|"
				 	$("#JoinDisplay").append(elm.val().split("^")[0]+", ");
				 	$("#ConditionDisplay").append(elm.val().split("^")[0]+", ");
				 	$("#AggregateConditionDisplay").append(elm.val().split("^")[0]+", ");
				 }
			 });
			 if(count > 1){
				 $("#setJoinButton").show();
				 $("#objectsForJoins").val(values);
			 }else{
				 $("#setJoinButton").hide();
				 $("#JoinDisplay").append("<br/><br/><b>Select another object to perform join</b>");
				 $("#objectsForJoins").val("");
			 }
			 
			 if(count > 0){
				 $("#setConditionButton").show();
				 $("#setAggregateConditionButton").show();
				 $("#reportParamDetails").show();
				 $("#objectsForConditions").val(values);
				 $("#objectsForAggregateConditions").val(values);
				 $("#columnsPanel").html("<div class='card-header'><h5 class='card-title'>Columns</h5></div><center><br/></br/>Loading...<br/><br/></center>");
				 $.ajax({
					 url : "${pageContext.request.contextPath}/admin/getAllObjectColumns?${_csrf.parameterName}=${_csrf.token}",
					 data : "value="+values,
					 type : "POST",
					 cache : false,	
					 success : function(resData){
						 $("#builtJoin").val("");
						 $("#builtReportColumn").val("");
						 $("#builtConditionColumn").val("");
						 $("#builtAggregateConditionColumn").val("");
						 $("#columnsPanel").html(resData);
						 $("ul > li:first").addClass("active");
						 $(".tab-content div:first").addClass("active");
					 },
					 error : function(a,b,c){
						 alert(a+"\n"+b+"\n"+c);
					 }
				 });
			 }else{
				 $("#setConditionButton").hide();
				 $("#setAggregateConditionButton").hide();
				 $("#reportParamDetails").hide();
				 alert("Select at least one object");
			 }
		 });

	 	 
	 		$("#setJoinButton").click(function(){
	 			if($("#builtJoin").val() == ""){
				 var objectsForJoin = $("#objectsForJoins").val();
				 $.ajax({
					 url : "${pageContext.request.contextPath}/admin/createJoinForm?${_csrf.parameterName}=${_csrf.token}",
					 data : "objectsForJoin="+objectsForJoin,
					 type : "POST",
					 cache : false,	
					 success : function(resData){
						 $("#setJoinModalDetails").html(resData);
					 },
					 error : function(a,b,c){
						 alert(a+"\n"+b+"\n"+c);
					 }
				 });
	 			}
			 });

		 $("#addJoinRow").click(function(){
			 var tbody = $("table#JoinDetailsTable > tbody");
			 var tr = $("table#JoinDetailsTable > tbody > tr:first").clone();
			 $(tbody).append("<tr>"+tr.html()+"</tr>");
		 });

		 $("#saveJoinRow").click(function(){
			 var message = "";
			 var value = "";
			 var tr = $("table#JoinDetailsTable > tbody > tr");
			 $(tr).each(function(indexTr){
				 var td = $(this).children("td");
				 $(td).each(function(indexTd){
					 var currVal = $(this).children().val();					 
					 var currRow = indexTr+1;
					 var currCol = indexTd+1;
					 if(indexTd != 8 && currVal == undefined){
						 value = value+"^";
					 }else if(indexTd != 8){
						 value = value+currVal+"^";
					 }					 
				 });
				 value = value+"|";
			 });

			 $.ajax({
				url : "${pageContext.request.contextPath}/admin/buildJoin?${_csrf.parameterName}=${_csrf.token}",
				data : "value="+escape(value),
				type : "POST",
				cache : false,	
				success : function(resData){
					$("#builtJoin").show();
					$("#builtJoin").val(resData);
				},
				error : function(a,b,c){
					alert(a+"\n"+b+"\n"+c);
				}
			 });
		 });

		 $("#addReportRow").click(function(){
			 var tbody = $("table#ReportColumnDetailsTable > tbody");
			 var tr = $("table#ReportColumnDetailsTable > tbody > tr:first").clone();
			 $(tbody).append("<tr>"+tr.html()+"</tr>");
		 });

		 $("#saveReportRow").click(function(){
			 var isValid = true;
			 var message = "";
			 var value = "";
			 var tr = $("table#ReportColumnDetailsTable > tbody > tr");
			 $(tr).each(function(indexTr){
				 var td = $(this).children("td");
				 $(td).each(function(indexTd){
					 var currVal = $(this).children().val();					 
					 var currRow = indexTr+1;
					 var currCol = indexTd+1;
					 if(indexTd != 3 && indexTd != 4 && (currVal == '' || currVal == undefined) && isValid){
						 message = "Please complete Row No : "+currRow+", Column No : "+currCol;
						 isValid = false;
					 }else if(indexTd != 4 && isValid){
						 isValid = true;
						 value = value+currVal+"^";
					 }
				 });
				 value = value+"|";
			 });

			 if(isValid){
				 $.ajax({
					 url : "${pageContext.request.contextPath}/admin/buildReportColumns?${_csrf.parameterName}=${_csrf.token}",
					 data : "value="+escape(value),
					 type : "POST",
					 cache : false,	
					 success : function(resData){
						 $("#builtReportColumn").show();
						 $("#builtReportColumn").val(resData);
						 $("a[href=#reportColumnDetails]").tab('show');
						 if(resData.trim().length > 0){
							 $("#reportSaveFooter").show();
						 }else{
							 $("#reportSaveFooter").hide();
						 }
					 },
					 error : function(a,b,c){
						 alert(a+"\n"+b+"\n"+c);
					 }
				 });
			 }else{alert(message);}
		 });

		 $("#setConditionButton").click(function(){
			 var objectsForConditions = $("#objectsForConditions").val();
			 var noOfParams = $("#noOfParams").val();
			 if($("#builtConditionColumn").val() == ""){
				 $.ajax({
					 url : "${pageContext.request.contextPath}/admin/createSetConditionForm?${_csrf.parameterName}=${_csrf.token}",
					 data : "objectsForConditions="+objectsForConditions+"&noOfParams="+noOfParams,
					 type : "POST",
					 cache : false,	
					 success : function(resData){
						 $("#setConditionModalDetails").html(resData);
					 },
					 error : function(a,b,c){
						 alert(a+"\n"+b+"\n"+c);
					 }
				 });
	 		}
		 });

		 $("#addConditionRow").click(function(){
			 var tbody = $("table#ConditionDetailsTable > tbody");
			 var tr = $("table#ConditionDetailsTable > tbody > tr:first").clone();
			 $(tr).children().each(function(indexTr){
				 if(indexTr == 5){
					 var datepickerelm = $(this).children();
					 $(datepickerelm).removeClass("datePicker");
					 $(datepickerelm).removeClass("hasDatepicker");
					 $(datepickerelm).attr("id","");
				 }
			 });
			 $(tbody).append("<tr>"+tr.html()+"</tr>");
		 });

		 $("#saveConditionRow").click(function(){
			 var message = "";
			 var value = "";
			 var tr = $("table#ConditionDetailsTable > tbody > tr");
			 
			 $(tr).each(function(indexTr){
				 var td = $(this).children("td");
				 $(td).each(function(indexTd){
					 var currVal = $(this).children().val();			 
					 var currRow = indexTr+1;
					 var currCol = indexTd+1; 
					 if(currVal == undefined){
						 currVal = "";
					 }
						 
					 if(indexTd != 11){
						 value = value+currVal+"^";
					 }
				 });
				 value = value+"|";
			 });
			 
			 $.ajax({
				 url : "${pageContext.request.contextPath}/admin/buildCondition?${_csrf.parameterName}=${_csrf.token}",
				 data : "value="+escape(value),
				 type : "POST",
				 cache : false,	
				 success : function(resData){
					 $("#builtConditionColumn").show();
					 $("#builtConditionColumn").val(resData);
				 },
				 error : function(a,b,c){
					 alert("Error occurred. Value and datatype could be a reason");
				 }
			 });
		 });

		 $("#setAggregateConditionButton").click(function(){
			 var objectsForAggregateConditions = $("#objectsForAggregateConditions").val();
			 var noOfParams = $("#noOfParams").val();
			 if($("#builtAggregateConditionColumn").val() == ""){
				 $.ajax({
					 url : "${pageContext.request.contextPath}/admin/createSetAggregateConditionForm?${_csrf.parameterName}=${_csrf.token}",
					 data : "objectsForAggregateConditions="+objectsForAggregateConditions+"&noOfParams="+noOfParams,
					 type : "POST",
					 cache : false,	
					 success : function(resData){
						 $("#setAggregateConditionModalDetails").html(resData);
					 },
					 error : function(a,b,c){
						 alert(a+"\n"+b+"\n"+c);
					 }
				 });
	 		}
		 });

		 $("#saveAggregateConditionRow").click(function(){
			 var isValid = true;
			 var message = "";
			 var groupVal = "";
			 var havingVal = "";
			 var groupTable = $("table#ACGroup > tbody > tr");
			 var havingTable = $("table#ACHaving > tbody > tr");

			 $(groupTable).each(function(indexTr){
				 if($(this).attr("style") != "display: none;"){
					 var groupTableTd = $(this).children("td");
					 $(groupTableTd).each(function(indexTd){
						 var currVal = $(this).children().val();			 
						 var currRow = indexTr+1;
						 var currCol = indexTd+1; 
						 if(indexTd != 2 && (currVal == '' || currVal == undefined) && isValid){						 
							 message = "Please complete Row No : "+currRow+", Column No : "+currCol+" of GROUP section";
							 isValid = false;
						 }else if(indexTd != 2 && isValid){
							 isValid = true;
							 groupVal = groupVal+currVal+"^";
						 }
					 });
					 groupVal = groupVal+"|";
				 }				 
			 });

			 $(havingTable).each(function(indexTr){
				 if($(this).attr("style") != "display: none;"){
					 var havingTableTd = $(this).children("td");
					 $(havingTableTd).each(function(indexTd){
						 var currVal = $(this).children().val();			 
						 var currRow = indexTr+1;
						 var currCol = indexTd+1; 
						 if(indexTd != 6 && indexTd != 7 && indexTd != 8 && (currVal == '' || currVal == undefined) && isValid){						 
							 message = "Please complete Row No : "+currRow+", Column No : "+currCol+" of HAVING section";
							 isValid = false;
						 }else if(indexTd != 8 && isValid){
							 isValid = true;
							 havingVal = havingVal+currVal+"^";
						 }
					 });
					 havingVal = havingVal+"|";
				 }				 
			 });
			 
			 if(isValid){
				 $.ajax({
					 url : "${pageContext.request.contextPath}/admin/buildAggregateCondition?${_csrf.parameterName}=${_csrf.token}",
					 data : "group="+escape(groupVal)+"&having="+escape(havingVal),
					 type : "POST",
					 cache : false,	
					 success : function(resData){
						 $("#builtAggregateConditionColumn").show();
						 $("#builtAggregateConditionColumn").val(resData);
					 },
					 error : function(a,b,c){
						 alert(a+"\n"+b+"\n"+c);
					 }
				 });
			 }else{alert(message);}
		 });

		 $("#setParametersButton").click(function(){
			 var noOfParams = $("#noOfParams").val();
			 var reportId = $("#reportId").val();
			var mywin = window.open("${pageContext.request.contextPath}/admin/setReportParameters?l_strNoOfParameters="+noOfParams+"&l_strReportID="+reportId,"Set/Manage_Parameters","height=500,width=1250,scrollbars=1,resizable=Yes");
		 	mywin.moveTo(10,02);
		 });

		$("#SaveReportFinal").click(function(){
			var objects = escape($("#objectsForConditions").val());
			var joinDetails = escape($("#builtJoin").val());
			var reportColumns = escape($("#builtReportColumn").val());
			var conditionDetails = escape($("#builtConditionColumn").val());
			var aggregateConditionDetails = escape($("#builtAggregateConditionColumn").val());
			var reportCode = escape($("#reportCode").val());
			var reportName = escape($("#reportName").val());
			var reportHeader = escape($("#reportHeader").val());
			var reportFooter = escape($("#reportFooter").val());
			var noOfParams = escape($("#noOfParams").val());
			var reportId = escape($("#reportId").val());
			var joinHtml = escape($("#setJoinModalDetails").html());
			var reportHtml = escape($("#setReportModalDetails").html());
			var ConHtml = escape($("#setConditionModalDetails").html());
			var aggrConHtml = escape($("#setAggregateConditionModalDetails").html());
			var objectConDetails = escape($("#objectsForAggregateConditions").val());
			
			var isEnable = $("#isEnable").is(":checked");
			
			if(reportColumns.trim().length > 0){
				if(reportCode.trim().length > 0){
					if(reportName.trim().length > 0){
						if(reportHeader.trim().length > 0 && reportFooter.trim().length > 0){
							var fullData =  "objects="+objects+"&joinDetails="+joinDetails+"&reportColumns="+reportColumns+
											"&conditionDetails="+conditionDetails+"&aggregateConditionDetails="+aggregateConditionDetails+
											"&reportCode="+reportCode+"&reportName="+reportName+"&reportHeader="+reportHeader+
											"&reportFooter="+reportFooter+"&isEnable="+isEnable+"&reportId="+reportId+"&noOfParams="+noOfParams+
											"&joinHtml="+joinHtml+"&reportHtml="+reportHtml+"&ConHtml="+ConHtml+"&aggrConHtml="+aggrConHtml+"&objectConDetails="+objectConDetails;
							$("#SaveReportFinal").html("Saving...");
							$("#SaveReportFinal").attr("disabled","disabled");
							$.ajax({
								url : "${pageContext.request.contextPath}/admin/saveReport?${_csrf.parameterName}=${_csrf.token}",
								type : "POST",
								cache : false,
								data : fullData,
								success : function(resData){
									if(resData == "Error occured while saving report!"){
										alert(resData);
									}else{
										if(reportId == resData){
											alert("Report successfully updated");
										}else{
											$("#reportId").val(resData);
											alert("Report successfully saved. Report ID : "+resData);
										}
									}
									$("#SaveReportFinal").html("Save");
									$("#SaveReportFinal").removeAttr("disabled");
								 },
								 error : function(a,b,c){
									 alert(a+"\n"+b+"\n"+c);
								 }
							});
						}else{
							alert("Enter report header and footer details");
						}
					}else{
						alert("Enter report name");
					}
				}else{
					alert("Enter report code");
				}
			}else{
				alert("No Report columns selected.");
			}
		});
	});	
</script>
<script type="text/javascript">
	function getReportColumns(){
		var reportColumns = "";
		var alreadySelected = $("#builtReportColumn").val().trim();
		var newAdded = false;
		var count = 0;
		$("#objectDetailPanel > div > div > table").each(function(index){
			var elm = $(this).children("tbody").children("tr").children("td");
			$(elm).each(function(indexTd){
				var checkBox = $(this).children("input[type='checkbox']");
				if(checkBox.is(":checked")){
					reportColumns = reportColumns + checkBox.val() +", ";
					count++;
					if(!newAdded && alreadySelected.indexOf(checkBox.val()) < 0){
						newAdded = true;
					}
				}
			});
		});
		
		if(count > 0){
			$("#setReportModal").modal('show');
			if(newAdded){
				var objects = $("#objectsForConditions").val();
				$("#setReportModalDetails").html("<br/><br/><center>Loading...</center><br/><br/>");
				$.ajax({
					url : "${pageContext.request.contextPath}/admin/builtReportColumnForm?${_csrf.parameterName}=${_csrf.token}",
					 data : "reportColumns="+reportColumns+"&objects="+objects,
					 type : "POST",
					 cache : false,	
					 success : function(resData){
						 $("#setReportModalDetails").html(resData);
					 },
					 error : function(a,b,c){
						 alert(a+"\n"+b+"\n"+c);
					 }
				});
			}
		}else{
			alert("Select at least one field");
		}		
	}

	function clearChecks(){
		$("#objectDetailPanel > div > div > table").each(function(index){
			var elm = $(this).children("tbody").children("tr").children("td");
			$(elm).each(function(indexTd){
				var checkBox = $(this).children("input[type='checkbox']");
				if(checkBox.is(":checked")){
					checkBox.prop('checked', false);
				}
			});
		});
		$("a[href=#reportColumnDetails]").tab('show');
		$("#builtReportColumn").val("");
		$("#builtReportColumn").hide();
	}

	function getLeftFields(elm){
		getFields(elm, 'left');
	}
	
	function getRightFields(elm){
		getFields(elm, 'right');
	}
	
	function getFields(elm, side){
		if(elm.value != ""){
			$(elm).parent("td").parent("tr").children("td#"+side+"ObjectFields").html("Loading...");
			$.ajax({
				 url : "${pageContext.request.contextPath}/admin/getObjectColumns?${_csrf.parameterName}=${_csrf.token}",
				 data : "objectName="+elm.value,
				 type : "POST",
				 cache : false,	
				 success : function(resData){
					 $(elm).parent("td").parent("tr").children("td#"+side+"ObjectFields").html(resData);
				 },
				 error : function(a,b,c){
					 alert(a+"\n"+b+"\n"+c);
				 }
			});
		}else{
			$(elm).parent("td").parent("tr").children("td#"+side+"ObjectFields").html("Select "+side+" object");
		}
	}

	function getConditionLeftFields(elm){
		getConditionFields(elm,'Left');
	}

	function getConditionRightFields(elm){
		getConditionFields(elm,'Right');
	}

	function getConditionFields(elm, side){
		if(elm.value != ""){
			$(elm).parent("td").parent("tr").children("td#condition"+side+"Fileds").html("Loading...");
			$.ajax({
				 url : "${pageContext.request.contextPath}/admin/getObjectColumns?${_csrf.parameterName}=${_csrf.token}",
				 data : "objectName="+elm.value,
				 type : "POST",
				 cache : false,	
				 success : function(resData){
					 $(elm).parent("td").parent("tr").children("td#condition"+side+"Fileds").html(resData);
				 },
				 error : function(a,b,c){
					 alert(a+"\n"+b+"\n"+c);
				 }
			});
		}else{
			$(elm).parent("td").parent("tr").children("td#condition"+side+"Fileds").html("Select object");
		}
	}

	function getReportFields(elm){
		if(elm.value != ""){
			$(elm).parent("td").parent("tr").children("td#reportFileds").html("Loading...");
			$.ajax({
				 url : "${pageContext.request.contextPath}/admin/getObjectColumns?${_csrf.parameterName}=${_csrf.token}",
				 data : "objectName="+elm.value,
				 type : "POST",
				 cache : false,	
				 success : function(resData){
					 $(elm).parent("td").parent("tr").children("td#reportFileds").html(resData);
				 },
				 error : function(a,b,c){
					 alert(a+"\n"+b+"\n"+c);
				 }
			});
		}else{
			$(elm).parent("td").parent("tr").children("td#reportFileds").html("Select object");
		}
	}

	function getACHavingFields(elm){
		if(elm.value != ""){
			$(elm).parent("td").parent("tr").children("td#ACHavingFileds").html("Loading...");
			$.ajax({
				 url : "${pageContext.request.contextPath}/admin/getObjectColumns?${_csrf.parameterName}=${_csrf.token}",
				 data : "objectName="+elm.value,
				 type : "POST",
				 cache : false,	
				 success : function(resData){
					 $(elm).parent("td").parent("tr").children("td#ACHavingFileds").html(resData);
				 },
				 error : function(a,b,c){
					 alert(a+"\n"+b+"\n"+c);
				 }
			});
		}else{
			$(elm).parent("td").parent("tr").children("td#ACHavingFileds").html("Select object");
		}
	}

	function getACGroupFields(elm){
		if(elm.value != ""){
			$(elm).parent("td").parent("tr").children("td#ACGroupFileds").html("Loading...");
			$.ajax({
				 url : "${pageContext.request.contextPath}/admin/getObjectColumns?${_csrf.parameterName}=${_csrf.token}",
				 data : "objectName="+elm.value,
				 type : "POST",
				 cache : false,	
				 success : function(resData){
					 $(elm).parent("td").parent("tr").children("td#ACGroupFileds").html(resData);
				 },
				 error : function(a,b,c){
					 alert(a+"\n"+b+"\n"+c);
				 }
			});
		}else{
			$(elm).parent("td").parent("tr").children("td#ACGroupFileds").html("Select object");
		}
	}
	
	function removeJoinRow(elm){
		var tbody = $("table#JoinDetailsTable > tbody > tr");
		if(tbody.length > 1){
			$(elm).parent().remove();
		}else{
			$("#builtJoin").val("");
			$('#setJoinModal').modal('hide');
		}
	}

	function removeConditionRow(elm){
		var tbody = $("table#ConditionDetailsTable > tbody > tr");
		if(tbody.length > 1){
			$(elm).parent().remove();
		}else{
			$("#builtConditionColumn").val("");
			$('#setConditionModal').modal('hide');
		}
	}

	function removeReportRow(elm){
		var tbody = $("table#ReportColumnDetailsTable > tbody > tr");
		if(tbody.length > 1){
			$(elm).parent().remove();
		}else{
			$("a[href=#reportColumnDetails]").tab('show');
			$("#builtReportColumn").val("");
			$('#setReportModal').modal('hide');
		}
	}

	function checkDatatype(elm){
		var elmVal = elm.value;
		var inputElm = $(elm).parent().next().children();
		if(elmVal == "DATE"){
			$(inputElm).addClass("datePicker");
			$(inputElm).datepicker({
				 dateFormat : "dd/mm/yy"
			 });
		}else{
			$(inputElm).removeClass("datePicker");
			$(inputElm).datepicker("destroy");
		}
	}

	function addACGroupRow(){
		 var tbody = $("table#ACGroup > tbody");
		 var tr = $("table#ACGroup > tbody > tr:first");
		 if($(tr).attr("style") == "display: none;"){
			 $(tr).removeAttr('style');
		 }else{
			 $(tbody).append("<tr>"+tr.html()+"</tr>");
		 }
	 }

	function addACHavingRow(){
		 var tbody = $("table#ACHaving > tbody");
		 var tr = $("table#ACHaving > tbody > tr:first");
		 if($(tr).attr("style") == "display: none;"){
			 $(tr).removeAttr('style');
		 }else{
			 var trClone = $("table#ACHaving > tbody > tr:first").clone();
			 $(trClone).children().each(function(indexTr){
				 if(indexTr == 5){
					 var datepickerelm = $(this).children();
					 $(datepickerelm).removeClass("datePicker");
					 $(datepickerelm).removeClass("hasDatepicker");
					 $(datepickerelm).attr("id","");
				 }
			 });
			 $(tbody).append("<tr>"+trClone.html()+"</tr>");
		 }		 
	 }

	function removeACGroup(elm){
		var tbody = $("table#ACGroup > tbody > tr");
		if(tbody.length > 1){
			$(elm).parent().remove();
		}else{
			$("#builtAggregateConditionColumn").val("");
			$('#setAggregateConditionModal').modal('hide');
		}
	}

	function removeACHaving(elm){
		var tbody = $("table#ACHaving > tbody > tr");
		if(tbody.length > 1){
			$(elm).parent().remove();
		}else{
			$(elm).parent().attr("style","display : none");
		}
	}

	function getColumnDatatype(elm){
		var inpElm = $(elm).parent().next().next().next().next().children();
		var inpVal = elm.value;
		var datepickerObj;
		$.ajax({
			url : "${pageContext.request.contextPath}/admin/getColumnsDatatype?${_csrf.parameterName}=${_csrf.token}",
			data : "value="+inpVal,
			type : "POST",
			cache : false,
			success : function(resData){
				if(resData.indexOf("DATE") >= 0 || resData.indexOf("TIMESTAMP") >= 0){
					$(inpElm).addClass("datePicker");
					datepickerObj = $(inpElm).datepicker({
						 dateFormat : "dd/mm/yy"
					 });
				}else{
					$(inpElm).removeClass("datePicker");
					$(inpElm).removeClass("hasDatepicker");
					$(inpElm).attr("id","");
					$(inpElm).datepicker("destroy");
				}
			},
			error : function(a,b,c){
				alert(a+"\n"+b+"\n"+c);
			}
		});
	}
</script>
<style type="text/css">
	.dataTables_filter{
		display: none;
	}
	textarea { 
	   width: 100%;
	    height: 100%;
	}
	.datePicker{
		background-image:url("${pageContext.request.contextPath}/includes/images/calendar.png");
		background-repeat:no-repeat;
		background-position: 98%;
	}
</style>
    	</head>    	
    	<body>
    <div class="card-body">
		<div class="row row-xs-height">
			<div class="col-xs-3" >
				<div class="card card-info">
					<div class="card-header">
					    <h5 class="card-title">Report Wizard</h5>
					</div>
					<div style="min-height:200px; max-height: 200px; overflow-y: auto;">
				    	<form class="form-horizontal" role="form">
					    	<table id="businessObjects" class="table table-striped table-bordered" cellspacing="0" width="100%">
					    		<%
					    		if(businessObjects != null && businessObjects.size() > 0){
					    		%>
					    		
					    		<thead>
					    			<tr>
					    				<td>
											  <input type="text" class="form-control input-sm" id="searchBO" placeholder="Search"/>
									
					    				</td>
					    			</tr>
					    		</thead>
					    		<tbody>
					    			<%
					    				for(int i = 0; i < businessObjects.size(); i++){
					    					Map<String, Object> bo = businessObjects.get(i);
					    			%>
					    			<tr>
						    			<td>
											<input type="checkbox" id="<%=bo.get("DISPLAYNAME")%>" value="<%=bo.get("TABLENAME")%>^<%=bo.get("DISPLAYNAME")%>"/>
											<label for="<%=bo.get("DISPLAYNAME")%>"><%=bo.get("DISPLAYNAME")%></label> 
						    			</td>
					    			</tr>
					    			<%  }  %>
					    		</tbody>
					    		<%}else{ %>
					    		<tr>
					    			<td>
										No objects found
					    			</td>
					    		</tr>
					    		<%} %>
							</table>
						</form>
					</div>
					<div class="card-footer" style="text-align: center;">
						<button type="button" class="btn btn-success btn-xs" id="startCreateRule">Start</button>
					</div>
				</div>
			</div>
			<div class="col-xs-9">
				<div class="card card-info" id="columnsPanel">
					<div class='card-header'>
						<h5 class='card-title'>Columns</h5>
					</div>
					<center><br/><br/>Please select the objects first<br/><br/></center>
				</div>
			</div>
		</div>
		<div class="row row-xs-height">
			<div class="col-xs-12">
				<div class="card card-info">
					<div role="tabpanel"  style="min-height:225px; max-height: 225px; overflow-y: auto;">
					  <ul class="nav nav-tabs" role="tablist" id="reportGenTab">
					    <li role="presentation" class="active">
					    	<a href="#joinDetails" aria-controls="joinDetails" role="tab" data-toggle="tab">Set Joins</a>
					    </li>
					    <li role="presentation">
					    	<a href="#reportColumnDetails" aria-controls="reportColumnDetails" role="tab" data-toggle="tab">Report Columns</a>
					    </li>
					    <li role="presentation">
					    	<a href="#parameterDetails" aria-controls="parameterDetails" role="tab" data-toggle="tab">Set Parameters</a>
					    </li>
					    <li role="presentation">
					    	<a href="#conditionColumnDetails" aria-controls="conditionColumnDetails" role="tab" data-toggle="tab">Condition Columns</a>
					    </li>
					    <li role="presentation">
					    	<a href="#aggregateConditionDetails" aria-controls="aggregateConditionDetails" role="tab" data-toggle="tab">Aggregate Conditions</a>
					    </li>
					  </ul>
					
					  <!-- Tab panes -->
					  <div class="tab-content">
					    <div role="tabpanel" class="tab-pane active" id="joinDetails">
					    	<div class="col-xs-4">
					    		<div style="vertical-align: middle; ">
					    			<input type="hidden" value="" id="objectsForJoins"/>
					    			<center>
					    				<br/>
						    			<div id="JoinDisplay">
						    				
						    			</div>
						    			<br/><br/>
						    			<button type="button" id="setJoinButton" class="btn btn-primary btn-sm" data-toggle="modal" data-target="#setJoinModal">
										  Create / Manage Join
										</button>
									</center>
					    		</div>
							</div>
							<div class="col-lg-8">
							<textarea class="form-control" rows="10" id="builtJoin"></textarea>
							</div>
					    </div>
					    <div role="tabpanel" class="tab-pane" id="reportColumnDetails">
					    	<textarea class="form-control" rows="10" id="builtReportColumn"></textarea>
					    </div>					    
					    <div role="tabpanel" class="tab-pane" id="parameterDetails">
					    	<div class="col-xs-6">
					    		<div style="vertical-align: middle;" id="reportParamDetails">
					    			<center>
					    				<br/>
						    			<br/><br/>
						    			<form class="form-inline" role="form">
										  	<div class="form-group">
										    	<div class="input-group">
										    		<label class="sr-only" for="noOfParams">Enter No of Parameters</label>
										      		<input type="text" id="noOfParams" name="noOfParams" class="form-control input-sm"/>
										    	</div>
										  	</div>
										  	<div class="form-group">
										    	<div class="input-group">
										      		<button type="button" id="setParametersButton" class="btn btn-primary btn-sm">
												  	Set / Manage Parameters
													</button>
										    	</div>
										  	</div>										  	
										</form>
									</center>
					    		</div>
							</div>
							<div class="col-lg-6">
							</div>
					    </div>
					    <div role="tabpanel" class="tab-pane" id="conditionColumnDetails">
					    	<div class="col-xs-4">
					    		<div style="vertical-align: middle; ">
					    			<input type="hidden" value="" id="objectsForConditions"/>
					    			<center>
					    				<br/>
						    			<div id="ConditionDisplay">
						    				
						    			</div>
						    			<br/><br/>
						    			<button type="button" id="setConditionButton" class="btn btn-primary btn-sm" data-toggle="modal" data-target="#setConditionModal">
										  Set / Manage Condition
										</button>
									</center>
					    		</div>
							</div>
							<div class="col-lg-8">
							<textarea class="form-control" rows="10" id="builtConditionColumn"></textarea>
							</div>
					    </div>
					    <div role="tabpanel" class="tab-pane" id="aggregateConditionDetails">
					    	<div class="col-xs-4">
					    		<div style="vertical-align: middle; ">
					    			<input type="hidden" value="" id="objectsForAggregateConditions"/>
					    			<center>
					    				<br/>
						    			<div id="AggregateConditionDisplay">
						    				
						    			</div>
						    			<br/><br/>
						    			<button type="button" id="setAggregateConditionButton" class="btn btn-primary btn-sm" data-toggle="modal" data-target="#setAggregateConditionModal">
										  Set / Manage Aggregate Condition
										</button>
									</center>
					    		</div>
							</div>
							<div class="col-lg-8">
							<textarea class="form-control" rows="10" id="builtAggregateConditionColumn"></textarea>
							</div>
					    </div>
					  </div>
					
					</div>
					<div class="card-footer" style="text-align: center;" id="reportSaveFooter">
						<button type="button" class="btn btn-success btn-xs" data-toggle="modal" data-target="#saveReportModal" id="saveReportDummy">Save Report</button>
						<button type="button" class="btn btn-info btn-xs">Generate Report</button>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div class="modal fade bs-example-modal-lg" id="setJoinModal" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
		<div class="modal-dialog modal-lg">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
				<h4 class="modal-title" id="myModalLabel">Set Join</h4>
			</div>
			<div class="modal-body" id="setJoinModalDetails" style="max-height: 400px; overflow-y: auto;">
				<br/><br/>
				<center>
				Loading...
				</center>
				<br/><br/>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-primary" id="addJoinRow">Add Row</button>
				<button type="button" class="btn btn-success" id="saveJoinRow">Save Joins</button>
				<button type="button" class="btn btn-danger" data-dismiss="modal">Close</button>
			</div>
		</div>
		</div>
	</div>
	
	<div class="modal fade bs-example-modal-lg" id="setReportModal" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
		<div class="modal-dialog modal-lg">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
				<h4 class="modal-title" id="myModalLabel">Set Report Columns</h4>
			</div>
			<div class="modal-body" id="setReportModalDetails" style="max-height: 400px; overflow-y: auto;">
				<br/><br/>
				<center>
				Loading...
				</center>
				<br/><br/>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-primary" id="addReportRow">Add Row</button>
				<button type="button" class="btn btn-success" id="saveReportRow">Save Report Columns</button>
				<button type="button" class="btn btn-danger" data-dismiss="modal">Close</button>
			</div>
		</div>
		</div>
	</div>
	
	<div class="modal fade bs-example-modal-lg" id="setConditionModal" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
		
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
				<h4 class="modal-title" id="myModalLabel">Set Condition</h4>
			</div>
			<div class="modal-body" id="setConditionModalDetails" style="max-height: 400px; overflow-y: auto;">
				<br/><br/>
				<center>
				Loading...
				</center>
				<br/><br/>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-primary" id="addConditionRow">Add Row</button>
				<button type="button" class="btn btn-success" id="saveConditionRow">Save Conditions</button>
				<button type="button" class="btn btn-danger" data-dismiss="modal">Close</button>
			</div>
		</div>
		
	</div>
	
	<div class="modal fade bs-example-modal-lg" id="setAggregateConditionModal" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
		<div class="modal-dialog modal-lg">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
				<h4 class="modal-title" id="myModalLabel">Set Aggregate Condition</h4>
			</div>
			<div class="modal-body" id="setAggregateConditionModalDetails" style="max-height: 400px; overflow-y: auto;">
				<br/><br/>
				<center>
				Loading...
				</center>
				<br/><br/>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-success" id="saveAggregateConditionRow">Save Aggregate Conditions</button>
				<button type="button" class="btn btn-danger" data-dismiss="modal">Close</button>
			</div>
		</div>
		</div>
	</div>
	
	<div class="modal fade bs-example-modal-lg" id="saveReportModal" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
		<div class="modal-dialog modal-lg">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
				<h4 class="modal-title" id="myModalLabel">Save Report</h4>
			</div>
			<div class="modal-body" id="saveReportModalDetails" style="max-height: 400px; overflow-y: auto;">
				<!-- 
				<br/><br/>
				<center>
				Loading...
				</center>
				<br/><br/>
				 -->
				 <table id='SaveReportTable' class='table table-striped table-bordered' cellspacing='0' width='100%'>
				 	<tbody>
				 		<tr>
				 			<td width="30%">Report Code</td>
				 			<td width="70%">
				 				<input type="hidden" id="reportId" value="<%=reportID%>"/>
				 				<input type="text" class='form-control input-sm' id="reportCode" name="reportCode"/> </td>
				 		</tr>
				 		<tr>
				 			<td>Report Name</td>
				 			<td><input type="text" class='form-control input-sm' id="reportName" name="reportName"/> </td>
				 		</tr>
				 		<tr>
				 			<td>Report Header</td>
				 			<td><input type="text" class='form-control input-sm' id="reportHeader" name="reportHeader"/> </td>
				 		</tr>
				 		<tr>
				 			<td>Report Footer</td>
				 			<td><input type="text" class='form-control input-sm' id="reportFooter" name="reportFooter"/> </td>
				 		</tr>
						<!--
				 		<tr>
				 			<td>Alert/Report</td>
				 			<td><input type="checkbox" name="isAlert" value="Y" id="isAlert"/>Is Alert
				 			<input type="checkbox" name="isReport" value="N" id="isReport"/>Is Report </td>
				 		</tr>
						-->
				 		<tr>
				 			<td>Is Enable</td>
				 			<td><input type="checkbox" name="isEnable" value="Y" id="isEnable" checked="checked"/> </td>
				 		</tr>
				 	</tbody>
				 </table>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-success" id="SaveReportFinal">Save Report</button>
				<button type="button" class="btn btn-danger" data-dismiss="modal">Close</button>
			</div>
		</div>
		</div>
	</div>
   </body>
    </html>

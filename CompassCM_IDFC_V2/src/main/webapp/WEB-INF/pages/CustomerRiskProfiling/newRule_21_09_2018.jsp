<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="java.util.*"%>
<%@ include file="../tags/tags.jsp"%>


<%
String contextPath = request.getContextPath()==null?"":request.getContextPath();
List<Map<String, Object>> businessObjects = (List<Map<String, Object>>) request.getAttribute("BUSINESSOBJECTS");
String message = (String) request.getAttribute("message");
String ruleID = (String) request.getAttribute("ruleID");
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
<script type="text/javascript"	src="${pageContext.request.contextPath}/includes/scripts/bootstrap-select.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/includes/scripts/jquery.dataTables.min.js"></script>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/includes/styles/bootstrap.min.css" />
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/includes/styles/bootstrap-select.min.css" />
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
		 $("#builtJoin").hide();
		 $("#builtReportColumn").hide();
		 $("#builtConditionColumn").hide();
		 $("#builtAggregateConditionColumn").hide();
		 $("#reportSaveFooter").hide();
		 $("#reportParamDetails").hide();

		/*  $(document).keyup(function(evt){
			 var elm = evt.target;
			 var val = $(elm).val();
			 $(elm).attr("value",val);
		 }); */

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

		 //when click on start button...
	 	 $("#startCreateRule").click(function(){
		 	 var count = 0;
		 	 var values = "";
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
				 $("#reportParamDetails").show();
				 $("#objectsForConditions").val(values);
				 $("#objectsForAggregateConditions").val(values);
				 $("#columnsPanel").html("<div class='card-header'><h5 class='card-title'>Columns</h5></div><center><br/></br/>Loading...<br/><br/></center>");
				 $.ajax({
					 url : "${pageContext.request.contextPath}/admin/getAllTableColumns?${_csrf.parameterName}=${_csrf.token}",
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
					 url : "${pageContext.request.contextPath}/admin/createRuleConditionForm?${_csrf.parameterName}=${_csrf.token}",
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
			 alert("hi");
			 var message = "";
			 var value = "";
			 var tr = $("table#ConditionDetailsTable > tbody > tr");
			 
			 $(tr).each(function(indexTr){
				 var td = $(this).children("td");
				 $(td).each(function(indexTd){
					 var currVal = $(this).find('input, select').val();
					 console.log(currVal);
					 var currRow = indexTr+1;
					 var currCol = indexTd+1; 
					 if(currVal == undefined){
						 currVal = "";
					 }
					console.log("index td = "+indexTd);	 
					 if(indexTd != 12){
						 if(Array.isArray(currVal)){
							 currVal = currVal.join(); 
						 }
						 value = value+currVal+"^";
					 }
				 });
				 value = value+"|";
			 });
			 
			 console.log(value);
			 console.log("select box value = "+$("#selectbox").val());
			 
			 $.ajax({
				 url : "${pageContext.request.contextPath}/admin/buildRules?${_csrf.parameterName}=${_csrf.token}",
				 data : "value="+escape(value),
				 type : "POST",
				 cache : false,	
				 success : function(resData){
					 $("#builtConditionColumn").show();
					 $("#builtConditionColumn").val(resData);
					 $("#reportSaveFooter").show();
				 },
				 error : function(a,b,c){
					 alert("Error occurred. Value and datatype could be a reason");
				 }
			 });
		 });
		 
		 
		
		 
		

		/*  $("#setParametersButton").click(function(){
			 var noOfParams = $("#noOfParams").val();
			 var ruleID = $("#ruleID").val();
			var mywin = window.open("${pageContext.request.contextPath}/admin/setReportParameters?l_strNoOfParameters="+noOfParams+"&l_strruleID="+ruleID,"Set/Manage_Parameters","height=500,width=1250,scrollbars=1,resizable=Yes");
		 	mywin.moveTo(10,02);
		 }); */

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
			var ruleID = escape($("#ruleID").val());
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
											"&reportFooter="+reportFooter+"&isEnable="+isEnable+"&ruleID="+ruleID+"&noOfParams="+noOfParams+
											"&joinHtml="+joinHtml+"&reportHtml="+reportHtml+"&ConHtml="+ConHtml+"&aggrConHtml="+aggrConHtml+"&objectConDetails="+objectConDetails;
							$("#SaveReportFinal").html("Saving...");
							$("#SaveReportFinal").attr("disabled","disabled");
							console.log(fullData);
							$.ajax({
								url : "${pageContext.request.contextPath}/admin/saveReport?${_csrf.parameterName}=${_csrf.token}",
								type : "POST",
								cache : false,
								data : fullData,
								success : function(resData){
									if(resData == "Error occured while saving report!"){
										alert(resData);
									}else{
										if(ruleID == resData){
											alert("Report successfully updated");
										}else{
											$("#ruleID").val(resData);
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
	


	function getConditionLeftFields(elm){
		getConditionFields(elm,'Left');
	}

	function getConditionRightFields(elm){
		getConditionFields(elm,'Right');
	}

	//hit when we select Object static/dynamic
	function getConditionFields(elm, side){
		if(elm.value != ""){
			$(elm).parent("td").parent("tr").children("td#condition"+side+"Fileds").html("Loading...");
			$.ajax({
				 url : "${pageContext.request.contextPath}/admin/getTableObjectColumns?${_csrf.parameterName}=${_csrf.token}",
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

	
	

	function removeConditionRow(elm){
		var tbody = $("table#ConditionDetailsTable > tbody > tr");
		if(tbody.length > 1){
			$(elm).parent().remove();
		}else{
			$("#builtConditionColumn").val("");
			$('#setConditionModal').modal('hide');
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
	
	
	
	//hit when we select column (fetch the column values..)
	function getCRPTableColumnValue(elm){
		let index =  elm.parentNode.cellIndex;
		index = index+2;
		let tableName = elm.value.split(".")[0];
		let columnName = elm.value.split(".")[1];
		$.ajax({
			url: "${pageContext.request.contextPath}/admin/getCRPTableColumnValue?${_csrf.parameterName}=${_csrf.token}",
			data : {tableName:tableName,columnName:columnName},
			type: "POST",
			success:function(resData){
				console.log( $(elm).closest("tr"));
				 $(elm).parent("td").parent("tr").children("td").eq(index).html(resData);
			},
			complete:function(){
				$("#selectbox").selectpicker();
				
			},
			error:function(err){
				console.log(err);
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
					    	<a href="#conditionColumnDetails" aria-controls="conditionColumnDetails" role="tab" data-toggle="tab">Condition Columns</a>
					    </li>
					  </ul>
					
					  <!-- Tab panes -->
					  <div class="tab-content">
					    <div role="tabpanel" class="tab-pane active" id="conditionColumnDetails">
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
					  </div>
					
					</div>
					<div class="card-footer" style="text-align: center;" id="ruleSaveFooter">
						<button type="button" class="btn btn-success btn-xs" data-toggle="modal" data-target="#saveReportModal" id="saveReportDummy">Save Rule</button>
					</div>
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
	
	
	<div class="modal fade bs-example-modal-lg" id="saveReportModal" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
		<div class="modal-dialog modal-lg">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
				<h4 class="modal-title" id="myModalLabel">Save Rules</h4>
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
				 			<td width="30%">Report id</td>
				 			<td width="70%">
				 				<input type="hidden" id="ruleID" value="<%=ruleID%>"/>
				 				<input type="text" class='form-control input-sm' id="ruleCode" name="ruleCode"/> </td>
				 		</tr>
				 		<tr>
				 			<td>Rule Name</td>
				 			<td><input type="text" class='form-control input-sm' id="ruleName" name="ruleName"/> </td>
				 		</tr>
				 		<tr>
				 			<td>Risk</td>
				 			<td>
								<select multiple class="form-control" id="risk">
							        <option>HIGH</option>
							        <option selected>Low</option>
							        <option>Medium</option>
							      </select>
				 			</td>
				 		</tr>
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

<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="java.util.*"%>
<%@ include file="../tags/tags.jsp"%>
<%
String contextPath = request.getContextPath()==null?"":request.getContextPath();
List<Map<String, Object>> businessObjects = (List<Map<String, Object>>) request.getAttribute("BUSINESSOBJECTS");
String message = (String) request.getAttribute("message");
String ruleID = (String) request.getAttribute("ruleID");
%>

<html>
	<head>
		<script type="text/javascript"	src="${pageContext.request.contextPath}/includes/scripts/jquery.js"></script>
		<script type="text/javascript"	src="${pageContext.request.contextPath}/includes/scripts/jquery-ui.js"></script>
		<script type="text/javascript"	src="${pageContext.request.contextPath}/includes/scripts/bootstrap.min.js"></script>
		<!--<script type="text/javascript"	src="${pageContext.request.contextPath}/includes/scripts/bootstrap-select.min.js"></script>-->
		
		<link rel="StyleSheet" type="text/css"	href="${pageContext.request.contextPath}/includes/styles/bootstrap.min.css" />
		<!--<link rel="StyleSheet" type="text/css"	href="${pageContext.request.contextPath}/includes/styles/bootstrap-select.min.css" />-->
				
		<style type="text/css">
			body{
				font-size : 13px !important;
			}
			.table{
				font-size : 12px !important;
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
	  <script type="text/javascript">
	  	$(document).ready(function(){
	  		$("#setRuleButton").hide();
	  		$("#ruleSaveFooter").hide();
	  		//$(".selectpicker").selectpicker();
	  		
	  		$("#ruleID").val('<%=ruleID%>');
			var ruleID = $("#ruleID").val();
			
			
			
			
			$("#businessObjects > tbody > tr").each(function(){
				var elm = $(this).children("td").children("input");
				$.ajax({
					 url : "${pageContext.request.contextPath}/admin/CRPobjectToSelect?${_csrf.parameterName}=${_csrf.token}",
					 data : "ruleID="+ruleID+"&objectName="+elm.val().split("^")[0],
					 type : "POST",
					 cache : false,	
					 success : function(resData){
						 if(resData == "y"){
							 elm.attr("checked","checked");
							 $("#startCreateRule").click();
						 }
					 },
					 error : function(a,b,c){
						 alert(a+"\n"+b+"\n"+c);
					 }
				 });
			});

	  		
	  		
	  		// when click on start button......
	  		$("#startCreateRule").click(function(){
	  			var count = 0;
	  			var values = "";
	  			$("#businessObjects > tbody > tr").each(function(){
			 		let elm = $(this).children("td").children("input");
				 	if(elm.is(":checked")){
					 	count++;
					 	values = values + elm.val()+"|"
					 }
				 });
				 if(count > 0){
					 $("#objectsForCustomerRiskProfileRule").val(values);
					 $.ajax({
						 url : "${pageContext.request.contextPath}/admin/getAllTableColumns?${_csrf.parameterName}=${_csrf.token}",
						 data : "value="+values,
						 type : "POST",
						 cache : false,	
						 success : function(resData){
							 $("#columnsPanel").html(resData);
							 $("ul > li:first").addClass("active");
							 $(".tab-content div:first").addClass("active");
							 $.ajax({
								 url : "${pageContext.request.contextPath}/admin/getCRPRulesDetails?${_csrf.parameterName}=${_csrf.token}",
								 data : "ruleID="+ruleID+"&section=RULE",
								 type : "POST",
								 cache : false,	
								 success : function(resData){
									 $("#builtRuleColumn").val(resData);
									 $("#ruleSaveFooter").show();
								 },
								 error : function(a,b,c){
									 alert(a+"\n"+b+"\n"+c);
								 }
							});
							 
							 $.ajax({
								 url : "${pageContext.request.contextPath}/admin/getCRPRulesDetails?${_csrf.parameterName}=${_csrf.token}",
								 data : "ruleID="+ruleID+"&section=RULEHTML",
								 type : "POST",
								 cache : false,	
								 success : function(resData){
									 $("#setRuleModalDetails").html(resData);
								 },
								 error : function(a,b,c){
									 alert(a+"\n"+b+"\n"+c);
								 }
							});
							 
							 $.ajax({
								 url : "${pageContext.request.contextPath}/admin/getCRPRulesDetails?${_csrf.parameterName}=${_csrf.token}",
								 data : "ruleID="+ruleID+"&section=ISENABLE",
								 type : "POST",
								 cache : false,	
								 success : function(resData){
									 if(resData == "Y"){
										 $("#isEnable").attr("checked","checked");
									 }else{
										 $("#isEnable").removeAttr("checked");
									 }
									 
								 },
								 error : function(a,b,c){
									 alert(a+"\n"+b+"\n"+c);
								 }
							});	
							 $.ajax({
								 url : "${pageContext.request.contextPath}/admin/getCRPRulesDetails?${_csrf.parameterName}=${_csrf.token}",
								 data : "ruleID="+ruleID+"&section=RISK",
								 type : "POST",
								 cache : false,	
								 success : function(resData){
									 $("#risk").val(resData);
								},
								 error : function(a,b,c){
									 alert(a+"\n"+b+"\n"+c);
								 }
							});
							 $.ajax({
								 url : "${pageContext.request.contextPath}/admin/getCRPRulesDetails?${_csrf.parameterName}=${_csrf.token}",
								 data : "ruleID="+ruleID+"&section=RULENAME",
								 type : "POST",
								 cache : false,	
								 success : function(resData){
									 $("#ruleName").val(resData);
								},
								 error : function(a,b,c){
									 alert(a+"\n"+b+"\n"+c);
								 }
							});
							 $.ajax({
								 url : "${pageContext.request.contextPath}/admin/getCRPRulesDetails?${_csrf.parameterName}=${_csrf.token}",
								 data : "ruleID="+ruleID+"&section=RULECODE",
								 type : "POST",
								 cache : false,	
								 success : function(resData){
									 $("#ruleCode").val(resData);
								},
								 error : function(a,b,c){
									 alert(a+"\n"+b+"\n"+c);
								 }
							});
							 
						 },
						 complete:function(){
							 $("#setRuleButton").show(); 
						 },
						 error : function(a,b,c){
							 alert(a+"\n"+b+"\n"+c);
						 }
				 	});
				 }
	  		});
	  		
	  		// when click on set rule 
	  		 $("#setRuleButton").click(function(){
				 var objectsForCustomerRiskProfileRule = $("#objectsForCustomerRiskProfileRule").val();
				 var noOfParams = $("#noOfParams").val();
				 if($("#builtRuleColumn").val() == ""){
					 $.ajax({
						 url : "${pageContext.request.contextPath}/admin/createRuleConditionForm?${_csrf.parameterName}=${_csrf.token}",
						 data : "objectsForConditions="+objectsForCustomerRiskProfileRule,
						 type : "POST",
						 cache : false,	
						 success : function(resData){
							 $("#setRuleModalDetails").html(resData);
						 },
						 error : function(a,b,c){
							 alert(a+"\n"+b+"\n"+c);
						 }
					 });
		 		}
			 });
	  		
	  		
	  	});
	  </script>
	</head>
	
	<body>
	<input type="hidden" value="" id="objectsForCustomerRiskProfileRule"/>
	<div class="card-body">
		<div class="row row-xs-height">
			<div class="col-xs-3" >
				<div class="card card-info">
					<div class="card-header">
					    <h5 class="card-title">Customer Risk Profiling</h5>
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
				<div class="card card-info" id="columnsPanel" style="margin-bottom:5px;">
					<div class='card-header'>
						<h5 class='card-title'>Columns</h5>
					</div>
					<center><br/><br/>Please select the Parameter Types<br/><br/></center>
				</div>
				<button type="button" id="setRuleButton" class="col-md-pull-8 btn btn-primary btn-sm" data-toggle="modal" data-target="#setRuleModal">
				  Set Rule
				</button>
			</div>
			
		</div>
		<div class="row row-xs-height">
			<div class="col-xs-12">
				<div class="card card-primary" id="CustomerRiskProfileTextArea" >
					<div class="card-header panelSlidingRiskRules${UNQID} clearfix">
						<h6 class="card-title pull-${dirL}">Generated Rule</h6>
					</div>
					<div class="card-body">
						<textarea class="form-control" rows="10" id="builtRuleColumn"></textarea>
					</div>
					<div class="card-footer" style="text-align: center;" id="ruleSaveFooter">
						<button type="button" class="btn btn-success btn-xs" data-toggle="modal" data-target="#saveFinalRUlesModal" id="openModalForFinalRule">Save Rule</button>
						<button type="button" class="btn btn-primary btn-xs" id="ValidateCRPRules">Validate Rule</button>
						<button type="button" class="btn btn-danger btn-xs" onclick="window.close()">Close</button>
					</div>
					
				</div>
			</div>
		</div>
	</div>
	<!-- modal for creating rules -->
	<div class="modal fade bs-example-modal-lg" id="setRuleModal" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
				<h4 class="modal-title" id="myModalLabel">Set Condition</h4>
			</div>
			<div class="modal-body"  style="max-height: 400px; overflow-y: auto;">
				<div class="scrollTable container-fluid" style="width: 3000px;">
				<div class="table-responsive" id="setRuleModalDetails">
					<br/><br/>
					<center>
					Loading...
					</center>
					<br/><br/>
				</div>
				</div>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-primary" id="addRuleRow">Add Row</button>
				<button type="button" class="btn btn-success" id="saveRuleRow">Save Rules</button>
				<button type="button" class="btn btn-danger" data-dismiss="modal">Close</button>
			</div>
		</div>
	</div>
	<!-- modal for savinf final rules... -->
		<div class="modal fade bs-example-modal-lg" id="saveFinalRUlesModal" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
		<div class="modal-dialog modal-lg">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
				<h4 class="modal-title" id="myModalLabel">Save Rules</h4>
			</div>
			<div class="modal-body" id="saveRUlesModalDetails" style="max-height: 400px; overflow-y: auto;">
				 <table id='SaveReportTable' class='table table-striped table-bordered' cellspacing='0' width='100%'>
				 	<tbody>
				 		<tr>
				 			<td width="30%">Rule Code</td>
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
								<select  class="form-control" id="risk">
							        <option>HIGH</option>
							        <option selected>MEDIUM</option>
							        <option>LOW</option>
							      </select>
				 			</td>
				 		</tr>
				 		<tr>
				 			<td>Is Enable</td>
				 			<td><input type="checkbox" name="isEnable" id="isEnable" checked="checked"/> </td>
				 		</tr>
				 	</tbody>
				 </table>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-success" id="SaveRulesFinal">Save CRP Rule</button>
				<button type="button" class="btn btn-danger" data-dismiss="modal">Close</button>
			</div>
		</div>
		</div>
	</div>
	
	
	</body>
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
				 $(elm).parent("td").parent("tr").children("td").eq(index).html(resData);
			},
			complete:function(){
			//	$("#selectpicker").selectpicker();
				
			},
			error:function(err){
				console.log(err);
			}
		});
	}
	
	//for adding new row for rule
	$("#addRuleRow").click(function(){
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
	//for removing rule
	function removeConditionRow(elm){
		var tbody = $("table#ConditionDetailsTable > tbody > tr");
		if(tbody.length > 1){
			$(elm).parent().remove();
		}else{
			$("#builtRuleColumn").val("");
			$('#setRuleModal').modal('hide');
		}
	}
	// for saving rules...
	
	$("#saveRuleRow").click(function(){
			 //alert("hi");
			 var message = "";
			 var value = "";
			 var tr = $("table#ConditionDetailsTable > tbody > tr");
			 
			 $(tr).each(function(indexTr){
				 var td = $(this).children("td");
				 $(td).each(function(indexTd){
					 var currVal = $(this).find('input, select').val();
					 var currRow = indexTr+1;
					 var currCol = indexTd+1; 
					 if(currVal == undefined){
						 currVal = "";
					 } 
					 if(indexTd != 12){
						 if(Array.isArray(currVal)){
							 currVal = currVal.join(); 
						 }
						 value = value+currVal+"^";
					 }
				 });
				 value = value+"|";
			 });
			 
			 $.ajax({
				 url : "${pageContext.request.contextPath}/admin/buildRules?${_csrf.parameterName}=${_csrf.token}",
				 data : "value="+escape(value),
				 type : "POST",
				 cache : false,	
				 success : function(resData){
					 if(resData['STATUS'] != false ){
					 $("#builtRuleColumn").show();
					 $("#ruleSaveFooter").show();
					 $("#builtRuleColumn").val(resData['RULE']);
					 $("#reportSaveFooter").show();
					 }else{
						 alert(resData['MESSAGE']);
					 }
					 
				 },
				 error : function(a,b,c){
					 alert("Error occurred. Value and datatype could be a reason");
				 }
			 });
		 });
	
	//for saving rule finally 
	$("#SaveRulesFinal").click(function(){
		let ruleID = $("#ruleID").val();
		let ruleName = $("#ruleName").val();
		let ruleCode = $("#ruleCode").val();
		let risk = $("#risk").val();
		let isEnable = $("#isEnable").val();
		if($("#isEnable").prop("checked")){
			isEnable = 'Y';
		}else{
			isEnable = 'N';
		} 
		let rule = $("#builtRuleColumn").val();
		let ruleConditionHTML = $("#setRuleModalDetails").html();
		let objects = $("#objectsForCustomerRiskProfileRule").val();
		$.ajax({
			url : "${pageContext.request.contextPath}/admin/saveCRPRules?${_csrf.parameterName}=${_csrf.token}",
			type : "POST",
			cache : false,
			data : {ruleID:ruleID,ruleName:ruleName,ruleCode:ruleCode,risk:risk,isEnable:isEnable,rule:rule,ruleConditionHTML:ruleConditionHTML,objects:objects},
			success:function(res){
				if(res == ruleID){
					alert("Rule has been saved.");
					$("#saveFinalRUlesModal").modal('toggle');
				}
			},
			error: function(err){
				console.log("Error while saving Customer Risk Profiling Rule.");
			}
		});
	});
	
	//for validating rules..
	$("#ValidateCRPRules").click(function(){
		let rule = $("#builtRuleColumn").val();
		$.ajax({
			url: "${pageContext.request.contextPath}/admin/validateCRPRules?${_csrf.parameterName}=${_csrf.token}",
			type : "POST",
			cache : false,
			data : {rule:rule},
			success:function(res){
				$("#ruleValidationDiv").show();
				$("#ruleValidationResult").val(res.RULERESULT.MESSAGE);
			},
			error: function(err){
				console.log("Error while Validating Customer Risk Profiling Rule.");
			}
		});
	});

</script>

</html>

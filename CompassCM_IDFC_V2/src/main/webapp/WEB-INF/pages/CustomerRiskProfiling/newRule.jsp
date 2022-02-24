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
		<%-- <script type="text/javascript"	src="${pageContext.request.contextPath}/includes/scripts/bootstrap-select.min.js"></script> --%>
		
		<link rel="StyleSheet" type="text/css"	href="${pageContext.request.contextPath}/includes/styles/bootstrap.min.css" />
		<%-- <link rel="StyleSheet" type="text/css"	href="${pageContext.request.contextPath}/includes/styles/bootstrap-select.min.css" /> --%>
				
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
			#ConditionDetailsTable >th, td{
				min-width: 100px;
			}
			/* .selectedColumnValues{
				height: 10px !important;
			} */
			
	  </style>
	  <script type="text/javascript">
	  	$(document).ready(function(){
	  		$("#setRuleButton").hide();
	  		$("#ruleSaveFooter").hide();
	  		//$(".selectpicker").selectpicker();
	  		
 	  		 $(document).keyup(function(evt){
				 var elm = evt.target;
				 var val = $(elm).val();
				 $(elm).attr("value",val);
			 });
			 
 	  		 $("#setRuleModal").on("change","select:not('.selectedColumnValues')",function(evt){ 
				  var elm = evt.target;
				 var val = $(elm).val();
				 $(elm).children("option").each(function(){
					 if(val == $(this).attr("value")){
						 $(this).attr("selected","selected");
					 }else{
						 $(this).removeAttr("selected")
					 }
				 }); 
			 }); 
	  		
			 $(document).on("change",".selectedColumnValues",function(){
				 let selecteValues = $(this).val();
				/*  console.log(selecteValues);
				 var selectedValuesAee = selecteValues.split(','); */
				 $(this).children("option").each(function(){
					let condition = selecteValues.includes($(this).val());
					if(condition){
						$(this).attr("selected","selected");
					}else{
						$(this).removeAttr("selected")
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
				 });//console.log(values);
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
						 },
						 complete:function(){
							 $("#setRuleButton").show(); 
						 },
						 error : function(a,b,c){
							 alert(a+"\n"+b+"\n"+c);
						 }
				 	});
				 }else{
					 alert("Select atleast an object to start.");
				 }
	  		});
	  		

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
	  		
	  		// when click on set rule 
	  		 $("#setRuleButton").click(function(){
				 var objectsForCustomerRiskProfileRule = $("#objectsForCustomerRiskProfileRule").val();
				 console.log(objectsForCustomerRiskProfileRule);
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
	  		
	  		// for saving rules...
	  		
	  		$("#saveRuleRow").click(function(){
	  				 var message = "";
	  				 var value = "";
	  				 var tr = $("table#ConditionDetailsTable > tbody > tr");
	  				 
	  				 $(tr).each(function(indexTr){
	  					 var td = $(this).children("td");
	  					 //alert("td = "+td);
	  					 $(td).each(function(indexTd){
	  						// alert(this);
	  						 var currVal = $(this).find('input, select').val();
	  						 //alert("currVal = "+currVal);
	  						 console.log(currVal);
	  						 var currRow = indexTr+1;
	  						 //alert("currRow = "+currRow);
	  						 var currCol = indexTd+1; 
	  						 //alert("currCol = "+currCol);
	  						 if(currVal == undefined){
	  							 currVal = "";
	  						 }
	  						console.log("index td = "+indexTd);	 
	  						 if(indexTd != 13){
	  							 if(Array.isArray(currVal)){
	  								 currVal = currVal.join(); 
	  							 }
	  							 value = value+currVal+"^";
	  						 }
	  					 });
	  					 value = value+"|";
	  				 });
	  				// alert(value);
	  				 $.ajax({
	  					 url : "${pageContext.request.contextPath}/admin/buildRules?${_csrf.parameterName}=${_csrf.token}",
	  					 data : "value="+escape(value),
	  					 type : "POST",
	  					 cache : false,	
	  					 success : function(resData){
	  						 if(resData.STATUS){
	  							 $("#builtRuleColumn").show();
	  							 $("#ruleSaveFooter").show();
	  							 $("#builtRuleColumn").val(resData.RULE);
	  							 $("#reportSaveFooter").show(); 
	  						 }else{
	  							 alert(resData.MESSAGE);
	  						 }
	  					 },
	  					 error : function(a,b,c){
	  						 //alert("Error occurred. Value and datatype could be a reason");
	  						 alert(a,b,c);
	  					 }
	  				 });
	  			 });
	  		
	  		//for saving rule finally 
	  		$("#SaveRulesFinal").click(function(){
	  	//		alert('as');
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
	  		//	alert(isEnable);
	  			$.ajax({
	  				url : "${pageContext.request.contextPath}/admin/saveCRPRules?${_csrf.parameterName}=${_csrf.token}",
	  				type : "POST",
	  				cache : false,
	  				data : {ruleID:ruleID,ruleName:ruleName,ruleCode:ruleCode,risk:risk,isEnable:isEnable,rule:rule,ruleConditionHTML:ruleConditionHTML,objects:objects},
	  				success:function(res){
	  					//console.log(res);
	  					if(res == ruleID){
	  						alert("The rule has been saved successfully.");
	  						$("#saveFinalRulesModal").modal('toggle');
	  					}
	  				},
	  				error: function(err){
	  					console.log("Error while saving rule.");
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
	  					console.log("Error while validating rules.");
	  				}
	  			});
	  		});
	  	});
	  	
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
  			if(elm.parentNode.id === "conditionLeftFileds"){
  				index = index+2;
  			}else if(elm.parentNode.id === "conditionRightFileds"){
  				index = index+3;
  			}
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
  					$(".selectpicker").selectpicker();
  				},
  				error:function(err){
  					console.log(err);
  				}
  			});
  		}
  		
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
										No object found
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
						<textarea class="form-control" rows="7" id="builtRuleColumn"></textarea>
					</div>
					<div class="card-footer" style="text-align: center;" id="ruleSaveFooter">
						<button type="button" class="btn btn-success btn-xs" data-toggle="modal" data-target="#saveFinalRulesModal" id="openModalForFinalRule">Save Rule</button>
						<button type="button" class="btn btn-primary btn-xs" id="ValidateCRPRules">Validate Rule</button>
						<button type="button" class="btn btn-danger btn-xs" onclick="window.close()">Close</button>
					</div>
					
				</div>
			</div>
			<div class="col-sm-offset-7 col-sm-4" id="ruleValidationDiv" style="display:none">
				<textarea class="form-control" rows="4" id="ruleValidationResult" style="border:2px solid red"></textarea>
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
		<div class="modal fade bs-example-modal-lg" id="saveFinalRulesModal" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
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
								<select  class="form-control riskRatingSelectBox" id="risk">
							        <option>HIGH</option>
							        <option >MEDIUM</option>
							        <option selected>LOW</option>
							      </select>
				 			</td>
				 		</tr>
				 		<tr>
				 			<td>Is Enable</td>
				 			<td>
				 				<input type="checkbox" name="isEnable" id="isEnable" checked="checked"/> 
				 			</td>
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

</html>

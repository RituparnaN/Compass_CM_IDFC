<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="java.util.*"%>
<%@ include file="../tags/tags.jsp"%>
<jsp:include page="../tags/staticFiles.jsp"/>
<html>
<head>
<style>
#ConditionDetailsTable tr:nth-child(odd) {
   /* border-top: 20px solid #337ab7;
  border-collapse: separate;
  border-spacing: 20px; */
}
#ConditionDetailsTable tr:nth-child(even) {
  /* border-bottom: 3px solid #337ab7;
  border-collapse: separate; */
}
.btn-icon{
	background-color: transparent;
    border-color: transparent;
    box-shadow: none;
}

.coloured-icon{
	color: #337ab7;
	font-size: 20px;
}

 .customTable{
	border: 1px solid #ddd;
	box-shadow: 0 0 0 1px #337ab7;
	border-radius: 4px;
} 

 .labelFont{
	font-size: 14px;
} 
</style>
</head>
<body style="margin:5px; overflow-y: scroll;">
	<div class="card card-default card-primary" >
		<div class="card-header" id="createRulePanelHeader" style="cursor:pointer;">Update Risk Rating Rule</div>
			<div class="card-body" id="setRulePanelDiv" style="max-height:80%; overflow-y:auto; display: none;">
			</div>	
			<div class="card-footer clearfix">
				<div class="pull-${dirR}">
					<button type="button" class="btn btn-icon" id="addRuleRow" title="Add Row">
						<span><i class="fa fa-plus coloured-icon" aria-hidden="true"></i></span>
					</button>
					<button type="button" class="btn btn-icon" id="viewRuleRow" title="Show/Hide Rule" >
						<span><i class="glyphicon glyphicon-eye-close coloured-icon" aria-hidden="true"></i></span>
					</button>
					<button type="button" class="btn btn-icon" id="validateCRPRules" title="Validate Rule">
						<span><i class="glyphicon glyphicon-check coloured-icon" aria-hidden="true"></i></span>
					</button>
					<button type="button" class="btn btn-icon" data-toggle="modal" id="openModalForFinalRule" title="Save Rule">
						<span><i class="glyphicon glyphicon-floppy-saved coloured-icon" aria-hidden="true"></i></span>
					</button>
					<!-- <button type="button" class="btn btn-icon" data-toggle="modal" data-target="#saveFinalRulesModal" id="openModalForFinalRule" title="Save Rule">
						<span><i class="glyphicon glyphicon-floppy-saved coloured-icon" aria-hidden="true"></i></span>
					</button> -->
					<button type="button" class="btn btn-icon" onclick="window.close()" title="Close Window">
						<span><i class="fa fa-remove coloured-icon" aria-hidden="true"></i></span>
					</button>
				</div>
			</div>
	</div>
	<div class="card card-default card-primary" style="display:block;" id = "createdRulePanel">
		<div class="card-header">Created Rule</div>
		<div class="card-body" >
			<textarea class="form-control" id="createdRuleTextArea" name = "createdRuleTextArea" ></textarea>
		</div>
		<%-- <div class="card-footer clearfix">
			<div class="pull-${dirR}">
				<button type="button" class="btn btn-danger" onclick="window.close()">Close</button>
			</div>
		</div> --%>
	</div>
	
<!-- modal for saving final rules... -->
		<div class="modal fade bs-example-modal-lg" id="saveFinalRulesModal" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
		<div class="modal-dialog modal-lg">
		<div class="card card-default card-primary ">
			<div class="card-header ">
				<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
				<h4 class="modal-title" id="myModalLabel">Save Rules</h4>
			</div>
			<div class="card-body" id="saveRUlesModalDetails" style="max-height: 400px; overflow-y: auto;">
				 <table id='SaveReportTable' class='table table-striped table-bordered' cellspacing='0' width='100%'>
				 	<tbody>
				 		<tr>
				 			<td width="30%">Rule Code</td>
				 			<td width="70%">
				 				<input type="hidden" id="ruleID" value="${ruleID}"/>
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
	
<!-- for showing validation error/success message -->
<div class="modal fade bs-example-modal-lg" id="validationMessage" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
	<div class="modal-dialog modal-lg">
	<div class="modal-content">
		<div class="modal-header">
			<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
			<h4 class="modal-title" id="validationModalLabel">Validation Message</h4>
		</div>
		<div class="modal-body"  style="max-height: 400px; overflow-y: auto;">
			<textarea rows="5" class="form-control" id="validationMessageTextarea"></textarea>
		
		</div>
	</div>
	</div>
</div>
	
<!-- for cloning below div  -->
<table style="display:none" id="cloningTable">
	<tr class="collapseRow" style="height: 10px; background-color: #337ab7; cursor: pointer;"><td colspan="5"></td></tr>
	<tr>
		<td width="5%">
			<select class="form-control input-sm conOperatorKeyword" name = "condtionOperator" style="width: auto;">
				<option>Select</option>
				<option value="WHEN">WHEN</option>
				<option value="AND">AND</option>
				<option value="OR">OR</option>
			</select>
			<!-- <label class="checkbox-inline"><input class="conOperatorKeyword" type="checkbox" name = "condtionOperator" value="WHEN">WHEN</label>
			<label class="checkbox-inline"><input class="conOperatorKeyword" type="checkbox" name = "condtionOperator" value="AND">AND</label>
			<label class="checkbox-inline"><input class="conOperatorKeyword" type="checkbox" name = "condtionOperator" value="OR">OR</label> -->
			<!-- <p  class="display-4 deleteRows" style="float:right;color:red;cursor: pointer;">Delete</p> -->
		</td>
		<td width="20%" >
			<select class="form-control input-sm leftObject" onchange="getLeftObjectColumns(this)" style="margin-bottom:15px;">
			 	<option>Select Object</option>
				<c:forEach var = "objects" items = "${BUSINESSOBJECTS}">
					<option value = "${objects.TABLENAME}">${objects.DISPLAYNAME} </option>
				</c:forEach>
			 </select>
		</td>
		<td width="28%" >
			<select class="form-control">
				<option>Operators</option>
				<option value='='> = </option>
				<option value='<>'> <> </option>
				<option value='>'> > </option>
				<option value='<'> < </option>
				<option value='>='> >= </option>
				<option value='<='> <= </option>
				<option value='+'> + </option>
				<option value='-'> - </option>
				<option value='/'> / </option>
				<option value='*'> * </option>
				<option value='LIKE'> LIKE </option>
				<option value='NOT LIKE'> NOT LIKE </option>
				<option value='IN'>IN</option>
				<option value='NOT IN'>NOT IN</option>
			</select>
			<br>
				<label class="btn btn-sm btn-default form-check-label" >
				<input class="form-check-input objValCheckBox" type="checkbox" id= "staticValueCheckBox"  name = "objectValueCheckBox" value="StaticValue">
				Static Value</label>
				&nbsp;&nbsp;
				<label class="btn btn-sm btn-default form-check-label" >
				<input class="form-check-input objValCheckBox" type="checkbox" id="subParamCheckBox" name = "objectValueCheckBox"  value="Sub-Parameters" checked="checked">
				Sub-Parameter</label>
				&nbsp;&nbsp;
				<label class="btn btn-sm btn-default form-check-label" >
				<input class="form-check-input objValCheckBox" type="checkbox" id="rightObjectCheckBox" name = "objectValueCheckBox"  value="RightObject">
				Right Object</label>
		</td>
		<td width="40%">
			<div class="leftObjectFiledValueDiv"></div>
			<div class="rightObjectAndFFieldsDIv" style="display:none">
				<select class="form-control rightObject" onchange="getRightObjectColumns(this)" style="margin-bottom:15px;">
				 	<option>Select Object</option>
						<c:forEach var = "objects" items = "${BUSINESSOBJECTS}">
							<option value = "${objects.TABLENAME}">${objects.DISPLAYNAME} </option>
						</c:forEach>
			 	</select>
			</div>
			<div class="staticValuesDiv" style="display:none">
				<input type="text" class="form-control staticValue" name="staticValue"/>
			</div>
		</td>
		<td width="2%" style="text-align:center;">
			<button type="button" class="btn btn-icon deleteRows" title="Delete" style="color:#f86767; padding: 5px 0 0 0;">
				<span><i class="glyphicon glyphicon-trash" aria-hidden="true"></i></span>
			</button>
		</td>
	</tr>
</table>
	
</body>
<script type ="text/javascript">
var ruleID = "${ruleID}";
var CRPRuleStatus = "${CRPRuleStatus}";

$.ajax({
	url : "${pageContext.request.contextPath}/admin/getRuleDetails?${_csrf.parameterName}=${_csrf.token}",
	data : "CRPRuleStatus="+CRPRuleStatus+"&ruleID="+ruleID,
	type : "POST",
	cache : false,	
	success : function(resData){
		if(resData["STATUS"]){
			 $("#setRulePanelDiv").html(resData["RULEHTML"]);
			// $("#createdRulePanel").show();
			 $("#createdRuleTextArea").val(resData["RULE"]);
			 $("#risk").val(resData["RISK"]);
			 if(resData["ISENABLE"] == "Y"){
				 $("#isEnable").attr("checked","checked");
			 }else{
				 $("#isEnable").removeAttr("checked");
			 }
			 $("#ruleName").val(resData["RULENAME"]);
			 $("#ruleCode").val(resData["RULECODE"]);
		}else{
			alert(resData["MESSAGE"]);
		}
	},complete:function(){
		/*  var tr = $("table#ConditionDetailsTable > tbody > tr");
		 tr.each(function(indexTr){
			if(indexTr % 2 != 0){
				let selectBox = $(this).find('td').eq(1).children().eq(1);
				let selectBoxVal = $(selectBox).val();
				var selValue = $(this).find('td').eq(1).children().eq(1);
				var div =  $(this).find('td').eq(3).find(".leftObjectFiledValueDiv");
				console.log($(div).closest(".selectedColumnValues").children("option:selected").attr('value'));
				console.log($(div).closest(".selectedColumnValues select").val());
				if($(div).is(":visible")){
					
				}
				//selectBox.val(selectBoxVal).trigger("change");
				
			}
		}); */ 
	},
	error : function(a,b,c){
	 alert(a+"\n"+b+"\n"+c);
	}
});

$(document).keyup(function(evt){
	 var elm = evt.target;
	 var val = $(elm).val();
	 $(elm).attr("value",val);
});
$("#setRulePanelDiv").on("change","select:not('.selectedColumnValues')",function(evt){ 
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
 
 function getLeftObjectColumns(elm){
		getObjectColumns(elm,'LEFT');
	};
	function getRightObjectColumns(elm){
		getObjectColumns(elm,'RIGHT');
	};
	
	function getObjectColumns(elm,side){
		if(elm.value != ""){
			var str = "<select class='form-control input-sm' onchange='getCRPTableColumnValue(this)' >";
			str += "<option value=''>Select</option>";
			$.ajax({
				 url : "${pageContext.request.contextPath}/admin/getTableColumns?${_csrf.parameterName}=${_csrf.token}",
				 data : "objectName="+elm.value,
				 type : "POST",
				 cache : false,	
				 success : function(resData){
					 $.each(resData,function(k,v){
						 if(elm.value == "TB_CRP_STATIC_PARAMETERS"){
							 str += "<option value= TB_CRP_STATIC_SUB_PARAMETERS."+k+">"+v+"</option>";
						 }else if(elm.value == "TB_CRP_DYNAMIC_PARAMETERS"){
							str += "<option value= TB_CRP_DYNAMIC_SUB_PARAMETERS."+k+">"+v+"</option>"; 
						 }
					 });
					 str += "</select>";
					// console.log(str);
					 $(elm).next().remove();
					 $(elm).parent().append(str);
					//$(elm).parent("td").parent("tr").children("td#condition"+side+"Fileds").html(resData);
				 },
				 error : function(a,b,c){
					 alert(a+"\n"+b+"\n"+c);
				 }
			});
		}else{
			$(elm).parent("td").parent("tr").children("td#condition"+side+"Fileds").html("Select object");
		}
	}


	//for showing/hinding stativ val,right Object and right field
	$(document).on("click",".objValCheckBox",function() {
		let elm = $(this);
		$(this).closest('td').find('input').not(this).prop('checked', false); 
		$(this).attr("checked","checked");
		let checkBoxVal = $(this).val();
		elm.closest('td').next('td').children().hide();
		if(checkBoxVal === "StaticValue"){
			elm.closest('td').next('td').find('.staticValuesDiv').show();
		}else if(checkBoxVal === "Sub-Parameters"){
			elm.closest('td').next('td').find('.leftObjectFiledValueDiv').show();
		}else if(checkBoxVal === "RightObject"){
			elm.closest('td').next('td').find('.rightObjectAndFFieldsDIv').show();
		}
		
	});	
	
	
	//for getting crp table column values after clicking on fileds
	function getCRPTableColumnValue(elm){
		let tableName = elm.value.split(".")[0];
		let columnName = elm.value.split(".")[1];
		var str = "<select class='form-control selectedColumnValues selectpicker' name='columnValues' id='columnValues' multiple='multiple' style='height:80px; overflow: auto;'>";
		//str += "<option value=''>Select</option>";
		$.ajax({
			url: "${pageContext.request.contextPath}/admin/getTableColumnValue?${_csrf.parameterName}=${_csrf.token}",
			data : {tableName:tableName,columnName:columnName},
			type: "POST",
			success:function(resData){
				//console.log(resData);
				$.each(resData,function(k,v){
					str += "<option value='"+k+"'>"+v+"</option>";
				});
				str += "</select>";
				//console.log("checking...");
				//console.log($(elm).closest("tr").find("td").eq(3).find(".leftObjectFiledValueDiv"));
				$(elm).closest("tr").find("td").eq(3).find(".leftObjectFiledValueDiv").children().remove();
				$(elm).closest("tr").find("td").eq(3).find(".leftObjectFiledValueDiv").append(str);
			},
			complete:function(){
				$(".selectpicker").selectpicker('refresh');
			},
			error:function(err){
				alert(err);
				//console.log(err);
			}
		});
	};
	
	//open modal for saving rule
	$("#openModalForFinalRule").click(function(){
		if($("#createdRulePanel").css("display") == "none"){
			alert("Please view the created rule prior to saving.");
		}else{
			$("#saveFinalRulesModal").modal("show");
		}
	});
	
	//for creating rule string
	$("#viewRuleRow").click(function(){
		 var tr = $("table#ConditionDetailsTable > tbody > tr");
		 var check = true;
		 var conditionOp = "";
		 var fieldName = "";
		 var operator = "";
		 var rightObjFieldOrValue = "";
		 var rule = "";
		 $(tr).each(function(indexTr){
			if(indexTr % 2 != 0){
				var td = $(this).children("td");
				$(td).each(function(indexTd){
					if(indexTd == 0){	
						conditionOp = $(td).find('select[name=condtionOperator] option:selected').val();
						if(conditionOp != "" && conditionOp != null && conditionOp != "Select"){
							rule += "  "+conditionOp;
						}
					}else if(indexTd == 1){
						if($(this).children().eq(1).val() != "" && $(this).children().eq(1).val() != null){
							fieldName = $(this).children().eq(1).val();
						}else{fieldName = "";}
					}else if(indexTd == 2){
						if($(this).children().eq(0).val() == "Operators" && conditionOp != "THEN"){
							alert("Please Select the Operator.");
							check = false;
						}else{
							if($(this).children().eq(0).val() != "Operators"){
								operator = $(this).children().eq(0).val();
								if(indexTr == 1){
									$("#setRulePanelDiv").slideToggle(800);
								}
							}else{operator = "";}
						}
					 }else if(indexTd == 3){
						 let visibleDiv = $(this).find("div:visible");
						 if(visibleDiv.attr('class') == "rightObjectAndFFieldsDIv"){
							rightObjFieldOrValue = visibleDiv.children().eq(1).val();
						 }else if(visibleDiv.attr('class') == "leftObjectFiledValueDiv"){
							rightObjFieldOrValue = visibleDiv.find(".selectedColumnValues select").val();
							rightObjFieldOrValue = formatQueryAccOperator(operator,rightObjFieldOrValue,fieldName);
							//alert(rightObjFieldOrValue);
						 }else{
							rightObjFieldOrValue = visibleDiv.children().eq(0).val();
							rightObjFieldOrValue = formatQueryAccOperator(operator,rightObjFieldOrValue,fieldName);
						 }
					 }
				});
			
			rule += "  "+fieldName+" "+ operator+" "+rightObjFieldOrValue;
			//alert(rule);
			}
		});
		 if(!check){
			 return false; 
		 }
		 
		 $("#createdRulePanel").toggle();
		 $("#createdRuleTextArea").val("");
		 $("#createdRuleTextArea").val(rule);
	});
	
	//for adding new row 
	$("#addRuleRow").click(function(){
		$("#ConditionDetailsTable").append($("#cloningTable").children().clone());
	});
	
	//for formatting rule query according operator
	function formatQueryAccOperator(op,val,fieldName){
		//console.log(op+"  "+val);
		let valArr = val.toString().split(',');
		let str = "";
		if(op == "IN" || op == "NOT IN"){
			str += " ( ";
			for(var i = 0; i<valArr.length; i++ ){
				str +=  "'"+valArr[i]+"'";
				if(i != valArr.length-1){
					str += " , "; 
				}
			}
			str += " ) ";
		}else if(op == "LIKE" || op == "NOT LIKE"){
			str += "'%"+val+"%'";
		}else if (op == "/"){
			str += val;
		}else{
			if(fieldName.includes("STATIC")){
				str +=  "'"+val+"'";
			}else{
				str += val;
			}
		}
		
		//console.log(op+" "+str);
		return str;
	};
	
	//for deleting rows
	$(document).on("click",".deleteRows",function() {
		$(this).closest('tr').prev().remove();
		$(this).closest('tr').remove();
	});
	
	//for Saving Final Rule
	$("#SaveRulesFinal").click(function(){
	  	var ruleID = $("#ruleID").val();
	  	var ruleName = $("#ruleName").val();
	  	var ruleCode = $("#ruleCode").val();
	  	var risk = $("#risk").val();
	  	var isEnable = $("#isEnable").val();
	  	
	  	if($("#isEnable").prop("checked")){
	  		isEnable = 'Y';
	  	}else{
	  		isEnable = 'N';
	  	} 
	  	let rule = $("#createdRuleTextArea").val().trim();
		let ruleConditionHTML = $("#setRulePanelDiv").html();
		//	alert(isEnable);
		$.ajax({
			url : "${pageContext.request.contextPath}/admin/saveRules?${_csrf.parameterName}=${_csrf.token}",
			type : "POST",
			cache : false,
			data : {ruleID:ruleID,ruleName:ruleName,ruleCode:ruleCode,risk:risk,isEnable:isEnable,rule:rule,ruleConditionHTML:ruleConditionHTML},
			success:function(res){
				//console.log(res);
				if(res == ruleID){
					alert("The rule has been saved successfully.");
					$("#saveFinalRulesModal").modal('toggle');
				}
			},
			error: function(err){
				alert(err);
				//console.log("Error while saving rule.");
			}
		});
	});
	
	//validate rule
	$("#ValidateCRPRules").click(function(){
		if($("#createdRulePanel").css("display") == "none"){
			alert("Please view the created rule prior to validating.");
		}else{
		  	var rule = $("#createdRuleTextArea").val().trim();
		  	$.ajax({
		  		url: "${pageContext.request.contextPath}/admin/validateCRPRules?${_csrf.parameterName}=${_csrf.token}",
		  		type : "POST",
		  		cache : false,
		  		data : {rule:rule},
		  		success:function(res){
		  			//alert(res.RULERESULT.MESSAGE);
		  			$("#validationMessage").modal();
		  			$("#validationMessageTextarea").val(res.RULERESULT.MESSAGE);
		  		},
		  		error: function(err){
		  			alert("Error while validating rules.");
		  		}
		  	});
		}
	 });
	
	$(document).on("click",".collapseRow",function(e) {
		//alert('as');
		$(this).closest("tr").next().slideToggle(800);
	});
	
	
	$("#createRulePanelHeader").click(function(){
		$("#setRulePanelDiv").slideToggle(800);
	});

</script>
</html>
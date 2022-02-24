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
 .resizeTextarea{
 	resize: vertical;
} 

</style>
</head>
<body style="margin:5px; overflow-y: scroll;">
	<div class="card card-default card-primary" >
		<div class="card-header" id="createRulePanelHeader" style="cursor:pointer;">Update Risk Rating Rule</div>
			<div class="card-body" id="setRulePanelDiv" style="max-height:80%; overflow-y:auto;">
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
			<textarea class="form-control input-sm resizeTextarea" id="createdRuleTextArea" name = "createdRuleTextArea" disabled="disabled"></textarea>
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
				<h4 class="modal-title" id="myModalLabel">Update Rule</h4>
			</div>
			<p  class="text-info" id  = "validationMessageDuringSaving" style="padding-left: 10px;padding-top: 10px;"></p>
			<div class="card card-default card-primary" style="margin: 10px 10px 10px 10px;">
			<div class="card-body" id="saveRulesModalDetails" style="max-height: 400px; overflow-y: auto; padding: 0;">
				 <table id='SaveReportTable' class='table table-striped'>
				 		<tr>
				 			<td width="20%">Rule Code</td>
				 			<td width="25%">
				 				<input type="hidden" id="ruleID" value="${ruleID}"/>
				 				<input type="text" class='form-control input-sm' id="ruleCode" name="ruleCode" disabled="disabled"/>
				 			 </td>
				 			 <td width="10%"></td>
				 			 <td width="20%">Rule Name</td>
				 			 <td width="25%"><input type="text" class='form-control input-sm' id="ruleName" name="ruleName"/></td>
				 		</tr>
				 		<tr>
				 			<td width="20%">Risk</td>
				 			<td width="25%">
								<select  class="form-control riskRatingSelectBox" id="risk">
							        <option>HIGH</option>
							        <option >MEDIUM</option>
							        <option selected>LOW</option>
							      </select>
				 			</td>
				 			<td width="10%"></td>
				 			<td width="20%">Is Enabled</td>
				 			<td width="25%">
				 				<input type="checkbox" name="isEnabled" id="isEnabled" checked="checked"/> 
				 			</td>
				 			
				 		</tr>
				 		<tr>
				 			<td width="20%">Maker Comment</td>
				 			<td width="25%">
				 				<textarea class="form-control input-sm resizeTextarea" id ="previousMakerComment" rows="2" disabled></textarea></td>
				 			<td width="10%"></td>
				 			<td width="20%">Rule For</td>
				 			<td width="25%">
				 				<select class="form-control input-sm" id="CRPRuleFor">
				 					<option value="" >Select Rule For</option>
				 					<option value = "SET_A">SET_A</option>
				 					<option value = "SET_B">SET_B</option>
				 				</select>
				 			</td>
				 		</tr>
				 		<tr id="checkCommentTr" style="display:none;">
				 			<td width="20%">Checker Comment</td>
				 			<td colspan="4"><textarea class="form-control input-sm resizeTextarea" id ="checkerComment" rows="2" disabled ></textarea></td>
				 		</tr>
				 		<tr>
				 			<td>Comment</td>
				 			<td colspan="4">
				 				<textarea rows="4" id="makerComments" class="form-control input-sm resizeTextarea"></textarea>
				 			</td>
				 		</tr>
				 </table>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-success" id="updateRulesFinal">Update CRP Rule</button>
				<button type="button" class="btn btn-danger" data-dismiss="modal">Close</button>
			</div>
			</div>
		</div>
		</div>
	</div>
	
<!-- for showing validation error/success message -->
<!-- <div class="modal fade bs-example-modal-lg" id="validationMessage" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
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
</div> -->

<div class="modal fade bs-example-modal-lg" id="validationMessage" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
	<div class="modal-dialog modal-lg">
		<div class="modal-content card-primary" style="height: auto;">
			<div class="modal-header card-header" style="cursor: move;" >
				<div class="modal-button">
					<button type="button" class="close" data-dismiss="modal" aria-label="Close" title="Close">
						<span aria-hidden="true" class="fa fa-remove"></span>
					</button>
				</div>
				<h4 class="modal-title" id="validationModalLabel">Validation Message</h4>					
			</div>
			<div class="modal-body" id="compassCaseWorkFlowGenericModal-body">
				<textarea rows="5" class="form-control" id="validationMessageTextarea" style="resize: vertical;"></textarea>
				
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
				 $("#isEnabled").attr("checked","checked");
			 }else{
				 $("#isEnabled").removeAttr("checked");
			 }
			 $("#ruleName").val(resData["RULENAME"]);
			 $("#ruleCode").val(resData["RULECODE"]);
			 $("#previousMakerComment").val(resData['MAKERCOMMENTS']);
			 if(resData['CHECKERCOMMENTS'] != "" && resData['CHECKERCOMMENTS'] != null ){
				 $("#checkCommentTr").show();
				 $("#checkerComment").val(resData['CHECKERCOMMENTS']);
			 }
			 $("#CRPRuleFor").val(resData['RULEFOR']);
			 
		}else{
			alert(resData["MESSAGE"]);
		}
	},
	complete:function(){
		/* var tr = $("table#ConditionDetailsTable > tbody > tr");
		 $(tr).each(function(indexTr){
			 if(indexTr % 2 != 0){
				 var currentRow = $(this);
				 var td =  $(this).children("td").eq(3);
				 let visibleDiv = $(td).find("div.leftObjectFiledValueDiv");
					let rightObjFieldOrValue = visibleDiv.find("select").val();
					visibleDiv.children().remove();
					let subParameterSelectBox = $(currentRow).children("td").eq(1).children().eq(1);
					subParameterSelectBox.val(subParameterSelectBox.val()).trigger('change');
					if(visibleDiv.find("select.selectedColumnValues").length){
						visibleDiv.find("select.selectedColumnValues").selectpicker('destroy');
						visibleDiv.find("select.selectedColumnValues").selectpicker();
						visibleDiv.find("select.selectedColumnValues").selectpicker('val',rightObjFieldOrValue);
						visibleDiv.find("select.selectedColumnValues").selectpicker('refresh');
					}else{
						console.log("did not find it ");
					}
				 
			}
		}); */


		 var tr = $("table#ConditionDetailsTable > tbody > tr");
			 $(tr).each(function(indexTr){
				 if(indexTr % 2 != 0){
					 var currentRow = $(this);
					 var td =  $(this).children("td").eq(3);
					 let visibleDiv = $(td).find("div.leftObjectFiledValueDiv");
					 let rightObjFieldOrValue = [];
						rightObjFieldOrValue = visibleDiv.find("select").val();
						visibleDiv.children().remove();
						let subParameterSelectBox = $(currentRow).children("td").eq(1).children().eq(1);
						subParameterSelectBox.val(subParameterSelectBox.val()).trigger('change');
						if(visibleDiv.find("select.selectedColumnValues").length){
							visibleDiv.find("select.selectedColumnValues").selectpicker('destroy');
							visibleDiv.find("select.selectedColumnValues").selectpicker();
							visibleDiv.find("select.selectedColumnValues").selectpicker('val',rightObjFieldOrValue);
							visibleDiv.find("select.selectedColumnValues").selectpicker('refresh');
							if(rightObjFieldOrValue != null  && rightObjFieldOrValue.length > 0  ){
								visibleDiv.find("select.selectedColumnValues").children("option").each(function(){
									let valIndex = $.inArray($(this).val(), rightObjFieldOrValue );
									if(valIndex >= 0){
										$(this).attr("selected","selected");
									}else{
										$(this).removeAttr("selected")
									}
									 
								 });
								
							}
						}else{
							console.log("Element not find.");
						}
					 
				}
			});
		
		<c:if test = "${f:contains(CURRENTROLECODE, 'ROLE_MLRO')}">
			$("#addRuleRow").prop('disabled', true);
			$("#openModalForFinalRule").prop('disabled', true);
			$(".deleteRows").prop('disabled', true);
		
		</c:if>
		 
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
	/* $(document).on("click",".objValCheckBox",function() {
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
		
	});	 */
	
	$(document).on("click",".objValCheckBox",function() {
		let elm = $(this);
		$(this).closest('td').find('input').not(this).removeAttr('checked');  
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
			type : "POST",
			async : false,
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
			//$("#saveFinalRulesModal").modal("show");
			$("#setRulePanelDiv").slideDown(800);
			let showSaveModal = true
			validationCRPRules(showSaveModal);
		}
	});
	
	//for creating rule string
	$("#viewRuleRow").click(function(){
		var hideSetRulePanelDiv = true;
		var hideCreatedRulePanelDiv = true;
		viewRuleFun(hideSetRulePanelDiv,hideCreatedRulePanelDiv);
		
	});
	
	function viewRuleFun(hideSetRulePanelDiv,hideCreatedRulePanelDiv){
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
								if(indexTr == 1 && hideSetRulePanelDiv){
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
		 
		 if(hideCreatedRulePanelDiv){
			 $("#createdRulePanel").toggle(); 
		 }
		 $("#createdRuleTextArea").val("");
		 $("#createdRuleTextArea").val(rule);
	}
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
	$("#updateRulesFinal").click(function(){
	  	var ruleID = $("#ruleID").val();
	  	var ruleName = $("#ruleName").val();
	  	var ruleCode = $("#ruleCode").val();
	  	var risk = $("#risk").val();
	  	var makerComments = $("#makerComments").val(); 
	  	var isEnabled = $("#isEnabled").val();
	  	var CRPRuleFor = $("#CRPRuleFor").val();
	  	
	  	if(ruleCode == "" || ruleCode == null){
	  		alert("Please enter Rule Code.");
	  		return false;
	  	}else if(ruleName == "" || ruleName == null){
	  		alert("Please enter Rule Name.");
	  		return false;
	  	}else if (CRPRuleFor == "" || CRPRuleFor == null || CRPRuleFor == "Select Rule For"){
	  		alert("Please Select Rule For");
	  		return false;
	  	}else if(makerComments == "" || makerComments == null) {
	  		alert("Please enter Comments.");
	  		return false;
	  	}
	  	
	  	if($("#isEnabled").prop("checked")){
	  		isEnabled = 'Y';
	  	}else{
	  		isEnabled = 'N';
	  	} 
	  	let rule = $("#createdRuleTextArea").val().trim();
		let ruleConditionHTML = $("#setRulePanelDiv").html();
		//	alert(isEnabled);
		$.ajax({
			url : "${pageContext.request.contextPath}/admin/saveRules?${_csrf.parameterName}=${_csrf.token}",
			type : "POST",
			cache : false,
			data : {ruleID:ruleID,ruleName:ruleName,ruleCode:ruleCode,risk:risk,isEnabled:isEnabled,rule:rule,ruleConditionHTML:ruleConditionHTML,makerComments:makerComments,CRPRuleFor:CRPRuleFor},
			success:function(res){
				//console.log(res);
				if(res == ruleID){
					alert("The rule has been saved successfully.");
					$("#saveFinalRulesModal").modal('toggle');
				}
			},complete:function(){
				closeThisWindow();
			},
			error: function(err){
				alert(err);
				//console.log("Error while saving rule.");
			}
		});
	});
	
	//validate rule
	$("#validateCRPRules").click(function(){
		if($("#createdRulePanel").css("display") == "none"){
			alert("Please view the created rule prior to validating.");
		}else{
			$("#setRulePanelDiv").slideDown(800);
			let showSaveModal = false;
		   	validationCRPRules(showSaveModal);
		}
	 });
	function validationCRPRules(showSaveModal){
			var hideSetRulePanelDiv = false;
			var hideCreatedRulePanelDiv = false;
			 $.when(viewRuleFun(hideSetRulePanelDiv,hideCreatedRulePanelDiv)).then(function( ) {
				var rule = $("#createdRuleTextArea").val().trim();
				var ruleID = ${ruleID};
				$.ajax({
					url: "${pageContext.request.contextPath}/admin/validateCRPRules?${_csrf.parameterName}=${_csrf.token}",
			 		type : "POST",
			  		cache : false,
			  		data : {rule:rule,ruleID:ruleID},
			  		success:function(res){
			  			if(showSaveModal && res.RULERESULT.VALIDATIONFLAG == 'Y'){
			  				/* if(rule.includes("DYNAMIC")){
			  					$("#ruleCode").val("DYNAMIC"+ruleID);
			  				}else{
			  					$("#ruleCode").val("STATIC"+ruleID);
			  				} */
			  				$("#validationMessageDuringSaving").text(res.RULERESULT.MESSAGE);
			  				$("#saveFinalRulesModal").modal("show");
			  			}else{
			  				$("#validationMessage").modal();
				  			$("#validationMessageTextarea").val(res.RULERESULT.MESSAGE);	
			  			}
			  			
			  		},
			  		error: function(err){
			  			alert("Error while validating rules.");
			  		}
			  	});
			 })
		}
	$(document).on("click",".collapseRow",function(e) {
		//alert('as');
		$(this).closest("tr").next().slideToggle(800);
	});
	
	
	$("#createRulePanelHeader").click(function(){
		$("#setRulePanelDiv").slideToggle(800);
	});
	
	function closeThisWindow(){
		window.opener.document.getElementById("flagFromUpdateRuleWindow").value = 'closingWindowAfterUpdatingRule';
		window.close();
	};

</script>
</html>
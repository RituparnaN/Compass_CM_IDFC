<%@ page language="java" contentType="text/html;ch`arset=UTF-8"
	pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../../tags/tags.jsp"%>
<script type="text/javascript">
$(document).ready(function(){
	var id = '${UNQID}';
	
	compassTopFrame.init(id, 'compassModuleDetailsSearchTable'+id, 'dd/mm/yy');
	getTemplates();
	
	$('.panelSlidingMissingFieldsTemplate'+id).on("click", function (e) {
		var mainRow = $(this).parents(".compassrow"+id);
		compassTopFrame.searchPanelSliding(id, mainRow, 'missingFieldsTemplateSerachResultPanel');
    });
	
	$('.panelSlidingAddFieldsToTemplate'+id).on("click", function (e) {
		var mainRow = $(this).parents(".compassrow"+id);
		compassTopFrame.searchPanelSliding(id, mainRow, 'addFieldsToTemplateSerachResultPanel');
    });
	
	$("#searchMissingFieldsTemplate"+id).click(function(){
		var templateId = $("#templateId"+id).val();
		var templateName = $("#templateName"+id).val();
		var productCode = $("#productCode"+id).val();
		var custType = $("#custType"+id).val();
		var isEnabled = $("#isEnabled"+id).val();
		var fullData = "templateId="+templateId+"&templateName="+templateName+"&productCode="+productCode+
							"&custType="+custType+"&isEnabled="+isEnabled;
		var mainRow = $(this).parents("div.compassrow"+id);
		var slidingDiv = $(mainRow).children().children().children();
		var panelBody = $(mainRow).children().children().find(".panelSearchForm");
		
		$.ajax({
			url: "${pageContext.request.contextPath}/admin/searchRiskParamFields",
			cache: false,
			type: "POST",
			data: "id="+id+"&fullData="+fullData,
			success: function(res){
				$("#missingFieldsTemplateSerachResultPanel"+id).css("display", "block");
				$("#missingFieldsTemplateSerachResult"+id).html(res);
				$(panelBody).slideUp();
				$(slidingDiv).addClass('card-collapsed');
				$(slidingDiv).find('i.collapsable').removeClass('fa-chevron-up').addClass('fa-chevron-down');
				$(mainRow).next().find(".compassrow"+id).find(".card-header").next().slideDown();
				
				getTemplates();
			},
			error: function(a,b,c){
				alert(a+b+c);
			}
		});
	});
	
	$("#addMissingFieldsTemplate"+id).click(function(){
		var templateId = $("#templateId"+id).val();
		var templateName = $("#templateName"+id).val();
		var productCode = $("#productCode"+id).val();
		var custType = $("#custType"+id).val();
		var productCodeRiskvalue = $("#productCodeRiskvalue"+id).val();
		var custTypeRiskvalue = $("#custTypeRiskvalue"+id).val();
		
		var isEnabled = $("#isEnabled"+id).val();
		var fullData = "templateId="+templateId+"&templateName="+templateName+"&productCode="+productCode+
							"&custType="+custType+"&productCodeRiskvalue="+productCodeRiskvalue+
							"&custTypeRiskvalue="+custTypeRiskvalue+"&isEnabled="+isEnabled;
		var mainRow = $(this).parents("div.compassrow"+id);
		var slidingDiv = $(mainRow).children().children().children();
		var panelBody = $(mainRow).children().children().find(".panelSearchForm");
		if(templateId != '' && templateName != '' && productCode != '' && custType != '' &&
				isEnabled != ''){
			if(confirm("Confirm adding")){
				$.ajax({
					url: "${pageContext.request.contextPath}/admin/addRiskParamFieldsTemplate",
					cache: false,
					type: "POST",
					data: fullData,
					success: function(res) {
						$("#missingFieldsTemplateSerachResultPanel"+id).css("display", "block");
						$("#missingFieldsTemplateSerachResult"+id).html(res);
						$(panelBody).slideUp();
						$(slidingDiv).addClass('card-collapsed');
						$(slidingDiv).find('i.collapsable').removeClass('fa-chevron-up').addClass('fa-chevron-down');
						$(mainRow).next().find(".compassrow"+id).find(".card-header").next().slideDown();
					},
					error: function(a,b,c) {
						alert(a+b+c);
					}
				});
		      }
		 }else
			 alert("Enter all the fields data.");
	});
	
	$("#updateMissingFieldsTemplate"+id).click(function(){
		var searchButton = "searchMissingFieldsTemplate${UNQID}"; 
		var table = $("#missingFieldsTemplateSerachResult"+id).find("table").children("tbody");
		var selectedTempId = "";	
		var selectedTempName = "";
		var selectedProductCode = "";
		var selectedCustomerType = "";
		var selectedIsEnabled = "";
		var selectedCount = 0;
		$(table).children("tr").each(function(){
			var checkbox = $(this).children("td:first-child").children("input");
			var tempId = $(this).children("td:nth-child(2)").html();
			var tempName = $(this).children("td:nth-child(3)").html();
			var productCode = $(this).children("td:nth-child(4)").html();
			var customerType = $(this).children("td:nth-child(5)").html();
			var isEnabled = $(this).children("td:nth-child(7)").html();
			if($(checkbox).prop("checked")){
				selectedTempId = tempId;
				selectedTempName = tempName;
				selectedProductCode = productCode;
				selectedCustomerType = customerType;
				selectedIsEnabled = isEnabled;
				selectedCount++;
			}
		});
		if(selectedCount > 1 || selectedCount == 0){
			alert("Select one record at a time to update.");
		}else{
			$("#compassCaseWorkFlowGenericModal").modal("show");
			$("#compassCaseWorkFlowGenericModal-title").html("Update Template Details");
			$.ajax({
				url: "${pageContext.request.contextPath}/admin/fetchRiskParamFieldsToUpdate",
				cache: false,
				type: "POST",
				data: "selectedTempId="+selectedTempId+"&selectedTempName="+selectedTempName+
					  "&selectedProductCode="+selectedProductCode+"&selectedCustomerType="+selectedCustomerType+
					  "&selectedIsEnabled="+selectedIsEnabled+"&searchButton="+searchButton,
				success: function(response) {
					$("#compassCaseWorkFlowGenericModal-body").html(response);
				},
				error: function(a,b,c) {
					alert(a+b+c);
				}
			});
		}
	});		
	
	$("#searchAddFieldsToTemplate"+id).click(function(){
		var template = $("#addTemplateSelectBox"+id).val();
		var detailType = $("#detailType"+id).val();
		var fullData = "template="+template+"&detailType="+detailType;
		
		var mainRow = $(this).parents("div.compassrow"+id);
		var slidingDiv = $(mainRow).children().children().children();
		var panelBody = $(mainRow).children().children().find(".panelSearchForm");
		
		$.ajax({
			url: "${pageContext.request.contextPath}/admin/searchAddRiskParamFieldsToTemplate",
			cache: false,
			type: "POST",
			data: fullData,
			success: function(res){
				$("#addFieldsToTemplateSerachResultPanel"+id).css("display", "block");
				$("#addFieldsToTemplateSerachResult"+id).html(res);
				$(panelBody).slideUp();
				$(slidingDiv).addClass('card-collapsed');
				$(slidingDiv).find('i.collapsable').removeClass('fa-chevron-up').addClass('fa-chevron-down');
				$(mainRow).next().find(".compassrow"+id).find(".card-header").next().slideDown();
			},
			error: function(a,b,c){
				alert(a+b+c);
			}
		});
	});
	
	$("#updateComplianceScore"+id).click(function(){
		var fullData = "";
		var searchTemplate = $("#searchTemplate").val();
		var tr = $("#addFieldsToTemplateSerachResult").find("table").children("tbody").children("tr");
		$(tr).each(function(){
			var checkbox = $(this).children("td:first-child").children("input").prop("checked");
			var tablename = $(this).children("td:nth-child(3)").html();
			var fieldname = $(this).children("td:nth-child(4)").html();
			var compliance = $(this).children("td:nth-child(7)").children("select").val();
			if(checkbox){
				fullData = fullData +tablename+","+fieldname+","+compliance+";";
			}
		});
		$.ajax({
			url: "${pageContext.request.contextPath}/admin/updateRiskParamFieldsScore",
			cache: false,
			type: "POST",
			data: "fullData="+fullData+"&searchTemplate="+searchTemplate,
			success: function(res){
				alert(res);
			},
			error: function(a,b,c){
				alert(a+b+c);
			}
		});
	});

	$("#updateParameterWeightageList"+id).click(function(){
		var fullData = " ";
		$(".compassRiskCalculationSearchTable").children("tbody").children("tr").each(function(){
			var paramId = $(this).children("td:first-child").html();
			var paramWeightage = $(this).children("td:nth-child(3)").children("select").val();
			fullData = fullData + paramId+"="+paramWeightage+",";
		});
		$.ajax({
			url: "${pageContext.request.contextPath}/admin/updateParameterWeightageList",
			cache: false,
			type: "POST",
			data: "strParameters="+fullData,
			success: function(res){
				alert(res);
			},
			error: function(a,b,c){
				alert(a+b+c);
			}
		});
	});
	
	$("#calculateRisk"+id).click(function(){
		var btn = $(this);
		var btnMsg = $(btn).html();
		$(btn).html("Calculating...");
		$(btn).attr("disabled",true);
		$.ajax({
			url: "${pageContext.request.contextPath}/admin/calculateRisk",
			cache: false,
			type: "POST",
			success: function(res){		
				alert("Risk calculated successfully.");
				$(btn).html(btnMsg);
				$(btn).removeAttr("disabled");
			},
			error: function(a,b,c){
				alert(a+b+c);
			}
		});
	});

	

	
	
});

function getTemplates(){
	var html = "";
	$.ajax({
		url: "${pageContext.request.contextPath}/admin/getTemplatesForRiskParamFieldsTemplate",
		cache: false,
		type: "POST",
		success: function(response) {
			$.each(response.RECORDDATA, function(k,v){
				html = html+"<option value='"+v.TEMPLATEID+"'>"+v.TEMPLATENAME+"</option>";
			});
			$("#addTemplateSelectBox${UNQID}").html(html);
		},
		error: function(a,b,c) {
			alert(a+b+c);
		}
	});
	
}
</script>
<div role="tabpanel" class="tab-pane active" id="Tab1" >
	<div class="row compassrow${UNQID}">
	    <div class="col-sm-12">
		<div class="card card-primary panel_missingFieldsTemplate" style="margin-top: 2px;">
			<div class="card-header panelSlidingMissingFieldsTemplate${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}"><spring:message code="app.common.riskParametersTemplateSearchHeader"/></h6>
				<div class="btn-group pull-${dirR} clearfix">
					<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
				</div>
			</div>
			<div class="panelSearchForm">
			<form action="javascript:void(0)" method="POST" id="searchMasterForm${UNQID}">
				<table class="table compassModuleDetailsSearchTable${UNQID}" style="margin-bottom: 0px;">
					<tr>
						<td width="15%">Template Id</td>
							<td width="30%">
								<input type="text" class="form-control input-sm" name="templateId" id="templateId${UNQID}"/>
							</td>
						<td width="10%">&nbsp;</td>
						<td width="15%">Template Name</td>
						<td width="30%">
							<input type="text" class="form-control input-sm" name="templateName" id="templateName${UNQID}"/>	
						</td>
					</tr>
					<tr>	
						<td width="15%">Product Code</td>
						<td width="30%">
							<select class="form-control input-sm" name="productCode" id="productCode${UNQID}">
								<option value="ALL">ALL</option>
								<c:forEach var="productCode" items="${FIELDSMAP['PRODUCT']}">
									<option value="${productCode.key}">${productCode.value}</option>
								</c:forEach>
							</select>
						</td>
						<td width="10%">&nbsp;</td>
						<td width="15%">Customer Type</td>
						<td width="30%">
							<select class="form-control input-sm" name="custType" id="custType${UNQID}">
								<option value="ALL">ALL</option>
								<c:forEach var="custType" items="${FIELDSMAP['CUSTOMER']}">
									<option value="${custType.key}">${custType.value}</option>
								</c:forEach>
							</select>
						</td>
					</tr>
					<tr>	
						<td width="15%">ProductCode RiskValue</td>
						<td width="30%">
							<select class="form-control input-sm" name="custTypeRiskValue" id="custTypeRiskValue${UNQID}">
								<option value="1">1 - Low</option>
								<option value="2">2 - Medium</option>
								<option value="3">3 - High</option>
							</select>
						</td>
						<td width="10%">&nbsp;</td>
						<td width="15%">CustomerType  RiskValue</td>
						<td width="30%">
							<select class="form-control input-sm" name="custTypeRiskValue" id="custTypeRiskValue${UNQID}">
								<option value="1">1 - Low</option>
								<option value="2">2 - Medium</option>
								<option value="3">3 - High</option>
							</select>
						</td>
					</tr>
					<tr>	
						<td width="15%">Is Enabled</td>
						<td width="30%">
							<select class="form-control input-sm" name="isEnabled" id="isEnabled${UNQID}">
								<option value=""></option>
								<option value="Y">Yes</option>
								<option value="N">No</option>
							</select>
						</td>
						<td colspan="3">&nbsp;</td>
					</tr>
				</table>
				<div class="card-footer clearfix">
					<div class="pull-${dirR}">
						<input type="button" id="addMissingFieldsTemplate${UNQID}" class="btn btn-primary btn-sm" name="Add" value="Add">
						<button type="button" id="searchMissingFieldsTemplate${UNQID}" class="btn btn-success btn-sm" name="Search" value="Search">Search</button>
						<input type="reset" class="btn btn-danger btn-sm" id="clearMissingFieldsTemplate${UNQID}" name="Clear" value="Clear"/>
					</div>
				</div>
			</form>
			</div>
		</div>
		<div class="card card-primary" id="missingFieldsTemplateSerachResultPanel${UNQID}" style="display: none;">
			<div class="card-header panelSlidingMissingFieldsTemplate${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}"><spring:message code="app.common.riskParametersTemplateResultHeader"/></h6>
				<div class="btn-group pull-${dirR} clearfix">
					<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
				</div>
			</div>
			<div id="missingFieldsTemplateSerachResult${UNQID}"></div>
			<div class="card-footer clearfix">
				<div class="pull-${dirR}">
				<input type="button" class="btn btn-primary btn-sm" id="updateMissingFieldsTemplate${UNQID}" name="Update" value="Update"/>
				</div>
			</div>
		</div>
		</div>
	</div>
</div>

<div role="tabpanel" class="tab-pane" id="Tab2">
	<div class="row">
		<div class="col-sm-12">
			<div class="card card-default" style="margin-bottom: 0px;">
				<div class="row compassrow${UNQID}">
					<div class="col-sm-12">
						<div class="card card-primary panel_addFieldsToTemplate" style="margin-bottom: 0px; margin-top: 2px;">
							<div class="card-header panelSlidingAddFieldsToTemplate${UNQID} clearfix">
								<h6 class="card-title pull-${dirL}">Add Fields To Template</h6>
									<div class="btn-group pull-${dirR} clearfix">
										<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
									</div>
							</div>
							<div class="panelSearchForm">
								<table class="table compassAddFieldsToTemplateSearchTable" style="margin-bottom: 0px;">
									<tr>
										<td width="15%">Template</td>
										<td width="30%">
											<select class="form-control input-sm" name="addTemplateSelectBox" id="addTemplateSelectBox${UNQID}">
												<option value="">Select One</option>
											</select> 
										</td>
										<td width="10%">&nbsp;</td>
										<td width="15%">Detail Type</td>
										<td width="30%">
											<select class="form-control input-sm" name="detailType" id="detailType${UNQID}">
												<option value="ACCOUNTSTATUS">Account Status</option>
												<option value="CUSTOMEROCCUPATION">Customer Occupation</option>
												<option value="COUNTRYCODE">Country Code</option>
												<option value="ISSTRSENT">IsSTR Sent</option>
												<option value="TRANSACTIONRANGE">Transaction Range</option>
											</select> 
										</td>
									</tr>
								</table>
								<div class="card-footer clearfix">
									<div class="pull-${dirR}">
										<input type="button" id="searchAddFieldsToTemplate${UNQID}" class="btn btn-primary btn-sm" name="Search" value="Search">
									</div>
								</div>
							</div>
						</div>
					</div>
					<div class="col-sm-12">
						<div class="card card-primary" id="addFieldsToTemplateSerachResultPanel${UNQID}" style="margin-top: 10px; margin-bottom: 0px; display: none;">
							<div class="card-header panelSlidingAddFieldsToTemplate${UNQID} clearfix">
								<h6 class="card-title pull-${dirL}">Update Risk Value</h6>
							<div class="btn-group pull-${dirR} clearfix">
								<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
							</div>
							</div>
							<div id="addFieldsToTemplateSerachResult${UNQID}"></div>
							<div class="card-footer clearfix">
								<div class="pull-${dirR}">
									<button type="button" class="btn btn-success btn-sm" id="updateComplianceScore${UNQID}" name="Update">Update</button>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>

<div role="tabpanel" class="tab-pane" id="Tab3">
	<div class="row">
	    <div class="col-sm-12">
		<div class="card card-primary panel_parameterListBottomFrame" style="margin-bottom: 0px;">
		 <div class="panelSearchForm">
			<table class="table table-bordered table-striped compassRiskCalculationSearchTable" style="margin-bottom: 0px;">
				<thead>
					<tr>
						<th class="info">Parameter Id </th>
						<th class="info">Parameter Name</th>
						<th class="info">Weightage</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="parameterList" items="${RESULTLIST}">
						<tr>
							<td>${parameterList['RISKPARAMETERID']}</td>
							<td>${parameterList['RISKPARAMETERNAME']}</td>
							<td>
								<select class="form-control input-sm" style="width: 50%" <c:if test="${parameterList['ISRISKPARAMETERMARKED'] ne 'Y'}">disabled="disabled"</c:if>>
									<option value="1" <c:if test="${parameterList['RISKPARAMETERWEIGHTAGE'] eq '1'}">selected="selected"</c:if>>1</option>
									<option value="2" <c:if test="${parameterList['RISKPARAMETERWEIGHTAGE'] eq '2'}">selected="selected"</c:if>>2</option>
									<option value="3" <c:if test="${parameterList['RISKPARAMETERWEIGHTAGE'] eq '3'}">selected="selected"</c:if>>3</option>
									<option value="4" <c:if test="${parameterList['RISKPARAMETERWEIGHTAGE'] eq '4'}">selected="selected"</c:if>>4</option>
									<option value="5" <c:if test="${parameterList['RISKPARAMETERWEIGHTAGE'] eq '5'}">selected="selected"</c:if>>5</option>
								</select>
							</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
			<div class="card-footer clearfix">
					<div class="pull-${dirR}">
						<input type="button" id="updateParameterWeightageList${UNQID}" class="btn btn-success btn-sm" name="Update" value="Update"/>
						<button type="button" id="calculateRisk${UNQID}" class="btn btn-primary btn-sm" name="CalculateRisk">Calculate Risk</button>
					</div>
			</div>
		</div>
	   </div>
	   </div>
	</div>
</div>

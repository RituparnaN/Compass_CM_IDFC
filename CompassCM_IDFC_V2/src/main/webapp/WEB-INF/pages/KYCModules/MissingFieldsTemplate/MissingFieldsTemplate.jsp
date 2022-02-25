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
			url: "${pageContext.request.contextPath}/common/searchMissingFields",
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
		var isEnabled = $("#isEnabled"+id).val();
		var fullData = "templateId="+templateId+"&templateName="+templateName+"&productCode="+productCode+
							"&custType="+custType+"&isEnabled="+isEnabled;
		var mainRow = $(this).parents("div.compassrow"+id);
		var slidingDiv = $(mainRow).children().children().children();
		var panelBody = $(mainRow).children().children().find(".panelSearchForm");
		if(templateId != '' && templateName != '' && productCode != '' && custType != '' &&
				isEnabled != ''){
			if(confirm("Confirm adding")){
				$.ajax({
					url: "${pageContext.request.contextPath}/common/addMissingFieldsTemplate",
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
				url: "${pageContext.request.contextPath}/common/fetchMissingFieldsToUpdate",
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
			url: "${pageContext.request.contextPath}/common/searchAddFieldsToTemplate",
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
		var detailType = $("#detailType").val();
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
			url: "${pageContext.request.contextPath}/common/updateComplianceScore",
			cache: false,
			type: "POST",
			data: "fullData="+fullData+"&searchTemplate="+searchTemplate+"&detailType="+detailType,
			success: function(res){
				alert(res);
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
		url: "${pageContext.request.contextPath}/common/getTemplatesForMissingFieldsTemplate",
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
	    <div class="col-sm-12" >
		<div class="card card-primary panel_missingFieldsTemplate" style="margin-top: 2px; margin-bottom: 0px;">
			<div class="card-header panelSlidingMissingFieldsTemplate${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}"><spring:message code="app.common.missingFieldsTemplateSearchHeader"/></h6>
				<div class="btn-group pull-${dirR} clearfix">
					<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
				</div>
			</div>
			<div class="panelSearchForm">
			<form action="javascript:void(0)" method="POST" id="searchMasterForm${UNQID}">
				<table class="table table-striped compassModuleDetailsSearchTable${UNQID}" style="margin-bottom: 0px;">
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
		<div class="card card-primary" id="missingFieldsTemplateSerachResultPanel${UNQID}" style="display: none; margin-top: 10px;">
			<div class="card-header panelSlidingMissingFieldsTemplate${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}"><spring:message code="app.common.missingFieldsTemplateResultHeader"/></h6>
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
						<div class="card card-primary panel_addFieldsToTemplate" style="margin-bottom: -1px; margin-top: 1px;">
							<div class="card-header panelSlidingAddFieldsToTemplate${UNQID} clearfix">
								<h6 class="card-title pull-${dirL}">Add Fields To Template</h6>
									<div class="btn-group pull-${dirR} clearfix">
										<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
									</div>
							</div>
							<div class="panelSearchForm">
								<table class="table  compassAddFieldsToTemplateSearchTable" style="margin-bottom: 0px;">
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
												<option value="TB_ACCOUNTSMASTER">Accounts Details</option>
												<option value="TB_CUSTOMERMASTER">Customer Details</option>
												<option value="TB_NOMINEEDETAILS">Nominee Details</option>
												<option value="TB_MINORDETAILS">Minor Details</option>
												<option value="TB_NRECUSTOMERDETAILS">NRECustomer Details</option>
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
								<h6 class="card-title pull-${dirL}">Update Compliance Score</h6>
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

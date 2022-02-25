<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../tags/tags.jsp"%>
<script type="text/javascript">
	$(document).ready(function(){
		var id = '${UNQID}';

		compassTopFrame.init(id, 'compassModuleDetailsSearchTable'+id, 'dd/mm/yy');
		
		$('.panelSlidingCDDMasterModules'+id).on("click", function (e) {
			var mainRow = $(this).parents(".compassrow"+id);
			compassTopFrame.searchPanelSliding(id, mainRow, 'cddMasterModulesSerachResultPanel');
	    });

		$("#moduleType"+id).on("change", function(){
			if($(this).val() == "AttributeTypeMaster"){
				$("#attributeTypeMasterField").css("display", "table-row");
				$("#countryMasterField").css("display", "none");
				$("#occupationIndustryMasterField").css("display", "none");
			}
			else if($(this).val() == "CountryMaster"){
				$("#attributeTypeMasterField").css("display", "none");
				$("#countryMasterField").css("display", "table-row");
				$("#occupationIndustryMasterField").css("display", "none");
			}
			else if($(this).val() == "OccupationIndustryMaster"){
				$("#attributeTypeMasterField").css("display", "none");
				$("#countryMasterField").css("display", "none");
				$("#occupationIndustryMasterField").css("display", "table-row");
			}
		});
		
		$("#uploadCDDMasterModulesData"+id).click(function(){
			if($("#moduleType"+id).val() == 'AttributeTypeMaster'){
				compassFileUpload.init("attributeTypeMasterData"+id,"${pageContext.request.contextPath}","cddMasterModules","0","Y","Y","");
			}
			else if($("#moduleType"+id).val() == 'CountryMaster'){
				compassFileUpload.init("countryMasterData"+id,"${pageContext.request.contextPath}","cddMasterModules","0","Y","Y","");
			}
			else if($("#moduleType"+id).val() == 'OccupationIndustryMaster'){
				compassFileUpload.init("occupationIndustryMasterData"+id,"${pageContext.request.contextPath}","cddMasterModules","0","Y","Y","");
			}
		});
		
		$("#searchCDDMasterModuleDetails"+id).click(function(){
			var mainRow = $(this).parents(".compassrow"+id);
			var slidingDiv = $(mainRow).children().children().children();
			var panelBody = $(mainRow).children().children().find(".panelSearchForm");
			
			var moduleType = $("#moduleType"+id).val();
			var riskRating = $("#riskRating"+id).val();
			var description = "";
			var countryName = "";
			if(moduleType == "AttributeTypeMaster")
				description = $("#attributeTypeDescription"+id).val();
			if(moduleType == "CountryMaster")
				countryName = $("#countryMasterName"+id).val();
			if(moduleType == "OccupationIndustryMaster")
				description = $("#occupationIndustryDescription"+id).val();
						
			var fullData = "moduleType="+moduleType+"&riskRating="+riskRating+"&description="+description+"&countryName="+countryName;
			
			if(moduleType != 'ALL'){
			$.ajax({
				url: "${pageContext.request.contextPath}/admin/searchCDDMasterModulesData",
				cache: false,
				type: "POST",
				data: fullData,
				success: function(res) {
					$("#cddMasterModulesSerachResultPanel"+id).css("display", "block");
					$("#cddMasterModulesSerachResult"+id).html(res);
					$(panelBody).slideUp();
					$(slidingDiv).addClass('card-collapsed');
					$(slidingDiv).find('i.collapsable').removeClass('fa-chevron-up').addClass('fa-chevron-down');
					$(mainRow).next().find(".compassrow"+id).find(".card-header").next().slideDown();
				},
				error: function(a,b,c) {
					alert(a+b+c);
				}
			});
			}else{
				alert("Please select module type.");
			}
		});
					
});
</script>

<div class="row compassrow${UNQID}">
	<div class="col-sm-12">
		<div class="card card-primary panel_cddMasterModules">
			<div class="card-header panelSlidingCDDMasterModules${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}"><spring:message code="app.common.cddMasterModulesSearchHeader"/></h6>
				<div class="btn-group pull-${dirR} clearfix">
					<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
				</div>
			</div>
			<div class="panelSearchForm">
			<form action="javascript:void(0)" method="POST" id="searchMasterForm${UNQID}">
				<table class="table compassModuleDetailsSearchTable${UNQID}" style="margin-bottom: 0px;">
					<tr>
						<td width="15%">Module Type</td>
						<td width="30%">
							<select class="form-control input-sm" id="moduleType${UNQID}" name="moduleType">
								<option value = "ALL" selected="selected">Select Module Type</option>
								<option value="AttributeTypeMaster">Attribute Type Master</option>
								<option value="CountryMaster">Country Master</option>
								<option value="OccupationIndustryMaster">Occupation Industry Master</option>
							</select>
						</td>
						<td width="10%">&nbsp;</td>
						<td width="15%">Risk Rating</td>
						<td width="30%">
							<select class="form-control input-sm" id="riskRating${UNQID}" name="riskRating" >
								<option value = "ALL" selected="selected">Select Risk Rating</option>
								<option value="Low">Low</option>								
								<option value="Medium">Medium</option>
								<option value="High">High</option>
							</select>
						</td>
					</tr>
					<tr id = "attributeTypeMasterField" style="display: none;">
						<td width="15%">Description</td>
						<td width="30%">
							<select class="form-control input-sm" id="attributeTypeDescription${UNQID}" name="attributeTypeDescription" style="width: 384px">
								<option value="ALL">All</option>
								<c:forEach var="LISTVALUE" items="${ATTRIBUTELIST}">
									<option value="${LISTVALUE}">${LISTVALUE}</option>
								</c:forEach>
							</select>
						</td>
						<td colspan="3">&nbsp;</td>
					</tr>
					<tr id = "countryMasterField" style="display: none;">
						<td width="15%">Country Name</td>
						<td width="30%">
							<select class="form-control input-sm" id="countryMasterName${UNQID}" name="countryMasterName" style="width: 384px">
								<option value="ALL">All</option>	
								<c:forEach var="LISTVALUE" items="${COUNTRYLIST}">								
									<option value="${LISTVALUE}" >${LISTVALUE}</option>
								</c:forEach>
							</select>
						</td>
						<td colspan="3">&nbsp;</td>
					</tr>
					<tr id = "occupationIndustryMasterField" style="display: none;">
						<td width="15%">Description</td>
						<td width="30%">
							<select class="form-control input-sm" id="occupationIndustryDescription${UNQID}" name="occupationIndustryDescription" style="width: 384px">
								<option value="ALL">All</option>
								<c:forEach var="LISTVALUE" items="${OCCUPATIONLIST}">	
									<option value="${LISTVALUE}">${LISTVALUE}</option>
								</c:forEach>
							</select>
						</td>
						<td colspan="3">&nbsp;</td>
					</tr>
				</table>
				<div class="card-footer clearfix">
					<div class="pull-${dirR}">
						<input type="button" class="btn btn-warning btn-sm" id="uploadCDDMasterModulesData${UNQID}" name="UploadCDDMasterModulesData" value="Upload CDD Master Data"/>
						<button type="button" id="searchCDDMasterModuleDetails${UNQID}" class="btn btn-success btn-sm" name="Search" value="Search">Search</button>
					</div>
				</div>
			</form>
			</div>
		</div>
		<div class="card card-primary" id="cddMasterModulesSerachResultPanel${UNQID}" style="display: none;">
			<div class="card-header panelSlidingCDDMasterModules${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}"><spring:message code="app.common.cddMasterModulesResultHeader"/></h6>
				<div class="btn-group pull-${dirR} clearfix">
					<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
				</div>
			</div>
			<div id="cddMasterModulesSerachResult${UNQID}"></div>
		</div>
	</div>
</div>
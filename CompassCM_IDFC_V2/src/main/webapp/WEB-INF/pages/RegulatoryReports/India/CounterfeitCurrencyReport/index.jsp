<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../../../tags/tags.jsp"%>
<script type="text/javascript">
	$(document).ready(function() {
		var id = '${UNQID}';
		compassTopFrame.init(id, 'ccrTable', 'dd/mm/yy');
		
		$("#uploadCCR"+id).click(function(){
			compassFileUpload.init("uploadCCR"+id,"${pageContext.request.contextPath}","counterfeitCurrencyReport","0","Y","Y","");
		});
		
		$(".panelSlidingCCReport"+id).on("click", function(e){
			var mainRow = $(this).parents(".compassrow"+id);
			compassTopFrame.searchPanelSliding(id, mainRow, 'counterfeitCurrencyReportSerachResultPanel');
		});
		
		var buttonId = "";
		$("#viewGeneratedCcrFiles"+id).click(function(){
			
			buttonId = $(this)[0].id;
		});
		$("#searchCCReport"+id).click(function(){
			buttonId = $(this)[0].id;
		});
		
		/* DOWNLOAD GENERATED CCR FILES */
		$("#searchMasterForm"+id).submit(function(e){
			var reportingYear = $("#REPORTINGYEAR_"+id).val();
			
			if(reportingYear != ""){
				if(buttonId ==  "viewGeneratedCcrFiles"+id){
					var viewCcrButton = $("#viewGeneratedCcrFiles"+id);
					var mainRow = $(this).parents("div.compassrow"+id);
					var slidingDiv = $(mainRow).children().children().children();
					var panelBody = $(mainRow).children().children().find(".panelSearchForm");
					$.ajax({
						url: "${pageContext.request.contextPath}/common/viewGeneratedCCRFilesMaster",
						data: $(this).serialize() + "&viewFilePageUrl=RegulatoryReports/India/CounterfeitCurrencyReport/ViewGeneratedFile"+"&viewCcrButton="+buttonId,
						type: "POST",
						success: function(res){
							$("#counterfeitCurrencyReportSerachResult"+id).html(res);
							$("#counterfeitCurrencyReportSerachResultPanel"+id).show();
							$(panelBody).slideUp();
							$(slidingDiv).addClass('card-collapsed');
							$(slidingDiv).find('i.collapsable').removeClass('fa-chevron-up').addClass('fa-chevron-down');
							$(mainRow).next().find(".compassrow"+id).find(".card-header").next().slideDown();
						},
						error: function(err){
							alert(err);
							//console.log(err);
						}
					});
					
				}else if(buttonId ==  "searchCCReport"+id){
					var submitButton = $("#searchCCReport"+id);
					compassTopFrame.submitForm(id, e, submitButton, 'counterfeitCurrencyReportSerachResultPanel',
							'counterfeitCurrencyReportSerachResult', '${pageContext.request.contextPath}/common/searchGenericMaster',
							'${pageContext.request.contextPath}/includes/images/qde-loadder.gif');
				}
			}else{
				alert("Please enter the year of reporting.");
			}
		});
		
		$("#generateNewCCR"+id).click(function(){
			var branchCode = $("#BRANCHCODE_"+id).val();
			var accountNo = $("#ACCOUNTNO_"+id).val();
			var fullData = 'BranchCode='+branchCode+'&AccountNo='+accountNo;
			//alert(fullData);
			var url = '${pageContext.request.contextPath}/common/generateNewCCR?'+fullData;
			if(branchCode == '' && accountNo == ''){
				alert('Select either Account number or Branch code.');
				return false;
			}else if(branchCode != '' && accountNo != ''){
				alert('Select either Account number or Branch code.');
				branchCode.val('');
				accountNo.val('');
				return false;
			}else{
				$.ajax({
					url: url,
					type: 'POST',
					cache: false,
					data: 'fullData='+fullData,
					success: function(res){
						var ccrNo = res;
						url = '${pageContext.request.contextPath}/common/viewCCRDetails?ccrNo='+ccrNo+'&fullData='+fullData;	
						window.open(url,'CCR_CRF','top=10,left=20, height=750, width=900,scrollbars=yes,resizable=yes');
					},
					error: function(a,b,c){
						alert(a+b+c);
					}
				});
			}
		});
	});
		
</script>
<div class="row compassrow${UNQID}">
	<div class="col-sm-12">
		<div class="card card-primary panel_counterfeitCurrencyReport">
			<div class="card-header panelSlidingCCReport${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}"><spring:message code="app.common.counterfeitCurrencyReportHeader"/></h6>
				<div class="btn-group pull-${dirR} clearfix">
					<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
				</div>
			</div>
			<div class="panelSearchForm">
			<form action="javascript:void(0)" method="POST" id="searchMasterForm${UNQID}">
			<input type="hidden" name="moduleType" value="${MODULETYPE}">
			<input type="hidden" name="bottomPageUrl" value="RegulatoryReports/India/CounterfeitCurrencyReport/SearchBottomPage">
			<div class="card-search-card" >
				<table class="table table-striped formSearchTable counterfeitCurrencyReportTable" style="margin-bottom: 0px;">
					<tbody>
						<c:set var="LABELSCOUNT" value="${f:length(MASTERSEARCHFRAME)}"/>
						<c:set var="LABELSITRCOUNT" value="0" scope="page"/>
						
						<c:forEach var="ALLLABELSMAP" items="${MASTERSEARCHFRAME}">
							<c:choose>
								<c:when test="${LABELSITRCOUNT % 2 == 0}">
												<tr>
										<td width="15%">
											<spring:message code="${ALLLABELSMAP['MODULEPARAMNAME']}"/>
											<span style="color: red;"><c:if test="${ALLLABELSMAP['MODULEPARAMVALIDATIONFIELD'] eq 'Y'}"> *</c:if></span>
										</td>
										<td width="30%">
											<c:if test="${ALLLABELSMAP['MODULEPARAMDATATYPE'] eq 'date'}">
												<input type="text" value="${ALLLABELSMAP['MODULEPARAMDEFAULTVALUE']}" 
												class="form-control input-sm datepicker"
												id="${ALLLABELSMAP['MODULEPARAMIDNAME']}_${UNQID}" 
												name="${ALLLABELSMAP['MODULEPARAMINDEX']}_${ALLLABELSMAP['MODULEPARAMIDNAME']}"
												validation="${ALLLABELSMAP['MODULEPARAMVALIDATIONFIELD']}"/>
											</c:if>
											
											<c:if test="${ALLLABELSMAP['MODULEPARAMDATATYPE'] eq 'select'}">
												<c:set var="SELECTOPTIONNAMEVALUE" value="${ALLLABELSMAP['MODULEPARAMSELECTNAMEVALUES']}"/>
												<select class="form-control input-sm" id="${ALLLABELSMAP['MODULEPARAMIDNAME']}_${UNQID}" 
												validation="${ALLLABELSMAP['MODULEPARAMVALIDATIONFIELD']}"
												name="${ALLLABELSMAP['MODULEPARAMINDEX']}_${ALLLABELSMAP['MODULEPARAMIDNAME']}">
													<c:forEach var="NAMEVALUE" items="${SELECTOPTIONNAMEVALUE}">
														<option value="${NAMEVALUE.key}">${NAMEVALUE.value}</option>
													</c:forEach>
												</select>
											</c:if>
											
											<c:if test="${ALLLABELSMAP['MODULEPARAMDATATYPE'] eq 'text'}">
												<input type="text" value="${ALLLABELSMAP['MODULEPARAMDEFAULTVALUE']}" class="form-control input-sm" 
												id="${ALLLABELSMAP['MODULEPARAMIDNAME']}_${UNQID}" 
												validation="${ALLLABELSMAP['MODULEPARAMVALIDATIONFIELD']}"
												name="${ALLLABELSMAP['MODULEPARAMINDEX']}_${ALLLABELSMAP['MODULEPARAMIDNAME']}"/>
											</c:if>
											
											<c:if test="${ALLLABELSMAP['MODULEPARAMDATATYPE'] eq 'view'}">
												<div class="input-group" style="z-index: 1">
													<input type="text" value="${ALLLABELSMAP['MODULEPARAMDEFAULTVALUE']}" 
													class="form-control input-sm" aria-describedby="basic-addon${UNQID}" 
													id="${ALLLABELSMAP['MODULEPARAMIDNAME']}_${UNQID}" 
													validation="${ALLLABELSMAP['MODULEPARAMVALIDATIONFIELD']}"
													name="${ALLLABELSMAP['MODULEPARAMINDEX']}_${ALLLABELSMAP['MODULEPARAMIDNAME']}"/>
													<span class="input-group-addon formSearchIcon" id="basic-addon${UNQID}" 
													onclick="compassTopFrame.moduleSearch('${ALLLABELSMAP['MODULEPARAMIDNAME']}_${UNQID}','${ALLLABELSMAP['MODULEPARAMIDNAME']}','${ALLLABELSMAP['MODULEPARAMVIEWNAME']}','${ALLLABELSMAP['SEARCHMULTIPLESELECT']}','${pageContext.request.contextPath}')" style="cursor: pointer;" title="Search">
														<i class="fa fa-search"></i>
													</span>
												</div>
											</c:if>
										</td>
										<td width="10%">&nbsp;</td>
								</c:when>
								<c:otherwise>
										<td width="15%">
											<spring:message code="${ALLLABELSMAP['MODULEPARAMNAME']}"/>
											<span style="color: red;"><c:if test="${ALLLABELSMAP['MODULEPARAMVALIDATIONFIELD'] eq 'Y'}"> *</c:if></span>
										</td>
										<td width="30%">
											<c:if test="${ALLLABELSMAP['MODULEPARAMDATATYPE'] eq 'date'}">
												<input type="text" value="${ALLLABELSMAP['MODULEPARAMDEFAULTVALUE']}" 
												class="form-control input-sm datepicker" id="${ALLLABELSMAP['MODULEPARAMIDNAME']}_${UNQID}" 
												name="${ALLLABELSMAP['MODULEPARAMINDEX']}_${ALLLABELSMAP['MODULEPARAMIDNAME']}" 
												validation="${ALLLABELSMAP['MODULEPARAMVALIDATIONFIELD']}"/>
											</c:if>
											
											<c:if test="${ALLLABELSMAP['MODULEPARAMDATATYPE'] eq 'select'}">
												<c:set var="SELECTOPTIONNAMEVALUE" value="${ALLLABELSMAP['MODULEPARAMSELECTNAMEVALUES']}"/>
												<select class="form-control input-sm" id="${ALLLABELSMAP['MODULEPARAMIDNAME']}_${UNQID}" 
												name="${ALLLABELSMAP['MODULEPARAMINDEX']}_${ALLLABELSMAP['MODULEPARAMIDNAME']}"
												validation="${ALLLABELSMAP['MODULEPARAMVALIDATIONFIELD']}">
													<c:forEach var="NAMEVALUE" items="${SELECTOPTIONNAMEVALUE}">
														<option value="${NAMEVALUE.key}">${NAMEVALUE.value}</option>
													</c:forEach>
												</select>
											</c:if>
											
											<c:if test="${ALLLABELSMAP['MODULEPARAMDATATYPE'] eq 'text'}">
												<input type="text" value="${ALLLABELSMAP['MODULEPARAMDEFAULTVALUE']}" 
												class="form-control input-sm" id="${ALLLABELSMAP['MODULEPARAMIDNAME']}_${UNQID}" 
												name="${ALLLABELSMAP['MODULEPARAMINDEX']}_${ALLLABELSMAP['MODULEPARAMIDNAME']}"
												validation="${ALLLABELSMAP['MODULEPARAMVALIDATIONFIELD']}"/>
											</c:if>
											
											<c:if test="${ALLLABELSMAP['MODULEPARAMDATATYPE'] eq 'view'}">
												<div class="input-group" style="z-index: 1">
													<input type="text" value="${ALLLABELSMAP['MODULEPARAMDEFAULTVALUE']}" 
													class="form-control input-sm" aria-describedby="basic-addon2" 
													id="${ALLLABELSMAP['MODULEPARAMIDNAME']}_${UNQID}" 
													name="${ALLLABELSMAP['MODULEPARAMINDEX']}_${ALLLABELSMAP['MODULEPARAMIDNAME']}"
													validation="${ALLLABELSMAP['MODULEPARAMVALIDATIONFIELD']}"/>
													<span class="input-group-addon formSearchIcon" id="basic-addon2" 
													onclick="compassTopFrame.moduleSearch('${ALLLABELSMAP['MODULEPARAMIDNAME']}_${UNQID}','${ALLLABELSMAP['MODULEPARAMIDNAME']}','${ALLLABELSMAP['MODULEPARAMVIEWNAME']}','${ALLLABELSMAP['SEARCHMULTIPLESELECT']}','${pageContext.request.contextPath}')" style="cursor: pointer;" title="Search">
														<i class="fa fa-search"></i>
													</span>
												</div>												
											</c:if>
										</td>
									</tr>
								</c:otherwise>
							</c:choose>
							
							<c:set var="LABELSITRCOUNT" value="${LABELSITRCOUNT + 1}" scope="page"/>
						</c:forEach>
						<c:if test="${LABELSITRCOUNT % 2 != 0}">
								<td width="15%">&nbsp;</td>
								<td width="30%">&nbsp;</td>
							</tr>
						</c:if>
					</tbody>
				</table>
			</div>
			<div class="card-footer clearfix">
				<div class="pull-${dirR}">
					<!-- DOWNLOAD GENERATED CCR FILES -->
					<button type="submit" id="viewGeneratedCcrFiles${UNQID}" class="btn btn-primary btn-sm">View Generated Files</button>
					<button type="submit" id="searchCCReport${UNQID}" class="btn btn-success btn-sm"><spring:message code="app.common.searchButton"/></button>
					<input type="reset" id="clearCCReport${UNQID}" class="btn btn-danger btn-sm" name="ClearCCReport" value="Clear"/>
					<button  type="button" id="uploadCCR${UNQID}" class="btn btn-warning btn-sm">Upload CCR</button>
					<button  type="button" id="generateNewCCR${UNQID}" class="btn btn-primary btn-sm">Generate New CCR</button>
				</div>
			</div>
			</form>
			</div>
		</div>
		<div class="card card-primary" id="counterfeitCurrencyReportSerachResultPanel${UNQID}" style="display: none;">
			<div class="card-header panelSlidingCCReport${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}"><spring:message code="app.common.counterfeitCurrencyReportResultHeader"/></h6>
				<div class="btn-group pull-${dirR} clearfix">
					<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
				</div>
			</div>
			<div id="counterfeitCurrencyReportSerachResult${UNQID}"></div>
		</div>
	</div>
</div>




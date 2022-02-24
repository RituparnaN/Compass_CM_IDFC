<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../../../tags/tags.jsp"%>

<script type="text/javascript"	src="${pageContext.request.contextPath}/includes/scripts/CompassEmailExchange.js"></script>

<%-- <c:set var="ROLE" value="${f:substring(userRole,5,userRole.length())}"/> --%>
<script type="text/javascript">
	$(document).ready(function() {
		var id = '${UNQID}';
		var isDefaultDateRequired = false;
		compassTopFrame.init(id, 'amlUserPendingCaseTable'+id, 'dd/mm/yy',isDefaultDateRequired);

		$("#FROMDATE_"+id).val("");
		$("#TODATE_"+id).val("");
		
		$('.panelSlidingAmlUserPendingCase'+id).on("click", function (e) {
			var mainRow = $(this).parents(".compassrow"+id);
			compassTopFrame.searchPanelSliding(id, mainRow, 'amlUserPendingCaseSerachResultPanel');
	    });
		
		$("#searchMasterForm"+id).submit(function(e){
			var submitButton = $("#searchAmlUserPendingCase"+id);
			compassTopFrame.submitForm(id, e, submitButton, 'amlUserPendingCaseSerachResultPanel', 
					'amlUserPendingCaseSerachResult', '${pageContext.request.contextPath}/amlCaseWorkFlow/searchPendingCases',
					'${pageContext.request.contextPath}/includes/images/qde-loadder.gif');
		});
		
		$('#searchMasterForm'+id).trigger('submit');
		
		$("#attachEvedence"+id).click(function(){
			var caseNo = "";
			var count = 0;
			$("#amlUserPendingCaseSerachResult"+id).find("table").children("tbody").children("tr").each(function(){
				if($(this).children("td").children("input").prop("checked")){
					caseNo = $(this).children("td").children("input").val();
					count++;
				}
			});
			if(count == 0){
				alert("Select a record");
			}else if(count > 1){
				alert("Select only one record");
			} else {
			compassFileUpload.init("attachEvedence","${pageContext.request.contextPath}","5678","amlUserPendingCaseSerachResult"+id,"Y","Y");
			}
		});
		
		$("#fatca8966"+id).click(function(){
			var caseNo = "";
			var count = 0;
			$("#amlUserPendingCaseSerachResult"+id).find("table").children("tbody").children("tr").each(function(){
				if($(this).children("td").children("input").prop("checked")){
					caseNo = $(this).children("td").children("input").val();
					count++;
				}
			});
			if(count == 0){
				alert("Select a record");
			}else if(count > 1){
				alert("Select only one record");
			} else {
				$("#compassCaseWorkFlowGenericModal").modal("show");
				$("#compassCaseWorkFlowGenericModal-title").html("FATCA 8966 : "+caseNo);
				$("#compassCaseWorkFlowGenericModal-body").html("<br/><center><img alt='Loading...' src='${pageContext.request.contextPath}/includes/images/qde-loadder.gif'></center><br/>");
				$.ajax({
					url: "${pageContext.request.contextPath}/common/get8966Form",
					cache: false,
					type: "POST",
					data: "caseNo="+caseNo,
					success: function(res) {
						$("#compassCaseWorkFlowGenericModal-body").html(res);
					},
					error: function(a,b,c) {
						alert(a+b+c);
					}
				});
			}
		});
		
		$("#emailExchange"+id).click(function(){
			var caseNo = "";
			var count = 0;
			$("#amlUserPendingCaseSerachResult"+id).find("table").children("tbody").children("tr").each(function(){
				if($(this).children("td").children("input").prop("checked")){
					caseNo = $(this).children("td").children("input").val();
					count++;
				}
			});
			if(count == 0){
				alert("Select a record");
			}else if(count > 1){
				alert("Select only one record");
			} else {
				compassEmailExchange.openEmail('${pageContext.request.contextPath}', caseNo, '', 'INBOX');
			}
			/*
			if(caseNo == ""){
				alert("Select a record");
			}else{
				compassEmailExchange.openEmail('${pageContext.request.contextPath}', caseNo, '', 'INBOX');
			}
			*/
		});
		//Called the generic clear function
		genericClear(id);
		
	});
</script>
<div class="row compassrow${UNQID}">
	<div class="col-sm-12">
		<div class="card card-primary panel_amlUserPendingCase">
			<div class="card-header panelSlidingAmlUserPendingCase${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}"><spring:message code="app.common.amlUserPendingCaseSearchHeader"/></h6>
				<div class="btn-group pull-${dirR} clearfix">
					<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
				</div>
			</div>
			<div class="panelSearchForm">
			<form action="javascript:void(0)" method="POST" id="searchMasterForm${UNQID}">
			<input type="hidden" name="moduleType" value="${MODULETYPE}">
			<input type="hidden" name="bottomPageUrl" value="AMLCaseWorkFlow/User/PendingCases/SearchBottomPage">
			<div class="card-search-card" >
				<table class="table table-striped formSearchTable amlUserPendingCaseTable${UNQID}" style="margin-bottom: 0px;">
					<tbody>
						<c:set var="LABELSCOUNT" value="${f:length(MASTERSEARCHFRAME)}"/>
						<c:set var="LABELSITRCOUNT" value="0" scope="page"/>
						
						<c:forEach var="ALLLABELSMAP" items="${MASTERSEARCHFRAME}">
							<c:choose>
								<c:when test="${LABELSITRCOUNT % 2 == 0}">
									<tr>
										<td width="15%"><spring:message code="${ALLLABELSMAP['MODULEPARAMNAME']}"/></td>
										<td width="30%">
											<c:if test="${ALLLABELSMAP['MODULEPARAMDATATYPE'] eq 'date'}">
												<input type="text" value="${ALLLABELSMAP['MODULEPARAMDEFAULTVALUE']}" class="form-control input-sm datepicker" id="${ALLLABELSMAP['MODULEPARAMIDNAME']}_${UNQID}" name="${ALLLABELSMAP['MODULEPARAMINDEX']}_${ALLLABELSMAP['MODULEPARAMIDNAME']}"/>
											</c:if>
											<c:if test="${ALLLABELSMAP['MODULEPARAMDATATYPE'] eq 'select'}">
												<c:set var="SELECTOPTIONNAMEVALUE" value="${ALLLABELSMAP['MODULEPARAMSELECTNAMEVALUES']}"/>
												
												<select class="form-control input-sm" id="${ALLLABELSMAP['MODULEPARAMIDNAME']}_${UNQID}" name="${ALLLABELSMAP['MODULEPARAMINDEX']}_${ALLLABELSMAP['MODULEPARAMIDNAME']}">
													<c:forEach var="NAMEVALUE" items="${SELECTOPTIONNAMEVALUE}">
														<option value="${NAMEVALUE.key}">${NAMEVALUE.value}</option>
													</c:forEach>
												</select>
											</c:if>
											<c:if test="${ALLLABELSMAP['MODULEPARAMDATATYPE'] eq 'text'}">
												<input type="text" value="${ALLLABELSMAP['MODULEPARAMDEFAULTVALUE']}" class="form-control input-sm" id="${ALLLABELSMAP['MODULEPARAMIDNAME']}_${UNQID}" name="${ALLLABELSMAP['MODULEPARAMINDEX']}_${ALLLABELSMAP['MODULEPARAMIDNAME']}"/>
											</c:if>
											<c:if test="${ALLLABELSMAP['MODULEPARAMDATATYPE'] eq 'view'}">
												<div class="input-group" style="z-index: 1">
													<input type="text" value="${ALLLABELSMAP['MODULEPARAMDEFAULTVALUE']}" 
													class="form-control input-sm" aria-describedby="basic-addon${UNQID}" 
													id="${ALLLABELSMAP['MODULEPARAMIDNAME']}_${UNQID}" 
													validation="${ALLLABELSMAP['MODULEPARAMVALIDATIONFIELD']}"
													name="${ALLLABELSMAP['MODULEPARAMINDEX']}_${ALLLABELSMAP['MODULEPARAMIDNAME']}"/>
													<span class="input-group-addon" id="basic-addon${UNQID}" 
													onclick="compassTopFrame.moduleSearch('${ALLLABELSMAP['MODULEPARAMIDNAME']}_${UNQID}','${ALLLABELSMAP['MODULEPARAMIDNAME']}','${ALLLABELSMAP['MODULEPARAMVIEWNAME']}','${ALLLABELSMAP['SEARCHMULTIPLESELECT']}','${pageContext.request.contextPath}')" style="cursor: pointer;" title="Search">
														<i class="fa fa-search"></i>
													</span>
												</div>
											</c:if>
										</td>
										<td width="10%">&nbsp;</td>
								</c:when>
								<c:otherwise>
										<td width="15%"><spring:message code="${ALLLABELSMAP['MODULEPARAMNAME']}"/></td>
										<td width="30%">
											<c:if test="${ALLLABELSMAP['MODULEPARAMDATATYPE'] eq 'date'}">
												<input type="text" value="${ALLLABELSMAP['MODULEPARAMDEFAULTVALUE']}" class="form-control input-sm datepicker" id="${ALLLABELSMAP['MODULEPARAMIDNAME']}_${UNQID}" name="${ALLLABELSMAP['MODULEPARAMINDEX']}_${ALLLABELSMAP['MODULEPARAMIDNAME']}"/>
											</c:if>
											<c:if test="${ALLLABELSMAP['MODULEPARAMDATATYPE'] eq 'select'}">
												<c:set var="SELECTOPTIONNAMEVALUE" value="${ALLLABELSMAP['MODULEPARAMSELECTNAMEVALUES']}"/>
												
												<select class="form-control input-sm" id="${ALLLABELSMAP['MODULEPARAMIDNAME']}_${UNQID}" name="${ALLLABELSMAP['MODULEPARAMINDEX']}_${ALLLABELSMAP['MODULEPARAMIDNAME']}">
													<c:forEach var="NAMEVALUE" items="${SELECTOPTIONNAMEVALUE}">
														<option value="${NAMEVALUE.key}">${NAMEVALUE.value}</option>
													</c:forEach>
												</select>
											</c:if>
											<c:if test="${ALLLABELSMAP['MODULEPARAMDATATYPE'] eq 'text'}">
												<input type="text" value="${ALLLABELSMAP['MODULEPARAMDEFAULTVALUE']}" class="form-control input-sm" id="${ALLLABELSMAP['MODULEPARAMIDNAME']}_${UNQID}" name="${ALLLABELSMAP['MODULEPARAMINDEX']}_${ALLLABELSMAP['MODULEPARAMIDNAME']}"/>
											</c:if>
											<c:if test="${ALLLABELSMAP['MODULEPARAMDATATYPE'] eq 'view'}">
												<div class="input-group" style="z-index: 1">
													<input type="text" value="${ALLLABELSMAP['MODULEPARAMDEFAULTVALUE']}" 
													class="form-control input-sm" aria-describedby="basic-addon${UNQID}" 
													id="${ALLLABELSMAP['MODULEPARAMIDNAME']}_${UNQID}" 
													validation="${ALLLABELSMAP['MODULEPARAMVALIDATIONFIELD']}"
													name="${ALLLABELSMAP['MODULEPARAMINDEX']}_${ALLLABELSMAP['MODULEPARAMIDNAME']}"/>
													<span class="input-group-addon" id="basic-addon${UNQID}" 
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
					<button  type="submit" id="searchAmlUserPendingCase${UNQID}" class="btn btn-success btn-sm"><spring:message code="app.common.searchButton"/></button>
					<input type="button" id="clear${UNQID}" class="btn btn-danger btn-sm" name="Clear" value="Clear"/>
				</div>
			</div>
			</form>
			</div>
		</div>
		<div class="card card-primary" id="amlUserPendingCaseSerachResultPanel${UNQID}" style="display: none;">
			<div class="card-header panelSlidingAmlUserPendingCase${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}"><spring:message code="app.common.amlUserPendingCaseResultHeader"/></h6>
				<div class="btn-group pull-${dirR} clearfix">
					<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
				</div>
			</div>
			
			<div class="card-footer action-footer clearfix">
				<div class="pull-${dirR} clearfix">
					
					<%-- <button type="button" class="btn btn-primary btn-sm" onclick="caseWorkFlowActions.desktopCloserByBranchUser('amlUserPendingCaseSerachResult${UNQID}','${UNQID}')">Desktop Closure</button> --%>
					
					<button type="button" class="btn btn-primary btn-sm" onclick="caseWorkFlowActions.escalateCaseByBranchUser('amlUserPendingCaseSerachResult${UNQID}','${UNQID}')">Escalate Case</button>
					
					<button type="button" class="btn btn-primary btn-sm" onclick="caseWorkFlowActions.viewComments('amlUserPendingCaseSerachResult${UNQID}','${UNQID}')">View Comment</button>
					
					<!-- <button type="button" class="btn btn-primary btn-sm" id="viewSLSTR">View STR</button>
					
					<button type="button" class="btn btn-primary btn-sm" id="fatca8966">FATCA 8966</button> -->
					
					<button type="button" class="btn btn-primary btn-sm" id="attachEvedence${UNQID}">Attach Evidence</button>
					
					<!-- <button type="button" class="btn btn-primary btn-sm" id="addViewEDD">Add/View EDD</button> -->
		
					<button type="button" class="btn btn-primary btn-sm" id="emailExchange${UNQID}">To Business</button>
				</div>
			</div>
			
			<div id="amlUserPendingCaseSerachResult${UNQID}"></div>
			
			<div class="card-footer action-footer clearfix">			
			
		</div>
	</div>
</div>
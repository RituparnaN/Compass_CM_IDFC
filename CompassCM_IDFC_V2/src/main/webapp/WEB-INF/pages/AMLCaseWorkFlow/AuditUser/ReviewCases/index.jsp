<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../../../tags/tags.jsp"%>
<script type="text/javascript">
	$(document).ready(function() {
		var id = '${UNQID}';
		compassTopFrame.init(id, 'amlUserClosedCaseTable'+id, 'dd/mm/yy');
		
		$('.panelSlidingAmlUserClosedCase'+id).on("click", function (e) {
			var mainRow = $(this).parents(".compassrow"+id);
			compassTopFrame.searchPanelSliding(id, mainRow, 'amlUserClosedCaseSerachResultPanel');
	    });
		
		$("#searchMasterForm"+id).submit(function(e){
			var submitButton = $("#searchAmlUserClosedCase"+id);
			compassTopFrame.submitForm(id, e, submitButton, 'amlUserClosedCaseSerachResultPanel', 
					'amlUserClosedCaseSerachResult', '${pageContext.request.contextPath}/amlCaseWorkFlow/searchClosedCases',
					'${pageContext.request.contextPath}/includes/images/qde-loadder.gif');
		});
		
		$("#attachEvedence").click(function(){
			var caseNo = "";
			var count = 0;
			$("#amlUserClosedCaseSerachResult"+id).find("table").children("tbody").children("tr").each(function(){
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
			compassFileUpload.init("attachEvedence","${pageContext.request.contextPath}","5678","amlUserClosedCaseSerachResult"+id,"N","N");
			}
		});
		
		$("#fatca8966").click(function(){
			var caseNo = "";
			var count = 0;
			$("#amlUserClosedCaseSerachResult"+id).find("table").children("tbody").children("tr").each(function(){
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

		$("#assignToBranchUser").click(function(){
			var caseNo = "";
			var count = 0;
			$("#amlUserClosedCaseSerachResult"+id).find("table").children("tbody").children("tr").each(function(){
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
				// window.open("${pageContext.request.contextPath}/common/getSLSTR?caseNo="+caseNo);
				window.open("${pageContext.request.contextPath}/common/getINDSTRReport?l_strAlertNo="+caseNo+'&canUpdated=Y&canExported=N');
			}
		});
		/*
		$("#addViewEDD").click(function(){
			var caseNo = "";
			var count = 0;
			var userCode = "";
			$("#amlUserClosedCaseSerachResult"+id).find("table").children("tbody").children("tr").each(function(){
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
				window.open("${pageContext.request.contextPath}/common/showEDD?AlertNo="+caseNo+"&userCode="+userCode,'AddEDD','width=1000 toolbar=no,resizable=no,location=no, height=650 scrollbars=yes, top=250, left=100')
			}
		});
        */

        $("#ukSAR").click(function(){
			var caseNoUKSAR = "";
			var selectedCount = 0;
			
			$("#amlUserClosedCaseSerachResult"+id).find("table").children("tbody").children("tr").each(function(){
				var checkbox = $(this).children("td:first-child").children("input");
				var caseNo = $(this).children("td:nth-child(3)").html();
				if($(checkbox).prop("checked")){
					caseNoUKSAR = caseNo;
					selectedCount++;
				}
			});
			// alert(caseNoUKSAR);
			if (selectedCount > 1 || selectedCount == 0)
				alert("You can view SAR on a single case number at a time.");
			else
				window.open("${pageContext.request.contextPath}/common/ukSAR?caseNo="+caseNoUKSAR, "UK_SAR", "");
		});
		 
        $("#addViewEDD").click(function(){
			var caseNoForEDD = "";
			var selectedCount = 0;
			
			$("#amlUserClosedCaseSerachResult"+id).find("table").children("tbody").children("tr").each(function(){
				var checkbox = $(this).children("td:first-child").children("input");
				var caseNo = $(this).children("td:nth-child(3)").html();
				if($(checkbox).prop("checked")){
					caseNoForEDD = caseNo;
					selectedCount++;
				}
			});
			
			if (selectedCount > 1 || selectedCount == 0)
				alert("You can view EDD on a single case number at a time.");
			else{
				$("#compassCaseWorkFlowGenericModal").modal("show");
				$("#compassCaseWorkFlowGenericModal-title").html("View EDD");
				$.ajax({
					url: "${pageContext.request.contextPath}/common/viewEddRecords",
					cache: false,
					type: "POST",
					data: "caseNoForEDD="+caseNoForEDD,
					success: function(response) {
						$("#compassCaseWorkFlowGenericModal-body").html(response);
					},
					error: function(a,b,c) {
						alert(a+b+c);
					}
				});
			}
		});
		$("#viewSLSTR").click(function(){
			var caseNo = "";
			var count = 0;
			$("#amlUserClosedCaseSerachResult"+id).find("table").children("tbody").children("tr").each(function(){
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

				window.open("${pageContext.request.contextPath}/common/getSLSTR?caseNo="+caseNo);
				// window.open("${pageContext.request.contextPath}/common/getINDSTRReport?l_strAlertNo="+caseNo+'&canUpdated=Y&canExported=N');
				/*
				$("#compassCaseWorkFlowGenericModal").modal("show");
				$("#compassCaseWorkFlowGenericModal-title").html("SriLanka STR : "+caseNo);
				$("#compassCaseWorkFlowGenericModal-body").html("<br/><center><img alt='Loading...' src='${pageContext.request.contextPath}/includes/images/qde-loadder.gif'></center><br/>");
				$.ajax({
					url: "${pageContext.request.contextPath}/common/getSLSTR",
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
				*/
			}
		});

		$("#viewIndiaSTR").click(function(){
			var caseNo = "";
			var count = 0;
			$("#amlUserClosedCaseSerachResult"+id).find("table").children("tbody").children("tr").each(function(){
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

				window.open("${pageContext.request.contextPath}/common/getINDSTRReport?l_strAlertNo="+caseNo+'&canUpdated=Y&canExported=N');
				/*
				$("#compassCaseWorkFlowGenericModal").modal("show");
				$("#compassCaseWorkFlowGenericModal-title").html("SriLanka STR : "+caseNo);
				$("#compassCaseWorkFlowGenericModal-body").html("<br/><center><img alt='Loading...' src='${pageContext.request.contextPath}/includes/images/qde-loadder.gif'></center><br/>");
				$.ajax({
					url: "${pageContext.request.contextPath}/common/getSLSTR",
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
				*/
			}
		});
		
		$("#emailExchange").click(function(){
			var caseNo = "";
			$("#amlUserClosedCaseSerachResult"+id).find("table").children("tbody").children("tr").each(function(){
				if($(this).children("td").children("input").prop("checked")){
					caseNo = $(this).children("td").children("input").val();
				}
			});
			if(caseNo == ""){
				alert("Select a record");
			}else{
				compassEmailExchange.openEmail('${pageContext.request.contextPath}', caseNo, '', 'INBOX');
			}
		});
	});
</script>
<div class="row compassrow${UNQID}">
	<div class="col-sm-12">
		<div class="card card-primary panel_amlUserClosedCase">
			<div class="card-header panelSlidingAmlUserClosedCase${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}"><spring:message code="app.common.amlUserClosedCaseSearchHeader"/></h6>
				<div class="btn-group pull-${dirR} clearfix">
					<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
				</div>
			</div>
			<div class="panelSearchForm">
			<form action="javascript:void(0)" method="POST" id="searchMasterForm${UNQID}">
			<input type="hidden" name="moduleType" value="${MODULETYPE}">
			<input type="hidden" name="bottomPageUrl" value="AMLCaseWorkFlow/AuditUser/ReviewCases/SearchBottomPage">
			<div class="card-search-card" >
				<table class="table table-striped formSearchTable amlUserClosedCaseTable${UNQID}" style="margin-bottom: 0px;">
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
													<span class="input-group-addon formSearchIcon" id="basic-addon${UNQID}" 
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
					<button  type="submit" id="searchAmlUserClosedCase${UNQID}" class="btn btn-success btn-sm"><spring:message code="app.common.searchButton"/></button>
				</div>
			</div>
			</form>
			</div>
		</div>
		<div class="card card-primary" id="amlUserClosedCaseSerachResultPanel${UNQID}" style="display: none;">
			<div class="card-header panelSlidingAmlUserClosedCase${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}"><spring:message code="app.common.auditUserReviewCaseResultHeader"/></h6>
				<div class="btn-group pull-${dirR} clearfix">
					<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
				</div>
			</div>
			<div id="amlUserClosedCaseSerachResult${UNQID}"></div>
			
			<div class="card-footer action-footer clearfix">
				<div class="pull-${dirR} clearfix">
					<!-- 
					<button type="button" class="btn btn-primary btn-sm" onclick="caseWorkFlowActions.desktopCloser('amlUserClosedCaseSerachResult${UNQID}','${UNQID}')">Desktop Closure</button>
					
					<div class="btn-group dropup" role="group">
						<button type="button" class="btn btn-primary btn-sm dropdown-toggle" data-toggle="dropdown" aria-expanded="false">
							Close Case
							<span class="caret"></span>
						</button>
						<ul class="dropdown-menu" role="menu">
							<li><a href="javascript:void(0)" onclick="caseWorkFlowActions.closeWithSTR('amlUserClosedCaseSerachResult${UNQID}','${UNQID}')">With STR</a></li>
							<li><a href="javascript:void(0)" onclick="caseWorkFlowActions.closeWithoutSTR('amlUserClosedCaseSerachResult${UNQID}','${UNQID}')">Without STR</a></li>
						</ul>
					</div>
					 -->
					<button type="button" class="btn btn-primary btn-sm" onclick="caseWorkFlowActions.viewComments('amlUserClosedCaseSerachResult${UNQID}','${UNQID}')">View Comment</button>
					
					<!-- <button type="button" class="btn btn-primary btn-sm" id="viewIndiaSTR">Indian STR</button>
					<button type="button" class="btn btn-primary btn-sm" id="viewSLSTR">SL STR</button>
		            <button type="button" class="btn btn-primary btn-sm" id="ukSAR">UK SAR</button>-->
		            
		            <!--<div class="btn-group dropup" role="group">
						<button type="button" class="btn btn-primary btn-sm dropdown-toggle" data-toggle="dropdown" aria-expanded="false">
							View STR
							<span class="caret"></span>
						</button>
						<ul class="dropdown-menu" role="menu">
							<!--<li><a href="javascript:void(0)" onclick="caseWorkFlowActions.viewIndianSTR('amlUserPendingCaseSerachResult${UNQID}','${UNQID}')">Indian STR</a></li>
							<li><a href="javascript:void(0)" onclick="caseWorkFlowActions.viewSriLankanSTR('amlUserPendingCaseSerachResult${UNQID}','${UNQID}')">SL STR</a></li>
							<li><a href="javascript:void(0)" onclick="caseWorkFlowActions.viewUKSTR('amlUserPendingCaseSerachResult${UNQID}','${UNQID}')">UK SAR</a></li>
							<li><a href="javascript:void(0)" onclick="caseWorkFlowActions.viewMaldivesSTR('amlUserPendingCaseSerachResult${UNQID}','${UNQID}')">Maldives STR</a></li>
							<li><a href="javascript:void(0)" onclick="caseWorkFlowActions.viewNepalSTR('amlUserPendingCaseSerachResult${UNQID}','${UNQID}')">Nepal STR</a></li> -->
						<!--</ul>
					</div>
		            -->
					<%-- <button type="button" class="btn btn-primary btn-sm" onclick="caseWorkFlowActions.viewIndianSTR('amlUserClosedCaseSerachResult${UNQID}','${UNQID}')">View STR</button> --%>
								
					<!--<button type="button" class="btn btn-primary btn-sm" id="fatca8966">FATCA 8966</button>-->
					
					<!-- <button type="button" class="btn btn-primary btn-sm" id="attachEvedence">Attach Evidence</button>-->
					
					<!-- <button type="button" class="btn btn-primary btn-sm" id="addViewEDD">Add EDD</button>-->
					<!-- <button type="button" class="btn btn-primary btn-sm" id="addViewEDD">View EDD</button> -->
		
					<!-- <button type="button" class="btn btn-primary btn-sm" onclick="caseWorkFlowActions.assignToBranchUserByAMLuser('amlUserClosedCaseSerachResult${UNQID}','${UNQID}')">Assign To BranchUser</button>-->
					<!-- <button type="button" class="btn btn-primary btn-sm" id="assignToBranchUser">Assign To BranchUser</button>-->

					<!-- <button type="button" class="btn btn-primary btn-sm" id="emailExchange">To Business</button> -->
				</div>
			</div>
		</div>
	</div>
</div>
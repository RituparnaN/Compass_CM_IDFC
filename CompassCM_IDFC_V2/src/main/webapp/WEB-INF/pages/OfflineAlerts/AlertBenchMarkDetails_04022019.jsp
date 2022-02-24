<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../tags/tags.jsp"%>
<%
String CURRENTROLE = (String) request.getSession(false).getAttribute("CURRENTROLE");
String prefix = CURRENTROLE+"_CN_";
%>

<script type="text/javascript">
	$(document).ready(function() {
		var viewType = '${viewType}';
		var alertId = '${alertId}';
		var alertSerialNo = '${alertSerialNo}';
		var id = '${UNQID}';

		var benchMarkStatus = '${BENCHMARKSTATUS['STATUS']}';
		var requestType = '${BENCHMARKSTATUS['REQUESTTYPE']}';
			
		
		compassTopFrame.init(id, 'alertBenchMarkDtlsTable'+id, 'dd/mm/yy');
		
		$('.panelSlidingalertBenchMarkDtls'+id).on("click", function (e) {
			var mainRow = $(this).parents(".compassmodalrow"+id);
			compassTopFrame.searchPanelSliding(id, mainRow, 'alertBenchMarkDtlsSerachResultPanel');
	    });

		// $("#searchalertBenchMarkDtlsForm"+id).click(function(e){
		$("#savealertBenchMarkDtls"+id).click(function(e){
			var button = $(this);
			button.attr("disabled","disabled");
			var userLogcomments = prompt("Please enter your comments before saving."); 
			if(userLogcomments != null){
				/* $("#compassMediumGenericModal").modal("show");
				$("#compassMediumGenericModal-title").html("Put Comments");
				$("#compassMediumGenericModal-body").html("<br/><center><img alt='Loading...' src='${pageContext.request.contextPath}/includes/images/qde-loadder.gif'><center><br/>");
				*/
				var formObj = $("#searchalertBenchMarkDtlsForm"+id);
				var formData = (formObj).serialize();
				$.ajax({
					url: "${pageContext.request.contextPath}/admin/saveAlertBenchMarkParameters" ,
					cache: false,
					data: formData+"&alertId="+alertId+"&id="+id+"&viewType="+viewType+"&alertSerialNo="+alertSerialNo+"&userLogcomments="+userLogcomments,
					type: 'POST',
					success: function(res){
						alert('Successfully Saved.');
						$("#compassGenericModal").modal("hide");
						$(".offlineAlertsListTable"+id).children("tbody").children("tr").each(function(){
							var td = $(this).children("td:first-child");
							if($(td).html() == alertId)
								$(td).click();
						});
					},
					error: function(a,b,c){
						alert(a+b+c);
					},complete: function(){
						button.removeAttr("disabled");
					}
				});
			}else{
				button.removeAttr("disabled");
			}
		});

		$("#approvealertBenchMarkDtls"+id).click(function(e){
			var userLogcomments = prompt("Please enter your comments before saving."); 
			if(userLogcomments != null){
			// if(confirm("Are you sure you want to Save?")){
				var formObj = $("#searchalertBenchMarkDtlsForm"+id);
				var formData = (formObj).serialize();
				
				$.ajax({
					url: "${pageContext.request.contextPath}/admin/approveAlertBenchMarkParameters" ,
					cache: false,
					data: formData+"&alertId="+alertId+"&id="+id+"&viewType="+viewType+"&alertSerialNo="+alertSerialNo+"&requestType="+requestType+"&benchMarkStatus="+benchMarkStatus+"&userLogcomments="+userLogcomments,
					type: 'POST',
					success: function(res){
						alert('Successfully Saved.');
						$("#compassGenericModal").modal("hide");
						$(".offlineAlertsListTable"+id).children("tbody").children("tr").each(function(){
							var td = $(this).children("td:first-child");
							if($(td).html() == alertId)
								$(td).click();
						});
					},
					error: function(a,b,c){
						alert(a+b+c);
					}
				});
			}			
		});

		$("#rejectalertBenchMarkDtls"+id).click(function(e){
			var userLogcomments = prompt("Please enter your comments before saving."); 
			if(userLogcomments != null){
			// if(confirm("Are you sure you want to Save?")){
				var formObj = $("#searchalertBenchMarkDtlsForm"+id);
				var formData = (formObj).serialize();

				$.ajax({
					url: "${pageContext.request.contextPath}/admin/rejectAlertBenchMarkParameters" ,
					cache: false,
					data: formData+"&alertId="+alertId+"&id="+id+"&viewType="+viewType+"&alertSerialNo="+alertSerialNo+"&requestType="+requestType+"&benchMarkStatus="+benchMarkStatus+"&userLogcomments="+userLogcomments,
					type: 'POST',
					success: function(res){
						alert('Successfully Saved.');
						$("#compassGenericModal").modal("hide");
						$(".offlineAlertsListTable"+id).children("tbody").children("tr").each(function(){
							var td = $(this).children("td:first-child");
							if($(td).html() == alertId)
								$(td).click();
						});
					},
					error: function(a,b,c){
						alert(a+b+c);
					}
				});
			}			
		});
		
		$("#generatealertBenchMarkDtls"+id).click(function(e){
			var button = $(this);
			button.attr("disabled","disabled");
			var mainRow = $(this).parents("div.compassmodalrow"+id);
			var slidingDiv = $(mainRow).children().children().children();
			var panelBody = $(mainRow).children().children().find(".panelSearchForm");
			var generationType = "ALERTDATA";
			if(confirm("Are you sure you want to Generate Alert?")){
				var formObj = $("#searchalertBenchMarkDtlsForm"+id);
				var formData = (formObj).serialize();
				$.ajax({
					url: "${pageContext.request.contextPath}/admin/generateAlertWithBenchMarks" ,
					cache: false,
					data: formData+"&alertId="+alertId+"&id="+id+"&viewType="+viewType+"&alertSerialNo="+alertSerialNo+"&generationType="+generationType,
					type: 'POST',
					success: function(res){
						$("#alertBenchMarkDtlsSerachResultPanel"+id).css("display", "block");
						$("#alertBenchMarkDtlsSerachResult"+id).html(res);
						$(panelBody).slideUp();
						$(slidingDiv).addClass('card-collapsed');
						$(slidingDiv).find('i.collapsable').removeClass('fa-chevron-up').addClass('fa-chevron-down');
						$(mainRow).next().find(".compassmodalrow"+id).find(".card-header").next().slideDown();
					},
					error: function(a,b,c){
						alert(a+b+c);
					},complete: function (){
						button.removeAttr("disabled");
					}
				});
			}else{
				button.removeAttr("disabled");
			}			
		});

		$("#simulateAlertBenchMarkDtls"+id).click(function(e){
			var mainRow = $(this).parents("div.compassmodalrow"+id);
			var slidingDiv = $(mainRow).children().children().children();
			var panelBody = $(mainRow).children().children().find(".panelSearchForm");
			var generationType = "ALERTDATA";
			if(confirm("Are you sure you want to Generate Alert?")){
				var formObj = $("#searchalertBenchMarkDtlsForm"+id);
				var formData = (formObj).serialize();
				$.ajax({
					url: "${pageContext.request.contextPath}/admin/simulateAlertWithBenchMarks" ,
					cache: false,
					data: formData+"&alertId="+alertId+"&id="+id+"&viewType="+viewType+"&alertSerialNo="+alertSerialNo+"&generationType="+generationType,
					type: 'POST',
					success: function(res){
						$("#alertBenchMarkDtlsSerachResultPanel"+id).css("display", "block");
						$("#alertBenchMarkDtlsSerachResult"+id).html(res);
						$(panelBody).slideUp();
						$(slidingDiv).addClass('card-collapsed');
						$(slidingDiv).find('i.collapsable').removeClass('fa-chevron-up').addClass('fa-chevron-down');
						$(mainRow).next().find(".compassmodalrow"+id).find(".card-header").next().slideDown();
					},
					error: function(a,b,c){
						alert(a+b+c);
					}
				});
			}			
		});

		$("#deletealertBenchMarkDtls"+id).click(function(e){
			var button = $(this);
			button.prop("disabled", true);
			var formObj = $("#searchalertBenchMarkDtlsForm"+id);
			var formData = (formObj).serialize();
			var userLogcomments = prompt("Please enter your comments before saving."); 
			if(userLogcomments != null){
			// if(confirm("Are you sure you want to delete?")){
				$.ajax({
					url: "${pageContext.request.contextPath}/admin/deleteAlertBenchMarkParameters" ,
					cache: false,
					data: "alertId="+alertId+"&id="+id+"&viewType="+viewType+"&alertSerialNo="+alertSerialNo+"&userLogcomments="+userLogcomments,
					type: 'POST',
					success: function(res){
						alert('Successfully Deleted');
						$("#compassGenericModal").modal("hide");
						$(".offlineAlertsListTable"+id).children("tbody").children("tr").each(function(){
							var td = $(this).children("td:first-child");
							if($(td).html() == alertId)
								$(td).click();
						});
					},
					error: function(a,b,c){
						alert(a+b+c);
					},complete: function (){
						button.removeAttr("disabled");
					}
				});
			}else{
				button.removeAttr("disabled");		
			}
		});		
	});
</script>
<div class="row compassmodalrow${UNQID}">
	<div class="col-sm-12">
		<div class="card card-primary panel_alertBenchMarkDtls">
			<div class="card-header panelSlidingalertBenchMarkDtls${UNQID} clearfix">
				<!-- <h6 class="card-title pull-${dirL}"><spring:message code="app.common.alertBenchMarkDtlsSearchHeader"/></h6> -->
				<h6 class="card-title pull-${dirL}">${alertName}</h6>
				<div class="btn-group pull-${dirR} clearfix">
					<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
				</div>
			</div>
			<div class="panelSearchForm">
			<form action="javascript:void(0)" method="POST" id="searchalertBenchMarkDtlsForm${UNQID}">
			<input type="hidden" name="moduleType" value="${MODULETYPE}">
			<input type="hidden" name="bottomPageUrl" value="OfflineAlerts/AlertResult">
			<div class="card-search-card" >
				<table class="table table-striped formSearchTable alertBenchMarkDtlsTable${UNQID}" style="margin-bottom: 0px;">
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
												<input type="text" value="${ALLLABELSMAP['MODULEPARAMDEFAULTVALUE']}" class="form-control input-sm datepickerText" id="${ALLLABELSMAP['MODULEPARAMIDNAME']}_${UNQID}" name="${ALLLABELSMAP['MODULEPARAMINDEX']}_${ALLLABELSMAP['MODULEPARAMIDNAME']}"/>
											</c:if>
											<c:if test="${ALLLABELSMAP['MODULEPARAMDATATYPE'] eq 'select'}">
												<c:set var="SELECTOPTIONNAMEVALUE" value="${ALLLABELSMAP['MODULEPARAMSELECTNAMEVALUES']}"/>
												
												<select class="form-control input-sm" id="${ALLLABELSMAP['MODULEPARAMIDNAME']}_${UNQID}" name="${ALLLABELSMAP['MODULEPARAMINDEX']}_${ALLLABELSMAP['MODULEPARAMIDNAME']}">
													<c:forEach var="NAMEVALUE" items="${SELECTOPTIONNAMEVALUE}">
														<!-- <option value="${NAMEVALUE.key}">${NAMEVALUE.value}</option>-->
														<option value="${NAMEVALUE.key}"<c:if test="${ALLLABELSMAP['MODULEPARAMDEFAULTVALUE'] eq NAMEVALUE.key}">selected</c:if>>${NAMEVALUE.value}</option>
													</c:forEach>
												</select>
											</c:if>
											<c:if test="${ALLLABELSMAP['MODULEPARAMDATATYPE'] eq 'string'}">
												<input type="text" value="${ALLLABELSMAP['MODULEPARAMDEFAULTVALUE']}" class="form-control input-sm" id="${ALLLABELSMAP['MODULEPARAMIDNAME']}_${UNQID}" name="${ALLLABELSMAP['MODULEPARAMINDEX']}_${ALLLABELSMAP['MODULEPARAMIDNAME']}"/>
											</c:if>
											<c:if test="${ALLLABELSMAP['MODULEPARAMDATATYPE'] eq 'numeric'}">
												<input type="text" value="${ALLLABELSMAP['MODULEPARAMDEFAULTVALUE']}" class="form-control input-sm" id="${ALLLABELSMAP['MODULEPARAMIDNAME']}_${UNQID}" name="${ALLLABELSMAP['MODULEPARAMINDEX']}_${ALLLABELSMAP['MODULEPARAMIDNAME']}"/>
											</c:if>
											<c:if test="${ALLLABELSMAP['MODULEPARAMDATATYPE'] eq 'search'}">
												<div class="input-group" style="z-index: 1">
													<input type="text" value="${ALLLABELSMAP['MODULEPARAMDEFAULTVALUE']}" class="form-control input-sm" aria-describedby="basic-addon${UNQID}" id="${ALLLABELSMAP['MODULEPARAMIDNAME']}_${UNQID}" name="${ALLLABELSMAP['MODULEPARAMINDEX']}_${ALLLABELSMAP['MODULEPARAMIDNAME']}"/>
													<span class="input-group-addon" id="basic-addon${UNQID}" onclick="compassTopFrame.moduleSearch('${ALLLABELSMAP['MODULEPARAMIDNAME']}_${UNQID}','${ALLLABELSMAP['MODULEPARAMIDNAME']}','${ALLLABELSMAP['MODULEPARAMVIEWNAME']}','${ALLLABELSMAP['MODULEPARAMVALIDATIONFIELD']}','${pageContext.request.contextPath}')"  style="cursor: pointer;" title="Search">
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
												<input type="text" value="${ALLLABELSMAP['MODULEPARAMDEFAULTVALUE']}" class="form-control input-sm datepickerText" id="${ALLLABELSMAP['MODULEPARAMIDNAME']}_${UNQID}" name="${ALLLABELSMAP['MODULEPARAMINDEX']}_${ALLLABELSMAP['MODULEPARAMIDNAME']}"/>
											</c:if>
											<c:if test="${ALLLABELSMAP['MODULEPARAMDATATYPE'] eq 'select'}">
												<c:set var="SELECTOPTIONNAMEVALUE" value="${ALLLABELSMAP['MODULEPARAMSELECTNAMEVALUES']}"/>
												
												<select class="form-control input-sm" id="${ALLLABELSMAP['MODULEPARAMIDNAME']}_${UNQID}" name="${ALLLABELSMAP['MODULEPARAMINDEX']}_${ALLLABELSMAP['MODULEPARAMIDNAME']}">
													<c:forEach var="NAMEVALUE" items="${SELECTOPTIONNAMEVALUE}">
														<!-- <option value="${NAMEVALUE.key}">${NAMEVALUE.value}</option>-->
														<option value="${NAMEVALUE.key}"<c:if test="${ALLLABELSMAP['MODULEPARAMDEFAULTVALUE'] eq NAMEVALUE.key}">selected</c:if>>${NAMEVALUE.value}</option>
													</c:forEach>
												</select>
											</c:if>
											<c:if test="${ALLLABELSMAP['MODULEPARAMDATATYPE'] eq 'string'}">
												<input type="text" value="${ALLLABELSMAP['MODULEPARAMDEFAULTVALUE']}" class="form-control input-sm" id="${ALLLABELSMAP['MODULEPARAMIDNAME']}_${UNQID}" name="${ALLLABELSMAP['MODULEPARAMINDEX']}_${ALLLABELSMAP['MODULEPARAMIDNAME']}"/>
											</c:if>
											<c:if test="${ALLLABELSMAP['MODULEPARAMDATATYPE'] eq 'numeric'}">
												<input type="text" value="${ALLLABELSMAP['MODULEPARAMDEFAULTVALUE']}" class="form-control input-sm" id="${ALLLABELSMAP['MODULEPARAMIDNAME']}_${UNQID}" name="${ALLLABELSMAP['MODULEPARAMINDEX']}_${ALLLABELSMAP['MODULEPARAMIDNAME']}"/>
											</c:if>
											<c:if test="${ALLLABELSMAP['MODULEPARAMDATATYPE'] eq 'search'}">
												<div class="input-group" style="z-index: 1">
													<input type="text" value="${ALLLABELSMAP['MODULEPARAMDEFAULTVALUE']}" class="form-control input-sm" aria-describedby="basic-addon2" id="${ALLLABELSMAP['MODULEPARAMIDNAME']}_${UNQID}" name="${ALLLABELSMAP['MODULEPARAMINDEX']}_${ALLLABELSMAP['MODULEPARAMIDNAME']}"/>
													<span class="input-group-addon" id="basic-addon2" onclick="compassTopFrame.moduleSearch('${ALLLABELSMAP['MODULEPARAMIDNAME']}_${UNQID}','${ALLLABELSMAP['MODULEPARAMIDNAME']}','${ALLLABELSMAP['MODULEPARAMVIEWNAME']}','${ALLLABELSMAP['MODULEPARAMVALIDATIONFIELD']}','${pageContext.request.contextPath}')"  style="cursor: pointer;" title="Search">
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

						<c:if test="${(CURRENTROLE eq 'ROLE_MLRO' || CURRENTROLE eq 'ROLE_MLROL2')}">
							<td width="15%"><font color="red">Request For</font></td>
							<td width="15%">
								<input type="text" value="${BENCHMARKSTATUS['REQUESTTYPE']}" class="form-control input-sm" id="REQUESTTYPE"+"_${UNQID}" name="REQUESTTYPE" readOnly />
							</td>	
						</c:if>
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
					<c:if test="${(CURRENTROLE eq 'ROLE_ADMIN' || CURRENTROLE eq 'ROLE_AMLO' || CURRENTROLE eq 'ROLE_MLROL1')}">
					<button type="button" id="savealertBenchMarkDtls${UNQID}" class="btn btn-success btn-sm"><spring:message code="app.common.SAVEBUTTON"/></button>
					<button type="button" id="generatealertBenchMarkDtls${UNQID}" class="btn btn-primary btn-sm"><spring:message code="app.common.GENERATEBUTTON"/></button>
					<button type="button" id="deletealertBenchMarkDtls${UNQID}" class="btn btn-danger btn-sm"><spring:message code="app.common.DELETEBUTTON"/></button>
					<button type="button" id="simulateAlertBenchMarkDtls${UNQID}" class="btn btn-primary btn-sm"><spring:message code="app.common.SIMULATEBUTTON"/></button>
					</c:if>
					<c:if test="${(CURRENTROLE eq 'ROLE_MLRO' || CURRENTROLE eq 'ROLE_MLROL2')}">
					<button type="button" id="approvealertBenchMarkDtls${UNQID}" class="btn btn-success btn-sm"><spring:message code="app.common.APPROVEBUTTON"/></button>
					<button type="button" id="rejectalertBenchMarkDtls${UNQID}" class="btn btn-primary btn-sm"><spring:message code="app.common.REJECTBUTTON"/></button>
					</c:if>
				</div>
			</div>
			</form>
			</div>
		</div>
		<div class="card card-primary" id="alertBenchMarkDtlsSerachResultPanel${UNQID}" style="display: none;">
			<div class="card-header panelSlidingalertBenchMarkDtls${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}">Generated Alerts</h6>
				<div class="btn-group pull-${dirR} clearfix">
					<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
				</div>
			</div>
			<div id="alertBenchMarkDtlsSerachResult${UNQID}"></div>
		</div>
	</div>
</div>
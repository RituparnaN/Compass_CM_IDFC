<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../tags/tags.jsp"%>
<script type="text/javascript">
	$(document).ready(function() {
		var viewType = '${viewType}';
		var reportId = '${reportId}';
		var reportSerialNo = '${reportSerialNo}';
		var id = '${UNQID}';
		var group = '${group}';
		var reportId = '${reportId}';
		compassTopFrame.init(id, 'reportBenchMarkDtlsTable'+id, 'dd/mm/yy');
		
		$('.panelSlidingreportBenchMarkDtls'+id).on("click", function (e) {
			var mainRow = $(this).parents(".compassmodalrow"+id);
			compassTopFrame.searchPanelSliding(id, mainRow, 'reportBenchMarkDtlsSerachResultPanel');
	    });

		// $("#searchreportBenchMarkDtlsForm"+id).click(function(e){
		$("#savereportBenchMarkDtls"+id).click(function(e){
			
			if(confirm("Are you sure you want to Save?")){
				var formObj = $("#searchreportBenchMarkDtlsForm"+id);
				var formData = (formObj).serialize();

				$.ajax({
					url: "${pageContext.request.contextPath}/common/saveReportBenchMarkParameters" ,
					cache: false,
					data: formData+"&reportId="+reportId+"&id="+id+"&viewType="+viewType+"&reportSerialNo="+reportSerialNo+"&group="+group,
					type: 'POST',
					success: function(res){
						$("#compassGenericModal").modal("hide");
						alert("Successfully Saved")
						$(".reportsGenericListTable"+id).children("tbody").children("tr").each(function(){
							var td = $(this).children("td:first-child");
							if($(td).html() == reportId)
								$(td).click();
						});
					},
					error: function(a,b,c){
						alert(a+b+c);
					}
				});
			}			
		});
		
		$("#generatereportBenchMarkDtls"+id).click(function(e){
			var mainRow = $(this).parents("div.compassmodalrow"+id);
			var slidingDiv = $(mainRow).children().children().children();
			var panelBody = $(mainRow).children().children().find(".panelSearchForm");
			var generationType = "exportData";
			if(confirm("Are you sure you want to Generate Report?")){
				var formObj = $("#searchreportBenchMarkDtlsForm"+id);
				var formData = (formObj).serialize();
				$.ajax({
					url: "${pageContext.request.contextPath}/common/generateReportWithBenchMarks" ,
					cache: false,
					data: formData+"&reportId="+reportId+"&id="+id+"&viewType="+viewType+"&reportSerialNo="+reportSerialNo+"&generationType="+generationType+"&group="+group,
					type: 'POST',
					success: function(res){
						$("#reportBenchMarkDtlsSerachResultPanel"+id).css("display", "block");
						$("#reportBenchMarkDtlsSerachResult"+id).html(res);
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

		$("#exportExcelReportDtls"+id).click(function(e){
			var generationType = "exportExcel";
			if(confirm("Are you sure you want to Generate Excel Report?")){
				var formObj = $("#searchreportBenchMarkDtlsForm"+id);
				var formData = (formObj).serialize();
				$.fileDownload("${pageContext.request.contextPath}/common/generateReportWithBenchMarks?"+formData+"&reportId="+reportId+"&id="+id+"&viewType="+viewType+"&reportSerialNo="+reportSerialNo+"&generationType="+generationType+"&group="+group, {
				    httpMethod : "GET",
					successCallback: function (url) {					 
				    	$(elm).html("Downloaded");
				    },
				    failCallback: function (html, url) {
				        alert('Failed to download file'+url+"\n"+html);
				    }
				});
			}
		});


		$("#exportPDFReportDtls"+id).click(function(e){
			var generationType = "exportPDF";
			if(confirm("Are you sure you want to Generate PDF Report?")){
				var formObj = $("#searchreportBenchMarkDtlsForm"+id);
				var formData = (formObj).serialize();
				$.fileDownload("${pageContext.request.contextPath}/common/generateReportWithBenchMarks?"+formData+"&reportId="+reportId+"&id="+id+"&viewType="+viewType+"&reportSerialNo="+reportSerialNo+"&generationType="+generationType+"&group="+group, {
				    httpMethod : "GET",
					successCallback: function (url) {					 
				    	$(elm).html("Downloaded");
				    },
				    failCallback: function (html, url) {
				        alert('Failed to download file'+url+"\n"+html);
				    }
				});
			}			
		});
		
		$("#exportCSVReportDtls"+id).click(function(e){
			var generationType = "exportCSV";
			if(confirm("Are you sure you want to Generate CSV Report?")){
				var formObj = $("#searchreportBenchMarkDtlsForm"+id);
				var formData = (formObj).serialize();
				$.fileDownload("${pageContext.request.contextPath}/common/generateReportWithBenchMarks?"+formData+"&reportId="+reportId+"&id="+id+"&viewType="+viewType+"&reportSerialNo="+reportSerialNo+"&generationType="+generationType+"&group="+group, {
				    httpMethod : "GET",
					successCallback: function (url) {					 
				    	$(elm).html("Downloaded");
				    },
				    failCallback: function (html, url) {
				        alert('Failed to download file'+url+"\n"+html);
				    }
				});
			}			
		});
		
		$("#resetReportColumnsDtls"+id).click(function(e){
			if(confirm("Are you sure you want to reset columns?")){
				var url = "${pageContext.request.contextPath}/common/fetchDetailsToResetReportColumns?reportId="+reportId;
				window.open(url,'Reset Report Columns','height=600px,width=1000px');
			}
		});
		

		$("#deletereportBenchMarkDtls"+id).click(function(e){
			var formObj = $("#searchreportBenchMarkDtlsForm"+id);
			var formData = (formObj).serialize();
			
			if(confirm("Are you sure you want to delete?")){
				$.ajax({
					url: "${pageContext.request.contextPath}/common/deleteReportBenchMarkParameters" ,
					cache: false,
					data: "reportId="+reportId+"&id="+id+"&viewType="+viewType+"&reportSerialNo="+reportSerialNo+"&group="+group,
					type: 'POST',
					success: function(res){
						$("#compassGenericModal").modal("hide");
						alert("Successfully Deleted");
						$(".reportsGenericListTable"+id).children("tbody").children("tr").each(function(){
							var td = $(this).children("td:first-child");
							if($(td).html() == reportId)
								$(td).click();
						});
					},
					error: function(a,b,c){
						alert(a+b+c);
					}
				});
				
			}			
		});	
						
		/* $("#openModalInTab").click(function(){
			var moduleCode = 'reports';
			var moduleHeader = 'Report Details';
			var moduleValue = '${reportId}';
			var detailPage = 'Reports/ReportBenchMarkDetails';
			alert(moduleHeader+','+moduleValue+', '+moduleCode+', '+detailPage);
			if(moduleValue != undefined)
				alert(moduleValue);
				openModalInTab($(this), moduleHeader, moduleValue, moduleCode, detailPage);
		});
		
		$("#openModalInWindow").click(function(){
			var moduleCode = 'Reports';
			var moduleHeader = $("#compassGenericModal-body").find("div.card-body").children("input#moduleHeader"+id).val();
			var moduleValue = $("#compassGenericModal-body").find("div.card-body").find("input#moduleValue"+id).val();
			var detailPage = $("#compassGenericModal-body").find("div.card-body").children("input#detailPage"+id).val();
			//alert('sd');
			if(moduleValue != undefined)
				openModalInWindow($(this), moduleHeader, moduleValue, moduleCode, detailPage, true);
		}); */
		
	});
</script>
<div class="row compassmodalrow${UNQID}">
	<div class="col-sm-12">
		<div class="card card-primary panel_reportBenchMarkDtls">
			<div class="card-header panelSlidingreportBenchMarkDtls${UNQID} clearfix">
				<!-- <h6 class="card-title pull-${dirL}"><spring:message code="app.common.reportBenchMarkDtlsSearchHeader"/></h6> -->
				<h6 class="card-title pull-${dirL}">${reportName}</h6>
				<div class="btn-group pull-${dirR} clearfix">
					<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
				</div>
			</div>
			<div class="panelSearchForm">
			<form action="javascript:void(0)" method="POST" id="searchreportBenchMarkDtlsForm${UNQID}">
			<input type="hidden" name="moduleType" value="${MODULETYPE}">
			<input type="hidden" name="bottomPageUrl" value="Reports/ReportResult">
			<div class="card-search-card" >
				<table class="table table-striped formSearchTable reportBenchMarkDtlsTable${UNQID}" style="margin-bottom: 0px;">
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
														<option value="${NAMEVALUE.key}" <c:if test="${ALLLABELSMAP['MODULEPARAMDEFAULTVALUE'] eq NAMEVALUE.key}">selected</c:if>>${NAMEVALUE.value}</option>
													</c:forEach>
												</select>
											</c:if>
											<c:if test="${ALLLABELSMAP['MODULEPARAMDATATYPE'] eq 'selectfromview'}">
												<c:set var="SELECTOPTIONNAMEVALUE" value="${ALLLABELSMAP['MODULEPARAMSELECTNAMEVALUES']}"/>
												
												<select class="form-control input-sm" id="${ALLLABELSMAP['MODULEPARAMIDNAME']}_${UNQID}" name="${ALLLABELSMAP['MODULEPARAMINDEX']}_${ALLLABELSMAP['MODULEPARAMIDNAME']}">
													<c:forEach var="NAMEVALUE" items="${SELECTOPTIONNAMEVALUE}">
														<option value="${NAMEVALUE.key}" <c:if test="${ALLLABELSMAP['MODULEPARAMDEFAULTVALUE'] eq NAMEVALUE.key}">selected</c:if>>${NAMEVALUE.value}</option>
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
													<input type="text" value="${ALLLABELSMAP['MODULEPARAMDEFAULTVALUE']}" 
													class="form-control input-sm" aria-describedby="basic-addon${UNQID}" 
													id="${ALLLABELSMAP['MODULEPARAMIDNAME']}_${UNQID}" 
													validation="${ALLLABELSMAP['MODULEPARAMVALIDATIONFIELD']}"
													name="${ALLLABELSMAP['MODULEPARAMINDEX']}_${ALLLABELSMAP['MODULEPARAMIDNAME']}"/>
													<span class="input-group-addon" id="basic-addon${UNQID}" 
													onclick="compassTopFrame.moduleSearch('${ALLLABELSMAP['MODULEPARAMIDNAME']}_${UNQID}','${ALLLABELSMAP['MODULEPARAMIDNAME']}','${ALLLABELSMAP['MODULEPARAMVIEWNAME']}','${ALLLABELSMAP['MODULEPARAMVALIDATIONFIELD']}','${pageContext.request.contextPath}')" style="cursor: pointer;" title="Search">
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
														<option value="${NAMEVALUE.key}" <c:if test="${ALLLABELSMAP['MODULEPARAMDEFAULTVALUE'] eq NAMEVALUE.key}">selected</c:if>>${NAMEVALUE.value}</option>
													</c:forEach>
												</select>
											</c:if>
											<c:if test="${ALLLABELSMAP['MODULEPARAMDATATYPE'] eq 'selectfromview'}">
												<c:set var="SELECTOPTIONNAMEVALUE" value="${ALLLABELSMAP['MODULEPARAMSELECTNAMEVALUES']}"/>
												
												<select class="form-control input-sm" id="${ALLLABELSMAP['MODULEPARAMIDNAME']}_${UNQID}" name="${ALLLABELSMAP['MODULEPARAMINDEX']}_${ALLLABELSMAP['MODULEPARAMIDNAME']}">
													<c:forEach var="NAMEVALUE" items="${SELECTOPTIONNAMEVALUE}">
														<option value="${NAMEVALUE.key}" <c:if test="${ALLLABELSMAP['MODULEPARAMDEFAULTVALUE'] eq NAMEVALUE.key}">selected</c:if>>${NAMEVALUE.value}</option>
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
													<input type="text" value="${ALLLABELSMAP['MODULEPARAMDEFAULTVALUE']}" 
													class="form-control input-sm" aria-describedby="basic-addon${UNQID}" 
													id="${ALLLABELSMAP['MODULEPARAMIDNAME']}_${UNQID}" 
													validation="${ALLLABELSMAP['MODULEPARAMVALIDATIONFIELD']}"
													name="${ALLLABELSMAP['MODULEPARAMINDEX']}_${ALLLABELSMAP['MODULEPARAMIDNAME']}"/>
													<span class="input-group-addon" id="basic-addon${UNQID}" 
													onclick="compassTopFrame.moduleSearch('${ALLLABELSMAP['MODULEPARAMIDNAME']}_${UNQID}','${ALLLABELSMAP['MODULEPARAMIDNAME']}','${ALLLABELSMAP['MODULEPARAMVIEWNAME']}','${ALLLABELSMAP['MODULEPARAMVALIDATIONFIELD']}','${pageContext.request.contextPath}')" style="cursor: pointer;" title="Search">
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
					<button type="button" id="savereportBenchMarkDtls${UNQID}" class="btn btn-primary btn-sm"><spring:message code="app.common.SAVEBUTTON"/></button>
					<button type="button" id="exportExcelReportDtls${UNQID}" class="btn btn-success btn-sm"><spring:message code="app.common.EXPORTEXCELBUTTON"/></button>
					<button type="button" id="exportCSVReportDtls${UNQID}" class="btn btn-primary btn-sm"><spring:message code="app.common.EXPORTCSVBUTTON"/></button>
					<button type="button" id="exportPDFReportDtls${UNQID}" class="btn btn-success btn-sm"><spring:message code="app.common.EXPORTPDFBUTTON"/></button>
					<!--<button type="button" id="generatereportBenchMarkDtls${UNQID}" class="btn btn-primary btn-sm"><spring:message code="app.common.GENERATEBUTTON"/></button>-->
					<button type="button" id="resetReportColumnsDtls${UNQID}" class="btn btn-success btn-sm"><spring:message code="app.common.RESETREPORTCOLUMNSBUTTON"/></button>
					<button type="button" id="deletereportBenchMarkDtls${UNQID}" class="btn btn-danger btn-sm"><spring:message code="app.common.DELETEBUTTON"/></button>
				</div>
			</div>
			</form>
			</div>
		</div>
		<div class="card card-primary" id="reportBenchMarkDtlsSerachResultPanel${UNQID}" style="display: none;">
			<div class="card-header panelSlidingreportBenchMarkDtls${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}">Generated Reports</h6>
				<div class="btn-group pull-${dirR} clearfix">
					<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
				</div>
			</div>
			<div id="reportBenchMarkDtlsSerachResult${UNQID}"></div>
		</div>
	</div>
</div>
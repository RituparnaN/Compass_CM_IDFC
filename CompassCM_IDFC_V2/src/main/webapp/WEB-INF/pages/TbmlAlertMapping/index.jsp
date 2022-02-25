<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../tags/tags.jsp"%>
<script type="text/javascript">
	$(document).ready(function() {
		var id = '${UNQID}';
		compassTopFrame.init(id, 'tbmlAlertMappingTable', 'dd/mm/yy');
		
		$('.panelSlidingtbmlAlertMapping'+id).on("click", function (e) {
			var mainRow = $(this).parents(".compassrow"+id);
			compassTopFrame.searchPanelSliding(id, mainRow, 'tbmlAlertMappingSearchResultPanel');
	    });
		
		$("#searchMasterForm"+id).submit(function(e){
			var submitButton = $("#searchtbmlAlertMapping"+id);
			compassTopFrame.submitForm(id, e, submitButton, 'tbmlAlertMappingSearchResultPanel', 
					'tbmlAlertMappingSearchResult', '${pageContext.request.contextPath}/admin/tbmlAlertMappingSearch',
					'${pageContext.request.contextPath}/includes/images/qde-loadder.gif');
		});
		
		
		//for uploading
		
		$("#uploadtbmlAlertMapping"+id).click(function(){
			compassFileUpload.init("uploadtbmlAlertMapping"+id,"${pageContext.request.contextPath}","tbmlAlertMapping","0","Y","Y","");
	});
		
		
	});
</script>
<div class="row compassrow${UNQID}">
	<div class="col-sm-12">
		<div class="card card-primary panel_tbmlAlertMapping">
			<div class="card-header panelSlidingtbmlAlertMapping${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}">TBML Alert Mapping</h6>
				<div class="btn-group pull-${dirR} clearfix">
					<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
				</div>
			</div>
			<div class="panelSearchForm">
			<form action="javascript:void(0)" method="POST" id="searchMasterForm${UNQID}">
			<input type="hidden" name="moduleType" value="${MODULETYPE}">
			<div class="card-search-card" >
				<table class="table table-striped formSearchTable tbmlAlertMappingTable" style="margin-bottom: 0px;">
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
											
											
											
											
										</td>
										<td width="10%">&nbsp;</td>
								</c:when>
								<c:otherwise>
										<td width="15%">
											<spring:message code="${ALLLABELSMAP['MODULEPARAMNAME']}"/>
											<span style="color: red;"><c:if test="${ALLLABELSMAP['MODULEPARAMVALIDATIONFIELD'] eq 'Y'}"> *</c:if></span>
										</td>
										<td width="30%">
											
											
											<c:if test="${ALLLABELSMAP['MODULEPARAMDATATYPE'] eq 'select'}">
												<c:set var="SELECTOPTIONNAMEVALUE" value="${ALLLABELSMAP['MODULEPARAMSELECTNAMEVALUES']}"/>
												<select class="form-control input-sm" id="${ALLLABELSMAP['MODULEPARAMIDNAME']}_${UNQID}" 
												name="${ALLLABELSMAP['MODULEPARAMINDEX']}_${ALLLABELSMAP['MODULEPARAMIDNAME']}"
												validation="${ALLLABELSMAP['MODULEPARAMVALIDATIONFIELD']}">
													<c:forEach var="NAMEVALUE" items="${SELECTOPTIONNAMEVALUE}">
														<c:if test = "${f:startsWith(NAMEVALUE, 'OFL_TBML') || f:startsWith(NAMEVALUE, 'ALL')}">
															<option value="${NAMEVALUE.key}">${NAMEVALUE.value}</option>
														</c:if>
													</c:forEach>
												</select>
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
					<button type="submit" id="searchtbmlAlertMapping${UNQID}" class="btn btn-success btn-sm">Search</button>
					<input type="button" class="btn btn-warning btn-sm" id="uploadtbmlAlertMapping${UNQID}" name="uploadtbmlAlertMapping" value="Upload Tbml Alert Mapping"/>
				</div>
			</div>
			</form>
			</div>
		</div>
		<div class="card card-primary" id="tbmlAlertMappingSearchResultPanel${UNQID}" style="display: none;">
			<div class="card-header panelSlidingtbmlAlertMapping${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}">TBML Alert Mapping Result</h6>
				<div class="btn-group pull-${dirR} clearfix">
					<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
				</div>
			</div>
			<div id="tbmlAlertMappingSearchResult${UNQID}"></div>
		</div>
	</div>
</div>




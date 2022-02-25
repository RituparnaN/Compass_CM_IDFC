<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../../tags/tags.jsp"%>
<c:set var="ROLE" value="${f:substring(userRole,5,12)}"/>
<script type="text/javascript">
	$(document).ready(function() {
		var id = '${UNQID}';
		compassTopFrame.init(id, 'branchUserMappingTable', 'dd/mm/yy');
		
		$('.panelSlidingBranchUserMapping'+id).on("click", function (e) {
			var mainRow = $(this).parents(".compassrow"+id);
			compassTopFrame.searchPanelSliding(id, mainRow, 'branchUserMappingSearchResultPanel');
		});
		
		$('#searchMasterForm'+id).submit(function(e){
			var submitButton=$("#searchBranchUserMapping"+id);
			compassTopFrame.submitForm(id, e,submitButton, 'branchUserMappingSearchResultPanel', 'branchUserMappingSearchResult',
					'${pageContext.request.contextPath}/common/searchGenericMaster',
					'${pageContext.request.contextPath}/includes/images/qde-loadder.gif');			
		});
		
		//generic clear function
		genericClear(id);
			
	});
	
	function uploadBranchUserMappingFile(elm){
		compassFileUpload.init("uploadBranchUserMappingFile","${pageContext.request.contextPath}","BRANCHUSERMAPPINGUPLOAD","0","Y","N","");
	}
		
</script>
<div class="row compassrow${UNQID}">
	<div class="col-sm-12">
		<div class="card card-primary panel_branchUserMapping">
			<div class="card-header panelSlidingBranchUserMapping${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}"><spring:message code="app.common.branchUserMappingSearchHeader"/></h6>
				<div class="btn-group pull-${dirR} clearfix">
					<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
				</div>
			</div>
			<div class="panelSearchForm">
			<form action="javascript:void(0)" method="POST" id="searchMasterForm${UNQID}">
			<input type="hidden" name="moduleType" value="${MODULETYPE}">
			<input type="hidden" name="bottomPageUrl" value="MasterModules/BranchUserMapping/SearchBottomPage">
			<div class="card-search-card" >
				<table class="table table-striped formSearchTable branchUserMappingTable" style="margin-bottom: 0px;">
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
					<button  type="submit" id="searchBranchUserMapping${UNQID}" class="btn btn-success btn-sm"><spring:message code="app.common.searchButton"/></button>
					<c:if test="${f:containsIgnoreCase(ROLE,'AMLO')}">
						<button type="button" id="uploadBranchUserMappingFile${UNQID}" class="btn btn-warning btn-sm"  onclick="uploadBranchUserMappingFile(this)">Upload BranchUser Mapping File</button>
					</c:if>
					<input type="button" id="clear${UNQID}" class="btn btn-danger btn-sm" name="Clear" value="Clear"/>
				</div>
			</div>
			</form>
			</div>
		</div>
		<div class="card card-primary" id="branchUserMappingSearchResultPanel${UNQID}" style="display: none;">
			<div class="card-header panelSlidingBranchUserMapping${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}">Branch User Mapping Result</h6>
				<div class="btn-group pull-${dirR} clearfix">
					<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
				</div>
			</div>
			<div id="branchUserMappingSearchResult${UNQID}"></div>
		</div>
	</div>
</div>



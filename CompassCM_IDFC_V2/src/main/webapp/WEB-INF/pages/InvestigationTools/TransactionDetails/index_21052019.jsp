<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../../tags/tags.jsp"%>
<c:set var="CALLFROMACCOUNTSMASTER" value="${CALLFROMACCOUNTSMASTER}"/>
<c:if test="${CALLFROMACCOUNTSMASTER == 'Yes'}">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Transaction Details</title>
<jsp:include page="../../tags/staticFiles.jsp"/>
</c:if>

<script type="text/javascript">
	$(document).ready(function() {
		var id = '${UNQID}';
		
		compassTopFrame.init(id, 'transactionDetailsTable', 'dd/mm/yy');
		var AccountNo = "${ACCOUNTNO}";
		$("#ACCOUNTNO_"+id).val(AccountNo);
		
		$(".panelSlidingTransactionDetails"+id).on("click", function(e){
			var mainRow = $(this).parents(".compassrow"+id);
			compassTopFrame.searchPanelSliding(id, mainRow, 'transactionDetailsSerachResultPanel');
		});
		
		$("#searchMasterForm"+id).submit(function(e){
			var customerId = $("#CUSTOMERID_"+id).val();
			var accountNo = $("#ACCOUNTNO_"+id).val();
			
			var fromDate = $('#FROMDATE_'+id).val();
			var toDate = $('#TODATE_'+id).val();
			function parseDate(str) {
			    var ymd = str.split('/');
			    return new Date(ymd[2], ymd[1]-1, ymd[0]);
			}
			
			var diff = Math.round(parseDate(toDate) - parseDate(fromDate));
			var days = Math.round(diff/1000/60/60/24);
			
			if(days < '0' || days > '30'){
				alert("Date range should be within a month");
			}
			else{
				if((customerId == '') && (accountNo == '')){
					/* alert(customerId);
					alert(accountNo); */
					alert('Please select either CustomerId/AccountNo.');
					return false;
				}else{
					var submitButton = $("#searchTransactionDetails"+id);
					compassTopFrame.submitForm(id, e, submitButton, 'transactionDetailsSerachResultPanel',
							'transactionDetailsSerachResult', '${pageContext.request.contextPath}/common/searchGenericMaster?${_csrf.parameterName}=${_csrf.token}',
							'${pageContext.request.contextPath}/includes/images/qde-loadder.gif');
				}
			}
		});
		
		$("#viewAccountStatement"+id).click(function(){
			var formObj = $("#searchMasterForm"+id);
			var formData = (formObj).serialize();
			window.open('${pageContext.request.contextPath}/common/viewAccountStatement?'+formData,'Account_Statement','height=600px,width=1000px');
		});
		
	});

</script>
<c:if test="${CALLFROMACCOUNTSMASTER == 'Yes'}">
<style>
.panel_transactionDetails, 
	.panel_transactionDetailsResult{
		margin-left: 10px !important;
		margin-right: 10px !important;
		margin-top: 5px !important;
	}
</style>
</c:if>
<div class="row compassrow${UNQID}">
	<div class="col-sm-12">
		<div class="card card-primary panel_transactionDetails">
			<div class="card-header panelSlidingTransactionDetails${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}"><spring:message code="app.common.transactionDetailsHeader"/></h6>
				<div class="btn-group pull-${dirR} clearfix">
					<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
				</div>
			</div>
			<div class="panelSearchForm">
			<form action="javascript:void(0)" method="POST" id="searchMasterForm${UNQID}">
			<input type="hidden" name="moduleType" value="${MODULETYPE}">
			<input type="hidden" name="bottomPageUrl" value="InvestigationTools/TransactionDetails/SearchBottomPage">
			<div class="card-search-card" >
				<table class="table table-striped formSearchTable transactionDetailsTable" style="margin-bottom: 0px;">
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
													<span class="input-group-addon" id="basic-addon2" 
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
					<button type="submit" id="searchTransactionDetails${UNQID}" class="btn btn-success btn-sm"><spring:message code="app.common.searchButton"/></button>
					<button type="button" id="viewAccountStatement${UNQID}" class="btn btn-primary btn-sm"><spring:message code="app.common.viewAccountStatement"/></button>
				</div>
			</div>
			</form>
			</div>
		</div>
		<div class="card card-primary panel_transactionDetailsResult" id="transactionDetailsSerachResultPanel${UNQID}" style="display: none;">
			<div class="card-header panelSlidingTransactionDetails${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}"><spring:message code="app.common.transactionDetailsResultHeader"/></h6>
				<div class="btn-group pull-${dirR} clearfix">
					<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
				</div>
			</div>
			<div id="transactionDetailsSerachResult${UNQID}"></div>
		</div>
	</div>
</div>

<div class="modal fade bs-example-modal-lg" id="compassGenericModal" tabindex="1" role="dialog" aria-labelledby="myLargeModalLabel">
	<div class="modal-dialog modal-lg">
		<div class="modal-content card-primary">
			<div class="modal-header card-header" style="cursor: move;">
				<div class="modal-button">
					<button type="button" class="close" data-dismiss="modal" aria-label="Close" title="Close">
						<span aria-hidden="true" class="fa fa-remove"></span>
					</button>
					<button type="button" class="close"  title="Open in new Window" id="openModalInWindow">
						<span aria-hidden="true" class="fa fa-external-link"></span>
					</button>
					<button type="button" class="close" title="Open in Tab" id="openModalInTab">
						<span aria-hidden="true" class="fa fa-plus"></span>
					</button>
				</div>
				<h4 class="modal-title" id="compassGenericModal-title">...</h4>					
			</div>
			<div class="modal-body" id="compassGenericModal-body">
			<br/>
				<center>
					<img alt="Loading..." src="${pageContext.request.contextPath}/includes/images/qde-loadder.gif">
				</center>
			<br/>
			</div>
		</div>
	</div>
</div>



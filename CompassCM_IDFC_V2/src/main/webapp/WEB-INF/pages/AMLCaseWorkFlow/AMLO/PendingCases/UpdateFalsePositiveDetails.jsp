<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../../../tags/tags.jsp"%>
<c:set var="ROLE" value="${ROLE}"/>

<script type="text/javascript">
	$(document).ready(function() {
		var id = '${UNQID}';
		var searchButton = '${searchButton}';
		
		compassTopFrame.init(id, 'compassModuleDetailsSearchTable'+id, 'dd/mm/yy');
		
		$('.panelSlidingFalsePositive'+id).on("click", function (e) {
			var mainRow = $(this).parents(".compassrow"+id);
			compassTopFrame.searchPanelSliding(id, mainRow, 'falsePositiveSerachResultPanel');
	    });
		
		$("#saveToFalsePositive"+id).click(function(){
			var refNo = $("#refNo"+id).val();
			var caseNo = $("#caseNo"+id).val();
			var alertNo = $("#alertNo"+id).val();
			var caseStatus = $("#caseStatus"+id).val();
			var branchCode = $("#branchCode"+id).val();
			var custId = $("#custId"+id).val();
			var customerName = $("#custName"+id).val();
			var accNo = $("#accNo"+id).val();
			var alertCode = $("#alertCode"+id).val();
			var alertMsg = $("#alertMsg"+id).val();
			var activeFromDate = $("#activeFrom"+id).val();
			var activeTo = $("#activeTo"+id).val();
			var isEnabled = $("#isEnabled"+id).val();
			var reason = $("#reason"+id).val();
			var toleranceLevel = $("#toleranceLevel"+id).val();
			var isToBeDeleted = $("#isToBeDeleted"+id).val();
			/* var fullData = "activeFromDate="+activeFromDate+"&activeTo="+activeTo+"&isEnabled="+isEnabled+"&reason="+reason+
						   "&toleranceLevel="+toleranceLevel+"&isToBeDeleted="+isToBeDeleted;
			alert(fullData); */
			//alert(searchButton);
			$.ajax({
				url: "${pageContext.request.contextPath}/amlCaseWorkFlow/saveToFalsePositive",
				cache: false,
				type: "POST",
				data: "caseNo="+caseNo+"&refNo="+refNo+"&activeFromDate="+activeFromDate+"&activeTo="+activeTo+"&isEnabled="+isEnabled+"&reason="+reason+
				   "&toleranceLevel="+toleranceLevel+"&isToBeDeleted="+isToBeDeleted,
				success: function(response) {
					alert(response);
					$("#"+searchButton).click();
					$("#compassGenericModal").modal("hide");
					
				},
				error: function(a,b,c) {
					alert(a+b+c);
				}
			});
		});
	});
</script>
<div class="row compassrow${UNQID}">
	<div class="col-sm-12">
		<div class="card card-primary panel_falsePositive">
			<%-- <div class="card-header panelSlidingFalsePositive${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}"><spring:message code="app.common.falsePositiveSearchHeader"/></h6>
				<div class="btn-group pull-${dirR} clearfix">
					<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
				</div>
			</div> --%>
			<div class="panelSearchForm">
			<form action="javascript:void(0)" method="POST" id="searchMasterForm${UNQID}">
				<table class="table compassModuleDetailsSearchTable${UNQID}" style="margin-bottom: 0px;">
					<tr>
						<td width="15%">Reference No</td>
						<td width="30%">
							<input type="text" class="form-control input-sm" name="refNo" id="refNo${UNQID}" value="${resultData['REFERENCENO']}" disabled="disabled"/>
						</td>
						<td width="10%">&nbsp;</td>
						<td width="15%">Case No</td>
						<td width="30%">
							<input type="text" class="form-control input-sm" name="caseNo" id="caseNo${UNQID}" value="${resultData['CASENO']}" disabled="disabled"/>
						</td>
					</tr>
					<tr>
						<td width="15%">Alert No</td>
						<td width="30%">
							<input type="text" class="form-control input-sm" name="alertNo" id="alertNo${UNQID}" value="${resultData['ALERTNO']}" disabled="disabled"/>
						</td>
						<td width="10%">&nbsp;</td>
						<td width="15%">Case Action</td>
						<td width="30%">
							<input type="text" class="form-control input-sm" name="caseStatus" id="caseStatus${UNQID}" value="${resultData['CASESTATUS']}" disabled="disabled"/>
						</td>
					</tr>
					<tr>
						<td width="15%">Customer Id</td>
						<td width="30%">
							<input type="text" class="form-control input-sm" name="custId" id="custId${UNQID}" value="${resultData['CUSTOMERID']}" disabled="disabled"/>
						</td>
						<td width="10%">&nbsp;</td>
						<td width="15%">Customer Name</td>
						<td width="30%">
							<input type="text" class="form-control input-sm" name="custName" id="custName${UNQID}" value="${resultData['CUSTOMERNAME']}" disabled="disabled"/>
						</td>
					</tr>
					<tr>
						<td width="15%">Account No</td>
						<td width="30%">
							<input type="text" class="form-control input-sm" name="accNo" id="accNo${UNQID}" value="${resultData['ACCOUNTNO']}" disabled="disabled"/>
						</td>	
						<td width="10%">&nbsp;</td>
						<td width="15%">Alert Code</td>
						<td width="30%">
							<input type="text" class="form-control input-sm" name="alertCode" id="alertCode${UNQID}" value="${resultData['ALERTCODE']}" disabled="disabled"/>
						</td>
					</tr>
					<tr>	
						<td width="15%">Alert Message</td>
						<td width="30%">
							<input type="text" class="form-control input-sm" name="alertMsg" id="alertMsg${UNQID}" value="${resultData['ALERTMESSAGE']}" disabled="disabled"/>
						</td>
						<td width="10%">&nbsp;</td>
						<td width="15%">Active From</td>
						<td width="30%">
							<input type="text" class="form-control input-sm datepicker" name="activeFrom" id="activeFrom${UNQID}" value="${resultData['ACTIVEFROMDATE']}" 
							<%-- <c:if test="${ROLE ne 'ROLE_AMLUSER'}">disabled="disabled"</c:if>/> --%>			
							<c:if test="${ROLE ne 'ROLE_AMLO'}">disabled="disabled"</c:if>/>			
						</td>
					</tr>
					<tr>	
						<td width="15%">Active To</td>
						<td width="30%">
							<input type="text" class="form-control input-sm datepicker" name="activeTo" id="activeTo${UNQID}" value="${resultData['ACTIVETODATE']}"
							<%-- <c:if test="${ROLE ne 'ROLE_AMLUSER'}">disabled="disabled"</c:if>/> --%>
							<c:if test="${ROLE ne 'ROLE_AMLO'}">disabled="disabled"</c:if>/>
							
						</td>
						<td width="10%">&nbsp;</td>
						<td width="15%">Is Enabled</td>
						<td width="30%">
							<select class="form-control input-sm" name="isEnabled" id="isEnabled${UNQID}" 
							<%-- <c:if test="${ROLE ne 'ROLE_AMLUSER'}">disabled="disabled"</c:if>> --%>
							<c:if test="${ROLE ne 'ROLE_AMLO'}">disabled="disabled"</c:if>>
								<option value="Select"></option>
								<option value="Y" <c:if test="${resultData.ISENABLED eq 'Y'}">selected="selected"</c:if>>Yes</option>
								<option value="N" <c:if test="${resultData.ISENABLED eq 'N'}">selected="selected"</c:if>>No</option>
							</select>
						</td>
					</tr>
					<tr>	
						<td width="15%">Reason</td>
						<td width="30%">
							<textarea class="form-control input-sm" name="reason" id="reason${UNQID}" 
							<%-- <c:if test="${ROLE ne 'ROLE_AMLUSER'}">disabled="disabled"</c:if>> --%>
							<c:if test="${ROLE ne 'ROLE_AMLO'}">disabled="disabled"</c:if>>${resultData['REASON']}</textarea>
						</td>
						<td width="10%">&nbsp;</td>
						<td width="15%">To Be Deleted</td>
						<td width="30%">
							<select class="form-control input-sm" name="isToBeDeleted" id="isToBeDeleted${UNQID}" 
							<%-- <c:if test="${ROLE ne 'ROLE_AMLUSER'}">disabled="disabled"</c:if>> --%>
							<c:if test="${ROLE ne 'ROLE_AMLO'}">disabled="disabled"</c:if>>
								<option value="Select"></option>
								<option value="Y" <c:if test="${resultData.ISTOBEDELETED eq 'Y'}">selected="selected"</c:if>>Yes</option>
								<option value="N" <c:if test="${resultData.ISTOBEDELETED eq 'N'}">selected="selected"</c:if>>No</option>
							</select>
						</td>
					</tr>
					<tr>	
						<td width="15%">Tolerance Level</td>
						<td width="30%">
							<input type="text" class="form-control input-sm" name="toleranceLevel" id="toleranceLevel${UNQID}" value="${resultData['TOLERANCELEVEL']}"
							<%-- <c:if test="${ROLE ne 'ROLE_AMLUSER'}">disabled="disabled"</c:if>/> --%>
							<c:if test="${ROLE ne 'ROLE_AMLO'}">disabled="disabled"</c:if>/>
						</td>
						<td width="10%">&nbsp;</td>
						<td width="15%">Branch Code</td>
						<td width="30%">
							<input type="text" class="form-control input-sm" name="branchCode" id="branchCode${UNQID}" value="${resultData['BRANCHCODE']}" disabled="disabled"/>
						</td>
					</tr>
					<tr>	
						<td width="15%">Updated By</td>
						<td width="30%">
							<input type="text" class="form-control input-sm" name="updatedBy" id="updatedBy${UNQID}"  value="${resultData['UPDATEDBY']}" disabled="disabled"/>
						</td>
						<td width="10%">&nbsp;</td>
						<td width="15%">Updated On</td>
						<td width="30%">
							<input type="text" class="form-control input-sm" name="branchCode" id="branchCode${UNQID}" value="${resultData['UPDATETIMESTAMP']}" disabled="disabled"/>
						</td>
					</tr>
				</table>
				<div class="card-footer clearfix">
					<div class="pull-${dirR}">
					<%-- <c:if test="${ROLE eq 'ROLE_AMLUSER'}"> --%>
					<c:if test="${ROLE eq 'ROLE_AMLO'}">
						<input type="button" id="saveToFalsePositive${UNQID}" class="btn btn-success btn-sm" name="Save" value="Post">
					</c:if>
					</div>
				</div>
			</form>
			</div>
		</div>
	</div>
</div>
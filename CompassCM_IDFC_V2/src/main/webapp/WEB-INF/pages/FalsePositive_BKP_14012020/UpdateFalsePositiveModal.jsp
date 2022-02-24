<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../tags/tags.jsp"%>
    
<script type="text/javascript">
	$(document).ready(function(){
		var id = '${UNQID}';
		var searchButton = '${searchButton}';
		var isView = '${isView}';
		
		$(".datepicker").datepicker({
			changeMonth: true,
			changeYear: true,
			dateFormat: "dd/mm/yy"
		});
		
		//compassTopFrame.init(id, 'updateFalsePositiveTable'+id, 'dd/mm/yy');
		
		$("#updateFalsePositiveModal"+id).click(function(){
			   var adminComments = "";
				var custId = $("#custId"+id).val();
				var accNo = $("#accNo"+id).val();
				var alertCode = $("#alertCode"+id).val();
				var alertMsg = $("#alertMsg"+id).val();
				var activeFrom = $("#activeFrom"+id).val();
				var activeTo = $("#activeTo"+id).val();
				var isEnabled = $("#isEnabled"+id).val();
				var reason = $("#reason"+id).val();
				var toleranceLevel = $("#toleranceLevel"+id).val();
				var status = "Pending";
				
				// alert(fullData);
				if(activeFrom != '' &&	activeTo != '' && isEnabled != '' && toleranceLevel != '' && reason != ''){
					alert(reason.length);
					if(reason.length > 4000){
						alert('Reason cannot exceed 4000 characters.');
					}else{
						if(confirm("Confirm updating")){
							adminComments = prompt("Please enter your comments before updating.");
							var fullData = "custId="+custId+"&accNo="+accNo+"&alertCode="+alertCode+"&alertMsg="+alertMsg+"&activeFrom="+activeFrom+
							   "&activeTo="+activeTo+"&isEnabled="+isEnabled+"&reason="+reason+"&toleranceLevel="+toleranceLevel+
							   "&status="+status+"&adminComments="+adminComments;
							$.ajax({
								url: "${pageContext.request.contextPath}/admin/updateFalsePositive",
								cache: false,
								type: "POST",
								data: fullData,
								success: function(res){
									$("#"+searchButton).click();
									$("#compassCaseWorkFlowGenericModal").modal("hide");
									alert(res);
								},
								error: function(a,b,c){
									alert(a+b+c);
								}
							});
						}
					}
				}else{
					alert("Please enter data in all fields.");
				}
		});
		
	});
</script>
<div class="row compassrow${UNQID}">
	<div class="col-sm-12">
	<div class="card card-primary updateFalsePositiveModalForm">
		<form action="javascript:void(0)" method="POST" id="updateFalsePositiveForm${UNQID}">
			<table class="table table-striped updateFalsePositiveTable${UNQID}" style="margin-bottom: 0px;">
				<tr>
					<td width="15%">Customer Id</td>
						<td width="30%">
							<div class="input-group" style="z-index: 1">
								<input type="text" class="form-control input-sm" value="${RESULTMAP['CUSTOMERID']}" name="custId" id="custId${UNQID}" readonly="readonly"/>
								<span class="input-group-addon" id="basic-addon${UNQID}" onclick="alert('search')" style="cursor: pointer;" title="Search">
									<i class="fa fa-search"></i>
								</span>
							</div>
						</td>
					<td width="10%">&nbsp;</td>
					<td width="15%">Account No</td>
					<td width="30%">
						<div class="input-group" style="z-index: 1">
							<input type="text" class="form-control input-sm" name="accNo"  value="${RESULTMAP['ACCOUNTNO']}" id="accNo${UNQID}" readonly="readonly"/>
							<span class="input-group-addon" id="basic-addon${UNQID}" onclick="alert('search')" style="cursor: pointer;" title="Search">
								<i class="fa fa-search"></i>
							</span>
						</div>
					</td>
				</tr>
				<tr>	
					<td width="15%">Alert Code</td>
					<td width="30%">
						<input type="text" class="form-control input-sm" name="alertCode" id="alertCode${UNQID}" disabled="disabled" value="${RESULTMAP['ALERTCODE']}"/>
						<%-- <select class="form-control input-sm" name="alertCode" id="alertCode${UNQID}" disabled="disabled" >
							<c:forEach var="alertCodes" items="${ALERTCODES}">
								<option value="${alertCodes.key}" <c:if test="${alertCodes.key eq RESULTMAP['ALERTCODE']}">selected="selected"</c:if>>${alertCodes.key} - ${alertCodes.value}</option>
							</c:forEach>
						</select> --%>
					</td>
					<td width="10%">&nbsp;</td>
					<td width="15%">Alert Message</td>
					<td width="30%">
						<input type="text" class="form-control input-sm" name="alertMsg" id="alertMsg${UNQID}" disabled="disabled" value="${RESULTMAP['ALERTMESSAGE']}"/>
						<%-- <c:if test="${isView eq 'Y'}">disabled="disabled"</c:if>/> --%>
					</td>
				</tr>
				<tr>	
					<td width="15%">Active From</td>
					<td width="30%">
						<c:if test="${isView eq 'Y'}">
							<input type="text" class="form-control input-sm" id="activeFrom${UNQID}" name="activeFrom" value="${RESULTMAP['ACTIVEFROMDATE']}" disabled="disabled"/>
						</c:if>
						<c:if test="${isView eq 'N'}">
							<input type="text" class="form-control input-sm datepicker" id="activeFrom${UNQID}" name="activeFrom" value="${RESULTMAP['ACTIVEFROMDATE']}"/>
						</c:if>
					<td width="10%">&nbsp;</td>
					<td width="15%">Active To</td>
					<td width="30%">
						<c:if test="${isView eq 'Y'}">
							<input type="text" class="form-control input-sm" id="activeTo${UNQID}" name="activeTo" value="${RESULTMAP['ACTIVETODATE']}" disabled="disabled"/>
						</c:if>
						<c:if test="${isView eq 'N'}">
							<input type="text" class="form-control input-sm datepicker" id="activeTo${UNQID}" name="activeTo" value="${RESULTMAP['ACTIVETODATE']}"/>
						</c:if>
					</td>
				</tr>
				<tr>	
					<td width="15%">Is Enabled</td>
					<td width="30%">
						<select class="form-control input-sm" name="isEnabled" id="isEnabled${UNQID}" <c:if test="${isView eq 'Y'}">disabled="disabled"</c:if>>
							<option value=""></option>
							<option value="Y" <c:if test="${'Y' eq RESULTMAP['ISENABLED']}">selected="selected"</c:if>>Yes</option>
							<option value="N" <c:if test="${'N' eq RESULTMAP['ISENABLED']}">selected="selected"</c:if>>No</option>
						</select>
					</td>
					<td width="10%">&nbsp;</td>
					<td width="15%">Tolerance Level</td>
					<td width="30%">
						<input type="text" class="form-control input-sm" name="toleranceLevel" id="toleranceLevel${UNQID}" value="${RESULTMAP['TOLERANCELEVEL']}"
						onkeyup="$(this).val($(this).val().replace(/[^\d]/ig, ''))" <c:if test="${isView eq 'Y'}">disabled="disabled"</c:if>>
					</td>
				</tr>
				<tr>
					<td width="15%">Maker Code</td>
					<td width="30%">
						<input type="text" class="form-control input-sm" name="makerCode" value="${RESULTMAP['MAKERCODE']}" disabled="disabled"/></td>
					<td width="10%">&nbsp;</td>
					<td width="15%">Maker Comments</td>
					<td width="30%">
						<input type="text" class="form-control input-sm" name="makerComments" value="${RESULTMAP['ADMINCOMMENTS']}" disabled="disabled"/></td>
				</tr>
				<tr>	
					<td width="15%">Maker Timestamp</td>
					<td width="30%">
						<input type="text" class="form-control input-sm" name="makerTimestamp" value="${RESULTMAP['ADMINTIMESTAMP']}" disabled="disabled"/></td>
					<td width="10%">&nbsp;</td>	
					<td width="15%">Checker Code</td>
					<td width="30%">
						<input type="text" class="form-control input-sm" name="checkerCode" value="${RESULTMAP['CHECKERCODE']}" disabled="disabled"/></td>
				</tr>
				<tr>	
					<td width="15%">Checker Comments</td>
					<td width="30%">
						<input type="text" class="form-control input-sm" name="checkerComments" value="${RESULTMAP['MLROCOMMENTS']}" disabled="disabled"/></td>
					<td width="10%">&nbsp;</td>
					<td width="15%">Checker Timestamp</td>
					<td width="30%">
						<input type="text" class="form-control input-sm" name="checkerTimestamp" value="${RESULTMAP['MLROTIMESTAMP']}" disabled="disabled"/></td>
				</tr>
				<tr>	
					<td width="15%">Status</td>
					<td width="30%">
						<input type="text" class="form-control input-sm" name="status" id="status${UNQID}" value="${RESULTMAP['STATUS']}" disabled="disabled"/>
					</td>
					<td width="10%">&nbsp;</td>
					<td width="15%">Reason</td>
					<td width="30%">
						<textarea class="form-control input-sm" name="reason" id="reason${UNQID}"
						<c:if test="${isView eq 'Y'}">disabled="disabled"</c:if>>${RESULTMAP['REASON']}</textarea>
					</td>
				</tr>
				</table>
			<c:if test="${isView eq 'N'}">	
			<div class="card-footer clearfix">
				<div class="pull-${dirR}">
					<button type="button" class="btn btn-sm btn-success" id="updateFalsePositiveModal${UNQID}" >Save</button>
				</div>
			</div>
			</c:if>
		</form>
	</div>
	</div>
</div>
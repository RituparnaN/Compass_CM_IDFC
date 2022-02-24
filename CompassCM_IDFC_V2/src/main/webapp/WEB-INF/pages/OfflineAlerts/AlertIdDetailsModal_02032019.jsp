<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ include file="../tags/tags.jsp"%>
<script type="text/javascript">
	$(document).ready(function(){
		var id = '${UNQID}';
		$(".datepicker").datepicker({
			dateFormat : "dd/mm/yy"
		});
		
		$("#closeAlertDetails"+id).click(function(){
			$("#compassGenericModal").modal("hide");
		});
		
		$("#updateAlertDetails"+id).click(function(){
			var alertId = $("#alertId"+id).val();
			var alertName = $("#alertName"+id).val();
			var alertSubGroup = $("#alertSubGroup"+id).val();
			var alertSubGroupOrder = $("#alertSubGroupOrder"+id).val();
			var alertFrequency = $("#alertFrequency"+id).val();
			var seqNo = $("#seqNo"+id).val();
			var isEnabled = $("#isEnabled"+id).val();
			var lastAlertedTxnDate = $("#lastAlertedTxnDate"+id).val();
			var sourceSystem = $("#sourceSystem"+id).val();
			var makerCode = $("#makerCode"+id).val();
			var makerComments = $("#makerComments"+id).val();
			var checkerCode = $("#checkerCode"+id).val();
			var checkerComments = $("#checkerComments"+id).val();
			var status = "P";
			var fullData = "alertId="+alertId+"&alertName="+alertName+"&alertSubGroup="+alertSubGroup+"&alertSubGroupOrder="+alertSubGroupOrder+
						   "&alertFrequency="+alertFrequency+"&seqNo="+seqNo+"&isEnabled="+isEnabled+"&lastAlertedTxnDate="+lastAlertedTxnDate+
						   "&sourceSystem="+sourceSystem+"&makerCode="+makerCode+"&makerComments="+makerComments+"&checkerCode="+checkerCode+"&checkerComments="+checkerComments+"&status="+status;
			$.ajax({
				url: "${pageContext.request.contextPath}/admin/updateAlertDetailsandComments" ,
				cache: false,
				data: fullData,
				type: "POST",
				success: function(res){
					alert(res);
					$("#compassGenericModal").modal("hide");
				},
				error: function(a,b,c){
					alert(a+b+c);
				}
			});
		});
		
		$("#approveAlertDetails"+id).click(function(){
			var alertId = $("#alertId"+id).val();
			var alertName = $("#alertName"+id).val();
			var alertSubGroup = $("#alertSubGroup"+id).val();
			var alertSubGroupOrder = $("#alertSubGroupOrder"+id).val();
			var alertFrequency = $("#alertFrequency"+id).val();
			var seqNo = $("#seqNo"+id).val();
			var isEnabled = $("#isEnabled"+id).val();
			var lastAlertedTxnDate = $("#lastAlertedTxnDate"+id).val();
			var sourceSystem = $("#sourceSystem"+id).val();
			var makerCode = $("#makerCode"+id).val();
			var makerComments = $("#makerComments"+id).val();
			var checkerCode = $("#checkerCode"+id).val();
			var checkerComments = $("#checkerComments"+id).val();
			var status = "A";
			var fullData = "alertId="+alertId+"&alertName="+alertName+"&alertSubGroup="+alertSubGroup+"&alertSubGroupOrder="+alertSubGroupOrder+
						   "&alertFrequency="+alertFrequency+"&seqNo="+seqNo+"&isEnabled="+isEnabled+"&lastAlertedTxnDate="+lastAlertedTxnDate+
						   "&sourceSystem="+sourceSystem+"&makerCode="+makerCode+"&makerComments="+makerComments+"&checkerCode="+checkerCode+"&checkerComments="+checkerComments+"&status="+status;
			$.ajax({
				url: "${pageContext.request.contextPath}/admin/updateAlertDetailsandComments" ,
				cache: false,
				data: fullData,
				type: "POST",
				success: function(res){
					alert(res);
					$("#compassGenericModal").modal("hide");
				},
				error: function(a,b,c){
					alert(a+b+c);
				}
			});
		});
		
		$("#rejectAlertDetails"+id).click(function(){
			var alertId = $("#alertId"+id).val();
			var alertName = $("#alertName"+id).val();
			var alertSubGroup = $("#alertSubGroup"+id).val();
			var alertSubGroupOrder = $("#alertSubGroupOrder"+id).val();
			var alertFrequency = $("#alertFrequency"+id).val();
			var seqNo = $("#seqNo"+id).val();
			var isEnabled = $("#isEnabled"+id).val();
			var lastAlertedTxnDate = $("#lastAlertedTxnDate"+id).val();
			var sourceSystem = $("#sourceSystem"+id).val();
			var makerCode = $("#makerCode"+id).val();
			var makerComments = $("#makerComments"+id).val();
			var checkerCode = $("#checkerCode"+id).val();
			var checkerComments = $("#checkerComments"+id).val();
			var status = "R";
			var fullData = "alertId="+alertId+"&alertName="+alertName+"&alertSubGroup="+alertSubGroup+"&alertSubGroupOrder="+alertSubGroupOrder+
						   "&alertFrequency="+alertFrequency+"&seqNo="+seqNo+"&isEnabled="+isEnabled+"&lastAlertedTxnDate="+lastAlertedTxnDate+
						   "&sourceSystem="+sourceSystem+"&makerCode="+makerCode+"&makerComments="+makerComments+"&checkerCode="+checkerCode+"&checkerComments="+checkerComments+"&status="+status;
			$.ajax({
				url: "${pageContext.request.contextPath}/admin/updateAlertDetailsandComments" ,
				cache: false,
				data: fullData,
				type: "POST",
				success: function(res){
					alert(res);
					$("#compassGenericModal").modal("hide");
				},
				error: function(a,b,c){
					alert(a+b+c);
				}
			});
		});
		
	});
</script>
<div class="row">
	<div class="col-sm-12">
		<div class="card card-primary">
			<div class="card-header clearfix">
				<h6 class="card-title pull-${dirL}">${alertName}</h6>
			</div>
			<div class="panelShowAlertDetails">
				<table class="table table-striped" style="margin-bottom: 0px;">
					<tr>
						<td width="15%">
							Alert Id
						</td>
						<td width="30%">
							<input type="text" class="form-control input-sm" name="alertId" id="alertId${UNQID}" readonly="readonly" value="${alertId}"/>
						</td>
						<td width="10%">&nbsp;</td>
						<td width="15%">
							Alert Name
						</td>
						<td width="30%">
							<%-- <input type="text" class="form-control input-sm" name="alertName" id="alertName" value="${alertName}"/> --%>
							<textarea class="form-control input-sm" name="alertName" id="alertName${UNQID}">${alertName}</textarea>
						</td>
					</tr>
					<tr>
						<td width="15%">
							Alert Sub-Group
						</td>
						<td width="30%">
							<%-- <input type="text" class="form-control input-sm" name="alertSubGroup" id="alertSubGroup" value="${ALERTDETAILS['ALERTSUBGROUP']}"/> --%>
							<textarea class="form-control input-sm" name="alertSubGroup" id="alertSubGroup${UNQID}">${ALERTDETAILS['ALERTSUBGROUP']}</textarea>
						</td>
						<td width="10%">&nbsp;</td>
						<td width="15%">
							Alert Sub-Group Order
						</td>
						<td width="30%">
							<input type="text" class="form-control input-sm" name="alertSubGroupOrder" id="alertSubGroupOrder${UNQID}" value="${ALERTDETAILS['ALERTSUBGROUPORDER']}"/>
						</td>
					</tr>
					<tr>
						<td width="15%">
							Alert Frequency
						</td>
						<td width="30%">
							<select class="form-control input-sm" name="alertFrequency" id="alertFrequency${UNQID}">
								<option value="" <c:if test="${ALERTDETAILS['ALERTFREQUENCY'] eq ''}">selected</c:if>>Not defined</option>
								<option value="DAILY" <c:if test="${ALERTDETAILS['ALERTFREQUENCY'] eq 'DAILY'}">selected</c:if>>DAILY</option>
								<option value="WEEKLY" <c:if test="${ALERTDETAILS['ALERTFREQUENCY'] eq 'WEEKLY'}">selected</c:if>>WEEKLY</option>
								<option value="FORTNIGHTLY" <c:if test="${ALERTDETAILS['ALERTFREQUENCY'] eq 'FORTNIGHTLY'}">selected</c:if>>FORTNIGHTLY</option>
								<option value="MONTHLY" <c:if test="${ALERTDETAILS['ALERTFREQUENCY'] eq 'MONTHLY'}">selected</c:if>>MONTHLY</option>
							</select>
						</td>
						<td width="10%">&nbsp;</td>
						<td width="15%">
							Sequence Number
						</td>
						<td width="30%">
							<input type="text" class="form-control input-sm" name="seqNo" id="seqNo${UNQID}" value="${ALERTDETAILS['SEQNO']}"/>
						</td>
					</tr>
					<tr>
						<td width="15%">
							Is Enabled
						</td>
						<td width="30%">
							<select class="form-control input-sm" name="isEnabled" id="isEnabled${UNQID}">
								<option value="Y" <c:if test="${ALERTDETAILS['ISENABLED'] eq 'Y'}">selected</c:if>>Yes</option>
								<option value="N" <c:if test="${ALERTDETAILS['ISENABLED'] eq 'N'}">selected</c:if>>No</option>
							</select>
						</td>
						<td width="10%">&nbsp;</td>
						<td width="15%">
							Last Alerted Transaction Date
						</td>
						<td width="30%">
							<input type="text" class="form-control input-sm datepicker" name="lastAlertedTxnDate" id="lastAlertedTxnDate${UNQID}" value="${ALERTDETAILS['LASTALERTEDTRANSACTIONDATE']}"/>
						</td>
					</tr>
					<tr>
						<td width="15%">
							Source System
						</td>
						<td width="30%">
							<input type="text" class="form-control input-sm" name="sourceSystem" id="sourceSystem${UNQID}" value="${ALERTDETAILS['SOURCESYSTEM']}"/>
						</td>
						<td width="10%">&nbsp;</td>
						<td width="15%">
							Version No
						</td>
						<td width="30%">
							<input type="text" class="form-control input-sm" name="versionNo" id="versionNo${UNQID}" readonly="readonly" value="${ALERTDETAILS['VERSIONNO']}"/>
						</td>
					</tr>
					
					<tr>
						<td width="15%">
							Maker Code
						</td>
						<td width="30%">
							<input type="text" class="form-control input-sm" name="makerCode" id="makerCode${UNQID}" readonly="readonly" value="${ALERTDETAILS['MAKERCODE']}"/>
						</td>
						<td width="10%">&nbsp;</td>
						<td width="15%">
							Maker Comments
						</td>
						<td width="30%">
							<%-- <input type="text" class="form-control input-sm" name="makerComments" id="makerComments" value="${ALERTDETAILS['MAKERCOMMENTS']}"/> --%>
							<c:if test="${userRole eq 'ROLE_ADMIN' || userRole eq 'ROLE_AMLO' || userRole eq 'ROLE_MLROL1'}">
								<textarea class="form-control input-sm" name="makerComments" id="makerComments${UNQID}">${ALERTDETAILS['MAKERCOMMENTS']}</textarea>
							</c:if>
							<c:if test="${userRole eq 'ROLE_MLRO' || userRole eq 'ROLE_MLROL2'}">
								<textarea class="form-control input-sm" name="makerComments" id="makerComments${UNQID}" readonly="readonly">${ALERTDETAILS['MAKERCOMMENTS']}</textarea>
							</c:if>
						</td>
					</tr>
					<tr>
						<td width="15%">
							Maker IP Address
						</td>
						<td width="30%">
							<input type="text" class="form-control input-sm" name="makerIPAddress" id="makerIPAddress${UNQID}" readonly="readonly" value="${ALERTDETAILS['MAKERIPADDRESS']}"/>
						</td>
						<td width="10%">&nbsp;</td>
						<td width="15%">
							Maker Timestamp
						</td>
						<td width="30%">
							<input type="text" class="form-control input-sm" name="makerTimestamp" id="makerTimestamp${UNQID}" readonly="readonly" value="${ALERTDETAILS['MAKERTIMESTAMP']}"/>
						</td>
					</tr>
					
					<c:if test="${userRole eq 'ROLE_MLRO' || userRole eq 'ROLE_MLROL2'}">
					<tr>
						<td width="15%">
							Checker Code ${userRole}
						</td>
						<td width="30%">
							<input type="text" class="form-control input-sm" name="checkerCode" id="checkerCode${UNQID}" readonly="readonly" value="${ALERTDETAILS['CHECKERCODE']}"/>
						</td>
						<td width="10%">&nbsp;</td>
						<td width="15%">
							Checker Comments
						</td>
						<td width="30%">
							<%-- <input type="text" class="form-control input-sm" name="checkerComments" id="checkerComments" readonly="readonly" value="${ALERTDETAILS['CHECKERCOMMENTS']}"/> --%>
							<textarea class="form-control input-sm" name="checkerComments" id="checkerComments${UNQID}">${ALERTDETAILS['CHECKERCOMMENTS']}</textarea>
						</td>
					</tr>
					<tr>
						<td width="15%">
							Checker IP Address
						</td>
						<td width="30%">
							<input type="text" class="form-control input-sm" name="checkerIPAddress" id="checkerIPAddress${UNQID}" readonly="readonly" value="${ALERTDETAILS['CHECKERIPADDRESS']}"/>
						</td>
						<td width="10%">&nbsp;</td>
						<td width="15%">
							Checker Timestamp
						</td>
						<td width="30%">
							<input type="text" class="form-control input-sm" name="checkerTimestamp" id="checkerTimestamp${UNQID}" readonly="readonly" value="${ALERTDETAILS['CHECKERTIMESTAMP']}"/>
						</td>
				    </tr>
				    <tr>
						<td width="15%">
							Status
						</td>
						<td width="30%">
							<input type="text" class="form-control input-sm" name="alertStatus" id="alertStatus${UNQID}" readonly="readonly" value="${ALERTDETAILS['STATUS']}"/>
						</td>
						<td width="10%">&nbsp;</td>
				    </tr>
					</c:if>
					</table>
			</div>
			<div class="card-footer clearfix">
				<div class="card-title pull-right">					
					<c:if test="${(CURRENTROLE eq 'ROLE_ADMIN' || CURRENTROLE eq 'ROLE_AMLO' || CURRENTROLE eq 'ROLE_MLROL1')}">
					<button type="button" class="btn btn-success btn-sm" id="updateAlertDetails${UNQID}"><spring:message code="app.common.SAVEBUTTON"/></button>
					</c:if>
					<c:if test="${(userRole eq 'ROLE_MLRO' || userRole eq 'ROLE_MLROL2')}">
					<c:if test="${ALERTDETAILS['STATUS'] eq 'P'}">
					<button type="button" class="btn btn-success btn-sm" id="approveAlertDetails${UNQID}"><spring:message code="app.common.APPROVEBUTTON"/></button>
					<button type="button" class="btn btn-success btn-sm" id="rejectAlertDetails${UNQID}"><spring:message code="app.common.REJECTBUTTON"/></button>
					</c:if>
					</c:if>
					<button type="button" class="btn btn-danger btn-sm" id="closeAlertDetails${UNQID}">Close</button>
				</div>
			</div>
		</div>
	</div>
</div>
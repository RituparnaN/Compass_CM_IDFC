<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ include file="../tags/tags.jsp"%>
<script type="text/javascript">
	$(document).ready(function(){
		$("#closeAlertStatusModal").click(function(){
			$("#compassGenericModal").modal("hide");
		});
	});
</script>
<div class="row">
	<div class="col-sm-12">
		<div class="card card-primary">
			<div class="card-header clearfix">
				<h6 class="card-title pull-${dirL}">${alertName}</h6>
			</div>
			<div class="panelShowAlertApprovalStatusDetails">
				<table class="table table-striped" style="margin-bottom: 0px;">
					<tr>
						<td width="15%">
							Status
						</td>
						<td width="30%">
							<input type="text" class="form-control input-sm" name="status" id="status" readonly="readonly" value="${ALERTSTATUSDETAILS['STATUS']}"/>
						</td>
						<td width="10%">&nbsp;</td>
						<td width="15%">
							Request Type
						</td>
						<td width="30%">
							<input type="text" class="form-control input-sm" name="requestType" id="requestType" readonly="readonly" value="${ALERTSTATUSDETAILS['REQUESTTYPE']}"/>
						</td>
					</tr>
					<tr>
						<td width="15%">
							Maker Code
						</td>
						<td width="30%">
							<input type="text" class="form-control input-sm" name="makerCode" id="makerCode" readonly="readonly" value="${ALERTSTATUSDETAILS['MAKERCODE']}"/>
						</td>
						<td width="10%">&nbsp;</td>
						<td width="15%">
							Maker Comments
						</td>
						<td width="30%">
							<input type="text" class="form-control input-sm" name="makerComments" id="makerComments" readonly="readonly" value="${ALERTSTATUSDETAILS['MAKERCOMMENTS']}"/>
						</td>
					</tr>
					<tr>
						<td width="15%">
							Maker Timestamp
						</td>
						<td width="30%">
							<input type="text" class="form-control input-sm" name="makerTimestamp" id="makerTimestamp" readonly="readonly" value="${ALERTSTATUSDETAILS['MAKERTIMESTAMP']}"/>
						</td>
						<td width="10%">&nbsp;</td>
						<td width="15%">
							Maker IP Address
						</td>
						<td width="30%">
							<input type="text" class="form-control input-sm" name="makerIPAddress" id="makerIPAddress" readonly="readonly" value="${ALERTSTATUSDETAILS['MAKERIPADDRESS']}"/>
						</td>
					</tr>
					<tr>
						<td width="15%">
							Checker Code
						</td>
						<td width="30%">
							<input type="text" class="form-control input-sm" name="checkerCode" id="checkerCode" readonly="readonly" value="${ALERTSTATUSDETAILS['CHECKERCODE']}"/>
						</td>
						<td width="10%">&nbsp;</td>
						<td width="15%">
							Checker Comments
						</td>
						<td width="30%">
							<input type="text" class="form-control input-sm" name="checkerComments" id="checkerComments" readonly="readonly" value="${ALERTSTATUSDETAILS['CHECKERCOMMENTS']}"/>
						</td>
					</tr>
					<tr>
						<td width="15%">
							Checker Timestamp
						</td>
						<td width="30%">
							<input type="text" class="form-control input-sm" name="checkerTimestamp" id="checkerTimestamp" readonly="readonly" value="${ALERTSTATUSDETAILS['CHECKERTIMESTAMP']}"/>
						</td>
						<td width="10%">&nbsp;</td>
						<td width="15%">
							Checker IP Address
						</td>
						<td width="30%">
							<input type="text" class="form-control input-sm" name="checkerIPAddress" id="checkerIPAddress" readonly="readonly" value="${ALERTSTATUSDETAILS['CHECKERIPADDRESS']}"/>
						</td>
					</tr>
					</table>
			</div>
			<div class="card-footer clearfix">
				<div class="card-title pull-right">
					<button type="button" class="btn btn-danger btn-sm" id="closeAlertStatusModal">Close</button>
				</div>
			</div>
		</div>
	</div>
</div>
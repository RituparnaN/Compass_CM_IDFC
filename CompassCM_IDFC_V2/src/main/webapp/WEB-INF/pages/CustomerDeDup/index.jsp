<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../tags/tags.jsp"%>

<script type="text/javascript">
	$(document).ready(function() {
		var id = '${UNQID}';
 		compassTopFrame.init(id, 'deDupScanningTable'+id, 'dd/mm/yy');

 		$("#scanDeDup"+id).click(function(){
 			var l_strFromDate = $("#FromDate"+id).val();
			var l_strToDate = $("#TODATE"+id).val();

			var l_strCustomerNameCheck = 'N';
			if($("#customerName"+id).prop("checked")){
				l_strCustomerNameCheck = 'Y';
			}
			
			var l_strMotherNameCheck = 'N';
			if($("#motherName"+id).prop("checked")){
				l_strMotherNameCheck = 'Y';
			}
			var l_strPermanentAddressLine1Check = 'N';
			if($("#permAddr1"+id).prop("checked")){
				l_strPermanentAddressLine1Check = 'Y';
			}
			var l_strCommAddressLine1Check = 'N';
			if($("#commAddr1"+id).prop("checked")){
				l_strCommAddressLine1Check = 'Y';
			}
			var l_strPanNoCheck = 'N';
			if($("#panNo"+id).prop("checked")){
				l_strPanNoCheck = 'Y';
			}
			var l_strPassportNoCheck = 'N';
			if($("#passportNo"+id).prop("checked")){
				l_strPassportNoCheck = 'Y';
			}
			var l_strDrivingLicenseNoCheck = 'N';
			if($("#dlNo"+id).prop("checked")){
				l_strDrivingLicenseNoCheck = 'Y';
			}
			var l_strDateOfBirthCheck = 'N';
			if($("#dob"+id).prop("checked")){
				l_strDateOfBirthCheck = 'Y';
			}
			
			/*alert(l_strFromDate+" "+l_strToDate+" "+l_strCustomerNameCheck+" "+l_strMotherNameCheck+" "+
					l_strPermanentAddressLine1Check+" "+l_strCommAddressLine1Check+" "+l_strPanNoCheck+" "+
					l_strPassportNoCheck+" "+l_strDrivingLicenseNoCheck+" "+l_strDateOfBirthCheck);
			*/
			
			if(l_strFromDate != '' && l_strToDate != '' && l_strCustomerNameCheck == 'Y' && l_strMotherNameCheck == 'Y' && 
					   l_strPermanentAddressLine1Check == 'Y' && l_strCommAddressLine1Check == 'Y' && l_strPanNoCheck == 'Y' && 
					   l_strPassportNoCheck == 'Y' && l_strDrivingLicenseNoCheck == 'Y' && l_strDateOfBirthCheck == 'Y'){
				/*alert(l_strFromDate+" "+l_strToDate+" "+l_strCustomerNameCheck+" "+l_strMotherNameCheck+" "+
						l_strPermanentAddressLine1Check+" "+l_strCommAddressLine1Check+" "+l_strPanNoCheck+" "+
						l_strPassportNoCheck+" "+l_strDrivingLicenseNoCheck+" "+l_strDateOfBirthCheck);*/
				var fullData = "l_strFromDate="+l_strFromDate+"&l_strToDate="+l_strToDate+"&l_strCustomerNameCheck="+l_strCustomerNameCheck+
							   "&l_strMotherNameCheck="+l_strMotherNameCheck+"&l_strPermanentAddressLine1Check="+l_strPermanentAddressLine1Check+
							   "&l_strCommAddressLine1Check="+l_strCommAddressLine1Check+"&l_strPanNoCheck="+l_strPanNoCheck+
							   "&l_strPassportNoCheck="+l_strPassportNoCheck+"&l_strDrivingLicenseNoCheck="+l_strDrivingLicenseNoCheck+"&l_strDateOfBirthCheck="+l_strDateOfBirthCheck;
				$("#compassRTScanningModal").modal("show");
				$("#compassRTScanningModal-title").html("DeDup Scanning");
				$("#compassRTScanningModal-body").html("<br/><center><img alt='Loading...' src='${pageContext.request.contextPath}/includes/images/qde-loadder.gif'><center><br/>");
				
				$("#openRTModalInWindow").attr("url-attr", "/common/deDupScanningCheck");
				$("#openRTModalInWindow").attr("data-attr", fullData);
				
				$.ajax({
			 		url : '${pageContext.request.contextPath}/common/deDupScanningCheck',
			 		cache : true,
			 		type : 'POST',
			 		data : fullData,
			 		success : function(resData){
			 			$("#compassRTScanningModal-body").html(resData);
			 		},
			 		error: function(a,b,c){
						alert(a+b+c);
					}
			 	});
			}
			else{
				alert('All fields are mandatory.');
				return false;
			}
 		});
	});
</script>
<div class="row compassrow${UNQID}">
	<div class="col-sm-12">
		<div class="card card-primary panel_deDupScanning">
			<div class="card-header panelSlidingDeDupScanning${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}"><spring:message code="app.common.deDupScanHeader"/></h6>
				<div class="btn-group pull-${dirR} clearfix">
					<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
				</div>
			</div>
			<div class="panelSearchForm">
			<form action="javascript:void(0)" method="POST" id="searchMasterForm${UNQID}">
			<input type="hidden" name="moduleType" value="${MODULETYPE}">
			<div class="card-search-card" >
				<table class="table table-striped formSearchTable deDupScanningTable${UNQID}" style="margin-bottom: 0px;">
					<tr>
						<td width="25%">From Date</td>
						<td width="20%"><input type="text" class="form-control input-sm datepicker" name="fromDate" id="FromDate${UNQID}" value='01/01/1970'/></td>
						<td width="10%">&nbsp;</td>
						<td width="25%">To Date</td>
						<td width="20%"><input type="text" class="form-control input-sm datepicker" name="toDate" id="TODATE${UNQID}"/></td>
					</tr>
					<tr>	
						<td width="25%">Customer Name</td>
						<td width="20%"><input type="checkbox"  name="customerName" id="customerName${UNQID}" value="Y" checked></td>
						<td width="10%">&nbsp;</td>
						<td width="25%">Mother Name</td>
						<td width="20%"><input type="checkbox" name="motherName" id="motherName${UNQID}" value="Y" checked></td>
					</tr>
					<tr>	
						<td width="25%">Permanent AddressLine 1</td>
						<td width="20%"><input type="checkbox" name="permAddr1" id="permAddr1${UNQID}" value="Y" checked></td>
						<td width="10%">&nbsp;</td>
						<td width="25%">Communication AddressLine 1</td>
						<td width="20%"><input type="checkbox" name="commAddr1" id="commAddr1${UNQID}" value="Y" checked></td>
					</tr>
					<tr>	
						<td width="25%">ID Number</td>
						<td width="20%"><input type="checkbox" name="panNo" id="panNo${UNQID}" value="Y" checked></td>
						<td width="10%">&nbsp;</td>
						<td width="25%">Passport Number</td>
						<td width="20%"><input type="checkbox" name="passportNo" id="passportNo${UNQID}" value="Y" checked></td>
					</tr>
					<tr>	
						<td width="25%">Driving License Number</td>
						<td width="20%"><input type="checkbox" name="dlNo" id="dlNo${UNQID}" value="Y" checked></td>
						<td width="10%">&nbsp;</td>
						<td width="25%">Date Of Birth</td>
						<td width="20%"><input type="checkbox" name="dob" id="dob${UNQID}" value="Y" checked></td>
					</tr>
				</table>
			</div>
			<div class="card-footer clearfix">
				<div class="pull-${dirR}">
					<button  type="submit" id="scanDeDup${UNQID}" class="btn btn-success btn-sm"><spring:message code="app.common.scanButton"/></button>
				</div>
			</div>
			</form>
			</div>
		</div>
	</div>
</div>
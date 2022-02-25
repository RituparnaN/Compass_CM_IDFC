<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../tags/tags.jsp"%>
<script type="text/javascript">
	$(document).ready(function() {
		var id = '${UNQID}';
		var userRole = '${USERROLE}';
		var alertMsg = '${ALERTMESSAGES}';
		
		if(userRole == 'ROLE_MLRO' || userRole == 'ROLE_MLROL1' || userRole == 'ROLE_MLROL2'){
			$(document).find("#addFalsePositive"+id).css({display:'none'});
		}else if(userRole == 'ROLE_ADMIN' || userRole == 'ROLE_AMLO'){
			$(document).find("#pendingFalsePositive"+id).css({display:'none'});
		}
		
		compassTopFrame.init(id, 'compassModuleDetailsSearchTable'+id, 'dd/mm/yy');
		
		$('.panelSlidingFalsePositive'+id).on("click", function (e) {
			var mainRow = $(this).parents(".compassrow"+id);
			compassTopFrame.searchPanelSliding(id, mainRow, 'falsePositiveSerachResultPanel');
	    });
		
		 $("#alertCode"+id).change(function(){
			 let alertCode = $(this).val();
			 $("#alertMsg"+id).find('option').remove();
			 var options = "<option value='ALL'>ALL</option>";
			 $.ajax({
				url: "${pageContext.request.contextPath}/admin/getAlertMessages",
				data: "alertCode="+alertCode,
				cache:	false,
				type: "POST",
				success: function(response){
					for(i in response){
						options += "<option value = '"+response[i].CODE+"'>"+response[i].MESSAGE+"</option>";
						//alert(response[i].MESSAGE);
					}
					$("#alertMsg"+id).append(options);
				},
				error: function(a,b,c){
					alert(a+b+c);
				}
			});	
		 });	
		/* $("#alertCode"+id).change(function(){
			var alertCode = $("#alertCode"+id).val();
			//var options = $(this).find("option");
			$('#alertMsg'+id).val(alertCode).trigger('change'); 
			
			$("#alertMsg"+id+" option").each(function(){
				var alertMsg = $(this).val();
				alert()
				if(alertMsg == alertCode){
					alert('true');
					console.log($(this).val());
				}
			}); */
			/* $.each(alertMsg,function(i,v){
				$.each(v,function(key,value){
					alert(key);
				});
			}); */
		
		
		
		/* $("#alertCode"+id).change(function() {
			  var alertCode = $(this).val();
			  var options = $(this).find('option').filter('[value=' + alertCode + ']');
			  $('#alertMsg'+id).html(options).trigger('refresh');  
			  console.log( $('#alertMsg'+id).html(options));
			}); */
		
		$("#addFalsePositive"+id).click(function(){
			var custId = $("#custId"+id).val();
			var accNo = $("#accNo"+id).val();
			var alertCode = $("#alertCode"+id).val();
			var alertMsg = $("#alertMsg"+id+" option:selected").text();
			var activeFrom = $("#activeFrom"+id).val();
			var activeTo = $("#activeTo"+id).val();
			var isEnabled = $("#isEnabled"+id).val();
			var reason = $("#reason"+id).val();
			var toleranceLevel = $("#toleranceLevel"+id).val();
			var status = "Pending";
			var fullData = "";
			var adminComments;
			var mainRow = $(this).parents("div.compassrow"+id);
			var slidingDiv = $(mainRow).children().children().children();
			var panelBody = $(mainRow).children().children().find(".panelSearchForm");
			
			if(custId != '' && accNo != '' && alertMsg != '' && activeFrom != '' &&
					activeTo != '' && isEnabled != '' && toleranceLevel != '' && reason != ''){
				if(reason.length > 4000){
					alert('Reason cannot exceed 4000 characters.');
				}else{
					if(confirm("Confirm adding")){
						adminComments = prompt("Please enter your comments before adding.");
						fullData = "custId="+custId+"&accNo="+accNo+"&alertCode="+alertCode+"&alertMsg="+alertMsg+"&activeFrom="+activeFrom+
						   "&activeTo="+activeTo+"&isEnabled="+isEnabled+"&reason="+reason+"&toleranceLevel="+toleranceLevel+"&status="+status+
						   "&adminComments="+adminComments;
						$.ajax({
							url: "${pageContext.request.contextPath}/admin/addFalsePositive",
							cache: false,
							type: "POST",
							data: fullData,
							success: function(res) {
								$("#falsePositiveSerachResultPanel"+id).css("display", "block");
								$("#falsePositiveSerachResult"+id).html(res);
								$(panelBody).slideUp();
								$(slidingDiv).addClass('card-collapsed');
								$(slidingDiv).find('i.collapsable').removeClass('fa-chevron-up').addClass('fa-chevron-down');
								$(mainRow).next().find(".compassrow"+id).find(".card-header").next().slideDown();
								$(document).find("#updateFalsePositive"+id).css({display:'block'});
								$(document).find("#viewFalsePositive"+id).css({display:'none'});
								$(document).find("#approveFalsePositive"+id).css({display:'none'});
								$(document).find("#rejectFalsePositive"+id).css({display:'none'});
							},
							error: function(a,b,c) {
								alert(a+b+c);
							}
						});
				      }
				}	
			 }else{
				 alert("Enter all the fields data.");
			}
			
		});
		
		$("#searchFalsePositive"+id).click(function(){
			var custId = $("#custId"+id).val();
			var accNo = $("#accNo"+id).val();
			var alertCode = $("#alertCode"+id).val();
			var alertMsg = $("#alertMsg"+id).val();
			var activeFrom = $("#activeFrom"+id).val();
			var activeTo = $("#activeTo"+id).val();
			var isEnabled = $("#isEnabled"+id).val();
			var reason = $("#reason"+id).val();
			var toleranceLevel = $("#toleranceLevel"+id).val();
			var status = "Approved";
			var fullData = "custId="+custId+"&accNo="+accNo+"&alertCode="+alertCode+"&alertMsg="+alertMsg+"&activeFrom="+activeFrom+
						   "&activeTo="+activeTo+"&isEnabled="+isEnabled+"&reason="+reason+"&toleranceLevel="+toleranceLevel+"&status="+status;
			var mainRow = $(this).parents("div.compassrow"+id);
			var slidingDiv = $(mainRow).children().children().children();
			var panelBody = $(mainRow).children().children().find(".panelSearchForm");
			
			$.ajax({
				url: "${pageContext.request.contextPath}/admin/searchFalsePositives",
				cache: false,
				type: "POST",
				data: fullData,
				success: function(res) {
					$("#falsePositiveSerachResultPanel"+id).css("display", "block");
					$("#falsePositiveSerachResult"+id).html(res);
					$(panelBody).slideUp();
					$(slidingDiv).addClass('card-collapsed');
					$(slidingDiv).find('i.collapsable').removeClass('fa-chevron-up').addClass('fa-chevron-down');
					$(mainRow).next().find(".compassrow"+id).find(".card-header").next().slideDown();
					$(document).find("#rejectFalsePositive"+id).css({display:'none'});
					$(document).find("#approveFalsePositive"+id).css({display:'none'});
					
					if(userRole == 'ROLE_MLRO' || userRole == 'ROLE_MLROL1' || userRole == 'ROLE_MLROL2'){
						$(document).find("#updateFalsePositive"+id).css({display:'none'});
						$(document).find("#viewFalsePositive"+id).css({display:'block'});
					}else if(userRole == 'ROLE_ADMIN' || userRole == 'ROLE_AMLO'){
						$(document).find("#updateFalsePositive"+id).css({display:'block'});
						$(document).find("#viewFalsePositive"+id).css({display:'none'});
					}
				},
				error: function(a,b,c) {
					alert(a+b+c);
				}
			});
		});
		
		$("#pendingFalsePositive"+id).click(function(){
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
			var fullData = "custId="+custId+"&accNo="+accNo+"&alertCode="+alertCode+"&alertMsg="+alertMsg+"&activeFrom="+activeFrom+
						   "&activeTo="+activeTo+"&isEnabled="+isEnabled+"&reason="+reason+"&toleranceLevel="+toleranceLevel+"&status="+status;
			var mainRow = $(this).parents("div.compassrow"+id);
			var slidingDiv = $(mainRow).children().children().children();
			var panelBody = $(mainRow).children().children().find(".panelSearchForm");
			
			$.ajax({
				url: "${pageContext.request.contextPath}/admin/searchFalsePositives",
				cache: false,
				type: "POST",
				data: fullData,
				success: function(res) {
					$("#falsePositiveSerachResultPanel"+id).css("display", "block");
					$("#falsePositiveSerachResult"+id).html(res);
					$(panelBody).slideUp();
					$(slidingDiv).addClass('card-collapsed');
					$(slidingDiv).find('i.collapsable').removeClass('fa-chevron-up').addClass('fa-chevron-down');
					$(mainRow).next().find(".compassrow"+id).find(".card-header").next().slideDown();
					$(document).find("#updateFalsePositive"+id).css({display:'none'});
					$(document).find("#rejectFalsePositive"+id).css({display:'block'});
					$(document).find("#approveFalsePositive"+id).css({display:'block'});
				},
				error: function(a,b,c) {
					alert(a+b+c);
				}
			});
		});
		
		
		$("#uploadFalsePositive"+id).click(function(){
			compassFileUpload.init("uploadFalsePositive"+id,"${pageContext.request.contextPath}","custAccFalsePositive","0","Y","Y","");	
		});
		
		$("#updateFalsePositive"+id).click(function(){
			var searchButton = "searchFalsePositive${UNQID}"; 
			var table = $("#falsePositiveSerachResult"+id).find("table").children("tbody");
			var selectedCustId = "";
			var selectedAccNo = "";
			var selectedAlertCode = "";
			var selectedStatus = "";
			var selectedCount = 0;
			var isView = 'N';
			$(table).children("tr").each(function(){
				var checkbox = $(this).children("td:first-child").children("input");
				var custId = $(this).children("td:nth-child(2)").html();
				var accNo = $(this).children("td:nth-child(3)").html();
				var alertCode = $(this).children("td:nth-child(5)").html();
				var status = $(this).children("td:nth-child(6)").html();
				if($(checkbox).prop("checked")){
					selectedCustId = custId;
					selectedAccNo = accNo;
					selectedAlertCode = alertCode;
					selectedStatus = status;
					selectedCount++;
					//alert(selectedStatus);
				}
			});
			if(selectedCount > 1 || selectedCount == 0){
				alert("Select one record at a time to update.");
			}else{
				$.ajax({
					url: "${pageContext.request.contextPath}/admin/fetchFalsePositiveToUpdate",
					cache: false,
					type: "POST",
					data: "selectedCustId="+selectedCustId+"&selectedAccNo="+selectedAccNo+
						  "&selectedAlertCode="+selectedAlertCode+"&selectedStatus="+selectedStatus+"&searchButton="+searchButton+
						  "&isView="+isView,
					
					success: function(response) {
						$("#compassCaseWorkFlowGenericModal").modal("show");
						$("#compassCaseWorkFlowGenericModal-title").html("Update Customer/Account False+ve");
						$("#compassCaseWorkFlowGenericModal-body").html(response);
					},
					error: function(a,b,c) {
						alert(a+b+c);
					}
				});				
			}
		});
		
		$("#viewFalsePositive"+id).click(function(){
			var searchButton = "searchFalsePositive${UNQID}"; 
			var table = $("#falsePositiveSerachResult"+id).find("table").children("tbody");
			var selectedCustId = "";
			var selectedAccNo = "";
			var selectedAlertCode = "";
			var selectedStatus = "";
			var selectedCount = 0;
			var isView = 'Y';
			$(table).children("tr").each(function(){
				var checkbox = $(this).children("td:first-child").children("input");
				var custId = $(this).children("td:nth-child(2)").html();
				var accNo = $(this).children("td:nth-child(3)").html();
				var alertCode = $(this).children("td:nth-child(5)").html();
				var status = $(this).children("td:nth-child(6)").html();
				if($(checkbox).prop("checked")){
					selectedCustId = custId;
					selectedAccNo = accNo;
					selectedAlertCode = alertCode;
					selectedStatus = status;
					selectedCount++;
					//alert(selectedStatus);
				}
			});
			if(selectedCount > 1 || selectedCount == 0){
				alert("Select one record at a time to update.");
			}else{
				
				$.ajax({
					url: "${pageContext.request.contextPath}/admin/fetchFalsePositiveToUpdate",
					cache: false,
					type: "POST",
					data: "selectedCustId="+selectedCustId+"&selectedAccNo="+selectedAccNo+
						  "&selectedAlertCode="+selectedAlertCode+"&selectedStatus="+selectedStatus+"&searchButton="+searchButton+
						  "&isView="+isView,
					
					success: function(response) {
						$("#compassCaseWorkFlowGenericModal").modal("show");
						$("#compassCaseWorkFlowGenericModal-title").html("View Customer/Account False+ve Details");
						$("#compassCaseWorkFlowGenericModal-body").html(response);
					},
					error: function(a,b,c) {
						alert(a+b+c);
					}
				});				
			}
		});
		
		$("#rejectFalsePositive"+id).click(function(){
			var searchButton = "pendingFalsePositive${UNQID}"; 
			var table = $("#falsePositiveSerachResult"+id).find("table").children("tbody");
			var selectedCustId = "";
			var selectedAccNo = "";
			var selectedAlertCode = "";
			var selectedCount = 0;
			$(table).children("tr").each(function(){
				var checkbox = $(this).children("td:first-child").children("input");
				var custId = $(this).children("td:nth-child(2)").html();
				var accNo = $(this).children("td:nth-child(3)").html();
				var alertCode = $(this).children("td:nth-child(5)").html();
				if($(checkbox).prop("checked")){
					selectedCustId = custId;
					selectedAccNo = accNo;
					selectedAlertCode = alertCode;
					selectedCount++;
				}
			});
			if(selectedCount > 1 || selectedCount == 0){
				alert("Select one record at a time to reject.");
			}else{
				var mlroComments = prompt("Please enter your comments before rejecting.");
				if(mlroComments != null){
					$.ajax({
						url: "${pageContext.request.contextPath}/admin/rejectFalsePositive",
						cache: false,
						type: "POST",
						data: "selectedCustId="+selectedCustId+"&selectedAccNo="+selectedAccNo+
							  "&selectedAlertCode="+selectedAlertCode+"&mlroComments="+mlroComments,
						success: function(response) {
							$("#"+searchButton).click();
						},
						error: function(a,b,c) {
							alert(a+b+c);
						}
					});
				}
			}
		});
		
		$("#approveFalsePositive"+id).click(function(){
			var searchButton = "searchFalsePositive${UNQID}"; 
			var table = $("#falsePositiveSerachResult"+id).find("table").children("tbody");
			var selectedCustId = "";
			var selectedAccNo = "";
			var selectedAlertCode = "";
			var selectedAlertMessage = "";
			var selectedActiveFrom = "";
			var selectedActiveTo = "";
			var selectedReason = "";
			var selectedIsEnabled = "";
			var selectedToleranceLevel = "";
			var selectedAdminComments = "";
			var selectedAdminTimestamp = "";
			var selectedCount = 0;
			$(table).children("tr").each(function(){
				var checkbox = $(this).children("td:first-child").children("input");
				var custId = $(this).children("td:nth-child(2)").html();
				var accNo = $(this).children("td:nth-child(3)").html();
				var alertCode = $(this).children("td:nth-child(5)").html();
				var alertMessage = $(this).children("td:nth-child(7)").html();
				var activeFrom = $(this).children("td:nth-child(8)").html();
				var activeTo = $(this).children("td:nth-child(9)").html();
				var reason = $(this).children("td:nth-child(10)").html();
				var isEnabled = $(this).children("td:nth-child(11)").html();
				var toleranceLevel = $(this).children("td:nth-child(12)").html();
				/* var adminComments = $(this).children("td:nth-child(13)").html();
				var adminTimestamp = $(this).children("td:nth-child(14)").html(); */
				
				if($(checkbox).prop("checked")){
					selectedCustId = custId;
					selectedAccNo = accNo;
					selectedAlertCode = alertCode;
					selectedAlertMessage = alertMessage;
					selectedActiveFrom = activeFrom;
					selectedActiveTo = activeTo;
					selectedReason = reason;
					selectedIsEnabled = isEnabled;
					selectedToleranceLevel = toleranceLevel;
					/* selectedAdminComments = adminComments;
					selectedAdminTimestamp = adminTimestamp; */
					selectedCount++;
				}
			});
			/* alert("selectedCustId="+selectedCustId+"&selectedAccNo="+selectedAccNo+
					  "&selectedAlertCode="+selectedAlertCode+"&selectedAlertMessage="+selectedAlertMessage+
					  "&selectedActiveFrom="+selectedActiveFrom+"&selectedActiveTo="+selectedActiveTo+
					  "&selectedReason="+selectedReason+"&selectedIsEnabled="+selectedIsEnabled+
					  "&selectedToleranceLevel="+selectedToleranceLevel+"&selectedMlroComments="+selectedMlroComments +
					  "&selectedAdminComments="+selectedAdminComments+"&selectedAdminTimestamp="+selectedAdminTimestamp ); */
			if(selectedCount > 1 || selectedCount == 0){
				alert("Select one record at a time to approve.");
			}else{
				var selectedMlroComments = prompt("Please enter your comments before approving.");
				if(selectedMlroComments != null){
					$.ajax({
						url: "${pageContext.request.contextPath}/admin/approveFalsePositive",
						cache: false,
						type: "POST",
						data: "selectedCustId="+selectedCustId+"&selectedAccNo="+selectedAccNo+
							  "&selectedAlertCode="+selectedAlertCode+"&selectedAlertMessage="+selectedAlertMessage+
							  "&selectedActiveFrom="+selectedActiveFrom+"&selectedActiveTo="+selectedActiveTo+
							  "&selectedReason="+selectedReason+"&selectedIsEnabled="+selectedIsEnabled+
							  "&selectedToleranceLevel="+selectedToleranceLevel+"&selectedMlroComments="+selectedMlroComments/* +
							  "&selectedAdminComments="+selectedAdminComments+"&selectedAdminTimestamp="+selectedAdminTimestamp */,
						success: function(response) {
							$("#pendingFalsePositive"+id).click();
						},
						error: function(a,b,c) {
							alert(a+b+c);
						}
					});
				}
			}
		});
	});
</script>
<div class="row compassrow${UNQID}">
	<div class="col-sm-12">
		<div class="card card-primary panel_falsePositive">
			<div class="card-header panelSlidingFalsePositive${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}"><spring:message code="app.common.falsePositiveSearchHeader"/></h6>
				<div class="btn-group pull-${dirR} clearfix">
					<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
				</div>
			</div>
			<div class="panelSearchForm">
			<form action="javascript:void(0)" method="POST" id="searchMasterForm${UNQID}">
				<table class="table table-striped compassModuleDetailsSearchTable${UNQID}" style="margin-bottom: 0px;">
					<tr>
						<td width="15%">Customer Id</td>
							<td width="30%">
								<div class="input-group" style="z-index: 1">
									<input type="text" class="form-control input-sm" name="custId" id="custId${UNQID}"/>
									<span class="input-group-addon" id="basic-addon${UNQID}" 
										onclick="compassTopFrame.moduleSearch('custId${UNQID}','CUSTOMERID','VW_CUSTOMERID_SEARCH','N','${pageContext.request.contextPath}')" style="cursor: pointer;" title="Search">
										<i class="fa fa-search"></i>
									</span>
								</div>
							</td>
						<td width="10%">&nbsp;</td>
						<td width="15%">Account No</td>
						<td width="30%">
							<div class="input-group" style="z-index: 1">
								<input type="text" class="form-control input-sm" name="accNo" id="accNo${UNQID}"/>
								<span class="input-group-addon" id="basic-addon${UNQID}" 
									onclick="compassTopFrame.moduleSearch('accNo${UNQID}','ACCOUNTNO','VW_ACCOUNTNO_SEARCH','Y','${pageContext.request.contextPath}')" style="cursor: pointer;" title="Search">
									<i class="fa fa-search"></i>
								</span>
							</div>
						</td>
					</tr>
					<%-- <tr><td colspan="5">${ALERTCODES}</td></tr> --%>
					<tr>	
						<td width="15%">Alert Code</td>
						<td width="30%">
							<select class="form-control input-sm" name="alertCode" id="alertCode${UNQID}">
								<c:forEach var="alertCodes" items="${ALERTCODES}">
									<option value="${alertCodes.key}">${alertCodes.key} - ${alertCodes.value}</option>
								</c:forEach>
							</select>
						</td>
						<td width="10%">&nbsp;</td>
						<td width="15%">Alert Message</td>
						<td width="30%">
							<select class="form-control input-sm" name="alertMsg" id="alertMsg${UNQID}">
								<option value=""></option>
							</select>
							<%-- <select class="form-control input-sm" name="alertMsg" id="alertMsg${UNQID}">
								<c:forEach var="alertMsgs" items="${ALERTMESSAGES}">
									<c:forEach var="alertMsg" items="${alertMsgs}">
										<option value="${alertMsg.key}">${alertMsg.key} - ${alertMsg.value}</option>
									</c:forEach>
								</c:forEach>
							</select> --%>
						</td>
					</tr>
					<tr>	
						<td width="15%">Active From</td>
						<td width="30%">
							<input type="text" class="form-control input-sm datepicker" id="activeFrom${UNQID}" name="activeFrom" /></td>
						<td width="10%">&nbsp;</td>
						<td width="15%">Active To</td>
						<td width="30%">
							<input type="text" class="form-control input-sm datepicker" id="activeTo${UNQID}" name="activeTo" /></td>
					</tr>
					<tr>	
						<td width="15%">Is Enabled</td>
						<td width="30%">
							<select class="form-control input-sm" name="isEnabled" id="isEnabled${UNQID}">
								<option value=""></option>
								<option value="Y">Yes</option>
								<option value="N">No</option>
							</select>
						</td>
						<td width="10%">&nbsp;</td>
						<td width="15%">Tolerance Level</td>
						<td width="30%">
							<input type="text" class="form-control input-sm" name="toleranceLevel" id="toleranceLevel${UNQID}"
							onkeyup="$(this).val($(this).val().replace(/[^\d]/ig, ''))">
						</td>
					</tr>
					<tr>	
						<td width="15%">Reason</td>
						<td colspan="4">
							<textarea class="form-control input-sm" name="reason" id="reason${UNQID}"></textarea>
						</td>
						</tr>
				</table>
				<div class="card-footer clearfix">
					<div class="pull-${dirR}">
						<input type="button" id="addFalsePositive${UNQID}" class="btn btn-success btn-sm" name="Add" value="Add">
						<c:if test="${USERROLE eq 'ROLE_ADMIN' || USERROLE eq 'ROLE_AMLO'}">
							<input type="button" id="searchFalsePositive${UNQID}" class="btn btn-primary btn-sm" name="Search" value="Search">
						</c:if>
						<c:if test="${USERROLE eq 'ROLE_MLRO' || USERROLE eq 'ROLE_MLROL1' || USERROLE eq 'ROLE_MLROL2'}">
							<input type="button" id="pendingFalsePositive${UNQID}" class="btn btn-primary btn-sm" name="pendingFalsePositive" value="Search for Approval"/>
						</c:if>
						<input type="button" class="btn btn-warning btn-sm" id="uploadFalsePositive${UNQID}" name="UploadFalsePositive" value="Upload False Positive"/>
						<input type="reset" class="btn btn-danger btn-sm" id="clearFalsePositive${UNQID}" name="Clear" value="Clear"/>
					</div>
				</div>
			</form>
			</div>
		</div>
		<div class="card card-primary" id="falsePositiveSerachResultPanel${UNQID}" style="display: none;">
			<div class="card-header panelSlidingFalsePositive${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}"><spring:message code="app.common.falsePositiveResultHeader"/></h6>
				<div class="btn-group pull-${dirR} clearfix">
					<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
				</div>
			</div>
			<div id="falsePositiveSerachResult${UNQID}"></div>
			<div class="card-footer clearfix">
				<div class="pull-${dirR}" style="display: flex;">
				<input type="button" class="btn btn-primary btn-sm" id="updateFalsePositive${UNQID}" name="Update" value="Update" style="margin-right: 5px;"/>
				<input type="button" class="btn btn-primary btn-sm" id="viewFalsePositive${UNQID}" name="View" value="View" style="margin-right: 5px;"/>
				<input type="button" class="btn btn-success btn-sm" id="approveFalsePositive${UNQID}" name="Approve" value="Approve" style="margin-right: 5px;"/>
				<input type="button" class="btn btn-danger btn-sm" id="rejectFalsePositive${UNQID}" name="Reject" value="Reject"/>
				</div>
			</div>
		</div>
	</div>
</div>
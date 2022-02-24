<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../tags/tags.jsp"%>
<script type="text/javascript">
	$(document).ready(function() {
		var id = '${UNQID}';
		compassTopFrame.init(id, 'compassModuleDetailsSearchTable'+id, 'dd/mm/yy');
		
		$('.panelSlidingFalsePositive'+id).on("click", function (e) {
			var mainRow = $(this).parents(".compassrow"+id);
			compassTopFrame.searchPanelSliding(id, mainRow, 'falsePositiveSerachResultPanel');
	    });
		
		$("#addFalsePositive"+id).click(function(){
			var custId = $("#custId"+id).val();
			var accNo = $("#accNo"+id).val();
			var alertCode = $("#alertCode"+id).val();
			var alertMsg = $("#alertMsg"+id).val();
			var activeFrom = $(".activeFrom"+id).val();
			var activeTo = $(".activeTo"+id).val();
			var isEnabled = $("#isEnabled"+id).val();
			var reason = $("#reason"+id).val();
			var toleranceLevel = $("#toleranceLevel"+id).val();
			var fullData = "custId="+custId+"&accNo="+accNo+"&alertCode="+alertCode+"&alertMsg="+alertMsg+"&activeFrom="+activeFrom+
						   "&activeTo="+activeTo+"&isEnabled="+isEnabled+"&reason="+reason+"&toleranceLevel="+toleranceLevel;
			var mainRow = $(this).parents("div.compassrow"+id);
			var slidingDiv = $(mainRow).children().children().children();
			var panelBody = $(mainRow).children().children().find(".panelSearchForm");
			if(custId != '' && accNo != '' && alertMsg != '' && activeFrom != '' &&
					activeTo != '' && isEnabled != '' && reason != '' && toleranceLevel != ''){
				if(confirm("Confirm adding")){
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
						},
						error: function(a,b,c) {
							alert(a+b+c);
						}
					});
			      }
			 }else
				 alert("Enter all the fields data.");
		});
		
		$("#searchFalsePositive"+id).click(function(){
			var custId = $("#custId"+id).val();
			var accNo = $("#accNo"+id).val();
			var alertCode = $("#alertCode"+id).val();
			var alertMsg = $("#alertMsg"+id).val();
			var activeFrom = $(".activeFrom"+id).val();
			var activeTo = $(".activeTo"+id).val();
			var isEnabled = $("#isEnabled"+id).val();
			var reason = $("#reason"+id).val();
			var toleranceLevel = $("#toleranceLevel"+id).val();
			var fullData = "custId="+custId+"&accNo="+accNo+"&alertCode="+alertCode+"&alertMsg="+alertMsg+"&activeFrom="+activeFrom+
						   "&activeTo="+activeTo+"&isEnabled="+isEnabled+"&reason="+reason+"&toleranceLevel="+toleranceLevel;
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
				alert("Select one record at a time to update.");
			}else{
				$("#compassCaseWorkFlowGenericModal").modal("show");
				$("#compassCaseWorkFlowGenericModal-title").html("Update Customer/Account False+ve");
				$.ajax({
					url: "${pageContext.request.contextPath}/admin/fetchFalsePositiveToUpdate",
					cache: false,
					type: "POST",
					data: "selectedCustId="+selectedCustId+"&selectedAccNo="+selectedAccNo+
						  "&selectedAlertCode="+selectedAlertCode+"&searchButton="+searchButton,
					success: function(response) {
						$("#compassCaseWorkFlowGenericModal-body").html(response);
					},
					error: function(a,b,c) {
						alert(a+b+c);
					}
				});
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
				<table class="table compassModuleDetailsSearchTable${UNQID}" style="margin-bottom: 0px;">
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
					<tr>	
						<td width="15%">Alert Code</td>
						<td width="30%">
							<select class="form-control input-sm" name="alertCode" id="alertCode${UNQID}">
								<c:forEach var="alertCodes" items="${ALERTCODES}">
									<option value="${alertCodes.key}">${alertCodes.value}</option>
								</c:forEach>
							</select>
						</td>
						<td width="10%">&nbsp;</td>
						<td width="15%">Alert Message</td>
						<td width="30%"><input type="text" class="form-control input-sm" name="alertMsg" id="alertMsg${UNQID}"/></td>
					</tr>
					<tr>	
						<td width="15%">Active From</td>
						<td width="30%">
							<input type="text" class="form-control input-sm datepicker activeFrom${UNQID}" name="activeFrom" /></td>
						<td width="10%">&nbsp;</td>
						<td width="15%">Active To</td>
						<td width="30%">
							<input type="text" class="form-control input-sm datepicker activeTo${UNQID}" name="activeTo" /></td>
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
						<td width="15%">Reason</td>
						<td width="30%">
							<textarea class="form-control input-sm" name="reason" id="reason${UNQID}"></textarea>
						</td>
						</tr>
					<tr>	
						<td width="15%">Tolerance Level</td>
						<td width="30%">
							<input type="text" class="form-control input-sm" name="toleranceLevel" id="toleranceLevel${UNQID}">
						</td>
						<td width="10%">&nbsp;</td>
						<td width="15%">&nbsp;</td>
						<td width="30%">&nbsp;</td>
						</tr>
				</table>
				<div class="card-footer clearfix">
					<div class="pull-${dirR}">
						<input type="button" id="addFalsePositive${UNQID}" class="btn btn-primary btn-sm" name="Add" value="Add">
						<button type="button" id="searchFalsePositive${UNQID}" class="btn btn-success btn-sm" name="Search" value="Search">Search</button>
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
				<div class="pull-${dirR}">
				<input type="button" class="btn btn-primary btn-sm" id="updateFalsePositive${UNQID}" name="Update" value="Update"/>
				</div>
			</div>
		</div>
	</div>
</div>
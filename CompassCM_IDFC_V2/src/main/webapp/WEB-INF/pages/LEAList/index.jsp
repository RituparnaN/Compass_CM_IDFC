<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../tags/tags.jsp"%>
<script type="text/javascript">
	$(document).ready(function() {
		var id = '${UNQID}';
		var currentRole = '${CURRENTROLE}';
		var listStatus = '${LISTSTATUS}';
		
		$('.panelSlidingManageLEAList'+id).on("click", function (e) {
			var mainRow = $(this).parents(".compassrow"+id);
			compassTopFrame.searchPanelSliding(id, mainRow, 'searchLEAListSerachResultPanel');
	    });
		
		/*if(currentRole == "ROLE_LEAMAKER"){
			$("#createLEAList"+id).css("display","inline-block");
			//$("#uploadLEAList"+id).css("display","inline-block");
			$("#updateLEAList"+id).css("display","inline-block");
			$("#approveLEAList"+id).css("display","none");
			$("#rejectLEAList"+id).css("display","none");
		}
		else if(currentRole == "ROLE_LEACHECKER"){
			$("#createLEAList"+id).css("display","none");
			//$("#uploadLEAList"+id).css("display","none");
			$("#updateLEAList"+id).css("display","none");
			$("#approveLEAList"+id).css("display","inline-block");
			$("#rejectLEAList"+id).css("display","inline-block");
			
		}*/
			
		$("#createLEAList"+id).click(function(){
			var searchButton = "searchLEAList${UNQID}";
			$.ajax({
				url: "${pageContext.request.contextPath}/common/createLEAList",
				cache: false,
				type: "POST",
				data: "searchButton="+searchButton,
				success: function(res){
					$("#compassCaseWorkFlowGenericModal").modal("show");
					$("#compassCaseWorkFlowGenericModal-title").html("Create LEA List");
					$("#compassCaseWorkFlowGenericModal-body").html(res);
				},
				error: function(a,b,c){
					alert(a+b+c);
				}
			});			
		});
		
		$("#searchLEAList"+id).click(function(){
			var listCode = $("#listCode"+id).val();
			var serialNo = $("#serialNumber"+id).val();
			var listStatus = $("#listStatus"+id).val();
			var fullData = "listCode="+listCode+"&serialNo="+serialNo+"&listStatus="+listStatus;
			
			var mainRow = $(this).parents("div.compassrow"+id);
			var slidingDiv = $(mainRow).children().children().children();
			var panelBody = $(mainRow).children().children().find(".panelSearchForm");
			
			$.ajax({
				url: "${pageContext.request.contextPath}/common/searchLEAList",
				cache: false,
				type: "POST",
				data: fullData,
				success: function(res) {
					$("#searchLEAListSerachResultPanel"+id).css("display", "block");
					$("#searchLEAListSerachResult"+id).html(res);
					$(panelBody).slideUp();
					$(slidingDiv).addClass('card-collapsed');
					$(slidingDiv).find('i.collapsable').removeClass('fa-chevron-up').addClass('fa-chevron-down');
					$(mainRow).next().find(".compassrow"+id).find(".card-header").next().slideDown();
					
					if(listStatus == 'A' || listStatus == 'R'){
						$("#approveLEAList"+id).css("display","none");
						$("#rejectLEAList"+id).css("display","none");
					}else{
						$("#approveLEAList"+id).css("display","inline-block");
						$("#rejectLEAList"+id).css("display","inline-block");
					}
				},
				error: function(a,b,c) {
					alert(a+b+c);
				}
			});
		});
		
		$("#updateLEAList"+id).click(function(){
			var searchButton = "searchLEAList${UNQID}";
			var table = $("#searchLEAListSerachResult"+id).find("table").children("tbody");
			var listCodeToUpdate = "";
			var selectedCount = 0;
			$(table).children("tr").each(function(){
				var checkbox = $(this).children("td:first-child").children("input");
				var listCode = $(this).children("td:nth-child(2)").children("a").html();
				
				if($(checkbox).prop("checked")){
					listCodeToUpdate = listCode;
					selectedCount++;
				}
			});
			if (selectedCount > 1 || selectedCount == 0)
				alert("You can update only one LEA record at a time.");
			else{
				$("#compassCaseWorkFlowGenericModal").modal("show");
				$("#compassCaseWorkFlowGenericModal-title").html("Update LEAList");
				$.ajax({
					url: "${pageContext.request.contextPath}/common/fetchLEAListForUpdate",
					cache: false,
					type: "POST",
					data: "listCodeToUpdate="+listCodeToUpdate+"&searchButton="+searchButton,
					success: function(response) {
						$("#compassCaseWorkFlowGenericModal-body").html(response);
					},
					error: function(a,b,c) {
						alert(a+b+c);
					}
				});
				
			}
		});
		
		approveOrReject = function (statusMessage){
			var searchButton = $("#searchLEAList"+id);
			var table = $("#searchLEAListSerachResult"+id).find("table").children("tbody");
			var listCodeToUpdate = "";
			var status = statusMessage;
			var check = "";
			var recordStatus = "";
			if(status == "A"){
				check = "approval";
			}else if(status == "R"){
				check = "rejection";
			}
			var selectedCount = 0;
			$(table).children("tr").each(function(){
				var checkbox = $(this).children("td:first-child").children("input");
				var listCode = $(this).children("td:nth-child(2)").children("a").html();
				recordStatus = $(this).children("td:nth-child(8)").html();
				if($(checkbox).prop("checked")){
					listCodeToUpdate = listCode;
					selectedCount++;
				}
			});
			if (selectedCount > 1 || selectedCount == 0)
				alert("You can select only one LEA record at a time.");
			else if(recordStatus == 'A' || recordStatus == 'R'){
				alert("This record is already approved/rejected.");
			}else{
				if(confirm("Confirm "+check)){
					$.ajax({
						url: "${pageContext.request.contextPath}/common/approveOrRejectLEAList",
						cache: false,
						data: "listCodeToUpdate="+listCodeToUpdate+"&status="+status,
						type: "POST",
						success: function(response) {
							alert(response);
							searchButton.click();
						},
						error: function(a,b,c) {
							alert(a+b+c);
						}
					});
				}
			}
		};
		
		$("#uploadLEAList"+id).click(function(){
			/* 25/12/2018- interchange the below lines for disabling file deletion */
			//compassFileUpload.init("uploadLEAList"+id,"${pageContext.request.contextPath}","LEALIST","LEAList","Y","");
			compassFileUpload.init("uploadLEAList"+id,"${pageContext.request.contextPath}","LEALIST","LEAList","Y","Y");
		});
		
		/* $('#deleteLEAList'+id).click(function(){
			var table = $("#searchLEAListSerachResult"+id).find("table").children("tbody");
			var listCodeToDelete = "";
			var selectedCount = 0;
			$(table).children("tr").each(function(){
				var checkbox = $(this).children("td:first-child").children("input");
				var listCode = $(this).children("td:nth-child(2)").children("a").html();
				if($(checkbox).prop("checked")){
					listCodeToDelete = listCodeToDelete + listCode+",";
					selectedCount++;
				}
			});
			
			if(selectedCount > 0){
				if(confirm("Are you sure?")){
					$.ajax({
						url: "${pageContext.request.contextPath}/common/deleteLEAList",
						cache: false,
						type: "POST",
						data: "listCodeToDelete="+listCodeToDelete,
						success: function(res) {
							alert(res);
							$("#searchLEAList"+id).click();
						},
						error: function(a,b,c) {
							alert(a+b+c);
						}
					});
				}
			}else
				alert("Select atleast one record");
		}); */
		
	});
</script>
<div class="row compassrow${UNQID}">
	<div class="col-sm-12">
		<div class="card card-primary panel_manageLEAList">
			<div class="card-header panelSlidingManageLEAList${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}"><spring:message code="app.common.leaListSearchHeader"/></h6>
				<div class="btn-group pull-${dirR} clearfix">
					<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
				</div>
			</div>
			<div class="panelSearchForm">
			<form action="javascript:void(0)" method="POST" id="searchMasterForm${UNQID}">
				<table class="table compassModuleDetailsSearchTable" style="margin-bottom: 0px;">
					<tr>
						<td width="15%">List Code</td>
						<td width="30%"><input type="text" class="form-control input-sm" name="listCode" id="listCode${UNQID}"/></td>
						<td width="10%">&nbsp;</td>
						<td width="15%">Serial Number</td>
						<td width="30%"><input type="text" class="form-control input-sm" name="serialNumber" id="serialNumber${UNQID}"/></td>
					</tr>
					<tr>
						<td width="15%">Status</td>
						<td width="30%">
							<select class="form-control input-sm" id="listStatus${UNQID}" name="listStatus">
								<option value="">All</option>
								<option value="P">Pending</option>
								<option value="A">Approved</option>
								<option value="R">Rejected</option>
							</select> 
						</td>
						<td width="10%">&nbsp;</td>
						<td width="15%">&nbsp;</td>
						<td width="30%">&nbsp;</td>
					</tr>
				</table>
				<div class="card-footer clearfix">
					<div class="pull-${dirR}">
					<c:if test="${CURRENTROLE eq 'ROLE_LEAMAKER'}">
						<input type="button" id="createLEAList${UNQID}" class="btn btn-primary btn-sm" name="Create" value="Create">
					</c:if>
						<button type="button" id="searchLEAList${UNQID}" class="btn btn-success btn-sm"><spring:message code="app.common.searchButton"/></button>
						<input type="button" class="btn btn-warning btn-sm" id="uploadLEAList${UNQID}" name="uploadLEAList" value="Upload List"/>
						<input type="reset" class="btn btn-danger btn-sm" id="clearLEAList${UNQID}" name="Clear" value="Clear"/>
					</div>
				</div>
			</form>
			</div>
		</div>
		<div class="card card-primary" id="searchLEAListSerachResultPanel${UNQID}" style="display: none;">
			<div class="card-header panelSlidingManageLEAList${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}"><spring:message code="app.common.leaListResultHeader"/></h6>
				<div class="btn-group pull-${dirR} clearfix">
					<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
				</div>
			</div>
			<div id="searchLEAListSerachResult${UNQID}"></div>
			<div class="card-footer clearfix">
				<div class="pull-${dirR}">
				<c:if test="${CURRENTROLE eq 'ROLE_LEAMAKER'}">
					<input type="button" class="btn btn-primary btn-sm" id="updateLEAList${UNQID}" name="Update" value="Update"/>
				</c:if>
				<c:if test="${CURRENTROLE eq 'ROLE_LEACHECKER'}">
					<input type="button" class="btn btn-success btn-sm" id="approveLEAList${UNQID}" name="Approve" value="Approve" onclick="approveOrReject('A')"/>
					<input type="button" class="btn btn-danger btn-sm" id="rejectLEAList${UNQID}" name="Reject" value="Reject" onclick="approveOrReject('R')"/>
				</c:if>
					<%-- <input type="button" class="btn btn-danger btn-sm" id="deleteLEAList${UNQID}" name="Delete" value="Delete"/> --%>
				</div>
			</div>
		</div>
	</div>
</div>
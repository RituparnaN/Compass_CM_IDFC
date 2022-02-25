<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../../tags/tags.jsp"%>
<script type="text/javascript">
	$(document).ready(function(){
	var id = '${UNQID}';
	var userRole = '${USERROLE}';
	compassTopFrame.init(id, 'compassHighRiskWordSearchTable'+id, 'dd/mm/yy');
	
	var newWindowArray = [];
	
	$(".datepicker").datepicker({
		 dateFormat : "dd/mm/yy",
		 changeMonth: true,
	     changeYear: true
	});
	
	if(userRole == 'ROLE_MLRO' || userRole == 'ROLE_MLROL1' || userRole == 'ROLE_MLROL2'){
		$(document).find("#addNew"+id).css({display:'none'});
	}else if(userRole == 'ROLE_AMLO'){
		$(document).find(".approveReject").css({display:'none'});
	}
	
	$('.panelSlidingHighRiskWord'+id).on("click", function (e) {
		var mainRow = $(this).parents(".compassrow"+id);
		compassTopFrame.searchPanelSliding(id, mainRow, 'highRiskWordSerachResultPanel'+id);
    });
	
	$("#searchMasterForm"+id).submit(function(e){
		var submitButton = $("#searchHighRiskWord"+id);
		compassTopFrame.submitForm(id, e, submitButton, 'highRiskWordSerachResultPanel', 
				'highRiskWordSerachResult', '${pageContext.request.contextPath}/common/searchGenericMaster',
				'${pageContext.request.contextPath}/includes/images/qde-loadder.gif');
	});
	
	
	$("#addNew"+id).click(function(){
		var searchButton = "searchHighRiskWord${UNQID}";
		var actionForModal = "New";
		$.ajax({
			url: "${pageContext.request.contextPath}/common/openModalForNewEntry",
			cache: false,
			type: "POST",
			data: "searchButton="+searchButton+"&actionForModal="+actionForModal,
			success: function(res){
				$("#compassMediumGenericModal").modal("show");
				$("#compassMediumGenericModal-title").html("Add New Entry");
				$("#compassMediumGenericModal-body").html(res);
			},
			error: function(a,b,c){
				alert(a+b+c);
			}
		});
	});
	
	/* 25032019- method called for View/Update(hyperlinks) */
	getSeqNoDetails = function(seqNo){
		var searchButton = "searchHighRiskWord${UNQID}";
		var actionForModal = "";
		var modalTitle = "";
		if(userRole == 'ROLE_MLRO' || userRole == 'ROLE_MLROL1' || userRole == 'ROLE_MLROL2'){
			actionForModal = "View";
			modalTitle = "View SeqNo Details";
		}else if(userRole == 'ROLE_AMLO'){
			actionForModal = "Update";
			modalTitle = "Update SeqNo Details";
		}
		//console.log(seqNo);
		$.ajax({
			url: "${pageContext.request.contextPath}/common/getSeqNoDetails",
			cache: false,
			type: "POST",
			data: "searchButton="+searchButton+"&actionForModal="+actionForModal+
				"&seqNo="+seqNo,
			success: function(res){
				$("#compassMediumGenericModal").modal("show");
				$("#compassMediumGenericModal-title").html(modalTitle);
				$("#compassMediumGenericModal-body").html(res);
			},
			error: function(a,b,c){
				alert(a+b+c);
			}
		});
	}
	
	$(".approveReject").click(function(){
		var searchButton = "searchHighRiskWord${UNQID}";
		var buttonClicked = $(this).val();
		var action = "";
		var seqNo = "";
		var statusSelected = "";
		var selectedCount = 0;
		var checkerComments = "";
		if(buttonClicked == 'Approve'){
			action = "Approve";
		}else if(buttonClicked == 'Reject'){
			action = "Reject";
		}
		$("#highRiskWordSerachResult"+id).find("table").children("tbody").children("tr").each(function(){
			var row = $(this).children("td").eq(0).children("input[type='checkbox']");
			if($(row).prop("checked")){
				seqNo = $(this).children("td:nth-child(2)").text().trim();
				statusSelected = $(this).children("td:nth-child(5)").text().charAt(0);
				selectedCount++;
			}
		});
		if (selectedCount > 1 || selectedCount == 0){
			alert("You can select a single record only at a time.");
		}else{
			if(statusSelected.charAt(0) == "A" || statusSelected.charAt(0) == "R"){
				alert("Please select a pending record.");
			}else{
				checkerComments = prompt("Please enter some comments.");
				if(!checkerComments == ""){
					$.ajax({
						url: "${pageContext.request.contextPath}/common/approveOrReject",
						cache: false,
						type: "POST",
						data: "action="+action+"&seqNo="+seqNo+"&checkerComments="+checkerComments,
						success: function(res){
							alert(res);
							$("#"+searchButton).click();
						},
						error: function(a,b,c){
							alert(a+b+c);
						}
					});
				}else{
					alert("Checker's comment is necessary.");
				}
			}
		}
	});
	
	// Called the generic clear function
	genericClear(id);
	
});
</script>
<div class="row compassrow${UNQID}">
	<div class="col-sm-12">
		<div class="card card-primary panel_highRiskWord">
			<div class="card-header panelSlidingHighRiskWord${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}">CRP High Risk Word</h6>
				<div class="btn-group pull-${dirR} clearfix">
					<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
				</div>
			</div>
			<div class="panelSearchForm">
			<form action="javascript:void(0)" method="POST" id="searchMasterForm${UNQID}">
				<input type="hidden" name="moduleType" value="${MODULETYPE}">
				<input type="hidden" name="bottomPageUrl" value="MasterModules/CRPHighRiskWord/SearchBottomPage">
				<table class="table compassHighRiskWordSearchTable${UNQID}" style="margin-bottom: 0px;">
					<tr>
						<td width="15%">Word</td>
						<td width="30%">
							<input type="text" class="form-control input-sm" id="wordField${UNQID}" name="1_WORD"></input>
						</td>
						<td width="10%">&nbsp;</td>
						<td width="15%">Is Enabled</td>
						<td width="30%">
							<select class="form-control input-sm" id="isEnabled${UNQID}" name="2_ISENABLED" style="width: 100%;">
								<option value="ALL">ALL</option>
								<option value="Y">Yes</option>
								<option value="N">No</option>
							</select>
						</td>
					</tr>
					<tr>
						<td width="15%">Status</td>
						<td width="30%">
							<select class="form-control input-sm" id="status${UNQID}" name="3_STATUS" style="width: 100%;">
								<option value="ALL">ALL</option>
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
						<button type="submit" id="searchHighRiskWord${UNQID}" class="btn btn-primary btn-sm" name="Search" value="Search">Search</button>
						<%-- <input type="reset" id="clearHighRiskWordMapping${UNQID}" class="btn btn-danger btn-sm" name="Clear" value="Clear"> --%>
						<!--  28.05.2019 -->
						<input type="button" id="clear${UNQID}" class="btn btn-danger btn-sm" name="Clear" value="Clear"/>
					</div>
				</div>
			</form>
			</div>
		</div>
		<div class="card card-primary" id="highRiskWordSerachResultPanel${UNQID}" style="display: none;">
			<div class="card-header panelSlidingHighRiskWord${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}">CRP High Risk Word List</h6>
				<div class="btn-group pull-${dirR} clearfix">
					<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
				</div>
			</div>
			<div id="highRiskWordSerachResult${UNQID}"></div>
			<div class="card-footer clearfix">
				<div class="pull-${dirR}">
					<input type="button" class="btn btn-success btn-sm approveReject" id="approve${UNQID}" name="Approve" value="Approve"/>
					<input type="button" class="btn btn-danger btn-sm approveReject" id="reject${UNQID}" name="Reject" value="Reject"/>
					<input type="button" class="btn btn-primary btn-sm" id="addNew${UNQID}" name="Add New" value="Add New"/>
				</div>
			</div>
		</div>
	</div>
</div>
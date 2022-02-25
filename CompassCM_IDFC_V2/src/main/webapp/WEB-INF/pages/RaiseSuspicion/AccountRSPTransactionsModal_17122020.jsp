<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ include file="../tags/tags.jsp"%>
    
<script type="text/javascript">
	$(document).ready(function(){
		var id = '${ALERTNO}';
		compassTopFrame.init(id, 'accountRSPTransactionsTable${ALERTNO}', 'dd/mm/yy');
		
		compassDatatable.construct('raiseSuspicionTransactionsTable${ALERTNO}', "Raise Suspicion Transactions", true);
		compassDatatable.enableCheckBoxSelection();
		
		$('.panelSlidingAccountTransactions'+id).on("click", function (e) {
			var mainRow = $(this).parents(".compassrowAccountRSPTransactions"+id);
			compassTopFrame.searchPanelSliding(id, mainRow, 'accountTransactionsDiv');
	    });
		
		
		$("#searchAccountRSPTransactions"+id).click(function(){
			var accountNo = $("#accountNo"+id).val();
			var fromDate = $("#FROMDATE_"+id).val();
			var toDate = $("#TODATE_"+id).val();
			$.ajax({
				url: "${pageContext.request.contextPath}/common/fetchAccountNoBasedTransactions",
				cache: false,
				type: "POST",
				data: "accountNo="+accountNo+"&fromDate="+fromDate+"&toDate="+toDate,
				success: function(res) {
					transactionsTableUpdateFunction(res['HEADER'], res['DATA'],
							"accountTransactionsTable${ALERTNO}", "Account Transactions");
					compassDatatable.enableCheckBoxSelection();
					$("#accountTransactionsDiv"+id).css("display", "BLOCK");
					
					//searchFormSlidingUp
					var slidingDiv = $(".compassrowAccountRSPTransactions"+id).children().children().children();
					var panelBody = $(".compassrowAccountRSPTransactions"+id).children().children().find(".panelSearchForm");
					$(panelBody).slideUp();
					$(slidingDiv).addClass('card-collapsed');
					$(slidingDiv).find('i.collapsable').removeClass('fa-chevron-up').addClass('fa-chevron-down');
					$(".compassrowAccountRSPTransactions"+id).next().find(".compassrowAccountRSPTransactions"+id).find(".card-header").next().slideDown();
					//
				},
				error: function(a,b,c) {
					alert(a+b+c);
				}
			});
		});
		
		$("#addAccountRSPTransactions"+id).click(function(){
			var accountNo = $("#accountNo"+id).val();
			var action = "ADD";
			var transactionNo = "";
			var count = 0;
			$(".accountTransactionsTable"+id).children("tbody").find("tr").each(function(){
				if($(this).children("td").children("input").prop("checked")){
					transactionNo += $(this).children("td:nth-child(2)").html().trim()+"~~~";
					count++;
				}
			});
			if(count == 0){
				alert("Select a record");
			}else {
				$.ajax({
					url: "${pageContext.request.contextPath}/common/updateAccountRSPTransactions",
					cache: false,
					type: "POST",
					data: "alertNo="+id+"&accountNo="+accountNo+"&transactionNo="+transactionNo+
						"&action="+action,
					success: function(res) {
						//VIVEK - updating raise suspicion table
						transactionsTableUpdateFunction(res['HEADER'], res['DATA'],
								"raiseSuspicionTransactionsTable${ALERTNO}", "Raise Suspicion Transactions");
					},
					error: function(a,b,c) {
						alert(a+b+c);
					}
				});
			}
		});
		
		$("#deleteAccountRSPTransactions"+id).click(function(){
			var accountNo = $("#accountNo"+id).val();
			var action = "DELETE";
			var transactionNo = "";
			var count = 0;
			$(".raiseSuspicionTransactionsTable"+id).children("tbody").find("tr").each(function(){
				if($(this).children("td").children("input").prop("checked")){
					transactionNo += $(this).children("td:nth-child(3)").html().trim()+"~~~";
					count++;
				}
			});
			if(count == 0){
				alert("Select a record");
			}else {
				$.ajax({
					url: "${pageContext.request.contextPath}/common/updateAccountRSPTransactions",
					cache: false,
					type: "POST",
					data: "alertNo="+id+"&accountNo="+accountNo+"&transactionNo="+transactionNo+
						"&action="+action,
					success: function(res) {
						//VIVEK - updating raise suspicion table
						transactionsTableUpdateFunction(res['HEADER'], res['DATA'],
								"raiseSuspicionTransactionsTable${ALERTNO}", "Raise Suspicion Transactions");
					},
					error: function(a,b,c) {
						alert(a+b+c);
					}
				});
			}
		});
		
		/* VIVEK - 09.12.2020 */
		function transactionsTableUpdateFunction(header, data, unqTable, tableName){
			var HEADER = header;
			var DATA = data;
			//console.log("VIVEK - HEADER = "+HEADER);
			//console.log("VIVEK - DATA = "+DATA);
			var transactionsTableConstruction = "";
			//----------------------------------------
			transactionsTableConstruction += "<thead>";
			transactionsTableConstruction += 	"<tr>";
			transactionsTableConstruction += 		"<th class='info no-sort' style='text-align: center;'>";
			transactionsTableConstruction += 			"<input type='checkbox' class='checkbox-check-all' compassTable='"+unqTable+"' id='"+unqTable+"'>";
			transactionsTableConstruction += 		"</th>";
			HEADER.forEach(function(eachHeader) {
				transactionsTableConstruction +=	"<th class='info' id='"+eachHeader+"'><spring:message code='"+eachHeader+"'/></th>";
			});
			transactionsTableConstruction += 	"</tr>";
			transactionsTableConstruction += "</thead>";
			//----------------------------------------
			transactionsTableConstruction += "<tbody>";
			DATA.forEach(function(eachData) {
				transactionsTableConstruction += "<tr>";
				transactionsTableConstruction += 	"<td class='no-sort' style='text-align: center;'>";
				transactionsTableConstruction += 		"<input type='checkbox'/>";
				transactionsTableConstruction += 	"</td>";
				eachData.forEach(function(value) {
					if(value != "" && value != " "){
						transactionsTableConstruction += 	"<td data-toggle='tooltip' data-placement='auto'  title='"+value+"' data-container='body'>"+value+"</td>";
					}else{
						transactionsTableConstruction += 	"<td>"+value+"</td>";
					}
				});
			});
			transactionsTableConstruction += "</tbody>";
			//----------------------------------------
			$("."+unqTable).html(transactionsTableConstruction);
			
			$('.'+unqTable).DataTable().destroy();
			compassDatatable.construct(unqTable, tableName, true);
		}
		
		$("#closeAccountRSPTransactionsModal"+id).click(function(){
			$("#compassMediumGenericModal").modal("hide");
		});
		
		
});
</script>
<div class="row compassrowAccountRSPTransactions${ALERTNO}">
	<div class="col-sm-12">
		<div class="card card-primary panelAccountRSPTransactions">
			<div class="card-header panelSlidingAccountTransactions${ALERTNO} clearfix">
				<h6 class="card-title pull-${dirL}">Account Transactions</h6>
				<div class="btn-group pull-${dirR} clearfix">
					<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
				</div>
			</div>
			<div class="panelSearchForm">
				<form action="javascript:void(0)" method="POST" id="accountRSPTransactionsForm${ALERTNO}">
					<div class="card-search-card" >
						<table class="table table-striped accountRSPTransactionsTable${ALERTNO}" style="margin-bottom: 0px;">
							<tr>
								<td width="15%">From Date</td>
								<td width="30%">
									<input type="text" class="form-control input-sm datepicker" name="fromDate" id="FROMDATE_${ALERTNO}"/>
								</td> 
								<td width="10%">&nbsp;</td>
								<td width="15%">To Date</td>
								<td width="30%">
									<input type="text" class="form-control input-sm datepicker" name="toDate" id="TODATE_${ALERTNO}"/>
								</td>
							</tr>
							<tr>
								<td width="15%">Account No</td>
								<td width="30%">
									<input type="text" class="form-control input-sm" name="accountNo" id="accountNo${ALERTNO}" value="${ACCOUNTNO}"/>
								</td> 
								<td colspan="3">&nbsp;</td>
							</tr>
						</table>
					</div>
					<div class="card-footer clearfix">
						<div class="pull-${dirR}">
							<button type="button" id="searchAccountRSPTransactions${ALERTNO}" class="btn btn-primary btn-sm">Search</button>
						</div>
					</div>
				</form>
			</div>
		</div>
		<div class="card card-primary" id="accountTransactionsDiv${ALERTNO}" style="display: none;">
			<div class="card-header panelSlidingAccountTransactions${ALERTNO} clearfix">
				<h6 class="card-title pull-${dirL}">Account Transactions Result</h6>
				<div class="btn-group pull-${dirR} clearfix">
					<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
				</div>
			</div>
			<table class="table table-bordered table-striped accountTransactionsTable${ALERTNO} ${MODULETYPE}${UNQID}" >
			</table>
			<div class="card-footer clearfix">
				<div class="pull-${dirR}">
					<button type="button" id="addAccountRSPTransactions${ALERTNO}" class="btn btn-success btn-sm">Add</button>
				</div>
			</div>
		</div>
		<div class="card card-primary raiseSuspicionTransactionsPanel">
			<div class="card-header panelRaiseSuspicionTransactions${ALERTNO} clearfix">
				<h6 class="card-title pull-${dirL}">Raise Suspicion Transactions</h6>
			</div>
			<table class="table table-bordered table-striped raiseSuspicionTransactionsTable${ALERTNO} ${MODULETYPE}${UNQID}" >
				<thead>
					<tr>
						<th class="info no-sort" style="text-align: center;">
							<input type="checkbox" class="checkbox-check-all" 
								compassTable="raiseSuspicionTransactionsTable${ALERTNO}" id="raiseSuspicionTransactionsTable${ALERTNO}">
						</th>
						<c:forEach var="TH" items="${ALERTTXNMAPPINGS['HEADER']}">
							<c:set var="colArray" value="${f:split(TH, '.')}" />
							<c:set var="colArrayCnt" value="${f:length(colArray)}" />
							<th class="info" id="${colArray[colArrayCnt-1]}"><spring:message code="${TH}"/></th>
						</c:forEach>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="RECORD" items="${ALERTTXNMAPPINGS['DATA']}">
						<tr>
							<td class="no-sort" style="text-align: center;">
								<input type="checkbox"/>	
							</td>
							<c:forEach var="TD" items="${RECORD}">
								<c:choose>
									<c:when test="${TD ne ' ' and TD ne ''}">
										<td data-toggle="tooltip" data-placement="auto"  title="${TD}" data-container="body">${TD}</td>
									</c:when>
									<c:otherwise>
										<td>${TD}</td>
									</c:otherwise>
								</c:choose>
							</c:forEach>
						</tr>
					</c:forEach>
				</tbody>
			</table>
			<div class="card-footer clearfix">
				<div class="pull-${dirR}">
					<button type="button" id="deleteAccountRSPTransactions${ALERTNO}" class="btn btn-danger btn-sm">Delete</button>
					<button type="button" id="closeAccountRSPTransactionsModal${ALERTNO}" class="btn btn-danger btn-sm">Close</button>
				</div>
			</div>
		</div>
	</div>
</div>
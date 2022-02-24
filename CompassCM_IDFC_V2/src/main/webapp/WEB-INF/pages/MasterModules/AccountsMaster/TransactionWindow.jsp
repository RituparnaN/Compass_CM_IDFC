<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../../tags/tags.jsp"%>
<link rel="StyleSheet" type="text/css"	href="${pageContext.request.contextPath}/includes/styles/bootstrap.min.css" />
<link rel="StyleSheet" type="text/css"	href="${pageContext.request.contextPath}/includes/styles/font-awesome.min.css" />
<link rel="StyleSheet" type="text/css"	href="${pageContext.request.contextPath}/includes/styles/jquery-ui.min.css" />
<link rel="StyleSheet" type="text/css"	href="${pageContext.request.contextPath}/includes/styles/select2.min.css" />
<link rel="StyleSheet" type="text/css"	href="${pageContext.request.contextPath}/includes/styles/template/default.css" />

<script type="text/javascript" src="${pageContext.request.contextPath}/includes/scripts/jquery.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/includes/scripts/jquery-ui.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/includes/scripts/bootstrap.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/includes/scripts/select2.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/includes/scripts/CompassTopFrame.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/includes/scripts/CompassDatatable.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/includes/scripts/jquery.dataTables.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/includes/scripts/master-module-hyperlinks.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/includes/scripts/dataTables.bootstrap.js"></script>

<script type="text/javascript">

	$(document).ready(function() {
		
		$(".datepicker").datepicker({
			 dateFormat : "dd/mm/yy",
			 changeMonth: true,
		     changeYear: true
		 });
		
		var title = $(document).attr("title");
		var titleSplitted = title.split(": ");
		var AccountNo = "${ACCOUNTNO}";
		$("#ACCOUNTNUMBER").val(AccountNo);
		
		var id = '${UNQID}';
		compassTopFrame.init(id, 'transactionDetailsTable', 'dd/mm/yy');
		
		$(".panelSlidingTransactionDetails"+id).on("click", function(e){
			var mainRow = $(this).parents(".compassrow"+id);
			compassTopFrame.searchPanelSliding(id, mainRow, 'transactionDetailsSerachResultPanel');
		});
		//{1_FROMDATE:1_FROMDATE,2_TODATE:2_TODATE,3_ACCOUNTNUMBER:3_ACCOUNTNUMBER,moduleType:"transactionDetailsMasterNew",bottomPageUrl:"InvestigationTools/TransactionDetails/SearchBottomPage"},
		$("#searchNewData"+id).click(function(){
			var submitButton = "searchNewData"+id;
			$.ajax({
				url :  "${pageContext.request.contextPath}/common/searchGenericMaster?${_csrf.parameterName}=${_csrf.token}",
				cache : false,
				type : 'POST',
				data :$("#searchMasterForm"+id).serialize()+"&submitButton="+submitButton,
				success : function(response){
					$("#transactionDetailsSerachResultPanel"+id).show();
					$("#transactionDetailsSerachResultPanel"+id).css("margin","15px");
					$("#transactionDetailsSerachResult"+id).html(response);
					$("#transactionDetailsSerachResultPanel"+id).find(".compassDataTable").css("overflow-x","auto");
				},
				error : function(a,b,c){
					alert("Something went wrong"+a+b+c);
				}
			});
		})
		
	});
		
</script>

<style>
	.datepicker{
		background-image:url("${pageContext.request.contextPath}/includes/images/calendar.png");
		background-repeat:no-repeat;
		background-position: 98%;
	}
	
</style>

<div class="row compassrow${UNQID}">
	<div class="col-sm-12">
		<div class="card card-primary panel_transactionDetails" style="margin:15px;">
			<div class="card-header panelSlidingTransactionDetails${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}"><spring:message code="app.common.transactionDetailsHeader"/></h6>
				<div class="btn-group pull-${dirR} clearfix">
					<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
				</div>
			</div>
			<div class="panelSearchForm">
			<form action="javascript:void(0)" method="POST" id="searchMasterForm${UNQID}">
			<input type="hidden" name="moduleType" value="transactionDetailsMasterNew">
			<input type="hidden" name="bottomPageUrl" value="InvestigationTools/TransactionDetails/SearchBottomPage">
			<div class="card-search-card" >
				<table class="table table-striped formSearchTable transactionDetailsTable" style="margin-bottom: 0px;">
					<tbody>
						<tr>
							<td colspan='1'>
								FROM DATE:
							</td>
							<td colspan='1'>
								<input type="text" style="width:95%;" class="form-control datepicker" id="FROMDATE" name="1_FROMDATE" />
							</td>
							<td colspan='1'>
								TO DATE:
							</td>
							<td colspan='1'>
								<input type="text" style="width:95%;" class="form-control datepicker" id="TODATE" name="2_TODATE" />
							</td>
						</tr>
						<tr>
							<td colspan='1'>
								ACCOUNT NO:
							</td>
							<td colspan='1'>
								<input type="text" style="width:95%;" class="form-control input-sm" id="ACCOUNTNUMBER" name="3_ACCOUNTNUMBER" />
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			<div class="card-footer clearfix">
				<div class="pull-${dirR}">
					<button type="submit" id="searchNewData${UNQID}" class="btn btn-success btn-sm"><spring:message code="app.common.searchButton"/></button>
					<%-- <button type="button" id="viewAccountStatement${UNQID}" class="btn btn-primary btn-sm"><spring:message code="app.common.viewAccountStatement"/></button> --%>
				</div>
			</div>
			</form>
			</div>
		</div>
		<div class="card card-primary" id="transactionDetailsSerachResultPanel${UNQID}" style="display: none;">
			<div class="card-header panelSlidingTransactionDetails${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}"><spring:message code="app.common.transactionDetailsResultHeader"/></h6>
				<div class="btn-group pull-${dirR} clearfix">
					<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
				</div>
			</div>
			<div id="transactionDetailsSerachResult${UNQID}"></div>
		</div>
	</div>
</div>

<div class="modal fade bs-example-modal-lg" id="compassGenericModal" tabindex="1" role="dialog" aria-labelledby="myLargeModalLabel">
	<div class="modal-dialog modal-lg">
		<div class="modal-content card-primary">
			<div class="modal-header card-header" style="cursor: move;">
				<div class="modal-button">
					<button type="button" class="close" data-dismiss="modal" aria-label="Close" title="Close">
						<span aria-hidden="true" class="fa fa-remove"></span>
					</button>
					<button type="button" class="close"  title="Open in new Window" id="openModalInWindow">
						<span aria-hidden="true" class="fa fa-external-link"></span>
					</button>
					<button type="button" class="close" title="Open in Tab" id="openModalInTab">
						<span aria-hidden="true" class="fa fa-plus"></span>
					</button>
				</div>
				<h4 class="modal-title" id="compassGenericModal-title">...</h4>					
			</div>
			<div class="modal-body" id="compassGenericModal-body">
			<br/>
				<center>
					<img alt="Loading..." src="${pageContext.request.contextPath}/includes/images/qde-loadder.gif">
				</center>
			<br/>
			</div>
		</div>
	</div>
</div>




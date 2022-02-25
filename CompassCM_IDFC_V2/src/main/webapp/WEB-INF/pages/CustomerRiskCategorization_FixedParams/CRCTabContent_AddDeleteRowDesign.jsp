<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../tags/tags.jsp"%>

<script type="text/javascript">
	$(document).ready(function() {
		var id = '${UNQID}';
		compassTopFrame.init(id, 'compassRiskAssignmentSearchTable'+id, 'dd/mm/yy');

		$(".selectpicker").selectpicker();
		
		$('.panelSlidingStaticCRC'+id).on("click", function (e) {
			var mainRow = $(this).parents(".compassrow"+id);
			compassTopFrame.searchPanelSliding(id, mainRow, 'staticRiskSerachResultPanel');
	    });
		
		var riskParam = "";
		
		$("input:radio[name = staticCRCCustomerType]").change(function(){
			var checked = $(this).filter(':checked');
			
			//alert(checked.val());
			if(checked.val() == 'I'){
				$('.individualParams').show();
				$('.nonIndividualParams').hide();
				$('.solePropParams').hide();
			}
			else if(checked.val() == 'N'){
				$('.nonIndividualParams').show();
				$('.individualParams').hide();
				$('.solePropParams').hide();
			}
			else if(checked.val() == 'S'){
				$('.solePropParams').show();
				$('.individualParams').hide();
				$('.nonIndividualParams').hide();
			}
		});
		
		$("#searchStaticCRCParamAssignment"+id).click(function(){
			var mainRow = $(this).parents("div.compassrow"+id);
			var slidingDiv = $(mainRow).children().children().children();
			var panelBody = $(mainRow).children().children().find(".panelSearchForm");
	
			var checkedCustomerType = $("input:radio[name = staticCRCCustomerType]").filter(":checked");
			var customerType = checkedCustomerType.val();
			
			
			if(checkedCustomerType.val() == 'I'){
				riskParam = $("#indivRiskParameter"+id).val();
			}
			else if(checkedCustomerType.val() == 'N'){
				riskParam = $("#nonIndivRiskParameter"+id).val();
			}
			else if(checkedCustomerType.val() == 'S'){
				riskParam = $("#solePropRiskParameter"+id).val();
			}
			
			/* alert(customerType);
			alert(riskParam); */
			
			var fullData = "customerType="+customerType+"&riskParam="+riskParam+"&id="+id;
			$.ajax({
				url: "${pageContext.request.contextPath}/admin/searchStaticCRCParamAssignment",
				cache: false,
				type: "POST",
				data: fullData,
				success: function(res){
					$("#staticRiskSerachResultPanel"+id).css("display", "block");
					$("#staticCRCRiskAssignmentSerachResult"+id).html(res);
					$(panelBody).slideUp();
					$(slidingDiv).addClass('card-collapsed');
					$(slidingDiv).find('i.collapsable').removeClass('fa-chevron-up').addClass('fa-chevron-down');
					$(mainRow).next().find(".compassrow"+id).find(".card-header").next().slideDown();					
				},
				error: function(a,b,c){
					alert(a+b+c);
				}
			});
			
		});
		
		$("#updateStaticRiskAssignmentValue"+id).click(function(){
			var table = $("#staticCRCRiskAssignmentSerachResult"+id).find("table");
			var fullData = "";
			$(table).children("tbody").children("tr").each(function(){
				var staticParamCode = $(this).children("td:first-child").html();
				var staticParamRiskValue = $(this).children("td:nth-child(3)").children("select").val();
				fullData = fullData + staticParamCode+"="+ staticParamRiskValue+",";
			});
			//alert(fullData);
			$.ajax({
				url: "${pageContext.request.contextPath}/admin/updateStaticRiskAssignmentValue",
				cache: false,
				type: "POST",
				data: "fullData="+fullData+"&riskParam="+riskParam,
				success: function(res){
					alert(res);
					$("#searchStaticCRCParamAssignment"+id).click();
				},
				error: function(a,b,c){
					alert(a+b+c);
				}
			});
		});
	
		$("input:radio[name = dynamicCRCCustomerType]").change(function(){
			var checked = $(this).filter(':checked');
			
			//alert(checked.val());
			if(checked.val() == 'I'){
				$('.turnoverSurgeRule').hide();
			}
			else if(checked.val() == 'N'){
				$('.turnoverSurgeRule').show();
			}
			else if(checked.val() == 'S'){
				$('.turnoverSurgeRule').show();
			}
		});
		
		
		var rowIndex1 = 0;
		$(".addFilingRegReport").click(function(){
			rowIndex1++;
			$("#filingRegulatoryReportTable").append('<tr valign="top"><td width="75%">&nbsp;<select class="" id="reportName'+rowIndex1+'" name="reportName[]"><option>Select a report</option><option value="STR">STR</option><option value="CTR">CTR</option><option value="NTR">NTR</option><option value="CBWTR">CBWTR</option></select> &nbsp; <input type="text" id="reportValue'+rowIndex1+'" name="reportValue[]" placeholder="Input Value" /> &nbsp; <button class="btn deleteIconBtn"><i class="fa fa-times"></i></button></td><td width="5%">&nbsp;</td><td align="center" width="20%"><select class="form-control input-sm" style="width: 40%;" id="regulatoryReportRiskValue"><option value="1">1-LOW</option><option value="2">2-MEDIUM</option><option value="3">3-HIGH</option></select></td></tr>');
			$("#filingRegulatoryReportTable").on('click','.deleteIconBtn',function(){
		        $(this).parent().parent().remove();
		    });
		});
		
		var rowIndex2 = 0;
		$(".addChangingAccStatus").click(function(){
			rowIndex2++;
			$("#changingAccStatusTable").append('<tr valign="top"><td width="75%">&nbsp;<select class="" id="accountStatusFrom" name="accountStatusFrom[]" ><option>Select account status</option><option value="Dormant">Dormant</option><option value="Inactive">Inactive</option><select/> &nbsp; <input type="text" class="" id="accountStatusTo" name="accountStatusTo[]" value="Active" /> &nbsp; <button class="btn deleteIconBtn"><i class="fa fa-times"></i></button></td><td width="5%">&nbsp;</td><td align="center" width="20%"><select class="form-control input-sm" style="width: 40%;" id="accountStatusChangeRisk"><option value="1">1-LOW</option><option value="2">2-MEDIUM</option><option value="3">3-HIGH</option></select></td></tr>');
			$("#changingAccStatusTable").on('click','.deleteIconBtn',function(){
		        $(this).parent().parent().remove();
		    });
		});
		
		var rowIndex3 = 0;
		$(".addPostAccStatusChange").click(function(){
			rowIndex3++;
			$("#postAccountStatusChangeTable").append('<tr valign="top"><td width="75%">&nbsp;<select class="" id="postAccountStatusFrom" name="postAccountStatusFrom[]" ><option>Select account status</option><option value="Blocked">Blocked</option><option value="Freezed">Freezed</option><select/> &nbsp; <input type="text" class="" id="postAccountStatusTo" name="postAccountStatusTo[]" value="Active" /> &nbsp; <button class="btn deleteIconBtn"><i class="fa fa-times"></i></button></td><td width="5%">&nbsp;</td><td align="center" width="20%"><select class="form-control input-sm" style="width: 40%;" id="accountStatusChangeRisk"><option value="1">1-LOW</option><option value="2">2-MEDIUM</option><option value="3">3-HIGH</option></select></td></tr>');
			$("#postAccountStatusChangeTable").on('click','.deleteIconBtn',function(){
		        $(this).parent().parent().remove();
		    });
		});
		
		var rowIndex4 = 0;
		$(".addTxnsWithHighRiskCustomer").click(function(){
			rowIndex4++;
			$("#transactionsWithHighRiskCustTable").append('<tr valign="top"><td width="75%">&nbsp;<select class="" id="valueOrVolume" name="valueOrVolume[]" ><option>Select Value Or Volume</option><option value="Value">Value</option><option value="Volume">Volume</option><select/> &nbsp; <input type="text" class="" id="percentageTxnWithHighRiskCust" name="percentageTxnWithHighRiskCust[]" value="" placeholder="Percentage"/>% &nbsp; <button class="btn deleteIconBtn"><i class="fa fa-times"></i></button></td><td width="5%">&nbsp;</td><td align="center" width="20%"><select class="form-control input-sm" style="width: 40%;" id="highRiskCustTxnRisk"><option value="1">1-LOW</option><option value="2">2-MEDIUM</option><option value="3">3-HIGH</option></select></td></tr>');
			$("#transactionsWithHighRiskCustTable").on('click','.deleteIconBtn',function(){
		        $(this).parent().parent().remove();
		    });
		});
		
		var rowIndex5 = 0;
		$(".addAlertCounts").click(function(){
			rowIndex5++;
			$("#countOfAlertsGeneratedTable").append('<tr valign="top"><td width="75%">&nbsp;Range - From <input type="text" class="" id="alertCountRangeFrom" name="alertCountRangeFrom[]" /> &nbsp; To &nbsp;<input type="text" class="" id="alertCountRangeTo" name="alertCountRangeTo[]" /> &nbsp;<button class="btn deleteIconBtn"><i class="fa fa-times"></i></button></td><td width="5%">&nbsp;</td><td align="center" width="20%"><select class="form-control input-sm" style="width: 40%;" id="alertCountRisk"><option value="1">1-LOW</option><option value="2">2-MEDIUM</option><option value="3">3-HIGH</option></select></td></tr>');
			$("#countOfAlertsGeneratedTable").on('click','.deleteIconBtn',function(){
		        $(this).parent().parent().remove();
		    });
		}); 
		
		var rowIndex6 = 0;
		$(".addTurnoverInAccount").click(function(){
			rowIndex6++;
			$("#turnoverInAccountTable").append('<tr valign="top"><td width="75%">&nbsp;Range - From <input type="text" class="" id="turnoverSurgeRangeFrom" name="turnoverSurgeRangeFrom[]" /> &nbsp; To &nbsp;<input type="text" class="" id="turnoverSurgeRangeTo" name="turnoverSurgeRangeTo[]" /> &nbsp;<button class="btn deleteIconBtn"><i class="fa fa-times"></i></button></td><td width="5%">&nbsp;</td><td align="center" width="20%"><select class="form-control input-sm" style="width: 40%;" id="turnoverSurgeRisk"><option value="1">1-LOW</option><option value="2">2-MEDIUM</option><option value="3">3-HIGH</option></select></td></tr>');
			$("#turnoverInAccountTable").on('click','.deleteIconBtn',function(){
		        $(this).parent().parent().remove();
		    });
		}); 
		
});
</script>
<style>
	.rulesAndRiskHeader{
		text-align: center;
		font-weight: bold;
	}
	.addIconBtn{
		color: #33CC33;
		background-color: transparent;
		padding: 0;
		margin-left: 10px;
	}
	.addIconBtn:hover{
		color: #33CC33;
		background-color: transparent;
		padding: 0;
		margin-left: 10px;
	}
	.deleteIconBtn{
		color: red;
		background-color: transparent;
		padding: 0;
		margin-left: 10px;
	}
	.deleteIconBtn:hover{
		color: red;
		background-color: transparent;
		padding: 0;
		margin-left: 10px;
	}
</style>
<div role="tabpanel" class="tab-pane active" id="staticCRC" >
	<div class="row compassrow${UNQID}">
	    <div class="col-sm-12">
		<div class="card card-primary panel_staticCRCFrame" style="margin-bottom: 0px; margin-top: 5px;">
			<div class="card-header panelSlidingStaticCRC${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}"><spring:message code="app.common.staticCRC"/></h6>
				<div class="btn-group pull-${dirR} clearfix">
					<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
				</div>
			</div>
			 <div class="panelSearchForm">
				<table class="table table-striped compassStaticCRCSearchTable" style="margin-bottom: 0px;">
					<tr>
						<td width="10%" style="padding-top: 15px;">Customer Type</td>
						<td width="5%">&nbsp;</td>
						<td width="85%">
							<table style="width:100%">
								<tr>
									<td width="25%">
										<label class="btn btn-default btn-sm" for="customerTypeIndiv">
											<input type="radio" name="staticCRCCustomerType" id="customerTypeIndiv${UNQID}" value="I" checked="checked">
											Individual
										</label>
									</td>
									<td width="5%">&nbsp;</td>
									<td width="25%">
										<label class="btn btn-default btn-sm" for="customerTypeNonIndiv">
											<input type="radio" name="staticCRCCustomerType" id="customerTypeNonIndiv${UNQID}" value="N">
											Non-Individual
										</label>
									</td>
									<td width="5%">&nbsp;</td>
									<td width="25%">
										<label class="btn btn-default btn-sm" for="customerTypeSoleProp">
											<input type="radio" name="staticCRCCustomerType" id="customerTypeSoleProp${UNQID}" value="S">
											Sole Proprietor
										</label>
									</td>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td width="10%">Risk Parameters</td>
						<td width="5%">&nbsp;</td>
						<td width="85%" class="individualParams" >
							<select class="form-control input-sm " id="indivRiskParameter${UNQID}" name="indivRiskParameter">
								<option value="I1">Product</option>
								<option value="I2">Constitution</option>
								<option value="I3">Occupation</option>
								<option value="I4">Country</option>
								<option value="I5">PEP customer</option>
								<option value="I6">PAN availability</option>
							</select>
						</td>
						<td width="85%" class="nonIndividualParams" style="display: none;">
							<select class="form-control input-sm " id="nonIndivRiskParameter${UNQID}" name="nonIndivRiskParameter" >
								<option value="N1">Product</option>
								<option value="N2">Constitution</option>
								<option value="N3">Industry</option>
								<option value="N4">Country</option>
								<option value="N5">Line of Business</option>
								<option value="N6">PAN availability</option>
							</select>
						</td>
						<td width="85%" class="solePropParams" style="display: none;">
							<select class="form-control input-sm " id="solePropRiskParameter${UNQID}" name="solePropRiskParameter" >
								<option value="S1">Product</option>
								<option value="S2">Constitution</option>
								<option value="S3">Industry</option>
								<option value="S4">Country</option>
								<option value="S5">Line of Business</option>
								<option value="S6">PAN availability</option>
							</select>
						</td>
					</tr>
				</table>
				<div class="card-footer clearfix">
						<div class="pull-${dirR}">
							<input type="button" id="searchStaticCRCParamAssignment${UNQID}" class="btn btn-primary btn-sm" name="Search" value="Search"/>
						</div>
				</div>
			</div>
	   </div>
	   </div>
	   <div class="col-sm-12">
			<div class="card card-primary" id="staticRiskSerachResultPanel${UNQID}" style="margin-top: 10px; margin-bottom: 0px; display: none;">
				<div class="card-header panelSlidingRiskAssignment${UNQID} clearfix">
					<h6 class="card-title pull-${dirL}">Update Risk Value</h6>
				<div class="btn-group pull-${dirR} clearfix">
					<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
				</div>
				</div>
				<div id="staticCRCRiskAssignmentSerachResult${UNQID}"></div>
				<div class="card-footer clearfix">
					<div class="pull-${dirR}">
						<button type="button" class="btn btn-success btn-sm" id="updateStaticRiskAssignmentValue${UNQID}" name="Update">Update</button>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>

<div role="tabpanel" class="tab-pane" id="dynamicCRC" >
	<div class="row compassrow${UNQID}">
	    <div class="col-sm-12">
		<div class="card card-primary panel_dynamicCRCFrame" style="margin-bottom: 0px; margin-top: 5px;">
			<div class="card-header panelSlidingDynamicCRC${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}"><spring:message code="app.common.dynamicCRC"/></h6>
				<div class="btn-group pull-${dirR} clearfix">
					<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
				</div>
			</div>
			 <div class="panelSearchForm">
				<table class="table table-striped compassDynamicCRCSearchTable" style="margin-bottom: 0px;">
					<tr>
						<td width="20%">From Date</td>
						<td width="25%">
							<input type="text" class="form-control input-sm datepicker" name="fromDate" id="fromDate${UNQID}">
						</td>
						<td width="10%">&nbsp;</td>
						<td width="20%">To Date</td>
						<td width="25%">
							<input type="text" class="form-control input-sm datepicker" name="toDate" id="toDate${UNQID}">
						</td>
					</tr>
					<tr>
						<td width="20%" style="padding-top: 15px;">Customer Type</td>
						<td colspan="4">
							<table style="width:100%">
								<tr>
									<td width="25%">
										<label class="btn btn-default btn-sm" for="customerTypeIndiv">
											<input type="radio" name="dynamicCRCCustomerType" id="customerTypeIndiv${UNQID}" value="I" checked="checked">
											Individual
										</label>
									</td>
									<td width="5%">&nbsp;</td>
									<td width="25%">
										<label class="btn btn-default btn-sm" for="customerTypeNonIndiv">
											<input type="radio" name="dynamicCRCCustomerType" id="customerTypeNonIndiv${UNQID}" value="N">
											Non-Individual
										</label>
									</td>
									<td width="5%">&nbsp;</td>
									<td width="25%">
										<label class="btn btn-default btn-sm" for="customerTypeSoleProp">
											<input type="radio" name="dynamicCRCCustomerType" id="customerTypeSoleProp${UNQID}" value="S">
											Sole Proprietor
										</label>
									</td>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td colspan = "5" style="background-color: #D9EDF7;">
							<table style="width:100%">
								<tr>
									<td width="75%" style="font-weight: 800;">Rules</td>
									<td width="5%">&nbsp;</td>
									<td width="20%" class="rulesAndRiskHeader">Risk Value</td>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td colspan = "5"">
							<table style="width:100%" id="filingRegulatoryReportTable">
								<tr>
									<td width="75%" style="font-weight: 600;">
									Filing of Regulatory report
									<button class="btn addIconBtn addFilingRegReport"><i class="fa fa-plus"></i></button>
									</td>
									<td width="5%">&nbsp;</td>
									<td width="20%" align="center">&nbsp;
										<!-- <select class="form-control input-sm" style="width: 40%;" id="">
											<option value="1">1-LOW</option>
											<option value="2">2-MEDIUM</option>
											<option value="3">3-HIGH</option>
										</select> -->
									</td>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td colspan = "5"">
							<table style="width:100%" id="changingAccStatusTable">
								<tr>
									<td width="75%" style="font-weight: 600;">
									Changing of Account Status
									<button class="btn addIconBtn addChangingAccStatus"><i class="fa fa-plus"></i></button>
									</td>
									<td width="5%">&nbsp;</td>
									<td width="20%" align="center">&nbsp;
										<!-- <select class="form-control input-sm" style="width: 40%;" id="">
											<option value="1">1-LOW</option>
											<option value="2">2-MEDIUM</option>
											<option value="3">3-HIGH</option>
										</select> -->
									</td>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td colspan = "5"">
							<table style="width:100%" id="postAccountStatusChangeTable">
								<tr>
									<td width="75%" style="font-weight: 600;">
									Post Account Status Change
									<button class="btn addIconBtn addPostAccStatusChange"><i class="fa fa-plus"></i></button>
									</td>
									<td width="5%">&nbsp;</td>
									<td width="20%" align="center">&nbsp;
										<!-- <select class="form-control input-sm" style="width: 40%;" id="">
											<option value="1">1-LOW</option>
											<option value="2">2-MEDIUM</option>
											<option value="3">3-HIGH</option>
										</select> -->
									</td>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td colspan = "5"">
							<table style="width:100%" id="transactionsWithHighRiskCustTable">
								<tr>
									<td width="75%" style="font-weight: 600;">
									Transactions with High risk customer
									<button class="btn addIconBtn addTxnsWithHighRiskCustomer"><i class="fa fa-plus"></i></button>
									</td>
									<td width="5%">&nbsp;</td>
									<td width="20%" align="center">&nbsp;
										<!-- <select class="form-control input-sm" style="width: 40%;" id="">
											<option value="1">1-LOW</option>
											<option value="2">2-MEDIUM</option>
											<option value="3">3-HIGH</option>
										</select> -->
									</td>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td colspan = "5"">
							<!-- <table class="form-inline" style="width:100%"> -->
							<table style="width:100%" id="countOfAlertsGeneratedTable">
								<tr>
									<td width="75%" style="font-weight: 600;">
									Count of Alerts Generated 
									<%-- <input type="text" class="form-control form-control-sm input-sm" id="alertCount${UNQID}" name="alertCount" style="width: 5%; font-weight: normal;"> --%>
									<button class="btn addIconBtn addAlertCounts"><i class="fa fa-plus"></i></button>
									</td>
									<td width="5%">&nbsp;</td>
									<td width="20%" align="center">&nbsp;
										<%-- <select class="form-control input-sm" style="width: 40%;" id="alertCountRisk${UNQID}" name="alertCountRisk">
											<option value="1">1-LOW</option>
											<option value="2">2-MEDIUM</option>
											<option value="3">3-HIGH</option>
										</select>  --%>
									</td>
								</tr>
							</table>
						</td>
					</tr>
					<tr class="turnoverSurgeRule" style="display: none;">
						<td colspan = "5"">
							<table style="width:100%" id="turnoverInAccountTable">
								<tr>
									<td width="75%" style="font-weight: 600;">
									Turnover Surge in the account
									<button class="btn addIconBtn addTurnoverInAccount"><i class="fa fa-plus"></i></button>
									</td>
									<td width="5%">&nbsp;</td>
									<td width="20%" align="center">&nbsp;
										<!-- <select class="form-control input-sm" style="width: 40%;" id="">
											<option value="1">1-LOW</option>
											<option value="2">2-MEDIUM</option>
											<option value="3">3-HIGH</option>
										</select> -->
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
				<div class="card-footer clearfix">
					<div class="pull-${dirR}">
						<input type="button" id="searchDynamicCRCParamAssignment${UNQID}" class="btn btn-primary btn-sm" name="Search" value="Search"/>
					</div>
				</div>
			</div>
	   </div>
	   </div>
	   <div class="col-sm-12">
			<div class="card card-primary" id="dynamicRiskSerachResultPanel${UNQID}" style="margin-top: 10px; margin-bottom: 0px; display: none;">
				<div class="card-header panelSlidingRiskAssignment${UNQID} clearfix">
					<h6 class="card-title pull-${dirL}">Update Risk Value</h6>
				<div class="btn-group pull-${dirR} clearfix">
					<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
				</div>
				</div>
				<div id="dynamicCRCRiskAssignmentSerachResult${UNQID}"></div>
				<div class="card-footer clearfix">
					<div class="pull-${dirR}">
						<button type="button" class="btn btn-success btn-sm" id="updateDynamicRiskAssignmentValue${UNQID}" name="Update">Update</button>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
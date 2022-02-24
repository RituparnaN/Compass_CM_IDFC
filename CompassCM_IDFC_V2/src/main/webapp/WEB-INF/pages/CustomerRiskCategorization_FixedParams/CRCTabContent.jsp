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
		
		$("input:radio[name = dynamicCRCCustomerType]").change(function(){
			var checked = $(this).filter(':checked');
			
			//alert(checked.val());
			if(checked.val() == 'I'){
				$('.dynamicIndividualParams').show();
				$('.dynamicNonIndividualParams').hide();
				$('.dynamicSolePropParams').hide();
			}
			else if(checked.val() == 'N'){
				$('.dynamicNonIndividualParams').show();
				$('.dynamicIndividualParams').hide();
				$('.dynamicSolePropParams').hide();
			}
			else if(checked.val() == 'S'){
				$('.dynamicSolePropParams').show();
				$('.dynamicIndividualParams').hide();
				$('.dynamicNonIndividualParams').hide();
			}
		});
		
		$("#searchDynamicCRCParamAssignment"+id).click(function(){
			var mainRow = $(this).parents("div.compassrow"+id);
			var slidingDiv = $(mainRow).children().children().children();
			var panelBody = $(mainRow).children().children().find(".panelSearchForm");
			var dynamicCheckedCustomerType = $("input:radio[name = dynamicCRCCustomerType]").filter(":checked");
			var dynamicCustomerType = dynamicCheckedCustomerType.val();
			
			
			if(dynamicCheckedCustomerType.val() == 'I'){
				dynamicRiskParam = $("#dynamicIndivRiskParameter"+id).val();
			}
			else if(dynamicCheckedCustomerType.val() == 'N'){
				dynamicRiskParam = $("#dynamicNonIndivRiskParameter"+id).val();
			}
			else if(dynamicCheckedCustomerType.val() == 'S'){
				dynamicRiskParam = $("#dynamicSolePropRiskParameter"+id).val();
			}
			//var isRangeRequired = $("#parameterId"+id).find("option[value='"+searchParamId+"']").attr("isRangeRequired");
			$.ajax({
				url: "${pageContext.request.contextPath}/admin/searchRiskAssignment",
				cache: false,
				type: "POST",
				data: "dynamicRiskParam="+dynamicRiskParam+"&id="+id+"&dynamicCustomerType="+dynamicCustomerType,
				success: function(res){
					$("#riskAssignmentSerachResultPanel"+id).css("display", "block");
					$("#riskAssignmentSerachResult"+id).html(res);
					$(panelBody).slideUp();
					$(slidingDiv).addClass('card-collapsed');
					$(slidingDiv).find('i.collapsable').removeClass('fa-chevron-up').addClass('fa-chevron-down');
					$(mainRow).next().find(".compassrow"+id).find(".card-header").next().slideDown();
					
					if(isRangeRequired == "Y"){
						$("#addRiskAssignmentValue"+id).removeAttr("disabled");
						//$("#updateRiskAssignmentValue"+id).attr("disabled", true);
						
					}else{
						$("#addRiskAssignmentValue"+id).attr("disabled", true);
						//$("#updateRiskAssignmentValue"+id).removeAttr("disabled");
					}
					
					
				},
				error: function(a,b,c){
					alert(a+b+c);
				}
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
						<td width="10%">Risk Parameters</td>
						<td width="5%">&nbsp;</td>
						<td width="85%" class="dynamicIndividualParams" >
							<select class="form-control input-sm " id="dynamicIndivRiskParameter${UNQID}" name="dynamicIndivRiskParameter">
								<option value="DR1_I">Filing of Regulatory Report</option>
								<option value="DR2_I">Account Status Change</option>
								<option value="DR3_I">Account Status Change (Based on reason)</option>
								<option value="DR4_I">Transaction with High Risk customer</option>
								<option value="DR5_I">Alerts Generated Count</option>
							</select>
						</td>
						<td width="85%" class="dynamicNonIndividualParams" style="display: none;">
							<select class="form-control input-sm " id="dynamicNonIndivRiskParameter${UNQID}" name="dynamicNonIndivRiskParameter" >
								<option value="DR1_N">Filing of Regulatory Report</option>
								<option value="DR2_N">Account Status Change</option>
								<option value="DR3_N">Account Status Change (Based on reason)</option>
								<option value="DR4_N">Transaction with High Risk customer</option>
								<option value="DR5_N">Turnover in the account</option>
								<option value="DR6_N">Alerts Generated Count</option>
							</select>
						</td>
						<td width="85%" class="dynamicSolePropParams" style="display: none;">
							<select class="form-control input-sm " id="dynamicSolePropRiskParameter${UNQID}" name="dynamicSolePropRiskParameter" >
								<option value="DR1_S">Filing of Regulatory Report</option>
								<option value="DR2_S">Account Status Change</option>
								<option value="DR3_S">Account Status Change (Based on reason)</option>
								<option value="DR4_S">Transaction with High Risk customer</option>
								<option value="DR5_S">Turnover in the account</option>
								<option value="DR6_S">Alerts Generated Count</option>
							</select>
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
						<button type="button" class="btn btn-success btn-sm" id="updateDynamicRiskAssignmentValue${UNQID}" name="Update">Update</button>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
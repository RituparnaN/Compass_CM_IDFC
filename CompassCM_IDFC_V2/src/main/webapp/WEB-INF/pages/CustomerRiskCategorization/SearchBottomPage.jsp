<%@ page language="java" contentType="text/html;charset=UTF-8"
	pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../tags/tags.jsp"%>
<script type="text/javascript">
	$(document).ready(function() {
		var id = '${UNQID}';
		compassTopFrame.init(id, 'compassRiskAssignmentSearchTable'+id, 'dd/mm/yy');
		
		$('.panelSlidingStaticRiskAssignment'+id).on("click", function (e) {
			var mainRow = $(this).parents(".compassrow"+id);
			compassTopFrame.searchPanelSliding(id, mainRow, 'staticRiskAssignmentSerachResultPanel');
	    });
		
		$('.panelSlidingDynamicRiskAssignment'+id).on("click", function (e) {
			var mainRow = $(this).parents(".compassrow"+id);
			compassTopFrame.searchPanelSliding(id, mainRow, 'dynamicRiskAssignmentSerachResultPanel');
	    });
		
		$('.panelSlidingStaticRiskParameter'+id).on("click", function (e) {
			var mainRow = $(this).parents(".compassrow"+id);
			compassTopFrame.searchPanelSliding(id, mainRow, 'staticRiskParametersSerachResultPanel');
	    });
		
		$('.panelSlidingDynamicRiskParameter'+id).on("click", function (e) {
			var mainRow = $(this).parents(".compassrow"+id);
			compassTopFrame.searchPanelSliding(id, mainRow, 'dynamicRiskParametersSerachResultPanel');
	    });
		
		$('.panelSlidingStaticRiskCalculation'+id).on("click", function (e) {
			var mainRow = $(this).parents(".compassrow"+id);
			compassTopFrame.searchPanelSliding(id, mainRow, 'staticRiskCalculationSerachResultPanel');
	    });
		
		$('.panelSlidingDynamicRiskCalculation'+id).on("click", function (e) {
			var mainRow = $(this).parents(".compassrow"+id);
			compassTopFrame.searchPanelSliding(id, mainRow, 'dynamicRiskCalculationSerachResultPanel');
	    });
		
		$("input:radio[name = staticCRCCustomerType]").change(function(){
			var checked = $(this).filter(':checked');
			
			//alert(checked.val());
			if(checked.val() == 'I'){
				$('.staticIndividualParams').show();
				$('.staticNonIndividualParams').hide();
				$('.staticSolePropParams').hide();
			}
			else if(checked.val() == 'N'){
				$('.staticNonIndividualParams').show();
				$('.staticIndividualParams').hide();
				$('.staticSolePropParams').hide();
			}
			else if(checked.val() == 'S'){
				$('.staticSolePropParams').show();
				$('.staticIndividualParams').hide();
				$('.staticNonIndividualParams').hide();
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
		
		$("#searchStaticRiskParameters"+id).click(function(){
			var mainRow = $(this).parents("div.compassrow"+id);
			var slidingDiv = $(mainRow).children().children().children();
			var panelBody = $(mainRow).children().children().find(".panelSearchForm");
			var customerType = $("input:radio[name = staticCustomerType]").filter(":checked").val();
			$.ajax({
				url: "${pageContext.request.contextPath}/admin/searchStaticRiskParameters",
				cache: false,
				type: "POST",
				data: "customerType="+customerType,
				success: function(res){
					$("#staticRiskParametersSerachResultPanel"+id).css("display", "block");
					$("#staticRiskParametersSerachResult"+id).html(res);
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
		
		$("#searchDynamicRiskParameters"+id).click(function(){
			var mainRow = $(this).parents("div.compassrow"+id);
			var slidingDiv = $(mainRow).children().children().children();
			var panelBody = $(mainRow).children().children().find(".panelSearchForm");
			var customerType = $("input:radio[name = dynamicCustomerType]").filter(":checked").val();
			$.ajax({
				url: "${pageContext.request.contextPath}/admin/searchDynamicRiskParameters",
				cache: false,
				type: "POST",
				data: "customerType="+customerType,
				success: function(res){
					$("#dynamicRiskParametersSerachResultPanel"+id).css("display", "block");
					$("#dynamicRiskParametersSerachResult"+id).html(res);
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
		
		$("#updateStaticRiskParametersList"+id).click(function(){
			var fullData = "";
			$(".staticParameterListTable").children("tbody").children("tr").each(function(){
				var checkbox = $(this).children("td:first-child").children("input");
				var paramId = $(checkbox).attr("id");
				
				fullData = fullData+paramId+"=";
				if($(checkbox).prop("checked")){
					fullData = fullData+"Y";
				}else{
					fullData = fullData+"N";
				}
				fullData = fullData+",";
			});
			$.ajax({
				url: "${pageContext.request.contextPath}/admin/saveStaticParameterList",
				cache: false,
				type: "POST",
				data: "staticRiskParameters="+fullData+"&id="+id,
				success: function(res){
					alert("Static Parameters Updated Successfully");
					//$("#customerRiskCategorizationBottomFrame").html(res);
				},
				error: function(a,b,c){
					alert(a+b+c);
				}
			});
		});
		
		$("#updateDynamicRiskParametersList"+id).click(function(){
			var fullData = "";
			$(".dynamicParameterListTable").children("tbody").children("tr").each(function(){
				var checkbox = $(this).children("td:first-child").children("input");
				var paramId = $(checkbox).attr("id");
				fullData = fullData+paramId+"=";
				if($(checkbox).prop("checked")){
					fullData = fullData+"Y";
				}else{
					fullData = fullData+"N";
				}
				fullData = fullData+",";
			});
			$.ajax({
				url: "${pageContext.request.contextPath}/admin/saveDynamicParameterList",
				cache: false,
				type: "POST",
				data: "dynamicRiskParameters="+fullData+"&id="+id,
				success: function(res){
					alert("Dynamic Parameters Updated Successfully");
					//$("#customerRiskCategorizationBottomFrame").html(res);
				},
				error: function(a,b,c){
					alert(a+b+c);
				}
			});
		});
		
		$("#searchStaticRiskAssignment"+id).click(function(){
			var searchButton = "searchStaticRiskAssignment${UNQID}";
			var mainRow = $(this).parents("div.compassrow"+id);
			var slidingDiv = $(mainRow).children().children().children();
			var panelBody = $(mainRow).children().children().find(".panelSearchForm");
			var searchParamId = "";
			//var isRangeRequired = $("#staticParameterId"+id).find("option[value='"+searchParamId+"']").attr("isRangeRequired");
			var customerType = $("input:radio[name = staticCRCCustomerType]").filter(":checked").val();
			
			if(customerType == 'I'){
				searchParamId = $("#staticIndvParameterId"+id).val();
			}
			else if(customerType == 'N'){
				searchParamId = $("#staticNonIndvParameterId"+id).val();
			}
			else if(customerType == 'S'){
				searchParamId = $("#staticSolePropParameterId"+id).val();
			}
			
			$.ajax({
				url: "${pageContext.request.contextPath}/admin/searchStaticRiskAssignment",
				cache: false,
				type: "POST",
				data: "searchParamId="+searchParamId+"&id="+id+"&customerType="+customerType+"&searchButton="+searchButton,
				success: function(res){
					$("#staticRiskAssignmentSerachResultPanel"+id).css("display", "block");
					$("#staticRiskAssignmentSerachResult"+id).html(res);
					$(panelBody).slideUp();
					$(slidingDiv).addClass('card-collapsed');
					$(slidingDiv).find('i.collapsable').removeClass('fa-chevron-up').addClass('fa-chevron-down');
					$(mainRow).next().find(".compassrow"+id).find(".card-header").next().slideDown();
					
					/* if(isRangeRequired == "Y"){
						$("#addStaticRiskAssignmentValue"+id).removeAttr("disabled");
						//$("#updateRiskAssignmentValue"+id).attr("disabled", true);
						
					}else{
						$("#addStaticRiskAssignmentValue"+id).attr("disabled", true);
						//$("#updateRiskAssignmentValue"+id).removeAttr("disabled");
					} */
				},
				error: function(a,b,c){
					alert(a+b+c);
				}
			});
		});
		
		$("#searchDynamicRiskAssignment"+id).click(function(){
			var searchButton = "searchDynamicRiskAssignment${UNQID}";
			var mainRow = $(this).parents("div.compassrow"+id);
			var slidingDiv = $(mainRow).children().children().children();
			var panelBody = $(mainRow).children().children().find(".panelSearchForm");
			var searchParamId = "";
			var isRangeRequired = "";
			var customerType = $("input:radio[name = dynamicCRCCustomerType]").filter(":checked").val();
			
			if(customerType == 'I'){
				searchParamId = $("#dynamicIndvParameterId"+id).val();
				isRangeRequired = $("#dynamicIndvParameterId"+id).find("option[value='"+searchParamId+"']").attr("isRangeRequired");
			}
			else if(customerType == 'N'){
				searchParamId = $("#dynamicNonIndvParameterId"+id).val();
				isRangeRequired = $("#dynamicNonIndvParameterId"+id).find("option[value='"+searchParamId+"']").attr("isRangeRequired");
			}
			else if(customerType == 'S'){
				searchParamId = $("#dynamicSolePropParameterId"+id).val();
				isRangeRequired = $("#dynamicSolePropParameterId"+id).find("option[value='"+searchParamId+"']").attr("isRangeRequired");
			}
			/* alert("customerType = "+customerType);
			alert("searchParamId = "+searchParamId);
			alert("isRangeRequired = "+isRangeRequired);
			 */
			$.ajax({
				url: "${pageContext.request.contextPath}/admin/searchDynamicRiskAssignment",
				cache: false,
				type: "POST",
				data: "searchParamId="+searchParamId+"&id="+id+"&isRangeRequired="+isRangeRequired+"&customerType="+customerType+"&searchButton="+searchButton,
				success: function(res){
					$("#dynamicRiskAssignmentSerachResultPanel"+id).css("display", "block");
					$("#dynamicRiskAssignmentSerachResult"+id).html(res);
					$(panelBody).slideUp();
					$(slidingDiv).addClass('card-collapsed');
					$(slidingDiv).find('i.collapsable').removeClass('fa-chevron-up').addClass('fa-chevron-down');
					$(mainRow).next().find(".compassrow"+id).find(".card-header").next().slideDown();
					
					if(isRangeRequired == "Y"){
						$("#addDynamicRiskAssignmentValue"+id).removeAttr("disabled");
						//$("#updateRiskAssignmentValue"+id).attr("disabled", true);
						
					}else{
						$("#addDynamicRiskAssignmentValue"+id).attr("disabled", true);
						//$("#updateRiskAssignmentValue"+id).removeAttr("disabled");
					}
				},
				error: function(a,b,c){
					alert(a+b+c);
				}
			});
		});
		
		$("#updateStaticRiskAssignmentValue"+id).click(function(){
			var paramId = "";
			var customerType = $("input:radio[name = staticCRCCustomerType]").filter(":checked").val();
						
			if(customerType == 'I'){
				paramId = $("#staticIndvParameterId"+id).val();
			}
			else if(customerType == 'N'){
				paramId = $("#staticNonIndvParameterId"+id).val();
			}
			else if(customerType == 'S'){
				paramId = $("#staticSolePropParameterId"+id).val();
			}
			
			var table = $("#staticRiskAssignmentSerachResult"+id).find("table");
			var fullData = "";
			$(table).children("tbody").children("tr").each(function(){
				var paramCode = $(this).children("td:first-child").html();
				var paramRiskValue = $(this).children("td:nth-child(3)").children("select").val();
				fullData = fullData +paramCode+"="+paramRiskValue+",";
			});
			//alert(paramId);
			$.ajax({
				url: "${pageContext.request.contextPath}/admin/updateStaticRiskAssignmentValue",
				cache: false,
				type: "POST",
				data: "fullData="+fullData+"&paramId="+paramId,
				success: function(res){
					alert(res);
					$("#searchStaticRiskAssignment"+id).click();
				},
				error: function(a,b,c){
					alert(a+b+c);
				}
			});
		});
		
		$("#updateDynamicRiskAssignmentValue"+id).click(function(){
			var paramId = "";
			var customerType = $("input:radio[name = dynamicCRCCustomerType]").filter(":checked").val();
			
			if(customerType == 'I'){
				paramId = $("#dynamicIndvParameterId"+id).val();
			}
			else if(customerType == 'N'){
				paramId = $("#dynamicNonIndvParameterId"+id).val();
			}
			else if(customerType == 'S'){
				paramId = $("#dynamicSolePropParameterId"+id).val();
			}
			
			var table = $("#dynamicRiskAssignmentSerachResult"+id).find("table");
			var fullData = "";
			$(table).children("tbody").children("tr").each(function(){
				var paramCode = $(this).children("td:first-child").html();
				var paramRiskValue = $(this).children("td:nth-child(3)").children("select").val();
				fullData = fullData +paramCode+"="+paramRiskValue+",";
			});
			$.ajax({
				url: "${pageContext.request.contextPath}/admin/updateDynamicRiskAssignmentValue",
				cache: false,
				type: "POST",
				data: "fullData="+fullData+"&paramId="+paramId,
				success: function(res){
					alert(res);
				},
				error: function(a,b,c){
					alert(a+b+c);
				}
			});
		});

		
		$("#addDynamicRiskAssignmentValue"+id).click(function(){
			var paramId = "";
			var customerType = $("input:radio[name = dynamicCRCCustomerType]").filter(":checked").val();
			
			if(customerType == 'I'){
				paramId = $("#dynamicIndvParameterId"+id).val();
			}
			else if(customerType == 'N'){
				paramId = $("#dynamicNonIndvParameterId"+id).val();
			}
			else if(customerType == 'S'){
				paramId = $("#dynamicSolePropParameterId"+id).val();
			}
			//alert("paramId = "+paramId);
			$.ajax({
				url: "${pageContext.request.contextPath}/admin/fetchParamIdToAddNewDynamicRiskParameter",
				cache: false,
				type: "POST",
				data: "paramId="+paramId+"&isNew=Y",
				success: function(res){
					$("#compassCaseWorkFlowGenericModal").modal("show");
					$("#compassCaseWorkFlowGenericModal-title").html("Dynamic Risk Parameter Details");
					$("#compassCaseWorkFlowGenericModal-body").html(res);
				},
				error: function(a,b,c){
					alert(a+b+c);
				}
			});
		});
		
		$("#searchStaticRiskWeightage"+id).click(function(){
			var mainRow = $(this).parents("div.compassrow"+id);
			var slidingDiv = $(mainRow).children().children().children();
			var panelBody = $(mainRow).children().children().find(".panelSearchForm");
			var customerType = $("input:radio[name = staticCustomerType_RC]").filter(":checked").val();
			//alert(customerType);
			$.ajax({
				url: "${pageContext.request.contextPath}/admin/searchStaticRiskWeightage",
				cache: false,
				type: "POST",
				data: "customerType="+customerType,
				success: function(res){
					$("#staticRiskCalculationSerachResultPanel"+id).css("display", "block");
					$("#staticRiskCalculationSerachResult"+id).html(res);
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
		
		$("#searchDynamicRiskWeightage"+id).click(function(){
			var mainRow = $(this).parents("div.compassrow"+id);
			var slidingDiv = $(mainRow).children().children().children();
			var panelBody = $(mainRow).children().children().find(".panelSearchForm");
			var customerType = $("input:radio[name = dynamicCustomerType_RC]").filter(":checked").val();
			$.ajax({
				url: "${pageContext.request.contextPath}/admin/searchDynamicRiskWeightage",
				cache: false,
				type: "POST",
				data: "customerType="+customerType,
				success: function(res){
					$("#dynamicRiskCalculationSerachResultPanel"+id).css("display", "block");
					$("#dynamicRiskCalculationSerachResult"+id).html(res);
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
		
		$("#updateStaticRiskWeightage"+id).click(function(){
			var fullData = "";
			$(".staticRiskWeightageTable").children("tbody").children("tr").each(function(){
				var paramId = $(this).children("td:first-child").html();
				var paramWeightage = $(this).children("td:nth-child(3)").children("select").val();
				fullData = fullData + paramId+"="+paramWeightage+",";
			});
			$.ajax({
				url: "${pageContext.request.contextPath}/admin/updateStaticRiskWeightageList",
				cache: false,
				type: "POST",
				data: "staticRiskWeightage="+fullData+"&id="+id,
				success: function(res){
					alert(res);
					//$("#customerRiskCategorizationBottomFrame").html(res);
				},
				error: function(a,b,c){
					alert(a+b+c);
				}
			});
		});
		
		$("#updateDynamicRiskWeightage"+id).click(function(){
			var fullData = "";
			$(".dynamicRiskWeightageTable").children("tbody").children("tr").each(function(){
				var paramId = $(this).children("td:first-child").html();
				var paramWeightage = $(this).children("td:nth-child(3)").children("select").val();
				fullData = fullData + paramId+"="+paramWeightage+",";
			});
			$.ajax({
				url: "${pageContext.request.contextPath}/admin/updateDynamicRiskWeightageList",
				cache: false,
				type: "POST",
				data: "dynamicRiskWeightage="+fullData+"&id="+id,
				success: function(res){
					alert(res);
					//$("#customerRiskCategorizationBottomFrame").html(res);
				},
				error: function(a,b,c){
					alert(a+b+c);
				}
			});
		});
		
		$("#calculateStaticRisk"+id).click(function(){
			var btn = $(this);
			var btnMsg = $(btn).html();
			$(btn).html("Calculating...");
			$(btn).attr("disabled",true);
			$.ajax({
				url: "${pageContext.request.contextPath}/admin/calculateStaticRisk",
				cache: false,
				type: "POST",
				success: function(res){		
					alert("Static Risk calculated successfully.");
					$(btn).html(btnMsg);
					$(btn).removeAttr("disabled");
				},
				error: function(a,b,c){
					alert(a+b+c);
				}
			});
		});
		
		$("#calculateDynamicRisk"+id).click(function(){
			var btn = $(this);
			var btnMsg = $(btn).html();
			$(btn).html("Calculating...");
			$(btn).attr("disabled",true);
			$.ajax({
				url: "${pageContext.request.contextPath}/admin/calculateDynamicRisk",
				cache: false,
				type: "POST",
				success: function(res){		
					alert("Dynamic Risk calculated successfully.");
					$(btn).html(btnMsg);
					$(btn).removeAttr("disabled");
				},
				error: function(a,b,c){
					alert(a+b+c);
				}
			});
		});
});
	
</script>
<style>
.subNav{
margin-top: 5px;
}
</style>
<div role="tabpanel" class="tab-pane active" id="CRC_RP" >
	<ul class="nav nav-pills modalNav subNav" role="tablist">
		<li role="presentation" class= "active">
			<a class="subTab nav-link active" href="#staticRP" aria-controls="tab" role="tab" data-toggle="tab">Static</a>
		</li>
		<li role="presentation" >
			<a class="subTab nav-link" href="#dynamicRP" aria-controls="tab" role="tab" data-toggle="tab">Dynamic</a>
		</li>
	</ul>
<div class="tab-content" id="riskParametersTab">
	<div role="tabpanel" class="tab-pane active" id="staticRP" >
		<div class="row">
			<div class="col-sm-12">
				<div class="card card-default" style="margin-bottom: 0px;">
					<div class="row compassrow${UNQID}">
						<div class="col-sm-12">
							<div class="card card-primary panel_riskParameter" style="margin-bottom: 0px; margin-top: 2px;">
								<div class="card-header panelSlidingStaticRiskParameter${UNQID} clearfix">
									<h6 class="card-title pull-${dirL}">Static Risk Parameters</h6>
										<div class="btn-group pull-${dirR} clearfix">
											<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
										</div>
								</div>
								<div class="panelSearchForm">
									<table class="table table-striped staticRiskParameterSearchTable" style="margin-bottom: 0px;">
										<tr>
										<td width="10%" style="padding-top: 15px;">Customer Type</td>
										<td width="5%">&nbsp;</td>
										<td width="85%">
											<table style="width:100%">
												<tr>
													<td width="20%">
														<label class="btn btn-default btn-sm" for="staticCustomerTypeIndiv${UNQID}">
															<input type="radio" name="staticCustomerType" id="staticCustomerTypeIndiv${UNQID}" value="I" checked="checked">
															Individual
														</label>
													</td>
													<td width="5%">&nbsp;</td>
													<td width="20%">
														<label class="btn btn-default btn-sm" for="staticCustomerTypeNonIndiv${UNQID}">
															<input type="radio" name="staticCustomerType" id="staticCustomerTypeNonIndiv${UNQID}" value="N">
															Non-Individual
														</label>
													</td>
													<td width="5%">&nbsp;</td>
													<td width="20%">
														<label class="btn btn-default btn-sm" for="staticCustomerTypeSoleProp${UNQID}">
															<input type="radio" name="staticCustomerType" id="staticCustomerTypeSoleProp${UNQID}" value="S">
															Sole Proprietor
														</label>
													</td>
													<td width="5%">&nbsp;</td>
													<td width="20%">
														<label class="btn btn-default btn-sm" for="staticCustomerTypeAll${UNQID}">
															<input type="radio" name="staticCustomerType" id="staticCustomerTypeAll${UNQID}" value="A">
															All of these
														</label>
													</td>
													<td width="5%">&nbsp;</td>
												</tr>
											</table>
										</td>
										</tr>
									</table>
									<div class="card-footer clearfix">
										<div class="pull-${dirR}">
											<input type="button" id="searchStaticRiskParameters${UNQID}" class="btn btn-primary btn-sm" name="Search" value="Search">
										</div>
									</div>
								</div>
							</div>
						</div>
						<div class="col-sm-12">
							<div class="card card-primary" id="staticRiskParametersSerachResultPanel${UNQID}" style="margin-top: 10px; margin-bottom: 0px; display: none;">
								<div class="card-header panelSlidingStaticRiskParameters${UNQID} clearfix">
									<h6 class="card-title pull-${dirL}">Update Static Risk Value</h6>
								<div class="btn-group pull-${dirR} clearfix">
									<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
								</div>
								</div>
								<div id="staticRiskParametersSerachResult${UNQID}"></div>
								<div class="card-footer clearfix">
									<div class="pull-${dirR}">
										<%-- <button type="button" class="btn btn-success btn-sm" id="addStaticRiskAssignmentValue${UNQID}" name="Add">Add</button> --%>
										<button type="button" class="btn btn-success btn-sm" id="updateStaticRiskParametersList${UNQID}" name="Update">Update</button>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	
	<div role="tabpanel" class="tab-pane" id="dynamicRP" >
		<div class="row">
			<div class="col-sm-12">
				<div class="card card-default" style="margin-bottom: 0px;">
					<div class="row compassrow${UNQID}">
						<div class="col-sm-12">
							<div class="card card-primary panel_riskParameter" style="margin-bottom: 0px; margin-top: 2px;">
								<div class="card-header panelSlidingDynamicRiskParameter${UNQID} clearfix">
									<h6 class="card-title pull-${dirL}">Dynamic Risk Parameters</h6>
										<div class="btn-group pull-${dirR} clearfix">
											<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
										</div>
								</div>
								<div class="panelSearchForm">
									<table class="table table-striped dynamicRiskParameterSearchTable" style="margin-bottom: 0px;">
										<tr>
										<td width="10%" style="padding-top: 15px;">Customer Type</td>
										<td width="5%">&nbsp;</td>
										<td width="85%">
											<table style="width:100%">
												<tr>
													<td width="20%">
														<label class="btn btn-default btn-sm" for="dyanmicCustomerTypeIndiv${UNQID}">
															<input type="radio" name="dynamicCustomerType" id="dyanmicCustomerTypeIndiv${UNQID}" value="I" checked="checked">
															Individual
														</label>
													</td>
													<td width="5%">&nbsp;</td>
													<td width="20%">
														<label class="btn btn-default btn-sm" for="dyanmicCustomerTypeNonIndiv${UNQID}">
															<input type="radio" name="dynamicCustomerType" id="dyanmicCustomerTypeNonIndiv${UNQID}" value="N">
															Non-Individual
														</label>
													</td>
													<td width="5%">&nbsp;</td>
													<td width="20%">
														<label class="btn btn-default btn-sm" for="dyanmicCustomerTypeSoleProp${UNQID}">
															<input type="radio" name="dynamicCustomerType" id="dyanmicCustomerTypeSoleProp${UNQID}" value="S">
															Sole Proprietor
														</label>
													</td>
													<td width="5%">&nbsp;</td>
													<td width="20%">
														<label class="btn btn-default btn-sm" for="dyanmicCustomerTypeAll${UNQID}">
															<input type="radio" name="dynamicCustomerType" id="dyanmicCustomerTypeAll${UNQID}" value="A">
															All of these
														</label>
													</td>
													<td width="5%">&nbsp;</td>
												</tr>
											</table>
										</td>
										</tr>
									</table>
									<div class="card-footer clearfix">
										<div class="pull-${dirR}">
											<input type="button" id="searchDynamicRiskParameters${UNQID}" class="btn btn-primary btn-sm" name="Search" value="Search">
										</div>
									</div>
								</div>
							</div>
						</div>
						<div class="col-sm-12">
							<div class="card card-primary" id="dynamicRiskParametersSerachResultPanel${UNQID}" style="margin-top: 10px; margin-bottom: 0px; display: none;">
								<div class="card-header panelSlidingDynamicRiskParameters${UNQID} clearfix">
									<h6 class="card-title pull-${dirL}">Update Dynamic Risk Value</h6>
								<div class="btn-group pull-${dirR} clearfix">
									<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
								</div>
								</div>
								<div id="dynamicRiskParametersSerachResult${UNQID}"></div>
								<div class="card-footer clearfix">
									<div class="pull-${dirR}">
										<%-- <button type="button" class="btn btn-success btn-sm" id="addStaticRiskAssignmentValue${UNQID}" name="Add">Add</button> --%>
										<button type="button" class="btn btn-success btn-sm" id="updateDynamicRiskParametersList${UNQID}" name="Update">Update</button>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
</div>

<div role="tabpanel" class="tab-pane" id="CRC_RA">
	<ul class="nav nav-pills modalNav subNav" role="tablist">
		<li role="presentation" class= "active">
			<a class="subTab nav-link active" href="#staticRA" aria-controls="tab" role="tab" data-toggle="tab">Static</a>
		</li>
		<li role="presentation" >
			<a class="subTab nav-link" href="#dynamicRA" aria-controls="tab" role="tab" data-toggle="tab">Dynamic</a>
		</li>
	</ul>
	<div class="tab-content" id="riskAssignmentTab">
	<div role="tabpanel" class="tab-pane active" id="staticRA" >
		<div class="row">
			<div class="col-sm-12">
				<div class="card card-default" style="margin-bottom: 0px;">
					<div class="row compassrow${UNQID}">
						<div class="col-sm-12">
							<div class="card card-primary panel_riskAssignment" style="margin-bottom: 0px; margin-top: 2px;">
								<div class="card-header panelSlidingStaticRiskAssignment${UNQID} clearfix">
									<h6 class="card-title pull-${dirL}">Static Risk Assignment</h6>
										<div class="btn-group pull-${dirR} clearfix">
											<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
										</div>
								</div>
								<div class="panelSearchForm">
									<table class="table table-striped staticRiskAssignmentSearchTable" style="margin-bottom: 0px;">
										<tr>
										<td width="10%" style="padding-top: 15px;">Customer Type</td>
										<td width="5%">&nbsp;</td>
										<td width="85%">
											<table style="width:100%">
												<tr>
													<td width="25%">
														<label class="btn btn-default btn-sm" for="customerTypeIndiv${UNQID}">
															<input type="radio" name="staticCRCCustomerType" id="customerTypeIndiv${UNQID}" value="I" checked="checked">
															Individual
														</label>
													</td>
													<td width="5%">&nbsp;</td>
													<td width="25%">
														<label class="btn btn-default btn-sm" for="customerTypeNonIndiv${UNQID}">
															<input type="radio" name="staticCRCCustomerType" id="customerTypeNonIndiv${UNQID}" value="N">
															Non-Individual
														</label>
													</td>
													<td width="5%">&nbsp;</td>
													<td width="25%">
														<label class="btn btn-default btn-sm" for="customerTypeSoleProp${UNQID}">
															<input type="radio" name="staticCRCCustomerType" id="customerTypeSoleProp${UNQID}" value="S">
															Sole Proprietor
														</label>
													</td>
												</tr>
											</table>
										</td>
										</tr>
										<tr>
											<td width="10%">Parameter Id</td>
											<td width="5%">&nbsp;</td>
											<td width="85%" class="staticIndividualParams" >
												<select class="form-control input-sm" name="staticIndvParameterId" id="staticIndvParameterId${UNQID}">
													<c:forEach var="parameterList" items="${STATICPARAMLIST}">
														<c:if test="${parameterList['ISRISKPARAMETERMARKED'] eq 'Y' && parameterList['CUSTOMERTYPE'] eq 'I'}">
															<option value="${parameterList['RISKPARAMETERID']}">${parameterList['RISKPARAMETERNAME']}</option>
														</c:if>
													</c:forEach>
												</select> 
											</td>
											<td width="85%" class="staticNonIndividualParams" style="display: none;">
												<select class="form-control input-sm" name="staticNonIndvParameterId" id="staticNonIndvParameterId${UNQID}">
													<c:forEach var="parameterList" items="${STATICPARAMLIST}">
														<c:if test="${parameterList['ISRISKPARAMETERMARKED'] eq 'Y' && parameterList['CUSTOMERTYPE'] eq 'N'}">
															<option value="${parameterList['RISKPARAMETERID']}">${parameterList['RISKPARAMETERNAME']}</option>
														</c:if>
													</c:forEach>
												</select> 
											</td>
											<td width="85%" class="staticSolePropParams" style="display: none;">
												<select class="form-control input-sm" name="staticSolePropParameterId" id="staticSolePropParameterId${UNQID}">
													<c:forEach var="parameterList" items="${STATICPARAMLIST}">
														<c:if test="${parameterList['ISRISKPARAMETERMARKED'] eq 'Y' && parameterList['CUSTOMERTYPE'] eq 'S'}">
															<option value="${parameterList['RISKPARAMETERID']}">${parameterList['RISKPARAMETERNAME']}</option>
														</c:if>
													</c:forEach>
												</select> 
											</td>
										</tr>
									</table>
									<div class="card-footer clearfix">
										<div class="pull-${dirR}">
											<input type="button" id="searchStaticRiskAssignment${UNQID}" class="btn btn-primary btn-sm" name="Search" value="Search">
										</div>
									</div>
								</div>
							</div>
						</div>
						<div class="col-sm-12">
							<div class="card card-primary" id="staticRiskAssignmentSerachResultPanel${UNQID}" style="margin-top: 10px; margin-bottom: 0px; display: none;">
								<div class="card-header panelSlidingStaticRiskAssignment${UNQID} clearfix">
									<h6 class="card-title pull-${dirL}">Update Static Risk Value</h6>
								<div class="btn-group pull-${dirR} clearfix">
									<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
								</div>
								</div>
								<div id="staticRiskAssignmentSerachResult${UNQID}"></div>
								<div class="card-footer clearfix">
									<div class="pull-${dirR}">
										<%-- <button type="button" class="btn btn-success btn-sm" id="addStaticRiskAssignmentValue${UNQID}" name="Add">Add</button> --%>
										<button type="button" class="btn btn-success btn-sm" id="updateStaticRiskAssignmentValue${UNQID}" name="Update">Update</button>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div role="tabpanel" class="tab-pane" id="dynamicRA" >
		<div class="row">
			<div class="col-sm-12">
				<div class="card card-default" style="margin-bottom: 0px;">
					<div class="row compassrow${UNQID}">
						<div class="col-sm-12">
							<div class="card card-primary panel_riskAssignment" style="margin-bottom: 0px; margin-top: 2px;">
								<div class="card-header panelSlidingDynamicRiskAssignment${UNQID} clearfix">
									<h6 class="card-title pull-${dirL}">Dynamic Risk Assignment</h6>
										<div class="btn-group pull-${dirR} clearfix">
											<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
										</div>
								</div>
								<div class="panelSearchForm">
									<table class="table table-striped dynamicRiskAssignmentSearchTable" style="margin-bottom: 0px;">
										<tr>
										<td width="10%" style="padding-top: 15px;">Customer Type</td>
										<td width="5%">&nbsp;</td>
										<td width="85%">
											<table style="width:100%">
												<tr>
													<td width="25%">
														<label class="btn btn-default btn-sm" for="dynamicCustomerTypeIndiv${UNQID}">
															<input type="radio" name="dynamicCRCCustomerType" id="dynamicCustomerTypeIndiv${UNQID}" value="I" checked="checked">
															Individual
														</label>
													</td>
													<td width="5%">&nbsp;</td>
													<td width="25%">
														<label class="btn btn-default btn-sm" for="dynamicCustomerTypeNonIndiv${UNQID}">
															<input type="radio" name="dynamicCRCCustomerType" id="dynamicCustomerTypeNonIndiv${UNQID}" value="N">
															Non-Individual
														</label>
													</td>
													<td width="5%">&nbsp;</td>
													<td width="25%">
														<label class="btn btn-default btn-sm" for="dynamicCustomerTypeSoleProp${UNQID}">
															<input type="radio" name="dynamicCRCCustomerType" id="dynamicCustomerTypeSoleProp${UNQID}" value="S">
															Sole Proprietor
														</label>
													</td>
												</tr>
											</table>
										</td>
										</tr>
										<tr>
											<td width="10%">Parameter Id</td>
											<td width="5%">&nbsp;</td>
											<td width="85%" class="dynamicIndividualParams" >
												<select class="form-control input-sm" name="dynamicIndvParameterId" id="dynamicIndvParameterId${UNQID}">
													<c:forEach var="parameterList" items="${DYNAMICPARAMLIST}">
														<c:if test="${parameterList['ISRISKPARAMETERMARKED'] eq 'Y' && parameterList['CUSTOMERTYPE'] eq 'I'}">
															<option isRangeRequired="${parameterList['ISFROMTOREQ']}" value="${parameterList['RISKPARAMETERID']}">${parameterList['RISKPARAMETERNAME']}</option>
														</c:if>
													</c:forEach>
												</select> 
											</td>
											<td width="85%" class="dynamicNonIndividualParams" style="display: none;">
												<select class="form-control input-sm" name="dynamicNonIndvParameterId" id="dynamicNonIndvParameterId${UNQID}">
													<c:forEach var="parameterList" items="${DYNAMICPARAMLIST}">
														<c:if test="${parameterList['ISRISKPARAMETERMARKED'] eq 'Y' && parameterList['CUSTOMERTYPE'] eq 'N'}">
															<option isRangeRequired="${parameterList['ISFROMTOREQ']}" value="${parameterList['RISKPARAMETERID']}">${parameterList['RISKPARAMETERNAME']}</option>
														</c:if>
													</c:forEach>
												</select> 
											</td>
											<td width="85%" class="dynamicSolePropParams" style="display: none;">
												<select class="form-control input-sm" name="dynamicSolePropParameterId" id="dynamicSolePropParameterId${UNQID}">
													<c:forEach var="parameterList" items="${DYNAMICPARAMLIST}">
														<c:if test="${parameterList['ISRISKPARAMETERMARKED'] eq 'Y' && parameterList['CUSTOMERTYPE'] eq 'S'}">
															<option isRangeRequired="${parameterList['ISFROMTOREQ']}" value="${parameterList['RISKPARAMETERID']}">${parameterList['RISKPARAMETERNAME']}</option>
														</c:if>
													</c:forEach>
												</select> 
											</td>
										</tr>
									</table>
									<div class="card-footer clearfix">
										<div class="pull-${dirR}">
											<input type="button" id="searchDynamicRiskAssignment${UNQID}" class="btn btn-primary btn-sm" name="Search" value="Search">
										</div>
									</div>
								</div>
							</div>
						</div>
						<div class="col-sm-12">
							<div class="card card-primary" id="dynamicRiskAssignmentSerachResultPanel${UNQID}" style="margin-top: 10px; margin-bottom: 0px; display: none;">
								<div class="card-header panelSlidingDynamicRiskAssignment${UNQID} clearfix">
									<h6 class="card-title pull-${dirL}">Update Dynamic Risk Value</h6>
								<div class="btn-group pull-${dirR} clearfix">
									<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
								</div>
								</div>
								<div id="dynamicRiskAssignmentSerachResult${UNQID}"></div>
								<div class="card-footer clearfix">
									<div class="pull-${dirR}">
										<button type="button" class="btn btn-success btn-sm" id="addDynamicRiskAssignmentValue${UNQID}" name="Add">Add</button>
										<button type="button" class="btn btn-success btn-sm" id="updateDynamicRiskAssignmentValue${UNQID}" name="Update">Update</button>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
</div>

<div role="tabpanel" class="tab-pane" id="CRC_RC" >
	<ul class="nav nav-pills modalNav subNav" role="tablist">
		<li role="presentation" class= "active">
			<a class="subTab nav-link active" href="#staticRC" aria-controls="tab" role="tab" data-toggle="tab">Static</a>
		</li>
		<li role="presentation" >
			<a class="subTab nav-link" href="#dynamicRC" aria-controls="tab" role="tab" data-toggle="tab">Dynamic</a>
		</li>
	</ul>
<div class="tab-content" id="riskCalculationTab">
	<div role="tabpanel" class="tab-pane active" id="staticRC" >
		<div class="row">
			<div class="col-sm-12">
				<div class="card card-default" style="margin-bottom: 0px;">
					<div class="row compassrow${UNQID}">
						<div class="col-sm-12">
							<div class="card card-primary panel_riskCalculation" style="margin-bottom: 0px; margin-top: 2px;">
								<div class="card-header panelSlidingStaticRiskCalculation${UNQID} clearfix">
									<h6 class="card-title pull-${dirL}">Static Risk Weightage</h6>
										<div class="btn-group pull-${dirR} clearfix">
											<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
										</div>
								</div>
								<div class="panelSearchForm">
									<table class="table table-striped staticRiskCalculationSearchTable" style="margin-bottom: 0px;">
										<tr>
										<td width="10%" style="padding-top: 15px;">Customer Type</td>
										<td width="5%">&nbsp;</td>
										<td width="85%">
											<table style="width:100%">
												<tr>
													<td width="20%">
														<label class="btn btn-default btn-sm" for="staticCustomerTypeIndiv_RC${UNQID}">
															<input type="radio" name="staticCustomerType_RC" id="staticCustomerTypeIndiv_RC${UNQID}" value="I" checked="checked">
															Individual
														</label>
													</td>
													<td width="5%">&nbsp;</td>
													<td width="20%">
														<label class="btn btn-default btn-sm" for="staticCustomerTypeNonIndiv_RC${UNQID}">
															<input type="radio" name="staticCustomerType_RC" id="staticCustomerTypeNonIndiv_RC${UNQID}" value="N">
															Non-Individual
														</label>
													</td>
													<td width="5%">&nbsp;</td>
													<td width="20%">
														<label class="btn btn-default btn-sm" for="staticCustomerTypeSoleProp_RC${UNQID}">
															<input type="radio" name="staticCustomerType_RC" id="staticCustomerTypeSoleProp_RC${UNQID}" value="S">
															Sole Proprietor
														</label>
													</td>
													<td width="5%">&nbsp;</td>
													<td width="20%">
														<label class="btn btn-default btn-sm" for="staticCustomerTypeAll_RC${UNQID}">
															<input type="radio" name="staticCustomerType_RC" id="staticCustomerTypeAll_RC${UNQID}" value="A">
															All of these
														</label>
													</td>
													<td width="5%">&nbsp;</td>
												</tr>
											</table>
										</td>
										</tr>
									</table>
									<div class="card-footer clearfix">
										<div class="pull-${dirR}">
											<input type="button" id="searchStaticRiskWeightage${UNQID}" class="btn btn-primary btn-sm" name="Search" value="Search">
										</div>
									</div>
								</div>
							</div>
						</div>
						<div class="col-sm-12">
							<div class="card card-primary" id="staticRiskCalculationSerachResultPanel${UNQID}" style="margin-top: 10px; margin-bottom: 0px; display: none;">
								<div class="card-header panelSlidingStaticRiskCalculation${UNQID} clearfix">
									<h6 class="card-title pull-${dirL}">Update Static Risk Value</h6>
								<div class="btn-group pull-${dirR} clearfix">
									<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
								</div>
								</div>
								<div id="staticRiskCalculationSerachResult${UNQID}"></div>
								<div class="card-footer clearfix">
									<div class="pull-${dirR}">
										<%-- <button type="button" class="btn btn-success btn-sm" id="addStaticRiskAssignmentValue${UNQID}" name="Add">Add</button> --%>
										<%-- <button type="button" class="btn btn-success btn-sm" id="updateStaticRiskWeightage${UNQID}" name="Update">Update</button> --%>
										<button type="button" class="btn btn-warning btn-sm" id="calculateStaticRisk${UNQID}" name="Calculate">Calculate</button>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	
	<div role="tabpanel" class="tab-pane" id="dynamicRC" >
		<div class="row">
			<div class="col-sm-12">
				<div class="card card-default" style="margin-bottom: 0px;">
					<div class="row compassrow${UNQID}">
						<div class="col-sm-12">
							<div class="card card-primary panel_riskCalculation" style="margin-bottom: 0px; margin-top: 2px;">
								<div class="card-header panelSlidingDynamicRiskCalculation${UNQID} clearfix">
									<h6 class="card-title pull-${dirL}">Dynamic Risk Weightage</h6>
										<div class="btn-group pull-${dirR} clearfix">
											<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
										</div>
								</div>
								<div class="panelSearchForm">
									<table class="table table-striped dynamicRiskCalculationSearchTable" style="margin-bottom: 0px;">
										<tr>
										<td width="10%" style="padding-top: 15px;">Customer Type</td>
										<td width="5%">&nbsp;</td>
										<td width="85%">
											<table style="width:100%">
												<tr>
													<td width="20%">
														<label class="btn btn-default btn-sm" for="dyanmicCustomerTypeIndiv_RC${UNQID}">
															<input type="radio" name="dynamicCustomerType_RC" id="dyanmicCustomerTypeIndiv_RC${UNQID}" value="I" checked="checked">
															Individual
														</label>
													</td>
													<td width="5%">&nbsp;</td>
													<td width="20%">
														<label class="btn btn-default btn-sm" for="dyanmicCustomerTypeNonIndiv_RC${UNQID}">
															<input type="radio" name="dynamicCustomerType_RC" id="dyanmicCustomerTypeNonIndiv_RC${UNQID}" value="N">
															Non-Individual
														</label>
													</td>
													<td width="5%">&nbsp;</td>
													<td width="20%">
														<label class="btn btn-default btn-sm" for="dyanmicCustomerTypeSoleProp_RC${UNQID}">
															<input type="radio" name="dynamicCustomerType_RC" id="dyanmicCustomerTypeSoleProp_RC${UNQID}" value="S">
															Sole Proprietor
														</label>
													</td>
													<td width="5%">&nbsp;</td>
													<td width="20%">
														<label class="btn btn-default btn-sm" for="dyanmicCustomerTypeAll_RC${UNQID}">
															<input type="radio" name="dynamicCustomerType_RC" id="dyanmicCustomerTypeAll_RC${UNQID}" value="A">
															All of these
														</label>
													</td>
													<td width="5%">&nbsp;</td>
												</tr>
											</table>
										</td>
										</tr>
									</table>
									<div class="card-footer clearfix">
										<div class="pull-${dirR}">
											<input type="button" id="searchDynamicRiskWeightage${UNQID}" class="btn btn-primary btn-sm" name="Search" value="Search">
										</div>
									</div>
								</div>
							</div>
						</div>
						<div class="col-sm-12">
							<div class="card card-primary" id="dynamicRiskCalculationSerachResultPanel${UNQID}" style="margin-top: 10px; margin-bottom: 0px; display: none;">
								<div class="card-header panelSlidingDynamicRiskCalculation${UNQID} clearfix">
									<h6 class="card-title pull-${dirL}">Update Dynamic Risk Value</h6>
								<div class="btn-group pull-${dirR} clearfix">
									<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
								</div>
								</div>
								<div id="dynamicRiskCalculationSerachResult${UNQID}"></div>
								<div class="card-footer clearfix">
									<div class="pull-${dirR}">
										<%-- <button type="button" class="btn btn-success btn-sm" id="updateDynamicRiskWeightage${UNQID}" name="Update">Update</button> --%>
										<button type="button" class="btn btn-warning btn-sm" id="calculateDynamicRisk${UNQID}" name="Calculate">Calculate</button>	
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
</div>

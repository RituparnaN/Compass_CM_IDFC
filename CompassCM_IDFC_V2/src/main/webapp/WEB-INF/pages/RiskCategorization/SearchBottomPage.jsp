<%@ page language="java" contentType="text/html;charset=UTF-8"
	pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../tags/tags.jsp"%>
<script type="text/javascript">
	$(document).ready(function() {
		var id = '${UNQID}';
		compassTopFrame.init(id, 'compassRiskAssignmentSearchTable'+id, 'dd/mm/yy');

		$('.panelSlidingRiskAssignment'+id).on("click", function (e) {
			var mainRow = $(this).parents(".compassrow"+id);
			compassTopFrame.searchPanelSliding(id, mainRow, 'riskAssignmentSerachResultPanel');
	    });
		
		$("#updateParameterList"+id).click(function(){
			var fullData = "";
			$(".compassParameterListSearchTable").children("tbody").children("tr").each(function(){
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
				url: "${pageContext.request.contextPath}/admin/saveParameterList",
				cache: false,
				type: "POST",
				data: "strRiskParameters="+fullData+"&id="+id,
				success: function(res){
					alert("Updated Successfully");
					$("#riskCategorizationBottomFrame").html(res);
				},
				error: function(a,b,c){
					alert(a+b+c);
				}
			});
		});
	
		$("#searchRiskAssignment"+id).click(function(){
			var mainRow = $(this).parents("div.compassrow"+id);
			var slidingDiv = $(mainRow).children().children().children();
			var panelBody = $(mainRow).children().children().find(".panelSearchForm");
			var searchParamId = $("#parameterId"+id).val();
			var isRangeRequired = $("#parameterId"+id).find("option[value='"+searchParamId+"']").attr("isRangeRequired");
			var searchButtonId = "searchRiskAssignment"+id;
			console.log(searchButtonId);
			$.ajax({
				url: "${pageContext.request.contextPath}/admin/searchRiskAssignment",
				cache: false,
				type: "POST",
				data: "searchParamId="+searchParamId+"&id="+id+"&isRangeRequired="+isRangeRequired+"&searchButtonId="+searchButtonId,
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
		
		$("#updateRiskAssignmentValue"+id).click(function(){
			var paramId = $("#parameterId"+id).val();
			var table = $("#riskAssignmentSerachResult"+id).find("table.compassRiskAssignmentResultTable");
			var fullData = "";
			$(table).children("tbody").children("tr").each(function(){
				var paramCode = $(this).children("td:first-child").html();
				var paramRiskValue = $(this).children("td:nth-child(3)").children("select").val();
				var priorityRiskValue = $(this).children("td:nth-child(4)").children("select").val();
				//console.log(paramCode+" = "+paramRiskValue);
				fullData = fullData +paramCode+"="+paramRiskValue+"~"+priorityRiskValue+",";
				//debugger;
			});
			$.ajax({
				url: "${pageContext.request.contextPath}/admin/updateRiskAssignmentValue",
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
		
		$("#addRiskAssignmentValue"+id).click(function(){
			var paramId = $("#parameterId"+id).val();
			var searchButtonId = "searchRiskAssignment"+id;
			console.log(searchButtonId);
			
			$.ajax({
				url: "${pageContext.request.contextPath}/admin/fetchParamIdToAddNewRiskParameter",
				cache: false,
				type: "POST",
				data: "paramId="+paramId+"&isNew=Y"+"&searchButtonId="+searchButtonId,
				success: function(res){
					$("#compassCaseWorkFlowGenericModal").modal("show");
					$("#compassCaseWorkFlowGenericModal-title").html("Risk Parameter Details");
					$("#compassCaseWorkFlowGenericModal-body").html(res);
				},
				error: function(a,b,c){
					alert(a+b+c);
				}
			});

		});
		
		$("#updateParameterWeightageList"+id).click(function(){
			var fullData = " ";
			$(".compassRiskCalculationSearchTable").children("tbody").children("tr").each(function(){
				var paramId = $(this).children("td:first-child").html();
				var paramWeightage = $(this).children("td:nth-child(3)").children("select").val();
				fullData = fullData + paramId+"="+paramWeightage+",";
			});
			$.ajax({
				url: "${pageContext.request.contextPath}/admin/updateParameterWeightageList",
				cache: false,
				type: "POST",
				data: "strParameters="+fullData,
				success: function(res){
					alert(res);
				},
				error: function(a,b,c){
					alert(a+b+c);
				}
			});
		});
		
		$("#calculateRisk"+id).click(function(){
			var btn = $(this);
			var btnMsg = $(btn).html();
			$(btn).html("Calculating...");
			$(btn).attr("disabled",true);
			$.ajax({
				url: "${pageContext.request.contextPath}/admin/calculateRisk",
				cache: false,
				type: "POST",
				success: function(res){		
					alert("Risk calculated successfully.");
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
<div role="tabpanel" class="tab-pane active" id="RP" >
	<div class="row">
	    <div class="col-sm-12">
		<div class="card card-primary panel_parameterListBottomFrame" style="margin-bottom: 0px;">
		 <div class="panelSearchForm">
			<table class="table table-bordered table-striped compassParameterListSearchTable" style="margin-bottom: 0px;">
				<thead>
					<tr>
						<th style="text-align: center;" class="info"><input type="checkbox"></th>
						<th class="info">Parameter Id</th>
						<th class="info">Parameter Name</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="parameterList" items="${RESULTLIST}">
						<tr>
							<td style="text-align: center;">
								<input type="checkbox" id="${parameterList['RISKPARAMETERID']}" <c:if test="${parameterList['ISRISKPARAMETERMARKED'] eq 'Y'}">checked="checked"</c:if> >
							</td>
							<td>${parameterList['RISKPARAMETERID']}</td>
							<td>${parameterList['RISKPARAMETERNAME']}</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
			<div class="card-footer clearfix">
					<div class="pull-${dirR}">
						<input type="button" id="updateParameterList${UNQID}" class="btn btn-success btn-sm" name="Update" value="Update"/>
					</div>
			</div>
		</div>
	   </div>
	   </div>
	</div>
</div>

<div role="tabpanel" class="tab-pane" id="RA">
	<div class="row">
		<div class="col-sm-12">
			<div class="card card-default" style="margin-bottom: 0px;">
				<div class="row compassrow${UNQID}">
					<div class="col-sm-12">
						<div class="card card-primary panel_riskAssignment" style="margin-bottom: 0px; margin-top: 2px;">
							<div class="card-header panelSlidingRiskAssignment${UNQID} clearfix">
								<h6 class="card-title pull-${dirL}">Risk Assignment</h6>
									<div class="btn-group pull-${dirR} clearfix">
										<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
									</div>
							</div>
							<div class="panelSearchForm">
								<table class="table compassRiskAssignmentSearchTable" style="margin-bottom: 0px;">
									<tr>
										<td width="15%">Parameter Id</td>
										<td width="30%">
											<select class="form-control input-sm" name="parameterId" id="parameterId${UNQID}">
												<c:forEach var="parameterList" items="${RESULTLIST}">
													<c:if test="${parameterList['ISRISKPARAMETERMARKED'] eq 'Y'}">
														<option isRangeRequired="${parameterList['ISFROMTOREQ']}" value="${parameterList['RISKPARAMETERID']}">${parameterList['RISKPARAMETERNAME']}</option>
													</c:if>
												</c:forEach>
											</select> 
										</td>
										<td width="55%">&nbsp;</td>
									</tr>
								</table>
								<div class="card-footer clearfix">
									<div class="pull-${dirR}">
										<input type="button" id="searchRiskAssignment${UNQID}" class="btn btn-primary btn-sm" name="Search" value="Search">
									</div>
								</div>
							</div>
						</div>
					</div>
					<div class="col-sm-12">
						<div class="card card-primary" id="riskAssignmentSerachResultPanel${UNQID}" style="margin-top: 10px; margin-bottom: 0px; display: none;">
							<div class="card-header panelSlidingRiskAssignment${UNQID} clearfix">
								<h6 class="card-title pull-${dirL}">Update Risk Value</h6>
							<div class="btn-group pull-${dirR} clearfix">
								<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
							</div>
							</div>
							<div id="riskAssignmentSerachResult${UNQID}"></div>
							<div class="card-footer clearfix">
								<div class="pull-${dirR}">
									<button type="button" class="btn btn-success btn-sm" id="addRiskAssignmentValue${UNQID}" name="Add">Add</button>
									<button type="button" class="btn btn-success btn-sm" id="updateRiskAssignmentValue${UNQID}" name="Update">Update</button>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>

<div role="tabpanel" class="tab-pane" id="RC">
	<div class="row">
	    <div class="col-sm-12">
		<div class="card card-primary panel_parameterListBottomFrame" style="margin-bottom: 0px;">
		 <div class="panelSearchForm">
			<table class="table table-bordered table-striped compassRiskCalculationSearchTable" style="margin-bottom: 0px;">
				<thead>
					<tr>
						<th class="info">Parameter Id </th>
						<th class="info">Parameter Name</th>
						<th class="info">Weightage</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="parameterList" items="${RESULTLIST}">
						<tr>
							<td>${parameterList['RISKPARAMETERID']}</td>
							<td>${parameterList['RISKPARAMETERNAME']}</td>
							<td>
								<select class="form-control input-sm" style="width: 50%" <c:if test="${parameterList['ISRISKPARAMETERMARKED'] ne 'Y'}">disabled="disabled"</c:if>>
									<option value="1" <c:if test="${parameterList['RISKPARAMETERWEIGHTAGE'] eq '1'}">selected="selected"</c:if>>1</option>
									<option value="2" <c:if test="${parameterList['RISKPARAMETERWEIGHTAGE'] eq '2'}">selected="selected"</c:if>>2</option>
									<option value="3" <c:if test="${parameterList['RISKPARAMETERWEIGHTAGE'] eq '3'}">selected="selected"</c:if>>3</option>
									<option value="4" <c:if test="${parameterList['RISKPARAMETERWEIGHTAGE'] eq '4'}">selected="selected"</c:if>>4</option>
									<option value="5" <c:if test="${parameterList['RISKPARAMETERWEIGHTAGE'] eq '5'}">selected="selected"</c:if>>5</option>
								</select>
							</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
			<div class="card-footer clearfix">
					<div class="pull-${dirR}">
						<input type="button" id="updateParameterWeightageList${UNQID}" class="btn btn-success btn-sm" name="Update" value="Update"/>
						<button type="button" id="calculateRisk${UNQID}" class="btn btn-primary btn-sm" name="CalculateRisk">Calculate Risk</button>
					</div>
			</div>
		</div>
	   </div>
	   </div>
	</div>
</div>

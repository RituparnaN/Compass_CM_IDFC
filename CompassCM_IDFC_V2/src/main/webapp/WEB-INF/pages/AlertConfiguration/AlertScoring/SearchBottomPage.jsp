<%@ page language="java" contentType="text/html;charset=UTF-8"
	pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../../tags/tags.jsp"%>
<script type="text/javascript">
	$(document).ready(function() {
		var id = '${UNQID}';
		$(".compassrow"+id).find("select").select2();
		
		compassTopFrame.init(id, 'compassAlertScoreAssignmentSearchTable'+id, 'dd/mm/yy');
		compassDatatable.enableCheckBoxSelection();

		$('.panelSlidingAlertScoreAssignment'+id).on("click", function (e) {
			var mainRow = $(this).parents(".compassrow"+id);
			compassTopFrame.searchPanelSliding(id, mainRow, 'alertScoreAssignmentSerachResultPanel');
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
				url: "${pageContext.request.contextPath}/admin/saveAlertParameterList",
				cache: false,
				type: "POST",
				data: "strAlertParameters="+fullData+"&id="+id,
				success: function(res){
					alert("Updated Successfully");
					$("#alertScoringBottomFrame").html(res);
					$(checkbox).prop("checked");
				},
				error: function(a,b,c){
					alert(a+b+c);
				}
			});
		});
		
		$("#calculateAlertScore"+id).click(function(){
			var btn = $(this);
			var btnMsg = $(btn).html();
			$(btn).html("Calculating...");
			$(btn).attr("disabled",true);
			$.ajax({
				url: "${pageContext.request.contextPath}/admin/calculateAlertScore",
				cache: false,
				type: "POST",
				success: function(res){		
					alert("Alert Score calculated successfully.");
					$(btn).html(btnMsg);
					$(btn).removeAttr("disabled");
				},
				error: function(a,b,c){
					alert(a+b+c);
				}
			});
		});
	
		$("#searchAlertScoreAssignment"+id).click(function(){
			var mainRow = $(this).parents("div.compassrow"+id);
			var slidingDiv = $(mainRow).children().children().children();
			var panelBody = $(mainRow).children().children().find(".panelSearchForm");
			var searchParamId = $("#parameterId"+id).val();

			$.ajax({
				url: "${pageContext.request.contextPath}/admin/searchAlertScoreAssignment",
				cache: false,
				type: "POST",
				data: "searchParamId="+searchParamId+"&id="+id,
				success: function(res){
					$("#alertScoreAssignmentSerachResultPanel"+id).css("display", "block");
					$("#alertScoreAssignmentSerachResult"+id).html(res);
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
		
		$("#updateAlertScoreAssignmentValue"+id).click(function(){
			var paramId = $("#parameterId"+id).val();
			var table = $("#alertScoreAssignmentSerachResult"+id).find("table");
			var fullData = "";
			$(table).children("tbody").children("tr").each(function(){
				var paramCode = $(this).children("td:first-child").html();
				var paramScoreValue = $(this).children("td:nth-child(3)").children("select").val();
				fullData = fullData +paramCode+"="+paramScoreValue+",";
			});
			
			$.ajax({
				url: "${pageContext.request.contextPath}/admin/updateAlertScoreAssignmentValue",
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
						<th style="text-align: center;" class="info">
							<input type="checkbox"  class="checkbox-check-all" compassTable="compassParameterListSearchTable" >
						</th>
						<th class="info">Parameter Id</th>
						<th class="info">Parameter Name</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="parameterList" items="${RESULTLIST}">
						<tr>
							<td style="text-align: center;">
								<input type="checkbox" id="${parameterList['PARAMID']}" <c:if test="${parameterList['PARAM_FLAG'] eq 'Y'}">checked="checked"</c:if> >
							</td>
							<td>${parameterList['PARAMID']}</td>
							<td>${parameterList['PARAMNAME']}</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
			<div class="card-footer clearfix">
					<div class="pull-${dirR}">
						<input type="button" id="updateParameterList${UNQID}" class="btn btn-success btn-sm" name="Update" value="Update"/>
						<button type="button" id="calculateAlertScore${UNQID}" class="btn btn-primary btn-sm" name="CalculateScore">Calculate Score</button>
						
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
						<div class="card card-primary panel_alertScoreAssignment" style="margin-bottom: 0px; margin-top: 2px;">
							<div class="card-header panelSlidingAlertScoreAssignment${UNQID} clearfix">
								<h6 class="card-title pull-${dirL}">Alert Score Assignment</h6>
									<div class="btn-group pull-${dirR} clearfix">
										<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
									</div>
							</div>
							<div class="panelSearchForm">
								<table class="table compassAlertScoreAssignmentSearchTable" style="margin-bottom: 0px;">
									<tr>
										<td width="15%">Parameter Id</td>
										<td width="85%">
											<select class="form-control input-sm" name="parameterId" id="parameterId${UNQID}" style="width: 100%;">
												<c:forEach var="parameterList" items="${RESULTLIST}">
													<c:if test="${parameterList['PARAM_FLAG'] eq 'Y'}">
														<option value="${parameterList['PARAMID']}">${parameterList['PARAMNAME']}</option>
													</c:if>
												</c:forEach>
											</select> 
										</td>
										<!-- <td width="55%">&nbsp;</td> -->
									</tr>
								</table>
								<div class="card-footer clearfix">
									<div class="pull-${dirR}">
										<input type="button" id="searchAlertScoreAssignment${UNQID}" class="btn btn-primary btn-sm" name="Search" value="Search">
									</div>
								</div>
							</div>
						</div>
					</div>
					<div class="col-sm-12">
						<div class="card card-primary" id="alertScoreAssignmentSerachResultPanel${UNQID}" style="margin-top: 10px; margin-bottom: 0px; display: none;">
							<div class="card-header panelSlidingAlertScoreAssignment${UNQID} clearfix">
								<h6 class="card-title pull-${dirL}">Update Score Value</h6>
							<div class="btn-group pull-${dirR} clearfix">
								<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
							</div>
							</div>
							<div id="alertScoreAssignmentSerachResult${UNQID}"></div>
							<div class="card-footer clearfix">
								<div class="pull-${dirR}">
									<button type="button" class="btn btn-success btn-sm" id="updateAlertScoreAssignmentValue${UNQID}" name="Update">Update</button>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
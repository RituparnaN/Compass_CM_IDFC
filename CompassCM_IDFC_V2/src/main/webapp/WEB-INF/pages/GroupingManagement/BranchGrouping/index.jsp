<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../../tags/tags.jsp"%>
<script type="text/javascript">
	$(document).ready(function() {
		var id = '${UNQID}';
		
  		compassTopFrame.init(id, 'compassBranchGroupSearchTable'+id, 'dd/mm/yy');
		
		$('.panelSlidingBranchGrouping'+id).on("click", function (e) {
			var mainRow = $(this).parents(".compassrow"+id);
			compassTopFrame.searchPanelSliding(id, mainRow, 'branchGroupingSerachResultPanel');
	    });
				
		$("#createBranchGrouping"+id).click(function(){
			var groupCode = $("#groupCode"+id).val();
			var groupName = $("#groupName"+id).val();
			var description = $("#description"+id).val();
			var riskRating = $("#riskRating"+id).val();
			var fullData = "groupCode="+groupCode+"&groupName="+groupName+"&description="+description+"&riskRating="+riskRating;
			var mainRow = $(this).parents(".compassrow"+id);
			var slidingDiv = $(mainRow).children().children().children();
			var panelBody = $(mainRow).children().children().find(".panelSearchForm");
			
			if(groupCode != ''&& groupName != '' && riskRating != ''){
				if(confirm("Confirm creation")){
					$.ajax({
						url: "${pageContext.request.contextPath}/common/createBranchGrouping",
						cache: false,
						type: "POST",
						data: fullData,
						success: function(res){
							$("#branchGroupingSerachResultPanel"+id).css("display", "block");
							$("#branchGroupingSerachResult"+id).html(res);
							$(panelBody).slideUp();
							$(slidingDiv).addClass('card-collapsed');
							$(slidingDiv).find('i.collapsable').removeClass('fa-chevron-up').addClass('fa-chevron-down');
							$(mainRow).next().find(".compassrow"+id).find(".card-header").next().slideDown();
							$("#clearBranchGrouping"+id).click();
						},
						error: function(a,b,c){
							alert(a+b+c);
						}
					});
				}
			}else
				alert("Enter Group Code, Group Name and Risk Rating.");
		});
		$("#searchBranchGrouping"+id).click(function(){
			var groupCode = $("#groupCode"+id).val();
			var groupName = $("#groupName"+id).val();
			var description = $("#description"+id).val();
			var riskRating = $("#riskRating"+id).val();
			var fullData = "groupCode="+groupCode+"&groupName="+groupName+"&description="+description+"&riskRating="+riskRating;
			var mainRow = $(this).parents(".compassrow"+id);
			var slidingDiv = $(mainRow).children().children().children();
			var panelBody = $(mainRow).children().children().find(".panelSearchForm");
					
			$.ajax({
				url: "${pageContext.request.contextPath}/common/searchBranchGrouping",
				cache: false,
				type: "POST",
				data: fullData,
				success: function(res) {
					$("#branchGroupingSerachResultPanel"+id).css("display", "block");
					$("#branchGroupingSerachResult"+id).html(res);
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
		
		$("#deletebranchGrouping"+id).click(function(){
			var table = $("#branchGroupingSerachResult"+id).find("table").children("tbody");
			var groupCodeToDelete = "";
			var selectedCount = 0;
			$(table).children("tr").each(function(){
				var checkbox = $(this).children("td:first-child").children("input");
				var groupCode = $(this).children("td:nth-child(2)").children("a").html();
				if($(checkbox).prop("checked")){
					groupCodeToDelete = groupCodeToDelete + groupCode+",";
					selectedCount++;
				}
			});
			
			if(selectedCount > 0){
				if(confirm("Are you sure?")){
					$.ajax({
						url: "${pageContext.request.contextPath}/common/deleteBranchGrouping",
						cache: false,
						type: "POST",
						data: "groupCodeToDelete="+groupCodeToDelete,
						success: function(res) {
							alert(res);
							$("#searchBranchGrouping"+id).click();
						},
						error: function(a,b,c) {
							alert(a+b+c);
						}
					});
				}
			}else
				alert("Select atleast one record");
		
		});
		
	});
</script>
<div class="row compassrow${UNQID}">
	<div class="col-sm-12">
		<div class="card card-primary panel_branchGrouping">
			<div class="card-header panelSlidingBranchGrouping${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}"><spring:message code="app.common.branchGroupingHeader"/></h6>
				<div class="btn-group pull-${dirR} clearfix">
					<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
				</div>
			</div>
			<div class="panelSearchForm">
			<form action="javascript:void(0)" method="POST" id="searchMasterForm${UNQID}">
				<table class="table compassBranchGroupSearchTable" style="margin-bottom: 0px;">
					<tr>
						<td width="15%">Group Code</td>
						<td width="30%"><input type="text" class="form-control input-sm" name="groupCode" id="groupCode${UNQID}"/></td>
						<td width="10%">&nbsp;</td>
						<td width="15%">Group Name</td>
						<td width="30%"><input type="text" class="form-control input-sm" name="groupName" id="groupName${UNQID}"/></td>
					</tr>
					<tr>	
						<td width="15%">Description</td>
						<td width="30%"><textarea class="form-control input-sm" name="description" id="description${UNQID}"></textarea></td>
						<td width="10%">&nbsp;</td>
						<td width="15%">Risk Rating</td>
						<td width="30%">
							<select class="form-control input-sm" name="riskRating" id="riskRating${UNQID}">
								<option value="">All</option>
								<option value="1">Low</option>
								<option value="2">Medium</option>
								<option value="3">High</option>
							</select> 
						</td>
					</tr>
				</table>
				<div class="card-footer clearfix">
					<div class="pull-${dirR}">
						<input type="button" id="createBranchGrouping${UNQID}" class="btn btn-primary btn-sm" name="Create" value="Create">
						<button type="button" id="searchBranchGrouping${UNQID}" class="btn btn-success btn-sm"><spring:message code="app.common.searchButton"/></button>
						<input type="reset" class="btn btn-danger btn-sm" id="clearBranchGrouping${UNQID}" name="Clear" value="Clear"/>
					</div>
				</div>
			</form>
			</div>
		</div>
		<div class="card card-primary" id="branchGroupingSerachResultPanel${UNQID}" style="display: none;">
			<div class="card-header panelSlidingBranchGrouping${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}"><spring:message code="app.common.branchGroupingResultHeader"/></h6>
				<div class="btn-group pull-${dirR} clearfix">
					<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
				</div>
			</div>
			<div id="branchGroupingSerachResult${UNQID}"></div>
			<div class="card-footer clearfix">
				<div class="pull-${dirR}">
					<input type="button" class="btn btn-danger btn-sm" id="deletebranchGrouping${UNQID}" name="Delete" value="Delete"/>
				</div>
			</div>
		</div>
	</div>
</div>
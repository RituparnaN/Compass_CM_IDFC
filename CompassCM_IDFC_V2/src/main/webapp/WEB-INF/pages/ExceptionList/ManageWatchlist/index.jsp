<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../../tags/tags.jsp"%>
<script type="text/javascript">
	$(document).ready(function() {
		var id = '${UNQID}';
		
		$('.panelSlidingManageWatchlist'+id).on("click", function (e) {
			var mainRow = $(this).parents(".compassrow"+id);
			compassTopFrame.searchPanelSliding(id, mainRow, 'manageWatchlistSerachResultPanel');
	    });
		
		$('#deleteWatchlist'+id).click(function(){
			var table = $("#manageWatchlistSerachResult"+id).find("table").children("tbody");
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
						url: "${pageContext.request.contextPath}/common/deleteWatchlist",
						cache: false,
						type: "POST",
						data: "listCodeToDelete="+listCodeToDelete,
						success: function(res) {
							alert(res);
							$("#searchManageWatchlistTable"+id).click();
						},
						error: function(a,b,c) {
							alert(a+b+c);
						}
					});
				}
			}else
				alert("Select atleast one record");
		});
			
		$("#searchManageWatchlistTable"+id).click(function(){
			var listCode = $("#listCode"+id).val();
			var listName = $("#listName"+id).val();
			var description = $("#description"+id).val();
			var riskRating = $("#riskRating"+id).val();
			var fullData = "listCode="+listCode+"&listName="+listName+"&description="+description+"&riskRating="+riskRating;
			
			var mainRow = $(this).parents("div.compassrow"+id);
			var slidingDiv = $(mainRow).children().children().children();
			var panelBody = $(mainRow).children().children().find(".panelSearchForm");
			
			$.ajax({
				url: "${pageContext.request.contextPath}/common/searchManageWatchlist",
				cache: false,
				type: "POST",
				data: fullData,
				success: function(res) {
					$("#manageWatchlistSerachResultPanel"+id).css("display", "block");
					$("#manageWatchlistSerachResult"+id).html(res);
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
		
		$("#createWatchlist"+id).click(function(){
			var listCode = $("#listCode"+id).val();
			var listName = $("#listName"+id).val();
			var description = $("#description"+id).val();
			var riskRating = $("#riskRating"+id).val();
			var fullData = "listCode="+listCode+"&listName="+listName+"&description="+description+"&riskRating="+riskRating;
			var mainRow = $(this).parents("div.compassrow"+id);
			var slidingDiv = $(mainRow).children().children().children();
			var panelBody = $(mainRow).children().children().find(".panelSearchForm");
			
			if(listCode != ''&& listName != '' && riskRating != '' ){
				if(confirm("Confirm creation")){
					$.ajax({
						url: "${pageContext.request.contextPath}/common/createWatchlist",
						cache: false,
						type: "POST",
						data: fullData,
						success: function(res){
							$("#manageWatchlistSerachResultPanel"+id).css("display", "block");
							$("#manageWatchlistSerachResult"+id).html(res);
							$(panelBody).slideUp();
							$(slidingDiv).addClass('card-collapsed');
							$(slidingDiv).find('i.collapsable').removeClass('fa-chevron-up').addClass('fa-chevron-down');
							$(mainRow).next().find(".compassrow"+id).find(".card-header").next().slideDown();
						},
						error: function(a,b,c){
							alert(a+b+c);
						}
					});
				}
			}else
				alert('Enter ListCode, ListName and RiskRating');
		});
		
		$("#updateWatchlist"+id).click(function(){
			var searchButton = "searchManageWatchlistTable${UNQID}";
			var table = $("#manageWatchlistSerachResult"+id).find("table").children("tbody");
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
				alert("You can update only one watchlist at a time.");
			else{
				$("#compassCaseWorkFlowGenericModal").modal("show");
				$("#compassCaseWorkFlowGenericModal-title").html("Update Watchlist");
				$.ajax({
					url: "${pageContext.request.contextPath}/common/fetchWatchlistForUpdate",
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
	});
</script>
<div class="row compassrow${UNQID}">
	<div class="col-sm-12">
		<div class="card card-primary panel_manageWatchlist">
			<div class="card-header panelSlidingManageWatchlist${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}"><spring:message code="app.common.watchlistSearchHeader"/></h6>
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
						<td width="15%">List Name</td>
						<td width="30%"><input type="text" class="form-control input-sm" name="listName" id="listName${UNQID}"/></td>
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
						<input type="button" id="createWatchlist${UNQID}" class="btn btn-primary btn-sm" name="Create" value="Create">
						<button type="button" id="searchManageWatchlistTable${UNQID}" class="btn btn-success btn-sm"><spring:message code="app.common.searchButton"/></button>
						<input type="reset" class="btn btn-danger btn-sm" id="clearWatchlist${UNQID}" name="Clear" value="Clear"/>
					</div>
				</div>
			</form>
			</div>
		</div>
		<div class="card card-primary" id="manageWatchlistSerachResultPanel${UNQID}" style="display: none;">
			<div class="card-header panelSlidingManageWatchlist${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}"><spring:message code="app.common.watchlistResultHeader"/></h6>
				<div class="btn-group pull-${dirR} clearfix">
					<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
				</div>
			</div>
			<div id="manageWatchlistSerachResult${UNQID}"></div>
			<div class="card-footer clearfix">
				<div class="pull-${dirR}">
				<input type="button" class="btn btn-primary btn-sm" id="updateWatchlist${UNQID}" name="Update" value="Update"/>
					<input type="button" class="btn btn-danger btn-sm" id="deleteWatchlist${UNQID}" name="Delete" value="Delete"/>
				</div>
			</div>
		</div>
	</div>
</div>
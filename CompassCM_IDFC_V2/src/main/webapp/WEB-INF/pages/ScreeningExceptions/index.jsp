<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../tags/tags.jsp"%>
<script type="text/javascript">
	$(document).ready(function() {
		var id = '${UNQID}';
		compassTopFrame.init(id, 'compassModuleDetailsSearchTable'+id, 'dd/mm/yy');
		
		$('.panelSlidingScreeningException'+id).on("click", function (e) {
			var mainRow = $(this).parents(".compassrow"+id);
			compassTopFrame.searchPanelSliding(id, mainRow, 'screeningExceptionsSerachResultPanel');
	    });
		
		$("#addScreeningException"+id).click(function(){
			var custId = $("#custId"+id).val();
			var custName = $("#custName"+id).val();
			var matchedList = $("#matchedList"+id).val();
			var matchedEntity = $("#matchedEntity"+id).val();
			var isEnabled = $("#isEnabled"+id).val();
			var listId = $("#listId"+id).val();
			var reason = $("#reason"+id).val();
			var fullData = "custId="+custId+"&custName="+custName+"&matchedList="+matchedList+
						   "&matchedEntity="+matchedEntity+"&isEnabled="+isEnabled+"&listId="+listId+"&reason="+reason;
			var mainRow = $(this).parents("div.compassrow"+id);
			var slidingDiv = $(mainRow).children().children().children();
			var panelBody = $(mainRow).children().children().find(".panelSearchForm");
			if(custId != '' && custName != '' && matchedList != '' && matchedEntity != '' &&
					isEnabled != '' && listId != '' ){
				if(confirm("Confirm adding")){
					$.ajax({
						url: "${pageContext.request.contextPath}/admin/addScreeningException",
						cache: false,
						type: "POST",
						data: fullData,
						success: function(res) {
							$("#screeningExceptionsSerachResultPanel"+id).css("display", "block");
							$("#screeningExceptionsSerachResult"+id).html(res);
							$(panelBody).slideUp();
							$(slidingDiv).addClass('card-collapsed');
							$(slidingDiv).find('i.collapsable').removeClass('fa-chevron-up').addClass('fa-chevron-down');
							$(mainRow).next().find(".compassrow"+id).find(".card-header").next().slideDown();
						},
						error: function(a,b,c) {
							alert(a+b+c);
						}
					});
			      }
			 }else
				 alert("Enter all the fields data.");
		});
		
		$("#searchScreeningExceptions"+id).click(function(){
			var custId = $("#custId"+id).val();
			var custName = $("#custName"+id).val();
			var matchedList = $("#matchedList"+id).val();
			var matchedEntity = $("#matchedEntity"+id).val();
			var isEnabled = $("#isEnabled"+id).val();
			var listId = $("#listId"+id).val();
			var reason = $("#reason"+id).val();
			var fullData = "custId="+custId+"&custName="+custName+"&matchedList="+matchedList+
						   "&matchedEntity="+matchedEntity+"&isEnabled="+isEnabled+"&listId="+listId+"&reason="+reason;
			var mainRow = $(this).parents("div.compassrow"+id);
			var slidingDiv = $(mainRow).children().children().children();
			var panelBody = $(mainRow).children().children().find(".panelSearchForm");
			
			$.ajax({
				url: "${pageContext.request.contextPath}/admin/searchScreeningExceptions",
				cache: false,
				type: "POST",
				data: fullData,
				success: function(res) {
					$("#screeningExceptionsSerachResultPanel"+id).css("display", "block");
					$("#screeningExceptionsSerachResult"+id).html(res);
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
		
		$("#updateScreeningException"+id).click(function(){
			var searchButton = "searchScreeningExceptions${UNQID}"; 
			var table = $("#screeningExceptionsSerachResult"+id).find("table").children("tbody");
			var selectedCustId = "";	
			var selectedCustName = "";
			var selectedMatchedEntity = "";
			var selectedCount = 0;
			$(table).children("tr").each(function(){
				var checkbox = $(this).children("td:first-child").children("input");
				var custId = $(this).children("td:nth-child(2)").html();
				var custName = $(this).children("td:nth-child(3)").html();
				var matchedEntity = $(this).children("td:nth-child(5)").html();
				if($(checkbox).prop("checked")){
					selectedCustId = custId;
					selectedMatchedEntity = matchedEntity;
					selectedCustName = custName;
					selectedCount++;
				}
			});
			if(selectedCount > 1 || selectedCount == 0){
				alert("Select one record at a time to update.");
			}else{
				$("#compassCaseWorkFlowGenericModal").modal("show");
				$("#compassCaseWorkFlowGenericModal-title").html("Update To Whitelist");
				$.ajax({
					url: "${pageContext.request.contextPath}/admin/fetchScreeningExceptionToUpdate",
					cache: false,
					type: "POST",
					data: "selectedCustId="+selectedCustId+"&selectedMatchedEntity="+selectedMatchedEntity+
						  "&selectedCustName="+selectedCustName+"&searchButton="+searchButton,
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
		<div class="card card-primary panel_screeningExceptions">
			<div class="card-header panelSlidingScreeningException${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}"><spring:message code="app.common.screeningExceptionsSearchHeader"/></h6>
				<div class="btn-group pull-${dirR} clearfix">
					<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
				</div>
			</div>
			<div class="panelSearchForm">
			<form action="javascript:void(0)" method="POST" id="searchMasterForm${UNQID}">
				<table class="table compassModuleDetailsSearchTable${UNQID}" style="margin-bottom: 0px;">
					<tr>
						<td width="15%">Customer Id</td>
							<td width="30%">
								<div class="input-group" style="z-index: 1">
									<input type="text" class="form-control input-sm" name="custId" id="custId${UNQID}"/>
									<span class="input-group-addon formSearchIcon" id="basic-addon${UNQID}" 
										onclick="compassTopFrame.moduleSearch('custId${UNQID}','CUSTOMERID','VW_CUSTOMERID_SEARCH','N','${pageContext.request.contextPath}')" style="cursor: pointer;" title="Search">
										<i class="fa fa-search"></i>
									</span>
								</div>
							</td>
						<td width="10%">&nbsp;</td>
						<td width="15%">Customer Name</td>
						<td width="30%">
							<input type="text" class="form-control input-sm" name="custName" id="custName${UNQID}"/>	
						</td>
					</tr>
					<tr>	
						<td width="15%">Matched List</td>
						<td width="30%">
							<select class="form-control input-sm" name="matchedList" id="matchedList${UNQID}">
								<option value="ALL">ALL</option>
								<c:forEach var="matchedList" items="${MATCHEDLIST}">
									<option value="${matchedList.key}">${matchedList.value}</option>
								</c:forEach>
							</select>
						</td>
						<td width="10%">&nbsp;</td>
						<td width="15%">Matched Entity</td>
						<td width="30%"><input type="text" class="form-control input-sm" name="matchedEntity" id="matchedEntity${UNQID}"/></td>
					</tr>
					<tr>	
						<td width="15%">Is Enabled</td>
						<td width="30%">
							<select class="form-control input-sm" name="isEnabled" id="isEnabled${UNQID}">
								<option value=""></option>
								<option value="Y">Yes</option>
								<option value="N">No</option>
							</select>
						</td>
						<td width="10%">&nbsp;</td>
						<td width="15%">List Id</td>
						<td width="30%">
							<input type="text" class="form-control input-sm" name="listId" id="listId${UNQID}" /></td>
					</tr>
					<tr>
						<td width="15%">Reason</td>
						<td width="30%"><textarea class="form-control input-sm" name="reason" id="reason${UNQID}"></textarea></td>
						<td colspan="3">&nbsp;</td>
					</tr>
				</table>
				<div class="card-footer clearfix">
					<div class="pull-${dirR}">
						<input type="button" id="addScreeningException${UNQID}" class="btn btn-primary btn-sm" name="Add" value="Add">
						<button type="button" id="searchScreeningExceptions${UNQID}" class="btn btn-success btn-sm" name="Search" value="Search">Search</button>
						<input type="reset" class="btn btn-danger btn-sm" id="clearScreeningException${UNQID}" name="Clear" value="Clear"/>
					</div>
				</div>
			</form>
			</div>
		</div>
		<div class="card card-primary" id="screeningExceptionsSerachResultPanel${UNQID}" style="display: none;">
			<div class="card-header panelSlidingScreeningException${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}"><spring:message code="app.common.screeningExceptionsResultHeader"/></h6>
				<div class="btn-group pull-${dirR} clearfix">
					<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
				</div>
			</div>
			<div id="screeningExceptionsSerachResult${UNQID}"></div>
			<div class="card-footer clearfix">
				<div class="pull-${dirR}">
				<input type="button" class="btn btn-primary btn-sm" id="updateScreeningException${UNQID}" name="Update" value="Update"/>
				</div>
			</div>
		</div>
	</div>
</div>
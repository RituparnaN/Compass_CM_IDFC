<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../../tags/tags.jsp"%>
<script type="text/javascript">
	var id;
	$(document).ready(function() {
		id = '${UNQID}';
		compassTopFrame.init(id, 'exceptionListDetailsTable'+id, 'dd/mm/yy');
		
		$('.panelSlidingListDetails'+id).on("click", function (e) {
			var mainRow = $(this).parents(".compassrow"+id);
			compassTopFrame.searchPanelSliding(id, mainRow, 'listDetailsSerachResultPanel');
	    });
		
		var tableClass = 'exceptionListDetailsTable';
		compassDatatable.construct(tableClass, "exceptionListDetailsTable", true);
		compassDatatable.enableCheckBoxSelection();	
		
		
	});
	
	function fetchListRecords(elm, listId, isFileUploadEnabled){
		var mainRow = $(elm).parents("div.compassrow"+id);
		var slidingDiv = $(mainRow).children().children().children();
		var panelBody = $(mainRow).children().children().find(".panelSearchForm");
		
		$.ajax({
			url: "${pageContext.request.contextPath}/common/getExceptionListRecords" ,
			cache: false,
			data: "listCode="+listId+"&id="+id+"&isFileUploadEnabled="+isFileUploadEnabled,
			type: "POST",
			success: function(res){
				$("#listDetailsSerachResultPanel"+id).css("display", "block");
				$("#listDetailsSerachResult"+id).html(res);
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
	
</script>
<style type="text/css">
	.listCodeLink{
		text-decoration: underline;
		color: blue;
		cursor: pointer;
	}
</style>
<div class="row compassrow${UNQID}">
	<div class="col-sm-12">
		<div class="card card-primary panel_listDetails" >
			<div class="card-header panelSlidingListDetails${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}">Exception List</h6>
				<div class="btn-group pull-${dirR} clearfix">
					<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
				</div>
			</div>
			<div class="panelSearchForm">
			<form action="javascript:void(0)" method="POST" id="searchMasterForm${UNQID}">
				<table class="table exceptionListDetailsTable${UNQID} table-striped table-bordered" style="margin-bottom: 0px; text-align: center;">
					<thead>
					<tr style=" font-weight: bold;">
						<td width="20%" class="info">List Code</td>
						<td width="20%" class="info">List Name</td>
						<td width="45%" class="info">List Description</td>
						<td width="15%" class="info">List Type</td>
					</tr>
					</thead>
					<tbody>
						<c:forEach var="record" items="${RESULT}">
						<tr>
							<td class = "listCodeLink" onclick="fetchListRecords(this, '${record['LISTCODE']}', '${record['ISFILEUPLOADENABLED']}')">${record['LISTCODE']}</td>
							<td>${record['LISTNAME']}</td>
							<td>${record['LISTDESCRIPTION']}</td>
							<td>${record['LISTTYPE']}</td>
						</tr>
						</c:forEach>
					</tbody>
					</table>
			</form>
			</div>
		</div>
		<div class="card card-primary" id="listDetailsSerachResultPanel${UNQID}" style="display: none;">
			<div class="card-header panelSlidingListDetails${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}">List Details</h6>
				<div class="btn-group pull-${dirR} clearfix">
					<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
				</div>
			</div>
			<div id="listDetailsSerachResult${UNQID}"></div>
			
		</div>
	</div>
</div>
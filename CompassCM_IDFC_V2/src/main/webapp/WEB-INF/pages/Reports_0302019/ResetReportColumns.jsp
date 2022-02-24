<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="../tags/tags.jsp"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Reset Report Columns</title>
<jsp:include page="../tags/staticFiles.jsp"/>
<script type="text/javascript">
$(document).ready(function(){
	var id = '${UNQID}';
	
	var tableClass = 'compassResetReportsColumnsListTable';
	compassDatatable.construct(tableClass, "Report Columns List", true);
	compassDatatable.enableCheckBoxSelection();
	
	$("#saveResetingReportColumns"+id).click(function(){
		var reportId = '${reportId}';
		var userId = '${userId}';
		var allColName = "";
		var allCheckbox = "";
		var allAliasName = "";
		var allColIndex = "";
		var fullData = "";
		var tr = $(".resetReportsColumnsListTable"+id).children("tbody").children("tr");
		$(tr).each(function(){
			var checkbox = $(this).children("td:first-child").children("input").prop("checked");
			var colName = $(this).children("td:nth-child(3)").html();
			var aliasName = $(this).children("td:nth-child(4)").children("input").val();			
			var colIndex = $(this).children("td:nth-child(5)").children("select").val();
			if(checkbox){
				checkbox = "Y";
			}
			else{
				checkbox = "N";
			}
			/*allCheckbox = allCheckbox+","+checkbox;
			allAliasName = allAliasName+","+aliasName;
			allColIndex = allColIndex+","+colIndex;
			allColName = allColName+","+colName;*/
			var data = checkbox+","+colName+","+aliasName+","+colIndex;
			fullData = fullData+";"+data;
		});
		//var fullData = "reportId="+reportId+"&userId="+userId+"&allColName="+allColName+"&allCheckbox="+allCheckbox+"&allAliasName="+allAliasName+"allColIndex="+allColIndex;
		// alert(fullData);
		if(confirm("Are you sure?")){
			$.ajax({
				url: "${pageContext.request.contextPath}/common/resetReportColumns",
				cache: false,
				type: "POST",
				data: "reportId="+reportId+"&userId="+userId+"&fullData="+fullData,
				success: function(res) {
					// alert(res);
					window.location.reload();
					window.close();
				},
				error: function(a,b,c) {
					alert(a+b+c);
				}
			});
		}
	});
	
	$("#closeResetingReportColumnsWindow"+id).click(function(){
		window.close();
	});
});
</script>
<style type="text/css">
	.panel_resetreportColumnsDetails{
		margin-left: 10px;
		margin-right: 10px;
		margin-top: 5px;
	}
</style>
</head>
<body>
<div class="row compassrow${UNQID}">
	<div class="col-sm-12">
		<div class="card card-primary panel_resetreportColumnsDetails" >
			<div class="card-header panelSlidingResetreportsGenericDetails${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}">Report Columns List</h6>
			</div>
			<div class="panelSearchForm">
			<form action="javascript:void(0)" method="POST" id="searchMasterForm${UNQID}">
				<table class="table searchResultGenericTable resetReportsColumnsListTable${UNQID} table-striped table-bordered" style="margin-bottom: 0px; text-align: center;">
					<thead>
					<tr style="font-weight: bold;">
						<th width="10%" class="info no-sort" align="center">
							<input type="checkbox" class="checkbox-check-all" compassTable="compassResetReportsColumnsListTable" id="compassResetReportsColumnsListTable"></th>
						</th>
						<th width="10%" class="info">Serial No</th>
						<th width="35%" class="info">Column Name</th>
						<th width="35%" class="info">Column Alias Name</th>
						<th width="10%" class="info">Column Index</th>
					</tr>
					</thead>
					<tbody>
						<c:forEach var="columnsList" items="${DATALIST}" varStatus="loop">
						<tr>
							<td class="no-sort" style="text-align: center;">
								<input type="checkbox" <c:if test="${columnsList['ISENABLED'] eq 'Y'}">checked="checked"</c:if>/>	
							</td>
							<td>${loop.index+1}</td>
							<td>${columnsList['COLUMNNAME']}</td>
							<td><input type = "text" id="aliasName" name="aliasName" value="${columnsList['ALIASNAME']}" style="width: 100%;"/></td>
							<td style="text-align: right;">
								<select class="form-control input-sm" style="width: 100%;">
									<c:forEach var="i" begin="1" end="1000">
										<option value="${i}" <c:if test="${columnsList['COLUMNINDEX'] eq i}">selected="selected"</c:if>>${i}</option>
									</c:forEach>
								</select>
							</td>
						</tr>
						</c:forEach>
					</tbody>
					</table>
					<div class="card-footer clearfix">
					<div class="pull-right">
						<input type="button" id="saveResetingReportColumns${UNQID}" class="btn btn-primary btn-sm" name="saveResetingReportColumns" value="Save">
						<input type="button" class="btn btn-danger btn-sm" id="closeResetingReportColumnsWindow${UNQID}" name="close" value="Close"/>
					</div>
				</div>
			</form>
			</div>
			
		</div>
	</div>
</div>
</body>
</html>

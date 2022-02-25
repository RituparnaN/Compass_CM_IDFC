<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../tags/tags.jsp"%>
<script type="text/javascript">
$(document).ready(function(){
	var id = '${UNQID}';

	$("#searchListMapping"+id).click(function(){
		var sourceList = $("#sourceList"+id).val();
		var destinationList = $("#destinationList"+id).val();
		var fullData = "sourceList="+sourceList+"&destinationList="+destinationList;
		$.ajax({
			url: "${pageContext.request.contextPath}/admin/middleFrame",
			cache: false,
			type: "POST",
			data: fullData,
			success: function(res) {
				$("#screeningMappingUpdateSearchLevelPanel"+id).css("display","block");
				$("#screeningMappingSerachResult"+id).html(res);
			},
			error: function(a,b,c) {
				alert(a+b+c);
			}
		});
		$.ajax({
			url: "${pageContext.request.contextPath}/admin/bottomFrame",
			cache: false,
			type: "POST",
			data: fullData,
			success: function(res) {
				$("#screeningMappingUpdateFieldMappingPanel"+id).css("display","block");
				$("#fieldScreeningMappingSerachResult"+id).html(res);
			},
			error: function(a,b,c) {
				alert(a+b+c);
			}
		});
	});
	
	$("#updateScreeningMapping"+id).click(function(){
		var tr = $("#screeningMappingSerachResult"+id).find("table").children("tbody").children("tr");
		var chkbox = $(tr).children("td:first-child").children("input").prop("checked");
		if(chkbox)
			chkbox = "1";
		else
			chkbox = "0";
		var sourceList = $(tr).children("td:nth-child(2)").html();
		var destinationList = $(tr).children("td:nth-child(3)").html();
		var mappingLevel = $(tr).children("td:nth-child(4)").children("select").val();
		var fullData = "chkbox="+chkbox+"&sourceList="+sourceList+"&destinationList="+destinationList+"&mappingLevel="+mappingLevel;
		
		$.ajax({
			url: "${pageContext.request.contextPath}/admin/updateScreeningMapping",
			cache: false,
			type: "POST",
			data: fullData,
			success: function(res) {
				alert(res);
			},
			error: function(a,b,c) {
				alert(a+b+c);
			}
		});
	});
	
	$("#deleteScreeningMapping"+id).click(function(){
		var tr = $("#screeningMappingSerachResult"+id).find("table").children("tbody").children("tr");
		var sourceList = $(tr).children("td:nth-child(2)").html();
		var destinationList = $(tr).children("td:nth-child(3)").html();
		var fullData = "sourceList="+sourceList+"&destinationList="+destinationList;
		$.ajax({
			url: "${pageContext.request.contextPath}/admin/deleteScreeningMapping",
			cache: false,
			type: "POST",
			data: fullData,
			success: function(res) {
				alert(res);
				$(tr).children("td:first-child").children("input").prop("checked",false);
			},
			error: function(a,b,c) {
				alert(a+b+c);
			}
		});
	});
	
	$("#updateFieldScreeningMapping"+id).click(function(){
		var fullData = "";
		var tr = $("#fieldScreeningMappingSerachResult"+id).find("table").children("tbody").children("tr");
		$(tr).each(function(){
			if ($(this).children("td:first-child").children("input").prop("checked")){
				var sourceList = $(this).children("td:nth-child(2)").html();
				var sourceField = $(this).children("td:nth-child(3)").html();
				var destinationList = $(this).children("td:nth-child(4)").html();
				var destinationField = $(this).children("td:nth-child(5)").html();
				var rank = $(this).children("td:nth-child(6)").children("select").val();
				fullData = fullData + "sourceList="+sourceList+","+"sourceField="+sourceField+","+"destinationList="+destinationList+
										","+"destinationField="+destinationField+","+"rank="+rank+";" ;
			}
		});
		$.ajax({
			url: "${pageContext.request.contextPath}/admin/updateFieldScreeningMapping",
			cache: false,
			type: "POST",
			data: "fullData="+fullData,
			success: function(res) {
				alert(res);
			},
			error: function(a,b,c) {
				alert(a+b+c);
			}
		});
	});
	
});
</script>
<div class="row compassrow${UNQID}">
	<div class="col-sm-12">
		<div class="card card-primary panel_screeningMapping">
			<div class="card-header panelScreeningMapping${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}"><spring:message code="app.common.screeningMappingHeader"/></h6>
				<div class="btn-group pull-${dirR} clearfix">
					<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
				</div>
			</div>
			<div class="panelSearchForm">
				<table class="table compassscreeningMappingSearchTable" style="margin-bottom: 0px;">
					<tr>
						<td width="15%">Source List Name</td>
						<td width="30%">
							<select class="form-control input-sm" name="sourceList" id="sourceList${UNQID}" >
								<c:forEach var = "listData" items= "${DATALIST}">
									<option value="${listData['LISTCODE']}">${listData['LISTNAME']}</option>
								</c:forEach>
							</select>
						</td>
						<td width="10%">&nbsp;</td>
						<td width="15%">Destination List Name</td>
						<td width="30%">
							<select class="form-control input-sm" name="destinationList" id="destinationList${UNQID}">
								<c:forEach var = "listData" items= "${DATALIST}">
									<option value="${listData['LISTCODE']}">${listData['LISTNAME']}</option>
								</c:forEach>
							</select>
						</td>
					</tr>
				</table>
				<div class="card-footer clearfix">
					<div class="pull-${dirR}">
						<button type="button" id="searchListMapping${UNQID}" class="btn btn-success btn-sm"><spring:message code="app.common.searchButton"/></button>
					</div>
				</div>
			</div>
		</div>
		<div class="card card-primary" id="screeningMappingUpdateSearchLevelPanel${UNQID}" style="display: none;">
			<div class="card-header panelScreeningMapping${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}"><spring:message code="app.common.screeningMappingResultHeader"/></h6>
				<div class="btn-group pull-${dirR} clearfix">
					<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
				</div>
			</div>
			<div id="screeningMappingSerachResult${UNQID}"></div>
			<div class="card-footer clearfix">
				<div class="pull-${dirR}">
					<input type="button" class="btn btn-primary btn-sm" id="updateScreeningMapping${UNQID}" name="Update" value="Update"/>
					<input type="button" class="btn btn-danger btn-sm" id="deleteScreeningMapping${UNQID}" name="Delete" value="Delete"/>
				</div>
			</div>
		</div>
		<div class="card card-primary" id="screeningMappingUpdateFieldMappingPanel${UNQID}" style="display: none;">
			<div class="card-header panelFieldScreeningMapping${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}"><spring:message code="app.common.fieldScreeningMappingResultHeader"/></h6>
				<div class="btn-group pull-${dirR} clearfix">
					<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
				</div>
			</div>
			<div id="fieldScreeningMappingSerachResult${UNQID}"></div>
			<div class="card-footer clearfix">
				<div class="pull-${dirR}">
					<input type="button" class="btn btn-primary btn-sm" id="updateFieldScreeningMapping${UNQID}" name="Update" value="Update"/>
				</div>
			</div>
		</div>
	</div>
</div>
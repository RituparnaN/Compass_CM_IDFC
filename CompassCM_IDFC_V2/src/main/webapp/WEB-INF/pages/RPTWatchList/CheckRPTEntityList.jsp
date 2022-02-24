<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../tags/tags.jsp"%>
<c:set var="MODULETYPE" value="${moduleType}"/>
<c:set var="MODULENAME" value="${moduleName}"/>
<c:set var="UNQID" value="${UNQID}"/>
<c:set var="HEADER" value="${PENDINGRPTENTITIES['HEADER']}"/>
<c:set var="DATA" value="${PENDINGRPTENTITIES['DATA']}"/>
<c:set var="RECORDCOUNT" value="${f:length(DATA)}"/>
<c:set var="HEADERINDEX" value="0"/>
<jsp:useBean id="commonUtil" class="com.quantumdataengines.app.compass.util.CommonUtil" scope="page"/>

<script type="text/javascript">
	$(document).ready(function(){
		var tableClass = '${MODULETYPE}${UNQID}';
		compassDatatable.construct(tableClass, "${MODULENAME}", true);
	});
	
	function viewUpdateRPTEntity(elm){
		$("#compassMediumGenericModal").modal("show");
		$("#compassMediumGenericModal-title").html("RPT Entity Details");
		var entityId = $(elm).attr("entityId");
		var LISTCODE = $(elm).attr("listCode");
		var LISTNAME = $(elm).attr("listName");
		$.ajax({
			url: "${pageContext.request.contextPath}/rptcommon/viewUpdateRPTEntity",
			cache: false,
			type: "POST",
			data : "LISTCODE="+LISTCODE+"&LISTNAME="+LISTNAME+"&ENTITYID="+entityId+"&AUTHORIZE=Y",
			success: function(res){
				$("#compassMediumGenericModal-body").html(res);
			},
			error: function(a,b,c){
				alert(a+b+c);
			}
		});
	}
</script>
<div class="row compassrow${UNQID}">
	<div class="col-sm-12">
		<div class="card card-primary panel_RPTWatchList">
			<div class="card-header panelSlidingRPTWatchListCustomer${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}"><spring:message code="app.common.rptWatchListHeader"/></h6>
			</div>
			<div id="searchResultGenericDiv">
				<table class="table table-bordered table-striped searchResultGenericTable ${MODULETYPE}${UNQID}" style="margin-bottom: 0px;">
					<thead>
						<tr>
							<th id="${commonUtil.getColumnId(HEADER[0])}"><spring:message code="${HEADER[0]}"/></th>
							<th id="${commonUtil.getColumnId(HEADER[2])}"><spring:message code="${HEADER[2]}"/></th>
							<th id="${commonUtil.getColumnId(HEADER[3])}"><spring:message code="${HEADER[3]}"/></th>
							<th id="${commonUtil.getColumnId(HEADER[4])}"><spring:message code="${HEADER[5]}"/></th>
							<th id="${commonUtil.getColumnId(HEADER[14])}"><spring:message code="${HEADER[14]}"/></th>
							<th id="${commonUtil.getColumnId(HEADER[15])}"><spring:message code="${HEADER[15]}"/></th>
							<th id="${commonUtil.getColumnId(HEADER[16])}"><spring:message code="${HEADER[16]}"/></th>
							<th id="${commonUtil.getColumnId(HEADER[17])}"><spring:message code="${HEADER[17]}"/></th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="RECORD" items="${DATA}">
							<tr>
								<td>${RECORD[0]}</td>
								<td>${RECORD[2]}</td>
								<td>${RECORD[3]}</td>
								<td entityId="${RECORD[4]}" listCode="${RECORD[1]}" listName="${RECORD[2]}">${RECORD[5]}</td>
								<td>${RECORD[14]}</td>
								<td>${RECORD[15]}</td>
								<td>${RECORD[16]}</td>
								<td>${RECORD[17]}</td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>
		</div>
	</div>
</div>

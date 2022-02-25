<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../tags/tags.jsp"%>

<style type="text/css">
	.modalNav li a{
		font-size: 12px;
		padding: 5px 10px;
	}
	table.compassModuleDetailsSearchTable tr td{
		border: 0px;
	}
</style>
<script type="text/javascript">
	$(document).ready(function(){
		var id = '${UNQID}';
		var tableClass = 'modalBottomDetailsTable'+id;
		compassDatatable.construct(tableClass, "AccountProfileDetails_Non_Cash_Details", true);
		
	});
</script>
<div class="container" style="width: 100%;">
	<div class="row">
		<div class="col-sm-12">
			<div class="card card-primary modalBottomDetails">
				<div class="card-header panelSlidingAccountProfile${UNQID} clearfix">
					<h6 class="card-title pull-${dirL}">${CHANNELTYPE}</h6>
				</div>
				<table class="table table-bordered">
					<c:set var="RECORDCOUNT" value="${f:length(WHOLEDATA)}" scope="page"/>
					<c:choose>
						<c:when test="${RECORDCOUNT > 0}">
							<table class="table table-striped table-bordered searchResultGenericTable modalBottomDetailsTable${UNQID}">
								<thead>
									<c:forEach var="EACHROW" items="${WHOLEDATA}" begin="0" end="0">
										<tr>
											<c:forEach var="EACHDATA" items="${EACHROW}">
												<c:set var="colArray" value="${f:split(EACHDATA.key, '.')}" />
												<c:set var="colArrayCnt" value="${f:length(colArray)}" />
												<th id="${colArray[colArrayCnt-1]}"><spring:message code="${EACHDATA.key}"/></th>
											</c:forEach>
										</tr>
									</c:forEach>
								</thead>
								<tbody>
									<c:forEach var="EACHROW" items="${WHOLEDATA}">
										<tr>
											<c:forEach var="EACHDATA" items="${EACHROW}">
												<c:choose>
													<c:when test="${EACHDATA.value ne ' ' and EACHDATA.value ne ''}">
														<td data-toggle="tooltip" data-placement="auto"  title="${TD}" data-container="body">${EACHDATA.value}</td>
													</c:when>
													<c:otherwise>
														<td>${EACHDATA.value}</td>
													</c:otherwise>
												</c:choose>
											</c:forEach>
										</tr>
									</c:forEach>
								</tbody>
							</table>
						</c:when>
						<c:otherwise>
							<br/>
							<center>
							No ${tab} Record Found
							</center>
							<br/>
						</c:otherwise>
					</c:choose>
				</table>
				<br/><br/>
				<div class="row nonCashBottomDetailsDiv" style="display: none;">
					<div class="col-sm-12">
						<div class="card">
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>


<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../tags/tags.jsp"%>
<script type="text/javascript">
	$(document).ready(function(){
		$(document).ready(function(){
			var tableClass = 'emailRefreshLogTable';
			compassDatatable.construct(tableClass, "${MODULENAME}", true);
		});
	});
</script>
<div class="row">
	<div class="col-sm-12">
		<div class="card card-primary">
			<div class="card-header clearfix">
		    	<h6 class="card-title pull-${dirL}">Email Refresh Log</h6>
		    </div>
			<table class="table table-bordered table-striped emailRefreshLogTable" id="emailRefreshLogTable" style="margin-bottom: 0px;">
				<thead>
					<tr>
						<th width="20%">RefreshTime</th>
						<th width="10%">Folder</th>
						<th width="8%">Count</th>
						<th width="10%">Status</th>
						<th width="40%">Message</th>
						<th width="12%">RefreshedBy</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="emailRefreshLog" items="${EMAILREFRESHLOG}">
						<tr>
							<td>${emailRefreshLog['REFRESHTIME']}</td>
							<td>${emailRefreshLog['FOLDER']}</td>
							<td>${emailRefreshLog['EMAILCOUNT']}</td>
							<td>${emailRefreshLog['STATUS']}</td>
							<td>${emailRefreshLog['MESSAGE']}</td>
							<td>${emailRefreshLog['UPDATEDBY']}</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
		
	</div>
</div>


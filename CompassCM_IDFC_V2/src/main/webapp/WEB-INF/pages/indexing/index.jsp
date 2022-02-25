<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../tags/tags.jsp"%>

<div class="row">
	<div class="col-sm-12">
		<div class="card card-primary">
			<div class="card-header indexingStartPanel clearfix">
				<h6 class="card-title pull-${dirL}">Start Indexing</h6>
			</div>
			<div class="card-search-card">
				<table class="table table-striped formSearchTable">
					<tbody>
						<tr>
							<td width="30%">Date Range</td>
							<td width="70%">
								<div class="input-daterange input-group">
									<span class="input-group-addon">FROM</span>
									<input type="text" class="form-control" id="indexingFromDate" value="${FROMDATE}"/>
									<span class="input-group-addon">TO</span>
									<input type="text" class="form-control" id="indexingToDate" value="${TODATE}"/>
								</div>
							</td>
						</tr>
						<tr>
							<td width="30%">List Name</td><td width="70%">
								<div class="input-list input-group">
									<select class="form-control" id="listName" name="listName">
										<option>adjfhsh</option>
										<option>bdscdsfds</option>
										<option>cddsdss</option>
									</select>
								</div>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			<div class="card-footer clearfix">
				<div class="pull-${dirR}">
					<a href="javascript:void(0)" id="startindexing" class="btn btn-info btn-sm"
					<c:if test="${INDEXING == 1}">disabled="disabled"</c:if>>
					Start</a>
					<a href="javascript:void(0)" id="cancelIndexing" class="btn btn-warning btn-sm">Cancel</a>
				</div>
			</div>
		</div>
	</div>
</div>
<div class="card card-primary" id="indexingSerachResultPanel${UNQID}" style="display: block;">
			<div class="card-header panelSlidingIndexing${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}"><spring:message code="app.common.indexingResultHeader"/></h6>
			</div>		
					<div class="row">
						<div class="col-lg-12">
							<div class="progress" style="margin: 2px 10px;">
								<div class="progress-bar progress-bar-striped active" style="width: 0%" role="progressbar" aria-valuenow="30" aria-valuemin="0" aria-valuemax="100">0%</div>
							</div>
						</div>
					</div>
			<div id="indexingSerachResult${UNQID}"></div>
</div>

<script type="text/javascript">
	$("#indexingFromDate").datepicker({
		defaultDate: "+1w",
		numberOfMonths: 1,
		changeMonth: true,
	    dateFormat:'dd/mm/yy',
	    onClose: function(selecteddate){
	    	$("#indexingToDate").datepicker("option", "minDate", selecteddate);
	    }
	});
	
	$("#indexingToDate").datepicker({
		changeMonth: true,
		defaultDate: "+1w",
		numberOfMonths: 1,
	    dateFormat:'dd/mm/yy',
	    onClose: function(selecteddate){
	    	$("#indexingFromDate").datepicker("option", "maxDate", selecteddate);
	    }
	});
</script>	

<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../tags/tags.jsp"%>
<script type="text/javascript">
	$(document).ready(function() {
		compassTopFrame.init('', 'dashboardSearchTable', 'dd/mm/yy');
	});
</script>
<div id="page-wrapper">
	<div class="row">
		<div class="col-lg-12">
			<ul class="nav nav-tabs compass-nav-tabs" role="tablist">
				<li class="active litabdashboard">
					<a class="nav-link active" href="#dashboard" data-toggle="tab">Dash Board</a></li>
			</ul>
			<div class="tab-content compass-tab-content">
				<div class="tab-pane active" id="dashboard">
					
				</div>
			</div>
		</div>
	</div>
</div>
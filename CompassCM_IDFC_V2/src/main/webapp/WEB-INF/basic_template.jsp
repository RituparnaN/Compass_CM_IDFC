<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="pages/tags/tags.jsp"%>
<script type="text/javascript">
	$(document).ready(function() {
		var id = '${UNQID}';
		compassTopFrame.init(id, 'moduleTable'+id, 'dd/mm/yy');
		
		$('.panelSlidingModuleName'+id).on("click", function (e) {
			var mainRow = $(this).parents(".compassrow"+id);
			compassTopFrame.searchPanelSliding(id, mainRow, 'moduleNameSerachResultPanel');
	    });
		
		$("#searchMasterForm"+id).submit(function(e){
			var submitButton = $("#searchModule"+id);
			var formObj = $("#searchMasterForm"+id);
			var formData = (formObj).serialize();
			compassTopFrame.submitForm(id, e, submitButton, 'moduleNameSerachResultPanel', 
					'moduleNameSerachResult', '${pageContext.request.contextPath}/common/searchGenericMaster',
					'${pageContext.request.contextPath}/includes/images/qde-loadder.gif');
		});
	});
</script>
<style type="text/css">

</style>
<div class="row compassrow${UNQID}">
	<div class="col-sm-12">
		<div class="card card-primary panel_moduleName">
			<div class="card-header panelSlidingModuleName${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}">Module Name</h6>
				<div class="btn-group pull-${dirR} clearfix">
					<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
				</div>
			</div>
			<div class="panelSearchForm">
			<form action="javascript:void(0)" method="POST" id="searchMasterForm${UNQID}">
			<input type="hidden" name="moduleType" value="${MODULETYPE}">
			<input type="hidden" name="bottomPageUrl" value="AlertEngines/SearchBottomPage">
			<div class="card-search-card" >
				<table class="table table-striped formSearchTable moduleTable${UNQID}" style="margin-bottom: 0px;">
					<tbody>
						<tr>
							<td width="15%"></td>
							<td width="30%">
								<input type="text" class="fomr-control input-sm" name="" id=""/>
							</td>
							<td width="10%">&nbsp;</td>
							<td width="15%"></td>
							<td width="30%">
								
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			<div class="card-footer clearfix">
				<div class="pull-${dirR}">
					<button  type="submit" id="searchModule${UNQID}" class="btn btn-success btn-sm">Search</button>
				</div>
			</div>
			</form>
			</div>
		</div>
		<div class="card card-primary" id="moduleNameSerachResultPanel${UNQID}" style="display: none;">
			<div class="card-header panelSlidingModuleName${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}">Module Search Result</h6>
				<div class="btn-group pull-${dirR} clearfix">
					<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
				</div>
			</div>
			<div id="moduleNameSerachResult${UNQID}"></div>
		</div>
	</div>
</div>
<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../../tags/tags.jsp"%>
<script type="text/javascript">
	$(document).ready(function() {
		var id = '${UNQID}';
		var branchList = '${BRANCHLIST}';
  		compassTopFrame.init(id, 'compassMissingFieldsReportSearchTable'+id, 'dd/mm/yy');
		
		$('.panelSlidingMissingFieldsReport'+id).on("click", function (e) {
			var mainRow = $(this).parents(".compassrow"+id);
			compassTopFrame.searchPanelSliding(id, mainRow, 'missingFieldsReportSerachResultPanel');
	    });
		
		$("#searchMissingFieldsReport"+id).click(function(){
			var template = $("#template"+id).val();
			var branchCode = $("#branchCode"+id).val();
			var complianceScore = $("#complianceScore"+id).val();
			
			var fullData = "template="+template+"&branchCode="+branchCode+"&complianceScore="+complianceScore;
			var mainRow = $(this).parents("div.compassrow"+id);
			var slidingDiv = $(mainRow).children().children().children();
			var panelBody = $(mainRow).children().children().find(".panelSearchForm");
			
			
			$.ajax({
				url: "${pageContext.request.contextPath}/common/searchMissingFieldsReport",
				cache: false,
				type: "POST",
				data: fullData,
				success: function(res){
					$("#missingFieldsReportSerachResultPanel"+id).css("display", "block");
					$("#missingFieldsReportSerachResult"+id).html(res);
					$(panelBody).slideUp();
					$(slidingDiv).addClass('card-collapsed');
					$(slidingDiv).find('i.collapsable').removeClass('fa-chevron-up').addClass('fa-chevron-down');
					$(mainRow).next().find(".compassrow"+id).find(".card-header").next().slideDown();
				},
				error: function(a,b,c){
					alert(a+b+c);
				}
			});
		});
	});
</script>

<div class="row compassrow${UNQID}">
	<div class="col-sm-12">
		<div class="card card-primary panel_missingFieldsReport">
			<div class="card-header panelSlidingMissingFieldsReport${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}"><spring:message code="app.common.missingFieldsReportSearchHeader"/></h6>
				<div class="btn-group pull-${dirR} clearfix">
					<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
				</div>
			</div>
			<div class="panelSearchForm">
			<form action="javascript:void(0)" method="POST" id="searchMasterForm${UNQID}">
				<table class="table compassMissingFieldsReportSearchTable" style="margin-bottom: 0px;">
					<tr>
						<td width="15%">Template</td>
						<td width="30%">
							<select class="form-control input-sm" name="template" id="template${UNQID}">
								<c:forEach items="${TEMPLATELIST}" var="templateIds">
									<option value="${templateIds['TEMPLATEID']}">${templateIds['TEMPLATENAME']}</option>
								</c:forEach>
							</select> 
						</td>
						<td width="10%">&nbsp;</td>
						<td width="15%">Branch Code</td>
						<td width="30%">
							<select class="form-control input-sm" name="branchCode" id="branchCode${UNQID}">
								<option value="ALL">All</option>
								<c:forEach items="${BRANCHLIST}" var="branchCodes">
									<option value="${branchCodes['BRANCHCODE']}">${branchCodes['BRANCHNAME']}</option>
								</c:forEach>
							</select> 
						</td>
					</tr>
					<tr>	
						<td width="15%">Compliance Score</td>
						<td width="30%">
							<select class="form-control input-sm" name="complianceScore" id="complianceScore${UNQID}">
								<option value="ALL">All</option>
								<option value="1">Optional</option>
								<option value="2">Mandatory By Bank</option>
								<option value="3">Mandatory By Regulator</option>
							</select> 
						</td>
						<td colspan="3">&nbsp;</td>
					</tr>
				</table>
				<div class="card-footer clearfix">
					<div class="pull-${dirR}">
						<button type="button" id="searchMissingFieldsReport${UNQID}" class="btn btn-success btn-sm"><spring:message code="app.common.searchButton"/></button>
						<input type="reset" class="btn btn-danger btn-sm" id="clearMissingFieldsReport${UNQID}" name="Clear" value="Clear"/>
					</div>
				</div>
			</form>
			</div>
		</div>
		<div class="card card-primary" id="missingFieldsReportSerachResultPanel${UNQID}" style="display: none;">
			<div class="card-header panelSlidingMissingFieldsReport${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}"><spring:message code="app.common.missingFieldsReportResultHeader"/></h6>
				<div class="btn-group pull-${dirR} clearfix">
					<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
				</div>
			</div>
			<div id="missingFieldsReportSerachResult${UNQID}"></div>
		</div>
	</div>
</div>
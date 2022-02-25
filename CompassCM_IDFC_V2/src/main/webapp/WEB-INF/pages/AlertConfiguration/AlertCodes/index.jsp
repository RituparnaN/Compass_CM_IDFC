<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../../tags/tags.jsp"%>
<script type="text/javascript">
	$(document).ready(function() {
		var id = '${UNQID}';
		$(".compassrow"+id).find("select").select2();
		
  		compassTopFrame.init(id, 'compassAlertCodesEditorSearchTable'+id, 'dd/mm/yy');
		
		$('.panelSlidingAlertCodesEditor'+id).on("click", function (e) {
			var mainRow = $(this).parents(".compassrow"+id);
			compassTopFrame.searchPanelSliding(id, mainRow, 'alertCodesEditorSerachResultPanel');
	    });
				
		$("#openModalTocreateSubjectiveAlert"+id).click(function(){
				$.ajax({
						url: "${pageContext.request.contextPath}/admin/openModalTocreateSubjectiveAlert",
						cache: false,
						type: "POST",
						success: function(res){
							$("#compassCaseWorkFlowGenericModal").modal("show");
							$("#compassCaseWorkFlowGenericModal-title").html("Create Subjective Alert");
							$("#compassCaseWorkFlowGenericModal-body").html(res);
						},
						error: function(a,b,c){
							alert(a+b+c);
						}
					});
		});
		
		$("#searchAlertCodes"+id).click(function(){
			var alertType = $("#alertType"+id).val();
			var alertCode = $("#alertCode"+id).val();
			var fullData = "alertType="+alertType+"&alertCode="+alertCode;
			var mainRow = $(this).parents(".compassrow"+id);
			var slidingDiv = $(mainRow).children().children().children();
			var panelBody = $(mainRow).children().children().find(".panelSearchForm");
			if(alertCode == 'ALL'){
				alert("Select an Alert Code");
			}else{
			$.ajax({
				url: "${pageContext.request.contextPath}/admin/searchAlertCodeDetails",
				cache: false,
				type: "POST",
				data: fullData,
				success: function(res) {
					$("#alertCodesEditorSerachResultPanel"+id).css("display", "block");
					$("#alertCodesEditorSerachResult"+id).html(res);
					$(panelBody).slideUp();
					$(slidingDiv).addClass('card-collapsed');
					$(slidingDiv).find('i.collapsable').removeClass('fa-chevron-up').addClass('fa-chevron-down');
					$(mainRow).next().find(".compassrow"+id).find(".card-header").next().slideDown();
				},
				error: function(a,b,c) {
					alert(a+b+c);
				}
			});
			}
		});
		
		$("#alertType"+id).on("change", function(){
			var alertType = $(this).val();
			$.ajax({
				url: "${pageContext.request.contextPath}/admin/getAlertCodeForAlertType",
				cache: false,
				type: "POST",
				data: "alertType="+alertType,
				success: function(res) {
					$.each(res, function(k,v){
						//alert(v.ALERTCODE+" "+v.ALERTMESSAGE);
						
					});
				},
				error: function(a,b,c) {
					alert(a+b+c);
				}
			});
			
		});
		
		$("#updateAlertDetails"+id).click(function(){
			var table = $("#alertCodesEditorSerachResult"+id).find("table");
			var alertCode = $(table).find("input[name='alertCode']").val();
			var alertName = $(table).find("input[name='alertName']").val();
			var description = $(table).find("input[name='description']").val();
			var alertMsg = $(table).find("input[name='alertMsg']").val();
			var alertPriority = $(table).find("select[name='alertPriority']").val();
			var alertEnabled = $(table).find("select[name='alertEnabled']").val();
			var fullData = "alertCode="+alertCode+"&alertName="+alertName+"&description="+description+"&alertMsg="
							+alertMsg+"&alertPriority="+alertPriority+"&alertEnabled="+alertEnabled;
			$.ajax({
				url: "${pageContext.request.contextPath}/admin/updateAlertDetails",
				cache: false,
				type: "POST",
				data: fullData,
				success: function(res){
					alert(res);
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
		<div class="card card-primary panel_alertCodesEditor">
			<div class="card-header panelSlidingAlertCodesEditor${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}"><spring:message code="app.common.alertCodesEditorHeader"/></h6>
				<div class="btn-group pull-${dirR} clearfix">
					<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
				</div>
			</div>
			<div class="panelSearchForm">
			<form action="javascript:void(0)" method="POST" id="searchMasterForm${UNQID}">
				<table class="table compassAlertCodesEditorSearchTable" style="margin-bottom: 0px;">
					<tr>
						<td width="15%">Alert Type</td>
						<td width="30%">
							<select class="form-control input-sm" name="alertType" id="alertType${UNQID}">
								<option value="ALL">ALL</option>
								<option value="R">ONLINE</option>
								<option value="N">OFFLINE</option>
								<option value="S">SUBJECTIVE</option>
							</select> 
						</td>
						<td width="10%">&nbsp;</td>
						<td width="15%">Alert Code</td>
						<td width="30%">
							<select class="form-control input-sm" name="alertCode" id="alertCode${UNQID}">
								<c:forEach var="alertCodes" items="${ALERTCODES}">
									<option value="${alertCodes.key}">${alertCodes.value}</option>
								</c:forEach>
							</select>
						</td>
					</tr>
					</table>
				<div class="card-footer clearfix">
					<div class="pull-${dirR}">
						<input type="button" id="searchAlertCodes${UNQID}" class="btn btn-primary btn-sm" name="Search" value="Search">
						<input type="button" id="openModalTocreateSubjectiveAlert${UNQID}" class="btn btn-success btn-sm" name="Create Subjective Alert" value="Create Subjective Alert"/>
						<input type="reset" class="btn btn-danger btn-sm" id="clearAlertCodesEditor${UNQID}" name="Clear" value="Clear"/>
					</div>
				</div>
			</form>
			</div>
		</div>
		<div class="card card-primary" id="alertCodesEditorSerachResultPanel${UNQID}" style="display: none;">
			<div class="card-header panelSlidingAlertCodesEditor${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}"><spring:message code="app.common.alertCodesEditorResultHeader"/></h6>
				<div class="btn-group pull-${dirR} clearfix">
					<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
				</div>
			</div>
			<div id="alertCodesEditorSerachResult${UNQID}"></div>
			<div class="card-footer clearfix">
				<div class="pull-${dirR}">
					<input type="button" class="btn btn-success btn-sm" id="updateAlertDetails${UNQID}" name="Update" value="Update"/>
				</div>
			</div>
		</div>
	</div>
</div>
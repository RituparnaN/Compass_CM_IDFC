<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../../tags/tags.jsp"%>
<script type="text/javascript">
	$(document).ready(function() {
		var id = '${UNQID}';
		
		$(".compassrow"+id).find("select").select2();
		
  		compassTopFrame.init(id, 'compassAlertRatingsDetailsSearchTable'+id, 'dd/mm/yy');
		
		$('.panelSlidingAlertRatingsDetails'+id).on("click", function (e) {
			var mainRow = $(this).parents(".compassrow"+id);
			compassTopFrame.searchPanelSliding(id, mainRow, 'alertRatingsDetailsSerachResultPanel');
		});
		
		$("#alertCode"+id).on("change", function(){
			var alertCode = $(this).val();
			var select = "<select class='form-control input-sm' name='alertMessage' id='alertMessage${UNQID}'><option value='ALL'>ALL</option>";
			$.ajax({
				url: "${pageContext.request.contextPath}/admin/getAlertCode",
				cache: false,
				type: "POST",
				data: "alertCode="+alertCode,
				success: function(res) {
					$.each(res, function(k,v){
						select = select + "<option values='"+v.ALERTMESSAGE+"'>"+v.ALERTMESSAGE+"</option>"
					});
					select = select + "</select>";
					$("#alertMessageTd").html(select);
				},
				error: function(a,b,c) {
					alert(a+b+c);
				}
			});
	    });
		
		$("#searchAlertRatings"+id).click(function(){
			var alertCode = $("#alertCode"+id).val();
			var alertMsg = $("#alertMessage"+id).val();
			var mainRow = $(this).parents(".compassrow"+id);
			var slidingDiv = $(mainRow).children().children().children();
			var panelBody = $(mainRow).children().children().find(".panelSearchForm");
			var fullData = "alertCode="+alertCode+"&alertMsg="+alertMsg;
			$.ajax({
				url: "${pageContext.request.contextPath}/admin/searchAlertRatingsDetails",
				cache: false,
				type: "POST",
				data: fullData,
				success: function(res) {
					$("#alertRatingsDetailsSerachResultPanel"+id).css("display", "block");
					$("#alertRatingsDetailsSerachResult"+id).html(res);
					$(panelBody).slideUp();
					$(slidingDiv).addClass('card-collapsed');
					$(slidingDiv).find('i.collapsable').removeClass('fa-chevron-up').addClass('fa-chevron-down');
					$(mainRow).next().find(".compassrow"+id).find(".card-header").next().slideDown();
				},
				error: function(a,b,c) {
					alert(a+b+c);
				}
			});
		});
		
		$("#uploadAlertsRatingMapping"+id).click(function(){
				compassFileUpload.init("uploadAlertsRatingMapping"+id,"${pageContext.request.contextPath}","alertRatings","0","Y","Y","");
		});
		
		$("#updateAlertRatingsValues"+id).click(function(){
			var fullData = "";
			var table = $("#alertRatingsDetailsSerachResult"+id).find("table");
			$(table).children("tbody").children("tr").each(function(){
				var checkbox = $(this).children("td:first-child").children("input").prop("checked");
				
				if(checkbox){
					var alertCode = $(this).children("td:nth-child(2)").html();
					var alertMsg = $(this).children("td:nth-child(3)").html();
					var alertRating = $(this).children("td:nth-child(4)").children("select").val();
					fullData = fullData + "checkbox="+checkbox+"|^|ALERTID="+alertCode+"|^|ALERTMESSAGE="+alertMsg+"|^|ALERTRATING="+alertRating+ ",";
				}
			});
			//alert(fullData);
			$.ajax({
				url: "${pageContext.request.contextPath}/admin/updateAlertRatingsValues",
				cache: false,
				type: "POST",
				data: "fullData="+fullData,
				success: function(res){
					alert(res);
				//	$(tr).children("td:first-child").children("input").prop("checked",true);
				},
				error: function(a,b,c){
					alert(a+b+c);
				}
			});
		});
	});
	
	function checkSelectBoxOnUpdate(elm){
		$(elm).parents("tr").children("td:first-child").children("input").prop("checked", true);
	}
	
</script>
<div class="row compassrow${UNQID}">
	<div class="col-sm-12">
		<div class="card card-primary panel_alertRatingsDetails">
			<div class="card-header panelSlidingAlertRatingsDetails${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}"><spring:message code="app.common.alertRatingsDetailsHeader"/></h6>
				<div class="btn-group pull-${dirR} clearfix">
					<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
				</div>
			</div>
			<div class="panelSearchForm">
			<form action="javascript:void(0)" method="POST" id="searchMasterForm${UNQID}">
				<table class="table compassAlertRatingsDetailsSearchTable" style="margin-bottom: 0px;">
					<tr>
						<td width="15%">Alert Code</td>
						<td width="30%">
							<select class="form-control input-sm" name="alertCode" id="alertCode${UNQID}">
								<option value="ALL">ALL</option>
								<c:forEach var="alertCode" items="${ALERTCODE}">
									<option value="${alertCode['ALERTCODE']}">${alertCode['ALERTCODE']}</option>
								</c:forEach>
							</select> 
						</td>
						<td width="10%">&nbsp;</td>
						<td width="15%">Alert Message</td>
						<td width="30%" id="alertMessageTd">
							<select class="form-control input-sm" name="alertMessage" id="alertMessage${UNQID}">
								<option value="ALL">ALL</option>
								<c:forEach var="alertMessage" items="${ALERTMSG}">
									<option value="${alertMessage['ALERTMESSAGE']}">${alertMessage['ALERTMESSAGE']}</option>
								</c:forEach>
							</select>
						</td>
					</tr>
					</table>
				<div class="card-footer clearfix">
					<div class="pull-${dirR}">
						<input type="submit" id="searchAlertRatings${UNQID}" class="btn btn-primary btn-sm" name="Search" value="Search">
						<input type="button" class="btn btn-warning btn-sm" id="uploadAlertsRatingMapping${UNQID}" name="UploadAlertsRatingMapping" value="Upload Alerts Rating Mapping"/>
					</div>
				</div>
			</form>
			</div>
		</div>
		<div class="card card-primary" id="alertRatingsDetailsSerachResultPanel${UNQID}" style="display: none;">
			<div class="card-header panelSlidingAlertRatingsDetails${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}"><spring:message code="app.common.alertRatingsDetailsResultHeader"/></h6>
				<div class="btn-group pull-${dirR} clearfix">
					<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
				</div>
			</div>
			<div id="alertRatingsDetailsSerachResult${UNQID}"></div>
			<div class="card-footer clearfix">
				<div class="pull-${dirR}">
					<input type="button" class="btn btn-success btn-sm" id="updateAlertRatingsValues${UNQID}" name="Update" value="Update"/>
				</div>
			</div>
		</div>
	</div>
</div>
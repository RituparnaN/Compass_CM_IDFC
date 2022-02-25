<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../tags/tags.jsp"%>

<style type="text/css">
	.datepicker{
		background-image:url("${pageContext.request.contextPath}/includes/images/calendar.png");
		background-repeat:no-repeat;
		background-position: 98%;
	} 	
</style>
<script type="text/javascript">
	$(document).ready(function(){
		var id = '${UNQID}';
				
		$("#searchModuleDetails"+id).click(function(){
			/* alert(moduleDetails);
			alert(colValue); */
			var childWindow = $("#childWindow").val() != undefined ? "1" : "0";
			var moduleCode = $("#moduleCode"+id).val();
			var moduleHeader = $("#moduleHeader"+id).val();
			var moduleValue = $("#caseNo"+id).val();
			var detailPage = $("#detailPage"+id).val();
			if(childWindow == "1"){
				searchInChildWindow(moduleHeader, moduleValue, moduleCode, detailPage);
			}else{
				if($("#compassGenericModal").hasClass("show")){
					openDetails($(this), moduleHeader, moduleValue, moduleCode, detailPage);
				}else{
					openModalInTab($(this), moduleHeader, moduleValue, moduleCode, detailPage);
				}
			}
			
		});
		
		$("#moduleValue"+id).keydown(function(event){
	        if(event.which=="13")
	        	$("#searchModuleDetails"+id).click();
		});
				
		$("#saveComments"+id).click(function(){
			var alertNos = "${alertNos}";
			var caseNo = "${caseNo}";
			var caseStatus = "${caseStatus}";
			var userRole = "${userRole}";
			var action = "${action}";
			var parentFormId = "${parentFormId}";
			var fraudIndicator = $("#fraudIndicator"+id).val();
			var	comments  = $("#amluserComments"+id).val();
			var modalId = "${modalId}";
			var fullData = "CaseNos="+caseNo+"&alertNos="+alertNos+"&Comments="+comments+"&FraudIndicator="+fraudIndicator;
			//alert(fullData);
			if(comments == ''){
				alert('Please enter Comments.');
			}else if(comments.length > 4000){
				alert('Comments cannot exceed 4000 words.');
			}else{
			
				$.ajax({
 					url: "${pageContext.request.contextPath}/amlCaseWorkFlow/saveComments",
					cache: false,
					type: "POST",
					data: fullData,
					success: function(res){
						alert(res);
						$("#"+parentFormId).submit();
						$("#"+modalId).modal("hide");
					},
					error: function(a,b,c){
						alert(a+b+c);
					}
				});
			}
		}); 


		 $("#openModalInTab").click(function(){
			var moduleCode = $("#compassGenericModal-body").find("div.card-body").children("input#moduleCode"+id).val();
			var moduleHeader = $("#compassGenericModal-body").find("div.card-body").children("input#moduleHeader"+id).val();
			var moduleValue = $("#compassGenericModal-body").find("div.card-body").find("input#moduleValue"+id).val();
			var detailPage = $("#compassGenericModal-body").find("div.card-body").children("input#detailPage"+id).val();
			if(moduleValue != undefined)
				openModalInTab($(this), moduleHeader, moduleValue, moduleCode, detailPage);
		});
		
		$("#openModalInWindow").click(function(){
			var moduleCode = $("#compassGenericModal-body").find("div.card-body").children("input#moduleCode"+id).val();
			var moduleHeader = $("#compassGenericModal-body").find("div.card-body").children("input#moduleHeader"+id).val();
			var moduleValue = $("#compassGenericModal-body").find("div.card-body").find("input#moduleValue"+id).val();
			var detailPage = $("#compassGenericModal-body").find("div.card-body").children("input#detailPage"+id).val();
			if(moduleValue != undefined)
				openModalInWindow($(this), moduleHeader, moduleValue, moduleCode, detailPage, true);
		});
		
			
			
	});	
</script>

<div class="container" style="width: 100%; padding-left: 0; padding-right: 0;">
	<div class="row">
		<div class="col-sm-12">
			<div class="card card-primary commentsMainDiv${UNQID}">
				<div class="card-header panelSlidingAddComments${UNQID} clearfix" 
					id="${varStatus.index}slidingAddCommentsPanel${UNQID}" data-toggle="collapse" 
					data-target="#${tabIndex}addCommentsDiv${varStatus.index}">
					<h6 class="card-title pull-${dirL}">Add Comments</h6>
					<div class="btn-group pull-${dirR} clearfix">
						<span class="pull-right"><i class="collapsable fa fa-chevron-down"></i></span>
					</div>
				</div>
				<div id="${tabIndex}addCommentsDiv${varStatus.index}" >
					<table class="table table-striped">
						<tr>
							<td width="20%">Action Type</td>
							<td colspan="4">
								<select class="form-control input-sm" name="fraudIndicator" id="fraudIndicator${UNQID}" style="width:100%">
								   	<c:forEach var="suspicionIndicators" items="${SUSPICIONINDICATORS}">
								   		<option value="${suspicionIndicators.SUSPICION_INDICATOR_CODE}">${suspicionIndicators.SUSPICION_INDICATOR_DESC}</option>
								   	</c:forEach>
								</select>	
							</td>
						</tr>
						<tr>
							<td width="20%">Comments</td>
							<td colspan="4">
									<textarea class="form-control input-sm" name="amluserComments" id="amluserComments${UNQID}" ></textarea>
							</td>
						</tr>
					</table>
				</div>
				<div class="card-footer clearfix">
					<div class="pull-${dirR}">
						<input type="button" class="btn btn-success btn-sm" id="saveComments${UNQID}" value="Save Comments">
						<input type="button" class="btn btn-danger btn-sm" id="closeAddViewCommentsModal${UNQID}" data-dismiss="modal" value="Close"/>
					</div>
				</div>
				</div>
		</div>
	</div>
</div>
</form>
</body>
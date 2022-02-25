<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../tags/tags.jsp"%>

<style>
	.labelField{
		margin-left: 4px;
		font-weight: normal;
	}
	
	.textareaField{
		min-height: 40px;
		overflow: auto;
		resize: vertical;
	}
</style>

<script>
	$(document).ready(function(){
		var id = '${UNQID}';
		var searchButton = '${SEARCHBUTTON}';
		var userCode = '${USERCODE}';
		var actionForModal = '${ACTIONFORMODAL}';
		var checkerComments = "";
		var reportingUserCode = "";
		var reviewersCode = "";
		var isEnabled = "";
		
		if(actionForModal == 'View'){
			$(document).find("#approve"+id).css({display:'none'});
			$(document).find("#reject"+id).css({display:'none'});
			$(document).find("#checkerCommentField"+id).attr({disabled:'disabled'});
		}else if(actionForModal == 'Edit'){
			$(document).find("#checkerHidePart"+id).css({display:'none'});
		}
		
		$(".approveOrReject").click(function(){
			var actionToTake = $(this).val();
			reportingUserCode = $("#reportingUserCode"+id).val();
			reviewersCode = $("#reviewersCode"+id).val();
			isEnabled = $("#isEnabled"+id).val().charAt(0);
			var actionToTake = $(this).val();
			checkerComments = $("#checkerCommentField"+id).val();
			fullData = userCode+"--"+reportingUserCode+"--"+reviewersCode+"--"+isEnabled+"--"+checkerComments+";";
			//alert(fullData);
			if(!checkerComments == ""){
				$.ajax({
					url: "${pageContext.request.contextPath}/admin/approveOrRejectRepUser",
					cache: false,
					type: "POST",
					data: "fullData="+fullData+"&actionToTake="+actionToTake,
					success: function(res) {
						alert(res);
						$("#"+searchButton).click();
						$("#compassSearchModuleModal").modal('hide');
					},
					error: function(a,b,c) {
						alert(a+b+c);
					} 
				});
			}else{
				alert("Checker's comment is necessary.");
			}
		});
		
		$("#close"+id).click(function(){
			$("#compassSearchModuleModal").modal('hide');
		});
	});
</script>

<div class="card card-default">
		<table class="table table-striped" id="makerCommentsTable">
			<c:forEach items="${RESULTDATA}" var="row">	
				<tr>
					<td width='15%'>
						<label class="labelField"> User Code </label>
					</td>
					<td width='30%'>
						<input disabled="disabled" type="text" style="width:100%;" class="form-control input-sm" id="userCode${UNQID}" name="userCode"  value="${USERCODE}"/>
					</td>
					<td width='10%'>&nbsp;</td>
					<td width='15%'>
						<label class="labelField"> Reporting User Code </label>
					</td>
					<td width='30%'>
						<input disabled="disabled" type="text" style="width:100%;" class="form-control input-sm" id="reportingUserCode${UNQID}" name="reportingUserCode"  value="${row.REPORTINGUSERCODE}"/>
					</td>
				</tr>
				<tr>
					<td width='15%'>
						<label class="labelField"> Reviewer's Code </label>
					</td>
					<td width='30%'>
						<input disabled="disabled" type="text" style="width:100%;" class="form-control input-sm" id="reviewersCode${UNQID}" name="reviewersCode"  value="${row.REVIEWERSCODE}"/>
					</td>
					<td width='10%'>&nbsp;</td>
					<td width='15%'>
						<label class="labelField"> Is Enabled </label>
					</td>
					<td width='30%'>
						<input disabled="disabled" type="text" style="width:100%;" class="form-control input-sm" id="isEnabled${UNQID}" name="isEnabled"  value="${row.ISENABLED}"/>
					</td>
				</tr>
				<tr>
					<td width='15%'>
						<label class="labelField"> Status </label>
					</td>
					<td width='30%'>
						<input disabled="disabled" type="text" style="width:100%;" class="form-control input-sm" id="statusSelected${UNQID}" name="statusSelected"  value="${row.STATUS}"/>
					</td>
					<td colspan='3'>&nbsp;</td>
				</tr>	
				<tr>
					<td width='15%'>
						<label class="labelField"> Maker Code </label>
					</td>
					<td width='30%'>
						<input disabled="disabled" type="text" style="width:100%;" class="form-control input-sm" id="makerCodeField${UNQID}" name="makerCodeField"  value="${row.MAKERCODE}"/>
					</td>
					<td width='10%'>&nbsp;</td>
					<td width='15%'>
						<label class="labelField"> Maker Timestamp </label>
					</td>
					<td width='30%'>
						<input disabled="disabled" type="text" style="width:100%;" class="form-control input-sm" id="makerTimestampField${UNQID}" name="makerTimestampField"  value="${row.MAKERTIMESTAMP}"/>
					</td>
				</tr>
				<tr>
					<td width='15%'>
						<label class="labelField"> Maker Comments</label>
					</td>
					<td colspan="4">
						<textarea class="form-control input-sm textareaField" disabled="disabled" rows="2" cols="60" style="width:100%;" class="form-control input-sm" id="makerCommentsField${UNQID}" name="makerCommentsField">${row.MAKERCOMMENTS}</textarea>
					</td>
				</tr>
				<tr id="checkerHidePart${UNQID}">
					<td width='15%'>
						<label class="labelField"> Checker Code </label>
					</td>
					<td width='30%'>
						<input disabled="disabled" type="text" style="width:100%;" class="form-control input-sm" id="makerCodeField${UNQID}" name="makerCodeField"  value="${row.CHECKERCODE}"/>
					</td>
					<td width='10%'>&nbsp;</td>
					<td width='15%'>
						<label class="labelField"> Checker Timestamp </label>
					</td>
					<td width='30%'>
						<input disabled="disabled" type="text" style="width:100%;" class="form-control input-sm" id="makerTimestampField${UNQID}" name="makerTimestampField"  value="${row.CHECKERTIMESTAMP}"/>
					</td>
				</tr>
				<tr>
					<td width='15%'>
						<label class="labelField"> Checker Comments </label> 
					</td>
					<td colspan="4">
						<textarea rows="2" cols="60" style="width:100%;" class="form-control input-sm textareaField" id="checkerCommentField${UNQID}" name="checkerCommentField">${row.CHECKERCOMMENTS}</textarea>
					</td>
				</tr>
			</c:forEach>
		</table>
		<div class="card-footer" style="min-height: 50px;">
			<div class="pull-${dirR}">
				<input type="button" class="btn btn-success btn-sm approveOrReject" id="approve${UNQID}" name="approve" value="Approve"/>
				<input type="button" class="btn btn-danger btn-sm approveOrReject" id="reject${UNQID}" name="reject" value="Reject"/>
				<input type="button" class="btn btn-primary btn-sm" id="close${UNQID}" name="close" value="Close"/>
			</div>
		</div>
</div>


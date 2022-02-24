<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../../tags/tags.jsp"%>

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
		
		if(actionForModal == 'View'){
			$(document).find("#saveOrUpdate"+id).css({display:'none'});
		}else if(actionForModal == 'Update'){
			$(document).find("#saveOrUpdate"+id).val("Update");
		}else if(actionForModal == 'New'){
			$(document).find("#saveOrUpdate"+id).val("Save");
		}
		
		$("#saveOrUpdate"+id).click(function(){
			var actionToTake = $(this).val();
			var seqNo = $("#seqNo"+id).val();
			var word = $("#word"+id).val();
			var riskValue = $("#riskValue"+id).val();
			var isEnabled = $("#isEnabled"+id).val().charAt(0);
			var status = "P";
			var makerComments = $("#makerCommentsField"+id).val();
			var fullData = seqNo+"--"+word+"--"+riskValue+"--"+isEnabled+"--"+status+"--"+makerComments+";";
			//alert(fullData);
			if(!makerComments == ""){
				$.ajax({
					url: "${pageContext.request.contextPath}/common/saveOrUpdateWordRecord",
					cache: false,
					type: "POST",
					data: "fullData="+fullData+"&actionToTake="+actionToTake,
					success: function(res) {
						alert(res);
						$("#"+searchButton).click();
						$("#compassMediumGenericModal").modal('hide');
					},
					error: function(a,b,c) {
						alert(a+b+c);
					} 
				});
			}else{
				alert("Maker's comment is necessary.");
			}
		});
		
		$("#close"+id).click(function(){
			$("#compassMediumGenericModal").modal('hide');
		});
	});
</script>

<div class="card card-default">
		<table class="table table-striped" id="makerCommentsTable">
			<%-- <tr><td>${RESULTDATA}</td></tr> --%>
			<c:choose>
				<c:when test="${ACTIONFORMODAL == 'Update'}">
					<c:forEach items="${RESULTDATA}" var="row">
						<tr>
							<td width='15%'>
								<label class="labelField"> Seq No </label>
							</td>
							<td width='30%'>
								<input readonly="readonly" type="text" style="width:100%;" class="form-control input-sm" id="seqNo${UNQID}" name="seqNo"  value="${row.SEQNO}"/>
							</td>
							<td width='10%'>&nbsp;</td>
							<td width='15%'>
								<label class="labelField"> Word </label>
							</td>
							<td width='30%'>
								<input type="text" style="width:100%;" class="form-control input-sm" id="word${UNQID}" name="word"  value="${row.WORD}"/>
							</td>
						</tr>
						<tr>
							<td width='15%'>
								<label class="labelField"> Risk Value </label>
							</td>
							<td width='30%'>
								<select class="form-control input-sm" id="riskValue${UNQID}" name="riskValue" style="width: 100%;" disabled>
									<option value="HIGH" selected>High</option>
									<option value="MEDIUM">Medium</option>
									<option value="LOW">Low</option>
								</select>
							</td>
							<td width='10%'>&nbsp;</td>
							<td width='15%'>
								<label class="labelField"> Is Enabled </label>
							</td>
							<td width='30%'>
								<select class="form-control input-sm" id="isEnabled${UNQID}" name="isEnabled" style="width: 100%;">
									<option value="Y">Yes</option>
									<option value="N">No</option>
								</select>
							</td>
						</tr>
						<tr>
							<td width='15%'>
								<label class="labelField"> Maker Comments</label>
							</td>
							<td colspan="4">
								<textarea class="form-control input-sm textareaField" rows="2" cols="60" style="width:100%;" class="form-control input-sm" id="makerCommentsField${UNQID}" name="makerCommentsField"></textarea>
							</td>
						</tr>
					</c:forEach>
				</c:when>
				<c:when test="${ACTIONFORMODAL == 'New'}">
					<tr>
						<td width='15%'>
							<label class="labelField"> Seq No </label>
						</td>
						<td width='30%'>
							<input readonly="readonly" type="text" style="width:100%;" class="form-control input-sm" id="seqNo${UNQID}" name="seqNo"  value="${NEWSEQNO}"/>
						</td>
						<td width='10%'>&nbsp;</td>
						<td width='15%'>
							<label class="labelField"> Word </label>
						</td>
						<td width='30%'>
							<input type="text" style="width:100%;" class="form-control input-sm" id="word${UNQID}" name="word"  value="${row.WORD}"/>
						</td>
					</tr>
					<tr>
						<td width='15%'>
							<label class="labelField"> Risk Value </label>
						</td>
						<td width='30%'>
							<select class="form-control input-sm" id="riskValue${UNQID}" name="riskValue" style="width: 100%;" disabled>
								<option value="HIGH" selected>High</option>
								<option value="MEDIUM">Medium</option>
								<option value="LOW">Low</option>
							</select>
						</td>
						<td width='10%'>&nbsp;</td>
						<td width='15%'>
							<label class="labelField"> Is Enabled </label>
						</td>
						<td width='30%'>
							<select class="form-control input-sm" id="isEnabled${UNQID}" name="isEnabled" style="width: 100%;">
								<option value="Y">Yes</option>
								<option value="N">No</option>
							</select>
						</td>
					</tr>
					<tr>
						<td width='15%'>
							<label class="labelField"> Maker Comments</label>
						</td>
						<td colspan="4">
							<textarea class="form-control input-sm textareaField" rows="2" cols="60" style="width:100%;" class="form-control input-sm" id="makerCommentsField${UNQID}" name="makerCommentsField"></textarea>
						</td>
					</tr>
				</c:when>
				<c:otherwise>
					<c:forEach items="${RESULTDATA}" var="row">
						<tr>
							<td width='15%'>
								<label class="labelField"> Seq No </label>
							</td>
							<td width='30%'>
								<input readonly="readonly" type="text" style="width:100%;" class="form-control input-sm" id="seqNo${UNQID}" name="seqNo"  value="${row.SEQNO}"/>
							</td>
							<td width='10%'>&nbsp;</td>
							<td width='15%'>
								<label class="labelField"> Word </label>
							</td>
							<td width='30%'>
								<input readonly="readonly" type="text" style="width:100%;" class="form-control input-sm" id="word${UNQID}" name="word"  value="${row.WORD}"/>
							</td>
						</tr>
						<tr>
							<td width='15%'>
								<label class="labelField"> Risk Value </label>
							</td>
							<td width='30%'>
								<input readonly="readonly" type="text" style="width:100%;" class="form-control input-sm" id="riskValue${UNQID}" name="riskValue"  value="${row.RISKVALUE}"/>
							</td>
							<td width='10%'>&nbsp;</td>
							<td width='15%'>
								<label class="labelField"> Is Enabled </label>
							</td>
							<td width='30%'>
								<input readonly="readonly" type="text" style="width:100%;" class="form-control input-sm" id="isEnabled${UNQID}" name="isEnabled"  value="${row.ISENABLED}"/>
							</td>
						</tr>
						<tr class="extraFields">
							<td width='15%'>
								<label class="labelField"> Status </label>
							</td>
							<td colspan='4'>
								<input readonly="readonly" type="text" style="width:100%;" class="form-control input-sm" id="statusSelected${UNQID}" name="statusSelected"  value="${row.STATUS}"/>
							</td>
						</tr>	
						<tr class="extraFields">
							<td width='15%'>
								<label class="labelField"> Maker Code </label>
							</td>
							<td width='30%'>
								<input readonly="readonly" type="text" style="width:100%;" class="form-control input-sm" id="makerCodeField${UNQID}" name="makerCodeField"  value="${row.MAKERCODE}"/>
							</td>
							<td width='10%'>&nbsp;</td>
							<td width='15%'>
								<label class="labelField"> Maker Timestamp </label>
							</td>
							<td width='30%'>
								<input readonly="readonly" type="text" style="width:100%;" class="form-control input-sm" id="makerTimestampField${UNQID}" name="makerTimestampField"  value="${row.MAKERTIMESTAMP}"/>
							</td>
						</tr>
						<tr>
							<td width='15%'>
								<label class="labelField"> Maker Comments</label>
							</td>
							<td colspan="4">
								<textarea readonly="readonly" class="form-control input-sm textareaField" rows="2" cols="60" style="width:100%;" class="form-control input-sm" id="makerCommentsField${UNQID}" name="makerCommentsField">${row.MAKERCOMMENTS}</textarea>
							</td>
						</tr>
						<tr class="extraFields">
							<td width='15%'>
								<label class="labelField"> Checker Code </label>
							</td>
							<td width='30%'>
								<input readonly="readonly" type="text" style="width:100%;" class="form-control input-sm" id="makerCodeField${UNQID}" name="makerCodeField"  value="${row.CHECKERCODE}"/>
							</td>
							<td width='10%'>&nbsp;</td>
							<td width='15%'>
								<label class="labelField"> Checker Timestamp </label>
							</td>
							<td width='30%'>
								<input readonly="readonly" type="text" style="width:100%;" class="form-control input-sm" id="makerTimestampField${UNQID}" name="makerTimestampField"  value="${row.CHECKERTIMESTAMP}"/>
							</td>
						</tr>
						<tr class="extraFields">
							<td width='15%'>
								<label class="labelField"> Checker Comments </label> 
							</td>
							<td colspan="4">
								<textarea readonly="readonly" rows="2" cols="60" style="width:100%;" class="form-control input-sm textareaField" id="checkerCommentsField${UNQID}" name="checkerCommentsField">${row.CHECKERCOMMENTS}</textarea>
							</td>
						</tr>
					</c:forEach>
				</c:otherwise>
			</c:choose>
		</table>
		<div class="card-footer" style="min-height: 50px;">
			<div class="pull-${dirR}">
				<input type="button" class="btn btn-success btn-sm" id="saveOrUpdate${UNQID}" name="saveOrUpdate" value=""/>
				<input type="button" class="btn btn-primary btn-sm" id="close${UNQID}" name="close" value="Close"/>
			</div>
		</div>
</div>


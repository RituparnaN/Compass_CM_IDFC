<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../../tags/tags.jsp"%>
<c:set var="EMAILQUESTIONDETAILS" value="${DETAILS['EMAILQUESTIONDETAILS']}"/>
<c:set var="EMAILGROUPDETAILS" value="${DETAILS['EMAILGROUPDETAILS']}"/>
<script type="text/javascript">
$(function(){
	var id = "${UNQID}";
	var submitButton = "${submitButton}";
	$("#update"+id).click(function(){
		let questionGroup = $("#questionGroup"+id).val();
		let questionGroupTitle = $("#questionGroup"+id).children("option:selected").text();
		let question = $("#question"+id).val();
		let questionID = "${EMAILQUESTIONDETAILS['EMAILQUESTIONID']}";
		let action = "UPDATE"
		
		
		$.ajax({
			url : "${pageContext.request.contextPath}/common/insertUpdateEamilQuestion",
			data : {questionGroupTitle:questionGroupTitle,questionGroup:questionGroup,question:question,questionID:questionID,action:action},
			type : "POST",
			cache : false,	
			success : function(resData){
				alert(resData);
				$("#compassMediumGenericModal").modal('hide');
				$("#"+submitButton).click();
				
			},
			error : function(a,b,c){
			 alert(a,b,c);
			}
		});
	});
});

</script>

  <div class="card card-primary">
    <div class="card-header">Email Questions Details</div>
    <div class="card-body">
    	<table class="table">
    		<tr>
    			<td width = "15%">Email Question Id</td>
    			 <td width = "30%"><input type="text" class="form-control" value = "${EMAILQUESTIONDETAILS['EMAILQUESTIONID']}" disabled/></td>
    			 
    			<td width = "10%"></td>
    			<td width = "15%">Group Title</td>
    			<td width = "35%">
    			    <select class="form-control" id = "questionGroup${UNQID}">
    					<c:forEach items = "${EMAILGROUPDETAILS}" var = "group">
    						<option value = "${group.value}"  <c:if test = "${group.key eq EMAILQUESTIONDETAILS['QUESTIONGROUPTITLE']}">selected</c:if> >${group.key}</option>
    					</c:forEach>
    				</select> 
    			</td>
    		</tr>
    		<tr>
    			<td width = "15%">Updated By</td>
    			<td width = "30%"><input type="text" class="form-control" value = "${EMAILQUESTIONDETAILS['UPDATEDBY']}" disabled/></td>
    			<td width = "10%"></td>
    			<td width = "15%">Last Updated Time</td>
    			<td width = "35%"><input type="text" class="form-control" value = "${EMAILQUESTIONDETAILS['UPDATETIMESTAMP']}" disabled/></td>
    		</tr>
    		<tr>
    			<td width = "15%">Question</td>
    			<td colspan='4'><textarea class="form-control" rows="5" id="question${UNQID}">${EMAILQUESTIONDETAILS['QUESTION']}</textarea></td>
    			
    		</tr>
    	</table>
    </div>
    <div class="card-footer clearfix">
		<div class="pull-${dirR}">
			<button  type="button" id="update${UNQID}" class="btn btn-success btn-sm">Update</button>
		</div>
	</div>
  </div>

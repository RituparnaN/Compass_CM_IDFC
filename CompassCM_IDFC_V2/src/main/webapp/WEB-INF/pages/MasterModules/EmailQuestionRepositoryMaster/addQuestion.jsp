<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../../tags/tags.jsp"%>
<c:set var="EMAILGROUPDETAILS" value="${DETAILS['EMAILQUESTIONDETAILS']}"/>
<script>
	var id = "${UNQID}";
	var submitButton = "${submitButton}";
	$("#addQuestion"+id).click(function(){
		let questionGroup = $("#questionGroup"+id).val();
		let questionGroupTitle = $("#questionGroup"+id).children("option:selected").text();
		let question = $("#question"+id).val();
		let questionID = "${DETAILS['EMAILQUESTIONID']}";
		let action = "INSERT"
		if(questionGroup == null || questionGroup == "Select Group"){
			alert("Please Select Group");
			return false;
		}
		if(question == ""){
			alert("Please Enter Question");
			return false;
		}
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
</script>
  <div class="card card-primary">
    <div class="card-header">Add Email Questions</div>
    <div class="card-body">
    	<table class="table">
    		<tr>
    			<td width="20%">Select Group</td>
    			<td >
    			    <select class="form-control col-sm-4" id = "questionGroup${UNQID}">
    			    	<option>Select Group</option>
    					<c:forEach items = "${EMAILGROUPDETAILS}" var = "group">
    						<option value = "${group.value}"   >${group.key}</option>
    					</c:forEach>
    				</select> 
    			</td>
    			
    		</tr>
    		<tr>
    			<td width="20%">Question</td>
    			<td ><textarea class="form-control" rows="5" id="question${UNQID}"></textarea></td>
    			
    		</tr>
    	</table>
    </div>
    <div class="card-footer clearfix">
		<div class="pull-${dirR}">
			<button  type="button" id="addQuestion${UNQID}" class="btn btn-success btn-sm">Add</button>
		</div>
	</div>
  </div>

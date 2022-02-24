<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="java.util.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
String contextPath = request.getContextPath() == null ? "" : request.getContextPath();
String cifNo = (String) request.getAttribute("CIF");
String accountNo = (String) request.getAttribute("AccountNo");
String caseNo = (String) request.getAttribute("caseNo");
%>
<script type="text/javascript">
$(document).ready(function(){
	$("#uploadDocForm").submit(function(e){
		var docName = $("#documentName").val();
		var fileObj = $("#cpuMakerUploadDoc")[0].files[0];
		var fd = new FormData();
	    fd.append('file', fileObj);
	    fd.append('CIF_NO','<%=cifNo%>');
	    fd.append('ACCOUNT_NO','<%=accountNo%>');
	    fd.append('CASE_NO','<%=caseNo%>');
	    fd.append('documentName',docName);
	    if(docName != ""){
	    	$.ajax({
		        url: "${pageContext.request.contextPath}/cpumaker/uploadFormDocument",
		        type: "POST",
		        contentType:false,
		        processData: false,
		        enctype : "multipart/form-data",
		        cache: false,
		        data: fd,
		        success: function(data){
		        	var formObj = $("#AccountOpeningForm");
					var formData = $(formObj).serialize();
					$.ajax({
						type : "GET",
						url : "<%=contextPath%>/cpuMaker/searchAccountOpeningForm",
						cache : false,
						data : formData+"&FORM_SECTION=category5",
						success : function(res){
							$("#accountOpeningFormSearch").html(res);
						},
						error : function(){
							alert("error");
						}
					});
		        },
		        error : function(a,b,c){
		        	alert(a.status+" "+b+" "+c);
		        }
		    });
	    }else{
	    	alert("Please Enter a DOcument Name");
	    }
		e.preventDefault();
	});
});
</script>
<form action="javascript:void(0)" method="POST" enctype="multipart/form-data" id="uploadDocForm">			
<input type="hidden" name="CIF_NO" id="upload_cif_no" value="<%=cifNo%>"/>
<input type="hidden" name="ACCOUNT_NO" id="upload_account_no" value="<%=accountNo%>"/>
<input type="hidden" name="CASE_NO" id="upload_case_no" value="<%=caseNo%>"/>
	<table class="table table-bordered table-stripped">
		<tbody>
			<tr>
				<td width="35%">Document Name</td>
				<td width="65%">
					<input type="text" id="documentName" name="documentName" class="form-control input-sm"/> 
				</td>
			</tr>
			<tr>
				<td>
					Choose file
				</td>
				<td>
					<input type="file"  name="cpuMakerUploadDoc" id="cpuMakerUploadDoc"/>
				</td>
			</tr>
		</tbody>
	</table>
	<div class="modal-footer" style="background: #E6E6FA">
        <button type="submit" class="btn btn-success">Upload</button>
        <button type="button" class="btn btn-danger" data-dismiss="modal">Close</button>
      </div>
</form>

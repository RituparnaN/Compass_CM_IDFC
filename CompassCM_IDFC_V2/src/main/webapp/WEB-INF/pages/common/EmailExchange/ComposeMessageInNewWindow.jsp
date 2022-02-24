<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../../tags/tags.jsp"%>
<%-- <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> --%>
<c:set var="dirR" value="${'right'}"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>${moduleHeader}</title>
<jsp:include page="../../tags/staticFiles.jsp"/>

<style>
	body{
		padding: 20px;
	}
</style>

<script type="text/javascript">
	$(document).ready(function(){
		//CKEDITOR.replace('editor1');
		var caseNo = "${caseNo}";
		
		CKEDITOR.replace( 'editor1', {
		    //allowedContent: 'p b i; a[!href]',
			allowedContent: true,
		} );
		
		$("#email_attachment_dragandrop_handler").click(function(){
			 $("#fileupload").click(); 
		});
		
		var objEmailAttachment = $("#email_attachment_dragandrop_handler");
		objEmailAttachment.on('dragenter', function (e) {
		    e.stopPropagation();
		    e.preventDefault();
		    $(this).css('border', '2px solid #0B85A1');
		});
		objEmailAttachment.on('dragover', function (e) {
		     e.stopPropagation();
		     e.preventDefault();
		});
		objEmailAttachment.on('drop', function (e) {
		     $(this).css('border', '2px dotted #0B85A1');
		     e.preventDefault();
		     var files = e.originalEvent.dataTransfer.files;
		     for(var i = 0; i < files.length; i++){
		    	 compassEmailExchange.pushFile(files[i]);
		     }
		});
		
		/*  19012019 */
		$("#emailQuestionButton").click(function(){
			//$("#compassSearchModuleModal").modal("show");
			//$("#compassSearchModuleModal-title").html("Email Questions for Case No - "+caseNo);
			$("#compassEmailQuestionModal").modal("show");
			$("#compassEmailQuestionModal-title").html("Email Questions for Case No - "+caseNo);
			var mainCkeditor = CKEDITOR.instances['editor1'];
			var newListGenerated = $(mainCkeditor.editable().$).find('#emailComposeQuestionList');
			
			var fetchedQuestionsArray = [];

			$(newListGenerated).find("ul").each(function(i, k){
				$(k).find('li').each(function(index,val){
					var groupName = $(val).attr("groupname");
					var groupTitle = $(val).attr("grouptitle");
					var questionNo = $(val).attr("questionno");
					var question = $(val).text();
					var fetchedQuestions = {};
					fetchedQuestions.questionNo = questionNo;
					fetchedQuestions.groupName = groupName;
					fetchedQuestions.groupTitle = groupTitle;
					fetchedQuestions.question = question;
					fetchedQuestionsArray.push(fetchedQuestions);
				});
			});
			$.ajax({
				url : "${pageContext.request.contextPath}/common/getEmailQuestions",
				cache : false,
				data : {caseNo:caseNo, previousQuestions:JSON.stringify(fetchedQuestionsArray)},
				type : 'GET',
				success : function(resData){
					//$("#compassSearchModuleModal-body").html(resData);
					$("#compassEmailQuestionModal-body").html(resData);
				}
			});
		});
});
	//for checking question from every group selected or not 
	function validateEmailQuestionGroup(context, elm, caseNo){
		if($("#emailQuestionGroupSelectionFlag").find("p").length){
			let status = $("#emailQuestionGroupSelectionFlag").find("p").attr("status");
			var selectionStatus = (status === "true");
			if(selectionStatus){
				compassEmailExchange.prepareEmailSending(context, elm, caseNo);
			}else{
				alert(decodeURI($("#emailQuestionGroupSelectionFlag").find("p").attr("message")));
			}
		}else{
			alert("Please Select Questions From Every Group");
		}
		
	};
</script>
<style type="text/css">
#email_attachment_dragandrop_handler {
    z-index: 5;
    border:2px dotted #0B85A1;
	width: 100%;
	cursor: pointer;
    height: 50px;
    position: relative;
    background: #FFF;
    overflow: auto;
}

#attachments{
   	position: relative;
    z-index: 7;
    top: 0;
    left: 0;
    color: #000;
    padding: 2px;
}

#attachments_text {
   z-index: 6;
    font-family: Arial;
    font-size: 25px;
    color: rgba(0, 0, 0, 0.5);
    overflow: hidden;
    padding: 0;
    margin: 0;
    bottom: 0;
    right: 0;
    left: 30%;
    top:7px;;
    position: absolute;
}

/*  21.02.2019 */
#cke_1_contents{
	min-height: 350px !important;
}

</style>
</head>
<body>
<table class="table table-bordered table-striped">
	<tr>
		<td width="15%">TO</td>
		<td width="30%">
			<textarea class="form-control input-sm" id="to" rows="1">${emailDetails['RECIPIENTSTO']}</textarea>
		</td>
		<td width="10%" style="text-align: center; vertical-align: middle;" onclick="compassEmailExchange.getEmailMapping('${pageContext.request.contextPath}', this)">
			<i class="fa fa-search"></i>
		</td>
		<td width="15%">CC</td>
		<td width="30%">
			<textarea class="form-control input-sm" id="cc" rows="1">${emailDetails['RECIPIENTSCC']}</textarea>
		</td>
	</tr>
	<tr>
		<td>Subject</td>
		<td colspan="2">
			<input type="text" class="form-control input-sm" id="subject1" value="${emailDetails['SUBJECT']}" readonly="readonly"/>
		</td>
		<td colspan="2">
			<input type="text" class="form-control input-sm" id="subject2" value=""/>
		</td>
	</tr>
	<tr>
		<td colspan="5">
			<textarea class="ckeditor form-control input-sm" cols="80" id="editor1" name= "strMessage" rows="7">${emailDetails['MESSAGECONTENT']}</textarea>
		</td>
	</tr>
	<tr>
		<td>Attach Files <br/><span style="font-size: 10px;" id="totalAttachmentSize"></span> </td>
		<td colspan="4">
		 <div id="email_attachment_dragandrop_handler">
                <div id="attachments">
                </div>
                <div id="attachments_text">
                    Choose or Drop Files
                </div>
            </div>
			<input id="fileupload" style="display: none;" onchange="compassEmailExchange.FileSelected(this); this.value=null; return false;" class="form-control input-sm" type="file" name="files[]"  multiple>
		</td>
	</tr>
	<tr>
		<td colspan="5" style="text-align: center;">
			<button class="btn btn-primary btn-sm" id="emailQuestionButton">Select Questions</button>
			<%-- <button class="btn btn-success btn-sm" onclick="compassEmailExchange.prepareEmailSending('${pageContext.request.contextPath}',this, '${caseNo}')">Send</button> --%>
			<button class="btn btn-success btn-sm" onclick="validateEmailQuestionGroup('${pageContext.request.contextPath}',this, '${caseNo}')">Send</button>
		</td>
	</tr>
</table>
<div class="modal fade bs-example-modal-lg" id="compassEmailQuestionModal" tabindex="1" role="dialog" aria-labelledby="myLargeModalLabel">
		<div class="modal-dialog modal-lg">
			<div class="modal-content card-primary">
				<div class="modal-header card-header" style="cursor: move;">
					<div class="modal-button">
						<button type="button" class="close" data-dismiss="modal" aria-label="Close" title="Close">
							<span aria-hidden="true" class="fa fa-remove"></span>
						</button>
						<button type="button" class="close"  title="Open in new Window" id="openEmailQuestionModalInWindow">
							<span aria-hidden="true" class="fa fa-external-link"></span>
						</button>
					</div>
					<h4 class="modal-title" id="compassEmailQuestionModal-title">...</h4>					
				</div>
				<div class="modal-body" id="compassEmailQuestionModal-body">
				<br/>
					<center>
						<img alt="Loading..." src="${pageContext.request.contextPath}/includes/images/qde-loadder.gif">
					</center>
				<br/>
				</div>
			</div>
		</div>
</div>
<div id = "emailQuestionGroupSelectionFlag" style="display:none">

</div>
</body>
</html>


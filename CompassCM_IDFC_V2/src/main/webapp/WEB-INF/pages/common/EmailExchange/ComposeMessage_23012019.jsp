<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../../tags/tags.jsp"%>

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
		
		$("#emailQuestionButton").click(function(){
			$("#compassMediumGenericModal").modal("show");
			$("#compassMediumGenericModal-title").html("Email Questions:");
			var mainCkeditor = CKEDITOR.instances['editor1'];
			var newListGenerated = $(mainCkeditor.editable().$).find('#emailComposeQuestionList');
			
			var fetchedQuestionsArray = [];

			$(newListGenerated).find("ul").each(function(i, k){
				$(k).find('li').each(function(index,val){
					var group = $(val).attr("group");
					var questionNo = $(val).attr("questionno");
					var question = $(val).text();
					var fetchedQuestions = {};
					fetchedQuestions.questionNo = questionNo;
					fetchedQuestions.group = group;
					fetchedQuestions.question = question;
					fetchedQuestionsArray.push(fetchedQuestions);
				});
			});
			$.ajax({
				url : "${pageContext.request.contextPath}/common/getEmailQuestions",
				cache : false,
				data : {caseNo:caseNo, previousQuestions:JSON.stringify(fetchedQuestionsArray)},
				type : 'POST',
				success : function(resData){
					$("#compassMediumGenericModal-body").html(resData);
				}
			});
		});
	});
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

</style>
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
			<button class="btn btn-success btn-sm" onclick="compassEmailExchange.prepareEmailSending('${pageContext.request.contextPath}',this, '${caseNo}')">Send</button>
		</td>
	</tr>
</table>


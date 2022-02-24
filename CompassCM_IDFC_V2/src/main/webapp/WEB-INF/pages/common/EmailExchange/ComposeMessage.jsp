<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../../tags/tags.jsp"%>
<c:set var="emailNumber" value=""></c:set>
<c:if test="${emailNo eq '' || emailNo eq null}">
	<c:set var="emailNumber" value=""></c:set>
</c:if>
<c:if test="${emailNo ne '' || emailNo ne null}">
	<c:set var="emailNumber" value="${emailNo}"></c:set>
</c:if>
<script type="text/javascript">
	$(document).ready(function(){
		var emailNum = '${emailNo}';
		//alert("emailNum '"+emailNum+"'");
		//alert("emailNo '"+emailNo+"'");
		//CKEDITOR.replace('editor1');
		var caseNo = "${caseNo}";
		
		CKEDITOR.replace( 'editor1', {
		    //allowedContent: 'p b i; a[!href]',
			allowedContent: true,
		} );
		
		$("#email_attachment_dragandrop_handler").click(function(){
			$(this).parent().children().eq(1).click();
			//$("#fileupload").click();
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
		
		//for opening in new window
		$("#openComposeMessageModalInWindow").click(function(){
			let url = "${pageContext.request.contextPath}/common/composeMessageInNewWindow?caseNo="+caseNo+"&emailNo="+"&folderType="+"&composeType=NEW&${_csrf.parameterName}=${_csrf.token}";
			window.open(url,"Compose Message for Case No: ${CASENO}","height="+screen.availHeight+",width="+screen.availWidth);
			$("#composeEmailMessageModal").modal("hide");
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
				compassEmailExchange.prepareEmailSending(context,elm, caseNo);
			}else{
				alert(decodeURI($("#emailQuestionGroupSelectionFlag").find("p").attr("message")));
			}
		}else{
			alert("Please Select Questions from every Group.");
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
		<c:if test="${composeType eq 'NEW'}">
			<td colspan="2">
				<input type="text" class="form-control input-sm" id="subject1" value="${emailDetails['SUBJECT']}" readonly="readonly"/>
			</td>
			<td colspan="2">
				<input type="text" class="form-control input-sm" id="subject2" value=""/>
			</td>
		</c:if>
		<c:if test="${composeType eq 'DRAFTS'}">
			<td colspan="2">
			<%-- <input type="text" class="form-control input-sm" id="subject1" value="${emailDetails['CASENO']}" readonly="readonly"/> --%>
			<input type="text" class="form-control input-sm" id="subject1" value="${emailDetails['SUBJECT']}" readonly="readonly"/>
		</td>
		<td colspan="2">
			<input type="text" class="form-control input-sm" id="subject2" value=""/>
		</td>
		</c:if>
	</tr>
	<tr>
		<td colspan="5">
			<textarea class="ckeditor form-control input-sm" cols="80" id="editor1" name= "strMessage" rows="20">${emailDetails['MESSAGECONTENT']}</textarea>
		</td>
	</tr>
	<tr>
		<td>Attach File(s) <br/><span style="font-size: 10px;" id="totalAttachmentSize"></span> </td>
		<td colspan="4">
		 <div id="email_attachment_dragandrop_handler">
                <div id="attachments">
                <c:set var="fileCount" value="${f:length(EMAILATTACHMENTS)}"></c:set>
                	<c:forEach begin="0" end="${fileCount}" varStatus="loop" var="attachment" items="${EMAILATTACHMENTS}">
                		<button style="margin: 2px;" class="btn btn-xs btn-success" 
                				onclick="compassEmailExchange.removeAttachment(this, event, ${loop.index})" 
								filename="${attachment['FILENAME']}(${attachment['FILESIZE']})" 
								onmouseout="compassEmailExchange.hideRemove(this)" 
								onmouseover="compassEmailExchange.showRemove(this)">${attachment['FILENAME']}(${attachment['FILESIZE']})
						</button>
                	</c:forEach>
                	
                </div>
                <div id="attachments_text">
                    Choose or Drop Files
                </div>
            </div>
			<input id="fileupload" style="display: none;" onchange="compassEmailExchange.FileSelected(this, '${fileCount}'); this.value=null; return false;" class="form-control input-sm" type="file" name="files[]"  multiple>
		</td>
	</tr>
	<tr>
		<td colspan="5" style="text-align: center;">
			<button class="btn btn-primary btn-sm" id="emailQuestionButton">Select Questions</button>
			<%-- <button class="btn btn-success btn-sm" onclick="compassEmailExchange.prepareEmailSending('${pageContext.request.contextPath}',this, '${caseNo}')">Send</button> --%>
			<button class="btn btn-primary btn-sm" onclick="compassEmailExchange.prepareEmailAsDraft('${pageContext.request.contextPath}',this, '${caseNo}', 'Y', '${emailNumber}')">Save As Draft</button>
			<c:if test="${composeType eq 'DRAFTS'}">
				<button class="btn btn-danger btn-sm" onclick="compassEmailExchange.deleteDraftEmail('${pageContext.request.contextPath}',this, '${caseNo}', 'Y', '${emailNumber}')">Delete Draft</button>
			</c:if>
			<button class="btn btn-success btn-sm" onclick="compassEmailExchange.prepareEmailSending('${pageContext.request.contextPath}',this, '${caseNo}', 'N', '${emailNumber}')">Send</button>
		</td>
	</tr>
</table>
<div id = "emailQuestionGroupSelectionFlag" style="display:none">

</div>


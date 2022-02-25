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
		CKEDITOR.replace('editor1', {
			   //allowedContent: 'p b i; a[!href]',
			allowedContent: true,
		});
		
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
		    	 compassStaffEmailExchange.pushFile(files[i]);
		     }
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
		<td width="10%" style="text-align: center; vertical-align: middle;" onclick="compassStaffEmailExchange.getEmailMapping('${pageContext.request.contextPath}', this)">
			<i class="fa fa-search"></i>
		</td>
		<td width="15%">CC</td>
		<td width="30%">
			<textarea class="form-control input-sm" id="cc" rows="1">${emailDetails['RECIPIENTSCC']}</textarea>
		</td>
	</tr>
	<tr style="display: none;" >
		<td width="15%">BCC</td>
		<td width="30%">
			<textarea class="form-control input-sm" id="bcc" rows="1">${emailDetails['RECIPIENTSBCC']}</textarea>
		</td>
		<td>&nbsp;</td>
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
		<td>Attach File <br/><span style="font-size: 10px;" id="totalAttachmentSize"></span> </td>
		<td colspan="4">
		 <div id="email_attachment_dragandrop_handler">
                <div id="attachments">
                <c:set var="fileCount" value="${f:length(EMAILATTACHMENTS)}"></c:set>
                	<c:forEach begin="0" end="${fileCount}" varStatus="loop" var="attachment" items="${EMAILATTACHMENTS}">
                		<button style="margin: 2px;" class="btn btn-xs btn-success" 
                				onclick="compassStaffEmailExchange.removeAttachment(this, event, ${loop.index})" 
								filename="${attachment['FILENAME']}(${attachment['FILESIZE']})" 
								onmouseout="compassStaffEmailExchange.hideRemove(this)" 
								onmouseover="compassStaffEmailExchange.showRemove(this)">${attachment['FILENAME']}(${attachment['FILESIZE']})
						</button>
                	</c:forEach>
                	
                </div>
                <div id="attachments_text">
                    Choose or Drop Files
                </div>
            </div>
			<input id="fileupload" style="display: none;" onchange="compassStaffEmailExchange.FileSelected(this, '${fileCount}'); this.value=null; return false;" class="form-control input-sm" type="file" name="files[]"  multiple>
		</td>
	</tr>
	<tr>
		<td colspan="5" style="text-align: center;">
			<%-- <button class="btn btn-primary btn-sm" onclick="compassStaffEmailExchange.prepareEmailAsDraft('${pageContext.request.contextPath}',this, '${caseNo}', 'Y', '${emailNumber}')">Save As Draft</button> --%>
			<button class="btn btn-success btn-sm" onclick="compassStaffEmailExchange.prepareEmailSending('${pageContext.request.contextPath}',this, '${reportCaseNo}', 'N', '${emailNumber}')">Send</button>
			<%-- <c:if test="${composeType eq 'DRAFTS'}">
				<button class="btn btn-danger btn-sm" onclick="compassStaffEmailExchange.deleteDraftEmail('${pageContext.request.contextPath}',this, '${reportCaseNo}', 'Y', '${emailNumber}')">Delete</button>
			</c:if> --%>
		</td>
	</tr>
</table>


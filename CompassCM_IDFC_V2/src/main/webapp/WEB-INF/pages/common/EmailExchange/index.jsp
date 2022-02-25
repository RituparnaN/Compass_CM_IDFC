<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../../tags/tags.jsp"%>
<script type="text/javascript">
	$(document).ready(function() {
		var emailCount = "";
		var folderType = "${folderType}";
		var caseNo = "${caseNo}";
		var emailNumber = "${emailNumber}";
		//var parentFormId = "${parentFormId}";
		
		compassEmailExchange.highlighFolder(folderType);
		
		$("#composeEmailMessageModal").find("#openComposeMessageModalInWindow").css("display","none");
		
		$(".emailComponent").click(function(){
			var folder = $(this).attr("id");
			if(folder != "COMPOSE"){
				compassEmailExchange.highlighFolder(folder);
				compassEmailExchange.showAllMessage("${pageContext.request.contextPath}", caseNo, folder);
				$("#composeEmailMessageModal").find("#openComposeMessageModalInWindow").css("display","none");
			} else{
				compassEmailExchange.composeMessage("${pageContext.request.contextPath}", caseNo, '', '','NEW');
				$("#composeEmailMessageModal").find("#openComposeMessageModalInWindow").css("display","block");
			}
				
		});
		
		if(emailNumber != ""){
			compassEmailExchange.showMessage("${pageContext.request.contextPath}", caseNo, emailNumber, folderType);
		}else{
			compassEmailExchange.showAllMessage("${pageContext.request.contextPath}", caseNo, folderType);
		}
	});
	
</script>
<div class="row">
	<div class="col-sm-2" id="emailComponent">
		<div style="margin-bottom: 3px;">
			<button id="COMPOSE" type="button" class="btn btn-sm emailComponent emailExchangeButtons" style="width: 100%; text-align: left;">Compose</button>
		</div>
		<div style="margin-bottom: 3px;">
			<button id="INBOX" type="button" class="btn btn-sm emailComponent emailExchangeButtons" style="width: 100%; text-align: left;">Inbox</button>
		</div>
		<div style="margin-bottom: 3px;">
			<button id="SENT" type="button" class="btn btn-sm emailComponent emailExchangeButtons" style="width: 100%; text-align: left;">Sent</button>
		</div>
		<div>
			<button id="DRAFTS" type="button" class="btn btn-sm emailComponent emailExchangeButtons" style="width: 100%; text-align: left;">Drafts</button>
		</div>
	</div>
	<div class="col-sm-10" id="emailBodySubjectPanel">
		
	</div>
	
	


<div class="modal fade bs-example-modal-lg" id="emailQuestionModal" tabindex="1" role="dialog" aria-labelledby="myLargeModalLabel">
	<div class="modal-dialog modal-lg">
		<div class="modal-content card-primary">
			<div class="modal-header card-header" style="cursor: move;">
				<div class="modal-button">
					<button type="button" class="close" id = "emailQuestionModalCloseButton" aria-label="Close" title="Close">
						<span aria-hidden="true" class="fa fa-remove"></span>
					</button>
				</div>
				<h4 class="modal-title" id="compassRTScanningModal-title">...</h4>					
			</div>
				<div class="modal-body" id="emailQUestionMOdalBody">
					<div class="col-sm-12">
						<div class="form-group col-sm-8">
							<label for="sel1">Select Questions</label> <select
								class="form-control" id="emailQuestionsSelectBox"
								name="emailQuestionsSelectBox" MULTIPLE>
							</select>
						</div>
						<div class="form-group col-sm-4">
							<label for="sel1">Select Group</label> <select
								class="form-control" id="emailQuestionGroup">
								<option value="Group 1">Group 1</option>
								<option value="Group 2">Group 2</option>
								<option value="Group 3">Group 3</option>
								<option value="Group 4">Group 4</option>
							</select>
						</div>
						<button class="btn btn-primary pull-right" id="addQuestionInGroup">Add
							Question IN Group</button>
					</div>
					<div class="col-sm-12">
						<textarea class="form-control" rows="5"
							id="emailQuestionWithGroup"></textarea>
					</div>
				</div>
		</div>
	</div>
</div>

</div>
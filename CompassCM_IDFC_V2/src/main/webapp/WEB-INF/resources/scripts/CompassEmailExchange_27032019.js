var compassEmailExchange = compassEmailExchange || (function(){
	var uploadingFiles = [];
	var maxFileSize = 3;
	var blockedTypes = "exe,sh";
	var _completeCount = 0;
	return {
		openEmail : function(context, caseNo, emailNumber, folderType){
			/*$("#compassCaseWorkFlowGenericModal").modal("show");
			//$("#compassCaseWorkFlowGenericModal-title").html("Email Exchange : "+caseNo);
			$("#compassCaseWorkFlowGenericModal-title").html("To Business : "+caseNo);
			$("#compassCaseWorkFlowGenericModal-body").html("<br/><center><img alt='Loading...' src='"+context+"/includes/images/qde-loadder.gif'><center><br/>");
			$.ajax({
				url : context+"/common/showEmail",
				cache : false,
				data : "caseNo="+caseNo+"&emailNumber="+emailNumber+"&folderType="+folderType,
				type : 'POST',
				success : function(resData){
					$("#compassCaseWorkFlowGenericModal-body").html(resData);
				}
			});*/
			
			/* 03/03/2019*/
			$("#composeEmailMessageModal").modal("show");
			$("#composeEmailMessageModal-title").html("To Business : "+caseNo);
			$("#composeEmailMessageModal-body").html("<br/><center><img alt='Loading...' src='"+context+"/includes/images/qde-loadder.gif'><center><br/>");
			$.ajax({
				url : context+"/common/showEmail",
				cache : false,
				data : "caseNo="+caseNo+"&emailNumber="+emailNumber+"&folderType="+folderType,
				type : 'POST',
				success : function(resData){
					$("#composeEmailMessageModal-body").html(resData);
				}
			});
		},
		highlighFolder : function(folderType){
			$("#emailComponent").children("div").each(function(){
				$(this).children("button").removeClass("btn-primary");
				$(this).children("button").css("font-weight", "normal");
				
				if($(this).children("button").attr("id") == folderType){
					$(this).children("button").addClass("btn-primary");
					$(this).children("button").css("font-weight", "bold");
				}
			});
		},
		showAllMessage : function(context, caseNo, folder){
			$("#emailBodySubjectPanel").html("<br/><center><img alt='Loading...' src='"+context+"/includes/images/qde-loadder.gif'><center><br/>");
			$.ajax({
				url : context+"/common/showAllMessage",
				cache : false,
				data : "caseNo="+caseNo+"&folder="+folder,
				type : 'POST',
				success : function(resData){
					$("#emailBodySubjectPanel").html(resData);
					compassEmailExchange.updateEmailCount(context, caseNo, folder);
				}
			});
		},
		showMessage : function(context, caseNo, emailNumber, folder){
			$("#emailBodySubjectPanel").html("<br/><center><img alt='Loading...' src='"+context+"/includes/images/qde-loadder.gif'><center><br/>");
			$.ajax({
				url : context+"/common/showMessage",
				cache : false,
				data : "caseNo="+caseNo+"&folder="+folder+"&emailNumber="+emailNumber,
				type : 'POST',
				success : function(resData){
					$("#emailBodySubjectPanel").html(resData);
					compassEmailExchange.updateEmailCount(context, caseNo, folder);
				}
			});
		},
		updateEmailCount : function(context, caseNo, folderType){
			$.ajax({
				url : context+"/common/getFolderEmailCount",
				cache : false,
				data : "folder="+folderType+"&caseNo="+caseNo,
				type : 'POST',
				success : function(resData){
					if(parseInt(resData) > 0){
						if(folderType == "INBOX"){
							$("#emailComponent").children("div").find("button#"+folderType).html("Inbox <span class='badge pull-right'>"+resData+"</span>");
						}else{
							$("#emailComponent").children("div").find("button#"+folderType).html("Sent <span class='badge pull-right'>"+resData+"</span>");
						}
					}else{
						if(folderType == "INBOX"){
							$("#emailComponent").children("div").find("button#"+folderType).html("Inbox");
						}else{
							$("#emailComponent").children("div").find("button#"+folderType).html("Sent");
						}
					}
				}
			});
		},
		downloadAttachment : function(context, caseNo, messageNumber, attachmentNumebr){
			$.fileDownload(context+'/common/downloadEmailAttachment?caseNo='+caseNo+'&messageNumber='+messageNumber+'&attachmentNumebr='+attachmentNumebr, {
			    httpMethod : "GET",
				successCallback: function (url) {
			    },
			    failCallback: function (html, url) {
			        alert('Failed to download file'+url+"\n"+html);
			    }
			});
		},
		composeMessage : function(context, caseNo, emailNo, folderType, composeType){
			uploadingFiles = [];
			compassEmailExchange.highlighFolder("COMPOSE");
			$("#emailBodySubjectPanel").html("<br/><center><img alt='Loading...' src='"+context+"/includes/images/qde-loadder.gif'><center><br/>");
			$.ajax({
				url : context+"/common/composeMessage",
				cache : false,
				data : "caseNo="+caseNo+"&emailNo="+emailNo+"&folderType="+folderType+"&composeType="+composeType,
				type : 'POST',
				success : function(resData){
					$("#emailBodySubjectPanel").html(resData);
				}
			});
		},
		FileSelected : function(elm){
			if ('files' in elm) {
			    if (elm.files.length == 0)
			    	alert("Select one or more files.");
			    else
			    	for(var i = 0; i < elm.files.length; i++){
			    		compassEmailExchange.pushFile(elm.files[i]);
				     }				     
			}else{
				alert("No Files");
			}
		},
		pushFile : function(fileObj){
			var push = true;
			for (var i = 0; i < uploadingFiles.length; i++) {
				if(uploadingFiles[i].name == fileObj.name){
					alert(fileObj.name+" is already added as attachments");
					push = false;
				}
		    }
			if(push){
				var maxAllowed = maxFileSize * 1024 * 1024;
				var selectedFilesSize = 0;
				var fileSize = fileObj.size;				
				for (var i = 0; i < uploadingFiles.length; i++) {
					selectedFilesSize = selectedFilesSize + uploadingFiles[i].size;
			    }
				selectedFilesSize = selectedFilesSize + fileSize;
				if(selectedFilesSize > maxAllowed){
					alert("You can attach at most "+maxFileSize+" MB in an Email as attachments");
					push = false;
				}
			}
			if(push){
				var acctualFileType = fileObj.name.slice((fileObj.name.lastIndexOf(".") - 1 >>> 0) + 2);
				if(blockedTypes.indexOf(acctualFileType) > 0){
					alert("You cannot attach "+acctualFileType+" file as an Email attachment");
					push = false;
				}
			}
			if(push){
				uploadingFiles.push(fileObj);
				compassEmailExchange.handleAttachment();
			}
		},
		showRemove : function(elm){
			var width = $(elm).css("width");
			$(elm).removeClass("btn-success").addClass("btn-danger");
			$(elm).css("width", width);
			$(elm).html("Remove");
			
		},
		hideRemove : function(elm){
			$(elm).removeClass("btn-danger").addClass("btn-success");
			$(elm).html($(elm).attr("fileName"));
		},
		removeAttachment : function(elm, e, index){
			e.stopPropagation();
			e.preventDefault();
			uploadingFiles.splice(index, 1);
			compassEmailExchange.handleAttachment();
		},
		handleAttachment : function(){
			$("#attachments").children("button").each(function(){
				$(this).remove();
			});
			var totalSize = 0;
			var unit = "KB";
			for (var i = 0; i < uploadingFiles.length; i++) {
				var num = uploadingFiles[i].size / 1024;
				totalSize = totalSize + uploadingFiles[i].size;
				num = +(Math.round(num + "e+2")  + "e-2");
				var html = "<button style='margin:2px;' class='btn btn-success btn-xs' onclick='compassEmailExchange.removeAttachment(this, event, "+i+")' fileName='"+uploadingFiles[i].name+" ("+num+" KB)' onmouseout='compassEmailExchange.hideRemove(this)' onmouseover='compassEmailExchange.showRemove(this)'>"+uploadingFiles[i].name+" ("+num+" KB)</button>";
				$("#attachments").append(html);
			}
			totalSize = totalSize / 1024;
			if(totalSize > 1024){
				totalSize = totalSize / 1024;
				unit = "MB";
			}
			totalSize = +(Math.round(totalSize + "e+2")  + "e-2");
			$("#totalAttachmentSize").html("<em>Attachment Size : "+totalSize+" "+unit+"</em>")
		},
		getEmailMapping : function(context, elm){
			var mapping = prompt("Enter Email Mapping Code : ","");
			if(mapping != null){
				$.ajax({
					url : context+"/common/getEmailIdsForMapping",
					cache : false,
					data : "mappingCode="+mapping,
					type : 'POST',
					success : function(resData){
						if(resData.STATUS == 0)
							alert("Coundn't find the email ids for "+mapping);
						else{
							$("#to").val(resData.TO);
							$("#cc").val(resData.CC);
						}
					}
				});
			}
		},
		prepareEmailSending : function(context, elm, caseNo){
			_completeCount = 0;
			$(elm).attr("disabled", true);
			$(elm).html("Preparing...");
			$.ajax({
				url : context+"/common/getAttachmentFolder",
				cache : false,
				type : 'POST',
				success : function(resData){
					//if(uploadingFiles.length > 0){
					if(uploadingFiles != undefined && uploadingFiles.length > 0){
						for (var i = 0; i < uploadingFiles.length; i++){
							$(elm).html("Attaching File...");
							var fd = new FormData();
						    fd.append('file', uploadingFiles[i]);
						    fd.append('caseNo', caseNo);
						    fd.append('attachmentFolder', resData);
						    compassEmailExchange.emailAttachments(context, elm, caseNo, fd, resData);
						}
					}else{
						compassEmailExchange.sendEmail(context, elm, caseNo, resData);
					}
				}
			});
		},
		emailAttachments : function (context, elm, caseNo, formData, attachmentFolder){
			$.ajax({
				url: context + "/common/emailAttachments",
		        type: "POST",
		        contentType:false,
		        processData: false,
		        enctype : "multipart/form-data",
		        cache: false,
		        data: formData,
				success : function(resData){
					_completeCount++;
					if((_completeCount == uploadingFiles.length)){
		        		setTimeout(compassEmailExchange.sendEmail(context, elm, caseNo, attachmentFolder), 2000);
		        	}
				}
			});
		},
		sendEmail : function (context, elm, caseNo, attachmentFolder){
			var table = $(elm).parents("table");
			var to = $(table).find("#to").val();
			var cc = $(table).find("#cc").val();
			var subject = $(table).find("#subject1").val() + " " + $(table).find("#subject2").val();
			//var content = CKEDITOR.instances['editor1'].getData();
			var content = encodeURI(CKEDITOR.instances['editor1'].getData());
			//console.log("email content = "+content);		
			
			var fullData = "caseNo="+caseNo+"&to="+to+"&cc="+cc+"&subject="+subject+"&content="+content+"&attachmentFolder="+attachmentFolder;
			var fullData2 = "CaseNos="+caseNo+"&CaseStatus=51&Comments=Email Sent to Business&FraudIndicator=Email_To_Business&RemovalReason=NA&OutcomeIndicator=NA"+
							"&HighRiskReasonCode=NA&AddedToFalsePositive=N&LastReviewedDate=&addedToMarkAll=N&exitRecommended=N&userActionType=saveAndClose&reassignToUserCode=NA"+
							"&alertNos=&fiuReferenceNo=&fiuReferenceDate=&fromDate=&toDate=&alertCode=&branchCode=&accountNo=&customerId=&hasAnyOldCases=&caseRating=&fromCaseNo=&toCaseNo=";
			$(elm).html("Sending...");
			$.ajax({
				url : context+"/common/sendEmail",
				cache : false,
				data : fullData,
				type : 'POST',
				success : function(resData){
					$(elm).removeAttr("disabled");
					$(elm).html("Send");
					alert(resData.MSG);
					//alert(resData.STATUS);
					if(resData.STATUS == 1){
						//$("#compassCaseWorkFlowGenericModal").modal("hide");
						$.ajax({
							url : context+"/amlCaseWorkFlow/saveComments",
							cache : false,
							data : fullData2,
							type : 'POST',
							success : function(resData){
								//alert("Saved successfully.");
								//$("#"+parentFormId).submit();
								$(".compass-tab-content").find("div.active").find("form").submit();
								$("#composeEmailMessageModal").modal("hide");
								//window.opener.$("#"+parentFormId).submit();
								window.opener.$(".compass-tab-content").find("div.active").find("form").submit();
								window.close();
							},
							error: function(a,b,c){
								// alert(a+b+c);
								alert("Error While Updating : "+a+b+c);
							}
						});
					}
				}
			});
		}
	}
}());
var compassStaffEmailExchange = compassStaffEmailExchange || (function(){
	var uploadingFiles;
	var maxFileSize = 3;
	var blockedTypes = "exe,sh";
	var _completeCount = 0;
	return {
		openEmail : function(context, reportId, reportCaseNo, fromDate, toDate, staffAccNo, emailNumber, folderType){
			$("#compassCaseWorkFlowGenericModal").modal("show");
			$("#compassCaseWorkFlowGenericModal-title").html("Staff Email Exchange : "+reportCaseNo);
			$("#compassCaseWorkFlowGenericModal-body").html("<br/><center><img alt='Loading...' src='"+context+"/includes/images/qde-loadder.gif'><center><br/>");
			//alert(reportId+", "+reportCaseNo+", "+fromDate+", "+toDate+", "+staffAccNo+", "+folderType);
			$.ajax({
				url : context+"/common/showStaffEmail",
				cache : false,
				data : "reportId="+reportId+"&reportCaseNo="+reportCaseNo+"&fromDate="+fromDate+"&toDate="+toDate+"&staffAccNo="+staffAccNo+"&folderType="+folderType+"&emailNumber="+emailNumber,
				type : 'POST',
				success : function(resData){
					$("#compassCaseWorkFlowGenericModal-body").html(resData);
				}
			});
		},
		highlightFolder : function(folderType){
			$("#emailComponent").children("div").each(function(){
				$(this).children("button").removeClass("btn-primary");
				$(this).children("button").css("font-weight", "normal");
				
				if($(this).children("button").attr("id") == folderType){
					$(this).children("button").addClass("btn-primary");
					$(this).children("button").css("font-weight", "bold");
				}
			});
		},
		showAllMessage : function(context, reportId, reportCaseNo, folder){
			$("#emailBodySubjectPanel").html("<br/><center><img alt='Loading...' src='"+context+"/includes/images/qde-loadder.gif'><center><br/>");
			$.ajax({
				url : context+"/common/showAllStaffMessage",
				cache : false,
				data : "reportId="+reportId+"&reportCaseNo="+reportCaseNo+"&folder="+folder,
				type : 'POST',
				success : function(resData){
					$("#emailBodySubjectPanel").html(resData);
					compassStaffEmailExchange.updateEmailCount(context, reportId, reportCaseNo, folder);
				}
			});
		},
		showMessage : function(context, reportId, reportCaseNo, emailNumber, folder){
			$("#emailBodySubjectPanel").html("<br/><center><img alt='Loading...' src='"+context+"/includes/images/qde-loadder.gif'><center><br/>");
			$.ajax({
				url : context+"/common/showStaffMessage",
				cache : false,
				data : "reportId="+reportId+"&reportCaseNo="+reportCaseNo+"&folder="+folder+"&emailNumber="+emailNumber,
				type : 'POST',
				success : function(resData){
					$("#emailBodySubjectPanel").html(resData);
					compassStaffEmailExchange.updateEmailCount(context, reportId, reportCaseNo, folder);
				}
			});
		},
		updateEmailCount : function(context, reportId, reportCaseNo, folderType){
			$.ajax({
				url : context+"/common/getFolderEmailCount",
				cache : false,
				data : "folder="+folderType+"&reportId="+reportId+"&reportCaseNo="+reportCaseNo,
				type : 'POST',
				success : function(resData){
					if(parseInt(resData) > 0){
						if(folderType == "INBOX"){
							$("#emailComponent").children("div").find("button#"+folderType).html("Inbox <span class='badge pull-right'>"+resData+"</span>");
						}else if(folderType == "SENT"){
							$("#emailComponent").children("div").find("button#"+folderType).html("Sent <span class='badge pull-right'>"+resData+"</span>");
						}else{
							$("#emailComponent").children("div").find("button#"+folderType).html("Drafts <span class='badge pull-right'>"+resData+"</span>");
						}
					}else{
						if(folderType == "INBOX"){
							$("#emailComponent").children("div").find("button#"+folderType).html("Inbox");
						}else if(folderType == "SENT"){
							$("#emailComponent").children("div").find("button#"+folderType).html("Sent");
						}else{
							$("#emailComponent").children("div").find("button#"+folderType).html("Drafts");
						}						
					}
				}
			});
		},
		downloadAttachment : function(context, reportCaseNo, messageNumber, attachmentNumebr){
			$.fileDownload(context+'/common/downloadEmailAttachment?caseNo='+reportCaseNo+'&messageNumber='+messageNumber+'&attachmentNumebr='+attachmentNumebr, {
			    httpMethod : "GET",
				successCallback: function (url) {
			    },
			    failCallback: function (html, url) {
			        alert('Failed to download file'+url+"\n"+html);
			    }
			});
		},
		composeMessage : function(context, reportId, reportCaseNo, emailNo, fromDate, toDate, staffAccNo, folderType, composeType){
			//alert(fromDate+", "+toDate+", "+staffAccNo+", "+folderType+", "+composeType);
			uploadingFiles = [];
			compassStaffEmailExchange.highlightFolder("COMPOSE");
			$("#emailBodySubjectPanel").html("<br/><center><img alt='Loading...' src='"+context+"/includes/images/qde-loadder.gif'><center><br/>");
			$.ajax({
				url : context+"/common/composeStaffMessage",
				cache : false,
				data : "reportId="+reportId+"&reportCaseNo="+reportCaseNo+"&fromDate="+fromDate+"&toDate="+toDate+"&staffAccNo="+staffAccNo+"&emailNo="+emailNo+"&folderType="+folderType+"&composeType="+composeType,
				type : 'POST',
				success : function(resData){
					$("#emailBodySubjectPanel").html(resData);
				}
			});
		},
		FileSelected : function(elm, fileCount){
			//alert(fileCount);
			if ('files' in elm) {
			    if (elm.files.length == 0)
			    	alert("Select one or more files.");
			    else
			    	for(var i = 0; i < elm.files.length; i++){
			    		compassStaffEmailExchange.pushFile(elm.files[i]);
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
				compassStaffEmailExchange.handleAttachment();
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
			compassStaffEmailExchange.handleAttachment();
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
				var html = "<button style='margin:2px;' class='btn btn-success btn-xs' onclick='compassStaffEmailExchange.removeAttachment(this, event, "+i+")' fileName='"+uploadingFiles[i].name+" ("+num+" KB)' onmouseout='compassStaffEmailExchange.hideRemove(this)' onmouseover='compassStaffEmailExchange.showRemove(this)'>"+uploadingFiles[i].name+" ("+num+" KB)</button>";
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
		prepareEmailSending : function(context, elm, reportCaseNo, isDraft, emailNo){
			_completeCount = 0;
			//alert("sending email for sending");
			$(elm).attr("disabled", true);
			$(elm).html("Preparing to send...");
			$.ajax({
				url : context+"/common/getAttachmentFolder",
				cache : false,
				type : 'POST',
				success : function(resData){
					if(uploadingFiles.length > 0){
						for (var i = 0; i < uploadingFiles.length; i++){
							$(elm).html("Attaching File...");
							var fd = new FormData();
						    fd.append('file', uploadingFiles[i]);
						    fd.append('caseNo', reportCaseNo);
						    fd.append('attachmentFolder', resData);
						    alert("uploading...");
						    compassStaffEmailExchange.emailAttachments(context, elm, reportCaseNo, fd, resData, isDraft, emailNo);
						}
					}else{
						//alert("sending...");
						compassStaffEmailExchange.sendEmail(context, elm, reportCaseNo, resData, isDraft, emailNo);
					}
				}
			});
		},
		emailAttachments : function (context, elm, reportCaseNo, formData, attachmentFolder, isDraft, emailNo){
			//alert("formData for attachment= "+formData);
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
		        		setTimeout(compassStaffEmailExchange.sendEmail(context, elm, reportCaseNo, attachmentFolder, isDraft, emailNo), 2000);
		        	}
				}
			});
		},
		sendEmail : function (context, elm, reportCaseNo, attachmentFolder, isDraft, emailNo){
			var table = $(elm).parents("table");
			var to = $(table).find("#to").val();
			var cc = $(table).find("#cc").val();
			var bcc = $(table).find("#bcc").val();
			var subject = $(table).find("#subject1").val() + " " + $(table).find("#subject2").val();
			//var content = encodeURI(CKEDITOR.instances['editor1'].getData().replace(/[&]nbsp[;]/gi," "));
			var content = CKEDITOR.instances['editor1'].getData();
			
			$(elm).html("Sending...");
			//alert("emailNo:"+emailNo+"caseNo:"+caseNo+"to:"+to+"cc:"+cc+"subject:"+subject+"content:"+content+"attachmentFolder:"+attachmentFolder+"isDraft:"+isDraft);
			$.ajax({
				url : context+"/common/sendEmail",
				cache : false,
				data : {caseNo:reportCaseNo,to:to,cc:cc,bcc:bcc,subject:subject,content:content,attachmentFolder:attachmentFolder,isDraft:isDraft,emailNo:emailNo},//fullData,
				type : 'POST',
				success : function(resData){
					$(elm).removeAttr("disabled");
					$(elm).html("Send");
					alert(resData.MSG);
					if(resData.STATUS = 1){
						$("#compassCaseWorkFlowGenericModal").modal("hide");
					}
				}
			});
		}
	}
}());
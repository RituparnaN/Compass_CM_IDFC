var compassFileUploadFromPortal = compassFileUploadFromPortal || (function(){
	var uploadingFiles;
	var blockFiles;
	var allowedFiles;
	var maxFileSize;
	var fileSelectCount;
	var _uploadUrl;
	var _processingUrl;
	var _moduleRefId;
	var _moduleUnqNo = "";
	var _uploading = 0;
	var _unqId;
	var _completeCount = 0;
	var _readFlag = 'N';
	var _fileAttachUrl;
	var _searchUrl;
	var _uploadEnable;
	var _removeEmable;
	return {
		init : function(uploadButton, searchUrl, moduleRefId, searchResultPanel, uploadEnable, removeEmable, caseNo){
			//alert(uploadButton+", "+searchUrl+", "+moduleRefId+", "+searchResultPanel+", "+uploadEnable+", "+removeEmable+", "+caseNo);
			_searchUrl = searchUrl;
			_uploadUrl = searchUrl+"/commonFromPortal/genericFileUploadFromPortal";
			_processingUrl = searchUrl+"/commonFromPortal/genericFileProcessFromPortal";
			_uploadEnable = uploadEnable;
			_removeEmable = removeEmable;
			
			uploadingFiles = [];
			_moduleRefId = moduleRefId;
			_uploading = 0;
			_readFlag = 'N';
			_moduleUnqNo = caseNo;
			compassFileUploadFromPortal.handleFileUpload();
				
			$("#"+searchResultPanel).find("table").children("tbody").children("tr").each(function(){
				if($(this).children("td").children("input").prop("checked")){
					_moduleUnqNo = $(this).children("td").children("input").val();
				}
			});
				
			if(searchResultPanel != "0" && _moduleUnqNo == ""){
				alert("Select a record");
				return false;
			}
					
			$("#compassFileUploadModal").modal("show");
			$("#compassFileUploadModal-title").html("...");
			$("#compassFileUploadModal-loader").css("display", "block");
			$("#compassFileUploadModal-upload").css("display", "none");
			$("#compassFileUploadModal-process").css("display", "none");
			$("#compassFileUploadModal-uploadFileSize").html("...");
			$("#compassFileUploadModal-uploadFileAllowedType").html("...");
			$("#compassFileUploadModal-uploadFileBlockedType").html("...");
			$("#compassFileUploadModal-uploadFileMaxNoSize").html("...");
			$("#compassFileUploadModal-uploadedFiles").html("<center></br>No File Available For Download</br></br></center>");
			if(_uploadEnable == "Y"){
				$("#compassFileUploadModal-uploadEnable").html("<strong>Yes</strong>");
			}else{
				$("#compassFileUploadModal-uploadEnable").html("<strong>No</strong>");
			}
				
				
			$.ajax({
				url : searchUrl+"/commonFromPortal/getFileUploadConfigFromPortal",
				cache : false,
				data : "moduleRefId="+moduleRefId+"&moduleUnqNo="+_moduleUnqNo,
				type : 'GET',
				success : function(resData){
					if(resData.MODULENAME == undefined){
						$("#compassFileUploadModal").modal("hide");
						alert("Upload Configuration not found for this Upload type. Please contact administrator");
					}else{
						if(resData.UPLOADEDFILES != ""){
							$("#compassFileUploadModal-upload").children("div:first-child").removeClass("col-sm-9").addClass("col-sm-6");
							$("#compassFileUploadModal-upload").children("div:nth-child(2)").removeClass("col-sm-3").addClass("col-sm-6");
							var table = "<table class='table table-bordered tablestripped'>"+
										"	<tr>"+
										"		<th width='33%'>File Name</th>"+
										"		<th width='33%'>File Size</th>"+
										"		<th width='33%'><button class='btn btn-warning btn-xs' onclick=\"compassFileUploadFromPortal.downloadFile(this, '', '', '', '"+_moduleUnqNo+"')\">Download All</button></th>"+
										"	</tr>";
							$.each(resData.UPLOADEDFILES, function(key,value){
								table = table + "<tr>" +
												"	<td>"+value.FILENAME+"</td>"+
												"	<td>"+value.FILESIZE+"</td>"+
												"	<td> "+
												"		<button class='btn btn-warning btn-xs' onclick=\"compassFileUploadFromPortal.downloadFile(this, '"+value.SEQNO+"', '"+value.UPLOADREFNO+"', '"+value.MODULEREF+"', '"+_moduleUnqNo+"')\">Download</button>"+
												"		<button class='btn btn-danger btn-xs' onclick=\"compassFileUploadFromPortal.removeFile(this, '"+value.SEQNO+"', '"+value.UPLOADREFNO+"', '"+value.MODULEREF+"', '"+_moduleUnqNo+"')\">Remove</button>"+
												"	</td>"+
												"</tr>";
							});
							table = table + "</table>";
							$("#compassFileUploadModal-uploadedFiles").html(table);
						}else{
							$("#compassFileUploadModal-upload").children("div:first-child").removeClass("col-sm-6").addClass("col-sm-9");
							$("#compassFileUploadModal-upload").children("div:nth-child(2)").removeClass("col-sm-6").addClass("col-sm-3");
						}
						blockFiles = resData.BLOCKFILETYPES;
						maxFileSize = parseInt(resData.FILEMAXSIZE)*1024;
						allowedFiles = resData.ALLOWFILETYPES;
						fileSelectCount = resData.SELECTFILECOUNT;
						_unqId = resData.UNQID;
						_readFlag = resData.READFLAG;
						_fileAttachUrl = resData.ATTACHFILEURL;
						
						$("#compassFileUploadModal-title").html(resData.MODULENAME);
						$("#compassFileUploadModal-loader").css("display", "none");
						$("#compassFileUploadModal-upload").css("display", "block");
						if(resData.FILEMAXSIZE == 0)
							$("#compassFileUploadModal-uploadFileSize").html("<strong>no limit</strong>");
						else
							$("#compassFileUploadModal-uploadFileSize").html("<strong>"+resData.FILEMAXSIZE+" MB</strong>");
						$("#compassFileUploadModal-uploadFileAllowedType").html("<strong>"+resData.ALLOWFILETYPES+"</strong>");
						$("#compassFileUploadModal-uploadFileBlockedType").html("<strong>"+resData.BLOCKFILETYPES+"</strong>");
						$("#compassFileUploadModal-uploadFileMaxNoSize").html("<strong>"+resData.SELECTFILECOUNT+"</strong>");
					}
				},
				error : function(a,b,c){
					alert("Something went wrong");
				}
			});
		},
		FileSelected : function(elm){
			if ('files' in elm) {
			    if (elm.files.length == 0)
			    	alert("Select one or more files.");
			    else
			    	for(var i = 0; i < elm.files.length; i++){
			    		compassFileUploadFromPortal.pushFile(elm.files[i]);
				     }				     
			}else{
				alert("No Files");
			}
		},
		pushFile : function(fileObj){
			var push = true;
			for (var i = 0; i < uploadingFiles.length; i++) {
				if(uploadingFiles[i].name == fileObj.name)
					push = false;
		    }
			if(push){
				if(maxFileSize != 0 && fileObj.size > (maxFileSize*1024)){
					var allowedSize = +(Math.round(maxFileSize / 1024 + "e+2")  + "e-2");
					var acctualSize = +(Math.round((fileObj.size / 1048576) + "e+2")  + "e-2");
					alert("File size of "+fileObj.name+" is "+acctualSize+" MB where allowed file size is "+allowedSize+" MB");
				}else{
					var acctualFileType = fileObj.name.slice((fileObj.name.lastIndexOf(".") - 1 >>> 0) + 2);
					if((allowedFiles != "ALL") && (allowedFiles.indexOf(acctualFileType) < 0)){
						alert(fileObj.name+" file type "+acctualFileType+" is not allowed");
					}else if((blockFiles != "ALL") && (blockFiles.indexOf(acctualFileType) > -1)){
						alert(fileObj.name+" file type "+acctualFileType+" is not allowed");
					} else if(uploadingFiles.length == fileSelectCount){
						alert("You can select at most "+fileSelectCount+" files for this upload");
					}else{
						if(_uploading == 0){
							if(_uploadEnable == "Y"){
								uploadingFiles.push(fileObj);
								compassFileUploadFromPortal.handleFileUpload();
								$("#upload").removeAttr("disabled");
							}else{
								alert("File uploading is not available");
							}
						}else{
							alert("If you want to upload more file, close and re-open the uploader")
						}
					}
				}
			}else
				alert(fileObj.name+" is already added in the queue for upload.")
		},
		handleFileUpload : function() {			
			$("#upload-files").children("tbody").children("tr").each(function(i,k){
				if(i != 0){
					$(this).remove();
				}
			});
			for (var i = 0; i < uploadingFiles.length; i++) {
				var num = uploadingFiles[i].size / 1024;
				num = +(Math.round(num + "e+2")  + "e-2");
				var tr = "<tr id='uploadItem"+i+"'><td>"+uploadingFiles[i].name+"</td><td>"+num+" KB</td><td>"+uploadingFiles[i].name.slice((uploadingFiles[i].name.lastIndexOf(".") - 1 >>> 0) + 2)+"</td><td>&nbsp;</td><td><button type='button' class='btn btn-danger btn-xs' onclick='compassFileUploadFromPortal.removeFromUpload("+i+")'>Delete</button></td></tr>"
				$("#upload-files").append(tr);
			}
		},		
		removeFromUpload : function(index){
			uploadingFiles.splice(index, 1);
			compassFileUploadFromPortal.handleFileUpload();
			if(uploadingFiles.length == 0)
				$("#upload").attr("disabled", true);
		},
		createStatusBar : function(elm){
			$("#"+elm).children("td:nth-child(4)").html("<div class='progress' style='margin:0;'><div class='progress-bar' role='progressbar' aria-valuenow='0' aria-valuemin='0' aria-valuemax='100' style='width:0%'>0%</div></div>");
		},
		setProgress : function(id, progress){
			$("#"+id).children("td:nth-child(4)").children("div.progress").children("div.progress-bar").attr("aria-valuenow", progress);
			$("#"+id).children("td:nth-child(4)").children("div.progress").children("div.progress-bar").css("width",progress+"%");
			$("#"+id).children("td:nth-child(4)").children("div.progress").children("div.progress-bar").html(progress+"%");
		},
		startUpload : function(elm){
			if(confirm("Are you sure?")){
				$(elm).attr("disabled", true);
				_uploading = 1;
				_completeCount = 0;
				for (var i = 0; i < uploadingFiles.length; i++){
					$("#uploadItem"+i).children("td:nth-child(5)").html("Starting upload...");
					var fd = new FormData();
				    fd.append('file', uploadingFiles[i]);
				    fd.append('uploadRefId', _moduleRefId);
				    fd.append('unqId', _unqId);
				    fd.append('seqNo', i);
				    fd.append('moduleUnqNo', _moduleUnqNo);
				    new compassFileUploadFromPortal.createStatusBar("uploadItem"+i);
				    compassFileUploadFromPortal.sendFileToServer("uploadItem"+i, fd);
				}
			}			
		},
		sendFileToServer : function(elm, formData){
		    var jqXHR=$.ajax({
		    	xhr: function() {
		    		var xhrobj = $.ajaxSettings.xhr();
		    		if (xhrobj.upload) {
		    			xhrobj.upload.addEventListener('progress', function(event) {
		            		var percent = 0;
		                    var position = event.loaded || event.position;
		                    var total = event.total;
		                    if (event.lengthComputable) {
		                    	percent = Math.ceil(position / total * 100);
		                    }
		                    compassFileUploadFromPortal.setProgress(elm, percent);
		                    if(percent == 100)
		                    	$("#"+elm).children("td:nth-child(5)").html("Writing file...");
		                    else
		                    	$("#"+elm).children("td:nth-child(5)").html("Uploading...");
		    			}, false);
		    		}
		        return xhrobj;
		    	},
		        url: _uploadUrl,
		        type: "POST",
		        contentType:false,
		        processData: false,
		        enctype : "multipart/form-data",
		        cache: false,
		        data: formData,
		        success: function(data){
		        	compassFileUploadFromPortal.setProgress(elm, 100);
		        	$("#"+elm).children("td:nth-child(5)").html("Uploaded");
		        	_completeCount++;		        	
		        	if((_completeCount == uploadingFiles.length) && _readFlag == "Y"){
		        		for (var i = 0; i < uploadingFiles.length; i++) {
		        			$("#uploadItem"+i).children("td:nth-child(5)").html("Processing...");
		    			}
		        		compassFileUploadFromPortal.processUploadedFiles();
		        	}else if((_completeCount == uploadingFiles.length)){
		        		setTimeout(compassFileUploadFromPortal.attachFile(), 2000);
		        	}
		        },
		        error : function(a,b,c){
		        	alert(a.status+" "+b+" "+c);
		        }
		    }); 
		},
		processUploadedFiles : function(){
			$.ajax({
				url : _processingUrl,
				type: "POST",
				cache : false,
				data : "uploadRefNo="+_unqId+"&moduleRefId="+_moduleRefId,
				success : function(resData){
					var successAll = true;
					$.each(resData, function(key,value){
						if(successAll && value.STATUS == "0")
							successAll = false;
						$("#uploadItem"+value.SEQNO).children("td:nth-child(5)").html(value.MESSAGE);
					});
					if(successAll){
						setTimeout(compassFileUploadFromPortal.attachFile(), 2000);
					}
				},
				error : function(){
					alert("Error while file processing");
				}
			});
		},
		attachFile : function(){
			$.ajax({
				url : _searchUrl+_fileAttachUrl,
				type: "POST",
				cache : false,
				data : "uploadRefNo="+_unqId+"&moduleRefId="+_moduleRefId+"&moduleUnqNo="+_moduleUnqNo,
				success : function(resData){
					$("#compassFileUploadModal-upload").css("display", "none");
					$("#compassFileUploadModal-process").css("display", "block");
					$("#compassFileUploadModal-process").html(resData);
				},
				error : function(a,b,c){
					alert("Error while file attaching"+a+c+b);
				}
			});
		},
		downloadFile : function(elm, seqNo, uploadRefNo, moduleRefNo, moduleUnqNo){
			var accVal = $(elm).html();
			$(elm).html("Downloading...");
			$.fileDownload(_searchUrl+'/commonFromPortal/downloadServerFileFromPortal?seqNo='+seqNo+'&uploadRefNo='+uploadRefNo+'&moduleRefNo='+moduleRefNo+"&moduleUnqNo="+moduleUnqNo, {
			    httpMethod : "GET",
				successCallback: function (url) {					 
			    	$(elm).html(accVal);
			    },
			    failCallback: function (html, url) {
			        alert('Failed to download file'+url+"\n"+html);
			    }
			});
		},
		removeFile : function(elm, seqNo, uploadRefNo, moduleRefNo, moduleUnqNo){
			if(_removeEmable == "Y"){
				if(confirm("Are you sure?")){
					var accVal = $(elm).html();
					$(elm).html("Removing...");
					$.ajax({
						url : _searchUrl+'/commonFromPortal/removeServerFileFromPortal?seqNo='+seqNo+'&uploadRefNo='+uploadRefNo+'&moduleRefNo='+moduleRefNo+"&moduleUnqNo="+moduleUnqNo,
						type: "POST",
						cache : false,
						success : function(resData){
							alert(resData);
							$(elm).parent("td").parent("tr").remove();
						},
						error : function(a,b,c){
							alert("Error while removing file : "+a+c+b);
						}
					});
				}
			}else{
				alert("This file cannot be deleted");
			}
		}
	};
}());
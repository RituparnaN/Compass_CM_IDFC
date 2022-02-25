<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../tags/tags.jsp"%>
<%
String contextPath = request.getContextPath()==null?"":request.getContextPath();
String caseNo = (String) request.getAttribute("caseNo");
%>
<html>
	<head>
		<jsp:include page="../tags/staticFiles.jsp"></jsp:include>
		<script type="text/javascript">
			var timer;
			var caseNo = '<%=caseNo%>';
						
			$(document).ready(function(){
				if(caseNo != '' && caseNo != 'null'){
					
					$.ajax({
						type : "POST",
						url : "${pageContext.request.contextPath}/common/generateFATCAFile?caseNo="+caseNo,
						cache : false,
						success : function(res){
							$("#message").html(res.MESSAGE);
							getStatus(caseNo);
							if(res.STARTGENERATION == "1"){
								startFetchingStatus(caseNo);
							}
						},
						error : function(a,b,c){
							$("#message").html("Error while starting process. "+c);
						}
					});
				}else{
					alert("Invalid case no");
				}
				
				$(".donwloadXMLFile").click(function(){
					var typeType = $(this).attr("fileType");
					if(timer == undefined)
						startFetchingStatus(caseNo);
					$.fileDownload('${pageContext.request.contextPath}/common/donwloadXMLFile?caseNo='+caseNo+'&typeType='+typeType, {
						httpMethod : "GET",
					    successCallback: function (url) {					 
					        alert('You just got a file download dialog or ribbon for this URL :' + url);
					    },
					    failCallback: function (html, url) {					 
					        alert('Your file download just failed for this URL:' + url + '\r\n' +
					                'Here was the resulting error HTML: \r\n' + html
					                );
					    }
					});
				});
				
				$("#DownloadCaseFolder").click(function(){
					if(timer == undefined)
						startFetchingStatus(caseNo);
					$.fileDownload('${pageContext.request.contextPath}/common/DownloadCaseFolder?caseNo='+caseNo, {
						httpMethod : "GET",
					    successCallback: function (url) {					 
					        alert('You just got a file download dialog or ribbon for this URL :' + url);
					    },
					    failCallback: function (html, url) {					 
					        alert('Your file download just failed for this URL:' + url + '\r\n' +
					                'Here was the resulting error HTML: \r\n' + html
					                );
					    }
					});
				});
				
				$(".continueWithXMLFile").click(function(){
					var typeType = $(this).attr("fileType");
					if(timer == undefined)
						startFetchingStatus(caseNo);
					$.ajax({
						type : "POST",
						url : "${pageContext.request.contextPath}/common/processXMLFile?caseNo="+caseNo+"&typeType="+typeType,
						cache : false,
						success : function(res){
							if(res != "")
								alert(res);
						},
						error : function(a,b,c){
							alert("Error while starting XML processing. "+c);
						}
					});
				});
				
				$(".continueUnpack").click(function(){
					if(timer == undefined)
						startFetchingStatus(caseNo);
					$.ajax({
						type : "POST",
						url : "${pageContext.request.contextPath}/common/unpackIRSZipNotification?caseNo="+caseNo,
						cache : false,
						success : function(res){
							if(res != "")
								alert(res);
						},
						error : function(a,b,c){
							alert("Error while starting Zip processing. "+c);
						}
					});
				});
				
				$("#uploadXMLFile").click(function(){
					if(timer == undefined)
						startFetchingStatus(caseNo);
					var formData = new FormData(document.getElementById("uploadFATCAXMLFile"));
					$.ajax({
						url: "${pageContext.request.contextPath}/common/uploadFATCAXMLFile",
			            type: "POST",
			            data: formData,
			            enctype: 'multipart/form-data',
			            processData: false,
			            contentType: false,
			            success : function(res){
							if(res != " ")
								alert(res);
							$("#filename").val("");
						},
						error : function(a,b,c){
							alert("Error while uploading XML file. "+c);
						}
					});
				});
				
				$("#uploadZipFile").click(function(){
					if(timer == undefined)
						startFetchingStatus(caseNo);
					var formData = new FormData(document.getElementById("uploadIRSZipFile"));
					$.ajax({
						url: "${pageContext.request.contextPath}/common/uploadIRSZipFile",
			            type: "POST",
			            data: formData,
			            enctype: 'multipart/form-data',
			            processData: false,
			            contentType: false,
			            success : function(res){
							if(res != " ")
								alert(res);
							$("#fis_filename").val("");
						},
						error : function(a,b,c){
							alert("Error while uploading ZIP file. "+c);
						}
					});
				});
				
				$("#ViewPayload").click(function(){
					if(timer == undefined)
						startFetchingStatus(caseNo);
					$("#payloadModal").modal('show');
					$.ajax({
						type : "POST",
						url : "${pageContext.request.contextPath}/common/readPlayLoad?caseNo="+caseNo,
						cache : false,
						success : function(res){
							$("#payloadModal").css("max-height", $(window).height()- 30);
							$("#payloadTitle").html("IRS Notification");
							$("#payloadDetails").html(res);
						},
						error : function(a,b,c){
							alert("Error while reading IRS Payload. "+c);
						}
					});
				});
				 
			});
			
			function startFetchingStatus(caseNo){
				timer = setInterval(function(){ 
					getStatus(caseNo);
					}, 2000);
			}
			
			function startOver(){
				if(confirm("All current status, FATCA Package Folder and IRS Notification folder will be deleted and process will be started from begining for this CASE NO : "+caseNo+". Do you confirm?")){
					window.location.href = "${pageContext.request.contextPath}/common/reGenerateFATCAFile?caseNo="+caseNo;
				}
			}
			
			function getStatus(caseNo){
				$.ajax({
					type : "GET",
					url : "${pageContext.request.contextPath}/common/getFATCAMessageStatus?caseNo=<%=caseNo%>",
					cache : false,
					success : function(res){
						var html = "";
						
						if(res.FATCAGENERATIONLOG.status == 0){
							$("#status").html("Not Started");
						}else if(res.FATCAGENERATIONLOG.status == 1){
							$("#status").html("Running");
						}else if(res.FATCAGENERATIONLOG.status == 2){
							$("#status").html("Completed");
						}else if(res.FATCAGENERATIONLOG.status == 3){
							$("#status").html("Inturrepted");
						}else{
							$("#status").html("Not Started");
						}
						
						if(res.FATCAGENERATIONLOG.startDate != ""){
							$("#starttime").html(res.FATCAGENERATIONLOG.startDate);
						}else{
							$("#starttime").html("...");
						}
						
						if(res.FATCAGENERATIONLOG.message != "" && res.FATCAGENERATIONLOG.message != undefined){
							$("#message").html(res.FATCAGENERATIONLOG.message);
						}
						
						if(res.FATCAGENERATIONLOG.startDate != "null"){
							$("#endtime").html(res.FATCAGENERATIONLOG.endDate);
						}else{
							$("#endtime").html("...");
						}
						
						$("#startedBy").html(res.FATCAGENERATIONLOG.generatedBy);
						
						if(res.FATCAGENERATIONLOG.originalXMLFile != ""){
							html = "<table class='table table-bordered'><tr><td>"+res.FATCAGENERATIONLOG.originalXMLFile+"</td></tr></table>"
							$("#originalFile").html(html);
							$("#originalFileDownload").show();
						}else{
							$("#originalFile").html("...");
							$("#originalFileDownload").hide();
						}
						
						if(res.FATCAGENERATIONLOG.originalFileValid == true){
							$("#originalFileContinue").show();
						}else{
							$("#originalFileContinue").hide();
						}
						
						if(parseInt(res.FATCAGENERATIONLOG.progressStatus) >=2){
							$("#uploadFATCAFileSection").show();
						}else{
							$("#uploadFATCAFileSection").hide();
						}
						
						if(parseInt(res.FATCAGENERATIONLOG.progressStatus) >=6){
							$("#uploadIRSZipFileSection").show();
						}else{
							$("#uploadIRSZipFileSection").hide();
						}
						
						if(res.FATCAGENERATIONLOG.uploadedXMLFile != ""){
							html = "<table class='table table-bordered'><tr><td>"+res.FATCAGENERATIONLOG.uploadedXMLFile+"</td></tr></table>"
							$("#uploadedFile").html(html);
							$("#uploadedFileDownload").show();
						}else{
							$("#uploadedFile").html("...");
							$("#uploadedFileDownload").hide();
						}
						
						if(res.FATCAGENERATIONLOG.uploadedFileValid == true){
							$("#uploadedFileContinue").show();
						}else{
							$("#uploadedFileContinue").hide();
						}
						
						if(res.FATCAGENERATIONLOG.signedXMLFile != ""){
							$("#signedXMLFileDisplay").html(res.FATCAGENERATIONLOG.signedXMLFile);
							$("#signedXMLFileDownload").show();
						}else{
							$("#signedXMLFileDisplay").html("...");
							$("#signedXMLFileDownload").hide();
						}
						
						if(res.FATCAGENERATIONLOG.generatedZipFile != ""){
							$("#fatcaFinalZIPFileDisplay").html(res.FATCAGENERATIONLOG.generatedZipFile);
							$("#fatcaFinalZIPFileDownload").show();
						}else{
							$("#fatcaFinalZIPFileDisplay").html("...");
							$("#fatcaFinalZIPFileDownload").hide();
						}
						
						if(res.FATCAGENERATIONLOG.irsnotificationFile != ""){
							html = "<table class='table table-bordered'><tr><td>"+res.FATCAGENERATIONLOG.irsnotificationFile+"</td></tr></table>"
							$("#uploadedZipFile").html(html);
							$("#uploadedZipFileDownload").show();
						}else{
							$("#uploadedZipFile").html("...");
							$("#uploadedZipFileDownload").hide();
						}
						
						if(parseInt(res.FATCAGENERATIONLOG.progressStatus) >= 7){
							$("#uploadedZipFileContinue").show();
						}else{
							$("#uploadedZipFileContinue").hide();
						}
						
						if(res.FATCAGENERATIONLOG.irsPayloadFile != ""){
							$("#IRSPayloadFileDisplay").html(res.FATCAGENERATIONLOG.irsPayloadFile);
							$("#IRSPayloadFileDownload").show();
							$("#IRSPayloadFileParse").show();
							$("#additionalButton").show();
						}else{
							$("#IRSPayloadFileDisplay").html("...");
							$("#IRSPayloadFileDownload").hide();
							$("#IRSPayloadFileParse").hide();
							$("#additionalButton").hide();
						}
						
						if(res.FATCAGENERATIONLOG.irsMetadataFile != ""){
							$("#IRSMetadataFileDisplay").html(res.FATCAGENERATIONLOG.irsMetadataFile);
							$("#IRSMetadataFileDownload").show();
						}else{
							$("#IRSMetadataFileDisplay").html("...");
							$("#IRSMetadataFileDownload").hide();
						}
						
						var html = "<table class='table table-bordered'><tr><td colspan='2'>&nbsp;</td></tr><tr><th width='20%'>Timestamp</th><th width='80%'>Message</th></tr>";
						
						var count = 0;
						for(var c in res.FATCAGENERATIONMESSAGELIST){
							count++;
						}						
						for(var data in res.FATCAGENERATIONMESSAGELIST){
							data = (count - data)-1;
						    var timestamp = res.FATCAGENERATIONMESSAGELIST[data].timestamp;
						    var message = res.FATCAGENERATIONMESSAGELIST[data].message;
						    html = html+"<tr><td>"+timestamp+"</td><td>"+message+"</td></tr>";
						}
						/*
						for(var data in res.FATCAGENERATIONMESSAGELIST){
							
						     var timestamp = res.FATCAGENERATIONMESSAGELIST[data].timestamp;
						     var message = res.FATCAGENERATIONMESSAGELIST[data].message;
						     html = html+"<tr><td>"+timestamp+"</td><td>"+message+"</td></tr>";
						}
						*/
						html = html+"</table>"
						$("#statusMessage").html(html);
						$("#statusMessage").css("max-height", $(window).height()- 225);
						$("#statusMessage").css("overflow-y", "auto");
					},
					error : function(a,b,c){
						alert("Error while starting process. "+c);
					}
				});
			}
		</script>
		<style type="text/css">
			.table-responsive {
    width: 100%;
    margin-bottom: 15px;
    overflow-y: hidden;
    overflow-x: hidden;
    -ms-overflow-style: -ms-autohiding-scrollbar;
    border: 1px solid #ddd;
    -webkit-overflow-scrolling: touch;
    margin-bottom: 0px;
}

.table-responsive>.table { 
    margin-bottom: 0px;
}

.table-responsive>.table>thead>tr>th, 
.table-responsive>.table>tbody>tr>th, 
.table-responsive>.table>tfoot>tr>th, 
.table-responsive>.table>thead>tr>td, 
.table-responsive>.table>tbody>tr>td, 
.table-responsive>.table>tfoot>tr>td {
    max-width: 100px;
	white-space: nowrap;
	overflow: hidden;
	text-overflow : ellipsis;
}	
		</style>
	</head>
	<body>
		<br/>
		<div class="container-fluid" style="margin-left: 15px;">
			<div class="row">
				<div class="col-md-3">
					<div class="card card-info">
					  <div class="card-header">Original XML</div>
					  <div id="originalFile">
					  ...
					  </div>
					  <div class="card-footer" style="text-align: right;">
					  	<span id="originalFileDownload" style="display: none;"><button fileType='OriginalXML' class='btn btn-primary btn-xs donwloadXMLFile'>Download</button></span>
					  	<span id="originalFileContinue" style="display: none;"><button fileType='OriginalXML' class='btn btn-success btn-xs continueWithXMLFile'>Continue</button></span>
					  </div>
					</div>
					<div class="card card-info">
					  <div class="card-header">Uploaded XML</div>
					  <form id="uploadFATCAXMLFile" name="uploadFATCAXMLFile" method="POST">
					  <div id="uploadFATCAFileSection" style="display: none;" class="table-responsive">
					  	<table class="table table-bordered">
					  		<tbody>
					  		<tr>
					  			<td width="80%">
					  				<input type="hidden" name="caseNo" value="<%=caseNo%>"/>
					  				<input type="file" name="fileName" id="filename"/>
					  			</td>
					  			<td width="20%">
					  				<button id="uploadXMLFile" type="button" class="btn btn-info btn-xs">Upload</button>
					  			</td>
					  		</tr>
					  		</tbody>
					  	</table>
					  </div>
					  </form>
					  <div id="uploadedFile" style="max-width: inherit; overflow-y: hidden">
					  ...
					  </div>
					  <div class="card-footer" style="text-align: right;">
					  	<span id="uploadedFileDownload" style="display: none;"><button fileType='UploadedXML' class='btn btn-primary btn-xs donwloadXMLFile'>Download</button></span>
					  	<span id="uploadedFileContinue" style="display: none;"><button fileType='UploadedXML' class='btn btn-success btn-xs continueWithXMLFile'>Continue</button></span>
					  </div>
					</div>
					<div class="card card-info">
					  <div class="card-header">Final FATCA Package</div>
					  <div id="finalFATCAPackage" class="table-responsive">
					  	<table class="table table-bordered">
					  		<tbody>
					  		<tr>
					  			<td id="signedXMLFileDisplay" width="80%">
					  				...
					  			</td>
					  			<td width="20%">
					  				<button style="display: none;" id="signedXMLFileDownload" fileType='SignedXML' class='btn btn-primary btn-xs donwloadXMLFile'>Download</button>
					  			</td>
					  		</tr>
					  		<tr>
					  			<td id="fatcaFinalZIPFileDisplay">
					  				...
					  			</td>
					  			<td>
					  				<button style="display: none;" id="fatcaFinalZIPFileDownload" fileType='FinalZIP' class='btn btn-primary btn-xs donwloadXMLFile'>Download</button>
					  			</td>
					  		</tr>
					  		</tbody>
					  	</table>
					  </div>
					</div>
				</div>
		        <div class="col-md-6">
		        	<div class="card card-info" class="table-responsive">
					  <div class="card-header">FATCA File Generation</div>
					  <table class="table table-bordered">
					  	<tr>
					  		<td width="50%">Start Time : <strong id="starttime"></strong></td>
					  		<td width="50%">End Time : <strong id="endtime"></strong></td>
					  	</tr>
					  	<tr>
					  		<td>Started by : <strong id="startedBy"></strong></td>
							<td>Status : <strong id="status"></strong></td>
					  	</tr>
					  	<tr>
					  		<td colspan="2">
						  		<table width='100%'>
						  			<tr>
						  				<td width="10%">
						  					Message : 
						  				</td>
						  				<td width="75%" style="text-align: justify;">
						  					<strong id="message">Checking previous FATCA history of this case. Please wait...</strong>
						  				</td>
						  				<td width="15%" style="text-align: right;">
						  					<button class="btn btn-sm btn-danger" id="startOver" onclick="startOver()">Start Over</button>
						  				</td>
						  			</tr>
						  		</table>
					  		</td>
					  	</tr>
					  </table>
					  <div id="statusMessage"></div>
					</div>
		        </div>
		        <div class="col-md-3">
		        	<div class="card card-info">
					  <div class="card-header">IRS Notification Upload</div>
					  <form id="uploadIRSZipFile" name="uploadIRSZipFile" method="POST">
					  <div id="uploadIRSZipFileSection" style="display: none;" class="table-responsive">
					  	<table class="table table-bordered">
					  		<tbody>
					  		<tr>
					  			<td width="80%">
					  				<input type="hidden" name="caseNo" value="<%=caseNo%>"/>
					  				<input type="file" name="fileName" id="fis_filename"/>
					  			</td>
					  			<td width="20%">
					  				<button id="uploadZipFile" type="button" class="btn btn-info btn-xs">Upload</button>
					  			</td>
					  		</tr>
					  		</tbody>
					  	</table>
					  </div>
					  </form>
					  <div id="uploadedZipFile" style="max-width: inherit; overflow-y: hidden">
					  ...
					  </div>
					  <div class="card-footer" style="text-align: right;">
					  	<span id="uploadedZipFileDownload" style="display: none;"><button fileType='UploadedZIP' class='btn btn-primary btn-xs donwloadXMLFile'>Download</button></span>
					  	<span id="uploadedZipFileContinue" style="display: none;"><button class='btn btn-success btn-xs continueUnpack'>Continue</button></span>
					  </div>
					</div>
					<div class="card card-info">
					  <div class="card-header">IRS Response</div>
					  <div id="IRSResponse" class="table-responsive">
					  	<table class="table table-bordered" style="width: 100%">
					  		<tbody>
					  		<tr>
					  			<td id="IRSMetadataFileDisplay" width="80%">
					  				...
					  			</td>
					  			<td width="20%">
					  				<button style="display: none;" id="IRSMetadataFileDownload" fileType='IRSMetadataXML' class='btn btn-primary btn-xs donwloadXMLFile'>Download</button>
					  			</td>
					  		</tr>
					  		<tr>
					  			<td id="IRSPayloadFileDisplay">
					  				...
					  			</td>
					  			<td>
					  				<button style="display: none;" id="IRSPayloadFileDownload" fileType='IRSPayloadXML' class='btn btn-primary btn-xs donwloadXMLFile'>Download</button>
					  			</td>
					  		</tr>
					  		<tr style="display: none; text-align: center;" id="additionalButton">
					  			<td colspan="2">
					  				<button id="ViewPayload" class='btn btn-success btn-xs'>View Payload</button>
					  				<button id="DownloadCaseFolder" class='btn btn-danger btn-xs'>Download Case Folder</button>
					  			</td>
					  		</tr>
					  		</tbody>
					  	</table>
					  </div>
					</div>
		        </div>
			</div>
		</div>
		<div class="modal fade" role="dialog" id="payloadModal" aria-labelledby="gridSystemModalLabel">
		  <div class="modal-dialog modal-lg" role="document">
		    <div class="modal-content">
		      <div class="modal-header">
		        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
		        <h4 class="modal-title" id="payloadTitle">...</h4>
		      </div>
		      <div class="modal-body">
		        <div class="container-fluid">
		          <div class="row">
		            <div class="col-xs-12" id="payloadDetails">...</div>
		          </div>
		        </div>
		      </div>
		    </div>
		  </div>
       	</div>
	</body>
</html>
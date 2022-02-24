<%@ include file="../../tags/tags.jsp"%>
<jsp:include page="../../tags/staticFiles.jsp"/>
<html>
	<head>
		<meta http-equiv="X-UA-Compatible" content="IE=edge">
		<meta name="_csrf" content="${_csrf.token}"/>
		<meta name="_csrf_header" content="${_csrf.headerName}"/>
		<title>Entity Tracer</title>
		<%-- <script type="text/javascript"	src="${pageContext.request.contextPath}/includes/scripts/jquery.js"></script>
		<script type="text/javascript"	src="${pageContext.request.contextPath}/includes/scripts/jquery-ui.js"></script>
		<script type="text/javascript"	src="${pageContext.request.contextPath}/includes/scripts/bootstrap.min.js"></script>
		<script type="text/javascript"	src="${pageContext.request.contextPath}/includes/scripts/Base64.js"></script>
		<script type="text/javascript"	src="${pageContext.request.contextPath}/includes/scripts/CompassTopFrame.js"></script>
		<script type="text/javascript"	src="${pageContext.request.contextPath}/includes/scripts/CompassFileUpload.js"></script>
		<script type="text/javascript"	src="${pageContext.request.contextPath}/includes/scripts/select2.min.js"></script>
		 --%>
		<link rel="StyleSheet" type="text/css"	href="${pageContext.request.contextPath}/includes/styles/bootstrap.min.css" />
		<link rel="StyleSheet" type="text/css"	href="${pageContext.request.contextPath}/includes/styles/jquery-ui.min.css" />
		<link rel="StyleSheet" type="text/css"	href="${pageContext.request.contextPath}/includes/styles/template/default.css" />
		<link rel="StyleSheet" type="text/css"	href="${pageContext.request.contextPath}/includes/styles/select2.min.css" />
		
		<script type="text/javascript">
			$(function () {
			    var token = $("meta[name='_csrf']").attr("content");
			    var header = $("meta[name='_csrf_header']").attr("content");
			    var multiTabDisplay = 1;
			    $(document).ajaxSend(function(e, xhr, options) {
			        xhr.setRequestHeader(header, token);
			    });
			    
			    $("select").select2();
			    
			    var url_attr_encoded = '${url_attr_encoded}';
			    var data_attr_encoded = '${data_attr_encoded}';
			    
			    var url_attr = Base64.decode(url_attr_encoded);
			    var data_attr = Base64.decode(data_attr_encoded);
			    
			    $.ajax({
			 		url : "${pageContext.request.contextPath}"+url_attr,
			 		cache : true,
			 		type : "POST",
			 		data : data_attr,
			 		success : function(resData){
			 			alert(resData);
			 			$("#EntityTracerNewWindow").html(resData);
			 		}
			 	});
			});
		</script>
	</head>
	
	<!-- <input type="hidden" id="RTWindow" value="1"> -->
	
	<body>
		<%-- <div class="modal fade bs-example-modal-sm" id="compassMediumGenericModal" tabindex="1" role="dialog" aria-labelledby="myLargeModalLabel">
		<div class="modal-dialog modal-xl">
			<div class="modal-content card-primary">
				<div class="modal-header card-header" style="cursor: move;">
					<div class="modal-button">
						<button type="button" class="close" data-dismiss="modal" aria-label="Close" title="Close">
							<span aria-hidden="true" class="fa fa-remove"></span>
						</button>
					</div>
					<h4 class="modal-title" id="compassMediumGenericModal-title">...</h4>					
				</div>
				<div class="modal-body" id="compassMediumGenericModal-body">
				<br/>
					<center>
						<img alt="Loading..." src="${pageContext.request.contextPath}/includes/images/qde-loadder.gif">
					</center>
				<br/>
				</div>
			</div>
		</div>
	</div>
	<div class="modal fade bd-example-modal-sm" id="compassSearchModuleModal" tabindex="-1" role="dialog" aria-labelledby="mySmallModalLabel" aria-hidden="true">
  		<div class="modal-dialog modal-xl">
    		<div class="modal-content card-primary">
    			<div class="modal-header card-header" style="cursor: move;">
					<div class="modal-button">
						<button type="button" class="close" data-dismiss="modal" aria-label="Close" title="Close">
							<span aria-hidden="true" class="fa fa-remove"></span>
						</button>
					</div>
					<h4 class="modal-title" id="compassSearchModuleModal-title">...</h4>					
				</div>
				<div class="modal-body" id="compassSearchModuleModal-body">
				</div>
			</div>
 		</div>
	</div>
	<div class="modal fade bs-example-modal-lg" id="compassFileUploadModal" tabindex="1" role="dialog" aria-labelledby="myLargeModalLabel">
		<div class="modal-dialog modal-lg">
			<div class="modal-content card-primary">
				<div class="modal-header card-header" style="cursor: move;">
					<div class="modal-button">
						<button type="button" class="close" data-dismiss="modal" aria-label="Close" title="Close">
							<span aria-hidden="true" class="fa fa-remove"></span>
						</button>
					</div>
					<h4 class="modal-title" id="compassFileUploadModal-title">...</h4>					
				</div>
				<div class="modal-body" id="compassFileUploadModal-body">
					<div id="compassFileUploadModal-loader">
						<br/>
							<center>
								<img alt="Loading..." src="${pageContext.request.contextPath}/includes/images/qde-loadder.gif">
							</center>
						<br/>
					</div>
					<div id="compassFileUploadModal-process" style="display: none;">
					</div>
					<div class="row" id="compassFileUploadModal-upload" style="display: none;">
						<div class="col-sm-6">
							<div class="card card-info">
								<div class="card-header clearfix">
									<h6 class="card-title">Upload File</h6>
								</div>
								<table class="table table-bordered table-striped" style="margin-bottom: 0px;">
									<tr>
										<td colspan="2" style="font-size: 10px;">
											Allowed File Size : <span id="compassFileUploadModal-uploadFileSize"></span><br/>
											Allowed File Type : <span id="compassFileUploadModal-uploadFileAllowedType"></span><br/>
											Block File Type : <span id="compassFileUploadModal-uploadFileBlockedType"></span><br/>
											Maximum File Select Count : <span id="compassFileUploadModal-uploadFileMaxNoSize"></span><br/>
											Upload Enable : <span id="compassFileUploadModal-uploadEnable"></span>
										</td>
									</tr>
									<tr>
										<td width="15%">Select Files</td>
										<td width="85%">
											<input id="fileupload" onchange="compassFileUpload.FileSelected(this); this.value=null; return false;" class="form-control input-sm" type="file" name="files[]"  multiple>
										</td>
									</tr>
									<tr>
										<td colspan="2" style="text-align: center; font-weight: bold;">Or</td>
									</tr>
									<tr>
										<td>Drop Files</td>
										<td>
											<div id="dragandrophandler">Drag & Drop Files Here</div>
										</td>
									</tr>
									<tr>
										<td>Selected Files</td>
										<td>
											<table class="table table-bordered table-striped" id="upload-files" style="font-size: 12px;">
										        <tr>
										            <th width="25%">File Name</th>
										            <th width="15%">File Size</th>
										            <th width="10%">File Type</th>
										            <th width="25%">Progress</th>
										            <th width="25%">Action / Status</th>
										        </tr>
										    </table>
										</td>
									</tr>
									<tr>
										<td colspan="2" style="text-align: center;">
											<button type="button" class="btn btn-warning btn-sm" id="upload" disabled="disabled" onclick="compassFileUpload.startUpload(this);">Upload</button>
										</td>
									</tr>
								</table>
							</div>
						</div>
						<div class="col-sm-6">
							<div class="card card-info">
								<div class="card-header clearfix">
									<h6 class="card-title">Download File</h6>
								</div>
								<div id="compassFileUploadModal-uploadedFiles">
									
								</div>
							</div>
						</div>
					</div>
					
				</div>
			</div>
		</div>
	</div>
 --%>		
 <div class="modal fade bs-example-modal-lg" id="compassGenericModal" tabindex="1" role="dialog" aria-labelledby="myLargeModalLabel">
	<div class="modal-dialog modal-lg">
		<div class="modal-content card-primary">
			<div class="modal-header card-header" style="cursor: move;">
				<div class="modal-button">
					<button type="button" class="close" data-dismiss="modal" aria-label="Close" title="Close">
						<span aria-hidden="true" class="fa fa-remove"></span>
					</button>
					<button type="button" class="close"  title="Open in new Window" id="openModalInWindow" url-attr="" data-attr="">
						<span aria-hidden="true" class="fa fa-external-link"></span>
					</button>
					<button type="button" class="close" title="Open in Tab" id="openModalInTab">
						<span aria-hidden="true" class="fa fa-plus"></span>
					</button>
				</div>
				<h4 class="modal-title" id="compassGenericModal-title">...</h4>					
			</div>
			<div class="modal-body" id="compassGenericModal-body">
			<br/>
				<center>
					<img alt="Loading..." src="${pageContext.request.contextPath}/includes/images/qde-loadder.gif">
				</center>
			<br/>
			</div>
		</div>
	</div>
</div> 
<div class="modal fade bs-example-modal-lg" id="compassRTScanningModal" tabindex="1" role="dialog" aria-labelledby="myLargeModalLabel">
	<div class="modal-dialog modal-lg">
		<div class="modal-content card-primary">
			<div class="modal-header card-header" style="cursor: move;">
				<div class="modal-button">
					<button type="button" class="close" data-dismiss="modal" aria-label="Close" title="Close">
						<span aria-hidden="true" class="fa fa-remove"></span>
					</button>
					<button type="button" class="close"  title="Open in new Window" id="openRTModalInWindow" url-attr="" data-attr="">
						<span aria-hidden="true" class="fa fa-external-link"></span>
					</button>
				</div>
				<h4 class="modal-title" id="compassRTScanningModal-title">...</h4>					
			</div>
			<div class="modal-body" id="compassRTScanningModal-body">
			<br/>
				<center>
					<img alt="Loading..." src="${pageContext.request.contextPath}/includes/images/qde-loadder.gif">
				</center>
			<br/>
			</div>
		</div>
	</div>
</div>
<div class="modal fade bs-example-modal-sm" id="compassMediumGenericModal" tabindex="1" role="dialog" aria-labelledby="myLargeModalLabel">
	<div class="modal-dialog modal-xl">
		<div class="modal-content card-primary">
			<div class="modal-header card-header" style="cursor: move;">
				<div class="modal-button">
					<button type="button" class="close" data-dismiss="modal" aria-label="Close" title="Close">
						<span aria-hidden="true" class="fa fa-remove"></span>
					</button>
				</div>
				<h4 class="modal-title" id="compassMediumGenericModal-title">...</h4>					
			</div>
			<div class="modal-body" id="compassMediumGenericModal-body">
			<br/>
				<center>
					<img alt="Loading..." src="${pageContext.request.contextPath}/includes/images/qde-loadder.gif">
				</center>
			<br/>
			</div>
		</div>
	</div>
</div>
<div class="modal fade bs-example-modal-lg" id="compassFileUploadModal" tabindex="1" role="dialog" aria-labelledby="myLargeModalLabel">
		<div class="modal-dialog modal-lg">
			<div class="modal-content card-primary">
				<div class="modal-header card-header" style="cursor: move;">
					<div class="modal-button">
						<button type="button" class="close" data-dismiss="modal" aria-label="Close" title="Close">
							<span aria-hidden="true" class="fa fa-remove"></span>
						</button>
					</div>
					<h4 class="modal-title" id="compassFileUploadModal-title">...</h4>					
				</div>
				<div class="modal-body" id="compassFileUploadModal-body">
					<div id="compassFileUploadModal-loader">
						<br/>
							<center>
								<img alt="Loading..." src="${pageContext.request.contextPath}/includes/images/qde-loadder.gif">
							</center>
						<br/>
					</div>
					<div id="compassFileUploadModal-process" style="display: none;">
					</div>
					<div class="row" id="compassFileUploadModal-upload" style="display: none;">
						<div class="col-sm-6">
							<div class="card card-info">
								<div class="card-header clearfix">
									<h6 class="card-title">Upload File</h6>
								</div>
								<table class="table table-bordered table-striped" style="margin-bottom: 0px;">
									<tr>
										<td colspan="2" style="font-size: 10px;">
											Allowed File Size : <span id="compassFileUploadModal-uploadFileSize"></span><br/>
											Allowed File Type : <span id="compassFileUploadModal-uploadFileAllowedType"></span><br/>
											Block File Type : <span id="compassFileUploadModal-uploadFileBlockedType"></span><br/>
											Maximum File Select Count : <span id="compassFileUploadModal-uploadFileMaxNoSize"></span><br/>
											Upload Enable : <span id="compassFileUploadModal-uploadEnable"></span>
										</td>
									</tr>
									<tr>
										<td width="15%">Select Files</td>
										<td width="85%">
											<input id="fileupload" onchange="compassFileUpload.FileSelected(this); this.value=null; return false;" class="form-control input-sm" type="file" name="files[]"  multiple>
										</td>
									</tr>
									<tr>
										<td colspan="2" style="text-align: center; font-weight: bold;">Or</td>
									</tr>
									<tr>
										<td>Drop Files</td>
										<td>
											<div id="dragandrophandler">Drag & Drop Files Here</div>
										</td>
									</tr>
									<tr>
										<td>Selected Files</td>
										<td>
											<table class="table table-bordered table-striped" id="upload-files" style="font-size: 12px;">
										        <tr>
										            <th width="25%">File Name</th>
										            <th width="15%">File Size</th>
										            <th width="10%">File Type</th>
										            <th width="25%">Progress</th>
										            <th width="25%">Action / Status</th>
										        </tr>
										    </table>
										</td>
									</tr>
									<tr>
										<td colspan="2" style="text-align: center;">
											<button type="button" class="btn btn-warning btn-sm" id="upload" disabled="disabled" onclick="compassFileUpload.startUpload(this);">Upload</button>
										</td>
									</tr>
								</table>
							</div>
						</div>
						<div class="col-sm-6">
							<div class="card card-info">
								<div class="card-header clearfix">
									<h6 class="card-title">Download File</h6>
								</div>
								<div id="compassFileUploadModal-uploadedFiles">
									
								</div>
							</div>
						</div>
					</div>
					
				</div>
			</div>
		</div>
	</div>
 
 <div id="compassGenericModal">
			<div id="EntityTracerNewWindow">Loading...</div>
		</div>
	</body>
</html>


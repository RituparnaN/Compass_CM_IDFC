<%@ page language="java" contentType="text/html;charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../../tags/tags.jsp"%>
<!DOCTYPE html>
<html>
	<head>
		<title>
			<spring:message code="app.login.NAME" />
			<tiles:insertAttribute name="title" />
		</title>
		<tiles:insertAttribute name="static" />
		<script type="text/javascript"	src="${pageContext.request.contextPath}/includes/scripts/compass.js"></script>
		<jsp:include page="../../tags/commonScripts.jsp"/>
		<tiles:insertAttribute name="otherStatic" />
		<style type="text/css">
			#dragandrophandler {
				border:2px dotted #0B85A1;
				width: 100%;
				color: #92AAB0;
				text-align: center;
				vertical-align:middle;
				padding:10px;
				font-size: 20px;
			}
		</style>
	</head>
<body>
	<input type="hidden" id="multiTabDisplayInput" value="1"/>
	<input type="hidden" id="closeRefreshTabInput" value="1"/>
	<input type="hidden" id="autoCollapseInput" value="1"/>
	<div id="wrapper">
        <!-- Navigation -->
        <nav class="navbar navbar-default navbar-static-top" role="navigation" style="margin-bottom: 0;position:fixed !important; width:100%;">
            <div class="navbar-header" style="min-height: 50px; display: inline-block;">
				<ul class="nav navbar-top-links navbar-${dirR}" dir="${sessionScope.LABELDIR}">
					<li class="dropdown emailNotification">
						<a class="dropdown-toggle" href="javascript:void(0)" id="toggleSidebar"> 
							<i class="fa fa-expand fa-fw" title="Toggle Sidebar"></i>
						</a>
					</li>
				</ul>
				<a class="navbar-brand" href="javascript:navigate('Overview','Overview','common/getDashboardGraph','1')" style="margin-top: -5px;"> 
					<img alt="Compass" src='${pageContext.request.contextPath}/includes/images/qde/Compass-Logo-Reverse.png'
					width="180px" height="35px" />
				</a>
			</div>
            <tiles:insertAttribute name="header" />
            <tiles:insertAttribute name="sideBar" />
        </nav>
        <tiles:insertAttribute name="content" />
    </div>
    
    <section id="footer" style="z-index: 100000000">
    	<div class="row" id="QDE_Logo">
    		<div class="pull-left" style="margin-left: 12px; margin-top: 4px;">
    			<img alt="Compass" src='${pageContext.request.contextPath}/includes/images/qde/QDE-Graphic-White-24x24-pixels.png'
					width="24px" height="24px" />
				<span style="color: white;  font-size: 10px;">Copyright Quantum Data Engines. 2016-17</span>
    		</div>
    	</div> 
	</section>
        
    <div id="dialog" title="Your session is about to expire!">
		<p>
			<span class="ui-icon ui-icon-alert" style="float:left; margin:0 7px 50px 0;"></span>
			You will be logged off in <span id="dialog-countdown" style="font-weight:bold"></span> seconds.
		</p>
		<p>Do you want to continue your session?</p>
	</div>
	<input type="hidden" id="tabUrl" value=""/>
	<input type="hidden" id="tabModuleCode" value=""/>
	<div class="modal fade bs-example-modal-lg" id="compassGenericModal" tabindex="1" role="dialog" aria-labelledby="myLargeModalLabel">
		<div class="modal-dialog modal-lg">
			<div class="modal-content card-primary">
				<div class="modal-header card-header" style="cursor: move;">
					<div class="modal-button">
						<button type="button" class="close" data-dismiss="modal" aria-label="Close" title="Close">
							<span aria-hidden="true" class="fa fa-remove"></span>
						</button>
						<button type="button" class="close"  title="Open in new Window" id="openModalInWindow">
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
	<div class="modal fade bs-example-modal-lg" id="compassCaseWorkFlowGenericModal" tabindex="1" role="dialog" aria-labelledby="myLargeModalLabel">
		<div class="modal-dialog modal-lg">
			<div class="modal-content card-primary">
				<div class="modal-header card-header" style="cursor: move;">
					<div class="modal-button">
						<button type="button" class="close" data-dismiss="modal" aria-label="Close" title="Close">
							<span aria-hidden="true" class="fa fa-remove"></span>
						</button>
					</div>
					<h4 class="modal-title" id="compassCaseWorkFlowGenericModal-title">...</h4>					
				</div>
				<div class="modal-body" id="compassCaseWorkFlowGenericModal-body">
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
					<div class="row" id="compassFileUploadModal-upload" style="display: none; word-break: break-all;">
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
											<!-- <input id="fileupload" onchange="compassFileUpload.FileSelected(this); this.value=null; return false;" class="form-control input-sm" type="file" name="files[]"  multiple webkitdirectory> -->
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
	<div class="modal fade bs-example-modal-lg" id="composeEmailMessageModal" tabindex="1" role="dialog" aria-labelledby="myLargeModalLabel">
		<div class="modal-dialog modal-lg">
			<div class="modal-content card-primary">
				<div class="modal-header card-header" style="cursor: move;">
					<div class="modal-button">
						<button type="button" class="close" data-dismiss="modal" aria-label="Close" title="Close">
							<span aria-hidden="true" class="fa fa-remove"></span>
						</button>
						<button type="button" class="close"  title="Open in new Window" id="openComposeMessageModalInWindow">
							<span aria-hidden="true" class="fa fa-external-link"></span>
						</button>
					</div>
					<h4 class="modal-title" id="composeEmailMessageModal-title">...</h4>					
				</div>
				<div class="modal-body" id="composeEmailMessageModal-body">
				<br/>
					<center>
						<img alt="Loading..." src="${pageContext.request.contextPath}/includes/images/qde-loadder.gif">
					</center>
				<br/>
				</div>
			</div>
		</div>
	</div>
	<div class="modal fade" id="tdCellCustomTooltipModel" role="dialog" >
    <div class="modal-dialog modal-xl" style="width:30%">
      <div class="modal-content card-primary" style="height:30%;">
        <div class="modal-header card-header">
          	<div class="modal-button">
				<button type="button" class="close" data-dismiss="modal" aria-label="Close" title="Close">
					<span aria-hidden="true" class="fa fa-remove"></span>
				</button>
			</div>
          <h4 class="modal-title" id = "tdCellCustomTooltipModel-title">Modal Header</h4>
        </div>
        <div class="modal-body" id = "tdCellCustomTooltipModel-body" style="text-align:center">
          <p>This is td tooltip.</p>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
        </div>
      </div>
    </div>
  </div>
</body>
</html>
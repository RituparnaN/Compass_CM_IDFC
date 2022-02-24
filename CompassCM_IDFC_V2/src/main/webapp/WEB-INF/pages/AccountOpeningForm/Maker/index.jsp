<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="java.util.*, com.quantumdataengines.app.compass.model.AOFDisabledFiledsMap"%>
<%
String contextPath = request.getContextPath()==null?"":request.getContextPath();
String userID = request.getAttribute("userID") != null ? (String) request.getAttribute("userID") : "";
String caseNo = request.getAttribute("CASE_NO") != null ? (String) request.getAttribute("CASE_NO") : "";
String accountNo = request.getAttribute("ACCOUNT_NO") != null ? (String) request.getAttribute("ACCOUNT_NO") : "";
String cifNo = request.getAttribute("CIF_NO") != null ? (String) request.getAttribute("CIF_NO") : "";
String canEdit = request.getAttribute("CAN_EDIT") != null ? (String) request.getAttribute("CAN_EDIT") : "N";

Map<String, String> allCountries = request.getAttribute("ALLCOUNTRIES") != null ? (Map<String, String>) request.getAttribute("ALLCOUNTRIES") : new HashMap<String, String>();
Iterator<String> countryItr = allCountries.keySet().iterator();

Map<String, List<Map<String, String>>> accountsAndMandates = request.getAttribute("ACCOUNTS_AND_MANDATES") != null ? (Map<String, List<Map<String, String>>>) request.getAttribute("ACCOUNTS_AND_MANDATES") : new HashMap<String, List<Map<String, String>>>();
Map<String, String> cifData = (Map<String, String>) request.getAttribute("CIF_DATA");
List<Map<String, String>> jointHolder = (List<Map<String, String>>) request.getAttribute("JOINT_HOLDER");
List<Map<String, String>> uploadData = (List<Map<String, String>>) request.getAttribute("UPLOAD_DATA");
Map<String, String> FORMSTATUS = request.getAttribute("FORMSTATUS") != null ? (Map<String, String>) request.getAttribute("FORMSTATUS") : new HashMap<String, String>();

String MESSAGE = request.getAttribute("MESSAGE") != null ? (String) request.getAttribute("MESSAGE") : "";
boolean SEARCHDONE = request.getAttribute("SEARCHDONE") != null ? (Boolean) request.getAttribute("SEARCHDONE") : false;
String FORM_SECTION = request.getAttribute("FORM_SECTION") != null ? (String) request.getAttribute("FORM_SECTION") : "";

%>
<style type="text/css">
	.red{
		color: #E77471;
	}
	.bacred{
		background: #FFCCCC;
	}
	.section{
		width: 100%;
		margin: 2px 0 10px 0;
		border: 1px solid #000000;
	}
	.sectionHeader{
		background: gray;
		color: #FFFFFF;
		font-weight: bold;
		font-size: 15px;
		padding: 2px;
		height: 30px;
	}
	.sectionHeaderRej{
		background: red;
		color: #FFFFFF;
		font-weight: bold;
		font-size: 15px;
		padding: 2px;
		height: 30px;
	}
	.sectionBody{
		padding: 3px;
	}
	.sectionFooter{
		background: gray;
		padding-left: 70%;
		padding-right: 5%;
	}
	ul.inlineUL{
		line-height: 0px;
		margin-bottom: 0px;
		list-style-type: none;
	}
	ul.inlineUL li{
		display: inline;
		padding: 0 5px;
		line-height: 0px;
		margin-bottom: 3px;
	}
	.datepicker{
		background-image:url("<%=contextPath%>/includes/images/calendar.png");
		background-repeat:no-repeat;
		background-position: 98%;
	}
	input[type=text]{		
		margin: 2px 0;
	}
	select{		
		margin: 2px 0;
	}
	input[type=text].input-ovr {
		text-align: justify;
		padding:2px 5px;
		height: 28px;
		font-size:14px;
		font-weight: normal;
		line-height:1.42857143;
		color:#555;
		border:1px solid #ccc;
		border-radius:4px;
		-webkit-box-shadow:inset 0 1px 1px rgba(0,0,0,.075);
		box-shadow:inset 0 1px 1px rgba(0,0,0,.075);
		-webkit-transition:border-color ease-in-out .15s,-webkit-box-shadow ease-in-out .15s;
		-o-transition:border-color ease-in-out .15s,box-shadow ease-in-out .15s;
		transition:border-color ease-in-out .15s,box-shadow ease-in-out .15s
	}
	#accountHolderDetails{
		overflow: auto;
	}
	#informationPanel{
		overflow: auto;
		margin-top: 2px;
	}
	
	#accountOpeningFormSearch > .nav-tabs{
	  background-color: #ACBAE6;
	}
	
	#accountOpeningFormSearch > .nav-tabs > li > a{
	  color: #191970 !important;
	}
	
	#accountOpeningFormSearch > .nav-tabs > li > a:hover{
	  color: #4B0082 !important;
	}
	
	#accountOpeningFormSearch > .fullWidthTable{
		width: 100%;
	}
	
	.card-header{
		font-size: 13px;
		padding: 3px 5px;
		line-height: 20px; 
	}
</style>
<script type="text/javascript">
	$(document).ready(function(){
		
		var caseNo = '<%=caseNo%>';
		if(caseNo != ""){
			
			var formObj = $("#AccountOpeningForm");
			var formData = $(formObj).serialize();
			$.ajax({
				type : "GET",
				url : "<%=contextPath%>/cpuMaker/searchAccountOpeningForm",
				cache : false,
				data : formData,
				success : function(res){
					$("#accountOpeningFormSearch").html(res);
				},
				error : function(){
					alert("error");
				}
			});
		}
		
		$("#AccountOpeningForm").submit(function(e){
			var formObj = $("#AccountOpeningForm");
			var formData = $(formObj).serialize();
			$.ajax({
				type : "GET",
				url : "<%=contextPath%>/cpuMaker/searchAccountOpeningForm",
				cache : false,
				data : formData,
				success : function(res){
					$("#accountOpeningFormSearch").html(res);
				},
				error : function(){
					alert("error");
				}
			});
			e.preventDefault();
		});
		
		
		$(".form-control").each(function() {
			if($(this).hasClass("bacred")){
				$(this).css("background","#FFCCCC");
			}
		});
		
		$("div.card-body").keydown(function(e){
			var keycode =  e.keyCode ? e.keyCode : e.which;
		    if(keycode == 8){
		    	if(e.target.isContentEditable)
		    		return true;
		    	else
		    		return false;
		    }
		});
		
		var form_section_cat = '<%=FORM_SECTION%>';
		if(form_section_cat == ''){
			$('.nav-tabs a[href="#category1"]').tab('show');
		}else{
			$('.nav-tabs a[href="#'+form_section_cat+'"]').tab('show');
		}
		
		var MESSAGE = '<%=MESSAGE%>';
		if(MESSAGE != ' ' && MESSAGE.length != 0){
			alert(MESSAGE);
		}
		
		var cifValue = "";
		var accNoVal = "";
		var cifDBClick = 0;
		var accDBClick = 0;
		var fetchedCifNo = '<%=cifNo%>';
		
		if(fetchedCifNo == '')
			$("#cifNumner").focus();
		
		$("#cifNumner").focus(function(){
			if(cifDBClick == 0){
				cifValue = $("#cifNumner").val();
				$("#cifNumner").val("");
			}
		});
		
		$("#accNumber").focus(function(){
			if(accDBClick == 0){
				accNoVal = $("#accNumber").val();
				$("#accNumber").val("");
			}
		});
		
		$('#cifNumner').on('blur', function() {
			if(cifDBClick == 0){
				var val = $("#cifNumner").val(); 
				if(val.length == 0){
					$("#cifNumner").val(cifValue);
				}
			}
		});
		
		$('#accNumber').on('blur', function() {
			if(accDBClick == 0){
				var val = $("#accNumber").val(); 
				if(val.length == 0){
					$("#accNumber").val(accNoVal);
				}
			}
		});
		
		$('#cifNumner').on('dblclick', function() {
			if(cifDBClick == 0){
				cifDBClick = 1;
				$("#cifNumner").val(cifValue);
				cifValue = "";
			}
		});
		
		$('#accNumber').on('dblclick', function() {
			if(accDBClick == 0){
				accDBClick = 1;
				$("#accNumber").val(accNoVal);
				accNoVal = "";
			}
		});
		
		$(".datepicker").datepicker({
			 dateFormat : "dd/mm/yy",
			 changeMonth: true,
		     changeYear: true
		 });
		
		var searchPanelHeightPX = $("#searchPanel").css("height");
		var searchPanelHeight = searchPanelHeightPX.substring(0, searchPanelHeightPX.length - 2);
		var removeHeight = parseInt(searchPanelHeight) + 80;		
		$("#informationPanel").css("height",$(window).height() - removeHeight);
		
		var shouldClose = false;
		$('#accountHolderModal').on('shown.bs.modal', function (e) {
			shouldClose = false;
		});
		
		$('#accountHolderModal').on('hide.bs.modal', function (e) {
			if(!shouldClose){
				e.preventDefault();
			    if(confirm("Do you want to close the window?")){
			    	shouldClose = true;
			    	$('#accountHolderModal').modal('hide');
			    }
			}
		});
	});
	
	function forceCheck(elm, chkVal){
		if(chkVal != 'null'){
			$("input[name="+elm.name+"][value="+chkVal+"]").prop("checked", "checked");
		}
		return false;
	}
	
	function forceCheckSelect(elm, chkVal){
		if(chkVal != 'null'){
			$("select[name="+elm.name+"] > option[value="+chkVal+"]").attr("selected", "selected");
		}else{
			$("select[name="+elm.name+"] > option[value='']").attr("selected", "selected");
		}
		return false;
	}
	
	function deleteDocument(elm, docRefNo){
		if(confirm("Do you want to remove this document?")){
			var cifNo = $("#CIF_NO").val();
			var accNO = $("#ACCOUNT_NO").val();
			var caseNo = $("#CASE_NO").val();
			$(elm).html("Removing...");
			$.ajax({
				type : "POST",
				url : "<%=contextPath%>/cpumaker/deleteUploadedDocument?docRefNo="+docRefNo+"&cifNo="+cifNo+"&accNO="+accNO+"&caseNo="+caseNo,
				cache : false,
				success : function(res){
					if(res == 1){
						$(elm).parent().html("Document Removed");
					}else{
						$(elm).html("Remove");
						alert("Document cannot be removed");
					}
				},
				error : function(){
					alert("Could not process the request");
					$(elm).html("Remove");
				}
			});
		}
	}
	
	function viewServerDocument(fileRefNo, accountNo, isServerFile){
		var serverFileWin = window.open('<%=contextPath%>/cpumaker/viewUploadAndServerFile?serverFileRefNo='+fileRefNo+'&accountNo='+accountNo+'&isServerFile='+isServerFile,'AccountOpeningMandate','height=800, width=1200, resizable=Yes, scrollbars=Yes');
		serverFileWin.focus();
	}
	
	function closeModal(){
		$('#accountHolderModal').modal('hide');
	}
</script>

</head>
<body>
<div class="modal fade bs-example-modal-lg" id="accountHolderModal" tabindex="1" role="dialog" aria-labelledby="myLargeModalLabel">
  <div class="modal-dialog modal-lg">
    <div class="modal-content card-primary">
      <div class="modal-header card-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
        <span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="modal-title">...</h4>
      </div>
	  <div class="modal-body" id="accountHolderDetails">
      	Loading...
      </div>
    </div>
  </div>
</div>
	<div class="row" id="searchPanel">
		<div class="col-lg-12">
			<div class="card card-info">
				<div class="card-header">
					Search by CIF / Account Number / Both
				</div>
				<form id="AccountOpeningForm" action="javascript:void(0)" method="GET">
					<input type="hidden" name="caseNo" value="<%=caseNo%>"/>
					<table class="table table-bordered" style="margin-bottom: 0px;">
						<tr>
							<td width="45%">
								<div class="input-group">
								  <label class="input-group-addon btn-info" for="cifNumner" id="basic-addon1">CIF Number</label>
								  <input value="<%=cifNo%>" id="cifNumner" name="cifNumner" type="text" class="form-control input-sm" placeholder="CIF" aria-describedby="basic-addon1" autocomplete="off"/>
								</div>
							</td>
							<td width="45%">
								<div class="input-group">
								  <label class="input-group-addon btn-info" for="accNumber" id="basic-addon1">Account Number</label>
								  <input value="<%=accountNo%>" id="accNumber" name="accNumber" type="text" class="form-control input-sm" placeholder="Account Number" aria-describedby="basic-addon1" autocomplete="off"/>
								</div>
							</td>
							<td width="10%"><input type="submit" class="btn btn-primary" value="Search"> </td>
						</tr>
					</table>
				</form>
			</div>
		</div>
	</div>
	<div class="row">
		<div class="col-lg-12" id="accountOpeningFormSearch">
		
		</div>
	</div>
<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, com.quantumdataengines.app.compass.model.CDDDisabledFieldsMap"%>
<%@ include file="../../tags/tags.jsp"%>

<%
String CURRENTROLE = (String) request.getSession(false).getAttribute("CURRENTROLE");
String prefix = CURRENTROLE+"_CE_";
%>

<style type="text/css">
	.modalNav li a{
		font-size: 13px;
		padding: 5px 10px;
	}
	.nav-pills>li.active>a{
		color: #000000;
		background-color: #b2b2ff;
	}
	.nav-pills>li>a{
		border-radius : 0px;
	}
	/*.nav-pills>li.active>a, .nav-pills>li.active>a:focus, .nav-pills>li.active>a:hover {
		color: #000000;
    	background-color: #b2b2ff;
	}
	*/
	input:required, select:required, textarea:required {
	  border-color: #86C090;
	}
	
	input:required:invalid, select:required:invalid, textarea:required:invalid {
	  border-color: #FF9999;
	}
	
	.panelSearchForm{
		font-size: 13px;
	}
	
	table > tr > td{
		text-align: left;
	}
	
	button.bs-placeholder {
		border-color: #FF9999;
	}
	
	button:not(.bs-placeholder){
		border-color: #86C090;
	}
	
	.btn-primary.btn-outline, .btn-success.btn-outline{
		color : #000000;
	}
	
	textarea {
  		resize: vertical;
	}
	
	.chkListCheck, .chkListApprove{
		text-align: center;
	}

	.bootstrap-select .dropdown-menu {
		width: 500px;
		height : 300px;
	}
	.bootstrap-select .dropdown-menu span.text {
		display: block;
		overflow: hidden;
		text-overflow: ellipsis;
	}
</style>
<script type="text/javascript">
	$(document).ready(function() {
		var id = '${UNQID}';
		var COMPASSREFERENCENO = '${COMPASSREFERENCENO}';
		var FETCHSTATUS = '${FORMDATA['FETCHSTATUS']}';
		var FATCHMSG = '${FORMDATA['FETCHMSG']}';
		var LINENO = '${FORMDATA['LINENO']}';
		if(FETCHSTATUS == '1'){
			alert(FATCHMSG)
		}
		
		/*$('input[type=radio]').parent("label").on('mouseover', function(event) {
			var radio = $(this).find("input");
			var radioname = $(radio).attr("name");
			var isChecked = $(radio).prop("checked");
			if(isChecked){
				if(!isDisabled){
				if($(this).next().attr("id") != "closeSpan"){
					var button = "<span id='closeSpan'>&nbsp;&nbsp;<button type='button' class='btn btn-danger btn-xs' id='uncheck' radio='"+radioname+"'>Uncheck</button>"+
					"<button type='button' class='btn btn-default btn-xs' id='closeUncheck'>x</button>&nbsp;&nbsp;&nbsp;&nbsp;</span>";
					$(this).after($(button));
				}
				}
			}
		});
		*/
		$(document).on('click', '#closeUncheck',function(e) {
			$(this).parent("span").remove();
		});
		
		$(document).on('click', '#uncheck',function(e) {
			var radio = $(this).attr("radio");
			$("input[name="+radio+"]").parent("label").removeClass("btn-success").addClass("btn-primary");
			$("input[name="+radio+"]").each(function(){
				$(this).prop("checked", false);
			});
			$(this).parent("span").remove();
		});
		
		$("#uploadAlertsRatingMapping"+id).click(function(){
			compassFileUpload.init("uploadBenificialOwnerStructure"+id,"${pageContext.request.contextPath}","benificialOwnerStructure","0","Y","Y","CDDBO_"+COMPASSREFERENCENO);
		});
		
		$(".selectpicker").selectpicker();
		
		$("#uploadAlertsRatingMapping"+id).click(function(){
			compassFileUpload.init("uploadBenificialOwnerStructure"+id,"${pageContext.request.contextPath}","benificialOwnerStructure","0","Y","Y","CDDBO_"+COMPASSREFERENCENO);
		});
		
		loadStatusApprovals(COMPASSREFERENCENO, LINENO);
		loadIdentificationForm(COMPASSREFERENCENO, LINENO);
		
		var cddFormStatus = '${FORMDATA['STATUS']}';
		var CURRENTROLE = '${CURRENTROLE}';
		
		if((CURRENTROLE == 'ROLE_BPAMAKER' && cddFormStatus == 'BPA-P') || (CURRENTROLE == 'ROLE_BPDMAKER' && cddFormStatus == 'BPD-P')){
			$(".saveCloseCDDForm, .saveCDDForm, .cddModifyButton").each(function(){
				$(this).removeAttr("disabled");
			});
		} else {
			$(".saveCloseCDDForm, .saveCDDForm, .cddModifyButton").each(function(){
				$(this).attr("disabled","disabled");
			});
		}
				
		$("input, select, textarea").each(function(){
			$(this).attr("required", "required");
		});
		
		$(".datepicker").datepicker({
			changeMonth: true,
			changeYear: true,
			dateFormat: "dd/mm/yy"
		});
		
		$("input[type='checkbox'], input[type='radio']").each(function(){
			var name = $(this).attr("name");
			var isChecked = $(this).prop("checked");
			if(isChecked){
				$("input[name='"+name+"'], input[name='"+name+"']").each(function(){
					$(this).parent("label").removeClass("btn-primary").addClass("btn-success");
				});
			}
		});
		
		$("input[type='checkbox'], input[type='radio']").click(function(){
			var name = $(this).attr("name");
			var isChecked = $(this).prop("checked");
			if(isChecked){
				$("input[name='"+name+"'], input[name='"+name+"']").each(function(){
					$(this).parent("label").removeClass("btn-primary").addClass("btn-success");
				});
			}else{
				$("input[name='"+name+"'], input[name='"+name+"']").each(function(){
					$(this).parent("label").removeClass("btn-success").addClass("btn-primary");
				});
			}
		});

		$("#checkCustomerPANNo"+id).click(function(){
			$("#checkCustomerPANNo"+id).attr("disabled", true);
			$("#checkCustomerPANNo"+id).html("Validating");
			
			var PANNO = $("#PANNO"+id).val();
			
			var fullData =  "COMPASSREFERENCENO="+COMPASSREFERENCENO+"&UNQID="+id+"&FORMLINENO="+LINENO+"&PANNO="+PANNO;
			$.ajax({
				url : "${pageContext.request.contextPath}/cddFormCommon/validateCustomerPANNo",
				type : "POST",
				cache : false,
				data : fullData,
				success : function(res){
					//var panValidationResponse = res['validationResult'];
					$("#PANNSDLRESPONSE"+id).val(res);
					$("#checkCustomerPANNo"+id).removeAttr("disabled");
					$("#checkCustomerPANNo"+id).html("Check Pan");
					/*
					$("#calculateCDDRisk"+id).removeAttr("disabled");
					$("#calculateCDDRisk"+id).html("Calculate");
					
					var DUEDILIGENCE = res['DUEDILIGENCE'];
					var RISKRATING = res['RISKRATING'];
					var RISKRATINGTEXT = res['RISKRATINGTEXT'];
					var riskRating = RISKRATING+" - "+RISKRATINGTEXT+" ("+DUEDILIGENCE+")";
					$("#SYSTEMRISKRATING"+id).val(riskRating);
					
					var isChecked = $("#RR_CHARACTERISTICS_1"+id).prop("checked");
					if(!isChecked){
						$("#PROVISIONALRISKRATING"+id).val(riskRating);
					}
					*/
				},
				error : function(){
					var panValidationResponse = "Error while validation PAN No";
					$("#PANNSDLRESPONSE"+id).val(panValidationResponse);
					
					alert("Error while saving form");
					$("#checkCustomerPANNo"+id).removeAttr("disabled");
					$("#checkCustomerPANNo"+id).html("Check Pan");
				}
			});
		});
		
		$(".saveCDDForm").click(function(){
			var formData1 = $("#searchMasterForm1"+id).serialize();
			var formData2 = $("#searchMasterForm2"+id).serialize();
			var formData3 = $("#searchMasterForm3"+id).serialize();
			var fullData = formData1+"&"+formData2+"&"+formData3;

			var cddFormStatus = '${FORMDATA['STATUS']}';
			var CURRENTROLE = '${CURRENTROLE}';
			
			if((CURRENTROLE == 'ROLE_BPAMAKER' && cddFormStatus == 'BPA-P') || (CURRENTROLE == 'ROLE_BPDMAKER' && cddFormStatus == 'BPD-P')){
			
			
			//if($("#LASTREVIEWDATE"+id).val() == ''){
			//	alert('Date of last review is a mandatory field.');
			//	return false;	
			//}

			if(CURRENTROLE == 'ROLE_BPAMAKER' && cddFormStatus == 'BPA-P')
			if($("#CUSTOMERID"+id).val() == ''){
				alert('Customer id is a mandatory field.');
				return false;	
			}

			if(CURRENTROLE == 'ROLE_BPAMAKER' && cddFormStatus == 'BPA-P')
			if($("#PREVIOUSRISKRATING"+id).val() == ''){
				alert('Previous risk rating is a mandatory field.');
				return false;	
			}

			if(CURRENTROLE == 'ROLE_BPAMAKER' && cddFormStatus == 'BPA-P')
			if(!($("#REVIEWPURPOSE1"+id).prop("checked")) && !($("#REVIEWPURPOSE2"+id).prop("checked")) && !($("#REVIEWPURPOSE3"+id).prop("checked")) && !($("#REVIEWPURPOSE4"+id).prop("checked")) && !($("#REVIEWPURPOSE5"+id).prop("checked"))){
				alert('Purpose of CDD review is a mandatory field.');
				return false;	
			}

			if(CURRENTROLE == 'ROLE_BPAMAKER' && cddFormStatus == 'BPA-P')
			if($("#RELATIONSHIPMANAGER"+id).val() == ''){
				alert('Relationship manager is a mandatory field.');
				return false;	
			}

			if(CURRENTROLE == 'ROLE_BPAMAKER' && cddFormStatus == 'BPA-P')
			if($("#DEPTINCHARGE"+id).val() == ''){
				alert('Department incharge is a mandatory field.');
				return false;	
			}
			
			if(CURRENTROLE == 'ROLE_BPDMAKER' && cddFormStatus == 'BPD-P')
			if(($("#EXISTINGCUSTOMERY"+id).prop("checked")) && !($("#EXISTINGRISKRATING1"+id).prop("checked")) && !($("#EXISTINGRISKRATING2"+id).prop("checked")) && !($("#EXISTINGRISKRATING3"+id).prop("checked")) && !($("#EXISTINGRISKRATING4"+id).prop("checked")) && !($("#EXISTINGRISKRATING5"+id).prop("checked"))) {
				alert('Risk rating is a mandatory field.');
				return false;	
			}

			/*if(CURRENTROLE == 'ROLE_BPDMAKER' && cddFormStatus == 'BPD-P')
			if(!($("#GOVERNMENTENTITYY"+id).prop("checked")) && !($("#GOVERNMENTENTITYN"+id).prop("checked"))){
				alert('General information is a mandatory field.');
				return false;	
			}*/

			if(CURRENTROLE == 'ROLE_BPAMAKER' && cddFormStatus == 'BPA-P')
			if($("#RESIDENTIALADDRESS"+id).val() == ''){
				alert('Residential address line 1 is a mandatory field.');
				return false;	
			}

			if(CURRENTROLE == 'ROLE_BPAMAKER' && cddFormStatus == 'BPA-P')
			if($("#RESIDENTIALADDRESS2"+id).val() == ''){
				alert('Residential address line 2 is a mandatory field.');
				return false;	
			}

			if(CURRENTROLE == 'ROLE_BPAMAKER' && cddFormStatus == 'BPA-P')
			if($("#RESIDENTIALADDRESS3"+id).val() == ''){
				alert('Residential address line 3 is a mandatory field.');
				return false;	
			}

			if(CURRENTROLE == 'ROLE_BPAMAKER' && cddFormStatus == 'BPA-P')
			if($("#MAILINGADDRESS"+id).val() == ''){
				alert('Mailing address line 1 is a mandatory field.');
				return false;	
			}

			if(CURRENTROLE == 'ROLE_BPAMAKER' && cddFormStatus == 'BPA-P')
			if($("#MAILINGADDRESS2"+id).val() == ''){
				alert('Mailing address line 2 is a mandatory field.');
				return false;	
			}

			if(CURRENTROLE == 'ROLE_BPAMAKER' && cddFormStatus == 'BPA-P')
			if($("#MAILINGADDRESS3"+id).val() == ''){
				alert('Mailing address line 3 is a mandatory field.');
				return false;	
			}

			if(CURRENTROLE == 'ROLE_BPAMAKER' && cddFormStatus == 'BPA-P')
			if($("#PANNO"+id).val() == ''){
				alert('PAN no is a mandatory field.');
				return false;	
			}

			if(CURRENTROLE == 'ROLE_BPAMAKER' && cddFormStatus == 'BPA-P')
			if($("#BUSINESSTYPE"+id).val() == ''){
				alert('Type of business is a mandatory field.');
				return false;	
			}

			if(CURRENTROLE == 'ROLE_BPDMAKER' && cddFormStatus == 'BPD-P')
			if($("#NATUREOFBUSINESS"+id).val() == ''){
				alert('Nature of business is a mandatory field.');
				return false;	
			}

			if(CURRENTROLE == 'ROLE_BPAMAKER' && cddFormStatus == 'BPA-P')
			if($("#COUNRYOFINCORPORATION"+id).val() == ''){
				alert('Country of incorporation is a mandatory field.');
				return false;	
			}

			if(CURRENTROLE == 'ROLE_BPAMAKER' && cddFormStatus == 'BPA-P')
			if($("#DATEOFINCORPORATION"+id).val() == ''){
				alert('Date of incorporation is a mandatory field.');
				return false;	
			}

			if(CURRENTROLE == 'ROLE_BPDMAKER' && cddFormStatus == 'BPD-P')
			if($("#SOURCEOFFUND"+id).val() == ''){
				alert('Source of funds is a mandatory field.');
				return false;	
			}

			if(CURRENTROLE == 'ROLE_BPDMAKER' && cddFormStatus == 'BPD-P')
			if(!($("#PRODUCTSERVICE_TD"+id).prop("checked")) && !($("#PRODUCTSERVICE_SA"+id).prop("checked")) && !($("#PRODUCTSERVICE_GR"+id).prop("checked")) && 
			   !($("#PRODUCTSERVICE_CA"+id).prop("checked")) && !($("#PRODUCTSERVICE_LN"+id).prop("checked")) && !($("#PRODUCTSERVICE_RE"+id).prop("checked")) && 
			   !($("#PRODUCTSERVICE_IB"+id).prop("checked")) && !($("#PRODUCTSERVICE_TF"+id).prop("checked")) && !($("#PRODUCTSERVICE_OT"+id).prop("checked")) ){
				alert('Type of product is a mandatory field.');
				return false;	
			}

			if(CURRENTROLE == 'ROLE_BPDMAKER' && cddFormStatus == 'BPD-P')
			if($("#EXPECTEDTXNAMT"+id).val() == ''){
				alert('Expected transaction amount is a mandatory field.');
				return false;	
			}

			if(CURRENTROLE == 'ROLE_BPDMAKER' && cddFormStatus == 'BPD-P')
			if($("#EXPECTEDTXNCOUNT"+id).val() == ''){
				alert('Expected transaction count is a mandatory field.');
				return false;	
			}

			if(CURRENTROLE == 'ROLE_BPDMAKER' && cddFormStatus == 'BPD-P')
			if($("#EXPECTEDTXNCURRENCY"+id).val() == ''){
				alert('Expected transaction currency is a mandatory field.');
				return false;	
			}

			if(CURRENTROLE == 'ROLE_BPDMAKER' && cddFormStatus == 'BPD-P')
			if($("#EXPECTEDTXNFRQ"+id).val() == ''){
				alert('Expected transaction frequency is a mandatory field.');
				return false;	
			}

			if(CURRENTROLE == 'ROLE_BPAMAKER' && cddFormStatus == 'BPA-P')
			if($("#PRINCIPALCOUNTRIES"+id).val() == ''){
				alert('List principal country of business is a mandatory field.');
				return false;	
			}
			
			if(CURRENTROLE == 'ROLE_BPAMAKER' && cddFormStatus == 'BPA-P')
			if(!($("#CLAFMATCH_Y"+id).prop("checked")) && !($("#CLAFMATCH_N"+id).prop("checked"))){
				alert('Sanctions is a mandatory field.');
				return false;	
			}

			if(CURRENTROLE == 'ROLE_BPAMAKER' && cddFormStatus == 'BPA-P')
			if(!($("#SLSMATCH_Y"+id).prop("checked")) && !($("#SLSMATCH_N"+id).prop("checked"))){
				alert('Sanctions, local and HO bad guy list is a mandatory field.');
				return false;	
			}

			if(CURRENTROLE == 'ROLE_BPAMAKER' && cddFormStatus == 'BPA-P')
			if(!($("#PEPMATCH_Y"+id).prop("checked")) && !($("#PEPMATCH_N"+id).prop("checked"))){
				alert('PEP is a mandatory field.');
				return false;	
			}

			if(CURRENTROLE == 'ROLE_BPAMAKER' && cddFormStatus == 'BPA-P')
			if(!($("#ADVINFO_Y"+id).prop("checked")) && !($("#ADVINFO_N"+id).prop("checked"))){
				alert('DOW JONES is a mandatory field.');
				return false;	
			}

			if(CURRENTROLE == 'ROLE_BPAMAKER' && cddFormStatus == 'BPA-P')
			if(!($("#ASEMATCH_Y"+id).prop("checked")) && !($("#ASEMATCH_N"+id).prop("checked"))){
				alert('Trust customer is a mandatory field.');
				return false;	
			}
			}
			
			$.ajax({
				url : "${pageContext.request.contextPath}/cddFormCommon/saveCDDFormData",
				type : "POST",
				cache : false,
				data : fullData,
				success : function(res){
					alert(res.MSG);
					if(res.STATUS == "2"){
						$(".saveCDDForm").attr("disabled", true);
					}
				},
				error : function(){
					alert("Error while saving form");
				}
			});
		});
		
		$(".saveDraftCDDForm").click(function(){
			var formData1 = $("#searchMasterForm1"+id).serialize();
			var formData2 = $("#searchMasterForm2"+id).serialize();
			var formData3 = $("#searchMasterForm3"+id).serialize();
			var fullData = formData1+"&"+formData2+"&"+formData3;

			var cddFormStatus = '${FORMDATA['STATUS']}';
			var CURRENTROLE = '${CURRENTROLE}';
			
			$.ajax({
				url : "${pageContext.request.contextPath}/cddFormCommon/saveCDDFormData",
				type : "POST",
				cache : false,
				data : fullData,
				success : function(res){
					alert(res.MSG);
					if(res.STATUS == "2"){
						$(".saveCDDForm").attr("disabled", true);
					}
				},
				error : function(){
					alert("Error while saving form");
				}
			});
		});
		
		$(".saveCDDFormBPAMaker").click(function(){
			var formObj = $("#checkListForm"+id);
			var formData = $(formObj).serialize();
			$.ajax({
				url : "${pageContext.request.contextPath}/cddFormCommon/saveCDDCheckListForm",
				type : "POST",
				cache : false,
				data : formData,
				success : function(res){
					if(res == "1"){
						alert("CDD Check List successfully saved");
					}else{
						alert("Failed to save CDD Check List");
					}
				},
				error : function(){
					alert("Error while saving form");
				}
			});
		});
		
		$(".saveCDDFormBPAChecker").click(function(){
			var formObj = $("#checkListForm"+id);
			var formData = $(formObj).serialize();
			$.ajax({
				url : "${pageContext.request.contextPath}/cddFormCommon/saveCDDCheckListFormChecker",
				type : "POST",
				cache : false,
				data : formData,
				success : function(res){
					if(res == "1"){
						alert("CDD Check List successfully saved");
					}else{
						alert("Failed to save CDD Check List");
					}
				},
				error : function(){
					alert("Error while saving form");
				}
			});
		});
		
		$("#addIntermediaries"+id).click(function(){
			$("#compassMediumGenericModal").modal("show");
			$("#compassMediumGenericModal-title").html("Add Intermediaries");
			$("#compassMediumGenericModal-body").html("Loading...");
			$.ajax({
				url : "${pageContext.request.contextPath}/cddFormCommon/addIntermediaries",
				type : "POST",
				cache : false,
				data : "COMPASSREFERENCENO="+COMPASSREFERENCENO+"&UNQID="+id+"&FORMLINENO="+LINENO,
				success : function(res){
					$("#compassMediumGenericModal-body").html(res);
				},
				error : function(){
					alert("Error while saving form");
				}
			});
		});
		
		$("#addPEPDetails"+id).click(function(){
			$("#compassMediumGenericModal").modal("show");
			$("#compassMediumGenericModal-title").html("Add PEP");
			$("#compassMediumGenericModal-body").html("Loading...");
			$.ajax({
				url : "${pageContext.request.contextPath}/cddFormCommon/addPEP",
				type : "POST",
				cache : false,
				data : "COMPASSREFERENCENO="+COMPASSREFERENCENO+"&UNQID="+id+"&FORMLINENO="+LINENO,
				success : function(res){
					$("#compassMediumGenericModal-body").html(res);
				},
				error : function(){
					alert("Error while saving form");
				}
			});
		});
		
		$("#addBeneficialOwners"+id).click(function(){
			$("#compassMediumGenericModal").modal("show");
			$("#compassMediumGenericModal-title").html("Add Beneficial Owners");
			$("#compassMediumGenericModal-body").html("Loading...");
			$.ajax({
				url : "${pageContext.request.contextPath}/cddFormCommon/addBeneficialOwner",
				type : "POST",
				cache : false,
				data : "COMPASSREFERENCENO="+COMPASSREFERENCENO+"&UNQID="+id+"&FORMLINENO="+LINENO,
				success : function(res){
					$("#compassMediumGenericModal-body").html(res);
				},
				error : function(){
					alert("Error while saving form");
				}
			});
		});
		
		
		$("#addDirectors"+id).click(function(){
			$("#compassMediumGenericModal").modal("show");
			$("#compassMediumGenericModal-title").html("Add Director");
			$("#compassMediumGenericModal-body").html("Loading...");
			$.ajax({
				url : "${pageContext.request.contextPath}/cddFormCommon/addDirector",
				type : "POST",
				cache : false,
				data : "COMPASSREFERENCENO="+COMPASSREFERENCENO+"&UNQID="+id+"&FORMLINENO="+LINENO,
				success : function(res){
					$("#compassMediumGenericModal-body").html(res);
				},
				error : function(){
					alert("Error while saving form");
				}
			});
		});
		
		$("#addAuthorizedSignatory"+id).click(function(){
			$("#compassMediumGenericModal").modal("show");
			$("#compassMediumGenericModal-title").html("Add Authorized Signatory");
			$("#compassMediumGenericModal-body").html("Loading...");
			$.ajax({
				url : "${pageContext.request.contextPath}/cddFormCommon/addAuthorizedSignatory",
				type : "POST",
				cache : false,
				data : "COMPASSREFERENCENO="+COMPASSREFERENCENO+"&UNQID="+id+"&FORMLINENO="+LINENO,
				success : function(res){
					$("#compassMediumGenericModal-body").html(res);
				},
				error : function(){
					alert("Error while saving form");
				}
			});
		});
		
		$("#screenCustomerNames"+id).click(function(){
			var CUSTOMERNAMETOSCREEN = $("#CUSTOMERNAMETOSCREEN"+id).val();
			var CUSTOMERALIASNAMETOSCREEN = $("#CUSTOMERALIASNAMETOSCREEN"+id).val();
			var CUSTOMERFORMARNAMETOSCREEN = $("#CUSTOMERFORMARNAMETOSCREEN"+id).val();
			if(CUSTOMERNAMETOSCREEN != ""){
				var fullData = "NAME1="+CUSTOMERNAMETOSCREEN+"&NAME2="+CUSTOMERALIASNAMETOSCREEN+"&NAME3="+CUSTOMERFORMARNAMETOSCREEN+"&NAME4=&NAME5=&DATEOFBIRTH=&PASSPORTNO=&PANNO=&ACCOUNTNO=&CUSTOMERID=&userCode=NA&BlackListCheck=Y&SelectedBlackListCheck=Y"+
				   "&CustomerDataBaseCheck=Y&RejectedListCheck=Y&EmployeeDataBaseCheck=N";
				screenName(fullData);
			}else{
				alert("Enter Customer Name to Screen");
			}
		});
		
		$("#CUSTOMERNAME"+id).keyup(function(){
			var customerName = $(this).val();
			$("#CUSTOMERNAMETOSCREEN"+id).val(customerName);
			$("#RISKRATINGCUSTOMERNAME"+id).val(customerName);
		});
		
		$("#CUSTOMERALIASNAME"+id).keyup(function(){
			var customerName = $(this).val();
			$("#CUSTOMERALIASNAMETOSCREEN"+id).val(customerName);
		});
		
		$("#CUSTOMERPREVNAME"+id).keyup(function(){
			var customerName = $(this).val();
			$("#CUSTOMERFORMARNAMETOSCREEN"+id).val(customerName);
		});
		
		$("#RELATIONSHIPMANAGER"+id).keyup(function(){
			var customerName = $(this).val();
			$("#RISKRATINGRELATIONSHIPMANAGER"+id).val(customerName);
		});
		
		$("#DEPTINCHARGE"+id).keyup(function(){
			var customerName = $(this).val();
			$("#RISKRATINGDEPTINCHARGE"+id).val(customerName);
		}); 
		
		$("#moveToScreening"+id).click(function(){
			$("li#screeningTab > a").click();
		});
		
		$("#moveToRiskRating"+id).click(function(){
			$("li#riskRatingTab > a").click();
		});
		
		$("input[id^='PRODUCTSERVICE']").click(function(){
			var riskRating = "";
			var riskRatingDesc = "";
			$("input[id^='PRODUCTSERVICE']").each(function(){
				if($(this).prop("checked")){
					if(riskRating == ""){
						riskRatingDesc = $(this).parent("label").children("span").html();
						riskRating = $(this).attr("riskRating");
					}
					
					if(riskRating == "Low" && ($(this).attr("riskRating") == "Medium") || ($(this).attr("riskRating") == "High")){
						riskRatingDesc = $(this).parent("label").children("span").html();
						riskRating = $(this).attr("riskRating");
					}
					
					if(riskRating == "Medium" && $(this).attr("riskRating") == "High"){
						riskRatingDesc = $(this).parent("label").children("span").html();
						riskRating = $(this).attr("riskRating");
					}
				}
			});
			$("#PRODUCTRISKRATING_DESC"+id).val(riskRatingDesc);
			$("#PRODUCTRISKRATING_VALUE"+id).val(riskRating);
			$("#PRODUCTRISKRATING"+id).val(riskRating);
		});
				
		$("input[id^='RISKRATINGCHANNEL']").click(function(){
			var riskRating = "";
			var riskRatingDesc = "";
			$("input[id^='RISKRATINGCHANNEL']").each(function(){
				if($(this).prop("checked")){
					if(riskRating == ""){
						riskRatingDesc = $(this).val();
						riskRating = $(this).attr("riskRating");
					}
					
					if(riskRating == "Low" && ($(this).attr("riskRating") == "Medium") || ($(this).attr("riskRating") == "High")){
						riskRatingDesc = $(this).val();
						riskRating = $(this).attr("riskRating");
					}
					
					if(riskRating == "Medium" && $(this).attr("riskRating") == "High"){
						riskRatingDesc = $(this).val();
						riskRating = $(this).attr("riskRating");
					}
				}
			});
			$("#CHANNELRISKRATING_VALUE"+id).val(riskRating);
			$("#CHANNELRISKRATING"+id).val(riskRating);
		});
		
		$("#RR_CHARACTERISTICS_1"+id).click(function(){
			var isChecked = $(this).prop("checked");
			if(isChecked){
				$("#PROVISIONALRISKRATING"+id).val("5 - High (Enhanced)");
			}else{
				var systemGeneratedRisk = $("#SYSTEMRISKRATING"+id).val();
				$("#PROVISIONALRISKRATING"+id).val(systemGeneratedRisk);
			}
			
		});
		
		$("#calculateCDDRisk"+id).click(function(){
			var cddRiskRating = "";
			var isValid = true;
			var CHANNELRISKRATING = $("#CHANNELRISKRATING"+id).val();
			var PRODUCTRISKRATING = $("#PRODUCTRISKRATING"+id).val();
			var GEOGRAPHICRISKRATING = $("#GEOGRAPHICRISKRATING"+id).val();
			var INDUSTRYTYPERISKRATING = $("#INDUSTRYTYPERISKRATING"+id).val();
			var ATTRIBUTETYPERISKRATING = $("#ATTRIBUTETYPERISKRATING"+id).val();
			
			if(isValid && (CHANNELRISKRATING == "")){
				isValid = false;
				alert("Channel Risk Rating missing");
			}
			
			if(isValid && (PRODUCTRISKRATING == "")){
				isValid = false;
				alert("Product / Service Risk Rating missing");
			}
			
			if(isValid && (GEOGRAPHICRISKRATING == "")){
				isValid = false;
				alert("Geographic Risk Rating missing");
			}
			
			if(isValid && (INDUSTRYTYPERISKRATING == "")){
				isValid = false;
				alert("Inductry Risk Rating missing");
			}
			
			if(isValid && (ATTRIBUTETYPERISKRATING == "")){
				isValid = false;
				alert("Attribute Risk Rating missing");
			}
			
			var fullData =  "CHANNELRISKRATING="+CHANNELRISKRATING+"&PRODUCTRISKRATING="+PRODUCTRISKRATING+
							"&GEOGRAPHICRISKRATING="+GEOGRAPHICRISKRATING+"&INDUSTRYTYPERISKRATING="+INDUSTRYTYPERISKRATING+
							"&ATTRIBUTETYPERISKRATING="+ATTRIBUTETYPERISKRATING+"&TYPE=CORP";
			if(isValid){
				$("#calculateCDDRisk"+id).attr("disabled", "disabled");
				$("#calculateCDDRisk"+id).html("Calculating...");
				$.ajax({
					url : "${pageContext.request.contextPath}/cddFormCommon/calculateCDDRiskRating",
					type : "POST",
					cache : false,
					data : fullData,
					success : function(res){
						$("#calculateCDDRisk"+id).removeAttr("disabled");
						$("#calculateCDDRisk"+id).html("Calculate");
						
						var DUEDILIGENCE = res['DUEDILIGENCE'];
						var RISKRATING = res['RISKRATING'];
						var RISKRATINGTEXT = res['RISKRATINGTEXT'];
						var riskRating = RISKRATING+" - "+RISKRATINGTEXT+" ("+DUEDILIGENCE+")";
						$("#SYSTEMRISKRATING"+id).val(riskRating);
						
						var isChecked = $("#RR_CHARACTERISTICS_1"+id).prop("checked");
						if(!isChecked){
							$("#PROVISIONALRISKRATING"+id).val(riskRating);
						}
					},
					error : function(){
						alert("Error while saving form");
					}
				});
			}
		});
		
		$("#copyRAtoMA"+id).click(function(){
			$("#MAILINGADDRESS"+id).val($("#RESIDENTIALADDRESS"+id).val());
			$("#MAILINGADDRESS2"+id).val($("#RESIDENTIALADDRESS2"+id).val());
			$("#MAILINGADDRESS3"+id).val($("#RESIDENTIALADDRESS3"+id).val());
		});

		$("#EXISTINGCUSTOMERN"+id).click(function(){
			$("#EXISTINGBRANCH"+id).attr("disabled", true);
			$("#EXISTINGRISKRATING1"+id).attr("disabled", true);
			$("#EXISTINGRISKRATING2"+id).attr("disabled", true);
			$("#EXISTINGRISKRATING3"+id).attr("disabled", true);
			$("#EXISTINGRISKRATING4"+id).attr("disabled", true);
			$("#EXISTINGRISKRATING5"+id).attr("disabled", true);
		});

		$("#EXISTINGCUSTOMERY"+id).click(function(){
			$("#EXISTINGBRANCH"+id).removeAttr("disabled");
			$("#EXISTINGRISKRATING1"+id).attr("disabled", false);
			$("#EXISTINGRISKRATING2"+id).attr("disabled", false);
			$("#EXISTINGRISKRATING3"+id).attr("disabled", false);
			$("#EXISTINGRISKRATING4"+id).attr("disabled", false);
			$("#EXISTINGRISKRATING5"+id).attr("disabled", false);
		});

		$("#DIRECTDEALINGWITHSANCTION_N"+id).click(function(){
			$("#SANCTIONCOUNTRIES"+id).attr("disabled", true);
			$("#SANCTIONSCREENHITS_Y"+id).attr("disabled", true);
			$("#SANCTIONSCREENHITS_N"+id).attr("disabled", true);
			$("#SANCTIONGOODSSERVICE"+id).attr("disabled", true);
			$("#SANCTIONINVOLVEMENT"+id).attr("disabled", true);
			$("#SOURCEOFWEALTH"+id).attr("disabled",true);
			$("#OTHERSOURCEOFWEALTH"+id).attr("disabled", true);
			$("#ADDITIONALINFORMATION"+id).attr("disabled", true);
		});

		$("#DIRECTDEALINGWITHSANCTION_Y"+id).click(function(){
			$("#SANCTIONCOUNTRIES"+id).attr("disabled", false);
			$("#SANCTIONSCREENHITS_Y"+id).attr("disabled", false);
			$("#SANCTIONSCREENHITS_N"+id).attr("disabled", false);
			$("#SANCTIONGOODSSERVICE"+id).attr("disabled", false);
			$("#SANCTIONINVOLVEMENT"+id).attr("disabled", false);
			$("#SOURCEOFWEALTH"+id).removeAttr("disabled");
			$("#OTHERSOURCEOFWEALTH"+id).attr("disabled", false);
			$("#ADDITIONALINFORMATION"+id).attr("disabled", false);
		});
		
	});
	
	function refreshIntermediaries(){
		var id = '${UNQID}';
		var COMPASSREFERENCENO = '${COMPASSREFERENCENO}';
		$("#compassMediumGenericModal").modal("hide");
		$("#intermediaryDetails"+id).html("Loading...");
		$.ajax({
			url : "${pageContext.request.contextPath}/cddFormCommon/getIntermediaries",
			type : "POST",
			cache : false,
			data : "COMPASSREFERENCENO="+COMPASSREFERENCENO+"&UNQID="+id,
			success : function(res){
				$("#intermediaryDetails"+id).html(res);
			},
			error : function(){
				alert("Error while saving form");
			}
		});
	}
	
	function refreshPEP(){
		var id = '${UNQID}';
		var COMPASSREFERENCENO = '${COMPASSREFERENCENO}';
		$("#compassMediumGenericModal").modal("hide");
		$("#pepDetails"+id).html("Loading...");
		$.ajax({
			url : "${pageContext.request.contextPath}/cddFormCommon/getPEPs",
			type : "POST",
			cache : false,
			data : "COMPASSREFERENCENO="+COMPASSREFERENCENO+"&UNQID="+id,
			success : function(res){
				$("#pepDetails"+id).html(res);
			},
			error : function(){
				alert("Error while saving form");
			}
		});
	}
	
	function refreshBeneficialOwners(){
		var id = '${UNQID}';
		var COMPASSREFERENCENO = '${COMPASSREFERENCENO}';
		$("#compassMediumGenericModal").modal("hide");
		$("#beneficialOwnerDetails"+id).html("Loading...");
		$.ajax({
			url : "${pageContext.request.contextPath}/cddFormCommon/getBeneficialOwners",
			type : "POST",
			cache : false,
			data : "COMPASSREFERENCENO="+COMPASSREFERENCENO+"&UNQID="+id,
			success : function(res){
				$("#beneficialOwnerDetails"+id).html(res);
			},
			error : function(){
				alert("Error while saving form");
			}
		});
	}
	
	function refreshDirectors(){
		var id = '${UNQID}';
		var COMPASSREFERENCENO = '${COMPASSREFERENCENO}';
		$("#compassMediumGenericModal").modal("hide");
		$("#directorsDetails"+id).html("Loading...");
		$.ajax({
			url : "${pageContext.request.contextPath}/cddFormCommon/getDirectors",
			type : "POST",
			cache : false,
			data : "COMPASSREFERENCENO="+COMPASSREFERENCENO+"&UNQID="+id,
			success : function(res){
				$("#directorsDetails"+id).html(res);
			},
			error : function(){
				alert("Error while saving form");
			}
		});
	}
	
	
	function refreshAuthorizedSignatories(){
		var id = '${UNQID}';
		var COMPASSREFERENCENO = '${COMPASSREFERENCENO}';
		var LINENO = '${FORMDATA['LINENO']}';
		$("#compassMediumGenericModal").modal("hide");
		$("#authorizedSignatoriesDetails"+id).html("Loading...");
		$.ajax({
			url : "${pageContext.request.contextPath}/cddFormCommon/getAuthorizedSignatories",
			type : "POST",
			cache : false,
			data : "COMPASSREFERENCENO="+COMPASSREFERENCENO+"&UNQID="+id,
			success : function(res){
				$("#authorizedSignatoriesDetails"+id).html(res);
				loadIdentificationForm(COMPASSREFERENCENO, LINENO);
			},
			error : function(){
				alert("Error while saving form");
			}
		});
	}
	
	function updateScreeningMatch(elm, type, compassRefNo, lineNo){
		var match = $(elm).parent().parent().find("td.match").find("select").val();
		var list = $(elm).parent().parent().find("td.listname").find("select").val();
		
		if(match == "Y" && (list == "null" || list == null)){
			alert("Select list");
		}else{
			$.ajax({
				url : "${pageContext.request.contextPath}/cddFormCommon/updateScreeningMatch",
				type : "POST",
				cache : false,
				data : "COMPASSREFERENCENO="+compassRefNo+"&LINENO="+lineNo+"&TYPE="+type+"&MATCH="+match+"&LIST="+list,
				success : function(res){
					alert(res);
				},
				error : function(){
					alert("Error while updating screening info");
				}
			});
		}
	}
	
	function removeEntity(type, compassRefNo, lineNo){
		if(confirm("Are you sure?")){
			$.ajax({
				url : "${pageContext.request.contextPath}/cddFormCommon/removeEntity",
				type : "POST",
				cache : false,
				data : "COMPASSREFERENCENO="+compassRefNo+"&LINENO="+lineNo+"&TYPE="+type,
				success : function(res){
					alert(res);
					if(type == "BENEFICIALOWNER"){
						refreshBeneficialOwners();
					}else if(type == "INTERMEDIARY"){
						refreshIntermediaries();
					}else if(type == "PEP"){
						refreshPEP();
					}else if(type == "DIRECTOR"){
						refreshDirectors();
					}else if(type == "AUTHORIZEDSIGNATORY"){
						refreshAuthorizedSignatories();
					}
				},
				error : function(){
					alert("Error while removing");
				}
			});
		}
	}
	
	function viewDetails(type, compassRefNo, lineNo){
		var id = '${UNQID}';
		var FORMLINENO = '${FORMDATA['LINENO']}';
		$("#compassMediumGenericModal").modal("show");
		$("#compassMediumGenericModal-title").html("View / Update "+type);
		$("#compassMediumGenericModal-body").html("Loading...");
		$.ajax({
			url : "${pageContext.request.contextPath}/cddFormCommon/viewEntity",
			type : "POST",
			cache : false,
			data : "COMPASSREFERENCENO="+compassRefNo+"&UNQID="+id+"&TYPE="+type+"&LINENO="+lineNo+"&FORMLINENO="+FORMLINENO,
			success : function(res){
				$("#compassMediumGenericModal-body").html(res);
			},
			error : function(){
				alert("Error while saving form");
			}
		});
	}

	/*
	function screen(elm){
		var name = $(elm).parents("tr").children("td:first-child").html();
		var data = "";
		var fullData = "NAME1="+name+"&NAME2=&NAME3=&NAME4=&NAME5=&DATEOFBIRTH=&PASSPORTNO=&PANNO=&ACCOUNTNO=&CUSTOMERID=&userCode=NA&BlackListCheck=Y&SelectedBlackListCheck=Y"+
		   "&CustomerDataBaseCheck=Y&RejectedListCheck=Y&EmployeeDataBaseCheck=N";
		screenName(fullData);
	}
	
	function screenName(data){
		$("#compassRTScanningModal").modal("show");
		$("#compassRTScanningModal-title").html("Real Time Scanning");
		$("#compassRTScanningModal-body").html("<br/><center><img alt='Loading...' src='${pageContext.request.contextPath}/includes/images/qde-loadder.gif'><center><br/>");
		
		$("#openRTModalInWindow").attr("url-attr", "/common/dataEntryFormScanning");
		$("#openRTModalInWindow").attr("data-attr", data);
		
		$.ajax({
	 		url : '${pageContext.request.contextPath}/common/dataEntryFormScanning',
	 		cache : true,
	 		type : 'POST',
	 		data : data,
	 		success : function(resData){
	 			$("#compassRTScanningModal-body").html(resData);
	 		}
	 	});
	}
	*/

	function screen(elm, nameType, lineNo){
		var id = '${UNQID}';
		COMPASSREFERENCENO = '${COMPASSREFERENCENO}';
		var name = $(elm).parents("tr").children("td:first-child").html();
		var fullData = "";
		if(nameType == "CUSTOMERNAME"){
			var CUSTOMERNAMETOSCREEN = $("#CUSTOMERNAMETOSCREEN"+id).val();
			var CUSTOMERALIASNAMETOSCREEN = $("#CUSTOMERALIASNAMETOSCREEN"+id).val();
			var CUSTOMERFORMARNAMETOSCREEN = $("#CUSTOMERFORMARNAMETOSCREEN"+id).val();
			fullData = "CDDFORMTYPE=CORPORATEEXISTING&COMPASSREFERENCENO="+COMPASSREFERENCENO+"&CDDNAMETYPE="+nameType+"&CDDNAMELINENO="+lineNo+"&NAME1="+CUSTOMERNAMETOSCREEN+"&NAME2="+CUSTOMERALIASNAMETOSCREEN+"&NAME3="+CUSTOMERFORMARNAMETOSCREEN+"&NAME4=&NAME5=&DATEOFBIRTH=&PASSPORTNO=&PANNO=&ACCOUNTNO=&CUSTOMERID=&userCode=NA&BlackListCheck=Y&SelectedBlackListCheck=Y"+
			   "&CustomerDataBaseCheck=Y&RejectedListCheck=Y&EmployeeDataBaseCheck=N";
		}
		else {
			fullData = "CDDFORMTYPE=CORPORATEEXISTING&COMPASSREFERENCENO="+COMPASSREFERENCENO+"&CDDNAMETYPE="+nameType+"&CDDNAMELINENO="+lineNo+"&NAME1="+name+"&NAME2=&NAME3=&NAME4=&NAME5=&DATEOFBIRTH=&PASSPORTNO=&PANNO=&ACCOUNTNO=&CUSTOMERID=&userCode=NA&BlackListCheck=Y&SelectedBlackListCheck=Y"+
			   "&CustomerDataBaseCheck=Y&RejectedListCheck=Y&EmployeeDataBaseCheck=N";
		}
		// alert(fullData);
		screenName(fullData);
	}
	
	function screened(elm, nameType, screenedReferenceNo){
		var name = $(elm).parents("tr").children("td:first-child").html();
		var data = "";
		screenedName(screenedReferenceNo);
	}
	
	function screenName(data){
		$("#compassRTScanningModal").modal("show");
		$("#compassRTScanningModal-title").html("Real Time Scanning");
		$("#compassRTScanningModal-body").html("<br/><center><img alt='Loading...' src='${pageContext.request.contextPath}/includes/images/qde-loadder.gif'><center><br/>");
		
		$("#openRTModalInWindow").attr("url-attr", "/common/dataEntryFormScanning");
		$("#openRTModalInWindow").attr("data-attr", data);
		
		$.ajax({
	 		url : '${pageContext.request.contextPath}/common/dataEntryFormScanning',
	 		cache : true,
	 		type : 'POST',
	 		data : data,
	 		success : function(resData){
	 			$("#compassRTScanningModal-body").html(resData);
	 		}
	 	});
	}

	function screenedName(data){
		$("#compassRTScanningModal").modal("show");
		$("#compassRTScanningModal-title").html("Real Time Scanning");
		$("#compassRTScanningModal-body").html("<br/><center><img alt='Loading...' src='${pageContext.request.contextPath}/includes/images/qde-loadder.gif'><center><br/>");

		var url = "${pageContext.request.contextPath}/common/fileMatches?counter=0&filename="+data+"&FileImport=N&UserCode=ALL&RecordStatus=ALL&ScanningFromDate=&ScanningToDate=&ProcessingFromDate=&ProcessingToDate=";
		//$("#openRTModalInWindow").attr("url-attr", "/common/fileMatches");
		$("#openRTModalInWindow").attr("url-attr", url);
		$("#openRTModalInWindow").attr("data-attr", data);
		$.ajax({
	 		url : url, // '${pageContext.request.contextPath}/common/fileMatches',
	 		cache : true,
	 		type : 'POST',
	 		data : data,
	 		success : function(resData){
	 			$("#compassRTScanningModal-body").html(resData);
	 		}
	 	});
	}
	
	function loadStatusApprovals(COMPASSREFERENCENO, LINENO){
		$("#statusApprovals").html("Loading...")
		$.ajax({
			url : "${pageContext.request.contextPath}/cddFormCommon/getStatusAndApproval",
			type : "POST",
			cache : false,
			data : "COMPASSREFERENCENO="+COMPASSREFERENCENO+"&LINENO="+LINENO,
			success : function(res){
				$("#statusApprovals").html(res);
			},
			error : function(){
				alert("Error while getting status and approval page");
			}
		});
	}
	
	function loadIdentificationForm(COMPASSREFERENCENO, LINENO){
		$("#identificationForm").html("Loading...")
		$.ajax({
			url : "${pageContext.request.contextPath}/cddFormCommon/loadIdentificationFormPage",
			type : "POST",
			cache : false,
			data : "COMPASSREFERENCENO="+COMPASSREFERENCENO+"&LINENO="+LINENO+"&TYPE=CORPEXISTING",
			success : function(res){
				$("#identificationForm").html(res);
			},
			error : function(){
				alert("Error while load identification page");
			}
		});
	}
	
	function createAFA(elm){
		var compassRefNo = $(elm).attr("compassRefNo");
		var formLineNo = $(elm).attr("formLineNo");
		var kyogiFor = $(elm).attr("kyogiFor");
		var kyogiType = "";
		if(kyogiFor == "CA")
			kyogiType = "Current Account";
		else
			kyogiType = "Saving Account";
		
		if(confirm("Are you sure you want to generate Account Opening Kyogi - "+kyogiType+" for this CDD")){
			$(elm).html("Creating...");
			$(elm).attr("disabled","disabled");
			$.ajax({
				url : "${pageContext.request.contextPath}/cddFormCommon/createAFA",
				type : "POST",
				cache : false,
				data : "COMPASSREFERENCENO="+compassRefNo+"&LINENO="+formLineNo+"&KYOGIFOR="+kyogiFor,
				success : function(res){
					loadIdentificationForm(compassRefNo, formLineNo);
				},
				error : function(){
					alert("Error while loading identification form page");
				}
			});
		}
	}
	
	function openAFA(elm){
		var compassRefNo = $(elm).attr("compassRefNo");
		var formLineNo = $(elm).attr("formLineNo");
		var kyogiFor = $(elm).attr("kyogiFor");
		var kyogiType = "";
		if(kyogiFor == "CA")
			kyogiType = "Current Account";
		else
			kyogiType = "Saving Account";
		
		$(elm).html("Opening...");
		$(elm).attr("disabled","disabled");
		$("#compassMediumGenericModal").modal("show");
		$("#compassMediumGenericModal-title").html("Account Opening Kyogi - "+kyogiType);
		$("#compassMediumGenericModal-body").html("Loading...");
		$.ajax({
			url : "${pageContext.request.contextPath}/cddFormCommon/openAFA",
			type : "POST",
			cache : false,
			data : "COMPASSREFERENCENO="+compassRefNo+"&LINENO="+formLineNo+"&KYOGIFOR="+kyogiFor,
			success : function(res){
				$(elm).removeAttr("disabled");
				$(elm).html("Open");
				$("#compassMediumGenericModal-body").html(res);
			},
			error : function(){
				alert("Error while loading identification form page");
			}
		});
	}
	
	function openIDF(elm){
		var entityType = $(elm).attr("entityType");
		var lineNo = $(elm).attr("lineNo");
		var compassRefNo = $(elm).attr("compassRefNo");
		var formLineNo = $(elm).attr("formLineNo");
		$("#compassMediumGenericModal").modal("show");
		$("#compassMediumGenericModal-title").html("Identification Form  -  取 引 時 確 認 書");
		$("#compassMediumGenericModal-body").html("Loading...");
		$.ajax({
			url : "${pageContext.request.contextPath}/cddFormCommon/loadIdentificationForm",
			type : "POST",
			cache : false,
			data : "COMPASSREFERENCENO="+compassRefNo+"&LINENO="+lineNo+"&IDFORMTYPE="+entityType+"&FORMTYPE=CORPEXISTING&FORMLINENO="+formLineNo,
			success : function(res){
				$("#compassMediumGenericModal-body").html(res);
			},
			error : function(){
				alert("Error while loading identification form");
			}
		});
	}
	
	function saveIdentificationForm(elm){
		var fullData = $(elm).parents("form").serialize();
		$.ajax({
			url : "${pageContext.request.contextPath}/cddFormCommon/saveIdentificationForm",
			type : "POST",
			cache : false,
			data : fullData,
			success : function(res){
				alert(res);
			},
			error : function(){
				alert("Error while loading identification form");
			}
		});
	}
	
	function getRiskRating(type, elm, riskRatingId){
		var id = '${UNQID}';
		var riskRatingDesc = $(elm).val();
		var riskRating = $(elm).find(":selected").attr("riskRating");
		$("#"+riskRatingId+"_DESC"+id).val(riskRatingDesc);
		$("#"+riskRatingId+"_VALUE"+id).val(riskRating);
		$("#"+riskRatingId+id).val(riskRating);
		if(type == "INCROPCOUNTRY"){
			setMaximumRiskRating();
		}
	}
	
	function getRiskMaxRating(type, elm, riskRatingId){
		var id = '${UNQID}';
		var riskRatingDesc = "";
		var riskRating = "";
		$(elm).find(":selected").each(function(){
			if(riskRating == ""){
				riskRatingDesc = $(this).text();
				riskRating = $(this).attr("riskRating");
			}
			
			if(riskRating == "Low" && ($(this).attr("riskRating") == "Medium") || ($(this).attr("riskRating") == "High")){
				riskRatingDesc = $(this).text();
				riskRating = $(this).attr("riskRating");
			}
			
			if(riskRating == "Medium" && $(this).attr("riskRating") == "High"){
				riskRatingDesc = $(this).text();
				riskRating = $(this).attr("riskRating");
			}
		});
		$("#"+riskRatingId+"_DESC"+id).val(riskRatingDesc);
		$("#"+riskRatingId+"_VALUE"+id).val(riskRating);
		$("#"+riskRatingId+id).val(riskRating);
		$("#PRINCIPALCOUNTRIESNAMES"+id).val(riskRatingDesc+" ("+riskRating+")");
		setMaximumRiskRating();
	}
	
	function setMaximumRiskRating(){
		var id = '${UNQID}';
		var PRINCICOUNTRYRISKRATING = $("#PRINCICOUNTRYRISKRATING"+id).val();
		var INCROPCOUNTRYRISKRATING = $("#INCROPCOUNTRYRISKRATING"+id).val();
		if(PRINCICOUNTRYRISKRATING == "Low" || INCROPCOUNTRYRISKRATING == "Low"){
			$("#GEOGRAPHICRISKRATING_VALUE"+id).val("Low");
			$("#GEOGRAPHICRISKRATING"+id).val("Low");
		}
		if(PRINCICOUNTRYRISKRATING == "Medium" || INCROPCOUNTRYRISKRATING == "Medium"){
			$("#GEOGRAPHICRISKRATING_VALUE"+id).val("Medium");
			$("#GEOGRAPHICRISKRATING"+id).val("Medium");
		}
		if(PRINCICOUNTRYRISKRATING == "High" || INCROPCOUNTRYRISKRATING == "High"){
			$("#GEOGRAPHICRISKRATING_VALUE"+id).val("High");
			$("#GEOGRAPHICRISKRATING"+id).val("High");
		}
	}
</script>
<div class="col-sm-12">
	<div class="card card-primary panel_CDDForm">
		<div class="card-header panelSlidingCDDForm${UNQID} clearfix">
			<h6 class="card-title pull-${dirL}">CDD Form for Existing Corporate Customer For Compass ReferenceNo : ${COMPASSREFERENCENO}</h6>
		</div>
		<div class="panelSearchForm">
				<div class="card-search-card" >
					<ul class="nav nav-pills modalNav" role="tablist">
						<li role="presentation" class="active" id="cddTab">
							<a class="subTab nav-link active" href="#cdd" aria-controls="tab" role="tab" data-toggle="tab">Customer Due Diligence</a>
						</li>
						<li role="presentation" id="screeningTab">
							<a class="subTab nav-link" href="#screening" aria-controls="tab" role="tab" data-toggle="tab">Screening</a>
						</li>
						<li role="presentation" id="riskRatingTab">
							<a class="subTab nav-link" href="#riskRating" aria-controls="tab" role="tab" data-toggle="tab">Risk Rating</a>
						</li>
						<li role="presentation" id="checkListTab">
							<a class="subTab nav-link" href="#checkList" aria-controls="tab" role="tab" data-toggle="tab">Check List</a>
						</li>
						<li role="presentation" id="identificationFormTab">
							<a class="subTab nav-link" href="#identificationForm" aria-controls="tab" role="tab" data-toggle="tab">IdentificationForm</a>
						</li>
						<li role="presentation" id="statusApprovalsTab">
							<a class="subTab nav-link" href="#statusApprovals" aria-controls="tab" role="tab" data-toggle="tab">Status & Approvals</a>
						</li>
					</ul>
					<div class="tab-content">
						<div role="tabpanel" class="tab-pane active" id="cdd">
							<form action="javascript:void(0)" method="POST" id="searchMasterForm1${UNQID}">
							<input type="hidden" name="COMPASSREFERENCENO" id="COMPASSREFERENCENO${UNQID}" value="${COMPASSREFERENCENO}"/>
							<input type="hidden" name="LINENO" id="LINENO${UNQID}" value="${LINENO}"/>
							<table class="table table-bordered table-striped" style="margin-bottom: 0px;">
								<tbody>
									<tr>
										<td width="15%">
											Date of Last Review<font size = "4" color = "red"><b> * </b></font>
										</td>
										<td width="33%">
											<input type="text" class="form-control input-sm" readonly="readonly" name="LASTREVIEWDATE" id="LASTREVIEWDATE${UNQID}" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"LASTREVIEWDATE")){ %> disabled <% } %> value="${FORMDATA['LASTREVIEWDATE']}">
										</td>
										<td width="4%">&nbsp;</td>
										<td width="15%">
											Date Current Review Started
										</td>
										<td width="33%">
											<input type="text" class="form-control input-sm" readonly="readonly" name="CURRENTREVIEWDATE" id="CURRENTREVIEWDATE${UNQID}" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"CURRENTREVIEWDATE")){ %> disabled <% } %> value="${FORMDATA['STARTTIMESTAMP']}">
										</td>
									</tr>
									<tr>
										<td width="15%">
											Full Name of Customer
										</td>
										<td width="33%">
											<input type="text" autocomplete="off" class="form-control input-sm" name="CUSTOMERNAME" id="CUSTOMERNAME${UNQID}" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"CUSTOMERNAME")){ %> disabled <% } %> value="${FORMDATA['CUSTOMERNAME']}">
										</td>
										<td width="4%">&nbsp;</td>
										<td width="15%">
											Formerly Known As
										</td>
										<td width="33%">
											<input type="text" autocomplete="off" class="form-control input-sm" name="CUSTOMERPREVNAME" id="CUSTOMERPREVNAME${UNQID}" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"CUSTOMERPREVNAME")){ %> disabled <% } %> value="${FORMDATA['CUSTOMERPREVNAME']}">
										</td>
									</tr>
									<tr>
										<td>
											Alias (if any)
										</td>
										<td>
											<input type="text"  autocomplete="off" class="form-control input-sm" name="CUSTOMERALIASNAME" id="CUSTOMERALIASNAME${UNQID}" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"CUSTOMERALIASNAME")){ %> disabled <% } %>  value="${FORMDATA['CUSTOMERALIASNAME']}">
										</td>
										<td>&nbsp;</td>
										<td>
											Customer ID<font size = "4" color = "red"><b> * </b></font>
										</td>
										<td>
											<input type="text" class="form-control input-sm" name="CUSTOMERID" id="CUSTOMERID${UNQID}" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"CUSTOMERID")){ %> disabled <% } %> value="${FORMDATA['CUSTOMERID']}">
										</td>
									</tr>
									<tr>
										
									</tr>
									<tr>
										<td>Relationship Manager<font size = "4" color = "red"><b> * </b></font></td>
										<td>
											<input type="text" class="form-control input-sm" name="RELATIONSHIPMANAGER" id="RELATIONSHIPMANAGER${UNQID}" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"RELATIONSHIPMANAGER")){ %> disabled <% } %> value="${FORMDATA['RELATIONSHIPMANAGER']}">
										</td>
										<td>&nbsp;</td>
										<td>Department-In-Charge<font size = "4" color = "red"><b> * </b></font></td>
										<td>
											<input type="text" class="form-control input-sm" name="DEPTINCHARGE" id="DEPTINCHARGE${UNQID}" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"DEPTINCHARGE")){ %> disabled <% } %> value="${FORMDATA['DEPTINCHARGE']}">
										</td>
									</tr>
									<tr>
										<td>Previous Risk Rating<font size = "4" color = "red"><b> * </b></font></td>
										<td colspan="4">
											<input type="text" class="form-control input-sm" name="PREVIOUSRISKRATING" id="PREVIOUSRISKRATING${UNQID}" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"PREVIOUSRISKRATING")){ %> disabled <% } %> value="${FORMDATA['PREVIOUSRISKRATING']}">
										</td>
									</tr>
									<tr>
										<td colspan="5"><strong>Purpose of CDD Review (Please select one of the following)</strong><font size = "4" color = "red"><b> * </b></font></td>
									</tr>
									<tr>
										<td colspan="5">
											<table class="table">
												<tr>
													<td width="50%">
														<label class="btn btn-outline btn-primary btn-sm radio-inline" for="REVIEWPURPOSE1${UNQID}">
															<input type="radio" id="REVIEWPURPOSE1${UNQID}" name="REVIEWPURPOSE" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"REVIEWPURPOSE")){ %> disabled <% } %> value="1"
															<c:if test="${FORMDATA['REVIEWPURPOSE'] eq '1'}">checked="checked"</c:if>
															/>
															Regular Periodic CDD Review
														</label>
													</td>
													<td width="50%">
														<label class="btn btn-outline btn-primary btn-sm radio-inline" for="REVIEWPURPOSE2${UNQID}">
															<input type="radio" id="REVIEWPURPOSE2${UNQID}" name="REVIEWPURPOSE" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"REVIEWPURPOSE")){ %> disabled <% } %> value="2"
															<c:if test="${FORMDATA['REVIEWPURPOSE'] eq '2'}">checked="checked"</c:if>
															/>
															Knowledge of adverse news / negative information on Customer, <br/>beneficial owner(s), authorized signor(s) or director(s)
														</label>
													</td>
												</tr>
												<tr>
													<td width="50%">
														<label class="btn btn-outline btn-primary btn-sm radio-inline" for="REVIEWPURPOSE3${UNQID}">
															<input type="radio" id="REVIEWPURPOSE3${UNQID}" name="REVIEWPURPOSE" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"REVIEWPURPOSE")){ %> disabled <% } %> value="3"
															<c:if test="${FORMDATA['REVIEWPURPOSE'] eq '3'}">checked="checked"</c:if>
															/>
															Addition of Customers, Beneficial Owner(s), Authorized Signor(s) or <br/>Directors to economic sanctions and/or restricted lists and/or PEP status
														</label>
													</td>
													<td width="50%">
														<label class="btn btn-outline btn-primary btn-sm radio-inline" for="REVIEWPURPOSE4${UNQID}">
															<input type="radio" id="REVIEWPURPOSE4${UNQID}" name="REVIEWPURPOSE" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"REVIEWPURPOSE")){ %> disabled <% } %> value="4"
															<c:if test="${FORMDATA['REVIEWPURPOSE'] eq '4'}">checked="checked"</c:if>
															/>
															Changes in Beneficial Owner(s) of Customer or Customer's <br/>ownership and control structure
														</label>
													</td>
												</tr>
												<tr>
													<td colspan="2">
														<label class="btn btn-outline btn-primary btn-sm radio-inline" for="REVIEWPURPOSE5${UNQID}">
															<input type="radio" id="REVIEWPURPOSE5${UNQID}" name="REVIEWPURPOSE" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"REVIEWPURPOSE")){ %> disabled <% } %> value="5"
															<c:if test="${FORMDATA['REVIEWPURPOSE'] eq '5'}">checked="checked"</c:if>
															/>
															Others
														</label>
													</td>
												</tr>
												<tr>
													<td width="50%">
														Please state others
													</td>
													<td width="50%">
														<input type="text" class="form-control input-sm" name="OTHERREVIEWPURPOSE" id="OTHERREVIEWPURPOSE${UNQID}" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"OTHERREVIEWPURPOSE")){ %> disabled <% } %> value="${FORMDATA['OTHERREVIEWPURPOSE']}">
													</td>
												</tr>
											</table>
										</td>
									</tr>
									<tr>
										<td colspan="5" style="text-align: left;">
											<strong> Checking of Common Customer</strong>
											<table class="table" style="margin-bottom: 0px;">
												<tr>
													<td colspan="2" width="50%">
														Does the customer have an existing banking relationship with any other India branch?
													</td>
													<td width="25%">
														<label class="btn btn-outline btn-success btn-sm radio-inline" for="EXISTINGCUSTOMERN${UNQID}">
														  <input type="radio" id="EXISTINGCUSTOMERN${UNQID}" name="EXISTINGCUSTOMER" checked="checked" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"EXISTINGCUSTOMER")){ %> disabled <% } %> value="NO"
														  <c:if test="${FORMDATA['EXISTINGCUSTOMER'] ne 'YES'}">checked="checked"</c:if>
														  />
														  	No
														</label>
														
														<label class="btn btn-outline btn-success btn-sm radio-inline" for="EXISTINGCUSTOMERY${UNQID}">
														  <input type="radio" id="EXISTINGCUSTOMERY${UNQID}"  name="EXISTINGCUSTOMER" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"EXISTINGCUSTOMER")){ %> disabled <% } %> value="YES"
														  <c:if test="${FORMDATA['EXISTINGCUSTOMER'] eq 'YES'}">checked="checked"</c:if>
														  />
														  	Yes
														</label>
													</td>
													<td width="25%">&nbsp;</td>
												</tr>
												<tr>
													<td colspan="4">
														If Yes, which branch(es) and what is the assigned AML Risk Rating?
													</td>
												</tr>
												<tr>
													<td colspan="2">
														Branch
													</td>
													<td colspan="2">
														<select class="form-control input-sm selectpicker" multiple name="EXISTINGBRANCH" id="EXISTINGBRANCH${UNQID}" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"EXISTINGBRANCH")){ %> disabled <% } %>>
															<c:forEach var="BRANCHCODE" items="${BRANCHCODE}">
																<option value="${BRANCHCODE.key}" <c:if test="${f:contains(FORMDATA['EXISTINGBRANCH'], BRANCHCODE.key)}">selected="selected"</c:if>>${BRANCHCODE.value}</option>
															</c:forEach>
														</select>
													</td>
												</tr>
												<tr>
													<td colspan="2">
														Risk Rating
													</td>
													<td colspan="2">
														<label class="btn btn-outline btn-primary btn-sm radio-inline" for="EXISTINGRISKRATING1${UNQID}">
														  <input type="radio" id="EXISTINGRISKRATING1${UNQID}" name="EXISTINGRISKRATING" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"EXISTINGRISKRATING")){ %> disabled <% } %> value="1"
														  <c:if test="${FORMDATA['EXISTINGRISKRATING'] eq '1'}">checked="checked"</c:if>
														  <c:if test="${FORMDATA['EXISTINGCUSTOMER'] ne 'YES'}">disabled</c:if>
														  />
														  	1 Low
														</label>
														
														<label class="btn btn-outline btn-primary btn-sm radio-inline" for="EXISTINGRISKRATING2${UNQID}">
														  <input type="radio" id="EXISTINGRISKRATING2${UNQID}"  name="EXISTINGRISKRATING" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"EXISTINGRISKRATING")){ %> disabled <% } %> value="2"
														  <c:if test="${FORMDATA['EXISTINGRISKRATING'] eq '2'}">checked="checked"</c:if>
														  <c:if test="${FORMDATA['EXISTINGCUSTOMER'] ne 'YES'}">disabled</c:if>
														  />
														  	2 Low
														</label>
														
														&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
														
														<label class="btn btn-outline btn-primary btn-sm radio-inline" for="EXISTINGRISKRATING3${UNQID}">
														  <input type="radio" id="EXISTINGRISKRATING3${UNQID}"  name="EXISTINGRISKRATING" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"EXISTINGRISKRATING")){ %> disabled <% } %> value="3"
														  <c:if test="${FORMDATA['EXISTINGRISKRATING'] eq '3'}">checked="checked"</c:if>
														  <c:if test="${FORMDATA['EXISTINGCUSTOMER'] ne 'YES'}">disabled</c:if>
														  />
														  	3 Medium
														</label>
														
														&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
														
														<label class="btn btn-outline btn-primary btn-sm radio-inline" for="EXISTINGRISKRATING4${UNQID}">
														  <input type="radio" id="EXISTINGRISKRATING4${UNQID}"  name="EXISTINGRISKRATING" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"EXISTINGRISKRATING")){ %> disabled <% } %> value="4"
														  <c:if test="${FORMDATA['EXISTINGRISKRATING'] eq '4'}">checked="checked"</c:if>
														  <c:if test="${FORMDATA['EXISTINGCUSTOMER'] ne 'YES'}">disabled</c:if>
														  />
														  	4 High
														</label>
														<label class="btn btn-outline btn-primary btn-sm radio-inline" for="EXISTINGRISKRATING5${UNQID}">
														  <input type="radio" id="EXISTINGRISKRATING5${UNQID}"  name="EXISTINGRISKRATING" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"EXISTINGRISKRATING")){ %> disabled <% } %> value="5"
														  <c:if test="${FORMDATA['EXISTINGRISKRATING'] eq '5'}">checked="checked"</c:if>
														  <c:if test="${FORMDATA['EXISTINGCUSTOMER'] ne 'YES'}">disabled</c:if>
														  />
														  	5 High
														</label>
													</td>
												</tr>
												<tr>
													<td colspan="4">
														<strong>General Checking (for prohibation of establishment of banking relationship with non-acceptable customers)</strong>
													</td>
												</tr>
												<tr>
													<td colspan="4">
														Are you aware of any of the following?<br/>
														<label style="margin-bottom: 8px" class="btn btn-outline btn-primary btn-sm checkbox-inline" for="GENERALCHECKING1${UNQID}">
														  <input type="checkbox" id="GENERALCHECKING1${UNQID}"  name="GENERALCHECKING1" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"GENERALCHECKING1")){ %> disabled <% } %> value="1"
														  <c:if test="${FORMDATA['GENERALCHECKING1'] eq '1'}">checked="checked"</c:if>
														  />
														  	1) Customer who requested anonymity or give fictitious names
														</label>
														<br/>
														<label style="margin-bottom: 8px" class="btn btn-outline btn-primary btn-sm checkbox-inline" for="GENERALCHECKING2${UNQID}">
														  <input type="checkbox" id="GENERALCHECKING2${UNQID}"  name="GENERALCHECKING2" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"GENERALCHECKING2")){ %> disabled <% } %> value="2"
														  <c:if test="${FORMDATA['GENERALCHECKING2'] eq '2'}">checked="checked"</c:if>
														  />
														  	2) Customer who request for numbered account(s)
														</label>
														<br/>
														<label style="margin-bottom: 8px" class="btn btn-outline btn-primary btn-sm checkbox-inline" for="GENERALCHECKING3${UNQID}">
														  <input type="checkbox" id="GENERALCHECKING3${UNQID}"  name="GENERALCHECKING3" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"GENERALCHECKING3")){ %> disabled <% } %> value="3"
														  <c:if test="${FORMDATA['GENERALCHECKING3'] eq '3'}">checked="checked"</c:if>
														  />
														  	3) Situations where there are suspicions that Customer may be involved in money laundering or terrorist financing
														</label>
														<br/>
														<label style="margin-bottom: 8px" class="btn btn-outline btn-primary btn-sm checkbox-inline" for="GENERALCHECKING4${UNQID}">
														  <input type="checkbox" id="GENERALCHECKING4${UNQID}"  name="GENERALCHECKING4" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"GENERALCHECKING4")){ %> disabled <% } %> value="4"
														  <c:if test="${FORMDATA['GENERALCHECKING4'] eq '4'}">checked="checked"</c:if>
														  />
														  	4) Refusal to provide basic information on their identity
														</label>
														<br/>
														<label style="margin-bottom: 8px" class="btn btn-outline btn-primary btn-sm checkbox-inline" for="GENERALCHECKING5${UNQID}">
														  <input type="checkbox" id="GENERALCHECKING5${UNQID}"  name="GENERALCHECKING5" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"GENERALCHECKING5")){ %> disabled <% } %> value="5"
														  <c:if test="${FORMDATA['GENERALCHECKING5'] eq '5'}">checked="checked"</c:if>
														  />
														  	5) Unable to ascertain the legitimacy of Customer's or Beneficial Owner's source of funds
														</label>
														<br/>
														<label style="margin-bottom: 8px" class="btn btn-outline btn-primary btn-sm checkbox-inline" for="GENERALCHECKING6${UNQID}">
														  <input type="checkbox" id="GENERALCHECKING6${UNQID}"  name="GENERALCHECKING6" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"GENERALCHECKING6")){ %> disabled <% } %> value="6"
														  <c:if test="${FORMDATA['GENERALCHECKING6'] eq '6'}">checked="checked"</c:if>
														  />
														  	6) Other cases as informed by Branch Compliance Team
														</label><br/>
														<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="GENERALCHECKING7${UNQID}">
														  <input type="checkbox" id="GENERALCHECKING7${UNQID}"  name="GENERALCHECKING7" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"GENERALCHECKING7")){ %> disabled <% } %> value="7"
														  <c:if test="${FORMDATA['GENERALCHECKING7'] eq '7'}">checked="checked"</c:if>
														  />
														  	7) None of the above. Continue with CDD / KYC Checking.
														</label>
													</td>
												</tr>
												<tr>
													<td colspan="4">
														If customer falls into any of the categories from 1) - 6), Please refer case to Branch Compliance Team
													</td>
												</tr>
											</table>
										</td>
									</tr>
									<c:if test="${(FORMDATA['STATUS'] eq 'BPA-P' && CURRENTROLE eq 'ROLE_BPAMAKER') || (FORMDATA['STATUS'] eq 'BPD-P' && CURRENTROLE eq 'ROLE_BPDMAKER')}">
										<tr>
											<td colspan="5" style="text-align: right;">
												<button type="button" class="btn btn-success btn-sm saveDraftCDDForm" id="saveDraftCDDForm1${UNQID}">Save Draft</button>
												<button type="button" class="btn btn-success btn-sm saveCDDForm" id="saveCDDForm1${UNQID}">Save</button>
											</td>
										</tr>
									</c:if>
								</tbody>
							</table>
							
							<table class="table table-bordered table-striped" style="margin-bottom: 0px;" id="GeneralInformationTable">
								<tbody>
									<tr>
										<td colspan="5"> <strong>Customer Information</strong> </td>
									</tr>
									<tr>
										<td width="15%">
											Registered Address<font size = "4" color = "red"><b> * </b></font>
										</td>
										<td width="33%">
											<table class="table" style="margin: 0px;">
												<tr>
													<td>
														Line 1<font size = "4" color = "red"><b> * </b></font>
													</td>
													<td>
														<textarea rows="2" cols="2" class="form-control" name="RESIDENTIALADDRESS" id="RESIDENTIALADDRESS${UNQID}" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"RESIDENTIALADDRESS")){ %> disabled <% } %>>${FORMDATA['RESIDENTIALADDRESS']}</textarea>
													</td>
												</tr>
												<tr>
													<td>
														Line 2<font size = "4" color = "red"><b> * </b></font>
													</td>
													<td>
														<input type="text" class="form-control input-sm" name="RESIDENTIALADDRESS2" id="RESIDENTIALADDRESS2${UNQID}" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"RESIDENTIALADDRESS2")){ %> disabled <% } %> value="${FORMDATA['RESIDENTIALADDRESS2']}"/>
													</td>
												</tr>
												<tr>
													<td>
														Line 3<font size = "4" color = "red"><b> * </b></font>
													</td>
													<td>
														<input type="text" class="form-control input-sm" name="RESIDENTIALADDRESS3" id="RESIDENTIALADDRESS3${UNQID}" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"RESIDENTIALADDRESS3")){ %> disabled <% } %> value="${FORMDATA['RESIDENTIALADDRESS3']}"/>
													</td>
												</tr>
											</table>
										</td>
										<td width="4%" style="text-align: center; vertical-align: middle;">
											<button type="button" class="btn btn-primary btn-sm" id="copyRAtoMA${UNQID}">
											<i class="fa fa-arrow-right" aria-hidden="true"></i>
											</button>
										</td>
										<td width="15%">
											Mailing Address<font size = "4" color = "red"><b> * </b></font>
										</td>
										<td width="33%">
											<table class="table" style="margin: 0px;">
												<tr>
													<td>
														Line 1<font size = "4" color = "red"><b> * </b></font>
													</td>
													<td>
														<textarea rows="2" cols="2" class="form-control" name="MAILINGADDRESS" id="MAILINGADDRESS${UNQID}" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"MAILINGADDRESS")){ %> disabled <% } %>>${FORMDATA['MAILINGADDRESS']}</textarea>
													</td>
												</tr>
												<tr>
													<td>
														Line 2<font size = "4" color = "red"><b> * </b></font>
													</td>
													<td>
														<input type="text" class="form-control input-sm" name="MAILINGADDRESS2" id="MAILINGADDRESS2${UNQID}" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"MAILINGADDRESS2")){ %> disabled <% } %> value="${FORMDATA['MAILINGADDRESS2']}"/>
													</td>
												</tr>
												<tr>
													<td>
														Line 3<font size = "4" color = "red"><b> * </b></font>
													</td>
													<td>
														<input type="text" class="form-control input-sm" name="MAILINGADDRESS3" id="MAILINGADDRESS3${UNQID}" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"MAILINGADDRESS3")){ %> disabled <% } %> value="${FORMDATA['MAILINGADDRESS3']}"/>
													</td>
												</tr>
											</table>
										</td>
									</tr>
									<tr>
										<td width="15%">
											PAN No<font size = "4" color = "red"><b> * </b></font>
										</td>
										<td width="33%">
											<input type="text" class="form-control input-sm" name="PANNO" id="PANNO${UNQID}" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"PANNO")){ %> disabled <% } %> value="${FORMDATA['PANNO']}"/>
										</td>
										<td width="4%"  style="text-align: center; vertical-align: middle;">
											<button type="button" class="btn btn-primary btn-sm" id="checkCustomerPANNo${UNQID}" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"CHECKCUSTOMERPANNO")){ %> disabled <% } %>>Check PAN</button>
										</td>
										<td width="15%">
											NSDL Response
										</td>
										<td width="33%">
											<textarea rows="2" cols="2" class="form-control" name="PANNSDLRESPONSE" id="PANNSDLRESPONSE${UNQID}"  readOnly>${FORMDATA['PANNSDLRESPONSE']}</textarea>
										</td>
									</tr>
									<tr>
										<td>
											Type of Business<font size = "4" color = "red"><b> * </b></font>
										</td>
										<td id="OCCUPATIONID">
											<select class="form-control input-sm selectpicker" name="BUSINESSTYPE" id="BUSINESSTYPE${UNQID}" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"BUSINESSTYPE")){ %> disabled <% } %> onchange="getRiskRating('INDUSTRYTYPE',this,'INDUSTRYTYPERISKRATING')">
												<option value="">Select One</option>
												<c:forEach var="INDUSTRYOCCUPATIONMASTER" items="${INDUSTRYOCCUPATIONMASTER}">
													<option value="${INDUSTRYOCCUPATIONMASTER['OPTIONVALUE']}" riskRating="${INDUSTRYOCCUPATIONMASTER['RISKRATING']}" 
													<c:if test="${FORMDATA['BUSINESSTYPE'] eq INDUSTRYOCCUPATIONMASTER['OPTIONVALUE']}">selected="selected"</c:if>>${INDUSTRYOCCUPATIONMASTER['OPTIONNAME']}</option>
												</c:forEach>
											</select>
										</td>
										<td>&nbsp;</td>
										<td>
											Other Business Type
										</td>
										<td>
											<input type="text" class="form-control input-sm" name="OTHERBUSINESSTYPE" id="OTHERBUSINESSTYPE${UNQID}" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"OTHERBUSINESSTYPE")){ %> disabled <% } %> value="${FORMDATA['OTHERBUSINESSTYPE']}">
										</td>
									</tr>
									<tr>
										<td>
											Nature of Business<font size = "4" color = "red"><b> * </b></font>
										</td>
										<td>
											<input type="text" class="form-control input-sm" name="NATUREOFBUSINESS" id="NATUREOFBUSINESS${UNQID}" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"NATUREOFBUSINESS")){ %> disabled <% } %> value="${FORMDATA['NATUREOFBUSINESS']}">
										</td>
										<td>&nbsp;</td>
										<td>
											Purpose of Business Relationship / Opening Account
										</td>
										<td>
											<input type="text" class="form-control input-sm" name="PURPOSEOFACCOUNT" id="PURPOSEOFACCOUNT${UNQID}" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"PURPOSEOFACCOUNT")){ %> disabled <% } %> value="${FORMDATA['PURPOSEOFACCOUNT']}">
										</td>
									</tr>
									<tr>
										<td>
											Country of incorporation<font size = "4" color = "red"><b> * </b></font>
										</td>
										<td>
											<select class="form-control input-sm selectpicker" name="COUNRYOFINCORPORATION" id="COUNRYOFINCORPORATION${UNQID}" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"COUNRYOFINCORPORATION")){ %> disabled <% } %> onchange="getRiskRating('INCROPCOUNTRY',this,'INCROPCOUNTRYRISKRATING')">
												<option value="">Select One</option>
												<c:forEach var="COUNTRYMASTER" items="${COUNTRYMASTER}">
													<option value="${COUNTRYMASTER['OPTIONVALUE']}" riskRating="${COUNTRYMASTER['RISKRATING']}" 
													<c:if test="${FORMDATA['COUNRYOFINCORPORATION'] eq COUNTRYMASTER['OPTIONVALUE']}">selected="selected"</c:if>>${COUNTRYMASTER['OPTIONNAME']}</option>
												</c:forEach>
											</select>
										</td>
										<td>&nbsp;</td>
										<td>
											Date of incorporation<font size = "4" color = "red"><b> * </b></font>
										</td>
										<td>
											<input type="text" class="form-control input-sm datepicker" name="DATEOFINCORPORATION" id="DATEOFINCORPORATION${UNQID}" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"DATEOFINCORPORATION")){ %> disabled <% } %> value="${FORMDATA['DATEOFINCORPORATION']}">
										</td>
									</tr>
									<tr>
										<td>
											List Principal Countries of Business<font size = "4" color = "red"><b> * </b></font>
										</td>
										<td>
											<select class="form-control input-sm selectpicker" multiple name="PRINCIPALCOUNTRIES" id="PRINCIPALCOUNTRIES${UNQID}" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"PRINCIPALCOUNTRIES")){ %> disabled <% } %> onchange="getRiskMaxRating('PRINCIPALCOUNTRY',this,'PRINCICOUNTRYRISKRATING')"
												<c:forEach var="COUNTRYMASTER" items="${COUNTRYMASTER}">
													<option value="${COUNTRYMASTER['OPTIONVALUE']}" riskRating="${COUNTRYMASTER['RISKRATING']}"
													<c:if test="${f:contains(FORMDATA['PRINCIPALCOUNTRIES'], COUNTRYMASTER['OPTIONVALUE'])}">selected="selected"</c:if>>${COUNTRYMASTER['OPTIONNAME']}</option>
												</c:forEach>
											</select>
										</td>
										<td>&nbsp;</td>
										<td>
											State the Principal Countries of Business with the Higest Risk Rating
										</td>
										<td>
											<input type="text" class="form-control input-sm" readonly="readonly" name="PRINCIPALCOUNTRIESNAMES" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"PRINCIPALCOUNTRIESNAMES")){ %> disabled <% } %> id="PRINCIPALCOUNTRIESNAMES${UNQID}"
												value="${FORMDATA['PRINCIPALCOUNTRIESNAMES']}"
											/>
										</td>
									</tr>
									<tr>
										<td rowspan="2" style="vertical-align: middle;">
											Type of Company Structure<br/>
											If others, please specify others
										</td>
										<td id="COMPANYSTRUCTUREID">
											<select class="form-control input-sm selectpicker" name="COMPANYSTRUCTURETYPE" id="COMPANYSTRUCTURETYPE${UNQID}" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"COMPANYSTRUCTURETYPE")){ %> disabled <% } %> onchange="getRiskRating('ATTRIBUTETYPE',this,'ATTRIBUTETYPERISKRATING')">
												<option value="">Select One</option>												
												<c:forEach var="ATTRIBUTETYPEMASTER" items="${ATTRIBUTETYPEMASTER}">
													<option value="${ATTRIBUTETYPEMASTER['OPTIONVALUE']}" riskRating="${ATTRIBUTETYPEMASTER['RISKRATING']}"
													<c:if test="${FORMDATA['COMPANYSTRUCTURETYPE'] eq ATTRIBUTETYPEMASTER['OPTIONVALUE']}">selected="selected"</c:if>>${ATTRIBUTETYPEMASTER['OPTIONNAME']}</option>
												</c:forEach>
											</select>
										</td>
										<td>&nbsp;</td>
										<td rowspan="2" style="vertical-align: middle;">
											Source of Funds<br/>
											If others, please state others<font size = "4" color = "red"><b> * </b></font>
										</td>
										<td>
											<select class="form-control input-sm selectpicker" name="SOURCEOFFUND" id="SOURCEOFFUND${UNQID}" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"SOURCEOFFUND")){ %> disabled <% } %>>
												<option value="">Select One</option>												
												<c:forEach var="SOURCEOFFUND" items="${SOURCEOFFUND}">
													<option value="${SOURCEOFFUND['OPTIONVALUE']}" 
													<c:if test="${FORMDATA['SOURCEOFFUND'] eq SOURCEOFFUND['OPTIONVALUE']}">selected="selected"</c:if>>${SOURCEOFFUND['OPTIONNAME']}</option>
												</c:forEach>
											</select>
										</td>
									</tr>
									<tr>
										<td>
											<input type="text" class="form-control input-sm" name="OTHERCOMPANYSTRUCTURE" id="OTHERCOMPANYSTRUCTURE${UNQID}" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"OTHERCOMPANYSTRUCTURE")){ %> disabled <% } %> value="${FORMDATA['OTHERCOMPANYSTRUCTURE']}">
										</td>
										<td>&nbsp;</td>
										<td>
											<input type="text" class="form-control input-sm" name="OTHERSOURCEOFFUND" id="OTHERSOURCEOFFUND${UNQID}" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"OTHERSOURCEOFFUND")){ %> disabled <% } %> value="${FORMDATA['OTHERSOURCEOFFUND']}">
										</td>
									</tr>
									<tr>
										<td colspan="2">
											Types of Products and/or Services offered to Customer<br/>
											(Select all applicable Products and Services)<font size = "4" color = "red"><b> * </b></font>
										</td>
										<td colspan="3">
											<table class="table" style="margin-bottom: 0px;">
												<tr>
													<td>
														<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="PRODUCTSERVICE_TD${UNQID}">
														  <input type="checkbox" id="PRODUCTSERVICE_TD${UNQID}"  name="PRODUCTSERVICE_TD" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"PRODUCTSERVICE_TD")){ %> disabled <% } %> value="TD"
														  <c:if test="${FORMDATA['PRODUCTSERVICE_TD'] eq 'TD'}">checked="checked"</c:if>
														   riskRating="Low" />
														  <span>Time / Term Deposits</span>
														</label>
													</td>
													<td>
														<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="PRODUCTSERVICE_SA${UNQID}">
														  <input type="checkbox" id="PRODUCTSERVICE_SA${UNQID}"  name="PRODUCTSERVICE_SA" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"PRODUCTSERVICE_SA")){ %> disabled <% } %> value="SA"
														  <c:if test="${FORMDATA['PRODUCTSERVICE_SA'] eq 'SA'}">checked="checked"</c:if>
														  riskRating="High" />
														  <span>Saving Account</span>
														</label>
													</td>
												</tr>
												<tr>
													<td>
														<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="PRODUCTSERVICE_GR${UNQID}">
														  <input type="checkbox" id="PRODUCTSERVICE_GR${UNQID}"  name="PRODUCTSERVICE_GR" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"PRODUCTSERVICE_GR")){ %> disabled <% } %> value="GR"
														  <c:if test="${FORMDATA['PRODUCTSERVICE_GR'] eq 'GR'}">checked="checked"</c:if>
														  riskRating="Low" />
														  <span>Guarantees</span>
														</label>
													</td>
													<td>
														<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="PRODUCTSERVICE_CA${UNQID}">
														  <input type="checkbox" id="PRODUCTSERVICE_CA${UNQID}"  name="PRODUCTSERVICE_CA" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"PRODUCTSERVICE_CA")){ %> disabled <% } %> value="CA"
														  <c:if test="${FORMDATA['PRODUCTSERVICE_CA'] eq 'CA'}">checked="checked"</c:if>
														  riskRating="High" />
														  <span>Current Account</span>
														</label>
													</td>
												</tr>
												<tr>
													<td>
														<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="PRODUCTSERVICE_LN${UNQID}">
														  <input type="checkbox" id="PRODUCTSERVICE_LN${UNQID}"  name="PRODUCTSERVICE_LN" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"PRODUCTSERVICE_LN")){ %> disabled <% } %> value="LN"
														  <c:if test="${FORMDATA['PRODUCTSERVICE_LN'] eq 'LN'}">checked="checked"</c:if>
														  riskRating="Low" />
														  <span>Loan</span>
														</label>
													</td>
													<td>
														<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="PRODUCTSERVICE_RE${UNQID}">
														  <input type="checkbox" id="PRODUCTSERVICE_RE${UNQID}"  name="PRODUCTSERVICE_RE" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"PRODUCTSERVICE_RE")){ %> disabled <% } %> value="RE"
														  <c:if test="${FORMDATA['PRODUCTSERVICE_RE'] eq 'RE'}">checked="checked"</c:if>
														  riskRating="High" />
														  <span>Remittance (i.e. ITT & OTT)</span>
														</label>
													</td>
												</tr>
												<tr>
													<td>
														<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="PRODUCTSERVICE_IB${UNQID}">
														  <input type="checkbox" id="PRODUCTSERVICE_IB${UNQID}"  name="PRODUCTSERVICE_IB" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"PRODUCTSERVICE_IB")){ %> disabled <% } %> value="IB"
														  <c:if test="${FORMDATA['PRODUCTSERVICE_IB'] eq 'IB'}">checked="checked"</c:if>
														  riskRating="High" />
														  <span>Internet Banking (i.e. MGeB)</span>
														</label>
													</td>
													<td>
														<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="PRODUCTSERVICE_TF${UNQID}">
														  <input type="checkbox" id="PRODUCTSERVICE_TF${UNQID}"  name="PRODUCTSERVICE_TF" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"PRODUCTSERVICE_TF")){ %> disabled <% } %> value="TF"
														  <c:if test="${FORMDATA['PRODUCTSERVICE_TF'] eq 'TF'}">checked="checked"</c:if>
														  riskRating="High" />
														  <span>Trade Finance</span>
														</label>
													</td>
												</tr>
												<tr>
													<td>
														<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="PRODUCTSERVICE_OT${UNQID}">
														  <input type="checkbox" id="PRODUCTSERVICE_OT${UNQID}"  name="PRODUCTSERVICE_OT" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"PRODUCTSERVICE_OT")){ %> disabled <% } %> value="OT"
														  <c:if test="${FORMDATA['PRODUCTSERVICE_OT'] eq 'OT'}">checked="checked"</c:if>
														  riskRating="High" />
														  <span>Others</span>
														</label>
													</td>
													<td>
														&nbsp;
													</td>
												</tr>
											</table>
										</td>
									</tr>
									<tr>
										<td colspan="2">
											If Others, please specify others
										</td>
										<td colspan="3">
											<textarea rows="2" cols="2" class="form-control" name="OTHERPRODUCTSERVICE" id="OTHERPRODUCTSERVICE${UNQID}" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"OTHERPRODUCTSERVICE")){ %> disabled <% } %>>${FORMDATA['OTHERPRODUCTSERVICE']}</textarea>
										</td>
									</tr>
									<tr>
										<td colspan="2">
											How does customer transact with MHBK?<br/>
										</td>
										<td colspan="3">
											<label class="btn btn-outline btn-primary btn-sm radio-inline" for="FACETOFACEINTRACTIONY${UNQID}">
												<input type="radio" id="FACETOFACEINTRACTIONY${UNQID}" name="FACETOFACEINTRACTION" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"FACETOFACEINTRACTION")){ %> disabled <% } %> value="YES"
												<c:if test="${FORMDATA['FACETOFACEINTRACTION'] eq 'YES'}">checked="checked"</c:if>
												/>
												Face to face interaction with Customer
											</label>
											
											<label class="btn btn-outline btn-primary btn-sm radio-inline" for="FACETOFACEINTRACTIONN${UNQID}">
												<input type="radio" id="FACETOFACEINTRACTIONN${UNQID}"  name="FACETOFACEINTRACTION" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"FACETOFACEINTRACTION")){ %> disabled <% } %> value="NO"
												<c:if test="${FORMDATA['FACETOFACEINTRACTION'] eq 'NO'}">checked="checked"</c:if>
												/>
												NO face to face interaction with Customer
											</label>
											
											<label class="btn btn-outline btn-primary btn-sm radio-inline" for="FACETOFACEINTRACTIONB${UNQID}">
												<input type="radio" id="FACETOFACEINTRACTIONB${UNQID}"  name="FACETOFACEINTRACTION" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"FACETOFACEINTRACTION")){ %> disabled <% } %> value="BOTH"
												<c:if test="${FORMDATA['FACETOFACEINTRACTION'] eq 'BOTH'}">checked="checked"</c:if>
												/>
												Both
											</label>
										</td>
									</tr>
									<tr>
										<td colspan="2">If there was no face-to-face interation, please state reason </td>
										<td colspan="3">
											<textarea rows="2" cols="2" class="form-control" name="REASONFORNOINTRACTION" id="REASONFORNOINTRACTION${UNQID}" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"REASONFORNOINTRACTION")){ %> disabled <% } %>>${FORMDATA['REASONFORNOINTRACTION']}</textarea>
										</td>
									</tr>
									<tr>
										<td colspan="2">Is customer categorized as Mizuho group branches / subsidiaries</td>
										<td colspan="3">
											<label class="btn btn-outline btn-primary btn-sm radio-inline" for="MIZUHOBRANCHSUBSIDIARIESY${UNQID}">
												<input type="radio" id="MIZUHOBRANCHSUBSIDIARIESY${UNQID}" name="MIZUHOBRANCHSUBSIDIARIES" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"MIZUHOBRANCHSUBSIDIARIES")){ %> disabled <% } %> value="YES"
												<c:if test="${FORMDATA['MIZUHOBRANCHSUBSIDIARIES'] eq 'YES'}">checked="checked"</c:if>
												/>
												Yes
											</label>
											
											<label class="btn btn-outline btn-primary btn-sm radio-inline" for="MIZUHOBRANCHSUBSIDIARIESN${UNQID}">
												<input type="radio" id="MIZUHOBRANCHSUBSIDIARIESN${UNQID}"  name="MIZUHOBRANCHSUBSIDIARIES" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"MIZUHOBRANCHSUBSIDIARIES")){ %> disabled <% } %> value="NO"
												<c:if test="${FORMDATA['MIZUHOBRANCHSUBSIDIARIES'] eq 'NO'}">checked="checked"</c:if>
												/>
												No
											</label>
										</td>
									</tr>
									<tr>
										<td colspan="2">Is foreign correspondent banking customer (non-Mizuho group)</td>
										<td colspan="3">
											<label class="btn btn-outline btn-primary btn-sm radio-inline" for="FRGNCRSPNDNTBNKCSTOMRY${UNQID}">
												<input type="radio" id="FRGNCRSPNDNTBNKCSTOMRY${UNQID}" name="FRGNCRSPNDNTBNKCSTOMR" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"FRGNCRSPNDNTBNKCSTOMR")){ %> disabled <% } %> value="YES"
												<c:if test="${FORMDATA['FRGNCRSPNDNTBNKCSTOMR'] eq 'YES'}">checked="checked"</c:if>
												/>
												Yes
											</label>
											
											<label class="btn btn-outline btn-primary btn-sm radio-inline" for="FRGNCRSPNDNTBNKCSTOMRN${UNQID}">
												<input type="radio" id="FRGNCRSPNDNTBNKCSTOMRN${UNQID}"  name="FRGNCRSPNDNTBNKCSTOMR" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"FRGNCRSPNDNTBNKCSTOMR")){ %> disabled <% } %> value="NO"
												<c:if test="${FORMDATA['FRGNCRSPNDNTBNKCSTOMR'] eq 'NO'}">checked="checked"</c:if>
												/>
												No
											</label>
										</td>
									</tr>
									<tr>
										<td colspan="2">Is foreign correspondent banking customer from High Risk contries (non-Mizuho group)</td>
										<td colspan="3">
											<label class="btn btn-outline btn-primary btn-sm radio-inline" for="FRGNCRSPNDNTBNKCSTOMRHRY${UNQID}">
												<input type="radio" id="FRGNCRSPNDNTBNKCSTOMRHRY${UNQID}" name="FRGNCRSPNDNTBNKCSTOMRHR" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"FRGNCRSPNDNTBNKCSTOMR")){ %> disabled <% } %> value="YES"
												<c:if test="${FORMDATA['FRGNCRSPNDNTBNKCSTOMRHR'] eq 'YES'}">checked="checked"</c:if>
												/>
												Yes
											</label>
											
											<label class="btn btn-outline btn-primary btn-sm radio-inline" for="FRGNCRSPNDNTBNKCSTOMRHRN${UNQID}">
												<input type="radio" id="FRGNCRSPNDNTBNKCSTOMRHRN${UNQID}"  name="FRGNCRSPNDNTBNKCSTOMRHR" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"FRGNCRSPNDNTBNKCSTOMR")){ %> disabled <% } %> value="NO"
												<c:if test="${FORMDATA['FRGNCRSPNDNTBNKCSTOMRHR'] eq 'NO'}">checked="checked"</c:if>
												/>
												No
											</label>
										</td>
									</tr>
									<tr>
										<td colspan="2">Is NGO and/or Charity customer</td>
										<td colspan="3">
											<label class="btn btn-outline btn-primary btn-sm radio-inline" for="NGOCHARITYY${UNQID}">
												<input type="radio" id="NGOCHARITYY${UNQID}" name="NGOCHARITY" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"NGOCHARITY")){ %> disabled <% } %> value="YES"
												<c:if test="${FORMDATA['NGOCHARITY'] eq 'YES'}">checked="checked"</c:if>
												/>
												Yes
											</label>
											
											<label class="btn btn-outline btn-primary btn-sm radio-inline" for="NGOCHARITYN${UNQID}">
												<input type="radio" id="NGOCHARITYN${UNQID}"  name="NGOCHARITY" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"NGOCHARITY")){ %> disabled <% } %> value="NO"
												<c:if test="${FORMDATA['NGOCHARITY'] eq 'NO'}">checked="checked"</c:if>
												/>
												No
											</label>
										</td>
									</tr>
									<tr>
										<td colspan="2">Is cash intensive business customer</td>
										<td colspan="3">
											<label class="btn btn-outline btn-primary btn-sm radio-inline" for="CASHINTENSIVEY${UNQID}">
												<input type="radio" id="CASHINTENSIVEY${UNQID}" name="CASHINTENSIVE" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"CASHINTENSIVE")){ %> disabled <% } %> value="YES"
												<c:if test="${FORMDATA['CASHINTENSIVE'] eq 'YES'}">checked="checked"</c:if>
												/>
												Yes
											</label>
											
											<label class="btn btn-outline btn-primary btn-sm radio-inline" for="CASHINTENSIVEN${UNQID}">
												<input type="radio" id="CASHINTENSIVEN${UNQID}"  name="CASHINTENSIVE" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"CASHINTENSIVE")){ %> disabled <% } %> value="NO"
												<c:if test="${FORMDATA['CASHINTENSIVE'] eq 'NO'}">checked="checked"</c:if>
												/>
												No
											</label>
										</td>
									</tr>
									<tr>
										<td colspan="5"> <strong>For Customer with Current Account(s)</strong> </td>
									</tr>
									<tr>
										<td colspan="2">Expected transaction volume<font size = "4" color = "red"><b> * </b></font></td>
										<td colspan="3">
											<table class="table" style="margin-bottom: 0px;">
												<tr>
													<td width="50%">
														Amount<font size = "4" color = "red"><b> * </b></font>
													</td>
													<td width="50%">
														<input type="text" class="form-control input-sm" name="EXPECTEDTXNAMT" id="EXPECTEDTXNAMT${UNQID}" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"EXPECTEDTXNAMT")){ %> disabled <% } %> value="${FORMDATA['EXPECTEDTXNAMT']}">
													</td>
												</tr>
												<tr>
													<td width="50%">
														No of Transaction<font size = "4" color = "red"><b> * </b></font>
													</td>
													<td width="50%">
														<input type="text" class="form-control input-sm" name="EXPECTEDTXNCOUNT" id="EXPECTEDTXNCOUNT${UNQID}" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"EXPECTEDTXNCOUNT")){ %> disabled <% } %> value="${FORMDATA['EXPECTEDTXNCOUNT']}">
													</td>
												</tr>
												<tr>
													<td width="50%">
														Currency<font size = "4" color = "red"><b> * </b></font>
													</td>
													<td width="50%">
														<select class="form-control input-sm selectpicker" name="EXPECTEDTXNCURRENCY" id="EXPECTEDTXNCURRENCY${UNQID}" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"EXPECTEDTXNCURRENCY")){ %> disabled <% } %>>
															<option value="">Select One</option>												
															<c:forEach var="CURRENCYMASTER" items="${CURRENCYMASTER}">
																<option value="${CURRENCYMASTER['OPTIONVALUE']}" 
																<c:if test="${FORMDATA['EXPECTEDTXNCURRENCY'] eq CURRENCYMASTER['OPTIONVALUE']}">selected="selected"</c:if>>${CURRENCYMASTER['OPTIONNAME']}</option>
															</c:forEach>
														</select>
													</td>
												</tr>
												<tr>
													<td width="50%">
														Frequency<font size = "4" color = "red"><b> * </b></font>
													</td>
													<td width="50%">
														<label class="btn btn-outline btn-primary btn-sm radio-inline" for="EXPECTEDTXNFRQ_M${UNQID}">
														  <input type="radio" id="EXPECTEDTXNFRQ_M${UNQID}"  name="EXPECTEDTXNFRQ" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"EXPECTEDTXNFRQ")){ %> disabled <% } %> value="M"
														  <c:if test="${FORMDATA['EXPECTEDTXNFRQ'] eq 'M'}">checked="checked"</c:if>
														  />
														  	Per Month<font size = "4" color = "red"><b> * </b></font>
														</label>
														
														<label class="btn btn-outline btn-primary btn-sm radio-inline" for="EXPECTEDTXNFRQ_A${UNQID}">
														  <input type="radio" id="EXPECTEDTXNFRQ_A${UNQID}"  name="EXPECTEDTXNFRQ" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"EXPECTEDTXNFRQ")){ %> disabled <% } %> value="A"
														  <c:if test="${FORMDATA['EXPECTEDTXNFRQ'] eq 'A'}">checked="checked"</c:if>
														  />
														  	Per Annum<font size = "4" color = "red"><b> * </b></font>
														</label>
													</td>
												</tr>
											</table>
										</td>
									</tr>
									<c:if test="${(FORMDATA['STATUS'] eq 'BPA-P' && CURRENTROLE eq 'ROLE_BPAMAKER') || (FORMDATA['STATUS'] eq 'BPD-P' && CURRENTROLE eq 'ROLE_BPDMAKER')}">
										<tr>
											<td colspan="5" style="text-align: right;">
												<button type="button" class="btn btn-success btn-sm saveDraftCDDForm" id="saveDraftCDDForm2${UNQID}">Save Draft</button>
												<button type="button" class="btn btn-success btn-sm saveCDDForm" id="saveCDDForm2${UNQID}">Save</button>
											</td>
										</tr>
									</c:if>
									<tr>
										<td colspan="5">
											<strong>Customer Contact Record</strong>
										</td>
									</tr>
									<tr>
										<td>Date of contact with customer representative</td>
										<td>
											<input type="text" class="form-control input-sm" name="CUSTCONTACTDATE" id="CUSTCONTACTDATE${UNQID}" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"CUSTCONTACTDATE")){ %> disabled <% } %> value="${FORMDATA['CUSTCONTACTDATE']}">
										</td>
										<td>&nbsp;</td>
										<td>Method<br/>(e.g. Phone Call, Email, Site Visit, etc.)</td>
										<td>
											<input type="text" class="form-control input-sm" name="CUSTCONTACTMETHOD" id="CUSTCONTACTMETHOD${UNQID}" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"CUSTCONTACTMETHOD")){ %> disabled <% } %> value="${FORMDATA['CUSTCONTACTMETHOD']}">
										</td>
									</tr>
									<tr>
										<td>Name of Customer Representative contacted</td>
										<td>
											<input type="text" class="form-control input-sm" name="CUSTCONTACTNAME" id="CUSTCONTACTNAME${UNQID}" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"CUSTCONTACTNAME")){ %> disabled <% } %> value="${FORMDATA['CUSTCONTACTNAME']}">
										</td>
										<td>&nbsp;</td>
										<td>Position of Customer Representative contacted</td>
										<td>
											<input type="text" class="form-control input-sm" name="CUSTCONTACTPOSITION" id="CUSTCONTACTPOSITION${UNQID}" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"CUSTCONTACTPOSITION")){ %> disabled <% } %> value="${FORMDATA['CUSTCONTACTPOSITION']}">
										</td>
									</tr>
								</tbody>
							</table>
							<table class="table table-bordered table-striped" style="margin-bottom: 0px;">
								<tbody>
									<tr style="background-color: #BBB;">
										<td colspan="4"> <strong>Beneficial Owners</strong><font size = "4" color = "red"><b> * </b></font> </td>
										<td colspan="1" style="text-align: center;">
											<c:if test="${(FORMDATA['STATUS'] eq 'BPA-P' && CURRENTROLE eq 'ROLE_BPAMAKER') || (FORMDATA['STATUS'] eq 'BPD-P' && CURRENTROLE eq 'ROLE_BPDMAKER')}">
												<% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"ADDBENEFICIALOWNERS")){ %> 
												<button type="button" class="btn btn-primary btn-xs" id="addBeneficialOwners${UNQID}" disabled>Add Beneficial Owners</button>
												<% } else { %>
												<button type="button" class="btn btn-primary btn-xs cddModifyButton" id="addBeneficialOwners${UNQID}">Add Beneficial Owners</button>
												<% } %>
											</c:if>
											<button type="button" class="btn btn-success btn-xs" id="uploadAlertsRatingMapping${UNQID}" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"UPLOADALERTSRATINGMAPPING")){ %> disabled <% } %>>Upload / View Beneficial Owners Structure</button>
											
										</td>
									</tr>
									<tr>
										<td colspan="5" id="beneficialOwnerDetails${UNQID}">
											<table class="table table-bordered table-striped" style="margin-bottom: 0px;">
												<thead>
													<th>Name</th>
													<th>Effective Shareholding</th>
													<th>Nationality</th>
													<th>Date of Birth</th>
													<th>Match?</th>
													<th>List Name</th>
													<th>Action</th>
												</thead>
												<tbody>
													<c:choose>
														<c:when test="${f:length(BENEFICIALOWNER) > 0}">
															<c:forEach var="BENEFICIALOWNER" items="${BENEFICIALOWNER}">
																<tr>
																	<td width="15%" style="cursor: pointer; text-decoration: underline; color: blue;" onclick="viewDetails('BENEFICIALOWNER','${BENEFICIALOWNER['COMPASSREFNO']}','${BENEFICIALOWNER['LINENO']}')" >${BENEFICIALOWNER['NAME']}</td>
																	<td width="15%">${BENEFICIALOWNER['EFFECTIVESHAREHOLDING']}</td>
																	<td width="10%">${BENEFICIALOWNER['NATIONALITY']}</td>
																	<td width="10%">${BENEFICIALOWNER['DATEOFBIRTH']}</td>
																	<td width="15%" class="match">
																		<select class="form-control input-sm selectpicker">
																			<option value="N" <c:if test="${BENEFICIALOWNER['SANCTIONLISTMATCH'] eq 'N'}">selected</c:if> >No</option>
																			<option value="Y" <c:if test="${BENEFICIALOWNER['SANCTIONLISTMATCH'] eq 'Y'}">selected</c:if>>Yes</option>
																		</select>
																	</td>
																	<td width="15%" class="listname">
																		<select class="form-control input-sm selectpicker" multiple>
																			<option value="">None</option>
																			<option value="DJ" <c:if test="${f:contains(BENEFICIALOWNER['SANCTIONLISTNAME'], 'DJ')}">selected</c:if>>Dowjones</option>
																			<option value="RBI" <c:if test="${f:contains(BENEFICIALOWNER['SANCTIONLISTNAME'], 'RBI')}">selected</c:if>>RBI Defaulter</option>
																			<option value="EXP" <c:if test="${f:contains(BENEFICIALOWNER['SANCTIONLISTNAME'], 'EXP')}">selected</c:if>>Exporter List</option>
																			<option value="FIU" <c:if test="${f:contains(BENEFICIALOWNER['SANCTIONLISTNAME'], 'FIU')}">selected</c:if>>Local FIU Exception</option>
																			<option value="OFC" <c:if test="${f:contains(BENEFICIALOWNER['SANCTIONLISTNAME'], 'OFC')}">selected</c:if>>OFAC SDN</option>
																			<option value="UNC" <c:if test="${f:contains(BENEFICIALOWNER['SANCTIONLISTNAME'], 'UNC')}">selected</c:if>>UN Consolidated</option>
																			<option value="CLF" <c:if test="${f:contains(BENEFICIALOWNER['SANCTIONLISTNAME'], 'CLF')}">selected</c:if>>CLAF List</option>
																			<option value="CUL" <c:if test="${f:contains(BENEFICIALOWNER['SANCTIONLISTNAME'], 'CUL')}">selected</c:if>>Caution List</option>
																			<option value="CNS" <c:if test="${f:contains(BENEFICIALOWNER['SANCTIONLISTNAME'], 'CNS')}">selected</c:if>>Cibil Non Suit Filed</option>
																			<option value="CSF" <c:if test="${f:contains(BENEFICIALOWNER['SANCTIONLISTNAME'], 'CSF')}">selected</c:if>>Cibil Suit Filed</option>
																			<option value="CLS" <c:if test="${f:contains(BENEFICIALOWNER['SANCTIONLISTNAME'], 'CLS')}">selected</c:if>>High Risk Countries List</option>
																			<option value="HBL" <c:if test="${f:contains(BENEFICIALOWNER['SANCTIONLISTNAME'], 'HBL')}">selected</c:if>>HO Bad Guy List</option>
																			<option value="UAL" <c:if test="${f:contains(BENEFICIALOWNER['SANCTIONLISTNAME'], 'UAL')}">selected</c:if>>UN Alquaida List</option>
																			<option value="UTL" <c:if test="${f:contains(BENEFICIALOWNER['SANCTIONLISTNAME'], 'UTL')}">selected</c:if>>UN Taliban List</option>
																		</select>
																	</td>
																	<td width="20%">
																		<!-- <button type="button" class="btn btn-primary btn-xs" onclick="screen(this)">Screen</button>-->
																		<c:choose>
																			<c:when test="${(CURRENTROLE eq 'ROLE_BPDMAKER')}">
																				<button type="button" class="btn btn-primary btn-xs" onclick="screen(this, 'BENEFICIALOWNER','${BENEFICIALOWNER['LINENO']}')">Screen</button>
																				<button type="button" class="btn btn-primary btn-xs" onclick="screened(this,'BENEFICIALOWNER','${BENEFICIALOWNER['SCREENINGREFERENCENO']}')">View Screened Matches</button>
																			</c:when>
																			<c:otherwise>
																				<button type="button" class="btn btn-primary btn-xs" onclick="screened(this,'BENEFICIALOWNER','${BENEFICIALOWNER['SCREENINGREFERENCENO']}')">View Screened Matches</button>
																			</c:otherwise>
																		</c:choose>
																		<c:if test="${(FORMDATA['STATUS'] eq 'BPA-P' && CURRENTROLE eq 'ROLE_BPAMAKER') || (FORMDATA['STATUS'] eq 'BPD-P' && CURRENTROLE eq 'ROLE_BPDMAKER')}">
																			<button type="button" class="btn btn-success btn-xs cddModifyButton" onclick="updateScreeningMatch(this, 'BENEFICIALOWNER','${BENEFICIALOWNER['COMPASSREFNO']}','${BENEFICIALOWNER['LINENO']}')">Update</button>
																			<button type="button" class="btn btn-danger btn-xs cddModifyButton"  onclick="removeEntity('BENEFICIALOWNER','${BENEFICIALOWNER['COMPASSREFNO']}','${BENEFICIALOWNER['LINENO']}')">Remove</button>
																		</c:if>
																	</td>
																</tr>
															</c:forEach>
														</c:when>
														<c:otherwise>
															<tr>
																<td colspan="7"><center>No Beneficial Owner Added</center></td>
															</tr>
														</c:otherwise>
													</c:choose>		
												</tbody>
											</table>
										</td>
									</tr>
									<tr style="background-color: #BBB;">
										<td colspan="4"> <strong>Directors</strong><font size = "4" color = "red"><b> * </b></font> </td>
										<td colspan="1" style="text-align: center;">
											<c:if test="${(FORMDATA['STATUS'] eq 'BPA-P' && CURRENTROLE eq 'ROLE_BPAMAKER') || (FORMDATA['STATUS'] eq 'BPD-P' && CURRENTROLE eq 'ROLE_BPDMAKER')}">
												<% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"ADDDIRECTORS")){ %> 
												<button type="button" class="btn btn-primary btn-xs" id="addDirectors${UNQID}" disabled>Add Director</button>
												<% } else { %>
												<button type="button" class="btn btn-primary btn-xs cddModifyButton" id="addDirectors${UNQID}">Add Director</button>
												<% } %>
											</c:if>
										</td>
									</tr>
									<tr>
										<td colspan="5" id="directorsDetails${UNQID}">
											<table class="table table-bordered table-striped" style="margin-bottom: 0px;">
												<thead>
													<th>Name</th>
													<th>Date of Birth</th>
													<th>Match?</th>
													<th>List Name</th>
													<th>Action</th>
												</thead>
												<tbody>
													<c:choose>
														<c:when test="${f:length(DIRECTORS) > 0}">
															<c:forEach var="DIRECTORS" items="${DIRECTORS}">
																<tr>
																	<td width="15%" style="cursor: pointer; text-decoration: underline; color: blue;" onclick="viewDetails('DIRECTOR','${DIRECTORS['COMPASSREFNO']}','${DIRECTORS['LINENO']}')" >${DIRECTORS['NAME']}</td>
																	<td width="10%">${DIRECTORS['DATEOFBIRTH']}</td>
																	<td width="15%" class="match">
																		<select class="form-control input-sm selectpicker">
																			<option value="N" <c:if test="${DIRECTORS['SANCTIONLISTMATCH'] eq 'N'}">selected</c:if> >No</option>
																			<option value="Y" <c:if test="${DIRECTORS['SANCTIONLISTMATCH'] eq 'Y'}">selected</c:if>>Yes</option>
																		</select>
																	</td>
																	<td width="15%" class="listname">
																		<select class="form-control input-sm selectpicker" multiple>
																			<option value="">None</option>
																			<option value="DJ" <c:if test="${f:contains(DIRECTORS['SANCTIONLISTNAME'], 'DJ')}">selected</c:if>>Dowjones</option>
																			<option value="RBI" <c:if test="${f:contains(DIRECTORS['SANCTIONLISTNAME'], 'RBI')}">selected</c:if>>RBI Defaulter</option>
																			<option value="EXP" <c:if test="${f:contains(DIRECTORS['SANCTIONLISTNAME'], 'EXP')}">selected</c:if>>Exporter List</option>
																			<option value="FIU" <c:if test="${f:contains(DIRECTORS['SANCTIONLISTNAME'], 'FIU')}">selected</c:if>>Local FIU Exception</option>
																			<option value="OFC" <c:if test="${f:contains(DIRECTORS['SANCTIONLISTNAME'], 'OFC')}">selected</c:if>>OFAC SDN</option>
																			<option value="UNC" <c:if test="${f:contains(DIRECTORS['SANCTIONLISTNAME'], 'UNC')}">selected</c:if>>UN Consolidated</option>
																			<option value="CLF" <c:if test="${f:contains(DIRECTORS['SANCTIONLISTNAME'], 'CLF')}">selected</c:if>>CLAF List</option>
																			<option value="CUL" <c:if test="${f:contains(DIRECTORS['SANCTIONLISTNAME'], 'CUL')}">selected</c:if>>Caution List</option>
																			<option value="CNS" <c:if test="${f:contains(DIRECTORS['SANCTIONLISTNAME'], 'CNS')}">selected</c:if>>Cibil Non Suit Filed</option>
																			<option value="CSF" <c:if test="${f:contains(DIRECTORS['SANCTIONLISTNAME'], 'CSF')}">selected</c:if>>Cibil Suit Filed</option>
																			<option value="CLS" <c:if test="${f:contains(DIRECTORS['SANCTIONLISTNAME'], 'CLS')}">selected</c:if>>High Risk Countries List</option>
																			<option value="HBL" <c:if test="${f:contains(DIRECTORS['SANCTIONLISTNAME'], 'HBL')}">selected</c:if>>HO Bad Guy List</option>
																			<option value="UAL" <c:if test="${f:contains(DIRECTORS['SANCTIONLISTNAME'], 'UAL')}">selected</c:if>>UN Alquaida List</option>
																			<option value="UTL" <c:if test="${f:contains(DIRECTORS['SANCTIONLISTNAME'], 'UTL')}">selected</c:if>>UN Taliban List</option>
																		</select>
																	</td>
																	<td width="20%">
																		<!-- <button type="button" class="btn btn-primary btn-xs" onclick="screen(this)">Screen</button>-->
																		<c:choose>
																			<c:when test="${(CURRENTROLE eq 'ROLE_BPAMAKER')}">
																				<button type="button" class="btn btn-primary btn-xs" onclick="screen(this, 'DIRECTOR','${DIRECTORS['LINENO']}')">Screen</button>
																				<button type="button" class="btn btn-primary btn-xs" onclick="screened(this,'DIRECTOR','${DIRECTORS['SCREENINGREFERENCENO']}')">View Screened Matches</button>
																			</c:when>
																			<c:otherwise>
																				<button type="button" class="btn btn-primary btn-xs" onclick="screened(this,'DIRECTOR','${DIRECTORS['SCREENINGREFERENCENO']}')">View Screened Matches</button>
																			</c:otherwise>
																		</c:choose>
																		<c:if test="${(FORMDATA['STATUS'] eq 'BPA-P' && CURRENTROLE eq 'ROLE_BPAMAKER') || (FORMDATA['STATUS'] eq 'BPD-P' && CURRENTROLE eq 'ROLE_BPDMAKER')}">
																			<button type="button" class="btn btn-success btn-xs cddModifyButton" onclick="updateScreeningMatch(this, 'DIRECTOR','${DIRECTORS['COMPASSREFNO']}','${DIRECTORS['LINENO']}')">Update</button>
																			<button type="button" class="btn btn-danger btn-xs cddModifyButton"  onclick="removeEntity('DIRECTOR','${DIRECTORS['COMPASSREFNO']}','${DIRECTORS['LINENO']}')">Remove</button>
																		</c:if>
																	</td>
																</tr>
															</c:forEach>
														</c:when>
														<c:otherwise>
															<tr>
																<td colspan="5"><center>No Director Added</center></td>
															</tr>
														</c:otherwise>
													</c:choose>		
												</tbody>
											</table>
										</td>
									</tr>
									<tr style="background-color: #BBB;">
										<td colspan="4"> <strong>Authorized Signatories </strong><font size = "4" color = "red"><b> * </b></font> </td>
										<td colspan="1" style="text-align: center;">
											<c:if test="${(FORMDATA['STATUS'] eq 'BPA-P' && CURRENTROLE eq 'ROLE_BPAMAKER') || (FORMDATA['STATUS'] eq 'BPD-P' && CURRENTROLE eq 'ROLE_BPDMAKER')}">
												<% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"ADDAUTHORIZEDSIGNATORY")){ %> 
												<button type="button" class="btn btn-primary btn-xs" id="addAuthorizedSignatory${UNQID}" disabled>Add Authorized Signatory</button>
												<% } else { %>
												<button type="button" class="btn btn-primary btn-xs cddModifyButton" id="addAuthorizedSignatory${UNQID}">Add Authorized Signatory</button>
												<% } %>
											</c:if>
										</td>
									</tr>
									<tr>
										<td colspan="5" id="authorizedSignatoriesDetails${UNQID}">
											<table class="table table-bordered table-striped" style="margin-bottom: 0px;">
												<thead>
													<th>Name</th>
													<th>Date of Birth</th>
													<th>Match?</th>
													<th>List Name</th>
													<th>Action</th>
												</thead>
												<tbody>
													<c:choose>
														<c:when test="${f:length(AUTHORIZEDSIGNATORIES) > 0}">
															<c:forEach var="AUTHORIZEDSIGNATORIES" items="${AUTHORIZEDSIGNATORIES}">
																<tr>
																	<td width="15%" style="cursor: pointer; text-decoration: underline; color: blue;" onclick="viewDetails('AUTHORIZEDSIGNATORY','${AUTHORIZEDSIGNATORIES['COMPASSREFNO']}','${AUTHORIZEDSIGNATORIES['LINENO']}')" >${AUTHORIZEDSIGNATORIES['NAME']}</td>
																	<td width="10%">${AUTHORIZEDSIGNATORIES['DATEOFBIRTH']}</td>
																	<td width="15%" class="match">
																		<select class="form-control input-sm selectpicker">
																			<option value="N" <c:if test="${AUTHORIZEDSIGNATORIES['SANCTIONLISTMATCH'] eq 'N'}">selected</c:if> >No</option>
																			<option value="Y" <c:if test="${AUTHORIZEDSIGNATORIES['SANCTIONLISTMATCH'] eq 'Y'}">selected</c:if>>Yes</option>
																		</select>
																	</td>
																	<td width="15%" class="listname">
																		<select class="form-control input-sm selectpicker" multiple>
																			<option value="">None</option>
																			<option value="DJ" <c:if test="${f:contains(AUTHORIZEDSIGNATORIES['SANCTIONLISTNAME'], 'DJ')}">selected</c:if>>Dowjones</option>
																			<option value="RBI" <c:if test="${f:contains(AUTHORIZEDSIGNATORIES['SANCTIONLISTNAME'], 'RBI')}">selected</c:if>>RBI Defaulter</option>
																			<option value="EXP" <c:if test="${f:contains(AUTHORIZEDSIGNATORIES['SANCTIONLISTNAME'], 'EXP')}">selected</c:if>>Exporter List</option>
																			<option value="FIU" <c:if test="${f:contains(AUTHORIZEDSIGNATORIES['SANCTIONLISTNAME'], 'FIU')}">selected</c:if>>Local FIU Exception</option>
																			<option value="OFC" <c:if test="${f:contains(AUTHORIZEDSIGNATORIES['SANCTIONLISTNAME'], 'OFC')}">selected</c:if>>OFAC SDN</option>
																			<option value="UNC" <c:if test="${f:contains(AUTHORIZEDSIGNATORIES['SANCTIONLISTNAME'], 'UNC')}">selected</c:if>>UN Consolidated</option>
																			<option value="CLF" <c:if test="${f:contains(AUTHORIZEDSIGNATORIES['SANCTIONLISTNAME'], 'CLF')}">selected</c:if>>CLAF List</option>
																			<option value="CUL" <c:if test="${f:contains(AUTHORIZEDSIGNATORIES['SANCTIONLISTNAME'], 'CUL')}">selected</c:if>>Caution List</option>
																			<option value="CNS" <c:if test="${f:contains(AUTHORIZEDSIGNATORIES['SANCTIONLISTNAME'], 'CNS')}">selected</c:if>>Cibil Non Suit Filed</option>
																			<option value="CSF" <c:if test="${f:contains(AUTHORIZEDSIGNATORIES['SANCTIONLISTNAME'], 'CSF')}">selected</c:if>>Cibil Suit Filed</option>
																			<option value="CLS" <c:if test="${f:contains(AUTHORIZEDSIGNATORIES['SANCTIONLISTNAME'], 'CLS')}">selected</c:if>>High Risk Countries List</option>
																			<option value="HBL" <c:if test="${f:contains(AUTHORIZEDSIGNATORIES['SANCTIONLISTNAME'], 'HBL')}">selected</c:if>>HO Bad Guy List</option>
																			<option value="UAL" <c:if test="${f:contains(AUTHORIZEDSIGNATORIES['SANCTIONLISTNAME'], 'UAL')}">selected</c:if>>UN Alquaida List</option>
																			<option value="UTL" <c:if test="${f:contains(AUTHORIZEDSIGNATORIES['SANCTIONLISTNAME'], 'UTL')}">selected</c:if>>UN Taliban List</option>
																		</select>
																	</td>
																	<td width="20%">
																		<!-- <button type="button" class="btn btn-primary btn-xs" onclick="screen(this)">Screen</button> -->
																		<c:choose>
																			<c:when test="${(CURRENTROLE eq 'ROLE_BPAMAKER')}">
																				<button type="button" class="btn btn-primary btn-xs" onclick="screen(this, 'AUTHORIZEDSIGNATORY','${AUTHORIZEDSIGNATORIES['LINENO']}')">Screen</button>
																				<button type="button" class="btn btn-primary btn-xs" onclick="screened(this,'AUTHORIZEDSIGNATORY','${AUTHORIZEDSIGNATORIES['SCREENINGREFERENCENO']}')">View Screened Matches</button>
																			</c:when>
																			<c:otherwise>
																				<button type="button" class="btn btn-primary btn-xs" onclick="screened(this,'AUTHORIZEDSIGNATORY','${AUTHORIZEDSIGNATORIES['SCREENINGREFERENCENO']}')">View Screened Matches</button>
																			</c:otherwise>
																		</c:choose>
																		<c:if test="${(FORMDATA['STATUS'] eq 'BPA-P' && CURRENTROLE eq 'ROLE_BPAMAKER') || (FORMDATA['STATUS'] eq 'BPD-P' && CURRENTROLE eq 'ROLE_BPDMAKER')}">
																			<button type="button" class="btn btn-success btn-xs cddModifyButton" onclick="updateScreeningMatch(this, 'AUTHORIZEDSIGNATORY','${AUTHORIZEDSIGNATORIES['COMPASSREFNO']}','${AUTHORIZEDSIGNATORIES['LINENO']}')">Update</button>
																			<button type="button" class="btn btn-danger btn-xs cddModifyButton"  onclick="removeEntity('AUTHORIZEDSIGNATORY','${AUTHORIZEDSIGNATORIES['COMPASSREFNO']}','${AUTHORIZEDSIGNATORIES['LINENO']}')">Remove</button>
																		</c:if>
																	</td>
																</tr>
															</c:forEach>
														</c:when>
														<c:otherwise>
															<tr>
																<td colspan="5"><center>No Authorized Signatory Added</center></td>
															</tr>
														</c:otherwise>
													</c:choose>		
												</tbody>
											</table>
										</td>
									</tr>
									<tr style="background-color: #BBB;">
										<td colspan="4"> <strong>Third Parties or Intermediaries</strong> </td>
										<td colspan="1" style="text-align: center;">
											<c:if test="${(FORMDATA['STATUS'] eq 'BPA-P' && CURRENTROLE eq 'ROLE_BPAMAKER') || (FORMDATA['STATUS'] eq 'BPD-P' && CURRENTROLE eq 'ROLE_BPDMAKER')}">
												<% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"ADDINTERMEDIARIES")){ %> 
												<button type="button" class="btn btn-primary btn-xs" id="addIntermediaries${UNQID}" disabled>Add Intermediary</button>
												<% } else { %>
												<button type="button" class="btn btn-primary btn-xs cddModifyButton" id="addIntermediaries${UNQID}">Add Intermediary</button>
												<% } %>
											</c:if>
										</td>
									</tr>
									<tr>
										<td colspan="5">
											Note : For Accounts Referred by Intermediaries or where Power of Attorney (POA) is applicable (Please skip if not aplicable)
											<br/>
											<table class="table" style="margin-bottom: 0px;">
												<tr>
													<td width="17%">
														<label class="btn btn-outline btn-primary btn-sm radio-inline" for="INTERMEDIARIESTYPE_AGNT${UNQID}">
														  <input type="radio" id="INTERMEDIARIESTYPE_AGNT${UNQID}"  name="INTERMEDIARIESTYPE" value="BROKER"
														  <c:if test="${FORMDATA['INTERMEDIARIESTYPE'] eq 'BROKER'}">checked="checked"</c:if>
														  />
														  	Broker / Agent
														</label>
													</td>
													<td width="17%">
														<label class="btn btn-outline btn-primary btn-sm radio-inline" for="INTERMEDIARIESTYPE_POA${UNQID}">
														  <input type="radio" id="INTERMEDIARIESTYPE_POA${UNQID}"  name="INTERMEDIARIESTYPE" value="POA"
														  <c:if test="${FORMDATA['INTERMEDIARIESTYPE'] eq 'POA'}">checked="checked"</c:if>
														  />
														  	Power of Attorney (POA)
														</label>
													</td>
													<td width="17%">
														<label class="btn btn-outline btn-primary btn-sm radio-inline" for="INTERMEDIARIESTYPE_INT${UNQID}">
														  <input type="radio" id="INTERMEDIARIESTYPE_INT${UNQID}"  name="INTERMEDIARIESTYPE" value="INT"
														  <c:if test="${FORMDATA['INTERMEDIARIESTYPE'] eq 'INT'}">checked="checked"</c:if>
														  />
														  	Intermediary
														</label>
													</td>
													<td width="17%">
														<label class="btn btn-outline btn-primary btn-sm radio-inline" for="INTERMEDIARIESTYPE_NA${UNQID}">
														  <input type="radio" id="INTERMEDIARIESTYPE_NA${UNQID}"  name="INTERMEDIARIESTYPE" value="NA"
														  <c:if test="${FORMDATA['INTERMEDIARIESTYPE'] eq 'NA'}">checked="checked"</c:if>
														  />
														  	Not Available
														</label>
													</td>
													<td width="17%">
														<label class="btn btn-outline btn-primary btn-sm radio-inline" for="INTERMEDIARIESTYPE_OTH${UNQID}">
														  <input type="radio" id="INTERMEDIARIESTYPE_OTH${UNQID}"  name="INTERMEDIARIESTYPE" value="OTH"
														  <c:if test="${FORMDATA['INTERMEDIARIESTYPE'] eq 'OTH'}">checked="checked"</c:if>
														  />
														  	Other
														</label>
													</td>
													<td width="15%">
														<input type="text" class="form-control input-sm" name="INTERMEDIARIESTYPEOTHER" id="INTERMEDIARIESTYPEOTHER${UNQID}" value="${FORMDATA['INTERMEDIARIESTYPEOTHER']}">
													</td>
												</tr>
											</table>
										</td>
									</tr>
									<tr>
										<td colspan="5" id="intermediaryDetails${UNQID}">
											<table class="table table-bordered table-striped" style="margin-bottom: 0px;">
												<thead>
													<th>Name</th>
													<th>Nationality</th>
													<th>Match?</th>
													<th>List Name</th>
													<th>Action</th>
												</thead>
												<tbody>
													<c:choose>
														<c:when test="${f:length(INTERMEDIARIES) > 0}">
															<c:forEach var="INTERMEDIARIES" items="${INTERMEDIARIES}">
																<tr>
																	<td width="20%" style="cursor: pointer; text-decoration: underline; color: blue;" onclick="viewDetails('INTERMEDIARY','${INTERMEDIARIES['COMPASSREFNO']}','${INTERMEDIARIES['LINENO']}')" >${INTERMEDIARIES['INTERMEDIARYNAME']}</td>
																	<td width="20%">${INTERMEDIARIES['INTERMEDIARYNATIONALITY']}</td>
																	<td width="20%" class="match">
																		<select class="form-control input-sm selectpicker">
																			<option value="N" <c:if test="${INTERMEDIARIES['SANCTIONLISTMATCH'] eq 'N'}">selected</c:if> >No</option>
																			<option value="Y" <c:if test="${INTERMEDIARIES['SANCTIONLISTMATCH'] eq 'Y'}">selected</c:if>>Yes</option>
																		</select>
																	</td>
																	<td width="20%" class="listname">
																		<select class="form-control input-sm selectpicker" multiple>
																			<option value="">None</option>
																			<option value="DJ" <c:if test="${f:contains(INTERMEDIARIES['SANCTIONLISTNAME'], 'DJ')}">selected</c:if>>Dowjones</option>
																			<option value="RBI" <c:if test="${f:contains(INTERMEDIARIES['SANCTIONLISTNAME'], 'RBI')}">selected</c:if>>RBI Defaulter</option>
																			<option value="EXP" <c:if test="${f:contains(INTERMEDIARIES['SANCTIONLISTNAME'], 'EXP')}">selected</c:if>>Exporter List</option>
																			<option value="FIU" <c:if test="${f:contains(INTERMEDIARIES['SANCTIONLISTNAME'], 'FIU')}">selected</c:if>>Local FIU Exception</option>
																			<option value="OFC" <c:if test="${f:contains(INTERMEDIARIES['SANCTIONLISTNAME'], 'OFC')}">selected</c:if>>OFAC SDN</option>
																			<option value="UNC" <c:if test="${f:contains(INTERMEDIARIES['SANCTIONLISTNAME'], 'UNC')}">selected</c:if>>UN Consolidated</option>
																			<option value="CLF" <c:if test="${f:contains(INTERMEDIARIES['SANCTIONLISTNAME'], 'CLF')}">selected</c:if>>CLAF List</option>
																			<option value="CUL" <c:if test="${f:contains(INTERMEDIARIES['SANCTIONLISTNAME'], 'CUL')}">selected</c:if>>Caution List</option>
																			<option value="CNS" <c:if test="${f:contains(INTERMEDIARIES['SANCTIONLISTNAME'], 'CNS')}">selected</c:if>>Cibil Non Suit Filed</option>
																			<option value="CSF" <c:if test="${f:contains(INTERMEDIARIES['SANCTIONLISTNAME'], 'CSF')}">selected</c:if>>Cibil Suit Filed</option>
																			<option value="CLS" <c:if test="${f:contains(INTERMEDIARIES['SANCTIONLISTNAME'], 'CLS')}">selected</c:if>>High Risk Countries List</option>
																			<option value="HBL" <c:if test="${f:contains(INTERMEDIARIES['SANCTIONLISTNAME'], 'HBL')}">selected</c:if>>HO Bad Guy List</option>
																			<option value="UAL" <c:if test="${f:contains(INTERMEDIARIES['SANCTIONLISTNAME'], 'UAL')}">selected</c:if>>UN Alquaida List</option>
																			<option value="UTL" <c:if test="${f:contains(INTERMEDIARIES['SANCTIONLISTNAME'], 'UTL')}">selected</c:if>>UN Taliban List</option>
																		</select>
																	</td>
																	<td width="20%">
																		<!-- <button type="button" class="btn btn-primary btn-xs" onclick="screen(this)">Screen</button>-->
																		<c:choose>
																			<c:when test="${(CURRENTROLE eq 'ROLE_BPAMAKER')}">
																				<button type="button" class="btn btn-primary btn-xs" onclick="screen(this, 'INTERMEDIARY','${INTERMEDIARIES['LINENO']}')">Screen</button>
																				<button type="button" class="btn btn-primary btn-xs" onclick="screened(this,'INTERMEDIARY','${INTERMEDIARIES['SCREENINGREFERENCENO']}')">View Screened Matches</button>
																			</c:when>
																			<c:otherwise>
																				<button type="button" class="btn btn-primary btn-xs" onclick="screened(this,'INTERMEDIARY','${INTERMEDIARIES['SCREENINGREFERENCENO']}')">View Screened Matches</button>
																			</c:otherwise>
																		</c:choose>
																		<c:if test="${(FORMDATA['STATUS'] eq 'BPA-P' && CURRENTROLE eq 'ROLE_BPAMAKER') || (FORMDATA['STATUS'] eq 'BPD-P' && CURRENTROLE eq 'ROLE_BPDMAKER')}">
																			<button type="button" class="btn btn-success btn-xs cddModifyButton" onclick="updateScreeningMatch(this, 'INTERMEDIARY','${INTERMEDIARIES['COMPASSREFNO']}','${INTERMEDIARIES['LINENO']}')">Update</button>
																			<button type="button" class="btn btn-danger btn-xs cddModifyButton"  onclick="removeEntity('INTERMEDIARY','${INTERMEDIARIES['COMPASSREFNO']}','${INTERMEDIARIES['LINENO']}')">Remove</button>
																		</c:if>
																	</td>
																</tr>
															</c:forEach>
														</c:when>
														<c:otherwise>
															<tr>
																<td colspan="5"><center>No Intermediary Added</center></td>
															</tr>
														</c:otherwise>
													</c:choose>
												</tbody>
											</table>
										</td>
									</tr>
									<tr>
										<td colspan="5" style="text-align: right;">
											<c:if test="${(FORMDATA['STATUS'] eq 'BPA-P' && CURRENTROLE eq 'ROLE_BPAMAKER') || (FORMDATA['STATUS'] eq 'BPD-P' && CURRENTROLE eq 'ROLE_BPDMAKER')}">
											<button type="button" class="btn btn-success btn-sm saveDraftCDDForm" id="saveDraftCDDForm3${UNQID}">Save Draft</button>
											<button type="button" class="btn btn-success btn-sm saveCDDForm" id="saveCDDForm3${UNQID}">Save</button>
											</c:if>
											<button type="button" class="btn btn-warning btn-sm" id="moveToScreening${UNQID}">Screening >></button>
										</td>
									</tr>
								</tbody>
							</table>
							</form>
						</div>
						<jsp:include page="corpExisting_Part2.jsp" />
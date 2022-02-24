<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, com.quantumdataengines.app.compass.model.CDDDisabledFieldsMap"%>
<%@ include file="../../tags/tags.jsp"%>

<%
String CURRENTROLE = (String) request.getSession(false).getAttribute("CURRENTROLE");
String prefix = CURRENTROLE+"_IE_";
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
		
		$(".selectpicker").selectpicker();
		
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
			if(!($("#REVIEWPURPOSE1"+id).prop("checked")) && !($("#REVIEWPURPOSE2"+id).prop("checked")) && !($("#REVIEWPURPOSE3"+id).prop("checked")) && !($("#REVIEWPURPOSE4"+id).prop("checked"))){
				alert('Purpose of CDD review is a mandatory field.');
				return false;	
			}

			if(CURRENTROLE == 'ROLE_BPAMAKER' && cddFormStatus == 'BPA-P')
			if($("#CUSTOMERNAME"+id).val() == ''){
				alert('Full customer name is a mandatory field.');
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
			if(!($("#EXISTINGCUSTOMERY"+id).prop("checked")) && !($("#EXISTINGCUSTOMERN"+id).prop("checked"))){
				alert('Risk rating is a mandatory field.');
				return false;	
			}
			*/

			if(CURRENTROLE == 'ROLE_BPDMAKER' && cddFormStatus == 'BPD-P')			
			if($("#FACETOFACEINTRACTION"+id).val() == ''){
				alert('General information is a mandatory field.');
				return false;	
			}

			if(CURRENTROLE == 'ROLE_BPDMAKER' && cddFormStatus == 'BPD-P')
			if($("#REASONFORNOINTRACTION"+id).val() == ''){
				alert('General information reason is a mandatory field.');
				return false;	
			}

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
			if($("#PASSPORT"+id).val() == ''){
				alert('Passport no is a mandatory field.');
				return false;	
			}

			if(CURRENTROLE == 'ROLE_BPAMAKER' && cddFormStatus == 'BPA-P')
			if(!($("#EMBASSYCUSTOMERY"+id).prop("checked")) && !($("#EMBASSYCUSTOMERN"+id).prop("checked"))){
				alert('Embassy customer is a mandatory field.');
				return false;	
			}

			if(CURRENTROLE == 'ROLE_BPAMAKER' && cddFormStatus == 'BPA-P')
			if(!($("#NGOCUSTOMERY"+id).prop("checked")) && !($("#NGOCUSTOMERN"+id).prop("checked"))){
				alert('NGO customer is a mandatory field.');
				return false;	
			}

			if(CURRENTROLE == 'ROLE_BPAMAKER' && cddFormStatus == 'BPA-P')
			if(!($("#TRUSTCUSTOMERY"+id).prop("checked")) && !($("#TRUSTCUSTOMERN"+id).prop("checked"))){
				alert('Trust customer is a mandatory field.');
				return false;	
			}
			
			if(CURRENTROLE == 'ROLE_BPAMAKER' && cddFormStatus == 'BPA-P')
			if($("#DATEOFINCORPORATION"+id).val() == ''){
				alert('Date of birth is a mandatory field.');
				return false;	
			}

			if(CURRENTROLE == 'ROLE_BPDMAKER' && cddFormStatus == 'BPD-P')
			if(!($("#PRODUCTSERVICE_TD"+id).prop("checked")) && !($("#PRODUCTSERVICE_SA"+id).prop("checked")) && !($("#PRODUCTSERVICE_GR"+id).prop("checked")) && 
			   !($("#PRODUCTSERVICE_CA"+id).prop("checked")) && !($("#PRODUCTSERVICE_LN"+id).prop("checked")) && !($("#PRODUCTSERVICE_RE"+id).prop("checked")) && 
			   !($("#PRODUCTSERVICE_IB"+id).prop("checked")) && !($("#PRODUCTSERVICE_TF"+id).prop("checked")) && !($("#PRODUCTSERVICE_OT"+id).prop("checked")) ){
				alert('Type of product is a mandatory field.');
				return false;	
			}


			if(CURRENTROLE == 'ROLE_BPAMAKER' && cddFormStatus == 'BPA-P')
			if($("#OCCUPATION"+id).val() == ''){
				alert('Occupation is a mandatory field.');
				return false;	
			}

			if(CURRENTROLE == 'ROLE_BPAMAKER' && cddFormStatus == 'BPA-P')
			if($("#OTHEROCCUPATION"+id).val() == ''){
				alert('Other occupation is a mandatory field.');
				return false;	
			}

			if(CURRENTROLE == 'ROLE_BPDMAKER' && cddFormStatus == 'BPD-P')
			if($("#SOURCEOFFUND"+id).val() == ''){
				alert('Source of funds is a mandatory field.');
				return false;	
			}
			
			if(CURRENTROLE == 'ROLE_BPAMAKER' && cddFormStatus == 'BPA-P')
			if($("#DOMICILE"+id).val() == ''){
				alert('Country of residence is a mandatory field.');
				return false;	
			}

			if(CURRENTROLE == 'ROLE_BPAMAKER' && cddFormStatus == 'BPA-P')
			if($("#CITIZEN"+id).val() == ''){
				alert('Country of citizenship is a mandatory field.');
				return false;	
			}
			/*
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
			*/

			if(CURRENTROLE == 'ROLE_BPAMAKER' && cddFormStatus == 'BPA-P')
			if($("#NOMINEENAME"+id).val() == ''){
				alert('Nominee name is a mandatory field.');
				return false;	
			}

			if(CURRENTROLE == 'ROLE_BPAMAKER' && cddFormStatus == 'BPA-P')
			if($("#NOMINEEADDRESS"+id).val() == ''){
				alert('Nominee address is a mandatory field.');
				return false;	
			}

			if(CURRENTROLE == 'ROLE_BPAMAKER' && cddFormStatus == 'BPA-P')
			if($("#NOMINEEDOB"+id).val() == ''){
				alert('Nominee date of birth is a mandatory field.');
				return false;	
			}

			if(CURRENTROLE == 'ROLE_BPAMAKER' && cddFormStatus == 'BPA-P')
			if($("#NOMINEEAADHAR"+id).val() == ''){
				alert('Nominee AADHAR is a mandatory field.');
				return false;	
			}

			if(CURRENTROLE == 'ROLE_BPAMAKER' && cddFormStatus == 'BPA-P')
			if($("#RELATIONWITHPRIMARY"+id).val() == ''){
				alert('Nominee relation with primary is a mandatory field.');
				return false;	
			}

			if(CURRENTROLE == 'ROLE_BPAMAKER' && cddFormStatus == 'BPA-P')
			if($("#RELATIONWITHPRIMARYOTHER"+id).val() == ''){
				alert('Nominee relation with other is a mandatory field.');
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
		
		$("#addJointHolder"+id).click(function(){
			$("#compassMediumGenericModal").modal("show");
			$("#compassMediumGenericModal-title").html("Add Joint Holder");
			$("#compassMediumGenericModal-body").html("Loading...");
			$.ajax({
				url : "${pageContext.request.contextPath}/cddFormCommon/addJointHolder",
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

		$("#addNomineeDetail"+id).click(function(){
			$("#compassMediumGenericModal").modal("show");
			$("#compassMediumGenericModal-title").html("Add Nominee Detail");
			$("#compassMediumGenericModal-body").html("Loading...");
			$.ajax({
				url : "${pageContext.request.contextPath}/cddFormCommon/addNomineeDetail",
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
		
		$("#screenCustomerNames"+id).click(function(){
			var CUSTOMERNAMETOSCREEN = $("#CUSTOMERNAMETOSCREEN"+id).val();
			var CUSTOMERALIASNAMETOSCREEN = $("#CUSTOMERALIASNAMETOSCREEN"+id).val();
			if(CUSTOMERNAMETOSCREEN != ""){
				var fullData = "NAME1="+CUSTOMERNAMETOSCREEN+"&NAME2="+CUSTOMERALIASNAMETOSCREEN+"&NAME3=&NAME4=&NAME5=&DATEOFBIRTH=&PASSPORTNO=&PANNO=&ACCOUNTNO=&CUSTOMERID=&userCode=NA&BlackListCheck=Y&SelectedBlackListCheck=Y"+
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
						
			var fullData =  "CHANNELRISKRATING="+CHANNELRISKRATING+"&PRODUCTRISKRATING="+PRODUCTRISKRATING+
							"&GEOGRAPHICRISKRATING="+GEOGRAPHICRISKRATING+"&INDUSTRYTYPERISKRATING="+INDUSTRYTYPERISKRATING+
							"&TYPE=INDV";
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
	
	function refreshJointHolder(){
		var id = '${UNQID}';
		var COMPASSREFERENCENO = '${COMPASSREFERENCENO}';
		$("#compassMediumGenericModal").modal("hide");
		$("#jointHolderDetails"+id).html("Loading...");
		$.ajax({
			url : "${pageContext.request.contextPath}/cddFormCommon/getJointHolder",
			type : "POST",
			cache : false,
			data : "COMPASSREFERENCENO="+COMPASSREFERENCENO+"&UNQID="+id,
			success : function(res){
				$("#jointHolderDetails"+id).html(res);
			},
			error : function(){
				alert("Error while saving form");
			}
		});
	}

	function refreshNomineeDetail(){
		var id = '${UNQID}';
		var COMPASSREFERENCENO = '${COMPASSREFERENCENO}';
		$("#compassMediumGenericModal").modal("hide");
		$("#nomineeDetails"+id).html("Loading...");
		$.ajax({
			url : "${pageContext.request.contextPath}/cddFormCommon/getNomineeDetail",
			type : "POST",
			cache : false,
			data : "COMPASSREFERENCENO="+COMPASSREFERENCENO+"&UNQID="+id,
			success : function(res){
				$("#nomineeDetails"+id).html(res);
			},
			error : function(){
				alert("Error while saving form");
			}
		});
	}
	
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
	
	function updateScreeningMatch(elm, type, compassRefNo, lineNo){
		var match = $(elm).parent().parent().find("td.match").find("select").val();
		var list = $(elm).parent().parent().find("td.listname").find("select").val();
		var LINENO = '${FORMDATA['LINENO']}';
		
		if(match == "Y" && (list == "null" || list == null)){
			alert("Select list");
		}else{
			$.ajax({
				url : "${pageContext.request.contextPath}/cddFormCommon/updateScreeningMatch",
				type : "POST",
				cache : false,
				data : "COMPASSREFERENCENO="+compassRefNo+"&LINENO="+lineNo+"&TYPE="+type+"&MATCH="+match+"&LIST="+list+"&FORMLINENO="+LINENO,
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
		var LINENO = '${FORMDATA['LINENO']}';
		if(confirm("Are you sure?")){
			$.ajax({
				url : "${pageContext.request.contextPath}/cddFormCommon/removeEntity",
				type : "POST",
				cache : false,
				data : "COMPASSREFERENCENO="+compassRefNo+"&LINENO="+lineNo+"&TYPE="+type+"&FORMLINENO="+LINENO,
				success : function(res){
					alert(res);
					if(type == "JOINTHOLDER"){
						refreshJointHolder();
					}else if(type == "NOMINEEDETAIL"){
						refreshNomineeDetail();
					}else if(type == "INTERMEDIARY"){
						refreshIntermediaries();
					}else if(type == "PEP"){
						refreshPEP();
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
			fullData = "CDDFORMTYPE=INDIVIDUALEXISTING&COMPASSREFERENCENO="+COMPASSREFERENCENO+"&CDDNAMETYPE="+nameType+"&CDDNAMELINENO="+lineNo+"&NAME1="+CUSTOMERNAMETOSCREEN+"&NAME2="+CUSTOMERALIASNAMETOSCREEN+"&NAME3=&NAME4=&NAME5=&DATEOFBIRTH=&PASSPORTNO=&PANNO=&ACCOUNTNO=&CUSTOMERID=&userCode=NA&BlackListCheck=Y&SelectedBlackListCheck=Y"+
			   "&CustomerDataBaseCheck=Y&RejectedListCheck=Y&EmployeeDataBaseCheck=N";
		}
		else {
			fullData = "CDDFORMTYPE=INDIVIDUALEXISTING&COMPASSREFERENCENO="+COMPASSREFERENCENO+"&CDDNAMETYPE="+nameType+"&CDDNAMELINENO="+lineNo+"&NAME1="+name+"&NAME2=&NAME3=&NAME4=&NAME5=&DATEOFBIRTH=&PASSPORTNO=&PANNO=&ACCOUNTNO=&CUSTOMERID=&userCode=NA&BlackListCheck=Y&SelectedBlackListCheck=Y"+
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
			data : "COMPASSREFERENCENO="+COMPASSREFERENCENO+"&LINENO="+LINENO+"&TYPE=INVDEXISTING",
			success : function(res){
				$("#identificationForm").html(res);
			},
			error : function(){
				alert("Error while loading identification form page");
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
			data : "COMPASSREFERENCENO="+compassRefNo+"&LINENO="+lineNo+"&IDFORMTYPE="+entityType+"&FORMTYPE=INVDEXISTING&FORMLINENO="+formLineNo,
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
		} else if(type == "PRINCIPALCOUNTRY"){
			setMaximumRiskRating();
		}
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
			<h6 class="card-title pull-${dirL}">CDD Form for Existing Individual Customer For Compass ReferenceNo : ${COMPASSREFERENCENO}</h6>
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
											Full Name of Customer<font size = "4" color = "red"><b> * </b></font>
										</td>
										<td width="33%">
											<input type="text" autocomplete="off" class="form-control input-sm" name="CUSTOMERNAME" id="CUSTOMERNAME${UNQID}" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"CUSTOMERNAME")){ %> disabled <% } %> value="${FORMDATA['CUSTOMERNAME']}">
										</td>
										<td width="4%">&nbsp;</td>
										<td width="15%">
											Alias (if any)
										</td>
										<td width="33%">
											<input type="text"  autocomplete="off" class="form-control input-sm" name="CUSTOMERALIASNAME" id="CUSTOMERALIASNAME${UNQID}" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"CUSTOMERALIASNAME")){ %> disabled <% } %>  value="${FORMDATA['CUSTOMERALIASNAME']}">
										</td>
									</tr>
									<tr>
										<td width="15%">
											Customer ID<font size = "4" color = "red"><b> * </b></font>
										</td>
										<td colspan="4">
											<input type="text" class="form-control input-sm" name="CUSTOMERID" id="CUSTOMERID${UNQID}" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"CUSTOMERID")){ %> disabled <% } %> value="${FORMDATA['CUSTOMERID']}">
										</td>
									</tr>
									<tr>
										<td>Relationship Manager</td>
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
															<c:if test="${FORMDATA['REVIEWPURPOSE'] eq '1'}">checked="checked"</c:if>/>
															Regular Periodic CDD Review
														</label>
													</td>
													<td width="50%">
														<label class="btn btn-outline btn-primary btn-sm radio-inline" for="REVIEWPURPOSE2${UNQID}">
															<input type="radio" id="REVIEWPURPOSE2${UNQID}" name="REVIEWPURPOSE" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"REVIEWPURPOSE")){ %> disabled <% } %> value="2"
															<c:if test="${FORMDATA['REVIEWPURPOSE'] eq '2'}">checked="checked"</c:if>/>
															Knowledge of adverse news / negative information on Customer
														</label>
													</td>
												</tr>
												<tr>
													<td width="50%">
														<label class="btn btn-outline btn-primary btn-sm radio-inline" for="REVIEWPURPOSE3${UNQID}">
															<input type="radio" id="REVIEWPURPOSE3${UNQID}" name="REVIEWPURPOSE" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"REVIEWPURPOSE")){ %> disabled <% } %> value="3"
															<c:if test="${FORMDATA['REVIEWPURPOSE'] eq '3'}">checked="checked"</c:if>/>
															Addition to restricted lists or PEP status
														</label>
													</td>
													<td width="50%">
														<label class="btn btn-outline btn-primary btn-sm radio-inline" for="REVIEWPURPOSE4${UNQID}">
															<input type="radio" id="REVIEWPURPOSE4${UNQID}" name="REVIEWPURPOSE" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"REVIEWPURPOSE")){ %> disabled <% } %> value="4"
															<c:if test="${FORMDATA['REVIEWPURPOSE'] eq '4'}">checked="checked"</c:if>/>
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
											<strong> Checking of Common Customer</strong><font size = "4" color = "red"><b> * </b></font>
											<table class="table" style="margin-bottom: 0px;">
												<tr>
													<td colspan="2" width="50%">
														Does the customer have an existing banking relationship with any other India branch?
													</td>
													<td width="25%">
														<label class="btn btn-outline btn-success btn-sm radio-inline" for="EXISTINGCUSTOMERN${UNQID}">
														  <input type="radio" id="EXISTINGCUSTOMERN${UNQID}" name="EXISTINGCUSTOMER" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"EXISTINGCUSTOMER")){ %> disabled <% } %> checked="checked" value="NO"
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
														  	5) Unable to ascertain the legitimacy of Customer's source of funds
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
							
							<table class="table table-bordered table-striped" style="margin-bottom: 0px;">
								<tbody>
									<tr>
										<td colspan="5"> <strong>Customer Information</strong> </td>
									</tr>
									<tr>
										<td width="15%">
											Residential Address<font size = "4" color = "red"><b> * </b></font>
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
										<td>
											PAN No<font size = "4" color = "red"><b> * </b></font>
										</td>
										<td>
											<input type="text" class="form-control input-sm" name="PANNO" id="PANNO${UNQID}" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"PANNO")){ %> disabled <% } %> value="${FORMDATA['PANNO']}"/>
										</td>
										<td>
											<button type="button" class="btn btn-primary btn-sm" id="checkCustomerPANNo${UNQID}" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"CHECKCUSTOMERPANNO")){ %> disabled <% } %>>Check PAN</button>
										</td>
										<td>
											NSDL Response
										</td>
										<td>
											<textarea rows="2" cols="2" class="form-control" name="PANNSDLRESPONSE" id="PANNSDLRESPONSE${UNQID}" readOnly>${FORMDATA['PANNSDLRESPONSE']}</textarea>
											
										</td>
									</tr>
									<tr>
										<td>
											Aadhar card No
										</td>
										<td>
											<input type="text" class="form-control input-sm" name="AADHARNO" id="AADHARNO${UNQID}" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"AADHARNO")){ %> disabled <% } %> value="${FORMDATA['AADHARNO']}"/>
										</td>
										<td>&nbsp;</td>
										<td>
											Embassy customer<font size = "4" color = "red"><b> * </b></font>
										</td>
										<td>
											<label class="btn btn-outline btn-primary btn-sm radio-inline" for="EMBASSYCUSTOMERY${UNQID}">
												<input type="radio" id="EMBASSYCUSTOMERY${UNQID}" name="EMBASSYCUSTOMER" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"EMBASSYCUSTOMER")){ %> disabled <% } %> value="YES"
												<c:if test="${FORMDATA['EMBASSYCUSTOMER'] eq 'YES'}">checked="checked"</c:if>
												/>
												Yes
											</label>
											
											<label class="btn btn-outline btn-primary btn-sm radio-inline" for="EMBASSYCUSTOMERN${UNQID}">
												<input type="radio" id="EMBASSYCUSTOMERN${UNQID}"  name="EMBASSYCUSTOMER" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"EMBASSYCUSTOMER")){ %> disabled <% } %> value="NO"
												<c:if test="${FORMDATA['EMBASSYCUSTOMER'] eq 'NO'}">checked="checked"</c:if>
												/>
												No
											</label>
										</td>
									</tr>
									<tr>
										<td>
											NGO customer<font size = "4" color = "red"><b> * </b></font>
										</td>
										<td>
											<label class="btn btn-outline btn-primary btn-sm radio-inline" for="NGOCUSTOMERY${UNQID}">
												<input type="radio" id="NGOCUSTOMERY${UNQID}" name="NGOCUSTOMER" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"NGOCUSTOMER")){ %> disabled <% } %> value="YES"
												<c:if test="${FORMDATA['NGOCUSTOMER'] eq 'YES'}">checked="checked"</c:if>
												/>
												Yes
											</label>
											
											<label class="btn btn-outline btn-primary btn-sm radio-inline" for="NGOCUSTOMERN${UNQID}">
												<input type="radio" id="NGOCUSTOMERN${UNQID}"  name="NGOCUSTOMER" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"NGOCUSTOMER")){ %> disabled <% } %> value="NO"
												<c:if test="${FORMDATA['NGOCUSTOMER'] eq 'NO'}">checked="checked"</c:if>
												/>
												No
											</label>
										</td>
										<td>&nbsp;</td>
										<td>
											Trust customer<font size = "4" color = "red"><b> * </b></font>
										</td>
										<td>
											<label class="btn btn-outline btn-primary btn-sm radio-inline" for="TRUSTCUSTOMERY${UNQID}">
												<input type="radio" id="TRUSTCUSTOMERY${UNQID}" name="TRUSTCUSTOMER" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"TRUSTCUSTOMER")){ %> disabled <% } %> value="YES"
												<c:if test="${FORMDATA['TRUSTCUSTOMER'] eq 'YES'}">checked="checked"</c:if>
												/>
												Yes
											</label>
											
											<label class="btn btn-outline btn-primary btn-sm radio-inline" for="TRUSTCUSTOMERN${UNQID}">
												<input type="radio" id="TRUSTCUSTOMERN${UNQID}"  name="TRUSTCUSTOMER" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"TRUSTCUSTOMER")){ %> disabled <% } %> value="NO"
												<c:if test="${FORMDATA['TRUSTCUSTOMER'] eq 'NO'}">checked="checked"</c:if>
												/>
												No
											</label>
										</td>	
									</tr>
									<tr>
										<td>
											Passport<font size = "4" color = "red"><b> * </b></font>
										</td>
										<td>
											<input type="text" class="form-control input-sm" name="PASSPORT" id="PASSPORT${UNQID}" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"PASSPORT")){ %> disabled <% } %> value="${FORMDATA['PASSPORT']}"/>
										</td>
										<td>&nbsp;</td>
										<td>
											Driving Licence
										</td>
										<td>
											<input type="text" class="form-control input-sm" name="DRIVINGLICENCE" id="DRIVINGLICENCE${UNQID}" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"DRIVINGLICENCE")){ %> disabled <% } %> value="${FORMDATA['DRIVINGLICENCE']}"/>
										</td>
									</tr>
									<tr>
										<td>
											CKYC Identification No
										</td>
										<td>
											<input type="text" class="form-control input-sm" name="CKYCNO" id="CKYCNO${UNQID}" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"CKYCNO")){ %> disabled <% } %> value="${FORMDATA['CKYCNO']}"/>
										</td>
										<td>&nbsp;</td>
										<td>&nbsp;</td>
										<td>&nbsp;</td>
									</tr>
									<tr>
										<td>
											Type of Occupation<br/> If others, please specify others<font size = "4" color = "red"><b> * </b></font>
										</td>
										<td id="OCCUPATIONID">
											<select class="form-control input-sm selectpicker" name="OCCUPATION" id="OCCUPATION${UNQID}" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"OCCUPATION")){ %> disabled <% } %> onchange="getRiskRating('INDUSTRYTYPE',this,'INDUSTRYTYPERISKRATING')">
												<option value="">Select One</option>
												<c:forEach var="INDUSTRYOCCUPATIONMASTER" items="${INDUSTRYOCCUPATIONMASTER}">
													<option value="${INDUSTRYOCCUPATIONMASTER['OPTIONVALUE']}" riskRating="${INDUSTRYOCCUPATIONMASTER['RISKRATING']}" 
													<c:if test="${FORMDATA['OCCUPATION'] eq INDUSTRYOCCUPATIONMASTER['OPTIONVALUE']}">selected="selected"</c:if>>${INDUSTRYOCCUPATIONMASTER['OPTIONNAME']}</option>
												</c:forEach>
											</select>
											<br/>
											<br/>
											<input type="text" class="form-control input-sm" name="OTHEROCCUPATION" id="OTHEROCCUPATION${UNQID}" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"OTHEROCCUPATION")){ %> disabled <% } %> value="${FORMDATA['OTHEROCCUPATION']}"/>
										</td>
										<td>&nbsp;</td>
										<td>
											Date of Birth<font size = "4" color = "red"><b> * </b></font>
										</td>
										<td>
											<input type="text" class="form-control input-sm datepicker" name="DATEOFINCORPORATION" id="DATEOFINCORPORATION${UNQID}" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"DATEOFINCORPORATION")){ %> disabled <% } %> value="${FORMDATA['DATEOFINCORPORATION']}"/>
										</td>
									</tr>
									<tr>
										<td>
											Purpose of Business Relationship / Opening Account
										</td>
										<td>
											<input type="text" class="form-control input-sm" name="PURPOSEOFACCOUNT" id="PURPOSEOFACCOUNT${UNQID}" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"PURPOSEOFACCOUNT")){ %> disabled <% } %> value="${FORMDATA['PURPOSEOFACCOUNT']}"/>
										</td>
										<td>&nbsp;</td>
										<td>
											Source of Funds<font size = "4" color = "red"><b> * </b></font>
										</td>
										<td>
											<select class="form-control input-sm selectpicker" name="SOURCEOFFUND" id="SOURCEOFFUND${UNQID}" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"SOURCEOFFUND")){ %> disabled <% } %>>
												<option value="">Select One</option>
												<option value="Salary" <c:if test="${FORMDATA['SOURCEOFFUND'] eq 'Salary'}">selected="selected"</c:if>>Salary</option>
												<option value="Business proceeds" <c:if test="${FORMDATA['SOURCEOFFUND'] eq 'Business proceeds'}">selected="selected"</c:if>>Business proceeds</option>
												<option value="Investments" <c:if test="${FORMDATA['SOURCEOFFUND'] eq 'Investments'}">selected="selected"</c:if>>Investments</option>
												<option value="Others" <c:if test="${FORMDATA['SOURCEOFFUND'] eq 'Others'}">selected="selected"</c:if>>Others</option>
											</select>
										</td>
									</tr>
									<tr>
										<td>
											Country of Residence or Domicile<font size = "4" color = "red"><b> * </b></font>
										</td>
										<td>
											<select class="form-control input-sm selectpicker" name="DOMICILE" id="DOMICILE${UNQID}" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"DOMICILE")){ %> disabled <% } %> onchange="getRiskRating('INCROPCOUNTRY',this,'INCROPCOUNTRYRISKRATING')">
												<option value="">Select One</option>
												<c:forEach var="COUNTRYMASTER" items="${COUNTRYMASTER}">
													<option value="${COUNTRYMASTER['OPTIONVALUE']}" riskRating="${COUNTRYMASTER['RISKRATING']}"
													<c:if test="${f:contains(FORMDATA['DOMICILE'], COUNTRYMASTER['OPTIONVALUE'])}">selected="selected"</c:if>>${COUNTRYMASTER['OPTIONNAME']}</option>
												</c:forEach>
											</select>
										</td>
										<td>&nbsp;</td>
										<td>
											Country of Citizenship<font size = "4" color = "red"><b> * </b></font>
										</td>
										<td>
											<select class="form-control input-sm selectpicker" name="CITIZEN" id="CITIZEN${UNQID}" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"CITIZEN")){ %> disabled <% } %> onchange="getRiskRating('PRINCIPALCOUNTRY',this,'PRINCICOUNTRYRISKRATING')">
												<option value="">Select One</option>
												<c:forEach var="COUNTRYMASTER" items="${COUNTRYMASTER}">
													<option value="${COUNTRYMASTER['OPTIONVALUE']}" riskRating="${COUNTRYMASTER['RISKRATING']}"
													<c:if test="${f:contains(FORMDATA['CITIZEN'], COUNTRYMASTER['OPTIONVALUE'])}">selected="selected"</c:if>>${COUNTRYMASTER['OPTIONNAME']}</option>
												</c:forEach>
											</select>
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
														  <input type="checkbox" id="PRODUCTSERVICE_TD${UNQID}"  name="PRODUCTSERVICE_TD" value="TD" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"PRODUCTSERVICE_TD")){ %> disabled <% } %>
														  <c:if test="${FORMDATA['PRODUCTSERVICE_TD'] eq 'TD'}">checked="checked"</c:if>
														   riskRating="Low" />
														  <span>Time / Term Deposits</span>
														</label>
													</td>
													<td>
														<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="PRODUCTSERVICE_SA${UNQID}">
														  <input type="checkbox" id="PRODUCTSERVICE_SA${UNQID}"  name="PRODUCTSERVICE_SA" value="SA" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"PRODUCTSERVICE_SA")){ %> disabled <% } %>
														  <c:if test="${FORMDATA['PRODUCTSERVICE_SA'] eq 'SA'}">checked="checked"</c:if>
														  riskRating="High" />
														  <span>Saving Account</span>
														</label>
													</td>
												</tr>
												<tr>
													<td>
														<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="PRODUCTSERVICE_GR${UNQID}">
														  <input type="checkbox" id="PRODUCTSERVICE_GR${UNQID}"  name="PRODUCTSERVICE_GR" value="GR" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"PRODUCTSERVICE_GR")){ %> disabled <% } %>
														  <c:if test="${FORMDATA['PRODUCTSERVICE_GR'] eq 'GR'}">checked="checked"</c:if>
														  riskRating="Low" />
														  <span>Guarantees</span>
														</label>
													</td>
													<td>
														<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="PRODUCTSERVICE_CA${UNQID}">
														  <input type="checkbox" id="PRODUCTSERVICE_CA${UNQID}"  name="PRODUCTSERVICE_CA" value="CA" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"PRODUCTSERVICE_CA")){ %> disabled <% } %>
														  <c:if test="${FORMDATA['PRODUCTSERVICE_CA'] eq 'CA'}">checked="checked"</c:if>
														  riskRating="High" />
														  <span>Current Account</span>
														</label>
													</td>
												</tr>
												<tr>
													<td>
														<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="PRODUCTSERVICE_LN${UNQID}">
														  <input type="checkbox" id="PRODUCTSERVICE_LN${UNQID}"  name="PRODUCTSERVICE_LN" value="LN" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"PRODUCTSERVICE_LN")){ %> disabled <% } %>
														  <c:if test="${FORMDATA['PRODUCTSERVICE_LN'] eq 'LN'}">checked="checked"</c:if>
														  riskRating="Low" />
														  <span>Loan</span>
														</label>
													</td>
													<td>
														<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="PRODUCTSERVICE_RE${UNQID}">
														  <input type="checkbox" id="PRODUCTSERVICE_RE${UNQID}"  name="PRODUCTSERVICE_RE" value="RE" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"PRODUCTSERVICE_RE")){ %> disabled <% } %>
														  <c:if test="${FORMDATA['PRODUCTSERVICE_RE'] eq 'RE'}">checked="checked"</c:if>
														  riskRating="High" />
														  <span>Remittance (i.e. ITT & OTT)</span>
														</label>
													</td>
												</tr>
												<tr>
													<td>
														<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="PRODUCTSERVICE_IB${UNQID}">
														  <input type="checkbox" id="PRODUCTSERVICE_IB${UNQID}"  name="PRODUCTSERVICE_IB" value="IB" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"PRODUCTSERVICE_IB")){ %> disabled <% } %>
														  <c:if test="${FORMDATA['PRODUCTSERVICE_IB'] eq 'IB'}">checked="checked"</c:if>
														  riskRating="High" />
														  <span>Internet Banking (i.e. MGeB)</span>
														</label>
													</td>
													<td>
														<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="PRODUCTSERVICE_TF${UNQID}">
														  <input type="checkbox" id="PRODUCTSERVICE_TF${UNQID}"  name="PRODUCTSERVICE_TF" value="TF" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"PRODUCTSERVICE_TF")){ %> disabled <% } %>
														  <c:if test="${FORMDATA['PRODUCTSERVICE_TF'] eq 'TF'}">checked="checked"</c:if>
														  riskRating="High" />
														  <span>Trade Finance</span>
														</label>
													</td>
												</tr>
												<tr>
													<td>
														<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="PRODUCTSERVICE_OT${UNQID}">
														  <input type="checkbox" id="PRODUCTSERVICE_OT${UNQID}"  name="PRODUCTSERVICE_OT" value="OT" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"PRODUCTSERVICE_OT")){ %> disabled <% } %>
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
											<label style="margin-bottom: 8px;" class="btn btn-outline btn-primary btn-sm radio-inline" for="FACETOFACEINTRACTIONY${UNQID}">
												<input type="radio" id="FACETOFACEINTRACTIONY${UNQID}" name="FACETOFACEINTRACTION" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"FACETOFACEINTRACTION")){ %> disabled <% } %> value="YES"
												<c:if test="${FORMDATA['FACETOFACEINTRACTION'] eq 'YES'}">checked="checked"</c:if>
												/>
												Face-to-face interaction with customer
											</label>
											
											<label class="btn btn-outline btn-primary btn-sm radio-inline" for="FACETOFACEINTRACTIONN${UNQID}">
												<input type="radio" id="FACETOFACEINTRACTIONN${UNQID}"  name="FACETOFACEINTRACTION" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"FACETOFACEINTRACTION")){ %> disabled <% } %> value="NO"
												<c:if test="${FORMDATA['FACETOFACEINTRACTION'] eq 'NO'}">checked="checked"</c:if>
												/>
												No face-to-face interaction with customer (e.g. Telephone, Internet, Fax, Mail, etc.)
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
										<td colspan="5"> <strong>For Customer with Current Account(s)</strong> </td>
									</tr>
									<tr>
										<td colspan="2">Expected transaction volume<font size = "4" color = "red"><b>  </b></font></td>
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
								</tbody>
							</table>
							<table class="table table-bordered table-striped" style="margin-bottom: 0px;">
								<tbody>
									<tr>
										<td colspan="4"> <strong>Joint Holder Details</strong> </td>
										<td colspan="1" style="text-align: center;">
											<c:if test="${(FORMDATA['STATUS'] eq 'BPA-P' && CURRENTROLE eq 'ROLE_BPAMAKER') || (FORMDATA['STATUS'] eq 'BPD-P' && CURRENTROLE eq 'ROLE_BPDMAKER')}">
												<% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"ADDJOINTHOLDER")){ %>
												<button type="button" class="btn btn-primary btn-xs" id="addJointHolder${UNQID}" disabled>Add Joint Holder</button>
												<% } else { %>	
												<button type="button" class="btn btn-primary btn-xs cddModifyButton" id="addJointHolder${UNQID}">Add Joint Holder</button>
												<% } %>
											</c:if>
										</td>
									</tr>
									<tr>
										<td colspan="5" id="jointHolderDetails${UNQID}">
											<table class="table table-bordered table-striped" style="margin-bottom: 0px;">
												<thead>
													<th>Name</th>
													<th>Pan No</th>
													<th>Relation</th>
													<th>Match?</th>
													<th>List Name</th>
													<th>Action</th>
												</thead>
												<tbody>
													<c:choose>
														<c:when test="${f:length(JOINTHOLDERS) > 0}">
															<c:forEach var="JOINTHOLDERS" items="${JOINTHOLDERS}">
																<tr>
																	<td width="20%" style="cursor: pointer; text-decoration: underline; color: blue;" onclick="viewDetails('JOINTHOLDER','${JOINTHOLDERS['COMPASSREFNO']}','${JOINTHOLDERS['LINENO']}')" >${JOINTHOLDERS['JOINTHOLDERNAME']}</td>
																	<td width="15%">${JOINTHOLDERS['JOINTHOLDERPAN']}</td>
																	<td width="15%">${JOINTHOLDERS['RELATIONWITHPRIMARY']}</td>
																	<td width="15%" class="match">
																		<select class="form-control input-sm selectpicker">
																			<option value="N" <c:if test="${JOINTHOLDERS['SANCTIONLISTMATCH'] eq 'N'}">selected</c:if> >No</option>
																			<option value="Y" <c:if test="${JOINTHOLDERS['SANCTIONLISTMATCH'] eq 'Y'}">selected</c:if>>Yes</option>
																		</select>
																	</td>
																	<td width="15%" class="listname">
																		<select class="form-control input-sm selectpicker" multiple>
																			<option value="">None</option>
																			<option value="DJ" <c:if test="${f:contains(JOINTHOLDERS['SANCTIONLISTNAME'], 'DJ')}">selected</c:if>>Dowjones</option>
																			<option value="RBI" <c:if test="${f:contains(JOINTHOLDERS['SANCTIONLISTNAME'], 'RBI')}">selected</c:if>>RBI Defaulter</option>
																			<option value="EXP" <c:if test="${f:contains(JOINTHOLDERS['SANCTIONLISTNAME'], 'EXP')}">selected</c:if>>Exporter List</option>
																			<option value="FIU" <c:if test="${f:contains(JOINTHOLDERS['SANCTIONLISTNAME'], 'FIU')}">selected</c:if>>Local FIU Exception</option>
																			<option value="OFC" <c:if test="${f:contains(JOINTHOLDERS['SANCTIONLISTNAME'], 'OFC')}">selected</c:if>>OFAC SDN</option>
																			<option value="UNC" <c:if test="${f:contains(JOINTHOLDERS['SANCTIONLISTNAME'], 'UNC')}">selected</c:if>>UN Consolidated</option>
																		</select>
																	</td>
																	<td width="20%">
																		<!-- <button type="button" class="btn btn-primary btn-xs" onclick="screen(this)">Screen</button>  -->
																		<c:choose>
																			<c:when test="${(CURRENTROLE eq 'ROLE_BPAMAKER')}">
																				<button type="button" class="btn btn-primary btn-xs" onclick="screen(this, 'JOINTHOLDER','${JOINTHOLDERS['LINENO']}')">Screen</button>
																				<button type="button" class="btn btn-primary btn-xs" onclick="screened(this,'JOINTHOLDER','${JOINTHOLDERS['SCREENINGREFERENCENO']}')">View Screened Matches</button>
																			</c:when>
																			<c:otherwise>
																				<button type="button" class="btn btn-primary btn-xs" onclick="screened(this,'JOINTHOLDER','${JOINTHOLDERS['SCREENINGREFERENCENO']}')">View Screened Matches</button>
																			</c:otherwise>
																		</c:choose>
																		<c:if test="${(FORMDATA['STATUS'] eq 'BPA-P' && CURRENTROLE eq 'ROLE_BPAMAKER') || (FORMDATA['STATUS'] eq 'BPD-P' && CURRENTROLE eq 'ROLE_BPDMAKER')}">
																			<button type="button" class="btn btn-success btn-xs cddModifyButton" onclick="updateScreeningMatch(this, 'JOINTHOLDER','${JOINTHOLDERS['COMPASSREFNO']}','${JOINTHOLDERS['LINENO']}')">Update</button>
																			<button type="button" class="btn btn-danger btn-xs cddModifyButton"  onclick="removeEntity('JOINTHOLDER','${JOINTHOLDERS['COMPASSREFNO']}','${JOINTHOLDERS['LINENO']}')">Remove</button>
																		</c:if>
																		<c:if test="${(FORMDATA['STATUS'] eq 'BPA-P' && CURRENTROLE eq 'ROLE_BPAMAKER') || (FORMDATA['STATUS'] eq 'BPD-P' && CURRENTROLE eq 'ROLE_BPDMAKER')}">
																			<button type="button" class="btn btn-success btn-xs cddModifyButton" onclick="updateScreeningMatch(this, 'JOINTHOLDER','${JOINTHOLDERS['COMPASSREFNO']}','${JOINTHOLDERS['LINENO']}')">Update</button>
																			<button type="button" class="btn btn-danger btn-xs cddModifyButton"  onclick="removeEntity('JOINTHOLDER','${JOINTHOLDERS['COMPASSREFNO']}','${JOINTHOLDERS['LINENO']}')">Remove</button>
																		</c:if>
																	</td>
																</tr>
															</c:forEach>
														</c:when>
														<c:otherwise>
															<tr>
																<td colspan="6"><center>No Joint Holder Added</center></td>
															</tr>
														</c:otherwise>
													</c:choose>		
												</tbody>
											</table>
										</td>
									</tr>
									<tr>
										<td colspan="4"> <strong>Nominee Details</strong><font size = "4" color = "red"><b> * </b></font> </td>
										<td colspan="1" style="text-align: center;">
											<c:if test="${(FORMDATA['STATUS'] eq 'BPA-P' && CURRENTROLE eq 'ROLE_BPAMAKER') || (FORMDATA['STATUS'] eq 'BPD-P' && CURRENTROLE eq 'ROLE_BPDMAKER')}">
												<% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"ADDNOMINEEDETAIL")){ %>
												<button type="button" class="btn btn-primary btn-xs" id="addNomineeDetail${UNQID}" disabled>Add Nominee Detail</button>
												<% } else { %>	
												<button type="button" class="btn btn-primary btn-xs cddModifyButton" id="addNomineeDetail${UNQID}">Add Nominee Detail</button>
												<% } %> 
											</c:if>
										</td>
									</tr>
									<tr>
										<td colspan="5" id="nomineeDetails${UNQID}">
											<table class="table table-bordered table-striped" style="margin-bottom: 0px;">
												<thead>
													<th>Name</th>
													<th>Date Of Birth</th>
													<th>Relation</th>
													<th>Match?</th>
													<th>List Name</th>
													<th>Action</th>
												</thead>
												<tbody>
													<c:choose>
														<c:when test="${f:length(NOMINEEDETAILS) > 0}">
															<c:forEach var="NOMINEEDETAILS" items="${NOMINEEDETAILS}">
																<tr>
																	<td width="20%" style="cursor: pointer; text-decoration: underline; color: blue;" onclick="viewDetails('NOMINEEDETAIL','${NOMINEEDETAILS['COMPASSREFNO']}','${NOMINEEDETAILS['LINENO']}')" >${NOMINEEDETAILS['NOMINEENAME']}</td>
																	<td width="15%">${NOMINEEDETAILS['NOMINEEDOB']}</td>
																	<td width="15%">${NOMINEEDETAILS['RELATIONWITHPRIMARY']}</td>
																	<td width="15%" class="match">
																		<select class="form-control input-sm selectpicker">
																			<option value="N" <c:if test="${NOMINEEDETAILS['SANCTIONLISTMATCH'] eq 'N'}">selected</c:if> >No</option>
																			<option value="Y" <c:if test="${NOMINEEDETAILS['SANCTIONLISTMATCH'] eq 'Y'}">selected</c:if>>Yes</option>
																		</select>
																	</td>
																	<td width="15%" class="listname">
																		<select class="form-control input-sm selectpicker" multiple>
																			<option value="">None</option>
																			<option value="DJ" <c:if test="${f:contains(NOMINEEDETAILS['SANCTIONLISTNAME'], 'DJ')}">selected</c:if>>Dowjones</option>
																			<option value="RBI" <c:if test="${f:contains(NOMINEEDETAILS['SANCTIONLISTNAME'], 'RBI')}">selected</c:if>>RBI Defaulter</option>
																			<option value="EXP" <c:if test="${f:contains(NOMINEEDETAILS['SANCTIONLISTNAME'], 'EXP')}">selected</c:if>>Exporter List</option>
																			<option value="FIU" <c:if test="${f:contains(NOMINEEDETAILS['SANCTIONLISTNAME'], 'FIU')}">selected</c:if>>Local FIU Exception</option>
																			<option value="OFC" <c:if test="${f:contains(NOMINEEDETAILS['SANCTIONLISTNAME'], 'OFC')}">selected</c:if>>OFAC SDN</option>
																			<option value="UNC" <c:if test="${f:contains(NOMINEEDETAILS['SANCTIONLISTNAME'], 'UNC')}">selected</c:if>>UN Consolidated</option>
																		</select>
																	</td>
																	<td width="20%">
																		<!-- <button type="button" class="btn btn-primary btn-xs" onclick="screen(this)">Screen</button> -->
																		<c:choose>
																			<c:when test="${(CURRENTROLE eq 'ROLE_BPAMAKER')}">
																				<button type="button" class="btn btn-primary btn-xs" onclick="screen(this, 'NOMINEEDETAIL','${NOMINEEDETAILS['LINENO']}')">Screen</button>
													                            <button type="button" class="btn btn-primary btn-xs" onclick="screened(this,'NOMINEEDETAIL','${NOMINEEDETAILS['SCREENINGREFERENCENO']}')">View Screened Matches</button>
																			</c:when>
																			<c:otherwise>
																				<button type="button" class="btn btn-primary btn-xs" onclick="screened(this,'NOMINEEDETAIL','${NOMINEEDETAILS['SCREENINGREFERENCENO']}')">View Screened Matches</button>
																			</c:otherwise>
																		</c:choose>
																		<c:if test="${(FORMDATA['STATUS'] eq 'BPA-P' && CURRENTROLE eq 'ROLE_BPAMAKER') || (FORMDATA['STATUS'] eq 'BPD-P' && CURRENTROLE eq 'ROLE_BPDMAKER')}">
																			<button type="button" class="btn btn-success btn-xs cddModifyButton" onclick="updateScreeningMatch(this, 'NOMINEEDETAIL','${NOMINEEDETAILS['COMPASSREFNO']}','${NOMINEEDETAILS['LINENO']}')">Update</button>
																			<button type="button" class="btn btn-danger btn-xs cddModifyButton"  onclick="removeEntity('NOMINEEDETAIL','${NOMINEEDETAILS['COMPASSREFNO']}','${NOMINEEDETAILS['LINENO']}')">Remove</button>
																		</c:if>
																	</td>
																</tr>
															</c:forEach>
														</c:when>
														<c:otherwise>
															<tr>
																<td colspan="6"><center>No Nominee Details Added</center></td>
															</tr>
														</c:otherwise>
													</c:choose>		
												</tbody>
											</table>
										</td>
									</tr>
									<tr>
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
																		</select>
																	</td>
																	<td width="20%">
																		<!--<button type="button" class="btn btn-primary btn-xs" onclick="screen(this)">Screen</button>-->
																		<c:choose>
																			<c:when test="${(CURRENTROLE eq 'ROLE_BPAMAKER')}">
																				<button type="button" class="btn btn-primary btn-xs" onclick="screen(this,'INTERMEDIARY','${INTERMEDIARIES['LINENO']}')">Screen</button>
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
						<div role="tabpanel" class="tab-pane" id="screening">
							<form action="javascript:void(0)" method="POST" id="searchMasterForm2${UNQID}">
							<table class="table table-bordered table-striped" style="margin-bottom: 0px;">
								<tbody>
									<tr>
										<td colspan="1" width="15%">Customer Full Name</td>
										<td colspan="3" width="50%">
											<input type="text" class="form-control input-sm" name="CUSTOMERNAMETOSCREEN" id="CUSTOMERNAMETOSCREEN${UNQID}" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"CUSTOMERNAMETOSCREEN")){ %> disabled <% } %> value="${FORMDATA['CUSTOMERNAME']}">
										</td>
										<td colspan="1" style="text-align: center; vertical-align: middle;" width="35%" rowspan="2">
											<!-- <button type="button" class="btn btn-primary btn-sm" id="screenCustomerNames${UNQID}">Screen</button>-->
											<c:choose>
												<c:when test="${(CURRENTROLE eq 'ROLE_BPAMAKER')}">
													<button type="button" class="btn btn-primary btn-xs" onclick="screen(this,'CUSTOMERNAME','${FORMDATA['LINENO']}')">Screen</button>&nbsp;&nbsp;&nbsp;&nbsp;
													<button type="button" class="btn btn-primary btn-xs" onclick="screened(this,'CUSTOMERNAME','${FORMDATA['SCREENINGREFERENCENO']}')">View Screened Matches</button>
												</c:when>
												<c:otherwise>
													<button type="button" class="btn btn-primary btn-xs" onclick="screened(this,'CUSTOMERNAME','${FORMDATA['SCREENINGREFERENCENO']}')">View Screened Matches</button>
												</c:otherwise>
											</c:choose>
										</td>
									</tr>
									<tr>
										<td colspan="1" width="15%">Customer Alias Name</td>
										<td colspan="3" width="50%">
											<input type="text" class="form-control input-sm" name="CUSTOMERALIASNAMETOSCREEN" id="CUSTOMERALIASNAMETOSCREEN${UNQID}" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"CUSTOMERALIASNAMETOSCREEN")){ %> disabled <% } %> value="${FORMDATA['CUSTOMERALIASNAME']}">
										</td>
									</tr>
									<tr>
										<th colspan="2" width="40%">List Name</th>
										<th colspan="2" width="40%">Description</th>
										<th colspan="1" width="20%">Action</th>
									</tr>
									<tr>
										<td colspan="2" >CLAF (or equivalent)</td>
										<td colspan="2" >Sanctions<font size = "4" color = "red"><b> * </b></font></td>
										<td colspan="1">
											<label class="btn btn-outline btn-primary btn-sm radio-inline" for="CLAFMATCH_Y${UNQID}">
												<input type="radio" id="CLAFMATCH_Y${UNQID}"  name="CLAFMATCH" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"CLAFMATCH")){ %> disabled <% } %> value="YES"
												<c:if test="${FORMDATA['CLAFMATCH'] eq 'YES'}">checked="checked"</c:if>
												/>
												Yes
											</label>
											<label class="btn btn-outline btn-primary btn-sm radio-inline" for="CLAFMATCH_N${UNQID}">
												<input type="radio" id="CLAFMATCH_N${UNQID}"  name="CLAFMATCH" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"CLAFMATCH")){ %> disabled <% } %> value="NO"
												<c:if test="${FORMDATA['CLAFMATCH'] eq 'NO'}">checked="checked"</c:if>
												/>
												No
											</label>
										</td>
									</tr>
									<tr>
										<td colspan="2" >Sanctions List Search</td>
										<td colspan="2" >Sanctions, Local & HO Bad Guy List<font size = "4" color = "red"><b> * </b></font></td>
										<td colspan="1">
											<label class="btn btn-outline btn-primary btn-sm radio-inline" for="SLSMATCH_Y${UNQID}">
												<input type="radio" id="SLSMATCH_Y${UNQID}"  name="SLSMATCH" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"SLSMATCH")){ %> disabled <% } %> value="YES"
												<c:if test="${FORMDATA['SLSMATCH'] eq 'YES'}">checked="checked"</c:if>
												/>
												Yes
											</label>
											<label class="btn btn-outline btn-primary btn-sm radio-inline" for="SLSMATCH_N${UNQID}">
												<input type="radio" id="SLSMATCH_N${UNQID}"  name="SLSMATCH" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"SLSMATCH")){ %> disabled <% } %> value="NO"
												<c:if test="${FORMDATA['SLSMATCH'] eq 'NO'}">checked="checked"</c:if>
												/>
												No
											</label>
										</td>
									</tr>
									<tr>
										<td colspan="2" rowspan="2" style="vertical-align: middle;">Dow Jones (or equivalent)<font size = "4" color = "red"><b> * </b></font></td>
										<td colspan="2" >PEP (If Yes is selected, please fill in the PEP Details in the below table)<font size = "4" color = "red"><b> * </b></font></td>
										<td colspan="1">
											<label class="btn btn-outline btn-primary btn-sm radio-inline" for="PEPMATCH_Y${UNQID}">
												<input type="radio" id="PEPMATCH_Y${UNQID}"  name="PEPMATCH" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"PEPMATCH")){ %> disabled <% } %> value="YES"
												<c:if test="${FORMDATA['PEPMATCH'] eq 'YES'}">checked="checked"</c:if>
												/>
												Yes
											</label>
											<label class="btn btn-outline btn-primary btn-sm radio-inline" for="PEPMATCH_N${UNQID}">
												<input type="radio" id="PEPMATCH_N${UNQID}"  name="PEPMATCH" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"PEPMATCH")){ %> disabled <% } %> value="NO"
												<c:if test="${FORMDATA['PEPMATCH'] eq 'NO'}">checked="checked"</c:if>
												/>
												No
											</label>
										</td>
									</tr>
									<tr>
										<td colspan="2" >Adverse Information is relation to ML/TF, Sanctions<font size = "4" color = "red"><b> * </b></font></td>
										<td colspan="1">
											<label class="btn btn-outline btn-primary btn-sm radio-inline" for="ADVINFO_Y${UNQID}">
												<input type="radio" id="ADVINFO_Y${UNQID}"  name="ADVINFO" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"ADVINFO")){ %> disabled <% } %> value="YES"
												<c:if test="${FORMDATA['ADVINFO'] eq 'YES'}">checked="checked"</c:if>
												/>
												Yes
											</label>
											<label class="btn btn-outline btn-primary btn-sm radio-inline" for="ADVINFO_N${UNQID}">
												<input type="radio" id="ADVINFO_N${UNQID}"  name="ADVINFO" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"ADVINFO")){ %> disabled <% } %> value="NO"
												<c:if test="${FORMDATA['ADVINFO'] eq 'NO'}">checked="checked"</c:if>
												/>
												No
											</label>
										</td>
									</tr>
									<tr>
										<td colspan="2" >Credit Inquiry</td>
										<td colspan="2" >Anti-Social Elements(ASE)<font size = "4" color = "red"><b> * </b></font></td>
										<td colspan="1">
											<label class="btn btn-outline btn-primary btn-sm radio-inline" for="ASEMATCH_Y${UNQID}">
												<input type="radio" id="ASEMATCH_Y${UNQID}"  name="ASEMATCH" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"ASEMATCH")){ %> disabled <% } %> value="YES"
												<c:if test="${FORMDATA['ASEMATCH'] eq 'YES'}">checked="checked"</c:if>
												/>
												Yes
											</label>
											<label class="btn btn-outline btn-primary btn-sm radio-inline" for="ASEMATCH_N${UNQID}">
												<input type="radio" id="ASEMATCH_N${UNQID}"  name="ASEMATCH" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"ASEMATCH")){ %> disabled <% } %> value="NO"
												<c:if test="${FORMDATA['ASEMATCH'] eq 'NO'}">checked="checked"</c:if>
												/>
												No
											</label>
										</td>
									</tr>
									<tr>
										<td colspan="4" >In addition to the above, are you aware of any AML / CTF and Sanction risk posed by the Customer?</td>
										<td colspan="1">
											<label class="btn btn-outline btn-primary btn-sm radio-inline" for="OTHERMATCH_Y${UNQID}">
												<input type="radio" id="OTHERMATCH_Y${UNQID}"  name="OTHERMATCH" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"OTHERMATCH")){ %> disabled <% } %> value="YES"
												<c:if test="${FORMDATA['OTHERMATCH'] eq 'YES'}">checked="checked"</c:if>
												/>
												Yes
											</label>
											<label class="btn btn-outline btn-primary btn-sm radio-inline" for="OTHERMATCH_N${UNQID}">
												<input type="radio" id="OTHERMATCH_N${UNQID}"  name="OTHERMATCH" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"OTHERMATCH")){ %> disabled <% } %> value="NO"
												<c:if test="${FORMDATA['OTHERMATCH'] eq 'NO'}">checked="checked"</c:if>
												/>
												No
											</label>
										</td>
									</tr>
									<tr>
										<td colspan="2">If Yes is selected for any of the above questions, please provide details</td>
										<td colspan="3">
											<textarea rows="2" cols="2" class="form-control" name="SCREENINGMATCHDETAILS" id="SCREENINGMATCHDETAILS${UNQID}" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"SCREENINGMATCHDETAILS")){ %> disabled <% } %>>${FORMDATA['SCREENINGMATCHDETAILS']}</textarea>
										</td>
									</tr>
									<tr>
										<td colspan="4"><strong>PEP Details</strong> </td>
										<td colspan="1" style="text-align: center;">
											<c:if test="${(FORMDATA['STATUS'] eq 'BPA-P' && CURRENTROLE eq 'ROLE_BPAMAKER') || (FORMDATA['STATUS'] eq 'BPD-P' && CURRENTROLE eq 'ROLE_BPDMAKER')}">
											<% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"ADDPEPDETAILS")){ %> 
											<button type="button" class="btn btn-primary btn-xs" id="addPEPDetails${UNQID}" disabled>Add PEP</button>
											<% } else { %>
											<button type="button" class="btn btn-primary btn-xs cddModifyButton" id="addPEPDetails${UNQID}">Add PEP</button>
											<% } %>
											</c:if>
										</td>
									</tr>
									<tr>
										<td colspan="5" id="pepDetails${UNQID}">
											<table class="table table-bordered table-striped" style="margin-bottom: 0px;">
												<thead>
													<th>Name</th>
													<th>Position Held in Government</th>
													<th>Nationality</th>
													<th>Position Held in Company</th>
													<th>Match?</th>
													<th>List Name</th>
													<th>Action</th>
												</thead>
												<tbody>
													<c:choose>
														<c:when test="${f:length(PEPDETAILS) > 0}">
															<c:forEach var="PEPDETAILS" items="${PEPDETAILS}">
																<tr>
																	<td width="15%" style="cursor: pointer; text-decoration: underline; color: blue;" onclick="viewDetails('PEP','${PEPDETAILS['COMPASSREFNO']}','${PEPDETAILS['LINENO']}')" >${PEPDETAILS['PEPNAME']}</td>
																	<td width="15%">${PEPDETAILS['PEPPOSITIONINGOVT']}</td>
																	<td width="15%">${PEPDETAILS['PEPNATIONALITY']}</td>
																	<td width="15%">${PEPDETAILS['PEPPOSITIONINCOMPANY']}</td>
																	<td width="10%" class="match">
																		<select class="form-control input-sm selectpicker">
																			<option value="N" <c:if test="${PEPDETAILS['SANCTIONLISTMATCH'] eq 'N'}">selected</c:if> >No</option>
																			<option value="Y" <c:if test="${PEPDETAILS['SANCTIONLISTMATCH'] eq 'Y'}">selected</c:if>>Yes</option>
																		</select>
																	</td>
																	<td width="15%" class="listname">
																		<select class="form-control input-sm selectpicker" multiple>
																			<option value="">None</option>
																			<option value="DJ" <c:if test="${f:contains(PEPDETAILS['SANCTIONLISTNAME'], 'DJ')}">selected</c:if>>Dowjones</option>
																			<option value="RBI" <c:if test="${f:contains(PEPDETAILS['SANCTIONLISTNAME'], 'RBI')}">selected</c:if>>RBI Defaulter</option>
																			<option value="EXP" <c:if test="${f:contains(PEPDETAILS['SANCTIONLISTNAME'], 'EXP')}">selected</c:if>>Exporter List</option>
																			<option value="FIU" <c:if test="${f:contains(PEPDETAILS['SANCTIONLISTNAME'], 'FIU')}">selected</c:if>>Local FIU Exception</option>
																			<option value="OFC" <c:if test="${f:contains(PEPDETAILS['SANCTIONLISTNAME'], 'OFC')}">selected</c:if>>OFAC SDN</option>
																			<option value="UNC" <c:if test="${f:contains(PEPDETAILS['SANCTIONLISTNAME'], 'UNC')}">selected</c:if>>UN Consolidated</option>
																		</select>
																	</td>
																	<td width="15%">
																		<!-- <button type="button" class="btn btn-primary btn-xs" onclick="screen(this)">Screen</button>-->
																		<c:choose>
																			<c:when test="${(CURRENTROLE eq 'ROLE_BPAMAKER')}">
																				<button type="button" class="btn btn-primary btn-xs" onclick="screen(this,'PEP','${PEPDETAILS['LINENO']}')">Screen</button>
																				<button type="button" class="btn btn-primary btn-xs" onclick="screened(this,'PEP','${PEPDETAILS['SCREENINGREFERENCENO']}')">View Screened Matches</button>
																			</c:when>
																			<c:otherwise>
																				<button type="button" class="btn btn-primary btn-xs" onclick="screened(this,'PEP','${PEPDETAILS['SCREENINGREFERENCENO']}')">View Screened Matches</button>
																			</c:otherwise>
																		</c:choose>
																		<c:if test="${(FORMDATA['STATUS'] eq 'BPA-P' && CURRENTROLE eq 'ROLE_BPAMAKER') || (FORMDATA['STATUS'] eq 'BPD-P' && CURRENTROLE eq 'ROLE_BPDMAKER')}">
																			<button type="button" class="btn btn-success btn-xs cddModifyButton" onclick="updateScreeningMatch(this, 'PEP','${PEPDETAILS['COMPASSREFNO']}','${PEPDETAILS['LINENO']}')">Update</button>
																			<button type="button" class="btn btn-danger btn-xs cddModifyButton"  onclick="removeEntity('PEP','${PEPDETAILS['COMPASSREFNO']}','${PEPDETAILS['LINENO']}')">Remove</button>
																		</c:if>
																		<c:if test="${(FORMDATA['STATUS'] eq 'BPA-P' && CURRENTROLE eq 'ROLE_BPAMAKER') || (FORMDATA['STATUS'] eq 'BPD-P' && CURRENTROLE eq 'ROLE_BPDMAKER')}">
																			<button type="button" class="btn btn-success btn-xs cddModifyButton" onclick="updateScreeningMatch(this, 'PEP','${PEPDETAILS['COMPASSREFNO']}','${PEPDETAILS['LINENO']}')">Update</button>
																			<button type="button" class="btn btn-danger btn-xs cddModifyButton"  onclick="removeEntity('PEP','${PEPDETAILS['COMPASSREFNO']}','${PEPDETAILS['LINENO']}')">Remove</button>
																		</c:if>
																	</td>
																</tr>
															</c:forEach>
														</c:when>
														<c:otherwise>
															<tr>
																<td colspan="7"><center>No PEP Added</center></td>
															</tr>
														</c:otherwise>
													</c:choose>
												</tbody>
											</table>
										</td>
									</tr>
									<tr>
										<td colspan="5"><strong>Sanctions</strong> </td>
									</tr>
									<tr>
										<td colspan="2" >Does the Customer have any direct dealings with sanctioned countries or parties?</td>
										<td colspan="3">
											<label class="btn btn-outline btn-primary btn-sm radio-inline" for="DIRECTDEALINGWITHSANCTION_Y${UNQID}">
												<input type="radio" id="DIRECTDEALINGWITHSANCTION_Y${UNQID}"  name="DIRECTDEALINGWITHSANCTION" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"DIRECTDEALINGWITHSANCTION")){ %> disabled <% } %> value="YES"
												<c:if test="${FORMDATA['DIRECTDEALINGWITHSANCTION'] eq 'YES'}">checked="checked"</c:if>
												/>
												Yes
											</label>
											<label class="btn btn-outline btn-primary btn-sm radio-inline" for="DIRECTDEALINGWITHSANCTION_N${UNQID}">
												<input type="radio" id="DIRECTDEALINGWITHSANCTION_N${UNQID}"  name="DIRECTDEALINGWITHSANCTION" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"DIRECTDEALINGWITHSANCTION")){ %> disabled <% } %> value="NO"
												<c:if test="${FORMDATA['DIRECTDEALINGWITHSANCTION'] eq 'NO'}">checked="checked"</c:if>
												/>
												No
											</label>
										</td>
									</tr>
									<tr>
										<td colspan="5">
											If No, proceed to Risk Rating Form<br/>
											If Yes, please do the following<br/>
											Proceed to answer questions below and proceed to Risk Rating Form
										</td>
									</tr>
									<tr>
										<td colspan="2" >
											Please provide the name of sanctioned countries and parties
										</td>
										<td colspan="3">
											<textarea rows="2" cols="2" class="form-control" name="SANCTIONCOUNTRIES" id="SANCTIONCOUNTRIES${UNQID}" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"SANCTIONCOUNTRIES")){ %> disabled <% } %>
											<c:if test="${FORMDATA['DIRECTDEALINGWITHSANCTION'] ne 'YES'}">disabled</c:if>>${FORMDATA['SANCTIONCOUNTRIES']}</textarea>
										</td>
									</tr>
									<tr>
										<td colspan="2" >have you conducted screening on the sanctioned parties & addressed any hits?</td>
										<td colspan="3">
											<label class="btn btn-outline btn-primary btn-sm radio-inline" for="SANCTIONSCREENHITS_Y${UNQID}">
												<input type="radio" id="SANCTIONSCREENHITS_Y${UNQID}"  name="SANCTIONSCREENHITS" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"SANCTIONSCREENHITS")){ %> disabled <% } %> value="YES"
												<c:if test="${FORMDATA['SANCTIONSCREENHITS'] eq 'YES'}">checked="checked"</c:if>
												<c:if test="${FORMDATA['DIRECTDEALINGWITHSANCTION'] ne 'YES'}">disabled</c:if>
												/>
												Yes
											</label>
											<label class="btn btn-outline btn-primary btn-sm radio-inline" for="SANCTIONSCREENHITS_N${UNQID}">
												<input type="radio" id="SANCTIONSCREENHITS_N${UNQID}"  name="SANCTIONSCREENHITS" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"SANCTIONSCREENHITS")){ %> disabled <% } %> value="NO"
												<c:if test="${FORMDATA['SANCTIONSCREENHITS'] eq 'NO'}">checked="checked"</c:if>
												<c:if test="${FORMDATA['DIRECTDEALINGWITHSANCTION'] ne 'YES'}">disabled</c:if>
												/>
												No
											</label>
										</td>
									</tr>
									<tr>
										<td colspan="2" >
											Please provide indicate the goods/servies involved
										</td>
										<td colspan="3">
											<textarea rows="2" cols="2" class="form-control" name="SANCTIONGOODSSERVICE" id="SANCTIONGOODSSERVICE${UNQID}" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"SANCTIONGOODSSERVICE")){ %> disabled <% } %>>${FORMDATA['SANCTIONGOODSSERVICE']}</textarea>
										</td>
									</tr>
									<tr>
										<td colspan="2" >
											Please explain the nature of business involved with the sanctions parties
										</td>
										<td colspan="3">
											<textarea rows="2" cols="2" class="form-control" name="SANCTIONINVOLVEMENT" id="SANCTIONINVOLVEMENT${UNQID}" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"SANCTIONINVOLVEMENT")){ %> disabled <% } %>
											<c:if test="${FORMDATA['DIRECTDEALINGWITHSANCTION'] ne 'YES'}">disabled</c:if>>${FORMDATA['SANCTIONINVOLVEMENT']}</textarea>
										</td>
									</tr>
									<tr>
										<td colspan="5"><strong>Additional Customer Information (For Customer subjected to EDD only)</strong> </td>
									</tr>
									<tr>
										<td colspan="2" rowspan="2" style="vertical-align: middle;">
											Source of Wealth (If others, please specify others)
										</td>
										<td colspan="3">
											<select class="form-control input-sm selectpicker" name="SOURCEOFWEALTH" id="SOURCEOFWEALTH${UNQID}" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"SOURCEOFWEALTH")){ %> disabled <% } %>>
												<option value="">Select One</option>
												<option value="Salary" <c:if test="${FORMDATA['SOURCEOFFUND'] eq 'Salary'}">selected="selected"</c:if>>Salary</option>
												<option value="Business proceeds" <c:if test="${FORMDATA['SOURCEOFFUND'] eq 'Business proceeds'}">selected="selected"</c:if>>Business proceeds</option>
												<option value="Investments" <c:if test="${FORMDATA['SOURCEOFFUND'] eq 'Investments'}">selected="selected"</c:if>>Investments</option>
												<option value="Others" <c:if test="${FORMDATA['SOURCEOFFUND'] eq 'Others'}">selected="selected"</c:if>>Others</option>
											</select>
										</td>
									</tr>
									<tr>
										<td colspan="5">
											<textarea rows="2" cols="2" class="form-control" name="OTHERSOURCEOFWEALTH" id="OTHERSOURCEOFWEALTH${UNQID}" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"OTHERSOURCEOFWEALTH")){ %> disabled <% } %>
											<c:if test="${FORMDATA['DIRECTDEALINGWITHSANCTION'] ne 'YES'}">disabled</c:if>>${FORMDATA['OTHERSOURCEOFWEALTH']}</textarea>
										</td>
									</tr>
									<tr>
										<td colspan="5"><strong>Additional Information</strong> </td>
									</tr>
									<tr>
										<td colspan="5">
											<textarea rows="2" cols="2" class="form-control" name="ADDITIONALINFORMATION" id="ADDITIONALINFORMATION${UNQID}" <% if(CDDDisabledFieldsMap.isFieldDisabled(prefix+"ADDITIONALINFORMATION")){ %> disabled <% } %>
											<c:if test="${FORMDATA['DIRECTDEALINGWITHSANCTION'] ne 'YES'}">disabled</c:if>>${FORMDATA['ADDITIONALINFORMATION']}</textarea>
										</td>
									</tr>
									<tr>
										<td colspan="5" style="text-align: right;">
											<c:if test="${(FORMDATA['STATUS'] eq 'BPA-P' && CURRENTROLE eq 'ROLE_BPAMAKER') || (FORMDATA['STATUS'] eq 'BPD-P' && CURRENTROLE eq 'ROLE_BPDMAKER')}">
												<button type="button" class="btn btn-success btn-sm saveDraftCDDForm" id="saveDraftCDDForm4${UNQID}">Save Draft</button>
												<button type="button" class="btn btn-success btn-sm saveCDDForm" id="saveCDDForm4${UNQID}">Save</button>
											</c:if>
											<button type="button" class="btn btn-warning btn-sm" id="moveToRiskRating${UNQID}">Risk Rating >></button>
										</td>
									</tr>
								</tbody>
							</table>
							</form>
						</div>
						<div role="tabpanel" class="tab-pane" id="riskRating">
							<form action="javascript:void(0)" method="POST" id="searchMasterForm3${UNQID}">
							<table class="table table-bordered table-striped" style="margin-bottom: 0px;">
								<tbody>
									<tr>
										<td width="15%">
											Full Name of Customer
										</td>
										<td width="85%" colspan="4">
											<input type="text" class="form-control input-sm" readonly="readonly" name="RISKRATINGCUSTOMERNAME" id="RISKRATINGCUSTOMERNAME${UNQID}" value="${FORMDATA['CUSTOMERNAME']}"/>
										</td>
									</tr>
									<tr>
										<td width="15%">Relationship Manager</td>
										<td width="33%">
											<input type="text" class="form-control input-sm" readonly="readonly" name="RISKRATINGRELATIONSHIPMANAGER" id="RISKRATINGRELATIONSHIPMANAGER${UNQID}" value="${FORMDATA['RELATIONSHIPMANAGER']}"/>
										</td>
										<td width="4%">&nbsp;</td>
										<td width="15%">Department-In-Charge</td>
										<td width="33%">
											<input type="text" class="form-control input-sm" readonly="readonly" name="RISKRATINGDEPTINCHARGE" id="RISKRATINGDEPTINCHARGE${UNQID}" value="${FORMDATA['DEPTINCHARGE']}"/>
										</td>
									</tr>
									<tr>
										<td colspan="5"><strong style="font-size: 20px;">Part 1 - Risk Factors</strong></td>
									</tr>
									<tr>
										<td colspan="5"><strong>1. Customer Risk - Industry / Occupation Type</strong></td>
									</tr>
									<tr>
										<td colspan="2" rowspan="2" style="vertical-align: middle;">
											Please select the option that best describes the Customer's Occupation. Refer to Branch Complianced Team,
											if unable to determine Occupation Type. For Others Occupation Type, please specify
										</td>
										<td colspan="2">
											Occupation Type
										</td>
										<td colspan="1">
											<input type="text" class="form-control input-sm" readonly="readonly" name="INDUSTRYTYPERISKRATING_DESC" id="INDUSTRYTYPERISKRATING_DESC${UNQID}" value="${FORMDATA['INDUSTRYTYPERISKRATING_DESC']}"/>
										</td>
									</tr>
									<tr>
										<td colspan="2">
											Risk Rating
										</td>
										<td colspan="1">
											<input type="text" class="form-control input-sm"  readonly="readonly" name="INDUSTRYTYPERISKRATING_VALUE" id="INDUSTRYTYPERISKRATING_VALUE${UNQID}" value="${FORMDATA['INDUSTRYTYPERISKRATING_VALUE']}"/>
											<input type="hidden" name="INDUSTRYTYPERISKRATING" id="INDUSTRYTYPERISKRATING${UNQID}" value="${FORMDATA['INDUSTRYTYPERISKRATING']}">
										</td>
									</tr>
									<tr>
										<td colspan="5"><strong>2. Geographic Risk</strong></td>
									</tr>
									<tr>
										<td colspan="2" rowspan="2" style="vertical-align: middle;">
											Country of Citizenship
										</td>
										<td colspan="2">
											Country
										</td>
										<td colspan="1">
											<input type="text" class="form-control input-sm" readonly="readonly" name="PRINCICOUNTRYRISKRATING_DESC" id="PRINCICOUNTRYRISKRATING_DESC${UNQID}" value="${FORMDATA['PRINCICOUNTRYRISKRATING_DESC']}"/>
										</td>
									</tr>
									<tr>
										<td colspan="2">
											Risk Rating
										</td>
										<td colspan="1">
											<input type="text" class="form-control input-sm"  readonly="readonly" name="PRINCICOUNTRYRISKRATING_VALUE" id="PRINCICOUNTRYRISKRATING_VALUE${UNQID}" value="${FORMDATA['PRINCICOUNTRYRISKRATING_VALUE']}"/>
											<input type="hidden" name="PRINCICOUNTRYRISKRATING" id="PRINCICOUNTRYRISKRATING${UNQID}" value="${FORMDATA['PRINCICOUNTRYRISKRATING']}">
										</td>
									</tr>
									<tr>
										<td colspan="2" rowspan="2" style="vertical-align: middle;">
											Country of Residence / Domicile
										</td>
										<td colspan="2">
											Country
										</td>
										<td colspan="1">
											<input type="text" class="form-control input-sm" readonly="readonly" name="INCROPCOUNTRYRISKRATING_DESC" id="INCROPCOUNTRYRISKRATING_DESC${UNQID}" value="${FORMDATA['INCROPCOUNTRYRISKRATING_DESC']}"/>
										</td>
									</tr>
									<tr>
										<td colspan="2">
											Risk Rating
										</td>
										<td colspan="1">
											<input type="text" class="form-control input-sm"  readonly="readonly" name="INCROPCOUNTRYRISKRATING_VALUE" id="INCROPCOUNTRYRISKRATING_VALUE${UNQID}" value="${FORMDATA['INCROPCOUNTRYRISKRATING_VALUE']}"/>
											<input type="hidden" name="INCROPCOUNTRYRISKRATING" id="INCROPCOUNTRYRISKRATING${UNQID}" value="${FORMDATA['INCROPCOUNTRYRISKRATING']}">
										</td>									
									</tr>
									<tr>
										<td colspan="4" >
											Overall Geographic Risk
										</td>
										<td colspan="1">
											<input type="text" class="form-control input-sm"  readonly="readonly" name="GEOGRAPHICRISKRATING_VALUE" id="GEOGRAPHICRISKRATING_VALUE${UNQID}" value="${FORMDATA['GEOGRAPHICRISKRATING_VALUE']}"/>
											<input type="hidden" name="GEOGRAPHICRISKRATING" id="GEOGRAPHICRISKRATING${UNQID}" value="${FORMDATA['GEOGRAPHICRISKRATING']}">
										</td>
									</tr>
									<tr>
										<td colspan="2" rowspan="2" style="vertical-align: middle;">
											Economic Sanctions Questionnaire
										</td>
										<td colspan="2">
											Is the Customer's a Citizen or Resides in a Country that is subjected to economic sanctions?<br/>
											If Yes, refer immediately to Branch Compliance Team.<br/>
											<br/>
											Countries subjected to economic sanctions include : Democratic People's Republic of Korea,
											Sudan, Iran (Islamic Republic of), Cuba and Syrian Arab Republic
										</td>
										<td colspan="1" style="vertical-align: middle;">
											<label class="btn btn-outline btn-primary btn-sm radio-inline" for="ECONOMICSANCTIONS_Y${UNQID}">
												<input type="radio" id="ECONOMICSANCTIONS_Y${UNQID}"  name="ECONOMICSANCTIONS" value="YES"
												<c:if test="${FORMDATA['ECONOMICSANCTIONS'] eq 'YES'}">checked="checked"</c:if>
												/>
												Yes
											</label>
											<label class="btn btn-outline btn-primary btn-sm radio-inline" for="ECONOMICSANCTIONS_N${UNQID}">
												<input type="radio" id="ECONOMICSANCTIONS_N${UNQID}"  name="ECONOMICSANCTIONS" value="NO"
												<c:if test="${FORMDATA['ECONOMICSANCTIONS'] eq 'NO'}">checked="checked"</c:if>
												/>
												No
											</label>
										</td>
									</tr>
									<tr>
										<td colspan="2" >
											Name of Jurisdiction
										</td>
										<td colspan="1">
											<input type="text" class="form-control input-sm" name="SANCTIONJURISDICTION" id="SANCTIONJURISDICTION${UNQID}" value="${FORMDATA['SANCTIONJURISDICTION']}">
										</td>
									</tr>
									<tr>
										<td colspan="5"><strong>3. Product and Service Risk</strong></td>
									</tr>
									<tr>
										<td colspan="2">Selected Products and Services</td>
										<td colspan="3">
											<input type="text" class="form-control input-sm" readonly="readonly" name="PRODUCTRISKRATING_DESC" id="PRODUCTRISKRATING_DESC${UNQID}" value="${FORMDATA['PRODUCTRISKRATING_DESC']}">
										</td>
									</tr>
									<tr>
										<td colspan="2">Overall Product Risk</td>
										<td colspan="3">
											<input type="text" class="form-control input-sm"  readonly="readonly" name="PRODUCTRISKRATING_VALUE" id="PRODUCTRISKRATING_VALUE${UNQID}" value="${FORMDATA['PRODUCTRISKRATING_VALUE']}"/>
											<input type="hidden" name="PRODUCTRISKRATING" id="PRODUCTRISKRATING${UNQID}" value="${FORMDATA['PRODUCTRISKRATING']}">
										</td>
									</tr>
									<tr>
										<td colspan="5"><strong>4. Channel Risk</strong></td>
									</tr>
									<tr>
										<td colspan="2">Select All Channels to be provided</td>
										<td colspan="3">
											<label style="margin-bottom: 8px" class="btn btn-outline btn-primary btn-sm checkbox-inline" for="RISKRATINGCHANNEL_1${UNQID}">
												<input type="checkbox" id="RISKRATINGCHANNEL_1${UNQID}"  name="RISKRATINGCHANNEL_1" value="YES" riskRating="Low"
												<c:if test="${FORMDATA['RISKRATINGCHANNEL_1'] eq 'YES'}">checked="checked"</c:if>
												/>
												Face-to-face interaction with customer
											</label>
											<br/>
											<label style="margin-bottom: 8px" class="btn btn-outline btn-primary btn-sm checkbox-inline" for="RISKRATINGCHANNEL_2${UNQID}">
												<input type="checkbox" id="RISKRATINGCHANNEL_2${UNQID}"  name="RISKRATINGCHANNEL_2" value="YES" riskRating="High"
												<c:if test="${FORMDATA['RISKRATINGCHANNEL_2'] eq 'YES'}">checked="checked"</c:if>
												/>
												No face-to-face interaction with customer
											</label>
											<br/>
											<label style="margin-bottom: 8px" class="btn btn-outline btn-primary btn-sm checkbox-inline" for="RISKRATINGCHANNEL_3${UNQID}">
												<input type="checkbox" id="RISKRATINGCHANNEL_3${UNQID}"  name="RISKRATINGCHANNEL_3" value="YES" riskRating="High"
												<c:if test="${FORMDATA['RISKRATINGCHANNEL_3'] eq 'YES'}">checked="checked"</c:if>
												/>
												<!--Third party (e.g. Power of Attorney, agent, broker or intermediary)-->
												Not applicable
											</label>
											<br/>
											<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="RISKRATINGCHANNEL_4${UNQID}">
												<input type="checkbox" id="RISKRATINGCHANNEL_4${UNQID}"  name="RISKRATINGCHANNEL_4" value="YES" riskRating="High"
												<c:if test="${FORMDATA['RISKRATINGCHANNEL_4'] eq 'YES'}">checked="checked"</c:if>
												/>
												Internet Banking (e.g. MGeB)
											</label>
										</td>
									</tr>
									<tr>
										<td colspan="2">Overall Channel Risk</td>
										<td colspan="3">
											<input type="text" class="form-control input-sm"  readonly="readonly" name="CHANNELRISKRATING_VALUE" id="CHANNELRISKRATING_VALUE${UNQID}" value="${FORMDATA['CHANNELRISKRATING_VALUE']}"/>
											<input type="hidden" name="CHANNELRISKRATING" id="CHANNELRISKRATING${UNQID}" value="${FORMDATA['CHANNELRISKRATING']}">
										</td>
									</tr>
									<tr>
										<td colspan="5"><strong>5. System Generated Risk Rating</strong></td>
									</tr>
									<tr>
										<td colspan="2">System Generated Risk Rating</td>
										<td>
											<button type="button" class="btn btn-primary btn-sm" id="calculateCDDRisk${UNQID}">Calculate</button>
										</td>
										<td colspan="2">
											<input type="text" class="form-control input-sm"  readonly="readonly" 
											name="SYSTEMRISKRATING" id="SYSTEMRISKRATING${UNQID}" value="${FORMDATA['SYSTEMRISKRATING']}"/>
										</td>
									</tr>
									<tr>
										<td colspan="5"><strong style="font-size: 20px;">Part 2 - Other Risk Factors</strong></td>
									</tr>
									<tr>
										<td colspan="5"><strong>1. Characteristics</strong></td>
									</tr>
									<tr>
										<td colspan="5" style="padding-left: 15px;">
											<label style="margin-bottom: 8px" class="btn btn-outline btn-primary btn-sm checkbox-inline" for="RR_CHARACTERISTICS_1${UNQID}">
												<input type="checkbox" id="RR_CHARACTERISTICS_1${UNQID}"  name="RR_CHARACTERISTICS_1" value="YES"
												<c:if test="${FORMDATA['RR_CHARACTERISTICS_1'] eq 'YES'}">checked="checked"</c:if>
												/>
												Customers who are PEPs or where Related Parties are PEPs
											</label>
											<br/>
											<label style="margin-bottom: 8px" class="btn btn-outline btn-primary btn-sm checkbox-inline" for="RR_CHARACTERISTICS_2${UNQID}">
												<input type="checkbox" id="RR_CHARACTERISTICS_2${UNQID}"  name="RR_CHARACTERISTICS_2" value="YES"
												<c:if test="${FORMDATA['RR_CHARACTERISTICS_2'] eq 'YES'}">checked="checked"</c:if>
												/>
												Adverse News relating to customer and/or connected parties
											</label>
											<br/>
											<label style="margin-bottom: 8px" class="btn btn-outline btn-primary btn-sm checkbox-inline" for="RR_CHARACTERISTICS_3${UNQID}">
												<input type="checkbox" id="RR_CHARACTERISTICS_3${UNQID}"  name="RR_CHARACTERISTICS_3" value="YES"
												<c:if test="${FORMDATA['RR_CHARACTERISTICS_3'] eq 'YES'}">checked="checked"</c:if>
												/>
												Customers who are categorized as Anti-Social Element or problem Customers
											</label>
											<br/>
											<label style="margin-bottom: 8px" class="btn btn-outline btn-primary btn-sm checkbox-inline" for="RR_CHARACTERISTICS_4${UNQID}">
												<input type="checkbox" id="RR_CHARACTERISTICS_4${UNQID}"  name="RR_CHARACTERISTICS_4" value="YES"
												<c:if test="${FORMDATA['RR_CHARACTERISTICS_4'] eq 'YES'}">checked="checked"</c:if>
												/>
												Customers who are known to have been involved in illicit use of account
											</label>
											<br/>
											<label style="margin-bottom: 8px" class="btn btn-outline btn-primary btn-sm checkbox-inline" for="RR_CHARACTERISTICS_5${UNQID}">
												<input type="checkbox" id="RR_CHARACTERISTICS_5${UNQID}"  name="RR_CHARACTERISTICS_5" value="YES"
												<c:if test="${FORMDATA['RR_CHARACTERISTICS_5'] eq 'YES'}">checked="checked"</c:if>
												/>
												Parties subject to economic sanctions such as freezing of assets ("Sanctions Targets")
											</label>
											<br/>
											<label style="margin-bottom: 8px" class="btn btn-outline btn-primary btn-sm checkbox-inline" for="RR_CHARACTERISTICS_6${UNQID}">
												<input type="checkbox" id="RR_CHARACTERISTICS_6${UNQID}"  name="RR_CHARACTERISTICS_6" value="YES"
												<c:if test="${FORMDATA['RR_CHARACTERISTICS_6'] eq 'YES'}">checked="checked"</c:if>
												/>
												Customers who has direct dealings with sanctioned countries or parties
											</label>
											<br/>
											<label style="margin-bottom: 8px" class="btn btn-outline btn-primary btn-sm checkbox-inline" for="RR_CHARACTERISTICS_7${UNQID}">
												<input type="checkbox" id="RR_CHARACTERISTICS_7${UNQID}"  name="RR_CHARACTERISTICS_7" value="YES"
												<c:if test="${FORMDATA['RR_CHARACTERISTICS_7'] eq 'YES'}">checked="checked"</c:if>
												/>
												None of the above
											</label>
										</td>
									</tr>
									<tr>
										<td colspan="5"><strong style="font-size: 20px;">Part 3 - Final Risk Rating</strong></td>
									</tr>
									<tr>
										<td width="15%">
											Provisional Risk Rating
										</td>
										<td width="33%">
											<input type="text" readonly="readonly" class="form-control input-sm" name="PROVISIONALRISKRATING" id="PROVISIONALRISKRATING${UNQID}" value="${FORMDATA['PROVISIONALRISKRATING']}">
										</td>
										<td>&nbsp;</td>
										<td width="15%">
											Final Risk Rating
										</td>
										<td width="33%">
											<select class="form-control input-sm selectpicker" name="FINALRISKRATING" id="FINALRISKRATING${UNQID}">
												<option value="1 - Low (Simplified)" <c:if test="${FORMDATA['FINALRISKRATING'] eq '1 - Low (Simplified)'}">selected="selected"</c:if> >1 - Low (Simplified)</option>
												<option value="2 - Low (Simplified)" <c:if test="${FORMDATA['FINALRISKRATING'] eq '2 - Low (Simplified)'}">selected="selected"</c:if>>2 - Low (Simplified)</option>
												<option value="3 - Medium (Standard)" <c:if test="${FORMDATA['FINALRISKRATING'] eq '3 - Medium (Standard)'}">selected="selected"</c:if>>3 - Medium (Standard)</option>
												<option value="4 - High (Enhanced)" <c:if test="${FORMDATA['FINALRISKRATING'] eq '4 - High (Enhanced)'}">selected="selected"</c:if>>4 - High (Enhanced)</option>
												<option value="5 - High (Enhanced)" <c:if test="${FORMDATA['FINALRISKRATING'] eq '5 - High (Enhanced)'}">selected="selected"</c:if>>5 - High (Enhanced)</option>
											</select>
										</td>
									</tr>
									<tr>
										<td>
											Reason(s) for Deviations between Provisional and Final Risk Rating
										</td>
										<td colspan="4">
											<textarea rows="2" cols="2" class="form-control" name="RISKRATINGREASON" id="RISKRATINGREASON${UNQID}">${FORMDATA['RISKRATINGREASON']}</textarea>
										</td>
									</tr>
									<c:if test="${(FORMDATA['STATUS'] eq 'BPA-P' && CURRENTROLE eq 'ROLE_BPAMAKER') || (FORMDATA['STATUS'] eq 'BPD-P' && CURRENTROLE eq 'ROLE_BPDMAKER')}">
										<tr>
											<td colspan="5" style="text-align: right;">
												<button type="button" class="btn btn-success btn-sm saveDraftCDDForm" id="saveDraftCDDForm5${UNQID}">Save Draft</button>
												<button type="button" class="btn btn-success btn-sm saveCDDForm" id="saveCDDForm5${UNQID}">Save</button>
											</td>
										</tr>
									</c:if>
								</tbody>
							</table>
							</form>
						</div>
						<div role="tabpanel" class="tab-pane" id="checkList">
							<form action="javascript:void(0)" method="POST" id="checkListForm${UNQID}">
							<input type="hidden" name="COMPASSREFERENCENO" id="COMPASSREFERENCENO1${UNQID}" value="${COMPASSREFERENCENO}"/>
							<input type="hidden" name="LINENO" id="LINENO1${UNQID}" value="${LINENO}"/>
							<table class="table table-bordered table-striped checkListTable" id="checkListTable${UNQID}" style="margin-bottom: 0px;">
								<tr>
									<th width="5%">SR NO.</th>
									<th width="50%">Documents</th>
									<th width="15%" class="chkListCheck">Check</th>
									<th width="15%" class="chkListApprove">Approve</th>
									<th width="15%">Mandaroty / Provisional</th>
								</tr>
								<tr>
									<td>1</td>
									<td>
										<strong>a) PAN card</strong><br/>
										Copy of the PAN card.
									</td>
									<td class="chkListCheck">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_PANCARD_CHECK${UNQID}">
											<input type="checkbox" id="CHKLIST_PANCARD_CHECK${UNQID}"  name="CHKLIST_PANCARD_CHECK" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_PANCARD_CHECK'] eq 'Y'}">checked="checked"</c:if>
												<c:choose><c:when test="${(FORMDATA['STATUS'] ne 'BPA-P') &&  (CURRENTROLE ne 'ROLE_BPAMAKER') ||
															  (FORMDATA['STATUS'] ne 'BPD-P') &&  (CURRENTROLE ne 'ROLE_BPDMAKER')}">
												</c:when><c:otherwise>disabled="disabled"</c:otherwise></c:choose>
											/>
											Check
										</label>
									</td>
									<td class="chkListApprove">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_PANCARD_APPROVE${UNQID}">
											<input type="checkbox" id="CHKLIST_PANCARD_APPROVE${UNQID}"  name="CHKLIST_PANCARD_APPROVE" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_PANCARD_APPROVE'] eq 'Y'}">checked="checked"</c:if>
												<c:if test="${(FORMDATA['STATUS'] ne 'BPA-A') &&  (CURRENTROLE ne 'ROLE_BPACHECKER')}">
													disabled="disabled"
												</c:if>
											/>
											Approve
										</label>
									</td>
									<td>
										Mandatory
									</td>
								</tr>
								<tr>
									<td colspan="5" style="background-color: #BBB">Check List for BANK STAFF<strong></strong></td>
								</tr>
								<tr>
									<td>2</td>
									<td>
										<strong>Letter from HRM department confirming the address of the staff</strong>
									</td>
									<td class="chkListCheck">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_HRMLETTER_CHECK${UNQID}">
											<input type="checkbox" id="CHKLIST_HRMLETTER_CHECK${UNQID}"  name="CHKLIST_HRMLETTER_CHECK" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_HRMLETTER_CHECK'] eq 'Y'}">checked="checked"</c:if>
												<c:choose><c:when test="${(FORMDATA['STATUS'] ne 'BPA-P') &&  (CURRENTROLE ne 'ROLE_BPAMAKER') ||
															  (FORMDATA['STATUS'] ne 'BPD-P') &&  (CURRENTROLE ne 'ROLE_BPDMAKER')}">
												</c:when><c:otherwise>disabled="disabled"</c:otherwise></c:choose>
											/>
											Check
										</label>
									</td>
									<td class="chkListApprove">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_HRMLETTER_APPROVE${UNQID}">
											<input type="checkbox" id="CHKLIST_HRMLETTER_APPROVE${UNQID}"  name="CHKLIST_HRMLETTER_APPROVE" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_HRMLETTER_APPROVE'] eq 'Y'}">checked="checked"</c:if>
												<c:if test="${(FORMDATA['STATUS'] ne 'BPA-A') &&  (CURRENTROLE ne 'ROLE_BPACHECKER')}">
													disabled="disabled"
												</c:if>
											/>
											Approve
										</label>
									</td>
									<td>
										Mandatory
									</td>
								</tr>
								<tr>
									<td colspan="5" style="background-color: #BBB">Identification Proof (Any one of the document listed below)<strong></strong></td>
								</tr>
								<tr>
									<td rowspan="8" style="vertical-align: middle;">3</td>
									<td>
										<strong>a) PAN card</strong><br/>
										-Mandatory for Indian Nationals. If not available, obtain allotment letter of PAN card.<br/>
										-For foreign nationals: Foreign individuals PAN may not be instited upon, instead any of the other
										document listed below at b, g & h be accpeted as the identification document
									</td>
									<td class="chkListCheck">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_ID_PANCARD_CHECK${UNQID}">
											<input type="checkbox" id="CHKLIST_ID_PANCARD_CHECK${UNQID}"  name="CHKLIST_ID_PANCARD_CHECK" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_ID_PANCARD_CHECK'] eq 'Y'}">checked="checked"</c:if>
												<c:choose><c:when test="${(FORMDATA['STATUS'] ne 'BPA-P') &&  (CURRENTROLE ne 'ROLE_BPAMAKER') ||
															  (FORMDATA['STATUS'] ne 'BPD-P') &&  (CURRENTROLE ne 'ROLE_BPDMAKER')}">
												</c:when><c:otherwise>disabled="disabled"</c:otherwise></c:choose>
											/>
											Check
										</label>
									</td>
									<td class="chkListApprove">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_ID_PANCARD_APPROVE${UNQID}">
											<input type="checkbox" id="CHKLIST_ID_PANCARD_APPROVE${UNQID}"  name="CHKLIST_ID_PANCARD_APPROVE" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_ID_PANCARD_APPROVE'] eq 'Y'}">checked="checked"</c:if>
												<c:if test="${(FORMDATA['STATUS'] ne 'BPA-A') &&  (CURRENTROLE ne 'ROLE_BPACHECKER')}">
													disabled="disabled"
												</c:if>
											/>
											Approve
										</label>
									</td>
									<td rowspan="8" style="vertical-align: middle;">
										Mandatory
									</td>
								</tr>
								<tr>
									<td>
										<strong>b) Passport Copy</strong> (At least 6 month validity left) 
									</td>
									<td class="chkListCheck">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_ID_PASSPORT_CHECK${UNQID}">
											<input type="checkbox" id="CHKLIST_ID_PASSPORT_CHECK${UNQID}"  name="CHKLIST_ID_PASSPORT_CHECK" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_ID_PASSPORT_CHECK'] eq 'Y'}">checked="checked"</c:if>
												<c:choose><c:when test="${(FORMDATA['STATUS'] ne 'BPA-P') &&  (CURRENTROLE ne 'ROLE_BPAMAKER') ||
															  (FORMDATA['STATUS'] ne 'BPD-P') &&  (CURRENTROLE ne 'ROLE_BPDMAKER')}">
												</c:when><c:otherwise>disabled="disabled"</c:otherwise></c:choose>
											/>
											Check
										</label>
									</td>
									<td class="chkListApprove">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_ID_PASSPORT_APPROVE${UNQID}">
											<input type="checkbox" id="CHKLIST_ID_PASSPORT_APPROVE${UNQID}"  name="CHKLIST_ID_PASSPORT_APPROVE" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_ID_PASSPORT_APPROVE'] eq 'Y'}">checked="checked"</c:if>
												<c:if test="${(FORMDATA['STATUS'] ne 'BPA-A') &&  (CURRENTROLE ne 'ROLE_BPACHECKER')}">
													disabled="disabled"
												</c:if>
											/>
											Approve
										</label>
									</td>
								</tr>
								<tr>
									<td>
										<strong>c) Driving Licence</strong> (At least 6 month validity left) 
									</td>
									<td class="chkListCheck">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CKHLIST_ID_DL_CHECK${UNQID}">
											<input type="checkbox" id="CKHLIST_ID_DL_CHECK${UNQID}"  name="CKHLIST_ID_DL_CHECK" value="Y"
												<c:if test="${CHECKLIST['CKHLIST_ID_DL_CHECK'] eq 'Y'}">checked="checked"</c:if>
												<c:choose><c:when test="${(FORMDATA['STATUS'] ne 'BPA-P') &&  (CURRENTROLE ne 'ROLE_BPAMAKER') ||
															  (FORMDATA['STATUS'] ne 'BPD-P') &&  (CURRENTROLE ne 'ROLE_BPDMAKER')}">
												</c:when><c:otherwise>disabled="disabled"</c:otherwise></c:choose>
											/>
											Check
										</label>
									</td>
									<td class="chkListApprove">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CKHLIST_ID_DL_APPROVE${UNQID}">
											<input type="checkbox" id="CKHLIST_ID_DL_APPROVE${UNQID}"  name="CKHLIST_ID_DL_APPROVE" value="Y"
												<c:if test="${CHECKLIST['CKHLIST_ID_DL_APPROVE'] eq 'Y'}">checked="checked"</c:if>
												<c:if test="${(FORMDATA['STATUS'] ne 'BPA-A') &&  (CURRENTROLE ne 'ROLE_BPACHECKER')}">
													disabled="disabled"
												</c:if>
											/>
											Approve
										</label>
									</td>
								</tr>
								<tr>
									<td>
										<strong>d) Voters Identity card</strong>
									</td>
									<td class="chkListCheck">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_ID_VIC_CHECKER${UNQID}">
											<input type="checkbox" id="CHKLIST_ID_VIC_CHECKER${UNQID}"  name="CHKLIST_ID_VIC_CHECKER" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_ID_VIC_CHECKER'] eq 'Y'}">checked="checked"</c:if>
												<c:choose><c:when test="${(FORMDATA['STATUS'] ne 'BPA-P') &&  (CURRENTROLE ne 'ROLE_BPAMAKER') ||
															  (FORMDATA['STATUS'] ne 'BPD-P') &&  (CURRENTROLE ne 'ROLE_BPDMAKER')}">
												</c:when><c:otherwise>disabled="disabled"</c:otherwise></c:choose>
											/>
											Check
										</label>
									</td>
									<td class="chkListApprove">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_ID_VIC_APPROVE${UNQID}">
											<input type="checkbox" id="CHKLIST_ID_VIC_APPROVE${UNQID}"  name="CHKLIST_ID_VIC_APPROVE" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_ID_VIC_APPROVE'] eq 'Y'}">checked="checked"</c:if>
												<c:if test="${(FORMDATA['STATUS'] ne 'BPA-A') &&  (CURRENTROLE ne 'ROLE_BPACHECKER')}">
													disabled="disabled"
												</c:if>
											/>
											Approve
										</label>
									</td>
								</tr>
								<tr>
									<td>
										<strong>e) Job card</strong> issued by National Rural Employment Authority of India (NREGA) duly
										signed by an officer of the State Government
									</td>
									<td class="chkListCheck">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_ID_JOB_CHECK${UNQID}">
											<input type="checkbox" id="CHKLIST_ID_JOB_CHECK${UNQID}"  name="CHKLIST_ID_JOB_CHECK" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_ID_JOB_CHECK'] eq 'Y'}">checked="checked"</c:if>
												<c:choose><c:when test="${(FORMDATA['STATUS'] ne 'BPA-P') &&  (CURRENTROLE ne 'ROLE_BPAMAKER') ||
															  (FORMDATA['STATUS'] ne 'BPD-P') &&  (CURRENTROLE ne 'ROLE_BPDMAKER')}">
												</c:when><c:otherwise>disabled="disabled"</c:otherwise></c:choose>
											/>
											Check
										</label>
									</td>
									<td class="chkListApprove">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_ID_JOB_APPROVE${UNQID}">
											<input type="checkbox" id="CHKLIST_ID_JOB_APPROVE${UNQID}"  name="CHKLIST_ID_JOB_APPROVE" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_ID_JOB_APPROVE'] eq 'Y'}">checked="checked"</c:if>
												<c:if test="${(FORMDATA['STATUS'] ne 'BPA-A') &&  (CURRENTROLE ne 'ROLE_BPACHECKER')}">
													disabled="disabled"
												</c:if>
											/>
											Approve
										</label>
									</td>
								</tr>
								<tr>
									<td>
										<strong>f) Letter issued by Unique Identification Authority of India (UIDAI) / Aadhaar card </strong> containing
										the details such as name, address and Aadhaar numner
									</td>
									<td class="chkListCheck">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_ID_UAIDI_CHECK${UNQID}">
											<input type="checkbox" id="CHKLIST_ID_UAIDI_CHECK${UNQID}"  name="CHKLIST_ID_UAIDI_CHECK" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_ID_UAIDI_CHECK'] eq 'Y'}">checked="checked"</c:if>
												<c:choose><c:when test="${(FORMDATA['STATUS'] ne 'BPA-P') &&  (CURRENTROLE ne 'ROLE_BPAMAKER') ||
															  (FORMDATA['STATUS'] ne 'BPD-P') &&  (CURRENTROLE ne 'ROLE_BPDMAKER')}">
												</c:when><c:otherwise>disabled="disabled"</c:otherwise></c:choose>
											/>
											Check
										</label>
									</td>
									<td class="chkListApprove">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_ID_UAIDI_APPROVE${UNQID}">
											<input type="checkbox" id="CHKLIST_ID_UAIDI_APPROVE${UNQID}"  name="CHKLIST_ID_UAIDI_APPROVE" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_ID_UAIDI_APPROVE'] eq 'Y'}">checked="checked"</c:if>
												<c:if test="${(FORMDATA['STATUS'] ne 'BPA-A') &&  (CURRENTROLE ne 'ROLE_BPACHECKER')}">
													disabled="disabled"
												</c:if>
											/>
											Approve
										</label>
									</td>
									<td>
								</tr>
								<tr>
									<td>
										<strong>g) Letter from a recognized public authority or public servant</strong> confirming the identity 
										of the customer to the satisfaction of the bank 
									</td>
									<td class="chkListCheck">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_ID_LTRPA_CHECK${UNQID}">
											<input type="checkbox" id="CHKLIST_ID_LTRPA_CHECK${UNQID}"  name="CHKLIST_ID_LTRPA_CHECK" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_ID_LTRPA_CHECK'] eq 'Y'}">checked="checked"</c:if>
												<c:choose><c:when test="${(FORMDATA['STATUS'] ne 'BPA-P') &&  (CURRENTROLE ne 'ROLE_BPAMAKER') ||
															  (FORMDATA['STATUS'] ne 'BPD-P') &&  (CURRENTROLE ne 'ROLE_BPDMAKER')}">
												</c:when><c:otherwise>disabled="disabled"</c:otherwise></c:choose>
											/>
											Check
										</label>
									</td>
									<td class="chkListApprove">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_ID_LTRPA_APPROVE${UNQID}">
											<input type="checkbox" id="CHKLIST_ID_LTRPA_APPROVE${UNQID}"  name="CHKLIST_ID_LTRPA_APPROVE" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_ID_LTRPA_APPROVE'] eq 'Y'}">checked="checked"</c:if>
												<c:if test="${(FORMDATA['STATUS'] ne 'BPA-A') &&  (CURRENTROLE ne 'ROLE_BPACHECKER')}">
													disabled="disabled"
												</c:if>
											/>
											Approve
										</label>
									</td>
								</tr>
								<tr>
									<td>
										<strong>h) Any Other ID card issued by a competent authority </strong>(please specify) <br/>
	`									If, there is a name change, due to marriage or otherwise, a marriage Certificateissued by the State Government or a Gazette notification, indicating such  a change of name
									</td>
									<td>
										<textarea rows="2" cols="2" class="form-control" name="CHKLIST_ID_OTHER_DETAILS" id="CHKLIST_ID_OTHER_DETAILS${UNQID}"
												<c:choose><c:when test="${(FORMDATA['STATUS'] ne 'BPA-P') &&  (CURRENTROLE ne 'ROLE_BPAMAKER') ||
															  (FORMDATA['STATUS'] ne 'BPD-P') &&  (CURRENTROLE ne 'ROLE_BPDMAKER')}">
												</c:when><c:otherwise>disabled="disabled"</c:otherwise></c:choose>
										>${CHECKLIST['CHKLIST_ID_OTHER_DETAILS']}</textarea>
									</td>
									<td class="chkListApprove">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_ID_OTHER_APPROVE${UNQID}">
											<input type="checkbox" id="CHKLIST_ID_OTHER_APPROVE${UNQID}"  name="CHKLIST_ID_OTHER_APPROVE" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_ID_OTHER_APPROVE'] eq 'Y'}">checked="checked"</c:if>
												<c:if test="${(FORMDATA['STATUS'] ne 'BPA-A') &&  (CURRENTROLE ne 'ROLE_BPACHECKER')}">
													disabled="disabled"
												</c:if>
											/>
											Approve
										</label>
									</td>
								</tr>
								<tr>
									<td colspan="5" style="background-color: #BBB">Address Proof (For Foreign Nationals working in India)<strong></strong></td>
								</tr>
								<tr>
									<td>4</td>
									<td>
										<strong>a) Copy of FRRO</strong>
									</td>
									<td class="chkListCheck">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_ADR_FRRO_CHECK${UNQID}">
											<input type="checkbox" id="CHKLIST_ADR_FRRO_CHECK${UNQID}"  name="CHKLIST_ADR_FRRO_CHECK" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_ID_LTRPA_CHECK'] eq 'Y'}">checked="checked"</c:if>
												<c:choose><c:when test="${(FORMDATA['STATUS'] ne 'BPA-P') &&  (CURRENTROLE ne 'ROLE_BPAMAKER') ||
															  (FORMDATA['STATUS'] ne 'BPD-P') &&  (CURRENTROLE ne 'ROLE_BPDMAKER')}">
												</c:when><c:otherwise>disabled="disabled"</c:otherwise></c:choose>
											/>
											Check
										</label>
									</td>
									<td class="chkListApprove">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_ADR_FRRO_APPROVE${UNQID}">
											<input type="checkbox" id="CHKLIST_ADR_FRRO_APPROVE${UNQID}"  name="CHKLIST_ADR_FRRO_APPROVE" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_ADR_FRRO_APPROVE'] eq 'Y'}">checked="checked"</c:if>
												<c:if test="${(FORMDATA['STATUS'] ne 'BPA-A') &&  (CURRENTROLE ne 'ROLE_BPACHECKER')}">
													disabled="disabled"
												</c:if>
											/>
											Approve
										</label>
									</td>
									<td>
										Mandatory
									</td>
								</tr>
								<tr>
									<td colspan="5" style="background-color: #BBB">Address Proof (For Residents -Any one of the document listed below)<strong></strong></td>
								</tr>
								<tr>
									<td rowspan="9" style="vertical-align: middle;">5</td>
									<td>
										<strong>a) Passport copy</strong> (At least 6 months validity left)
									</td>
									<td class="chkListCheck">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_ADR_PASSPORT_CHECK${UNQID}">
											<input type="checkbox" id="CHKLIST_ADR_PASSPORT_CHECK${UNQID}"  name="CHKLIST_ADR_PASSPORT_CHECK" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_ADR_PASSPORT_CHECK'] eq 'Y'}">checked="checked"</c:if>
												<c:choose><c:when test="${(FORMDATA['STATUS'] ne 'BPA-P') &&  (CURRENTROLE ne 'ROLE_BPAMAKER') ||
															  (FORMDATA['STATUS'] ne 'BPD-P') &&  (CURRENTROLE ne 'ROLE_BPDMAKER')}">
												</c:when><c:otherwise>disabled="disabled"</c:otherwise></c:choose>
											/>
											Check
										</label>
									</td>
									<td class="chkListApprove">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_ADR_PASSPORT_APPROVE${UNQID}">
											<input type="checkbox" id="CHKLIST_ADR_PASSPORT_APPROVE${UNQID}"  name="CHKLIST_ADR_PASSPORT_APPROVE" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_ADR_PASSPORT_APPROVE'] eq 'Y'}">checked="checked"</c:if>
												<c:if test="${(FORMDATA['STATUS'] ne 'BPA-A') &&  (CURRENTROLE ne 'ROLE_BPACHECKER')}">
													disabled="disabled"
												</c:if>
											/>
											Approve
										</label>
									</td>
									<td rowspan="9" style="vertical-align: middle;">
										Mandatory
									</td>
								</tr>
								<tr>
									<td>	
										<strong>b) Telephone - Landline Bill</strong> (should  not be more than 6 months old)
									</td>
									<td class="chkListCheck">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_ADR_TEL_CHECK${UNQID}">
											<input type="checkbox" id="CHKLIST_ADR_TEL_CHECK${UNQID}"  name="CHKLIST_ADR_TEL_CHECK" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_ADR_TEL_CHECK'] eq 'Y'}">checked="checked"</c:if>
												<c:choose><c:when test="${(FORMDATA['STATUS'] ne 'BPA-P') &&  (CURRENTROLE ne 'ROLE_BPAMAKER') ||
															  (FORMDATA['STATUS'] ne 'BPD-P') &&  (CURRENTROLE ne 'ROLE_BPDMAKER')}">
												</c:when><c:otherwise>disabled="disabled"</c:otherwise></c:choose>
											/>
											Check
										</label>
									</td>
									<td class="chkListApprove">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_ADR_TEL_APPROVE${UNQID}">
											<input type="checkbox" id="CHKLIST_ADR_TEL_APPROVE${UNQID}"  name="CHKLIST_ADR_TEL_APPROVE" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_ADR_TEL_APPROVE'] eq 'Y'}">checked="checked"</c:if>
												<c:if test="${(FORMDATA['STATUS'] ne 'BPA-A') &&  (CURRENTROLE ne 'ROLE_BPACHECKER')}">
													disabled="disabled"
												</c:if>
											/>
											Approve
										</label>
									</td>
								</tr>
								<tr>
									<td>
										<strong>c) Letter from Employer</strong> (subject to the satisfaction of the Bank)
									</td>
									<td class="chkListCheck">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_ADR_EMPLTR_CHECK${UNQID}">
											<input type="checkbox" id="CHKLIST_ADR_EMPLTR_CHECK${UNQID}"  name="CHKLIST_ADR_EMPLTR_CHECK" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_ADR_EMPLTR_CHECK'] eq 'Y'}">checked="checked"</c:if>
												<c:choose><c:when test="${(FORMDATA['STATUS'] ne 'BPA-P') &&  (CURRENTROLE ne 'ROLE_BPAMAKER') ||
															  (FORMDATA['STATUS'] ne 'BPD-P') &&  (CURRENTROLE ne 'ROLE_BPDMAKER')}">
												</c:when><c:otherwise>disabled="disabled"</c:otherwise></c:choose>
											/>
											Check
										</label>
									</td>
									<td class="chkListApprove">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_ADR_EMPLTR_APPROVE${UNQID}">
											<input type="checkbox" id="CHKLIST_ADR_EMPLTR_APPROVE${UNQID}"  name="CHKLIST_ADR_EMPLTR_APPROVE" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_ADR_EMPLTR_APPROVE'] eq 'Y'}">checked="checked"</c:if>
												<c:if test="${(FORMDATA['STATUS'] ne 'BPA-A') &&  (CURRENTROLE ne 'ROLE_BPACHECKER')}">
													disabled="disabled"
												</c:if>
											/>
											Approve
										</label>
									</td>
								</tr>
								<tr>
									<td>
										<strong>d) Lease/ License/ Rent Agreement</strong>
									</td>
									<td class="chkListCheck">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_ADR_LLRA_CHECK${UNQID}">
											<input type="checkbox" id="CHKLIST_ADR_LLRA_CHECK${UNQID}"  name="CHKLIST_ADR_LLRA_CHECK" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_ADR_LLRA_CHECK'] eq 'Y'}">checked="checked"</c:if>
												<c:choose><c:when test="${(FORMDATA['STATUS'] ne 'BPA-P') &&  (CURRENTROLE ne 'ROLE_BPAMAKER') ||
															  (FORMDATA['STATUS'] ne 'BPD-P') &&  (CURRENTROLE ne 'ROLE_BPDMAKER')}">
												</c:when><c:otherwise>disabled="disabled"</c:otherwise></c:choose>
											/>
											Check
										</label>
									</td>
									<td class="chkListApprove">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_ADR_LLRA_APPROVE${UNQID}">
											<input type="checkbox" id="CHKLIST_ADR_LLRA_APPROVE${UNQID}"  name="CHKLIST_ADR_LLRA_APPROVE" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_ADR_LLRA_APPROVE'] eq 'Y'}">checked="checked"</c:if>
												<c:if test="${(FORMDATA['STATUS'] ne 'BPA-A') &&  (CURRENTROLE ne 'ROLE_BPACHECKER')}">
													disabled="disabled"
												</c:if>
											/>
											Approve
										</label>
									</td>
								</tr>
								<tr>
									<td>
										<strong>e) Letter from a recognized public authority or public servant</strong> confirming the address 
										of the customer to the satisfaction of the bank
									</td>
									<td class="chkListCheck">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_ADR_LTRPA_CHECK${UNQID}">
											<input type="checkbox" id="CHKLIST_ADR_LTRPA_CHECK${UNQID}"  name="CHKLIST_ADR_LTRPA_CHECK" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_ADR_LTRPA_CHECK'] eq 'Y'}">checked="checked"</c:if>
												<c:choose><c:when test="${(FORMDATA['STATUS'] ne 'BPA-P') &&  (CURRENTROLE ne 'ROLE_BPAMAKER') ||
															  (FORMDATA['STATUS'] ne 'BPD-P') &&  (CURRENTROLE ne 'ROLE_BPDMAKER')}">
												</c:when><c:otherwise>disabled="disabled"</c:otherwise></c:choose>
											/>
											Check
										</label>
									</td>
									<td class="chkListApprove">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_ADR_LTRPA_APPROVE${UNQID}">
											<input type="checkbox" id="CHKLIST_ADR_LTRPA_APPROVE${UNQID}"  name="CHKLIST_ADR_LTRPA_APPROVE" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_ADR_LTRPA_APPROVE'] eq 'Y'}">checked="checked"</c:if>
												<c:if test="${(FORMDATA['STATUS'] ne 'BPA-A') &&  (CURRENTROLE ne 'ROLE_BPACHECKER')}">
													disabled="disabled"
												</c:if>
											/>
											Approve
										</label>
									</td>
								</tr>
								<tr>
									<td>
										<strong>f) Ration card</strong>
									</td>
									<td class="chkListCheck">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_ADR_RC_CHECK${UNQID}">
											<input type="checkbox" id="CHKLIST_ADR_RC_CHECK${UNQID}"  name="CHKLIST_ADR_RC_CHECK" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_ADR_RC_CHECK'] eq 'Y'}">checked="checked"</c:if>
												<c:choose><c:when test="${(FORMDATA['STATUS'] ne 'BPA-P') &&  (CURRENTROLE ne 'ROLE_BPAMAKER') ||
															  (FORMDATA['STATUS'] ne 'BPD-P') &&  (CURRENTROLE ne 'ROLE_BPDMAKER')}">
												</c:when><c:otherwise>disabled="disabled"</c:otherwise></c:choose>
											/>
											Check
										</label>
									</td>
									<td class="chkListApprove">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_ADR_RC_APPROVE${UNQID}">
											<input type="checkbox" id="CHKLIST_ADR_RC_APPROVE${UNQID}"  name="CHKLIST_ADR_RC_APPROVE" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_ADR_RC_APPROVE'] eq 'Y'}">checked="checked"</c:if>
												<c:if test="${(FORMDATA['STATUS'] ne 'BPA-A') &&  (CURRENTROLE ne 'ROLE_BPACHECKER')}">
													disabled="disabled"
												</c:if>
											/>
											Approve
										</label>
									</td>
								</tr>
								<tr>
									<td>
										<strong>g) Electricity Bill</strong> (should  not be more than 6 months old)
									</td>
									<td class="chkListCheck">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_ADR_EB_CHECK${UNQID}">
											<input type="checkbox" id="CHKLIST_ADR_EB_CHECK${UNQID}"  name="CHKLIST_ADR_EB_CHECK" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_ADR_EB_CHECK'] eq 'Y'}">checked="checked"</c:if>
												<c:choose><c:when test="${(FORMDATA['STATUS'] ne 'BPA-P') &&  (CURRENTROLE ne 'ROLE_BPAMAKER') ||
															  (FORMDATA['STATUS'] ne 'BPD-P') &&  (CURRENTROLE ne 'ROLE_BPDMAKER')}">
												</c:when><c:otherwise>disabled="disabled"</c:otherwise></c:choose>
											/>
											Check
										</label>
									</td>
									<td class="chkListApprove">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_ADR_EB_APPROVE${UNQID}">
											<input type="checkbox" id="CHKLIST_ADR_EB_APPROVE${UNQID}"  name="CHKLIST_ADR_EB_APPROVE" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_ADR_EB_APPROVE'] eq 'Y'}">checked="checked"</c:if>
												<c:if test="${(FORMDATA['STATUS'] ne 'BPA-A') &&  (CURRENTROLE ne 'ROLE_BPACHECKER')}">
													disabled="disabled"
												</c:if>
											/>
											Approve
										</label>
									</td>
								</tr>
								<tr>
									<td>
										<strong>h)</strong> For low risk customers (under simplified measures), bill of post-paid mobile phone or piped gas or water bill (not more than two months old) or Bank A/C Statement or letter issued by Embassy/Mission in India
									</td>
									<td class="chkListCheck">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_ADR_OTHERBILL_CHECK${UNQID}">
											<input type="checkbox" id="CHKLIST_ADR_OTHERBILL_CHECK${UNQID}"  name="CHKLIST_ADR_OTHERBILL_CHECK" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_ADR_OTHERBILL_CHECK'] eq 'Y'}">checked="checked"</c:if>
												<c:choose><c:when test="${(FORMDATA['STATUS'] ne 'BPA-P') &&  (CURRENTROLE ne 'ROLE_BPAMAKER') ||
															  (FORMDATA['STATUS'] ne 'BPD-P') &&  (CURRENTROLE ne 'ROLE_BPDMAKER')}">
												</c:when><c:otherwise>disabled="disabled"</c:otherwise></c:choose>
											/>
											Check
										</label>
									</td>
									<td class="chkListApprove">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_ADR_OTHERBILL_APPROVE${UNQID}">
											<input type="checkbox" id="CHKLIST_ADR_OTHERBILL_APPROVE${UNQID}"  name="CHKLIST_ADR_OTHERBILL_APPROVE" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_ADR_OTHERBILL_APPROVE'] eq 'Y'}">checked="checked"</c:if>
												<c:if test="${(FORMDATA['STATUS'] ne 'BPA-A') &&  (CURRENTROLE ne 'ROLE_BPACHECKER')}">
													disabled="disabled"
												</c:if>
											/>
											Approve
										</label>
									</td>
								</tr>
								<tr>
									<td>
										<strong>i)</strong> Any Other address proof issued by a competent authority (please specify)
									</td>
									<td>
										<textarea rows="2" cols="2" class="form-control" name="CHKLIST_ADR_OTHERPROOF_DETAILS" id="CHKLIST_ADR_OTHERPROOF_DETAILS${UNQID}"
											<c:choose><c:when test="${(FORMDATA['STATUS'] ne 'BPA-P') &&  (CURRENTROLE ne 'ROLE_BPAMAKER') ||
															  (FORMDATA['STATUS'] ne 'BPD-P') &&  (CURRENTROLE ne 'ROLE_BPDMAKER')}">
												</c:when><c:otherwise>disabled="disabled"</c:otherwise></c:choose>
										>${CHECKLIST['CHKLIST_ADR_OTHERPROOF_DETAILS']}</textarea>
									</td>
									<td class="chkListApprove">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_ADR_OTHERPROOF_APPROVE${UNQID}">
											<input type="checkbox" id="CHKLIST_ADR_OTHERPROOF_APPROVE${UNQID}"  name="CHKLIST_ADR_OTHERPROOF_APPROVE" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_ADR_OTHERPROOF_APPROVE'] eq 'Y'}">checked="checked"</c:if>
												<c:if test="${(FORMDATA['STATUS'] ne 'BPA-A') &&  (CURRENTROLE ne 'ROLE_BPACHECKER')}">
													disabled="disabled"
												</c:if>
											/>
											Approve
										</label>
									</td>
								</tr>
								<tr>
									<td colspan="5" style="background-color: #BBB">Other Requirements<strong></strong></td>
								</tr>
								<tr>
									<td>6</td>
									<td>
										<strong>No Objection Certificate (NOC) </strong>from Existing Bankers or provide 
										evidence of letter sent to banks for seeking NOC (where loan or any credit facility
										 is granted or proposed to be granted to the by other banks) 
										 [Applicable in case of current accounts only]. 
										 In all cases, ensure declaration is given by customers with whom they are banking
									</td>
									<td class="chkListCheck">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_OR_NOC_CHECK${UNQID}">
											<input type="checkbox" id="CHKLIST_OR_NOC_CHECK${UNQID}"  name="CHKLIST_OR_NOC_CHECK" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_OR_NOC_CHECK'] eq 'Y'}">checked="checked"</c:if>
												<c:choose><c:when test="${(FORMDATA['STATUS'] ne 'BPA-P') &&  (CURRENTROLE ne 'ROLE_BPAMAKER') ||
															  (FORMDATA['STATUS'] ne 'BPD-P') &&  (CURRENTROLE ne 'ROLE_BPDMAKER')}">
												</c:when><c:otherwise>disabled="disabled"</c:otherwise></c:choose>
											/>
											Check
										</label>
									</td>
									<td class="chkListApprove">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_OR_NOC_APPROVE${UNQID}">
											<input type="checkbox" id="CHKLIST_OR_NOC_APPROVE${UNQID}"  name="CHKLIST_OR_NOC_APPROVE" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_OR_NOC_APPROVE'] eq 'Y'}">checked="checked"</c:if>
												<c:if test="${(FORMDATA['STATUS'] ne 'BPA-A') &&  (CURRENTROLE ne 'ROLE_BPACHECKER')}">
													disabled="disabled"
												</c:if>
											/>
											Approve
										</label>
									</td>
									<td>
										Mandatory
									</td>
								</tr>
								<tr>
									<td>7</td>
									<td>
										<strong>Latest photographs</strong> of the Account Holder with self attestation
									</td>
									<td class="chkListCheck">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_OR_PHOTO_CHECK${UNQID}">
											<input type="checkbox" id="CHKLIST_OR_PHOTO_CHECK${UNQID}"  name="CHKLIST_OR_PHOTO_CHECK" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_OR_PHOTO_CHECK'] eq 'Y'}">checked="checked"</c:if>
												<c:choose><c:when test="${(FORMDATA['STATUS'] ne 'BPA-P') &&  (CURRENTROLE ne 'ROLE_BPAMAKER') ||
															  (FORMDATA['STATUS'] ne 'BPD-P') &&  (CURRENTROLE ne 'ROLE_BPDMAKER')}">
												</c:when><c:otherwise>disabled="disabled"</c:otherwise></c:choose>
											/>
											Check
										</label>
									</td>
									<td class="chkListApprove">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_OR_PHOTO_APPROVE${UNQID}">
											<input type="checkbox" id="CHKLIST_OR_PHOTO_APPROVE${UNQID}"  name="CHKLIST_OR_PHOTO_APPROVE" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_OR_PHOTO_APPROVE'] eq 'Y'}">checked="checked"</c:if>
												<c:if test="${(FORMDATA['STATUS'] ne 'BPA-A') && (CURRENTROLE ne 'ROLE_BPACHECKER')}">
													disabled="disabled"
												</c:if>
											/>
											Approve
										</label>
									</td>
									<td>
										Mandatory
									</td>
								</tr>
								<tr>
									<td rowspan="3" style="vertical-align: middle;">8</td>
									<td>
										<strong>a) Reserve Bank of India (RBI) mandated Account Opening Form</strong>
									</td>
									<td class="chkListCheck">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_OR_RBIAOF_CHECK${UNQID}">
											<input type="checkbox" id="CHKLIST_OR_RBIAOF_CHECK${UNQID}"  name="CHKLIST_OR_RBIAOF_CHECK" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_OR_RBIAOF_CHECK'] eq 'Y'}">checked="checked"</c:if>
												<c:choose><c:when test="${(FORMDATA['STATUS'] ne 'BPA-P') &&  (CURRENTROLE ne 'ROLE_BPAMAKER') ||
															  (FORMDATA['STATUS'] ne 'BPD-P') &&  (CURRENTROLE ne 'ROLE_BPDMAKER')}">
												</c:when><c:otherwise>disabled="disabled"</c:otherwise></c:choose>
											/>
											Check
										</label>
									</td>
									<td class="chkListApprove">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_OR_RBIAOF_APPROVE${UNQID}">
											<input type="checkbox" id="CHKLIST_OR_RBIAOF_APPROVE${UNQID}"  name="CHKLIST_OR_RBIAOF_APPROVE" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_OR_RBIAOF_APPROVE'] eq 'Y'}">checked="checked"</c:if>
												<c:if test="${(FORMDATA['STATUS'] ne 'BPA-A') && (CURRENTROLE ne 'ROLE_BPACHECKER')}">
													disabled="disabled"
												</c:if>
											/>
											Approve
										</label>
									</td>
									<td rowspan="3" style="vertical-align: middle;">
										Mandatory
									</td>
								</tr>
								<tr>
									<td>
										<strong>b) Mizuho Bank Supplementary Form</strong>
									</td>
									<td class="chkListCheck">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_OR_MHBKSF_CHECK${UNQID}">
											<input type="checkbox" id="CHKLIST_OR_MHBKSF_CHECK${UNQID}"  name="CHKLIST_OR_MHBKSF_CHECK" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_OR_MHBKSF_CHECK'] eq 'Y'}">checked="checked"</c:if>
												<c:choose><c:when test="${(FORMDATA['STATUS'] ne 'BPA-P') &&  (CURRENTROLE ne 'ROLE_BPAMAKER') ||
															  (FORMDATA['STATUS'] ne 'BPD-P') &&  (CURRENTROLE ne 'ROLE_BPDMAKER')}">
												</c:when><c:otherwise>disabled="disabled"</c:otherwise></c:choose>
											/>
											Check
										</label>
									</td>
									<td class="chkListApprove">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_OR_MHBKSF_APPROVE${UNQID}">
											<input type="checkbox" id="CHKLIST_OR_MHBKSF_APPROVE${UNQID}"  name="CHKLIST_OR_MHBKSF_APPROVE" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_OR_MHBKSF_APPROVE'] eq 'Y'}">checked="checked"</c:if>
												<c:if test="${(FORMDATA['STATUS'] ne 'BPA-A') && (CURRENTROLE ne 'ROLE_BPACHECKER')}">
													disabled="disabled"
												</c:if>
											/>
											Approve
										</label>
									</td>
								</tr>
								<tr>
									<td><strong>c)Terms and Conditions for Opening and Operating Account with Mizuho Bank, Ltd </strong></td>
									<td class="chkListCheck">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_OR_TCOAMH_CHECK${UNQID}">
											<input type="checkbox" id="CHKLIST_OR_TCOAMH_CHECK${UNQID}"  name="CHKLIST_OR_TCOAMH_CHECK" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_OR_TCOAMH_CHECK'] eq 'Y'}">checked="checked"</c:if>
												<c:choose><c:when test="${(FORMDATA['STATUS'] ne 'BPA-P') &&  (CURRENTROLE ne 'ROLE_BPAMAKER') ||
															  (FORMDATA['STATUS'] ne 'BPD-P') &&  (CURRENTROLE ne 'ROLE_BPDMAKER')}">
												</c:when><c:otherwise>disabled="disabled"</c:otherwise></c:choose>
											/>
											Check
										</label>
									</td>
									<td class="chkListApprove">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_OR_TCOAMH_APPROVE${UNQID}">
											<input type="checkbox" id="CHKLIST_OR_TCOAMH_APPROVE${UNQID}"  name="CHKLIST_OR_TCOAMH_APPROVE" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_OR_TCOAMH_APPROVE'] eq 'Y'}">checked="checked"</c:if>
												<c:if test="${(FORMDATA['STATUS'] ne 'BPA-A') && (CURRENTROLE ne 'ROLE_BPACHECKER')}">
													disabled="disabled"
												</c:if>
											/>
											Approve
										</label>
									</td>
								</tr>
								<tr>
									<td>9</td>
									<td>
										<strong>Specimen Signature card</strong>
									</td>
									<td class="chkListCheck">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_OR_SSC_CHECK${UNQID}">
											<input type="checkbox" id="CHKLIST_OR_SSC_CHECK${UNQID}"  name="CHKLIST_OR_SSC_CHECK" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_OR_SSC_CHECK'] eq 'Y'}">checked="checked"</c:if>
												<c:choose><c:when test="${(FORMDATA['STATUS'] ne 'BPA-P') &&  (CURRENTROLE ne 'ROLE_BPAMAKER') ||
															  (FORMDATA['STATUS'] ne 'BPD-P') &&  (CURRENTROLE ne 'ROLE_BPDMAKER')}">
												</c:when><c:otherwise>disabled="disabled"</c:otherwise></c:choose>
											/>
											Check
										</label>
									</td>
									<td class="chkListApprove">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_OR_SSC_APPROVE${UNQID}">
											<input type="checkbox" id="CHKLIST_OR_SSC_APPROVE${UNQID}"  name="CHKLIST_OR_SSC_APPROVE" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_OR_SSC_APPROVE'] eq 'Y'}">checked="checked"</c:if>
												<c:if test="${(FORMDATA['STATUS'] ne 'BPA-A') && (CURRENTROLE ne 'ROLE_BPACHECKER')}">
													disabled="disabled"
												</c:if>
											/>
											Approve
										</label>
									</td>
									<td>
										Mandatory
									</td>
								</tr>
								<tr>
									<td>10</td>
									<td>
										<strong>Nomination Form - DA1</strong>
									</td>
									<td class="chkListCheck">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_OR_NFDA1_CHECK${UNQID}">
											<input type="checkbox" id="CHKLIST_OR_NFDA1_CHECK${UNQID}"  name="CHKLIST_OR_NFDA1_CHECK" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_OR_NFDA1_CHECK'] eq 'Y'}">checked="checked"</c:if>
												<c:choose><c:when test="${(FORMDATA['STATUS'] ne 'BPA-P') &&  (CURRENTROLE ne 'ROLE_BPAMAKER') ||
															  (FORMDATA['STATUS'] ne 'BPD-P') &&  (CURRENTROLE ne 'ROLE_BPDMAKER')}">
												</c:when><c:otherwise>disabled="disabled"</c:otherwise></c:choose>
											/>
											Check
										</label>
									</td>
									<td class="chkListApprove">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_OR_NFDA1_APPROVE${UNQID}">
											<input type="checkbox" id="CHKLIST_OR_NFDA1_APPROVE${UNQID}"  name="CHKLIST_OR_NFDA1_APPROVE" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_OR_NFDA1_APPROVE'] eq 'Y'}">checked="checked"</c:if>
												<c:if test="${(FORMDATA['STATUS'] ne 'BPA-A') && (CURRENTROLE ne 'ROLE_BPACHECKER')}">
													disabled="disabled"
												</c:if>
											/>
											Approve
										</label>
									</td>
									<td>
										Mandatory
									</td>
								</tr>
								<tr>
									<td>11</td>
									<td>
										<strong>Cheque Book Requisition form</strong>
									</td>
									<td class="chkListCheck">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_OR_CHQBK_CHECK${UNQID}">
											<input type="checkbox" id="CHKLIST_OR_CHQBK_CHECK${UNQID}"  name="CHKLIST_OR_CHQBK_CHECK" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_OR_CHQBK_CHECK'] eq 'Y'}">checked="checked"</c:if>
												<c:choose><c:when test="${(FORMDATA['STATUS'] ne 'BPA-P') &&  (CURRENTROLE ne 'ROLE_BPAMAKER') ||
															  (FORMDATA['STATUS'] ne 'BPD-P') &&  (CURRENTROLE ne 'ROLE_BPDMAKER')}">
												</c:when><c:otherwise>disabled="disabled"</c:otherwise></c:choose>
											/>
											Check
										</label>
									</td>
									<td class="chkListApprove">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_OR_CHQBK_APPROVE${UNQID}">
											<input type="checkbox" id="CHKLIST_OR_CHQBK_APPROVE${UNQID}"  name="CHKLIST_OR_CHQBK_APPROVE" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_OR_CHQBK_APPROVE'] eq 'Y'}">checked="checked"</c:if>
												<c:if test="${(FORMDATA['STATUS'] ne 'BPA-A') && (CURRENTROLE ne 'ROLE_BPACHECKER')}">
													disabled="disabled"
												</c:if>
											/>
											Approve
										</label>
									</td>
									<td>
										Optional
									</td>
								</tr>
								<tr>
									<td>12</td>
									<td>
										<strong>FATCA and CRS declaration form & FAQ</strong>
									</td>
									<td class="chkListCheck">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_OR_FATCACRS_CHECK${UNQID}">
											<input type="checkbox" id="CHKLIST_OR_FATCACRS_CHECK${UNQID}"  name="CHKLIST_OR_FATCACRS_CHECK" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_OR_FATCACRS_CHECK'] eq 'Y'}">checked="checked"</c:if>
												<c:choose><c:when test="${(FORMDATA['STATUS'] ne 'BPA-P') &&  (CURRENTROLE ne 'ROLE_BPAMAKER') ||
															  (FORMDATA['STATUS'] ne 'BPD-P') &&  (CURRENTROLE ne 'ROLE_BPDMAKER')}">
												</c:when><c:otherwise>disabled="disabled"</c:otherwise></c:choose>
											/>
											Check
										</label>
									</td>
									<td class="chkListApprove">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_OR_FATCACRS_APPROVE${UNQID}">
											<input type="checkbox" id="CHKLIST_OR_FATCACRS_APPROVE${UNQID}"  name="CHKLIST_OR_FATCACRS_APPROVE" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_OR_FATCACRS_APPROVE'] eq 'Y'}">checked="checked"</c:if>
												<c:if test="${(FORMDATA['STATUS'] ne 'BPA-A') && (CURRENTROLE ne 'ROLE_BPACHECKER')}">
													disabled="disabled"
												</c:if>
											/>
											Approve
										</label>
									</td>
									<td>
										Mandatory
									</td>
								</tr>
								<tr>
									<td colspan="5" style="background-color: #BBB">Documents for Banks Use (Please do not send this list to the customer)<strong></strong></td>
								</tr>
								<tr>
									<td rowspan="9" style="vertical-align: middle;">13</td>
									<td>
										<strong>a) Provisional and Remittance Indemnity</strong>
									</td>
									<td class="chkListCheck">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_BNKUS_PRI_CHECK${UNQID}">
											<input type="checkbox" id="CHKLIST_BNKUS_PRI_CHECK${UNQID}"  name="CHKLIST_BNKUS_PRI_CHECK" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_BNKUS_PRI_CHECK'] eq 'Y'}">checked="checked"</c:if>
												<c:choose><c:when test="${(FORMDATA['STATUS'] ne 'BPA-P') &&  (CURRENTROLE ne 'ROLE_BPAMAKER') ||
															  (FORMDATA['STATUS'] ne 'BPD-P') &&  (CURRENTROLE ne 'ROLE_BPDMAKER')}">
												</c:when><c:otherwise>disabled="disabled"</c:otherwise></c:choose>
											/>
											Check
										</label>
									</td>
									<td class="chkListApprove">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_BNKUS_PRI_APPROVE${UNQID}">
											<input type="checkbox" id="CHKLIST_BNKUS_PRI_APPROVE${UNQID}"  name="CHKLIST_BNKUS_PRI_APPROVE" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_BNKUS_PRI_APPROVE'] eq 'Y'}">checked="checked"</c:if>
												<c:if test="${(FORMDATA['STATUS'] ne 'BPA-A') && (CURRENTROLE ne 'ROLE_BPACHECKER')}">
													disabled="disabled"
												</c:if>
											/>
											Approve
										</label>
									</td>
									<td>
										Optional
									</td>
								</tr>
								<tr>
									<td>
										<strong>b) Internal Kyogi and Form I - 159 (Head Office Format)</strong>
									</td>
									<td class="chkListCheck">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_BNKUS_IKF_CHECK${UNQID}">
											<input type="checkbox" id="CHKLIST_BNKUS_IKF_CHECK${UNQID}"  name="CHKLIST_BNKUS_IKF_CHECK" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_BNKUS_IKF_CHECK'] eq 'Y'}">checked="checked"</c:if>
												<c:choose><c:when test="${(FORMDATA['STATUS'] ne 'BPA-P') &&  (CURRENTROLE ne 'ROLE_BPAMAKER') ||
															  (FORMDATA['STATUS'] ne 'BPD-P') &&  (CURRENTROLE ne 'ROLE_BPDMAKER')}">
												</c:when><c:otherwise>disabled="disabled"</c:otherwise></c:choose>
											/>
											Check
										</label>
									</td>
									<td class="chkListApprove">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_BNKUS_IKF_APPROVE${UNQID}">
											<input type="checkbox" id="CHKLIST_BNKUS_IKF_APPROVE${UNQID}"  name="CHKLIST_BNKUS_IKF_APPROVE" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_BNKUS_IKF_APPROVE'] eq 'Y'}">checked="checked"</c:if>
												<c:if test="${(FORMDATA['STATUS'] ne 'BPA-A') && (CURRENTROLE ne 'ROLE_BPACHECKER')}">
													disabled="disabled"
												</c:if>
											/>
											Approve
										</label>
									</td>
									<td rowspan="4" style="vertical-align: middle;">
										Mandatory
									</td>
								</tr>
								<tr>
									<td>
										<strong>c) Risk Rating Sheet</strong>
									</td>
									<td class="chkListCheck">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_BNKUS_RRS_CHECK${UNQID}">
											<input type="checkbox" id="CHKLIST_BNKUS_RRS_CHECK${UNQID}"  name="CHKLIST_BNKUS_RRS_CHECK" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_BNKUS_RRS_CHECK'] eq 'Y'}">checked="checked"</c:if>
												<c:choose><c:when test="${(FORMDATA['STATUS'] ne 'BPA-P') &&  (CURRENTROLE ne 'ROLE_BPAMAKER') ||
															  (FORMDATA['STATUS'] ne 'BPD-P') &&  (CURRENTROLE ne 'ROLE_BPDMAKER')}">
												</c:when><c:otherwise>disabled="disabled"</c:otherwise></c:choose>
											/>
											Check
										</label>
									</td>
									<td class="chkListApprove">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_BNKUS_RRS_APPROVE${UNQID}">
											<input type="checkbox" id="CHKLIST_BNKUS_RRS_APPROVE${UNQID}"  name="CHKLIST_BNKUS_RRS_APPROVE" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_BNKUS_RRS_APPROVE'] eq 'Y'}">checked="checked"</c:if>
												<c:if test="${(FORMDATA['STATUS'] ne 'BPA-A') && (CURRENTROLE ne 'ROLE_BPACHECKER')}">
													disabled="disabled"
												</c:if>
											/>
											Approve
										</label>
									</td>
								</tr>
								<tr>
									<td>
										<strong>d) PEP check with documentary proof</strong>
									</td>
									<td class="chkListCheck">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_BNKUS_PEPCHK_CHECK${UNQID}">
											<input type="checkbox" id="CHKLIST_BNKUS_PEPCHK_CHECK${UNQID}"  name="CHKLIST_BNKUS_PEPCHK_CHECK" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_BNKUS_PEPCHK_CHECK'] eq 'Y'}">checked="checked"</c:if>
												<c:choose><c:when test="${(FORMDATA['STATUS'] ne 'BPA-P') &&  (CURRENTROLE ne 'ROLE_BPAMAKER') ||
															  (FORMDATA['STATUS'] ne 'BPD-P') &&  (CURRENTROLE ne 'ROLE_BPDMAKER')}">
												</c:when><c:otherwise>disabled="disabled"</c:otherwise></c:choose>
											/>
											Check
										</label>
									</td>
									<td class="chkListApprove">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_BNKUS_PEPCHK_APPROVE${UNQID}">
											<input type="checkbox" id="CHKLIST_BNKUS_PEPCHK_APPROVE${UNQID}"  name="CHKLIST_BNKUS_PEPCHK_APPROVE" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_BNKUS_PEPCHK_APPROVE'] eq 'Y'}">checked="checked"</c:if>
												<c:if test="${(FORMDATA['STATUS'] ne 'BPA-A') && (CURRENTROLE ne 'ROLE_BPACHECKER')}">
													disabled="disabled"
												</c:if>
											/>
											Approve
										</label>
									</td>
								</tr>
								<tr>
									<td>
										<strong>e) CAP Checklist</strong>
									</td>
									<td class="chkListCheck">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_BNKUS_CAPCHK_CHECK${UNQID}">
											<input type="checkbox" id="CHKLIST_BNKUS_CAPCHK_CHECK${UNQID}"  name="CHKLIST_BNKUS_CAPCHK_CHECK" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_BNKUS_CAPCHK_CHECK'] eq 'Y'}">checked="checked"</c:if>
												<c:choose><c:when test="${(FORMDATA['STATUS'] ne 'BPA-P') &&  (CURRENTROLE ne 'ROLE_BPAMAKER') ||
															  (FORMDATA['STATUS'] ne 'BPD-P') &&  (CURRENTROLE ne 'ROLE_BPDMAKER')}">
												</c:when><c:otherwise>disabled="disabled"</c:otherwise></c:choose>
											/>
											Check
										</label>
									</td>
									<td class="chkListApprove">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_BNKUS_CAPCHK_APPROVE${UNQID}">
											<input type="checkbox" id="CHKLIST_BNKUS_CAPCHK_APPROVE${UNQID}"  name="CHKLIST_BNKUS_CAPCHK_APPROVE" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_BNKUS_CAPCHK_APPROVE'] eq 'Y'}">checked="checked"</c:if>
												<c:if test="${(FORMDATA['STATUS'] ne 'BPA-A') && (CURRENTROLE ne 'ROLE_BPACHECKER')}">
													disabled="disabled"
												</c:if>
											/>
											Approve
										</label>
									</td>
								</tr>
								<tr>
									<td>
										<strong>f) FIEL Checklist</strong>
									</td>
									<td class="chkListCheck">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_BNKUS_FIELCHK_CHECK${UNQID}">
											<input type="checkbox" id="CHKLIST_BNKUS_FIELCHK_CHECK${UNQID}"  name="CHKLIST_BNKUS_FIELCHK_CHECK" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_BNKUS_FIELCHK_CHECK'] eq 'Y'}">checked="checked"</c:if>
												<c:choose><c:when test="${(FORMDATA['STATUS'] ne 'BPA-P') &&  (CURRENTROLE ne 'ROLE_BPAMAKER') ||
															  (FORMDATA['STATUS'] ne 'BPD-P') &&  (CURRENTROLE ne 'ROLE_BPDMAKER')}">
												</c:when><c:otherwise>disabled="disabled"</c:otherwise></c:choose>
											/>
											Check
										</label>
									</td>
									<td class="chkListApprove">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_BNKUS_FIELCHK_APPROVE${UNQID}">
											<input type="checkbox" id="CHKLIST_BNKUS_FIELCHK_APPROVE${UNQID}"  name="CHKLIST_BNKUS_FIELCHK_APPROVE" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_BNKUS_FIELCHK_APPROVE'] eq 'Y'}">checked="checked"</c:if>
												<c:if test="${(FORMDATA['STATUS'] ne 'BPA-A') && (CURRENTROLE ne 'ROLE_BPACHECKER')}">
													disabled="disabled"
												</c:if>
											/>
											Approve
										</label>
									</td>
									<td>
										<label class="btn btn-outline btn-primary btn-sm radio-inline" for="CHKLIST_BNKUS_FIELCHK_Y${UNQID}">
											<input type="radio" id="CHKLIST_BNKUS_FIELCHK_Y${UNQID}"  name="CHKLIST_BNKUS_FIELCHK" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_BNKUS_FIELCHK'] eq 'Y'}">checked="checked"</c:if>
												<c:choose><c:when test="${(FORMDATA['STATUS'] ne 'BPA-P') &&  (CURRENTROLE ne 'ROLE_BPAMAKER') ||
															  (FORMDATA['STATUS'] ne 'BPD-P') &&  (CURRENTROLE ne 'ROLE_BPDMAKER')}">
												</c:when><c:otherwise>disabled="disabled"</c:otherwise></c:choose>
											/>
											Applicable
										</label>
										<label class="btn btn-outline btn-primary btn-sm radio-inline" for="CHKLIST_BNKUS_FIELCHK_N${UNQID}">
											<input type="radio" id="CHKLIST_BNKUS_FIELCHK_N${UNQID}"  name="CHKLIST_BNKUS_FIELCHK" value="N"
												<c:if test="${CHECKLIST['CHKLIST_BNKUS_FIELCHK'] eq 'N'}">checked="checked"</c:if>
												<c:choose><c:when test="${(FORMDATA['STATUS'] ne 'BPA-P') &&  (CURRENTROLE ne 'ROLE_BPAMAKER') ||
															  (FORMDATA['STATUS'] ne 'BPD-P') &&  (CURRENTROLE ne 'ROLE_BPDMAKER')}">
												</c:when><c:otherwise>disabled="disabled"</c:otherwise></c:choose>
											/>
											Not Applicable
										</label>
									</td>
								</tr>
								<tr>
									<td>
										<strong>g) Anti-Social Element Check </strong>
									</td>
									<td class="chkListCheck">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_BNKUS_ASECHK_CHECK${UNQID}">
											<input type="checkbox" id="CHKLIST_BNKUS_ASECHK_CHECK${UNQID}"  name="CHKLIST_BNKUS_ASECHK_CHECK" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_BNKUS_ASECHK_CHECK'] eq 'Y'}">checked="checked"</c:if>
												<c:choose><c:when test="${(FORMDATA['STATUS'] ne 'BPA-P') &&  (CURRENTROLE ne 'ROLE_BPAMAKER') ||
															  (FORMDATA['STATUS'] ne 'BPD-P') &&  (CURRENTROLE ne 'ROLE_BPDMAKER')}">
												</c:when><c:otherwise>disabled="disabled"</c:otherwise></c:choose>
											/>
											Check
										</label>
									</td>
									<td class="chkListApprove">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_BNKUS_ASECHK_APPROVE${UNQID}">
											<input type="checkbox" id="CHKLIST_BNKUS_ASECHK_APPROVE${UNQID}"  name="CHKLIST_BNKUS_ASECHK_APPROVE" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_BNKUS_ASECHK_APPROVE'] eq 'Y'}">checked="checked"</c:if>
												<c:if test="${(FORMDATA['STATUS'] ne 'BPA-A') && (CURRENTROLE ne 'ROLE_BPACHECKER')}">
													disabled="disabled"
												</c:if>
											/>
											Approve
										</label>
									</td>
									<td>
										<label class="btn btn-outline btn-primary btn-sm radio-inline" for="CHKLIST_BNKUS_ASECHK_Y${UNQID}">
											<input type="radio" id="CHKLIST_BNKUS_ASECHK_Y${UNQID}"  name="CHKLIST_BNKUS_ASECHK" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_BNKUS_ASECHK'] eq 'Y'}">checked="checked"</c:if>
												<c:choose><c:when test="${(FORMDATA['STATUS'] ne 'BPA-P') &&  (CURRENTROLE ne 'ROLE_BPAMAKER') ||
															  (FORMDATA['STATUS'] ne 'BPD-P') &&  (CURRENTROLE ne 'ROLE_BPDMAKER')}">
												</c:when><c:otherwise>disabled="disabled"</c:otherwise></c:choose>
											/>
											Conducted
										</label>
										<label class="btn btn-outline btn-primary btn-sm radio-inline" for="CHKLIST_BNKUS_ASECHK_N${UNQID}">
											<input type="radio" id="CHKLIST_BNKUS_ASECHK_N${UNQID}"  name="CHKLIST_BNKUS_ASECHK" value="N"
												<c:if test="${CHECKLIST['CHKLIST_BNKUS_ASECHK'] eq 'N'}">checked="checked"</c:if>
												<c:choose><c:when test="${(FORMDATA['STATUS'] ne 'BPA-P') &&  (CURRENTROLE ne 'ROLE_BPAMAKER') ||
															  (FORMDATA['STATUS'] ne 'BPD-P') &&  (CURRENTROLE ne 'ROLE_BPDMAKER')}">
												</c:when><c:otherwise>disabled="disabled"</c:otherwise></c:choose>
											/>
											Not Applicable
										</label>
									</td>
								</tr>
								<tr>
									<td>
										<strong>h) PAN Verification (when available on record)</strong>
									</td>
									<td class="chkListCheck">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_BNKUS_PANCHK_CHECK${UNQID}">
											<input type="checkbox" id="CHKLIST_BNKUS_PANCHK_CHECK${UNQID}"  name="CHKLIST_BNKUS_PANCHK_CHECK" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_BNKUS_PANCHK_CHECK'] eq 'Y'}">checked="checked"</c:if>
												<c:choose><c:when test="${(FORMDATA['STATUS'] ne 'BPA-P') &&  (CURRENTROLE ne 'ROLE_BPAMAKER') ||
															  (FORMDATA['STATUS'] ne 'BPD-P') &&  (CURRENTROLE ne 'ROLE_BPDMAKER')}">
												</c:when><c:otherwise>disabled="disabled"</c:otherwise></c:choose>
											/>
											Check
										</label>
									</td>
									<td class="chkListApprove">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_BNKUS_PANCHK_APPROVE${UNQID}">
											<input type="checkbox" id="CHKLIST_BNKUS_PANCHK_APPROVE${UNQID}"  name="CHKLIST_BNKUS_PANCHK_APPROVE" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_BNKUS_PANCHK_APPROVE'] eq 'Y'}">checked="checked"</c:if>
												<c:if test="${(FORMDATA['STATUS'] ne 'BPA-A') && (CURRENTROLE ne 'ROLE_BPACHECKER')}">
													disabled="disabled"
												</c:if>
											/>
											Approve
										</label>
									</td>
									<td>
										Mandatory
									</td>
								</tr>
								<tr>
									<td>
										<strong>i) Name check against SLS system</strong>
									</td>
									<td class="chkListCheck">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_BNKUS_SLSCHK_CHECK${UNQID}">
											<input type="checkbox" id="CHKLIST_BNKUS_SLSCHK_CHECK${UNQID}"  name="CHKLIST_BNKUS_SLSCHK_CHECK" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_BNKUS_SLSCHK_CHECK'] eq 'Y'}">checked="checked"</c:if>
												<c:choose><c:when test="${(FORMDATA['STATUS'] ne 'BPA-P') &&  (CURRENTROLE ne 'ROLE_BPAMAKER') ||
															  (FORMDATA['STATUS'] ne 'BPD-P') &&  (CURRENTROLE ne 'ROLE_BPDMAKER')}">
												</c:when><c:otherwise>disabled="disabled"</c:otherwise></c:choose>
											/>
											Check
										</label>
									</td>
									<td class="chkListApprove">
										<label class="btn btn-outline btn-primary btn-sm checkbox-inline" for="CHKLIST_BNKUS_SLSCHK_APPROVE${UNQID}">
											<input type="checkbox" id="CHKLIST_BNKUS_SLSCHK_APPROVE${UNQID}"  name="CHKLIST_BNKUS_SLSCHK_APPROVE" value="Y"
												<c:if test="${CHECKLIST['CHKLIST_BNKUS_SLSCHK_APPROVE'] eq 'Y'}">checked="checked"</c:if>
												<c:if test="${(FORMDATA['STATUS'] ne 'BPA-A') && (CURRENTROLE ne 'ROLE_BPACHECKER')}">
													disabled="disabled"
												</c:if>
											/>
											Approve
										</label>
									</td>
									<td>
										Mandatory
									</td>
								</tr>
								<c:if test="${(FORMDATA['STATUS'] eq 'BPA-P' && CURRENTROLE eq 'ROLE_BPAMAKER') || (FORMDATA['STATUS'] eq 'BPD-P' && CURRENTROLE eq 'ROLE_BPDMAKER')}">
									<tr>
										<td colspan="5" style="text-align: right;">
											<button type="button" class="btn btn-success btn-sm saveCDDFormBPAMaker" id="saveCDDForm6${UNQID}">Save</button>
										</td>
									</tr>
								</c:if>
								<c:if test="${FORMDATA['STATUS'] eq 'BPA-A' && CURRENTROLE eq 'ROLE_BPACHECKER'}">
									<tr>
										<td colspan="5" style="text-align: right;">
											<button type="button" class="btn btn-success btn-sm saveCDDFormBPAChecker" id="saveCDDForm7${UNQID}">Save</button>
										</td>
									</tr>
								</c:if>
							</table>
							</form>
						</div>
						<div role="tabpanel" class="tab-pane" id="identificationForm"></div>
						<div role="tabpanel" class="tab-pane" id="statusApprovals"></div>
					</div>
				</div>
		</div>
	</div>
</div>
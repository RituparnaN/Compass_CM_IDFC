var caseWorkFlowActions = caseWorkFlowActions || (function(){
	var ctx = window.location.href;
	ctx = ctx.substring(0, ctx.split("/", 4).join("/").length);
	return {
		openModalForCaseWorkFlow : function(action, ajaxUrl){
			$("#compassCaseWorkFlowGenericModal").modal("show");
			$("#compassCaseWorkFlowGenericModal-title").html(action);
			var ctx = window.location.href;
			ctx = ctx.substring(0, ctx.split("/", 4).join("/").length);
			var url = ctx + ajaxUrl;
			var loaderUrl = ctx + '/includes/images/qde-loadder.gif';
			$("#compassCaseWorkFlowGenericModal-body").html("<br/><center><img src='"+loaderUrl+"'/></center><br/>");
			
			$.ajax({
				url :  url,
				cache : false,
				type : 'GET',
				success : function(response){
					$("#compassCaseWorkFlowGenericModal-body").html(response);
				},
				error : function(a,b,c){
					alert("Something went wrong"+a+b+c);
				}
			});
		},
		desktopCloserByBranchUser : function(tableParentDivId){
			var selectedCases = "";
			$("#"+tableParentDivId).find("table").children("tbody").children("tr").each(function(){
    			var row = $(this).children("td").children("input[type='checkbox']");
    			if($(row).prop("checked")){
    				selectedCases = selectedCases + $(row).val()+",";
    			}
    		});
			// alert(selectedCases);
			var intSelectedCount = ((selectedCases.split(",").length)-1);
			if(intSelectedCount == 0 ) {
			   alert('Please select atleast one case to close');
			   return false;
			} else if(intSelectedCount > 1 ) {
			   alert('Please select only one case to close');
			   return false;
			}
			
			var formId = $("#"+tableParentDivId).parents("div.row").find("form").attr("id");
			
			var selectedCase = selectedCases.substr(0,selectedCases.length-1);
			var url = "/amlCaseWorkFlow/addViewComments?CaseNos="+selectedCase+"&CaseStatus=2&FlagType=Y&formId="+formId;
			caseWorkFlowActions.openModalForCaseWorkFlow("Add Comment For Desktop Closer", url);
			
			
		//	window.open("/Compass/",'CommentsForm','width=1200, height=600,toolbar=no,location=no,resizable=Yes,scrollbars=yes, top=130, left=170');
		},
		escalateCaseByBranchUser : function(tableParentDivId){
			var selectedCases = "";
			$("#"+tableParentDivId).find("table").children("tbody").children("tr").each(function(){
    			var row = $(this).children("td").children("input[type='checkbox']");
    			if($(row).prop("checked")){
    				selectedCases = selectedCases + $(row).val()+",";
    			}
    		});
			// alert(selectedCases);
			var intSelectedCount = ((selectedCases.split(",").length)-1);
			if(intSelectedCount == 0 ) {
			   alert('Please select atleast one case to close');
			   return false;
			} else if(intSelectedCount > 1 ) {
			   alert('Please select only one case to close');
			   return false;
			}
			
			var formId = $("#"+tableParentDivId).parents("div.row").find("form").attr("id");
			
			var selectedCase = selectedCases.substr(0,selectedCases.length-1);
			var url = "/amlCaseWorkFlow/addViewComments?CaseNos="+selectedCase+"&CaseStatus=3&FlagType=Y&formId="+formId;
			caseWorkFlowActions.openModalForCaseWorkFlow("Add Comment For Case Esclataion To AMLUser", url);
		},
		desktopCloserByFATCARMUser : function(tableParentDivId){
			var selectedCases = "";
			$("#"+tableParentDivId).find("table").children("tbody").children("tr").each(function(){
    			var row = $(this).children("td").children("input[type='checkbox']");
    			if($(row).prop("checked")){
    				selectedCases = selectedCases + $(row).val()+",";
    			}
    		});
			// alert(selectedCases);
			var intSelectedCount = ((selectedCases.split(",").length)-1);
			if(intSelectedCount == 0 ) {
			   alert('Please select atleast one case to close');
			   return false;
			} else if(intSelectedCount > 1 ) {
			   alert('Please select only one case to close');
			   return false;
			}
			
			var formId = $("#"+tableParentDivId).parents("div.row").find("form").attr("id");
			
			var selectedCase = selectedCases.substr(0,selectedCases.length-1);
			var url = "/fatcaCaseWorkFlow/fatcaAddViewComments?CaseNos="+selectedCase+"&CaseStatus=2&FlagType=Y&formId="+formId;
			caseWorkFlowActions.openModalForCaseWorkFlow("Add Comment For Desktop Closer", url);
			
			
		//	window.open("/Compass/",'CommentsForm','width=1200, height=600,toolbar=no,location=no,resizable=Yes,scrollbars=yes, top=130, left=170');
		},
		escalateCaseByFATCARMUser : function(tableParentDivId){
			var selectedCases = "";
			$("#"+tableParentDivId).find("table").children("tbody").children("tr").each(function(){
    			var row = $(this).children("td").children("input[type='checkbox']");
    			if($(row).prop("checked")){
    				selectedCases = selectedCases + $(row).val()+",";
    			}
    		});
			// alert(selectedCases);
			var intSelectedCount = ((selectedCases.split(",").length)-1);
			if(intSelectedCount == 0 ) {
			   alert('Please select atleast one case to close');
			   return false;
			} else if(intSelectedCount > 1 ) {
			   alert('Please select only one case to close');
			   return false;
			}
			
			var formId = $("#"+tableParentDivId).parents("div.row").find("form").attr("id");
			
			var selectedCase = selectedCases.substr(0,selectedCases.length-1);
			var url = "/fatcaCaseWorkFlow/fatcaAddViewComments?CaseNos="+selectedCase+"&CaseStatus=3&FlagType=Y&formId="+formId;
			caseWorkFlowActions.openModalForCaseWorkFlow("Add Comment For Case Esclataion To FATCAUser", url);
		},
		desktopCloser : function(tableParentDivId, divId){
			var selectedCases = "";
			var CM_CUSTOMERID = $("#CUSTOMERID_"+divId).val();
    		//alert('CM_CUSTOMERID : '+CM_CUSTOMERID);
			if(CM_CUSTOMERID == '' ) {
               alert('CustomeId in search should not be blank for desktop closure');
			   return false;
			}

			$("#"+tableParentDivId).find("table").children("tbody").children("tr").each(function(){
    			var row = $(this).children("td").children("input[type='checkbox']");
    			if($(row).prop("checked")){
    				selectedCases = selectedCases + $(row).val()+",";
    			}
    		});
			// alert(selectedCases);
			var intSelectedCount = ((selectedCases.split(",").length)-1);
			if(intSelectedCount == 0 ) {
			   alert('Please select atleast one case to close');
			   return false;
			} else if(intSelectedCount > 1 ) {
			   alert('Please select only one case to close');
			   return false;
			}
			
			var formId = $("#"+tableParentDivId).parents("div.row").find("form").attr("id");
			
			var selectedCase = selectedCases.substr(0,selectedCases.length-1);
			//var url = "/amlCaseWorkFlow/addViewComments?CaseNos="+selectedCase+"&CaseStatus=11&FlagType=Y&formId="+formId;
			
			var CM_FROMDATE = $("#FROMDATE_"+divId).val();
    		var CM_TODATE = $("#TODATE_"+divId).val();
    		var CM_ALERTCODE = $("#ALERTCODE_"+divId).val();
    		var CM_BRANCHCODE = $("#BRANCHCODE_"+divId).val();
    		var CM_ACCOUNTNO = $("#ACCOUNTNO_"+divId).val();
    		var CM_CUSTOMERID = $("#CUSTOMERID_"+divId).val();
    		var CM_HASANYOLDCASES = $("#HASANYOLDCASES_"+divId).val();
    		var CM_CASERATING = $("#CASERATING_"+divId).val();
    		var CM_FROMCASENO = $("#FROMCASENO_"+divId).val();
    		var CM_TOCASENO = $("#TOCASENO_"+divId).val();
    		var url = "/amlCaseWorkFlow/addOtherComments?CaseNos="+selectedCase+"&CaseStatus=11&FlagType=Y&formId="+formId+
				      "&fromDate="+CM_FROMDATE+"&toDate="+CM_TODATE+"&alertCode="+CM_ALERTCODE+"&branchCode="+CM_BRANCHCODE+"&accountNo="+CM_ACCOUNTNO+
				      "&customerId="+CM_CUSTOMERID+"&hasAnyOldCases="+CM_HASANYOLDCASES+"&caseRating="+CM_CASERATING+
				      "&fromCaseNo="+CM_FROMCASENO+"&toCaseNo="+CM_TOCASENO;
			caseWorkFlowActions.openModalForCaseWorkFlow("Add Comment For Desktop Closer", url);
			
			
		//	window.open("/Compass/",'CommentsForm','width=1200, height=600,toolbar=no,location=no,resizable=Yes,scrollbars=yes, top=130, left=170');
		},
		fatcaDesktopCloser : function(tableParentDivId){
			var selectedCases = "";
			$("#"+tableParentDivId).find("table").children("tbody").children("tr").each(function(){
    			var row = $(this).children("td").children("input[type='checkbox']");
    			if($(row).prop("checked")){
    				selectedCases = selectedCases + $(row).val()+",";
    			}
    		});
			// alert(selectedCases);
			var intSelectedCount = ((selectedCases.split(",").length)-1);
			if(intSelectedCount == 0 ) {
			   alert('Please select atleast one case to close');
			   return false;
			} else if(intSelectedCount > 1 ) {
			   alert('Please select only one case to close');
			   return false;
			}
			
			var formId = $("#"+tableParentDivId).parents("div.row").find("form").attr("id");
			
			var selectedCase = selectedCases.substr(0,selectedCases.length-1);
			var url = "/fatcaCaseWorkFlow/fatcaAddViewComments?CaseNos="+selectedCase+"&CaseStatus=11&FlagType=Y&formId="+formId;
			caseWorkFlowActions.openModalForCaseWorkFlow("Add Comment For Desktop Closer", url);
			
			
		//	window.open("/Compass/",'CommentsForm','width=1200, height=600,toolbar=no,location=no,resizable=Yes,scrollbars=yes, top=130, left=170');
		},
		closeWithSTR : function(tableParentDivId){
			var selectedCases = "";
			$("#"+tableParentDivId).find("table").children("tbody").children("tr").each(function(){
    			var row = $(this).children("td").children("input[type='checkbox']");
    			if($(row).prop("checked")){
    				selectedCases = selectedCases + $(row).val()+",";
    			}
    		});
			// alert(selectedCases);
			var intSelectedCount = ((selectedCases.split(",").length)-1);
			if(intSelectedCount == 0 ) {
			   alert('Please select atleast one case to close');
			   return false;
			} else if(intSelectedCount > 1 ) {
			   alert('Please select only one case to close');
			   return false;
			}
			
			var formId = $("#"+tableParentDivId).parents("div.row").find("form").attr("id");
			
			var selectedCase = selectedCases.substr(0,selectedCases.length-1);
			var url = "/amlCaseWorkFlow/addViewComments?CaseNos="+selectedCase+"&CaseStatus=6&FlagType=Y&formId="+formId;
			caseWorkFlowActions.openModalForCaseWorkFlow("Add Comment For Close With STR", url);
		},
		closeWithoutSTR : function(tableParentDivId){
			var selectedCases = "";
			$("#"+tableParentDivId).find("table").children("tbody").children("tr").each(function(){
    			var row = $(this).children("td").children("input[type='checkbox']");
    			if($(row).prop("checked")){
    				selectedCases = selectedCases + $(row).val()+",";
    			}
    		});
			// alert(selectedCases);
			var intSelectedCount = ((selectedCases.split(",").length)-1);
			if(intSelectedCount == 0 ) {
			   alert('Please select atleast one case to close');
			   return false;
			} else if(intSelectedCount > 1 ) {
			   alert('Please select only one case to close');
			   return false;
			}
			
			var formId = $("#"+tableParentDivId).parents("div.row").find("form").attr("id");
			
			var selectedCase = selectedCases.substr(0,selectedCases.length-1);
			var url = "/amlCaseWorkFlow/addViewComments?CaseNos="+selectedCase+"&CaseStatus=5&FlagType=Y&formId="+formId;
			caseWorkFlowActions.openModalForCaseWorkFlow("Add Comment For Close Without STR", url);
		},
		closeWithEscalation : function(tableParentDivId){
			var selectedCases = "";
			$("#"+tableParentDivId).find("table").children("tbody").children("tr").each(function(){
    			var row = $(this).children("td").children("input[type='checkbox']");
    			if($(row).prop("checked")){
    				selectedCases = selectedCases + $(row).val()+",";
    			}
    		});
			// alert(selectedCases);
			var intSelectedCount = ((selectedCases.split(",").length)-1);
			if(intSelectedCount == 0 ) {
			   alert('Please select atleast one case to close');
			   return false;
			} else if(intSelectedCount > 1 ) {
			   alert('Please select only one case to close');
			   return false;
			}
			
			var formId = $("#"+tableParentDivId).parents("div.row").find("form").attr("id");
			
			var selectedCase = selectedCases.substr(0,selectedCases.length-1);
			var url = "/fatcaCaseWorkFlow/fatcaAddViewComments?CaseNos="+selectedCase+"&CaseStatus=6&FlagType=Y&formId="+formId;
			caseWorkFlowActions.openModalForCaseWorkFlow("Add Comment For Close With Escalation", url);
		},
		closeWithoutEscalation : function(tableParentDivId){
			var selectedCases = "";
			$("#"+tableParentDivId).find("table").children("tbody").children("tr").each(function(){
    			var row = $(this).children("td").children("input[type='checkbox']");
    			if($(row).prop("checked")){
    				selectedCases = selectedCases + $(row).val()+",";
    			}
    		});
			// alert(selectedCases);
			var intSelectedCount = ((selectedCases.split(",").length)-1);
			if(intSelectedCount == 0 ) {
			   alert('Please select atleast one case to close');
			   return false;
			} else if(intSelectedCount > 1 ) {
			   alert('Please select only one case to close');
			   return false;
			}
			
			var formId = $("#"+tableParentDivId).parents("div.row").find("form").attr("id");
			
			var selectedCase = selectedCases.substr(0,selectedCases.length-1);
			var url = "/fatcaCaseWorkFlow/fatcaAddViewComments?CaseNos="+selectedCase+"&CaseStatus=5&FlagType=Y&formId="+formId;
			caseWorkFlowActions.openModalForCaseWorkFlow("Add Comment For Close Without Escalation", url);
		},
		assignToBranchUserByAMLuser : function(tableParentDivId){
			var selectedCases = "";
			$("#"+tableParentDivId).find("table").children("tbody").children("tr").each(function(){
    			var row = $(this).children("td").children("input[type='checkbox']");
    			if($(row).prop("checked")){
    				selectedCases = selectedCases + $(row).val()+",";
    			}
    		});
			// alert(selectedCases);
			var intSelectedCount = ((selectedCases.split(",").length)-1);
			/*if(intSelectedCount == 0 ) {
			   alert('Please select atleast one case to assign.');
			   return false;
			} else if(intSelectedCount > 1 ) {
			   alert('Please select only one case to assign.');
			   return false;
			}*/
			
			var formId = $("#"+tableParentDivId).parents("div.row").find("form").attr("id");
			
			var selectedCase = selectedCases.substr(0,selectedCases.length-1);
			var url = "/amlCaseWorkFlow/assignToBranchUser?CaseNos="+selectedCase+"&CaseStatus=1&FlagType=Y&formId="+formId;
			caseWorkFlowActions.openModalForCaseWorkFlow("Add Comment For Assignment To Branch User", url);
		},
		assignToRMUserByFATCAUser : function(tableParentDivId){
			var selectedCases = "";
			$("#"+tableParentDivId).find("table").children("tbody").children("tr").each(function(){
    			var row = $(this).children("td").children("input[type='checkbox']");
    			if($(row).prop("checked")){
    				selectedCases = selectedCases + $(row).val()+",";
    			}
    		});
			// alert(selectedCases);
			var intSelectedCount = ((selectedCases.split(",").length)-1);
			/*
			if(intSelectedCount == 0 ) {
			   alert('Please select atleast one case to close');
			   return false;
			} else if(intSelectedCount > 1 ) {
			   alert('Please select only one case to close');
			   return false;
			}
			*/
			var formId = $("#"+tableParentDivId).parents("div.row").find("form").attr("id");
			
			var selectedCase = selectedCases.substr(0,selectedCases.length-1);
			//var url = "/fatcaCaseWorkFlow/fatcaAddViewComments?CaseNos="+selectedCase+"&CaseStatus=1&FlagType=Y&formId="+formId;
			var url = "/fatcaCaseWorkFlow/assignToRMUser?CaseNos="+selectedCase+"&CaseStatus=1&FlagType=Y&formId="+formId;
			caseWorkFlowActions.openModalForCaseWorkFlow("Add Comment For Assignment To RM", url);
		},
		rejectSTRByAMLO : function(tableParentDivId){
			var selectedCases = "";
			$("#"+tableParentDivId).find("table").children("tbody").children("tr").each(function(){
    			var row = $(this).children("td").children("input[type='checkbox']");
    			if($(row).prop("checked")){
    				selectedCases = selectedCases + $(row).val()+",";
    			}
    		});
			// alert(selectedCases);
			var intSelectedCount = ((selectedCases.split(",").length)-1);
			if(intSelectedCount == 0 ) {
			   alert('Please select atleast one case to close');
			   return false;
			} else if(intSelectedCount > 1 ) {
			   alert('Please select only one case to close');
			   return false;
			}
			
			var formId = $("#"+tableParentDivId).parents("div.row").find("form").attr("id");
			
			var selectedCase = selectedCases.substr(0,selectedCases.length-1);
			var url = "/amlCaseWorkFlow/addViewComments?CaseNos="+selectedCase+"&CaseStatus=7&FlagType=Y&formId="+formId;
			caseWorkFlowActions.openModalForCaseWorkFlow("Add Comment For Reject STR", url);
		},
		approveSTRByAMLO : function(tableParentDivId){
			var selectedCases = "";
			$("#"+tableParentDivId).find("table").children("tbody").children("tr").each(function(){
    			var row = $(this).children("td").children("input[type='checkbox']");
    			if($(row).prop("checked")){
    				selectedCases = selectedCases + $(row).val()+",";
    			}
    		});
			// alert(selectedCases);
			var intSelectedCount = ((selectedCases.split(",").length)-1);
			if(intSelectedCount == 0 ) {
			   alert('Please select atleast one case to close');
			   return false;
			} else if(intSelectedCount > 1 ) {
			   alert('Please select only one case to close');
			   return false;
			}
			
			var formId = $("#"+tableParentDivId).parents("div.row").find("form").attr("id");
			
			var selectedCase = selectedCases.substr(0,selectedCases.length-1);
			var url = "/amlCaseWorkFlow/addViewComments?CaseNos="+selectedCase+"&CaseStatus=8&FlagType=Y&formId="+formId;
			caseWorkFlowActions.openModalForCaseWorkFlow("Add Comment For Approve STR", url);
		},
		rejectCaseByFATCAOfficer : function(tableParentDivId){
			var selectedCases = "";
			$("#"+tableParentDivId).find("table").children("tbody").children("tr").each(function(){
    			var row = $(this).children("td").children("input[type='checkbox']");
    			if($(row).prop("checked")){
    				selectedCases = selectedCases + $(row).val()+",";
    			}
    		});
			// alert(selectedCases);
			var intSelectedCount = ((selectedCases.split(",").length)-1);
			if(intSelectedCount == 0 ) {
			   alert('Please select atleast one case to close');
			   return false;
			} else if(intSelectedCount > 1 ) {
			   alert('Please select only one case to close');
			   return false;
			}
			
			var formId = $("#"+tableParentDivId).parents("div.row").find("form").attr("id");
			
			var selectedCase = selectedCases.substr(0,selectedCases.length-1);
			var url = "/fatcaCaseWorkFlow/fatcaAddViewComments?CaseNos="+selectedCase+"&CaseStatus=7&FlagType=Y&formId="+formId;
			caseWorkFlowActions.openModalForCaseWorkFlow("Add Comment For Reject Case", url);
		},
		approveCaseByFATCAOfficer : function(tableParentDivId){
			var selectedCases = "";
			$("#"+tableParentDivId).find("table").children("tbody").children("tr").each(function(){
    			var row = $(this).children("td").children("input[type='checkbox']");
    			if($(row).prop("checked")){
    				selectedCases = selectedCases + $(row).val()+",";
    			}
    		});
			// alert(selectedCases);
			var intSelectedCount = ((selectedCases.split(",").length)-1);
			if(intSelectedCount == 0 ) {
			   alert('Please select atleast one case to close');
			   return false;
			} else if(intSelectedCount > 1 ) {
			   alert('Please select only one case to close');
			   return false;
			}
			
			var formId = $("#"+tableParentDivId).parents("div.row").find("form").attr("id");
			
			var selectedCase = selectedCases.substr(0,selectedCases.length-1);
			var url = "/fatcaCaseWorkFlow/fatcaAddViewComments?CaseNos="+selectedCase+"&CaseStatus=8&FlagType=Y&formId="+formId;
			caseWorkFlowActions.openModalForCaseWorkFlow("Add Comment For Approve Case", url);
		},
		closeWithHindSightingByAMLO : function(tableParentDivId){
			var selectedCases = "";
			$("#"+tableParentDivId).find("table").children("tbody").children("tr").each(function(){
    			var row = $(this).children("td").children("input[type='checkbox']");
    			if($(row).prop("checked")){
    				selectedCases = selectedCases + $(row).val()+",";
    			}
    		});
			// alert(selectedCases);
			var intSelectedCount = ((selectedCases.split(",").length)-1);
			if(intSelectedCount == 0 ) {
			   alert('Please select atleast one case to close');
			   return false;
			} else if(intSelectedCount > 1 ) {
			   alert('Please select only one case to close');
			   return false;
			}
			
			var formId = $("#"+tableParentDivId).parents("div.row").find("form").attr("id");
			
			var selectedCase = selectedCases.substr(0,selectedCases.length-1);
			var url = "/amlCaseWorkFlow/addViewComments?CaseNos="+selectedCase+"&CaseStatus=16&FlagType=Y&formId="+formId;
			caseWorkFlowActions.openModalForCaseWorkFlow("Add Comment For Closure With Hindsighting", url);
		},
		closeWithoutHindSightingByAMLO : function(tableParentDivId){
			var selectedCases = "";
			$("#"+tableParentDivId).find("table").children("tbody").children("tr").each(function(){
    			var row = $(this).children("td").children("input[type='checkbox']");
    				selectedCases = selectedCases + $(row).val()+",";
    				if($(row).prop("checked")){
    			}
    		});
			// alert(selectedCases);
			var intSelectedCount = ((selectedCases.split(",").length)-1);
			if(intSelectedCount == 0 ) {
			   alert('Please select atleast one case to close');
			   return false;
			} else if(intSelectedCount > 1 ) {
			   alert('Please select only one case to close');
			   return false;
			}
			
			var formId = $("#"+tableParentDivId).parents("div.row").find("form").attr("id");
			
			var selectedCase = selectedCases.substr(0,selectedCases.length-1);
			var url = "/amlCaseWorkFlow/addViewComments?CaseNos="+selectedCase+"&CaseStatus=17&FlagType=Y&formId="+formId;
			caseWorkFlowActions.openModalForCaseWorkFlow("Add Comment For Closure Without Hindsighting", url);
		},
		rejectSTRByMLRO : function(tableParentDivId){
			var selectedCases = "";
			$("#"+tableParentDivId).find("table").children("tbody").children("tr").each(function(){
    			var row = $(this).children("td").children("input[type='checkbox']");
    			if($(row).prop("checked")){
    				selectedCases = selectedCases + $(row).val()+",";
    			}
    		});
			// alert(selectedCases);
			var intSelectedCount = ((selectedCases.split(",").length)-1);
			if(intSelectedCount == 0 ) {
			   alert('Please select atleast one case to close');
			   return false;
			} else if(intSelectedCount > 1 ) {
			   alert('Please select only one case to close');
			   return false;
			}
			
			var formId = $("#"+tableParentDivId).parents("div.row").find("form").attr("id");
			
			var selectedCase = selectedCases.substr(0,selectedCases.length-1);
			var url = "/amlCaseWorkFlow/addViewComments?CaseNos="+selectedCase+"&CaseStatus=9&FlagType=Y&formId="+formId;
			caseWorkFlowActions.openModalForCaseWorkFlow("Add Comment For Reject STR", url);
		},
		fileSTRByMLRO : function(tableParentDivId){
			var selectedCases = "";
			$("#"+tableParentDivId).find("table").children("tbody").children("tr").each(function(){
    			var row = $(this).children("td").children("input[type='checkbox']");
    			if($(row).prop("checked")){
    				selectedCases = selectedCases + $(row).val()+",";
    			}
    		});
			// alert(selectedCases);
			var intSelectedCount = ((selectedCases.split(",").length)-1);
			if(intSelectedCount == 0 ) {
			   alert('Please select atleast one case to close');
			   return false;
			} else if(intSelectedCount > 1 ) {
			   alert('Please select only one case to close');
			   return false;
			}
			
			var formId = $("#"+tableParentDivId).parents("div.row").find("form").attr("id");
			
			var selectedCase = selectedCases.substr(0,selectedCases.length-1);
			var url = "/amlCaseWorkFlow/addViewComments?CaseNos="+selectedCase+"&CaseStatus=10&FlagType=Y&formId="+formId;
			caseWorkFlowActions.openModalForCaseWorkFlow("Add Comment For File STR", url);
		},
		rejectCaseByFATCAManager : function(tableParentDivId){
			var selectedCases = "";
			$("#"+tableParentDivId).find("table").children("tbody").children("tr").each(function(){
    			var row = $(this).children("td").children("input[type='checkbox']");
    			if($(row).prop("checked")){
    				selectedCases = selectedCases + $(row).val()+",";
    			}
    		});
			// alert(selectedCases);
			var intSelectedCount = ((selectedCases.split(",").length)-1);
			if(intSelectedCount == 0 ) {
			   alert('Please select atleast one case to close');
			   return false;
			} else if(intSelectedCount > 1 ) {
			   alert('Please select only one case to close');
			   return false;
			}
			
			var formId = $("#"+tableParentDivId).parents("div.row").find("form").attr("id");
			
			var selectedCase = selectedCases.substr(0,selectedCases.length-1);
			var url = "/fatcaCaseWorkFlow/fatcaAddViewComments?CaseNos="+selectedCase+"&CaseStatus=9&FlagType=Y&formId="+formId;
			caseWorkFlowActions.openModalForCaseWorkFlow("Add Comment For Reject Reporting", url);
		},
		fileCaseByFATCAManager : function(tableParentDivId){
			var selectedCases = "";
			$("#"+tableParentDivId).find("table").children("tbody").children("tr").each(function(){
    			var row = $(this).children("td").children("input[type='checkbox']");
    			if($(row).prop("checked")){
    				selectedCases = selectedCases + $(row).val()+",";
    			}
    		});
			// alert(selectedCases);
			var intSelectedCount = ((selectedCases.split(",").length)-1);
			if(intSelectedCount == 0 ) {
			   alert('Please select atleast one case to close');
			   return false;
			} else if(intSelectedCount > 1 ) {
			   alert('Please select only one case to close');
			   return false;
			}
			
			var formId = $("#"+tableParentDivId).parents("div.row").find("form").attr("id");
			
			var selectedCase = selectedCases.substr(0,selectedCases.length-1);
			var url = "/fatcaCaseWorkFlow/fatcaAddViewComments?CaseNos="+selectedCase+"&CaseStatus=10&FlagType=Y&formId="+formId;
			caseWorkFlowActions.openModalForCaseWorkFlow("Add Comment For File Reporting", url);
		},
		viewComments : function(tableParentDivId){
			var selectedCases = "";
			$("#"+tableParentDivId).find("table").children("tbody").children("tr").each(function(){
    			var row = $(this).children("td").children("input[type='checkbox']");
    			if($(row).prop("checked")){
    				selectedCases = selectedCases + $(row).val()+",";
    			}
    		});
			// alert(selectedCases);
			var intSelectedCount = ((selectedCases.split(",").length)-1);
			if(intSelectedCount == 0 )
			{
			   alert('Please select atleast one case to close');
			   return false;
			}
			else if(intSelectedCount > 1 )
			{
			   alert('Please select only one case to close');
			   return false;
			}
			var selectedCase = selectedCases.substr(0,selectedCases.length-1);
			// window.open("/Compass/amlCaseWorkFlow/addViewComments?CaseNos="+selectedCase+"&CaseStatus=0&FlagType=N",'CommentsForm','width=1200, height=600,toolbar=no,location=no,resizable=Yes,scrollbars=yes, top=130, left=170');
			var formId = $("#"+tableParentDivId).parents("div.row").find("form").attr("id");
			var url = "/amlCaseWorkFlow/addViewComments?CaseNos="+selectedCase+"&CaseStatus=0&FlagType=N&formId="+formId;
			caseWorkFlowActions.openModalForCaseWorkFlow("View Comment For Case", url);
		},
		viewFatcaComments : function(tableParentDivId){
			var selectedCases = "";
			$("#"+tableParentDivId).find("table").children("tbody").children("tr").each(function(){
    			var row = $(this).children("td").children("input[type='checkbox']");
    			if($(row).prop("checked")){
    				selectedCases = selectedCases + $(row).val()+",";
    			}
    		});
			// alert(selectedCases);
			var intSelectedCount = ((selectedCases.split(",").length)-1);
			if(intSelectedCount == 0 )
			{
			   alert('Please select atleast one case to close');
			   return false;
			}
			else if(intSelectedCount > 1 )
			{
			   alert('Please select only one case to close');
			   return false;
			}
			var selectedCase = selectedCases.substr(0,selectedCases.length-1);
			// window.open("/Compass/amlCaseWorkFlow/addViewComments?CaseNos="+selectedCase+"&CaseStatus=0&FlagType=N",'CommentsForm','width=1200, height=600,toolbar=no,location=no,resizable=Yes,scrollbars=yes, top=130, left=170');
			var formId = $("#"+tableParentDivId).parents("div.row").find("form").attr("id");
			var url = "/fatcaCaseWorkFlow/fatcaAddViewComments?CaseNos="+selectedCase+"&CaseStatus=0&FlagType=N&formId="+formId;
			caseWorkFlowActions.openModalForCaseWorkFlow("View Comment For Case", url);
		},
		viewIndianSTR : function(tableParentDivId){
			var selectedCases = "";
			$("#"+tableParentDivId).find("table").children("tbody").children("tr").each(function(){
    			var row = $(this).children("td").children("input[type='checkbox']");
    			if($(row).prop("checked")){
    				selectedCases = selectedCases + $(row).val()+",";
    			}
    		});
			// alert(selectedCases);
			var intSelectedCount = ((selectedCases.split(",").length)-1);
			if(intSelectedCount == 0 ) {
			   alert('Please select atleast one record');
			   return false;
			} else if(intSelectedCount > 1 ) {
			   alert('Please select only one record');
			   return false;
			}
			
			var formId = $("#"+tableParentDivId).parents("div.row").find("form").attr("id");
			
			var selectedCase = selectedCases.substr(0,selectedCases.length-1);
			window.open(ctx + "/common/getINDSTRReport?l_strAlertNo="+selectedCase+'&canUpdated=Y&canExported=N');
		},
		viewSriLankanSTR : function(tableParentDivId){
			var selectedCases = "";
			$("#"+tableParentDivId).find("table").children("tbody").children("tr").each(function(){
    			var row = $(this).children("td").children("input[type='checkbox']");
    			if($(row).prop("checked")){
    				selectedCases = selectedCases + $(row).val()+",";
    			}
    		});
			// alert(selectedCases);
			var intSelectedCount = ((selectedCases.split(",").length)-1);
			if(intSelectedCount == 0 ) {
			   alert('Please select atleast record');
			   return false;
			} else if(intSelectedCount > 1 ) {
			   alert('Please select only one record');
			   return false;
			}
			
			var formId = $("#"+tableParentDivId).parents("div.row").find("form").attr("id");
			
			var selectedCase = selectedCases.substr(0,selectedCases.length-1);
			window.open(ctx + "/common/getSLSTR?caseNo="+selectedCase);
		},
		viewUKSTR : function(tableParentDivId){
			var selectedCases = "";
			$("#"+tableParentDivId).find("table").children("tbody").children("tr").each(function(){
    			var row = $(this).children("td").children("input[type='checkbox']");
    			if($(row).prop("checked")){
    				selectedCases = selectedCases + $(row).val()+",";
    			}
    		});
			// alert(selectedCases);
			var intSelectedCount = ((selectedCases.split(",").length)-1);
			if(intSelectedCount == 0 ) {
			   alert('Please select atleast record');
			   return false;
			} else if(intSelectedCount > 1 ) {
			   alert('Please select only one record');
			   return false;
			}
			
			var formId = $("#"+tableParentDivId).parents("div.row").find("form").attr("id");
			
			var selectedCase = selectedCases.substr(0,selectedCases.length-1);
			window.open(ctx + "/common/ukSAR?caseNo="+selectedCase, "UK_SAR", "");
		},
		viewMaldivesSTR : function(tableParentDivId){
			var selectedCases = "";
			$("#"+tableParentDivId).find("table").children("tbody").children("tr").each(function(){
    			var row = $(this).children("td").children("input[type='checkbox']");
    			if($(row).prop("checked")){
    				selectedCases = selectedCases + $(row).val()+",";
    			}
    		});
			// alert(selectedCases);
			var intSelectedCount = ((selectedCases.split(",").length)-1);
			if(intSelectedCount == 0 ) {
			   alert('Please select atleast one record');
			   return false;
			} else if(intSelectedCount > 1 ) {
			   alert('Please select only one record');
			   return false;
			}
			
			var formId = $("#"+tableParentDivId).parents("div.row").find("form").attr("id");
			
			var selectedCase = selectedCases.substr(0,selectedCases.length-1);
			//window.open(ctx + "/common/getINDSTRReport?l_strAlertNo="+selectedCase+'&canUpdated=Y&canExported=N');
			window.open(ctx + "/common/maldivesSTR?caseNo="+selectedCase, "MALDIVES_STR", "");
		},
		viewNepalSTR : function(tableParentDivId){
			var selectedCases = "";
			$("#"+tableParentDivId).find("table").children("tbody").children("tr").each(function(){
    			var row = $(this).children("td").children("input[type='checkbox']");
    			if($(row).prop("checked")){
    				selectedCases = selectedCases + $(row).val()+",";
    			}
    		});
			// alert(selectedCases);
			var intSelectedCount = ((selectedCases.split(",").length)-1);
			if(intSelectedCount == 0 ) {
			   alert('Please select atleast one record');
			   return false;
			} else if(intSelectedCount > 1 ) {
			   alert('Please select only one record');
			   return false;
			}
			
			var formId = $("#"+tableParentDivId).parents("div.row").find("form").attr("id");
			
			var selectedCase = selectedCases.substr(0,selectedCases.length-1);
			//window.open(ctx + "/common/getINDSTRReport?l_strAlertNo="+selectedCase+'&canUpdated=Y&canExported=N');
			window.open(ctx + "/common/nepalSTR?caseNo="+selectedCase, "NEPAL_STR", "");
		}
	};
}());
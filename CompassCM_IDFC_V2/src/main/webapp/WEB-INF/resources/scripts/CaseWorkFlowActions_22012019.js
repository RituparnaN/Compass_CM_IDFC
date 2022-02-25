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
		roboscanDetails : function(tableParentDivId, divId){
			var selectedCases = "";
			$("#"+tableParentDivId).find("table").children("tbody").children("tr").each(function(){
    			var row = $(this).children("td").children("input[type='checkbox']");
    			if($(row).prop("checked")){
    				selectedCases = selectedCases + $(row).val()+",";
    			}
    		});
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
			//var url = "/amlCaseWorkFlow/rpaRepositoryDetails?CaseNos="+selectedCase+"&CaseStatus=2&FlagType=Y&formId="+formId;
			//caseWorkFlowActions.openModalForCaseWorkFlow("RoboscanDetails", url);
			//var url = ctx + "/amlCaseWorkFlow/rpaRepositoryDetails?CaseNos="+selectedCase+"&CaseStatus=2&FlagType=Y&formId="+formId;
			//window.open(url,'RPARepositoryDetails','width=1200, height=600,toolbar=no,location=no,resizable=Yes,scrollbars=yes, top=130, left=170');
			var url = ctx + "/amlCaseWorkFlow/roboscanDetails?CaseNos="+selectedCase+"&CaseStatus=2&FlagType=Y&formId="+formId;
			window.open(url,'RoboscanDetails','width=1200, height=600,toolbar=no,location=no,resizable=Yes,scrollbars=yes, top=130, left=170');
			
		//	window.open("/Compass/",'CommentsForm','width=1200, height=600,toolbar=no,location=no,resizable=Yes,scrollbars=yes, top=130, left=170');
		},
		mergeCase : function(tableParentDivId, divId){
			var selectedCases = "";
			var selectedCustIds = "";
			//var CM_CUSTOMERID = $("#CUSTOMERID_"+divId).val();
    		
			$("#"+tableParentDivId).find("table").children("tbody").children("tr").each(function(){
    			var row = $(this).children("td").children("input[type='checkbox']");
    			var custIds = $(this).children("td:nth-child(4)").html();  
    			if($(row).prop("checked")){
    				selectedCases = selectedCases + $(row).val()+",";
    			}
    		});
			var intSelectedCount = ((selectedCases.split(",").length)-1);
			if(intSelectedCount < 2 ) {
			   alert('Please select atleast 2 cases to merge.');
			   return false;
			}   
			var formId = $("#"+tableParentDivId).parents("div.row").find("form").attr("id");
			
			var selectedCase = selectedCases.substr(0,selectedCases.length-1);
			var moduleCode = "viewComments";
			var moduleHeader = "";
			var moduleValue = selectedCase;
			var detailPage = "AMLCaseWorkFlow/AddViewCommentsWithHistory";
			var actionType = "mergeCase";
			var caseStatus = "10000000";
			var flagType = "Y";
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
    		//alert('CM_CUSTOMERID : '+CM_CUSTOMERID);
			
			//var url = "/amlCaseWorkFlow/getCaseWorkflowModuleDetails?moduleCode="+moduleCode+"&moduleHeader="+moduleHeader+"&moduleValue="+moduleValue+"&detailPage="+detailPage+"&actionType="+actionType+"&caseStatus="+caseStatus+"&flagType="+flagType+"&formId="+formId;
			caseWorkFlowActions.hasDistinctCustId(selectedCase,function(){
	    		var url = "/amlCaseWorkFlow/getCaseWorkflowModuleDetails?fromDate="+CM_FROMDATE+"&toDate="+CM_TODATE+
	    				  "&alertCode="+CM_ALERTCODE+"&branchCode="+CM_BRANCHCODE+"&accountNo="+CM_ACCOUNTNO+
					      "&customerId="+CM_CUSTOMERID+"&hasAnyOldCases="+CM_HASANYOLDCASES+"&caseRating="+CM_CASERATING+
					      "&fromCaseNo="+CM_FROMCASENO+"&toCaseNo="+CM_TOCASENO+"&moduleCode="+moduleCode+"&moduleHeader="+moduleHeader+
					      "&moduleValue="+moduleValue+"&detailPage="+detailPage+"&actionType="+actionType+"&caseStatus="+caseStatus+
					      "&flagType="+flagType+"&formId="+formId;
				caseWorkFlowActions.openModalForCaseWorkFlow("Add Comment For Case Merger", url);
				//alert("url = "+url);
			});
		},
		desktopCloserByBranchUser : function(tableParentDivId, divId){
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
			var moduleCode = "viewComments";
			var moduleHeader = "";
			var moduleValue = selectedCase;
			var detailPage = "AMLCaseWorkFlow/AddViewCommentsWithHistory";
			var actionType = "desktopCloserByBranchUser";
			var caseStatus = "2";
			var flagType = "Y";
			var url = "/amlCaseWorkFlow/getCaseWorkflowModuleDetails?moduleCode="+moduleCode+"&moduleHeader="+moduleHeader+"&moduleValue="+moduleValue+"&detailPage="+detailPage+"&actionType="+actionType+"&caseStatus="+caseStatus+"&flagType="+flagType+"&formId="+formId;
			//var url = "/amlCaseWorkFlow/addViewComments?CaseNos="+selectedCase+"&CaseStatus=2&FlagType=Y&formId="+formId;
			caseWorkFlowActions.openModalForCaseWorkFlow("Add Comment For Desktop Closer", url);
		//	window.open("/Compass/",'CommentsForm','width=1200, height=600,toolbar=no,location=no,resizable=Yes,scrollbars=yes, top=130, left=170');
		},
		escalateCaseByBranchUser : function(tableParentDivId, divId){
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
			var moduleCode = "viewComments";
			var moduleHeader = "";
			var moduleValue = selectedCase;
			var detailPage = "AMLCaseWorkFlow/AddViewCommentsWithHistory";
			var actionType = "escalateCaseByBranchUser";
			var caseStatus = "3";
			var flagType = "Y";
			var url = "/amlCaseWorkFlow/getCaseWorkflowModuleDetails?moduleCode="+moduleCode+"&moduleHeader="+moduleHeader+"&moduleValue="+moduleValue+"&detailPage="+detailPage+"&actionType="+actionType+"&caseStatus="+caseStatus+"&flagType="+flagType+"&formId="+formId;
			//var url = "/amlCaseWorkFlow/addViewComments?CaseNos="+selectedCase+"&CaseStatus=3&FlagType=Y&formId="+formId;
			caseWorkFlowActions.openModalForCaseWorkFlow("Add Comment For Case Esclataion To AMLUser", url);
		},
		desktopCloserByFATCARMUser : function(tableParentDivId, divId){
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
			caseWorkFlowActions.openModalForCaseWorkFlow("Add Comment For Desktop Closure", url);
			
			
		//	window.open("/Compass/",'CommentsForm','width=1200, height=600,toolbar=no,location=no,resizable=Yes,scrollbars=yes, top=130, left=170');
		},
		escalateCaseByFATCARMUser : function(tableParentDivId, divId){
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
		hasDistinctCustId:function(caseNo,callback){
			var distinctcustId = false;
			var ctx = window.location.href;
			ctx = ctx.substring(0, ctx.split("/", 4).join("/").length);
			var url = ctx+"/amlCaseWorkFlow/hasDistinctCustId";
			$.ajax({
				url: url,
				cache: false,
				type: "POST",
				data: {caseNo:caseNo},
				success: function(res) {
					console.log(res);
					if(res['STATUS'] == true)
					{
						alert(res['MESSAGE']);
						distinctcustId =  true;
					}
				},
				complete: function(){
					if(distinctcustId == false){
						callback();
					}
				},
				error: function(a,b,c) {
					console.log();
					return true;
				}
			});
		},
		desktopCloser : function(tableParentDivId, divId){
			var selectedCases = "";
			var selectedCustIds = "";
			/*var CM_CUSTOMERID = $("#CUSTOMERID_"+divId).val();
    		alert('CM_CUSTOMERID : '+CM_CUSTOMERID);*/
			/*if(CM_CUSTOMERID == '' ) {
               alert('CustomeId in search should not be blank for desktop closure');
			   return false;
			}*/

			$("#"+tableParentDivId).find("table").children("tbody").children("tr").each(function(){
    			var row = $(this).children("td").children("input[type='checkbox']");
    			var custIds = $(this).children("td:nth-child(4)").html();  
    			//alert(custIds);
    			if($(row).prop("checked")){
    				selectedCases = selectedCases + $(row).val()+",";
    				//selectedCustIds = selectedCustIds + custIds +",";
    			//	alert("selectedCustIds= "+selectedCustIds);
    			}
    		});
			// alert(selectedCases+" "+selectedCustIds);
			var intSelectedCount = ((selectedCases.split(",").length)-1);
			if(intSelectedCount == 0 ) {
			   alert('Please select atleast one case to close');
			   return false;
			}/* else if(intSelectedCount > 1 ) {
			   alert('Please select only one case to close');
			   return false;
			}*/
			
			var formId = $("#"+tableParentDivId).parents("div.row").find("form").attr("id");
			
			var selectedCase = selectedCases.substr(0,selectedCases.length-1);
			//var url = "/amlCaseWorkFlow/addViewComments?CaseNos="+selectedCase+"&CaseStatus=11&FlagType=Y&formId="+formId;
			caseWorkFlowActions.hasDistinctCustId(selectedCase,function(){
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
				caseWorkFlowActions.openModalForCaseWorkFlow("Add Comment For Desktop Closure", url);
			});
			
		//	window.open("/Compass/",'CommentsForm','width=1200, height=600,toolbar=no,location=no,resizable=Yes,scrollbars=yes, top=130, left=170');
		},
		fatcaDesktopCloser : function(tableParentDivId, divId){
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
		closeWithSTR : function(tableParentDivId, divId){
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
		   // var url = "/amlCaseWorkFlow/addViewComments?CaseNos="+selectedCase+"&CaseStatus=6&FlagType=Y&formId="+formId;
		    var moduleCode = "viewComments";
			var moduleHeader = "";
			var moduleValue = selectedCase;
			var actionType = "closeWithSTR";
			var detailPage = "AMLCaseWorkFlow/AddViewCommentsWithHistory";
			var caseStatus = "6";
			var flagType = "Y";
			var url = "/amlCaseWorkFlow/getCaseWorkflowModuleDetails?moduleCode="+moduleCode+"&moduleHeader="+moduleHeader+"&moduleValue="+moduleValue+"&detailPage="+detailPage+"&actionType="+actionType+"&caseStatus="+caseStatus+"&flagType="+flagType+"&formId="+formId;
			caseWorkFlowActions.openModalForCaseWorkFlow("Add Comment For Closing Case "+selectedCase+" With STR", url);
		},
		closeWithoutSTR : function(tableParentDivId, divId){
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
			//var url = "/amlCaseWorkFlow/addViewComments?CaseNos="+selectedCase+"&CaseStatus=5&FlagType=Y&formId="+formId;
			var moduleCode = "viewComments";
			var moduleHeader = "";
			var moduleValue = selectedCase;
			var actionType = "closeWithoutSTR";
			var detailPage = "AMLCaseWorkFlow/AddViewCommentsWithHistory";
			var caseStatus = "5";
			var flagType = "Y";
			var url = "/amlCaseWorkFlow/getCaseWorkflowModuleDetails?moduleCode="+moduleCode+"&moduleHeader="+moduleHeader+"&moduleValue="+moduleValue+"&detailPage="+detailPage+"&actionType="+actionType+"&caseStatus="+caseStatus+"&flagType="+flagType+"&formId="+formId;
			caseWorkFlowActions.openModalForCaseWorkFlow("Add Comment For Closing Case "+selectedCase+" Without STR", url);
		},
		closeWithEscalation : function(tableParentDivId, divId){
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
		closeWithoutEscalation : function(tableParentDivId, divId){
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
		assignToBranchUserByAMLuser : function(tableParentDivId, divId){
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
			/*var url = "/amlCaseWorkFlow/assignToBranchUser?CaseNos="+selectedCase+"&CaseStatus=1&FlagType=Y&formId="+formId;*/
			
			
			var moduleCode = "viewComments";
			var moduleHeader = "";
			var moduleValue = selectedCase;
			var actionType = "assignToBranchUserByAMLuser";
			var detailPage = "AMLCaseWorkFlow/AddViewCommentsWithHistory";
			var caseStatus = "1";
			var flagType = "Y";
			var url = "/amlCaseWorkFlow/getCaseWorkflowModuleDetails?moduleCode="+moduleCode+"&moduleHeader="+moduleHeader+"&moduleValue="+moduleValue+"&detailPage="+detailPage+"&actionType="+actionType+"&caseStatus="+caseStatus+"&flagType="+flagType+"&formId="+formId;
			caseWorkFlowActions.openModalForCaseWorkFlow("Add Comment For Assignment To Branch User", url);
		},
		assignToRMUserByFATCAUser : function(tableParentDivId, divId){
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
		rejectSTRByAMLO : function(tableParentDivId, divId){
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
			//var url = "/amlCaseWorkFlow/addViewComments?CaseNos="+selectedCase+"&CaseStatus=7&FlagType=Y&formId="+formId;
			var moduleCode = "viewComments";
			var moduleHeader = "";
			var moduleValue = selectedCase;
			var actionType = "rejectSTRByAMLO";
			var detailPage = "AMLCaseWorkFlow/AddViewCommentsWithHistory";
			var caseStatus = "7";
			var flagType = "Y";
			var url = "/amlCaseWorkFlow/getCaseWorkflowModuleDetails?moduleCode="+moduleCode+"&moduleHeader="+moduleHeader+"&moduleValue="+moduleValue+"&detailPage="+detailPage+"&actionType="+actionType+"&caseStatus="+caseStatus+"&flagType="+flagType+"&formId="+formId;
			caseWorkFlowActions.openModalForCaseWorkFlow("Add Comment For Rejecting STR "+selectedCase, url);
		},
		approveSTRByAMLO : function(tableParentDivId, divId){
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
			//var url = "/amlCaseWorkFlow/addViewComments?CaseNos="+selectedCase+"&CaseStatus=8&FlagType=Y&formId="+formId;
			var moduleCode = "viewComments";
			var moduleHeader = "";
			var moduleValue = selectedCase;
			var actionType = "approveSTRByAMLO";
			var detailPage = "AMLCaseWorkFlow/AddViewCommentsWithHistory";
			var caseStatus = "8";
			var flagType = "Y";
			var url = "/amlCaseWorkFlow/getCaseWorkflowModuleDetails?moduleCode="+moduleCode+"&moduleHeader="+moduleHeader+"&moduleValue="+moduleValue+"&detailPage="+detailPage+"&actionType="+actionType+"&caseStatus="+caseStatus+"&flagType="+flagType+"&formId="+formId;
			caseWorkFlowActions.openModalForCaseWorkFlow("Add Comment For Approving STR "+selectedCase, url);
		},
		rejectCaseByFATCAOfficer : function(tableParentDivId, divId){
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
		approveCaseByFATCAOfficer : function(tableParentDivId, divId){
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
		closeWithHindSightingByAMLO : function(tableParentDivId, divId){
			var selectedCases = "";
			var CM_CUSTOMERID = $("#CUSTOMERID_"+divId).val();
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
			// var url = "/amlCaseWorkFlow/addViewComments?CaseNos="+selectedCase+"&CaseStatus=20&FlagType=Y&formId="+formId;
			var CM_FROMDATE = $("#FROMDATE_"+divId).val();
    		var CM_TODATE = $("#TODATE_"+divId).val();
    		var CM_ALERTCODE = $("#ALERTCODE_"+divId).val();
    		var CM_BRANCHCODE = $("#BRANCHCODE_"+divId).val();
    		var CM_ACCOUNTNO = $("#ACCOUNTNO_"+divId).val();
    		// var CM_CUSTOMERID = $("#CUSTOMERID_"+divId).val();
    		var CM_HASANYOLDCASES = $("#HASANYOLDCASES_"+divId).val();
    		var CM_CASERATING = $("#CASERATING_"+divId).val();
    		var CM_FROMCASENO = $("#FROMCASENO_"+divId).val();
    		var CM_TOCASENO = $("#TOCASENO_"+divId).val();
    		var url = "/amlCaseWorkFlow/addOtherComments?CaseNos="+selectedCase+"&CaseStatus=20&FlagType=Y&formId="+formId+
				      "&fromDate="+CM_FROMDATE+"&toDate="+CM_TODATE+"&alertCode="+CM_ALERTCODE+"&branchCode="+CM_BRANCHCODE+"&accountNo="+CM_ACCOUNTNO+
				      "&customerId="+CM_CUSTOMERID+"&hasAnyOldCases="+CM_HASANYOLDCASES+"&caseRating="+CM_CASERATING+
				      "&fromCaseNo="+CM_FROMCASENO+"&toCaseNo="+CM_TOCASENO;
			caseWorkFlowActions.openModalForCaseWorkFlow("Add Comment For Closure With Hindsighting", url);
		},
		closeWithoutHindSightingByAMLO : function(tableParentDivId, divId){
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
			} /* else if(intSelectedCount > 1 ) {
			   alert('Please select only one case to close');
			   return false;
			} */
			
			var formId = $("#"+tableParentDivId).parents("div.row").find("form").attr("id");
			
			var selectedCase = selectedCases.substr(0,selectedCases.length-1);
			// var url = "/amlCaseWorkFlow/addViewComments?CaseNos="+selectedCase+"&CaseStatus=21&FlagType=Y&formId="+formId;
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
    		var url = "/amlCaseWorkFlow/addOtherComments?CaseNos="+selectedCase+"&CaseStatus=21&FlagType=Y&formId="+formId+
				      "&fromDate="+CM_FROMDATE+"&toDate="+CM_TODATE+"&alertCode="+CM_ALERTCODE+"&branchCode="+CM_BRANCHCODE+"&accountNo="+CM_ACCOUNTNO+
				      "&customerId="+CM_CUSTOMERID+"&hasAnyOldCases="+CM_HASANYOLDCASES+"&caseRating="+CM_CASERATING+
				      "&fromCaseNo="+CM_FROMCASENO+"&toCaseNo="+CM_TOCASENO;
			
			caseWorkFlowActions.openModalForCaseWorkFlow("Add Comment For Closure Without Hindsighting", url);
		},
		rejectSTRByMLRO : function(tableParentDivId, divId){
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
			
			/*var url = "/amlCaseWorkFlow/addViewComments?CaseNos="+selectedCase+"&CaseStatus=9&FlagType=Y&formId="+formId;
			caseWorkFlowActions.openModalForCaseWorkFlow("Add Comment For Reject STR", url);*/
			
			var selectedCase = selectedCases.substr(0,selectedCases.length-1);
			var moduleCode = "viewComments";
			var moduleHeader = "";
			var moduleValue = selectedCase;
			var actionType = "rejectSTRByMLRO";
			var detailPage = "AMLCaseWorkFlow/AddViewCommentsWithHistory";
			var caseStatus = "9";
			var flagType = "Y";
			var url = "/amlCaseWorkFlow/getCaseWorkflowModuleDetails?moduleCode="+moduleCode+"&moduleHeader="+moduleHeader+"&moduleValue="+moduleValue+"&detailPage="+detailPage+"&actionType="+actionType+"&caseStatus="+caseStatus+"&flagType="+flagType+"&formId="+formId;
			caseWorkFlowActions.openModalForCaseWorkFlow("Add Comment For Rejecting STR "+selectedCase, url);
		},
		fileSTRByMLRO : function(tableParentDivId, divId){
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
			
			/*var url = "/amlCaseWorkFlow/addViewComments?CaseNos="+selectedCase+"&CaseStatus=10&FlagType=Y&formId="+formId;
			caseWorkFlowActions.openModalForCaseWorkFlow("Add Comment For File STR", url);*/
			
			var selectedCase = selectedCases.substr(0,selectedCases.length-1);
			var moduleCode = "viewComments";
			var moduleHeader = "";
			var moduleValue = selectedCase;
			var actionType = "fileSTRByMLRO";
			var detailPage = "AMLCaseWorkFlow/AddViewCommentsWithHistory";
			var caseStatus = "10";
			var flagType = "Y";
			var url = "/amlCaseWorkFlow/getCaseWorkflowModuleDetails?moduleCode="+moduleCode+"&moduleHeader="+moduleHeader+"&moduleValue="+moduleValue+"&detailPage="+detailPage+"&actionType="+actionType+"&caseStatus="+caseStatus+"&flagType="+flagType+"&formId="+formId;
			caseWorkFlowActions.openModalForCaseWorkFlow("Add Comment For Filing STR "+selectedCase, url);
		},
		closeWithHindSightingByMLRO : function(tableParentDivId, divId){
			var selectedCases = "";
			var CM_CUSTOMERID = $("#CUSTOMERID_"+divId).val();
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
			// var url = "/amlCaseWorkFlow/addViewComments?CaseNos="+selectedCase+"&CaseStatus=16&FlagType=Y&formId="+formId;
			var CM_FROMDATE = $("#FROMDATE_"+divId).val();
    		var CM_TODATE = $("#TODATE_"+divId).val();
    		var CM_ALERTCODE = $("#ALERTCODE_"+divId).val();
    		var CM_BRANCHCODE = $("#BRANCHCODE_"+divId).val();
    		var CM_ACCOUNTNO = $("#ACCOUNTNO_"+divId).val();
    		// var CM_CUSTOMERID = $("#CUSTOMERID_"+divId).val();
    		var CM_HASANYOLDCASES = $("#HASANYOLDCASES_"+divId).val();
    		var CM_CASERATING = $("#CASERATING_"+divId).val();
    		var CM_FROMCASENO = $("#FROMCASENO_"+divId).val();
    		var CM_TOCASENO = $("#TOCASENO_"+divId).val();
    		var url = "/amlCaseWorkFlow/addOtherComments?CaseNos="+selectedCase+"&CaseStatus=16&FlagType=Y&formId="+formId+
				      "&fromDate="+CM_FROMDATE+"&toDate="+CM_TODATE+"&alertCode="+CM_ALERTCODE+"&branchCode="+CM_BRANCHCODE+"&accountNo="+CM_ACCOUNTNO+
				      "&customerId="+CM_CUSTOMERID+"&hasAnyOldCases="+CM_HASANYOLDCASES+"&caseRating="+CM_CASERATING+
				      "&fromCaseNo="+CM_FROMCASENO+"&toCaseNo="+CM_TOCASENO;
			
			caseWorkFlowActions.openModalForCaseWorkFlow("Add Comment For Closure With Hindsighting", url);
		},
		closeWithoutHindSightingByMLRO : function(tableParentDivId, divId){
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
			} /* else if(intSelectedCount > 1 ) {
			   alert('Please select only one case to close');
			   return false;
			} */
			
			var formId = $("#"+tableParentDivId).parents("div.row").find("form").attr("id");
			
			var selectedCase = selectedCases.substr(0,selectedCases.length-1);
			// var url = "/amlCaseWorkFlow/addViewComments?CaseNos="+selectedCase+"&CaseStatus=17&FlagType=Y&formId="+formId;
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
    		var url = "/amlCaseWorkFlow/addOtherComments?CaseNos="+selectedCase+"&CaseStatus=17&FlagType=Y&formId="+formId+
				      "&fromDate="+CM_FROMDATE+"&toDate="+CM_TODATE+"&alertCode="+CM_ALERTCODE+"&branchCode="+CM_BRANCHCODE+"&accountNo="+CM_ACCOUNTNO+
				      "&customerId="+CM_CUSTOMERID+"&hasAnyOldCases="+CM_HASANYOLDCASES+"&caseRating="+CM_CASERATING+
				      "&fromCaseNo="+CM_FROMCASENO+"&toCaseNo="+CM_TOCASENO;
			
			caseWorkFlowActions.openModalForCaseWorkFlow("Add Comment For Closure Without Hindsighting", url);
		},
		rejectSTRByAMLREP : function(tableParentDivId, divId){
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
			var url = "/amlCaseWorkFlow/addViewAMLRepComments?CaseNos="+selectedCase+"&CaseStatus=36&FlagType=Y&formId="+formId;
			caseWorkFlowActions.openModalForCaseWorkFlow("Add Comment For Reject STR", url);
		},
		fileSTRByAMLREP : function(tableParentDivId, divId){
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
			var url = "/amlCaseWorkFlow/addViewAMLRepComments?CaseNos="+selectedCase+"&CaseStatus=37&FlagType=Y&formId="+formId;
			caseWorkFlowActions.openModalForCaseWorkFlow("Add Comment For File STR", url);
		},
		rejectCaseByFATCAManager : function(tableParentDivId, divId){
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
		fileCaseByFATCAManager : function(tableParentDivId, divId){
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
		viewComments : function(tableParentDivId, divId){
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
			//var url = "/amlCaseWorkFlow/addViewComments?CaseNos="+selectedCase+"&CaseStatus=0&FlagType=N&formId="+formId;
			var moduleCode = "viewComments";
			var moduleHeader = "";
			var moduleValue = selectedCase;
			var detailPage = "AMLCaseWorkFlow/AddViewCommentsWithHistory";
			var actionType = "viewComments";
			var caseStatus = "0";
			var flagType = "N";
			var formId = formId;
			var url = "/amlCaseWorkFlow/getCaseWorkflowModuleDetails?moduleCode="+moduleCode+"&moduleHeader="+moduleHeader+"&moduleValue="+moduleValue+"&detailPage="+detailPage+"&actionType="+actionType+"&caseStatus="+caseStatus+"&flagType="+flagType+"&formId="+formId;
			caseWorkFlowActions.openModalForCaseWorkFlow("View Comment For Case No - "+selectedCase, url);
		},
		viewFatcaComments : function(tableParentDivId, divId){
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
		reAssignBackToUser : function(tableParentDivId, divId){
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
			// var url = "/amlCaseWorkFlow/addViewComments?CaseNos="+selectedCase+"&CaseStatus=17&FlagType=Y&formId="+formId;
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
    		var url = "/amlCaseWorkFlow/addOtherComments?CaseNos="+selectedCase+"&CaseStatus=999&FlagType=Y&formId="+formId+
				      "&fromDate="+CM_FROMDATE+"&toDate="+CM_TODATE+"&alertCode="+CM_ALERTCODE+"&branchCode="+CM_BRANCHCODE+"&accountNo="+CM_ACCOUNTNO+
				      "&customerId="+CM_CUSTOMERID+"&hasAnyOldCases="+CM_HASANYOLDCASES+"&caseRating="+CM_CASERATING+
				      "&fromCaseNo="+CM_FROMCASENO+"&toCaseNo="+CM_TOCASENO;
			
			caseWorkFlowActions.openModalForCaseWorkFlow("Add Comment To Reassign Case Back To The User", url);
		},
		viewIndianSTR : function(tableParentDivId, divId){
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
			window.open(ctx + "/common/getINDSTRReport?l_strAlertNo="+selectedCase, "Indian_STR", "");
		},
		viewSriLankanSTR : function(tableParentDivId, divId){
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
		viewUKSTR : function(tableParentDivId, divId){
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
		viewMaldivesSTR : function(tableParentDivId, divId){
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
		viewNepalSTR : function(tableParentDivId, divId){
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
		},
		reAssignToAMLUSER:function(tableParentDivId, divId){
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
			// var url = "/amlCaseWorkFlow/addViewComments?CaseNos="+selectedCase+"&CaseStatus=17&FlagType=Y&formId="+formId;
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
    		var url = "/amlCaseWorkFlow/reAssignToAMLUser?CaseNos="+selectedCase+"&CaseStatus=999&FlagType=Y&formId="+formId+
				      "&fromDate="+CM_FROMDATE+"&toDate="+CM_TODATE+"&alertCode="+CM_ALERTCODE+"&branchCode="+CM_BRANCHCODE+"&accountNo="+CM_ACCOUNTNO+
				      "&customerId="+CM_CUSTOMERID+"&hasAnyOldCases="+CM_HASANYOLDCASES+"&caseRating="+CM_CASERATING+
				      "&fromCaseNo="+CM_FROMCASENO+"&toCaseNo="+CM_TOCASENO;
			
			caseWorkFlowActions.openModalForCaseWorkFlow("Add Comment To Reassign Case Back To The AML User", url);
		},
		reAllocatingToAMLUSER:function(tableParentDivId, divId){
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
			} 
			/*
			else if(intSelectedCount > 1 ) {
			   alert('Please select only one record');
			   return false;
			}
			*/
			var formId = $("#"+tableParentDivId).parents("div.row").find("form").attr("id");
			var selectedCase = selectedCases.substr(0,selectedCases.length-1);
			
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
    		var url = "/amlCaseWorkFlow/reAllocatingToAMLUser?CaseNo="+selectedCase+"&CaseStatus=990&FlagType=Y&formId="+formId+
				      "&fromDate="+CM_FROMDATE+"&toDate="+CM_TODATE+"&alertCode="+CM_ALERTCODE+"&branchCode="+CM_BRANCHCODE+"&accountNo="+CM_ACCOUNTNO+
				      "&customerId="+CM_CUSTOMERID+"&hasAnyOldCases="+CM_HASANYOLDCASES+"&caseRating="+CM_CASERATING+
				      "&fromCaseNo="+CM_FROMCASENO+"&toCaseNo="+CM_TOCASENO;
    		
			//var url = "/amlCaseWorkFlow/reAllocatingToAMLUser?CaseNo="+selectedCase+"&formId="+formId;
			caseWorkFlowActions.openModalForCaseWorkFlow("For Re Allocating TO AMLUser "+selectedCase, url);
		},
		bonafideOkay : function(tableParentDivId, divId){
			var selectedCases = "";
			var selectedCustIds = "";
			
			$("#"+tableParentDivId).find("table").children("tbody").children("tr").each(function(){
    			var row = $(this).children("td").children("input[type='checkbox']");
    			var custIds = $(this).children("td:nth-child(4)").html();  
    			if($(row).prop("checked")){
    				selectedCases = selectedCases + $(row).val()+",";
    			}
    		});
			var intSelectedCount = ((selectedCases.split(",").length)-1);
			if(intSelectedCount == 0 ) {
			   alert('Please select atleast one case to close');
			   return false;
			}
			
			var formId = $("#"+tableParentDivId).parents("div.row").find("form").attr("id");
			
			var selectedCase = selectedCases.substr(0,selectedCases.length-1);
			var moduleCode = "viewComments";
			var moduleHeader = "";
			var moduleValue = selectedCase;
			var detailPage = "AMLCaseWorkFlow/AddViewCommentsWithHistory";
			var actionType = "bonafideOkay";
			var caseStatus = "11";
			var flagType = "Y";
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
    		// alert(CM_CUSTOMERID);
			caseWorkFlowActions.hasDistinctCustId(selectedCase,function(){
				
	    		var url = "/amlCaseWorkFlow/getCaseWorkflowModuleDetails?fromDate="+CM_FROMDATE+"&toDate="+CM_TODATE+
	    				  "&alertCode="+CM_ALERTCODE+"&branchCode="+CM_BRANCHCODE+"&accountNo="+CM_ACCOUNTNO+
					      "&customerId="+CM_CUSTOMERID+"&hasAnyOldCases="+CM_HASANYOLDCASES+"&caseRating="+CM_CASERATING+
					      "&fromCaseNo="+CM_FROMCASENO+"&toCaseNo="+CM_TOCASENO+"&moduleCode="+moduleCode+"&moduleHeader="+moduleHeader+
					      "&moduleValue="+moduleValue+"&detailPage="+detailPage+"&actionType="+actionType+"&caseStatus="+caseStatus+
					      "&flagType="+flagType+"&formId="+formId;
				caseWorkFlowActions.openModalForCaseWorkFlow("Add Comment For Bonafide Okay", url);
				//alert("url = "+url);
			});
			
		//	window.open("/Compass/",'CommentsForm','width=1200, height=600,toolbar=no,location=no,resizable=Yes,scrollbars=yes, top=130, left=170');
		},
		raisedForReviewByAMLUser : function(tableParentDivId, divId){
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
			   alert('Please select atleast one case to assign.');
			   return false;
			} else if(intSelectedCount > 1 ) {
			   alert('Please select only one case to assign.');
			   return false;
			}
			
			var formId = $("#"+tableParentDivId).parents("div.row").find("form").attr("id");
			
			var selectedCase = selectedCases.substr(0,selectedCases.length-1);
			/*var url = "/amlCaseWorkFlow/assignToBranchUser?CaseNos="+selectedCase+"&CaseStatus=1&FlagType=Y&formId="+formId;*/
			
			
			var moduleCode = "viewComments";
			var moduleHeader = "";
			var moduleValue = selectedCase;
			var actionType = "raisedForReviewByAMLUser";
			var detailPage = "AMLCaseWorkFlow/AddViewCommentsWithHistory";
			var caseStatus = "4";
			var flagType = "Y";
			
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
    		var url = "/amlCaseWorkFlow/getCaseWorkflowModuleDetails?fromDate="+CM_FROMDATE+"&toDate="+CM_TODATE+
    				  "&alertCode="+CM_ALERTCODE+"&branchCode="+CM_BRANCHCODE+"&accountNo="+CM_ACCOUNTNO+
				      "&customerId="+CM_CUSTOMERID+"&hasAnyOldCases="+CM_HASANYOLDCASES+"&caseRating="+CM_CASERATING+
				      "&fromCaseNo="+CM_FROMCASENO+"&toCaseNo="+CM_TOCASENO+"&moduleCode="+moduleCode+"&moduleHeader="+moduleHeader+
				      "&moduleValue="+moduleValue+"&detailPage="+detailPage+"&actionType="+actionType+"&caseStatus="+caseStatus+
				      "&flagType="+flagType+"&formId="+formId;
    		
			caseWorkFlowActions.openModalForCaseWorkFlow("Add Comment For Raising Case For Review", url);
		},
		raisedForSTRByAMLUser : function(tableParentDivId, divId){
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
			   alert('Please select atleast one case to assign.');
			   return false;
			} else if(intSelectedCount > 1 ) {
			   alert('Please select only one case to assign.');
			   return false;
			}
			
			var formId = $("#"+tableParentDivId).parents("div.row").find("form").attr("id");
			
			var selectedCase = selectedCases.substr(0,selectedCases.length-1);
			/*var url = "/amlCaseWorkFlow/assignToBranchUser?CaseNos="+selectedCase+"&CaseStatus=1&FlagType=Y&formId="+formId;*/
			
			
			var moduleCode = "viewComments";
			var moduleHeader = "";
			var moduleValue = selectedCase;
			var actionType = "raisedForSTRByAMLUser";
			var detailPage = "AMLCaseWorkFlow/AddViewCommentsWithHistory";
			var caseStatus = "6";
			var flagType = "Y";

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
    		var url = "/amlCaseWorkFlow/getCaseWorkflowModuleDetails?fromDate="+CM_FROMDATE+"&toDate="+CM_TODATE+
    				  "&alertCode="+CM_ALERTCODE+"&branchCode="+CM_BRANCHCODE+"&accountNo="+CM_ACCOUNTNO+
				      "&customerId="+CM_CUSTOMERID+"&hasAnyOldCases="+CM_HASANYOLDCASES+"&caseRating="+CM_CASERATING+
				      "&fromCaseNo="+CM_FROMCASENO+"&toCaseNo="+CM_TOCASENO+"&moduleCode="+moduleCode+"&moduleHeader="+moduleHeader+
				      "&moduleValue="+moduleValue+"&detailPage="+detailPage+"&actionType="+actionType+"&caseStatus="+caseStatus+
				      "&flagType="+flagType+"&formId="+formId;
    		
			caseWorkFlowActions.openModalForCaseWorkFlow("Add Comment For Raising Case For STR", url);
		},
		recommendForSuppressionByAMLUser : function(tableParentDivId, divId){
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
			   alert('Please select atleast one case to assign.');
			   return false;
			} else if(intSelectedCount > 1 ) {
			   alert('Please select only one case to assign.');
			   return false;
			}
			
			var formId = $("#"+tableParentDivId).parents("div.row").find("form").attr("id");
			
			var selectedCase = selectedCases.substr(0,selectedCases.length-1);
			/*var url = "/amlCaseWorkFlow/assignToBranchUser?CaseNos="+selectedCase+"&CaseStatus=1&FlagType=Y&formId="+formId;*/
			
			
			var moduleCode = "viewComments";
			var moduleHeader = "";
			var moduleValue = selectedCase;
			var actionType = "recommendForSuppressionByAMLUser";
			var detailPage = "AMLCaseWorkFlow/AddViewCommentsWithHistory";
			var caseStatus = "5";
			var flagType = "Y";

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
    		var url = "/amlCaseWorkFlow/getCaseWorkflowModuleDetails?fromDate="+CM_FROMDATE+"&toDate="+CM_TODATE+
    				  "&alertCode="+CM_ALERTCODE+"&branchCode="+CM_BRANCHCODE+"&accountNo="+CM_ACCOUNTNO+
				      "&customerId="+CM_CUSTOMERID+"&hasAnyOldCases="+CM_HASANYOLDCASES+"&caseRating="+CM_CASERATING+
				      "&fromCaseNo="+CM_FROMCASENO+"&toCaseNo="+CM_TOCASENO+"&moduleCode="+moduleCode+"&moduleHeader="+moduleHeader+
				      "&moduleValue="+moduleValue+"&detailPage="+detailPage+"&actionType="+actionType+"&caseStatus="+caseStatus+
				      "&flagType="+flagType+"&formId="+formId;
			
			caseWorkFlowActions.openModalForCaseWorkFlow("Add Comment For Recommending Case For Suppression", url);
		},
		approvedByAMLO: function(tableParentDivId, divId){
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
			   alert('Please select atleast one case to assign.');
			   return false;
			} else if(intSelectedCount > 1 ) {
			   alert('Please select only one case to assign.');
			   return false;
			}
			
			var formId = $("#"+tableParentDivId).parents("div.row").find("form").attr("id");
			
			var selectedCase = selectedCases.substr(0,selectedCases.length-1);
			/*var url = "/amlCaseWorkFlow/assignToBranchUser?CaseNos="+selectedCase+"&CaseStatus=1&FlagType=Y&formId="+formId;*/
			
			
			var moduleCode = "viewComments";
			var moduleHeader = "";
			var moduleValue = selectedCase;
			var actionType = "approvedByAMLO";
			var detailPage = "AMLCaseWorkFlow/AddViewCommentsWithHistory";
			var caseStatus = "8";
			var flagType = "Y";

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
    		var url = "/amlCaseWorkFlow/getCaseWorkflowModuleDetails?fromDate="+CM_FROMDATE+"&toDate="+CM_TODATE+
    				  "&alertCode="+CM_ALERTCODE+"&branchCode="+CM_BRANCHCODE+"&accountNo="+CM_ACCOUNTNO+
				      "&customerId="+CM_CUSTOMERID+"&hasAnyOldCases="+CM_HASANYOLDCASES+"&caseRating="+CM_CASERATING+
				      "&fromCaseNo="+CM_FROMCASENO+"&toCaseNo="+CM_TOCASENO+"&moduleCode="+moduleCode+"&moduleHeader="+moduleHeader+
				      "&moduleValue="+moduleValue+"&detailPage="+detailPage+"&actionType="+actionType+"&caseStatus="+caseStatus+
				      "&flagType="+flagType+"&formId="+formId;
			
			caseWorkFlowActions.openModalForCaseWorkFlow("Add Comment For Approving Case", url);
		},
		rejectedByAMLO: function(tableParentDivId, divId){
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
			   alert('Please select atleast one case to assign.');
			   return false;
			} else if(intSelectedCount > 1 ) {
			   alert('Please select only one case to assign.');
			   return false;
			}
			
			var formId = $("#"+tableParentDivId).parents("div.row").find("form").attr("id");
			
			var selectedCase = selectedCases.substr(0,selectedCases.length-1);
			/*var url = "/amlCaseWorkFlow/assignToBranchUser?CaseNos="+selectedCase+"&CaseStatus=1&FlagType=Y&formId="+formId;*/
			
			
			var moduleCode = "viewComments";
			var moduleHeader = "";
			var moduleValue = selectedCase;
			var actionType = "rejectedByAMLO";
			var detailPage = "AMLCaseWorkFlow/AddViewCommentsWithHistory";
			var caseStatus = "7";
			var flagType = "Y";

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
    		var url = "/amlCaseWorkFlow/getCaseWorkflowModuleDetails?fromDate="+CM_FROMDATE+"&toDate="+CM_TODATE+
    				  "&alertCode="+CM_ALERTCODE+"&branchCode="+CM_BRANCHCODE+"&accountNo="+CM_ACCOUNTNO+
				      "&customerId="+CM_CUSTOMERID+"&hasAnyOldCases="+CM_HASANYOLDCASES+"&caseRating="+CM_CASERATING+
				      "&fromCaseNo="+CM_FROMCASENO+"&toCaseNo="+CM_TOCASENO+"&moduleCode="+moduleCode+"&moduleHeader="+moduleHeader+
				      "&moduleValue="+moduleValue+"&detailPage="+detailPage+"&actionType="+actionType+"&caseStatus="+caseStatus+
				      "&flagType="+flagType+"&formId="+formId;
			
			caseWorkFlowActions.openModalForCaseWorkFlow("Add Comment For Rejecting Case", url);
		},
		raisedForReviewByAMLO: function(tableParentDivId, divId){
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
			   alert('Please select atleast one case to assign.');
			   return false;
			} else if(intSelectedCount > 1 ) {
			   alert('Please select only one case to assign.');
			   return false;
			}
			
			var formId = $("#"+tableParentDivId).parents("div.row").find("form").attr("id");
			
			var selectedCase = selectedCases.substr(0,selectedCases.length-1);
			/*var url = "/amlCaseWorkFlow/assignToBranchUser?CaseNos="+selectedCase+"&CaseStatus=1&FlagType=Y&formId="+formId;*/
			
			
			var moduleCode = "viewComments";
			var moduleHeader = "";
			var moduleValue = selectedCase;
			var actionType = "raisedForReviewByAMLO";
			var detailPage = "AMLCaseWorkFlow/AddViewCommentsWithHistory";
			var caseStatus = "22";
			var flagType = "Y";

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
    		var url = "/amlCaseWorkFlow/getCaseWorkflowModuleDetails?fromDate="+CM_FROMDATE+"&toDate="+CM_TODATE+
    				  "&alertCode="+CM_ALERTCODE+"&branchCode="+CM_BRANCHCODE+"&accountNo="+CM_ACCOUNTNO+
				      "&customerId="+CM_CUSTOMERID+"&hasAnyOldCases="+CM_HASANYOLDCASES+"&caseRating="+CM_CASERATING+
				      "&fromCaseNo="+CM_FROMCASENO+"&toCaseNo="+CM_TOCASENO+"&moduleCode="+moduleCode+"&moduleHeader="+moduleHeader+
				      "&moduleValue="+moduleValue+"&detailPage="+detailPage+"&actionType="+actionType+"&caseStatus="+caseStatus+
				      "&flagType="+flagType+"&formId="+formId;
			
			caseWorkFlowActions.openModalForCaseWorkFlow("Add Comment For Raising for Review", url);
		},
		approvedByMLRO: function(tableParentDivId, divId){
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
			   alert('Please select atleast one case to assign.');
			   return false;
			} else if(intSelectedCount > 1 ) {
			   alert('Please select only one case to assign.');
			   return false;
			}
			
			var formId = $("#"+tableParentDivId).parents("div.row").find("form").attr("id");
			
			var selectedCase = selectedCases.substr(0,selectedCases.length-1);
			/*var url = "/amlCaseWorkFlow/assignToBranchUser?CaseNos="+selectedCase+"&CaseStatus=1&FlagType=Y&formId="+formId;*/
			
			
			var moduleCode = "viewComments";
			var moduleHeader = "";
			var moduleValue = selectedCase;
			var actionType = "approvedByMLRO";
			var detailPage = "AMLCaseWorkFlow/AddViewCommentsWithHistory";
			var caseStatus = "10";
			var flagType = "Y";

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
    		var url = "/amlCaseWorkFlow/getCaseWorkflowModuleDetails?fromDate="+CM_FROMDATE+"&toDate="+CM_TODATE+
    				  "&alertCode="+CM_ALERTCODE+"&branchCode="+CM_BRANCHCODE+"&accountNo="+CM_ACCOUNTNO+
				      "&customerId="+CM_CUSTOMERID+"&hasAnyOldCases="+CM_HASANYOLDCASES+"&caseRating="+CM_CASERATING+
				      "&fromCaseNo="+CM_FROMCASENO+"&toCaseNo="+CM_TOCASENO+"&moduleCode="+moduleCode+"&moduleHeader="+moduleHeader+
				      "&moduleValue="+moduleValue+"&detailPage="+detailPage+"&actionType="+actionType+"&caseStatus="+caseStatus+
				      "&flagType="+flagType+"&formId="+formId;
			
			caseWorkFlowActions.openModalForCaseWorkFlow("Add Comment For Approving Case", url);
		},
		rejectedByMLRO: function(tableParentDivId, divId){
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
			   alert('Please select atleast one case to assign.');
			   return false;
			} else if(intSelectedCount > 1 ) {
			   alert('Please select only one case to assign.');
			   return false;
			}
			
			var formId = $("#"+tableParentDivId).parents("div.row").find("form").attr("id");
			
			var selectedCase = selectedCases.substr(0,selectedCases.length-1);
			/*var url = "/amlCaseWorkFlow/assignToBranchUser?CaseNos="+selectedCase+"&CaseStatus=1&FlagType=Y&formId="+formId;*/
			
			
			var moduleCode = "viewComments";
			var moduleHeader = "";
			var moduleValue = selectedCase;
			var actionType = "rejectedByMLRO";
			var detailPage = "AMLCaseWorkFlow/AddViewCommentsWithHistory";
			var caseStatus = "9";
			var flagType = "Y";

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
    		var url = "/amlCaseWorkFlow/getCaseWorkflowModuleDetails?fromDate="+CM_FROMDATE+"&toDate="+CM_TODATE+
    				  "&alertCode="+CM_ALERTCODE+"&branchCode="+CM_BRANCHCODE+"&accountNo="+CM_ACCOUNTNO+
				      "&customerId="+CM_CUSTOMERID+"&hasAnyOldCases="+CM_HASANYOLDCASES+"&caseRating="+CM_CASERATING+
				      "&fromCaseNo="+CM_FROMCASENO+"&toCaseNo="+CM_TOCASENO+"&moduleCode="+moduleCode+"&moduleHeader="+moduleHeader+
				      "&moduleValue="+moduleValue+"&detailPage="+detailPage+"&actionType="+actionType+"&caseStatus="+caseStatus+
				      "&flagType="+flagType+"&formId="+formId;
			
			caseWorkFlowActions.openModalForCaseWorkFlow("Add Comment For Rejecting Case", url);
		}
	
	};
}());
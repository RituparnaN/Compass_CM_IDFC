<%@ page language="java" contentType="text/html;charset=UTF-8"
	pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../tags/tags.jsp"%>

<c:set var="moduleDetails" value="${moduleDetails}"/>
<c:set var="TABNAMES" value="${moduleDetails['TABNAMES']}"/>
<c:set var="TABDISPLAY" value="${moduleDetails['TABDISPLAY']}"/>
<c:set var="ROLE" value="${f:substring(userRole,5,userRole.length())}"/>
<c:set var="action" value="${action}"/>
<c:set var="currentCaseStatus" value="${CASECOMMENTDETAILS['CASESTATUS']}" />
<c:set var="RECORDSIZE" value="${AlertDetails['RECORDS'].size()}"/>
<c:set var="PREVIOUS_USERCODE" value="${CASECOMMENTDETAILS['PREVIOUS_USERCODE']}" />
<c:set var="NONSUSPICIOUSCOMMENTS" value="${CASECOMMENTDETAILS['NONSUSPICIOUSCOMMENTS']}" />


<style type="text/css">
	.modalNav li a{
		font-size: 12px;
		padding: 5px 10px;
	}
	.datepicker{
		background-image:url("${pageContext.request.contextPath}/includes/images/calendar.png");
		background-repeat:no-repeat;
		background-position: 98%;
	} 
	
	table.compassModuleDetailsSearchTable tr td{
		border: 0px;
	}
	
	.autoCommentsSuggestion{
		resize: vertical;
	}
	
	textarea .viewCommentsTextarea{
		resize : both; max-width: 400px; min-width: 200px;
	}
	
	.ui-autocomplete{
		z-index: 215000000 !important;
	}
	.select2{
		display:none
	}
	
</style>
<script type="text/javascript">
	$(document).ready(function(){		
		
		try{
			document.getElementById('lastReviedDateMakerForm').valueAsDate = new Date();
			$(".selectpicker").selectpicker();
		}
		catch(e){
			
		}
		var id = '${UNQID}';
		var caseNos = '${caseNo}';
		var parentFormId = '${parentFormId}';
		var tableClass = 'modalDetailsTable'+id;
		var userRole = '${userRole}';
		var existingCaseStatus = '${currentCaseStatus}';
		/* if((existingCaseStatus == '4' || existingCaseStatus == '5' || existingCaseStatus == '6') && userRole == 'ROLE_AMLUSERL3'){
			userRole = 'ROLE_AMLO';
		} 	 */
		var flagType = '${flagType}';
		var caseStatus = '${caseStatus}';
		var customerId = '${inputCustomerId}';
		var addedToFalsePositive = 'N';
		var addToMarkAll = 'N';
		var evidenceCount;
		var FROMDATE = '${inputFromDate}';
		var TODATE = '${inputToDate}';
		var ALERTCODE = '${inputAlertCode}';
		var BRANCHCODE = '${inputBranchCode}';
		var ACCOUNTNO = '${inputAccountNo}';
		var CUSTOMERID = '${inputCustomerId}';
		var HASANYOLDCASES = '${inputHasAnyOldCases}';
		var CASERATING = '${inputCaseRating}';
		var FROMCASENO = '${inputFromCaseNo}';
		var TOCASENO = '${inputToCaseNo}';
		
		compassDatatable.construct(tableClass, "${MODULENAME}", true);

		$(".commentsHistoryContainer").find("select").select2({
  			dropdownParent: $("#compassCaseWorkFlowGenericModal")
  		});

		/*
		var tableClass = 'alertsListForAssignmentTable${UNQID}';
		compassDatatable.construct(tableClass, "Alerts List For Assignment Table", true);
		compassDatatable.enableCheckBoxSelection();
		*/
		/* $(".datepicker").datepicker({
			changeMonth: true,
			changeYear: true,
			dateFormat: _dateFormat
		}); */
		$(".validateComments").keyup(function(){
			var input = $(this).val();
			re = /[%'&<>]/gi;
			var isSplChar = re.test(input);
			if(isSplChar)
			{
				var no_spl_char = input.replace(/[%'&<>]/gi, '');
				$(this).val(no_spl_char);
			}
			/* if((/[^a-zA-Z0-9\-\/]/).test( input ) ) {
		        input = input.replace(/[^A-Z0-9]+/ig, "");
		        $(this).val(input);
		    } */
		});
		
		$(".datepicker").datepicker({
			changeMonth: true,
			changeYear: true,
			dateFormat: "dd/mm/yy"
		});
		
		$("#alertsListResultDiv"+id).find("table").children("tbody").children("tr").each(function(){
			var alertNo = $(this).children("td:nth-child(2)");
			alertNo.attr("onclick","openDetails(this, 'Alert Details', '"+alertNo.html()+"','alertEngine', 'AlertEngines/AlertDetails')");
		});
		
		$("#searchModuleDetails"+id).click(function(){
			/* alert(moduleDetails);
			alert(colValue); */
			var childWindow = $("#childWindow").val() != undefined ? "1" : "0";
			var moduleCode = $("#moduleCode"+id).val();
			var moduleHeader = $("#moduleHeader"+id).val();
			var moduleValue = $("#caseNo"+id).val();
			var detailPage = $("#detailPage"+id).val();
			if(childWindow == "1"){
				searchInChildWindow(moduleHeader, moduleValue, moduleCode, detailPage);
			}else{
				if($("#compassGenericModal").hasClass("in")){
					openDetails($(this), moduleHeader, moduleValue, moduleCode, detailPage);
				}else{
					openModalInTab($(this), moduleHeader, moduleValue, moduleCode, detailPage);
				}
			}
			
		});
		
		$(".panelSlidingViewComments"+id).click(function(){
			 if($(this).find("i").hasClass( "glyphicon-chevron-down" ))
			{
				 $(this).find("i").removeClass('glyphicon-chevron-down');
				 $(this).find("i").addClass('glyphicon-chevron-up');  
			}
			else{
				$(this).find("i").removeClass('glyphicon-chevron-up');
				$(this).find("i").addClass('glyphicon-chevron-down');
			}
		});
		
		$(".panelSlidingAddToFalsePositive"+id).click(function(){
			// alert($(this).find("i").hasClass( "glyphicon-chevron-down" ));
			 if($(this).find("i").hasClass( "glyphicon-chevron-down" ))
			{
				 $(this).find("i").removeClass('glyphicon-chevron-down');
				 $(this).find("i").addClass('glyphicon-chevron-up');  
			}
			else{
				$(this).find("i").removeClass('glyphicon-chevron-up');
				$(this).find("i").addClass('glyphicon-chevron-down');
			}
		});
		
		$(".panelSlidingAddComments"+id).click(function(){
			 if($(this).find("i").hasClass( "glyphicon-chevron-down" ))
			{
				 $(this).find("i").removeClass('glyphicon-chevron-down');
				 $(this).find("i").addClass('glyphicon-chevron-up');  
			}
			else{
				$(this).find("i").removeClass('glyphicon-chevron-up');
				$(this).find("i").addClass('glyphicon-chevron-down');
			}
		});
		$("#moduleValue"+id).keydown(function(event){
	        if(event.which=="13")
	        	$("#searchModuleDetails"+id).click();
		});
		
		$("#outcomeIndicator"+id).on("change", function(){
			if($(this).val() == "FUPR"){
				$("#highRiskRow").css("display", "table-row");
			}
			else{
				$("#highRiskRow").css("display", "none");
			}
		});
		
		$("#amlUserAddToFalsePositive"+id).change(function(){
			if($(this).prop("checked")){
				if(confirm('Are you sure to add this account in the false positive list?')){
					addedToFalsePositive = 'Y';	
					// alert("addedToFalsePositive= "+addedToFalsePositive);
				}else{
					addedToFalsePositive = 'N';
					// alert("addedToFalsePositive= "+addedToFalsePositive);
				}
			}
		});
		
		$("#amloAddToFalsePositive"+id).change(function(){
			if($(this).prop("checked")){
				if(confirm('Are you sure to add this account in the false positive list?')){
					addedToFalsePositive = 'Y';	
					// alert("addedToFalsePositive= "+addedToFalsePositive);
				}else{
					addedToFalsePositive = 'N';
					// alert("addedToFalsePositive= "+addedToFalsePositive);
				}
			}
		});
		
		$("#mlroAddToFalsePositive"+id).change(function(){
			if($(this).prop("checked")){
				if(confirm('Are you sure to add this account in the false positive list?')){
					addedToFalsePositive = 'Y';	
					
				}else{
					addedToFalsePositive = 'N';
				}
			}
		});
		
		$("input[name='addToMarkAll']").change(function(){
			// alert("customerId = "+customerId);
			// alert($(this).prop("checked"))
 			 if($(this).prop("checked")){
 				if(customerId == ''){
					alert('Please select customer id.');
					addToMarkAll = 'N';
					$(this).prop("checked",false);
				}else{
					if(confirm('Are you sure to mark all the cases?')){
						addToMarkAll = 'Y';	
					}else{
						addToMarkAll = 'N';
						$(this).prop("checked",false);
					}
				}
			 }else{
				 $(this).prop("checked",false);
				 addToMarkAll = 'N';
			 } 
		});
		
		$("#searchToAddToFalsePositive"+id).click(function(){
			var caseNo = $("#caseNo"+id).val();
			var searchButton = "searchToAddToFalsePositive${UNQID}";
			//alert(searchButton);
			//console.log(searchButton);
				$.ajax({
					url:"${pageContext.request.contextPath}/amlCaseWorkFlow/getAlertsForAddingToFalsePositive",
					data: "caseNo="+caseNo+"&searchButton="+searchButton,
					cache: false,
					type: "POST",
					success: function(res){
						$("#addFalsePositiveEntryDiv"+id).css("display","block");
						$("#addToFalsePostiveResultDiv"+id).html(res);
					},
					error: function(a,b,c){
						alert("Error While Updating : "+a+b+c);
						// alert(a+b+c);
					}
				});	
		});
		
	  $("#splitAndAssign"+id).click(function(){
		var rowCount =  ($("#alertsListResultDiv"+id).find("table").children("tbody").children("tr")).size();
		var caseNo = '${caseNo}'; 
		var selectedAlertNos = "";
		var caseStatus = "10001";
		var action = "Add Comments for Splitting and Assigning Cases";
		var formId = $("#addViewCommentsHistoryForm"+id);
		var modalId = "compassGenericModal";
		$("#alertsListResultDiv"+id).find("table").children("tbody").children("tr").each(function(){
   			var row = $(this).children("td").children("input[type='checkbox']");
   			var alertNo = $(this).children("td:nth-child(2)").html();  
   			
   			if($(row).prop("checked")){
   				selectedAlertNos = selectedAlertNos + alertNo +" ,";
   				//alert("selectedAlertNos = "+selectedAlertNos);
   			}
   		});
			var intSelectedCount = ((selectedAlertNos.split(",").length)-1);
			if(intSelectedCount == 0 || intSelectedCount == rowCount) {
			   alert('Please select atleast 1 alert and not more than '+(rowCount - 1)+' alerts to split and assign.');
			   return false;
			}else{
				if(confirm("Are you sure to split and assign alerts to users?")){
					$("#compassGenericModal").modal("show");
					$("#compassGenericModal-title").html(action);
					$.ajax({
						url:"${pageContext.request.contextPath}/amlCaseWorkFlow/openSplitAssignCasesModal",
						data: "alertNos="+selectedAlertNos+"&caseNo="+caseNo+"&caseStatus="+caseStatus+"&action="+action+"&formId="+formId+"&modalId="+modalId,
						cache: false,
						type: "POST",
						success: function(res){
							$("#compassGenericModal-body").html(res);
						},
						error: function(a,b,c){
							alert("Error While Updating : "+a+b+c);
							// alert(a+b+c);
						}
					});	
				}
			}
		}); 
	 
	 $("#addAlertComments"+id).click(function(){
			var caseNo = '${caseNo}'; 
			var selectedCount = "";
			var selectedAlertNo = "";
			var caseStatus = "20000";
			var action = "Add Alerts Comments";
			var formId = $("#addViewCommentsHistoryForm"+id);
			var modalId = "compassGenericModal";
			// alert(modalId);
			$("#alertsListResultDiv"+id).find("table").children("tbody").children("tr").each(function(){
	 			var row = $(this).children("td").children("input[type='checkbox']");
	 			var alertNo = $(this).children("td:nth-child(2)").html();  
	 			
	 			if($(row).prop("checked")){
	 				selectedAlertNo = alertNo;
	 				selectedCount++;
	 			}
 			});
			if(selectedCount == 0 || selectedCount > 1) {
			   alert('Please select only 1 alert to add comments.');
			   return false;
			}else{
				$("#compassGenericModal").modal("show");
				$("#compassGenericModal-title").html(action);
				$.ajax({
					url:"${pageContext.request.contextPath}/amlCaseWorkFlow/openAddAlertCommentsModal",
					data: "alertNos="+selectedAlertNo+"&caseNo="+caseNo+"&caseStatus="+caseStatus+"&action="+action+"&formId="+formId+"&modalId="+modalId,
					cache: false,
					type: "POST",
					success: function(res){
						$("#compassGenericModal-body").html(res);
					},
					error: function(a,b,c){
						// alert(a+b+c);
						alert("Error While Updating : "+a+b+c);
					}
				});	
			}
		}); 
		 
		$("#attachEvidence"+id).click(function(){
			if(caseNos.includes(",")){
				alert("Select only one case to attach any evidence.");
			}else{
				compassFileUpload.init("attachEvidence","${pageContext.request.contextPath}","5678","amlUserPendingCaseSerachResult"+id,"Y","Y",caseNos);
			}
		}); 
		 
		$("#viewEvidence"+id).click(function(){
			//alert(caseNos);
			var caseNos = '${caseNo}';
			compassFileUpload.init("attachEvidence","${pageContext.request.contextPath}","5678","amlUserPendingCaseSerachResult"+id,"N","N",caseNos);
		});
		
		$("#saveComments"+id).click(function(){
			var caseNos = $("#caseNo"+id).val();
			var comments = '';
			var lastReviewedDate = '';
			var fraudIndicator = '';
			var removalReason = '';
			var outcomeIndicator = '';
			var highRiskReasonCode = '';
			var reassignToUserCode = '';
			var assignedBranchCode = '';
			/* if(fraudIndicator == 'PNEF'){
				addedToFalsePositive = 'Y';
				$("#amluserAddToFalsePositive"+id).attr("checked","checked");
			}
			 */
			
			if(userRole == 'ROLE_USER'){
				lastReviewedDate = $("#userAcctReviewedDate"+id).val();
				reassignToUserCode = $("#amluserList"+id).val();
				fraudIndicator = $("#fraudIndicator"+id).val();
				comments  = $("#userComments"+id).val();
			} 
			else if(userRole == 'ROLE_AMLUSER' ){
				lastReviewedDate = $("#amluserAcctReviewedDate"+id).val();
				fraudIndicator = $("#fraudIndicator"+id).val();
				comments  = $("#amluserComments"+id).val();
				reassignToUserCode = $("#amloList"+id).val();
				assignedBranchCode = $("#assignedBranch"+id).val();
			}
			else if(userRole == 'ROLE_AMLO'){
				lastReviewedDate = $("#amloAcctReviewedDate"+id).val();
				fraudIndicator = $("#fraudIndicator"+id).val();
				comments  = $("#amloComments"+id).val();
				// outcomeIndicator = $('#outcomeIndicator'+id).val();
				// removalReason = $('#removalReason'+id).val();
				// highRiskReasonCode = $('#highRiskReasonCode'+id).val();
				/*
				if(caseStatus != '7'){
 				   reassignToUserCode = $("#mlroList"+id).val();
				}
				*/
				reassignToUserCode = $("#mlroList"+id).val();
			}
			else if(userRole == 'ROLE_MLRO'){
				lastReviewedDate = $("#mlroAcctReviewedDate"+id).val();
				fraudIndicator = $("#fraudIndicator"+id).val();
				comments  = $("#mlroComments"+id).val();
				reassignToUserCode = $("#mlroList"+id).val();
				// outcomeIndicator = $('#outcomeIndicator'+id).val();
				// removalReason = $('#removalReason'+id).val();
				// highRiskReasonCode = $('#highRiskReasonCode'+id).val();
			}
			
			//alert(assignedBranchCode+", "+caseNos+", "+comments+", "+lastReviewedDate+", "+fraudIndicator+", "+flagType+", "+caseStatus+", "+removalReason+", "+addedToFalsePositive);
			var fullData ="CaseNos="+caseNos+"&LastReviewedDate="+lastReviewedDate+"&Comments="+comments+"&FlagType="+flagType+
						  "&CaseStatus="+caseStatus+"&OutcomeIndicator="+outcomeIndicator+"&RemovalReason="+removalReason+"&amlUserAddToMarkAll="+addToMarkAll+
						  "&AddedToFalsePositive="+addedToFalsePositive+"&HighRiskReasonCode="+highRiskReasonCode+"&FraudIndicator="+fraudIndicator+
				          "&userActionType=saveOnly&reassignToUserCode="+reassignToUserCode+
				          "&FROMDATE="+FROMDATE+"&TODATE="+TODATE+"&TODATE="+TODATE+"&ALERTCODE="+ALERTCODE+"&BRANCHCODE="+BRANCHCODE+"&ACCOUNTNO="+ACCOUNTNO+
				          "&CUSTOMERID="+CUSTOMERID+"&HASANYOLDCASES="+HASANYOLDCASES+"&CASERATING="+CASERATING+"&FROMCASENO="+FROMCASENO+"&TOCASENO="+TOCASENO+
				          "&AssignedBranchCode="+assignedBranchCode;
				if(lastReviewedDate == '' || comments == ''){
					alert('Please enter Account Reviewed Date and Comments.');
				}else if(comments.length > 4000){
					alert('Comments cannot exceed 4000 characters.');
				}else{
					$.ajax({
	 					url: "${pageContext.request.contextPath}/amlCaseWorkFlow/saveComments",
						cache: false,
						type: "POST",
						data: fullData,
						success: function(res){
							alert("Saved successfully.");
							$("#"+parentFormId).submit();
							$("#compassCaseWorkFlowGenericModal").modal("hide");
							$(".compass-tab-content").find("div.active").find("form").submit();
						},
						error: function(a,b,c){
							// alert(a+b+c);
							alert("Error While Updating : "+a+b+c);
						}
					});
				
			}
		}); 

		$("#saveAndCloseComments"+id).click(function(){
			var caseNos = $("#caseNo"+id).val();
			var comments = '';
			var lastReviewedDate = '';
			var fraudIndicator = '';
			var removalReason = '';
			var outcomeIndicator = '';
			var highRiskReasonCode = '';
			var reassignToUserCode = '';
			var assignedBranchCode = '';
			
			if(fraudIndicator == 'PNEF'){
				addedToFalsePositive = 'Y';
				$("#amluserAddToFalsePositive"+id).attr("checked","checked");
			}
			
			if(userRole == 'ROLE_USER'){
				lastReviewedDate = $("#userAcctReviewedDate"+id).val();
				reassignToUserCode = $("#amluserList"+id).val();
				fraudIndicator = $("#fraudIndicator"+id).val();
				comments  = $("#userComments"+id).val();
			} 
			else if(userRole == 'ROLE_AMLUSER'){
				lastReviewedDate = $("#amluserAcctReviewedDate"+id).val();
				fraudIndicator = $("#fraudIndicator"+id).val();
				comments  = $("#amluserComments"+id).val();
				reassignToUserCode = $("#amloList"+id).val();
				assignedBranchCode = $("#assignedBranch"+id).val();
			}
			else if(userRole == 'ROLE_AMLO'){
				lastReviewedDate = $("#amloAcctReviewedDate"+id).val();
				fraudIndicator = $("#fraudIndicator"+id).val();
				comments  = $("#amloComments"+id).val();
				outcomeIndicator = $("#outcomeIndicator"+id).val();
				removalReason = $("#removalReason"+id).val();
				highRiskReasonCode = $("#highRiskReasonCode"+id).val();
				reassignToUserCode = $("#mlroList"+id).val();
			}
			else if(userRole == 'ROLE_MLRO'){
				lastReviewedDate = $("#mlroAcctReviewedDate"+id).val();
				fraudIndicator = $("#fraudIndicator"+id).val();
				comments  = $("#mlroComments"+id).val();
				outcomeIndicator = $("#outcomeIndicator"+id).val();
				removalReason = $("#removalReason"+id).val();
				highRiskReasonCode = $("#highRiskReasonCode"+id).val();
				reassignToUserCode = $("#mlroList"+id).val();
			}
			//alert(addToMarkAll);
			//alert(caseNos+", "+comments+", "+lastReviewedDate+", "+reassignToUserCode+", "+fraudIndicator+", "+flagType+", "+caseStatus+", "+removalReason+", "+addedToFalsePositive);
			var fullData ="CaseNos="+caseNos+"&LastReviewedDate="+lastReviewedDate+"&Comments="+comments+"&FlagType="+flagType+
						  "&CaseStatus="+caseStatus+"&OutcomeIndicator="+outcomeIndicator+"&RemovalReason="+removalReason+"&amlUserAddToMarkAll="+addToMarkAll+
						  "&AddedToFalsePositive="+addedToFalsePositive+"&HighRiskReasonCode="+highRiskReasonCode+"&FraudIndicator="+fraudIndicator+
				          "&userActionType=saveAndClose&reassignToUserCode="+reassignToUserCode+
				          "&FROMDATE="+FROMDATE+"&TODATE="+TODATE+"&TODATE="+TODATE+"&ALERTCODE="+ALERTCODE+"&BRANCHCODE="+BRANCHCODE+"&ACCOUNTNO="+ACCOUNTNO+
				          "&CUSTOMERID="+CUSTOMERID+"&HASANYOLDCASES="+HASANYOLDCASES+"&CASERATING="+CASERATING+"&FROMCASENO="+FROMCASENO+"&TOCASENO="+TOCASENO+
				          "&AssignedBranchCode="+assignedBranchCode;
			if(caseStatus == '10000000'){
				if(comments == '' ){
					alert('Please enter Comments.');
				}else if(comments.length > 4000){
					alert('Comments cannot exceed 4000 characters.');
				}else{
					$.ajax({
						url: "${pageContext.request.contextPath}/amlCaseWorkFlow/saveComments",
						cache: false,
						type: "POST",
						data: fullData,
						success: function(res){
							alert("Saved successfully.");
							$("#"+parentFormId).submit();
							$("#compassCaseWorkFlowGenericModal").modal("hide");
							$(".compass-tab-content").find("div.active").find("form").submit();
						},
						error: function(a,b,c){
							alert("Error While Updating : "+a+b+c);
							// alert(a+b+c);
						}
					});
				}
			}else{
				// if(lastReviewedDate == '' || comments == '' ){
				if(comments == '' ){	
					alert('Please enter Comments.');
				}else if(comments.length > 4000){
					alert('Comments cannot exceed 4000 characters.');
				}else{
					$.ajax({
						url: "${pageContext.request.contextPath}/amlCaseWorkFlow/getEvidenceAttachedCount",
						data : "caseNo="+caseNos,
						cache:	false,
						type: "POST",
						success: function(response){
							//alert(response);
							if(response == 0){
								if(confirm("No evidence has been attached - Details Saved successfully. Click Ok to proceed or Cancel to attach evidence.")){
									$.ajax({
										url: "${pageContext.request.contextPath}/amlCaseWorkFlow/saveComments",
										cache: false,
										type: "POST",
										data: fullData,
										success: function(res){
											// alert("Saved successfully.");
											$("#"+parentFormId).submit();
											$("#compassCaseWorkFlowGenericModal").modal("hide");
											$(".compass-tab-content").find("div.active").find("form").submit();
										},
										error: function(a,b,c){
											alert("Error While Updating"+a+b+c);
										}
									});
								}
							}else{
								$.ajax({
									url: "${pageContext.request.contextPath}/amlCaseWorkFlow/saveComments",
									cache: false,
									type: "POST",
									data: fullData,
									success: function(res){
										alert("Details Saved successfully.");
										$("#"+parentFormId).submit();
										$("#compassCaseWorkFlowGenericModal").modal("hide");
										$(".compass-tab-content").find("div.active").find("form").submit();
									},
									error: function(a,b,c){
										//alert(a+b+c);
										alert("Error While Updating : "+a+b+c);
									}
								});
							}
						}, 
						error: function(a,b,c){
							// alert(a+b+c);
							alert("Error While Updating : "+a+b+c);
						}				
					});	
				}
			}
		}); 
		
		
		
		 $("#openModalInTab").click(function(){
			var moduleCode = $("#compassGenericModal-body").find("div.card-body").children("input#moduleCode"+id).val();
			var moduleHeader = $("#compassGenericModal-body").find("div.card-body").children("input#moduleHeader"+id).val();
			var moduleValue = $("#compassGenericModal-body").find("div.card-body").find("input#moduleValue"+id).val();
			var detailPage = $("#compassGenericModal-body").find("div.card-body").children("input#detailPage"+id).val();
			if(moduleValue != undefined)
				openModalInTab($(this), moduleHeader, moduleValue, moduleCode, detailPage);
		});
		
		$("#openModalInWindow").click(function(){
			var moduleCode = $("#compassGenericModal-body").find("div.card-body").children("input#moduleCode"+id).val();
			var moduleHeader = $("#compassGenericModal-body").find("div.card-body").children("input#moduleHeader"+id).val();
			var moduleValue = $("#compassGenericModal-body").find("div.card-body").find("input#moduleValue"+id).val();
			var detailPage = $("#compassGenericModal-body").find("div.card-body").children("input#detailPage"+id).val();
			if(moduleValue != undefined)
				openModalInWindow($(this), moduleHeader, moduleValue, moduleCode, detailPage, true);
		});
		
		var availableComments = [];
		<c:forEach var="comments" items="${SUGGESTEDCOMMENTS}">
			availableComments.push('${comments}');
		</c:forEach>    
	
		 
		console.log(availableComments);
	
		function split(val) {
		    return val.split("\n");
		}
	
		function extractLast(term) {
		    return split(term).pop();
		}
		
		
		$("#escalateCaseButton").click(function() {
			
			 var caseNo = '${caseNo}'
			 var crn = '${COMPASSREFNO}'
			 var caseId = $("#caseId").val()
			 var options  = $("#options").val()
			 var remarks  = $("#remarks").val()
			 var comments  = $("#makerComments").val()
			 var checkerList  = $("#checkerList").val()
			 var data = "";
			 if(comments == ""){
				 alert("please provide commetns")
			 }
			 else{
			 if(remarks != undefined){
				 
			 	data = "caseNo="+caseNo+"&caseId="+caseId+"&options="+options+"&remarks="+remarks+"&comments="+comments+"&checkerList="+checkerList+"&compassRefNo="+crn
			 }
			 else{
			 	data = "caseNo="+caseNo+"&caseId="+caseId+"&options="+options+"&comments="+comments+"&checkerList="+checkerList+"&compassRefNo="+crn
				
			 }
			 			
				 $.ajax({
					url : "${pageContext.request.contextPath}/common/escalateCase",
					cache : false,
					type : "POST",
					data : data,
					success : function(res) {
						$("#compassMediumGenericModal").modal("hide");
						alert("Case Escalated SuccessFully")
						reloadTabContent();
					},
					error : function(a, b, c) {
						alert(a + b + c);
					}
				}); 
			 }
			 
		})
		
		 $(".autoCommentsSuggestion")
		    // don't navigate away from the field on tab when selecting an item
		    .on("keydown", function(event) {
		      if (event.keyCode === $.ui.keyCode.TAB &&
		        $(this).autocomplete("instance").menu.active) {
		        event.preventDefault();
		      }
		    })
		    .autocomplete({
		      minLength: 1,
		      source: function(request, response) {
		        // delegate back to autocomplete, but extract the last term
		        response($.ui.autocomplete.filter(
		          availableComments, extractLast(request.term)));
		      },
		      focus: function() {
		        // prevent value inserted on focus
		        return false;
		      },
		      open: function() {
		          $("ul.ui-menu").width( $(this).innerWidth() );
		      },
		      select: function(event, ui) {
		        var terms = split(this.value);
		        // remove the current input
		        terms.pop();
		        // add the selected item
		        //terms.push("\u2022 " + ui.item.value); for adding bullets
		        terms.push(ui.item.value);
		        // add placeholder to get the comma-and-space at the end
		        terms.push("");
		        this.value = terms.join("\r\n");
		        return false;
		      }
		    });	
			
	});	
	function checkerAction(action) {
		
		var caseNo = '${caseNo}'
		var caseId = $("#caseId").val()
		var crn = '${COMPASSREFNO}'
		var comments  = $("#checkerComments").val()
		if (comments.length == 0) {
			alert("Please provide comments")
		} else {
			
			 $.ajax({
				url : "${pageContext.request.contextPath}/common/checkerAction",
				cache : false,
				type : "POST",
				data : "caseNo="+caseNo+"&caseId="+caseId+"&comments="+comments+"&checkerAction="+action+"&compassRefNo="+crn,
				success : function(res) {
					$("#compassMediumGenericModal").modal("hide");
					alert(res+" SuccessFully")
					reloadTabContent();
				},
				error : function(a, b, c) {
					alert(a + b + c);
				}
			}); 
		}
	}
	
</script>
<form id="addViewCommentsHistoryForm${UNQID}">
	<div class="container commentsHistoryContainer" style="width: 100%;">
		<div class="row">
			<div class="col-sm-12">
				<div class="card card-primary">
					<div class="row">
						<div class="col-sm-3"></div>
						<div class="col-sm-6">
							<div class="card-body"
								style="text-align: center; padding: 5px 0px;">
								<input type="hidden" name="moduleCode" id="moduleCode${UNQID}"
									value="${moduleCode}" /> <input type="hidden" name="detailPage"
									id="detailPage${UNQID}" value="${detailPage}" /> <input
									type="hidden" name="moduleHeader" id="moduleHeader${UNQID}"
									value="${moduleHeader}" />
								<table class="table compassModuleDetailsSearchTable"
									style="margin-bottom: 0px;">
									<%-- <tr>
									<td>
										${moduleDetails}
									</td>
								</tr> --%>
									<tr>
										<c:choose>
											<c:when
												test="${ROLE eq 'CM_OFFICER' && action eq 'viewComments'}">
												<td width="30%">Question Id</td>
											</c:when>
											<c:otherwise>
												<td width="30%"><spring:message
														code="app.common.CASENO" /></td>

											</c:otherwise>
										</c:choose>
										<td width="40%"><input type="text"
											class="form-control input-sm" name="caseNo"
											id="caseNo${UNQID}" value="${caseNo}" readOnly /></td>

										<c:if
											test="${action eq 'viewComments' && ROLE ne 'CM_MAKER' && ROLE ne 'CM_CHECKER' && ROLE ne 'CM_OFFICER'}">
											<td width="30%"><button type="button"
													class="btn btn-primary btn-sm" id="viewEvidence${UNQID}">
													<spring:message code="app.common.viewEvidence" />
												</button></td>
										</c:if>
										<!--
									<td width="30%"><button type="button" class="btn btn-primary btn-sm" id="searchModuleDetails${UNQID}"><spring:message code="app.common.searchButton"/></button></td>
									-->
									</tr>
									<%-- <tr>
									<td>
										${CASECOMMENTDETAILS}
									</td>
								</tr> --%>
								</table>
							</div>
						</div>
						<div class="col-sm-3"></div>
					</div>
				</div>
			</div>
		</div>

		<c:if test="${action eq 'viewComments' && ROLE eq 'CM_OFFICER'}">
			<div class="row">
				<div class="col-sm-12">

					<div class="card card-primary commentsMainDiv${UNQID}">
						<div class="card-header panelSlidingAddComments${UNQID} clearfix"
							id="${varStatus.index}slidingAddCommentsPanel${UNQID}"
							data-toggle="collapse"
							data-target="#${tabIndex}addCommentsDiv${varStatus.index}">
							<h6 class="card-title pull-${dirL}">Approved case Responses</h6>
							<div class="btn-group pull-${dirR} clearfix">
								<span class="pull-right"><i
									class="collapsable fa fa-chevron-down"></i></span>
							</div>
						</div>
						<div id="${tabIndex}addCommentsDiv${varStatus.index}">
							<c:set var="RESPONSECOUNT"
								value="${f:length(APPROVEDCASERESPONSES.RESPONSES)}"
								scope="page" />
							<c:choose>
								<c:when test="${RESPONSECOUNT > 0}">
									<c:forEach var='RESPONSE'
										items="${APPROVEDCASERESPONSES.RESPONSES}">

										<div class='card card-primary'
											style="margin: .5%; padding-top: 1px;">

											<table class="table table-striped">


												<tr>
													<td width="15%">Case No</td>
													<td width="30%"><input type='text' readonly
														name="caseId" id="caseId" class='form-control input-sm'
														value="${RESPONSE.CASENO}" /></td>
													<td width="10%"></td>
													<td width="15%">Options</td>
													<td width="30%"><input class="form-control input-sm"
														readonly value="${RESPONSE.OPTIONS}" /></td>

												</tr>

												<tr>
													<td width="15%">Remarks</td>
													<td width="30%"><input class="form-control input-sm"
														readonly value="${RESPONSE.REMARKS}" /></td>

													<td width="10%"></td>
													<td width="15%">Maker Code</td>
													<td width="30%"><input class="form-control input-sm"
														readonly value="${RESPONSE.MAKERCODE}" /></td>
												</tr>
												<tr>
													<td width="15%">Checker Code</td>
													<td width="30%"><input class="form-control input-sm"
														readonly value="${f:replace(RESPONSE.CHECKERCODE,',','')}" />
													</td>
													<td colspan="3"></td>

												</tr>

											</table>
										</div>
									</c:forEach>
								</c:when>
								<c:otherwise>
									<br />
									<center>No Responses Found</center>
									<br />
								</c:otherwise>
							</c:choose>
						</div>
					</div>
				</div>
			</div>
		</c:if>

		<div class="row">
			<div class="col-sm-12">
				<div class="card card-primary">
					<ul class="nav nav-pills modalNav" role="tablist">
						<c:forEach var="tab" items="${TABNAMES}" varStatus="tabIndex">
							<%-- <c:if test="${tabIndex.index == 0}">class="active"</c:if> --%>
							<%-- console.log(${f:startsWith(ROLE,tab)}); --%>
							<li role="presentation"><c:choose>
									<c:when test="${tab eq 'USER'}">
										<a class="subTab nav-link"
											href="#${moduleCode}${UNQID}${tabIndex.index}"
											aria-controls="tab" role="tab" data-toggle="tab">BRANCHUSER</a>
									</c:when>
									<c:otherwise>
										<a
											class="subTab nav-link <c:if test="${f:startsWith(ROLE,tab)}"><c:out value='active'/></c:if>"
											href="#${moduleCode}${UNQID}${tabIndex.index}"
											aria-controls="tab" role="tab" data-toggle="tab">${tab}</a>
									</c:otherwise>
								</c:choose></li>
						</c:forEach>
					</ul>

					<div class="tab-content">
						<c:forEach var="tab" items="${TABNAMES}" varStatus="tabIndex">
							<%-- <div role="tabpanel" class="tab-pane <c:if test="${tabIndex.index == 0}">active</c:if>" id="${moduleCode}${UNQID}${tabIndex.index}"> --%>
							<div role="tabpanel"
								class="tab-pane <c:if test="${f:startsWith(ROLE,tab)}">active</c:if>"
								id="${moduleCode}${UNQID}${tabIndex.index}">
								<c:set var="tabIndex">${tabIndex.index}</c:set>
								<c:set var="tabDetail" value="${moduleDetails[tabIndex]}" />
								<c:set var="RECORDCOUNT" value="${f:length(tabDetail)}"
									scope="page" />
								<c:choose>
									<c:when test="${TABDISPLAY[tabIndex] eq 'T'}">
										<c:choose>
											<c:when test="${RECORDCOUNT > 0}">
												<table
													class="table table-striped table-bordered searchResultGenericTable modalDetailsTable${UNQID}">
													<thead>
														<c:forEach var="recordDetails" items="${tabDetail}"
															begin="0" end="0">
															<tr>
																<c:forEach var="fieldDetails" items="${recordDetails}">
																	<c:set var="colArray"
																		value="${f:split(fieldDetails.key, '.')}" />
																	<c:set var="colArrayCnt" value="${f:length(colArray)}" />
																	<th id="${colArray[colArrayCnt-1]}"><spring:message
																			code="${fieldDetails.key}" /></th>
																</c:forEach>
															</tr>
														</c:forEach>
													</thead>
													<tbody>
														<c:forEach var="recordDetails" items="${tabDetail}">
															<tr>
																<c:forEach var="fieldDetails" items="${recordDetails}">
																	<td data-toggle="tooltip" data-placement="auto"
																		title="${fieldDetails.value}" data-container="body">${fieldDetails.value}</td>
																</c:forEach>
															</tr>
														</c:forEach>
													</tbody>
												</table>
											</c:when>
											<c:otherwise>
												<br />
												<center>No ${tab} Record Found</center>
												<br />
											</c:otherwise>
										</c:choose>
									</c:when>
									<c:otherwise>
										<c:if
											test="${f:startsWith(ROLE,tab) && action ne 'viewComments'}">

											<div class="card card-primary commentsMainDiv${UNQID}"
												style="margin: 10px 5px 5px 5px;">
												<div
													class="card-header panelSlidingAddComments${UNQID} clearfix"
													id="${varStatus.index}slidingAddCommentsPanel${UNQID}"
													data-toggle="collapse"
													data-target="#${tabIndex}addCommentsDiv${varStatus.index}">
													<h6 class="card-title pull-${dirL}">Add Comments</h6>
													<div class="btn-group pull-${dirR} clearfix">
														<span class="pull-right"><i
															class="collapsable fa fa-chevron-down"></i></span>
													</div>
												</div>
												<div id="${tabIndex}addCommentsDiv${varStatus.index}">
													<table class="table table-striped">
														<tr>
															<c:if
																test="${action eq 'escalateCase' && ROLE eq 'CM_MAKER'}">


																<tr>
																	<td width="15%">Question Id</td>
																	<td width="30%"><input type='text' readonly
																		name="caseId" id="caseId"
																		class='form-control input-sm'
																		value="${CASEMETADETAILS.QUESTIONID}.${CASEMETADETAILS.VERSION_SEQNO}" />
																	</td>
																	<td width="10%"></td>
																	<td width="15%">Last Reviewed Date</td>
																	<td width="30%"><input
																		class="form-control input-sm" type='date' readonly
																		id="lastReviedDateMakerForm" /></td>

																</tr>
																<tr>
																	<td width="15%">Question</td>
																	<td colspan="4"><textarea name="question"
																			style='margin-bottom: 10px; min-height: 50px'
																			class='form-control' disabled>${CASEMETADETAILS.QUESTIONDESCRIPTION}</textarea>

																	</td>
																</tr>
																<tr>
																	<td width="15%">Options</td>
																	<td width="30%"><select name="options"
																		id="options"
																		class='form-control input-sm selectpicker'>
																			<c:forEach var="option"
																				items="${CASEMETADETAILS.OPTIONSLIST}">
																				<option value="${option}">${option}</option>
																			</c:forEach>
																	</select></td>
																	<!-- <td>
													<select class = "form-control selectpicker">
														<option>a</option>
														<option>a</option>
														<option>a</option>
													</select>
													</td> -->
																	<td width="10%"></td>
																	<td width="15%">Remarks</td>
																	<td width="30%"><c:if
																			test="${CASEMETADETAILS.ISFREETEXTAREAREQUIRED == 'Y'}">

																			<textarea name="remarks" id="remarks"
																				style='margin-bottom: 10px' class='form-control'></textarea>

																		</c:if> <c:if
																			test="${CASEMETADETAILS.ISFREETEXTAREAREQUIRED == 'N'}">

																			<textarea name="remarks" style='margin-bottom: 10px'
																				class='form-control' disabled> No remarks needed to this question</textarea>

																		</c:if></td>
																</tr>
																<tr>
																	<td width="15%">List of Users</td>
																	<td width="30%">
																		<!-- <select name ="checkerList" class='form-control selectpicker' required multiple='multiple'> -->
																		<select name="checkerList" id="checkerList"
																		class='form-control input-sm selectpicker'>
																			<c:forEach var="checker"
																				items="${CASEMETADETAILS.CHECKERSLIST}">
																				<option value="${checker}">${checker}</option>
																			</c:forEach>
																	</select>
																	</td>
																	<td colspan="3"></td>


																</tr>
																<tr>
																	<td width="15%">Comments:</td>
																	<td colspan="4"><textarea name="comments"
																			id="makerComments" style='margin-bottom: 10px'
																			class='form-control' required></textarea></td>
																</tr>

																<!-- <tr>
											<td colspan="5">
												<div style="float: right">
													
												</div>
											</td>
										</tr> -->
															</c:if>
															<c:if
																test="${action eq 'checkerAction' && ROLE eq 'CM_CHECKER'}">

																<tr>
																	<td width="15%">Question Id</td>
																	<td width="30%"><input type='text' readonly
																		name="caseId" id="caseId"
																		class='form-control input-sm'
																		value="${CASEMETADETAILS.QUESTIONID}.${CASEMETADETAILS.VERSION_SEQNO}" />
																	</td>
																	<td width="10%"></td>
																	<td width="15%">Last Reviewed Date</td>
																	<td width="30%"><input
																		class="form-control input-sm" type='date' readonly
																		id="lastReviedDateMakerForm" /></td>

																</tr>
																<tr>
																	<td width="15%">Question</td>
																	<td colspan="4"><textarea name="question"
																			style='margin-bottom: 10px; min-height: 50px'
																			class='form-control' disabled>${CASEMETADETAILS.QUESTIONDESCRIPTION}</textarea>

																	</td>
																</tr>
																<tr>
																	<td width="15%">Options</td>
																	<td width="30%">
																		<%-- <select name="options" id = "options"
															class='form-control selectpicker'>
																<c:forEach var="option"
																	items="${CASEMETADETAILS.OPTIONSLIST}">
																	<option
																		value="${CASEMETADETAILS.OPTIONSVALUELIST[option]}->${option}">${option}</option>
																</c:forEach>
														</select>  --%> <input type="text"
																		class="form-control input-sm"
																		name="userAcctReviewedDate" disabled
																		value="${CASEMETADETAILS.ESCALATIONOPTION}" />

																	</td>
																	<td width="10%"></td>
																	<td width="15%">Remarks</td>
																	<td width="30%"><c:if
																			test="${CASEMETADETAILS.ISFREETEXTAREAREQUIRED == 'Y'}">

																			<textarea name="remarks" id="remarks"
																				style='margin-bottom: 10px' class='form-control'
																				disabled>${CASEMETADETAILS.ESCALATIONREMARKS}</textarea>

																		</c:if> <c:if
																			test="${CASEMETADETAILS.ISFREETEXTAREAREQUIRED == 'N'}">

																			<textarea name="remarks" style='margin-bottom: 10px'
																				class='form-control' disabled> No remarks needed to this question</textarea>

																		</c:if></td>
																</tr>

																<tr>
																	<td width="15%">Comments:</td>
																	<td colspan="4"><textarea name="comments"
																			id="checkerComments" style='margin-bottom: 10px'
																			class='form-control' required></textarea></td>
																</tr>

																<!-- <tr>
											<td colspan="5">
												<div style="float: right">
													
												</div>
											</td>
										</tr> -->
															</c:if>
															<c:if
																test="${action ne 'mergeCase' && action ne 'escalateCase' && action ne 'checkerAction'}">
																<td width="20%">Account Reviewed Date</td>
																<c:if test="${ROLE eq 'USER'}">
																	<td width="25%"><input type="text"
																		class="form-control input-sm datepicker"
																		name="userAcctReviewedDate"
																		id="userAcctReviewedDate${UNQID}" disabled
																		style="width: 100%"
																		value="${CASECOMMENTDETAILS['CASEACCTREVIEWEDDATE']}" />
																	</td>
																</c:if>
																<c:if test="${ROLE eq 'AMLUSER'}">
																	<td width="25%"><input type="text"
																		class="form-control input-sm datepicker"
																		name="amluserAcctReviewedDate"
																		id="amluserAcctReviewedDate${UNQID}" disabled
																		style="width: 100%"
																		value="${CASECOMMENTDETAILS['CASEACCTREVIEWEDDATE']}" />
																	</td>
																</c:if>
																<c:if test="${ROLE eq 'AMLO'}">
																	<td width="25%"><input type="text"
																		class="form-control input-sm datepicker"
																		name="amloAcctReviewedDate"
																		id="amloAcctReviewedDate${UNQID}" disabled
																		style="width: 100%"
																		value="${CASECOMMENTDETAILS['CASEACCTREVIEWEDDATE']}" />
																	</td>
																</c:if>
																<c:if test="${ROLE eq 'MLRO'}">
																	<td width="25%"><input type="text"
																		class="form-control input-sm datepicker"
																		name="mlroAcctReviewedDate"
																		id="mlroAcctReviewedDate${UNQID}" disabled
																		style="width: 100%"
																		value="${CASECOMMENTDETAILS['CASEACCTREVIEWEDDATE']}" />
																	</td>
																</c:if>
																<td width="10%">&nbsp;</td>
															</c:if>
															<c:if
																test="${empty SUSPICIONINDICATORS && action ne 'escalateCase' && action ne 'checkerAction'}">
																<td width="20%">Sub-Action</td>
																<td width="25%"><select
																	class="form-control input-sm" name="fraudIndicator"
																	id="fraudIndicator${UNQID}" style="width: 100%">
																		<option value="NA">Not Available
																		<option>
																</select></td>
															</c:if>

															<c:if
																test="${not empty SUSPICIONINDICATORS && action ne 'escalateCase'}">
																<td width="20%">Sub-Action</td>
																<td width="25%"><select
																	class="form-control input-sm" name="fraudIndicator"
																	id="fraudIndicator${UNQID}" style="width: 100%">
																		<c:forEach var="suspicionIndicators"
																			items="${SUSPICIONINDICATORS}">
																			<option
																				value="${suspicionIndicators.SUSPICION_INDICATOR_CODE}">${suspicionIndicators.SUSPICION_INDICATOR_DESC}</option>
																		</c:forEach>
																</select></td>
															</c:if>
														</tr>
														<c:if test="${ROLE eq 'USER'}">
															<tr>
																<td width="20%">List Of Users</td>
																<td width="25%"><select
																	class="form-control input-sm" name="amluserList"
																	id="amluserList${UNQID}" style="width: 100%">
																		<c:forEach var="AllUsersListMappings"
																			items="${ALLUSERSLIST}">
																			<option value="${AllUsersListMappings.USERCODE2}"
																				<c:if test="${AllUsersListMappings.USERCODE1 eq userCode}">selected="selected"</c:if>>${AllUsersListMappings.USERNAME}</option>
																		</c:forEach>
																</select></td>
																<td colspan="3">&nbsp;</td>
															</tr>
														</c:if>
														<c:if test="${ROLE eq 'AMLUSER'}">
															<tr>
																<c:if
																	test="${action eq 'bonafideOkay' || action eq 'mergeCase'}">
																	<td width="20%">Mark All</td>
																	<td colspan="2"><input type="checkbox"
																		class="form-control input-sm" name="addToMarkAll"
																		id="amlUserAddToMarkAll${UNQID}"
																		style="width: 20px; margin-top: -4px;"></td>
																</c:if>
																<c:if
																	test="${action ne 'mergeCase' && action ne 'assignToBranchUserByAMLuser'}">
																	<%-- <td width="20%">AMLO List</td>
												<td width="20%">
													<select class="form-control input-sm" name="amloList" id="amloList${UNQID}" style="width:100%">
													    <c:forEach var="AMLUserAMLOMappings" items="${AMLUserAMLOMappingDetails}">
															<option value="${AMLUserAMLOMappings.AMLUSERCODE}" <c:if test="${AMLUserAMLOMappings.AMLUSERCODE eq userCode}">selected="selected"</c:if>>${AMLUserAMLOMappings.AMLOCODE}</option>
														</c:forEach>
													</select>
												</td> --%>
																	<td width="20%">List Of Users</td>
																	<td width="20%"><c:if
																			test="${action eq 'bonafideOkay'}">
																			<select class="form-control input-sm" name="amloList"
																				id="amloList${UNQID}" style="width: 100%" disabled>
																		</c:if> <c:if test="${action ne 'bonafideOkay'}">
																			<select class="form-control input-sm" name="amloList"
																				id="amloList${UNQID}" style="width: 100%">
																		</c:if> <c:forEach var="AllUsersListMappings"
																			items="${ALLUSERSLIST}">
																			<%-- <option value="${AllUsersListMappings.USERCODE2}" <c:if test="${AllUsersListMappings.USERCODE1 eq userCode}">selected="selected"</c:if>>${AllUsersListMappings.USERCODE2}</option> --%>
																			<option value="${AllUsersListMappings.USERCODE2}"
																				<c:if test="${AllUsersListMappings.USERCODE1 eq userCode}">selected="selected"</c:if>>${AllUsersListMappings.USERNAME}</option>
																		</c:forEach> </select></td>
																	<td colspan="3">&nbsp;</td>
																</c:if>
																<c:if test="${action eq 'assignToBranchUserByAMLuser'}">
																	<td width="20%">List Of Branches</td>
																	<td width="20%"><select
																		class="form-control input-sm" name="assignedBranch"
																		id="assignedBranch${UNQID}" style="width: 100%">
																			<c:forEach var="AllBranchListMappings"
																				items="${ALLBRANCHESLIST}">
																				<option value="${AllBranchListMappings.BRANCHCODE}"
																					<c:if test="${AllBranchListMappings.BRANCHCODE eq AllBranchListMappings.CASEBRANCHCODE}">selected="selected"</c:if>>${AllBranchListMappings.BRANCHCODE}
																					- ${AllBranchListMappings.BRANCHNAME}</option>
																			</c:forEach>
																	</select></td>
																	<td colspan="3">&nbsp;</td>
																</c:if>
															</tr>
														</c:if>
														<c:if test="${ROLE eq 'AMLO' || ROLE eq 'MLRO'}">
															<tr>
																<%-- <td width="20%">MLRO List </td>
											<td width="25%">
											<select class="form-control input-sm" name="mlroList" id="mlroList${UNQID}" style="width:100%">
											    <c:forEach var="AMLOMLROMappings" items="${AMLOMLROMappingDetails}">
													<option value="${AMLOMLROMappings.AMLOCODE}" <c:if test="${AMLOMLROMappings.AMLOCODE eq userCode}">selected="selected"</c:if>>${AMLOMLROMappings.MLROCODE}</option>
												</c:forEach>
											</select>
											</td> --%>
																<c:if test="${action eq 'bonafideOkayByAMLO'}">
																	<td width="20%">Mark All</td>
																	<td colspan="2"><input type="checkbox"
																		class="form-control input-sm" name="addToMarkAll"
																		id="amloAddToMarkAll${UNQID}"
																		style="width: 20px; margin-top: -4px;"></td>
																</c:if>

																<c:if test="${action eq 'bonafideOkayByMLRO'}">
																	<td width="20%">Mark All</td>
																	<td colspan="2"><input type="checkbox"
																		class="form-control input-sm" name="addToMarkAll"
																		id="mlroAddToMarkAll${UNQID}"
																		style="width: 20px; margin-top: -4px;"></td>
																</c:if>

																<c:if
																	test="${action ne 'bonafideOkayByAMLO' && action ne 'bonafideOkayByMLRO'}">
																	<td width="20%">List Of Users</td>
																	<td width="25%"><select
																		class="form-control input-sm" name="mlroList"
																		id="mlroList${UNQID}" style="width: 100%">
																			<c:forEach var="AllUsersListMappings"
																				items="${ALLUSERSLIST}">
																				<%-- <option value="${AllUsersListMappings.USERCODE2}" <c:if test="${AllUsersListMappings.USERCODE1 eq userCode}">selected="selected"</c:if>>${AllUsersListMappings.USERCODE2}</option> --%>
																				<option value="${AllUsersListMappings.USERCODE2}"
																					<c:if test="${AllUsersListMappings.USERCODE1 eq userCode}">selected="selected"</c:if>>${AllUsersListMappings.USERNAME}</option>
																			</c:forEach>
																	</select></td>
																</c:if>
																<td colspan="3">&nbsp;</td>
															</tr>
														</c:if>
														<c:if
															test="${action ne 'escalateCase' && action ne 'checkerAction'}">
															<tr>
																<td width="20%">Comments</td>
																<c:if test="${ROLE eq 'USER'}">
																	<td colspan="4"><textarea
																			class="form-control input-sm validateComments autoCommentsSuggestion"
																			name="userComments" id="userComments${UNQID}"></textarea>
																	</td>
																</c:if>
																<c:if test="${ROLE eq 'AMLUSER'}">
																	<td colspan="4"><textarea
																			class="form-control input-sm validateComments autoCommentsSuggestion"
																			name="amluserComments" id="amluserComments${UNQID}">${CASECOMMENTDETAILS['NONSUSPICIOUSCOMMENTS']}</textarea>
																	</td>
																</c:if>
																<c:if test="${ROLE eq 'AMLO'}">
																	<td colspan="4"><textarea
																			class="form-control input-sm validateComments autoCommentsSuggestion"
																			name="amloComments" id="amloComments${UNQID}"></textarea>
																	</td>
																</c:if>
																<c:if test="${ROLE eq 'MLRO'}">
																	<td colspan="4"><textarea
																			class="form-control input-sm validateComments autoCommentsSuggestion"
																			name="mlroComments" id="mlroComments${UNQID}"></textarea>
																	</td>
																</c:if>
															</tr>
														</c:if>
													</table>
												</div>
												<div class="card-footer clearfix">
													<div class="pull-${dirR}">
														<c:if test="${flagType eq 'Y'}">
															<c:if
																test="${(f:contains(ROLE,'AMLO') || f:contains(ROLE,'MLRO')) && (currentCaseStatus eq '5' || currentCaseStatus eq '8') 
										&& (action eq 'approvedByAMLO' || action eq 'approvedByMLRO' || action eq 'rejectedByMLRO')}">
																<input type="button" class="btn btn-primary btn-sm"
																	id="searchToAddToFalsePositive${UNQID}"
																	value="Add/View False Positive">
															</c:if>
															<c:if test="${action ne 'mergeCase'}">
																<input type="button" class="btn btn-warning btn-sm"
																	id="attachEvidence${UNQID}" value="Attach Evidence">
																<input type="button" class="btn btn-success btn-sm"
																	id="saveComments${UNQID}" value="Post">
															</c:if>
															<input type="button" class="btn btn-success btn-sm"
																id="saveAndCloseComments${UNQID}" value="Post and Close">
														</c:if>
														<c:if
															test="${action eq 'escalateCase' && ROLE eq 'CM_MAKER'}">
															<!-- <button class="form-control btn-success" type="submit">Escalate</button> -->
															<input type="button" class="btn btn-success btn-sm"
																id="escalateCaseButton" value="Escalate" />
														</c:if>
														<c:if
															test="${action eq 'checkerAction' && ROLE eq 'CM_CHECKER'}">
															<!-- <button class="form-control btn-success" type="submit">Escalate</button> -->
															<input type="button" class="btn btn-success btn-sm"
																id="approveCase${UNQID}" onclick="checkerAction('A')"
																value="Approve" />
															<input type="button" class="btn btn-warning btn-sm"
																id="rejectCase${UNQID}" onclick="checkerAction('R')"
																value="Reject" />
														</c:if>
														<input type="button" class="btn btn-danger btn-sm"
															id="closeAddViewCommentsModal${UNQID}"
															data-dismiss="modal" value="Close Window" />
													</div>
												</div>
											</div>
											<!-- 
							<div class="card card-primary" id="alertsListDiv${UNQID}" style="margin: 10px 5px 5px 5px; ">
								<div class="card-header panelSlidingAlertsList${UNQID} clearfix">
									<h6 class="card-title pull-${dirL}">Alerts List for Assignment ${recordCount}</h6>
									<div class="btn-group pull-${dirR} clearfix">
										<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
									</div>
								</div>
								<div id="alertsListResultDiv${UNQID}">
									<table class="table table-bordered table-striped searchResultGenericTable alertsListForAssignmentTable${UNQID}" style="margin-bottom: 0px;">
										<thead>
											<tr>
												<th class="info no-sort" style="text-align: center;">
													<input type="checkbox" class="checkbox-check-all" compassTable="alertsForAssignment${UNQID}" id="alertsForAssignment${UNQID}" />
												</th>
												<c:forEach var="TH" items="${AlertDetails['HEADERS']}">
													<c:set var="colArray" value="${f:split(TH, '.')}" />
													<c:set var="colArrayCnt" value="${f:length(colArray)}" />
													<th class="info" id="${colArray[colArrayCnt-1]}"><spring:message code="${TH}"/></th>
												</c:forEach>
											</tr>
										</thead>
										<tbody>
											<c:forEach var="record" items="${AlertDetails['RECORDS']}">
												<tr>
													<td style="text-align: center;"><input type="checkbox"></td>
													<c:forEach var="field" items="${record}">
														<td>${field.value}</td>
													</c:forEach>
												</tr>
											</c:forEach>
										</tbody>
									</table>
								</div>
								<div class="card-footer clearfix">
									<div class="pull-${dirR}">
									<c:if test="${RECORDSIZE ge 3}">
										<input type="button" class="btn btn-success btn-sm" id="splitAndAssign${UNQID}" name="splitAndAssign" value="Split and Assign Cases"/>
									</c:if>
									<c:if test="${RECORDSIZE ge 1}">
										<input type="button" class="btn btn-primary btn-sm" id="addAlertComments${UNQID}" name="addAlertComments" value="Add Alert Comments"/>
									</c:if>
									</div>
								</div>
							</div>
							-->
											<div class="card card-primary"
												id="addFalsePositiveEntryDiv${UNQID}"
												style="margin: 10px 5px 5px 5px; display: none;">
												<div
													class="card-header panelSlidingAddToFalsePositive${UNQID} clearfix">
													<h6 class="card-title pull-${dirL}">Alerts List for
														False Positive</h6>
													<div class="btn-group pull-${dirR} clearfix">
														<span class="pull-right"><i
															class="collapsable fa fa-chevron-up"></i></span>
													</div>
												</div>
												<div id="addToFalsePostiveResultDiv${UNQID}"></div>
												<div class="card-footer clearfix">
													<div class="pull-${dirL}">
														<h6 style="color: blue;">* Please click on
															hyperlinked Reference No to update any details.</h6>
														<%-- <input type="button" class="btn btn-success btn-sm" id="saveFalsePositive${UNQID}" name="Save" value="Post"/> --%>
														<%-- <input type="button" class="btn btn-primary btn-sm" id="updateFalsePositive${UNQID}" name="Update" value="Update"/> --%>
														<%-- <input type="button" class="btn btn-danger btn-sm" id="deleteFalsePositive${UNQID}" name="Delete" value="Delete"/> --%>
													</div>
												</div>
											</div>
										</c:if>
										<c:forEach var="fieldDetails" items="${tabDetail}"
											varStatus="varStatus">
											<%-- ${fieldDetails['app.common.CASESTATUS']} --%>
											<div class="card card-primary commentsMainDiv${UNQID}"
												style="margin: 10px 5px 5px 5px;">
												<div
													class="card-header panelSlidingViewComments${UNQID} clearfix"
													id="${varStatus.index}slidingViewCommentsPanel${UNQID}"
													data-toggle="collapse"
													data-target="#${tabIndex}commentsDiv${varStatus.index}">
													<%-- <h6 class="card-title pull-${dirL}">Comments ${varStatus.index+1}</h6> --%>
													<h6 class="card-title pull-${dirL}">
														<c:forEach var="columnDetails1" items="${fieldDetails}">
															<c:set var="columnName1" value="${columnDetails1.key}"></c:set>
															<c:set var="columnValue1" value="${columnDetails1.value}"></c:set>
															<c:if
																test="${f:contains(columnName1, 'app.common.CASESTATUS')}">${columnValue1} || </c:if>
														</c:forEach>
														<c:forEach var="columnDetails2" items="${fieldDetails}">
															<c:set var="columnName2" value="${columnDetails2.key}"></c:set>
															<c:set var="columnValue2" value="${columnDetails2.value}"></c:set>
															<c:if
																test="${f:contains(columnName2, 'app.common.USERCODE')}">${columnValue2} || </c:if>
														</c:forEach>
														<c:forEach var="columnDetails3" items="${fieldDetails}">
															<c:set var="columnName3" value="${columnDetails3.key}"></c:set>
															<c:set var="columnValue3" value="${columnDetails3.value}"></c:set>
															<c:if
																test="${f:contains(columnName3, 'app.common.UPDATETIMESTAMP')}">${columnValue3}</c:if>
														</c:forEach>
													</h6>
													<div class="btn-group pull-${dirR} clearfix">
														<span class="pull-right"><i
															class="collapsable fa fa-chevron-down"></i></span>
													</div>
												</div>
												<div id="${tabIndex}commentsDiv${varStatus.index}">
													<table class="table table-striped">
														<tbody>
															<c:set var="LABELSCOUNT"
																value="${f:length(fieldDetails)}" />
															<c:set var="LABELSITRCOUNT" value="0" scope="page" />
															<c:forEach var="ALLLABELSMAP" items="${fieldDetails}">

																<c:choose>
																	<c:when test="${LABELSITRCOUNT % 2 == 0}">
																		<tr>
																			<td width="20%"><spring:message
																					code="${ALLLABELSMAP.key}" /></td>
																			<c:choose>
																				<c:when
																					test="${f:contains(ALLLABELSMAP.key,'COMMENTS')}">
																					<td width="25%"><textarea
																							class="form-control input-sm" readonly="readonly">${ALLLABELSMAP.value}</textarea>
																					</td>
																				</c:when>
																				<c:otherwise>
																					<c:choose>
																						<c:when
																							test="${f:contains(ALLLABELSMAP.key,'ESCALATEDTO')}">
																							<td width="25%"><input type="text"
																								class="form-control input-sm viewCommentsTextarea"
																								value="${f:replace(ALLLABELSMAP.value,',','')}"
																								readonly="readonly" /></td>
																						</c:when>
																						<c:otherwise>
																							<td width="25%"><input type="text"
																								class="form-control input-sm viewCommentsTextarea"
																								value="${ALLLABELSMAP.value}"
																								readonly="readonly" /></td>
																						</c:otherwise>
																					</c:choose>

																				</c:otherwise>
																			</c:choose>
																			<td width="10%">&nbsp;</td>
																	</c:when>
																	<c:otherwise>
																		<td width="20%"><spring:message
																				code="${ALLLABELSMAP.key}" /></td>
																		<c:choose>
																			<c:when
																				test="${f:contains(ALLLABELSMAP.key,'COMMENTS')}">
																				<td width="25%"><textarea
																						class="form-control input-sm viewCommentsTextarea"
																						readonly="readonly">${ALLLABELSMAP.value}</textarea>
																				</td>
																			</c:when>
																			<c:otherwise>
																				<c:choose>
																					<c:when
																						test="${f:contains(ALLLABELSMAP.key,'ESCALATEDTO')}">
																						<td width="25%"><input type="text"
																							class="form-control input-sm viewCommentsTextarea"
																							value="${f:replace(ALLLABELSMAP.value,',','')}"
																							readonly="readonly" /></td>
																					</c:when>
																					<c:otherwise>
																						<td width="25%"><input type="text"
																							class="form-control input-sm viewCommentsTextarea"
																							value="${ALLLABELSMAP.value}" readonly="readonly" />
																						</td>
																					</c:otherwise>
																				</c:choose>
																			</c:otherwise>
																		</c:choose>
																		</tr>
																	</c:otherwise>
																</c:choose>
																<c:set var="LABELSITRCOUNT"
																	value="${LABELSITRCOUNT + 1}" scope="page" />
															</c:forEach>
															<c:if test="${LABELSITRCOUNT % 2 != 0}">
																<td width="20%">&nbsp;</td>
																<td width="25%">&nbsp;</td>
																</tr>
															</c:if>
														</tbody>
													</table>
												</div>
											</div>
										</c:forEach>

									</c:otherwise>
								</c:choose>
							</div>
						</c:forEach>
					</div>
				</div>
			</div>
		</div>
	</div>
</form>
</body>
function openDetails(elm, moduleHeader, value, moduleCode, detailPage){
	var childWindow = $("#childWindow").val() != undefined ? "1" : "0";
	if(childWindow == "1"){
		openModalInWindow(elm, moduleHeader, value, moduleCode, detailPage, false);
	}else{
		if($("#compassGenericModal").hasClass("in") && ($(elm).prop("tagName") != "BUTTON")){
			openModalInWindow(elm, moduleHeader, value, moduleCode, detailPage, false);
		}else{
			$(elm).tooltip('hide');
			$(elm).attr("disabled", "disabled");
			var accValue = $(elm).html();
			$(elm).html("Searching...");
			$("#compassGenericModal").modal("show");
			$("#compassGenericModal-title").html(moduleHeader);
			var ctx = window.location.href;
			ctx = ctx.substring(0, ctx.split("/", 4).join("/").length);
			var url = ctx + '/common/getModuleDetails?moduleCode='+moduleCode+'&moduleHeader='+moduleHeader+'&moduleValue='+value+'&detailPage='+detailPage;
			var loaderUrl = ctx + '/includes/images/qde-loadder.gif';
			$("#tabUrl").val('/common/getModuleDetails?moduleCode='+moduleCode+'&moduleHeader='+moduleHeader+'&moduleValue='+value+'&detailPage='+detailPage);
			$("#tabModuleCode").val(moduleCode);
			$("#compassGenericModal-body").html("<br/><center><img src='"+loaderUrl+"'/></center><br/>");
			
			$.ajax({
				url :  url,
				cache : false,
				type : 'GET',
				success : function(response){
					$("#compassGenericModal-body").html(response);
					$(elm).html(accValue);
					$(elm).removeAttr("disabled");
				},
				error : function(a,b,c){
					$(elm).html(accValue);
					$(elm).removeAttr("disabled");
					alert("Something went wrong"+a+b+c);
				}
			});
		}
		
	}
}

function showDetailsInButtomFrame(elm, value, moduleCode, detailPage){
	$(elm).parents("div#caseDetailsDiv").find("div#caseAlertDetailsDiv").css("display", "block");
	var mainDiv = $(elm).parents("div#caseDetailsDiv").find("div#caseAlertDetailsDiv").children("div").children("div");
	var ctx = window.location.href;
	ctx = ctx.substring(0, ctx.split("/", 4).join("/").length);
	var loaderUrl = ctx + '/includes/images/qde-loadder.gif';
	$(mainDiv).html("<br/><center><img src='"+loaderUrl+"'/></center><br/>");
	var url = ctx + '/common/getModuleDetails?moduleCode='+moduleCode+'&moduleHeader=AlertDetails&moduleValue='+value+'&detailPage='+detailPage;
	$.ajax({
		url :  url,
		cache : false,
		type : 'GET',
		success : function(response){
			$(mainDiv).html(response);
		},
		error : function(a,b,c){
			alert("Something went wrong"+a+b+c);
		}
	});
}

function openModalInTab(elm, moduleHeader, value, moduleCode, detailPage){
	$("#compassGenericModal").modal("hide");
	//alert(moduleHeader+','+value+', '+moduleCode+', '+detailPage);
	var url = '/common/getModuleDetails?moduleCode='+moduleCode+'&moduleHeader='+moduleHeader+'&moduleValue='+value+'&detailPage='+detailPage;
	moduleCode = moduleCode+"Details";
	navigate(moduleHeader, moduleCode, url, '1');
}

function openModalInWindow(elm, moduleHeader, value, moduleCode, detailPage, closeModal){
	if(closeModal)
		$("#compassGenericModal").modal("hide");
		
	var ctx = window.location.href;
	ctx = ctx.substring(0, ctx.split("/", 4).join("/").length);
	var url = ctx+'/common/showModuleDetailsInWindow?moduleCode='+moduleCode+'&moduleHeader='+moduleHeader+'&moduleValue='+value+'&detailPage='+detailPage;
	window.open(url, moduleHeader, 'height=600px,width=1000px');
}

/*function resetColumns(elm){
	var tableClass = $(elm).attr("tableClass");
	var colName = $(elm).children("a").html();
	var isEnabled = $(elm).attr("class");
	
	if(isEnabled == "enabledCol"){
		$(elm).removeClass("enabledCol").addClass("disabledCol");
	}else{
		$(elm).removeClass("disabledCol").addClass("enabledCol");
	}
	
	var resetColIndex = $("."+tableClass+"ResetCols").children("ul").children("li#"+colName).index();
	
	if($("."+tableClass).children("thead").children("tr").children("th:first-child").hasClass("no-sort"))
		resetColIndex = resetColIndex + 1;
	
	var tableObj = $("."+tableClass).DataTable();
	
	var column = tableObj.column(resetColIndex);
	
	if(column.visible()){
		column.visible(false);
	}else{
		column.visible(true);
	}
	
	$("."+tableClass).children("thead").children("tr").children("th").each(function(){
		$(this).css("width", "auto");
	});
}*/

function resetColumns(elm){
	var tableClass = $(elm).attr("tableClass");
	/*var colName = $(elm).children("a").html();*/
	var colName = $(elm).children("a").text().replace(/ /g,'');
	var isEnabled = $(elm).attr("class");
	//alert(colName+" "+isEnabled);
	// if(isEnabled == "enabledCol"){
	if($(elm).hasClass("enabledCol")){	
		$(elm).removeClass("enabledCol").addClass("disabledCol");
	}else{
		$(elm).removeClass("disabledCol").addClass("enabledCol");
	}
	
	var hideColumn = true;
	if($("."+tableClass+"ResetCols").find("ul.compassResetCols").children("li#"+colName).attr('index')){
		var resetColIndex = parseInt($("."+tableClass+"ResetCols").find("ul.compassResetCols").children("li#"+colName).attr('index'));
	}else if($("."+tableClass+"ResetCols").find("ul.compassResetCols").children("li#"+colName).attr('noindex')){
		hideColumn = false;
	}else{
		var resetColIndex = $("."+tableClass+"ResetCols").find("ul.compassResetCols").children("li#"+colName).index();
		//alert(colName+" "+resetColIndex);
	}
	if($("."+tableClass).children("thead").children("tr").children("th:first-child").hasClass("no-sort"))
		resetColIndex = resetColIndex + 1;
	
	if(hideColumn){
		var tableObj = $("."+tableClass).DataTable();
		var column = tableObj.column(resetColIndex);
		if(column.visible()){
			column.visible(false);
		}else{
			column.visible(true);
		}
		$("."+tableClass).children("thead").children("tr").children("th").each(function(){
			$(this).css("width", "auto");
		});
	}
	
	
}

function eventFired(_tableClass){
	var table = $("."+_tableClass);
	var detailPageUrl;
	
	detailPageUrl = "KYCModules/CustomerMaster/CustomerDetails";
	var customerIdColIndex = $(table).children("thead").children("tr").children("th#CUSTOMERID").index()+1;
	var customerIdCols = $(table).children("tbody").children("tr").children("td:nth-child("+customerIdColIndex+")");
	$(customerIdCols).each(function(a,b){
		var tdValue = $(this).html();
		
		if($(this).closest('table').find('th#CUSTOMERID').length)
		{
			$(this).addClass("hyperlinkCols");
			$(this).attr("onclick", "openDetails(this, 'Customer Details', '"+tdValue+"','customerMaster', '"+detailPageUrl+"')");
		}
		
		//$(this).attr("onclick", "openDetails(this, 'Customer Details', '"+tdValue+"','customerMaster', '"+detailPageUrl+"')");
	});
	
	detailPageUrl = "MasterModules/AccountsMaster/AccountDetails";
	var accountNoColIndex = $(table).children("thead").children("tr").children("th#ACCOUNTNO").index()+1;
	var accountNoCols = $(table).children("tbody").children("tr").children("td:nth-child("+accountNoColIndex+")");
	$(accountNoCols).each(function(a,b){
		var tdValue = $(this).html();
		/*$(this).addClass("hyperlinkCols");
		$(this).attr("onclick", "openDetails(this, 'Account Details', '"+tdValue+"','accountsMaster', '"+detailPageUrl+"')");*/
		if($(this).closest('table').find('th#ACCOUNTNO').length)
		{
			$(this).addClass("hyperlinkCols");
			$(this).attr("onclick", "openDetails(this, 'Account Details', '"+tdValue+"','accountsMaster', '"+detailPageUrl+"')");
		}
	});
	
	detailPageUrl = "AlertEngines/AlertDetails";
	var alertNoColIndex = $(table).children("thead").children("tr").children("th#ALERTNO").index()+1;
	var alertNoCols = $(table).children("tbody").children("tr").children("td:nth-child("+alertNoColIndex+")");
	$(alertNoCols).each(function(a,b){
		var tdValue = $(this).html();
		$(this).addClass("hyperlinkCols");
		$(this).attr("onclick", "openDetails(this, 'Alert Details', '"+tdValue+"','alertEngine', '"+detailPageUrl+"')");
	});
	
	detailPageUrl = "AlertEngines/AlertDetails";
	var alertNumberColIndex = $(table).children("thead").children("tr").children("th#ALERTNUMBER").index()+1;
	var alertNumberCols = $(table).children("tbody").children("tr").children("td:nth-child("+alertNumberColIndex+")");
	$(alertNumberCols).each(function(a,b){
		var tdValue = $(this).html();
		$(this).addClass("hyperlinkCols");
		$(this).attr("onclick", "showDetailsInButtomFrame(this, '"+tdValue+"','alertEngine', '"+detailPageUrl+"')");
	});
	
	
	
	detailPageUrl = "MasterModules/BranchMaster/BranchDetails";
	var branchCodeColIndex = $(table).children("thead").children("tr").children("th#BRANCHCODE").index()+1;
	var branchCodeCols = $(table).children("tbody").children("tr").children("td:nth-child("+branchCodeColIndex+")");
	$(branchCodeCols).each(function(a,b){
		var tdValue = $(this).html();
		$(this).addClass("hyperlinkCols");
		$(this).attr("onclick", "openDetails(this, 'Branch Details', '"+tdValue+"','branchMaster', '"+detailPageUrl+"')");
	});
	
	detailPageUrl = "KYCModules/CustomerMaster/CustomerDetails";
	var jointcustomerIdColIndex = $(table).children("thead").children("tr").children("th#JOINTCUSTOMERID").index()+1;
	var jointcustomerIdCols = $(table).children("tbody").children("tr").children("td:nth-child("+jointcustomerIdColIndex+")");
	$(jointcustomerIdCols).each(function(a,b){
		var tdValue = $(this).html();
		
		if($(this).closest('table').find('th#JOINTCUSTOMERID').length)
		{
			$(this).addClass("hyperlinkCols");
			$(this).attr("onclick", "openDetails(this, 'Customer Details', '"+tdValue+"','customerMaster', '"+detailPageUrl+"')");
		}
	});
	
	detailPageUrl = "MasterModules/AccountsMaster/AccountDetails";
	var jointaccountNoColIndex = $(table).children("thead").children("tr").children("th#JOINTACCOUNTNO").index()+1;
	var jointaccountNoCols = $(table).children("tbody").children("tr").children("td:nth-child("+jointaccountNoColIndex+")");
	$(jointaccountNoCols).each(function(a,b){
		var tdValue = $(this).html();
		if($(this).closest('table').find('th#JOINTACCOUNTNO').length)
		{
			$(this).addClass("hyperlinkCols");
			$(this).attr("onclick", "openDetails(this, 'Account Details', '"+tdValue+"','accountsMaster', '"+detailPageUrl+"')");
		}
		//$(this).attr("onclick", "openDetails(this, 'Account Details', '"+tdValue+"','accountsMaster', '"+detailPageUrl+"')");
	});
	
	detailPageUrl = "MasterModules/BankMaster/BankDetails";
	var bankCodeColIndex = $(table).children("thead").children("tr").children("th#BANKCODE").index()+1;
	var bankCodeCols = $(table).children("tbody").children("tr").children("td:nth-child("+bankCodeColIndex+")");
	$(bankCodeCols).each(function(a,b){
		var tdValue = $(this).html();
		$(this).addClass("hyperlinkCols");
		$(this).attr("onclick", "openDetails(this, 'Bank Details', '"+tdValue+"','bankMaster', '"+detailPageUrl+"')");
	});
	
	detailPageUrl = "MasterModules/ProductsMaster/ProductDetails";
	var productCodeColIndex = $(table).children("thead").children("tr").children("th#PRODUCTCODE").index()+1;
	var productCodeCols = $(table).children("tbody").children("tr").children("td:nth-child("+productCodeColIndex+")");
	$(productCodeCols).each(function(a,b){
		var tdValue = $(this).html();
		/*$(this).addClass("hyperlinkCols");
		$(this).attr("onclick", "openDetails(this, 'Product Details', '"+tdValue+"','productsMaster', '"+detailPageUrl+"')");*/
		if($(this).closest('table').find('th#PRODUCTCODE').length)
		{
			$(this).addClass("hyperlinkCols");
			$(this).attr("onclick", "openDetails(this, 'Product Details', '"+tdValue+"','productsMaster', '"+detailPageUrl+"')");
		}
	});
	
	detailPageUrl = "MasterModules/EmployeeMaster/EmployeeDetails";
	var empCodeColIndex = $(table).children("thead").children("tr").children("th#EMPCODE").index()+1;
	var empCodeCols = $(table).children("tbody").children("tr").children("td:nth-child("+empCodeColIndex+")");
	$(empCodeCols).each(function(a,b){
		var tdValue = $(this).html();
		$(this).addClass("hyperlinkCols");
		$(this).attr("onclick", "openDetails(this, 'Employee Details', '"+tdValue+"','employeeMaster', '"+detailPageUrl+"')");
	});
	
	detailPageUrl = "MasterModules/CustomerTypeMaster/CustomerTypeDetails";
	var customerTypeColIndex = $(table).children("thead").children("tr").children("th#CUSTOMERTYPE").index()+1;
	var customerTypeCols = $(table).children("tbody").children("tr").children("td:nth-child("+customerTypeColIndex+")");
	$(customerTypeCols).each(function(a,b){
		var tdValue = $(this).html();
		$(this).addClass("hyperlinkCols");
		$(this).attr("onclick", "openDetails(this, 'Customer Type Details', '"+tdValue+"','customerTypeMaster', '"+detailPageUrl+"')");
	});
	
	detailPageUrl = "InvestigationTools/TransactionDetails/TransactionDetails";
	var transactionNoColIndex = $(table).children("thead").children("tr").children("th#TRANSACTIONNO").index()+1;
	var transactionNoCols = $(table).children("tbody").children("tr").children("td:nth-child("+transactionNoColIndex+")");
	$(transactionNoCols).each(function(a,b){
		var tdValue = $(this).html();
		$(this).addClass("hyperlinkCols");
		$(this).attr("onclick", "openDetails(this, 'Transaction Details', '"+tdValue+"','transactionDetailsMaster', '"+detailPageUrl+"')");
	});
	
	detailPageUrl = "MasterModules/CountryMaster/CountryDetails";
	var countryCodeColIndex = $(table).children("thead").children("tr").children("th#COUNTRYCODE").index()+1;
	var countryCodeCols = $(table).children("tbody").children("tr").children("td:nth-child("+countryCodeColIndex+")");
	$(countryCodeCols).each(function(a,b){
		var tdValue = $(this).html();
		$(this).addClass("hyperlinkCols");
		$(this).attr("onclick", "openDetails(this, 'Country Details', '"+tdValue+"','countryMaster', '"+detailPageUrl+"')");
	});
	
	detailPageUrl = "MasterModules/CurrencyMaster/CurrencyDetails";
	var fromCurrColIndex = $(table).children("thead").children("tr").children("th#FROMCURRENCY").index()+1;
	var fromCurrCols = $(table).children("tbody").children("tr").children("td:nth-child("+fromCurrColIndex+")");
	$(fromCurrCols).each(function(a,b){
		var tdValue = $(this).html();
		$(this).addClass("hyperlinkCols");
		$(this).attr("onclick", "openDetails(this, 'Currency Details', '"+tdValue+"','currencyMaster', '"+detailPageUrl+"')");
	});
	
	detailPageUrl = "MasterModules/CurrencyMaster/CurrencyDetails";
	var toCurrColIndex = $(table).children("thead").children("tr").children("th#TOCURRENCY").index()+1;
	var toCurrCols = $(table).children("tbody").children("tr").children("td:nth-child("+toCurrColIndex+")");
	$(toCurrCols).each(function(a,b){
		var tdValue = $(this).html();
		$(this).addClass("hyperlinkCols");
		$(this).attr("onclick", "openDetails(this, 'Currency Details', '"+tdValue+"','currencyMaster', '"+detailPageUrl+"')");
	});
	
	var currencyCodeColIndex = $(table).children("thead").children("tr").children("th#CURRENCYCODE").index()+1;
	var currencyCodeCols = $(table).children("tbody").children("tr").children("td:nth-child("+currencyCodeColIndex+")");
	$(currencyCodeCols).each(function(a,b){
		var tdValue = $(this).html();
		$(this).addClass("hyperlinkCols");
		$(this).attr("onclick", "openDetails(this, 'Currency Details', '"+tdValue+"','currencyMaster', '"+detailPageUrl+"')");
	});
	
	detailPageUrl = "MasterModules/InstrumentMaster/InstrumentDetails";
	var instrumentCodeColIndex = $(table).children("thead").children("tr").children("th#INSTRUMENTCODE").index()+1;
	var instrumentCodeCols = $(table).children("tbody").children("tr").children("td:nth-child("+instrumentCodeColIndex+")");
	$(instrumentCodeCols).each(function(a,b){
		var tdValue = $(this).html();
		$(this).addClass("hyperlinkCols");
		$(this).attr("onclick", "openDetails(this, 'Instrument Details', '"+tdValue+"','instrumentMaster', '"+detailPageUrl+"')");
	});
	
	detailPageUrl = "MasterModules/TransactionTypeMaster/TransactionTypeDetails";
	var transactionTypeColIndex = $(table).children("thead").children("tr").children("th#TRANSACTIONTYPE").index()+1;
	var transactionTypeCols = $(table).children("tbody").children("tr").children("td:nth-child("+transactionTypeColIndex+")");
	$(transactionTypeCols).each(function(a,b){
		var tdValue = $(this).html();
		$(this).addClass("hyperlinkCols");
		$(this).attr("onclick", "openDetails(this, 'Transaction Type Details', '"+tdValue+"','transactionTypeMaster', '"+detailPageUrl+"')");
	});

	detailPageUrl = "AccountProfiling/AccountProfileDetails";
	var fromCurrColIndex = $(table).children("thead").children("tr").children("th#PROFILEACCOUNTNO").index()+1;
      
        /*var fromCurrCols = $(table).children("tbody").children("tr").children("td:nth-child("+fromCurrColIndex+")");
	$(fromCurrCols).each(function(a,b){
		var AP_FROMDATE = $("#AP_FROMDATE").val();
		var AP_TODATE = $("#AP_TODATE").val();
		var AP_CUSTOMERID = $("#AP_CUSTOMERID").val();
		
		var tdValue = $(this).html();
		tdValue = tdValue +"||"+AP_FROMDATE+"||"+AP_TODATE+"||"+AP_CUSTOMERID;
		$(this).addClass("hyperlinkCols");
		$(this).attr("onclick", "openDetails(this, 'Account Profile Details', '"+tdValue+"','accountProfiling', '"+detailPageUrl+"')");
	});

	detailPageUrl = "GraphicalReports/AccountProfileGraphDetails";
	var fromCurrColIndex = $(table).children("thead").children("tr").children("th#ACCT_OPENEDDATE").index()+1;*/

	var fromCurrCols = $(table).children("tbody").children("tr").children("td:nth-child("+fromCurrColIndex+")");
	$(fromCurrCols).each(function(a,b){
		var AP_FROMDATE = $("#AP_FROMDATE").val();
		var AP_TODATE = $("#AP_TODATE").val();
		var AP_CUSTOMERID = $("#AP_CUSTOMERID").val();
		
		var tdValue = $(this).html();
		tdValue = tdValue +"||"+AP_FROMDATE+"||"+AP_TODATE+"||"+AP_CUSTOMERID;
		$(this).addClass("hyperlinkCols");
		$(this).attr("onclick", "openDetails(this, 'Account Profile Details', '"+tdValue+"','accountProfiling', '"+detailPageUrl+"')");
	});

	detailPageUrl = "AMLCaseWorkFlow/CaseDetails";
	var caseNoColIndex = $(table).children("thead").children("tr").children("th#CASENO").index()+1;	
	var caseNoCols = $(table).children("tbody").children("tr").children("td:nth-child("+caseNoColIndex+")");
	$(caseNoCols).each(function(a,b){
		var tdValue = $(this).html();
		$(this).addClass("hyperlinkCols");
		$(this).attr("onclick", "openDetails(this, 'Case Alert Mapping Details', '"+tdValue+"','caseAlertDetails', '"+detailPageUrl+"')");
	});
	
	detailPageUrl = "AMLCaseWorkFlow/CaseDetails";
	var caseSourceSystemColIndex = $(table).children("thead").children("tr").children("th#CASESOURCESYSTEM").index()+1;
	var caseSourceSystemCols = $(table).children("tbody").children("tr").children("td:nth-child("+caseSourceSystemColIndex+")");
	$(caseSourceSystemCols).each(function(a,b){
		var tdValue = $(this).html();
		$(this).addClass("hyperlinkCols");
		$(this).attr("onclick", "openDetails(this, 'Customer Case History Details', '"+tdValue+"','customerCaseHistoryDetails', '"+detailPageUrl+"')");
	});

	/*detailPageUrl = "InvestigationTools/TransactionDetails/AlertMappedDetails";
	var tranNoColIndex = $(table).children("thead").children("tr").children("th#GENERATEDALERTSCOUNT").index()+1;	
	var tranNoCols = $(table).children("tbody").children("tr").children("td:nth-child("+tranNoColIndex+")");
	$(tranNoCols).each(function(a,b){
		//alert('tdValue1: '+tdValue1);
		
		var tdValue = $(this).html();
		//var tdValue1 = $(table).children("tbody").children("tr").children("td:nth-child(2)").html();
		//alert($("#element td:nth-child(2)").text());
		//alert($(this).closest("tr").find('td:eq(1)').text());
		var tdValue1 = $(this).closest("tr").find('td:eq(1)').text();
		//alert(tdValue1);
		$(this).addClass("hyperlinkCols");
		$(this).attr("onclick", "openDetails(this, 'Alert Mapping Details', '"+tdValue1+"','alertMappingDetails', '"+detailPageUrl+"', '"+tdValue+"')");
	});*/
	
	detailPageUrl = "";
	var listIdColIndex = $(table).children("thead").children("tr").children("th#LISTEDID").index()+1;
	var listIdCols = $(table).children("tbody").children("tr").children("td:nth-child("+listIdColIndex+")");
	$(listIdCols).each(function(a,b){
		var tdValue = $(this).html();
		$(this).addClass('listIdHyperlink');
		$(this).attr("onclick", "openListIdDetails(this)");
	});

	detailPageUrl = "";
	var alertSerialIdColIndex = $(table).children("thead").children("tr").children("th#ALERTSERIALID").index()+1;
	var alertSerialIdCols = $(table).children("tbody").children("tr").children("td:nth-child("+alertSerialIdColIndex+")");
	$(alertSerialIdCols).each(function(a,b){
		var tdValue = $(this).html();
		var tdValue1 = $(this).closest("tr").find('td:eq(1)').text();
		//alert(tdValue+' & '+tdValue1);
		$(this).addClass('alertSerialIdHyperlink');
		$(this).attr("onclick", "openAlertSerialIdDetails(this, '"+tdValue+"', '"+tdValue1+"')");
	});

	detailPageUrl = "";
	var alertApprovalStatusColIndex = $(table).children("thead").children("tr").children("th#ALERTAPPROVALSTATUS").index()+1;
	var alertApprovalStatusCols = $(table).children("tbody").children("tr").children("td:nth-child("+alertApprovalStatusColIndex+")");
	$(alertApprovalStatusCols).each(function(a,b){
		var tdValue = $(this).html();
		var tdValue1 = $(this).closest("tr").find('td:eq(0)').text();
		//alert(tdValue+' & '+tdValue1);
		$(this).addClass('alertApprovalStatusHyperlink');
		$(this).attr("onclick", "openAlertApprovalStatusDetails(this, '"+tdValue1+"', '"+tdValue+"')");
	});

	detailPageUrl = "";
	var reportSerialIdColIndex = $(table).children("thead").children("tr").children("th#REPORTSERIALID").index()+1;
	var reportSerialIdCols = $(table).children("tbody").children("tr").children("td:nth-child("+reportSerialIdColIndex+")");
	$(reportSerialIdCols).each(function(a,b){
		var tdValue = $(this).html();
		$(this).addClass('reportSerialIdHyperlink');
		$(this).attr("onclick", "openReportSerialIdDetails(this)");
	});

	detailPageUrl = "";
	var reportWidgetsIdColIndex = $(table).children("thead").children("tr").children("th#REPORTWIDGETSID").index()+1;
	var reportWidgetsIdCols = $(table).children("tbody").children("tr").children("td:nth-child("+reportWidgetsIdColIndex+")");
	$(reportWidgetsIdCols).each(function(a,b){
		var tdValue = $(this).html();
		$(this).addClass('reportWidgetsIdHyperlink');
		$(this).attr("onclick", "openReportWidgetsIdDetails(this)");
	});
	
	detailPageUrl = "";
	var transactionsColIndex = $(table).children("thead").children("tr").children("th#TRANSACTIONS").index()+1;
	var transactionsCols = $(table).children("tbody").children("tr").children("td:nth-child("+transactionsColIndex+")");
	$(transactionsCols).each(function(a,b){
		var tdValue = $(this).html();
		$(this).addClass('hyperlinkCols');
		$(this).attr("onclick", "openAlertTransactions(this)");
	});
	
	detailPageUrl = "";
	var transactionsColIndex = $(table).children("thead").children("tr").children("th#RPTLISTCODE").index()+1;
	var transactionsCols = $(table).children("tbody").children("tr").children("td:nth-child("+transactionsColIndex+")");
	$(transactionsCols).each(function(a,b){
		var tdValue = $(this).html();
		$(this).addClass('hyperlinkCols');
		$(this).attr("onclick", "openRPTWatchListDetails(this)");
	});

	detailPageUrl = "";
	var transactionsColIndex = $(table).children("thead").children("tr").children("th#RPTENTITYID").index()+1;
	var transactionsCols = $(table).children("tbody").children("tr").children("td:nth-child("+transactionsColIndex+")");
	$(transactionsCols).each(function(a,b){
		var tdValue = $(this).html();
		$(this).addClass('hyperlinkCols');
		$(this).attr("onclick", "viewUpdateRPTEntity(this)");
	});

	detailPageUrl = "";
	var docCodeColIndex = $(table).children("thead").children("tr").children("th#DOC_CODE").index()+1;
	var docCodeCols = $(table).children("tbody").children("tr").children("td:nth-child("+docCodeColIndex+")");
	$(docCodeCols).each(function(a,b){
		var tdValue = $(this).html();
		if($(this).closest('table').find('th#DOC_CODE').length)
		{
			$(this).addClass("hyperlinkCols");
			$(this).attr("onclick", "openDocDetails(this)");
		}
	});
	
	detailPageUrl = "";
	var fileNameColIndex = $(table).children("thead").children("tr").children("th#FILENAME").index()+1;
	var fileNameCols = $(table).children("tbody").children("tr").children("td:nth-child("+fileNameColIndex+")");
	$(fileNameCols).each(function(a,b){
		var tdValue = $(this).html();
		var fileUrl = $(this).closest('td').next().text();
		$(this).addClass("hyperlinkCols");
		$(this).attr("onclick", "downloadGeneratedXMLFile('"+tdValue+"','"+fileUrl+"')");
	});
	
	detailPageUrl = "";
	var CRPRuleIDColIndex = $(table).children("thead").children("tr").children("th#RULEID").index()+1;
	var CRPRuleIDCols = $(table).children("tbody").children("tr").children("td:nth-child("+CRPRuleIDColIndex+")");
	$(CRPRuleIDCols).each(function(a,b){
		var tdValue = $(this).html();
		$(this).addClass('CRPRuleHyperlink');
		$(this).attr("onclick", "openCRPRulesIDDetails(this)");
	});
	
	detailPageUrl = "";
	var CRPRuleIDColIndex = $(table).children("thead").children("tr").children("th#CRPRULEID").index()+1;
	var CRPRuleIDCols = $(table).children("tbody").children("tr").children("td:nth-child("+CRPRuleIDColIndex+")");
	$(CRPRuleIDCols).each(function(a,b){
		var tdValue = $(this).html();
		$(this).addClass('hyperlinkCols');
		$(this).attr("onclick", "openModelForChanginStatus(this)");
	});

	$('[data-toggle="tooltip"]').tooltip({container: 'body'});
}
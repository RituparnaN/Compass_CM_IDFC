<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../tags/tags.jsp"%>
<%@page import="java.util.*"%>
<% 
String contextPath = request.getContextPath()==null?"":request.getContextPath();
String scanningFromDate = (String)request.getParameter("ScanningFromDate");
String scanningToDate = (String)request.getParameter("ScanningToDate");
String processingFromDate = (String)request.getParameter("ProcessingFromDate");
String processingToDate = (String)request.getParameter("ProcessingToDate");
String userCode = (String)request.getParameter("UserCode");
String recordStatus = (String)request.getParameter("RecordStatus");
String strFileName = (String)request.getParameter("filename");
//String LOGGEDUSER = "AMLUser";
String LOGGEDUSER = request.getParameter("LOGGEDUSER") == null ? "AMLUser":(String)request.getParameter("LOGGEDUSER");
String l_strTopN = request.getAttribute("TopN") == null ? "0":(String)request.getAttribute("TopN");
String l_strFromDate = (String)request.getAttribute("l_strFromDate");
String l_strToDate = (String)request.getAttribute("l_strToDate");
String l_strCustomerNameCheck = (String)request.getAttribute("l_strCustomerNameCheck");
String l_strMotherNameCheck = (String)request.getAttribute("l_strMotherNameCheck");
String l_strPermanentAddressLine1Check = (String)request.getAttribute("l_strPermanentAddressLine1Check");
String l_strCommAddressLine1Check = (String)request.getAttribute("l_strCommAddressLine1Check");
String l_strPanNoCheck = (String)request.getAttribute("l_strPanNoCheck");
String l_strPassportNoCheck = (String)request.getAttribute("l_strPassportNoCheck");
String l_strDrivingLicenseNoCheck = (String)request.getAttribute("l_strDrivingLicenseNoCheck");
String l_strDateOfBirthCheck = (String)request.getAttribute("l_strDateOfBirthCheck");
//System.out.println("l_strTopN:  "+l_strTopN);
int l_strPageNo = (Integer.parseInt(l_strTopN)/20) + 1;
LinkedHashMap linkedHashMap = null;
int totalRecords = 0;
ArrayList resultedRecords = new ArrayList();
int counter = 0;
String FileName=null;
String FileImport = "N";
String arrayParamsPart1Name [] = new String[10];
String arrayParamsPart1Value [] = new String[10];
String arrayParamsPart2Name [] = new String[10];
String arrayParamsPart2Value [] = new String[10];
String isDataSaved = "";
String isAddedToAcceptList = "";
String isAdminUser = null;
Date resultedDate = new Date();
if(request.getAttribute("ReportData") != null)
	linkedHashMap = (LinkedHashMap)request.getAttribute("ReportData");
if(request.getAttribute("counter") != null)
	counter= Integer.parseInt((String)request.getAttribute("counter"));
if(linkedHashMap.get("TotalRecords") != null)
	totalRecords=((Integer)linkedHashMap.get("TotalRecords")).intValue();
if(linkedHashMap.get("ResultedRecords") != null)
	resultedRecords=(ArrayList)linkedHashMap.get("ResultedRecords");
if(linkedHashMap.get("FileName") != null)
	FileName=(String)linkedHashMap.get("FileName");
/*if(linkedHashMap.get("FileImport") != null)
	FileImport=(String)linkedHashMap.get("FileImport");
*/
//FileImport = "N";


if(session.getAttribute("ISADMIN") != null)
	isAdminUser = session.getAttribute("ISADMIN").toString().toUpperCase();	
isAdminUser = "N";
%>
<HTML>
   <HEAD>
   <TITLE>Screening Matches</TITLE>
<style>
.rightMainSearch {		
		background-color: #606062;
}

.forContentSearch {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 11px;
	background-color: #F2F2F1;
	padding-left: 10px;
}
.but1 {  font-size: 10px; color: #000000; text-align: center; background-color: #F2F2F1; background-repeat: no-repeat;height: 17px; width: 140px;border: 1px #000000 solid; clip:  rect(   )}
</style>
<script type="text/javascript">
	$(document).ready(function(){
		var id = '${UNQID}';
		$('[data-toggle="tooltip"]').tooltip("hide");
		$('[data-toggle="tooltip"]').tooltip({container:'body'});
		
		
		var slidingDiv = $(".panelSlidingRealTimeScanningResult"+id);
		var panelBody = $(slidingDiv).parent("div.card").find("div.panelSearchForm");
		$(panelBody).slideUp();
		$(slidingDiv).addClass('card-collapsed');
		$(slidingDiv).find('i.collapsable').removeClass('fa-chevron-up').addClass('fa-chevron-down');
		
		$(".panelCollapsable"+id).click(function(){
			var slidingDiv = $(".panelSlidingRealTimeScanningResult"+id);
			var panelBody = $(slidingDiv).parent("div.card").find("div.panelSearchForm");
			if($(slidingDiv).hasClass("card-collapsed")){
				$(panelBody).slideDown();
				$(slidingDiv).removeClass('card-collapsed');
				$(slidingDiv).find("i.collapsable").removeClass("fa-chevron-down").addClass("fa-chevron-up");
			}else{
				$(panelBody).slideUp();
				$(slidingDiv).addClass('card-collapsed');
				$(slidingDiv).find('i.collapsable').removeClass('fa-chevron-up').addClass('fa-chevron-down');
			}
		});

		$(".markMatchAction").click(function(){
			$('[data-toggle="tooltip"]').tooltip("hide");
			setHiddenTextValue();
			var checkboxes = getMarkedEntities();
			if(checkboxes == '') {
				alert('Please Check Atleast One checkbox');
				return;
			}
			var fileName = $("#rt_filename").val();
			var FileImport = $("#rt_FileImport").val();
			var counter = $("#rt_counter").val();
			var action = $(this).attr("action");
			
			$("#compassMediumGenericModal").modal("show");
			$("#compassMediumGenericModal-title").html("Customer DeDup Scanning");
			$("#compassMediumGenericModal-body").html("<br/><center><img alt='Loading...' src='${pageContext.request.contextPath}/includes/images/qde-loadder.gif'><center><br/>");
			// window.open('<%=contextPath%>/common/AddDeDupComments?RecordStatus=<%=recordStatus%>&ScanningFromDate=<%=scanningFromDate%>&ScanningToDate=<%=scanningToDate%>&ProcessingFromDate=<%=processingFromDate%>&ProcessingToDate=<%=processingToDate%>&selected='+checkboxes+'&action='+action+'&counter='+counter+'&FileName='+fileName+'&FileImport='+FileImport,'','width=420,height=200,left=300,top=350,screenX=250,screenY=300,OuterWidth=370,OuterHeight=150,resizable=yes,scrollbars=yes');
			
			var url = "${pageContext.request.contextPath}/common/AddDeDupComments?RecordStatus=<%=recordStatus%>"+
					  "&ScanningFromDate=<%=scanningFromDate%>&ScanningToDate=<%=scanningToDate%>"+
					  "&ProcessingFromDate=<%=processingFromDate%>&ProcessingToDate=<%=processingToDate%>"+
					  "&selected="+checkboxes+"&action="+action+"&counter="+counter+"&FileName="+fileName+"&FileImport="+FileImport;
			 alert(url);			
			$.ajax({
		 		url : url,
		 		cache : true,
		 		type : 'GET',
		 		success : function(resData){
			 		$("#compassMediumGenericModal-body").html(resData);
		 		}
		 	});
		});

		$("#attachMatchEvedence").click(function(){
			$('[data-toggle="tooltip"]').tooltip("hide");
			compassFileUpload.init("attachEvedence","${pageContext.request.contextPath}","customerDeDup","compassRTScanningModal","Y","Y","");
		});
		
		
		$("#compassFileUploadModal").on('hidden.bs.modal', function () {
			setHiddenTextValue();
			var counter = $("#rt_counter").val(); //  rt_counter
			var filename = $("#rt_filename").val();
			var FileImport = $("#rt_FileImport").val();
			/*
			var filename=document.viewmatches.filename.value;
			var FileImport=document.viewmatches.FileImport.value;
			*/
			$("#deDupFileMatchDetailsResult").html("<br/><center> <img src='<%=contextPath%>/includes/images/qde-loadder.gif' alt='Loading...'/></center>");
			var url = "<%=contextPath%>/common/fileMatches?counter="+counter+"&filename="+filename+""+
			"&FileImport="+FileImport+"&UserCode=<%=userCode%>&RecordStatus=<%=recordStatus%>"+
			"&ScanningFromDate=<%=scanningFromDate%>&ScanningToDate=<%=scanningToDate%>"+
			"&ProcessingFromDate=<%=processingFromDate%>&ProcessingToDate=<%=processingToDate%>";
			
			$.ajax({
		 		url : url,
		 		cache : true,
		 		type : 'POST',
		 		success : function(resData){
		 			var RTWindow = $("#RTWindow").val();
		 			if(RTWindow != undefined){
		 				$("#RTScanningNewWindow").html(resData);
		 			}else{
		 				$('[data-toggle="tooltip"]').tooltip("hide");
			 			$("#compassRTScanningModal-body").html(resData);
		 			}
		 		}
		 	});
		});

		$("#refreshPage").click(function(){
			setHiddenTextValue();
			var counter = $("#rt_counter").val(); //  rt_counter
			var filename = $("#rt_filename").val();
			var FileImport = $("#rt_FileImport").val();
			
			/*
			var filename=document.viewmatches.filename.value;
			var FileImport=document.viewmatches.FileImport.value;
			*/

			$("#deDupFileMatchDetailsResult").html("<br/><center> <img src='<%=contextPath%>/includes/images/qde-loadder.gif' alt='Loading...'/></center>");
			var url = "<%=contextPath%>/common/fileMatches?counter="+counter+"&filename="+filename+""+
			"&FileImport="+FileImport+"&UserCode=<%=userCode%>&RecordStatus=<%=recordStatus%>"+
			"&ScanningFromDate=<%=scanningFromDate%>&ScanningToDate=<%=scanningToDate%>"+
			"&ProcessingFromDate=<%=processingFromDate%>&ProcessingToDate=<%=processingToDate%>";

			$.ajax({
		 		url : url,
		 		cache : true,
		 		type : 'POST',
		 		success : function(resData){
		 			var RTWindow = $("#RTWindow").val();
		 			if(RTWindow != undefined){
		 				$("#RTScanningNewWindow").html(resData);
		 			}else{
		 				$('[data-toggle="tooltip"]').tooltip("hide");
			 			$("#compassRTScanningModal-body").html(resData);
		 			}
		 		}
		 	});
		});
		
		$("#searchRealTimeFile"+id).click(function(){
			var fileName = $("#rt_fileName_"+id).val();
			var reportStatus = $("#reportStatus"+id).val();
			var processingFromDate = $("#processingFromDate"+id).val();
			var processingToDate = $("#processingToDate"+id).val();
			$("#deDupFileMatchDetailsResult").html("<br/><center> <img src='<%=contextPath%>/includes/images/qde-loadder.gif' alt='Loading...'/></center>");
			
			var fullData = "counter=0&FileImport=Y&filename="+fileName+"&UserCode=NA&RecordStatus="+reportStatus+
			"&ScanningFromDate=&ScanningToDate=&ProcessingFromDate="+processingFromDate+"&ProcessingToDate="+processingToDate;
			
			$.ajax({
		 		url : "${pageContext.request.contextPath}/common/fileMatches",
		 		cache : true,
		 		type : "POST",
		 		data : fullData,
		 		success : function(resData){
		 			var RTWindow = $("#RTWindow").val();
		 			if(RTWindow != undefined){
		 				$("#RTScanningNewWindow").html(resData);
		 			}else{
		 				$("#compassRTScanningModal-body").html(resData);
		 			}
		 		}
		 	});
		});
		

		$(".viewAttachEvidence").click(function(){

			var count = getCountOfMarkedEntities();
			if(count == 0){
				alert('Please check one checkbox');
				return false;
			} else if (count > 1) {
				alert('Please check only one checkbox');
				return false;
			}
			else {
		   		var uniqueNum;
		   		uniqueNum = getMarkedEntities();
				// window.open("<%=contextPath%>/getAttachedCaseEvidence?userCode=<%= LOGGEDUSER%>&FlagType=Y&AlertNo="+uniqueNum,'ViewEvidence','width=420, height=200,toolbar=no,location=no, scrollbars=yes, top=250, left=100');
	 	    }

			$("#compassMediumGenericModal").modal("show");
			$("#compassMediumGenericModal-title").html("Customer DeDup  File Scanning");
			$("#compassMediumGenericModal-body").html("<br/><center><img alt='Loading...' src='${pageContext.request.contextPath}/includes/images/qde-loadder.gif'><center><br/>");
			
			var url = "<%=contextPath%>/getAttachedCaseEvidence?userCode=<%= LOGGEDUSER%>&FlagType=Y"+
			          "&AlertNo="+uniqueNum;
			// alert(url);			
			$.ajax({
		 		url : url,
		 		cache : true,
		 		type : 'GET',
		 		success : function(resData){
			 		$("#compassMediumGenericModal-body").html(resData);
		 		}
		 	});
		});

	});
</script>
<script language='javascript'>
<!--
    function getMarkedEntities(){
	   eleLen=document.viewmatches.elements.length;
       ele=eval("document.viewmatches.elements");
	   var checkedBox='';
	   var counter=0;
		
		for(var i=0; i<eleLen; i++)
	  	{
	  		if(ele[i].type=='checkbox' && ele[i].checked)
			{
				if(counter==0)
				{
                    checkedBox=ele[i].value.substr(0,ele[i].value.indexOf("^"));
					counter=1;
				}
				else
                    checkedBox=checkedBox+','+ele[i].value.substr(0,ele[i].value.indexOf("^"));
			} 
	  	}
		 return checkedBox;
	}
    
	function openSelectedListDetails(listname,listid,checkboxval)
	{
         if(listname !='NonCustomer')
         {
            var eleLen = document.forms[0].elements.length;
		var ele = eval("document.forms[0].elements");
		for(i=0;i<eleLen;i++)
		{
		  if(ele[i].type == "checkbox")
		  { 
		    if(ele[i].value == checkboxval)
		    {
		 	ele[i].checked = true;
		    }
		  }
		}
         window.open('<%=contextPath%>/common/RTlistDetails?listname='+listname+'&listid='+listid,'','width=550,height=635,left=0,top=0,screenX=250,screenY=300,OuterWidth=370,OuterHeight=150,toolbar=yes,location=no,resizable=yes, scrollbars=yes,menubar=yes');
         }
         else
         {
         window.open('<%=contextPath%>/common/RTlistDetails?listname='+listname+'&listid='+listid,'','width=550,height=635,left=525,top=0,screenX=250,screenY=300,OuterWidth=370,OuterHeight=150,toolbar=yes,location=no,resizable=yes, scrollbars=yes,menubar=yes');
         }
	}

	function openPreviousComments(comment){
	}
	function addNewComments(action)
	{
		setHiddenTextValue();
		var checkboxes = getMarkedEntities();
		if(checkboxes == '') {
			alert('Please Check Atleast One checkbox');
			return;
		}
		var counter = document.viewmatches.counter.value;
		var fileName  = document.viewmatches.filename.value;
		var FileImport  = document.viewmatches.FileImport.value;
		/*alert("RecordStatus="+recordStatus+"&ScanningFromDate="+scanningFromDate+
				"&ScanningToDate="+scanningToDate+"&ProcessingFromDate="+processingFromDate+"&ProcessingToDate="+processingToDate+
				"&selected="+checkboxes+"&action="+action+"&counter="+counter+"&FileName="+fileName+"&FileImport="+FileImport);
		*/
		window.open('<%=contextPath%>/common/AddDeDupComments?recordStatus=<%=recordStatus%>&ScanningFromDate='+scanningFromDate+'&ScanningToDate='+scanningToDate
				+'&ProcessingFromDate='+processingFromDate+'&ProcessingToDate='+processingToDate+'&selected='+checkboxes+'&action='+action
				+'&counter='+counter+'&FileName='+fileName+'&FileImport='+FileImport,'','width=550,height=635,left=0,top=0,screenX=250,screenY=300,OuterWidth=370,OuterHeight=150,toolbar=yes,location=no,resizable=yes, scrollbars=yes,menubar=yes');
		
	}
    function getMarkedEntitiesForAcceptList(key)
	{
		eleLen=document.viewmatches.elements.length;
	    ele=eval("document.viewmatches.elements");
		var checkedBox='';
		var counter=0;
		
		
		for(var i=0; i<eleLen; i++)
	  	{
	  		if(ele[i].type=='checkbox' && ele[i].checked)
			{
        	  if(counter==0)
			  {
		                      checkedBox=key+'^'+ele[i].value.substr(0,ele[i].value.indexOf("^"));
					counter=1;
			  }
				else
		                      checkedBox=checkedBox+','+(key+'^'+ele[i].value.substr(0,ele[i].value.indexOf("^")));
			} 
	  	}
         return checkedBox;
	}
      function getAcceptedMarkedEntitiesCount(key)
	{
   	    eleLen=document.viewmatches.elements.length;
	    ele=eval("document.viewmatches.elements");
	    var checkedBox='';
	    var counter=0;
		for(var i=0; i<eleLen; i++)
	  	{
	  		if(ele[i].type=='checkbox' && ele[i].checked)
			{
				if(ele[i].value.substr(ele[i].value.indexOf("^")+1)=='Y')
				{
					counter=counter+1;
				}
			} 
					
	  	}
		 return counter;
	}

      function getNotAcceptedMarkedEntitiesCount(key)
	{
   	    eleLen=document.viewmatches.elements.length;
	    ele=eval("document.viewmatches.elements");
	    var checkedBox='';
	    var counter=0;
		for(var i=0; i<eleLen; i++)
	  	{
	  		if(ele[i].type=='checkbox' && ele[i].checked)
			{
				if(ele[i].value.substr(ele[i].value.indexOf("^")+1)=='N')
				{
					counter=counter+1;
				}
			} 
					
	  	}
		 return counter;
	}

      function AddToPartyList(key,AcctCustID,ActTaken)
      {
    	  var userCode = '${usercode}';
  		setHiddenTextValue();
  		var checkboxes1 = key;
  		var countvalue = getAcceptedMarkedEntitiesCount(key);
  		var countvalue2 = getNotAcceptedMarkedEntitiesCount(key);
  		var checkboxes = getMarkedEntitiesForAcceptList(key);
  		if(countvalue > 0 && ActTaken == 'ToAdd') 
  		{
  			alert('Please UnCheck Already listed entity');
  		return;
  		}
  		if(countvalue2 > 0 && ActTaken == 'ToRemove') 
  		{
  			alert('Please UnCheck Already removed entity');
  		return;
  		}

  		if(checkboxes == '')
  		{
  			alert('Please Check Atleast One checkbox');
  			return;
  		}
          var action = ActTaken ;
          var counter = document.viewmatches.counter.value;
  		var fileName  = document.viewmatches.filename.value;
  		var FileImport  = document.viewmatches.FileImport.value;
  		window.open('<%=contextPath%>/common/AddDeDupComments?UserCode='+userCode+'&counter='+counter+'&TopN='+counter+'&l_strFromDate=<%=l_strFromDate%>&l_strToDate=<%=l_strToDate%>&l_strCustomerNameCheck=<%=l_strCustomerNameCheck%>&l_strMotherNameCheck=<%=l_strMotherNameCheck%>&l_strPermanentAddressLine1Check=<%=l_strPermanentAddressLine1Check%>&l_strCommAddressLine1Check=<%=l_strCommAddressLine1Check%>&l_strPanNoCheck=<%=l_strPanNoCheck%>&l_strPassportNoCheck=<%=l_strPassportNoCheck%>&l_strDrivingLicenseNoCheck=<%=l_strDrivingLicenseNoCheck%>&l_strDateOfBirthCheck=<%=l_strDateOfBirthCheck%>&selected='+checkboxes+'&action='+action,'','width=420,height=220,left=300,top=350,screenX=250,screenY=300,OuterWidth=370,OuterHeight=150,resizable=yes,scrollbars=yes');
  	}
      
	function addEntityToAcceptList(key,AcctCustID,ActTaken) {
			if(AcctCustID == 'N.A') {
   				alert('WhiteListing can be done for entity where atleast custID or AcctID is present');
				return;
            }  

            setHiddenTextValue();

            var checkboxes1 = key;
            var countvalue = getAcceptedMarkedEntitiesCount(key);
            var countvalue2 = getNotAcceptedMarkedEntitiesCount(key);
            var checkboxes = getMarkedEntitiesForAcceptList(key);
            if(countvalue > 0 && ActTaken == 'ToAdd') {
            	alert('Please UnCheck Already whitelisted entity');
				return;
            }
            if(countvalue2 > 0 && ActTaken == 'ToRemove') {
            	alert('Please UnCheck Already removed entity');
				return;
            }

		if(checkboxes == ''){
			alert('Please Check Atleast One checkbox');
			return;
		}

		var action = ActTaken ;
        var counter = document.viewmatches.counter.value;
		var fileName  = document.viewmatches.filename.value;
		var FileImport  = document.viewmatches.FileImport.value;
		//window.open('<%=contextPath%>/OnlineScanning/AddComments.jsp?UserCode=<%=userCode%>&RecordStatus=<%=recordStatus%>&ScanningFromDate=<%=scanningFromDate%>&ScanningToDate=<%=scanningToDate%>&ProcessingFromDate=<%=processingFromDate%>&ProcessingToDate=<%=processingToDate%>&selected='+checkboxes+'&action='+action+'&counter='+counter+'&FileName='+fileName+'&FileImport='+FileImport,'','width=420,height=220,left=300,top=350,screenX=250,screenY=300,OuterWidth=370,OuterHeight=150,resizable=yes,scrollbars=yes');

		var url = "${pageContext.request.contextPath}/common/AddRTComments?UserCode=<%=userCode%>&RecordStatus=<%=recordStatus%>"+
				  "&ScanningFromDate=<%=scanningFromDate%>&ScanningToDate=<%=scanningToDate%>&ProcessingFromDate=<%=processingFromDate%>"+
				  "&ProcessingToDate=<%=processingToDate%>&selected="+checkboxes+"&action="+action+
				  "&counter="+counter+"&FileName="+fileName+"&FileImport="+FileImport;
		
		$("#compassMediumGenericModal").modal("show");
		$("#compassMediumGenericModal-title").html("Add/Remove TO Accept List");
		$("#compassMediumGenericModal-body").html("<br/><center><img alt='Loading...' src='${pageContext.request.contextPath}/includes/images/qde-loadder.gif'><center><br/>");
		
		$.ajax({
			url : url,
			cache : true,
			type : 'GET',
			success : function(resData){
				$("#compassMediumGenericModal-body").html(resData);
			}
		});
	 }
	 
     function oldMarkedAcceptListEntities(key)
     {
           alert('This key has already added to the AcceptList'); 
     }
      function attachFileEvidence()
      {		
        var count = getCountOfMarkedEntities();
		if(count == 0)
			alert('Please check one checkbox');
		else if (count > 1)
			alert('Please check only one checkbox');
		else
		{
		   		var uniqueNum;
		   		uniqueNum = getMarkedEntities();
				window.open("<%=contextPath%>/getCaseEvidence?userCode=<%= LOGGEDUSER%>&FlagType=Y&AlertNo="+uniqueNum,'ViewEvidence','width=420, height=200,toolbar=no,location=no, scrollbars=yes, top=250, left=100');
 	       }
     }	
	
	function getCountOfMarkedEntities()
	{
		var eleLen = document.forms[0].elements.length;
		var ele = eval("document.forms[0].elements");
		var count = 0 ;
		var B="true";
		for(i=0;i<eleLen;i++)
		   {
			if(ele[i].type == "checkbox")
			 { 
				if(ele[i].checked == true)
				{
					count++  ;
				}
				
			 }
		   }
		  return count;
	}
	
	function getCountOfMarkedEntities()
	{
	   eleLen=document.viewmatches.elements.length;
       ele=eval("document.viewmatches.elements");
	   var checkedBox='';
	   var counter=0;
		
		for(var i=0; i<eleLen; i++)
	  	{
	  		if(ele[i].type=='checkbox' && ele[i].checked)
			{
	  			counter = counter + 1;	
	  		} 
	  	}
		 return counter;
	}	
	
    function setHiddenTextValue()
    {
		var fileimport = '<%=FileImport%>';
		var filename = '<%=FileName%>';
		
		document.viewmatches.FileImport.value = fileimport;
		
		if(fileimport == 'N')
			document.viewmatches.filename.value = filename;
		else
			document.viewmatches.filename.value = filename; //parent.topFrame.filterform.filename.options[parent.topFrame.filterform.filename.selectedIndex].value;
    }
	function getPrevRecords()
	{
		setHiddenTextValue();
		var counter = <%=counter%>;
		counter = counter-20;
		var filename=document.viewmatches.filename.value;
		var FileImport=document.viewmatches.FileImport.value;
		
		$("#deDupFileMatchDetailsResult").html("<br/><center> <img src='<%=contextPath%>/includes/images/qde-loadder.gif' alt='Loading...'/></center>");
		
		var url = "<%=contextPath%>/common/fileMatches?counter="+counter+"&filename="+filename+""+
		"&FileImport="+FileImport+"&UserCode=<%=userCode%>&RecordStatus=<%=recordStatus%>"+
		"&ScanningFromDate=<%=scanningFromDate%>&ScanningToDate=<%=scanningToDate%>"+
		"&ProcessingFromDate=<%=processingFromDate%>&ProcessingToDate=<%=processingToDate%>";
		
		$.ajax({
	 		url : url,
	 		cache : false,
	 		type : 'POST',
	 		success : function(resData){
	 			var RTWindow = $("#RTWindow").val();
	 			if(RTWindow != undefined){
	 				$("#RTScanningNewWindow").html(resData);
	 			}else{
	 				$('[data-toggle="tooltip"]').tooltip("hide");
		 			$("#compassCaseWorkFlowGenericModal-body").html(resData);
	 			}
	 		}
	 	});
		
	//	document.viewmatches.action='<%=contextPath%>/fileMatches?counter='+counter+'&filename='+filename+'&FileImport='+FileImport+'&UserCode=<%=userCode%>&RecordStatus=<%=recordStatus%>&ScanningFromDate=<%=scanningFromDate%>&ScanningToDate=<%=scanningToDate%>&ProcessingFromDate=<%=processingFromDate%>&ProcessingToDate=<%=processingToDate%>';
	//	document.viewmatches.submit();
	}
	
	function getNextRecords() {
		setHiddenTextValue();
		var userCode = '${userCode}';
		var l_strFromDate = '${l_strFromDate}';
		var l_strToDate = '${l_strToDate}';
		var l_strCustomerNameCheck = '${l_strCustomerNameCheck}';
		var l_strMotherNameCheck = '${l_strMotherNameCheck}';
		var l_strPermanentAddressLine1Check = '${l_strPermanentAddressLine1Check}';
		var l_strCommAddressLine1Check = '${l_strCommAddressLine1Check}';
		var l_strPanNoCheck = '${l_strPanNoCheck}';
		var l_strPassportNoCheck = '${l_strPassportNoCheck}';
		var l_strDrivingLicenseNoCheck = '${l_strDrivingLicenseNoCheck}';
		var l_strDateOfBirthCheck = '${l_strDateOfBirthCheck}';
		var counter = <%=counter%>;
		counter = counter+20;
		
		
		$("#deDupFileMatchDetailsResult").html("<br/><center> <img src='<%=contextPath%>/includes/images/qde-loadder.gif' alt='Loading...'/></center>");

		var fullData = "l_strFromDate="+l_strFromDate+"&l_strToDate="+l_strToDate+"&l_strCustomerNameCheck="+l_strCustomerNameCheck+
						"&l_strMotherNameCheck="+l_strMotherNameCheck+"&l_strPermanentAddressLine1Check="+l_strPermanentAddressLine1Check+
						"&l_strCommAddressLine1Check="+l_strCommAddressLine1Check+"&l_strPanNoCheck="+l_strPanNoCheck+
						"&l_strPassportNoCheck="+l_strPassportNoCheck+"&l_strDrivingLicenseNoCheck="+l_strDrivingLicenseNoCheck+
						"&l_strDateOfBirthCheck="+l_strDateOfBirthCheck;
		alert(fullData);
		$.ajax({
	 		url : '${pageContext.request.contextPath}/common/deDupScanningCheck',
	 		cache : false,
	 		type : 'POST',
	 		data : fullData,
	 		success : function(resData){
	 			//alert(resData);
	 			var RTWindow = $("#RTWindow").val();
	 			if(RTWindow != undefined){
	 				$("#RTScanningNewWindow").html(resData);
	 			}else{
	 				$('[data-toggle="tooltip"]').tooltip("hide");
		 			$("#compassCaseWorkFlowGenericModal-body").html(resData);

	 			}
	 			
	 		}
	 	});
		
	//	document.viewmatches.action='<%=contextPath%>/fileMatches?counter='+counter+'&filename='+filename+'&FileImport='+FileImport+'&UserCode=<%=userCode%>&RecordStatus=<%=recordStatus%>&ScanningFromDate=<%=scanningFromDate%>&ScanningToDate=<%=scanningToDate%>&ProcessingFromDate=<%=processingFromDate%>&ProcessingToDate=<%=processingToDate%>';

	//	document.viewmatches.submit();
	}
      function getAndSetNextValue()
	{
		setHiddenTextValue();
		var counter = document.viewmatches.EnterValue.value;
		counter = (counter-1)* 20;
		
		var filename=document.viewmatches.filename.value;
		var FileImport=document.viewmatches.FileImport.value;
		
		$("#deDupFileMatchDetailsResult").html("<br/><center> <img src='<%=contextPath%>/includes/images/qde-loadder.gif' alt='Loading...'/></center>");
		
		var url = "<%=contextPath%>/common/fileMatches?counter="+counter+"&filename="+filename+""+
		"&FileImport="+FileImport+"&UserCode=<%=userCode%>&RecordStatus=<%=recordStatus%>"+
		"&ScanningFromDate=<%=scanningFromDate%>&ScanningToDate=<%=scanningToDate%>"+
		"&ProcessingFromDate=<%=processingFromDate%>&ProcessingToDate=<%=processingToDate%>";
		
		$.ajax({
	 		url : url,
	 		cache : false,
	 		type : 'POST',
	 		success : function(resData){
	 			var RTWindow = $("#RTWindow").val();
	 			if(RTWindow != undefined){
	 				$("#RTScanningNewWindow").html(resData);
	 			}else{
	 				$('[data-toggle="tooltip"]').tooltip("hide");
		 			$("#compassCaseWorkFlowGenericModal-body").html(resData);
	 			}
	 		}
	 	});
		
	//	document.viewmatches.action='<%=contextPath%>/fileMatches?counter='+counter+'&filename='+filename+'&FileImport='+FileImport+'&UserCode=<%=userCode%>&RecordStatus=<%=recordStatus%>&ScanningFromDate=<%=scanningFromDate%>&ScanningToDate=<%=scanningToDate%>&ProcessingFromDate=<%=processingFromDate%>&ProcessingToDate=<%=processingToDate%>';

	//	document.viewmatches.submit();
	}
	function openPrintFormatPage(key)
	{	
		window.open('<%=contextPath%>/common/printPage?UserCode=<%=userCode%>&RecordStatus=<%=recordStatus%>&ScanningFromDate=<%=scanningFromDate%>&ScanningToDate=<%=scanningToDate%>&ProcessingFromDate=<%=processingFromDate%>&ProcessingToDate=<%=processingToDate%>&filename='+key+'&key='+key,'','width=1000,height=680,left=0,top=0,screenX=250,screenY=300,OuterWidth=370,OuterHeight=150,toolbar=yes,location=no,resizable=yes, scrollbars=yes,menubar=yes');
	}
	function showMatches(key1, key2)
	{	
	window.open('<%=contextPath%>/common/showDeDupCustMatches?key1='+key1+'&key2='+key2,'','width=1000,height=680,left=0,top=0,screenX=250,screenY=300,OuterWidth=370,OuterHeight=150,toolbar=yes,location=no,resizable=yes, scrollbars=yes,menubar=yes');
	}
	
-->
</script>
</head>
<body>
<div class="row">
	<div class="col-sm-12">
		<div class="card card-primary">
			<div class="card-header panelCollapsable${UNQID} clearfix">
				<h6 class="card-title pull-left">Customer DeDup  Scanning Result</h6>
				<div class="btn-group pull-right clearfix">
					<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
				</div>
			</div>
			<div id="deDupFileMatchDetailsResult">
			<FORM METHOD='POST' name='viewmatches' action="javascript:void(0)">
			<%
			if(linkedHashMap != null && linkedHashMap.size()>=4){
				String strColumnNameArray [] = (String [])linkedHashMap.get("ColumnName");
				%>
				<table align='center' border="0" width="100%" class="table table-bordered table-striped" style="margin-bottom: 0;">
					<tr>
						<%if(counter >= 20) {%>
									<td>
										&nbsp;&nbsp;<img src="<%=contextPath%>/includes/images/prev.gif" border="0" alt="Prev" onClick="getPrevRecords()"> 
									</td>
									<% } if(counter+20 < totalRecords) { %>
									<td>
										&nbsp;&nbsp;<img src="<%=contextPath%>/includes/images/next.gif" border="0" alt="Next" onClick="getNextRecords()">
									</td>
									<td> 
										&nbsp;&nbsp;<input type="text" name="EnterValue" size=2 maxsize =2>
										<INPUT TYPE='button' NAME='callnextvalue' VALUE='GO' class="but" onClick=" getAndSetNextValue()">
									</td>
									<% } %>
		    			
		    			<td nowrap="nowrap" width="30%">
		    				<div class="span1">
		    					<font  face="verdana" size=2 align='right'>
		    						<b>Dated On : </b><%=resultedDate%> 
		    					</font>
		    				</div>
		    			</td>
						<td nowrap="nowrap" width="20%">
							<div class="span1">
								<font  face="verdana" size=2 align='right'>
									<b>UserCode : </b><%= LOGGEDUSER %>
								</font>
							</div>
						</td>
						<td nowrap="nowrap" width="30%">
							<table>
								<tr>
									<td width="40%">
										<font face="verdana" size=2 align='right'><b>PageNo:</b>
										<%=(int)Math.ceil((double)(counter+1)/20)%>/<%=(int)Math.ceil((double)(totalRecords)/20)%></font>
									</td>
									<td width="30%">
										<font face="verdana" size="2" style="color:red">True Match</font>
									</td>
									<td width="30%">
										<font face="verdana" size="2" style="color:green">False Match</font>
									</td>
								</tr>
							</table>
		    			</td>
					</TR>
				</TABLE>
				<%		
				Set set = linkedHashMap.keySet();
				Iterator iterator = set.iterator();
				while(iterator.hasNext())
				{
				String strMapKey = (String)iterator.next();
				if(!(strMapKey.equals("ColumnName")) && !(strMapKey.equals("TotalRecords")) && !(strMapKey.equals("FileName")) && !(strMapKey.equals("FileImport")) ){
				ArrayList alMatchedList  = (ArrayList)linkedHashMap.get(strMapKey);
				String strCustomerName = alMatchedList.get(0).toString();
				String strMatchedCustomerId = alMatchedList.get(2).toString();
				%>
					<table width="100%" border="0" class="table table-bordered table-striped" style="margin-bottom: 0;">
						<tr>
							<td align="left"><font face="verdana" size="2"><b> 
				  				 <a title="View customer details" onclick="openSelectedListDetails('Customer','<%=strMapKey%>',' ')"><%=strCustomerName%></a></font>
				  				 <img src="${pageContext.request.contextPath}/includes/images/Log_16X16.gif" onclick="showMatches('<%=strMapKey%>','ALL')" title="View matches" style="cursor: hand">
				  				 <img src="${pageContext.request.contextPath}/includes/images/addToList.gif" 
				  				 onClick="AddToPartyList('<%=strMapKey%>','<%=strMatchedCustomerId%>','ToAdd')" title="Add To Party" style="cursor: hand">
							</b></td>
  						</tr>
					</table> 
					<table border="0" width="100%" cellspacing="1" cellpadding="1" class="table table-bordered table-striped">
					<TH class="info" style="text-align: center;"><font color="black" size="2">&nbsp;</font></TH>
					<% for(int j=2;j<strColumnNameArray.length-6;j++){  %>  
						<TH class="info" style="text-align: center;"><font color="black" size="2"><%=strColumnNameArray[j]%></font></TH>
					<%		
					}
					for(int i=0;i<alMatchedList.size();i=i+(strColumnNameArray.length-1))
					{

					%>
			<%
			String strTempColumn = null; 
			
			String strActionFlag = alMatchedList.get(i+8).toString();
			if(strActionFlag.equals("A")){
				strTempColumn = "bgcolor='RED'";
			} else if (strActionFlag.equals("R")){
				strTempColumn = "bgcolor='#71bd5c'";
			} else {
				strTempColumn = "";
			}
			String strMatchScore = alMatchedList.get(i+3).toString();
			String strBlackListName = alMatchedList.get(i+1).toString();
			String l_strIsIndiPartyList = alMatchedList.get(i+11).toString().trim();
		    String strIsFileAttached = alMatchedList.get(i+10).toString().trim();
			%>	
				<tr <% if(!strActionFlag.equals("N")){ %>style="cursor: hand;" onClick=openPreviousComments('<%=alMatchedList.get(i+9)%>')<%}%>>
					 <td bgcolor="<%=strTempColumn%>" width='5%' align='center'><input type='checkbox' name='check1' value='<%=(alMatchedList.get(i+2).toString())+"^"+l_strIsIndiPartyList%>'></td>
					 <% if(l_strIsIndiPartyList.equals("Y")) { %>  
					 <td bgcolor="<%=strTempColumn%>" width='15%' align='center'>
					 	<img src="${pageContext.request.contextPath}/includes/images/RemoveUser24X24.gif" onclick="AddToPartyList('<%=strMapKey%>','<%=alMatchedList.get(i+2).toString()%>','ToRemove')" title="Remove From Party" style="cursor: hand">
					 <font size="2"><a onclick= "showMatches('<%=strMapKey%>','<%=alMatchedList.get(i+2).toString()%>')" title="View matches"><%=strBlackListName%></font></a>
					 <% } else { %>
					 <td bgcolor="<%=strTempColumn%>" width='15%' align='center'><font size="2"><a onclick= "showMatches('<%=strMapKey%>','<%=alMatchedList.get(i+2).toString()%>')" title="View matches"><%=strBlackListName%></font></a>
					 <% }  if(strIsFileAttached.equals("Y")) { %> 
					 <img src="<%=contextPath%>/images/email.gif" title="Document Attached" style="cursor: hand">
					 <% }%>
					 </td>
					 <td bgcolor="<%=strTempColumn%>" width='5%' align='center'>
					 <font size="2">
					 <a onclick="openSelectedListDetails('Customer','<%=alMatchedList.get(i+2).toString()%>','<%=strMapKey+"^"+alMatchedList.get(i+2).toString()%>')" title="View customer details"> <%=alMatchedList.get(i+2).toString()%>
					 </font>
					 </a>
					 </td>
					 <td bgcolor="<%=strTempColumn%>" width='5%' align='center'><font size="2"><%=strMatchScore%></font></td>
                           <td bgcolor="<%=strTempColumn%>" width='25%' align='center'><font size="2"><%=alMatchedList.get(i+4).toString()%></font></td>
                           <td bgcolor="<%=strTempColumn%>" width='25%' align='center'><font size="2"><%=alMatchedList.get(i+5).toString()%></font></td>
				</tr>
		
		<%			
			}
%>
				</table>		
<%		
       } 
       }
      %>
		<!-- <BR>
		<BR> -->
		<table border=0 width="100%">
		<br>
		<TR>
		<TD align="center" colspan="7">
        <button type="button" class="btn btn-danger btn-sm markMatchAction" action="Approve" >TRUE MATCH</button>
        <button type="button" class="btn btn-success btn-sm markMatchAction" action="Reject" >FALSE MATCH</button>
        <button type="button" class="btn btn-warning btn-sm" id="attachMatchEvedence">Attach Evidence</button>
        <button type="button" class="btn btn-primary btn-sm" id="refreshPage">Refresh</button>
        <!-- <INPUT TYPE='button' NAME='Approve' VALUE='TRUE MATCH' class="btn btn-sm btn-success" onclick="addNewComments('Approve')">
		<INPUT TYPE='button' NAME='Reject' VALUE='FALSE MATCH'  class="btn btn-sm btn-danger" onclick="addNewComments('Reject')">
		<INPUT TYPE='button' NAME= 'AttachEvidence' id="attachMatchEvedence" value ='VIEW/ATTACH EVIDENCE' class="btn btn-sm btn-warning"  onclick="attachFileEvidence();" > 
		<INPUT TYPE='button' NAME='Close' VALUE='CLOSE'  class="btn btn-sm btn-danger" onclick="window.close()"> -->
	    </TD>
	    </TR> 
		<table>
		<% }
	else
	{
%>
		<br>
		<br>
		<table width="100%" border="0" cellspacing="0" cellpadding="0" bgcolor="#F3E2D1">
                  <tr>
                  <td></td>
                  <td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td>
                      <td></td><td></td><td></td><td></td><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td><td></td><td></td>
                      <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td><td></td><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td><td></td>
                    <td>
										<div class="span1">
											<font  face="verdana" size=2 align='right'><b>Dated On : <%=resultedDate%> </b></font>
										</div>	
			  </td>
                    <td>
										<div class="span1">
											<font  face="verdana" size=2 align='right'><b>UserCode : <%=request.getRemoteUser()%> </b></font>
										</div>	
			  </td>
                  </tr>
			<tr>
			<td>
										<div class="span1">
											<font  face="verdana" size=2 align='center'><b>No Match Found </b></font>
										</div>	
			</td>
			</tr>
                  <tr>
                  <td></td><td></td><td></td><td></td><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td><td></td><td></td><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td><td></td>
                  <%
                  if(FileImport.equals("Y"))
                  { %>
                  <td>
                     <!-- <INPUT TYPE='button' NAME='Export' VALUE='EXPORT TO FILE'  class="but1" onClick=" addNewComments('Export')"> -->
                  </td>
                  <% } %>
                  </tr>
		</table>
<%
	}
%>


	<input type='hidden' name='filename' id="rt_filename">
	<input type='hidden' name='FileImport' id="rt_FileImport">
	<input type='hidden' name='counter' id="rt_counter" value='<%=counter%>'>
</table>
</table>
</FORM>
</div>
</div>
</div>
</div>
</body>
</HTML>
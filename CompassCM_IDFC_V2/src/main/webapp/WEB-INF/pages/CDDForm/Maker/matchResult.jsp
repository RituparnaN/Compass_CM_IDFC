<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../tags/tags.jsp"%>
<%@page import="java.util.*,com.quantumdataengines.app.compass.model.scanning.RTMatchResultVO"%>
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

LinkedHashMap linkedHashMap = null;
int totalRecords = 0;
ArrayList resultedRecords = new ArrayList();
RTMatchResultVO rtMatchResultVO = null;
int counter = 0;
String FileName=null;
String FileImport = "N";
ArrayList alInputParametersName = null;
ArrayList alInputParametersValue = null;
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
if(linkedHashMap.get("FileImport") != null)
	FileImport=(String)linkedHashMap.get("FileImport");

//FileImport = "N";
if(FileImport.equalsIgnoreCase("N"))
{
	if(session.getAttribute("SearchParametersName") != null)
		alInputParametersName = (ArrayList)session.getAttribute("SearchParametersName");
	if(session.getAttribute("SearchParametersValue") != null)
		alInputParametersValue = (ArrayList)session.getAttribute("SearchParametersValue");
}
if(alInputParametersName != null && alInputParametersName.size() > 0 && alInputParametersValue != null && alInputParametersValue.size() > 0 )
{
  for(int i=0;i< alInputParametersName.size();i++)
  { 
    if(alInputParametersName.get(i).equals("NAME1"))
    {
     arrayParamsPart1Name[0] = alInputParametersName.get(i).toString() ; 
     arrayParamsPart1Value[0] = alInputParametersValue.get(i).toString();
    }
    if(alInputParametersName.get(i).equals("NAME3"))
    {
     arrayParamsPart1Name[1] = alInputParametersName.get(i).toString(); 
     arrayParamsPart1Value[1] = alInputParametersValue.get(i).toString();
    } 
    if(alInputParametersName.get(i).equals("NAME5"))
    {
     arrayParamsPart1Name[2] = alInputParametersName.get(i).toString(); 
     arrayParamsPart1Value[2] = alInputParametersValue.get(i).toString();
    } 
    if(alInputParametersName.get(i).equals("PASSPORTNO"))
    {
     arrayParamsPart1Name[3] = alInputParametersName.get(i).toString(); 
     arrayParamsPart1Value[3] = alInputParametersValue.get(i).toString();
    } 
    if(alInputParametersName.get(i).equals("ACCOUNTNO"))
    {
     arrayParamsPart1Name[4] = alInputParametersName.get(i).toString(); 
     arrayParamsPart1Value[4] = alInputParametersValue.get(i).toString();
    } 
	if(alInputParametersName.get(i).equals("NAME2"))
    {
     arrayParamsPart2Name[0] = alInputParametersName.get(i).toString(); 
     arrayParamsPart2Value[0] = alInputParametersValue.get(i).toString();
    } 
    
    if(alInputParametersName.get(i).equals("NAME4"))
    {
     arrayParamsPart2Name[1] = alInputParametersName.get(i).toString(); 
     arrayParamsPart2Value[1] = alInputParametersValue.get(i).toString();
    } 
    if(alInputParametersName.get(i).equals("DATEOFBIRTH"))
    {
     arrayParamsPart2Name[2] = alInputParametersName.get(i).toString(); 
     arrayParamsPart2Value[2] = alInputParametersValue.get(i).toString();
    } 

    if(alInputParametersName.get(i).equals("PANNO"))
    {
     arrayParamsPart2Name[3] = alInputParametersName.get(i).toString() ; 
     arrayParamsPart2Value[3] = alInputParametersValue.get(i).toString();
    }
    if(alInputParametersName.get(i).equals("CUSTOMERID"))
    {
     arrayParamsPart2Name[4] = alInputParametersName.get(i).toString(); 
     arrayParamsPart2Value[4] = alInputParametersValue.get(i).toString();
    } 
}
}
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
			$("#compassMediumGenericModal-title").html("Real Time File Scanning");
			$("#compassMediumGenericModal-body").html("<br/><center><img alt='Loading...' src='${pageContext.request.contextPath}/includes/images/qde-loadder.gif'><center><br/>");
			// window.open('<%=contextPath%>/common/AddRTComments?RecordStatus=<%=recordStatus%>&ScanningFromDate=<%=scanningFromDate%>&ScanningToDate=<%=scanningToDate%>&ProcessingFromDate=<%=processingFromDate%>&ProcessingToDate=<%=processingToDate%>&selected='+checkboxes+'&action='+action+'&counter='+counter+'&FileName='+fileName+'&FileImport='+FileImport,'','width=420,height=200,left=300,top=350,screenX=250,screenY=300,OuterWidth=370,OuterHeight=150,resizable=yes,scrollbars=yes');
			
			var url = "${pageContext.request.contextPath}/common/AddRTComments?RecordStatus=<%=recordStatus%>"+
					  "&ScanningFromDate=<%=scanningFromDate%>&ScanningToDate=<%=scanningToDate%>"+
					  "&ProcessingFromDate=<%=processingFromDate%>&ProcessingToDate=<%=processingToDate%>"+
					  "&selected="+checkboxes+"&action="+action+"&counter="+counter+"&FileName="+fileName+"&FileImport="+FileImport;
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

		$("#attachMatchEvedence").click(function(){
			$('[data-toggle="tooltip"]').tooltip("hide");
			compassFileUpload.init("attachEvedence","${pageContext.request.contextPath}","realTimScreening","compassRTScanningModal","Y","Y","");
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
			$("#realTimeFileMatchDetailsResult").html("<br/><center> <img src='<%=contextPath%>/includes/images/qde-loadder.gif' alt='Loading...'/></center>");
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

			$("#realTimeFileMatchDetailsResult").html("<br/><center> <img src='<%=contextPath%>/includes/images/qde-loadder.gif' alt='Loading...'/></center>");
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

		$("#getNextPage").click(function(){
			// setHiddenTextValue();
			var counter = 0;
			counter = $("#rt_counter").val(); //  rt_counter
			counter = (1*counter)+20;
			var filename = $("#rt_filename").val();
			var FileImport = $("#rt_FileImport").val();
			
			/*
			var filename=document.viewmatches.filename.value;
			var FileImport=document.viewmatches.FileImport.value;
			*/

			$("#realTimeFileMatchDetailsResult").html("<br/><center> <img src='<%=contextPath%>/includes/images/qde-loadder.gif' alt='Loading...'/></center>");
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

		$("#getPreviousPage").click(function(){
			// setHiddenTextValue();
			var counter = 0;
			counter = $("#rt_counter").val(); //  rt_counter
			counter = (1*counter)-20;
			var filename = $("#rt_filename").val();
			var FileImport = $("#rt_FileImport").val();
			
			/*
			var filename=document.viewmatches.filename.value;
			var FileImport=document.viewmatches.FileImport.value;
			*/

			$("#realTimeFileMatchDetailsResult").html("<br/><center> <img src='<%=contextPath%>/includes/images/qde-loadder.gif' alt='Loading...'/></center>");
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

		$("#getOnSpecificPage").click(function(){
			// setHiddenTextValue();
			var counter = $("#rt_EnterValue").val(); // document.viewmatches.EnterValue.value;
			counter = ((1*counter)-1)* 20;
			var filename = $("#rt_filename").val();
			var FileImport = $("#rt_FileImport").val();
			
			/*
			var filename=document.viewmatches.filename.value;
			var FileImport=document.viewmatches.FileImport.value;
			*/

			$("#realTimeFileMatchDetailsResult").html("<br/><center> <img src='<%=contextPath%>/includes/images/qde-loadder.gif' alt='Loading...'/></center>");
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
			$("#realTimeFileMatchDetailsResult").html("<br/><center> <img src='<%=contextPath%>/includes/images/qde-loadder.gif' alt='Loading...'/></center>");
			
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
			$("#compassMediumGenericModal-title").html("Real Time File Scanning");
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
        //window.open('<%=contextPath%>/common/RTlistDetails?listname='+listname+'&listid='+listid,'','width=550,height=635,left=0,top=0,screenX=250,screenY=300,OuterWidth=370,OuterHeight=150,toolbar=yes,location=no,resizable=yes, scrollbars=yes,menubar=yes');
		if(listname.substr(0, 11) == 'DOWJONELIST'){
			var url = "${pageContext.request.contextPath}/common/viewDowjonesRecord?recordId="+listid;
			window.open(url,'Dow Jones List Details','height=600px,width=1000px');
		}
		else {
			window.open('<%=contextPath%>/common/RTlistDetails?listname='+listname+'&listid='+listid,'','width=550,height=635,left=0,top=0,screenX=250,screenY=300,OuterWidth=370,OuterHeight=150,toolbar=yes,location=no,resizable=yes, scrollbars=yes,menubar=yes');
		} 
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
		window.open('<%=contextPath%>/common/AddRTComments?RecordStatus=<%=recordStatus%>&ScanningFromDate=<%=scanningFromDate%>&ScanningToDate=<%=scanningToDate%>&ProcessingFromDate=<%=processingFromDate%>&ProcessingToDate=<%=processingToDate%>&selected='+checkboxes+'&action='+action+'&counter='+counter+'&FileName='+fileName+'&FileImport='+FileImport,'','width=420,height=200,left=300,top=350,screenX=250,screenY=300,OuterWidth=370,OuterHeight=150,resizable=yes,scrollbars=yes');
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
	/*
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
	*/
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
		
		$("#realTimeFileMatchDetailsResult").html("<br/><center> <img src='<%=contextPath%>/includes/images/qde-loadder.gif' alt='Loading...'/></center>");
		
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
		 			$("#compassCaseWorkFlowGenericModal-body").html(resData);
	 			}
	 		}
	 	});
		
	//	document.viewmatches.action='<%=contextPath%>/fileMatches?counter='+counter+'&filename='+filename+'&FileImport='+FileImport+'&UserCode=<%=userCode%>&RecordStatus=<%=recordStatus%>&ScanningFromDate=<%=scanningFromDate%>&ScanningToDate=<%=scanningToDate%>&ProcessingFromDate=<%=processingFromDate%>&ProcessingToDate=<%=processingToDate%>';
	//	document.viewmatches.submit();
	}
	
	function getNextRecords() {
		setHiddenTextValue();
		var counter = <%=counter%>;
		counter = counter+20;
		var filename=document.viewmatches.filename.value;
		var FileImport=document.viewmatches.FileImport.value;
		
		$("#realTimeFileMatchDetailsResult").html("<br/><center> <img src='<%=contextPath%>/includes/images/qde-loadder.gif' alt='Loading...'/></center>");
		
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
		
		$("#realTimeFileMatchDetailsResult").html("<br/><center> <img src='<%=contextPath%>/includes/images/qde-loadder.gif' alt='Loading...'/></center>");
		
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
-->
</script>
</head>
<body>
<div class="row">
	<div class="col-sm-12">
		<c:choose>
			<c:when test="${FileImport ne 'Y'}">
				<div class="card card-primary">
					<div class="card-header panelSlidingRealTimeScanningResult${UNQID} panelCollapsable${UNQID} clearfix">
						<h6 class="card-title pull-left">Real Time Scanning Search</h6>
						<div class="btn-group pull-right clearfix">
							<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
						</div>
					</div>
					<div class="panelSearchForm">
						<table style="width: 100%; border="0">
							<tr>
								<td width="50%">
									<table class="table table-bordered table-striped" style="margin-bottom: 0px;">
										<% 
									      for(int i=0;i< arrayParamsPart1Name.length;i++){
									    	  if(arrayParamsPart1Name[i] != null && arrayParamsPart1Value[i] != null ) {
									    %>
										<tr>
										  <td width="50%"><%=arrayParamsPart1Name[i].toString().equals("NAME1")?"NAME/NIC 1":arrayParamsPart1Name[i].toString().equals("NAME2")?"NAME/NIC 2":arrayParamsPart1Name[i].toString().equals("NAME3")?"NAME/NIC 3":arrayParamsPart1Name[i].toString().equals("NAME4")?"NAME/NIC 4":arrayParamsPart1Name[i].toString().equals("NAME5")?"NAME/NIC 5":arrayParamsPart1Name[i].toString().equals("PANNO")?"NIC No":arrayParamsPart1Name[i].toString()%></td>
										  <td width="50%"><%=arrayParamsPart1Value[i].toString()%></td>
										</tr>
										<%	   }
									      } %>
									</table>
								</td>
								<td width="50%">
									<table class="table table-bordered table-striped" style="margin-bottom: 0px">		
										<% 
									      for(int i=0;i< arrayParamsPart2Name.length;i++){ 
											if(arrayParamsPart2Name[i] != null && arrayParamsPart2Value[i] != null)  {
									      %>
										<tr>
										  <td width="50%"><%=arrayParamsPart2Name[i].toString().equals("NAME1")?"NAME/NIC 1":arrayParamsPart2Name[i].toString().equals("NAME2")?"NAME/NIC 2":arrayParamsPart2Name[i].toString().equals("NAME3")?"NAME/NIC 3":arrayParamsPart2Name[i].toString().equals("NAME4")?"NAME/NIC 4":arrayParamsPart2Name[i].toString().equals("NAME5")?"NAME/NIC 5":arrayParamsPart2Name[i].toString().equals("PANNO")?"NIC No":arrayParamsPart2Name[i].toString()%></td>
										  <td width="50%"><%=arrayParamsPart2Value[i].toString()%></td>
										</tr>
									    <% }} %>
									</table>
								</td>
							</tr>
							<!-- 
							<tr>
								<td colspan="2">
									<button style="float:right; margin: 3px 10px 3px 0;" type="button" class="btn btn-primary btn-sm" id="openRTInNewWindow">Open In New Window</button>
								</td>
							</tr>
							 -->
						</table>
					</div>
				</div>
			</c:when>
			<c:otherwise>
				<div class="card card-primary" id="realTimeFileMatch${UNQID}">
					<div class="card-header panelSlidingRealTimeFileMatch${UNQID} clearfix">
						<h6 class="card-title pull-${dirL}">File Match</h6>
					</div>
					<div class="panelSearchForm">
						<table class="table table-bordered table-striped realTimeFileSearchTable${UNQID}" style="margin-bottom: 0px;">
							<tr>
								<td width="15%">File Name</td>
								<td width="30%">
									<div class="input-group" style="z-index: 1">
										<input type="text" class="form-control input-sm" aria-describedby="basic-addon-filename" 
										id="rt_fileName_${UNQID}" name="fileName${UNQID}" value="${filename}"/>
										<span class="input-group-addon formSearchIcon" id="basic-addon-filename${UNQID}" 
											onclick="compassTopFrame.moduleSearch('rt_fileName_${UNQID}','FILENAME','VW_RTSCANNINGUPLOADEDFILE','N','${pageContext.request.contextPath}')" style="cursor: pointer;" title="Search">
											<i class="fa fa-search"></i>
										</span>
									</div>
								</td>
								<td width="10%">
									&nbsp;
								</td>
								<td width="15%">Report Status</td>
								<td width="30%">
									<select class="form-control input-sm" id="reportStatus${UNQID}" name="reportStatus${UNQID}">
										<option value="ALL" <c:if test="${RecordStatus eq 'ALL'}">selected='selected'</c:if>>ALL</option>
										<option value="Processed" <c:if test="${RecordStatus eq 'Processed'}">selected='selected'</c:if>>Processed</option>
										<option value="True" <c:if test="${RecordStatus eq 'True'}">selected='selected'</c:if>>True Match</option>
										<option value="False" <c:if test="${RecordStatus eq 'False'}">selected='selected'</c:if>>False Match</option>
										<option value="Unprocessed" <c:if test="${RecordStatus eq 'Unprocessed'}">selected='selected'</c:if>>Unprocessed</option>
									</select>
								</td>
							</tr>
							<tr>
								<td>Processing From Date</td>
								<td>
									<input type="text" class="form-control input-sm datepicker" id="processingFromDate${UNQID}" name="processingFromDate${UNQID}" value="${ProcessingFromDate}"/>
								</td>
								<td>&nbsp;</td>
								<td>Processing To Date</td>
								<td>
									<input type="text" class="form-control input-sm datepicker" id="processingToDate${UNQID}" name="processingToDate${UNQID}" value="${ProcessingToDate}"/>
								</td>
							</tr>
						</table>
					</div>
					<div class="card-footer clearfix">
						<div class="pull-${dirR}">
							<button type="submit" id="searchRealTimeFile${UNQID}" class="btn btn-success btn-sm"><spring:message code="app.common.searchButton"/></button>
							<!-- 
							<button type="button" class="btn btn-primary btn-sm" id="openRTInNewWindow">Open In New Window</button>
							 -->
						</div>
					</div>
				</div>
			</c:otherwise>
		</c:choose>
		<div id="realTimeFileMatchDetailsResult">
		<%
		if(resultedRecords != null && resultedRecords.size() > 0) {
		%>
		<div class="card card-primary">
			<div class="card-header panelCollapsable${UNQID} clearfix">
				<h6 class="card-title pull-left">Real Time Scanning Result</h6>
				<div class="btn-group pull-right clearfix">
					<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
				</div>
			</div>
			<FORM METHOD='POST' name='viewmatches' action="javascript:void(0)">
				<table align='center' border="0" width="100%">
					<tr>
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
						<td width="20%">
							<table>
								<tr>
									<%if(counter >= 20) {%>
									<td>
										<!-- <img src="<%=contextPath%>/includes/images/prev.gif" border="0" alt="Prev" onClick="getPrevRecords()"> --> 
										<img src="<%=contextPath%>/includes/images/prev.gif" border="0" alt="Prev" id = "getPreviousPage"> 
									</td>
									<td>&nbsp;&nbsp;</td>
									<% } if(counter+20 < totalRecords) { %>
									<td>
										<!-- <img src="<%=contextPath%>/includes/images/next.gif" border="0" alt="Next" onClick="getNextRecords()">-->
										<img src="<%=contextPath%>/includes/images/next.gif" border="0" alt="Next" id="getNextPage">
									</td>
									<td>&nbsp;&nbsp;</td>
									<td> 
										<input type="text" name="EnterValue" id="rt_EnterValue" size="2" maxsize ="2">
										<!-- <INPUT TYPE='button' NAME='callnextvalue' VALUE='GO' class="but" onClick="javascript:getAndSetNextValue()">-->
										<INPUT TYPE='button' NAME='callnextvalue' VALUE='GO' class="but" id="getOnSpecificPage">
									</td>
									<% } %>
								</tr>
							</table>
		    			</td>
						<td nowrap="nowrap" width="30%">
							<table>
								<tr>
									<td width="40%">
										<font face="verdana" size=2 align='right'><b>PageNo:</b>
										<%=(int)Math.ceil((double)(counter+1)/20)%>/<%=(int)Math.ceil((double)(totalRecords)/20)%></font>
									</td>
									<!-- 
									<td width="30%">
										<font face="verdana" size="2" style="color:red">True Match</font>
									</td>
									<td width="30%">
										<font face="verdana" size="2" style="color:green">False Match</font>
									</td>
									 -->
									<td bgcolor="RED">&nbsp;&nbsp;</td><td><b><font face="verdana" size="2">True Match</font></b></td>
									<td bgcolor="YELLOW">&nbsp;&nbsp;</td><td><b><font face="verdana" size="2">False Match</font></b></td>
			
								</tr>
							</table>
		    			</td>
					</TR>
				</TABLE>
				<%		
				String strCustomerName = "";
				String strNextCustName = "";
				for(int l_intSize = 0; l_intSize < resultedRecords.size();l_intSize++)
		        {
	            rtMatchResultVO = (RTMatchResultVO) resultedRecords.get(l_intSize);	
				String strSourceInfoField = rtMatchResultVO.getSourceInfo();
				//String strSourceInfo = rtMatchResultVO.getSourceInfo();
				String strCombinedAcctCust = rtMatchResultVO.getComments();
				String strAccountCustomerId = strCombinedAcctCust.substring(0,strCombinedAcctCust.indexOf("^"));
				String strMatchedDate = rtMatchResultVO.getSerialNo1();
				isDataSaved = strMatchedDate.substring(strMatchedDate.length()-1,strMatchedDate.length());
				%>
						
				<%
				isAddedToAcceptList = strSourceInfoField.substring(strSourceInfoField.indexOf("^")+1,strSourceInfoField.length());
				//System.out.println("rtMatchResultVO.getCustomerName(): "+rtMatchResultVO.getCustomerName()+"   strCustomerName:   "+strCustomerName);
				if(!((rtMatchResultVO.getCustomerName().trim()+strSourceInfoField)).equals(strCustomerName+"")) {
            	%>
					<table width="100%" border="0">
						<tr>
							<td align="left"><font face="verdana" size="2"><B>SourceInfo : 
							<% 
							if(FileImport.equals("Y") || FileImport.equals("N")) { 
							%>
		   						<a href="javascript:openSelectedListDetails('NonCustomer','<%=rtMatchResultVO.getCustomerName()%>',' ')" title="View non customer details"><%=strSourceInfoField.substring(strSourceInfoField.indexOf("~")+1,strSourceInfoField.indexOf("$"))%></a></font>
		   						<img src="<%=contextPath%>/includes/images/Log_16X16.gif" onClick="openPrintFormatPage('<%=rtMatchResultVO.getCustomerName()%>')" title="View matches" style="cursor: hand">
			   					<%
								if(isAddedToAcceptList.equals("N")){
	            				%>  
	            				
			    					<!-- <img src="<%=contextPath%>/includes/images/addToList.gif" onClick="addEntityToAcceptList('<%=rtMatchResultVO.getCustomerName()%>','<%=strAccountCustomerId%>','ToAdd')" title="Add to Acceptlist" style="cursor: hand">-->
			    					<img src="<%=contextPath%>/includes/images/addToList.gif" onClick="addEntityToAcceptList('<%=rtMatchResultVO.getCustomerName()%>','<%=strAccountCustomerId%>','ToAdd')" title="Add to Acceptlist" style="cursor: hand">
								<% } else { %>
									<img src="<%=contextPath%>/includes/images/addToList.gif" onClick="addEntityToAcceptList('<%=rtMatchResultVO.getCustomerName()%>','<%=strAccountCustomerId%>','ToAdd')" title="Add to Acceptlist" style="cursor: hand">
								<% } 
							} else { 
							%>
								<a href="javascript:openSelectedListDetails('NonCustomer','<%=rtMatchResultVO.getCustomerName()%>',' ')" title="View non customer details"><%=strSourceInfoField.substring(strSourceInfoField.indexOf("~")+1,strSourceInfoField.length())%></a></font>
		    					<img src="<%=contextPath%>/includes/images/Log_16X16.gif" onClick="openPrintFormatPage('<%=rtMatchResultVO.getCustomerName()%>')" title="View matches" style="cursor: hand">
            				<% } %>
							</B></td>
  						</tr>
					</table> 
			<table class="table table-bordered table-striped ">
				<tr>
					<th class="info">.</th>
					<th class="info">ListName</th>
					<th class="info">ListId</th>
					<th class="info">MatchScore</th>
					<th class="info">MatchedValue</th>
					<th class="info">MatchDate</th>
				<tr>
			<%
            }
			strCustomerName = rtMatchResultVO.getCustomerName().trim()+strSourceInfoField;
			%>
			<%
			String strTempColumn = null; 
			
			String strActionFlag = rtMatchResultVO.getStatus();
			if(strActionFlag.equals("A")){
				strTempColumn = "bgcolor='RED'";
			} else if (strActionFlag.equals("R")){
				strTempColumn = "bgcolor='YELLOW'";
			} else {
				strTempColumn = "";
			}
			String strMatchScore = rtMatchResultVO.getRank();
			String strNewMatchScore = strMatchScore.substring(0,strMatchScore.length()-1);
			String strDoMarkAsBold  = strMatchScore.substring(strMatchScore.length()-1,strMatchScore.length());
			String strChangedBlackListName = rtMatchResultVO.getListName();
			String strBlackListName = strChangedBlackListName.substring(0,strChangedBlackListName.length()-2);
			String strIsIndividualAcceptList = strChangedBlackListName.substring(strChangedBlackListName.length()-1,strChangedBlackListName.length());
			String strAcctCustEvidenceFlag = rtMatchResultVO.getComments().trim();
			String strAccountCustomerDetails  = strAcctCustEvidenceFlag.substring(0,strAcctCustEvidenceFlag.indexOf("^")-1); 
			String strIsFileAttached = strAcctCustEvidenceFlag.substring(strAcctCustEvidenceFlag.indexOf("^")+1,strAcctCustEvidenceFlag.length());
			
			%>	
				<% if(!strActionFlag.equals("N")) { %>
				<tr style="cursor: hand;" onClick=openPreviousComments('<%=rtMatchResultVO.getComments().trim()%>')>
				<% } else { %><tr><% }  %>
				<%
				if(isAdminUser.equals("Y")){
	            %>
				<td <%=strTempColumn%> width='5%' align='center'>
					<input type='checkbox' <% if(!strActionFlag.equals("N")){ %>  <% } %> name='check1' value='<%=(rtMatchResultVO.getUniqueNumber()==null?"NA":rtMatchResultVO.getUniqueNumber().trim())+"^"+strIsIndividualAcceptList%>'></td>
				<% } else { %>
					<td <%=strTempColumn%> width='5%' align='center'><input type='checkbox' <% if(!strActionFlag.equals("N")){ %>  <% } %> name='check1' value='<%=(rtMatchResultVO.getUniqueNumber()==null?"NA":rtMatchResultVO.getUniqueNumber().trim())+"^"+strIsIndividualAcceptList%>'></td>
				<% } %>
			
				<% if(strIsIndividualAcceptList.equals("Y")) { %>  
					<td <%=strTempColumn%> width='15%' align='center'><img src="<%=contextPath%>/includes/images/RemoveUser24X24.gif" onClick="addEntityToAcceptList('<%=rtMatchResultVO.getCustomerName()%>','<%=rtMatchResultVO.getStatus()%>','ToRemove')" title="Remove From Acceptlist" style="cursor: hand"><font size="2"><%=strBlackListName%></font>
				<% } else { %>
					<td <%=strTempColumn%> width='15%' align='center' data-toggle="tooltip" data-placement="auto"  title="<%=strBlackListName%>" data-container="body">
						<font size="2"><%=strBlackListName%></font>
						<% } if(strIsFileAttached.equals("Y")) { %> 
							<img src="<%=contextPath%>/includes/images/email.gif" title="Document Attached" style="cursor: hand">
						<% } %>
					</td>

				<td <%=strTempColumn%> width='5%' align='center' >
					<font size="2">
						<a href= "javascript:openSelectedListDetails('<%=rtMatchResultVO.getListName()+'~'+strNewMatchScore%>','<%=rtMatchResultVO.getListId()%>','<%=rtMatchResultVO.getUniqueNumber() == null ? "NA":rtMatchResultVO.getUniqueNumber().trim()%>')">
							<%=rtMatchResultVO.getListId()%>
						</a>
					</font>
				</td>
				<td <%=strTempColumn%> width='5%' align='center' data-toggle="tooltip" data-placement="auto"  title="<%=strNewMatchScore%>" data-container="body">
					<font size="2"><%=strNewMatchScore%></font>
				</td>
				
				<% if(strDoMarkAsBold.equals("N")) {  %>
					<td <%=strTempColumn%> width='25%' align='center'  data-toggle="tooltip" data-placement="auto"  title="<%=rtMatchResultVO.getMatchedInfo()%>" data-container="body">
					<font size="2"><%=rtMatchResultVO.getMatchedInfo()%></font></td>
				<% } else {  %>
					<td <%=strTempColumn%> width='25%' align='center'  data-toggle="tooltip" data-placement="auto"  title="<%=rtMatchResultVO.getMatchedInfo()%>" data-container="body">
					<font size="2" color="FF0000"><B><%=rtMatchResultVO.getMatchedInfo()%></font></td>
				<% } %> 
				<td <%=strTempColumn%> width='25%' align='center' data-toggle="tooltip" data-placement="auto"  title="<%=rtMatchResultVO.getMatchDate()%>" data-container="body">
				<font size="2"><%=rtMatchResultVO.getMatchDate()%></font></td>
			</tr>
		
		<%
       if(l_intSize < resultedRecords.size()-1)
			strNextCustName = ((RTMatchResultVO) resultedRecords.get(l_intSize+1)).getCustomerName().trim();
       if((!(rtMatchResultVO.getCustomerName().trim()).equals(strNextCustName+"")) || l_intSize == resultedRecords.size()-1) {
		%>
				</table>		
		<% } 
       } %>
		<!-- <BR>
		<BR> -->
		<table border=0 width="100%">
		<TR>
		<TD align="center" colspan="7">
        <!-- <INPUT TYPE='button' NAME='Approve' VALUE='TRUE MATCH' class="but1" onClick="javascript:addNewComments('Approve')"> 
        <INPUT TYPE='button' NAME='Reject' VALUE='FALSE MATCH'  class="but1" onClick="javascript:addNewComments('Reject')">
        <INPUT TYPE='button' NAME= 'AttachEvidence' value ='VIEW/ATTACH EVIDENCE' OnClick="attachFileEvidence();" class="but1" >
        -->
        <button type="button" class="btn btn-danger btn-sm markMatchAction" action="Approve" >TRUE MATCH</button>
        <button type="button" class="btn btn-success btn-sm markMatchAction" action="Reject" >FALSE MATCH</button>
        <button type="button" class="btn btn-primary btn-sm" id="attachMatchEvedence">Attach Evidence</button>
        <button type="button" class="btn btn-primary btn-sm" id="refreshPage">Refresh</button>
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
                     <!-- <INPUT TYPE='button' NAME='Export' VALUE='EXPORT TO FILE'  class="but1" onClick="javascript:addNewComments('Export')"> -->
                  </td>
                  <% } %>
                  </tr>
		</table>
<%
	}
%>


	<input type='hidden' name='filename' id="rt_filename" value = '<%=FileName%>'>
	<input type='hidden' name='FileImport' id="rt_FileImport" value = '<%=FileImport%>'>
	<input type='hidden' name='counter' id="rt_counter" value='<%=counter%>'>
</table></table></FORM></div>
</div>
</div>
</div></body></HTML>
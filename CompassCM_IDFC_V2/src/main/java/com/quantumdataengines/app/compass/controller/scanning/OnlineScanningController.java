package com.quantumdataengines.app.compass.controller.scanning;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.fileupload.DiskFileUpload;
import org.apache.commons.fileupload.FileItem;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.view.RedirectView;

import com.quantumdataengines.app.compass.model.scanning.MatchResultVO;
import com.quantumdataengines.app.compass.otherservice.OtherCommonService;
import com.quantumdataengines.app.compass.schema.Configuration;
import com.quantumdataengines.app.compass.service.CommonService;
import com.quantumdataengines.app.compass.service.cdd.CDDFormService;
import com.quantumdataengines.app.compass.service.scanning.OnlineScanningService;
import com.quantumdataengines.app.compass.service.scanning.TemplateScreeningService;

@Controller
@RequestMapping(value="/common")
public class OnlineScanningController {
	private static final Logger log = LoggerFactory.getLogger(OnlineScanningController.class);
	
	@Autowired
	private OnlineScanningService OnlineScanningService;
	@Autowired
	private OtherCommonService otherCommonService;
	@Autowired
	private CommonService commonService;
	@Autowired
	private CDDFormService cddFormService;
	@Autowired
	private TemplateScreeningService templateScreeningService;
	
	@RequestMapping(value = "/realtimeScanning", method=RequestMethod.GET)
	public String realtimeScanning(HttpServletRequest request, HttpServletResponse response, Authentication authentication){
		request.setAttribute("UNQ", otherCommonService.getElementId());
		request.setAttribute("isActionAllowed", request.getParameter("isActionAllowed") == null ? "Y":request.getParameter("isActionAllowed"));
		commonService.auditLog(authentication.getPrincipal().toString(), request, "SCANNING", "OPEN", "Module Accessed");
		return "RealTimeScanning/index";
	}
	
	@RequestMapping(value = "/showViewMatchForm", method=RequestMethod.POST)
	public String showViewMatchForm(HttpServletRequest request, HttpServletResponse response, Authentication authentication){
		String strUsercode = authentication.getPrincipal().toString();
		Vector vecListOfFile = OnlineScanningService.getFileNames("file|"+strUsercode);
		request.setAttribute("FileName",vecListOfFile);
		request.setAttribute("UNQ", otherCommonService.getElementId());
		request.setAttribute("isActionAllowed", request.getParameter("isActionAllowed") == null ? "Y":request.getParameter("isActionAllowed"));
		commonService.auditLog(authentication.getPrincipal().toString(), request, "SCANNING", "OPEN", "Module Accessed");
		return "RealTimeScanning/showViewMatchForm";
	}

	@RequestMapping(value = "/dataEntryFormScanning", method=RequestMethod.POST)
	public String dataEntryFormScanning(HttpServletRequest request, HttpServletResponse response, Authentication authentication){
		String userCode = authentication.getPrincipal().toString();
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String ipAddress = request.getRemoteAddr();
		
		String l_strBlackListCheck = request.getParameter("BlackListCheck");
		String l_strSelectedBlackListCheck = request.getParameter("SelectedBlackListCheck");
		String l_strCustomerDataBaseCheck  = request.getParameter("CustomerDataBaseCheck");
		String l_strRejectedListCheck = request.getParameter("RejectedListCheck");
		String l_strEmployeeDataBaseCheck = request.getParameter("EmployeeDataBaseCheck");
		String cddFormType = request.getParameter("CDDFORMTYPE"); 
		String compassReferenceNo = request.getParameter("COMPASSREFERENCENO"); 
		String cddNameType = request.getParameter("CDDNAMETYPE"); 
		String cddNameLineNo = request.getParameter("CDDNAMELINENO"); 
		String templateSeqNo = request.getParameter("TEMPLATESEQNO"); 
		
		// System.out.println("cddFormType :  "+cddFormType+", compassReferenceNo :  "+compassReferenceNo+", cddNameType :  "+cddNameType+", cddNameLineNo:  "+cddNameLineNo);
		int intCount = 0;
		String AddSerialNo = "yes";

		StringBuffer sbInputFieldNames = new StringBuffer();
		StringBuffer sbInputFieldValues = new StringBuffer();
        StringBuffer sbNameValuePairs = new StringBuffer();
		
        HashMap hashMapSearchResult = new HashMap();
		ArrayList alInputParametersName = new ArrayList(); 
		ArrayList alInputParametersValue = new ArrayList();
				 	
		Enumeration enumTempList = request.getParameterNames();
		while(enumTempList.hasMoreElements()) {
			String strInputFieldName = (String)enumTempList.nextElement();
			
			if(strInputFieldName.trim().equalsIgnoreCase("screen")||strInputFieldName.trim().equalsIgnoreCase("Type")||
			   strInputFieldName.trim().equalsIgnoreCase("params") || strInputFieldName.trim().equalsIgnoreCase("_") ||
			   strInputFieldName.trim().equalsIgnoreCase("CDDFORMTYPE") || strInputFieldName.trim().equalsIgnoreCase("COMPASSREFERENCENO") ||
			   strInputFieldName.trim().equalsIgnoreCase("CDDNAMETYPE")|| strInputFieldName.trim().equalsIgnoreCase("CDDNAMELINENO") ||
			   strInputFieldName.trim().equalsIgnoreCase("TEMPLATESEQNO"))
			continue;
				
			intCount++;
			String strInputFieldValue = request.getParameter(strInputFieldName); 
			if(templateSeqNo != null && !templateSeqNo.equalsIgnoreCase("")){
				if(strInputFieldName.equalsIgnoreCase("NAME1")){
					strInputFieldValue = templateScreeningService.getTemplateFieldValues(templateSeqNo, "NAME");
					// System.out.println("strInputFieldValue:   "+strInputFieldValue);
				}
				if(strInputFieldName.equalsIgnoreCase("NAME5")){
					strInputFieldValue = templateScreeningService.getTemplateFieldValues(templateSeqNo, "COUNTRY");
					// System.out.println("strInputFieldValue:   "+strInputFieldValue);
				}
				if(strInputFieldName.equalsIgnoreCase("PANNO")){
					strInputFieldValue = templateScreeningService.getTemplateFieldValues(templateSeqNo, "IDVALUE");
					// System.out.println("PANNO strInputFieldValue:   "+strInputFieldValue);
				}
			}
			/*strInputFieldValue = strInputFieldValue.replace('~','&');
			strInputFieldValue = strInputFieldValue.replace('#','&');
			*/

			strInputFieldValue = strInputFieldValue.replace("~"," & ");
			strInputFieldValue = strInputFieldValue.replace("#"," & ");
			
			sbInputFieldNames.append(strInputFieldName);
			sbInputFieldValues.append(strInputFieldValue==null?"":strInputFieldValue);
			
            sbNameValuePairs.append(strInputFieldName).append(",");
            sbNameValuePairs.append(strInputFieldValue==null?"":strInputFieldValue);
			
			if(enumTempList.hasMoreElements())
			{
				sbInputFieldNames.append(",");
				sbInputFieldValues.append("~!~!");
                sbNameValuePairs.append("^");
			}
			
			alInputParametersName.add(strInputFieldName);
			alInputParametersValue.add(strInputFieldValue);
			hashMapSearchResult.put(strInputFieldName,strInputFieldValue);
		}
		
		String strFieldActualValue = sbInputFieldValues.toString();
		strFieldActualValue = strFieldActualValue.replaceAll("'","''");
		
		String strFinalFieldValue = strFieldActualValue.replaceAll("~!~!","','");
		strFinalFieldValue = "'" + strFinalFieldValue + "'";
		
		String strUniqueNumber = "";
		if(AddSerialNo.equalsIgnoreCase("yes"))
		{
			//String strUniqueNumber = System.currentTimeMillis()+String.valueOf(Math.random()).substring(2,9);
			strUniqueNumber = System.currentTimeMillis()+String.valueOf(Math.random()).substring(2,9);
			sbInputFieldNames.append(",SERIALNO");
			strFinalFieldValue = strFinalFieldValue+","+strUniqueNumber;
            sbNameValuePairs.append("^SERIALNO");
            sbNameValuePairs.append(",");
            sbNameValuePairs.append(strUniqueNumber);
            hashMapSearchResult.put("SNO",strUniqueNumber);
		}
		//String usercode = request.getUserPrincipal().toString();
		String usercode = authentication.getPrincipal().toString();
		strFinalFieldValue = strFinalFieldValue+"$"+usercode;
		boolean boolStatusFlag = OnlineScanningService.insertRecord(sbInputFieldNames.toString(),strFinalFieldValue);
		hashMapSearchResult = OnlineScanningService.getSearchValues(sbNameValuePairs.toString(),usercode);
		hashMapSearchResult.put("LoggedInUser",usercode);
		hashMapSearchResult.put("SNO",strUniqueNumber);
		
		hashMapSearchResult.put("BlackListCheck",l_strBlackListCheck);
		hashMapSearchResult.put("SelectedBlackListCheck",l_strSelectedBlackListCheck);
		hashMapSearchResult.put("CustomerDataBaseCheck",l_strCustomerDataBaseCheck);
		hashMapSearchResult.put("RejectedListCheck",l_strRejectedListCheck);
		hashMapSearchResult.put("EmployeeDataBaseCheck",l_strEmployeeDataBaseCheck);
		// System.out.println("hashMapSearchResult:  "+hashMapSearchResult);
		HashMap hashMapScanData = OnlineScanningService.getScanReport(""+199, hashMapSearchResult);
		HttpSession session = request.getSession();
		hashMapSearchResult.put("LoggedInUser",usercode);
		hashMapSearchResult.put("FileImport","N");
		ArrayList<HashMap<String,String>> fieldScanSummaryDetails = OnlineScanningService.getFieldScanSummaryDetails(strUniqueNumber, (String)hashMapScanData.get("FileName"), sbNameValuePairs.toString(), userCode, userRole, ipAddress);
		
		if(session.getAttribute("SearchParametersName") != null)
			session.removeAttribute("SearchParametersName");
		if(session.getAttribute("SearchParametersValue") != null)
			session.removeAttribute("SearchParametersValue");
			 
		session.setAttribute("SearchParametersName",alInputParametersName);
		session.setAttribute("SearchParametersValue",alInputParametersValue);
		request.setAttribute("ReportData",hashMapScanData);
		request.setAttribute("FieldScanSummaryDetails",fieldScanSummaryDetails);
		request.setAttribute("StrUniqueNumber", strUniqueNumber);
		request.setAttribute("FromBulkScreening", "N");
		//System.out.println(strUniqueNumber);
		request.setAttribute("LOGGEDUSER",authentication.getPrincipal().toString());
		request.setAttribute("isActionAllowed", request.getParameter("isActionAllowed") == null ? "Y":request.getParameter("isActionAllowed"));
		commonService.auditLog(authentication.getPrincipal().toString(), request, "SCANNING", "SEARCH", "Realtime Scan");
		if(compassReferenceNo != null && !compassReferenceNo.equalsIgnoreCase("")){
			String CURRENTROLE = (String) request.getSession(false).getAttribute("CURRENTROLE");
			cddFormService.saveScreeningMapping(compassReferenceNo, strUniqueNumber, (String)hashMapScanData.get("FileName"), 
					cddFormType, cddNameType, cddNameLineNo, 
					authentication.getPrincipal().toString(), (String) request.getSession(false).getAttribute("CURRENTROLE"), request.getLocalAddr());
		}
		if(templateSeqNo != null && !templateSeqNo.equalsIgnoreCase("")){
			templateScreeningService.saveScreeningMapping(templateSeqNo, strUniqueNumber, (String)hashMapScanData.get("FileName"), 
					authentication.getPrincipal().toString(), (String) request.getSession(false).getAttribute("CURRENTROLE"), request.getLocalAddr());
		}
		return "RealTimeScanning/matchResult";
	}
	
	@RequestMapping(value = "/fileMatches", method=RequestMethod.POST)
	public String fileMatches(HttpServletRequest request, HttpServletResponse response,	Authentication authentication) {
		String userCode = authentication.getPrincipal().toString();
		String filename = request.getParameter("filename");
		String fileimport = request.getParameter("FileImport");
		String strCounter = request.getParameter("counter");
		String isActionAllowed = request.getParameter("isActionAllowed") == null ? "Y":request.getParameter("isActionAllowed");
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String ipAddress = request.getRemoteAddr();
		String templateSeqNo = request.getParameter("templateSeqNo");
		
		MatchResultVO objMatchResultVO = new MatchResultVO();
		objMatchResultVO.setLoggedUser(userCode);
		objMatchResultVO.setUserCode(request.getParameter("UserCode"));
		objMatchResultVO.setRecordStatus(request.getParameter("RecordStatus"));
		objMatchResultVO.setScanningFromDate(request.getParameter("ScanningFromDate"));
		objMatchResultVO.setScanningToDate(request.getParameter("ScanningToDate"));
		objMatchResultVO.setProcessingFromDate(request.getParameter("ProcessingFromDate"));
		objMatchResultVO.setProcessingToDate(request.getParameter("ProcessingToDate"));
		objMatchResultVO.setFileName(filename);
		objMatchResultVO.setFileImport(fileimport);
		objMatchResultVO.setCounter(strCounter);
		
		String strUniqueNumber = OnlineScanningService.getUniqueNumber(filename, templateSeqNo);
		
		Map mapFileMatchesData = OnlineScanningService.getFileMatches(objMatchResultVO);
		request.setAttribute("ReportData",(LinkedHashMap)mapFileMatchesData);
		request.setAttribute("counter",strCounter);
		request.setAttribute("FileImport", fileimport);
		request.setAttribute("LOGGEDUSER",authentication.getPrincipal().toString());
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("filename", filename);
		request.setAttribute("RecordStatus", request.getParameter("RecordStatus"));
		request.setAttribute("ProcessingFromDate", request.getParameter("ProcessingFromDate"));
		request.setAttribute("ProcessingToDate", request.getParameter("ProcessingToDate"));
		request.setAttribute("isActionAllowed", request.getParameter("isActionAllowed"));
		request.setAttribute("FieldScanSummaryDetails", OnlineScanningService.getFieldScanSummaryDetails(strUniqueNumber, null, null, userCode, userRole, ipAddress));
		request.setAttribute("FromBulkScreening", "N");
		request.setAttribute("StrUniqueNumber", strUniqueNumber);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "SCANNING", "READ", "Module Accessed");
		return "RealTimeScanning/matchResult";
	}
	
	@RequestMapping(value = "/RTlistDetails")
	public ModelAndView listDetails(
			HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication)
	{
		String userCode = authentication.getPrincipal().toString();
		ModelAndView modelAndView = new ModelAndView("RealTimeScanning/listDetails");
		String strListName = request.getParameter("listname");
		String strListId = request.getParameter("listid");
		String strViewSelectedType = request.getParameter("ViewType") == null ? "viewhtml" :(String)request.getParameter("ViewType");
        ArrayList alListDetails = OnlineScanningService.getListDetails(strListName,strListId,strViewSelectedType);
        request.setAttribute("BlackListDetails",alListDetails);
	    request.setAttribute("listname",strListName);
        request.setAttribute("listid",strListId);
        request.setAttribute("LOGGEDUSER",authentication.getPrincipal().toString());
        commonService.auditLog(authentication.getPrincipal().toString(), request, "SCANNING", "OPEN", "Module Accessed");
		return modelAndView;
	}	
	
	@RequestMapping(value="/AddRTComments", method=RequestMethod.GET)
	public String AddRTComments(HttpServletRequest request, HttpServletResponse response, Authentication authentication){
		String l_mode = request.getParameter("mode");
		String l_selected = request.getParameter("selected");
		String l_action = request.getParameter("action");
		String l_counter = request.getParameter("counter"); 
		String l_fileName = request.getParameter("FileName"); 
		String l_comment = request.getParameter("comment");
		String l_fileimport = request.getParameter("FileImport");
		 
		String l_ScanningFromDate = request.getParameter("ScanningFromDate");
		String l_ScanningToDate = request.getParameter("ScanningToDate");
		String l_ProcessingFromDate = request.getParameter("ProcessingFromDate");
		String l_ProcessingToDate = request.getParameter("ProcessingToDate");
		String l_UserCode = authentication.getPrincipal().toString();
		String l_RecordStatus = request.getParameter("RecordStatus");
		
		request.setAttribute("mode", l_mode);
		request.setAttribute("selected", l_selected);
		request.setAttribute("action", l_action);
		request.setAttribute("counter", l_counter);
		request.setAttribute("FileName", l_fileName);
		request.setAttribute("comment", l_comment);
		request.setAttribute("FileImport", l_fileimport);
		request.setAttribute("ScanningFromDate", l_ScanningFromDate);
		request.setAttribute("ScanningToDate", l_ScanningToDate);
		request.setAttribute("ProcessingFromDate", l_ProcessingFromDate);
		request.setAttribute("ProcessingToDate", l_ProcessingToDate);
		request.setAttribute("UserCode", l_UserCode);
		request.setAttribute("RecordStatus", l_RecordStatus);
		request.setAttribute("LOGGEDUSER",authentication.getPrincipal().toString());
		commonService.auditLog(authentication.getPrincipal().toString(), request, "SCANNING", "INSERT", "Data Saved");
		return "RealTimeScanning/AddComments";
	}
	
	@RequestMapping(value="/viewRTComments", method=RequestMethod.GET)
	public String viewRTComments(HttpServletRequest request, HttpServletResponse response, Authentication authentication){
		String l_action = request.getParameter("action");
		String uniqueNumber = request.getParameter("uniqueNumber"); 
		
		String l_comment = OnlineScanningService.getComments(uniqueNumber);
		
		request.setAttribute("action", l_action);
		request.setAttribute("comment", l_comment);
		request.setAttribute("uniqueNumber", uniqueNumber);
		request.setAttribute("LOGGEDUSER",authentication.getPrincipal().toString());
		commonService.auditLog(authentication.getPrincipal().toString(), request, "SCANNING", "INSERT", "Data Saved");
		return "RealTimeScanning/AddComments";
	}
	
	@RequestMapping(value = "/printPage")
	public ModelAndView printPage(
			HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication)
	{
		ModelAndView modelAndView = new ModelAndView("RealTimeScanning/printPage");
		String strUniqueId = request.getParameter("key");
		String strUsercode = authentication.getPrincipal().toString();
		String strUniqueNumber = request.getParameter("uniqueNumber");
		String userCode = authentication.getPrincipal().toString();
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String ipAddress = request.getRemoteAddr();
		
		MatchResultVO objMatchResultVO = new MatchResultVO();
		objMatchResultVO.setLoggedUser(strUsercode);
		objMatchResultVO.setUserCode(request.getParameter("UserCode"));
		objMatchResultVO.setRecordStatus(request.getParameter("RecordStatus"));
		objMatchResultVO.setScanningFromDate(request.getParameter("ScanningFromDate"));
		objMatchResultVO.setScanningToDate(request.getParameter("ScanningToDate"));
		objMatchResultVO.setProcessingFromDate(request.getParameter("ProcessingFromDate"));
		objMatchResultVO.setProcessingToDate(request.getParameter("ProcessingToDate"));
		objMatchResultVO.setFileName(request.getParameter("filename"));
		objMatchResultVO.setFileImport("PrintPage");
		objMatchResultVO.setCounter("0");
		objMatchResultVO.setUniqueId(strUniqueId);
		Map mapFileResultMatches = OnlineScanningService.getFileMatches(objMatchResultVO);
		request.setAttribute("PrintRecords",(LinkedHashMap)mapFileResultMatches);
		request.setAttribute("LOGGEDUSER",authentication.getPrincipal().toString());
		request.setAttribute("FromBulkScreening", request.getParameter("FromBulkScreening"));
		request.setAttribute("FieldScanSummaryDetails", OnlineScanningService.getFieldScanSummaryDetails(strUniqueNumber, null, null, userCode, userRole, ipAddress));
		commonService.auditLog(authentication.getPrincipal().toString(), request, "SCANNING", "OPEN", "Module Accessed");
		return modelAndView;
	}	
	
	@RequestMapping(value = "/updateRecord")
	public String updateRecord(HttpServletRequest request, HttpServletResponse response, Authentication authentication) {
		MatchResultVO objMatchResultVO = new MatchResultVO();
		String action = request.getParameter("action");
		String selected = request.getParameter("selected");
		String l_strFileName = request.getParameter("FileName");
		String l_strComments =  request.getParameter("comments");
		String FileImport =  request.getParameter("FileImport");
		//String usercode = request.getUserPrincipal().toString();
		String userCode = authentication.getPrincipal().toString();
		String strCounter = request.getParameter("counter");
		String l_strProcessFromDate = request.getParameter("ProcessingFromDate");
		String l_strProcessToDate = request.getParameter("ProcessingToDate");
		String strUniqueNumber = request.getParameter("uniqueNumber");
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String ipAddress = request.getRemoteAddr();
		
		if(!action.equalsIgnoreCase("auditlog")) {
			objMatchResultVO.setLoggedUser(userCode);
			objMatchResultVO.setFileName(l_strFileName);
			objMatchResultVO.setFileImport(FileImport);
			objMatchResultVO.setCounter(strCounter);
			objMatchResultVO.setUserCode(request.getParameter("UserCode"));
			objMatchResultVO.setRecordStatus(request.getParameter("RecordStatus"));
			objMatchResultVO.setScanningFromDate(request.getParameter("ScanningFromDate"));
			objMatchResultVO.setScanningToDate(request.getParameter("ScanningToDate"));
			objMatchResultVO.setProcessingFromDate(l_strProcessFromDate);
			objMatchResultVO.setProcessingToDate(l_strProcessToDate);
		}
		
		OnlineScanningService.updateRecord(action,selected,userCode, l_strFileName, l_strComments);
		
		if(!action.equalsIgnoreCase("auditlog")) {
			LinkedHashMap lnkHashMapFileMatches = (LinkedHashMap)OnlineScanningService.getFileMatches(objMatchResultVO);
			request.setAttribute("ReportData",lnkHashMapFileMatches);
			request.setAttribute("counter",strCounter);
			request.setAttribute("isActionAllowed", request.getParameter("isActionAllowed") == null ? "Y":request.getParameter("isActionAllowed"));

			return "RealTimeScanning/matchResult"; 
		} else {
			HashMap<String,Object> hmAuditResults = OnlineScanningService.getAuditRecords(l_strProcessFromDate,l_strProcessToDate,l_strFileName+"|"+userCode,FileImport,strCounter);
			//Vector vecAuditResults = null;	
			request.setAttribute("Records",hmAuditResults);
			request.setAttribute("counter",strCounter);
			request.setAttribute("filename",l_strFileName);
			request.setAttribute("FileImport",FileImport);
			request.setAttribute("LOGGEDUSER",authentication.getPrincipal().toString());
			commonService.auditLog(authentication.getPrincipal().toString(), request, "SCANNING", "UPDATE", "Data Updated");
			return "RealTimeScanning/ALBottom";
		}
	}
	
	@RequestMapping(value = "/getALRecords")
	public ModelAndView getALRecords(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication)
	{
		ModelAndView modelAndView = new ModelAndView("RealTimeScanning/ALBottom");
		String usercode = request.getParameter("UserCode");
		String fromdate = request.getParameter("fromDate") == null ? "" :(String)request.getParameter("fromDate");
		String todate = request.getParameter("toDate") == null ? "" :(String)request.getParameter("toDate");
		String filename = request.getParameter("filename");
		String fileimport = request.getParameter("FileImport");
		String strCounter = request.getParameter("counter");;
		HashMap<String,Object> hmAuditResults = OnlineScanningService.getAuditRecords(fromdate,todate,filename+"|"+usercode,fileimport,strCounter);
		request.setAttribute("Records",hmAuditResults);
		request.setAttribute("counter",strCounter);
		request.setAttribute("filename",filename); 
		request.setAttribute("FileImport",fileimport); 
        request.setAttribute("UserCode",usercode);
        request.setAttribute("LOGGEDUSER",authentication.getPrincipal().toString());
        commonService.auditLog(authentication.getPrincipal().toString(), request, "SCANNING", "OPEN", "Module Accessed");
		return modelAndView;
	}
	
	@RequestMapping(value = "/onlineScanningFileImport", method=RequestMethod.POST)
	public @ResponseBody String onlineScanningFileImport(MultipartHttpServletRequest request, 
			HttpServletResponse response, Authentication authentication) {
		String strFileChangedName = null;
		String strResultMessage = null;
		//String strIpaddress = ApplicationProperties.getInstance().getProperty("DatabaseServerIP").trim();
		//String strFiledir = ApplicationProperties.getInstance().getProperty("DatabaseDirectoryPath").trim();
		//String strUseIP = ApplicationProperties.getInstance().getProperty("UseIP").trim();
		String strIpaddress = "";
		String strFiledir = "D://DailyImportFiles";
		String strUseIP = "No";
		HashMap hashMapSearchResult = new HashMap();
		int intFilesDatalength = 0;
		try {		  
			Iterator<String> itrator = request.getFileNames();
			MultipartFile multiFile = request.getFile(itrator.next());
			String strFilename = multiFile.getOriginalFilename();      
			byte[] byArrayFiledata = multiFile.getBytes();
			intFilesDatalength = byArrayFiledata.length;
			
			if(intFilesDatalength > 1048576) {
				strResultMessage = " File Size Should Not Be More Than 1 MB";
			} else {
				String strTemplateid = request.getParameter("templateid");
				String strImportId = request.getParameter("reportid");
				String strFieldDelimiter = request.getParameter("delimiter");
				String l_strBlackListCheck = request.getParameter("BlackListCheck");
				String l_strSelectedBlackListCheck = request.getParameter("SelectedBlackListCheck");
				String l_strCustomerDataBaseCheck  = request.getParameter("CustomerDataBaseCheck");
				String l_strRejectedListCheck = request.getParameter("RejectedListCheck");
				String l_strEmployeeDataBaseCheck = request.getParameter("EmployeeDataBaseCheck");
		
				hashMapSearchResult.put("BlackListCheck",l_strBlackListCheck);
				hashMapSearchResult.put("SelectedBlackListCheck",l_strSelectedBlackListCheck);
				hashMapSearchResult.put("CustomerDataBaseCheck",l_strCustomerDataBaseCheck);
				hashMapSearchResult.put("RejectedListCheck",l_strRejectedListCheck);
				hashMapSearchResult.put("EmployeeDataBaseCheck",l_strEmployeeDataBaseCheck);
				
				String strBlackImportListId = " ";
				String strWhiteImportListId = " ";
				
				if(strImportId.equalsIgnoreCase("199")) {
					strBlackImportListId = request.getParameter("blacklistid");
					strWhiteImportListId = request.getParameter("whitelistid");
				}
			
				strFileChangedName = strFilename.substring(strFilename.lastIndexOf("\\")+1,strFilename.length());
				String strFileData = new String(byArrayFiledata);
				String strUserCode = authentication.getPrincipal() == null ? "Admin":authentication.getPrincipal().toString();
				request.setAttribute("LOGGEDUSER",authentication.getPrincipal().toString());
				
				strResultMessage = OnlineScanningService.insertFile(strImportId,strFiledir,strFileData,strFileChangedName,strTemplateid,strUserCode,strFieldDelimiter,strBlackImportListId,strWhiteImportListId,hashMapSearchResult);
			}
		} catch(Exception e) {
			log.error("Exception in uploading the attached file : "+e.getMessage());
			e.printStackTrace();
		}
		commonService.auditLog(authentication.getPrincipal().toString(), request, "SCANNING", "INSERT", "Data Saved");
		return strResultMessage;
	}
	
	@RequestMapping(value = "/onlineScanningFileImportNew", method=RequestMethod.POST)
	public @ResponseBody String onlineScanningFileImportNew(MultipartHttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) {
		String strFileChangedName = null;
		String strResultMessage = null;
		/*
		ApplicationProperties appProperties = ApplicationProperties.getInstance();
		String TRANSACTIONFILESPATH = appProperties.getProperty("TransactionFilePath");
		*/
		
		Configuration config = commonService.getUserConfiguration();
		
		String TRANSACTIONFILESPATH = config.getPaths().getIndexingPath()+File.separator+"TransactionFilePath";
		String strIpaddress = "";
		String strFiledir = TRANSACTIONFILESPATH+File.separator+"RealTimeScanning"+File.separator;
		File tempDir = new File(strFiledir);
		if(!tempDir.exists())
			tempDir.mkdirs();
		
		String strUseIP = "No";
		HashMap hashMapSearchResult = new HashMap();
		int intFilesDatalength =0;

		try {
			
			Iterator<String> itrator = request.getFileNames();
			MultipartFile multiFile = request.getFile(itrator.next());
			String strFilename = multiFile.getOriginalFilename();      
			byte[] byArrayFiledata = multiFile.getBytes();
			intFilesDatalength = byArrayFiledata.length;
			
				
			strFiledir = strFiledir+strFilename;
			
			BufferedOutputStream stream = new BufferedOutputStream(new FileOutputStream(strFiledir));
	        stream.write(byArrayFiledata);
	        stream.close();
			
			
			if(intFilesDatalength > 1048576) {
				strResultMessage = " File Size Should Not Be More Than 1 MB";
			} else {
					String strTemplateid = request.getParameter("templateid");
					String strImportId = request.getParameter("reportid");
					String strFieldDelimiter = request.getParameter("delimiter");
					String l_strBlackListCheck = request.getParameter("BlackListCheck");
					String l_strSelectedBlackListCheck = request.getParameter("SelectedBlackListCheck");
					String l_strCustomerDataBaseCheck  = request.getParameter("CustomerDataBaseCheck");
					String l_strRejectedListCheck = request.getParameter("RejectedListCheck");
					String l_strEmployeeDataBaseCheck = request.getParameter("EmployeeDataBaseCheck");
			
					hashMapSearchResult.put("BlackListCheck",l_strBlackListCheck);
					hashMapSearchResult.put("SelectedBlackListCheck",l_strSelectedBlackListCheck);
					hashMapSearchResult.put("CustomerDataBaseCheck",l_strCustomerDataBaseCheck);
					hashMapSearchResult.put("RejectedListCheck",l_strRejectedListCheck);
					hashMapSearchResult.put("EmployeeDataBaseCheck",l_strEmployeeDataBaseCheck);
					
					String strBlackImportListId = " ";
					String strWhiteImportListId = " ";
					if(strImportId.equalsIgnoreCase("199")) {
						strBlackImportListId = request.getParameter("blacklistid");
						strWhiteImportListId = request.getParameter("whitelistid");
					}
					strFileChangedName = strFilename.substring(strFilename.lastIndexOf("\\")+1);
					String strFileData = new String(byArrayFiledata);
					String strUserCode = authentication.getPrincipal() == null ? "Admin":authentication.getPrincipal().toString();
			
					strResultMessage = OnlineScanningService.insertFileNew(strImportId,strFiledir,strFileData,strFileChangedName,strTemplateid,strUserCode,strFieldDelimiter,strBlackImportListId,strWhiteImportListId,hashMapSearchResult);
					request.setAttribute("LOGGEDUSER",authentication.getPrincipal().toString());
				}
		}
		catch(Exception e){
			log.error("Exception in uploading the attached file : "+e.getMessage());
			System.out.println("Exception in uploading the attached file");
			e.printStackTrace();
		}
		commonService.auditLog(authentication.getPrincipal().toString(), request, "SCANNING", "INSERT", "Data Saved");
		return strResultMessage;
	}
	
	@RequestMapping(value = "/getImportFileName")
	public ModelAndView getImportFileName(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication)
	{
		ModelAndView modelAndView = new ModelAndView("/OnlineScanning/viewMatchesFilterFrame");
		String strUsercode = authentication.getPrincipal().toString();
		Vector vecListOfFile = OnlineScanningService.getFileNames("file|"+strUsercode);
		request.setAttribute("FileName",vecListOfFile);
		String strActionValue = request.getParameter("action");
		if(strActionValue.equals("1"))
			modelAndView = new ModelAndView("/OnlineScanning/viewMatchesFilterFrame");
		else
			modelAndView = new ModelAndView("/OnlineScanning/ALTop");
		request.setAttribute("LOGGEDUSER",authentication.getPrincipal().toString());
		commonService.auditLog(authentication.getPrincipal().toString(), request, "SCANNING", "READ", "Module Accessed");
		return modelAndView;
	}
		
	@RequestMapping(value = "/onlineScanning")
	public ModelAndView getScanResult(@RequestParam(value = "type") String type, 
    		@RequestParam(value = "nameEnglish") String nameEnglish, @RequestParam(value = "idNumber") String idNumber,
    		@RequestParam(value = "nationality") String nationality, @RequestParam(value = "passportId") String passportId,
    		@RequestParam(value = "residence") String residence, @RequestParam(value = "birthPlace") String birthPlace,
    		@RequestParam(value = "params") String params, HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication)
		throws Exception
    {
    //String l_UserCode = request.getUserPrincipal().getName();
	String userCode = authentication.getPrincipal().toString();
    //l_Type = "MONTHGRAPH";
    //response.getWriter().write(OnlineScanningService.getScanningResults(userCode, type, nameEnglish, idNumber, nationality, passportId, residence, birthPlace, params));
    ArrayList<HashMap<String,String>> alScanningResults = OnlineScanningService.getScanningResults(userCode, type, nameEnglish, idNumber, nationality, passportId, residence, birthPlace, params);
	ModelAndView modelAndView = new ModelAndView("RTScanning/scanningResult");
	modelAndView.addObject("matchResult", alScanningResults);
	request.setAttribute("LOGGEDUSER",authentication.getPrincipal().toString());
	commonService.auditLog(authentication.getPrincipal().toString(), request, "SCANNING", "READ", "Module Accessed");
	return modelAndView;
    //return null;
    }
	
	@RequestMapping(value = "/onlineEntityScanning")
	public ModelAndView getEntityScanning(@RequestParam(value = "entityName") String entityName, 
    		@RequestParam(value = "listName") String listName, @RequestParam(value = "matchScore") String matchScore,
    		@RequestParam(value = "userCode") String userCode, HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication)
		throws Exception
    {
	int intCount = 0;
	StringBuffer sbInputFieldNames = new StringBuffer();
	StringBuffer sbInputFieldValues = new StringBuffer();
    StringBuffer sbNameValuePairs = new StringBuffer();
	
	HashMap hashMapSearchResult = new HashMap();
	ArrayList alInputParametersName = new ArrayList(); 
	ArrayList alInputParametersValue = new ArrayList();

	sbInputFieldNames.append("CUSTOMERNAME");
	sbInputFieldValues.append(entityName);
    sbNameValuePairs.append("CUSTOMERNAME").append(",");
    sbNameValuePairs.append(entityName);
	alInputParametersName.add("CUSTOMERNAME");
	alInputParametersValue.add(entityName);
	hashMapSearchResult.put("CUSTOMERNAME",entityName);
	String userCode1 = authentication.getPrincipal().toString();
	hashMapSearchResult.put("LoggedInUser",userCode1);
	LinkedHashMap linkedHashMapScanData = (LinkedHashMap)OnlineScanningService.getScanReport(""+6, hashMapSearchResult);
	String strFilesName = (String)linkedHashMapScanData.get("FileName");
	request.setAttribute("FileName", strFilesName);
	request.setAttribute("userCode",userCode);
	request.setAttribute("entityName",entityName);
	request.setAttribute("listName",listName);
	request.setAttribute("matchScore",matchScore);
	ArrayList<HashMap<String,String>> alEntityScanningResult = OnlineScanningService.getEntityScanning(strFilesName, entityName, listName, matchScore);
    ModelAndView modelAndView = new ModelAndView("RTScanning/scanningResult");
	modelAndView.addObject("matchResult", alEntityScanningResult);
	modelAndView.addObject("FileName", strFilesName);
	modelAndView.addObject("userCode", userCode);
	modelAndView.addObject("entityName", entityName);
	modelAndView.addObject("listName", listName);
	modelAndView.addObject("matchScore", matchScore);
	request.setAttribute("LOGGEDUSER",authentication.getPrincipal().toString());
	commonService.auditLog(authentication.getPrincipal().toString(), request, "SCANNING", "READ", "Module Accessed");
	return modelAndView;
    //return null;
    //return new ModelAndView("RTScanning/scanningResult");
    }
	
	@RequestMapping(value = "/getFileImportDetailss", method=RequestMethod.POST)
	public RedirectView getFileImportDetailss(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication){
		/*
		ApplicationProperties appProperties = ApplicationProperties.getInstance();
		String TRANSACTIONFILESPATH = appProperties.getProperty("TransactionFilePath");
		*/
		String TRANSACTIONFILESPATH = "D://TransactionFilePath";
		
		String uploadPath = TRANSACTIONFILESPATH+File.separator+"TEMPFILES";
		Map<String, Object> output;
		DiskFileUpload objDiskUpload = new DiskFileUpload();
		File uploadedFile = null;
		String entityName = "";
		String message = "";
		boolean status = false;
		try	{
			File f = new File(uploadPath);
			if(!f.exists()){
				f.mkdirs();
			}
			@SuppressWarnings("unchecked")
			List<FileItem> listFiles = objDiskUpload.parseRequest(request);		
			for (FileItem item : listFiles) {
	            if (item.isFormField()) {
	                String fieldname = item.getFieldName();
	                String fieldvalue = item.getString();
	                if(fieldname.equals("entityName")){
	                	entityName = fieldvalue;
	                }
	            }
			}
			for(FileItem item : listFiles){
				if(!item.isFormField()){
					String fileName = new File(item.getName()).getName();
		            String filePath = uploadPath + File.separator + fileName;
		            uploadedFile = new File(filePath);
		            item.write(uploadedFile);
				}
			}
			
			if(entityName != null && entityName != "" && uploadedFile != null && uploadedFile.exists() ){
				output = OnlineScanningService.getFileImportDetailss(uploadedFile, entityName);
				status = (Boolean) output.get("PROCESSSTATUS");
				message = (String) output.get("MESSAGE");
			}else{
				message = "Not the valid process";
			}
		}catch(Exception e){
		}
		try{
			if(uploadedFile != null && uploadedFile.exists())
				uploadedFile.delete();
		}catch(Exception e){}
		RedirectView rv = new RedirectView("OnlineScanning/matchResults_29102013");
		rv.addStaticAttribute("message", message);
		rv.addStaticAttribute("status", status);
		request.setAttribute("LOGGEDUSER",authentication.getPrincipal().toString());
		commonService.auditLog(authentication.getPrincipal().toString(), request, "SCANNING", "READ", "Module Accessed");
		return rv;
	}
	
	@RequestMapping(value = "/RTScanningNewWindow", method=RequestMethod.GET)
	public String RTScanningNewWindow(HttpServletRequest request, HttpServletResponse response, Authentication authentication){
		String url_attr_encoded = request.getParameter("url-attr-encoded");
		String data_attr_encoded = request.getParameter("data-attr-encoded");
		
		request.setAttribute("url_attr_encoded", url_attr_encoded);
		request.setAttribute("data_attr_encoded", data_attr_encoded);
		return "RealTimeScanning/RTScanningNewWIndow";
	}
}

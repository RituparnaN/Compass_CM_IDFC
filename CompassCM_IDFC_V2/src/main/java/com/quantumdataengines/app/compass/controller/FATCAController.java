package com.quantumdataengines.app.compass.controller;

import java.io.BufferedOutputStream;
import java.io.BufferedWriter;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBElement;
import javax.xml.bind.Unmarshaller;
import javax.xml.transform.stream.StreamSource;

import org.apache.commons.fileupload.DiskFileUpload;
import org.apache.commons.io.FileUtils;
import org.apache.commons.io.IOUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.quantumdataengines.app.compass.service.CommonService;
import com.quantumdataengines.app.compass.service.fatca.FATCAService;
import com.quantumdataengines.app.compass.util.fatca.FATCAFileGeneration;
import com.quantumdataengines.app.compass.util.fatca.FATCAMessage;
import com.quantumdataengines.app.compass.util.fatca.FATCAReportingStatus;
import com.quantumdataengines.app.compass.util.fatca.errorfile.FATCAFileErrorNotificationType;
import com.quantumdataengines.app.compass.util.fatca.validfile.FATCAValidFileNotificationType;

@Controller
@RequestMapping(value="/common")
public class FATCAController {
	
	@Autowired
	private FATCAService fatcaService;
	@Autowired
	private CommonService commonService;
	
	@RequestMapping(value="/get8966Form", method=RequestMethod.POST)
	public String get8966Form(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		String userCode = authentication.getPrincipal().toString();
		String path = "FATCAReport/8966/index";
		String caseNo = request.getParameter("caseNo");
		
		Map<String, String> formData = fatcaService.getFATCAFormData(caseNo, userCode);
		List<Map<String, String>> individualDetailsList = fatcaService.getIndividualDetails(caseNo, null, userCode);
		
		List<Map<String, String>> accountHolderDetailsList = fatcaService.getAccountHolderDetails(caseNo, null, userCode);
		
		request.setAttribute("FORMDATA", formData);
		request.setAttribute("INDIVIDUALDETAILS", individualDetailsList);
		request.setAttribute("ACCOUNTHOLDERDETAILS", accountHolderDetailsList);
		
		if(request.getParameter("message") !=  null){
			request.setAttribute("message", request.getParameter("message"));
		}
		request.setAttribute("caseNo", caseNo);
		request.setAttribute("ALLTITLES", fatcaService.getAllTitles());
		request.setAttribute("ALLCOUNTRIES", fatcaService.getAllCountry());
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "FATCA", "OPEN", "Module Accessed");
		return path;	
	}
	
	
	@RequestMapping(value="/saveFATCAForm", method=RequestMethod.POST)
	public @ResponseBody String saveFATCAForm(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		
		String USERCODE = authentication.getPrincipal().toString();
		String caseNo = request.getParameter("caseNo");
		String message = "";
		
		Map<String, String> paramMap = new HashMap<String, String>();
		
		Enumeration<String> paramEnum = request.getParameterNames();
		while (paramEnum.hasMoreElements()) {
			String paramName = paramEnum.nextElement();
			String paramValue = request.getParameter(paramName);
			paramMap.put(paramName, paramValue);
		}
		boolean isSaved = fatcaService.saveFATCAReport(paramMap, caseNo, USERCODE);
		if(isSaved)
			message = "FATCA Report successfully saved";
		else
			message = "Error while saving FATCA Report";
		commonService.auditLog(authentication.getPrincipal().toString(), request, "FATCA", "INSERT", "FATCA Form Saved "+isSaved);
		return message;
	}
	
	@RequestMapping(value="/exportFATCAForm", method=RequestMethod.GET)
	public String exportFATCAForm(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		String userCode = authentication.getPrincipal().toString();
		String caseNo = request.getParameter("caseNo");
		String message = "";
		
		BufferedWriter bufferedWriter = null;
		StringWriter stringWriter = null;

		try{
		HashMap hmFATCA8966XMLFileDetails = fatcaService.getForm8966XmlFileContent(caseNo, userCode);
		String l_strXmlFileName = (String) hmFATCA8966XMLFileDetails.get("FILENAME");
		HashMap l_HMXMlFileContent = (HashMap) hmFATCA8966XMLFileDetails.get("FILECONTENT");

		message = "FATCA Report successfully exported";
		// return "redirect:get8966Form?caseNo="+caseNo+"&message="+message;
		String l_strLineContent = "";
		stringWriter = new StringWriter();
		bufferedWriter = new BufferedWriter(stringWriter);

		Iterator<String> iterator = l_HMXMlFileContent.keySet().iterator();
		while (iterator.hasNext()) {
			String key = iterator.next().toString();
			String value = (String)l_HMXMlFileContent.get(key);
			//l_strLineContent = l_strLineContent+value+"\n";
			bufferedWriter.write(value);
			bufferedWriter.newLine();

		}
		bufferedWriter.flush();
        String fileData = stringWriter.toString();
        response.setContentType("APPLICATION/OCTET-STREAM");
        String disHeader = "Attachment;Filename=\""+l_strXmlFileName+"\"";
        response.setHeader("Content-disposition", disHeader);
        ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
        byteArrayOutputStream.write(fileData.getBytes());
        response.setContentLength(fileData.length());
        byteArrayOutputStream.writeTo(response.getOutputStream());
        byteArrayOutputStream.flush();
        byteArrayOutputStream.close();
        bufferedWriter.close();
		}
        catch (IOException e) {
        	System.out.println("Error occured : "+e.getMessage());
            e.printStackTrace();
        }
        catch (Exception e) {
        	System.out.println("Error occured : "+e.getMessage());
            e.printStackTrace();
        }	
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "FATCA", "DOWNLOAD", "FATCA Form Exported");
        return null;

	}
	
	@RequestMapping(value="/addFATCAAccountHolder", method=RequestMethod.POST)
	public String addFATCAAccountHolder(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		String USERCODE = authentication.getPrincipal().toString();
		String caseNo = request.getParameter("caseNo");
		
		request.setAttribute("caseNo", caseNo);
		request.setAttribute("lineNo", "0");
		request.setAttribute("ALLTITLES", fatcaService.getAllTitles());
		request.setAttribute("ALLCOUNTRIES", fatcaService.getAllCountry());
		commonService.auditLog(authentication.getPrincipal().toString(), request, "FATCA", "READ", "Module Accessed");
		return "FATCAReport/8966/addOrViewFATCAAccountHolder";
	}
	
	@RequestMapping(value="/updateFATCAAccountHolder", method=RequestMethod.POST)
	public String updateFATCAAccountHolder(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		String userCode = authentication.getPrincipal().toString();
		String caseNo = request.getParameter("caseNo");
		String lineNo = request.getParameter("lineNo");
		
		List<Map<String, String>> individualDetailsList = fatcaService.getAccountHolderDetails(caseNo, lineNo, userCode);
		if(individualDetailsList.size() > 0){
			request.setAttribute("ACCOUNTHOLDERDETAILS", individualDetailsList.get(0));
		}
		
		request.setAttribute("caseNo", caseNo);
		request.setAttribute("lineNo", lineNo);
		request.setAttribute("ALLTITLES", fatcaService.getAllTitles());
		request.setAttribute("ALLCOUNTRIES", fatcaService.getAllCountry());
		commonService.auditLog(authentication.getPrincipal().toString(), request, "FATCA", "READ", "Module Accessed");
		return "FATCAReport/8966/addOrViewFATCAAccountHolder";
	}
	
	@RequestMapping(value="/saveFATCAAccountHolder", method=RequestMethod.POST)
	public @ResponseBody String saveFATCAAccountHolder(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		String USERCODE = authentication.getPrincipal().toString();
		String caseNo = request.getParameter("caseNo");
		String lineNo = request.getParameter("lineNo");
		String message = "";
		
		Map<String, String> paramMap = new HashMap<String, String>();
		
		Enumeration<String> paramEnum = request.getParameterNames();
		while (paramEnum.hasMoreElements()) {
			String paramName = paramEnum.nextElement();
			String paramValue = request.getParameter(paramName);
			paramMap.put(paramName, paramValue);
		}
		boolean isSaved = fatcaService.saveAccountHolderDetails(paramMap, caseNo, lineNo, USERCODE);
		if(isSaved){
			if("0".equals(lineNo)){
				message = "Account Holder successfully added ";
			}else{
				message = "Account Holder successfully updated ";
			}
		}else{
			message = "Failed to save Account Holder details";
		}
		commonService.auditLog(authentication.getPrincipal().toString(), request, "FATCA", "INSERT", "FATCA Account Holder Added");
		return message;
	}
	
	@RequestMapping(value="/deleteFATCAAccountHolder", method=RequestMethod.POST)
	public @ResponseBody String deleteFATCAAccountHolder(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		String userCode = authentication.getPrincipal().toString();
		String caseNo = request.getParameter("caseNo");
		String lineNo = request.getParameter("lineNo");
		commonService.auditLog(authentication.getPrincipal().toString(), request, "FATCA", "DELETE", "FATCA Account Holder Deleted");
		if(fatcaService.deleteAccountHolderDetails(caseNo, lineNo, userCode))
			return "0";
		else
			return "1";
	}
	
	@RequestMapping(value="/addIndividual", method=RequestMethod.POST)
	public String addIndividual(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		String USERCODE = authentication.getPrincipal().toString();
		String caseNo = request.getParameter("caseNo");
		
		request.setAttribute("caseNo", caseNo);
		request.setAttribute("lineNo", "0");
		request.setAttribute("ALLTITLES", fatcaService.getAllTitles());
		request.setAttribute("ALLCOUNTRIES", fatcaService.getAllCountry());
		commonService.auditLog(authentication.getPrincipal().toString(), request, "FATCA", "READ", "Module Accessed");
		return "FATCAReport/8966/addOrViewNewIndividual";
	}
	
	@RequestMapping(value="/updateIndividual", method=RequestMethod.POST)
	public String updateIndividual(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		String userCode = authentication.getPrincipal().toString();
		String caseNo = request.getParameter("caseNo");
		String lineNo = request.getParameter("lineNo");
		
		List<Map<String, String>> individualDetailsList = fatcaService.getIndividualDetails(caseNo, lineNo, userCode);
		if(individualDetailsList.size() > 0){
			request.setAttribute("INDIVIDUALDETAILS", individualDetailsList.get(0));
		}
		
		request.setAttribute("caseNo", caseNo);
		request.setAttribute("lineNo", lineNo);
		request.setAttribute("ALLTITLES", fatcaService.getAllTitles());
		request.setAttribute("ALLCOUNTRIES", fatcaService.getAllCountry());
		commonService.auditLog(authentication.getPrincipal().toString(), request, "FATCA", "READ", "Module Accessed");
		return "FATCAReport/8966/addOrViewNewIndividual";
	}
	
	
	@RequestMapping(value="/saveIndividualDetails", method=RequestMethod.POST)
	public @ResponseBody String saveIndividualDetails(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		String USERCODE = authentication.getPrincipal().toString();
		String caseNo = request.getParameter("caseNo");
		String lineNo = request.getParameter("lineNo");
		String message = "";
		
		Map<String, String> paramMap = new HashMap<String, String>();
		
		Enumeration<String> paramEnum = request.getParameterNames();
		while (paramEnum.hasMoreElements()) {
			String paramName = paramEnum.nextElement();
			String paramValue = request.getParameter(paramName);
			paramMap.put(paramName, paramValue);
		}
		boolean isSaved = fatcaService.saveIndividualDetails(paramMap, caseNo, lineNo, USERCODE);
		if(isSaved){
			if("0".equals(lineNo)){
				message = "Individual successfully added ";
			}else{
				message = "Individual successfully updated ";
			}
		}else{
			message = "Failed to save Individual details";
		}
		commonService.auditLog(authentication.getPrincipal().toString(), request, "FATCA", "INSERT", "Individual Details Saved "+isSaved);
		return message;
	}
	
	@RequestMapping(value="/deleteIndividual", method=RequestMethod.POST)
	public @ResponseBody String deleteIndividual(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		String userCode = authentication.getPrincipal().toString();
		String caseNo = request.getParameter("caseNo");
		String lineNo = request.getParameter("lineNo");
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "FATCA", "DELETE", "Individual Details Deleted");
		if(fatcaService.deleteindividualDetails(caseNo, lineNo, userCode))
			return "0";
		else
			return "1";
	}
	
	@RequestMapping(value="/fatcaSettings", method=RequestMethod.POST)
	public String fatcaSettings(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		String userCode = authentication.getPrincipal().toString();
		String message = request.getParameter("message");
		request.setAttribute("FATCASETTINGS", fatcaService.fatcaSettings());
		request.setAttribute("MESSAGE", message);
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "FATCA", "OPEN", "Module Accessed");
		return "FATCAReport/fatcaSettings";
	}
	
	@RequestMapping(value="/updateFATCASettings", method=RequestMethod.POST)
	public @ResponseBody String updateFATCASettings(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		String userCode = authentication.getPrincipal().toString();
		Map<String, String> paramMap = new HashMap<String, String>();
		
		Enumeration<String> paramEnum = request.getParameterNames();
		while (paramEnum.hasMoreElements()) {
			String paramName = paramEnum.nextElement();
			String paramValue = request.getParameter(paramName);
			paramMap.put(paramName, paramValue);
		}
		
		boolean isSaved = fatcaService.updateFATCASettings(paramMap, userCode);
		
		if(isSaved){
			commonService.auditLog(authentication.getPrincipal().toString(), request, "FATCA", "UPDATE", "FATCA Settings Updated");
			return "FATCA Settings Updated";
		}
		else{
			commonService.auditLog(authentication.getPrincipal().toString(), request, "FATCA", "UPDATE", "Failed To Update FATCA Settings");
			return "Failed to update FATCA Settings";
		}
	}
	
	@RequestMapping(value = "/generateFATCAPackage", method = RequestMethod.GET) 
	public String generateFATCAPackage(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		String caseNo = request.getParameter("caseNo");
		
		if(caseNo == null || "".equals(caseNo)){
			caseNo = "";
		}
		
		response.addCookie(new Cookie("caseNo", caseNo));
		commonService.auditLog(authentication.getPrincipal().toString(), request, "FATCA", "OPEN", "Module Accessed");
		return "redirect:FATCAPackage";
	}
	
	@RequestMapping(value = "/FATCAPackage", method = RequestMethod.GET) 
	public String FATCAPackage(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		String caseNo = "";
		Cookie[] cookies = request.getCookies();
		for(Cookie cookie : cookies){
			if(cookie.getName().equals("caseNo")){
				caseNo = cookie.getValue();
				cookie.setMaxAge(0);
			}
		}		
		request.setAttribute("caseNo", caseNo);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "FATCA", "OPEN", "Module Accessed");
		return "FATCAReport/FATCAPackageGenerationTool";
	}
	
	@RequestMapping(value = "/generateFATCAFile", method = RequestMethod.POST)
	public @ResponseBody Map<String, String> generateFATCAFile(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		String userCode = authentication.getPrincipal().toString();
		Map<String, String> fatcaFileGenerationStatus = new HashMap<String, String>();
		String caseNo = request.getParameter("caseNo");
		FATCAFileGeneration fatcaFileGeneration = FATCAReportingStatus.getFATCAFileGeneration(caseNo);
		boolean startGeneration = false;
		boolean statusFetchRunning = false;
		
		
		if(fatcaFileGeneration == null){
			fatcaService.loadFATCAStatusFromDB(null, caseNo);
			fatcaFileGeneration = FATCAReportingStatus.getFATCAFileGeneration(caseNo);
		}
		
		if(fatcaFileGeneration == null){
			startGeneration = true;
			statusFetchRunning = true;
		}else{
			if(fatcaFileGeneration.getStatus() == 1){
				startGeneration = false;
				statusFetchRunning = true;
			}else{
				startGeneration = false;
				statusFetchRunning = false;
			}
		}
		
		if(statusFetchRunning){
			fatcaFileGenerationStatus.put("STARTGENERATION", "1");
			if(!startGeneration){
				fatcaFileGenerationStatus.put("MESSAGE", "FATCA File generation is running. Loading messages...");
			}else{
				fatcaFileGenerationStatus.put("MESSAGE", "FATCA File generation started. Loading messages...");
			}
		}else{
			fatcaFileGenerationStatus.put("STARTGENERATION", "0");
			fatcaFileGenerationStatus.put("MESSAGE", "This Case has been generated priviously. Do you want to Start Over? <a href='"+request.getContextPath()+"/regenerateFATCAFile?caseNo="+caseNo+"'>Yes</a>");
		}
		
		if(startGeneration){
			FATCAFileGeneration fileGeneration = new FATCAFileGeneration();
			fileGeneration.setStatus(1);
			fileGeneration.setGeneratedBy(userCode);
			fileGeneration.setStartDate(new Date());
			FATCAReportingStatus.setFATCAReportingStatus(caseNo, fileGeneration);
			FATCAReportingStatus.setFATCAMessage(caseNo, null);
			
			fatcaService.fatcaFileGeneration(caseNo, request.getContextPath()).start();
		}
		commonService.auditLog(authentication.getPrincipal().toString(), request, "FATCA", "OPEN", "FATCA File Generation Started");
		return fatcaFileGenerationStatus;
	}
	
	
	@RequestMapping(value = "/getFATCAMessageStatus", method = RequestMethod.GET)
	public @ResponseBody Map<String, Object> getFATCAMessageStatus(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		Map<String, Object> getFATCAMessageStatus = new HashMap<String, Object>();
		String caseNo = request.getParameter("caseNo");
		
		FATCAFileGeneration fatcaFileGeneration = FATCAReportingStatus.getFATCAFileGeneration(caseNo);
		
		Map<String, Object> fatcaFileGenerationLog = new HashMap<String, Object>();
		
		if(fatcaFileGeneration != null){
			fatcaFileGenerationLog.put("status", fatcaFileGeneration.getStatus());
			fatcaFileGenerationLog.put("progressStatus", fatcaFileGeneration.getProgressStatus());
			fatcaFileGenerationLog.put("startDate", fatcaFileGeneration.getStartDate());
			fatcaFileGenerationLog.put("endDate", fatcaFileGeneration.getEndDate());
			fatcaFileGenerationLog.put("generatedBy", fatcaFileGeneration.getGeneratedBy());
			fatcaFileGenerationLog.put("message", fatcaFileGeneration.getMessage());
			fatcaFileGenerationLog.put("caseFolderPath", fatcaFileGeneration.getCaseFolderPath());
			fatcaFileGenerationLog.put("originalXMLFile", fatcaFileGeneration.getOriginalXMLFile() != null ? fatcaFileGeneration.getOriginalXMLFile().getName() : "");
			fatcaFileGenerationLog.put("uploadedXMLFile", fatcaFileGeneration.getUploadedXMLFile() != null ? fatcaFileGeneration.getUploadedXMLFile().getName() : "");
		//	fatcaFileGenerationLog.put("uploadedXMLFile", fatcaFileGeneration.getOriginalXMLFile() != null ? fatcaFileGeneration.getOriginalXMLFile().getName() : "");
			fatcaFileGenerationLog.put("xmlFileToProcess", fatcaFileGeneration.getXmlFileToProcess() != null ? fatcaFileGeneration.getXmlFileToProcess().getName() : "");
			fatcaFileGenerationLog.put("generatedZipFile", fatcaFileGeneration.getGeneratedZipFile() != null ? fatcaFileGeneration.getGeneratedZipFile().getName() : "");
			fatcaFileGenerationLog.put("originalFileValid", fatcaFileGeneration.isOriginalFileValid());
			fatcaFileGenerationLog.put("uploadedFileValid", fatcaFileGeneration.isUploadedFileValid());
			fatcaFileGenerationLog.put("irsnotificationFile", fatcaFileGeneration.getIRSNotificationFile() != null ? fatcaFileGeneration.getIRSNotificationFile().getName() : "");
			fatcaFileGenerationLog.put("signedXMLFile", fatcaFileGeneration.getSignedXMLFile() != null ? fatcaFileGeneration.getSignedXMLFile().getName() : "");
			fatcaFileGenerationLog.put("irsNotificationFolder", fatcaFileGeneration.getIRSNotificationFolder());
			fatcaFileGenerationLog.put("irsPayloadFile", fatcaFileGeneration.getIRSPayloadFile() != null ? fatcaFileGeneration.getIRSPayloadFile().getName() : "");
			fatcaFileGenerationLog.put("irsMetadataFile", fatcaFileGeneration.getIRSMetadataFile() != null ? fatcaFileGeneration.getIRSMetadataFile().getName() : "");
			fatcaFileGenerationLog.put("isPlayloadRead", fatcaFileGeneration.isPlayloadRead());
			fatcaFileGenerationLog.put("IRSPayloadReadFile", fatcaFileGeneration.getIRSPayloadReadFile() != null ? fatcaFileGeneration.getIRSPayloadReadFile().getName() : "");
		}else{
			fatcaFileGenerationLog.put("status", "");
			fatcaFileGenerationLog.put("progressStatus", "");
			fatcaFileGenerationLog.put("startDate", "");
			fatcaFileGenerationLog.put("endDate", "");
			fatcaFileGenerationLog.put("generatedBy", "");
			fatcaFileGenerationLog.put("message", "");
			fatcaFileGenerationLog.put("caseFolderPath", "");
			fatcaFileGenerationLog.put("originalXMLFile", "");
			fatcaFileGenerationLog.put("uploadedXMLFile", "");
			fatcaFileGenerationLog.put("xmlFileToProcess", "");
			fatcaFileGenerationLog.put("generatedZipFile", "");
			fatcaFileGenerationLog.put("originalFileValid", false);
			fatcaFileGenerationLog.put("uploadedFileValid", false);
			fatcaFileGenerationLog.put("irsnotificationFile", "");
			fatcaFileGenerationLog.put("signedXMLFile", "");
			fatcaFileGenerationLog.put("irsNotificationFolder", "");
			fatcaFileGenerationLog.put("irsPayloadFile", "");
			fatcaFileGenerationLog.put("irsMetadataFile", "");
			fatcaFileGenerationLog.put("isPlayloadRead", false);
			fatcaFileGenerationLog.put("IRSPayloadReadFile", "");
		}
		
		getFATCAMessageStatus.put("FATCAGENERATIONLOG", fatcaFileGenerationLog);
		getFATCAMessageStatus.put("FATCAGENERATIONMESSAGELIST", FATCAReportingStatus.getFATCAMessageList(caseNo));
		commonService.auditLog(authentication.getPrincipal().toString(), request, "FATCA", "READ", "Data Read");
		return getFATCAMessageStatus;
	}
	
	
	@RequestMapping(value = "/donwloadXMLFile", method = RequestMethod.GET)
	public @ResponseBody String donwloadOriginalXMLFile(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		String caseNo = request.getParameter("caseNo");
		String typeType = request.getParameter("typeType");
		File downloadFile = null;
		String mimeType = "application/zip";
		FATCAFileGeneration fatcaFileGeneration = FATCAReportingStatus.getFATCAFileGeneration(caseNo);
		
		if("OriginalXML".equals(typeType)){
			downloadFile = fatcaFileGeneration.getOriginalXMLFile();
			mimeType = "application/xml";
		}else if("UploadedXML".equals(typeType)){
			downloadFile = fatcaFileGeneration.getUploadedXMLFile();
			mimeType = "application/xml";
		}else if("SignedXML".equals(typeType)){
			downloadFile = fatcaFileGeneration.getSignedXMLFile();
			mimeType = "application/xml";
		}else if("FinalZIP".equals(typeType)){
			downloadFile = fatcaFileGeneration.getGeneratedZipFile();
			mimeType = "application/zip";
		}else if("UploadedZIP".equals(typeType)){
			downloadFile = fatcaFileGeneration.getIRSNotificationFile();
			mimeType = "application/zip";
		}else if("IRSMetadataXML".equals(typeType)){
			downloadFile = fatcaFileGeneration.getIRSMetadataFile();
			mimeType = "application/xml";
		}else if("IRSPayloadXML".equals(typeType)){
			downloadFile = fatcaFileGeneration.getIRSPayloadFile();
			mimeType = "application/xml";
		}
		
		response.addCookie(new Cookie("fileDownload", "/"));
		 
		if(downloadFile != null && downloadFile.exists()){
			InputStream fileInputStream = new FileInputStream(downloadFile);
			response.setHeader("Content-Disposition", "attachment;filename=\"" +downloadFile.getName()+ "\"");
	        response.setContentType(mimeType);
	        OutputStream out = response.getOutputStream();
			IOUtils.copy(fileInputStream, out);
			out.flush();
		    out.close();
		    fileInputStream.close();
		    if("OriginalXML".equals(typeType))
		    	FATCAReportingStatus.setFATCAMessage(caseNo, new FATCAMessage(new Date(), "Compass generated XML file downloaded"));
		    else if("UploadedXML".equals(typeType))
		    	FATCAReportingStatus.setFATCAMessage(caseNo, new FATCAMessage(new Date(), "Uploaded XML file downloaded"));
		    else if("SignedXML".equals(typeType))
		    	FATCAReportingStatus.setFATCAMessage(caseNo, new FATCAMessage(new Date(), "Signed FATCA XML file downloaded"));
		    else if("FinalZIP".equals(typeType))
		    	FATCAReportingStatus.setFATCAMessage(caseNo, new FATCAMessage(new Date(), "FATCA Final File downloaded"));
		    else if("UploadedZIP".equals(typeType))
		    	FATCAReportingStatus.setFATCAMessage(caseNo, new FATCAMessage(new Date(), "IRS Notification File downloaded"));
		    else if("IRSMetadataXML".equals(typeType))
		    	FATCAReportingStatus.setFATCAMessage(caseNo, new FATCAMessage(new Date(), "IRS Metadata File downloaded"));
		    else if("IRSPayloadXML".equals(typeType))
		    	FATCAReportingStatus.setFATCAMessage(caseNo, new FATCAMessage(new Date(), "IRS Payload File downloaded"));
		}else{
			FATCAReportingStatus.setFATCAMessage(caseNo, new FATCAMessage(new Date(), "File not found"));
		}
		commonService.auditLog(authentication.getPrincipal().toString(), request, "FATCA", "DOWNLOAD", "FATCA XML File Downloaded");
	    return null;
	}
	
	
	@RequestMapping(value = "/uploadFATCAXMLFile", method = RequestMethod.POST)
	public @ResponseBody String uploadFATCAXMLFile(MultipartHttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		DiskFileUpload objDiskUpload = new DiskFileUpload();
		File uploadXMLFile = null;
		String caseNo = null;
		String message = "";
		
		try	{
			FATCAFileGeneration fatcaFileGeneration = null;
			Iterator<String> itrator = request.getFileNames();
			MultipartFile multiFile = request.getFile(itrator.next());
			caseNo = request.getParameter("caseNo");
			
	    	
	        byte[] bytes = multiFile.getBytes();
			
			if(caseNo != null && multiFile.getSize() > 0){
				float size = multiFile.getSize() / 1024;
				String fileName = multiFile.getOriginalFilename();
				if(fileName.lastIndexOf("\\") > 0)
					fileName = fileName.substring(fileName.lastIndexOf("\\")+1);
				
				fatcaFileGeneration = FATCAReportingStatus.getFATCAFileGeneration(caseNo);
				String fileExtension = fileName.substring(fileName.lastIndexOf(".")+1).toUpperCase();
				fatcaFileGeneration.setStatus(1);
				
				if(fileExtension.equals("XML")){
					FATCAReportingStatus.setFATCAMessage(caseNo, new FATCAMessage(new Date(), "Uploading XML File [File Name : "+fileName+", Size : "+size+"KB]"));
					String caseFolderPath = fatcaFileGeneration.getCaseFolderPath()+File.separator+"UPLOADEDXML";
					
					File caseFolder = new File(caseFolderPath);
					if(!caseFolder.exists())
						caseFolder.mkdirs();
					
					uploadXMLFile = new File(caseFolderPath+ File.separator + fileName);
					
					
					BufferedOutputStream stream = new BufferedOutputStream(new FileOutputStream(uploadXMLFile));
			        stream.write(bytes);
			        stream.close();
					
					String fileAbsolutename = uploadXMLFile.getAbsolutePath();
					uploadXMLFile = null;
					
					FATCAReportingStatus.setFATCAMessage(caseNo, new FATCAMessage(new Date(), "File uploaded and Stored in FATCA Case Folder"));
					fatcaFileGeneration.setUploadedXMLFile(new File(fileAbsolutename));
					
					FATCAReportingStatus.setFATCAMessage(caseNo, new FATCAMessage(new Date(), "Validating Uploaded XML file..."));
					boolean isValid = fatcaService.validateXMLFile(caseNo, fileAbsolutename);
					boolean isGeneratedXMLValid = fatcaFileGeneration.isOriginalFileValid();
					if(isValid){
						
						if(isGeneratedXMLValid){
							fatcaFileGeneration.setMessage("Compass generated XML and Upload XML both are valid FATCA XML file. You can continue with any one of these");
						}else{
							fatcaFileGeneration.setMessage("Upload XML is valid FATCA XML file. You can continue with this");
						}					
						
						fatcaFileGeneration.setUploadedFileValid(true);
						FATCAReportingStatus.setFATCAMessage(caseNo, new FATCAMessage(new Date(), "<font color='green'>Uploaded XML is validated.</font> XML File is ready to process."));
					}else{
						
						if(isGeneratedXMLValid){
							fatcaFileGeneration.setMessage("Upload XML is not a valid FATCA XML file. You can continue with Compass generated XML file or re-upload a valid XML file");
						}else{
							fatcaFileGeneration.setMessage("Upload XML is not a valid FATCA XML file. Please re-upload a valid XML file.");
						}
						
						fatcaFileGeneration.setUploadedFileValid(false);
						FATCAReportingStatus.setFATCAMessage(caseNo, new FATCAMessage(new Date(), "<font color='red'>Uploaded XML validation is completed with error(s).</font>"));
					}
					if(fatcaFileGeneration.getProgressStatus() <= 2)
						fatcaFileGeneration.setProgressStatus(3);
					
					message = " ";
				}else{
					FATCAReportingStatus.setFATCAMessage(caseNo, new FATCAMessage(new Date(), "A valid FATCA XML file was expected but found a "+fileExtension+" file."));
					message = "Please select a valid FATCA XML file";
				}
			}else{
				message = "Enter a valid File";
			}
			fatcaFileGeneration.setStatus(4);
			fatcaService.storeFATCAStatus(null, caseNo);
	    }catch (Exception e) {
	    	message = "Error occured while uploading file.";
	        e.printStackTrace();
	    }
		commonService.auditLog(authentication.getPrincipal().toString(), request, "FATCA", "INSERT", "FATCA XML File Uploaded");
		return message;
	}
	
	@RequestMapping(value = "/uploadIRSZipFile", method = RequestMethod.POST)
	public @ResponseBody String uploadIRSZipFile(MultipartHttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		DiskFileUpload objDiskUpload = new DiskFileUpload();
		File uploadZipFile = null;
		String caseNo = null;
		String message = "";
		
		try	{
			FATCAFileGeneration fatcaFileGeneration = null;
			Iterator<String> itrator = request.getFileNames();
			MultipartFile multiFile = request.getFile(itrator.next());
			caseNo = request.getParameter("caseNo");
			
	    	
	        byte[] bytes = multiFile.getBytes();
			
			if(caseNo != null && multiFile.getSize() > 0){
				float size = multiFile.getSize() / 1024;
				String fileName = multiFile.getOriginalFilename();
				if(fileName.lastIndexOf("\\") > 0)
					fileName = fileName.substring(fileName.lastIndexOf("\\")+1);
				
				fatcaFileGeneration = FATCAReportingStatus.getFATCAFileGeneration(caseNo);				
				String fileExtension = fileName.substring(fileName.lastIndexOf(".")+1).toUpperCase();
				fatcaFileGeneration.setStatus(1);
				
				if(fileExtension.equals("ZIP")){
					FATCAReportingStatus.setFATCAMessage(caseNo, new FATCAMessage(new Date(), "Uploading "+fileExtension+" File [File Name : "+fileName+", Size : "+size+"KB]"));
					
					String irsNotificationFolderPath = fatcaFileGeneration.getCaseFolderPath()+File.separator+"IRSNOTIFICATION";
					
					File irsNotificationFolder = new File(irsNotificationFolderPath);
					if(!irsNotificationFolder.exists())
						irsNotificationFolder.mkdirs();
					else{
						File[] fileList = irsNotificationFolder.listFiles();
						for(File file : fileList)
							file.delete();
					}
					
					uploadZipFile = new File(irsNotificationFolderPath+ File.separator + fileName);
					BufferedOutputStream stream = new BufferedOutputStream(new FileOutputStream(uploadZipFile));
			        stream.write(bytes);
			        stream.close();
					
					Map<String, Object> IRSNotificationFileCheck = fatcaService.checkIRSNotificationFile(uploadZipFile);
					boolean isValid = (Boolean) IRSNotificationFileCheck.get("ISVALID");
					String checkMessage = (String) IRSNotificationFileCheck.get("MESSAGE");
					
					if(isValid){
						FATCAReportingStatus.setFATCAMessage(caseNo, new FATCAMessage(new Date(), "IRS Notification file uploaded and Stored in FATCA Case Folder"));
						
						fatcaFileGeneration.setMessage("IRS Notification upload. Please click on continue button to unwrap it.");
						
						fatcaFileGeneration.setIRSNotificationFile(uploadZipFile);
						fatcaFileGeneration.setIRSNotificationFolder(irsNotificationFolderPath);
						fatcaFileGeneration.setProgressStatus(7);
						message = " ";
					}else{
						uploadZipFile.delete();
						FATCAReportingStatus.setFATCAMessage(caseNo, new FATCAMessage(new Date(), checkMessage));
						message = checkMessage;
					}
				}else{
					FATCAReportingStatus.setFATCAMessage(caseNo, new FATCAMessage(new Date(), "An IRS Notification ZIP file was expected but found a "+fileExtension+" file."));
					message = "Please upload a IRS Notification ZIP file";
				}
			}else{
				message = "Enter a valid File";
			}
			fatcaFileGeneration.setStatus(4);
			fatcaService.storeFATCAStatus(null, caseNo);
	    }catch (Exception e) {
	    	message = "Error occured while uploading file.";
	        e.printStackTrace();
	    }
		commonService.auditLog(authentication.getPrincipal().toString(), request, "FATCA", "INSERT", "IRS ZIP File Uploaded");
		return message;
	}
	
	@RequestMapping(value = "/processXMLFile", method = RequestMethod.POST)
	public @ResponseBody String processXMLFile(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		String caseNo = request.getParameter("caseNo");
		String typeType = request.getParameter("typeType");
		File xmlFile = null;
		FATCAFileGeneration fatcaFileGeneration = FATCAReportingStatus.getFATCAFileGeneration(caseNo);
		fatcaFileGeneration.setStatus(1);
		
		if(fatcaFileGeneration.getProgressStatus() != 4){
			if("OriginalXML".equals(typeType)){
				xmlFile = fatcaFileGeneration.getOriginalXMLFile();
				FATCAReportingStatus.setFATCAMessage(caseNo, new FATCAMessage(new Date(), "Starting FATCA final package gereration with Compass generated XML file : "+xmlFile.getName()));
			}else if("UploadedXML".equals(typeType)){
				xmlFile = fatcaFileGeneration.getUploadedXMLFile();
				FATCAReportingStatus.setFATCAMessage(caseNo, new FATCAMessage(new Date(), "Starting FATCA final package gereration with Uploaded XML file : "+xmlFile.getName()));
			}
			
			fatcaFileGeneration.setXmlFileToProcess(xmlFile);
			fatcaService.fatcaFileProcessing(caseNo, xmlFile).start();
			commonService.auditLog(authentication.getPrincipal().toString(), request, "FATCA", "OPEN", "Starting FATCA Final Package Gereration");
			return "";
		}else{
			return "FATCA Final generation is in progress. Wait till its get finished";
		}
		
	}
	
	@RequestMapping(value = "/unpackIRSZipNotification", method = RequestMethod.POST)
	public @ResponseBody String unpackIRSZipNotification(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		String caseNo = request.getParameter("caseNo");
		fatcaService.unpackIRSNotification(caseNo).start();
		commonService.auditLog(authentication.getPrincipal().toString(), request, "FATCA", "OPEN", "Unpacking IRS Zip Notification");
		return "";
	}
	
	
	@RequestMapping(value = "/DownloadCaseFolder", method = RequestMethod.GET)
	public @ResponseBody String DownloadCaseFolder(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		String caseNo = request.getParameter("caseNo");
		FATCAFileGeneration fatcaFileGeneration = FATCAReportingStatus.getFATCAFileGeneration(caseNo);
		String caseFolder = fatcaFileGeneration.getCaseFolderPath();
		
		String messageFilePath = caseFolder + File.separator + "Messages.txt";
		File messageFile = new File(messageFilePath);
		FATCAReportingStatus.setFATCAMessage(caseNo, new FATCAMessage(new Date(), "Creating Messages.txt file"));
		messageFile.createNewFile();
		FATCAReportingStatus.setFATCAMessage(caseNo, new FATCAMessage(new Date(), "Messages.txt file created and now writing..."));
		List<FATCAMessage> fatcaMessageList = FATCAReportingStatus.getFATCAMessageList(caseNo);
		PrintWriter writer = new PrintWriter(messageFile);
		writer.println("***** FATCA File Generation and IRS Notification Parsing status *****");
		writer.println("---------------------------------------------------------------------");
		writer.println("Start Time :: "+fatcaFileGeneration.getStartDate() != null ? fatcaFileGeneration.getStartDate() : "");
		writer.println("End Time :: "+fatcaFileGeneration.getEndDate() != null ? fatcaFileGeneration.getEndDate() : "");
		writer.println("Usercode :: "+fatcaFileGeneration.getGeneratedBy() != null ? fatcaFileGeneration.getGeneratedBy() : "");
		writer.println("Last Message :: "+fatcaFileGeneration.getMessage() != null ? fatcaFileGeneration.getMessage() : "");
		writer.println("---------------------------------------------------------------------");
		writer.println("---------------------------------------------------------------------\n");
		writer.println("Timestamp                   Message");
		writer.println("---------------------------------------------------------------------");
		for(FATCAMessage fatcaMessage : fatcaMessageList){
			writer.println(fatcaMessage.getTimestamp()+"     "+fatcaMessage.getMessage());
		}
		FATCAReportingStatus.setFATCAMessage(caseNo, new FATCAMessage(new Date(), "All message written now downloading..."));
		writer.close();
		File caseZipFile = fatcaService.generateCaseFolder(caseFolder);
		if(caseZipFile.exists()){
			response.addCookie(new Cookie("fileDownload", "/"));
			InputStream fileInputStream = new FileInputStream(caseZipFile);
			response.setHeader("Content-Disposition", "attachment;filename=\"" +"FATCA_CASE_"+caseZipFile.getName()+ "\"");
		    response.setContentType("application/zip");
		    OutputStream out = response.getOutputStream();
			IOUtils.copy(fileInputStream, out);
			out.flush();
			out.close();
			fileInputStream.close();
			caseZipFile.delete();
			messageFile.delete();
			FATCAReportingStatus.setFATCAMessage(caseNo, new FATCAMessage(new Date(), "Case folder downloaded."));
			commonService.auditLog(authentication.getPrincipal().toString(), request, "FATCA", "DOWNLOAD", "FATCA Case Folder Downloaded");
			return null;
		}else{
			return "Case folder couldn't created";
		}
	}
	
	@RequestMapping(value = "/readPlayLoad", method = RequestMethod.POST)
	public String readPlayLoad(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		String caseNo = request.getParameter("caseNo");
		boolean readSuccessful = false;
		FATCAValidFileNotificationType fatcaValidFileNotificationType = null;
		FATCAFileErrorNotificationType fatcaFileErrorNotificationType = null;
		FATCAFileGeneration fatcaFileGeneration = FATCAReportingStatus.getFATCAFileGeneration(caseNo);
		if(fatcaFileGeneration.isPlayloadRead()){
			File payloadFile = fatcaFileGeneration.getIRSPayloadReadFile();
			Class notificationClass = fatcaFileGeneration.getIRSNotificationType();
			
			if(notificationClass.equals(FATCAValidFileNotificationType.class)){
				JAXBContext jaxbContext = JAXBContext.newInstance(FATCAValidFileNotificationType.class);
		        Unmarshaller jaxbUnmarshaller = jaxbContext.createUnmarshaller();
		        JAXBElement<FATCAValidFileNotificationType> jaxbElement = 
		        		jaxbUnmarshaller.unmarshal(new StreamSource(payloadFile), FATCAValidFileNotificationType.class);
		        fatcaValidFileNotificationType = jaxbElement.getValue();
		        readSuccessful = true;
			}else if(notificationClass.equals(FATCAFileErrorNotificationType.class)){
				JAXBContext jaxbContext = JAXBContext.newInstance(FATCAFileErrorNotificationType.class);
		        Unmarshaller jaxbUnmarshaller = jaxbContext.createUnmarshaller();
		        JAXBElement<FATCAFileErrorNotificationType> jaxbElement = 
		        		jaxbUnmarshaller.unmarshal(new StreamSource(payloadFile), FATCAFileErrorNotificationType.class);
		        fatcaFileErrorNotificationType = jaxbElement.getValue();
		        readSuccessful = true;
			}
		}
		request.setAttribute("READ_SUCCESS", readSuccessful);
		request.setAttribute("PAYLOAD_VALID", fatcaValidFileNotificationType);
		request.setAttribute("PAYLOAD_ERROR", fatcaFileErrorNotificationType);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "FATCA", "READ", "Module Accessed");
		return "FATCAReport/payloadRead";
	}
	
	@RequestMapping(value = "/reGenerateFATCAFile", method = RequestMethod.GET)
	public String reGenerateFATCAFile(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		String caseNo = request.getParameter("caseNo");
		
		FATCAFileGeneration fatcaFileGeneration = FATCAReportingStatus.getFATCAFileGeneration(caseNo);
		if(fatcaFileGeneration != null){
			FATCAReportingStatus.setFATCAMessage(caseNo, new FATCAMessage(new Date(), "Removing all directories and files..."));
			String fatcaPackageFolder = fatcaFileGeneration.getFatcaPackageFolder();
			String IRSFotificationFolder = fatcaFileGeneration.getIRSNotificationFolder();			
			
			try{
				FileUtils.deleteDirectory(new File(fatcaPackageFolder));
			}catch(Exception e){}
			
			try{
				FileUtils.deleteDirectory(new File(IRSFotificationFolder));
			}catch(Exception e){}
			
			try{
				fatcaService.removeFATCAStatus(caseNo);
			}catch(Exception e){}
			
			FATCAReportingStatus.setFATCAReportingStatus(caseNo, null);
		}
		commonService.auditLog(authentication.getPrincipal().toString(), request, "FATCA", "OPEN", "FATCA File Regeneration Started");
		return "redirect:generateFATCAPackage?caseNo="+caseNo;
	}
}

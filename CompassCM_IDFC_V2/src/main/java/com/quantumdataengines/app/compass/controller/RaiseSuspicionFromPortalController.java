package com.quantumdataengines.app.compass.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.sql.Connection;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.IOUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.quantumdataengines.app.compass.otherservice.OtherCommonService;
import com.quantumdataengines.app.compass.service.CommonService;
import com.quantumdataengines.app.compass.service.master.GenericMasterService;
import com.quantumdataengines.app.compass.util.ActiveDirectoryLdapUtil;
import com.quantumdataengines.app.compass.util.CommonUtil;
import com.quantumdataengines.app.compass.util.ConnectionUtil;
import com.quantumdataengines.app.compass.util.EmailSenderUtil;

@Controller
// @RequestMapping(value="/amluser")
public class RaiseSuspicionFromPortalController {

	@Autowired
	private CommonService commonService;
	@Autowired
	private OtherCommonService otherCommonService;
	@Autowired
	private GenericMasterService genericMasterService;
	@Autowired
	private ConnectionUtil connectionUtil;
	
	@RequestMapping(value={"/raiseSuspicionFromPortal"}, method=RequestMethod.GET)
	public String securityTesting(HttpServletRequest request, HttpServletResponse response) throws Exception{
		
		String ldapType =  CommonUtil.loadProperties().getProperty("compass.aml.config.ldapType");
		Map<String, String> attributesMap =  new HashMap<String, String>();
			String userLogon = new com.sun.security.auth.module.NTSystem().getName();
			System.out.println("userLogon controller = "+userLogon);
			//System.out.println("controller 1st condi = "+request.getSession().getAttribute("userLogon"));
			
			/* Prompt for authentication
			  if(request.getSession().getAttribute("userLogon") == null) {
				String auth = request.getHeader("Authorization");
				try{ 
					System.out.println("auth = "+auth);
				   if (auth == null) 
				   {
					   response.setStatus(response.SC_UNAUTHORIZED); 
				       response.setHeader("WWW-Authenticate", "NTLM"); 
				       response.flushBuffer(); 
				   } 
				   if (auth.startsWith("NTLM ")){ 
				     byte[] msg = new sun.misc.BASE64Decoder().decodeBuffer(auth.substring(5)); 
				     int off = 0, length, offset; 
				     if (msg[8] == 1) 
				     { 
				       byte z = 0; 
				       byte[] msg1 = {(byte)'N', (byte)'T', (byte)'L', (byte)'M', (byte)'S', (byte)'S', (byte)'P', z,(byte)2, z, z, z, z, z, z, z,(byte)40, z, z, z, (byte)1, (byte)130, z, z,z, (byte)2, (byte)2, (byte)2, z, z, z, z, z, z, z, z, z, z, z, z}; 
				       response.setHeader("WWW-Authenticate", "NTLM " + new sun.misc.BASE64Encoder().encodeBuffer(msg1)); 
				       response.sendError(response.SC_UNAUTHORIZED);
				     }else if (msg[8] == 3){
				       off = 30; 
				       length = msg[off+17]*256 + msg[off+16]; 
				       offset = msg[off+19]*256 + msg[off+18]; 
				       String remoteHost = new String(msg, offset, length); 
				       length = msg[off+1]*256 + msg[off]; 
				       offset = msg[off+3]*256 + msg[off+2]; 
				       String domain = new String(msg, offset, length); 
				       length = msg[off+9]*256 + msg[off+8];
				       offset = msg[off+11]*256 + msg[off+10]; 
				       //String userLogon = new String(msg, offset, length); 
				       userLogon = new String(msg, offset, length); 
				       char a =0; 
				       char b =32;
				       request.getSession().setAttribute("userLogon",userLogon.trim().replace(a,b).replaceAll(" ","")); 
				       request.getSession().setAttribute("domain",domain.trim().replace(a,b).replaceAll(" ","")); 
				       response.setStatus(HttpServletResponse.SC_UNAUTHORIZED); 
				    } 
				  } 
				  }catch(Exception e){
				    System.out.println("error = "+e.getMessage()); 
				  }
			}*/
			
			//attributesMap = ActiveDirectoryLdapUtil.getAllAttributes(ldapType, userLogon);
			if(request.getSession().getAttribute("usernamevalue") == null && request.getSession().getAttribute("usermail") == null)
			{  
				attributesMap = ActiveDirectoryLdapUtil.getAllAttributes(ldapType, userLogon);
			}
			
			//System.out.println("allAttributes   "+attributesMap);
			
		
		//DomainUser domainUser = (DomainUser) authentication.getDetails();
		//log.info("Opening AMLUser index for : "+domainUser.getFirstName()+" "+domainUser.getLastName());
	
		String moduleType = "raiseSuspicionFromPortal";
		String ipAddress = request.getRemoteAddr();
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("RASUSERSLIST", genericMasterService.getRASUsersList(userLogon, "ROLE_PORTALUSER", ipAddress));
		request.setAttribute("BRANCHCODES", genericMasterService.getOptionNameValueFromView("VW_BRANCHCODE"));
		request.setAttribute("RAISEOFSUSPICION", genericMasterService.getOptionNameValueFromView("VW_TYPEOFSUSPICION"));
		request.setAttribute("USERLOGON", userLogon);
		request.setAttribute("ATTRIBUTES", attributesMap);
		request.getSession(false).setAttribute("CURRENTROLE","ROLE_PORTALUSER");
		request.getSession(false).setAttribute("userLogon",userLogon);
		
		//attributesMap.forEach((k, v) -> request.setAttribute(k,v));
		
		//System.out.println(k + ":" + v);
				
//		String userCode = request.getParameter("userLogon");
//		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
//		String ipAddress = request.getRemoteAddr();
//		
		/*
		String csrfToken = (String) request.getSession().getAttribute("X-CSRF-TOKEN");
	    if (null==csrfToken) {
	    	csrfToken = UUID.randomUUID().toString();
	        request.getSession(false).setAttribute("", csrfToken);
	    }*/
		String csrfToken = UUID.randomUUID().toString();
		request.setAttribute("XCSRFTOKEN1", csrfToken);
		HttpServletResponse res = (HttpServletResponse) response;
	    res.setHeader("X-CSRF-TOKEN", csrfToken);
	    
	    System.out.println("Controller->csrfToken "+csrfToken);
	    System.out.println("attributesMap = "+attributesMap);
		//request.setAttribute("_csrf")
		return "RaiseSuspicionFromPortal/index";
	}
	
	@RequestMapping(value="/commonFromPortal/validationCheck", method=RequestMethod.POST)
	public @ResponseBody List<Map<String,String>> validationCheck(HttpServletRequest request, HttpServletResponse response, 
					Authentication authentication) throws Exception{
		String custId = request.getParameter("customerId");
		String accNo = request.getParameter("accountNo");
		String userLogon = (String) request.getSession(false).getAttribute("userLogon");
		//String isValidMessage = "";
		commonService.auditLog(userLogon, request, "COMMON", "SEARCH", "Module Accessed");
		return commonService.validationCheck(custId,accNo);
	}
	
	@RequestMapping(value="/commonFromPortal/genericModuleFieldsSearch", method=RequestMethod.POST)
	public String genericModuleFieldsSearch(HttpServletRequest request, HttpServletResponse response, Authentication authentication){
		String searchFieldId = request.getParameter("searchFieldId");
		String serachFor = request.getParameter("serachFor");
		String viewName = request.getParameter("viewName");
		String isMultipleSelect = request.getParameter("isMultipleSelect");
		String userLogon = (String) request.getSession(false).getAttribute("userLogon");
		//System.out.println("searchFieldId = "+searchFieldId+" serachFor = "+serachFor+" viewName = "+viewName+" isMultipleSelect = "+isMultipleSelect);
		request.setAttribute("VIEWCOLS", genericMasterService.getViewOrTableColumns(viewName));
		request.setAttribute("searchFieldId", searchFieldId);
		request.setAttribute("serachFor", serachFor);
		request.setAttribute("viewName", viewName);
		request.setAttribute("isMultipleSelect", isMultipleSelect);
		request.setAttribute("UNQID", otherCommonService.getElementId());
		commonService.auditLog(userLogon, request, "GENERIC SEARCH : "+serachFor, "SEARCH", "Open generic search module to serach for "+serachFor);
		return "common/SearchModuleFromPortal/index";
	}
	
	@RequestMapping(value="/commonFromPortal/searchGenericModuleFields", method=RequestMethod.POST)
	public String searchGenericModuleFields(HttpServletRequest request, HttpServletResponse response, Authentication authentication){
		String searchFieldId = request.getParameter("searchFieldId");
		String serachFor = request.getParameter("serachFor");
		String viewName = request.getParameter("viewName");
		String isMultipleSelect = request.getParameter("isMultipleSelect");
		
		String moduleSearchBy = request.getParameter("moduleSearchBy");
		String moduleSearchType = request.getParameter("moduleSearchType");
		String moduleSearchValue = request.getParameter("moduleSearchValue");
		
		request.setAttribute("searchFieldId", searchFieldId);
		request.setAttribute("serachFor", serachFor);
		request.setAttribute("viewName", viewName);
		request.setAttribute("isMultipleSelect", isMultipleSelect);
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("SEARCHRESULT", genericMasterService.searchGenericModuleFields(viewName, moduleSearchType, moduleSearchValue, moduleSearchBy));
		commonService.auditLog((String) request.getSession(false).getAttribute("userLogon"), request, "GENERIC SEARCH : "+serachFor, "SEARCH", "Searching generic search for : "+serachFor+", Search By : "+moduleSearchBy+", Search Type : "+moduleSearchType+", input : "+moduleSearchValue);
		return "common/SearchModuleFromPortal/SearchBottomFrame";
	}
	
	@RequestMapping(value="/commonFromPortal/getFileUploadConfigFromPortal", method=RequestMethod.GET)
	public @ResponseBody Map<String, Object> getFileUploadConfigFromPortal(HttpServletRequest request, HttpServletResponse response) throws Exception{
		String userLogon = (String) request.getSession(false).getAttribute("userLogon");
		String CURRENTROLE = (String) request.getSession(false).getAttribute("CURRENTROLE");
		
		System.out.println("getFileUploadConfigFromPortal: ");
		String moduleRef = request.getParameter("moduleRefId");
		String moduleUnqNo = request.getParameter("moduleUnqNo");
		Map<String, Object> uploadConfig = commonService.getFileUploadConfig(moduleRef);
		List<Map<String, String>> uploadedFileConfig = commonService.getFilesInfoForModuleUnqNo(moduleUnqNo);
		uploadConfig.put("UPLOADEDFILES", uploadedFileConfig);
		uploadConfig.put("UNQID", otherCommonService.getElementId());
		uploadConfig.put("ATTACHFILEURL", "/commonFromPortal/fileAttachConfirmationFromPortal");
		System.out.println("uploadConfig: "+uploadConfig);
		System.out.println("uploadedFileConfig: "+uploadedFileConfig);
		commonService.auditLog(userLogon, request, "COMMON", "OPEN", "File Uploader Opened For"+moduleRef);
		return uploadConfig;
	}
	
	@RequestMapping(value="/commonFromPortal/genericFileUploadFromPortal", method = RequestMethod.POST)
	public @ResponseBody String genericFileUploadFromPortal(MultipartHttpServletRequest request, HttpServletResponse response) {
		String userLogon = (String) request.getSession(false).getAttribute("userLogon");
		String CURRENTROLE = (String) request.getSession(false).getAttribute("CURRENTROLE");
		
		String uploadModuleRefId = request.getParameter("uploadRefId");
		String uploadSeqNo = request.getParameter("unqId");
		String seqNo = request.getParameter("seqNo");
		String moduleUnqNo = request.getParameter("moduleUnqNo");
		
		Iterator<String> itrator = request.getFileNames();
		MultipartFile multiFile = request.getFile(itrator.next());
		
		Map<String, Object> uploadConfig = commonService.getFileUploadConfig(uploadModuleRefId);
	    commonService.saveUploadedFile(seqNo, (String) uploadConfig.get("FOLDERNAME"), uploadModuleRefId, 
	    		uploadSeqNo, moduleUnqNo, multiFile, userLogon, CURRENTROLE, request.getRemoteAddr());
	    commonService.auditLog(userLogon, request, "COMMON", "INSERT", "File Uploaded"+uploadModuleRefId+", Sequence No: "+seqNo);
	    return request.getFile("file") +" uploaded! uploadRefId = "+uploadModuleRefId+", uploadSeqNo="+uploadSeqNo;
	}
	
	@RequestMapping(value="/commonFromPortal/getAttachmentFolderFromPortal", method = RequestMethod.POST)
	public @ResponseBody String getAttachmentFolder(){
		return otherCommonService.getElementId();
	}	
	
	@RequestMapping(value="/commonFromPortal/downloadServerFileFromPortal", method = RequestMethod.GET)
	public @ResponseBody String downloadServerFileFromPortal(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		response.setHeader("Set-Cookie", "fileDownload=true; path=/");
		response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
		
		String userLogon = (String) request.getSession(false).getAttribute("userLogon");
		String CURRENTROLE = (String) request.getSession(false).getAttribute("CURRENTROLE");
		
		String seqNo = request.getParameter("seqNo");
		String uploadRefNo = request.getParameter("uploadRefNo");
		String moduleRefNo = request.getParameter("moduleRefNo");
		String moduleUnqNo = request.getParameter("moduleUnqNo");
		Map<String, Object> fileInfo = commonService.getFileContentForDownload(seqNo, uploadRefNo, moduleUnqNo);
		
		File file = (File) fileInfo.get("FILE");
		String fileName = (String) fileInfo.get("FILENAME");
		
		InputStream fileInputStream = new FileInputStream(file);
		response.setHeader("Content-Disposition", "attachment;filename=\"" +fileName+ "\"");
        response.setContentType("application/octet-stream");
        OutputStream out = response.getOutputStream();
		IOUtils.copy(fileInputStream, out);
		out.flush();
	    out.close();
	    fileInputStream.close();
	    file.delete();
	    commonService.auditLog(userLogon, request, "COMMON", "DOWNLOAD", "File Downloaded"+fileName);
		return null;
	}
	
	@RequestMapping(value="/commonFromPortal/removeServerFileFromPortal", method = RequestMethod.POST)
	public @ResponseBody String removeServerFileFromPortal(HttpServletRequest request, HttpServletResponse response) throws Exception{
		String userLogon = (String) request.getSession(false).getAttribute("userLogon");
		String CURRENTROLE = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String ipAddress = request.getRemoteAddr();
		
		String seqNo = request.getParameter("seqNo");
		String uploadRefNo = request.getParameter("uploadRefNo");
		String moduleRefNo = request.getParameter("moduleRefNo");
		String moduleUnqNo = request.getParameter("moduleUnqNo");
		
		commonService.auditLog(userLogon, request, "COMMON", "DELETE", "Server File Deleted");
		return commonService.removeServerFile(seqNo, uploadRefNo, moduleRefNo, moduleUnqNo,
				userLogon, CURRENTROLE, ipAddress);
	}
	
	@RequestMapping(value="/commonFromPortal/fileAttachConfirmationFromPortal", method = RequestMethod.POST)
	public String fileAttachConfirmationFromPortal(HttpServletRequest request, HttpServletResponse response) throws Exception{
		String userLogon = (String) request.getSession(false).getAttribute("userLogon");
		
		String uploadRefNo = request.getParameter("uploadRefNo");
		String moduleRefId = request.getParameter("moduleRefId");
		String moduleUnqNo = request.getParameter("moduleUnqNo");
		
		request.setAttribute("FILEINFO", commonService.getFileInfo(uploadRefNo, moduleRefId, moduleUnqNo));
		request.setAttribute("uploadRefNo", uploadRefNo);
		request.setAttribute("moduleRefId", moduleRefId);
		request.setAttribute("moduleUnqNo", moduleUnqNo);
		commonService.auditLog(userLogon, request, "COMMON", "SEARCH", "Module Accessed");
		return "common/FileAttachFromPortal/CommonFileAttach";
	}
		
	@RequestMapping(value="/commonFromPortal/submitReportOfSuspicionFromPortal", method=RequestMethod.POST)
	public @ResponseBody String submitReportOfSuspicionFromPortal(HttpServletRequest request,HttpServletResponse response){
		String userLogon = (String) request.getSession(false).getAttribute("userLogon");
		//String CURRENTROLE = (String) request.getSession(false).getAttribute("CURRENTROLE");
		
		System.out.println("In submitReportOfSuspicionFromPortal:");
		String alertNo = request.getParameter("alertNo");
		String reportingOn = request.getParameter("reportingOn");        
		String branchCode = request.getParameter("branchCode");
		String accountOrPersonName = request.getParameter("accountOrPersonName");
		String alertRating = request.getParameter("alertRating");
		String accountNo = request.getParameter("accountNo");
		String customerId = request.getParameter("customerId");
		String others = request.getParameter("others");
		String address1 = request.getParameter("address1");
		String address2 = request.getParameter("address2");
		String typeOfSuspicion = request.getParameter("typeOfSuspicion");
		String reasonForSuspicion = request.getParameter("reasonForSuspicion");
		String rasUserCode = request.getParameter("rasUserCode");
		
		String uid = request.getParameter("uid");
		String logonMailId = request.getParameter("mailId");
		String givenName = request.getParameter("givenName");
		String sn = request.getParameter("sn");
		String cn = request.getParameter("cn");
		String userPassword = request.getParameter("userPassword");
		
		String userCode = request.getParameter("userLogon");
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String ipAddress = request.getRemoteAddr();
		
		String subject = "Alert "+alertNo+" has been raised by "+userCode;
	    String content = typeOfSuspicion+System.lineSeparator()+reasonForSuspicion;
	    
		String message = genericMasterService.submitReportOfSuspicion(alertNo, reportingOn, branchCode, accountOrPersonName, alertRating, accountNo, customerId, others,
				address1, address2, typeOfSuspicion, reasonForSuspicion, rasUserCode, userCode, userRole, ipAddress);
		
		commonService.auditLog(userLogon, request, "RAISE SUSPICION", "INSERT", "Suspicion raised "+alertNo);
		
		String messageType = message.substring(0, message.indexOf(" -"));
		
		if(messageType.equalsIgnoreCase("SUCCESS")) {
			commonService.sendEmailFromPortal(alertNo, rasUserCode, subject, content, uid, logonMailId, givenName, sn, cn, userPassword, userCode, userRole, ipAddress);
		}
		/*
		String strFileChangedName = null;
		String strResultMessage = null;
		//Configuration config = commonService.getUserConfiguration();
		
		String TRANSACTIONFILESPATH = "C:\\eclipse\\aml\\APPFOLDER\\BANK_2"+File.separator+"TransactionFilePath";
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
			
				String alertNo = request.getParameter("alertNo");
				String reportingOn = request.getParameter("reportingOn");        
				String branchCode = request.getParameter("branchCode");
				String accountOrPersonName = request.getParameter("accountOrPersonName");
				String alertRating = request.getParameter("alertRating");
				String accountNo = request.getParameter("accountNo");
				String customerId = request.getParameter("customerId");
				String address1 = request.getParameter("address1");
				String address2 = request.getParameter("address2");
				String typeOfSuspicion = request.getParameter("typeOfSuspicion");
				String reasonForSuspicion = request.getParameter("reasonForSuspicion");
				String referenceCaseNo = request.getParameter("referenceCaseNo");
				String referenceCaseDate = request.getParameter("referenceCaseDate");
				String repeatSAR = request.getParameter("repeatSAR");
				String repeatSARRemarks = request.getParameter("repeatSARRemarks");
				String sourceOfInternalSAR = request.getParameter("sourceOfInternalSAR");
				String scenarioType = request.getParameter("scenarioType");
				
				String userCode = request.getParameter("userLogon");
				String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
				String ipAddress = request.getRemoteAddr();
				//System.out.println("Controller - repeatSAR = "+repeatSAR+"repeatSARRemarks = "+repeatSARRemarks+"sourceOfInternalSAR = "+sourceOfInternalSAR);
				
				genericMasterService.submitReportOfSuspicion(alertNo, reportingOn, branchCode, accountOrPersonName, alertRating, accountNo, customerId,
							address1, address2, typeOfSuspicion, reasonForSuspicion, referenceCaseNo, referenceCaseDate, 
							repeatSAR, repeatSARRemarks, sourceOfInternalSAR, scenarioType,
							userCode, userRole, ipAddress);
				
				//commonService.auditLog(authentication.getPrincipal().toString(), request, "RAISE SUSPICION", "INSERT", "Suspicion raised "+alertNo);
			}
		}
		catch(Exception e){
			System.out.println("Exception in uploading the attached file");
			e.printStackTrace();
		}
		*/	
		return message;
	}
}

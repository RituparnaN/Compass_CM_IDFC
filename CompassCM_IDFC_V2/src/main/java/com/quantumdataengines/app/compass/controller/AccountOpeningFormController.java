package com.quantumdataengines.app.compass.controller;

import java.awt.image.BufferedImage;
import java.io.BufferedOutputStream;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.codec.binary.Base64;
import org.apache.commons.io.IOUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.quantumdataengines.app.compass.model.AOFMandateFetchStatus;
import com.quantumdataengines.app.compass.schema.Configuration;
import com.quantumdataengines.app.compass.service.CommonService;
import com.quantumdataengines.app.compass.service.aof.AccountOpeningFormService;

@Controller
public class AccountOpeningFormController {
	
	@Autowired
	private AccountOpeningFormService accountOpeningFormService;
	@Value("${compass.aml.paths.aofmandate}")
	private String aofMandatePath;
	@Autowired
	private CommonService commonService;
	
	@RequestMapping(value="/cpuMaker/accountOpeningForm")
	public String accountOpeningForm(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		String USERCODE = authentication.getPrincipal().toString();
		String caseNo = request.getParameter("caseNo");
		request.setAttribute("CASE_NO", caseNo);
		String FORM_SECTION = request.getParameter("FORM_SECTION");
		
		request.setAttribute("FORM_SECTION", FORM_SECTION);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "AOF", "OPEN", "Module Accessed");
		return "AccountOpeningForm/Maker/index";
	}
	
	@RequestMapping(value="/cpuMaker/searchAccountOpeningForm")
	public String searchAccountOpeningForm(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		String USERCODE = authentication.getPrincipal().toString();
		
		String path = "AccountOpeningForm/Maker/AccountOpeningFormMaker";
		String accountNo = request.getParameter("accNumber");
		String cifNo = request.getParameter("cifNumner");
		String caseNo = request.getParameter("caseNo");		
		boolean finalSearch = false;	
		String message = "";
		
		if(cifNo == null || cifNo.trim().length() == 0){
			cifNo = " ";
		}
		
		if(accountNo == null || accountNo.trim().length() == 0){
			accountNo = " ";
		}
		
		if(caseNo == null || caseNo.trim().length() == 0)
			caseNo = " ";
		
		if(cifNo.trim().length() == 0 && accountNo.trim().length() == 0 && caseNo.trim().length() == 0){
			finalSearch = false;
			message = "Please enter a valid CIF Number or Account No or select from the Pending cases";
		}else{
			finalSearch = true;
			Map<String, Object> accountOpeningFormDataMap = accountOpeningFormService.getAccountOpeningFormData(cifNo, accountNo, caseNo, USERCODE, "M");
			
			request.setAttribute("CIF_DATA", (Map<String, String>) accountOpeningFormDataMap.get("CIF_DATA"));
			
			request.setAttribute("UPLOAD_DATA", (List<Map<String, String>>) accountOpeningFormDataMap.get("UPLOAD_DATA"));
			request.setAttribute("ACCOUNTS_AND_MANDATES", (Map<String, List<Map<String, String>>>) accountOpeningFormDataMap.get("ACCOUNTS_AND_MANDATES"));
			
			request.setAttribute("CIF_NO", (String) accountOpeningFormDataMap.get("CIF_NO"));
			request.setAttribute("ACCOUNT_NO", (String) accountOpeningFormDataMap.get("ACCOUNT_NO"));
			request.setAttribute("CASE_NO", (String) accountOpeningFormDataMap.get("CASE_NO"));
			request.setAttribute("CAN_EDIT", (String) accountOpeningFormDataMap.get("CAN_EDIT"));
			message = (String) accountOpeningFormDataMap.get("MESSAGE");
			
			request.setAttribute("JOINT_HOLDER", (List<Map<String, String>>) accountOpeningFormDataMap.get("JOINT_HOLDER"));
			request.setAttribute("FORMSTATUS", (Map<String, String>) accountOpeningFormDataMap.get("FORMSTATUS"));
		}
		
		if(request.getParameter("m") != null)
			message = request.getParameter("m");
			
		if(request.getParameter("FORM_SECTION") != null)
			request.setAttribute("FORM_SECTION", request.getParameter("FORM_SECTION"));
		
		request.setAttribute("SEARCHDONE", finalSearch);
		request.setAttribute("MESSAGE", message);
		request.setAttribute("ALLCOUNTRIES", accountOpeningFormService.getAllCountry());
		/*commonService.auditLog(authentication.getPrincipal().toString(), request, "AOF", "OPEN", "Module Accessed");*/
		commonService.auditLog(authentication.getPrincipal().toString(), request, "AOF", "SEARCH", "Searched Account Opening Form");
		return path;
	}
	
	@RequestMapping(value="/cpumaker/addAccountHolder")
	public String addAccountHolder(HttpServletRequest request, HttpServletResponse response, Authentication authentication){
		String path = "AccountOpeningForm/Maker/addAccountHolder";
		String type = request.getParameter("type");
		String accountNo = request.getParameter("AccountNo");
		String cifNo = request.getParameter("CIF");
		String lineNo = request.getParameter("LineNo");
		String canEdit = request.getParameter("canEdit");
		String caseNo = request.getParameter("caseNo");
		
		Map<String, Object> returnMap = accountOpeningFormService.getAccountHolderDetails(type, cifNo, accountNo, lineNo);
		
		request.setAttribute("ACCOUNTHOLDERDETAILS", returnMap.get("ACCOUNTHOLDER"));
		request.setAttribute("KEYCONTACTS", returnMap.get("KEYCONTACTS"));
		request.setAttribute("ALLCOUNTRIES", accountOpeningFormService.getAllCountry());
		request.setAttribute("type", type);
		request.setAttribute("CIF", cifNo);
		request.setAttribute("AccountNo", accountNo);
		request.setAttribute("LineNo", lineNo);
		request.setAttribute("caseNo", caseNo);
		request.setAttribute("canEdit", canEdit);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "AOF", "OPEN", "Module Accessed");
		return path;
	}
	
	@RequestMapping(value="/cpumaker/addAccountNoFrame")
	public String addAccountNoFrame(HttpServletRequest request, HttpServletResponse response, Authentication authentication){
		String path = "AccountOpeningForm/Maker/addAccountFrame";
		String accountNo = request.getParameter("AccountNo");
		String cifNo = request.getParameter("CIF");
		String caseNo = request.getParameter("CaseNo");
		String canEdit = request.getParameter("canEdit");
		
		request.setAttribute("CIF", cifNo);
		request.setAttribute("AccountNo", accountNo);
		request.setAttribute("caseNo", caseNo);
		request.setAttribute("canEdit", canEdit);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "AOF", "OPEN", "Module Accessed");
		return path;
	}
	
	@RequestMapping(value="/cpumaker/addAccountNo")
	public String addAccountNo(HttpServletRequest request, HttpServletResponse response, Authentication authentication){
		String path = "AccountOpeningForm/Maker/addAccountNo";
		String accountNo = request.getParameter("AccountNo");
		String cifNo = request.getParameter("CIF");
		String caseNo = request.getParameter("CaseNo");
		String canEdit = request.getParameter("canEdit");
		String message = "";
		
		Map<String, Object> allAccountDetails =  accountOpeningFormService.getAccountDetails(cifNo, accountNo, caseNo);
		
		Map<String, String> accountDetails = (Map<String, String>) allAccountDetails.get("ACCOUNT_DATA");
		Map<String, String> formStatus = (Map<String, String>) allAccountDetails.get("FORMSTATUS");
		List<Map<String, String>> jointHolderList = (List<Map<String, String>>) allAccountDetails.get("JOINT_HOLDER");
		
		request.setAttribute("accountData", accountDetails);
		request.setAttribute("FORMSTATUS", formStatus);
		request.setAttribute("JOINT_HOLDER", jointHolderList);
		
		request.setAttribute("CIF", cifNo);
		request.setAttribute("AccountNo", accountNo);
		request.setAttribute("caseNo", caseNo);
		request.setAttribute("canEdit", canEdit);
		
		if(request.getParameter("m") != null)
			message = request.getParameter("m");
		request.setAttribute("MESSAGE", message);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "AOF", "OPEN", "Module Accessed");
		return path;
	}
	
	@RequestMapping(value="/cpumaker/addValueAddedService")
	public String addValueAddedService(HttpServletRequest request, HttpServletResponse response, Authentication authentication){
		String path = "AccountOpeningForm/Maker/addValueAddedService";
		String accountNo = request.getParameter("AccountNo");
		String cifNo = request.getParameter("CIF");
		String lineNo = request.getParameter("LineNo");
		String caseNo = request.getParameter("caseNo");
		String canEdit = request.getParameter("canEdit");
		
		request.setAttribute("VALUEADDEDDETAILS", accountOpeningFormService.getValueAddedServiceDetails(cifNo, accountNo, lineNo));
		request.setAttribute("CIF", cifNo);
		request.setAttribute("AccountNo", accountNo);
		request.setAttribute("LineNo", lineNo);
		request.setAttribute("caseNo", caseNo);
		request.setAttribute("canEdit", canEdit);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "AOF", "OPEN", "Module Accessed");
		return path;
	}
	
	@RequestMapping(value="/cpumaker/saveMainFormData", method=RequestMethod.POST, params = "formSave")
	public @ResponseBody Map<String, Object> saveMainFormDataSave(HttpServletRequest request, HttpServletResponse response, Authentication authentication){
		String USERCODE = authentication.getPrincipal().toString();
		String cifNumner = request.getParameter("CIF_NO");
		String accNumber = request.getParameter("ACCOUNT_NO");
		String caseNo = request.getParameter("CASE_NO");
		String FORM_SECTION = request.getParameter("FORM_SECTION");
		Map<String, String> paramMap = new HashMap<String, String>();
		
		Enumeration<String> paramEnum = request.getParameterNames();
		while (paramEnum.hasMoreElements()) {
			String paramName = paramEnum.nextElement();
			String paramValue = request.getParameter(paramName);
			paramMap.put(paramName, paramValue);
		}
		Map<String, Object> mainMap = accountOpeningFormService.saveFormData(paramMap, caseNo, USERCODE, "U");
		commonService.auditLog(authentication.getPrincipal().toString(), request, "AOF", "INSERT", "Data Saved");
		mainMap.put("HIDESUBMIT", "N");
		return mainMap;
	}
	
	@RequestMapping(value="/cpumaker/saveMainFormData", method=RequestMethod.POST, params = "formClose")
	public @ResponseBody Map<String, Object> saveMainFormDataSaveClose(HttpServletRequest request, HttpServletResponse response, Authentication authentication){
		String USERCODE = authentication.getPrincipal().toString();
		String cifNumber = request.getParameter("CIF_NO");
		String accNumber = request.getParameter("ACCOUNT_NO");
		String caseNo = request.getParameter("CASE_NO");
		if(cifNumber != null && cifNumber.trim().length() > 0 && caseNo != null && caseNo.trim().length() > 0){
			Map<String, String> paramMap = new HashMap<String, String>();
			
			Enumeration<String> paramEnum = request.getParameterNames();
			while (paramEnum.hasMoreElements()) {
				String paramName = paramEnum.nextElement();
				String paramValue = request.getParameter(paramName);
				paramMap.put(paramName, paramValue);
			}
			Map<String, Object> mainMap = accountOpeningFormService.saveFormData(paramMap, caseNo, USERCODE, "P");
			commonService.auditLog(authentication.getPrincipal().toString(), request, "AOF", "INSERT", "Data Saved");
			mainMap.put("HIDESUBMIT", "Y");
			return mainMap;
		}else{
			Map<String, Object> mainMap = new HashMap<String, Object>(); 
			mainMap.put("HIDESUBMIT", "N");
			mainMap.put("MESSAGE", "CIF No should be selected in order to close");
			return mainMap;
		}
	}
	
	@RequestMapping(value="/cpumaker/saveAccountDetails", method=RequestMethod.POST)
	public @ResponseBody String saveAccountDetails(HttpServletRequest request, HttpServletResponse response, Authentication authentication){
		String USERCODE = authentication.getPrincipal().toString();
		String cifNumber = request.getParameter("CIF_NO");
		String accNumber = request.getParameter("ACCOUNT_NO");
		String caseNo = request.getParameter("CASE_NO");
		
		Map<String, String> paramMap = new HashMap<String, String>();
			
		Enumeration<String> paramEnum = request.getParameterNames();
		while (paramEnum.hasMoreElements()) {
			String paramName = paramEnum.nextElement();
			String paramValue = request.getParameter(paramName);
			paramMap.put(paramName, paramValue);
		}
		
		Map<String, Object> mainMap = accountOpeningFormService.saveAccountData(paramMap, caseNo, cifNumber, accNumber, USERCODE, "U");
		commonService.auditLog(authentication.getPrincipal().toString(), request, "AOF", "INSERT", "Data Saved");
		return (String) mainMap.get("MESSAGE");
	}
	
	@RequestMapping(value="/cpumaker/saveValueAddedService", method = RequestMethod.POST)
	public @ResponseBody String saveValueAddedService(HttpServletRequest request, HttpServletResponse response, Authentication authentication){
		String USERCODE = authentication.getPrincipal().toString();
		String cifNumber = request.getParameter("CIF_NO");
		String accNumber = request.getParameter("ACCOUNT_NO");
		String caseNo = request.getParameter("CASE_NO");
		
		Map<String, String> paramMap = new HashMap<String, String>();
		Enumeration<String> paramEnum = request.getParameterNames();
		while (paramEnum.hasMoreElements()) {
			String paramName = paramEnum.nextElement();
			String paramValue = request.getParameter(paramName);
			paramMap.put(paramName, paramValue);
		}
		String message = accountOpeningFormService.saveValueAddedService(caseNo, paramMap, USERCODE, "U");
		commonService.auditLog(authentication.getPrincipal().toString(), request, "AOF", "INSERT", "Data Saved");
		return message;
	}
	
	@RequestMapping(value="/cpumaker/saveAccountHolderDetails", method = RequestMethod.POST)
	public @ResponseBody String saveAccountHolderDetails(HttpServletRequest request, HttpServletResponse response, Authentication authentication){
		String USERCODE = authentication.getPrincipal().toString();
		String accountHolderType = request.getParameter("ACCOUNT_HOLDER_TYPE");
		String cifNumber = request.getParameter("CIF_NO");
		String accNumber = request.getParameter("ACCOUNT_NO");
		String lineNumber = request.getParameter("LINE_NO");
		String caseNo = request.getParameter("CASE_NO");
		if(cifNumber != null && cifNumber.trim().length() > 0){
			Map<String, String> paramMap = new HashMap<String, String>();
			
			Enumeration<String> paramEnum = request.getParameterNames();
			while (paramEnum.hasMoreElements()) {
				String paramName = paramEnum.nextElement();
				String paramValue = request.getParameter(paramName);
				paramMap.put(paramName, paramValue);
			}
			
			String message = accountOpeningFormService.saveAccountHolderDetails(caseNo, paramMap, accountHolderType, USERCODE, "U", lineNumber);
			commonService.auditLog(authentication.getPrincipal().toString(), request, "AOF", "INSERT", "Data Saved");
			return message;
		}else{
			return "CIF Number should be selected";
		}
	}
	
	@RequestMapping(value = "/cpumaker/uploadDocument")
	public String uploadDocument(HttpServletRequest request, HttpServletResponse response, Authentication authentication){
		String path = "AccountOpeningForm/Maker/uploadDocument";
		String accountNo = request.getParameter("AccountNo");
		String cifNo = request.getParameter("CIF");
		String caseNo = request.getParameter("CaseNo");
		
		request.setAttribute("caseNo", caseNo);
		request.setAttribute("CIF", cifNo);
		request.setAttribute("AccountNo", accountNo);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "AOF", "OPEN", "Module Accessed");
		return path;
	}
	
	@RequestMapping(value = "/cpumaker/uploadFormDocument", method=RequestMethod.POST)
	public @ResponseBody String uploadFormDocument(MultipartHttpServletRequest request, HttpServletResponse response, Authentication authentication){
		Configuration configuration = commonService.getUserConfiguration();
		String message = "Couldnot upload the document";
		String USERCODE = authentication.getPrincipal().toString();
		String uploadPath = configuration.getPaths().getIndexingPath()+File.separator+"CPUFILEUPLOAD";
		File uploadedFile = null;
		String cifNumber = request.getParameter("CIF_NO");
		String accNumber = request.getParameter("ACCOUNT_NO");
		String docName = request.getParameter("documentName");
		String caseNo = request.getParameter("CASE_NO");
		BufferedOutputStream stream = null;
		try	{
			File f = new File(uploadPath);
			if(!f.exists()){
				f.mkdirs();
			}
			
			Iterator<String> itrator = request.getFileNames();
			MultipartFile multiFile = request.getFile(itrator.next());
			String fileName = multiFile.getOriginalFilename();  
			String filePath = uploadPath + File.separator + fileName;
			
			if(cifNumber != null && cifNumber.trim().length() > 0 && caseNo != null && caseNo.trim().length() > 0){
				if(docName != null && docName.trim().length() > 0){
					uploadedFile = new File(filePath);
					stream = new BufferedOutputStream(new FileOutputStream(uploadedFile));
			        stream.write(multiFile.getBytes());
			        stream.close();
			        
					message = accountOpeningFormService.uploadFormDocument(caseNo, cifNumber, accNumber, docName, fileName, uploadedFile, "U", USERCODE);
				}else{
					message = "Enter a valid document name";
				}
			}else{
				message = "Cannot upload document without CIF No";
			}
		}catch(Exception e){
			e.printStackTrace();
		}
		commonService.auditLog(authentication.getPrincipal().toString(), request, "AOF", "INSERT", "Data Saved");
		return message;
	}
	
	@RequestMapping(value = "/cpumaker/deleteUploadedDocument", method=RequestMethod.POST)
	public @ResponseBody String deleteUploadedDocument(HttpServletRequest request, HttpServletResponse response, Authentication authentication){
		String USERCODE = authentication.getPrincipal().toString();
		String uploadDocRefNo = request.getParameter("docRefNo");
		String cifNo = request.getParameter("cifNo");
		String accountNo = request.getParameter("accNO");
		String caseNo = request.getParameter("caseNo");
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "AOF", "DELETE", "Data Deleted");
		return accountOpeningFormService.deleteDocument(caseNo, cifNo, accountNo, uploadDocRefNo, USERCODE);
	}
	
	@RequestMapping(value = "/cpumaker/viewUploadAndServerFile", method = RequestMethod.GET)
	public String viewUploadAndServerFile(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		String fileRefNo = request.getParameter("serverFileRefNo");
		String accountNo = request.getParameter("accountNo");
		String isServerFile = request.getParameter("isServerFile");
		
		request.setAttribute("isServerFile", isServerFile);
		request.setAttribute("fileRefNo", fileRefNo);
		request.setAttribute("accountNo", accountNo);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "AOF", "OPEN", "Module Accessed");
		return "AccountOpeningForm/Maker/viewServerFile";
	}
	
	@RequestMapping(value="/getTiffImage", method=RequestMethod.GET)
	public String getTiffImage(HttpServletRequest request, HttpServletResponse response, Authentication authentication){
		String fileRefNo = request.getParameter("serverFileRefNo");
		String imagePart = request.getParameter("part");
		try{
			int part = Integer.parseInt(imagePart);
			BufferedImage bufferedImage = (BufferedImage) accountOpeningFormService.getImageInfo(fileRefNo, part).get("IMAGE");
			
			response.setHeader("Content-Disposition", "inline;filename=\"" +imagePart+ "\"");
	        response.setContentType("image/jpeg");
	        OutputStream out = response.getOutputStream();
	        
	        
	        ByteArrayOutputStream os = new ByteArrayOutputStream();
	        ImageIO.write(bufferedImage, "jpeg", os);
	        InputStream is = new ByteArrayInputStream(os.toByteArray());
	        
	        
			IOUtils.copy(is, out);
			 out.flush();
		     out.close();
		}catch(Exception e){
			e.printStackTrace();
		}		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "AOF", "OPEN", "Module Accessed");
		return null;
	}
	
	@RequestMapping(value = "/cpuMaker/downloadServerFile", method = RequestMethod.POST)
	public @ResponseBody Map<String, Object> downloadServerFile(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		Map<String, Object> returnMap = new HashMap<String, Object>();
		String fileRefNo = request.getParameter("serverFileRefNo");
		int part = Integer.parseInt(request.getParameter("part"));
		
		Map<String, Object> imageMap = accountOpeningFormService.getImageInfo(fileRefNo, part);
		String status = (String) imageMap.get("STATUS");
		String message = (String) imageMap.get("MESSAGE");
		
		System.out.println("status : "+status+", message : "+message);
		
		if(status.equals("1")){
			BufferedImage bufferedImage = (BufferedImage) imageMap.get("IMAGE");
			
			ByteArrayOutputStream os = new ByteArrayOutputStream();
	        ImageIO.write(bufferedImage, "jpeg", os);
	        InputStream fileInputStream = new ByteArrayInputStream(os.toByteArray());	        
	        
	        byte[] fileByte = Base64.encodeBase64(IOUtils.toByteArray(fileInputStream));
	        
			String currentPage = (String) imageMap.get("CURRENTPAGE");
			String totalPage = (String) imageMap.get("TOTALPAGE");
			
			returnMap.put("CURRENTPAGE", currentPage);
			returnMap.put("TOTALPAGE", totalPage);
			returnMap.put("IMAGE", fileByte);
		}
		
		returnMap.put("STATUS", status);
		returnMap.put("MESSAGE", message);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "AOF", "DOWNLOAD", "File Downloaded");
		return returnMap;
	}
	
	@RequestMapping(value = "/cpuMaker/downloadUploadFile", method = RequestMethod.POST)
	public @ResponseBody byte[] downloadUploadFile(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		String fileRefNo = request.getParameter("serverFileRefNo");		
		Map<String, Object> resultMap = accountOpeningFormService.downloadFormUploadFile(fileRefNo);
		System.out.println(resultMap.size());
		if(resultMap.size() > 0){
			InputStream fileInputStream = (InputStream) resultMap.get("FILECONTENT");
			commonService.auditLog(authentication.getPrincipal().toString(), request, "AOF", "DOWNLOAD", "File Downloaded");
			return new Base64().encode(IOUtils.toByteArray(fileInputStream));
		}else{
			return null;
		}
	}
	
	@RequestMapping(value = "/cpuuser/CPUCaseWorkFlowMaker")
	public String aofViewStatus(HttpServletRequest request, HttpServletResponse response, Authentication authentication){
		commonService.auditLog(authentication.getPrincipal().toString(), request, "AOF", "OPEN", "Module Accessed");
		return "AccountOpeningForm/Maker/ViewStatus";
	}
	
	@RequestMapping(value = "/cpuMaker/viewAOFStatus", method=RequestMethod.POST)
	public String viewAOFStatus(HttpServletRequest request, HttpServletResponse response, Authentication authentication){
		String fromDate = request.getParameter("fromDate");
		String todate = request.getParameter("toDate");
		String status = request.getParameter("status");
		String USERCODE = authentication.getPrincipal().toString();
		
		request.setAttribute("FROMDATE",fromDate);
		request.setAttribute("TODATE",todate);
		request.setAttribute("STATUS",status);
		request.setAttribute("SEARCH","1");
		request.setAttribute("FORMSTATUS", accountOpeningFormService.getFormStatus(USERCODE, fromDate, todate, status, false));
		commonService.auditLog(authentication.getPrincipal().toString(), request, "AOF", "OPEN", "Module Accessed");
		return "AccountOpeningForm/Maker/makerViewStatusBottomFrame";
	}
	
	@RequestMapping(value = "/AccountOpeningFormCheck")
	public String AccountOpeningFormCheck(HttpServletRequest request, HttpServletResponse response, Authentication authentication){
		commonService.auditLog(authentication.getPrincipal().toString(), request, "AOF", "OPEN", "Module Accessed");
		return "/AccountOpeningForm/Checker/index.jsp";
	}
	
	@RequestMapping(value = "/viewAOFCheckerStatus", method=RequestMethod.GET)
	public String viewAOFCheckerStatus(HttpServletRequest request, HttpServletResponse response, Authentication authentication){
		String fromDate = request.getParameter("fromDate");
		String todate = request.getParameter("toDate");
		String status = request.getParameter("status");
		String USERCODE = authentication.getPrincipal().toString();
		
		request.setAttribute("FROMDATE",fromDate);
		request.setAttribute("TODATE",todate);
		request.setAttribute("STATUS",status);
		request.setAttribute("SEARCH","1");
		request.setAttribute("FORMSTATUS", accountOpeningFormService.getFormStatus(USERCODE, fromDate, todate, status, true));
		commonService.auditLog(authentication.getPrincipal().toString(), request, "AOF", "OPEN", "Module Accessed");
		return "/AccountOpeningForm/Checker/index.jsp";
	}
	
	@RequestMapping(value = "/AccountOpeningFormChecker", method=RequestMethod.GET)
	public String AccountOpeningFormChecker(HttpServletRequest request, HttpServletResponse response, Authentication authentication){
		String caseNo = request.getParameter("caseNo");
		String USERCODE = authentication.getPrincipal().toString();
		String message = "";
				
		Map<String, Object> accountOpeningFormDataMap = accountOpeningFormService.getAccountOpeningFormData("", "", caseNo, USERCODE, "C");
		
		request.setAttribute("CIF_DATA", (Map<String, String>) accountOpeningFormDataMap.get("CIF_DATA"));
		
		request.setAttribute("UPLOAD_DATA", (List<Map<String, String>>) accountOpeningFormDataMap.get("UPLOAD_DATA"));
		request.setAttribute("ACCOUNTS_AND_MANDATES", (Map<String, List<Map<String, String>>>) accountOpeningFormDataMap.get("ACCOUNTS_AND_MANDATES"));
		
		request.setAttribute("CASE_NO", (String) accountOpeningFormDataMap.get("CASE_NO"));
		request.setAttribute("CAN_CHECK", (String) accountOpeningFormDataMap.get("CAN_CHECK"));
		message = (String) accountOpeningFormDataMap.get("MESSAGE");
		
		request.setAttribute("JOINT_HOLDER", (List<Map<String, String>>) accountOpeningFormDataMap.get("JOINT_HOLDER"));
		request.setAttribute("FORMSTATUS", (Map<String, String>) accountOpeningFormDataMap.get("FORMSTATUS"));
		
		request.setAttribute("ACCOUNTNO", (String) accountOpeningFormDataMap.get("ACCOUNT_NO"));
		request.setAttribute("CIFNO", (String) accountOpeningFormDataMap.get("CIF_NO"));
		
		if(request.getParameter("message") != null)
			message = request.getParameter("message");
		
		request.setAttribute("MESSAGE", message);
		request.setAttribute("ALLCOUNTRIES", accountOpeningFormService.getAllCountry());
		request.setAttribute("AUDITLOG", accountOpeningFormService.getFormAuditLog(caseNo));
		commonService.auditLog(authentication.getPrincipal().toString(), request, "AOF", "OPEN", "Module Accessed");
		return "/AccountOpeningForm/Checker/AccountOpeningFormCheck";
	}
	
	@RequestMapping(value="/checkAccountHolder")
	public String checkAccountHolder(HttpServletRequest request, HttpServletResponse response, Authentication authentication){
		String path = "/AccountOpeningForm/Checker/checkAccountHolder";
		String type = request.getParameter("type");
		String accountNo = request.getParameter("AccountNo");
		String cifNo = request.getParameter("CIF");
		String lineNo = request.getParameter("LineNo");
		
		Map<String, Object> returnMap = accountOpeningFormService.getAccountHolderDetails(type, cifNo, accountNo, lineNo);
		
		request.setAttribute("ACCOUNTHOLDERDETAILS", returnMap.get("ACCOUNTHOLDER"));
		request.setAttribute("KEYCONTACTS", returnMap.get("KEYCONTACTS"));
		request.setAttribute("ALLCOUNTRIES", accountOpeningFormService.getAllCountry());
		request.setAttribute("type", type);
		request.setAttribute("CIF", cifNo);
		request.setAttribute("AccountNo", accountNo);
		request.setAttribute("LineNo", lineNo);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "AOF", "OPEN", "Module Accessed");
		return path;
	}
	
	@RequestMapping(value="/checkAccountNo")
	public String checkAccountNo(HttpServletRequest request, HttpServletResponse response, Authentication authentication){
		String path = "/AccountOpeningForm/Checker/checkAccountNo";
		String accountNo = request.getParameter("AccountNo");
		String cifNo = request.getParameter("CIF");
		String caseNo = request.getParameter("CaseNo");
		
		Map<String, Object> allAccountDetails =  accountOpeningFormService.getAccountDetails(cifNo, accountNo, caseNo);
		
		Map<String, String> accountDetails = (Map<String, String>) allAccountDetails.get("ACCOUNT_DATA");
		Map<String, String> formStatus = (Map<String, String>) allAccountDetails.get("FORMSTATUS");
		List<Map<String, String>> jointHolderList = (List<Map<String, String>>) allAccountDetails.get("JOINT_HOLDER");
		
		request.setAttribute("CaseNo", caseNo);
		request.setAttribute("CIF", cifNo);
		request.setAttribute("AccountNo", accountNo);
		
		request.setAttribute("accountData", accountDetails);
		request.setAttribute("FORMSTATUS", formStatus);
		request.setAttribute("JOINT_HOLDER", jointHolderList);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "AOF", "OPEN", "Module Accessed");
		return path;
	}
	
	@RequestMapping(value="/checkValueAddedService")
	public String checkValueAddedService(HttpServletRequest request, HttpServletResponse response, Authentication authentication){
		String path = "/AccountOpeningForm/Checker/checkValueAddedService";
		String accountNo = request.getParameter("AccountNo");
		String cifNo = request.getParameter("CIF");
		String lineNo = request.getParameter("LineNo");
		
		request.setAttribute("VALUEADDEDDETAILS", accountOpeningFormService.getValueAddedServiceDetails(cifNo, accountNo, lineNo));
		request.setAttribute("CIF", cifNo);
		request.setAttribute("AccountNo", accountNo);
		request.setAttribute("LineNo", lineNo);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "AOF", "OPEN", "Module Accessed");
		return path;
	}
	
	@RequestMapping(value="/saveCheckerAction", method=RequestMethod.POST, params="formApprove")
	public String saveCheckerActionApprove(HttpServletRequest request, HttpServletResponse response, Authentication authentication){
		String USERCODE = authentication.getPrincipal().toString();
		String cifNumber = request.getParameter("cifNumber");
		String accNumber = request.getParameter("accNumber");
		String remark = request.getParameter("remark");
		String caseNo = request.getParameter("caseNo");
		String status = "A";
		
		String message = accountOpeningFormService.saveCheckerResponse(caseNo, cifNumber, accNumber, remark, status, USERCODE,"","");
		commonService.auditLog(authentication.getPrincipal().toString(), request, "AOF", "INSERT", "Data Saved");
		return "redirect:AccountOpeningFormChecker?caseNo="+caseNo+"&message="+message;
	}
	
	@RequestMapping(value="/saveCheckerAction", method=RequestMethod.POST, params="formReject")
	public String saveCheckerActionReject(HttpServletRequest request, HttpServletResponse response, Authentication authentication){
		String USERCODE = authentication.getPrincipal().toString();
		String cifNumber = request.getParameter("cifNumber");
		String accNumber = request.getParameter("accNumber");
		String remark = request.getParameter("remark");
		String caseNo = request.getParameter("caseNo");
		String rejectedFileds = request.getParameter("rejectedFileds");
		String reasonOfRejection = request.getParameter("reasonOfRejection");
		
		String status = "R";
		String message = accountOpeningFormService.saveCheckerResponse(caseNo, cifNumber, accNumber, remark, status, USERCODE, rejectedFileds, reasonOfRejection);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "AOF", "INSERT", "Data Saved");
		return "redirect:AccountOpeningFormChecker?caseNo="+caseNo+"&message="+message;
	}
	
	@RequestMapping(value="/fetchAccountOpeningMandateFiles", method=RequestMethod.POST)
	public @ResponseBody String fetchAccountOpeningMandateFiles(HttpServletRequest request, HttpServletResponse response, Authentication authentication){
		String USERCODE = authentication.getPrincipal().toString();
		String returnString = "";
		File file = new File(aofMandatePath);
		if(file.exists() && file.isDirectory()){
			if(AOFMandateFetchStatus.getInstance().getStatus() != 1){
				accountOpeningFormService.truncateServerFilesTable();
				AOFMandateFetchStatus aofMandateFetchStatus = AOFMandateFetchStatus.newInstance();
				aofMandateFetchStatus.setStatusRunning();
				aofMandateFetchStatus.setNewPath(aofMandatePath);
				aofMandateFetchStatus.setStartDate(new Date());
				
				Thread thread = accountOpeningFormService.fetchAccountOpeningMandate(aofMandatePath, USERCODE);
				aofMandateFetchStatus.setThread(thread);
				thread.start();
				returnString = "Account Opening Mandate fetching process has been started";
			}else{
				returnString = "Account Opening Mandate fetching process has been already started";
			}
		}else{
			returnString = "Mentioned Path "+aofMandatePath+" in the configuration file is not a directory";
		}
		commonService.auditLog(authentication.getPrincipal().toString(), request, "AOF", "READ", "Module Accessed");
		return returnString;
	}
	
	@RequestMapping(value="/AccountOpeningMandateFetchLOG", method=RequestMethod.GET)
	public String AccountOpeningMandateFetchLOG(HttpServletRequest request, HttpServletResponse response, Authentication authentication){
		request.setAttribute("FETCHLOG", accountOpeningFormService.getAOFFetchLog());
		commonService.auditLog(authentication.getPrincipal().toString(), request, "AOF", "OPEN", "Module Accessed");
		return "/AccountOpeningForm/Admin/MandateFetchLog";
	}
	
	@RequestMapping(value="/getAccountOpeningMandateFetchStatus", method=RequestMethod.POST)
	public @ResponseBody Map<String, String> getAccountOpeningMandateFetchStatus(HttpServletRequest request, HttpServletResponse response, Authentication authentication){		
		Map<String, String> returnMap = new HashMap<String, String>();
		AOFMandateFetchStatus aofMandateFetchStatus = AOFMandateFetchStatus.getInstance();
		returnMap.put("STATUS", aofMandateFetchStatus.getStatus()+"");
		returnMap.put("COUNT", aofMandateFetchStatus.getCount()+"");
		returnMap.put("STARTTIME", aofMandateFetchStatus.getStartDate() != null ? aofMandateFetchStatus.getStartDate().toString() : "");
		returnMap.put("ENDTIME", aofMandateFetchStatus.getEndDate() != null ? aofMandateFetchStatus.getEndDate().toString() : "");
		returnMap.put("PATHCOUNT", aofMandateFetchStatus.getPathCount()+"");
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "AOF", "READ", "Module Accessed");
		return returnMap;
	}
	
	@RequestMapping(value="/assignCIF", method=RequestMethod.GET)
	public String assignCIF(HttpServletRequest request, HttpServletResponse response){
		request.setAttribute("BRANCH_CIFTYPE", accountOpeningFormService.getBranchCifTypeForAssignCIF());
		request.setAttribute("CHECKER_MAKER", accountOpeningFormService.getCheckerMakerCode());
		return "/AccountOpeningForm/Admin/assignCIF";
	}
	
	@RequestMapping(value="/calculateCIFForAssign", method=RequestMethod.POST)
	public @ResponseBody String calculateUnassignedCIF(HttpServletRequest request, HttpServletResponse response, Authentication authentication){
		String branchCode = request.getParameter("BRANCH_CODE");
		String cifType = request.getParameter("CIF_TYPE");
		String cifNumber = request.getParameter("CIF_NUMBER");
		String accountNo = request.getParameter("ACCOUNT_NO");
		String excludeApproved = request.getParameter("EXCLUDE_APPROVED") != null ? request.getParameter("EXCLUDE_APPROVED") : "N";
		
		String count = new Integer(accountOpeningFormService.countCIFForAssign(branchCode, cifType, cifNumber, accountNo, excludeApproved)).toString();
		commonService.auditLog(authentication.getPrincipal().toString(), request, "AOF", "READ", "Module Accessed");
		return count;
	}
	
	@RequestMapping(value="/assignCIFToCheckerMaker", method=RequestMethod.POST)
	public String assignCIFToChekerMaker(HttpServletRequest request, HttpServletResponse response, Authentication authentication){
		String branchCode = request.getParameter("BRANCH_CODE");
		String cifType = request.getParameter("CIF_TYPE");
		String cifNumber = request.getParameter("CIF_NUMBER");
		String accountNo = request.getParameter("ACCOUNT_NO");
		String excludeApproved = request.getParameter("EXCLUDE_APPROVED") != null ? request.getParameter("EXCLUDE_APPROVED") : "N";
		String maker = request.getParameter("MAKER");
		String checker = request.getParameter("CHECKER");
		String noOfCases = request.getParameter("NUMBER_OF_CASE");
		
		int assignedCIF = accountOpeningFormService.assignCIF(branchCode, cifType, cifNumber, accountNo, noOfCases, maker, checker, excludeApproved);
		
		String count = new Integer(accountOpeningFormService.countCIFForAssign(branchCode, cifType, cifNumber, accountNo, excludeApproved)).toString();
		request.setAttribute("BRANCH_CIFTYPE", accountOpeningFormService.getBranchCifTypeForAssignCIF());
		request.setAttribute("CHECKER_MAKER", accountOpeningFormService.getCheckerMakerCode());
		request.setAttribute("CASE_COUNT", count);
		request.setAttribute("ASSIGNED_COUNT", assignedCIF);
		
		request.setAttribute("BRANCH_CODE", branchCode);
		request.setAttribute("CIF_TYPE", cifType);
		request.setAttribute("CIF_NUMBER", cifNumber);
		request.setAttribute("ACCOUNT_NO", accountNo);
		request.setAttribute("EXCLUDE_APPROVED", excludeApproved);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "AOF", "INSERT", "Data Saved");
		return "/AccountOpeningForm/Admin/assignCIF";
	}
	
	@RequestMapping(value="/reAssignCIF", method=RequestMethod.GET)
	public String reAssignCIF(HttpServletRequest request, HttpServletResponse response, Authentication authentication){
		request.setAttribute("BRANCH_CIFTYPE", accountOpeningFormService.getBranchCifTypeForAssignCIF());
		request.setAttribute("CHECKER_MAKER", accountOpeningFormService.getCheckerMakerCode());
		commonService.auditLog(authentication.getPrincipal().toString(), request, "AOF", "INSERT", "Data Saved");
		return "/AccountOpeningForm/Admin/reAssignCIF";
	}
	
	@RequestMapping(value="/checkCasesForReAssign", method=RequestMethod.GET)
	public String checkCasesForReAssign(HttpServletRequest request, HttpServletResponse response, Authentication authentication){
		String branchCode = request.getParameter("BRANCH_CODE");
		String cifType = request.getParameter("CIF_TYPE");
		String cifNumber = request.getParameter("CIF_NUMBER");
		String accountNo = request.getParameter("ACCOUNT_NO");
		String maker = request.getParameter("MAKER");
		String checker = request.getParameter("CHECKER");
		
		request.setAttribute("CASES", accountOpeningFormService.checkCasesForReAssign("", "", branchCode, cifType, cifNumber, accountNo, maker, checker));
		request.setAttribute("BRANCH_CIFTYPE", accountOpeningFormService.getBranchCifTypeForAssignCIF());
		request.setAttribute("CHECKER_MAKER", accountOpeningFormService.getCheckerMakerCode());
		request.setAttribute("BRANCH_CODE", branchCode);
		request.setAttribute("CIF_TYPE", cifType);
		request.setAttribute("CIF_NUMBER", cifNumber);
		request.setAttribute("ACCOUNT_NO", accountNo);
		request.setAttribute("MAKER", maker);
		request.setAttribute("CHECKER", checker);
		request.setAttribute("ASSIGNED", count);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "AOF", "SEARCH", "Module Accessed");
		return "/AccountOpeningForm/Admin/reAssignCIF";
	}
	
	int count = -1;
	
	@RequestMapping(value="/reAssignCIFToCheckerMaker", method=RequestMethod.POST, params="reassign")
	public String reAssignCIFToCheckerMaker(HttpServletRequest request, HttpServletResponse response, Authentication authentication){
		String branchCode = request.getParameter("BRANCH_CODE");
		String cifType = request.getParameter("CIF_TYPE");
		String cifNumber = request.getParameter("CIF_NUMBER");
		String accountNo = request.getParameter("ACCOUNT_NO");
		String maker = request.getParameter("MAKER");
		String checker = request.getParameter("CHECKER");
		String selectedMaker = request.getParameter("SELECTED_MAKER");
		String selectedChecker = request.getParameter("SELECTED_CHECKER");
		String cases = request.getParameter("CASES");

		count = accountOpeningFormService.reassignCases(selectedMaker, selectedChecker, cases);
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "AOF", "INSERT", "Data Saved");
		return "redirect:checkCasesForReAssign?BRANCH_CODE="+branchCode+"&CIF_TYPE="+cifType+"&CIF_NUMBER="+cifNumber+"&ACCOUNT_NO="+accountNo+"&MAKER="+maker+"&CHECKER="+checker;
	}
	
	@RequestMapping(value="/reAssignCIFToCheckerMaker", method=RequestMethod.POST, params="unassign")
	public String unassignCIF(HttpServletRequest request, HttpServletResponse response, Authentication authentication){
		String branchCode = request.getParameter("BRANCH_CODE");
		String cifType = request.getParameter("CIF_TYPE");
		String cifNumber = request.getParameter("CIF_NUMBER");
		String accountNo = request.getParameter("ACCOUNT_NO");
		String maker = request.getParameter("MAKER");
		String checker = request.getParameter("CHECKER");
		String selectedMaker = request.getParameter("SELECTED_MAKER");
		String selectedChecker = request.getParameter("SELECTED_CHECKER");
		String cases = request.getParameter("CASES");

		count = accountOpeningFormService.unassignCases(cases);
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "AOF", "INSERT", "Data Saved");
		return "redirect:checkCasesForReAssign?BRANCH_CODE="+branchCode+"&CIF_TYPE="+cifType+"&CIF_NUMBER="+cifNumber+"&ACCOUNT_NO="+accountNo+"&MAKER="+maker+"&CHECKER="+checker;
	}
	
}

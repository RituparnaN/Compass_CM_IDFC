package com.quantumdataengines.app.compass.controller.regulatoryReports.india;

import java.io.BufferedOutputStream;
import java.io.BufferedWriter;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.StringWriter;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import com.quantumdataengines.app.compass.model.regulatoryReports.india_STR_TRF.ISTRTRFManualDetailsVO;
import com.quantumdataengines.app.compass.model.regulatoryReports.india_STR_TRF.ISTRTRFBranchDetailsVO;
import com.quantumdataengines.app.compass.model.regulatoryReports.india_STR_TRF.ISTRTRFEntityDetailsVO;
import com.quantumdataengines.app.compass.model.regulatoryReports.india_STR_TRF.ISTRTRFIndividualDetailsVO;
import com.quantumdataengines.app.compass.model.regulatoryReports.india_STR_TRF.ISTRTRFTransactionDetailsVO;
import com.quantumdataengines.app.compass.service.CommonService;
import com.quantumdataengines.app.compass.service.master.GenericMasterService;
import com.quantumdataengines.app.compass.service.regulatoryReports.india.INDSTRTRFService;
// import com.quantumdataengines.utilities.ApplicationProperties;

@Controller
@RequestMapping(value="/common")
public class INDSTRTRFController {
	private Logger log = LoggerFactory.getLogger(INDSTRController.class);
	@Autowired
	private INDSTRTRFService INDSTRTRFService;
	@Autowired
	private CommonService commonService;
	@Autowired
	private GenericMasterService genericMasterService;
	
	@Value("${compass.aml.paths.transactionFilePath}")
	private String transactionFilePath;

	@RequestMapping(value="/getINDSTRTRFReport")
	public ModelAndView getINDSTRTRFReport(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		ModelAndView mv = new ModelAndView("RegulatoryReports/India/STR_TRF/strTRFMain");
		HttpSession l_CHttpSession = request.getSession(true);
		String caseNo = request.getParameter("caseNo") == null?(String)l_CHttpSession.getAttribute("caseNo"):request.getParameter("caseNo").toString();
		//String caseNo = request.getParameter("caseNo").toString();
		String userCode = authentication.getPrincipal().toString();
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String canUpdated = request.getParameter("canUpdated") == null ? "N":request.getParameter("canUpdated").toString();
		String canExported = request.getParameter("canExported") == null ? "N":request.getParameter("canExported").toString();
		request.getSession().setAttribute("caseNo",caseNo);
		request.getSession().setAttribute("canUpdated",canUpdated);
		request.getSession().setAttribute("canExported",canExported);
		HashMap l_HMINDSTRTRFReport = INDSTRTRFService.getINDSTRTRFReport(caseNo, userCode, userRole);
		request.setAttribute("INDIANSTRTRFDETAILS", l_HMINDSTRTRFReport);
		request.setAttribute("canUpdated", canUpdated);
		request.setAttribute("canExported", canExported);
		request.setAttribute("caseNo",caseNo);
		request.setAttribute("groupCode", (String) request.getSession(false).getAttribute("CURRENTROLE"));
	    //System.out.println("group"+(String) request.getSession(false).getAttribute("CURRENTROLE"));
		commonService.auditLog(authentication.getPrincipal().toString(), request, "INDSTR_TRF", "OPEN", "Module Accessed");
		//System.out.println("mv = "+mv);
		return mv;
	}
	
	@RequestMapping(value = "/addNewTransactionDetailsInSTRTRF") 
	public ModelAndView addNewTransactionDetailsInSTRTRF(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication)throws Exception{
		ModelAndView mv = new ModelAndView("RegulatoryReports/India/STR_TRF/addTransactionDetails");
		String caseNo = (String)request.getSession().getAttribute("caseNo");
		String l_strAccountNo = (String)request.getAttribute("AccountNo");
		String l_strBankName = (String)request.getAttribute("BankName");
		String l_strBSRCode = (String)request.getAttribute("BSRCode");
		String l_strCallFrom = (String)request.getAttribute("CallFrom");
		String usercode = authentication.getPrincipal().toString();
		request.setAttribute("LOGGEDUSER", usercode);
	    request.setAttribute("caseNo", caseNo);
	    request.setAttribute("AccountNo", l_strAccountNo);
	    request.setAttribute("BankName", l_strBankName);
	    request.setAttribute("BSRCode", l_strBSRCode);
	    request.setAttribute("CallFrom", l_strCallFrom);
		request.setAttribute("PURPOSECODES", genericMasterService.getOptionNameValueFromView("VW_PURPOSECODE"));
		request.setAttribute("COUNTRYCODES", genericMasterService.getOptionNameValueFromView("VW_COUNTRYCODE"));
	    commonService.auditLog(authentication.getPrincipal().toString(), request, "INDSTR_TRF", "OPEN", "Module Accessed");
	    return mv;
    }
	
	@RequestMapping(value = "/getNewINDSTRTRFTransactions") 
	public ModelAndView getNewINDSTRTRFTransactions(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication)
    throws Exception
    {
		ModelAndView mv = new ModelAndView("RegulatoryReports/India/STR_TRF/addTransactionDetails");
		String caseNo = (String)request.getSession().getAttribute("caseNo");  
		String strTxnDate = request.getParameter("txnDate");
        String strtxnType = request.getParameter("txnType");
        String strIntrumentType = request.getParameter("strIntrumentType");
        String strCurrency = request.getParameter("strCurrency");
        String strAmtRupees = request.getParameter("strAmtRupees");
        String strTxnSeqNo = request.getParameter("txnSeqNo");
        HashMap hashMapDto = new HashMap(); 
        hashMapDto = INDSTRTRFService.getNewTransactionDetails(strTxnDate, strtxnType, strIntrumentType, strCurrency, strAmtRupees, caseNo, strTxnSeqNo);
        request.setAttribute("HmTxnDTO", hashMapDto);
        //System.out.println("hashMapTXNDto = "+hashMapDto);
        commonService.auditLog(authentication.getPrincipal().toString(), request, "INDSTR_TRF", "OPEN", "Module Accessed");
        return mv;
    }

	@RequestMapping(value = "/deleteNewINDSTRTRFTransactions") 
	public ModelAndView deleteNewINDSTRTRFTransactions(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication)
    throws Exception
    {
		ModelAndView mv = new ModelAndView("RegulatoryReports/India/STR_TRF/strTRFMain");
		String caseNo = (String)request.getSession().getAttribute("caseNo");  
		String userCode = authentication.getPrincipal().toString();
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String strTxnDate = request.getParameter("txnDate");
        String strtxnType = request.getParameter("txnType");
        String strIntrumentType = request.getParameter("intrumentType");
        String strCurrency = request.getParameter("currency");
        String strAmtRupees = request.getParameter("amtRupees");
        String strTxnSeqNo = request.getParameter("txnSeqNo");
        HashMap hashMapDto = new HashMap(); 
        boolean boolIsSaved = INDSTRTRFService.deleteTransactionDetails(strTxnDate, strtxnType, strIntrumentType, strCurrency, strAmtRupees, strTxnSeqNo, 
        		userCode, caseNo);
        
        HashMap l_HMINDSTRReport = INDSTRTRFService.getINDSTRTRFReport(caseNo, userCode, userRole);
        request.setAttribute("INDIANSTRTRFDETAILS", l_HMINDSTRReport);
        request.setAttribute("saved", "yes");
        request.setAttribute("IsSaved", "Yes");
        request.setAttribute("caseNo", caseNo);
        request.getSession().setAttribute("CallFrom", request.getParameter("CallFrom"));
        commonService.auditLog(authentication.getPrincipal().toString(), request, "INDSTR_TRF", "DELETE", "Data Deleted: "+boolIsSaved);
        return mv;
    }
	
	@RequestMapping(value = "/addNewBranchDetails") 
	public ModelAndView addNewLegalDetails(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication)throws Exception{
		ModelAndView mv = new ModelAndView("RegulatoryReports/India/STR_TRF/addBranchDetails");
		String caseNo = (String)request.getSession().getAttribute("caseNo");  
		String usercode = authentication.getPrincipal().toString();
		request.setAttribute("LOGGEDUSER", usercode);
	    request.setAttribute("caseNo", caseNo);
	    commonService.auditLog(authentication.getPrincipal().toString(), request, "INDSTR_TRF", "OPEN", "Module Accessed");
	    return mv;
    }
	
	@RequestMapping(value = "/getNewINDSTRTRFBranches") 
	public ModelAndView getNewINDSTRTRFBranches(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication)
    throws Exception
    {
		ModelAndView mv = new ModelAndView("RegulatoryReports/India/STR_TRF/addBranchDetails");
		String caseNo = (String)request.getSession().getAttribute("caseNo");  
		String strBranchSeqNo = request.getParameter("branchSeqNo");
		String strBranchName = request.getParameter("branchName");
        String strBranchRefNo = request.getParameter("branchRefNo");
        HashMap hashMapDto = new HashMap(); 
        hashMapDto = INDSTRTRFService.getNewBranchDetails(strBranchName, strBranchRefNo, caseNo, strBranchSeqNo);
        request.setAttribute("HmBrnDTO", hashMapDto);
        commonService.auditLog(authentication.getPrincipal().toString(), request, "INDSTR_TRF", "OPEN", "Module Accessed");
        //System.out.println("HmBrnDTO = "+hashMapDto);
        return mv;
    }

	@RequestMapping(value = "/deleteNewINDSTRTRFBranches") 
	public ModelAndView deleteNewINDSTRTRFBranches(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication)
    throws Exception
    {
		ModelAndView mv = new ModelAndView("RegulatoryReports/India/STR_TRF/strTRFMain");
		String caseNo = (String)request.getSession().getAttribute("caseNo");  
		String userCode = authentication.getPrincipal().toString();
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String strBranchName = request.getParameter("branchName");
        String strBranchRefNo = request.getParameter("branchRefNo");
        String strBranchSeqNo = request.getParameter("branchSeqNo");
        //HashMap hashMapDto = new HashMap(); 
        boolean boolIsSaved = INDSTRTRFService.deleteBranchDetails(strBranchName, strBranchRefNo, strBranchSeqNo, userCode, caseNo);
        
        HashMap l_HMINDSTRReport = INDSTRTRFService.getINDSTRTRFReport(caseNo, userCode, userRole);
        request.setAttribute("INDIANSTRTRFDETAILS", l_HMINDSTRReport);
        request.setAttribute("saved", "yes");
        request.setAttribute("IsSaved", "Yes");
        request.setAttribute("caseNo", caseNo);
        request.getSession().setAttribute("CallFrom", request.getParameter("CallFrom"));
        commonService.auditLog(authentication.getPrincipal().toString(), request, "INDSTR_TRF", "DELETE", "Data Deleted: "+boolIsSaved);
        return mv;
    }
	
	@RequestMapping(value = "/saveNewINDSTRTRFBranch") 
	public ModelAndView saveNewINDSTRTRFBranch(HttpServletRequest request, HttpServletResponse response, 
				Authentication authentication)throws Exception
	{
		ModelAndView mv = new ModelAndView("RegulatoryReports/India/STR_TRF/addBranchDetails");
		ISTRTRFBranchDetailsVO objISTRBranchDTO = new ISTRTRFBranchDetailsVO();
		String caseNo = (String)request.getSession().getAttribute("caseNo"); 
		String strBranchSeqNo = request.getParameter("branchSeqNo"); 
		//System.out.println("strBranchSeqNo = "+strBranchSeqNo);
		String usercode = authentication.getPrincipal().toString();
		String terminalId = request.getRemoteAddr();
		objISTRBranchDTO.setRepRole(request.getParameter("repRole"));
		objISTRBranchDTO.setInstituteName(request.getParameter("instituteName"));
		objISTRBranchDTO.setInstituteBranchName(request.getParameter("instituteBranchName"));
		objISTRBranchDTO.setInstituteRefNo(request.getParameter("instituteRefNo"));
		objISTRBranchDTO.setInstituteAddress(request.getParameter("instituteAddress"));
		objISTRBranchDTO.setInstituteCity(request.getParameter("instituteCity"));
		objISTRBranchDTO.setInstituteState(request.getParameter("instituteState"));
		objISTRBranchDTO.setInstituteCountry(request.getParameter("instituteCountry"));
		objISTRBranchDTO.setInstitutePin(request.getParameter("institutePin"));
		objISTRBranchDTO.setInstituteTelNo(request.getParameter("instituteTelNo"));
		objISTRBranchDTO.setInstituteMobNo(request.getParameter("instituteMobNo"));
		objISTRBranchDTO.setInstituteFaxNo(request.getParameter("instituteFaxNo"));
		objISTRBranchDTO.setInstituteEmail(request.getParameter("instituteEmail"));
		objISTRBranchDTO.setInstituteRemarks(request.getParameter("instituteRemarks"));	
			
	    boolean boolIsSaved = INDSTRTRFService.addBranchDetailsToList(caseNo, strBranchSeqNo, usercode, terminalId, objISTRBranchDTO);
	    request.setAttribute("IsSaved", "Yes");
	    commonService.auditLog(authentication.getPrincipal().toString(), request, "INDSTR_TRF", "INSERT", "Data Saved :"+boolIsSaved);
	    return mv;
    }
	   
	@RequestMapping(value = "/saveNewINDSTRTRFTransaction") 
	public ModelAndView saveNewINDSTRTRFTransaction(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication)throws Exception
    {
		ModelAndView mv = new ModelAndView("RegulatoryReports/India/STR_TRF/addTransactionDetails");
		ISTRTRFTransactionDetailsVO objISTRTransactionDTO = new ISTRTRFTransactionDetailsVO();
		String caseNo = (String)request.getSession().getAttribute("caseNo");  
		String usercode = authentication.getPrincipal().toString();
		String terminalId = request.getRemoteAddr();
		String strTxnSeqNo = request.getParameter("txnSeqNo");
		//System.out.println("strTxnSeqNo = "+strTxnSeqNo);
		objISTRTransactionDTO.setNameOfBank(request.getParameter("reportingEntity"));
        objISTRTransactionDTO.setTransactionDate(request.getParameter("transactionDate"));
        objISTRTransactionDTO.setTransactionTime(request.getParameter("transactionTime"));
        objISTRTransactionDTO.setTransactionNo(request.getParameter("transactionRefNo"));
        objISTRTransactionDTO.setTransactionType(request.getParameter("transactionType"));
        objISTRTransactionDTO.setInstrumentType(request.getParameter("instrumentType"));
        objISTRTransactionDTO.setTransactionInstitutionName(request.getParameter("transactionInstName"));
        objISTRTransactionDTO.setTransactionInstitutionRefNo(request.getParameter("transactionInstRefNo"));
        objISTRTransactionDTO.setTransactionStateCode(request.getParameter("txnStateCode"));
        objISTRTransactionDTO.setTransactionCountryCode(request.getParameter("txnCountryCode"));
        objISTRTransactionDTO.setTransactionAmount(request.getParameter("transactionAmount"));
        objISTRTransactionDTO.setTransactionAmtInForeignCurr(request.getParameter("transactionForeignCurrAmount"));
        objISTRTransactionDTO.setTransactionCurrencyCode(request.getParameter("currencyCode"));
        objISTRTransactionDTO.setPurposeOfTransaction(request.getParameter("transactionPurpose"));
        objISTRTransactionDTO.setRiskRating(request.getParameter("riskRating"));
        objISTRTransactionDTO.setPaymentInstrumentNo(request.getParameter("paymentInstrumentNo"));
        objISTRTransactionDTO.setPaymentInstrumentInstName(request.getParameter("paymentInstrumentIssueInstName"));
        objISTRTransactionDTO.setCustomerName(request.getParameter("customerName"));
        objISTRTransactionDTO.setOccupation(request.getParameter("occupation"));
        objISTRTransactionDTO.setDateOfBirth(request.getParameter("dob"));
        objISTRTransactionDTO.setGender(request.getParameter("gender"));
        objISTRTransactionDTO.setNationality(request.getParameter("nationality"));
        objISTRTransactionDTO.setIdentificationType(request.getParameter("idType"));
        objISTRTransactionDTO.setIdentificationNo(request.getParameter("idNumber"));
        objISTRTransactionDTO.setIssuingAuthority(request.getParameter("idIssuingAuthority"));
        objISTRTransactionDTO.setIssuingPlace(request.getParameter("idIssuingPlace"));
        objISTRTransactionDTO.setPanNo(request.getParameter("custPAN"));
        objISTRTransactionDTO.setUinNo(request.getParameter("custUIN"));
        objISTRTransactionDTO.setAddressLine(request.getParameter("custAddressLine"));
        objISTRTransactionDTO.setCity(request.getParameter("custCity"));
        objISTRTransactionDTO.setState(request.getParameter("stateCode"));
        objISTRTransactionDTO.setCountry(request.getParameter("countryCode"));
        objISTRTransactionDTO.setPinCode(request.getParameter("pinCode"));
        objISTRTransactionDTO.setTelephone(request.getParameter("telephone"));
        objISTRTransactionDTO.setMobile(request.getParameter("mobile"));
        objISTRTransactionDTO.setFax(request.getParameter("faxNo"));
        objISTRTransactionDTO.setEmailId(request.getParameter("emailAddress"));
        objISTRTransactionDTO.setAccountNo(request.getParameter("accountNo"));
        objISTRTransactionDTO.setAccountWithInstitutionName(request.getParameter("accountInstName"));
        objISTRTransactionDTO.setRelatedInstitutionRefNo(request.getParameter("instRefNo"));
        objISTRTransactionDTO.setRelatedInstitutionName(request.getParameter("relatedInstName"));
        objISTRTransactionDTO.setInstitutionRelationFlag(request.getParameter("relatedInstFlag"));
        objISTRTransactionDTO.setTransactionRemarks(request.getParameter("txnRemarks"));
	    boolean boolIsSaved = INDSTRTRFService.addTransactionDetailsToList(caseNo, strTxnSeqNo, usercode, terminalId, objISTRTransactionDTO);
	    request.setAttribute("IsSaved", "Yes");
	    commonService.auditLog(authentication.getPrincipal().toString(), request, "INDSTR_TRF", "INSERT", "Data Saved :"+boolIsSaved);
	   // System.out.println(mv);
	    return mv;
    }   
	
	@RequestMapping(value="/INDSTRTRFExportXML")
	public ModelAndView INDSTRTRFExportXML(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String caseNo = request.getParameter("caseNo") == null ? "" : request.getParameter("caseNo");
		String usercode = authentication.getPrincipal().toString();
		HashMap l_HMINDSTRTRFXMLFileDetails = INDSTRTRFService.getSTRTRFXMlFileContent(caseNo, usercode);
		String l_strXmlFileName = (String) l_HMINDSTRTRFXMLFileDetails.get("FILENAME");
		HashMap l_HMXMlFileContent = (HashMap) l_HMINDSTRTRFXMLFileDetails.get("FILECONTENT");
		BufferedWriter bufferedWriter = null;
		StringWriter stringWriter = null;

		try{
		/*	
		response.setHeader("Content-Disposition", "inline;filename=\"" +l_strXmlFileName+ "\"");
		response.setContentType("application/octet-stream");
        OutputStream out = response.getOutputStream();
        InputStream in = null;
        */
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
        	log.error("Error occured : "+e.getMessage());
            e.printStackTrace();
        }
        catch (Exception e) {
        	log.error("Error occured : "+e.getMessage());
            e.printStackTrace();
        }	
		commonService.auditLog(authentication.getPrincipal().toString(), request, "INDSTR", "DOWNLOAD", "File Downloaded");
        return null;
	}
	
	@RequestMapping(value = "/saveINDSTRTRFManualDetails") 
	public ModelAndView saveINDSTRTRFManualDetails(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication)
    throws Exception
    {
		ModelAndView mv = new ModelAndView("RegulatoryReports/India/STR_TRF/strTRFMain");
		String caseNo = (String)request.getSession().getAttribute("caseNo");  
		String usercode = authentication.getPrincipal().toString();
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		ISTRTRFManualDetailsVO objManualFormVO = setManualFormValues(request);
		boolean boolIsSaved = INDSTRTRFService.saveISTRTRFManualDetails(caseNo, usercode, objManualFormVO);
		if(boolIsSaved)
        {
            HashMap l_HMINDSTRTRFReport = INDSTRTRFService.getINDSTRTRFReport(caseNo, usercode,userRole);
            request.setAttribute("INDIANSTRTRFDETAILS", l_HMINDSTRTRFReport);
            request.setAttribute("saved", "yes");
            request.setAttribute("IsSaved", "Yes");
            request.setAttribute("caseNo", caseNo);
        }
		commonService.auditLog(authentication.getPrincipal().toString(), request, "INDSTR", "INSERT", "Data Saved: "+boolIsSaved);
		System.out.println("saveINDSTRTRFManualDetails = "+mv);
		return mv;
    }
	
	private ISTRTRFManualDetailsVO setManualFormValues(HttpServletRequest request)
    {
		ISTRTRFManualDetailsVO objManualFormVO = new ISTRTRFManualDetailsVO();
        try {
		String strArrayPart7susGrounds[] = new String[30];
        String strArrayPart8susGrounds[] = new String[5];
        String strArrayAlertIndicators[] = new String[3];
        String strArrayLawEnforcementAgencyDetails[] = new String[5];
        StringBuffer strBuffSuspiciousReason = new StringBuffer();
        String strTempVal = "";
        for(int i = 1; i <= 7; i++)
        {
            strTempVal = request.getParameter("suspReason" + i);
            if(strTempVal != null)
                strBuffSuspiciousReason.append(strTempVal).append(",");
        }
        objManualFormVO.setSuspReason(strBuffSuspiciousReason.toString());
        
        for(int i = 0; i < 30; i++)
        	strArrayPart7susGrounds[i] = request.getParameter("Part7susGrounds" + i);
        System.out.println("strArrayPart7susGrounds = "+strArrayPart7susGrounds);
        objManualFormVO.setSusGroundsP7(strArrayPart7susGrounds);

        for(int i = 0; i < 5; i++)
        	strArrayPart8susGrounds[i] = request.getParameter("Part8susGrounds" + i);
        System.out.println("strArrayPart8susGrounds = "+strArrayPart8susGrounds);
        objManualFormVO.setSusGroundsP8(strArrayPart8susGrounds);
        
        objManualFormVO.setMainPersonName(request.getParameter("mainPersonName"));
        objManualFormVO.setSourceOfAlert(request.getParameter("sourceOfAlert"));
        for(int i = 0; i <= 2; i++)
        	strArrayAlertIndicators[i] = request.getParameter("alertIndicators" + i);
        objManualFormVO.setAlertIndicators(strArrayAlertIndicators);
        
        StringBuffer strBuffSuspicionDueTo = new StringBuffer();
        strBuffSuspicionDueTo = strBuffSuspicionDueTo.append(request.getParameter("proceedsOfCrime")).append(",");
        strBuffSuspicionDueTo = strBuffSuspicionDueTo.append(request.getParameter("unusualComplexTransaction")).append(",");
        strBuffSuspicionDueTo = strBuffSuspicionDueTo.append(request.getParameter("noEcoRatBonPurpose")).append(",");
        strBuffSuspicionDueTo = strBuffSuspicionDueTo.append(request.getParameter("financialTerrorism"));
        System.out.println(strBuffSuspicionDueTo.toString());
        
        /*StringBuffer strBuffSuspicionDueTo = new StringBuffer();
    	for(int i = 1; i <= 4; i++)
        {
            strTempVal = request.getParameter("suspicionDueTo" + i);
            if(strTempVal != null)
            	strBuffSuspicionDueTo.append(strTempVal).append(",");
        }*/
        objManualFormVO.setSuspicionDueTo(strBuffSuspicionDueTo.toString());
        
        StringBuffer strAttemptedTransactions = new StringBuffer();
        for(int i = 1; i <= 2; i++)
        {
            strTempVal = request.getParameter("attemptedTransactions" + i);
            if(strTempVal != null)
            	strAttemptedTransactions.append(strTempVal).append(",");
        }
        objManualFormVO.setAttemptedTransactions(strAttemptedTransactions.toString());
        objManualFormVO.setPriorityRating(request.getParameter("priorityRating"));
        
        StringBuffer strReportCoverage = new StringBuffer();
        for(int i = 1; i <= 2; i++)
        {
            strTempVal = request.getParameter("reportCoverage" + i);
            if(strTempVal != null)
            	strReportCoverage.append(strTempVal).append(",");
        }
        objManualFormVO.setReportCoverage(strReportCoverage.toString());
        
        StringBuffer strAdditionalDocuments = new StringBuffer();
        for(int i = 1; i <= 2; i++)
        {
            strTempVal = request.getParameter("additionalDocuments" + i);
            if(strTempVal != null)
            	strAdditionalDocuments.append(strTempVal).append(",");
        }
        objManualFormVO.setAdditionalDocuments(strAdditionalDocuments.toString());
        
        StringBuffer strLawEnforcementInformed = new StringBuffer();
        for(int i = 1; i <= 3; i++)
        {
            strTempVal = request.getParameter("lawEnforcementInformed" + i);
            if(strTempVal != null)
            	strLawEnforcementInformed.append(strTempVal).append(",");
        }
        objManualFormVO.setLawEnforcementInformed(strLawEnforcementInformed.toString());
        
        for(int i = 0; i < 5; i++)
        	strArrayLawEnforcementAgencyDetails[i] = request.getParameter("LawEnforcementAgencyDetails" + i);
        objManualFormVO.setLawEnforcementAgencyDetails(strArrayLawEnforcementAgencyDetails);
        objManualFormVO.setSignatureName(request.getParameter("signatureName"));
        
    	objManualFormVO.setReportingEntityName(request.getParameter("reportingEntityName"));
        objManualFormVO.setReportingEntityCategory(request.getParameter("reportingEntityCategory"));
        objManualFormVO.setReportingEntityCode(request.getParameter("reportingEntityCode"));
        objManualFormVO.setReportingEntityFIUREID(request.getParameter("reportingEntityFIUREID"));
        objManualFormVO.setReportingBatchNo(request.getParameter("reportingBatchNo"));
        objManualFormVO.setReportingBatchDate(request.getParameter("reportingBatchDate"));
        objManualFormVO.setReportingBatchPertainingToMonth(request.getParameter("reportingBatchPertainingToMonth"));
        objManualFormVO.setReportingBatchPertainingToYear(request.getParameter("reportingBatchPertainingToYear"));
        objManualFormVO.setReportingBatchType(request.getParameter("reportingBatchType"));
        objManualFormVO.setReportingOriginalBatchId(request.getParameter("reportingOriginalBatchId"));
        objManualFormVO.setPrincipalOfficersName(request.getParameter("principalOfficersName"));
        objManualFormVO.setPrincipalOfficersDesignation(request.getParameter("principalOfficersDesignation"));
        objManualFormVO.setPrincipalOfficersAddress1(request.getParameter("principalOfficersAddress1"));
        objManualFormVO.setPrincipalOfficersAddress2(request.getParameter("principalOfficersAddress2"));
        objManualFormVO.setPrincipalOfficersAddress3(request.getParameter("principalOfficersAddress3"));
        objManualFormVO.setPrincipalOfficersCity(request.getParameter("principalOfficersCity"));
        objManualFormVO.setPrincipalOfficersState(request.getParameter("principalOfficersState"));
        objManualFormVO.setPrincipalOfficersCountry(request.getParameter("principalOfficersCountry"));
        objManualFormVO.setPrincipalOfficersAddressPinCode(request.getParameter("principalOfficersAddressPinCode"));
        objManualFormVO.setPrincipalOfficersTelephoneNo(request.getParameter("principalOfficersTelephoneNo"));
        objManualFormVO.setPrincipalOfficersMobileNo(request.getParameter("principalOfficersMobileNo"));
        objManualFormVO.setPrincipalOfficersFaxNo(request.getParameter("principalOfficersFaxNo"));
        objManualFormVO.setPrincipalOfficersEmailId(request.getParameter("principalOfficersEmailId"));
        }
        catch(Exception e)
        {
        	log.error("Exception in ISTRController->setManualFormValues : "+e.toString());
        	System.out.println("Exception in ISTRController->setManualFormValues : "+e.toString());
        	e.printStackTrace();
        }
        return objManualFormVO;
    }
	
	@RequestMapping(value = "/uploadTransactionInSTRTRF") 
	public ModelAndView uploadTransactionInSTRTRF(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication)throws Exception{
		ModelAndView mv = new ModelAndView("RegulatoryReports/India/STR_TRF/uploadTransactionInSTRTRF");
		String caseNo = (String)request.getSession().getAttribute("caseNo");
		System.out.println("caseNo = "+caseNo);
		String usercode = authentication.getPrincipal().toString();
		request.setAttribute("LOGGEDUSER", usercode);
	    request.setAttribute("caseNo", caseNo);
	    
	    commonService.auditLog(authentication.getPrincipal().toString(), request, "INDSTR_TRF", "OPEN", "Module Accessed");
	    return mv;
    }
	
	@RequestMapping(value = "/uploadINDSTRTRFTransactionsFile")
	public ModelAndView uploadINDSTRTRFTransactionsFile(MultipartHttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception {
		ModelAndView mv = new ModelAndView("RegulatoryReports/India/STR_TRF/uploadTransactionInSTRTRF");
		String message = "";
		String userCode = authentication.getPrincipal().toString();
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String ipAddress = request.getRemoteAddr();
		
		String caseNo = request.getParameter("caseNo");
		
		BufferedOutputStream stream = null;
		
		/*System.out.println("caseNo : "+caseNo);
		System.out.println("transactionFilePath : "+transactionFilePath);
		
		ApplicationProperties appProperties = ApplicationProperties.getInstance();
		String TRANSACTIONFILESPATH = appProperties.getProperty("TransactionFilePath");
		*/
		//String TRANSACTIONFILESPATH = "C:\\APPFOLDER\\TransactionFile";
		String TRANSACTIONFILESPATH = transactionFilePath;
		String uploadPath = TRANSACTIONFILESPATH+caseNo;
		//System.out.println(uploadPath);
		try {
		File folderName = new File(uploadPath);
		if(!folderName.exists()){
			folderName.mkdirs();
		}
		
		Iterator<String> itrator = request.getFileNames();
		MultipartFile multiFile = request.getFile(itrator.next());
		//System.out.println("multiFile:  "+multiFile);
		String fileName = multiFile.getOriginalFilename();
		//System.out.println("fileName:  "+fileName);
		
		byte[] bytes = multiFile.getBytes();
        String fullFilePath = uploadPath + File.separator + fileName;
        //System.out.println("fullFilePath = "+fullFilePath);
        File file = new File(uploadPath + File.separator + fileName);
        //System.out.println("file = "+file);
        //System.out.println("existing = "+file.exists());
        if(file.exists()){
        	//mv.addObject("message", "Couldn't upload the file as another file with the same name is already exists. Change this file name or try another");
        	message = "Couldn't upload the file as another file with the same name is already exists. Change this file name or try another";
        	request.setAttribute("message", message);
        	request.setAttribute("IsSaved", "No");
        }else{
            stream = new BufferedOutputStream(new FileOutputStream(file));
            stream.write(bytes);
            stream.close();
        	boolean res = INDSTRTRFService.saveSTRTRFTransactionFile(caseNo, fullFilePath, file, userCode, userRole, ipAddress);      
        	
			if(res){
				//mv.addObject("message", "File is Uploaded Successfully");
				message = "File is Uploaded Successfully";
				request.setAttribute("message", message);
				request.setAttribute("IsSaved", "Yes");
			}else{
				//mv.addObject("message", "Error occurred during file upload");
				message = "Error occurred during file upload";
				request.setAttribute("message", message);
				request.setAttribute("IsSaved", "No");
			}
        }
	    } catch (Exception e) {
	    	//mv.addObject("message", "Exception occured during file upload");
	    	message = "Exception occured during file upload";
	    	request.setAttribute("message", message);
	    	request.setAttribute("IsSaved", "No");
	        e.printStackTrace();
	    }
		commonService.auditLog(authentication.getPrincipal().toString(), request, "INDSTR_TRF", "INSERT", "File Uploaded");
		
		/*System.out.println("message = "+message);
		System.out.println("mv = "+mv);
		*/
		return mv;
	}

	@RequestMapping(value = "/addNewIndividualDetailsInSTRTRF") 
	public ModelAndView addNewIndividualDetailsInSTRTRF(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication)throws Exception{
		ModelAndView mv = new ModelAndView("RegulatoryReports/India/STR_TRF/addIndividualDetails");
		String caseNo = (String)request.getSession().getAttribute("caseNo");
		String l_strAccountNo = (String)request.getAttribute("AccountNo");
		String l_strBankName = (String)request.getAttribute("BankName");
		String l_strBSRCode = (String)request.getAttribute("BSRCode");
		String l_strCallFrom = (String)request.getAttribute("CallFrom");
		String usercode = authentication.getPrincipal().toString();
		request.setAttribute("LOGGEDUSER", usercode);
	    request.setAttribute("caseNo", caseNo);
	    request.setAttribute("AccountNo", l_strAccountNo);
	    request.setAttribute("BankName", l_strBankName);
	    request.setAttribute("BSRCode", l_strBSRCode);
	    request.setAttribute("CallFrom", l_strCallFrom);
	    
	    commonService.auditLog(authentication.getPrincipal().toString(), request, "INDSTR_TRF", "OPEN", "Module Accessed");
	    return mv;
    }
	
	@RequestMapping(value = "/getNewINDSTRTRFIndividuals") 
	public ModelAndView getNewINDSTRTRFIndividuals(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication)
    throws Exception
    {
		ModelAndView mv = new ModelAndView("RegulatoryReports/India/STR_TRF/addIndividualDetails");
		String caseNo = (String)request.getSession().getAttribute("caseNo");  
		String strTxnDate = request.getParameter("txnDate");
        String strtxnType = request.getParameter("txnType");
        String strIntrumentType = request.getParameter("strIntrumentType");
        String strCurrency = request.getParameter("strCurrency");
        String strAmtRupees = request.getParameter("strAmtRupees");
        String strTxnSeqNo = request.getParameter("txnSeqNo");
        HashMap hashMapDto = new HashMap(); 
        //hashMapDto = INDSTRTRFService.getNewIndividualDetails(strTxnDate, strtxnType, strIntrumentType, strCurrency, strAmtRupees, caseNo, strTxnSeqNo);
        request.setAttribute("HmTxnDTO", hashMapDto);
        //System.out.println("hashMapTXNDto = "+hashMapDto);
        commonService.auditLog(authentication.getPrincipal().toString(), request, "INDSTR_TRF", "OPEN", "Module Accessed");
        return mv;
    }

	@RequestMapping(value = "/addNewLegalDetailsInSTRTRF") 
	public ModelAndView addNewLegalDetailsInSTRTRF(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication)throws Exception{
		ModelAndView mv = new ModelAndView("RegulatoryReports/India/STR_TRF/addLegalDetails");
		String caseNo = (String)request.getSession().getAttribute("caseNo");
		String l_strAccountNo = (String)request.getAttribute("AccountNo");
		String l_strBankName = (String)request.getAttribute("BankName");
		String l_strBSRCode = (String)request.getAttribute("BSRCode");
		String l_strCallFrom = (String)request.getAttribute("CallFrom");
		String usercode = authentication.getPrincipal().toString();
		request.setAttribute("LOGGEDUSER", usercode);
	    request.setAttribute("caseNo", caseNo);
	    request.setAttribute("AccountNo", l_strAccountNo);
	    request.setAttribute("BankName", l_strBankName);
	    request.setAttribute("BSRCode", l_strBSRCode);
	    request.setAttribute("CallFrom", l_strCallFrom);
	    
	    commonService.auditLog(authentication.getPrincipal().toString(), request, "INDSTR_TRF", "OPEN", "Module Accessed");
	    return mv;
    }
	
	@RequestMapping(value = "/saveNewINDSTRTRFIndividuals") 
	public ModelAndView saveNewINDSTRTRFIndividuals(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception
    {
		ModelAndView mv = new ModelAndView("RegulatoryReports/India/STR_TRF/addIndividualDetails");
		String caseNo = (String)request.getSession().getAttribute("caseNo");  
		String usercode = authentication.getPrincipal().toString();
		
		String terminalId = request.getRemoteAddr();
		
		ISTRTRFIndividualDetailsVO objISTRTRFIndiDtlsDTO = new ISTRTRFIndividualDetailsVO();
		objISTRTRFIndiDtlsDTO.setNameOfBank(request.getParameter("repBranchName"));
	    objISTRTRFIndiDtlsDTO.setFullName(request.getParameter("customerFullName"));
	    objISTRTRFIndiDtlsDTO.setCustomerId(request.getParameter("customerId"));
	    objISTRTRFIndiDtlsDTO.setAccountNo(request.getParameter("accountNo"));
	    objISTRTRFIndiDtlsDTO.setRelationFlag(request.getParameter("individualRelationFlag"));
	    objISTRTRFIndiDtlsDTO.setFatherName(request.getParameter("fatherName"));
	    objISTRTRFIndiDtlsDTO.setOccupation(request.getParameter("occupationDescription"));
	    objISTRTRFIndiDtlsDTO.setDob(request.getParameter("dateOfBirth"));
	    objISTRTRFIndiDtlsDTO.setSex(request.getParameter("sexOfIndividual"));
	    objISTRTRFIndiDtlsDTO.setNationality(request.getParameter("nationality"));
	    objISTRTRFIndiDtlsDTO.setIdDoc(request.getParameter("identificationDocumentType"));
	    objISTRTRFIndiDtlsDTO.setIdNumber(request.getParameter("identificationNumber"));
	    objISTRTRFIndiDtlsDTO.setIssuingAuth(request.getParameter("issuingAuthority"));
	    objISTRTRFIndiDtlsDTO.setPlaceOfIssue(request.getParameter("placeOfIssue"));
	    objISTRTRFIndiDtlsDTO.setPanNo(request.getParameter("panIdNo"));
	    objISTRTRFIndiDtlsDTO.setUinNo(request.getParameter("UINumber"));
	    objISTRTRFIndiDtlsDTO.setAddEmployername(request.getParameter("placeOfWork"));
	    objISTRTRFIndiDtlsDTO.setAddBuildingNo(request.getParameter("commAddressLine1"));
	    objISTRTRFIndiDtlsDTO.setAddStreet(request.getParameter("commAddressLine2"));
	    objISTRTRFIndiDtlsDTO.setAddLocality(request.getParameter("commAddressLine3"));
	    objISTRTRFIndiDtlsDTO.setAddCity(request.getParameter("commAddressCity"));
	    objISTRTRFIndiDtlsDTO.setAddState(request.getParameter("commAddressState"));
	    objISTRTRFIndiDtlsDTO.setAddCountry(request.getParameter("commAddressCountry"));
	    objISTRTRFIndiDtlsDTO.setAddPinCode(request.getParameter("commAddressPinCode"));
	    objISTRTRFIndiDtlsDTO.setAddTelNo(request.getParameter("commAddressTelephoneNo"));
	    objISTRTRFIndiDtlsDTO.setAddMobileNo(request.getParameter("commAddressMobileNo"));
	    objISTRTRFIndiDtlsDTO.setAddFaxNo(request.getParameter("commAddressFaxNo"));
	    objISTRTRFIndiDtlsDTO.setAddEmail(request.getParameter("commAddressEmailId"));
	    objISTRTRFIndiDtlsDTO.setSecaddBuildingNo(request.getParameter("secAddressLine1"));
	    objISTRTRFIndiDtlsDTO.setSecaddStreet(request.getParameter("secAddressLine2"));
	    objISTRTRFIndiDtlsDTO.setSecaddLocality(request.getParameter("secAddressLine3"));
	    objISTRTRFIndiDtlsDTO.setSecaddCity(request.getParameter("secAddressCity"));
	    objISTRTRFIndiDtlsDTO.setSecaddState(request.getParameter("secAddressState"));
	    objISTRTRFIndiDtlsDTO.setSecaddCountry(request.getParameter("secAddressCountry"));
	    objISTRTRFIndiDtlsDTO.setSecaddPinCode(request.getParameter("secAddressPinCode"));
	    objISTRTRFIndiDtlsDTO.setSecaddTelNo(request.getParameter("secAddressTelephoneNo"));
	    String strAccountNo = request.getParameter("AccountNo");
	    String strRelationFlag = request.getParameter("RelationFlag");
	    String strCounterAccountNo = request.getParameter("CounterAccountNo");
	    String strCounterId = request.getParameter("CounterId");
	    String strCounterName = request.getParameter("CounterName");
	    String strBSRCode = request.getParameter("BSRCode");
	    
	    boolean boolIsSaved = INDSTRTRFService.addIndividualDetailsToList(caseNo, usercode, terminalId, strAccountNo, strRelationFlag, strCounterAccountNo, strCounterId, strCounterName, strBSRCode, objISTRTRFIndiDtlsDTO);
	    request.setAttribute("IsSaved", "Yes");
	    commonService.auditLog(authentication.getPrincipal().toString(), request, "INDSTR_TRF", "INSERT", "Data Saved :"+boolIsSaved);
	    return mv;
    }
	
	@RequestMapping(value = "/saveNewINDSTRTRFEntity") 
	public ModelAndView saveNewINDSTRTRFEntity(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception
    {
		ModelAndView mv = new ModelAndView("RegulatoryReports/India/STR_TRF/addLegalDetails");
		ISTRTRFEntityDetailsVO objISTRTRFLegalsDTO = new ISTRTRFEntityDetailsVO();
		String caseNo = (String)request.getSession().getAttribute("caseNo");  
		String usercode = authentication.getPrincipal().toString();
		String terminalId = request.getRemoteAddr();
		objISTRTRFLegalsDTO.setNameOfBank(request.getParameter("repBranchName"));
	    objISTRTRFLegalsDTO.setNameOfLegalPerson(request.getParameter("repNameOfEntity"));
	    objISTRTRFLegalsDTO.setCustomerID(request.getParameter("repCustomerId"));
	    objISTRTRFLegalsDTO.setAccountNo(request.getParameter("accountNo"));
	    objISTRTRFLegalsDTO.setLegalRelationFlag(request.getParameter("repLegalRelationFlag"));
	    objISTRTRFLegalsDTO.setNatureOfBusiness(request.getParameter("repNatureOfBusiness"));
	    objISTRTRFLegalsDTO.setIncorporationDate(request.getParameter("repDateOfIncorporation"));
	    objISTRTRFLegalsDTO.setConstitutionType(request.getParameter("typeOfConstitution"));
	    objISTRTRFLegalsDTO.setRegistrarionNumber(request.getParameter("repRegistrarionNumber"));
	    objISTRTRFLegalsDTO.setRegisteringAuth(request.getParameter("repRegisteringAuthority"));
	    objISTRTRFLegalsDTO.setRegisteringPlace(request.getParameter("repPlaceOfRegistration"));
	    objISTRTRFLegalsDTO.setPanNo(request.getParameter("repPanIdNo"));
	    objISTRTRFLegalsDTO.setUinNO(request.getParameter("repUINNO"));
	    objISTRTRFLegalsDTO.setAddBuildingNo(request.getParameter("repAddressLine1"));
	    objISTRTRFLegalsDTO.setAddStreet(request.getParameter("repAddressLine2"));
	    objISTRTRFLegalsDTO.setAddLocality(request.getParameter("repAddressLine3"));
	    objISTRTRFLegalsDTO.setAddCity(request.getParameter("repAddressCity"));
	    objISTRTRFLegalsDTO.setAddState(request.getParameter("repAddressState"));
	    objISTRTRFLegalsDTO.setAddCountry(request.getParameter("repAddressCountry"));
	    objISTRTRFLegalsDTO.setAddPinCode(request.getParameter("repAddressPinCode"));
	    objISTRTRFLegalsDTO.setAddTelNo(request.getParameter("repAddressTelephoneNo"));
	    objISTRTRFLegalsDTO.setAddMobilNo(request.getParameter("repAddressMobileNo"));
	    objISTRTRFLegalsDTO.setAddFaxNo(request.getParameter("repAddressFaxNo"));
	    objISTRTRFLegalsDTO.setAddEmail(request.getParameter("repAddressEMailAddress"));
	    objISTRTRFLegalsDTO.setSecaddBuildingNo(request.getParameter("repSecAddressLine1"));
	    objISTRTRFLegalsDTO.setSecaddStreet(request.getParameter("repSecAddressLine2"));
	    objISTRTRFLegalsDTO.setSecaddLocality(request.getParameter("repSecAddressLine3"));
	    objISTRTRFLegalsDTO.setSecaddCity(request.getParameter("repSecAddressCity"));
	    objISTRTRFLegalsDTO.setSecaddState(request.getParameter("repSecAddressState"));
	    objISTRTRFLegalsDTO.setSecaddCountry(request.getParameter("repSecAddressCountry"));
	    objISTRTRFLegalsDTO.setSecaddPinCode(request.getParameter("repSecAddressPinCode"));
	    objISTRTRFLegalsDTO.setSecaddTelNo(request.getParameter("repSecAddressTelephoneNo"));
	    objISTRTRFLegalsDTO.setSecaddFaxNo(request.getParameter("repSecAddressFaxNo"));
	    String strAccountNo = request.getParameter("AccountNo");
	    String strRelationFlag = request.getParameter("RelationFlag");
	    String strLegalAccountNo = request.getParameter("LegalAccountNo");
	    String strLegalCustomerID = request.getParameter("LegalCustomerID");
	    String strLegalPersonName = request.getParameter("LegalPersonName");
	    String strLegalBSRCode = request.getParameter("LegalBSRCode");
	    boolean boolIsSaved = INDSTRTRFService.addEntityDetailsToList(caseNo, usercode, terminalId, strAccountNo, 
	    		strRelationFlag, strLegalAccountNo, strLegalCustomerID, strLegalPersonName, strLegalBSRCode, objISTRTRFLegalsDTO);
	    request.setAttribute("IsSaved", "Yes");
	    commonService.auditLog(authentication.getPrincipal().toString(), request, "INDSTR_TRF", "INSERT", "Data Saved :"+boolIsSaved);
	    return mv;
    }
}

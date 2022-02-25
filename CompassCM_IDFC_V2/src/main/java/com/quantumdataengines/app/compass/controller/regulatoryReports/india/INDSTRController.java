package com.quantumdataengines.app.compass.controller.regulatoryReports.india;

import java.io.BufferedOutputStream;
import java.io.BufferedWriter;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.StringWriter;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import oracle.net.aso.b;

import org.apache.commons.fileupload.DiskFileUpload;
import org.apache.commons.fileupload.FileItem;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.view.RedirectView;

import com.quantumdataengines.app.compass.controller.reports.ExcelView;
import com.quantumdataengines.app.compass.controller.reports.MultiSheetExcelView;
import com.quantumdataengines.app.compass.controller.reports.PdfView;
import com.quantumdataengines.app.compass.model.regulatoryReports.india.ISTRAccountDetailsVO;
import com.quantumdataengines.app.compass.model.regulatoryReports.india.ISTREntityDetailsVO;
import com.quantumdataengines.app.compass.model.regulatoryReports.india.ISTRIndividualDetailsVO;
import com.quantumdataengines.app.compass.model.regulatoryReports.india.ISTRManualDetailsVO;
import com.quantumdataengines.app.compass.service.CommonService;
import com.quantumdataengines.app.compass.service.regulatoryReports.india.INDSTRService;
// import com.quantumdataengines.utilities.ApplicationProperties;

@Controller
@RequestMapping(value="/common")
public class INDSTRController {
	private Logger log = LoggerFactory.getLogger(INDSTRController.class);
	@Autowired
	private INDSTRService INDSTRService;
	@Autowired
	private CommonService commonService;
	@Value("${compass.aml.paths.transactionFilePath}")
	private String transactionFilePath;

	
	@RequestMapping(value = "/addNewIndividualDetails") 
	public ModelAndView addNewIndividualDetails(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication)
    throws Exception
    {
	ModelAndView mv = new ModelAndView("RegulatoryReports/India/STR/addIndividualDetails");
	String caseNo = (String)request.getSession().getAttribute("caseNo");  
	String usercode = authentication.getPrincipal().toString();
	request.setAttribute("LOGGEDUSER", usercode);
    request.setAttribute("caseNo", caseNo);
    commonService.auditLog(authentication.getPrincipal().toString(), request, "INDSTR", "OPEN", "Module Accessed");
    return mv;
    }
	
	@RequestMapping(value = "/saveNewINDSTRIndividuals") 
	public ModelAndView saveNewINDSTRIndividuals(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication)
    throws Exception
    {
	ModelAndView mv = new ModelAndView("RegulatoryReports/India/STR/addIndividualDetails");
	String caseNo = (String)request.getSession().getAttribute("caseNo");  
	String usercode = authentication.getPrincipal().toString();
	
	String terminalId = request.getRemoteAddr();
	
	ISTRIndividualDetailsVO objISTRIndiDtlsDTO = new ISTRIndividualDetailsVO();
	objISTRIndiDtlsDTO.setNameOfBank(request.getParameter("repBranchName"));
    objISTRIndiDtlsDTO.setFullName(request.getParameter("customerFullName"));
    objISTRIndiDtlsDTO.setCustomerId(request.getParameter("customerId"));
    objISTRIndiDtlsDTO.setAccountNo(request.getParameter("accountNo"));
    objISTRIndiDtlsDTO.setRelationFlag(request.getParameter("individualRelationFlag"));
    objISTRIndiDtlsDTO.setFatherName(request.getParameter("fatherName"));
    objISTRIndiDtlsDTO.setOccupation(request.getParameter("occupationDescription"));
    objISTRIndiDtlsDTO.setDob(request.getParameter("dateOfBirth"));
    objISTRIndiDtlsDTO.setSex(request.getParameter("sexOfIndividual"));
    objISTRIndiDtlsDTO.setNationality(request.getParameter("nationality"));
    objISTRIndiDtlsDTO.setIdDoc(request.getParameter("identificationDocumentType"));
    objISTRIndiDtlsDTO.setIdNumber(request.getParameter("identificationNumber"));
    objISTRIndiDtlsDTO.setIssuingAuth(request.getParameter("issuingAuthority"));
    objISTRIndiDtlsDTO.setPlaceOfIssue(request.getParameter("placeOfIssue"));
    objISTRIndiDtlsDTO.setPanNo(request.getParameter("panIdNo"));
    objISTRIndiDtlsDTO.setUinNo(request.getParameter("UINumber"));
    objISTRIndiDtlsDTO.setAddEmployername(request.getParameter("placeOfWork"));
    objISTRIndiDtlsDTO.setAddBuildingNo(request.getParameter("commAddressLine1"));
    objISTRIndiDtlsDTO.setAddStreet(request.getParameter("commAddressLine2"));
    objISTRIndiDtlsDTO.setAddLocality(request.getParameter("commAddressLine3"));
    objISTRIndiDtlsDTO.setAddCity(request.getParameter("commAddressCity"));
    objISTRIndiDtlsDTO.setAddState(request.getParameter("commAddressState"));
    objISTRIndiDtlsDTO.setAddCountry(request.getParameter("commAddressCountry"));
    objISTRIndiDtlsDTO.setAddPinCode(request.getParameter("commAddressPinCode"));
    objISTRIndiDtlsDTO.setAddTelNo(request.getParameter("commAddressTelephoneNo"));
    objISTRIndiDtlsDTO.setAddMobileNo(request.getParameter("commAddressMobileNo"));
    objISTRIndiDtlsDTO.setAddFaxNo(request.getParameter("commAddressFaxNo"));
    objISTRIndiDtlsDTO.setAddEmail(request.getParameter("commAddressEmailId"));
    objISTRIndiDtlsDTO.setSecaddBuildingNo(request.getParameter("secAddressLine1"));
    objISTRIndiDtlsDTO.setSecaddStreet(request.getParameter("secAddressLine2"));
    objISTRIndiDtlsDTO.setSecaddLocality(request.getParameter("secAddressLine3"));
    objISTRIndiDtlsDTO.setSecaddCity(request.getParameter("secAddressCity"));
    objISTRIndiDtlsDTO.setSecaddState(request.getParameter("secAddressState"));
    objISTRIndiDtlsDTO.setSecaddCountry(request.getParameter("secAddressCountry"));
    objISTRIndiDtlsDTO.setSecaddPinCode(request.getParameter("secAddressPinCode"));
    objISTRIndiDtlsDTO.setSecaddTelNo(request.getParameter("secAddressTelephoneNo"));
    String strAccountNo = request.getParameter("AccountNo");
    String strRelationFlag = request.getParameter("RelationFlag");
    String strCounterAccountNo = request.getParameter("CounterAccountNo");
    String strCounterId = request.getParameter("CounterId");
    String strCounterName = request.getParameter("CounterName");
    String strBSRCode = request.getParameter("BSRCode");
    
    boolean boolIsSaved = INDSTRService.addIndividualDetailsToList(caseNo, usercode, terminalId, strAccountNo, strRelationFlag, strCounterAccountNo, strCounterId, strCounterName, strBSRCode, objISTRIndiDtlsDTO);
    request.setAttribute("IsSaved", "Yes");
    commonService.auditLog(authentication.getPrincipal().toString(), request, "INDSTR", "INSERT", "Data Saved :"+boolIsSaved);
    return mv;
    }
	
	@RequestMapping(value = "/addNewLegalDetails") 
	public ModelAndView addNewLegalDetails(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication)
    throws Exception
    {
	ModelAndView mv = new ModelAndView("RegulatoryReports/India/STR/addLegalDetails");
	String caseNo = (String)request.getSession().getAttribute("caseNo");  
	String usercode = authentication.getPrincipal().toString();
	request.setAttribute("LOGGEDUSER", usercode);
    request.setAttribute("caseNo", caseNo);
    commonService.auditLog(authentication.getPrincipal().toString(), request, "INDSTR", "OPEN", "Module Accessed");
    return mv;
    }
	
	@RequestMapping(value = "/saveNewINDSTREntity") 
	public ModelAndView saveNewINDSTREntity(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication)
    throws Exception
    {
	ModelAndView mv = new ModelAndView("RegulatoryReports/India/STR/addLegalDetails");
	ISTREntityDetailsVO objISTRLegalsDTO = new ISTREntityDetailsVO();
	String caseNo = (String)request.getSession().getAttribute("caseNo");  
	String usercode = authentication.getPrincipal().toString();
	String terminalId = request.getRemoteAddr();
	objISTRLegalsDTO.setNameOfBank(request.getParameter("repBranchName"));
    objISTRLegalsDTO.setNameOfLegalPerson(request.getParameter("repNameOfEntity"));
    objISTRLegalsDTO.setCustomerID(request.getParameter("repCustomerId"));
    objISTRLegalsDTO.setAccountNo(request.getParameter("accountNo"));
    objISTRLegalsDTO.setLegalRelationFlag(request.getParameter("repLegalRelationFlag"));
    objISTRLegalsDTO.setNatureOfBusiness(request.getParameter("repNatureOfBusiness"));
    objISTRLegalsDTO.setIncorporationDate(request.getParameter("repDateOfIncorporation"));
    objISTRLegalsDTO.setConstitutionType(request.getParameter("typeOfConstitution"));
    objISTRLegalsDTO.setRegistrarionNumber(request.getParameter("repRegistrarionNumber"));
    objISTRLegalsDTO.setRegisteringAuth(request.getParameter("repRegisteringAuthority"));
    objISTRLegalsDTO.setRegisteringPlace(request.getParameter("repPlaceOfRegistration"));
    objISTRLegalsDTO.setPanNo(request.getParameter("repPanIdNo"));
    objISTRLegalsDTO.setUinNO(request.getParameter("repUINNO"));
    objISTRLegalsDTO.setAddBuildingNo(request.getParameter("repAddressLine1"));
    objISTRLegalsDTO.setAddStreet(request.getParameter("repAddressLine2"));
    objISTRLegalsDTO.setAddLocality(request.getParameter("repAddressLine3"));
    objISTRLegalsDTO.setAddCity(request.getParameter("repAddressCity"));
    objISTRLegalsDTO.setAddState(request.getParameter("repAddressState"));
    objISTRLegalsDTO.setAddCountry(request.getParameter("repAddressCountry"));
    objISTRLegalsDTO.setAddPinCode(request.getParameter("repAddressPinCode"));
    objISTRLegalsDTO.setAddTelNo(request.getParameter("repAddressTelephoneNo"));
    objISTRLegalsDTO.setAddMobilNo(request.getParameter("repAddressMobileNo"));
    objISTRLegalsDTO.setAddFaxNo(request.getParameter("repAddressFaxNo"));
    objISTRLegalsDTO.setAddEmail(request.getParameter("repAddressEMailAddress"));
    objISTRLegalsDTO.setSecaddBuildingNo(request.getParameter("repSecAddressLine1"));
    objISTRLegalsDTO.setSecaddStreet(request.getParameter("repSecAddressLine2"));
    objISTRLegalsDTO.setSecaddLocality(request.getParameter("repSecAddressLine3"));
    objISTRLegalsDTO.setSecaddCity(request.getParameter("repSecAddressCity"));
    objISTRLegalsDTO.setSecaddState(request.getParameter("repSecAddressState"));
    objISTRLegalsDTO.setSecaddCountry(request.getParameter("repSecAddressCountry"));
    objISTRLegalsDTO.setSecaddPinCode(request.getParameter("repSecAddressPinCode"));
    objISTRLegalsDTO.setSecaddTelNo(request.getParameter("repSecAddressTelephoneNo"));
    objISTRLegalsDTO.setSecaddFaxNo(request.getParameter("repSecAddressFaxNo"));
    String strAccountNo = request.getParameter("AccountNo");
    String strRelationFlag = request.getParameter("RelationFlag");
    String strLegalAccountNo = request.getParameter("LegalAccountNo");
    String strLegalCustomerID = request.getParameter("LegalCustomerID");
    String strLegalPersonName = request.getParameter("LegalPersonName");
    String strLegalBSRCode = request.getParameter("LegalBSRCode");
    boolean boolIsSaved = INDSTRService.addEntityDetailsToList(caseNo, usercode, terminalId, strAccountNo, 
    		strRelationFlag, strLegalAccountNo, strLegalCustomerID, strLegalPersonName, strLegalBSRCode, objISTRLegalsDTO);
    request.setAttribute("IsSaved", "Yes");
    commonService.auditLog(authentication.getPrincipal().toString(), request, "INDSTR", "INSERT", "Data Saved :"+boolIsSaved);
    return mv;
    }
	
	@RequestMapping(value = "/addNewAccountDetails") 
	public ModelAndView addNewAccountDetails(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication)
    throws Exception
    {
	ModelAndView mv = new ModelAndView("RegulatoryReports/India/STR/addAccountDetails");
	String caseNo = (String)request.getSession().getAttribute("caseNo");  
	String usercode = authentication.getPrincipal().toString();
	request.setAttribute("LOGGEDUSER", usercode);
    request.setAttribute("caseNo", caseNo);
    commonService.auditLog(authentication.getPrincipal().toString(), request, "INDSTR", "OPEN", "Module Accessed");
    return mv;
    }
	
	@RequestMapping(value = "/saveNewINDSTRAccount") 
	public ModelAndView saveNewINDSTRAccount(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication)
    throws Exception
    {
	ModelAndView mv = new ModelAndView("RegulatoryReports/India/STR/addAccountDetails");
	ISTRAccountDetailsVO objISTRAccountsDTO = new ISTRAccountDetailsVO();
	String caseNo = (String)request.getSession().getAttribute("caseNo");  
	String usercode = authentication.getPrincipal().toString();
	String terminalId = request.getRemoteAddr();
	ISTRAccountDetailsVO objISTRAccountDetailsVO = new ISTRAccountDetailsVO();
	objISTRAccountDetailsVO.setBankName(request.getParameter("repBankName"));
	objISTRAccountDetailsVO.setBranchName(request.getParameter("repBranchName"));
	objISTRAccountDetailsVO.setBranchReferenceNumberType(request.getParameter("repBranchReferenceNumberType"));
	objISTRAccountDetailsVO.setBranchBsrCode(request.getParameter("repBranchReferenceNumber"));
	objISTRAccountDetailsVO.setBranchAddressLine1(request.getParameter("repBranchBuildingNo"));
	objISTRAccountDetailsVO.setBranchAddressLine2(request.getParameter("repBranchStreet"));
	objISTRAccountDetailsVO.setBranchAddressLine3(request.getParameter("repBranchLocality"));
	objISTRAccountDetailsVO.setBranchCity(request.getParameter("repBranchCity"));
	objISTRAccountDetailsVO.setBranchState(request.getParameter("repBranchState"));
	objISTRAccountDetailsVO.setBranchCountry(request.getParameter("repBranchCountry"));
	objISTRAccountDetailsVO.setBranchPinCode(request.getParameter("repBranchPincode"));
	objISTRAccountDetailsVO.setBranchTelephoneNo(request.getParameter("repBranchTelephoneNo"));
	objISTRAccountDetailsVO.setBranchMobileNo(request.getParameter("repBranchMobile"));
	objISTRAccountDetailsVO.setBranchFaxNo(request.getParameter("repBranchFaxNo"));
	objISTRAccountDetailsVO.setBranchEmailId(request.getParameter("repBranchEmail"));
	objISTRAccountDetailsVO.setAccountNo(request.getParameter("repAccountNo"));
	objISTRAccountDetailsVO.setAccountHolderName(request.getParameter("repAccountHolderName"));
	objISTRAccountDetailsVO.setAccountType(request.getParameter("repAccountType"));
	objISTRAccountDetailsVO.setAccountHoldertype(request.getParameter("repAccountHolderType"));
	objISTRAccountDetailsVO.setAccountOpenDate(request.getParameter("repAccountOpenDate"));
	objISTRAccountDetailsVO.setAccountStatus(request.getParameter("repAccountStatus"));
	objISTRAccountDetailsVO.setAccountTotalCredit(request.getParameter("repAccountTotalCredit"));
	objISTRAccountDetailsVO.setAccountTotalDebit(request.getParameter("repAccountTotalDebit"));
	objISTRAccountDetailsVO.setAccountTotalCashCredit(request.getParameter("repAccountTotalCashCredit"));
	objISTRAccountDetailsVO.setAccountTotalCashDebit(request.getParameter("repAccountTotalCashDebit"));
	objISTRAccountDetailsVO.setAccountRiskCategory(request.getParameter("repAccountRiskCategory"));
    String strAccountNo = request.getParameter("AccountNo");
    String strRelationFlag = request.getParameter("RiskCategory");
    boolean boolIsSaved = INDSTRService.addAccountDetailsToList(caseNo, usercode, terminalId, strAccountNo, objISTRAccountDetailsVO);
    request.setAttribute("IsSaved", "Yes");
    commonService.auditLog(authentication.getPrincipal().toString(), request, "INDSTR", "INSERT", "Data Saved :"+boolIsSaved);
    return mv;
    }
	
	@RequestMapping(value = "/addNewTransactionDetails") 
	public ModelAndView addNewTransactionDetails(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication)
    throws Exception
    {
	ModelAndView mv = new ModelAndView("RegulatoryReports/India/STR/addTransactionDetails");
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
    commonService.auditLog(authentication.getPrincipal().toString(), request, "INDSTR", "OPEN", "Module Accessed");
    return mv;
    }
	
	@RequestMapping(value = "/saveNewINDSTRTransaction") 
	public ModelAndView saveNewINDSTRTransaction(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication)
    throws Exception
    {
	ModelAndView mv = new ModelAndView("RegulatoryReports/India/STR/addTransactionDetails");
	ISTRAccountDetailsVO objISTRAccountsDTO = new ISTRAccountDetailsVO();
    String caseNo = (String)request.getSession().getAttribute("caseNo");  
    String usercode = authentication.getPrincipal().toString();
	String terminalId = request.getRemoteAddr();
	String strTransactionNo = request.getParameter("TransactionNo");
	objISTRAccountsDTO.setNameOfBank(request.getParameter("NameOfBank"));
    objISTRAccountsDTO.setBSRcode(request.getParameter("BSRCode"));
    objISTRAccountsDTO.setAccountNo(request.getParameter("AccountNo"));
    objISTRAccountsDTO.setTransactionNo(request.getParameter("TransactionNo"));
    //objISTRAccountsDTO.setTransactiondetailsdate(request.getParameter("chTransactionDate1") + request.getParameter("chTransactionDate2") + request.getParameter("chTransactionDate3") + request.getParameter("chTransactionDate4") + request.getParameter("chTransactionDate5") + request.getParameter("chTransactionDate6") + request.getParameter("chTransactionDate7") + request.getParameter("chTransactionDate8"));
    objISTRAccountsDTO.setTransactiondetailsdate(request.getParameter("chTransactionDate"));
    objISTRAccountsDTO.setTransactiondetailsmode(request.getParameter("ModeOfTransaction"));
    objISTRAccountsDTO.setTransactiondetailsDebit(request.getParameter("DebitCredit"));
    //objISTRAccountsDTO.setTransactiondetailsAmount(request.getParameter("chTranAmount1") + request.getParameter("chTranAmount2") + request.getParameter("chTranAmount3") + request.getParameter("chTranAmount4") + request.getParameter("chTranAmount5") + request.getParameter("chTranAmount6") + request.getParameter("chTranAmount7") + request.getParameter("chTranAmount8") + request.getParameter("chTranAmount9") + request.getParameter("chTranAmount10") + request.getParameter("chTranAmount11") + request.getParameter("chTranAmount12"));
    objISTRAccountsDTO.setTransactiondetailsAmount(request.getParameter("chTranAmount"));
    objISTRAccountsDTO.setTransactiondetailsRemarks(request.getParameter("Remarks"));
    boolean boolIsSaved = INDSTRService.addTransactionsToList(caseNo, usercode, terminalId, strTransactionNo, objISTRAccountsDTO);
    int intInserted = 0;
    if(boolIsSaved) intInserted = 1;
    request.getSession().removeAttribute("PresentValue");
    request.getSession().setAttribute("PresentValue", intInserted+"");
    request.setAttribute("IsSaved", "Yes");
    commonService.auditLog(authentication.getPrincipal().toString(), request, "INDSTR", "INSERT", "Data Saved :"+boolIsSaved);
    return mv;
    }

	@RequestMapping(value = "/getNewINDSTRIndividuals") 
	public ModelAndView getNewINDSTRIndividuals(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication)
    throws Exception
    {
		ModelAndView mv = new ModelAndView("RegulatoryReports/India/STR/addIndividualDetails");
		String caseNo = (String)request.getSession().getAttribute("caseNo");  
		String strCounterName = request.getParameter("indvName");
        String strCounterID = request.getParameter("indvId");
        String strAccountNo = request.getParameter("acctNo");
        String strTransactionNo = (String)request.getSession().getAttribute("caseNo");
        HashMap hashMapDto = new HashMap(); 
        hashMapDto = INDSTRService.getNewIndividualDetails(strCounterName, strCounterID, strAccountNo, caseNo);
        request.setAttribute("HmAddNewIndivDTO", hashMapDto);
        commonService.auditLog(authentication.getPrincipal().toString(), request, "INDSTR", "OPEN", "Module Accessed");
        return mv;
    }

	@RequestMapping(value = "/deleteNewINDSTRIndividuals") 
	public ModelAndView deleteNewINDSTRIndividuals(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication)
    throws Exception
    {
		ModelAndView mv = new ModelAndView("RegulatoryReports/India/STR/strMain");
		String caseNo = (String)request.getSession().getAttribute("caseNo");  
		String usercode = authentication.getPrincipal().toString();
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String strCounterName = request.getParameter("indvName");
        String strCounterID = request.getParameter("indvId");
        String strAccountNo = request.getParameter("acctNo");
        String strRelationType = request.getParameter("relationType");
        HashMap hashMapDto = new HashMap(); 
        boolean boolIsSaved = INDSTRService.deleteIndividualDetails(strCounterName, strCounterID, strAccountNo, usercode, caseNo, strRelationType);
        
        HashMap l_HMINDSTRReport = INDSTRService.getINDSTRReport(caseNo, usercode, userRole);
        request.setAttribute("INDIANSTRDETAILS", l_HMINDSTRReport);
        request.setAttribute("saved", "yes");
        request.setAttribute("IsSaved", "Yes");
        request.setAttribute("caseNo", caseNo);
        request.getSession().setAttribute("CallFrom", request.getParameter("CallFrom"));
        commonService.auditLog(authentication.getPrincipal().toString(), request, "INDSTR", "DELETE", "Data Deleted: "+boolIsSaved);
        return mv;
    }

	@RequestMapping(value = "/getNewINDSTREntities") 
	public ModelAndView getNewINDSTREntities(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication)
    throws Exception
    {
		ModelAndView mv = new ModelAndView("RegulatoryReports/India/STR/addLegalDetails");
		String caseNo = (String)request.getSession().getAttribute("caseNo");  
		String strLegalAcctNo = request.getParameter("legalAcctNo");
        String strLegalName = request.getParameter("legalName");
        String strLegalId = request.getParameter("legalId");
        HashMap hashMapDto = new HashMap(); 
        hashMapDto = INDSTRService.getEntityDetails(strLegalAcctNo, strLegalName, strLegalId, caseNo);
        request.setAttribute("HmDto", hashMapDto);
        request.getSession().setAttribute("CallFrom", request.getParameter("CallFrom"));
        commonService.auditLog(authentication.getPrincipal().toString(), request, "INDSTR", "OPEN", "Module Accessed");
        return mv;
    }

	@RequestMapping(value = "/deleteNewINDSTREntities") 
	public ModelAndView deleteINDSTREntities(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication)
    throws Exception
    {
		ModelAndView mv = new ModelAndView("RegulatoryReports/India/STR/strMain");
		String caseNo = (String)request.getSession().getAttribute("caseNo");  
		String usercode = authentication.getPrincipal().toString();
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String strLegalAcctNo = request.getParameter("legalAcctNo");
        String strLegalPersonName = request.getParameter("legalName");
        String strLegalPersonId = request.getParameter("legalId");
        HashMap hashMapDto = new HashMap(); 
        boolean boolIsSaved = INDSTRService.deleteEntityDetails(strLegalAcctNo, strLegalPersonName, strLegalPersonId, usercode, caseNo);
        
        HashMap l_HMINDSTRReport = INDSTRService.getINDSTRReport(caseNo, usercode, userRole);
        request.setAttribute("INDIANSTRDETAILS", l_HMINDSTRReport);
        request.setAttribute("saved", "yes");
        request.setAttribute("IsSaved", "Yes");
        request.setAttribute("caseNo", caseNo);
        request.getSession().setAttribute("CallFrom", request.getParameter("CallFrom"));
        commonService.auditLog(authentication.getPrincipal().toString(), request, "INDSTR", "DELETE", "Data Deleted: "+boolIsSaved);
        return mv;
    }

	@RequestMapping(value = "/getNewINDSTRAccounts") 
	public ModelAndView getNewINDSTRAccounts(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication)
    throws Exception
    {
		ModelAndView mv = new ModelAndView("RegulatoryReports/India/STR/addAccountDetails");
		String caseNo = (String)request.getSession().getAttribute("caseNo");  
		String strAccountNo = request.getParameter("accountNo");
        String strCustomerName = request.getParameter("CustName");
        HashMap hashMapDto = new HashMap(); 
        hashMapDto = INDSTRService.getNewAccountDetails(strAccountNo, strCustomerName, caseNo);
        request.setAttribute("HmDto", hashMapDto);
        commonService.auditLog(authentication.getPrincipal().toString(), request, "INDSTR", "OPEN", "Module Accessed");
        return mv;
    }

	@RequestMapping(value = "/deleteNewINDSTRAccounts") 
	public ModelAndView deleteINDSTRAccounts(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication)
    throws Exception
    {
		ModelAndView mv = new ModelAndView("RegulatoryReports/India/STR/strMain");
		String caseNo = (String)request.getSession().getAttribute("caseNo");  
		String usercode = authentication.getPrincipal().toString();
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String strCustomerName = request.getParameter("indvName");
        String strAccountNo = request.getParameter("acctNo");
        String strDataType = request.getParameter("dataType");
        HashMap hashMapDto = new HashMap(); 
        boolean boolIsSaved = INDSTRService.deleteAccountDetails(strCustomerName, strAccountNo, strDataType, usercode, caseNo);
        HashMap l_HMINDSTRReport = INDSTRService.getINDSTRReport(caseNo, usercode, userRole);
        request.setAttribute("INDIANSTRDETAILS", l_HMINDSTRReport);
        request.setAttribute("saved", "yes");
        request.setAttribute("IsSaved", "Yes");
        request.setAttribute("caseNo", caseNo);
        request.getSession().setAttribute("CallFrom", request.getParameter("CallFrom"));
        commonService.auditLog(authentication.getPrincipal().toString(), request, "INDSTR", "DELETE", "Data Deleted: "+boolIsSaved);
        return mv;
    }

	@RequestMapping(value = "/getNewINDSTRTransactions") 
	public ModelAndView getNewINDSTRTransactions(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication)
    throws Exception
    {
		ModelAndView mv = new ModelAndView("RegulatoryReports/India/STR/addTransactionDetails");
		String caseNo = (String)request.getSession().getAttribute("caseNo");  
		HashMap hashMapDto = new HashMap(); 
        hashMapDto = INDSTRService.getNewTransactionDetails(caseNo, request.getParameter("accountNo"), request.getParameter("transactionNo"));
        request.setAttribute("HmDto", hashMapDto);
        commonService.auditLog(authentication.getPrincipal().toString(), request, "INDSTR", "OPEN", "Module Accessed");
        return mv;
    }

	@RequestMapping(value = "/deleteNewINDSTRTransactions") 
	public ModelAndView deleteNewINDSTRTransactions(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication)
    throws Exception
    {
		ModelAndView mv = new ModelAndView("RegulatoryReports/India/STR/strMain");
		String caseNo = (String)request.getSession().getAttribute("caseNo");  
		String usercode = authentication.getPrincipal().toString();
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String strAccountNo = request.getParameter("accountNo");
        String strTransactionNo = request.getParameter("tranNo");
        HashMap hashMapDto = new HashMap(); 
        boolean boolIsSaved = INDSTRService.deleteTransactionDetails(caseNo, strTransactionNo, strAccountNo, usercode);
        HashMap l_HMINDSTRReport = INDSTRService.getINDSTRReport(caseNo, usercode, userRole);
        request.setAttribute("INDIANSTRDETAILS", l_HMINDSTRReport);
        request.setAttribute("saved", "yes");
        request.setAttribute("IsSaved", "Yes");
        request.setAttribute("caseNo", caseNo);
        request.getSession().setAttribute("CallFrom", request.getParameter("CallFrom"));
        commonService.auditLog(authentication.getPrincipal().toString(), request, "INDSTR", "DELETE", "Data Deleted: "+boolIsSaved);        return mv;
    }
	
	@RequestMapping(value = "/saveINDSTRManualDetails") 
	public ModelAndView saveINDSTRManualDetails(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication)
    throws Exception
    {
		//System.out.println("in controller");
		ModelAndView mv = new ModelAndView("RegulatoryReports/India/STR/strMain");
		String caseNo = (String)request.getSession().getAttribute("caseNo");  
		String usercode = authentication.getPrincipal().toString();
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		ISTRManualDetailsVO objManualFormVO = setManualFormValues(request);
		boolean boolIsSaved = INDSTRService.saveISTRManualDetails(caseNo, usercode, objManualFormVO);
		if(boolIsSaved)
        {
            HashMap l_HMINDSTRReport = INDSTRService.getINDSTRReport(caseNo, usercode, userRole);
            request.setAttribute("INDIANSTRDETAILS", l_HMINDSTRReport);
            request.setAttribute("saved", "yes");
            request.setAttribute("IsSaved", "Yes");
            request.setAttribute("caseNo", caseNo);
        }
		commonService.auditLog(authentication.getPrincipal().toString(), request, "INDSTR", "INSERT", "Data Saved: "+boolIsSaved);
		//System.out.println("mv = "+mv);
        return mv;
    }
	
	@RequestMapping(value="/getINDSTRReport")
	public ModelAndView getINDSTRReport(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		ModelAndView mv = new ModelAndView("RegulatoryReports/India/STR/strMain");
		HttpSession l_CHttpSession = request.getSession(true);
		String caseNo = request.getParameter("caseNo") == null?(String)l_CHttpSession.getAttribute("caseNo"):request.getParameter("caseNo").toString();
		//String caseNo = request.getParameter("caseNo").toString();
		String canUpdated = request.getParameter("canUpdated") == null ? "N":request.getParameter("canUpdated").toString();
		String canExported = request.getParameter("canExported") == null ? "N":request.getParameter("canExported").toString();
		request.getSession().setAttribute("caseNo",caseNo);
		request.getSession().setAttribute("canUpdated",canUpdated);
		request.getSession().setAttribute("canExported",canExported);
		String usercode = authentication.getPrincipal().toString();
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		HashMap l_HMINDSTRReport = INDSTRService.getINDSTRReport(caseNo, usercode, userRole);
		request.setAttribute("INDIANSTRDETAILS", l_HMINDSTRReport);
		request.setAttribute("canUpdated", canUpdated);
		request.setAttribute("canExported", canExported);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "INDSTR", "OPEN", "Module Accessed");
		return mv;
	}
	
	@RequestMapping(value="/INDSTRExportXML")
	public ModelAndView INDSTRExportXML(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String caseNo = request.getParameter("caseNo") == null ? "" : request.getParameter("caseNo");
		String usercode = authentication.getPrincipal().toString();
		HashMap l_HMINDSTRXMLFileDetails = INDSTRService.getSTRXMlFileContent(caseNo, usercode);
		String l_strXmlFileName = (String) l_HMINDSTRXMLFileDetails.get("FILENAME");
		HashMap l_HMXMlFileContent = (HashMap) l_HMINDSTRXMLFileDetails.get("FILECONTENT");
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
	
	@RequestMapping(value = "/uploadINDSTRTransactions")
	public ModelAndView uploadINDSTRTransactions(MultipartHttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception {
		ModelAndView mv = new ModelAndView("RegulatoryReports/India/STR/addTransactionDetails");
		String userCode = authentication.getPrincipal().toString();
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String ipAddress = request.getRemoteAddr();
		
		String caseNo = request.getParameter("caseNo");
		String l_strBankName = request.getParameter("BankName");
		String l_strBSRCode = request.getParameter("BSRCode");
		String l_strAccountNo = request.getParameter("AccountNo");
		BufferedOutputStream stream = null;
		
		System.out.println("caseNo : "+caseNo);
		System.out.println("l_strBankName : "+l_strBankName);
		System.out.println("l_strAccountNo : "+l_strAccountNo);
		System.out.println("l_strBSRCode : "+l_strBSRCode);
		System.out.println("transactionFilePath : "+transactionFilePath);
		/*
		ApplicationProperties appProperties = ApplicationProperties.getInstance();
		String TRANSACTIONFILESPATH = appProperties.getProperty("TransactionFilePath");
		*/
		//String TRANSACTIONFILESPATH = "C:\\APPFOLDER\\TransactionFile";
		String TRANSACTIONFILESPATH = transactionFilePath;
		String uploadPath = TRANSACTIONFILESPATH+File.separator+caseNo+"_"+l_strAccountNo;
		try {
		File folderName = new File(uploadPath);
		if(!folderName.exists()){
			folderName.mkdirs();
		}
		
		Iterator<String> itrator = request.getFileNames();
		MultipartFile multiFile = request.getFile(itrator.next());
		System.out.println("multiFile:  "+multiFile);
		String fileName = multiFile.getOriginalFilename();
		System.out.println("fileName:  "+fileName);
		
		byte[] bytes = multiFile.getBytes();
        String fullFilePath = uploadPath + File.separator + fileName;
        File file = new File(uploadPath + File.separator + fileName);
        if(file.exists()){
        	mv.addObject("message", "Couldn't upload the file as another file with the same name is already exists. Change this file name or try another");
        }else{
            stream = new BufferedOutputStream(new FileOutputStream(file));
            stream.write(bytes);
            stream.close();
        	boolean res = INDSTRService.saveSTRTransactionFile(caseNo, l_strAccountNo, fullFilePath, file, userCode, userRole, ipAddress);           			
			if(res){
				mv.addObject("message", "File is Uploaded Successfully");
			}else{
				mv.addObject("message", "Error occured during file upload");
			}
        }
			
        /*
		
		System.out.println("uploadPath : "+uploadPath);
		DiskFileUpload objDiskUpload = new DiskFileUpload();
		File uploadedFile = null;
		try	{
			File f = new File(uploadPath);
			if(!f.exists()){
				f.mkdirs();
			}
			
			@SuppressWarnings("unchecked")
			List<FileItem> listFiles = objDiskUpload.parseRequest(request);	
			System.out.println("listFiles:  "+listFiles+", cOUNT OF FIELS: "+listFiles.size());
			for (FileItem item : listFiles) {
	            if (item.isFormField()) {
	                String fieldname = item.getFieldName();
	                String fieldvalue = item.getString();
	                mv.addObject(fieldname, fieldvalue);
	            } else {
	            	String fileName = new File(item.getName()).getName();
                    String filePath = uploadPath + File.separator + fileName;
                    uploadedFile = new File(filePath);
                    if(uploadedFile.exists()){
                    	mv.addObject("message", "Couldn't upload the file as another file with the same name is already exists. Change this file name or try another");
                    }else{
                    	item.write(uploadedFile);
                    	boolean res = INDSTRService.saveSTRTransactionFile(uploadedFile, usercode);           			
            			if(res){
            				mv.addObject("message", "File is Uploaded Successfully");
            			}else{
            				mv.addObject("message", "Error occured during file upload");
            			}
                    }
	            }
	        }
	        */
	    } catch (Exception e) {
	    	mv.addObject("message", "Exception occured during file upload");
	        e.printStackTrace();
	    }
		commonService.auditLog(authentication.getPrincipal().toString(), request, "INDSTR", "INSERT", "File Uploaded");
		return mv;
	}
	
	@RequestMapping(value = "/autoSaveINDSTRTransactions")
	public ModelAndView autoSaveINDSTRTransactions(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		ModelAndView mv = new ModelAndView("RegulatoryReports/India/STR/addTransactionDetails");
		String usercode = authentication.getPrincipal().toString();
		String caseNo = request.getParameter("caseNo");
		String l_strFromDate = request.getParameter("fromDate");
		String l_strToDate = request.getParameter("toDate");
		String l_strAccountNo = request.getParameter("accountNumber");
		String l_strSaveOrDelete = request.getParameter("SaveOrDelete");
		
		String BankName = request.getParameter("BankName");
		String BSRCode = request.getParameter("BSRCode");
		boolean boolIsSaved = INDSTRService.autoSaveINDSTRTransactions(caseNo, l_strAccountNo, l_strFromDate, l_strToDate, l_strSaveOrDelete, usercode);
        if(boolIsSaved){
        	mv.addObject("message", "Transactions are added successfully");
        	if(l_strSaveOrDelete.equalsIgnoreCase("Delete"))
        	  mv.addObject("message", "Transactions are deleted successfully");
        }else{
        	mv.addObject("message", "Error occured during this operation");
        }
        mv.addObject("caseNo", caseNo);
        mv.addObject("accountNumber", l_strAccountNo);
        mv.addObject("fromDate", l_strFromDate);
        mv.addObject("toDate", l_strToDate);
        mv.addObject("SaveOrDelete", l_strSaveOrDelete);
        mv.addObject("BankName", BankName);
        mv.addObject("BSRCode", BSRCode);
        commonService.auditLog(authentication.getPrincipal().toString(), request, "INDSTR", "INSERT", "Data Saved :"+boolIsSaved);
		return mv;
	}
	
	private ISTRManualDetailsVO setManualFormValues(HttpServletRequest request)
    {
		ISTRManualDetailsVO objManualFormVO = new ISTRManualDetailsVO();
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
        objManualFormVO.setSusGroundsP7(strArrayPart7susGrounds);

        for(int i = 0; i < 5; i++)
        	strArrayPart8susGrounds[i] = request.getParameter("Part8susGrounds" + i);
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
    	/*for(int i = 1; i <= 4; i++)
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
        objManualFormVO.setReasonOfRevision(request.getParameter("reasonOfRevision"));
        
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
	
	@RequestMapping(value = "/uploadExecuteFile", method=RequestMethod.POST)
	public RedirectView uploadExecuteFile(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication){
		/*
		ApplicationProperties appProperties = ApplicationProperties.getInstance();
		String TRANSACTIONFILESPATH = appProperties.getProperty("TransactionFilePath");
		*/
		String TRANSACTIONFILESPATH = "C:\\APPFOLDER\\TransactionFile";
		
		String uploadPath = TRANSACTIONFILESPATH+File.separator+"TEMPFILES";
		Map<String, Object> output;
		DiskFileUpload objDiskUpload = new DiskFileUpload();
		File uploadedFile = null;
		String procName = "";
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
	                if(fieldname.equals("procName")){
	                	procName = fieldvalue;
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
			
			if(procName != null && procName != "" && uploadedFile != null && uploadedFile.exists() ){
				output = INDSTRService.executeFile(uploadedFile, procName);
				status = (Boolean) output.get("PROCCREATED");
				message = (String) output.get("MESSAGE");
			}else{
				message = "Enter the valid name and salect a valid file";
			}
		}catch(Exception e){
		}
		try{
			if(uploadedFile != null && uploadedFile.exists())
				uploadedFile.delete();
		}catch(Exception e){}
		RedirectView rv = new RedirectView("CaseManager/AttachEvidence_copy.jsp");
		rv.addStaticAttribute("message", message);
		rv.addStaticAttribute("status", status);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "INDSTR", "INSERT", "File Uploaded :"+status);
		return rv;
	}
	
	@RequestMapping(value = "/exportAccountTxnDetails")
	public ModelAndView exportAccountTxnDetails(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		ModelAndView modelAndView = null;
		String caseNo = (String)request.getSession().getAttribute("caseNo");  
		String usercode = authentication.getPrincipal().toString();
		String strCustomerName = request.getParameter("indvName");
        String strAccountNo = request.getParameter("acctNo");
        String strDataType = request.getParameter("dataType");
        String generationType = request.getParameter("generationType");
        String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String ipAdress = request.getRemoteAddr();
		Map<String, String> paramMap = new LinkedHashMap<String, String>();
		paramMap.put("caseNo", caseNo);
		paramMap.put("AccountNo", strAccountNo);
		paramMap.put("AccountName", strCustomerName);
		paramMap.put("DataType", strDataType);
		paramMap.put("UserCode", usercode);
		paramMap.put("UserRole", userRole);
		paramMap.put("IPAdress", ipAdress);

		ArrayList<String> inputParameter = new ArrayList<String>();
		System.out.println("generationType:   "+generationType);
		String resultMessage = "";
		int resultCount = 0;
		Map<String, Object> model = new HashMap<String, Object>();
	    try
	    {
	    	long startGetData = new Date().getTime();
	    	Map<String,Object> l_HMReportData = (HashMap<String,Object>)INDSTRService.exportAccountTxnDetails(paramMap);
		
	    	long endGetData = new Date().getTime();
	    	long diff = (endGetData - startGetData)/1000;
			if(generationType.equalsIgnoreCase("exportPDF")){
				response.setContentType("application/pdf");
				response.setHeader("Content-Disposition", "attachment;fileName="+l_HMReportData.get("reportName")+".pdf");
				model.put(PdfView.PDF_LIST_KEY, l_HMReportData);
			}else if(generationType.equalsIgnoreCase("exportExcel")){
				response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
				response.setHeader("Content-Disposition", "attachment;fileName="+l_HMReportData.get("reportName")+".xlsx");
				model.put(ExcelView.EXCEL_LIST_KEY, l_HMReportData);
			}else if(generationType.equalsIgnoreCase("exportCSV")){
				String COMMA_DELIMITER = "\",\"";
				String NEW_LINE_SEPARATOR = "\n";
				String result = "";
				String[] l_Headers = (String[])l_HMReportData.get("Header");
			    ArrayList<HashMap<String, String>> l_al = (ArrayList<HashMap<String, String>>)l_HMReportData.get("ReportData");
			    HashMap<String, String> hashMap = new HashMap<String, String>();
			    String fileName = l_HMReportData.get("reportName")+".csv";
			    
				BufferedWriter bufferedWriter = null;
				StringWriter stringWriter = null;
				try{
					boolean first = true;
					boolean last = false;
					stringWriter = new StringWriter();
					bufferedWriter = new BufferedWriter(stringWriter);
					
					for(int i=0; i < l_Headers.length; i++)
				    {
						if(i == l_Headers.length - 1) last = true; 
						result = getCVSformatData(l_Headers[i]);
						if (first) {
							bufferedWriter.write("\""+result+COMMA_DELIMITER);
			            }
						else if(last){
							bufferedWriter.write(result+"\"");
						}
						else {
							bufferedWriter.write(result+COMMA_DELIMITER);
						}
				        first = false;
				    }
					bufferedWriter.newLine();
					
					for(int i=0; i < l_al.size(); i++)
					{
				        hashMap = (HashMap<String, String>)l_al.get(i);
				        first = true;
				        last = false;
					    for(int j=0; j < l_Headers.length; j++){
					    	if(j == l_Headers.length - 1) last = true; 
					    	result = getCVSformatData(hashMap.get(l_Headers[j]));
					    	if (first) {
								bufferedWriter.write("\""+result+COMMA_DELIMITER);
				            }
							else if(last){
								bufferedWriter.write(result+"\"");
							}
							else {
								bufferedWriter.write(result+COMMA_DELIMITER);
							}
					        first = false;
					    }
					    bufferedWriter.newLine();
					}
					
					bufferedWriter.flush();
			        String fileStringData = stringWriter.toString();
			        
			        response.setContentType("APPLICATION/OCTET-STREAM");
			        String disHeader = "Attachment;Filename=\""+fileName+"\"";
			        
			        response.setHeader("Content-disposition", disHeader);
			        ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
			        byteArrayOutputStream.write(fileStringData.getBytes());
			        response.setContentLength(fileStringData.length());
			        byteArrayOutputStream.writeTo(response.getOutputStream());
			        byteArrayOutputStream.flush();
			        byteArrayOutputStream.close();
			        bufferedWriter.close();
				}catch(Exception e){
					e.printStackTrace();
				}
			}
	
			model.put("reportId", "");
			model.put("startDate", "");
			model.put("endDate", "");
			model.put("inputParameter", inputParameter);
	    }
	    catch(Exception e){
	    	resultMessage = "Error while generating "+generationType+" reports for STR Accounts Export: ";
	    	log.error("Error while generating "+generationType+" reports for: STR Accounts Export. The error is : "+e.toString());
	    	System.out.println("Error while generating "+generationType+" reports for: STR Accounts Export. The error is : "+e.toString());
	    	e.printStackTrace();
	    }
	    
	    // resultMessage = resultMessage + resultCount;
	    
	    request.setAttribute("Result", resultCount);
	    request.setAttribute("resultMessage", resultMessage);
		request.setAttribute("generationType", generationType);
		
		if(generationType.equalsIgnoreCase("exportPDF"))
			modelAndView = new ModelAndView(new PdfView(), model);
		else if(generationType.equalsIgnoreCase("exportExcel"))
			modelAndView = new ModelAndView(new ExcelView(), model);
	    commonService.auditLog(authentication.getPrincipal().toString(), request, "REPORTS", "DOWNLOAD", "File Downloaded");
		return modelAndView;
    }
	
	@RequestMapping(value="/exportConsildatedExceptionReport")
	public ModelAndView exportConsildatedExceptionReport(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication){
		String caseNo = request.getParameter("caseNo");
		String usercode = authentication.getPrincipal().toString();
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String ipAdress = request.getRemoteAddr();
		Map<String, String> paramMap = new LinkedHashMap<String, String>();
		paramMap.put("caseNo", caseNo);
		paramMap.put("UserCode", usercode);
		paramMap.put("UserRole", userRole);
		paramMap.put("IPAdress", ipAdress);

		Map<String, Object> mainMap = INDSTRService.exportConsildatedExceptionReport(paramMap);
		Iterator<String> itr = mainMap.keySet().iterator();
		List<String> tabOrder = new Vector<String>();
		while(itr.hasNext()){
			tabOrder.add(itr.next());
		}
		mainMap.put("TABORDER", tabOrder);
		//System.out.println("mainMap controller STR = "+mainMap);
		ModelAndView modelAndView = new ModelAndView(new MultiSheetExcelView(), mainMap);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "REPORTS", "DOWNLOAD", "File Downloaded");
		return modelAndView;
	}
	
	private String getCVSformatData(String inputString) 
	{
        String result = inputString;
        if (result != null && result.contains("\"")) {
            result = result.replace("\"", "\"\"");
        }
        return result;
    }
}

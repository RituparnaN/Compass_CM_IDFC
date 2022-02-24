package com.quantumdataengines.app.compass.controller;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.Reader;
import java.io.StringWriter;
import java.util.Collections;
import java.util.Comparator;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import oracle.net.aso.i;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;

//import twitter4j.examples.block.CreateBlock;




import com.quantumdataengines.app.compass.otherservice.OtherCommonService;
import com.quantumdataengines.app.compass.service.CommonService;
import com.quantumdataengines.app.compass.service.master.GenericMasterService;
import com.quantumdataengines.app.compass.util.CommonUtil;
//import com.quantumdataengines.app.compass.util.DocumentFromWSDL;
//import com.quantumdataengines.app.compass.util.SOAPClient;

@Controller
@RequestMapping(value="/common")
public class GenericMasterController {
	private static final Logger log = LoggerFactory.getLogger(CommonController.class);
	
	@Autowired
	private CommonService commonService;
	@Autowired
	private OtherCommonService otherCommonService;
	@Autowired
	private GenericMasterService genericMasterService;
	
	//1. alertEngine
	@RequestMapping(value="/alertEngine", method=RequestMethod.GET)
	public String alertEngine(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String moduleType = request.getParameter("moduleType");
		request.setAttribute("MODULETYPE", moduleType);
		request.setAttribute("UNQID", otherCommonService.getElementId());
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		request.setAttribute("MASTERSEARCHFRAME", genericMasterService.getModuleParameters(moduleType, 
				authentication.getPrincipal().toString(), userRole, request.getRemoteAddr()));
		request.setAttribute("userRole", userRole);
		//setAuditLogEntries(request, response, authentication, moduleType);
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "ALERT ENGINE", "OPEN", "Module Accessed");
		return "AlertEngines/index";
	}
	
	// 2. bankMaster
	@RequestMapping(value="/bankMaster", method=RequestMethod.GET)
	public String bankMaster(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String moduleType = request.getParameter("moduleType");
		request.setAttribute("MODULETYPE", moduleType);
		request.setAttribute("UNQID", otherCommonService.getElementId());
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		request.setAttribute("MASTERSEARCHFRAME", genericMasterService.getModuleParameters(moduleType, 
				authentication.getPrincipal().toString(), userRole, request.getRemoteAddr()));
		request.setAttribute("userRole", userRole);
		//setAuditLogEntries(request, response, authentication, moduleType);
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "BANK MASTER", "OPEN", "Module Accessed");
		return "MasterModules/BankMaster/index";
	}
	
	//3. branchMaster
	@RequestMapping(value="/branchMaster", method=RequestMethod.GET)
	public String branchMaster(HttpServletRequest request, HttpServletResponse response, 
		Authentication authentication) throws Exception{
		String moduleType = request.getParameter("moduleType");
		request.setAttribute("MODULETYPE", moduleType);
		request.setAttribute("UNQID", otherCommonService.getElementId());
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		request.setAttribute("MASTERSEARCHFRAME", genericMasterService.getModuleParameters(moduleType, 
			authentication.getPrincipal().toString(), userRole, request.getRemoteAddr()));
		request.setAttribute("userRole", userRole);
		//setAuditLogEntries(request, response, authentication, moduleType);
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "BRANCH MASTER", "OPEN", "Module Accessed");
		return "MasterModules/BranchMaster/index";
	}
		
	//4. branchUserMapping
	@RequestMapping(value="/branchUserMapping", method=RequestMethod.GET)
	public String branchUserMapping(HttpServletRequest request, HttpServletResponse response, 
		Authentication authentication) throws Exception{
		String moduleType = request.getParameter("moduleType");
		request.setAttribute("MODULETYPE", moduleType);
		request.setAttribute("UNQID", otherCommonService.getElementId());
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		request.setAttribute("MASTERSEARCHFRAME", genericMasterService.getModuleParameters(moduleType, 
				authentication.getPrincipal().toString(), userRole, request.getRemoteAddr()));
		request.setAttribute("userRole", userRole);
		//setAuditLogEntries(request, response, authentication, moduleType);
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "BRANCH USER MAPPING MASTER", "OPEN", "Module Accessed");
		return "MasterModules/BranchUserMapping/index";
	}
	
	// 5. customerReviewedDetails
	@RequestMapping(value="/customerReviewedDetails", method=RequestMethod.GET)
	public String customerReviewedDetails(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String moduleType = request.getParameter("moduleType");
		request.setAttribute("MODULETYPE", moduleType);
		request.setAttribute("UNQID", otherCommonService.getElementId());
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		request.setAttribute("MASTERSEARCHFRAME", genericMasterService.getModuleParameters(moduleType, 
				authentication.getPrincipal().toString(), userRole, request.getRemoteAddr()));
		request.setAttribute("userRole", userRole);
		//setAuditLogEntries(request, response, authentication, moduleType);
		
		/*commonService.auditLog(authentication.getPrincipal().toString(), request, "BANK MASTER", "OPEN", "Module Accessed");*/
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CUSTOMER REVIEWED DETAILS", "OPEN", "Module Accessed");
		return "MasterModules/CustomerReviewedDetails/index";
	}
	
	// 6. accountsMaster
	@RequestMapping(value="/accountsMaster", method=RequestMethod.GET)
	public String accountsMaster(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String moduleType = request.getParameter("moduleType");
		request.setAttribute("MODULETYPE", moduleType);
		request.setAttribute("UNQID", otherCommonService.getElementId());
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		request.setAttribute("MASTERSEARCHFRAME", genericMasterService.getModuleParameters(moduleType, 
				authentication.getPrincipal().toString(), userRole, request.getRemoteAddr()));
		request.setAttribute("userRole", userRole);
		//setAuditLogEntries(request, response, authentication, moduleType);
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "ACCOUNTS MASTER", "OPEN", "Module Accessed");
		return "MasterModules/AccountsMaster/index";
	}

// 7. productsMaster
	@RequestMapping(value="/productsMaster", method=RequestMethod.GET)
	public String productsMaster(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String moduleType = request.getParameter("moduleType");
		request.setAttribute("MODULETYPE", moduleType);
		request.setAttribute("UNQID", otherCommonService.getElementId());
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		request.setAttribute("MASTERSEARCHFRAME", genericMasterService.getModuleParameters(moduleType, 
				authentication.getPrincipal().toString(), userRole, request.getRemoteAddr()));
		request.setAttribute("userRole", userRole);
		//setAuditLogEntries(request, response, authentication, moduleType);
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "PRODUCTS MASTER", "OPEN", "Module Accessed");
		return "MasterModules/ProductsMaster/index";
	}

// 8. instrumentMaster
	@RequestMapping(value="/instrumentMaster", method=RequestMethod.GET)
	public String instrumentMaster(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String moduleType = request.getParameter("moduleType");
		request.setAttribute("MODULETYPE", moduleType);
		request.setAttribute("UNQID", otherCommonService.getElementId());
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		request.setAttribute("MASTERSEARCHFRAME", genericMasterService.getModuleParameters(moduleType, 
				authentication.getPrincipal().toString(), userRole, request.getRemoteAddr()));
		request.setAttribute("userRole", userRole);
		setAuditLogEntries(request, response, authentication, moduleType);
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "INSTRUMENT MASTER", "OPEN", "Module Accessed");
		return "MasterModules/InstrumentMaster/index";
	}

// 9. employeeMaster
	@RequestMapping(value="/employeeMaster", method=RequestMethod.GET)
	public String employeeMaster(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String moduleType = request.getParameter("moduleType");
		request.setAttribute("MODULETYPE", moduleType);
		request.setAttribute("UNQID", otherCommonService.getElementId());
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		request.setAttribute("MASTERSEARCHFRAME", genericMasterService.getModuleParameters(moduleType, 
				authentication.getPrincipal().toString(), userRole, request.getRemoteAddr()));
		request.setAttribute("userRole", userRole);
		//setAuditLogEntries(request, response, authentication, moduleType);
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "EMPLOYEE MASTER", "OPEN", "Module Accessed");
		return "MasterModules/EmployeeMaster/index";
	}

// 10. countryMaster
	@RequestMapping(value="/countryMaster", method=RequestMethod.GET)
	public String countryMaster(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String moduleType = request.getParameter("moduleType");
		request.setAttribute("MODULETYPE", moduleType);
		request.setAttribute("UNQID", otherCommonService.getElementId());
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		request.setAttribute("MASTERSEARCHFRAME", genericMasterService.getModuleParameters(moduleType, 
				authentication.getPrincipal().toString(), userRole, request.getRemoteAddr()));
		request.setAttribute("userRole", userRole);
		//setAuditLogEntries(request, response, authentication, moduleType);
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "COUNTRY MASTER", "OPEN", "Module Accessed");
		return "MasterModules/CountryMaster/index";
	}

// 11. customerTypeMaster
	@RequestMapping(value="/customerTypeMaster", method=RequestMethod.GET)
	public String customerTypeMaster(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String moduleType = request.getParameter("moduleType");
		request.setAttribute("MODULETYPE", moduleType);
		request.setAttribute("UNQID", otherCommonService.getElementId());
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		request.setAttribute("MASTERSEARCHFRAME", genericMasterService.getModuleParameters(moduleType, 
				authentication.getPrincipal().toString(), userRole, request.getRemoteAddr()));
		request.setAttribute("userRole", userRole);
		//setAuditLogEntries(request, response, authentication, moduleType);
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CUSTOMER TYPE MASTER", "OPEN", "Module Accessed");
		return "MasterModules/CustomerTypeMaster/index";
	}
	
// 12. transactionTypeMaster
	@RequestMapping(value="/transactionTypeMaster", method=RequestMethod.GET)
	public String transactionTypeMaster(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String moduleType = request.getParameter("moduleType");
		request.setAttribute("MODULETYPE", moduleType);
		request.setAttribute("UNQID", otherCommonService.getElementId());
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		request.setAttribute("MASTERSEARCHFRAME", genericMasterService.getModuleParameters(moduleType, 
				authentication.getPrincipal().toString(), userRole, request.getRemoteAddr()));
		request.setAttribute("userRole", userRole);
		//setAuditLogEntries(request, response, authentication, moduleType);
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "TRANSACTION TYPE MASTER", "OPEN", "Module Accessed");
		return "MasterModules/TransactionTypeMaster/index";
	}
	
// 13. currencyMaster
	@RequestMapping(value="/currencyMaster", method=RequestMethod.GET)
	public String currencyMaster(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String moduleType = request.getParameter("moduleType");
		request.setAttribute("MODULETYPE", moduleType);
		request.setAttribute("UNQID", otherCommonService.getElementId());
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		request.setAttribute("MASTERSEARCHFRAME", genericMasterService.getModuleParameters(moduleType, 
				authentication.getPrincipal().toString(), userRole, request.getRemoteAddr()));
		request.setAttribute("userRole", userRole);
		//setAuditLogEntries(request, response, authentication, moduleType);
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CURRENCY MASTER", "OPEN", "Module Accessed");
		return "MasterModules/CurrencyMaster/index";
	}
	
// 14. currencyMappingMaster
	@RequestMapping(value="/currencyMappingMaster", method=RequestMethod.GET)
	public String currencyMappingMaster(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String moduleType = request.getParameter("moduleType");
		request.setAttribute("MODULETYPE", moduleType);
		request.setAttribute("UNQID", otherCommonService.getElementId());
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		request.setAttribute("MASTERSEARCHFRAME", genericMasterService.getModuleParameters(moduleType, 
				authentication.getPrincipal().toString(), userRole, request.getRemoteAddr()));
		request.setAttribute("userRole", userRole);
		//setAuditLogEntries(request, response, authentication, moduleType);
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CURRENCY MAPPING MASTER", "OPEN", "Module Accessed");
		return "MasterModules/CurrencyMappingMaster/index";
	}

// 15. fiuFieldMappingMaster
	@RequestMapping(value="/fiuFieldMappingMaster", method=RequestMethod.GET)
	public String fiuFieldMappingMaster(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String moduleType = request.getParameter("moduleType");
		request.setAttribute("MODULETYPE", moduleType);
		request.setAttribute("UNQID", otherCommonService.getElementId());
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		request.setAttribute("MASTERSEARCHFRAME", genericMasterService.getModuleParameters(moduleType, 
				authentication.getPrincipal().toString(), userRole, request.getRemoteAddr()));
		request.setAttribute("userRole", userRole);
		//setAuditLogEntries(request, response, authentication, moduleType);
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "FIU FIELD MAPPING MASTER", "OPEN", "Module Accessed");
		return "MasterModules/FIUFieldMappingMaster/index";
	}
	
// 16. referenceValuesMaster
	@RequestMapping(value="/referenceValuesMaster", method=RequestMethod.GET)
	public String referenceValuesMaster(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String moduleType = request.getParameter("moduleType");
		request.setAttribute("MODULETYPE", moduleType);
		request.setAttribute("UNQID", otherCommonService.getElementId());
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		request.setAttribute("MASTERSEARCHFRAME", genericMasterService.getModuleParameters(moduleType, 
				authentication.getPrincipal().toString(), userRole, request.getRemoteAddr()));
		request.setAttribute("userRole", userRole);
		//setAuditLogEntries(request, response, authentication, moduleType);
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "REFERENCE VALUES MASTER", "OPEN", "Module Accessed");
		return "MasterModules/ReferenceValuesMaster/index";
	}
	
// 17. customerMaster
	@RequestMapping(value="/customerMaster", method=RequestMethod.GET)
	public String customerMaster(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String moduleType = request.getParameter("moduleType");
		request.setAttribute("MODULETYPE", moduleType);
		request.setAttribute("UNQID", otherCommonService.getElementId());
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		request.setAttribute("MASTERSEARCHFRAME", genericMasterService.getModuleParameters(moduleType, 
				authentication.getPrincipal().toString(), userRole, request.getRemoteAddr()));
		request.setAttribute("userRole", userRole);
		//setAuditLogEntries(request, response, authentication, moduleType);
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CUSTOMER MASTER", "OPEN", "Module Accessed");
		return "KYCModules/CustomerMaster/index";
	}

// 18. transactionDetails
	@RequestMapping(value="/transactionDetails", method=RequestMethod.GET)
	public String transactionDetails(HttpServletRequest request, HttpServletResponse response, 
		Authentication authentication) throws Exception{
		String moduleType = request.getParameter("moduleType");
		String callFromAccountsMaster= request.getParameter("callFromAccountsMaster");
		String accountNo = request.getParameter("accountNo") == null ? "":request.getParameter("accountNo");
		request.setAttribute("MODULETYPE", moduleType);
		request.setAttribute("ACCOUNTNO", accountNo);
		request.setAttribute("CALLFROMACCOUNTSMASTER", callFromAccountsMaster);
		request.setAttribute("UNQID", otherCommonService.getElementId());
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		request.setAttribute("MASTERSEARCHFRAME", genericMasterService.getModuleParameters(moduleType, 
			authentication.getPrincipal().toString(), userRole, request.getRemoteAddr()));
		request.setAttribute("userRole", userRole);
		//setAuditLogEntries(request, response, authentication, moduleType);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "TRANSACTION DETAILS MASTER", "OPEN", "Module Accessed");
		return "InvestigationTools/TransactionDetails/index";
		
	}
	
	@RequestMapping(value={"/viewAccountStatement"}, method=RequestMethod.GET)
	public String viewAccountStatement(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		Map<String, String[]> formData =  request.getParameterMap();
		Map<String, String> paramTempMap = new HashMap<String, String>();
		Map<String, String> paramMap = new HashMap<String, String>();
		Iterator<String> itr = formData.keySet().iterator();
		while (itr.hasNext()) {
			String tempParamName = itr.next();
			String tempParamValue = formData.get(tempParamName)[0];
			//if(!"moduleType".equals(tempParamName) && !"bottomPageUrl".equals(tempParamName)){
			if(!"moduleType".equals(tempParamName) && !"bottomPageUrl".equals(tempParamName) && !"submitButton".equals(tempParamName) && !"_csrf".equals(tempParamName)){
				paramTempMap.put(tempParamName, tempParamValue);
			}
		}
		
		List<String> paramKeyList = new Vector<String>(paramTempMap.keySet());
		
		for(String paramName : paramKeyList) {
			String paramValue = formData.get(paramName)[0];
			paramMap.put(paramName.substring(paramName.indexOf("_")+1), paramValue);
			request.setAttribute(paramName.substring(paramName.indexOf("_")+1), paramValue);
		}
		
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("DETAILS", genericMasterService.viewAccountStatement(paramMap));
		commonService.auditLog(authentication.getPrincipal().toString(), request, "ACCOUNT STATEMENT", "OPEN", "Viewing Account Statement ");
		
		return "InvestigationTools/TransactionDetails/AccountStatement";
	}

	@RequestMapping(value={"/openSubjectiveAlertWindow"}, method=RequestMethod.GET)
	public String openSubjectiveAlertWindow(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		String transactionNo = request.getParameter("transactionNo");
		
		request.setAttribute("transactionNo", transactionNo);
		
		request.setAttribute("RECORDS", genericMasterService.openSubjectiveAlertWindow());
		request.setAttribute("UNQID", otherCommonService.getElementId());
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "SUBJECTIVEALERTS", "SEARCH", "SubjectiveAlerts List Accessed For Transaction No "+transactionNo);
		
		return "InvestigationTools/TransactionDetails/GenerateSubjectiveAlert";
	}

	@RequestMapping(value={"/generateSubjectiveAlert"}, method=RequestMethod.GET)
	public @ResponseBody String generateSubjectiveAlert(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		String transactionNo = request.getParameter("transactionNo");
		String alertCode = request.getParameter("alertCode");
		String userCode = authentication.getPrincipal().toString();
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		
		request.setAttribute("transactionNo", transactionNo);
		request.setAttribute("alertCode", alertCode);
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "SUBJECTIVEALERTS", "SEARCH", "SubjectiveAlerts Generated For Transaction No "+transactionNo);
		return genericMasterService.generateSubjectiveAlert(transactionNo, alertCode, userCode, userRole);
	}

	

// 23. accountProfiling
	@RequestMapping(value="/accountProfiling", method=RequestMethod.GET)
	public String accountProfiling(HttpServletRequest request, HttpServletResponse response, 
		Authentication authentication) throws Exception{
		String moduleType = request.getParameter("moduleType");
		request.setAttribute("MODULETYPE", moduleType);
		request.setAttribute("UNQID", otherCommonService.getElementId());
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		request.setAttribute("MASTERSEARCHFRAME", genericMasterService.getModuleParameters(moduleType, 
			authentication.getPrincipal().toString(), userRole, request.getRemoteAddr()));
		request.setAttribute("userRole", userRole);
		//setAuditLogEntries(request, response, authentication, moduleType);
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "ACCOUNT PROFILING", "OPEN", "Module Accessed");
		return "AccountProfiling/index";
	}
	
	//24. reportsWidgets
	@RequestMapping(value="/reportWidgets", method=RequestMethod.GET)
	public String reportWidgets(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String moduleType = request.getParameter("moduleType");
		request.setAttribute("MODULETYPE", moduleType);
		request.setAttribute("UNQID", otherCommonService.getElementId());
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		request.setAttribute("MASTERSEARCHFRAME", genericMasterService.getModuleParameters(moduleType, 
				authentication.getPrincipal().toString(), userRole, request.getRemoteAddr()));
		request.setAttribute("userRole", userRole);
		//setAuditLogEntries(request, response, authentication, moduleType);
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "REPORTS WIDGETS", "OPEN", "Module Accessed");
		return "ReportWidgets/SearchTopPage";
	}


	//25. mostActiveAccounts
	@RequestMapping(value="/mostActiveAccounts", method=RequestMethod.GET)
	public String mostActiveAccounts(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String moduleType = request.getParameter("moduleType");
		request.setAttribute("MODULETYPE", moduleType);
		request.setAttribute("UNQID", otherCommonService.getElementId());
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		request.setAttribute("MASTERSEARCHFRAME", genericMasterService.getModuleParameters(moduleType, 
				authentication.getPrincipal().toString(), userRole, request.getRemoteAddr()));
		request.setAttribute("userRole", userRole);
		//setAuditLogEntries(request, response, authentication, moduleType);
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "MOST ACTIVE ACCOUNTS", "OPEN", "Module Accessed");
		return "MostActiveAccounts/index";
	}

	//26. sriLankaCTR
	@RequestMapping(value="/sriLankaCTR", method=RequestMethod.GET)
	public String sriLankaCTR(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String moduleType = request.getParameter("moduleType");
		request.setAttribute("MODULETYPE", moduleType);
		request.setAttribute("UNQID", otherCommonService.getElementId());
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		request.setAttribute("MASTERSEARCHFRAME", genericMasterService.getModuleParameters(moduleType, 
				authentication.getPrincipal().toString(), userRole, request.getRemoteAddr()));
		request.setAttribute("userRole", userRole);
		//setAuditLogEntries(request, response, authentication, moduleType);
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "SRI LANKA CTR", "OPEN", "Module Accessed");
		return "RegulatoryReports/SriLanka/CTR/index";
	}

	//27. sriLankaIEFT
	@RequestMapping(value="/sriLankaIEFT", method=RequestMethod.GET)
	public String sriLankaIEFT(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String moduleType = request.getParameter("moduleType");
		request.setAttribute("MODULETYPE", moduleType);
		request.setAttribute("UNQID", otherCommonService.getElementId());
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		request.setAttribute("MASTERSEARCHFRAME", genericMasterService.getModuleParameters(moduleType, 
				authentication.getPrincipal().toString(), userRole, request.getRemoteAddr()));
		request.setAttribute("userRole", userRole);
		//setAuditLogEntries(request, response, authentication, moduleType);
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "SRI LANKA IEFT", "OPEN", "Module Accesed");
		return "RegulatoryReports/SriLanka/IEFT/index";
	}

	//28. sriLankaOEFT
	@RequestMapping(value="/sriLankaOEFT", method=RequestMethod.GET)
	public String sriLankaOEFT(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String moduleType = request.getParameter("moduleType");
		request.setAttribute("MODULETYPE", moduleType);
		request.setAttribute("UNQID", otherCommonService.getElementId());
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		request.setAttribute("MASTERSEARCHFRAME", genericMasterService.getModuleParameters(moduleType, 
				authentication.getPrincipal().toString(), userRole, request.getRemoteAddr()));
		request.setAttribute("userRole", userRole);
		//setAuditLogEntries(request, response, authentication, moduleType);
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "SRI LANKA OEFT", "OPEN", "Module Accesed");
		return "RegulatoryReports/SriLanka/OEFT/index";
	}

	//28. maldivesMonetaryAuthority
	@RequestMapping(value="/maldivesTTRReport", method=RequestMethod.GET)
	public String maldivesTTRReport(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String moduleType = request.getParameter("moduleType");
		request.setAttribute("MODULETYPE", moduleType);
		request.setAttribute("UNQID", otherCommonService.getElementId());
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		request.setAttribute("MASTERSEARCHFRAME", genericMasterService.getModuleParameters(moduleType, 
				authentication.getPrincipal().toString(), userRole, request.getRemoteAddr()));
		request.setAttribute("userRole", userRole);
		//setAuditLogEntries(request, response, authentication, moduleType);
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "MALDIVES MONETARY AUTHORITY", "OPEN", "Module Accesed");
		return "RegulatoryReports/Maldives/TTRReport/index";
	}

	// 34. fatcacustomers
	@RequestMapping(value="/fatcacustomers", method=RequestMethod.GET)
	public String fatcacustomers(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String moduleType = request.getParameter("moduleType");
		request.setAttribute("MODULETYPE", moduleType);
		request.setAttribute("UNQID", otherCommonService.getElementId());
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		request.setAttribute("MASTERSEARCHFRAME", genericMasterService.getModuleParameters(moduleType, 
				authentication.getPrincipal().toString(), userRole, request.getRemoteAddr()));
		request.setAttribute("userRole", userRole);
		//setAuditLogEntries(request, response, authentication, moduleType);
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "FATCA CUSTOMERs", "OPEN", "Module Accessed");
		return "KYCModules/FATCACustomers/index";
	}

	//39. nepalMonetaryAuthority
	@RequestMapping(value="/nepalTTRReport", method=RequestMethod.GET)
	public String nepalTTRReport(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String moduleType = request.getParameter("moduleType");
		request.setAttribute("MODULETYPE", moduleType);
		request.setAttribute("UNQID", otherCommonService.getElementId());
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		request.setAttribute("MASTERSEARCHFRAME", genericMasterService.getModuleParameters(moduleType, 
				authentication.getPrincipal().toString(), userRole, request.getRemoteAddr()));
		request.setAttribute("userRole", userRole);
		//setAuditLogEntries(request, response, authentication, moduleType);
		
		/*commonService.auditLog(authentication.getPrincipal().toString(), request, "MALDIVES MONETARY AUTHORITY", "OPEN", "Module Accesed");*/
		commonService.auditLog(authentication.getPrincipal().toString(), request, "NEPAL MONETARY AUTHORITY", "OPEN", "Module Accessed");
		return "RegulatoryReports/Nepal/TTRReport/index";
	}

	//40. pendingUploadedFiles
	@RequestMapping(value="/pendingUploadedFiles", method=RequestMethod.GET)
	public String pendingUploadedFiles(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String moduleType = request.getParameter("moduleType");
		request.setAttribute("MODULETYPE", moduleType);
		request.setAttribute("UNQID", otherCommonService.getElementId());
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		request.setAttribute("MASTERSEARCHFRAME", genericMasterService.getModuleParameters(moduleType, 
				authentication.getPrincipal().toString(), userRole, request.getRemoteAddr()));
		request.setAttribute("userRole", userRole);
		//setAuditLogEntries(request, response, authentication, moduleType);
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "PENDING MANUAL FILE UPLOAD", "OPEN", "Module Accessed");
		return "ManualFileUpload/PendingFiles/index";
	}

	//41. actionedUploadedFiles
	@RequestMapping(value="/actionedUploadedFiles", method=RequestMethod.GET)
	public String actionedUploadedFiles(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String moduleType = request.getParameter("moduleType");
		request.setAttribute("MODULETYPE", moduleType);
		request.setAttribute("UNQID", otherCommonService.getElementId());
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		request.setAttribute("MASTERSEARCHFRAME", genericMasterService.getModuleParameters(moduleType, 
				authentication.getPrincipal().toString(), userRole, request.getRemoteAddr()));
		request.setAttribute("userRole", userRole);
		//setAuditLogEntries(request, response, authentication, moduleType);
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "ACTIONED MANUAL FILE UPLOAD", "OPEN", "Module Accessed");
		return "ManualFileUpload/ActionedFiles/index";
	}

	@RequestMapping(value="/searchGenericMaster", method=RequestMethod.POST)
	public String searchAlertEngine(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		System.out.println("in genric master");
		Map<String, String> paramMap = new LinkedHashMap<String, String>();
		Map<String, String> paramTempMap = new LinkedHashMap<String, String>();
		String moduleType = request.getParameter("moduleType");
		String buttomPageUrl = request.getParameter("bottomPageUrl");
	//	String submitButton = request.getParameter("button");
		String submitButton = request.getParameter("submitButton");

		Map<String, String[]> formData =  request.getParameterMap();
		Iterator<String> itr = formData.keySet().iterator();
		while (itr.hasNext()) {
			String tempParamName = itr.next();
			String tempParamValue = formData.get(tempParamName)[0];
//			if(!"moduleType".equals(tempParamName) && !"bottomPageUrl".equals(tempParamName) && !"submitButton".equals(tempParamName) && !"_csrf".equals(tempParamName)){
			if(!"moduleType".equals(tempParamName) && !"bottomPageUrl".equals(tempParamName)
				&& !"submitButton".equals(tempParamName) && !"_csrf".equals(tempParamName)){
				paramTempMap.put(tempParamName, tempParamValue);
			}
		}
		
		
		List<String> paramKeyList = new Vector<String>(paramTempMap.keySet());
		System.out.println("param list = "+paramKeyList);
		Collections.sort(paramKeyList, new Comparator<String>(){
			@Override
			public int compare(String str1, String str2) {
				return  (Integer.parseInt(str1.substring(0, str1.indexOf("_")))) - Integer.parseInt(str2.substring(0, str2.indexOf("_")));
			}
		});
		
		for(String paramName : paramKeyList) {
			String paramValue = formData.get(paramName)[0];
			paramMap.put(paramName, paramValue);
			request.setAttribute(paramName.substring(paramName.indexOf("_")+1), paramValue);
		}
		
		String userCode = authentication.getPrincipal().toString();
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String ipAdress = request.getRemoteAddr();
		
		request.setAttribute("submitButton", submitButton);
		request.setAttribute("moduleType", moduleType);
		request.setAttribute("moduleName", moduleType);
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("PARAMETERS", paramMap);
		request.setAttribute("USERROLE", userRole);
		request.setAttribute("SEARCHRESULT", genericMasterService.searchGenericMaster(paramMap, moduleType, userCode, userRole, ipAdress));
		//System.out.println(genericMasterService.searchGenericMaster(paramMap, moduleType, userCode, userRole, ipAdress));
		commonService.auditLog(authentication.getPrincipal().toString(), request, moduleType, "OPEN", "Module Accesed");
		return buttomPageUrl;
	}
	
	@RequestMapping(value="/getModuleDetails", method=RequestMethod.GET)
	public String getModuleDetails(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		String moduleCode = request.getParameter("moduleCode");
		String moduleValue = request.getParameter("moduleValue");
		String detailPage = request.getParameter("detailPage");
		String moduleHeader = request.getParameter("moduleHeader");
		
		String CURRENTROLE = request.getSession(false) != null ? (String) request.getSession(false).getAttribute("CURRENTROLE") : "";
		
		Map<String, Object> mainMap = genericMasterService.getModuleDetails(moduleCode, moduleValue, 
				authentication.getPrincipal().toString(), CURRENTROLE, request.getRemoteAddr());
		
		
		if("accountProfiling".equals(moduleCode)){
			String[] valuesArr = CommonUtil.splitString(moduleValue, "||");
			request.setAttribute("AP_ACCOUNTNO", valuesArr[0]);
			request.setAttribute("AP_FROMDATE", valuesArr[1]);
			request.setAttribute("AP_TODATE", valuesArr[2]);
			request.setAttribute("AP_CUSTOMERID", valuesArr[3]);
		}
		
		request.setAttribute("MODULEDETAILS", mainMap);
		request.setAttribute("moduleCode", moduleCode);
		request.setAttribute("moduleValue", moduleValue);
		request.setAttribute("detailPage", detailPage);
		request.setAttribute("moduleHeader", moduleHeader);
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("userRole", CURRENTROLE);
		commonService.auditLog(authentication.getPrincipal().toString(), request, moduleCode, "SEARCH", moduleValue+" details viewed in tab");
		return detailPage;
	}
	
	@RequestMapping(value="/showModuleDetailsInWindow", method=RequestMethod.GET)
	public String showModuleDetailsInWindow(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		String moduleCode = request.getParameter("moduleCode");
		String moduleValue = request.getParameter("moduleValue");
		String detailPage = request.getParameter("detailPage");
		String moduleHeader = request.getParameter("moduleHeader");
		
		request.setAttribute("moduleCode", moduleCode);
		request.setAttribute("moduleValue", moduleValue);
		request.setAttribute("detailPage", detailPage);
		request.setAttribute("moduleHeader", moduleHeader);
		request.setAttribute("UNQID", otherCommonService.getElementId());
		commonService.auditLog(authentication.getPrincipal().toString(), request, moduleCode, "SEARCH", moduleValue+" details viewed in window");
		return "/common/showModuleDetailsInWindow";
	}
	
	@RequestMapping(value="/updateCustomerEntityEnrichment", method=RequestMethod.POST)
	public @ResponseBody String updateCustomerEntityEnrichment(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		String fieldsData = request.getParameter("fieldsData");
		String status = request.getParameter("status");
		String customerId = request.getParameter("customerId");
		String groupCode = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String ipAddress = request.getRemoteAddr();
		String userCode = authentication.getPrincipal().toString();
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CUSTOMER MASTER", "UPDATE", "Entity enrichment updated for "+customerId);
		return genericMasterService.updateCustomerEntityEnrichment(fieldsData, status, customerId, userCode, groupCode, ipAddress);
	}

	@RequestMapping(value="/updateCustomerOverRideRiskDetails", method=RequestMethod.POST)
	public @ResponseBody String updateCustomerOverRideRiskDetails(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		String fieldsData = request.getParameter("fieldsData");
		String status = request.getParameter("status");
		String customerId = request.getParameter("customerId");
		String userCode = authentication.getPrincipal().toString();
		String groupCode = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String ipAddress = request.getRemoteAddr();
		request.setAttribute("userRole", groupCode);
		//System.out.println("In controller : "+fieldsData+" ,status="+status+" ,usercode="+userCode);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CUSTOMER MASTER", "UPDATE", "Customer Risk rating Override Comments updated for "+customerId);
		return genericMasterService.updateCustomerOverRideRiskDetails(fieldsData, status, customerId, userCode, groupCode, ipAddress);
	}

	@RequestMapping(value="/updateProductExclusionDetails", method=RequestMethod.POST)
	public @ResponseBody String updateProductExclusionDetails(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		String fieldsData = request.getParameter("fieldsData");
		String status = request.getParameter("status");
		String productCode = request.getParameter("productCode");
		String userCode = authentication.getPrincipal().toString();
		String groupCode = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String ipAddress = request.getRemoteAddr();
		//System.out.println("In controller : "+fieldsData+" ,status="+status+" ,usercode="+userCode+" ,productCode = "+productCode);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "PRODUCTS MASTER", "UPDATE", "Product Exlcusion Comments updated for "+productCode);
		return genericMasterService.updateProductExclusionDetails(fieldsData, status, productCode, userCode, groupCode, ipAddress);
	}
	
	@RequestMapping(value="/updateSubGroupingCodeDetails", method=RequestMethod.POST)
	public @ResponseBody String updateSubGroupingCodeDetails(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		String fieldsData = request.getParameter("fieldsData");
		String status = request.getParameter("status");
		String transactionType = request.getParameter("transactionType");
		String userCode = authentication.getPrincipal().toString();
		String groupCode = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String ipAddress = request.getRemoteAddr();
		//System.out.println("In controller : "+fieldsData+" ,status="+status+" ,usercode="+userCode+" ,productCode = "+productCode);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "TRANSACTION TYPE MASTER", "UPDATE", "Sub Grouping Code updated for "+transactionType);
		return genericMasterService.updateSubGroupingCodeDetails(fieldsData, status, transactionType, userCode, groupCode, ipAddress);
	}
	
	@RequestMapping(value="/raiseSuspicion", method=RequestMethod.GET)
	public String raiseSuspicion(HttpServletRequest request, HttpServletResponse httpServletResponse, Authentication authentication){
		String moduleType = request.getParameter("moduleType");
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String userCode = authentication.getPrincipal().toString();
		String ipAddress = request.getRemoteAddr();
		request.setAttribute("userRole", userRole);
		request.setAttribute("userCode", userCode);
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("RASUSERSLIST", genericMasterService.getRASUsersList(userCode, userRole, ipAddress));
		request.setAttribute("BRANCHCODES", genericMasterService.getOptionNameValueFromView("VW_BRANCHCODE"));
		request.setAttribute("RAISEOFSUSPICION", genericMasterService.getOptionNameValueFromView("VW_TYPEOFSUSPICION"));
		commonService.auditLog(authentication.getPrincipal().toString(), request, moduleType, "READ", "Module Accessed");
		return "RaiseSuspicion/index";
	}

	@RequestMapping(value="/findSuspiciousTransaction", method=RequestMethod.POST)
	public String findSuspiciousTransaction(HttpServletRequest request, HttpServletResponse response, Authentication authentication){
		String alertCode = request.getParameter("alertCode");
		
		request.setAttribute("alertNo", alertCode);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "raiseSuspicion", "READ", "Transaction will be added for : "+alertCode);
		return "RaiseSuspicion/SuspiciousTransactionModal";
	}
	
	@RequestMapping(value="/saveSuspiciousTransaction", method=RequestMethod.POST)
	public String saveSuspiciousTransaction(HttpServletRequest request,HttpServletResponse response, Authentication authentication){
		String alertNo = request.getParameter("alertNo");
		String txnDate = request.getParameter("txnDate");
		String txnMode = request.getParameter("txnMode");
		String debitcredit = request.getParameter("debitcredit");
		String amount = request.getParameter("amount");
		String remarks = request.getParameter("remarks");
		
		alertNo = genericMasterService.saveSuspiciousTransaction(alertNo, txnDate, txnMode, debitcredit, amount, remarks, authentication.getPrincipal().toString());
		request.setAttribute("alertNo", alertNo);
		request.setAttribute("result", genericMasterService.getSuspiciousTransaction(alertNo));
		commonService.auditLog(authentication.getPrincipal().toString(), request, "RAISE SUSPICION", "CREATE", "Transaction Add for "+alertNo);
		return "RaiseSuspicion/SuspiciousTransactionsTable";
	}
	
	@RequestMapping(value="/showSuspiciousTransactionDetails", method=RequestMethod.POST)
	public String showSuspiciousTransactionDetails(HttpServletRequest request, HttpServletResponse response, Authentication authentication){
		String seqNo = request.getParameter("seqNo");
		String alertNo = request.getParameter("alertNo");
		
		request.setAttribute("alertNo", alertNo);
		request.setAttribute("seqNo", seqNo);
		request.setAttribute("DATA", genericMasterService.showSuspiciousTransactionDetails(seqNo, alertNo));
		request.setAttribute("DATA", genericMasterService.showSuspiciousTransactionDetails(seqNo, alertNo));
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "RAISE SUSPICION", "OPEN", "Module Accesed");
		return "RaiseSuspicion/SuspiciousTransactionModal";
	}
	
	@RequestMapping(value="/deleteSuspiciousTransactionDetails",method=RequestMethod.POST)
	public String deleteSuspiciousTransactionDetails(HttpServletRequest request, HttpServletResponse response, Authentication authentication){
		String seqNo = request.getParameter("seqNo");
		String alertNo = request.getParameter("alertNo");
		
		alertNo = genericMasterService.deleteSuspiciousTransactionDetails(seqNo, alertNo);
		request.setAttribute("alertNo", alertNo);
		request.setAttribute("result", genericMasterService.getSuspiciousTransaction(alertNo));
		commonService.auditLog(authentication.getPrincipal().toString(), request, "RAISE SUSPICION", "DELETE", "Transaction deleted for "+alertNo);
		return "RaiseSuspicion/SuspiciousTransactionsTable";
	}
	
	@RequestMapping(value="/updateSuspiciousTransaction", method=RequestMethod.POST)
	public String updateSuspiciousTransaction(HttpServletRequest request,HttpServletResponse response, Authentication authentication){
		String alertNo = request.getParameter("alertNo");
		String seqNo = request.getParameter("seqNo");
		String txnDate = request.getParameter("txnDate");
		String txnMode = request.getParameter("txnMode");
		String debitcredit = request.getParameter("debitcredit");
		String amount = request.getParameter("amount");
		String remarks = request.getParameter("remarks");
		
		alertNo = genericMasterService.updateSuspiciousTransaction(alertNo, seqNo, txnDate, txnMode, debitcredit, amount, remarks, authentication.getPrincipal().toString());
		request.setAttribute("alertNo", alertNo);
		request.setAttribute("result", genericMasterService.getSuspiciousTransaction(alertNo));
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "RAISE SUSPICION", "UPDATE", "Transaction updated for "+alertNo);
		return "RaiseSuspicion/SuspiciousTransactionsTable";
	}

	/*@RequestMapping(value="/submitReportOfSuspicion", method=RequestMethod.POST)
	public @ResponseBody String submitReportOfSuspicion(HttpServletRequest request,HttpServletResponse response, Authentication authentication){
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
		
		//System.out.println("Controller - repeatSAR = "+repeatSAR+"repeatSARRemarks = "+repeatSARRemarks+"sourceOfInternalSAR = "+sourceOfInternalSAR);
		
		genericMasterService.submitReportOfSuspicion(alertNo, reportingOn, branchCode, accountOrPersonName, alertRating, accountNo, customerId,
					address1, address2, typeOfSuspicion, reasonForSuspicion, referenceCaseNo, referenceCaseDate, 
					repeatSAR, repeatSARRemarks, sourceOfInternalSAR, 
					authentication.getPrincipal().toString(), "userRole", request.getRemoteAddr());
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "RAISE SUSPICION", "INSERT", "Suspicion raised "+alertNo);
		return "Alert has been generated and case has been assigned to user.";
	}
	*/
	
	@RequestMapping(value="/submitReportOfSuspicion", method=RequestMethod.POST)
	public @ResponseBody String submitReportOfSuspicion(HttpServletRequest request,HttpServletResponse response, Authentication authentication){
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
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
		String eddQuestions = request.getParameter("eddQuestions");
		
		/*Map<String, Object> dataMap = genericMasterService.validationCheck(accountNo, customerId);
		String ACCOUNTNOCOUNT = (String) dataMap.get("ACCOUNTNO");
		String CUSTOMERIDCOUNT = (String) dataMap.get("CUSTOMERID");
		
		int accNoCount = Integer.parseInt(ACCOUNTNOCOUNT);
		int custIdCount = Integer.parseInt(CUSTOMERIDCOUNT);
		
		if(accNoCount < 1 || custIdCount < 1){
			return "AccountNo/CustomerID is invalid.";
		}else{
			genericMasterService.submitReportOfSuspicion(alertNo, reportingOn, branchCode, accountOrPersonName, alertRating, accountNo, customerId,
					others, address1, address2, typeOfSuspicion, reasonForSuspicion, authentication.getPrincipal().toString(), "userRole", request.getRemoteAddr());
			commonService.auditLog(authentication.getPrincipal().toString(), request, "RAISE SUSPICION", "INSERT", "Suspicion raised "+alertNo);
			return "Alert has been generated and case has been assigned to user.";
		}*/
		
		String message = genericMasterService.submitReportOfSuspicion(alertNo, reportingOn, branchCode, accountOrPersonName, alertRating, accountNo, customerId,
				others, address1, address2, typeOfSuspicion, reasonForSuspicion, rasUserCode, authentication.getPrincipal().toString(), userRole, request.getRemoteAddr());
		/* 07.12.2020 */
		if("SUCCESS".equals(message.split("~~~")[1])) {
			System.err.println("message = "+message);
			genericMasterService.saveEddQuestionRecords(message.split("~~~")[2], eddQuestions, authentication.getPrincipal().toString(), userRole, request.getRemoteAddr());
		}
		commonService.auditLog(authentication.getPrincipal().toString(), request, "RAISE SUSPICION", "INSERT", "Suspicion raised "+alertNo);
		//return "Alert has been generated and case has been assigned to user.";
		return message.split("~~~")[0];
	}
	
	@RequestMapping(value="/getLinkedTransactionsForAlerts", method=RequestMethod.GET)
	public String getLinkedTransactionsForAlerts(HttpServletRequest request, HttpServletResponse response, Authentication authentication){
		String alertNo = request.getParameter("alertNo");
		request.setAttribute("LINKEDTXNS", genericMasterService.getLinkedTransactions(alertNo));
		commonService.auditLog(authentication.getPrincipal().toString(), request, "ALERT ENGINE", "READ", "Displayed Linked Transaction for Alert No : "+alertNo);
		return "AlertEngines/AlertLinkedTransactions";
	}
	
	@RequestMapping(value="/genericModuleFieldsSearch", method=RequestMethod.POST)
	public String genericModuleFieldsSearch(HttpServletRequest request, HttpServletResponse response, Authentication authentication){
		String searchFieldId = request.getParameter("searchFieldId");
		String serachFor = request.getParameter("serachFor");
		String viewName = request.getParameter("viewName");
		String isMultipleSelect = request.getParameter("isMultipleSelect");
		request.setAttribute("VIEWCOLS", genericMasterService.getViewOrTableColumns(viewName));
		request.setAttribute("searchFieldId", searchFieldId);
		request.setAttribute("serachFor", serachFor);
		request.setAttribute("viewName", viewName);
		request.setAttribute("isMultipleSelect", isMultipleSelect);
		request.setAttribute("UNQID", otherCommonService.getElementId());
		commonService.auditLog(authentication.getPrincipal().toString(), request, "GENERIC SEARCH : "+serachFor, "SEARCH", "Open generic search module to serach for "+serachFor);
		return "common/SearchModule/index";
	}
	
	
	@RequestMapping(value="/searchGenericModuleFields", method=RequestMethod.POST)
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
		commonService.auditLog(authentication.getPrincipal().toString(), request, "GENERIC SEARCH : "+serachFor, "SEARCH", "Searching generic search for : "+serachFor+", Search By : "+moduleSearchBy+", Search Type : "+moduleSearchType+", input : "+moduleSearchValue);
		return "common/SearchModule/SearchBottomFrame";
	}
	
	@RequestMapping(value="/getDocumentFromWSDL", method=RequestMethod.GET)
	public ModelAndView getDocumentFromWSDL(HttpServletRequest request, HttpServletResponse response, Authentication authentication){
		String documentCode = request.getParameter("docCode");
		String customerId = request.getParameter("customerId");
		System.out.println("customerId:  "+customerId+", documentCode: "+documentCode);

		Map<String, Object> documentDetails =  genericMasterService.getDocumentFromWSDL(customerId, documentCode);
		
		byte[] btDataFile;
		try {
		/*	
    	Map<String, String> documentDetails = new HashMap<String, String>();
    	File file = new File("D:\\SOAPFiles\\dmsout.txt");
        InputStream inputStream= new FileInputStream(file);
        Reader reader = new InputStreamReader(inputStream,"UTF-8");
        InputSource is = new InputSource(reader);
        
		//is.setCharacterStream(new StringReader(soapResponse.getSOAPPart().getTextContent()));
		
		DocumentBuilder documentBuilder = DocumentBuilderFactory.newInstance().newDocumentBuilder();
		Document doc = documentBuilder.parse(is);
		
		//doc.getDocumentElement().normalize();
	    String rootELement = doc.getDocumentElement().getNodeName();
	    NodeList nodeList = doc.getElementsByTagName("return");
	    //System.out.println(" Length is : "+nodeList.getLength());
	    //for (int i=0; i < nodeList.getLength(); i++) {
    	NodeList innerResultList = nodeList.item(0).getChildNodes();
    	System.out.println(" Length is : "+innerResultList.getLength());
        for (int l = 0; l < innerResultList.getLength(); l++) {
        	Element element = (Element)innerResultList.item(l);
        	//System.out.println("NodeName : "+element.getNodeName());
        	if(!element.getNodeName().equalsIgnoreCase("imagebinary"))
        	System.out.println("NodeName : "+element.getNodeName()+" And value is : "+element.getTextContent());
        	documentDetails.put(element.getNodeName(), element.getTextContent());
        }

		*/
			//System.out.println("documentDetails:  "+documentDetails);
			btDataFile = new sun.misc.BASE64Decoder().decodeBuffer(documentDetails.get("imagebinary").toString());
			//System.out.println("btDataFile:  "+btDataFile);
			/*
	        File of = new File("D://SOAPFiles//"+"filename."+documentDetails.get("imageExt")); // extension to be passed
			FileOutputStream osf = new FileOutputStream(of);
			osf.write(btDataFile);
			osf.flush();
			*/
			String fileName = customerId+"_"+documentCode.replaceAll(" ", "_")+"."+documentDetails.get("imageExt");
			
			response.setContentType("APPLICATION/OCTET-STREAM");
	        String disHeader = "Attachment;Filename=\""+fileName+"\"";
	        response.setHeader("Content-disposition", disHeader);
	        ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
	        byteArrayOutputStream.write(btDataFile);
	        response.setContentLength(btDataFile.length);
	        byteArrayOutputStream.writeTo(response.getOutputStream());
	        byteArrayOutputStream.flush();
	        byteArrayOutputStream.close();
	        
		} catch (IOException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}

		// request.setAttribute("DOCUMENT", genericMasterService.getDocumentFromWSDL(customerId, documentCode));
		
		return null;
	}
	
	private void setAuditLogEntries(HttpServletRequest request, HttpServletResponse response, Authentication authentication, String moduleType){
		commonService.auditLog(authentication.getPrincipal().toString(), request, moduleType, "READ", "Module Accessed");
	}
	
	@RequestMapping(value="/disabledColumnsMethod", method=RequestMethod.POST)
	public @ResponseBody Map<String,Object> disabledColumnsMethod(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String disabledColumn = request.getParameter("disabledColumnArray");
		String moduleCode = request.getParameter("moduleCode");
		String[] disabledColumns = disabledColumn.split(",");
		String userCode = authentication.getPrincipal().toString();
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String ipAdress = request.getRemoteAddr();

		return genericMasterService.saveDisabledColumnsData(disabledColumns, moduleCode, userCode, userRole, ipAdress);
	}
	
	/*@RequestMapping(value="/validationCheck", method=RequestMethod.POST)
	public String validationCheck(HttpServletRequest request,HttpServletResponse response, Authentication authentication){
		String accountNo = request.getParameter("accountNo");
		String customerId = request.getParameter("customerId");
		
		Map<String, Object> dataMap = genericMasterService.validationCheck(accountNo, customerId);
		request.setAttribute("ACCOUNTNOCOUNT", dataMap.get("ACCOUNTNO"));
		request.setAttribute("CUSTOMERIDCOUNT", dataMap.get("CUSTOMERID"));
		
		return "RaiseSuspicion/index";
	}*/

	@RequestMapping(value="/approveFileUpload", method=RequestMethod.POST)
	public String approveFileUpload(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String parameters = request.getParameter("parameters");
		String selectedFiles = request.getParameter("selectedFiles");
		String status = request.getParameter("status");
		String searchButton = request.getParameter("searchButton");
		
		request.setAttribute("parameters", parameters);
		request.setAttribute("selectedFiles", selectedFiles);
		request.setAttribute("status", status);	
		request.setAttribute("searchButton", searchButton);	
		return "ManualFileUpload/PendingFiles/FileUploadCommentsModal";
	}
	
	@RequestMapping(value="/rejectFileUpload", method=RequestMethod.POST)
	public String rejectFileUpload(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String parameters = request.getParameter("parameters");
		String selectedFiles = request.getParameter("selectedFiles");
		String status = request.getParameter("status");
		String searchButton = request.getParameter("searchButton");

		request.setAttribute("parameters", parameters);
		request.setAttribute("selectedFiles", selectedFiles);
		request.setAttribute("status", status);
		request.setAttribute("searchButton", searchButton);	
		return "ManualFileUpload/PendingFiles/FileUploadCommentsModal";
	}
	
	@RequestMapping(value="/saveFileUploadComments", method=RequestMethod.POST)
	public @ResponseBody String saveFileUploadComments(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String parameters = request.getParameter("parameters");
		String selectedFiles = request.getParameter("selectedFiles");
		String status = request.getParameter("status");
		String markAll = request.getParameter("markAll");
		String comments = request.getParameter("comments");
		System.out.println(parameters);
		String userCode = authentication.getPrincipal().toString();
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String ipAddress = request.getRemoteAddr();
		request.setAttribute("userRole", userRole);
		
		return commonService.saveFileUploadComments(parameters,selectedFiles,status,markAll,comments,userCode,userRole,ipAddress);
	}
	
	@RequestMapping(value="/getFileTypeAndName", method=RequestMethod.GET)
	public @ResponseBody Map<String,Object> getFileTypeAndName(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String parameters = request.getParameter("parameters");
		System.out.println(parameters);
		String number = request.getParameter("number");
		String isLoggedData = request.getParameter("isLoggedData") == null ? "N":request.getParameter("isLoggedData");
		String userCode = authentication.getPrincipal().toString();
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String ipAddress = request.getRemoteAddr();
		return genericMasterService.getFileTypeAndName(parameters,number,userCode,userRole,ipAddress);
	}
	
	@RequestMapping(value="/emailQuestionRepository", method=RequestMethod.GET)
	public String emailQuestionRepository(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String moduleType = request.getParameter("moduleType");
		request.setAttribute("MODULETYPE", moduleType);
		request.setAttribute("UNQID", otherCommonService.getElementId());
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		request.setAttribute("MASTERSEARCHFRAME", genericMasterService.getModuleParameters(moduleType, 
				authentication.getPrincipal().toString(), userRole, request.getRemoteAddr()));
		request.setAttribute("userRole", userRole);
		//setAuditLogEntries(request, response, authentication, moduleType);
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "BANK MASTER", "OPEN", "Module Accessed");
		return "MasterModules/EmailQuestionRepositoryMaster/index";
	}	
	
	/*@RequestMapping(value="/getTransactionData", method=RequestMethod.GET)
	public String getTransactionData(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String accountNo = request.getParameter("accNo");
		request.setAttribute("ACCOUNTNO", accountNo);
		String moduleType = "transactionDetailsMasterNew";
		request.setAttribute("MODULETYPE", moduleType);
		request.setAttribute("UNQID", otherCommonService.getElementId());
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		commonService.auditLog(authentication.getPrincipal().toString(), request, "TRANSACTION DETAILS MASTER", "OPEN", "Module Accessed");
		return "MasterModules/AccountsMaster/TransactionWindow";
	}*/
	
	//New ACCOUNT PROFILING - Keystone Bank
	@RequestMapping(value="/getNonCashChannelDetails", method=RequestMethod.POST)
	public String getNonCashChannelDetails(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		String channelType = request.getParameter("channelType");
		String detailPage = request.getParameter("detailPage");
		String ap_fromDate = request.getParameter("ap_fromDate");
		String ap_toDate = request.getParameter("ap_toDate");
		String ap_accountNo = request.getParameter("ap_accountNo");
		String ap_custId = request.getParameter("ap_custId");
		String userCode = authentication.getPrincipal().toString();
		String ipAdress = request.getRemoteAddr();

		List<Map<String, String>> mainMap = genericMasterService.getNonCashChannelDetails(channelType, userCode, ipAdress, 
				ap_fromDate, ap_toDate, ap_accountNo, ap_custId);
		
		request.setAttribute("CHANNELTYPE", channelType);
		request.setAttribute("WHOLEDATA", mainMap);
		request.setAttribute("UNQID", otherCommonService.getElementId());
		commonService.auditLog(authentication.getPrincipal().toString(), request, "Account Profiling", "SEARCH", "Non Cash channel details viewed in table");
		return detailPage;
	}
	
	@RequestMapping(value="/getNonCashTransactionDetails", method=RequestMethod.POST)
	public String getNonCashTransactionDetails(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		String counterPartyName = request.getParameter("counterPartyName");
		String channelType = request.getParameter("channelType");
		String detailPage = request.getParameter("detailPage");
		String ap_fromDate = request.getParameter("ap_fromDate");
		String ap_toDate = request.getParameter("ap_toDate");
		String ap_accountNo = request.getParameter("ap_accountNo");
		String ap_custId = request.getParameter("ap_custId");
		String userCode = authentication.getPrincipal().toString();
		String ipAdress = request.getRemoteAddr();
		
		List<Map<String, String>> mainMap = genericMasterService.getNonCashTransactionDetails(counterPartyName, channelType, userCode, ipAdress, 
				ap_fromDate, ap_toDate, ap_accountNo, ap_custId);
		
		request.setAttribute("COUNTERPARTYNAME", counterPartyName);
		request.setAttribute("CHANNELTYPE", channelType);
		request.setAttribute("WHOLEDATA", mainMap);
		request.setAttribute("UNQID", otherCommonService.getElementId());
		commonService.auditLog(authentication.getPrincipal().toString(), request, "Account Profiling", "SEARCH", "Non Cash channel details viewed in table");
		return detailPage;
	}
	
	/*  07.12.2020 */
	@RequestMapping(value="/getEddQuestions", method=RequestMethod.POST)
	public @ResponseBody Map<String, String> getEddQuestions(HttpServletRequest request,HttpServletResponse response, Authentication authentication){
		String accountType = request.getParameter("accountType");
		String userCode = authentication.getPrincipal().toString();
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String ipAddress = request.getRemoteAddr();
		
		Map<String, String> eddQuestions = genericMasterService.getEddQuestions(accountType, userCode, 
				userRole, ipAddress);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "EDD QUESTIONS", "SEARCH", "Searched EDD Questions for "+accountType+" Account Type");
		return eddQuestions;
	}
	
	@RequestMapping(value="/viewEDDQuestionRecords", method=RequestMethod.POST)
	public String viewEDDQuestionRecords(HttpServletRequest request,HttpServletResponse response, Authentication authentication){
		String caseNo = request.getParameter("caseNo");
		String userCode = authentication.getPrincipal().toString();
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String ipAddress = request.getRemoteAddr();
		
		Map<String, String> eddQuestions = genericMasterService.getEddQuestions("", userCode, 
				userRole, ipAddress);
		Map<String, String> eddQuestionRecords = genericMasterService.viewEDDQuestionRecords(caseNo, userCode, 
				userRole, ipAddress);
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("CASENO", caseNo);
		request.setAttribute("USERROLE", userRole);
		request.setAttribute("EDDQUESTIONS", eddQuestions);
		request.setAttribute("EDDQUESTIONRECORDS", eddQuestionRecords);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "EDD QUESTIONS", "SEARCH", "Searched EDD Question Records for "+caseNo+" Case No");
		return "common/template/eddQuestionsModal";
	}
	
	@RequestMapping(value="/updateEddQuestionRecords", method=RequestMethod.POST)
	public @ResponseBody String updateEddQuestionRecords(HttpServletRequest request,HttpServletResponse response, Authentication authentication){
		String caseNo = request.getParameter("caseNo");
		String eddQuestions = request.getParameter("eddQuestions");
		String userCode = authentication.getPrincipal().toString();
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String ipAddress = request.getRemoteAddr();
		
		String result = genericMasterService.updateEddQuestionRecords(caseNo, eddQuestions, userCode, 
				userRole, ipAddress);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "EDD QUESTIONS", "UPDATE", "Updated EDD Questions for "+caseNo+" Case No");
		return result;
	}
	
	@RequestMapping(value="/fetchAccountRelatedData", method=RequestMethod.POST)
	public @ResponseBody Map<String, String> fetchAccountRelatedData(HttpServletRequest request,HttpServletResponse response, Authentication authentication){
		String accountNo = request.getParameter("accountNo");
		String userCode = authentication.getPrincipal().toString();
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String ipAddress = request.getRemoteAddr();
		
		Map<String, String> result = genericMasterService.fetchAccountRelatedData(accountNo, userCode, 
				userRole, ipAddress);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "RAISE SUSPICION", "FETCH", "Fetched Account Related Data for "+accountNo+" Account No");
		return result;
	}
	
	@RequestMapping(value="/viewAccountRSPTransactions", method=RequestMethod.POST)
	public String viewAccountRSPTransactions(HttpServletRequest request,HttpServletResponse response, Authentication authentication){
		String accountNo = request.getParameter("accountNo");
		String alertNo = request.getParameter("alertNo");
		String userCode = authentication.getPrincipal().toString();
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String ipAddress = request.getRemoteAddr();
		
		Map<String, Object> alertTxnMappings = genericMasterService.fetchAlertNoTxnNoMappings(alertNo, userCode, 
				userRole, ipAddress);
		request.setAttribute("ALERTTXNMAPPINGS", alertTxnMappings);
		request.setAttribute("ACCOUNTNO", accountNo);
		request.setAttribute("ALERTNO", alertNo);
		request.setAttribute("USERROLE", userRole);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "RAISE SUSPICION", "FETCH", "Fetched Account Related Transactions Data for "+accountNo+" Account No");
		return "RaiseSuspicion/AccountRSPTransactionsModal";
	}
	
	@RequestMapping(value="/fetchAccountNoBasedTransactions", method=RequestMethod.POST)
	public @ResponseBody Map<String, Object> fetchAccountNoBasedTransactions(HttpServletRequest request,HttpServletResponse response, Authentication authentication){
		String accountNo = request.getParameter("accountNo");
		String fromDate = request.getParameter("fromDate");
		String toDate = request.getParameter("toDate");
		String userCode = authentication.getPrincipal().toString();
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String ipAddress = request.getRemoteAddr();
		
		Map<String, Object> accountTransactions = genericMasterService.fetchAccountNoBasedTransactions(
				accountNo, fromDate, toDate, userCode, userRole, ipAddress);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "RAISE SUSPICION", "FETCH", "Fetched Account Related Transactions Data for "+accountNo+" Account No");
		return accountTransactions;
	}
	
	@RequestMapping(value="/updateAccountRSPTransactions", method=RequestMethod.POST)
	public @ResponseBody Map<String, Object> updateAccountRSPTransactions(HttpServletRequest request,HttpServletResponse response, Authentication authentication){
		String alertNo = request.getParameter("alertNo");
		String accountNo = request.getParameter("accountNo");
		String transactionNo = request.getParameter("transactionNo");
		String action = request.getParameter("action");
		String userCode = authentication.getPrincipal().toString();
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String ipAddress = request.getRemoteAddr();
		
		Map<String, Object> accountTransactions = genericMasterService.updateAccountRSPTransactions(
				alertNo, accountNo, transactionNo, action, userCode, userRole, ipAddress);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "RAISE SUSPICION", action, "Updated Raise Suspicion Transactions for "+accountNo+" Account No");
		return accountTransactions;
	}
	
	@RequestMapping(value="/getEddQuestionCount", method=RequestMethod.POST)
	public @ResponseBody int getEddQuestionCount(HttpServletRequest request, 
			HttpServletResponse response, Authentication authentication){
		String caseNo = request.getParameter("caseNo");
		String userCode = authentication.getPrincipal().toString();
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String ipAddress = request.getRemoteAddr();
		
		int eddQuestionCount = genericMasterService.getEddQuestionCount(caseNo, userCode, 
				userRole, ipAddress);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "EDD QUESTIONS", "SEARCH", "EDD Questions Count for Case No "+caseNo);
		return eddQuestionCount;
	}
}

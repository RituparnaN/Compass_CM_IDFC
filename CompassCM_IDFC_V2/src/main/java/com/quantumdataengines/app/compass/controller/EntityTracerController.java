package com.quantumdataengines.app.compass.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.quantumdataengines.app.compass.otherservice.OtherCommonService;
import com.quantumdataengines.app.compass.service.CommonService;
import com.quantumdataengines.app.compass.service.entityTracer.EntityTracerService;
import com.quantumdataengines.app.compass.view.MultiSheetExcelView;
import com.quantumdataengines.app.listScanning.test.Search;

@Controller
@RequestMapping(value="/common")
public class EntityTracerController {
	private Logger log = LoggerFactory.getLogger(EntityTracerController.class);
	@Autowired
	private EntityTracerService EntityTracerService;
	@Autowired
	private OtherCommonService otherCommonService;
	@Autowired
	private CommonService commonService;
	
	@RequestMapping(value = "/getEntityLinkedDetailsExcel", method=RequestMethod.GET)
	public ModelAndView getEntityLinkedDetailsExcel(HttpServletRequest request, HttpServletResponse response, Authentication authentication){
		String userCode = authentication.getPrincipal().toString();
		
		String accountNumber = request.getParameter("AccountNumber");
		String customerId = request.getParameter("CustomerId");
		String customerName = request.getParameter("CustomerName");
		String fromDate = request.getParameter("FromDate");
		String toDate = request.getParameter("ToDate");
		String staticLink = request.getParameter("StaticLink");
		String transactionLink = request.getParameter("TransactionLink");
		// String minLinks = request.getParameter("MinLinks");
		String counterAccountNo = request.getParameter("CounterAccountNo");
		String counterAccountGroup = request.getParameter("CounterAccountGroup") == null ? "":request.getParameter("CounterAccountGroup");
		// String levelCount = request.getParameter("LevelCount");
		String productCode = request.getParameter("ProductCode");
		String message = "";
		
		int minLinks = 0;
		int levelCount = 0;
		boolean isStaticLink = false;
		boolean isTransactionLink = false;
		
		try{
			minLinks = Integer.parseInt(request.getParameter("MinLinks"));
		}catch(NumberFormatException e){
			message = "Enter a valid number for min links";
		}
		
		try{
			levelCount = Integer.parseInt(request.getParameter("LevelCount"));
		}catch(NumberFormatException e){
			message = "Enter a valid number for level count";
		}
		
		if(staticLink != null && staticLink.equalsIgnoreCase("y"))
			isStaticLink = true;
		if(transactionLink != null && transactionLink.equalsIgnoreCase("y"))
			isTransactionLink = true;
		

		Map<String, Object> mainMap = EntityTracerService.getLinkedTracer(accountNumber, customerId, customerName, fromDate, 
				toDate, isStaticLink, isTransactionLink, minLinks, counterAccountNo, levelCount, productCode, counterAccountGroup);
		// Temporarily by Govind on 6th Oct 2016
		 ModelAndView modelAndView = new ModelAndView(new MultiSheetExcelView(), mainMap);
		//return modelAndView;
		commonService.auditLog(authentication.getPrincipal().toString(), request, "ENTITY TRACER", "DOWNLOAD", "File Downloaded");
		return modelAndView;
	}
	
	/*@RequestMapping(value = "/getEntityLinkedDetailsMatrix", method=RequestMethod.GET)
	public ModelAndView getEntityLinkedDetailsMatrix(HttpServletRequest request, HttpServletResponse response, Authentication authentication){
		//System.out.println("getEntityLinkedDetailsMatrix:  ");
		ModelAndView modelAndView = new ModelAndView("/EntityTracer/EntityTracerMatrixGraphView");
		String userCode = authentication.getPrincipal().toString();
		
		String accountNumber = request.getParameter("AccountNumber");
		String customerId = request.getParameter("CustomerId");
		String customerName = request.getParameter("CustomerName");
		String fromDate = request.getParameter("FromDate");
		String toDate = request.getParameter("ToDate");
		String staticLink = request.getParameter("StaticLink");
		String transactionLink = request.getParameter("TransactionLink");
		// String minLinks = request.getParameter("MinLinks");
		String counterAccountNo = request.getParameter("CounterAccountNo");
		String counterAccountGroup = request.getParameter("CounterAccountGroup") == null ? "":request.getParameter("CounterAccountGroup");
		// String levelCount = request.getParameter("LevelCount");
		String productCode = request.getParameter("ProductCode");
		String message = "";
		
		int minLinks = 0;
		int levelCount = 0;
		boolean isStaticLink = false;
		boolean isTransactionLink = false;
		
		try{
			minLinks = Integer.parseInt(request.getParameter("MinLinks"));
		}catch(NumberFormatException e){
			message = "Enter a valid number for min links";
		}
		
		try{
			levelCount = Integer.parseInt(request.getParameter("LevelCount"));
		}catch(NumberFormatException e){
			message = "Enter a valid number for level count";
		}
		
		if(staticLink != null && staticLink.equalsIgnoreCase("y"))
			isStaticLink = true;
		if(transactionLink != null && transactionLink.equalsIgnoreCase("y"))
			isTransactionLink = true;
		
		/*
		Map<String, Object> mainMap = EntityTracerService.getLinkedTracer(accountNumber, customerId, customerName, toDate, 
				toDate, isStaticLink, isTransactionLink, minLinks, counterAccountNo, levelCount, productCode, counterAccountGroup);
		*/		
	/*	Search objSearch = new Search();
		//System.out.println("accountNumber:  "+accountNumber+",	counterAccountNo: "+counterAccountNo);
		HashMap hashMap = objSearch.fetchData(accountNumber,counterAccountNo, userCode);
		//HashMap<String, Object> hashMap = (HashMap<String, Object>)objSearch.fetchData("50230100002700", "50230100007956", userCode);
		//System.out.println("hashMap:  "+hashMap);
		String linkedFilePathName = hashMap.get("linkedFilePathName") == null ? "N.A.":hashMap.get("linkedFilePathName").toString();
		//System.out.println("linkedFilePathName:  "+linkedFilePathName);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "ENTITY MATRIX TRACER", "DOWNLOAD", "File Downloaded");
		request.setAttribute("EntityTracerMatrixData", hashMap);
		//request.setAttribute("EXCULDEDPRODUCTCODE", EntityTracerService.getExcludedProductCodes());
		request.setAttribute("EXCULDEDPRODUCTCODE", productCode);
		request.setAttribute("FromDate", fromDate);
		request.setAttribute("ToDate", toDate);
		request.setAttribute("AccountNumber", "50230100002700");
		request.setAttribute("CustomerId", customerId);
		request.setAttribute("CustomerName", customerName);
		request.setAttribute("StaticLink", staticLink);
		request.setAttribute("TransactionLink", transactionLink);
		request.setAttribute("MinLinks", request.getParameter("MinLinks"));
		request.setAttribute("CounterAccountNo", "50230100007956");
		request.setAttribute("CounterAccountGroup", counterAccountGroup);
		request.setAttribute("LevelCount", request.getParameter("LevelCount"));
		request.setAttribute("Message", message);
		
		return modelAndView;
	}*/

	@RequestMapping(value = "/getEntityLinkedPage") 
	public ModelAndView getEntityLinkedPage(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception {
		ModelAndView mv = new ModelAndView("/EntityTracer/EntityTracerTabView");
		String userCode = authentication.getPrincipal().toString();
		HashMap<String, Object> initialParameters = EntityTracerService.getInitialParameters();
		/*
		request.setAttribute("EXCULDEDPRODUCTCODE", EntityTracerService.getExcludedProductCodes());
		request.setAttribute("ACCOUNTGROUPS", EntityTracerService.getAccountGroups());
		*/
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("EXCULDEDPRODUCTCODE", (initialParameters.get("EXCLUDEDPRODUCTCODES")).toString());
		request.setAttribute("ACCOUNTGROUPS", (ArrayList<String>)(initialParameters.get("ACCOUNTGROUPS")));
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "ENTITY TRACER", "OPEN", "Module Accessed");
		return mv;
	}
	
	@RequestMapping(value = "/getEntityLinkedDetailsTabView", method=RequestMethod.POST) 
	public String getEntityLinkedDetailsTabView(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception {
	
	String userCode = authentication.getPrincipal().toString();
	String accountNumber = request.getParameter("AccountNumber");
	String customerId = request.getParameter("CustomerId");
	String customerName = request.getParameter("CustomerName");
	String fromDate = request.getParameter("FromDate");
	String toDate = request.getParameter("ToDate");
	String staticLink = request.getParameter("StaticLink");
	String transactionLink = request.getParameter("TransactionLink");
	// String minLinks = request.getParameter("MinLinks");
	String counterAccountNo = request.getParameter("CounterAccountNo");
	String counterAccountGroup = request.getParameter("CounterAccountGroup") == null ? "":request.getParameter("CounterAccountGroup");
	// String levelCount = request.getParameter("LevelCount");
	String productCode = request.getParameter("ProductCode");
	String message = "";
	
	int minLinks = 0;
	int levelCount = 0;
	boolean isStaticLink = false;
	boolean isTransactionLink = false;
	
	try{
		minLinks = Integer.parseInt(request.getParameter("MinLinks"));
	}catch(NumberFormatException e){
		message = "Enter a valid number for min links";
	}
	
	try{
		levelCount = Integer.parseInt(request.getParameter("LevelCount"));
	}catch(NumberFormatException e){
		message = "Enter a valid number for level count";
	}
	
	if(staticLink != null && staticLink.equalsIgnoreCase("y"))
		isStaticLink = true;
	if(transactionLink != null && transactionLink.equalsIgnoreCase("y"))
		isTransactionLink = true;
    
	Map<String, Object> mainMap = EntityTracerService.getLinkedTracer(accountNumber, customerId, customerName, 
			fromDate, toDate, isStaticLink, isTransactionLink, minLinks, counterAccountNo, levelCount, productCode, 
			counterAccountGroup);
	request.setAttribute("EntityTracerData", mainMap);
	//request.setAttribute("EXCULDEDPRODUCTCODE", EntityTracerService.getExcludedProductCodes());
	request.setAttribute("EXCULDEDPRODUCTCODE", productCode);
	request.setAttribute("FromDate", fromDate);
	request.setAttribute("ToDate", toDate);
	request.setAttribute("AccountNumber", accountNumber);
	request.setAttribute("CustomerId", customerId);
	request.setAttribute("CustomerName", customerName);
	request.setAttribute("StaticLink", staticLink);
	request.setAttribute("TransactionLink", transactionLink);
	request.setAttribute("MinLinks", request.getParameter("MinLinks"));
	request.setAttribute("CounterAccountNo", counterAccountNo);
	request.setAttribute("CounterAccountGroup", counterAccountGroup);
	request.setAttribute("LevelCount", request.getParameter("LevelCount"));
	request.setAttribute("Message", message);
	
	commonService.auditLog(authentication.getPrincipal().toString(), request, "ENTITY TRACER", "OPEN", "Module Accessed");
    return "EntityTracer/EntityTracerBottomPage";
    }
	
	@RequestMapping(value = "/getEntityLinkedDetailsGraphViewPage", method=RequestMethod.POST) 
	public String getEntityLinkedDetailsGraphViewPage(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception {
		String userCode = authentication.getPrincipal().toString();
		String accountNumber = request.getParameter("AccountNumber");
		String customerId = request.getParameter("CustomerId");
		String customerName = request.getParameter("CustomerName");
		String fromDate = request.getParameter("FromDate");
		String toDate = request.getParameter("ToDate");
		String staticLink = request.getParameter("StaticLink");
		String transactionLink = request.getParameter("TransactionLink");
		// String minLinks = request.getParameter("MinLinks");
		String counterAccountNo = request.getParameter("CounterAccountNo");
		String counterAccountGroup = request.getParameter("CounterAccountGroup") == null ? "":request.getParameter("CounterAccountGroup");
		// String levelCount = request.getParameter("LevelCount");
		String productCode = request.getParameter("ProductCode");
		String view = request.getParameter("view");
		
		request.setAttribute("EXCULDEDPRODUCTCODE", productCode);
		request.setAttribute("FromDate", fromDate);
		request.setAttribute("ToDate", toDate);
		request.setAttribute("AccountNumber", accountNumber);
		request.setAttribute("CustomerId", customerId);
		request.setAttribute("CustomerName", customerName);
		request.setAttribute("StaticLink", staticLink);
		request.setAttribute("TransactionLink", transactionLink);
		request.setAttribute("MinLinks", request.getParameter("MinLinks"));
		request.setAttribute("CounterAccountNo", counterAccountNo);
		request.setAttribute("CounterAccountGroup", counterAccountGroup);
		request.setAttribute("LevelCount", request.getParameter("LevelCount"));
		request.setAttribute("UNQID",  otherCommonService.getElementId());
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "ENTITY TRACER", "OPEN", "Module Accessed");
		if("V".equals(view))
			return "EntityTracer/EntityTracerVerticalGraphView";
		else if("VN".equals(view))
			return "EntityTracer/EntityTracerVerticalGraphViewNew";
		else if("H".equals(view))
			return "EntityTracer/EntityTracerHorizontalGraphView";
		else	
			return "EntityTracer/EntityTracerHorizontalGraphViewNew";
	}
	
	@RequestMapping(value = "/getEntityLinkedDetailsGraphView", method=RequestMethod.GET) 
	public @ResponseBody Map<String, Object> getEntityLinkedDetailsGraphView(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception {
		String userCode = authentication.getPrincipal().toString();
		String accountNumber = request.getParameter("AccountNumber");
		String customerId = request.getParameter("CustomerId");
		String customerName = request.getParameter("CustomerName");
		String fromDate = request.getParameter("FromDate");
		String toDate = request.getParameter("ToDate");
		String staticLink = request.getParameter("StaticLink");
		String transactionLink = request.getParameter("TransactionLink");
		// String minLinks = request.getParameter("MinLinks");
		String counterAccountNo = request.getParameter("CounterAccountNo");
		String counterAccountGroup = request.getParameter("CounterAccountGroup") == null ? "":request.getParameter("CounterAccountGroup");
		// String levelCount = request.getParameter("LevelCount");
		String productCode = request.getParameter("ProductCode");
		String message = "";
		
		int minLinks = 0;
		int levelCount = 0;
		boolean isStaticLink = false;
		boolean isTransactionLink = false;
		
		try{
			minLinks = Integer.parseInt(request.getParameter("MinLinks"));
		}catch(NumberFormatException e){
			message = "Enter a valid number for min links";
		}
		
		try{
			levelCount = Integer.parseInt(request.getParameter("LevelCount"));
		}catch(NumberFormatException e){
			message = "Enter a valid number for level count";
		}
		
		if(staticLink != null && staticLink.equalsIgnoreCase("y"))
			isStaticLink = true;
		if(transactionLink != null && transactionLink.equalsIgnoreCase("y"))
			isTransactionLink = true;
	    
		Map<String, Object> mainMap = EntityTracerService.getLinkedTracerForGraph(accountNumber, customerId, customerName, 
				fromDate, toDate, isStaticLink, isTransactionLink, minLinks, counterAccountNo, levelCount, productCode, 
				counterAccountGroup);
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "ENTITY TRACER", "OPEN", "Module Accessed");
	    return mainMap;
    }
	
	@RequestMapping(value = "/saveEntityTracerConfig", method=RequestMethod.POST) 
	public @ResponseBody String saveEntityLinkedDetails(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception {	
	String userCode = authentication.getPrincipal().toString();
	String accountNumber = request.getParameter("accountNumber");
	String customerId = request.getParameter("customerId");
	String customerName = request.getParameter("customerName");
	String fromDate = request.getParameter("fromDate");
	String toDate = request.getParameter("toDate");
	String staticLink = request.getParameter("staticLink");
	String transactionLink = request.getParameter("transactionLink");
	// String minLinks = request.getParameter("minLinks");
	String counterAccountNo = request.getParameter("counterAccountNo");
	String counterAccountGroup = request.getParameter("CounterAccountGroup") == null ? "":request.getParameter("CounterAccountGroup");
	// String levelCount = request.getParameter("levelCount");
	String productCode = request.getParameter("productCode");
	String message = "";
	int minLinks = 0;
	int levelCount = 1;
	
	try{
		minLinks = Integer.parseInt(request.getParameter("minLinks"));
	}catch(NumberFormatException e){
		message = "Enter valid numeric value in Min Links";
	}
	
	try{
		levelCount = Integer.parseInt(request.getParameter("levelCount"));
	}catch(NumberFormatException e){
		message = "Enter valid numeric value in Level Count";
	}
	
		try{
			EntityTracerService.saveEntityLinkedDetails(accountNumber, customerId, customerName, 
				fromDate, toDate, staticLink, transactionLink, minLinks, 
				counterAccountNo, levelCount, productCode, userCode);
			message = "Save Successful";
		}catch(NumberFormatException e){
			message = "Error occured while saving the config : "+e.getMessage();
		}
		commonService.auditLog(authentication.getPrincipal().toString(), request, "ENTITY TRACER", "INSERT", "Data Saved");
		return message;
    }
	
	@RequestMapping(value = "/saveEntityForceLink", method=RequestMethod.POST) 
	public @ResponseBody String saveEntityForceLink(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception {	
		String userCode = authentication.getPrincipal().toString();
		String forceLink = request.getParameter("forceLink");
		String accountNo = request.getParameter("accountNo");
		String linkType = request.getParameter("linkType");
		String linkedAccountNo = request.getParameter("linkedAccountNo");
		String counterAccountGroup = request.getParameter("CounterAccountGroup") == null ? "":request.getParameter("CounterAccountGroup");
		String linkedCustId = request.getParameter("linkedCustId");
		String linkCustName = request.getParameter("linkCustName");
		String terminalId = request.getRemoteAddr() == null ? "127.0.0.1":request.getRemoteAddr();
		String userComments = request.getParameter("userComments");
		String message = "";
		
		try{
			EntityTracerService.saveEntityForceLink(forceLink, accountNo, linkType,	linkedAccountNo, linkedCustId, linkCustName, userComments, userCode, terminalId);
			message = "Force Link Successful";
		}catch(NumberFormatException e){
			message = "Error occurred while saving force link : "+e.getMessage();
		}
		commonService.auditLog(authentication.getPrincipal().toString(), request, "ENTITY TRACER", "INSERT", "Data Saved");
		return message;
    }
	
	@RequestMapping(value = "/getLinkedTransactions", method=RequestMethod.POST)
	public String getLinkedTransactions(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception {	
		String LOGGEDUSER = authentication.getPrincipal().toString();
		String l_strAccountNo = (String)request.getParameter("l_strAccountNo");
		String l_strCustomerId = (String)request.getParameter("l_strCustomerId");
		String l_strCustomerName = (String)request.getParameter("l_strCustomerName");
		String l_strLinkedAcctNo = (String)request.getParameter("l_strLinkedAcctNo");
		String l_strLinkedCustId = (String)request.getParameter("l_strLinkedCustId");
		String l_strLinkedCustName = (String)request.getParameter("l_strLinkedCustName");
		String l_strLinkedType = (String)request.getParameter("l_strLinkedType");
		String l_strFromDate = request.getParameter("l_strFromDate")==null?"":(String)request.getParameter("l_strFromDate");
		String l_strToDate = request.getParameter("l_strToDate")==null?"":(String)request.getParameter("l_strToDate");
		String TERMINALID = request.getRemoteAddr();
		request.setAttribute("LINKEDTXNS", EntityTracerService.getLinkedTransactions(l_strFromDate, l_strToDate, l_strAccountNo, l_strLinkedAcctNo));
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "ENTITY TRACER", "SEARCH", "Module Accessed");
		return "EntityTracer/LinkedTransactions";
	}
	
	@RequestMapping(value = "/getEntityLinkedDetailsTabViewForCaseWorkFLow", method=RequestMethod.POST) 
		public String getEntityLinkedDetailsTabViewForCaseWorkFLow(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception {
		System.out.println("for  WorkFLow");
		String userCode = authentication.getPrincipal().toString();
		String accountNumber = request.getParameter("AccountNumber");
		String customerId = request.getParameter("CustomerId");
		String customerName = request.getParameter("CustomerName");
		String fromDate = request.getParameter("FromDate");
		String toDate = request.getParameter("ToDate");
		String staticLink = request.getParameter("StaticLink");
		String transactionLink = request.getParameter("TransactionLink");
		// String minLinks = request.getParameter("MinLinks");
		String counterAccountNo = request.getParameter("CounterAccountNo");
		String counterAccountGroup = request.getParameter("CounterAccountGroup") == null ? "":request.getParameter("CounterAccountGroup");
		// String levelCount = request.getParameter("LevelCount");
		String productCode = request.getParameter("ProductCode");
		String message = "";
		
		int minLinks = 0;
		int levelCount = 0;
		boolean isStaticLink = false;
		boolean isTransactionLink = false;
		
		try{
			minLinks = Integer.parseInt(request.getParameter("MinLinks"));
		}catch(NumberFormatException e){
			message = "Enter a valid number for min links";
		}
		
		try{
			levelCount = Integer.parseInt(request.getParameter("LevelCount"));
		}catch(NumberFormatException e){
			message = "Enter a valid number for level count";
		}
		
		if(staticLink != null && staticLink.equalsIgnoreCase("y"))
			isStaticLink = true;
		if(transactionLink != null && transactionLink.equalsIgnoreCase("y"))
			isTransactionLink = true;
	    
		Map<String, Object> mainMap = EntityTracerService.getLinkedTracer(accountNumber, customerId, customerName, 
				fromDate, toDate, isStaticLink, isTransactionLink, minLinks, counterAccountNo, levelCount, productCode, 
				counterAccountGroup);
		request.setAttribute("EntityTracerData", mainMap);
		//request.setAttribute("EXCULDEDPRODUCTCODE", EntityTracerService.getExcludedProductCodes());
		request.setAttribute("EXCULDEDPRODUCTCODE", productCode);
		request.setAttribute("FromDate", fromDate);
		request.setAttribute("ToDate", toDate);
		request.setAttribute("AccountNumber", accountNumber);
		request.setAttribute("CustomerId", customerId);
		request.setAttribute("CustomerName", customerName);
		request.setAttribute("StaticLink", staticLink);
		request.setAttribute("TransactionLink", transactionLink);
		request.setAttribute("MinLinks", request.getParameter("MinLinks"));
		request.setAttribute("CounterAccountNo", counterAccountNo);
		request.setAttribute("CounterAccountGroup", counterAccountGroup);
		request.setAttribute("LevelCount", request.getParameter("LevelCount"));
		request.setAttribute("Message", message);
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "ENTITY TRACER", "OPEN", "Module Accessed");
	    return "AMLCaseWorkFlow/AMLUser/PendingCases/EntityTracerTablePage";
	  }
	
}


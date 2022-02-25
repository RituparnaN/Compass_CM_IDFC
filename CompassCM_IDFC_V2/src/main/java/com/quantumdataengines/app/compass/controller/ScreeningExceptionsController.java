package com.quantumdataengines.app.compass.controller;
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

import com.quantumdataengines.app.compass.otherservice.OtherCommonService;
import com.quantumdataengines.app.compass.service.CommonService;
import com.quantumdataengines.app.compass.service.master.GenericMasterService;
import com.quantumdataengines.app.compass.service.screeningExceptions.ScreeningExceptionsService;

@Controller
@RequestMapping(value="/admin")
public class ScreeningExceptionsController {
	private static final Logger log = LoggerFactory.getLogger(CommonController.class);
	
	@Autowired
	private CommonService commonService;
	@Autowired
	private OtherCommonService otherCommonService;
	@Autowired
	private ScreeningExceptionsService screeningExceptionsService;
	@Autowired
	private GenericMasterService genericMasterService;
	
	@RequestMapping(value="/screeningExceptions", method=RequestMethod.GET)
	public String returnMatchedList(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{

		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("MATCHEDLIST", screeningExceptionsService.returnMatchedList());
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "SCREENING EXCEPTIONS", "OPEN", "Module Accessed");
		return "ScreeningExceptions/index";
	}
	
	@RequestMapping(value = "/searchScreeningExceptions", method=RequestMethod.POST) 
	public String searchScreeningExceptions(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication) throws Exception {
		String custId = request.getParameter("custId");
		String custName = request.getParameter("custName");
		String matchedList = request.getParameter("matchedList");
		String matchedEntity = request.getParameter("matchedEntity");
		String isEnabled = request.getParameter("isEnabled");
		String listId = request.getParameter("listId");
		String reason = request.getParameter("reason");

		Map<String, Object> resultMap =  screeningExceptionsService.searchScreeningExceptions(custId, custName,
											matchedList, matchedEntity, isEnabled, listId, reason);
				
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("resultData", resultMap);
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "SCREENING EXCEPTIONS", "SEARCH", "Module Accessed");
		return "ScreeningExceptions/SearchBottomFrame";
	}

	@RequestMapping(value = "/addScreeningException", method=RequestMethod.POST)
	public String addScreeningException(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception {
		String custId = request.getParameter("custId");
		String custName = request.getParameter("custName");
		String matchedList = request.getParameter("matchedList");
		String matchedEntity = request.getParameter("matchedEntity");
		String isEnabled = request.getParameter("isEnabled");
		String listId = request.getParameter("listId");
		String reason = request.getParameter("reason");
		String userCode = authentication.getPrincipal().toString();
		String CURRENTROLE = request.getSession(false) != null ? (String) 
				request.getSession(false).getAttribute("CURRENTROLE") : "";

		Map<String, Object> resultMap = screeningExceptionsService.addScreeningException(custId, custName, matchedList,
										reason, matchedEntity, isEnabled, listId, userCode, CURRENTROLE);
				
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("resultData",resultMap);
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "SCREENING EXCEPTIONS", "INSERT", "Screening Exception Inserted");
		return "ScreeningExceptions/SearchBottomFrame";

	}
	
	@RequestMapping(value="/fetchScreeningExceptionToUpdate", method=RequestMethod.POST)
	public String fetchScreeningExceptionToUpdate(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception {
		String selectedCustId = request.getParameter("selectedCustId");
		String selectedCustName = request.getParameter("selectedCustName");
		String selectedMatchedEntity = request.getParameter("selectedMatchedEntity");
		String searchButton = request.getParameter("searchButton");
		
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("searchButton", searchButton);
		request.setAttribute("MATCHEDLIST", screeningExceptionsService.returnMatchedList());
		request.setAttribute("RESULTMAP",screeningExceptionsService.fetchScreeningExceptionToUpdate(selectedCustId, selectedCustName, selectedMatchedEntity));
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "SCREENING EXCEPTIONS", "READ", "Module Accessed");
		return "ScreeningExceptions/UpdateScreeningExceptionsModal";
	}
	
	@RequestMapping(value="/updateScreeningException", method=RequestMethod.POST)
	public @ResponseBody String updateScreeningException(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception {
		String custId = request.getParameter("custId");
		String custName = request.getParameter("custName");
		String matchedList = request.getParameter("matchedList");
		String matchedEntity = request.getParameter("matchedEntity");
		String isEnabled = request.getParameter("isEnabled");
		String listId = request.getParameter("listId");
		String reason = request.getParameter("reason");
		String userCode = authentication.getPrincipal().toString();
		String CURRENTROLE = request.getSession(false) != null ? (String) 
				request.getSession(false).getAttribute("CURRENTROLE") : "";

		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("resultData", screeningExceptionsService.updateScreeningException(custId, custName, matchedList, reason, matchedEntity, 
				isEnabled, listId, userCode, CURRENTROLE));
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "SCREENING EXCEPTIONS", "UPDATE", "Screening Exception Updated");
		return "Updated Successfully.";


}


}




	
	
	
package com.quantumdataengines.app.compass.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import oracle.net.aso.i;

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
import com.quantumdataengines.app.compass.service.userCaseMapping.UserCaseMappingService;

@Controller
@RequestMapping(value="/admin")
public class UserCaseMappingController {
private static final Logger log = LoggerFactory.getLogger(CommonController.class);
	
	@Autowired
	private CommonService commonService;
	@Autowired
	private OtherCommonService otherCommonService;
	@Autowired
	private UserCaseMappingService userCaseMappingService;
	
	@RequestMapping(value="/userCaseMapping", method=RequestMethod.GET)
	public String getUserDetails(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		request.setAttribute("USERROLE", (String) request.getSession(false).getAttribute("CURRENTROLE"));
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("DATALIST", userCaseMappingService.getUserDetailsForUserCaseMapping("AMLUSER"));
		//System.out.println("controller = "+userCaseMappingService.getUserDetailsForUserCaseMapping("AMLUSER"));
		commonService.auditLog(authentication.getPrincipal().toString(), request, "USER ALERT MAPPING", "OPEN", "Module Accessed");
		return "UserCaseMapping/index";
	}
	
	@RequestMapping(value="/saveUserCaseAssignment", method=RequestMethod.POST)
	public @ResponseBody String saveUserCaseAssignment(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		String fullData = request.getParameter("fullData");
		String makerComments = request.getParameter("makerComments");
		String currentUser = authentication.getPrincipal().toString();
		String currentRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String ipAddress = request.getRemoteAddr();
		//System.out.println(fullData);
	    request.setAttribute("UNQID", otherCommonService.getElementId());
	    
	    commonService.auditLog(authentication.getPrincipal().toString(), request, "USER ALERT MAPPING", "INSERT", "User Alert Mapping Assignment Saved");
	    return userCaseMappingService.saveUserCaseAssignment(fullData, makerComments, currentUser, currentRole, ipAddress);
	   
	}
	
	@RequestMapping(value="/approveOrRejectUserCaseAssignment", method=RequestMethod.POST)
	public @ResponseBody String approveOrRejectUserCaseAssignment(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		String fullData = request.getParameter("fullData");
		String action = request.getParameter("action");
		String checkerComments = request.getParameter("checkerComments");
		String currentUser = authentication.getPrincipal().toString();
		String currentRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String ipAddress = request.getRemoteAddr();
		//System.out.println(fullData);
	    request.setAttribute("UNQID", otherCommonService.getElementId());
	    
	    commonService.auditLog(authentication.getPrincipal().toString(), request, "USER ALERT MAPPING", "UPDATE", "User Alert Mapping Assignment Approved or Rejected");
	    return userCaseMappingService.approveOrRejectUserCaseAssignment(fullData, action, checkerComments, currentUser, currentRole, ipAddress);
	   
	}
}
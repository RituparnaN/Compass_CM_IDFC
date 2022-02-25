package com.quantumdataengines.app.compass.controller;

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
import com.quantumdataengines.app.compass.service.userReportMapping.UserReportMappingService;

@Controller
@RequestMapping(value="/admin")
public class UserReportMappingController {
private static final Logger log = LoggerFactory.getLogger(CommonController.class);
	
	@Autowired
	private CommonService commonService;
	@Autowired
	private OtherCommonService otherCommonService;
	@Autowired
	private UserReportMappingService userReportMappingService;
	
	@RequestMapping(value="/userReportMapping", method=RequestMethod.GET)
	public String userReportMapping(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("PARAMDATA", userReportMappingService.userReportMapping());
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "USER REPORT MAPPING", "OPEN", "Module Accessed");
		return "UserReportMapping/index";
	}
	
	@RequestMapping(value="/searchUserReportMapping", method=RequestMethod.POST)
	public String searchUserReportMapping(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		
		String selectedUserCode = request.getParameter("userCode");
		String reportType = request.getParameter("reportType");
	    String reportId = request.getParameter("reportId");
	    
	    String userCode = authentication.getPrincipal().toString();
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String ipAddress = request.getRemoteAddr(); 
	    
		System.out.println(userCode);
		
	    request.setAttribute("UNQID", otherCommonService.getElementId());
	    request.setAttribute("resultData", userReportMappingService.searchUserReportMapping(selectedUserCode, reportType, reportId, userCode, userRole, ipAddress));
	    request.setAttribute("selectedUserCode", selectedUserCode);
	    request.setAttribute("reportType", reportType);
	    request.setAttribute("reportId", reportId);
	    
	    commonService.auditLog(authentication.getPrincipal().toString(), request, "USER REPORT MAPPING", "SEARCH", "Module Accessed");
		return "UserReportMapping/SearchBottomFrame";
	}
	
	@RequestMapping(value="/saveUserReportMapping", method=RequestMethod.POST)
	public @ResponseBody String saveUserReportMapping(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		
		String fullData = request.getParameter("fullData");
		String currentUser = authentication.getPrincipal().toString();
		
	    request.setAttribute("UNQID", otherCommonService.getElementId());
	    System.out.println(fullData);
	    commonService.auditLog(authentication.getPrincipal().toString(), request, "USER REPORT MAPPING", "INSERT", "User Report Mapping Assignment Saved");
	    return userReportMappingService.saveUserReportMapping(fullData, currentUser);
	   
	}
}
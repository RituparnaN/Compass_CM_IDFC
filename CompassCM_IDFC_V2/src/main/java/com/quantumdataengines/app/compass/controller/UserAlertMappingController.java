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
import com.quantumdataengines.app.compass.service.userAlertMapping.UserAlertMappingService;

@Controller
@RequestMapping(value="/admin")
public class UserAlertMappingController {
private static final Logger log = LoggerFactory.getLogger(CommonController.class);
	
	@Autowired
	private CommonService commonService;
	@Autowired
	private OtherCommonService otherCommonService;
	@Autowired
	private UserAlertMappingService userAlertMappingService;
	
	@RequestMapping(value="/userAlertMapping", method=RequestMethod.GET)
	public String getUserDetails(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("USERLIST", userAlertMappingService.getUserDetails("USER"));
		request.setAttribute("AMLUSERLIST", userAlertMappingService.getUserDetails("AMLUSER"));
		request.setAttribute("AMLOLIST", userAlertMappingService.getUserDetails("AMLO"));
		request.setAttribute("MLROLIST", userAlertMappingService.getUserDetails("MLRO"));
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "USER ALERT MAPPING", "OPEN", "Module Accessed");
		return "UserAlertMapping/index";
	}
	
	@RequestMapping(value="/searchUserALertMapping", method=RequestMethod.POST)
	public String searchUserALertMapping(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		
		String mappingType = request.getParameter("mappingType");
	    String userLevel = request.getParameter("userLevel");
	    String userCode = request.getParameter("userCode");
	    	    
	    request.setAttribute("UNQID", otherCommonService.getElementId());
	    request.setAttribute("resultData", userAlertMappingService.searchUserALertMapping(mappingType, userLevel, userCode));
	    request.setAttribute("mappingType", mappingType);
	    request.setAttribute("userLevel", userLevel);
	    request.setAttribute("userCode", userCode);
	    
	    commonService.auditLog(authentication.getPrincipal().toString(), request, "USER ALERT MAPPING", "SEARCH", "Module Accessed");
		return "UserAlertMapping/SearchBottomFrame";
	}
	
	@RequestMapping(value="/saveAssignment", method=RequestMethod.POST)
	public @ResponseBody String saveAssignment(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		
		String fullData = request.getParameter("fullData");
		String currentUser = authentication.getPrincipal().toString();
		
	    request.setAttribute("UNQID", otherCommonService.getElementId());
	    
	    commonService.auditLog(authentication.getPrincipal().toString(), request, "USER ALERT MAPPING", "INSERT", "User Alert Mapping Assignment Saved");
	    return userAlertMappingService.saveAssignment(fullData, currentUser);
	   
	}
}
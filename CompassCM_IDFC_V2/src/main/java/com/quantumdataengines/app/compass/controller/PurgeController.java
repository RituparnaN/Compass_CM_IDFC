package com.quantumdataengines.app.compass.controller;

import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;

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
import com.quantumdataengines.app.compass.service.purge.PurgeService;

@Controller
@RequestMapping(value="/common")
public class PurgeController {
private static final Logger log = LoggerFactory.getLogger(CommonController.class);
	
	@Autowired
	private CommonService commonService;
	@Autowired
	private OtherCommonService otherCommonService;
	@Autowired
	private PurgeService purgeService;
	
	@RequestMapping(value="/purge", method=RequestMethod.GET)
	public String purge(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		String moduleType = request.getParameter("moduleType");
		request.setAttribute("MODULETYPE", moduleType);
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("USERROLE", request.getSession(false).getAttribute("CURRENTROLE") == null ? "N.A.":request.getSession(false).getAttribute("CURRENTROLE").toString());
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "Purge", "OPEN", "Module Accessed");
		return "Purge/index";
	}
	
	@RequestMapping(value="/purgeUpdate", method=RequestMethod.POST)
	public @ResponseBody String purgeUpdate(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		String month = request.getParameter("month");
		String year = request.getParameter("year");
		String table = request.getParameter("table");
	    String actionType = request.getParameter("actionType");
	    String currentUser = authentication.getPrincipal().toString();
		String currentRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String ipAddress = request.getRemoteAddr();
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "Purge", "UPDATE", "Purge Data updated");
		return purgeService.purgeUpdate(month, year, table, actionType, currentUser, currentRole, ipAddress);
		
	}
	
	
}
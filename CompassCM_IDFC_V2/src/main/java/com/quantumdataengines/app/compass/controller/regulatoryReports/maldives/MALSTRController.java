package com.quantumdataengines.app.compass.controller.regulatoryReports.maldives;

import java.util.Enumeration;
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

import com.quantumdataengines.app.compass.service.CommonService;
import com.quantumdataengines.app.compass.service.regulatoryReports.maldives.MaldivesSTRService;

@Controller
@RequestMapping(value="/common")
public class MALSTRController {
private static final Logger log = LoggerFactory.getLogger(MALSTRController.class);
	
	@Autowired
	private MaldivesSTRService maldivesSTRService;
	@Autowired
	private CommonService commonService;
	
	@RequestMapping(value="/maldivesSTR", method=RequestMethod.GET)
	public String maldivesSTR(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		String caseNo = request.getParameter("caseNo");
		String userCode = authentication.getPrincipal().toString();
		String ipAddress = request.getRemoteAddr();
		String CURRENTROLE = request.getSession(false) != null ? (String) request.getSession(false).getAttribute("CURRENTROLE") : "";

		request.setAttribute("caseNo", caseNo);
		request.setAttribute("RECORD", maldivesSTRService.fetchMaldivesSTRData(caseNo, userCode, ipAddress, CURRENTROLE));
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "MALDIVES_STR", "READ", "Module Accessed");
		return "RegulatoryReports/Maldives/STR/MALDIVES_STR";
	}
	
		
	@RequestMapping(value="/saveMALDIVES_STR", method=RequestMethod.POST)
	public  String saveMALDIVES_STR(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		String caseNo = request.getParameter("caseNo");
		String userCode = authentication.getPrincipal().toString();
		Map<String, String> paramMap = new HashMap<String, String>();
		
		Enumeration enumObj =  request.getParameterNames();
		while(enumObj.hasMoreElements()){
			String paramName = (String) enumObj.nextElement();
			String paramValue = request.getParameter(paramName);
			paramMap.put(paramName, paramValue);	
		}
		request.setAttribute("caseNo", caseNo);
		maldivesSTRService.saveMALDIVES_STR(paramMap, caseNo, userCode);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "MALDIVES_STR", "INSERT", "Data Saved");
		return "redirect:maldivesSTR?caseNo="+caseNo;
	}
}

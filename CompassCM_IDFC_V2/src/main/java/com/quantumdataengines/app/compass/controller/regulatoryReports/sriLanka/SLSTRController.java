package com.quantumdataengines.app.compass.controller.regulatoryReports.sriLanka;

import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.quantumdataengines.app.compass.service.CommonService;
import com.quantumdataengines.app.compass.service.regulatoryReports.sriLanka.SLSTRService;

@Controller
@RequestMapping(value="/common")
public class SLSTRController {
	
	@Autowired
	private SLSTRService slSTRService;
	@Autowired
	private CommonService commonService;
	
	@RequestMapping(value="/getSLSTR", method=RequestMethod.GET)
	public String getSLSTR(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String caseNo = request.getParameter("caseNo");
		String USERCODE = authentication.getPrincipal().toString();
		Map<String, String> SLSTR = slSTRService.getSLSTR(caseNo, USERCODE);
		
		request.setAttribute("CASENO", caseNo);
		request.setAttribute("SLSTR", SLSTR);
		
		if(request.getParameter("M") != null)
			request.setAttribute("MESSAGE", request.getParameter("M"));
		request.setAttribute("LOGGEDUSER", USERCODE);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "SLSTR", "OPEN", "SLSTR Accessed");
		return "RegulatoryReports/SriLanka/STR/index";
	}
	
	@RequestMapping(value="/saveSLSTR", method=RequestMethod.GET, params = "formSave")
	public String saveSLSTR(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String caseNo = request.getParameter("caseNo");
		String USERCODE = authentication.getPrincipal().toString();
		
		Map<String, String> paramMap = new HashMap<String, String>();
		
		Enumeration<String> paramEnum = request.getParameterNames();
		while (paramEnum.hasMoreElements()) {
			String paramName = paramEnum.nextElement();
			String paramValue = request.getParameter(paramName);
			paramMap.put(paramName, paramValue);
		}
		String message = "";
		if(slSTRService.saveSLSTR(caseNo, paramMap, USERCODE)){
			message = "STR successfully saved";
		}else{
			message = "Failed to save STR";
		}
		
		request.setAttribute("LOGGEDUSER", USERCODE);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "SLSTR", "INSERT", "SLSTR Saved");
		return "redirect:getSLSTR?caseNo="+caseNo+"&M="+message;
	}
	
	@RequestMapping(value="/saveSLSTR", method=RequestMethod.GET, params = "exportXML")
	public String exportSLSTRXML(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String caseNo = request.getParameter("caseNo");
		String USERCODE = authentication.getPrincipal().toString();
		
		String message = "XML Exported";
		
		request.setAttribute("LOGGEDUSER", USERCODE);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "SLSTR", "INSERT", "SLSTR Generated :"+message);
		return "redirect:getSLSTR?caseNo="+caseNo+"&M="+message;
	}
}

package com.quantumdataengines.app.compass.controller.regulatoryReports.UK;

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
import org.springframework.web.bind.annotation.ResponseBody;

import com.quantumdataengines.app.compass.otherservice.OtherCommonService;
import com.quantumdataengines.app.compass.service.CommonService;
import com.quantumdataengines.app.compass.service.regulatoryReports.UK.UKSARService;

@Controller
@RequestMapping(value="/common")
public class UKSARController {
// private static final Logger log = LoggerFactory.getLogger(UKSARController.class);
	
	@Autowired
	private UKSARService ukSARService;
	@Autowired
	private CommonService commonService;
	
	@RequestMapping(value="/ukSAR", method=RequestMethod.GET)
	public String ukSAR(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		String caseNo = request.getParameter("caseNo");
		String userCode = authentication.getPrincipal().toString();
		String ipAddress = request.getRemoteAddr();
		String CURRENTROLE = request.getSession(false) != null ? (String) request.getSession(false).getAttribute("CURRENTROLE") : "";

		request.setAttribute("caseNo", caseNo);
		request.setAttribute("RECORD", ukSARService.fetchUKSARData(caseNo, userCode, ipAddress, CURRENTROLE));
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "UKSAR", "READ", "Module Accessed");
		return "RegulatoryReports/UK/UKSAR/UKSAR";
	}
	
	@RequestMapping(value="/saveUKSAR", method=RequestMethod.POST)
	public  String saveUKSAR(HttpServletRequest request, HttpServletResponse response,
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
		ukSARService.saveUKSAR(paramMap, caseNo, userCode);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "UKSAR", "INSERT", "Data Saved");
		return "redirect:ukSAR?caseNo="+caseNo;
	}
	
}

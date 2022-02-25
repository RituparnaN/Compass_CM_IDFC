package com.quantumdataengines.app.compass.controller;

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
import com.quantumdataengines.app.compass.service.edd.EDDService;

@Controller
@RequestMapping(value="/common")
public class EDDController {
private static final Logger log = LoggerFactory.getLogger(CommonController.class);
	
	@Autowired
	private CommonService commonService;
	@Autowired
	private OtherCommonService otherCommonService;
	@Autowired
	private EDDService eddService;
	/*
	@RequestMapping(value="/ukSAR", method=RequestMethod.GET)
	public String ukSAR(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		
		return "STR/UKSAR/UKSAR";
	}
	*/
	
	@RequestMapping(value="/viewEddRecords", method=RequestMethod.POST)
	public String viewEddRecords(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		String caseNoForEDD = request.getParameter("caseNoForEDD");
		
		request.setAttribute("caseNoForEDD", caseNoForEDD);
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("RECORDS", eddService.showEDDRecords(caseNoForEDD));
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "AML CASEWORKFLOW", "READ", "Module Accessed for CaseNo="+caseNoForEDD);
		return "AMLCaseWorkFlow/edd/viewEdd";
	}
	
	@RequestMapping(value="/addViewEDD", method=RequestMethod.POST)
	public String addViewEDD(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		String seqNo = request.getParameter("seqNo");
		String caseNoForEDD = request.getParameter("caseNoForEDD");
		request.setAttribute("UNQID", otherCommonService.getElementId());
		
		request.setAttribute("seqNo", seqNo);
		request.setAttribute("caseNoForEDD", caseNoForEDD);
		request.setAttribute("DATA", eddService.getEDDMasterData());
		request.setAttribute("FETCHEDDETAILS", eddService.fetchDetailsToUpdateEDD(seqNo));
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "AML CASEWORKFLOW", "READ", "Module Accessed");
		return "AMLCaseWorkFlow/edd/AddViewEDDModal";
	}
	
	@RequestMapping(value="/saveUpdateEDD", method=RequestMethod.POST)
	public @ResponseBody String saveUpdateEDD(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		String seqNo = request.getParameter("seqNo");
		String userCode = authentication.getPrincipal().toString();
		Map<String, String> paramMap = new HashMap<String, String>();
		
		Enumeration enumObj =  request.getParameterNames();
		while(enumObj.hasMoreElements()){
			String paramName = (String) enumObj.nextElement();
			String paramValue = request.getParameter(paramName);
			paramMap.put(paramName, paramValue);	
		}
		request.setAttribute("UNQID", otherCommonService.getElementId());
		
		if(seqNo.equals("0")){
			eddService.saveEDD(paramMap, seqNo, userCode);
			commonService.auditLog(authentication.getPrincipal().toString(), request, "AML CASEWORKFLOW", "INSERT", "EDD Saved "+seqNo);
		}
		else{
			commonService.auditLog(authentication.getPrincipal().toString(), request, "AML CASEWORKFLOW", "UPDATE", "EDD Updated "+seqNo);
			eddService.updateEDD(paramMap, seqNo, userCode);
		}
		return "OK";
	}
}

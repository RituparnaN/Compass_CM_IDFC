package com.quantumdataengines.app.compass.controller.regulatoryReports.india;

import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
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

import com.quantumdataengines.app.compass.controller.reports.WordView;
import com.quantumdataengines.app.compass.service.regulatoryReports.india.STRTemplateService;

@Controller
@RequestMapping(value="/common")
public class STRTemplateController {
	// private Logger log = LoggerFactory.getLogger(STRTemplateController.class);
	
	@Autowired
	private STRTemplateService strTemplateService;
	
	@RequestMapping(value="/strTemplate", method=RequestMethod.GET)
	public String STRTemplate(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception {
		request.setAttribute("TEMPLATES", strTemplateService.getAllSTRTemplate());
		return "/RegulatoryReports/India/STRTemplate/STRTemplate";
	}
	
	@RequestMapping(value="/getSTRVariables", method=RequestMethod.GET)
	public String getSTRVariables(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception {
		request.setAttribute("STRVARIABLES", strTemplateService.getAllVariables());
		return "/RegulatoryReports/India/STRTemplate/getSTRVariables";
	}
	
	@RequestMapping(value="/createSTRTemplate", method=RequestMethod.GET)
	public String createSTRTemplate(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception {
		String templateId = request.getParameter("templateid");
		if(templateId != null){
			Map<String, String> templateDetails = strTemplateService.getTemplateDetails(templateId);
			if(templateDetails.get("TEMPLATEID") != null){
				request.setAttribute("TEMPLATEDETAILS", strTemplateService.getTemplateDetails(templateId));
				request.setAttribute("ACTION", "UPDATE");
			}else{
				request.setAttribute("ACTION", "CREATE");
			}			
		}else{
			request.setAttribute("ACTION", "CREATE");
		}
		return "/RegulatoryReports/India/STRTemplate/createSTRTemplate";
	}
	
	@RequestMapping(value="/addUpdateSTRTemplate", method=RequestMethod.POST)
	public String addUpdateSTRTemplate(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception {
		String username = authentication.getPrincipal().toString();
		Map<String, String> paramMap = new HashMap<String, String>();
		
		Enumeration<String> paramEnum = request.getParameterNames();
		while (paramEnum.hasMoreElements()) {
			String paramName = paramEnum.nextElement();
			String paramValue = request.getParameter(paramName);
			paramMap.put(paramName, paramValue);
		}
		
		String templateId = strTemplateService.addUpdateSTRTemplate(paramMap, username);
		request.setAttribute("TEMPLATEDETAILS", strTemplateService.getTemplateDetails(templateId));
		request.setAttribute("ACTION", "UPDATE");
		return "/RegulatoryReports/India/STRTemplate/createSTRTemplate";
	}
	
	@RequestMapping(value="/generateAutoSTRView", method=RequestMethod.GET)
	public String generateAutoSTRView(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception {
		request.setAttribute("TEMPLATES", strTemplateService.getAllSTRTemplate());
		request.setAttribute("TYPEOFSUSPICIONS", strTemplateService.getAllTypeOfSuspicions());
		
		request.setAttribute("MESSAGE", request.getParameter("message") != null ? request.getParameter("message") : "");
		String usercode = authentication.getPrincipal().toString();
		request.setAttribute("LOGGEDUSER", usercode);
		request.setAttribute("GROUPOFLOGGEDUSER", (String) request.getSession(false).getAttribute("CURRENTROLE"));
		return "/RegulatoryReports/India/STRTemplate/generateAutoSTR";
	}
	
	@RequestMapping(value="/getSTRTemplateView", method=RequestMethod.POST)
	public @ResponseBody Map<String, String> getSTRTemplateView(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception {
		String templateId = request.getParameter("templateId");
		return strTemplateService.getTemplateDetails(templateId);
	}
	
	@RequestMapping(value="/selectAccountNumber", method=RequestMethod.POST)
	public String selectAccountNumber(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception {
		String primaryCustomerId = request.getParameter("primaryCustomerId");
		String secondaryCustomerId = request.getParameter("secondaryCustomerId");
		List<Map<String, String>> accountDetails = strTemplateService.selectAccountNumbers(primaryCustomerId, secondaryCustomerId);
		request.setAttribute("ACCOUNTDETAILS", accountDetails);
		return "/RegulatoryReports/India/STRTemplate/selectAccountNumber";
	}
	
	@RequestMapping(value="/generateAutoSTR", method=RequestMethod.POST)
	// public String generateAutoSTR(HttpServletRequest request, HttpServletResponse response,
	public @ResponseBody String generateAutoSTR(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception {
		String username = authentication.getPrincipal().toString();
		String groupCode = request.getSession().getAttribute("GROUPOFLOGGEDUSER") == null ? "N.A.": request.getSession().getAttribute("GROUPOFLOGGEDUSER").toString();
		Map<String, String> paramMap = new HashMap<String, String>();
		Enumeration<String> paramEnum = request.getParameterNames();
		while (paramEnum.hasMoreElements()) {
			String paramName = paramEnum.nextElement();
			String paramValue = request.getParameter(paramName);
			paramMap.put(paramName, paramValue);
		}
		String message = strTemplateService.generateAutoSTR(paramMap, username, groupCode);
		// return "redirect:generateAutoSTRView?message="+message;
		return message;
	}
	
	@RequestMapping(value = "/GroundOfSuspicionForSTRTemplate", method = RequestMethod.POST)
    public @ResponseBody String GroundOfSuspicionForSTRTemplate(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception {
		String primaryCustomerId = request.getParameter("primaryCustomerId");
		String secondaryCustomerId = request.getParameter("secondaryCustomerId");
		String accountNumbers = request.getParameter("accountNumbers");
		String templateId = request.getParameter("templateId");
		String fromDate = request.getParameter("fromDate");
		String toDate = request.getParameter("toDate");
		String caseNo = request.getParameter("caseNo");
		return strTemplateService.generateGOS(primaryCustomerId, secondaryCustomerId, accountNumbers, templateId, fromDate, toDate, caseNo);
	}
	
	@RequestMapping(value = "/GroundOfSuspicionForSTRTemplateDOC", method = RequestMethod.GET)
    public ModelAndView GroundOfSuspicionForSTRTemplateDOC(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception {
		String primaryCustomerId = request.getParameter("primaryCustomerId");
		String secondaryCustomerId = request.getParameter("secondaryCustomerId");
		String accountNumbers = request.getParameter("accountNumbers");
		String templateId = request.getParameter("templateId");
		String fromDate = request.getParameter("fromDate");
		String toDate = request.getParameter("toDate");
		String caseNo = request.getParameter("caseNo");
		
		Map<String, Object> model = new HashMap<String, Object>();
		
		List<Map<String, String>> parameters = new ArrayList<Map<String, String>>();
		Map<String, String> param = new HashMap<String, String>();
		param.put("Transaction From Date", fromDate);
		parameters.add(param);
		
		param = new HashMap<String, String>();
		param.put("Transaction To Date", toDate);
		parameters.add(param);
		
		param = new HashMap<String, String>();
		param.put("Primary Customer ID", primaryCustomerId);
		parameters.add(param);
		
		param = new HashMap<String, String>();
		param.put("Secondary Customer ID", secondaryCustomerId);
		parameters.add(param);
		
		param = new HashMap<String, String>();
		param.put("Account Numbers", accountNumbers);
		parameters.add(param);
		
		param = new HashMap<String, String>();
		param.put("CaseNo", caseNo);
		parameters.add(param);
		
		List<String> paragraphs = new ArrayList<String>();
		paragraphs.add("");
		paragraphs.add(strTemplateService.generateGOS(primaryCustomerId, secondaryCustomerId, accountNumbers, templateId, fromDate, toDate, caseNo));
				
		model.put("PARAMETERS", parameters);
		model.put("PARAGRAPHS", paragraphs);
		return new ModelAndView(new WordView(), model);
	}
}

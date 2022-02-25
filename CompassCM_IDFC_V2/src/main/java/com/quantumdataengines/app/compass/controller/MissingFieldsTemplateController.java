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
import com.quantumdataengines.app.compass.service.missingFieldsTemplate.MissingFieldsTemplateService;

@Controller
@RequestMapping(value="/common")
public class MissingFieldsTemplateController {
	private static final Logger log = LoggerFactory.getLogger(MissingFieldsTemplateController.class);
	
	@Autowired
	private CommonService commonService;
	@Autowired
	private OtherCommonService otherCommonService;
	@Autowired
	private GenericMasterService genericMasterService;
	@Autowired
	private MissingFieldsTemplateService missingFieldsTemplateService;
	
	@RequestMapping(value="/missingFieldsTemplate", method=RequestMethod.GET)
	public String missingFieldsTemplate(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{

		request.setAttribute("UNQID", otherCommonService.getElementId());
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "MISSING FIELDS TEMPLATE", "OPEN", "Module Accessed");
		return "KYCModules/MissingFieldsTemplate/index";
	}
	
	@RequestMapping(value="/getRequiredFields", method=RequestMethod.POST)
	public String getRequiredFields(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		String id = request.getParameter("id");

		request.setAttribute("FIELDSMAP", missingFieldsTemplateService.getRequiredFields());
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "MISSING FIELDS TEMPLATE", "READ", "Module Accessed");
		return "KYCModules/MissingFieldsTemplate/MissingFieldsTemplate";
	}

	@RequestMapping(value="/searchMissingFields", method=RequestMethod.POST)
	public String searchMissingFields(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		String id = request.getParameter("id");
		String templateId = request.getParameter("templateId");
		String templateName = request.getParameter("templateName");
		String productCode = request.getParameter("productCode");
		String custType = request.getParameter("custType");
		String isEnabled = request.getParameter("isEnabled");
		
		request.setAttribute("UNQID", id);
		request.setAttribute("resultData", missingFieldsTemplateService.searchMissingFields(templateId, templateName, productCode, custType, isEnabled));
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "MISSING FIELDS TEMPLATE", "SEARCH", "Module Accessed");
		return "KYCModules/MissingFieldsTemplate/SearchBottomFrameTab1";
	}
	
	@RequestMapping(value="/addMissingFieldsTemplate", method=RequestMethod.POST)
	public String addMissingFieldsTemplate(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		String id = request.getParameter("id");
		String templateId = request.getParameter("templateId");
		String templateName = request.getParameter("templateName");
		String productCode = request.getParameter("productCode");
		String custType = request.getParameter("custType");
		String isEnabled = request.getParameter("isEnabled");
		String userCode = authentication.getPrincipal().toString();
		String CURRENTROLE = request.getSession(false) != null ? (String) 
				request.getSession(false).getAttribute("CURRENTROLE") : "";

		request.setAttribute("UNQID", id);
		request.setAttribute("resultData", missingFieldsTemplateService.addMissingFieldsTemplate(templateId, templateName, productCode, custType, isEnabled, userCode, CURRENTROLE));
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "MISSING FIELDS TEMPLATE", "INSERT", "Missing Fields Template Inserted");
		return "KYCModules/MissingFieldsTemplate/SearchBottomFrameTab1";
	}
	
	@RequestMapping(value="/fetchMissingFieldsToUpdate", method=RequestMethod.POST)
	public String fetchMissingFieldsToUpdate(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception {
		String selectedTempId = request.getParameter("selectedTempId");
		String selectedTempName = request.getParameter("selectedTempName");
		String selectedProductCode = request.getParameter("selectedProductCode");
		String selectedCustomerType = request.getParameter("selectedCustomerType");
		String selectedIsEnabled = request.getParameter("selectedIsEnabled");
		String searchButton = request.getParameter("searchButton");
		
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("searchButton", searchButton);
		request.setAttribute("FIELDSMAP", missingFieldsTemplateService.getRequiredFields());
		request.setAttribute("RESULTMAP",missingFieldsTemplateService.fetchMissingFieldsToUpdate(selectedTempId, selectedTempName, selectedProductCode, selectedCustomerType, selectedIsEnabled));
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "MISSING FIELDS TEMPLATE", "READ", "Module Accessed");
		return "KYCModules/MissingFieldsTemplate/UpdateMissingFieldsModal";
	}
	
	@RequestMapping(value="/updateMissingFields", method=RequestMethod.POST)
	public @ResponseBody String updateMissingFields(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		String templateId = request.getParameter("templateId");
		String templateName = request.getParameter("templateName");
		String productCode = request.getParameter("productCode");
		String custType = request.getParameter("custType");
		String isEnabled = request.getParameter("isEnabled");
		String userCode = authentication.getPrincipal().toString();
		String CURRENTROLE = request.getSession(false) != null ? (String) 
				request.getSession(false).getAttribute("CURRENTROLE") : "";
		
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("resultData",missingFieldsTemplateService.updateMissingFields(templateId, templateName, productCode, custType, isEnabled, userCode, CURRENTROLE));
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "MISSING FIELDS TEMPLATE", "UPDATE", "Missing Fields Updated");
		return "Updated Successfully.";
	}
	
	@RequestMapping(value="/getTemplatesForMissingFieldsTemplate", method=RequestMethod.POST)
	public @ResponseBody Map<String, Object> getTemplatesForMissingFieldsTemplate(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "MISSING FIELDS TEMPLATE", "SEARCH", "Module Accessed");
		return missingFieldsTemplateService.searchMissingFields("", "", "", "", "");
	}
	
	@RequestMapping(value="/searchAddFieldsToTemplate", method=RequestMethod.POST)
	public String searchAddFieldsToTemplate(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		
		String template = request.getParameter("template");
		String detailType = request.getParameter("detailType");
		
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("template", template);
		request.setAttribute("resultData", missingFieldsTemplateService.searchAddFieldsToTemplate(template, detailType));
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "MISSING FIELDS TEMPLATE", "SEARCH", "Module Accessed");
		return "KYCModules/MissingFieldsTemplate/SearchBottomFrameTab2";
	}
	
	@RequestMapping(value="/updateComplianceScore", method=RequestMethod.POST)
	public @ResponseBody String updateComplianceScore(HttpServletRequest request, 
			HttpServletResponse response, Authentication authentication){
		
		request.setAttribute("UNQID", otherCommonService.getElementId());
		
		String searchTemplate = request.getParameter("searchTemplate");
		String detailType = request.getParameter("detailType");
		String fullData = request.getParameter("fullData");
		missingFieldsTemplateService.updateComplianceScore(fullData, searchTemplate, detailType);
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "MISSING FIELDS TEMPLATE", "UPDATE", "Compliance Score Updated");
		return "Successfully updated.";
	}
	
	
}

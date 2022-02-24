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
import com.quantumdataengines.app.compass.service.riskCategorization.RiskCategorizationService;

@Controller
@RequestMapping(value="/admin")
public class RiskCategorizationController{
private static final Logger log = LoggerFactory.getLogger(CommonController.class);
	
	@Autowired
	private CommonService commonService;
	@Autowired
	private OtherCommonService otherCommonService;
	@Autowired
	private RiskCategorizationService riskCategorizationService;
	
	@RequestMapping(value="/riskCategorization", method=RequestMethod.GET)
	public String riskCategorization(HttpServletRequest request, 
	HttpServletResponse response, Authentication authentication){

	request.setAttribute("UNQID", otherCommonService.getElementId());
	
	commonService.auditLog(authentication.getPrincipal().toString(), request, "RISK CATEGORIZATION", "OPEN", "Module Accessed");
	return "RiskCategorization/index";
	}
	
	@RequestMapping(value="/getRiskCategorizationBottomFrame", method=RequestMethod.POST)
	public String getRiskCategorizationBottomFrame(HttpServletRequest request, 
			HttpServletResponse response, Authentication authentication){
		String id = request.getParameter("id");
		
		request.setAttribute("UNQID", id);
		request.setAttribute("RESULTLIST", riskCategorizationService.getRiskParameterList());
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "RISK CATEGORIZATION", "SEARCH", "Module Accessed");
		return "RiskCategorization/SearchBottomPage";
	}
	
	@RequestMapping(value="/saveParameterList", method=RequestMethod.POST)
	public String saveParameterList(HttpServletRequest request, 
			HttpServletResponse response, Authentication authentication){
		String id = request.getParameter("id");
		String strRiskParameters = request.getParameter("strRiskParameters");
		riskCategorizationService.saveParameterList(strRiskParameters);
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "RISK CATEGORIZATION", "INSERT", "Parameter List Saved");
		return "forward:getRiskCategorizationBottomFrame?id="+id;
	}
	
	@RequestMapping(value="/searchRiskAssignment", method=RequestMethod.POST)
	public String searchRiskAssignment(HttpServletRequest request, 
			HttpServletResponse response, Authentication authentication){
		String id = request.getParameter("id");
		String searchParamId = request.getParameter("searchParamId");
		
		request.setAttribute("UNQID", id);
		request.setAttribute("isRangeRequired", request.getParameter("isRangeRequired"));
		request.setAttribute("searchParamId", searchParamId);
		request.setAttribute("RESULTLIST", riskCategorizationService.searchRiskAssignment(searchParamId));
		request.setAttribute("SEARCHBUTTONID", request.getParameter("searchButtonId"));
				
		commonService.auditLog(authentication.getPrincipal().toString(), request, "RISK CATEGORIZATION", "SEARCH", "Module Accessed");
		return "RiskCategorization/RiskAssignmentBottomFrame";
	
	}
	
	@RequestMapping(value="/updateRiskAssignmentValue", method=RequestMethod.POST)
	public @ResponseBody String updateRiskAssignmentValue(HttpServletRequest request, 
			HttpServletResponse response, Authentication authentication){
		String id = request.getParameter("id");
		String paramId = request.getParameter("paramId");
		String fullData = request.getParameter("fullData");
		riskCategorizationService.updateRiskAssignmentValue(fullData, paramId);
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "RISK CATEGORIZATION", "UPDATE", "Risk Assignment Value Updated");
		return "Successfully updated.";
	}
	
	@RequestMapping(value="/fetchParamIdToAddNewRiskParameter", method=RequestMethod.POST)
	public String fetchParamIdToAddNewRiskParameter(HttpServletRequest request, 
			HttpServletResponse response, Authentication authentication){
		String isNew = request.getParameter("isNew");
		String paramId = request.getParameter("paramId");
		
		System.out.println(request.getParameter("searchButtonId"));
		
		String isFromToReq = riskCategorizationService.fetchISFromToReqValue(paramId);
		request.setAttribute("paramId", paramId);
		request.setAttribute("isNew", isNew);
		request.setAttribute("isFromToReq", isFromToReq);
		request.setAttribute("SEARCHBUTTONID", request.getParameter("searchButtonId"));
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "RISK CATEGORIZATION", "READ", "Module Accessed");
		return "RiskCategorization/AddNewRiskParamModal";
	}
	
	@RequestMapping(value="/saveNewRiskParam", method=RequestMethod.POST)
	public @ResponseBody String saveNewRiskParam(HttpServletRequest request, 
			HttpServletResponse response, Authentication authentication){
		String id = request.getParameter("id");
		String paramId = request.getParameter("paramId");
		String paramCode = request.getParameter("paramCode");
		String paramDesc = request.getParameter("paramDesc");
		String paramRangeFrom = request.getParameter("paramRangeFrom"); 
		String paramRangeTo = request.getParameter("paramRangeTo");
		String paramRiskValue = request.getParameter("paramRiskValue");
		String priorityRiskValue = request.getParameter("priorityRiskValue");
		String userCode = authentication.getPrincipal().toString();
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "RISK CATEGORIZATION", "INSERT", "New Risk Parameter Saved");
		return riskCategorizationService.saveNewRiskParam(paramId, paramCode, paramDesc, paramRangeFrom, paramRangeTo, paramRiskValue, priorityRiskValue, userCode);
	}
	
	@RequestMapping(value="/fetchParamCodeToDeleteRiskParameter", method=RequestMethod.POST)
	public String fetchParamCodeToDeleteRiskParameter(HttpServletRequest request, 
			HttpServletResponse response, Authentication authentication){
		String paramCode = request.getParameter("paramCode");
		String searchParamId = request.getParameter("searchParamId");
		request.setAttribute("DATAMAP", riskCategorizationService.fetchParamCodeToDeleteRiskParameter(searchParamId, paramCode));
		request.setAttribute("paramId", searchParamId);
		request.setAttribute("SEARCHBUTTONID", request.getParameter("searchButtonId"));
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "RISK CATEGORIZATION", "READ", "Module Accessed");
		return "RiskCategorization/AddNewRiskParamModal";
	}

	@RequestMapping(value="/deleteNewRiskParam", method=RequestMethod.POST)
	public @ResponseBody String deleteNewRiskParam(HttpServletRequest request, 
			HttpServletResponse response, Authentication authentication){
		String paramId = request.getParameter("paramId");
		String paramCode = request.getParameter("paramCode");
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "RISK CATEGORIZATION", "DELETE", "Risk Parameter Deleted");
		return riskCategorizationService.deleteNewRiskParam(paramId, paramCode);
	}
	
	@RequestMapping(value="/updateNewRiskParam", method=RequestMethod.POST)
	public @ResponseBody String updateNewRiskParam(HttpServletRequest request, 
			HttpServletResponse response, Authentication authentication){
		String paramId = request.getParameter("paramId");
		String paramCode = request.getParameter("paramCode");
		String paramDesc = request.getParameter("paramDesc");
		String paramRangeFrom = request.getParameter("paramRangeFrom"); 
		String paramRangeTo = request.getParameter("paramRangeTo");
		String paramRiskValue = request.getParameter("paramRiskValue");
		String priorityRiskValue = request.getParameter("priorityRiskValue");
		String userCode = authentication.getPrincipal().toString();
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "RISK CATEGORIZATION", "UPDATE", "Risk Parameter Updated");
		return riskCategorizationService.updateNewRiskParam(paramId, paramCode, paramDesc, paramRangeFrom, paramRangeTo, paramRiskValue, priorityRiskValue, userCode);
	}
	
	@RequestMapping(value="/updateParameterWeightageList", method=RequestMethod.POST)
	public @ResponseBody String updateParameterWeightageList(HttpServletRequest request, 
			HttpServletResponse response, Authentication authentication){
		String id = request.getParameter("id");
		String strParameters = request.getParameter("strParameters");
		riskCategorizationService.updateParameterWeightageList(strParameters);
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "RISK CATEGORIZATION", "UPDATE", "Parameter Weightage list Updated");
		return "Successfully updated.";
	}
	
	@RequestMapping(value="/calculateRisk", method=RequestMethod.POST)
	public @ResponseBody String calculateRisk(HttpServletRequest request, 
			HttpServletResponse response, Authentication authentication){
		String userCode = authentication.getPrincipal().toString();
		String CURRENTROLE = request.getSession(false) != null ? (String) request.getSession(false).getAttribute("CURRENTROLE") : "";
		String ipAddress = request.getRemoteAddr();
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "RISK CATEGORIZATION", "UPDATE", "Risk Calculated");
		return riskCategorizationService.calculateRisk(userCode, CURRENTROLE, ipAddress);
	}
	
	
	@RequestMapping(value="/riskParamFieldsTemplate", method=RequestMethod.GET)
	public String riskParamFieldsTemplate(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{

		request.setAttribute("UNQID", otherCommonService.getElementId());
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "RISK CATEGORIZATION", "OPEN", "Module Accessed");
		return "RiskCategorization/RiskParamFieldsTemplate/index";
	}
	
	@RequestMapping(value="/getRiskParamRequiredFields", method=RequestMethod.POST)
	public String getRiskParamRequiredFields(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		String id = request.getParameter("id");

		request.setAttribute("FIELDSMAP", riskCategorizationService.getRequiredFields());
		request.setAttribute("RESULTLIST", riskCategorizationService.getRiskParameterList());
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "RISK CATEGORIZATION", "SEARCH", "Module Accessed");
		return "RiskCategorization/RiskParamFieldsTemplate/RiskParamFieldsTemplate";
	}

	@RequestMapping(value="/searchRiskParamFields", method=RequestMethod.POST)
	public String searchRiskParamFields(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		String id = request.getParameter("id");
		String templateId = request.getParameter("templateId");
		String templateName = request.getParameter("templateName");
		String productCode = request.getParameter("productCode");
		String custType = request.getParameter("custType");
		String isEnabled = request.getParameter("isEnabled");
		
		request.setAttribute("UNQID", id);
		request.setAttribute("resultData", riskCategorizationService.searchRiskParamFields(templateId, templateName, productCode, custType, isEnabled));
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "RISK CATEGORIZATION", "SEARCH", "Module Accessed");
		return "RiskCategorization/RiskParamFieldsTemplate/SearchBottomFrameTab1";
	}
	
	@RequestMapping(value="/addRiskParamFieldsTemplate", method=RequestMethod.POST)
	public String addRiskParamFieldsTemplate(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		String id = request.getParameter("id");
		String templateId = request.getParameter("templateId");
		String templateName = request.getParameter("templateName");
		String productCode = request.getParameter("productCode");
		String custType = request.getParameter("custType");
		String isEnabled = request.getParameter("isEnabled");
		String productCodeRiskValue = request.getParameter("productCodeRiskValue");
		String custTypeRiskValue = request.getParameter("custTypeRiskValue");
		String userCode = authentication.getPrincipal().toString();
		String CURRENTROLE = request.getSession(false) != null ? (String) 
				request.getSession(false).getAttribute("CURRENTROLE") : "";

		request.setAttribute("UNQID", id);
		request.setAttribute("resultData", riskCategorizationService.addRiskParamFieldsTemplate(templateId, templateName, productCode, custType, productCodeRiskValue, custTypeRiskValue, isEnabled, userCode, CURRENTROLE));
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "RISK CATEGORIZATION", "INSERT", "Risk Parameter Fields Inserted");
		return "RiskCategorization/RiskParamFieldsTemplate/SearchBottomFrameTab1";
	}
	
	@RequestMapping(value="/fetchRiskParamFieldsToUpdate", method=RequestMethod.POST)
	public String fetchRiskParamFieldsToUpdate(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception {
		String selectedTempId = request.getParameter("selectedTempId");
		String selectedTempName = request.getParameter("selectedTempName");
		String selectedProductCode = request.getParameter("selectedProductCode");
		String selectedCustomerType = request.getParameter("selectedCustomerType");
		String selectedIsEnabled = request.getParameter("selectedIsEnabled");
		String searchButton = request.getParameter("searchButton");
		
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("searchButton", searchButton);
		request.setAttribute("FIELDSMAP", riskCategorizationService.getRequiredFields());
		request.setAttribute("RESULTMAP",riskCategorizationService.fetchRiskParamFieldsToUpdate(selectedTempId, selectedTempName, selectedProductCode, selectedCustomerType, selectedIsEnabled));
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "RISK CATEGORIZATION", "READ", "Module Accessed");
		return "RiskCategorization/RiskParamFieldsTemplate/UpdateRiskParamFieldsModal";
	}
	
	@RequestMapping(value="/updateRiskParamFields", method=RequestMethod.POST)
	public @ResponseBody String updateRiskParamFields(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		String templateId = request.getParameter("templateId");
		String templateName = request.getParameter("templateName");
		String productCode = request.getParameter("productCode");
		String custType = request.getParameter("custType");
		String productCodeRiskValue = request.getParameter("productCodeRiskValue");
		String custTypeRiskValue = request.getParameter("custTypeRiskValue");
		String isEnabled = request.getParameter("isEnabled");
		String userCode = authentication.getPrincipal().toString();
		String CURRENTROLE = request.getSession(false) != null ? (String) 
				request.getSession(false).getAttribute("CURRENTROLE") : "";
		
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("resultData",riskCategorizationService.updateRiskParamFields(templateId, templateName, productCode, custType, productCodeRiskValue, custTypeRiskValue, isEnabled, userCode, CURRENTROLE));
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "RISK CATEGORIZATION", "UPDATE", "Risk Parameter Fields Updated");
		return "Updated Successfully.";
	}
	
	@RequestMapping(value="/getTemplatesForRiskParamFieldsTemplate", method=RequestMethod.POST)
	public @ResponseBody Map<String, Object> getTemplatesForRiskParamFieldsTemplate(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "RISK CATEGORIZATION", "SEARCH", "Module Accessed");
		return riskCategorizationService.searchRiskParamFields("", "", "", "", "");
	}
	
	@RequestMapping(value="/searchAddRiskParamFieldsToTemplate", method=RequestMethod.POST)
	public String searchAddRiskParamFieldsToTemplate(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		
		String template = request.getParameter("template");
		String detailType = request.getParameter("detailType");
		
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("template", template);
		request.setAttribute("resultData", riskCategorizationService.searchAddFieldsToTemplate(template, detailType));
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "RISK CATEGORIZATION", "SEARCH", "Module Accessed");
		return "RiskCategorization/RiskParamFieldsTemplate/SearchBottomFrameTab2";
	}
	
	@RequestMapping(value="/updateRiskParamFieldsScore", method=RequestMethod.POST)
	public @ResponseBody String updateRiskParamFieldsScore(HttpServletRequest request, 
			HttpServletResponse response, Authentication authentication){
		
		request.setAttribute("UNQID", otherCommonService.getElementId());
		
		String searchTemplate = request.getParameter("searchTemplate");
		String fullData = request.getParameter("fullData");
		riskCategorizationService.updateComplianceScore(fullData, searchTemplate);
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "RISK CATEGORIZATION", "UPDATE", "Risk Parameter Fields Score Updated");
		return "Successfully updated.";
	}
	
}
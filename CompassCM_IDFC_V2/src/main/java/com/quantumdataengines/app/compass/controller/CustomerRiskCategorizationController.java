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
import com.quantumdataengines.app.compass.service.customerRiskCategorization.CustomerRiskCategorizationService;

@Controller
@RequestMapping(value="/admin")
public class CustomerRiskCategorizationController{
private static final Logger log = LoggerFactory.getLogger(CommonController.class);
	
	@Autowired
	private CommonService commonService;
	@Autowired
	private OtherCommonService otherCommonService;
	@Autowired
	private CustomerRiskCategorizationService customerRiskCategorizationService;
	
	@RequestMapping(value="/customerRiskCategorization", method=RequestMethod.GET)
	public String riskCategorization(HttpServletRequest request, 
	HttpServletResponse response, Authentication authentication){

	request.setAttribute("UNQID", otherCommonService.getElementId());
	
	commonService.auditLog(authentication.getPrincipal().toString(), request, "CUSTOMER RISK CATEGORIZATION", "OPEN", "Module Accessed");
	return "CustomerRiskCategorization/index";
	}
	
	@RequestMapping(value="/getCustomerRiskCategorizationBottomFrame", method=RequestMethod.POST)
	public String getCustomerRiskCategorizationBottomFrame(HttpServletRequest request, 
	HttpServletResponse response, Authentication authentication){

	request.setAttribute("UNQID", otherCommonService.getElementId());
	
	String customerType = "A";
	
	request.setAttribute("STATICPARAMLIST", customerRiskCategorizationService.getStaticRiskParameterList(customerType));
	request.setAttribute("DYNAMICPARAMLIST", customerRiskCategorizationService.getDynamicRiskParameterList(customerType));
	
	commonService.auditLog(authentication.getPrincipal().toString(), request, "CUSTOMER RISK CATEGORIZATION", "OPEN", "Module Accessed");
	return "CustomerRiskCategorization/SearchBottomPage";
	}
	
	@RequestMapping(value="/searchStaticRiskParameters", method=RequestMethod.POST)
	public String searchStaticRiskParameters(HttpServletRequest request, HttpServletResponse response, Authentication authentication){
		String id = request.getParameter("id");
		String customerType = request.getParameter("customerType");
		
		request.setAttribute("UNQID", id);
		request.setAttribute("STATICPARAMLIST", customerRiskCategorizationService.getStaticRiskParameterList(customerType));
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CUSTOMER RISK CATEGORIZATION", "SEARCH", "Module Accessed");
		return "CustomerRiskCategorization/StaticRiskParametersBottomFrame";
	}
	
	@RequestMapping(value="/searchDynamicRiskParameters", method=RequestMethod.POST)
	public String searchDynamicRiskParameters(HttpServletRequest request, HttpServletResponse response, Authentication authentication){
		String id = request.getParameter("id");
		String customerType = request.getParameter("customerType");
		
		request.setAttribute("UNQID", id);
		request.setAttribute("DYNAMICPARAMLIST", customerRiskCategorizationService.getDynamicRiskParameterList(customerType));
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CUSTOMER RISK CATEGORIZATION", "SEARCH", "Module Accessed");
		return "CustomerRiskCategorization/DynamicRiskParametersBottomFrame";
	}
	
	@RequestMapping(value="/saveStaticParameterList", method=RequestMethod.POST)
	public String saveStaticParameterList(HttpServletRequest request, 
			HttpServletResponse response, Authentication authentication){
		String id = request.getParameter("id");
		String strRiskParameters = request.getParameter("staticRiskParameters");
		customerRiskCategorizationService.saveStaticParameterList(strRiskParameters);
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CUSTOMER RISK CATEGORIZATION", "INSERT", "Parameter List Saved");
		return "forward:searchStaticRiskParameters?id="+id;
	}
	
	@RequestMapping(value="/saveDynamicParameterList", method=RequestMethod.POST)
	public String saveDynamicParameterList(HttpServletRequest request, 
			HttpServletResponse response, Authentication authentication){
		String id = request.getParameter("id");
		String strRiskParameters = request.getParameter("dynamicRiskParameters");
		customerRiskCategorizationService.saveDynamicParameterList(strRiskParameters);
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CUSTOMER RISK CATEGORIZATION", "INSERT", "Parameter List Saved");
		return "forward:searchDynamicRiskParameters?id="+id;
	}
	
	@RequestMapping(value="/searchStaticRiskAssignment", method=RequestMethod.POST)
	public String searchStaticRiskAssignment(HttpServletRequest request, HttpServletResponse response, Authentication authentication){
		String id = request.getParameter("id");
		String searchParamId = request.getParameter("searchParamId");
		String customerType = request.getParameter("customerType");
		//System.out.println(searchParamId+" "+customerType);
		request.setAttribute("UNQID", id);
		request.setAttribute("isRangeRequired", request.getParameter("isRangeRequired"));
		request.setAttribute("searchParamId", searchParamId);
		request.setAttribute("STATICRESULTLIST", customerRiskCategorizationService.searchStaticRiskAssignment(searchParamId, customerType));
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CUSTOMER RISK CATEGORIZATION", "SEARCH", "Module Accessed");
		return "CustomerRiskCategorization/StaticRiskAssignmentBottomFrame";
	
	}
	
	@RequestMapping(value="/searchDynamicRiskAssignment", method=RequestMethod.POST)
	public String searchRiskAssignment(HttpServletRequest request, HttpServletResponse response, Authentication authentication){
		String id = request.getParameter("id");
		String searchParamId = request.getParameter("searchParamId");
		String customerType = request.getParameter("customerType");
		//System.out.println(searchParamId+" "+customerType);
		request.setAttribute("searchButton", request.getParameter("searchButton"));
		request.setAttribute("UNQID", id);
		request.setAttribute("isRangeRequired", request.getParameter("isRangeRequired"));
		request.setAttribute("searchParamId", searchParamId);
		request.setAttribute("DYNAMICRESULTLIST", customerRiskCategorizationService.searchDynamicRiskAssignment(searchParamId, customerType));
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CUSTOMER RISK CATEGORIZATION", "SEARCH", "Module Accessed");
		return "CustomerRiskCategorization/DynamicRiskAssignmentBottomFrame";
	
	}
	
	@RequestMapping(value="/updateStaticRiskAssignmentValue", method=RequestMethod.POST)
	public @ResponseBody String updateStaticRiskAssignmentValue(HttpServletRequest request, 
			HttpServletResponse response, Authentication authentication){
		String id = request.getParameter("id");
		String paramId = request.getParameter("paramId");
		String fullData = request.getParameter("fullData");
		customerRiskCategorizationService.updateStaticRiskAssignmentValue(fullData, paramId);
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CUSTOMER RISK CATEGORIZATION", "UPDATE", "Static Risk Assignment Value Updated");
		return "Successfully updated.";
	}
	
	@RequestMapping(value="/updateDynamicRiskAssignmentValue", method=RequestMethod.POST)
	public @ResponseBody String updateDynamicRiskAssignmentValue(HttpServletRequest request, 
			HttpServletResponse response, Authentication authentication){
		String id = request.getParameter("id");
		String paramId = request.getParameter("paramId");
		String fullData = request.getParameter("fullData");
		customerRiskCategorizationService.updateDynamicRiskAssignmentValue(fullData, paramId);
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CUSTOMER RISK CATEGORIZATION", "UPDATE", "Dynamic Risk Assignment Value Updated");
		return "Successfully updated.";
	}
	
	@RequestMapping(value="/fetchParamIdToAddNewDynamicRiskParameter", method=RequestMethod.POST)
	public String fetchParamIdToAddNewRiskParameter(HttpServletRequest request, 
			HttpServletResponse response, Authentication authentication){
		String isNew = request.getParameter("isNew");
		String paramId = request.getParameter("paramId");
		//System.out.println(isNew+" "+paramId);

		String isFromToReq = customerRiskCategorizationService.fetchISFromToReqValueForDynamicCRC(paramId);
		request.setAttribute("paramId", paramId);
		request.setAttribute("isNew", isNew);
		request.setAttribute("isFromToReq", isFromToReq);
		request.setAttribute("searchButton", request.getParameter("searchButton"));
		request.setAttribute("OccupationCodes", customerRiskCategorizationService.getOccupationCodes());
		//System.out.println(isFromToReq);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CUSTOMER RISK CATEGORIZATION", "READ", "Module Accessed");
		return "CustomerRiskCategorization/AddNewDynamicRiskParamModal";
	}
	
	@RequestMapping(value="/saveNewDynamicRiskParam", method=RequestMethod.POST)
	public @ResponseBody String saveNewRiskParam(HttpServletRequest request, 
			HttpServletResponse response, Authentication authentication){
		String id = request.getParameter("id");
		String paramId = request.getParameter("paramId");
		String paramCode = request.getParameter("paramCode");
		String paramDesc = request.getParameter("paramDesc");
		String paramRangeFrom = request.getParameter("paramRangeFrom"); 
		String paramRangeTo = request.getParameter("paramRangeTo");
		String paramRiskValue = request.getParameter("paramRiskValue");
		String paramOccupation = request.getParameter("paramOccupation");
		String userCode = authentication.getPrincipal().toString();
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CUSTOMER RISK CATEGORIZATION", "INSERT", "New Dynamic Risk Parameter Saved");
		return customerRiskCategorizationService.saveNewDynamicRiskParam(paramId, paramCode, paramDesc, paramRangeFrom, paramRangeTo, paramRiskValue, paramOccupation, userCode);
	}
	
	@RequestMapping(value="/fetchParamCodeToDeleteDynamicRiskParameter", method=RequestMethod.POST)
	public String fetchParamCodeToDeleteRiskParameter(HttpServletRequest request, 
			HttpServletResponse response, Authentication authentication){
		String paramCode = request.getParameter("paramCode");
		String searchParamId = request.getParameter("searchParamId");
		request.setAttribute("searchButton", request.getParameter("searchButton"));
		request.setAttribute("UNQID", request.getParameter("id"));
		request.setAttribute("DATAMAP", customerRiskCategorizationService.fetchParamCodeToDeleteDynamicRiskParameter(searchParamId, paramCode));
		request.setAttribute("paramId", searchParamId);
		request.setAttribute("OccupationCodes", customerRiskCategorizationService.getOccupationCodes());
		commonService.auditLog(authentication.getPrincipal().toString(), request, "RISK CATEGORIZATION", "READ", "Module Accessed");
		return "CustomerRiskCategorization/AddNewDynamicRiskParamModal";
	}

	@RequestMapping(value="/deleteNewDynamicRiskParam", method=RequestMethod.POST)
	public @ResponseBody String deleteNewRiskParam(HttpServletRequest request, 
			HttpServletResponse response, Authentication authentication){
		String paramId = request.getParameter("paramId");
		String paramCode = request.getParameter("paramCode");
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CUSTOMER RISK CATEGORIZATION", "DELETE", "Risk Parameter Deleted");
		return customerRiskCategorizationService.deleteNewDynamicRiskParam(paramId, paramCode);
	}
	
	@RequestMapping(value="/updateNewDynamicRiskParam", method=RequestMethod.POST)
	public @ResponseBody String updateNewRiskParam(HttpServletRequest request, 
			HttpServletResponse response, Authentication authentication){
		String paramId = request.getParameter("paramId");
		String paramCode = request.getParameter("paramCode");
		String paramDesc = request.getParameter("paramDesc");
		String paramRangeFrom = request.getParameter("paramRangeFrom"); 
		String paramRangeTo = request.getParameter("paramRangeTo");
		String paramRiskValue = request.getParameter("paramRiskValue");
		String paramOccupation = request.getParameter("paramOccupation");
		String userCode = authentication.getPrincipal().toString();
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CUSTOMER RISK CATEGORIZATION", "UPDATE", "Risk Parameter Updated");
		return customerRiskCategorizationService.updateNewDynamicRiskParam(paramId, paramCode, paramDesc, paramRangeFrom, paramRangeTo, paramRiskValue, paramOccupation, userCode);
	}
	
	@RequestMapping(value="/searchStaticRiskWeightage", method=RequestMethod.POST)
	public String searchStaticRiskWeightage(HttpServletRequest request, HttpServletResponse response, Authentication authentication){
		String id = request.getParameter("id");
		String customerType = request.getParameter("customerType");
		//System.out.println(customerType);
		request.setAttribute("UNQID", id);
		request.setAttribute("STATICPARAMLIST", customerRiskCategorizationService.getStaticRiskParameterList(customerType));
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CUSTOMER RISK CATEGORIZATION", "SEARCH", "Module Accessed");
		return "CustomerRiskCategorization/StaticRiskCalculationBottomFrame";
	}
	
	@RequestMapping(value="/searchDynamicRiskWeightage", method=RequestMethod.POST)
	public String searchDynamicRiskWeightage(HttpServletRequest request, HttpServletResponse response, Authentication authentication){
		String id = request.getParameter("id");
		String customerType = request.getParameter("customerType");
		
		request.setAttribute("UNQID", id);
		request.setAttribute("DYNAMICPARAMLIST", customerRiskCategorizationService.getDynamicRiskParameterList(customerType));
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CUSTOMER RISK CATEGORIZATION", "SEARCH", "Module Accessed");
		return "CustomerRiskCategorization/DynamicRiskCalculationBottomFrame";
	}
	
	@RequestMapping(value="/updateStaticRiskWeightageList", method=RequestMethod.POST)
	public String updateStaticRiskWeightageList(HttpServletRequest request, 
			HttpServletResponse response, Authentication authentication){
		String id = request.getParameter("id");
		String staticRiskWeightages = request.getParameter("staticRiskWeightage");
		//System.out.println("staticRiskWeightages = "+staticRiskWeightages);
		customerRiskCategorizationService.updateStaticRiskWeightageList(staticRiskWeightages);
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CUSTOMER RISK CATEGORIZATION", "INSERT", "Parameter Weightage Updated");
		//return "forward:searchStaticRiskWeightage?id="+id;
		return "Static Weightages Updated Successfully.";
	}
	
	@RequestMapping(value="/updateDynamicRiskWeightageList", method=RequestMethod.POST)
	public String updateDynamicRiskWeightageList(HttpServletRequest request, 
			HttpServletResponse response, Authentication authentication){
		String id = request.getParameter("id");
		String dynamicRiskWeightages = request.getParameter("dynamicRiskWeightage");
		//System.out.println("dynamicRiskWeightages = "+dynamicRiskWeightages);
		customerRiskCategorizationService.updateDynamicRiskWeightageList(dynamicRiskWeightages);
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CUSTOMER RISK CATEGORIZATION", "INSERT", "Parameter Weightage Updated");
		//return "forward:searchDynamicRiskWeightage?id="+id;
		return "Static Weightages Updated Successfully.";
	}
	
	@RequestMapping(value="/calculateStaticRisk", method=RequestMethod.POST)
	public @ResponseBody String calculateStaticRisk(HttpServletRequest request, 
			HttpServletResponse response, Authentication authentication){
		String userCode = authentication.getPrincipal().toString();
		String CURRENTROLE = request.getSession(false) != null ? (String) request.getSession(false).getAttribute("CURRENTROLE") : "";
		String ipAddress = request.getRemoteAddr();
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CUSTOMER RISK CATEGORIZATION", "UPDATE", "Static Risk Calculated");
		return customerRiskCategorizationService.calculateStaticRisk(userCode, CURRENTROLE, ipAddress);
	}
	
	@RequestMapping(value="/calculateDynamicRisk", method=RequestMethod.POST)
	public @ResponseBody String calculateDynamicRisk(HttpServletRequest request, 
			HttpServletResponse response, Authentication authentication){
		String userCode = authentication.getPrincipal().toString();
		String CURRENTROLE = request.getSession(false) != null ? (String) request.getSession(false).getAttribute("CURRENTROLE") : "";
		String ipAddress = request.getRemoteAddr();
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CUSTOMER RISK CATEGORIZATION", "UPDATE", "Dynamic Risk Calculated");
		return customerRiskCategorizationService.calculateDynamicRisk(userCode, CURRENTROLE, ipAddress);
	}
	
	/*	
	@RequestMapping(value="/riskParamFieldsTemplate", method=RequestMethod.GET)
	public String riskParamFieldsTemplate(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{

		request.setAttribute("UNQID", otherCommonService.getElementId());
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CUSTOMER RISK CATEGORIZATION", "OPEN", "Module Accessed");
		return "RiskCategorization/RiskParamFieldsTemplate/index";
	}
	
	@RequestMapping(value="/getRiskParamRequiredFields", method=RequestMethod.POST)
	public String getRiskParamRequiredFields(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		String id = request.getParameter("id");

		request.setAttribute("FIELDSMAP", customerRiskCategorizationService.getRequiredFields());
		request.setAttribute("RESULTLIST", customerRiskCategorizationService.getRiskParameterList());
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CUSTOMER RISK CATEGORIZATION", "SEARCH", "Module Accessed");
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
		request.setAttribute("resultData", customerRiskCategorizationService.searchRiskParamFields(templateId, templateName, productCode, custType, isEnabled));
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CUSTOMER RISK CATEGORIZATION", "SEARCH", "Module Accessed");
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
		request.setAttribute("resultData", customerRiskCategorizationService.addRiskParamFieldsTemplate(templateId, templateName, productCode, custType, productCodeRiskValue, custTypeRiskValue, isEnabled, userCode, CURRENTROLE));
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CUSTOMER RISK CATEGORIZATION", "INSERT", "Risk Parameter Fields Inserted");
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
		request.setAttribute("FIELDSMAP", customerRiskCategorizationService.getRequiredFields());
		request.setAttribute("RESULTMAP",customerRiskCategorizationService.fetchRiskParamFieldsToUpdate(selectedTempId, selectedTempName, selectedProductCode, selectedCustomerType, selectedIsEnabled));
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CUSTOMER RISK CATEGORIZATION", "READ", "Module Accessed");
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
		request.setAttribute("resultData",customerRiskCategorizationService.updateRiskParamFields(templateId, templateName, productCode, custType, productCodeRiskValue, custTypeRiskValue, isEnabled, userCode, CURRENTROLE));
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CUSTOMER RISK CATEGORIZATION", "UPDATE", "Risk Parameter Fields Updated");
		return "Updated Successfully.";
	}
	
	@RequestMapping(value="/getTemplatesForRiskParamFieldsTemplate", method=RequestMethod.POST)
	public @ResponseBody Map<String, Object> getTemplatesForRiskParamFieldsTemplate(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CUSTOMER RISK CATEGORIZATION", "SEARCH", "Module Accessed");
		return customerRiskCategorizationService.searchRiskParamFields("", "", "", "", "");
	}
	
	@RequestMapping(value="/searchAddRiskParamFieldsToTemplate", method=RequestMethod.POST)
	public String searchAddRiskParamFieldsToTemplate(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		
		String template = request.getParameter("template");
		String detailType = request.getParameter("detailType");
		
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("template", template);
		request.setAttribute("resultData", customerRiskCategorizationService.searchAddFieldsToTemplate(template, detailType));
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CUSTOMER RISK CATEGORIZATION", "SEARCH", "Module Accessed");
		return "RiskCategorization/RiskParamFieldsTemplate/SearchBottomFrameTab2";
	}
	
	@RequestMapping(value="/updateRiskParamFieldsScore", method=RequestMethod.POST)
	public @ResponseBody String updateRiskParamFieldsScore(HttpServletRequest request, 
			HttpServletResponse response, Authentication authentication){
		
		request.setAttribute("UNQID", otherCommonService.getElementId());
		
		String searchTemplate = request.getParameter("searchTemplate");
		String fullData = request.getParameter("fullData");
		customerRiskCategorizationService.updateComplianceScore(fullData, searchTemplate);
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CUSTOMER RISK CATEGORIZATION", "UPDATE", "Risk Parameter Fields Score Updated");
		return "Successfully updated.";
	}
	
*/}
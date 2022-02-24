/*package com.quantumdataengines.app.compass.controller;

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
public class CustomerRiskCategorizationController_static {
private static final Logger log = LoggerFactory.getLogger(CommonController.class);

@Autowired
private CustomerRiskCategorizationService customerRiskCategorizationService;
@Autowired
private CommonService commonService;
@Autowired
private OtherCommonService otherCommonService;

	@RequestMapping(value="/customerRiskCategorization")
	public String customerRiskCategorization(HttpServletRequest request, HttpServletResponse response, Authentication authentication){
	request.setAttribute("UNQID", otherCommonService.getElementId());
	commonService.auditLog(authentication.getPrincipal().toString(), request, "CUSTOMER RISK CATEGORIZATION", "OPEN", "Module Accessed");
	return "CustomerRiskCategorization/index";
	}
	
	@RequestMapping(value="/getCRCTabContent", method=RequestMethod.POST)
	public String getCRCTabContent(HttpServletRequest request, HttpServletResponse response, Authentication authentication){
		String id = request.getParameter("id");
		
		request.setAttribute("UNQID", id);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CUSTOMER RISK CATEGORIZATION", "SEARCH", "Module Accessed");
		return "CustomerRiskCategorization/CRCTabContent";
	}

	@RequestMapping(value="/searchStaticCRCParamAssignment")
	public String searchStaticCRCParamAssignment(HttpServletRequest request, HttpServletResponse response, Authentication authentication){
		String customerType = request.getParameter("customerType");
		String riskParam = request.getParameter("riskParam");
		String id = request.getParameter("id");
		
		request.setAttribute("UNQID", id);
		request.setAttribute("RESULTLIST", customerRiskCategorizationService.searchStaticCRCParamAssignment(customerType, riskParam));
		//System.out.println(customerRiskCategorizationService.searchStaticCRCParamAssignment(customerType, riskParam));
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CUSTOMER RISK CATEGORIZATION", "SEARCH", "Module Accessed");
		return "CustomerRiskCategorization/StaticCRCAssignmentBottomFrame";
	}
	
	@RequestMapping(value="/updateStaticRiskAssignmentValue")
	public @ResponseBody String updateStaticRiskAssignmentValue(HttpServletRequest request, HttpServletResponse response, Authentication authentication){
		String fullData = request.getParameter("fullData");
		String riskParam = request.getParameter("riskParam");
		
		//System.out.println(fullData+" "+riskParam);
		request.setAttribute("RESULTLIST", customerRiskCategorizationService.updateStaticRiskAssignmentValue(fullData, riskParam));
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CUSTOMER RISK CATEGORIZATION", "UPDATE", "Data Updated");
		return "Successfully updated";
	}
	
}
*/
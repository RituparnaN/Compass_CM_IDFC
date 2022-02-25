package com.quantumdataengines.app.compass.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.quantumdataengines.app.compass.otherservice.OtherCommonService;
import com.quantumdataengines.app.compass.service.CommonService;
import com.quantumdataengines.app.compass.service.manualEntityLinkage.ManualEntityLinkageService;
import com.quantumdataengines.app.compass.service.master.GenericMasterService;

@Controller
@RequestMapping(value="/common")
public class ManualEntityLinkageController {
	@Autowired
	private CommonService commonService;
	@Autowired
	private OtherCommonService otherCommonService;
	@Autowired
	private GenericMasterService genericMasterService;
	
	@Autowired 
	private ManualEntityLinkageService manualEntityLinkageService;
	
	@RequestMapping(value="/manualEntityLinkage", method=RequestMethod.GET)
	public String index (HttpServletRequest request, HttpServletResponse response,Authentication authentication) {
		
			String moduleType = request.getParameter("moduleType");
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		request.setAttribute("UNQID", otherCommonService.getElementId());
		List<Map<String, Object>> res = genericMasterService.getModuleParameters(moduleType,authentication.getPrincipal().toString(), userRole, request.getRemoteAddr());
		request.setAttribute("MASTERSEARCHFRAME", res);
		request.setAttribute("MODULETYPE", moduleType);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "Manual Entity Linkage", "OPEN", "Module Accessed");
		
		return "ManualEntityLinkage/index";
	}
	
	@RequestMapping(value="/getEntityDetails", method=RequestMethod.POST)
	public String getEntityDetails(HttpServletRequest request, HttpServletResponse response,Authentication authentication) {
		String sourceCustomerId = request.getParameter("1_SOURCECUSTOMERID");
		String destinationCustomerId = request.getParameter("2_DESTINATIONCUSTOMERID");
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String userCode = authentication.getPrincipal().toString();
		String ipAddress = request.getRemoteAddr();
		Map<String,String>entityRelationType = manualEntityLinkageService.getEntityRelationTypes(userCode,userRole,ipAddress);
		Map<String,List<String>> customerAccount = manualEntityLinkageService.getCustomerAccountList(sourceCustomerId,destinationCustomerId,userCode,userRole,ipAddress);
		
		request.setAttribute("SOURCECUSTOMERID", sourceCustomerId);
		request.setAttribute("SOURCEACCOUNTLIST", customerAccount.get(sourceCustomerId));
		request.setAttribute("DESTINATIONCUSTOMERID", destinationCustomerId);
		request.setAttribute("DESTINATIONACCOUNTLIST", customerAccount.get(destinationCustomerId));
		request.setAttribute("RELATIONTYPE", entityRelationType);
		request.setAttribute("UNQID", otherCommonService.getElementId());
		commonService.auditLog(authentication.getPrincipal().toString(), request, "Manual Entity Linkage", "READ", "Module Accessed");
		return "ManualEntityLinkage/CreateEntityRealtionLinkage";
	}
	
	@RequestMapping(value = "/saveEntityLinkage",method=RequestMethod.POST)
	@ResponseBody
	public String saveEntityLinkage(HttpServletRequest request, Authentication authentication) {
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String userCode = authentication.getPrincipal().toString();
		String ipAddress = request.getRemoteAddr();
		
		Map<String,String>entityRelationDetails = new HashMap<>();
		entityRelationDetails.put("SOURCEACCOUNTNO", request.getParameter("SOURCEACCOUNTNO"));
		entityRelationDetails.put("DESTINATIONACCOUNTNO",request.getParameter("DESTINATIONACCOUNTNO") );
		entityRelationDetails.put("SOURCECUSTOMERID", request.getParameter("SOURCECUSTOMERID"));
		entityRelationDetails.put("DESTINATIONCUSTOMERID", request.getParameter("DESTINATIONCUSTOMERID"));
		entityRelationDetails.put("RELATIONSHIPCODE", request.getParameter("RELATIONSHIPCODE"));
		entityRelationDetails.put("REMARKS", request.getParameter("REMARKS"));
		//List<HashMap<String, String>> entityRelationDetails = new ArrayList<HashMap<String,String>>();
		String res = manualEntityLinkageService.saveEntityLinkage(entityRelationDetails,userCode,userRole,ipAddress);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "Manual Entity Linkage", "WRITE", "Module Accessed");
		return res;
	}
	
	
	
	

}

package com.quantumdataengines.app.compass.controller;
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

import com.quantumdataengines.app.compass.otherservice.OtherCommonService;
import com.quantumdataengines.app.compass.service.CommonService;
import com.quantumdataengines.app.compass.service.falsePositive.FalsePositiveService;
import com.quantumdataengines.app.compass.service.master.GenericMasterService;

@Controller
@RequestMapping(value="/admin")
public class FalsePositiveController {
	private static final Logger log = LoggerFactory.getLogger(CommonController.class);
	
	@Autowired
	private CommonService commonService;
	@Autowired
	private OtherCommonService otherCommonService;
	@Autowired
	private FalsePositiveService falsePositiveService;
	@Autowired
	private GenericMasterService genericMasterService;
	
	@RequestMapping(value="/falsePositive", method=RequestMethod.GET)
	public String falsePositive(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{

		request.setAttribute("USERROLE", request.getSession(false).getAttribute("CURRENTROLE") == null ? "N.A.":request.getSession(false).getAttribute("CURRENTROLE").toString());
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("ALERTCODES", genericMasterService.getOptionNameValueFromView("VW_ALERTCODE"));
		//request.setAttribute("ALERTMESSAGES", falsePositiveService.getAlertMessages("VW_ALERTMESSAGE"));
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CUSTOMER FALSE POSITIVE", "OPEN", "Module Accessed");
		return "FalsePositive/index";
	}
	
	@RequestMapping(value="/getAlertMessages", method=RequestMethod.POST)
	public @ResponseBody List<Map<String,String>> getAlertMessage(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		String alertCode = request.getParameter("alertCode");
		//request.setAttribute("ALERTMESSAGES", falsePositiveService.getAlertMessages(alertCode));
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CUSTOMER FALSE POSITIVE", "OPEN", "Module Accessed");
		return falsePositiveService.getAlertMessages(alertCode);
	}
	
	@RequestMapping(value = "/searchFalsePositives", method=RequestMethod.POST) 
	public String searchFalsePositives(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication) throws Exception {
		String custId = request.getParameter("custId");
		String accNo = request.getParameter("accNo");
		String alertCode = request.getParameter("alertCode");
		String alertMsg = request.getParameter("alertMsg");
		String activeFrom = request.getParameter("activeFrom");
		String activeTo = request.getParameter("activeTo");
		String isEnabled = request.getParameter("isEnabled");
		String reason = request.getParameter("reason");
		String toleranceLevel = request.getParameter("toleranceLevel");
		String status = request.getParameter("status");
		String userRole = request.getSession(false).getAttribute("CURRENTROLE") == null ? "N.A.":request.getSession(false).getAttribute("CURRENTROLE").toString();

		Map<String, Object> resultMap =  falsePositiveService.searchFalsePositives(custId, accNo, alertCode,
				alertMsg, activeFrom, activeTo, isEnabled, reason, toleranceLevel, status, userRole);
		
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("resultData", resultMap);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CUSTOMER FALSE POSITIVE", "SEARCH", "Module Accessed");
		return "FalsePositive/SearchBottomFrame";
	}

	@RequestMapping(value = "/addFalsePositive", method=RequestMethod.POST)
	public String addFalsePositive(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception {
		String custId = request.getParameter("custId");
		String accNo = request.getParameter("accNo");
		String alertCode = request.getParameter("alertCode");
		String alertMsg = request.getParameter("alertMsg");
		String activeFrom = request.getParameter("activeFrom");
		String activeTo = request.getParameter("activeTo");
		String isEnabled = request.getParameter("isEnabled");
		String reason = request.getParameter("reason");
		String toleranceLevel = request.getParameter("toleranceLevel");
		String status = request.getParameter("status");
		String adminComments = request.getParameter("adminComments");
		String userCode = authentication.getPrincipal().toString();
		String CURRENTROLE = request.getSession(false) != null ? (String) 
				request.getSession(false).getAttribute("CURRENTROLE") : "";

		Map<String, Object> resultMap = falsePositiveService.addFalsePositive(custId, accNo, alertCode, alertMsg, activeFrom, activeTo,
				isEnabled, reason, toleranceLevel, status, adminComments, userCode, CURRENTROLE);
		
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("resultData",resultMap);
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CUSTOMER FALSE POSITIVE", "SEARCH", "Module Accessed To Add False Positive");
		return "FalsePositive/SearchBottomFrame";

	}
	
	@RequestMapping(value="/fetchFalsePositiveToUpdate", method=RequestMethod.POST)
	public String fetchFalsePositiveToUpdate(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception {
		String selectedCustId = request.getParameter("selectedCustId");
		String selectedAccNo = request.getParameter("selectedAccNo");
		String selectedAlertCode = request.getParameter("selectedAlertCode");
		String selectedStatus = request.getParameter("selectedStatus");
		String searchButton = request.getParameter("searchButton");
		String isView = request.getParameter("isView");
		/*System.out.println("CONTROLLER INPUT --- selectedCustId="+selectedCustId+"&selectedAccNo="+selectedAccNo+
							  "&selectedStatus="+selectedStatus+"&selectedAlertCode="+selectedAlertCode+"&searchButton="+searchButton);*/
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("searchButton", searchButton);
		request.setAttribute("isView", isView);
		request.setAttribute("ALERTCODES", genericMasterService.getOptionNameValueFromView("VW_ALERTCODE"));
		request.setAttribute("RESULTMAP", falsePositiveService.fetchFalsePositiveToUpdate(selectedCustId, selectedAccNo, selectedAlertCode, selectedStatus));
		//System.out.println("CONTROLLER OUTPUT --- "+falsePositiveService.fetchFalsePositiveToUpdate(selectedCustId, selectedAccNo, selectedAlertCode, selectedStatus));
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CUSTOMER FALSE POSITIVE", "OPEN", "Module Accessed To Update False Positive");
		return "FalsePositive/UpdateFalsePositiveModal";
	}
	
	@RequestMapping(value="/attachFalsePositiveMappingFile", method=RequestMethod.POST)
	public String attachAlertsRatingMappingFile(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		
		String uploadRefNo = request.getParameter("uploadRefNo");
		String moduleRefId= request.getParameter("moduleRefId");
		
		request.setAttribute("uploadRefNo", uploadRefNo);
		request.setAttribute("moduleRefId", moduleRefId);
		request.setAttribute("UNQID", otherCommonService.getElementId());
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CUSTOMER FALSE POSITIVE", "INSERT", "Data Inserted");
		return "FalsePositive/FalsePositiveMappingFileUploadProcessModal";
	}
	
	@RequestMapping(value="/processFalsePositiveUploadedFile", method=RequestMethod.POST)
	public @ResponseBody String processFalsePositiveUploadedFile(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		String uploadRefNo = request.getParameter("uploadRefNo");
		String moduleRefId = request.getParameter("moduleRefId");
		String userCode = authentication.getPrincipal().toString();
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CUSTOMER FALSE POSITIVE", "UPDATE", "Data Processed");
		return falsePositiveService.processFalsePositiveUploadedFile(moduleRefId, userCode);
	}
	
	@RequestMapping(value="/updateFalsePositive", method=RequestMethod.POST)
	public @ResponseBody String updateFalsePositive(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception {
		String custId = request.getParameter("custId");
		String accNo = request.getParameter("accNo");
		String alertCode = request.getParameter("alertCode");
		String alertMsg = request.getParameter("alertMsg");
		String activeFrom = request.getParameter("activeFrom");
		String activeTo = request.getParameter("activeTo");
		String isEnabled = request.getParameter("isEnabled");
		String reason = request.getParameter("reason");
		String toleranceLevel = request.getParameter("toleranceLevel");
		String status = request.getParameter("status");
		String adminComments = request.getParameter("adminComments");
		String userCode = authentication.getPrincipal().toString();
		String CURRENTROLE = request.getSession(false) != null ? (String) 
				request.getSession(false).getAttribute("CURRENTROLE") : "";
		// System.out.println("Controller --- activeFrom = "+activeFrom+" activeTo"+activeTo);
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("resultData", falsePositiveService.updateFalsePositive(custId, accNo, alertCode, alertMsg, activeFrom, activeTo, isEnabled, reason, toleranceLevel, status, adminComments, userCode, CURRENTROLE));
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CUSTOMER FALSE POSITIVE", "UPDATE", "Customer False Positive Updated");
		return "Updated Successfully.";
	}
	
	@RequestMapping(value="/rejectFalsePositive", method=RequestMethod.POST)
	public String rejectFalsePositive(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception {
		String selectedCustId = request.getParameter("selectedCustId");
		String selectedAccNo = request.getParameter("selectedAccNo");
		String selectedAlertCode = request.getParameter("selectedAlertCode");
		String mlroComments = request.getParameter("mlroComments");
		String userCode = authentication.getPrincipal().toString();
		
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("ALERTCODES", genericMasterService.getOptionNameValueFromView("VW_ALERTCODE"));
		request.setAttribute("RESULTMAP", falsePositiveService.rejectFalsePositive(selectedCustId, selectedAccNo, selectedAlertCode, mlroComments, userCode));
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CUSTOMER FALSE POSITIVE", "REJECTED", "Module Accessed To Reject False Positive");
		return "FalsePositive/SearchBottomFrame";
		/*return "Rejected Successfully";*/
	}
	
	@RequestMapping(value="/approveFalsePositive", method=RequestMethod.POST)
	public String approveFalsePositive(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception {
		String selectedCustId = request.getParameter("selectedCustId");
		String selectedAccNo = request.getParameter("selectedAccNo");
		String selectedAlertCode = request.getParameter("selectedAlertCode");
		String selectedAlertMessage = request.getParameter("selectedAlertMessage");
		String selectedActiveFrom = request.getParameter("selectedActiveFrom");
		String selectedActiveTo = request.getParameter("selectedActiveTo");
		String selectedReason = request.getParameter("selectedReason");
		String selectedIsEnabled = request.getParameter("selectedIsEnabled");
		String selectedToleranceLevel = request.getParameter("selectedToleranceLevel");
		String selectedMlroComments = request.getParameter("selectedMlroComments");
		String selectedAdminComments = request.getParameter("selectedAdminComments");
		String selectedAdminTimestamp = request.getParameter("selectedAdminTimestamp");
		String userCode = authentication.getPrincipal().toString();
		/*
		System.out.println("selectedCustId="+selectedCustId+"&selectedAccNo="+selectedAccNo+
							  "&selectedAlertCode="+selectedAlertCode+"&selectedAlertMessage="+selectedAlertMessage+
							  "&selectedActiveFrom="+selectedActiveFrom+"&selectedActiveTo="+selectedActiveTo+
							  "&selectedReason="+selectedReason+"&selectedIsEnabled="+selectedIsEnabled+
							  "&selectedToleranceLevel="+selectedToleranceLevel+"&selectedMlroComments="+selectedMlroComments+
							  "&selectedAdminComments="+selectedAdminComments+"&selectedAdminTimestamp="+selectedAdminTimestamp);
		*/
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("ALERTCODES", genericMasterService.getOptionNameValueFromView("VW_ALERTCODE"));
		request.setAttribute("RESULTMAP", falsePositiveService.approveFalsePositive(selectedCustId, selectedAccNo, selectedAlertCode, selectedAlertMessage, selectedActiveFrom, selectedActiveTo, selectedReason, 
				selectedIsEnabled, selectedToleranceLevel, selectedAdminComments, selectedAdminTimestamp, selectedMlroComments, userCode));
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CUSTOMER FALSE POSITIVE", "APPROVED", "Module Accessed To Approve False Positive");
		return "FalsePositive/SearchBottomFrame";
		/*return "Rejected Successfully";*/
	}


}




	
	
	
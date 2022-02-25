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
import com.quantumdataengines.app.compass.service.alertConfiguration.AlertCodesService;
import com.quantumdataengines.app.compass.service.alertConfiguration.AlertRatingsService;
import com.quantumdataengines.app.compass.service.alertConfiguration.AlertScoringService;
import com.quantumdataengines.app.compass.service.master.GenericMasterService;

@Controller
@RequestMapping(value="/admin")
public class AlertConfigController {
private static final Logger log = LoggerFactory.getLogger(CommonController.class);
	
	@Autowired
	private CommonService commonService;
	@Autowired
	private OtherCommonService otherCommonService;
	@Autowired
	private AlertCodesService alertCodesService;
	@Autowired
	private AlertRatingsService alertRatingsService;
	@Autowired
	private AlertScoringService alertScoringService;
	@Autowired
	private GenericMasterService genericMasterService;
	
	//Alert Codes
	@RequestMapping(value="/alertCodes", method=RequestMethod.GET)
	public String alertCodes(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{

		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("ALERTCODES", genericMasterService.getOptionNameValueFromView("VW_ALERTCODE"));
		commonService.auditLog(authentication.getPrincipal().toString(), request, "ALERTCONFIGURATION", "OPEN", "Module Accessed");
		return "AlertConfiguration/AlertCodes/index";
	}
	
	@RequestMapping(value="/getAlertCodeForAlertType", method=RequestMethod.POST)
	public @ResponseBody List<Map<String, String>> getAlertCodeForAlertType(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		String alertType = request.getParameter("alertType");
		
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("DATALIST", alertCodesService.getAlertCodeForAlertType(alertType));
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "ALERTCONFIGURATION", "SEARCH", "Module Accessed");
		return alertCodesService.getAlertCodeForAlertType(alertType);
	}
	
	@RequestMapping(value="/searchAlertCodeDetails", method=RequestMethod.POST)
	public String searchAlertCodeDetails(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		String alertType = request.getParameter("alertType");
		String alertCode = request.getParameter("alertCode");
		
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("DATAMAP", alertCodesService.searchAlertCodeDetails(alertType, alertCode));
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "ALERTCONFIGURATION", "SEARCH", "Module Accessed");
		return "AlertConfiguration/AlertCodes/SearchBottomFrame";
	}
	
	@RequestMapping(value="/openModalTocreateSubjectiveAlert", method=RequestMethod.POST)
	public String openModalTocreateSubjectiveAlert(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		
		request.setAttribute("UNQID", otherCommonService.getElementId());
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "ALERTCONFIGURATION", "OPEN", "Module Accessed");
		return "AlertConfiguration/AlertCodes/CreateSubjectiveAlertModal";
	}
	
	@RequestMapping(value="/createSubjectiveAlert", method=RequestMethod.POST)
	public @ResponseBody String createSubjectiveAlert(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		String alertCode =request.getParameter("alertCode");
		String alertName =request.getParameter("alertName");	
		String description =request.getParameter("description");
		String alertMsg =request.getParameter("alertMsg");
		String alertPriority =request.getParameter("alertPriority");
		String alertEnabled =request.getParameter("alertEnabled");
		String userCode = authentication.getPrincipal().toString();
		
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("resultData", alertCodesService.createSubjectiveAlert(alertCode, alertName, description, alertMsg, alertPriority, alertEnabled, userCode));
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "ALERTCONFIGURATION", "INSERT", "Data Saved");
		return "Subjective Alert successfully created";
	}
	
	@RequestMapping(value="/updateAlertDetails", method=RequestMethod.POST)
	public @ResponseBody String updateAlertDetails(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		String alertCode =request.getParameter("alertCode");
		String alertName =request.getParameter("alertName");	
		String description =request.getParameter("description");
		String alertMsg =request.getParameter("alertMsg");
		String alertPriority =request.getParameter("alertPriority");
		String alertEnabled =request.getParameter("alertEnabled");
		String userCode = authentication.getPrincipal().toString();
		
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("resultData", alertCodesService.updateAlertDetails(alertCode, alertName, description, alertMsg, alertPriority, alertEnabled, userCode));
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "ALERTCONFIGURATION", "UPDATE", "Data Updated");
		return "Alert Details successfully updated";
	}
		
	//Alerts Rating
	
	@RequestMapping(value="/alertRatings", method=RequestMethod.GET)
	public String alertRatings(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{

		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("ALERTCODE", alertRatingsService.getAlertCode());
		request.setAttribute("ALERTMSG", alertRatingsService.getAlertMsg(null));
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "ALERTCONFIGURATION", "OPEN", "Module Accessed");
		return "AlertConfiguration/AlertRatings/index";
	}
	
	@RequestMapping(value="/getAlertCode", method=RequestMethod.POST)
	public @ResponseBody List<Map<String, String>> getAlertCodeAndMsg(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		String alertCode = request.getParameter("alertCode");
		commonService.auditLog(authentication.getPrincipal().toString(), request, "ALERTCONFIGURATION", "READ", "Module Accessed");
		return alertRatingsService.getAlertMsg(alertCode);
	}
		
	@RequestMapping(value="/searchAlertRatingsDetails", method=RequestMethod.POST)
	public String searchAlertRatingsDetails(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		String alertCode = request.getParameter("alertCode");
		String alertMsg = request.getParameter("alertMsg");
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("DATALIST", alertRatingsService.searchAlertRatingsDetails(alertCode, alertMsg));
		commonService.auditLog(authentication.getPrincipal().toString(), request, "ALERTCONFIGURATION", "SEARCH", "Module Accessed");
		return "AlertConfiguration/AlertRatings/SearchBottomFrame";
	}
	
	@RequestMapping(value="/updateAlertRatingsValues", method=RequestMethod.POST)
	public @ResponseBody String updateAlertRatingsValues(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		String fullData = request.getParameter("fullData");
		String userCode = authentication.getPrincipal().toString();
		
		request.setAttribute("UNQID", otherCommonService.getElementId());
		commonService.auditLog(authentication.getPrincipal().toString(), request, "ALERTCONFIGURATION", "UPDATE", "Data Updated");
		return alertRatingsService.updateAlertRatingsValues(fullData, userCode);
	}

	@RequestMapping(value="/attachAlertsRatingMappingFile", method=RequestMethod.POST)
	public String attachAlertsRatingMappingFile(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		
		String uploadRefNo = request.getParameter("uploadRefNo");
		String moduleRefId= request.getParameter("moduleRefId");
		
		request.setAttribute("uploadRefNo", uploadRefNo);
		request.setAttribute("moduleRefId", moduleRefId);
		request.setAttribute("UNQID", otherCommonService.getElementId());
		commonService.auditLog(authentication.getPrincipal().toString(), request, "ALERTCONFIGURATION", "INSERT", "Data Inserted");
		return "AlertConfiguration/AlertRatings/AlertRatingMappingFileUploadProcessModal";
	}
	
	@RequestMapping(value="/processAlertRatingUploadedFile", method=RequestMethod.POST)
	public @ResponseBody String processAlertRatingUploadedFile(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		String uploadRefNo = request.getParameter("uploadRefNo");
		String moduleRefId = request.getParameter("moduleRefId");
		String userCode = authentication.getPrincipal().toString();
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "ALERTCONFIGURATION", "UPDATE", "Data Processed");
		return alertRatingsService.processAlertRatingUploadedFile(moduleRefId, userCode);
	}
	//Alert Scoring
	
	@RequestMapping(value="/alertScoring", method=RequestMethod.GET)
	public String alertScoring(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{

		request.setAttribute("UNQID", otherCommonService.getElementId());
		commonService.auditLog(authentication.getPrincipal().toString(), request, "ALERTCONFIGURATION", "OPEN", "Module Accessed");
		return "AlertConfiguration/AlertScoring/index";
	}
	
	@RequestMapping(value="/getAlertScoringBottomFrame", method=RequestMethod.POST)
	public String getAlertScoringBottomFrame(HttpServletRequest request, 
			HttpServletResponse response, Authentication authentication){
		String id = request.getParameter("id");
		
		request.setAttribute("UNQID", id);
		request.setAttribute("RESULTLIST", alertScoringService.getAlertParameterList());
		commonService.auditLog(authentication.getPrincipal().toString(), request, "ALERTCONFIGURATION", "OPEN", "Module Accessed");
		return "AlertConfiguration/AlertScoring/SearchBottomPage";
	}
	
	@RequestMapping(value="/saveAlertParameterList", method=RequestMethod.POST)
	public String saveAlertParameterList(HttpServletRequest request, 
			HttpServletResponse response, Authentication authentication){
		String id = request.getParameter("id");
		String strAlertParameters = request.getParameter("strAlertParameters");
		alertScoringService.saveAlertParameterList(strAlertParameters);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "ALERTCONFIGURATION", "INSERT", "Data Saved");
		return "forward:getAlertScoringBottomFrame?id="+id;
	}
	
	@RequestMapping(value="/calculateAlertScore", method=RequestMethod.POST)
	public @ResponseBody String calculateAlertScore(HttpServletRequest request, 
			HttpServletResponse response, Authentication authentication){
		String userCode = authentication.getPrincipal().toString();
		String CURRENTROLE = request.getSession(false) != null ? (String) request.getSession(false).getAttribute("CURRENTROLE") : "";
		String ipAddress = request.getRemoteAddr();
		commonService.auditLog(authentication.getPrincipal().toString(), request, "ALERTCONFIGURATION", "INSERT", "Data Saved");
		return alertScoringService.calculateAlertScore(userCode, CURRENTROLE, ipAddress);
	}
	
	@RequestMapping(value="/searchAlertScoreAssignment", method=RequestMethod.POST)
	public String searchAlertScoreAssignment(HttpServletRequest request, 
			HttpServletResponse response, Authentication authentication){
		String id = request.getParameter("id");
		String searchParamId = request.getParameter("searchParamId");
		
		request.setAttribute("UNQID", id);
		request.setAttribute("searchParamId", searchParamId);
		request.setAttribute("RESULTLIST", alertScoringService.searchAlertScoreAssignment(searchParamId));
		commonService.auditLog(authentication.getPrincipal().toString(), request, "ALERTCONFIGURATION", "READ", "Module Accessed");
		return "AlertConfiguration/AlertScoring/AlertScoringBottomFrame";
	
	}
	
	@RequestMapping(value="/updateAlertScoreAssignmentValue", method=RequestMethod.POST)
	public @ResponseBody String updateAlertScoreAssignmentValue(HttpServletRequest request, 
			HttpServletResponse response, Authentication authentication){
		String id = request.getParameter("id");
		String paramId = request.getParameter("paramId");
		String fullData = request.getParameter("fullData");
		alertScoringService.updateAlertScoreAssignmentValue(fullData, paramId);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "ALERTCONFIGURATION", "UPDATE", "Data Updated");
		return "Successfully updated.";
	}
	
}





	
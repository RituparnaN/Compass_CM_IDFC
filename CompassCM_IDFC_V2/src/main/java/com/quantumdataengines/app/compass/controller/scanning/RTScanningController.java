package com.quantumdataengines.app.compass.controller.scanning;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
//import org.apache.log4j.Logger;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
//import org.springframework.web.bind.annotation.RequestParam;
//import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.quantumdataengines.app.compass.service.CommonService;
import com.quantumdataengines.app.compass.service.scanning.RTScanningService;
//import com.quantumdataengines.aml.service.ScanningService;

@Controller
public class RTScanningController {
//	private Logger log = Logger.getLogger(getClass());
	private RTScanningService RTScanningService;
	//private ScanningService ScanningService;
	private CommonService commonService;

	@Autowired
	public RTScanningController(RTScanningService RTScanningService, CommonService commonService) {
		this.RTScanningService = RTScanningService;
//		this.auditLogService = auditLogService;
		//this.ScanningService = ScanningService;
	}

	@RequestMapping(value = "/rtScanning")
	public ModelAndView getScanResult(@RequestParam(value = "type") String type, 
    		@RequestParam(value = "nameEnglish") String nameEnglish, @RequestParam(value = "idNumber") String idNumber,
    		@RequestParam(value = "nationality") String nationality, @RequestParam(value = "passportId") String passportId,
    		@RequestParam(value = "residence") String residence, @RequestParam(value = "birthPlace") String birthPlace,
    		@RequestParam(value = "params") String params, HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication)
		throws Exception
    {
    String userCode = authentication.getPrincipal().toString();
	ArrayList<HashMap<String,String>> l_ALmatchResult = RTScanningService.getScanningResults(userCode, type, nameEnglish, idNumber, nationality, passportId, residence, birthPlace, params);
	ModelAndView modelAndView = new ModelAndView("RTScanning/scanningResult");
	modelAndView.addObject("matchResult", l_ALmatchResult);
	commonService.auditLog(authentication.getPrincipal().toString(), request, "SCANNING", "SEARCH", "Module Accessed");
    return modelAndView;
    }
	
	@RequestMapping(value = "/rtEntityScanning")
	public ModelAndView getEntityScanning(@RequestParam(value = "entityName") String entityName, 
    		@RequestParam(value = "listName") String listName, @RequestParam(value = "matchScore") String matchScore,
    		@RequestParam(value = "userCode") String userCode, HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication)
		throws Exception
    {
	StringBuffer sbInputFieldsName = new StringBuffer();
	StringBuffer sbInputFieldsValues = new StringBuffer();
    StringBuffer sbInputFieldValuePair = new StringBuffer();
		
	HashMap hashMapSearchResultData = new HashMap();
	ArrayList alInputParametersName = new ArrayList(); 
	ArrayList alInputParametersValue = new ArrayList();

	sbInputFieldsName.append("CUSTOMERNAME");
	sbInputFieldsValues.append(entityName);
    sbInputFieldValuePair.append("CUSTOMERNAME").append(",");
    sbInputFieldValuePair.append(entityName);

	alInputParametersName.add("CUSTOMERNAME");
	alInputParametersValue.add(entityName);
	hashMapSearchResultData.put("CUSTOMERNAME",entityName);
	String userCode1 = authentication.getPrincipal().toString();
	hashMapSearchResultData.put("LoggedInUser",userCode1);
	LinkedHashMap l_hmReportData = (LinkedHashMap)RTScanningService.getScanReport(hashMapSearchResultData);
	String l_FileName = (String)l_hmReportData.get("FileName");
	request.setAttribute("FileName", l_FileName);
	request.setAttribute("userCode",userCode);
	request.setAttribute("entityName",entityName);
	request.setAttribute("listName",listName);
	request.setAttribute("matchScore",matchScore);
	ArrayList<HashMap<String,String>> alScanningResult = RTScanningService.getEntityScanning(l_FileName, entityName, listName, matchScore);
    ModelAndView modelAndView = new ModelAndView("RTScanning/scanningResult");
	modelAndView.addObject("matchResult", alScanningResult);
	modelAndView.addObject("FileName", l_FileName);
	modelAndView.addObject("userCode", userCode);
	modelAndView.addObject("entityName", entityName);
	modelAndView.addObject("listName", listName);
	modelAndView.addObject("matchScore", matchScore);
	commonService.auditLog(authentication.getPrincipal().toString(), request, "SCANNING", "SEARCH", "Module Accessed");
    return modelAndView;
    }
    
}

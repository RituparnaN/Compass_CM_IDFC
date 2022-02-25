package com.quantumdataengines.app.compass.controller;

import java.util.Collection;
import java.util.Collections;
import java.util.Comparator;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Vector;

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

import com.quantumdataengines.app.compass.otherservice.OtherCommonService;
import com.quantumdataengines.app.compass.service.CommonService;
import com.quantumdataengines.app.compass.service.offlineAlerts.OfflineAlertsService;

@Controller
@RequestMapping(value="/admin")
public class OfflineAlertsController {
	private Logger log = LoggerFactory.getLogger(OfflineAlertsController.class);
	
	@Autowired
	private OtherCommonService otherCommonService;
	@Autowired
	private OfflineAlertsService offlineAlertsService;
	@Autowired
	private CommonService commonService;
	
	
	@RequestMapping(value = "/getListOfAlerts")
	public ModelAndView getListOfAlerts(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication)throws Exception
    {
		ModelAndView modelAndView = new ModelAndView("/OfflineAlerts/index");
		String viewType = request.getParameter("viewType") == null ? "ALL":(String)request.getParameter("viewType");
		String userRole = request.getSession(false).getAttribute("CURRENTROLE") == null ? "N.A.":request.getSession(false).getAttribute("CURRENTROLE").toString();
		Collection collection = offlineAlertsService.getListOfAlerts(request.getParameter("group"), userRole, viewType);
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("RESULT", collection);
		request.setAttribute("group", request.getParameter("group"));
		request.setAttribute("viewType", viewType);
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "OFFLINE ALERTS", "OPEN", "Module Accessed");
		return modelAndView;
    }
	
	@RequestMapping(value = "/getAlertsList")
	public ModelAndView getAlertsList(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication)throws Exception
    {
		ModelAndView modelAndView = new ModelAndView("/OfflineAlerts/AlertsList");
		String viewType = request.getParameter("viewType") == null ? "ALL":(String)request.getParameter("viewType");
		String userRole = request.getSession(false).getAttribute("CURRENTROLE") == null ? "N.A.":request.getSession(false).getAttribute("CURRENTROLE").toString();
		Collection collection = offlineAlertsService.getListOfAlerts(request.getParameter("group"), userRole, viewType);
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("RESULT", collection);
		request.setAttribute("group", request.getParameter("group"));
		request.setAttribute("viewType", viewType);

		request.setAttribute("ALERTSUBGROUP", offlineAlertsService.getAlertSubGroup(request.getParameter("group")));
		request.setAttribute("alertGroupName", offlineAlertsService.getAlertGroupName(request.getParameter("group")));
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "OFFLINE ALERTS", "OPEN", "Module Accessed");
		return modelAndView;
    }

	@RequestMapping(value = "/getListOfAlertBenchMarks")
	public ModelAndView getListOfAlertBenchMarks(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication)throws Exception
    {
		ModelAndView modelAndView = new ModelAndView("/OfflineAlerts/AlertBenchMarksList");
		String userRole = request.getSession(false).getAttribute("CURRENTROLE") == null ? "N.A.":request.getSession(false).getAttribute("CURRENTROLE").toString();
		
		String alertId = request.getParameter("alertId");
		String viewType = request.getParameter("viewType") == null ? "ALL":(String)request.getParameter("viewType");
		Map<String, Object> benchMarkList = offlineAlertsService.getListOfAlertBenchMarks(alertId, userRole, viewType);
		String alertName = offlineAlertsService.getAlertName(alertId);
		
		request.setAttribute("resultData", benchMarkList);
		request.setAttribute("alertId", alertId);
		request.setAttribute("alertName", alertName);
		request.setAttribute("UNQID", request.getParameter("id"));
		request.setAttribute("viewType", viewType);
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "OFFLINE ALERTS", "READ", "Module Accessed");
	    return modelAndView;
    }

	@RequestMapping(value = "/getAlertDetails")
	public ModelAndView getAlertDetails(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication)throws Exception
    {
		ModelAndView modelAndView = new ModelAndView("/OfflineAlerts/AlertIdDetailsModal");
		String userRole = request.getSession(false).getAttribute("CURRENTROLE") == null ? "N.A.":request.getSession(false).getAttribute("CURRENTROLE").toString();

		String alertId = request.getParameter("alertId");
		String alertName = offlineAlertsService.getAlertName(alertId);
		
		request.setAttribute("ALERTDETAILS", offlineAlertsService.getAlertDetails(alertId, userRole));
		request.setAttribute("alertId", alertId);
		request.setAttribute("alertName", alertName);
		request.setAttribute("UNQID", request.getParameter("id"));
		request.setAttribute("userRole", userRole);
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "OFFLINE ALERTS", "READ", "Module Accessed");
	    return modelAndView;
    }
	
	@RequestMapping(value="/updateAlertDetailsandComments")
	public @ResponseBody String updateAlertDetailsandComments(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication)throws Exception
	{
		String alertId = request.getParameter("alertId");
		String alertName= request.getParameter("alertName");
		String alertSubGroup= request.getParameter("alertSubGroup");
		String alertSubGroupOrder = request.getParameter("alertSubGroupOrder");
		String alertFrequency = request.getParameter("alertFrequency");
		String seqNo = request.getParameter("seqNo");
		String isEnabled = request.getParameter("isEnabled");
		String lastAlertedTxnDate = request.getParameter("lastAlertedTxnDate");
		String sourceSystem = request.getParameter("sourceSystem");
		String makerCode = request.getParameter("makerCode");
		String makerComments = request.getParameter("makerComments");
		String checkerCode = request.getParameter("checkerCode");
		String checkerComments = request.getParameter("checkerComments");
		
		String status = request.getParameter("status");
		String userCode = authentication.getPrincipal().toString();
		String userRole = request.getSession(false).getAttribute("CURRENTROLE") == null ? "N.A.":request.getSession(false).getAttribute("CURRENTROLE").toString();
		String ipAddress = request.getRemoteAddr();

		String updateResult = offlineAlertsService.updateAlertDetailsandComments( alertId, alertName, alertSubGroup, alertSubGroupOrder, alertFrequency, seqNo, 
				 isEnabled, lastAlertedTxnDate, sourceSystem, makerCode, makerComments, checkerCode, checkerComments, status, userCode, userRole, ipAddress);
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "OFFLINE ALERTS", "UPDATE", "Alert Details and Comments Updated");	
		return updateResult;
	}
	
	@RequestMapping(value = "/getAlertBenchMarkDetails")
	public ModelAndView getAlertBenchMarkDetails(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication)throws Exception
    {
		ModelAndView modelAndView = new ModelAndView("/OfflineAlerts/AlertBenchMarkDetails");
		String userRole = request.getSession(false).getAttribute("CURRENTROLE") == null ? "N.A.":request.getSession(false).getAttribute("CURRENTROLE").toString();
		String alertId = request.getParameter("alertId");
		String alertSerialNo = request.getParameter("alertSerialNo");
		String alertApprovalStatus = request.getParameter("alertApprovalStatus");
		String parameterType = request.getParameter("parameterType");
		
		String viewType = request.getParameter("viewType") == null ? "ALL":(String)request.getParameter("viewType");
		List<Map<String, Object>> searchFrameList = offlineAlertsService.getAlertBenchMarkDetails(alertId, alertSerialNo, alertApprovalStatus, userRole, viewType);
		String alertName = offlineAlertsService.getAlertName(alertId);
		Map<String, Object> alertBenchMarkStatusDetails = offlineAlertsService.getAlertBenchMarkStatusDetails(alertId, alertSerialNo, alertApprovalStatus, userRole, viewType);
		
		request.setAttribute("MASTERSEARCHFRAME", searchFrameList);
		request.setAttribute("BENCHMARKSTATUS", alertBenchMarkStatusDetails);
	    request.setAttribute("alertId", alertId);
	    request.setAttribute("alertName", alertName);
		request.setAttribute("alertSerialNo", alertSerialNo);
		request.setAttribute("alertApprovalStatus", alertApprovalStatus);
		request.setAttribute("parameterType", parameterType);
	    request.setAttribute("UNQID", request.getParameter("id"));
		request.setAttribute("viewType", viewType);
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "OFFLINE ALERTS", "READ", "Module Accessed");
	    return modelAndView;
    }
	
	@RequestMapping(value = "/saveAlertBenchMarkParameters", method=RequestMethod.POST)
	public ModelAndView saveAlertBenchMarkParameters(HttpServletRequest request, HttpServletResponse response, Authentication authentication)throws Exception    {
		Map<String, String> paramMap = new LinkedHashMap<String, String>();
		Map<String, String> paramTempMap = new LinkedHashMap<String, String>();
		String moduleType = request.getParameter("moduleType");
		
		String alertId = request.getParameter("alertId");
	    String alertSerialNo = request.getParameter("alertSerialNo");
	    String viewType = request.getParameter("viewType") == null ? "ALL":(String)request.getParameter("viewType");
	    String userLogcomments = request.getParameter("userLogcomments") == null ? "N.A":(String)request.getParameter("userLogcomments");
	    
		Map<String, String[]> formData =  request.getParameterMap();
		Iterator<String> itr = formData.keySet().iterator();
		while (itr.hasNext()) {
			String tempParamName = itr.next();
			String tempParamValue = formData.get(tempParamName)[0];
			if(!"moduleType".equals(tempParamName) && !"bottomPageUrl".equals(tempParamName)
			   && !"alertId".equals(tempParamName) && !"alertSerialNo".equals(tempParamName)
			   && !"viewType".equals(tempParamName) && !"id".equals(tempParamName)
			   && !"formData".equals(tempParamName) && !"submitButton".equals(tempParamName)
			   && !"userLogcomments".equals(tempParamName)){
				paramTempMap.put(tempParamName, tempParamValue);
			}
		}
		
		List<String> paramKeyList = new Vector<String>(paramTempMap.keySet());
		
		Collections.sort(paramKeyList, new Comparator<String>(){
			@Override
			public int compare(String str1, String str2) {
				return  (Integer.parseInt(str1.substring(0, str1.indexOf("_")))) - Integer.parseInt(str2.substring(0, str2.indexOf("_")));
			}
		});
		
		for(String paramName : paramKeyList) {
			String paramValue = formData.get(paramName)[0];
			paramMap.put(paramName, paramValue);
		}
		
		ModelAndView modelAndView = new ModelAndView("/OfflineAlerts/AlertBenchMarksList");
		
		String userCode = authentication.getPrincipal().toString();
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String ipAddress = request.getRemoteAddr();
		
		
		offlineAlertsService.saveAlertBenchMarkParameters(alertId, alertSerialNo, paramMap, userCode, userRole, ipAddress, userLogcomments);
	    
	    //Map<String, Object> benchMarkList = offlineAlertsService.getListOfAlertBenchMarks(request.getParameter("alertId"), userRole, viewType);
	    
		request.setAttribute("moduleType", moduleType);
		//request.setAttribute("resultData", benchMarkList);
		request.setAttribute("alertSerialNo", alertSerialNo);
		request.setAttribute("alertId", request.getParameter("alertId"));
		request.setAttribute("UNQID", request.getParameter("id"));
		request.setAttribute("viewType", viewType);
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "OFFLINE ALERTS", "INSERT", "Alert Benchmark Parameters Inserted for Configuration.");
	    return modelAndView;
    }

	@RequestMapping(value = "/deleteAlertBenchMarkParameters")
	public ModelAndView deleteAlertBenchMarkParameters(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication)throws Exception
    {
		ModelAndView modelAndView = new ModelAndView("/OfflineAlerts/AlertBenchMarksList");
	
		String userCode = authentication.getPrincipal().toString();
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String ipAdress = request.getRemoteAddr();
		
		String alertSerialNo = request.getParameter("alertSerialNo");
		String alertId = request.getParameter("alertId");
		String viewType = request.getParameter("viewType") == null ? "ALL":(String)request.getParameter("viewType");
	    String userLogcomments = request.getParameter("userLogcomments") == null ? "N.A":(String)request.getParameter("userLogcomments");
		String requestType = "DELETE";
	
		offlineAlertsService.deleteAlertBenchMarkParameters(alertId, alertSerialNo, requestType, userCode, userRole, ipAdress, userLogcomments);
	    
	    //Map<String, Object> benchMarkList = offlineAlertsService.getListOfAlertBenchMarks(request.getParameter("alertId"), userRole, viewType);
	
		//request.setAttribute("resultData", benchMarkList);
		request.setAttribute("alertSerialNo", alertSerialNo);
		request.setAttribute("alertId", request.getParameter("alertId"));
		request.setAttribute("UNQID", request.getParameter("id"));
		request.setAttribute("viewType", viewType);
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "OFFLINE ALERTS", "DELETE", "Alert Benchmark Parameters For Configuration Deleted");
		return modelAndView;
    }
	
	@RequestMapping(value = "/generateAlertWithBenchMarks")
	public ModelAndView generateAlertWithBenchMarks(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		ModelAndView modelAndView = new ModelAndView("/OfflineAlerts/AlertResult");
		Map<String, String> paramMap = new LinkedHashMap<String, String>();
		Map<String, String> paramTempMap = new LinkedHashMap<String, String>();
		String resultMessage = "No. Of Alerts Generated : ";
		String userCode = authentication.getPrincipal().toString();
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String ipAdress = request.getRemoteAddr();

		String alertId = request.getParameter("alertId");
		String alertSerialNo = request.getParameter("alertSerialNo");
		String viewType = request.getParameter("viewType") == null ? "ALL":(String)request.getParameter("viewType");
		String generationType = request.getParameter("generationType") == null ? "ALERTDATA":(String)request.getParameter("generationType");
	    String userLogcomments = request.getParameter("userLogcomments") == null ? "N.A":(String)request.getParameter("userLogcomments");
		
		Map<String, String[]> formData =  request.getParameterMap();
		Iterator<String> itr = formData.keySet().iterator();
		while (itr.hasNext()) {
			String tempParamName = itr.next();
			String tempParamValue = formData.get(tempParamName)[0];
			if(!"moduleType".equals(tempParamName) && !"bottomPageUrl".equals(tempParamName)
			   && !"alertId".equals(tempParamName) && !"alertSerialNo".equals(tempParamName)
			   && !"viewType".equals(tempParamName) && !"id".equals(tempParamName)
			   && !"formData".equals(tempParamName) && !"generationType".equals(tempParamName)
			   && !"submitButton".equals(tempParamName) && !"userLogcomments".equals(tempParamName)){
				paramTempMap.put(tempParamName, tempParamValue);
			}
		}
		
		List<String> paramKeyList = new Vector<String>(paramTempMap.keySet());
		
		Collections.sort(paramKeyList, new Comparator<String>(){
			@Override
			public int compare(String str1, String str2) {
				return  (Integer.parseInt(str1.substring(0, str1.indexOf("_")))) - Integer.parseInt(str2.substring(0, str2.indexOf("_")));
			}
		});
		
		for(String paramName : paramKeyList) {
			String paramValue = formData.get(paramName)[0];
			paramMap.put(paramName, paramValue);
		}
		
		int resultCount = 0;
	    try{
	    	resultMessage = offlineAlertsService.generateAlertWithBenchMarks(alertId, alertSerialNo, paramMap, generationType, userCode, userRole, ipAdress);
	    }
	    catch(Exception e){
	    	resultMessage = "Error while generating alerts for: "+alertId;
	    	log.error("Error while generating alerts for: "+alertId+". The error is : "+e.toString());
	    	System.out.println("Error while generating alerts for: "+alertId+". The error is : "+e.toString());
	    	e.printStackTrace();
	    }
	    
	    // resultMessage = resultMessage + resultCount;
	    
	    request.setAttribute("Result", resultCount);
	    request.setAttribute("resultMessage", resultMessage);
	    request.setAttribute("alertId", request.getParameter("alertId"));
		request.setAttribute("alertSerialNo", alertSerialNo);
		request.setAttribute("UNQID", request.getParameter("id"));
		request.setAttribute("viewType", viewType);
		request.setAttribute("generationType", generationType);
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "OFFLINE ALERTS", "INSERT", "Alerts Generated With Benchmark");
		return modelAndView;
    }
	
	@RequestMapping(value = "/simulateAlertWithBenchMarks")
	public ModelAndView simulateAlertWithBenchMarks(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		ModelAndView modelAndView = new ModelAndView("/OfflineAlerts/AlertResult");
		Map<String, String> paramMap = new LinkedHashMap<String, String>();
		Map<String, String> paramTempMap = new LinkedHashMap<String, String>();
		String resultMessage = "No. Of Alerts Generated : ";
		String userCode = authentication.getPrincipal().toString();
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String ipAdress = request.getRemoteAddr();

		String alertId = request.getParameter("alertId");
		String alertSerialNo = request.getParameter("alertSerialNo");
		String viewType = request.getParameter("viewType") == null ? "ALL":(String)request.getParameter("viewType");
		String generationType = request.getParameter("generationType") == null ? "ALERTDATA":(String)request.getParameter("generationType");
	    String userLogcomments = request.getParameter("userLogcomments") == null ? "N.A":(String)request.getParameter("userLogcomments");
		
		Map<String, String[]> formData =  request.getParameterMap();
		Iterator<String> itr = formData.keySet().iterator();
		while (itr.hasNext()) {
			String tempParamName = itr.next();
			String tempParamValue = formData.get(tempParamName)[0];
			if(!"moduleType".equals(tempParamName) && !"bottomPageUrl".equals(tempParamName)
			   && !"alertId".equals(tempParamName) && !"alertSerialNo".equals(tempParamName)
			   && !"viewType".equals(tempParamName) && !"id".equals(tempParamName)
			   && !"formData".equals(tempParamName) && !"generationType".equals(tempParamName)
			   && !"submitButton".equals(tempParamName) && !"userLogcomments".equals(tempParamName)){
				paramTempMap.put(tempParamName, tempParamValue);
			}
		}
		
		List<String> paramKeyList = new Vector<String>(paramTempMap.keySet());
		
		Collections.sort(paramKeyList, new Comparator<String>(){
			@Override
			public int compare(String str1, String str2) {
				return  (Integer.parseInt(str1.substring(0, str1.indexOf("_")))) - Integer.parseInt(str2.substring(0, str2.indexOf("_")));
			}
		});
		
		for(String paramName : paramKeyList) {
			String paramValue = formData.get(paramName)[0];
			paramMap.put(paramName, paramValue);
		}
		
		int resultCount = 0;
	    try{
	    	resultMessage = offlineAlertsService.simulateAlertWithBenchMarks(alertId, alertSerialNo, paramMap, generationType, userCode, userRole, ipAdress);
	    }
	    catch(Exception e){
	    	resultMessage = "Error while generating alerts for: "+alertId;
	    	log.error("Error while generating alerts for: "+alertId+". The error is : "+e.toString());
	    	System.out.println("Error while generating alerts for: "+alertId+". The error is : "+e.toString());
	    	e.printStackTrace();
	    }
	    
	    // resultMessage = resultMessage + resultCount;
	    
	    request.setAttribute("Result", resultCount);
	    request.setAttribute("resultMessage", resultMessage);
	    request.setAttribute("alertId", request.getParameter("alertId"));
		request.setAttribute("alertSerialNo", alertSerialNo);
		request.setAttribute("UNQID", request.getParameter("id"));
		request.setAttribute("viewType", viewType);
		request.setAttribute("generationType", generationType);
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "OFFLINE ALERTS", "INSERT", "Alerts Generated With Benchmark");
		return modelAndView;
    }
	
	@RequestMapping(value = "/approveAlertBenchMarkParameters", method=RequestMethod.POST)
	public ModelAndView approveAlertBenchMarkParameters(HttpServletRequest request, HttpServletResponse response, Authentication authentication)throws Exception    {
		Map<String, String> paramMap = new LinkedHashMap<String, String>();
		Map<String, String> paramTempMap = new LinkedHashMap<String, String>();
		String moduleType = request.getParameter("moduleType");
		
		String alertId = request.getParameter("alertId");
	    String alertSerialNo = request.getParameter("alertSerialNo");
	    String viewType = request.getParameter("viewType") == null ? "ALL":(String)request.getParameter("viewType");
	    String userLogcomments = request.getParameter("userLogcomments") == null ? "N.A":(String)request.getParameter("userLogcomments");
	    
	    String requestType = request.getParameter("requestType") == null ? "N.A.":(String)request.getParameter("requestType");
	    String benchMarkStatus = request.getParameter("benchMarkStatus") == null ? "N.A.":(String)request.getParameter("benchMarkStatus");
	    
		Map<String, String[]> formData =  request.getParameterMap();
		Iterator<String> itr = formData.keySet().iterator();
		while (itr.hasNext()) {
			String tempParamName = itr.next();
			String tempParamValue = formData.get(tempParamName)[0];
			if(!"moduleType".equals(tempParamName) && !"bottomPageUrl".equals(tempParamName)
			   && !"alertId".equals(tempParamName) && !"alertSerialNo".equals(tempParamName)
			   && !"viewType".equals(tempParamName) && !"id".equals(tempParamName)
			   && !"formData".equals(tempParamName) && !"submitButton".equals(tempParamName)
			   && !"REQUESTTYPE".equals(tempParamName) && !"requestType".equals(tempParamName) 
			   && !"benchMarkStatus".equals(tempParamName) && !"userLogcomments".equals(tempParamName)){
				paramTempMap.put(tempParamName, tempParamValue);
			}
		}
		
		List<String> paramKeyList = new Vector<String>(paramTempMap.keySet());
		
		Collections.sort(paramKeyList, new Comparator<String>(){
			@Override
			public int compare(String str1, String str2) {
				return  (Integer.parseInt(str1.substring(0, str1.indexOf("_")))) - Integer.parseInt(str2.substring(0, str2.indexOf("_")));
			}
		});
		
		for(String paramName : paramKeyList) {
			String paramValue = formData.get(paramName)[0];
			paramMap.put(paramName, paramValue);
		}
		
		ModelAndView modelAndView = new ModelAndView("/OfflineAlerts/AlertBenchMarksList");
		
		String userCode = authentication.getPrincipal().toString();
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String ipAdress = request.getRemoteAddr();
		
		
		offlineAlertsService.approveAlertBenchMarkParameters(alertId, alertSerialNo, paramMap, requestType, benchMarkStatus, userCode, userRole, ipAdress, userLogcomments);
	    
	    //Map<String, Object> benchMarkList = offlineAlertsService.getListOfAlertBenchMarks(request.getParameter("alertId"), userRole, viewType);
	    
		request.setAttribute("moduleType", moduleType);
		//request.setAttribute("resultData", benchMarkList);
		request.setAttribute("alertSerialNo", alertSerialNo);
		request.setAttribute("alertId", request.getParameter("alertId"));
		request.setAttribute("UNQID", request.getParameter("id"));
		request.setAttribute("viewType", viewType);
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "OFFLINE ALERTS", "INSERT", "Alert Benchmark Parameters Inserted");
	    return modelAndView;
    }
	
	@RequestMapping(value = "/rejectAlertBenchMarkParameters", method=RequestMethod.POST)
	public ModelAndView rejectAlertBenchMarkParameters(HttpServletRequest request, HttpServletResponse response, Authentication authentication)throws Exception    {
		Map<String, String> paramMap = new LinkedHashMap<String, String>();
		Map<String, String> paramTempMap = new LinkedHashMap<String, String>();
		String moduleType = request.getParameter("moduleType");
		
		String alertId = request.getParameter("alertId");
	    String alertSerialNo = request.getParameter("alertSerialNo");
	    String viewType = request.getParameter("viewType") == null ? "ALL":(String)request.getParameter("viewType");
	    String userLogcomments = request.getParameter("userLogcomments") == null ? "N.A":(String)request.getParameter("userLogcomments");
	    
	    String requestType = request.getParameter("requestType") == null ? "N.A.":(String)request.getParameter("requestType");
	    String benchMarkStatus = request.getParameter("benchMarkStatus") == null ? "N.A.":(String)request.getParameter("benchMarkStatus");

	    Map<String, String[]> formData =  request.getParameterMap();
		Iterator<String> itr = formData.keySet().iterator();
		while (itr.hasNext()) {
			String tempParamName = itr.next();
			String tempParamValue = formData.get(tempParamName)[0];
			if(!"moduleType".equals(tempParamName) && !"bottomPageUrl".equals(tempParamName)
			   && !"alertId".equals(tempParamName) && !"alertSerialNo".equals(tempParamName)
			   && !"viewType".equals(tempParamName) && !"id".equals(tempParamName)
			   && !"formData".equals(tempParamName) && !"submitButton".equals(tempParamName)
			   && !"REQUESTTYPE".equals(tempParamName) && !"requestType".equals(tempParamName) 
			   && !"benchMarkStatus".equals(tempParamName) && !"userLogcomments".equals(tempParamName)){
				paramTempMap.put(tempParamName, tempParamValue);
			}
		}
		
		List<String> paramKeyList = new Vector<String>(paramTempMap.keySet());
		
		Collections.sort(paramKeyList, new Comparator<String>(){
			@Override
			public int compare(String str1, String str2) {
				return  (Integer.parseInt(str1.substring(0, str1.indexOf("_")))) - Integer.parseInt(str2.substring(0, str2.indexOf("_")));
			}
		});
		
		for(String paramName : paramKeyList) {
			String paramValue = formData.get(paramName)[0];
			paramMap.put(paramName, paramValue);
		}
		
		ModelAndView modelAndView = new ModelAndView("/OfflineAlerts/AlertBenchMarksList");
		
		String userCode = authentication.getPrincipal().toString();
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String ipAdress = request.getRemoteAddr();
		
		offlineAlertsService.rejectAlertBenchMarkParameters(alertId, alertSerialNo, paramMap, requestType, benchMarkStatus, userCode, userRole, ipAdress, userLogcomments);
	    
	    //Map<String, Object> benchMarkList = offlineAlertsService.getListOfAlertBenchMarks(request.getParameter("alertId"), userRole, viewType);
	    
		request.setAttribute("moduleType", moduleType);
		//request.setAttribute("resultData", benchMarkList);
		request.setAttribute("alertSerialNo", alertSerialNo);
		request.setAttribute("alertId", request.getParameter("alertId"));
		request.setAttribute("UNQID", request.getParameter("id"));
		request.setAttribute("viewType", viewType);
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "OFFLINE ALERTS", "INSERT", "Alert Benchmark Parameters Inserted");
	    return modelAndView;
    }
	
	@RequestMapping(value = "/getAlertBenchMarkStatusDetails")
	public ModelAndView getAlertBenchMarkStatusDetails(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication)throws Exception
    {
		ModelAndView modelAndView = new ModelAndView("/OfflineAlerts/AlertApprovalStatusDetails");
		String userRole = request.getSession(false).getAttribute("CURRENTROLE") == null ? "N.A.":request.getSession(false).getAttribute("CURRENTROLE").toString();
		String alertId = request.getParameter("alertId");
		String alertSerialNo = request.getParameter("alertSerialNo");
		String alertApprovalStatus = request.getParameter("alertApprovalStatus");

		String viewType = request.getParameter("viewType") == null ? "ALL":(String)request.getParameter("viewType");
		String alertName = offlineAlertsService.getAlertName(alertId);
		
		request.setAttribute("ALERTSTATUSDETAILS", offlineAlertsService.getAlertBenchMarkStatusDetails(alertId, alertSerialNo, alertApprovalStatus, userRole, viewType));
	    request.setAttribute("alertId", alertId);
	    request.setAttribute("alertName", alertName);
		request.setAttribute("alertSerialNo", request.getParameter("alertSerialNo"));
		request.setAttribute("alertApprovalStatus", request.getParameter("alertApprovalStatus"));
	    request.setAttribute("UNQID", request.getParameter("id"));
		request.setAttribute("viewType", viewType);
		//System.out.println(offlineAlertsService.getAlertBenchMarkStatusDetails(alertId, alertSerialNo, userRole, viewType));
		commonService.auditLog(authentication.getPrincipal().toString(), request, "OFFLINE ALERTS", "READ", "Module Accessed");
	    return modelAndView;
    }
	
	@RequestMapping(value="/saveAlertBenchMarkParamsForSimulation")
	public ModelAndView saveAlertBenchMarkParamsForSimulation(HttpServletRequest request, HttpServletResponse response, Authentication authentication)throws Exception    {
		Map<String, String> paramMap = new LinkedHashMap<String, String>();
		Map<String, String> paramTempMap = new LinkedHashMap<String, String>();
		String moduleType = request.getParameter("moduleType");
		
		String alertId = request.getParameter("alertId");
	    String alertSerialNo = request.getParameter("alertSerialNo");
	    String viewType = request.getParameter("viewType") == null ? "ALL":(String)request.getParameter("viewType");
	    
		Map<String, String[]> formData =  request.getParameterMap();
		Iterator<String> itr = formData.keySet().iterator();
		while (itr.hasNext()) {
			String tempParamName = itr.next();
			String tempParamValue = formData.get(tempParamName)[0];
			if(!"moduleType".equals(tempParamName) && !"bottomPageUrl".equals(tempParamName)
			   && !"alertId".equals(tempParamName) && !"alertSerialNo".equals(tempParamName)
			   && !"viewType".equals(tempParamName) && !"id".equals(tempParamName)
			   && !"formData".equals(tempParamName) && !"submitButton".equals(tempParamName)){
				paramTempMap.put(tempParamName, tempParamValue);
			}
		}
		
		List<String> paramKeyList = new Vector<String>(paramTempMap.keySet());
		
		Collections.sort(paramKeyList, new Comparator<String>(){
			@Override
			public int compare(String str1, String str2) {
				return  (Integer.parseInt(str1.substring(0, str1.indexOf("_")))) - Integer.parseInt(str2.substring(0, str2.indexOf("_")));
			}
		});
		
		for(String paramName : paramKeyList) {
			String paramValue = formData.get(paramName)[0];
			paramMap.put(paramName, paramValue);
		}
		
		ModelAndView modelAndView = new ModelAndView("/OfflineAlerts/AlertBenchMarksList");
		
		String userCode = authentication.getPrincipal().toString();
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String ipAddress = request.getRemoteAddr();
		
		System.out.println("&alertId="+alertId+"&viewType="+viewType+"&alertSerialNo="+alertSerialNo+"&paramMap = "+paramMap);
		offlineAlertsService.saveAlertBenchMarkParamsForSimulation(alertId, alertSerialNo, paramMap, userCode, userRole, ipAddress);
	    	    
		request.setAttribute("moduleType", moduleType);
		//request.setAttribute("resultData", benchMarkList);
		request.setAttribute("alertSerialNo", alertSerialNo);
		request.setAttribute("alertId", request.getParameter("alertId"));
		request.setAttribute("UNQID", request.getParameter("id"));
		request.setAttribute("viewType", viewType);
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "OFFLINE ALERTS", "INSERT", "Alert Benchmark Parameters Inserted for Simulation.");
	    return modelAndView;
	}
	
	@RequestMapping(value = "/deleteAlertBenchMarkParamsForSimulation")
	public ModelAndView deleteAlertBenchMarkParamsForSimulation(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication)throws Exception
    {
		ModelAndView modelAndView = new ModelAndView("/OfflineAlerts/AlertBenchMarksList");
	
		String userCode = authentication.getPrincipal().toString();
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String ipAdress = request.getRemoteAddr();
		
		String alertSerialNo = request.getParameter("alertSerialNo");
		String alertId = request.getParameter("alertId");
		String viewType = request.getParameter("viewType") == null ? "ALL":(String)request.getParameter("viewType");
	    String userLogcomments = request.getParameter("userLogcomments") == null ? "N.A":(String)request.getParameter("userLogcomments");
		String requestType = "DELETE";
	    System.out.println("delete");
		offlineAlertsService.deleteAlertBenchMarkParamsForSimulation(alertId, alertSerialNo, requestType, userCode, userRole, ipAdress, userLogcomments);
	    
		request.setAttribute("alertSerialNo", alertSerialNo);
		request.setAttribute("alertId", request.getParameter("alertId"));
		request.setAttribute("UNQID", request.getParameter("id"));
		request.setAttribute("viewType", viewType);
		System.out.println("return");
		commonService.auditLog(authentication.getPrincipal().toString(), request, "OFFLINE ALERTS", "DELETE", "Alert Benchmark Parameters For Simulation Deleted");
		return modelAndView;
    }
}

package com.quantumdataengines.app.compass.controller;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
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

import com.quantumdataengines.app.compass.model.DomainUser;
import com.quantumdataengines.app.compass.model.Extraction;
import com.quantumdataengines.app.compass.otherservice.OtherCommonService;
import com.quantumdataengines.app.compass.service.CommonService;
import com.quantumdataengines.app.compass.service.etl.emailsettings.ETLEmailSettingService;
import com.quantumdataengines.app.compass.service.etl.extraction.ExtractionService;

@Controller
@RequestMapping(value="/etl")
public class ETLController {
	private static final Logger log = LoggerFactory.getLogger(AdminController.class);
	
	@Autowired
	private ExtractionService extractionServcie;
	@Autowired
	private ETLEmailSettingService etlEmailService;
	@Autowired
	private OtherCommonService otherCommonService;
	@Autowired
	private CommonService commonService;
	
	@RequestMapping(value={"/","/index"}, method=RequestMethod.GET)
	public String getUserIndex(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		DomainUser domainUser = (DomainUser) authentication.getDetails();
		log.info("Opening ETL index for : "+domainUser.getFirstName()+" "+domainUser.getLastName());
		commonService.auditLog(authentication.getPrincipal().toString(), request, "ETL", "OPEN", "Module Accessed");
		return "etlIndexTemplete";
	}
	
	
	@RequestMapping(value="/extraction", method=RequestMethod.GET)
	public String getExtractionPage(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		Extraction extraction = extractionServcie.getExtractionDetails();
		int status = extraction != null ? extraction.getStatus() : 0;
		request.setAttribute("FROMDATE", extractionServcie.getFromDateFromDB());
		request.setAttribute("TODATE", extractionServcie.getFromDateFromDB());
		request.setAttribute("EXTRACTION", status);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "ETL", "OPEN", "Module Accessed");
		return "extraction/index";
	}
	
	@RequestMapping(value="/checkExtractionDates", method=RequestMethod.POST)
	public @ResponseBody Map<String, String> checkExtractionDates(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		Map<String, String> checkDateMap = new HashMap<String, String>();
		String fromDate = request.getParameter("fromDate");
		String toDate = request.getParameter("toDate");
		String extractionFromDate = extractionServcie.getFromDateFromDB();
		try{
			Date l_strFromDate = otherCommonService.getFormattedStringDate(fromDate,"dd/MM/yyyy");
			Date l_strToDate = otherCommonService.getFormattedStringDate(toDate, "dd/MM/yyyy");
			Calendar cal = Calendar.getInstance();
			cal.add(Calendar.DATE, -1);
			Date l_extractionFromDate = otherCommonService.getFormattedStringDate(extractionFromDate, "dd/MM/yyyy");
			Date l_extractionToDate = otherCommonService.getFormattedStringDate(extractionFromDate, "dd/MM/yyyy");
			boolean isValid = true;
			checkDateMap.put("STATUS", "1");
			WHILE : if(isValid){
				if(!l_strFromDate.equals(l_strToDate)){
					isValid = false;
					checkDateMap.put("STATUS", "0");
					checkDateMap.put("MESSAGE", "FromDate and ToDate should be equal");
					break WHILE;
				}
				if(!l_strFromDate.equals(l_extractionFromDate)){
					checkDateMap.put("STATUS", "0");
					checkDateMap.put("MESSAGE", "FromDate ashould be equal : "+extractionFromDate);
					isValid = false;
					break WHILE;
				}
				if(!l_strToDate.equals(l_extractionToDate)){
					checkDateMap.put("STATUS", "0");
					checkDateMap.put("MESSAGE", "ToDate ashould be equal : "+extractionFromDate);
					isValid = false;
					break WHILE;
				}
				if(l_strToDate.after(cal.getTime())){
					checkDateMap.put("STATUS", "0");
					checkDateMap.put("MESSAGE", "ToDate should not be after "+otherCommonService.getFormattedDate(cal.getTime(), "dd/MM/yyyy"));
					isValid = false;
					break WHILE;
				}
			}
		}catch(Exception e){
			checkDateMap.put("STATUS", "0");
			checkDateMap.put("MESSAGE", e.getMessage());
		}
		commonService.auditLog(authentication.getPrincipal().toString(), request, "ETL", "SEARCH", "Module Accessed");
		return checkDateMap;
	}
	
	@RequestMapping(value="/startExtraction", method=RequestMethod.POST)
	public @ResponseBody String startExtraction(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		String fromDate = request.getParameter("fromDate");
		String toDate = request.getParameter("toDate");
		String userName = authentication.getPrincipal().toString();
		log.info("Delegating extraction job to handler...");
		
		if(extractionServcie.extractionStatus()){
			commonService.auditLog(authentication.getPrincipal().toString(), request, "ETL", "OPEN", "Extraction Started For From Date"+fromDate+"To Date: "+toDate);
			extractionServcie.ExtractionThreadStartPoint(fromDate, toDate, userName).start();
			return "";
		}else
			return "Extraction is already started";
	}
	
	@RequestMapping(value="/cancelExtraction", method=RequestMethod.POST)
	public @ResponseBody String cancelExtraction(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		commonService.auditLog(authentication.getPrincipal().toString(), request, "ETL", "DELETE", "Extraction Cancelled");
		return extractionServcie.cancelExtraction();
	}
	
	@RequestMapping(value="/getExtractionStatus", method=RequestMethod.POST)
	public @ResponseBody Extraction getExtractionStatus(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		
		return extractionServcie.getExtractionObject();
	}
	
	@RequestMapping(value="/getExtractionProcessMessage", method=RequestMethod.POST)
	public @ResponseBody Map<String, Object> getExtractionProcessMessage(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		List<HashMap<String, Object>> dataList = extractionServcie.getExtractionProcessMessage();
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("draw", "1");
		map.put("recordsTotal", dataList.size());
		map.put("recordsFiltered", dataList.size());
		map.put("data", dataList);
		
		return map;
	}
	
	@RequestMapping(value="/indexing", method=RequestMethod.GET)
	public String indexing(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		commonService.auditLog(authentication.getPrincipal().toString(), request, "ETL", "OPEN", "Module Accessed");
		return "indexing/index";
	}
	
	@RequestMapping(value="/etlEmailSettings", method=RequestMethod.GET)
	public String etlEmailSettings(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		request.setAttribute("EMAILSETTINGS", etlEmailService.getEmailSettings());
		commonService.auditLog(authentication.getPrincipal().toString(), request, "ETL", "OPEN", "Module Accessed");
		return "etlEmailSettings/index";
	}
	
	@RequestMapping(value="/saveETLEmailSettings", method=RequestMethod.POST)
	public @ResponseBody String saveETLEmailSettings(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		Map<String, String> emailSettings = new HashMap<String, String>(); 
		@SuppressWarnings("unchecked")
		List<String> allParametersName = new ArrayList<String>(request.getParameterMap().keySet());
		for(String parameterName : allParametersName){
			String paramValue = request.getParameter(parameterName);
			if(parameterName.equals("ETLEMAILPASSWORD")){
				paramValue = paramValue.replace(" ", "+");
			}	
			emailSettings.put(parameterName, paramValue);
		}
		commonService.auditLog(authentication.getPrincipal().toString(), request, "ETL", "INSERT", "ETL Email Settings Saved");
		return etlEmailService.saveEmailSettings(emailSettings);
	}
	
	@RequestMapping(value="/sendETLTestEmail", method=RequestMethod.POST)
	public @ResponseBody String sendETLTestEmail(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		String password = request.getParameter("password");
		return etlEmailService.sendETLTestEmail(password);
	}
}

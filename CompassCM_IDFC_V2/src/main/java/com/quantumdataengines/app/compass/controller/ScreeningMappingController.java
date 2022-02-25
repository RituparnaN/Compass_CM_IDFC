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
import com.quantumdataengines.app.compass.service.screeningMapping.ScreeningMappingService;

@Controller
@RequestMapping(value="/admin")
public class ScreeningMappingController {
private static final Logger log = LoggerFactory.getLogger(CommonController.class);
	
	@Autowired
	private CommonService commonService;
	@Autowired
	private OtherCommonService otherCommonService;
	@Autowired
	private ScreeningMappingService screeningMappingService;
	
	@RequestMapping(value="/screeningMapping", method=RequestMethod.GET)
	public String screeningMapping(HttpServletRequest request, 
			HttpServletResponse response, Authentication authentication){
		
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("DATALIST", screeningMappingService.getListData());
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "SCREENING MAPPING", "OPEN", "Module Accessed");
		return "ScreeningMapping/index";
	}
	
	@RequestMapping(value="/middleFrame", method=RequestMethod.POST)
	public String middleFrame(HttpServletRequest request, 
			HttpServletResponse response, Authentication authentication){
		String sourceList = request.getParameter("sourceList");
		String destinationList = request.getParameter("destinationList");
		
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("MIDDLEDATALIST", screeningMappingService.middleFrame(sourceList, destinationList));
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "SCREENING MAPPING", "OPEN", "Module Accessed");
		return "ScreeningMapping/MiddleFrame";
	}
	
	@RequestMapping(value="/updateScreeningMapping", method=RequestMethod.POST)
	public @ResponseBody String updateScreeningMapping(HttpServletRequest request, 
			HttpServletResponse response, Authentication authentication){
		String chkbox = request.getParameter("chkbox");
		String sourceList = request.getParameter("sourceList");
		String destinationList = request.getParameter("destinationList");
		String mappingLevel = request.getParameter("mappingLevel");
		String userCode = authentication.getPrincipal().toString();
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "SCREENING MAPPING", "UPDATE", "Screening Mapping Updated");
		return screeningMappingService.updateScreeningMapping(chkbox, sourceList, destinationList, mappingLevel, userCode);
	}
	
	@RequestMapping(value="/deleteScreeningMapping", method=RequestMethod.POST)
	public @ResponseBody String deleteScreeningMapping(HttpServletRequest request, 
			HttpServletResponse response, Authentication authentication){
		String sourceList = request.getParameter("sourceList");
		String destinationList = request.getParameter("destinationList");
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "SCREENING MAPPING", "DELETE", "Screening Mapping Deleted");
		return screeningMappingService.deleteScreeningMapping(sourceList, destinationList);
	}
	
	@RequestMapping(value="/bottomFrame", method=RequestMethod.POST)
	public String bottomFrame(HttpServletRequest request, 
			HttpServletResponse response, Authentication authentication){
		String sourceList = request.getParameter("sourceList");
		String destinationList = request.getParameter("destinationList");
		
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("BOTTOMDATALIST", screeningMappingService.bottomFrame(sourceList, destinationList));
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "SCREENING MAPPING", "OPEN", "Module Accessed");
		return "ScreeningMapping/BottomFrame";
	}
	
	@RequestMapping(value="/updateFieldScreeningMapping", method=RequestMethod.POST)
	public @ResponseBody String updateFieldScreeningMapping(HttpServletRequest request, 
			HttpServletResponse response, Authentication authentication){
		String fullData = request.getParameter("fullData");
		String userCode = authentication.getPrincipal().toString();
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "SCREENING MAPPING", "UPDATE", "Field Screening Mapping Updated");
		return screeningMappingService.updateFieldScreeningMapping(fullData, userCode);
	}
}

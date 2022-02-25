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

import com.quantumdataengines.app.compass.otherservice.OtherCommonService;
import com.quantumdataengines.app.compass.service.CommonService;
import com.quantumdataengines.app.compass.service.master.GenericMasterService;
import com.quantumdataengines.app.compass.service.missingFieldsReport.MissingFieldsReportService;

@Controller
@RequestMapping(value="/common")
public class MissingFieldsReportController {
	@SuppressWarnings("unused")
	private static final Logger log = LoggerFactory.getLogger(MissingFieldsReportController.class);
	
	@Autowired
	private CommonService commonService;
	@Autowired
	private OtherCommonService otherCommonService;
	@Autowired
	private GenericMasterService genericMasterService;
	@Autowired
	private MissingFieldsReportService missingFieldsReportService;
	
	@RequestMapping(value="/missingFieldsReport", method=RequestMethod.GET)
	public String missingFieldsReport(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{

		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("BRANCHLIST", missingFieldsReportService.getListOfBranchCodes());
		request.setAttribute("TEMPLATELIST", missingFieldsReportService.getListOfTemplates());
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "MISSING FIELDS REPORT", "OPEN", "Module Accessed");
		return "KYCModules/MissingFieldsReport/index";
	}

	@RequestMapping(value="/searchMissingFieldsReport", method=RequestMethod.POST)
	public String searchMissingFieldsReport(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		
		String template = request.getParameter("template");
		String branchCode = request.getParameter("branchCode");
		String complianceScore = request.getParameter("complianceScore");
		String userCode = authentication.getPrincipal().toString();
		String ipAddress = request.getRemoteAddr();

		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("resultData", missingFieldsReportService.searchMissingFieldsReport(template, branchCode, complianceScore, userCode, ipAddress));
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "MISSING FIELDS REPORT", "SEARCH", "Module Accessed");
		return "KYCModules/MissingFieldsReport/SearchBottomFrame";
	}
	
	}

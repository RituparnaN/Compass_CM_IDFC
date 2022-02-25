package com.quantumdataengines.app.compass.controller;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.quantumdataengines.app.compass.otherservice.OtherCommonService;
import com.quantumdataengines.app.compass.service.CommonService;
import com.quantumdataengines.app.compass.service.overviewGlance.OverviewGlanceService;

@Controller
@RequestMapping(value = "common/")
public class OverviewGlanceController {
	
	@Autowired
	private OverviewGlanceService overviewGlanceService;
	@Autowired
	private CommonService commonService;
	@Autowired
	private OtherCommonService otherCommonService;
	
	@RequestMapping(value = "overview/etlSummary",method = RequestMethod.GET)
	public String etlSummary(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception {
		String userCode = authentication.getPrincipal().toString();
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String ipAddr = request.getRemoteAddr();
		Map<String,Object> etlSummaryData = overviewGlanceService.getETLSummary(userCode, userRole, ipAddr);
		Map<String,Object> etlWorkflowData = overviewGlanceService.etlWorkflowData(userCode, userRole, ipAddr);
		Map<String,Object> etlAlertData = overviewGlanceService.etlAlertData(userCode, userRole, ipAddr);
		Map<String,Object> etlRegReportData = overviewGlanceService.etlRegReportData(userCode, userRole, ipAddr);
		Map<String,Object> etlUserRoleData = overviewGlanceService.etlUserRoleData(userCode, userRole, ipAddr);
		Map<String,Object> etlAccountTypeStatusData = overviewGlanceService.etlAccountTypeStatusData(userCode, userRole, ipAddr);
		Map<String,Object> etlCustomerTypeData = overviewGlanceService.etlCustomerTypeData(userCode, userRole, ipAddr);
		Map<String,Object> etlCaseProductivityData = overviewGlanceService.etlCaseProductivityData(userCode, userRole, ipAddr);
		request.setAttribute("ETLSUMMARYDATA", etlSummaryData);
		request.setAttribute("ETLWORKFLOWDATA", etlWorkflowData);
		request.setAttribute("ETLALERTDATA", etlAlertData);
		request.setAttribute("ETLREGREPORTDATA", etlRegReportData);
		request.setAttribute("ETLUSERROLEDATA", etlUserRoleData);
		request.setAttribute("ETLACCOUNTTYPESTATUSDATA", etlAccountTypeStatusData);
		request.setAttribute("ETLCUSTOMERTYPEDATA", etlCustomerTypeData);
		request.setAttribute("ETLCASEPRODUCTIVITYDATA", etlCaseProductivityData);
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("MODULETYPE", request.getParameter("moduleType"));
		commonService.auditLog(authentication.getPrincipal().toString(), request, "ETLSUMMARY", "OPEN", "Module Accessed");
		return "OverviewGlance/ETLSummary/index";
	}
	
	@RequestMapping(value = "overview/getETLAlertData",method = RequestMethod.POST)
	public String getETLAlertData(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception {
		String fromDate = request.getParameter("fromDate");
		String toDate = request.getParameter("toDate");
		String reportType = request.getParameter("reportType");
		String reportValue = request.getParameter("reportValue");
		String moduleType = request.getParameter("moduleType");
		String bottomPageUrl = request.getParameter("bottomPageUrl");
		String userCode = authentication.getPrincipal().toString();
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String ipAddr = request.getRemoteAddr();
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("moduleType", moduleType);
		request.setAttribute("moduleName", moduleType);
		request.setAttribute("SEARCHRESULT", overviewGlanceService.getETLAlertData(fromDate, toDate, 
				reportType, reportValue, moduleType, userCode, userRole, ipAddr));
		commonService.auditLog(authentication.getPrincipal().toString(), request, "ETLALERTDATA", "OPEN", "Module Accessed");
		return bottomPageUrl;
	}
	
	
	@RequestMapping(value = "overview/getETLRegulatoryReportData",method = RequestMethod.POST)
	public String getETLRegulatoryReportData(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception {
		String fromDate = request.getParameter("fromDate");
		String toDate = request.getParameter("toDate");
		String reportType = request.getParameter("reportType");
		String reportValue = request.getParameter("reportValue");
		String moduleType = request.getParameter("moduleType");
		String bottomPageUrl = request.getParameter("bottomPageUrl");
		String userCode = authentication.getPrincipal().toString();
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String ipAddr = request.getRemoteAddr();
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("moduleType", moduleType);
		request.setAttribute("moduleName", moduleType);
		request.setAttribute("SEARCHRESULT", overviewGlanceService.getETLRegulatoryReportData(fromDate, toDate, 
				reportType, reportValue, moduleType, userCode, userRole, ipAddr));
		commonService.auditLog(authentication.getPrincipal().toString(), request, "ETLREGREPORTS", "OPEN", "Module Accessed");
		return bottomPageUrl;
	}
	
	

}

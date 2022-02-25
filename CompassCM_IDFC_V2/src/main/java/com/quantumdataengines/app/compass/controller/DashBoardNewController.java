package com.quantumdataengines.app.compass.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import com.quantumdataengines.app.compass.otherservice.OtherCommonService;
import com.quantumdataengines.app.compass.service.CommonService;
import com.quantumdataengines.app.compass.service.dashBoardNew.DashBoardNewService;

@Controller
@RequestMapping(value="/common")
public class DashBoardNewController {
	@Autowired
	private DashBoardNewService DashBoardNewService;
	@Autowired
	private CommonService commonService;
	@Autowired
	private OtherCommonService otherCommonService;
	
	@RequestMapping(value = "/getDashboardNewTabView", method=RequestMethod.POST) 
	public String getDashboardNewTabView(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception {
		String fromDate = request.getParameter("fromDate");
		String toDate = request.getParameter("toDate");
		String sourceSystem = request.getParameter("sourceSystem");
		String userCode = authentication.getPrincipal().toString();
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
	    String ipAddress = request.getRemoteAddr();
	    		
		Map<String, Object> mainMap = DashBoardNewService.getDashBoardNewInTabView(fromDate, toDate, userCode, userRole, sourceSystem);
		List<Map<String, Object>> totalAmluserWiseRecordStats = DashBoardNewService.getTotalAmluserWiseRecordStats(fromDate, toDate, 
				sourceSystem, userCode, userRole, ipAddress);
		request.setAttribute("TotalAmluserWiseRecordStats", totalAmluserWiseRecordStats);
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("DashBoardData", mainMap);
		request.setAttribute("FromDate", fromDate);
		request.setAttribute("ToDate", toDate);
		request.setAttribute("SourceSystem", sourceSystem);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "DASHBOARD", "READ", "Module Accessed");
		//return "DashBoard/DashBoardGraphView";
		System.out.println("mainMap = "+mainMap);
		System.out.println("DashBoardNew/DashBoardNewTabView");
		return "DashBoardNew/NewDashBoardTabView";
    }
	
	/*@RequestMapping(value = "/getSwiftDashboardTabView") 
	public ModelAndView getSwiftDashboardTabView(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception {
		ModelAndView mv = new ModelAndView("/DashBoard/SwiftDashBoardTabView");
		String fromDate = request.getParameter("FromDate");
		String toDate = request.getParameter("ToDate");
		String messageFlowType = request.getParameter("MessageFlowType");
		String userCode = authentication.getPrincipal().toString();
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
	    
		Map<String, Object> mainMap = DashBoardService.getSwiftDashBoardInTabView(fromDate, toDate, userCode, userRole, messageFlowType);
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("DashBoardData", mainMap);
		request.setAttribute("FromDate", fromDate);
		request.setAttribute("ToDate", toDate);
		request.setAttribute("MessageFlowType", messageFlowType);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "DASHBOARD", "READ", "Module Accessed");
	    return mv;
    }
	
	@RequestMapping(value = "/getMISReportTabView") 
	public ModelAndView getMISReportTabView(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception {
		ModelAndView mv = new ModelAndView("/Reports/MISReports/MISReportTabView");
		String fromDate = request.getParameter("FromDate");
		String toDate = request.getParameter("ToDate");
		String reportFrequency = request.getParameter("ReportFrequency");
		String userCode = authentication.getPrincipal().toString();
	    
		Map<String, Object> mainMap = DashBoardService.getMISReportTabView(fromDate, toDate, userCode, reportFrequency);
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("MISReportsData", mainMap);
		request.setAttribute("FromDate", fromDate);
		request.setAttribute("ToDate", toDate);
		request.setAttribute("ReportFrequency", reportFrequency);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "DASHBOARD", "READ", "Module Accessed");
	    return mv;
    }	*/		
}

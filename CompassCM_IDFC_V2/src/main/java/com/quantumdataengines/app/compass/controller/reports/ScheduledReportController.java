package com.quantumdataengines.app.compass.controller.reports;

import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.view.RedirectView;

import com.quantumdataengines.app.compass.service.CommonService;
import com.quantumdataengines.app.compass.service.reports.ScheduledReportService;

@Controller
@RequestMapping(value="/admin")
public class ScheduledReportController {
	
	@Autowired
	private ScheduledReportService scheduledReportService;
	@Autowired
	private CommonService commonService;
	
	@RequestMapping(value = "/reportScheduler", method=RequestMethod.GET)
	public String reportScheduler(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication){
		request.setAttribute("LOGGEDUSER", authentication.getPrincipal().toString());
		commonService.auditLog(authentication.getPrincipal().toString(), request, "REPORTS", "OPEN", "Module Accessed");
		return "ReportScheduler/index";
	}
	
	@RequestMapping(value = "/getSchedulerTopFrame", method=RequestMethod.GET)
	public String getSchedulerTopFrame(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication){
		request.setAttribute("LOGGEDUSER", authentication.getPrincipal().toString());
		commonService.auditLog(authentication.getPrincipal().toString(), request, "REPORTS", "OPEN", "Module Accessed");
		return "ReportScheduler/ReportSearchFrame";
	}
	
	@RequestMapping(value = "/getSchedulerBottomFrame", method=RequestMethod.GET)
	public String getSchedulerBottomFrame(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication){
		request.setAttribute("LOGGEDUSER", authentication.getPrincipal().toString());
		commonService.auditLog(authentication.getPrincipal().toString(), request, "REPORTS", "OPEN", "Module Accessed");
		return "ReportScheduler/blank";
	}
	
	
	@RequestMapping(value = "/getReportNameList", method=RequestMethod.GET)
	public @ResponseBody String getReportNameList(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication){
		String reportGroup = request.getParameter("group");
		String str = "<select class='form-control input-sm' name='reportID' id='reportID'>";
		str = str+"<option value='' selected>Select One</option>";
		List<Map<String, String>> mainMap = scheduledReportService.getAllReportsDetails(reportGroup);
		for(Map<String, String> innerMap : mainMap){
			String reportID = innerMap.get("REPORTID");
			String reportName = innerMap.get("REPORTNAME");
		//	String reportSeqNo = innerMap.get("SEQNO");
			str = str+"<option value='"+reportID+"'>"+reportName+"</option>";
		}
		str = str+"</select>";
		request.setAttribute("LOGGEDUSER", authentication.getPrincipal().toString());
		return str;
	}
	
	@RequestMapping(value = "/searchAllReportForScheduling", method=RequestMethod.GET)
	public String searchAllReportForScheduling(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication){
		String reportID = request.getParameter("reportID");
		String reportName = request.getParameter("reportName");
		request.setAttribute("mainMap", scheduledReportService.getReportBenchmarkDetails(reportID));
		request.setAttribute("reportID", reportID);
		request.setAttribute("reportName", reportName);
		request.setAttribute("LOGGEDUSER", authentication.getPrincipal().toString());
		return "ReportScheduler/ReportBenchmark";
	}
	
	@RequestMapping(value = "/scheduleReport")
	public String scheduleReport(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication){
		String reportID = request.getParameter("reportID");
		String reportName = request.getParameter("reportName");
		String userID = request.getParameter("userID");
		String message = request.getParameter("message") != null ? (String) request.getParameter("message") : "";
		String strScheduleFrequency = "";
		String strScheduleDates = "";
		Map<String, String> benchmarkScheduleDetails = scheduledReportService.getBenchmarkScheduleDetails(userID, reportID);
		String isBenchmarkScheduled = benchmarkScheduleDetails.get("ISREPORTSCHEDULED");
		if("Y".equalsIgnoreCase(isBenchmarkScheduled)){
			strScheduleFrequency = benchmarkScheduleDetails.get("REPORTFREQUENCY");
			strScheduleDates = benchmarkScheduleDetails.get("REPORTGENERATIONDATES");
		}
		benchmarkScheduleDetails.remove("ISREPORTSCHEDULED");
		benchmarkScheduleDetails.remove("REPORTFREQUENCY");
		benchmarkScheduleDetails.remove("REPORTGENERATIONDATES");
		request.setAttribute("isBenchmarkScheduled", isBenchmarkScheduled);
		request.setAttribute("ScheduleFrequency", strScheduleFrequency);
		request.setAttribute("ScheduleDates", strScheduleDates);
		request.setAttribute("benchmarkScheduleDetails", benchmarkScheduleDetails);
		request.setAttribute("userID", userID);
		request.setAttribute("reportID", reportID);
		request.setAttribute("reportName", reportName);
		request.setAttribute("message", message);
		request.setAttribute("LOGGEDUSER", authentication.getPrincipal().toString());
		return "ReportScheduler/ScheduleReport";
	}
	
	@RequestMapping(value = "/saveScheduledBenchmark", method=RequestMethod.POST)
	public @ResponseBody String saveScheduledBenchmarkSave(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication){
		String reportID = request.getParameter("reportID");
		String reportName = request.getParameter("reportName");
		String userID = request.getParameter("userID");		
		String isSchedule = request.getParameter("isSchedule");
		String a_strSchedulingFrequency = request.getParameter("reportFrequency");		
		String a_strGenerationDates = request.getParameter("generationDates");
		Map<String, String[]> rawRequestMap = request.getParameterMap();
		Map<String, String[]> requestMap = new HashMap<String, String[]>();
		requestMap.putAll(rawRequestMap);
		Map<String, String> paramMap = new LinkedHashMap<String, String>();
		requestMap.remove("reportID");	requestMap.remove("userID");
		requestMap.remove("reportFrequency");	requestMap.remove("generationDates");
		requestMap.remove("reportName");	requestMap.remove("isSchedule");
		requestMap.remove("save");	requestMap.remove("delete");
		Iterator<String> itr = requestMap.keySet().iterator();
		while (itr.hasNext()) {
			String key = itr.next();
			String[] value = requestMap.get(key);
			paramMap.put(key, value[0]);
		}
		String latestUserID = scheduledReportService.saveOrUpdateReportBenchMark(reportID, userID, paramMap);
		String message = "";
		if(isSchedule != null){
			scheduledReportService.saveOrUpdateSchedulingDetailsForReport(latestUserID, reportID, a_strSchedulingFrequency, a_strGenerationDates);
		}else{
			scheduledReportService.deleteScheduling(latestUserID, reportID);
		}
		if(latestUserID != null){
			if(latestUserID.equalsIgnoreCase(userID)){
				message = "Report Benchmarks are updated successfully.";
			}else{
				message = "New Benchmark for this report has been created.";
			}
		}else{
			message = "Something went wrong while saving the benchmarks";
		}
		RedirectView rv = new RedirectView("scheduleReport?reportID="+reportID+"&reportName="+reportName+"&userID="+latestUserID+"&message="+message);
		request.setAttribute("LOGGEDUSER", authentication.getPrincipal().toString());
		commonService.auditLog(authentication.getPrincipal().toString(), request, "SCHEDULED BENCHMARK", "INSERT", "Saved");
		return message;
	}
	
	@RequestMapping(value = "/deleteScheduledBenchmark", method=RequestMethod.POST)
	public @ResponseBody String saveScheduledBenchmarkDelete(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication){
		String reportID = request.getParameter("reportID");
		String reportName = request.getParameter("reportName");
		String userID = request.getParameter("userID");
		String message = "";
		request.setAttribute("LOGGEDUSER", authentication.getPrincipal().toString());
		if(userID.equals("default")){
			message = "This benchmark cannot be deleted";
		}else{
			scheduledReportService.deleteBenchmark(userID, reportID);
			scheduledReportService.deleteScheduling(userID, reportID);
			message = "Report has been deleted successfully";
		}
		//RedirectView rv = new RedirectView("scheduleReport?reportID="+reportID+"&reportName="+reportName+"&userID=default&message="+message);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "SCHEDULED BENCHMARK", "DELETE", "Deleted");
		return message;
	}
}

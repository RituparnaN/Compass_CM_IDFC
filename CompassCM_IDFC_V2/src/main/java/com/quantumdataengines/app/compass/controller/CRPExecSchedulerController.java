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
import com.quantumdataengines.app.compass.service.crpExecScheduler.CRPExecSchedulerService;

@Controller
@RequestMapping(value="/common")
public class CRPExecSchedulerController {
private static final Logger log = LoggerFactory.getLogger(CommonController.class);
	
	@Autowired
	private CommonService commonService;
	@Autowired
	private OtherCommonService otherCommonService;
	@Autowired
	private CRPExecSchedulerService crpExecSchedulerService;
	
	@RequestMapping(value="/crpExecScheduler", method=RequestMethod.GET)
	public String crpExecScheduler(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("RESULTDATA", crpExecSchedulerService.getCRPExecutedDetails());
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CRP EXECUTION SCHEDULER", "OPEN", "Module Accessed");
		return "CRPExecScheduler/index";
	}
	
	
	@RequestMapping(value="/saveSchedulingDates", method=RequestMethod.POST)
	public @ResponseBody String saveSchedulingDates(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		String EXECUTED_FROMDATE = request.getParameter("EXECUTED_FROMDATE");
		String EXECUTED_TODATE = request.getParameter("EXECUTED_TODATE");
		String EXECUTED_DATE = request.getParameter("EXECUTED_DATE");
		String SCHEDULED_FROMDATE = request.getParameter("SCHEDULED_FROMDATE");
		String SCHEDULED_TODATE = request.getParameter("SCHEDULED_TODATE");
		String EXECUTION_DATE = request.getParameter("EXECUTION_DATE");
		String currentUser = authentication.getPrincipal().toString();
		/*System.out.println("Controller -- EXECUTED_FROMDATE="+EXECUTED_FROMDATE+"&EXECUTED_TODATE="+EXECUTED_TODATE+
				   "&EXECUTED_DATE="+EXECUTED_DATE+"SCHEDULED_FROMDATE="+SCHEDULED_FROMDATE+"&SCHEDULED_TODATE="+SCHEDULED_TODATE+
				   "&EXECUTION_DATE="+EXECUTION_DATE);*/
	    request.setAttribute("UNQID", otherCommonService.getElementId());
	    commonService.auditLog(authentication.getPrincipal().toString(), request, "CRP EXECUTION SCHEDULER", "INSERT", "CRP Execution Scheduling Saved");
		return crpExecSchedulerService.saveSchedulingDates(EXECUTED_FROMDATE, EXECUTED_TODATE, EXECUTED_DATE, SCHEDULED_FROMDATE, SCHEDULED_TODATE, EXECUTION_DATE, currentUser);
	}
	
}
package com.quantumdataengines.app.compass.controller.reports;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.quantumdataengines.app.compass.service.CommonService;
import com.quantumdataengines.app.compass.service.reports.MultiSheetReportService;
import com.quantumdataengines.app.compass.service.reports.ReportService;

@Controller
public class PdfController
{
	@Autowired
	private ReportService ReportService;
	@Autowired
	private MultiSheetReportService multiSheetReportService;
	@Autowired
	private CommonService commonService;
	
	private Logger log = LoggerFactory.getLogger(PdfController.class);
	@Autowired
	public PdfController(ReportService ReportService) {
		this.ReportService = ReportService;
	}
	
	@RequestMapping(value = "/getPDFFiles")
    public ModelAndView handleRequest(@RequestParam(value = "reportId") String reportId, 
    		@RequestParam(value = "startDate") String startDate, @RequestParam(value = "endDate") String endDate,
    		HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception
    {
	log.debug("In PdfController.handleRequest...");
	//HttpSession session = request.getSession(false);
	//@SuppressWarnings("unchecked")
	//HashMap<String, Object> l_HMUserDetails1 = (HashMap<String, Object>) session.getAttribute("userDetails");
	//UserFormBean ufb = (UserFormBean) l_HMUserDetails1.get("UserBean");
	//String username = ufb.getL_strUserID();
	//String username = "govind";
	//if (ufb.getL_strIsAdmin().equals("Y")) 
	//{
//	HashMap<String,Object> l_HMReportData = ReportService.reportData(username,reportId, startDate, endDate);
    Map<String, Object> model = new HashMap<String, Object>();
  //  model.put(PdfView.PDF_LIST_KEY, l_HMReportData);
    model.put("reportId", reportId);
    model.put("startDate", startDate);
    model.put("endDate", endDate);
    commonService.auditLog(authentication.getPrincipal().toString(), request, "REPORTS", "DOWNLOAD", "File Downloaded");
    return new ModelAndView(new PdfView(), model);
	//}
	//else
	//return new ModelAndView("nonAdmin");
  }
	@RequestMapping(value = "/getReportPDFFiles")
    public ModelAndView getReportPDFFiles(@RequestParam(value = "reportId") String reportId, 
    		@RequestParam(value = "startDate") String startDate, @RequestParam(value = "endDate") String endDate,
    		@RequestParam(value = "amount") String amount, @RequestParam(value = "filter1") String filter1,
    		@RequestParam(value = "filter2") String filter2, @RequestParam(value = "filter3") String filter3,
    		HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception
    {
	log.debug("In PdfController.getReportPDFFiles...");
	//HashMap<String, Object> l_HMUserDetails1 = (HashMap<String, Object>) session.getAttribute("userDetails");
	//UserFormBean ufb = (UserFormBean) l_HMUserDetails1.get("UserBean");
	//String username = ufb.getL_strUserID();
	String username = "govind";
	//if (ufb.getL_strIsAdmin().equals("Y")) 
	//{
	Map<String, Object> model = new HashMap<String, Object>();
    try{
	HashMap<String,Object> l_HMReportData = ReportService.reportData(username,reportId, startDate, endDate, amount, filter1, filter2, filter3);
    model.put(PdfView.PDF_LIST_KEY, l_HMReportData);
    model.put("reportId", reportId);
    model.put("startDate", startDate);
    model.put("endDate", endDate);
	}
	catch(Exception e)
	{
		log.error("Error occured "+e.toString());
		System.out.println("The exception is: "+e.toString());
		e.printStackTrace();
	}
    commonService.auditLog(authentication.getPrincipal().toString(), request, "REPORTS", "DOWNLOAD", "File Downloaded");
    return new ModelAndView(new PdfView(), model);
	//}
	//else
	//return new ModelAndView("nonAdmin");
  }
	
	@RequestMapping(value = "/getReportBuilderPDFData")
    public ModelAndView getReportBuilderPDFData(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception
    {
	log.debug("In PdfController.getReportBuilderPDFData...");
	String userName = request.getSession().getAttribute("LOGGEDUSER").toString();
	
	String builtCondition = request.getParameter("builtCondition");
	String l_strReportID = request.getParameter("l_strReportID");
	String l_strNoOfParameters = request.getParameter("l_strNoOfParameters");
	int l_intNoOfParameters = Integer.parseInt(l_strNoOfParameters);
	for(int i=1; i<=l_intNoOfParameters;i++){
		builtCondition = builtCondition.replaceAll("@param"+i, request.getParameter("@param"+i));	
	}
	
	Map<String, Object> model = new HashMap<String, Object>();
    try{
    HashMap<String,Object> l_HMReportData = ReportService.reportData(userName, builtCondition, l_strReportID, l_strNoOfParameters);
    model.put(PdfView.PDF_LIST_KEY, l_HMReportData);
    model.put("reportId", l_strReportID);
    model.put("startDate", "null");
    model.put("endDate", "null");
	}
	catch(Exception e)
	{
		log.error("The exception is: "+e.toString());
		System.out.println("The exception is: "+e.toString());
		e.printStackTrace();
	}
    commonService.auditLog(authentication.getPrincipal().toString(), request, "REPORTS", "DOWNLOAD", "File Downloaded");
    return new ModelAndView(new PdfView(), model);
  }
	
	@RequestMapping(value = "/getReportWidgetsMainPDFData")
    public ModelAndView getReportWidgetsMainPDFData(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception
    {
	log.debug("In PdfController.getReportBuilderPDFData...");
	String userName = request.getSession().getAttribute("LOGGEDUSER").toString();
	
	String reportId = request.getParameter("reportId");
	
	Map<String, Object> model = new HashMap<String, Object>();
    try{
    HashMap<String,Object> l_HMReportData = ReportService.reportWidgetsMainData(userName, reportId);
    model.put(PdfView.PDF_LIST_KEY, l_HMReportData);
    model.put("reportId", reportId);
    model.put("startDate", "null");
    model.put("endDate", "null");
	}
	catch(Exception e)
	{
		log.error("The exception is: "+e.toString());
		System.out.println("The exception is: "+e.toString());
		e.printStackTrace();
	}
    commonService.auditLog(authentication.getPrincipal().toString(), request, "REPORTS", "DOWNLOAD", "File Downloaded");
    return new ModelAndView(new PdfView(), model);
  } 	
	
	@RequestMapping(value = "/getReportWidgetsPDFData")
    public ModelAndView getReportWidgetsPDFData(HttpServletRequest request, HttpServletResponse response,Authentication authentication) throws Exception
    {
	log.debug("In PdfController.getReportBuilderPDFData...");
	String userName = request.getSession().getAttribute("LOGGEDUSER").toString();
	
	String selectedTables = (String)request.getParameter("selectedTables");
	String joinConditions = request.getParameter("joinConditions") == null ? "":(String)request.getParameter("joinConditions");
	String reportColumns = (String)request.getParameter("reportColumns");
	String params = (String)request.getParameter("params");
	String aggregateConditions = request.getParameter("aggregateConditions")==null?"":(String)request.getParameter("aggregateConditions");

	
	Map<String, Object> model = new HashMap<String, Object>();
    try{
    HashMap<String,Object> l_HMReportData = ReportService.reportWidgetsData(userName, selectedTables, joinConditions, 
    		reportColumns, params, aggregateConditions);
    model.put(PdfView.PDF_LIST_KEY, l_HMReportData);
    model.put("reportId", "TempReport");
    model.put("startDate", "null");
    model.put("endDate", "null");
	}
	catch(Exception e)
	{
		log.error("The exception is: "+e.toString());
		System.out.println("The exception is: "+e.toString());
		e.printStackTrace();
	}
    commonService.auditLog(authentication.getPrincipal().toString(), request, "REPORTS", "DOWNLOAD", "File Downloaded");
    return new ModelAndView(new PdfView(), model);
  }	
}

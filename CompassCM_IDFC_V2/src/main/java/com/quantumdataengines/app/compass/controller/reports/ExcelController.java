package com.quantumdataengines.app.compass.controller.reports;

import java.io.File;
import java.io.FileInputStream;
import java.io.OutputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.quantumdataengines.app.compass.service.CommonService;
import com.quantumdataengines.app.compass.service.dashBoard.DashBoardService;
import com.quantumdataengines.app.compass.service.reports.MultiSheetReportService;
import com.quantumdataengines.app.compass.service.reports.ReportService;
import com.quantumdataengines.app.compass.service.reports.ReportsGenericService;
import com.quantumdataengines.app.compass.util.CommonUtil;

@Controller
public class ExcelController
{
	@Autowired
	private ReportService ReportService;
	@Autowired
	private ReportsGenericService reportsGenericService;
	@Autowired
	private MultiSheetReportService multiSheetReportService;
	@Autowired
	private CommonService commonService;
	
	//@Value("${report.scheduled.path}")
	private String m_scheduledReportStaticPath = CommonUtil.loadProperties().getProperty("compass.aml.paths.appFolder");
	@Autowired
	private DashBoardService DashBoardService;
	private Logger log = Logger.getLogger(getClass());
	
	@RequestMapping(value = "/getExcel")
    public ModelAndView handleRequest(@RequestParam(value = "reportId") String reportId, 
    		@RequestParam(value = "startDate") String startDate, @RequestParam(value = "endDate") String endDate,
    		HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception
    {
	log.debug("In ExcelController.handleRequest...");
	HttpSession session = request.getSession(false);
	@SuppressWarnings("unchecked")
	//HashMap<String, Object> l_HMUserDetails1 = (HashMap<String, Object>) session.getAttribute("userDetails");
	//UserFormBean ufb = (UserFormBean) l_HMUserDetails1.get("UserBean");
	//String username = ufb.getL_strUserID();
	String username = "govind";
	//if (ufb.getL_strIsAdmin().equals("Y")) 
	//{
//	HashMap<String,Object> l_HMReportData = ReportService.reportData(username,reportId, startDate, endDate);
    Map<String, Object> model = new HashMap<String, Object>();
  //  model.put(ExcelView.EXCEL_LIST_KEY, l_HMReportData);
    commonService.auditLog(authentication.getPrincipal().toString(), request, "REPORTS", "DOWNLOAD", "File Downloaded");
	return new ModelAndView(new ExcelView(), model);
	//}
	//else
	//return new ModelAndView("nonAdmin");
    }
	
	@RequestMapping(value = "/getReportXLSFiles")
    public ModelAndView getReportEXCELFiles(@RequestParam(value = "reportId") String reportId, 
    		@RequestParam(value = "startDate") String startDate, @RequestParam(value = "endDate") String endDate,
    		@RequestParam(value = "amount") String amount, @RequestParam(value = "filter1") String filter1,
    		@RequestParam(value = "filter2") String filter2, @RequestParam(value = "filter3") String filter3,
    		HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception
    {
	log.debug("In ExcelController.getReportXLSFiles...");
	HttpSession session = request.getSession(false);
	@SuppressWarnings("unchecked")
	//HashMap<String, Object> l_HMUserDetails1 = (HashMap<String, Object>) session.getAttribute("userDetails");
	//UserFormBean ufb = (UserFormBean) l_HMUserDetails1.get("UserBean");
	//String username = ufb.getL_strUserID();
	String username = "govind";
	//if (ufb.getL_strIsAdmin().equals("Y")) 
	//{
	HashMap<String,Object> l_HMReportData = ReportService.reportData(username,reportId, startDate, endDate, amount, filter1, filter2, filter3);
    Map<String, Object> model = new HashMap<String, Object>();
    model.put(ExcelView.EXCEL_LIST_KEY, l_HMReportData);
    response.setContentType("application/vnd.ms-excel");
    response.setHeader("Content-Disposition", "attachment; fileName=\""+l_HMReportData.get("reportName")+".xlsx\"");
    commonService.auditLog(authentication.getPrincipal().toString(), request, "REPORTS", "DOWNLOAD", "File Downloaded");
	return new ModelAndView(new ExcelView(), model);
	//}
	//else
	//return new ModelAndView("nonAdmin");
    }
	
	@RequestMapping(value = "/getReportBuilderXLSData")
    public ModelAndView getReportBuilderXLSData(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception
    {
	log.debug("In ExcelController.getReportBuilderXLSData...");
	String username = authentication.getPrincipal().toString();
	
	String builtCondition = request.getParameter("builtCondition");
	String l_strReportID = request.getParameter("l_strReportID");
	String l_strNoOfParameters = request.getParameter("l_strNoOfParameters");
	int l_intNoOfParameters = Integer.parseInt(l_strNoOfParameters);
	for(int i=1; i<=l_intNoOfParameters;i++){
		builtCondition = builtCondition.replaceAll("@param"+i, request.getParameter("@param"+i));	
	}
	HashMap<String,Object> l_HMReportData = ReportService.reportData(username, builtCondition, l_strReportID, l_strNoOfParameters);
	Map<String, Object> model = new HashMap<String, Object>();
    model.put(ExcelView.EXCEL_LIST_KEY, l_HMReportData);
    response.setContentType("application/vnd.ms-excel");
    response.setHeader("Content-Disposition", "attachment; fileName=\""+l_HMReportData.get("reportName")+".xlsx\"");
    commonService.auditLog(authentication.getPrincipal().toString(), request, "REPORTS", "DOWNLOAD", "File Downloaded");
	return new ModelAndView(new ExcelView(), model);
	}
	
	@RequestMapping(value = "/getReportWidgetsMainXLSData")
    public ModelAndView getReportWidgetsMainXLSData(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception
    {
	log.debug("In ExcelController.getReportBuilderXLSData...");
	String userName = authentication.getPrincipal().toString();
	
	String reportId = request.getParameter("reportId");
	HashMap<String,Object> l_HMReportData = ReportService.reportWidgetsMainData(userName, reportId);
	Map<String, Object> model = new HashMap<String, Object>();
    model.put(ExcelView.EXCEL_LIST_KEY, l_HMReportData);
    response.setContentType("application/vnd.ms-excel");
    response.setHeader("Content-Disposition", "attachment; fileName=\""+l_HMReportData.get("reportName")+".xlsx\"");
    commonService.auditLog(authentication.getPrincipal().toString(), request, "REPORTS", "DOWNLOAD", "File Downloaded");
	return new ModelAndView(new ExcelView(), model);
	}
	
	@RequestMapping(value = "/getReportWidgetsXLSData")
    public ModelAndView getReportWidgetsXLSData(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception
    {
	log.debug("In ExcelController.getReportBuilderXLSData...");
	String userName = authentication.getPrincipal().toString();
	
	String selectedTables = (String)request.getParameter("selectedTables");
	String joinConditions = request.getParameter("joinConditions") == null ? "":(String)request.getParameter("joinConditions");
	String reportColumns = (String)request.getParameter("reportColumns");
	String params = (String)request.getParameter("params");
	String aggregateConditions = request.getParameter("aggregateConditions")==null?"":(String)request.getParameter("aggregateConditions");
	
	HashMap<String,Object> l_HMReportData = ReportService.reportWidgetsData(userName, selectedTables, joinConditions, 
    		reportColumns, params, aggregateConditions);
    Map<String, Object> model = new HashMap<String, Object>();
    model.put(ExcelView.EXCEL_LIST_KEY, l_HMReportData);
    response.setContentType("application/vnd.ms-excel");
    response.setHeader("Content-Disposition", "attachment; fileName=\""+l_HMReportData.get("reportName")+".xlsx\"");
    commonService.auditLog(authentication.getPrincipal().toString(), request, "REPORTS", "DOWNLOAD", "File Downloaded");
	return new ModelAndView(new ExcelView(), model);
	}
	
	@RequestMapping(value="/getExtractionLogInExcel")
	public ModelAndView extractionLogExcel(HttpServletRequest request, HttpServletResponse ersponse, 
			Authentication authentication){
		String fromDate = request.getParameter("fromDate");
		String toDate = request.getParameter("toDate");
		String logType = request.getParameter("logType");
		String status = request.getParameter("status");
		Map<String, Object> mainMap = multiSheetReportService.getExtractionLog(fromDate, toDate, logType, status);
		ModelAndView modelAndView = new ModelAndView(new MultiSheetExcelView(), mainMap);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "REPORTS", "DOWNLOAD", "File Downloaded");
		return modelAndView;
	}
	
	@RequestMapping(value="/DashBoard", method=RequestMethod.GET)
	public ModelAndView getDashBoard(HttpServletRequest request, HttpServletResponse ersponse, 
			Authentication authentication){
		String l_strFromDate = request.getParameter("FromDate");
		String l_strToDate = request.getParameter("ToDate");
		String l_strSourceSystem = request.getParameter("SourceSystem");
		String l_strUserCode = authentication.getPrincipal().toString();
		String l_strGroupCode = request.getSession(false).getAttribute("CURRENTROLE") == null ? "N.A.":request.getSession(false).getAttribute("CURRENTROLE").toString();
		Map<String, Object> mainMap = DashBoardService.getDashBoardInTabView(l_strFromDate, l_strToDate, l_strUserCode, l_strGroupCode, l_strSourceSystem);
		Iterator<String> itr = mainMap.keySet().iterator();
		List<String> tabOrder = new Vector<String>();
		while(itr.hasNext()){
			tabOrder.add(itr.next());
		}
		mainMap.put("TABORDER", tabOrder);
		ModelAndView modelAndView = new ModelAndView(new MultiSheetExcelView(), mainMap);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "REPORTS", "DOWNLOAD", "File Downloaded");
		return modelAndView;
	}

	@RequestMapping(value="/misReportTabXLS")
	public ModelAndView getMisReportTabXLS(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication){
		String l_strFromDate = request.getParameter("FromDate");
		String l_strToDate = request.getParameter("ToDate");
		String l_strReportFrequency = request.getParameter("ReportFrequency");
		String l_strUserCode = authentication.getPrincipal().toString();
		String userRole = request.getSession(false) != null ? (String) request.getSession(false).getAttribute("CURRENTROLE") : "";
		Map<String, Object> mainMap = DashBoardService.getMISReportTabView(l_strFromDate, l_strToDate, l_strUserCode, l_strReportFrequency);
		Iterator<String> itr = mainMap.keySet().iterator();
		List<String> tabOrder = new Vector<String>();
		while(itr.hasNext()){
			tabOrder.add(itr.next());
		}
		mainMap.put("TABORDER", tabOrder);
		ModelAndView modelAndView = new ModelAndView(new MultiSheetExcelView(), mainMap);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "REPORTS", "DOWNLOAD", "File Downloaded");
		return modelAndView;
	}

	@RequestMapping(value="/getConsolidatedReportTabXLS")
	public ModelAndView getConsolidatedReportTabXLS(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication){
		String l_strFromDate = request.getParameter("FromDate");
		String l_strToDate = request.getParameter("ToDate");
		String l_strReportFrequency = request.getParameter("ReportFrequency");
		String l_strUserCode = authentication.getPrincipal().toString();
		String userRole = request.getSession(false) != null ? (String) request.getSession(false).getAttribute("CURRENTROLE") : "";
		// Map<String, Object> mainMap = DashBoardService.getMISReportTabView(l_strFromDate, l_strToDate, l_strUserCode, l_strReportFrequency);
		Map<String, Object> mainMap = reportsGenericService.getConsolidatedReportTabView(l_strFromDate, l_strToDate, l_strUserCode, userRole, l_strReportFrequency);
		Iterator<String> itr = mainMap.keySet().iterator();
		List<String> tabOrder = new Vector<String>();
		while(itr.hasNext()){
			tabOrder.add(itr.next());
		}
		mainMap.put("TABORDER", tabOrder);
		ModelAndView modelAndView = new ModelAndView(new MultiSheetExcelView(), mainMap);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "REPORTS", "DOWNLOAD", "File Downloaded");
		return modelAndView;
	}

	@RequestMapping(value="/getExtractionLogInPage")
	public String extractionLogPage(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication){
		String fromDate = request.getParameter("fromDate");
		String toDate = request.getParameter("toDate");
		String logType = request.getParameter("logType");
		String status = request.getParameter("status");
		Map<String, Object> mainMap = multiSheetReportService.getExtractionLog(fromDate, toDate, logType, status);
		request.setAttribute("mainMap", mainMap);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "REPORTS", "OPEN", "Module Accessed");
		return "/ExtractionDashboard/getExtractionLogInPage";
	}
	
	@RequestMapping(value="/admin/downloadScheduledReport", method=RequestMethod.GET)
	public String getFolderDetails(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication){
		String refScheduleReportPath = m_scheduledReportStaticPath+File.separator+"GeneratedScheduledReport"+File.separator;
		String path = request.getParameter("path");
		
		String refPath = "";
		String backpath = request.getParameter("b");
		File folder;
		List<HashMap<String, String>> itemList = new ArrayList<HashMap<String, String>>();
		try{
			if(path.equalsIgnoreCase("root")){
				folder = new File(refScheduleReportPath);
			}else{
				path = refScheduleReportPath+path;
				folder = new File(path);
			}
			String ifFile = "";
			for(File fileEntry : folder.listFiles()){
				if(fileEntry.isFile()){
					ifFile = "y";
				}else{
					ifFile = "n";
				}
				HashMap<String, String> mainMap = new HashMap<String, String>();
				if(path.equalsIgnoreCase("root")){
					mainMap.put("ITEMPATH", fileEntry.getName());
				}else{
					String refFinalPath = "";
					refPath = path.replace(refScheduleReportPath, "");
					String[] strArr = CommonUtil.splitString(refPath, "\\");
					for(String str : strArr){
						if(str.length() >= 1)
							refFinalPath = refFinalPath + File.separator+ File.separator + str;
					}
					backpath = refFinalPath;
					mainMap.put("ITEMPATH", refFinalPath+File.separator+File.separator+fileEntry.getName());
				}
				
				long fileLength = fileEntry.length();
				float fileSize = 0L;
				String strFileSize = "";
				if(fileLength / (1000 * 1000) > 0){
					fileSize = fileLength / (1000 * 1000);
					strFileSize = fileSize+" MB";
				}else if(fileLength / (1000) > 0){
					fileSize = fileLength / (1000);
					strFileSize = fileSize+" KB";
				}else{
					strFileSize = fileLength+" B";
				}
				
				mainMap.put("ITEMNAME", fileEntry.getName());
				mainMap.put("ITEMSIZE", strFileSize);
				mainMap.put("DIRECTORY", ifFile);
				
				try{
					SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
					Date date = new Date(fileEntry.lastModified());
					mainMap.put("LASTMODIFIED", sdf.format(date));
				}catch(Exception e){}
				
				itemList.add(mainMap);
			}
		}catch(Exception e){
			e.printStackTrace();
		}
		request.setAttribute("itemList", itemList);
		request.setAttribute("backPath", backpath);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "REPORTS", "OPEN", "Module Accessed");
		return "/directoryDetails";
	}
	
	@RequestMapping(value="/downloadScheduleReport", method=RequestMethod.GET)
	public void downloadScheduleReport(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String path = request.getParameter("path");
		String name = request.getParameter("name");
		String filePath = "GeneratedScheduledReport"+path;
		String fullPath = m_scheduledReportStaticPath+File.separator+filePath;
		File outputFile = new File(fullPath);
		response.setContentType("application/octet-stream");
		response.setContentLength((int) outputFile.length());
		response.setHeader("Content-Disposition", "inline; filename="+name);
		
		FileInputStream fileIn = new FileInputStream(outputFile);
		OutputStream out = response.getOutputStream();
		 
		byte[] outputByte = new byte[(int) outputFile.length()];
		while(fileIn.read(outputByte, 0, (int) outputFile.length()) != -1){
			out.write(outputByte, 0, (int) outputFile.length());
		}
		fileIn.close();
		out.flush();
		out.close();
		commonService.auditLog(authentication.getPrincipal().toString(), request, "REPORTS", "DOWNLOAD", "File Downloaded");
	}
}
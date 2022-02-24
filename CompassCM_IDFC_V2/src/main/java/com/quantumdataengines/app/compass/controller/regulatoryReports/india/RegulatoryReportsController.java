package com.quantumdataengines.app.compass.controller.regulatoryReports.india;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.io.StringWriter;
import java.util.Enumeration;
import java.util.HashMap;
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
import org.springframework.web.servlet.ModelAndView;

import com.quantumdataengines.app.compass.controller.reports.MultiSheetExcelView;
import com.quantumdataengines.app.compass.otherservice.OtherCommonService;
import com.quantumdataengines.app.compass.service.CommonService;
import com.quantumdataengines.app.compass.service.master.GenericMasterService;
import com.quantumdataengines.app.compass.service.regulatoryReports.india.RegulatoryReportsService;

@Controller
@RequestMapping(value="/common")
public class RegulatoryReportsController {
	private Logger log = LoggerFactory.getLogger(RegulatoryReportsController.class);
	@Autowired
	private CommonService commonService;
	@Autowired
	private OtherCommonService otherCommonService;
	@Autowired
	private RegulatoryReportsService regulatoryReportsService;
	@Autowired
	private GenericMasterService genericMasterService;
	
	@RequestMapping(value = "/regulatoryReport") 
	public ModelAndView addNewIndividualDetails(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception {
		request.setAttribute("UNQID", otherCommonService.getElementId());
		ModelAndView mv = new ModelAndView("RegulatoryReports/India/GenerateRegulatoryReport/GenerateReport");
		commonService.auditLog(authentication.getPrincipal().toString(), request, "REGULATORY REPORT", "OPEN", "Module Accessed");
		return mv;
    }
	
	@RequestMapping(value="/generateRegulatoryExceptionFile")
	public ModelAndView generateRegulatoryExceptionFile(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication){
		String reportingMonth = request.getParameter("reportingMonth");
		String reportingYear = request.getParameter("reportingYear");
		String reportType = request.getParameter("reportType");
		String usercode = authentication.getPrincipal().toString();
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String ipAdress = request.getRemoteAddr();
		Map<String, String> paramMap = new LinkedHashMap<String, String>();
		paramMap.put("ReportingMonth", reportingMonth);
		paramMap.put("ReportingYear", reportingYear);
		paramMap.put("ReportType", reportType);
		paramMap.put("UserCode", usercode);
		paramMap.put("UserRole", userRole);
		paramMap.put("IPAdress", ipAdress);

		Map<String, Object> mainMap = regulatoryReportsService.generateRegulatoryExceptionFile(paramMap);
		Iterator<String> itr = mainMap.keySet().iterator();
		List<String> tabOrder = new Vector<String>();
		while(itr.hasNext()){
			tabOrder.add(itr.next());
		}
		mainMap.put("TABORDER", tabOrder);
		ModelAndView modelAndView = new ModelAndView(new MultiSheetExcelView(), mainMap);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "REGULATORY REPORTS", "DOWNLOAD EXCEPTION", "File Downloaded");
		return modelAndView;
	}
	
	@RequestMapping(value="/downloadRegulatoryExcel")
	public ModelAndView downloadRegulatoryExcel(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication){
		String reportingMonth = request.getParameter("reportingMonth");
		String reportingYear = request.getParameter("reportingYear");
		String reportType = request.getParameter("reportType");
		String usercode = authentication.getPrincipal().toString();
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String ipAdress = request.getRemoteAddr();
		Map<String, String> paramMap = new LinkedHashMap<String, String>();
		paramMap.put("ReportingMonth", reportingMonth);
		paramMap.put("ReportingYear", reportingYear);
		paramMap.put("ReportType", reportType);
		paramMap.put("UserCode", usercode);
		paramMap.put("UserRole", userRole);
		paramMap.put("IPAdress", ipAdress);

		Map<String, Object> mainMap = regulatoryReportsService.downloadRegulatoryExcel(paramMap);
		Iterator<String> itr = mainMap.keySet().iterator();
		List<String> tabOrder = new Vector<String>();
		while(itr.hasNext()){
			tabOrder.add(itr.next());
		}
		mainMap.put("TABORDER", tabOrder);
		ModelAndView modelAndView = new ModelAndView(new MultiSheetExcelView(), mainMap);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "REGULATORY REPORTS", "DOWNLOAD EXCEL", "File Downloaded");
		return modelAndView;
	}
	
	// GENERATED CTR FILES
		@RequestMapping(value="/viewGeneratedCTRFilesMaster", method=RequestMethod.POST)
		public String viewGeneratedCTRFilesMaster(HttpServletRequest request, HttpServletResponse response, 
				Authentication authentication) throws Exception{
			String moduleType = request.getParameter("moduleType");
			String viewFilePageUrl = request.getParameter("viewFilePageUrl");
			String viewCtrButton = request.getParameter("viewCtrButton");
			String reportingMonth = request.getParameter("1_REPORTINGMONTH"); 
			String reportingYear = request.getParameter("2_REPORTINGYEAR");
			//System.out.println("viewCtrButton "+viewCtrButton);
					
			String userCode = authentication.getPrincipal().toString();
			String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
			String ipAdress = request.getRemoteAddr();
					
			request.setAttribute("viewCtrButton", viewCtrButton);
			request.setAttribute("moduleType", moduleType);
			request.setAttribute("UNQID", otherCommonService.getElementId());
			request.setAttribute("SEARCHRESULT", regulatoryReportsService.viewGeneratedCTRFilesMaster(reportingMonth,reportingYear, moduleType, userCode, userRole, ipAdress));
			commonService.auditLog(authentication.getPrincipal().toString(), request, "CASH TRANSACTION REPORT", "SEARCH", "Module Accessed");
			return viewFilePageUrl;
		}
		
		@RequestMapping(value="/editCTRDetails", method=RequestMethod.POST)
		public String editCTRDetails(HttpServletRequest request, HttpServletResponse response, Authentication authentication){
			//String UNQID = request.getParameter("unqId");
			String selectedFileSeq = request.getParameter("selectedFileSeq");
			String viewCtrButton = request.getParameter("viewCtrButton");
			
			request.setAttribute("UNQID", otherCommonService.getElementId());
			request.setAttribute("selectedFileSeq", selectedFileSeq);
			request.setAttribute("viewCtrButton", viewCtrButton);
			
			commonService.auditLog(authentication.getPrincipal().toString(), request, "viewGeneratedCTRFiles", "READ", "Details will be added for sequence no.: "+selectedFileSeq);
			return "RegulatoryReports/India/CashTransactionReport/CTRFilesModal";
		}
		
		@RequestMapping(value="/updateCTRDetails", method=RequestMethod.POST)
		public  String updateCTRDetails(HttpServletRequest request, HttpServletResponse response,
				Authentication authentication)throws Exception{
			String selectedFileSeq = request.getParameter("selectedFileSeq");
			String userCode = authentication.getPrincipal().toString();
			Map<String, String> paramMap = new HashMap<String, String>();
			
			Enumeration enumObj =  request.getParameterNames();
			while(enumObj.hasMoreElements()){
				String paramName = (String) enumObj.nextElement();
				String paramValue = request.getParameter(paramName);
				paramMap.put(paramName, paramValue);
			}
			String result  = regulatoryReportsService.updateCTRDetails(paramMap, userCode, selectedFileSeq);
			
			
			request.setAttribute("selectedFileSeq", selectedFileSeq);
			String id = otherCommonService.getElementId();
			request.setAttribute("UNQID", id);
			
			commonService.auditLog(authentication.getPrincipal().toString(), request, "viewCTRFiles", "UPDATE", "Data Updated");
			return "RegulatoryReports/India/CashTransactionReport/ViewGeneratedFile";
			
		}

		
		// GENERATED NTR FILES
		@RequestMapping(value="/viewGeneratedNTRFilesMaster", method=RequestMethod.POST)
		public String viewGeneratedNTRFilesMaster(HttpServletRequest request, HttpServletResponse response, 
				Authentication authentication) throws Exception{
			String moduleType = request.getParameter("moduleType");
			String viewFilePageUrl = request.getParameter("viewFilePageUrl");
			String viewNtrButton = request.getParameter("viewNtrButton");
			String reportingMonth = request.getParameter("1_REPORTINGMONTH"); 
			String reportingYear = request.getParameter("2_REPORTINGYEAR");
			//System.out.println("viewButton "+viewButton);
					
			String userCode = authentication.getPrincipal().toString();
			String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
			String ipAdress = request.getRemoteAddr();
					
			request.setAttribute("viewNtrButton", viewNtrButton);
			request.setAttribute("moduleType", moduleType);
			request.setAttribute("UNQID", otherCommonService.getElementId());
			request.setAttribute("SEARCHRESULT", regulatoryReportsService.viewGeneratedNTRFilesMaster(reportingMonth,reportingYear, moduleType, userCode, userRole, ipAdress));
			commonService.auditLog(authentication.getPrincipal().toString(), request, "NPO TRANSACTION REPORT", "SEARCH", "Module Accessed");
			return viewFilePageUrl;
		}
		
		@RequestMapping(value="/editNTRDetails", method=RequestMethod.POST)
		public String editNTRDetails(HttpServletRequest request, HttpServletResponse response, Authentication authentication){
			//String UNQID = request.getParameter("unqId");
			String selectedFileSeq = request.getParameter("selectedFileSeq");
			String viewNtrButton = request.getParameter("viewNtrButton");
			
			request.setAttribute("UNQID", otherCommonService.getElementId());
			request.setAttribute("selectedFileSeq", selectedFileSeq);
			request.setAttribute("viewNtrButton", viewNtrButton);
			
			commonService.auditLog(authentication.getPrincipal().toString(), request, "viewGeneratedNTRFiles", "READ", "Details will be added for sequence no.: "+selectedFileSeq);
			return "RegulatoryReports/India/NPOTransactionReport/NTRFilesModal";
		}
		
		@RequestMapping(value="/updateNTRDetails", method=RequestMethod.POST)
		public  String updateNTRDetails(HttpServletRequest request, HttpServletResponse response,
				Authentication authentication)throws Exception{
			String selectedFileSeq = request.getParameter("selectedFileSeq");
			String userCode = authentication.getPrincipal().toString();
			Map<String, String> paramMap = new HashMap<String, String>();
			
			Enumeration enumObj =  request.getParameterNames();
			while(enumObj.hasMoreElements()){
				String paramName = (String) enumObj.nextElement();
				String paramValue = request.getParameter(paramName);
				paramMap.put(paramName, paramValue);
			}
			String result  = regulatoryReportsService.updateNTRDetails(paramMap, userCode, selectedFileSeq);
			
			
			request.setAttribute("selectedFileSeq", selectedFileSeq);
			String id = otherCommonService.getElementId();
			request.setAttribute("UNQID", id);
			
			commonService.auditLog(authentication.getPrincipal().toString(), request, "viewNTRFiles", "UPDATE", "Data Updated");
			return "RegulatoryReports/India/NPOTransactionReport/ViewGeneratedFile";
			
		}
		
		// GENERATED CBWTR FILES
		@RequestMapping(value="/viewGeneratedCBWTRFilesMaster", method=RequestMethod.POST)
		public String viewGeneratedCBWTRFilesMaster(HttpServletRequest request, HttpServletResponse response, 
				Authentication authentication) throws Exception{
			String moduleType = request.getParameter("moduleType");
			String viewFilePageUrl = request.getParameter("viewFilePageUrl");
			String viewCbwtrButton = request.getParameter("viewCbwtrButton");
			String reportingMonth = request.getParameter("1_REPORTINGMONTH"); 
			String reportingYear = request.getParameter("2_REPORTINGYEAR");
			//System.out.println("viewButton "+viewButton);
					
			String userCode = authentication.getPrincipal().toString();
			String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
			String ipAdress = request.getRemoteAddr();
					
			request.setAttribute("viewCbwtrButton", viewCbwtrButton);
			request.setAttribute("moduleType", moduleType);
			request.setAttribute("UNQID", otherCommonService.getElementId());
			request.setAttribute("SEARCHRESULT", regulatoryReportsService.viewGeneratedCBWTRFilesMaster(reportingMonth,reportingYear, moduleType, userCode, userRole, ipAdress));
			//System.out.println("resultData returned = "+genericMasterService.viewGeneratedCBWTRFilesMaster(reportingMonth,reportingYear, moduleType, userCode, userRole, ipAdress));
			commonService.auditLog(authentication.getPrincipal().toString(), request, "CBW TRANSACTION REPORT", "SEARCH", "Module Accessed");
			return viewFilePageUrl;
		}
		
		@RequestMapping(value="/editCBWTRDetails", method=RequestMethod.POST)
		public String editCBWTRDetails(HttpServletRequest request, HttpServletResponse response, Authentication authentication){
			//String UNQID = request.getParameter("unqId");
			String selectedFileSeq = request.getParameter("selectedFileSeq");
			String viewCbwtrButton = request.getParameter("viewCbwtrButton");
			
			request.setAttribute("UNQID", otherCommonService.getElementId());
			request.setAttribute("selectedFileSeq", selectedFileSeq);
			request.setAttribute("viewCbwtrButton", viewCbwtrButton);
			
			commonService.auditLog(authentication.getPrincipal().toString(), request, "viewGeneratedCBWTRFiles", "READ", "Details will be added for sequence no.: "+selectedFileSeq);
			return "RegulatoryReports/India/CBWTReport/CBWTRFilesModal";
		}
		
		@RequestMapping(value="/updateCBWTRDetails", method=RequestMethod.POST)
		public  String updateCBWTRDetails(HttpServletRequest request, HttpServletResponse response,
				Authentication authentication)throws Exception{
			String selectedFileSeq = request.getParameter("selectedFileSeq");
			String userCode = authentication.getPrincipal().toString();
			Map<String, String> paramMap = new HashMap<String, String>();
			
			Enumeration enumObj =  request.getParameterNames();
			while(enumObj.hasMoreElements()){
				String paramName = (String) enumObj.nextElement();
				String paramValue = request.getParameter(paramName);
				paramMap.put(paramName, paramValue);
			}
			String result  = regulatoryReportsService.updateCBWTRDetails(paramMap, userCode, selectedFileSeq);
			
			
			request.setAttribute("selectedFileSeq", selectedFileSeq);
			String id = otherCommonService.getElementId();
			request.setAttribute("UNQID", id);
			
			commonService.auditLog(authentication.getPrincipal().toString(), request, "viewCBWTRFiles", "UPDATE", "Data Updated");
			return "RegulatoryReports/India/CBWTReport/ViewGeneratedFile";
			
		}
		
		// Downloading regulatory files
		@RequestMapping(value="/downloadRegulatoryFiles", method=RequestMethod.GET)
		public ModelAndView downloadRegulatoryFiles(HttpServletRequest request, HttpServletResponse response, Authentication authentication){
			String fileName = request.getParameter("fileName");
			String filePath = request.getParameter("filePath");
			//System.out.println("fileName:  "+fileName+", filePath: "+filePath);
			String fileContent = "";
			BufferedWriter bufferedWriter = null;
			StringWriter stringWriter = null;
			try {
				BufferedReader bufferedReader = null;
				File inputFilePath = new File(filePath+File.separator+fileName);
					
				bufferedReader = new BufferedReader(new FileReader(inputFilePath));
				String currentLine;
				while ((currentLine = bufferedReader.readLine()) != null) {
					fileContent = fileContent + currentLine + System.getProperty("line.separator");
				}
				bufferedReader.close();
				
				stringWriter = new StringWriter();
				bufferedWriter = new BufferedWriter(stringWriter);
				bufferedWriter.write(fileContent);
				
				bufferedWriter.flush();
		        String fileData = stringWriter.toString();
				response.setContentType("APPLICATION/OCTET-STREAM");
		        String disHeader = "Attachment;Filename=\""+fileName+"\"";
		        response.setHeader("Content-disposition", disHeader);
		        ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
		        byteArrayOutputStream.write(fileData.getBytes());
		        // response.setContentLength(fileData.length());
		        byteArrayOutputStream.writeTo(response.getOutputStream());
		        byteArrayOutputStream.flush();
		        byteArrayOutputStream.close();
		        bufferedWriter.close();
		        
			} catch (IOException e) {
				e.printStackTrace();
			} catch (Exception e) {
				e.printStackTrace();
			}
			commonService.auditLog(authentication.getPrincipal().toString(), request, "REGULATORY REPORT", "DOWNLOAD", "File Downloaded = "+fileName);
			return null;
		}
		
		// Methods moved
	// 19.CTR
		@RequestMapping(value="/cashTransactionReport", method=RequestMethod.GET)
		public String cashTransactionReport(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
			String moduleType = request.getParameter("moduleType");
			request.setAttribute("MODULETYPE", moduleType);
			request.setAttribute("UNQID", otherCommonService.getElementId());
			String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
			request.setAttribute("MASTERSEARCHFRAME", genericMasterService.getModuleParameters(moduleType, 
				authentication.getPrincipal().toString(), userRole, request.getRemoteAddr()));
			//setAuditLogEntries(request, response, authentication, moduleType);
			
			commonService.auditLog(authentication.getPrincipal().toString(), request, "CTR", "OPEN", "Module Accessed");
			return "RegulatoryReports/India/CashTransactionReport/index";
		}
			
	// 20.NTR
		@RequestMapping(value="/npoTransactionReport", method=RequestMethod.GET)
		public String npoTransactionReport(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
			String moduleType = request.getParameter("moduleType");
			request.setAttribute("MODULETYPE", moduleType);
			request.setAttribute("UNQID", otherCommonService.getElementId());
			String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
			request.setAttribute("MASTERSEARCHFRAME", genericMasterService.getModuleParameters(moduleType, 
				authentication.getPrincipal().toString(), userRole, request.getRemoteAddr()));
			//setAuditLogEntries(request, response, authentication, moduleType);
			
			commonService.auditLog(authentication.getPrincipal().toString(), request, "NTR", "OPEN", "Module Accessed");
			return "RegulatoryReports/India/NPOTransactionReport/index";
		}

	// 21.CCR
		@RequestMapping(value="/counterfeitCurrencyReport", method=RequestMethod.GET)
		public String counterfeitCurrencyReport(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
			String moduleType = request.getParameter("moduleType");
			request.setAttribute("MODULETYPE", moduleType);
			request.setAttribute("UNQID", otherCommonService.getElementId());
			String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
			request.setAttribute("MASTERSEARCHFRAME", genericMasterService.getModuleParameters(moduleType, 
				authentication.getPrincipal().toString(), userRole, request.getRemoteAddr()));
			//setAuditLogEntries(request, response, authentication, moduleType);
			
			commonService.auditLog(authentication.getPrincipal().toString(), request, "CCR", "OPEN", "Module Accessed");
			return "RegulatoryReports/India/CounterfeitCurrencyReport/index";
		}

	// 22.CBWTR
		@RequestMapping(value="/cbwtReport", method=RequestMethod.GET)
		public String cbwtReport(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
			String moduleType = request.getParameter("moduleType");
			request.setAttribute("MODULETYPE", moduleType);
			request.setAttribute("UNQID", otherCommonService.getElementId());
			String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
			request.setAttribute("MASTERSEARCHFRAME", genericMasterService.getModuleParameters(moduleType, 
				authentication.getPrincipal().toString(), userRole, request.getRemoteAddr()));
			//setAuditLogEntries(request, response, authentication, moduleType);
			
			commonService.auditLog(authentication.getPrincipal().toString(), request, "CBWTR", "OPEN", "Module Accessed");
			return "RegulatoryReports/India/CBWTReport/index";
		}
}

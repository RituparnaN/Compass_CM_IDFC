package com.quantumdataengines.app.compass.controller;

import java.io.BufferedReader;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import com.quantumdataengines.app.compass.controller.reports.MultiSheetExcelViewChart;
import com.quantumdataengines.app.compass.controller.reports.MultiSheetExcelViewChartNew;
import com.quantumdataengines.app.compass.controller.reports.MultiSheetExcelViewChartSummary;
import com.quantumdataengines.app.compass.model.riskAssessment.MakerCheckerDataModel;
import com.quantumdataengines.app.compass.model.riskAssessmentNew.FormConfigurationModel;
import com.quantumdataengines.app.compass.model.riskAssessmentNew.FormDataModel;
import com.quantumdataengines.app.compass.otherservice.OtherCommonService;
import com.quantumdataengines.app.compass.service.CommonService;
import com.quantumdataengines.app.compass.service.riskAssessmentNew.RiskAssessmentNewService;

@Controller
@RequestMapping(value="/common")
public class RiskAssessmentControllerNew {
private static final Logger log = LoggerFactory.getLogger(CommonController.class);
	
	@Autowired
	private CommonService commonService;
	@Autowired
	private OtherCommonService otherCommonService;
	@Autowired
	private RiskAssessmentNewService riskAssessmentNewService;
	
	@RequestMapping(value="/riskAssessmentNew", method=RequestMethod.GET)
	public String riskAssessmentNew(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		String moduleType = request.getParameter("moduleType");
		String userCode = authentication.getPrincipal().toString();
		request.setAttribute("USERCODE", userCode);
		request.setAttribute("MODULETYPE", moduleType);
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("CURRENTROLE", request.getSession(false).getAttribute("CURRENTROLE") == null ? "N.A.":request.getSession(false).getAttribute("CURRENTROLE").toString());
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "RiskAssessmentNew", "OPEN", "Module Accessed");
		return "RiskAssessmentNew/index";
	}	
	@RequestMapping(value="/getRiskAssessmentSummary", method=RequestMethod.GET)
	public String riskAssessmentSummary(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		System.out.println("in here");
		String moduleType = request.getParameter("moduleType");
		int assessmentPeriod = Integer.parseInt(request.getParameter("assessmentPeriod"));
		String userCode = authentication.getPrincipal().toString();
		request.setAttribute("USERCODE", userCode);
		request.setAttribute("MODULETYPE", moduleType);
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("assessmentPeriod", assessmentPeriod);
		request.setAttribute("SUMMARYDETAILS", riskAssessmentNewService.getRASummaryData(assessmentPeriod) );
		
		request.setAttribute("CURRENTROLE", request.getSession(false).getAttribute("CURRENTROLE") == null ? "N.A.":request.getSession(false).getAttribute("CURRENTROLE").toString());
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "RiskAssessmentSummary", "OPEN", "Module Accessed");
		return "RiskAssessmentNew/riskAssessmentSummary";
	}	
	
	@RequestMapping(value="/questionnaireMasterNew", method=RequestMethod.GET)
	public String questionnaireMasterNew(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		String moduleType = request.getParameter("moduleType");
		request.setAttribute("MODULETYPE", moduleType);
		request.setAttribute("UNQID", otherCommonService.getElementId());
		String userCode = authentication.getPrincipal().toString();
		request.setAttribute("USERCODE", userCode);
		request.setAttribute("CURRENTROLE", request.getSession(false).getAttribute("CURRENTROLE") == null ? "N.A.":request.getSession(false).getAttribute("CURRENTROLE").toString());
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "QuestionnaireMasterNew", "OPEN", "Module Accessed");
		return "RiskAssessmentQuestionnaireMasterNew/index";
	}	
	
	@RequestMapping(value="/questionConfigurationForm", method=RequestMethod.POST)
	public String questionConfigurationForm(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		
		String assessmentUnit = request.getParameter("ASSESSMENTUNIT");
		String questionId = request.getParameter("QUESTIONID");
		System.out.println(assessmentUnit);
		
		String userCode = authentication.getPrincipal().toString();
		request.setAttribute("USERCODE", userCode);
		request.setAttribute("QUESTIONSFORMDETAILS", riskAssessmentNewService.getQuestionsFormDetails(assessmentUnit,""));
		request.setAttribute("ASSESSMENTUNIT", assessmentUnit);
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("QUESTIONID", questionId);
		request.setAttribute("CURRENTROLE", request.getSession(false).getAttribute("CURRENTROLE") == null ? "N.A.":request.getSession(false).getAttribute("CURRENTROLE").toString());
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "QuestionnaireMasterNew", "OPEN", "Module Accessed");
		return "RiskAssessmentQuestionnaireMasterNew/QuestionsConfigForm";
	}	
	
	@RequestMapping(value={"/saveRiskAssesesmentFormConfiguration"}, method=RequestMethod.POST)
	public ResponseEntity<String> saveRiskAssesesmentFormConfiguration(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String CURRENTROLE = (String) request.getSession(false).getAttribute("CURRENTROLE");
//		String data = request.getParameter("makerCheckerData");
		StringBuilder buffer = new StringBuilder();
	    BufferedReader reader = request.getReader();
	    String line;
	    while ((line = reader.readLine()) != null) {
	        buffer.append(line);
	        buffer.append(System.lineSeparator());
	    }
	    String data = buffer.toString();
	    String userCode = authentication.getPrincipal().toString();
	    String ipAddress = request.getRemoteAddr();
	    
	    FormConfigurationModel formConfigurationModel = new FormConfigurationModel(data);
		System.out.println(formConfigurationModel.questionsList.toString());
		riskAssessmentNewService.saveRiskAssesesmentFormConfiguration(formConfigurationModel);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "Risk Assessment New", "save form Configuration", "Module Accessed");
		return ResponseEntity.ok("Saved Successfully");
	}
	
	@RequestMapping(value={"/saveRiskAssesesmentForm"}, method=RequestMethod.POST)
	public ResponseEntity<String> saveRiskAssesesmentForm(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String CURRENTROLE = (String) request.getSession(false).getAttribute("CURRENTROLE");
		StringBuilder buffer = new StringBuilder();
		BufferedReader reader = request.getReader();
		String line;
		while ((line = reader.readLine()) != null) {
			buffer.append(line);
			buffer.append(System.lineSeparator());
		}
		String data = buffer.toString();
		String userName = authentication.getPrincipal().toString();
		String ipAddress = request.getRemoteAddr();
		System.out.println(data);
		FormDataModel formDataModel = new FormDataModel(data,userName,CURRENTROLE);
		
		riskAssessmentNewService.saveRiskAssesesmentForm(formDataModel);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "Risk Assessment Save", "save risk assessment form ", "Module Accessed");
		return ResponseEntity.ok("Saved Successfully");
	}
	
	@RequestMapping(value="/searchRiskAssessmentNew", method=RequestMethod.POST)
	public String searchCDDForm(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String COMPASSREFERENCENO = request.getParameter("COMPASSREFERENCENO");
		String ASSESSMENTUNIT = request.getParameter("ASSESSMENTUNIT");
		String CURRENTROLE = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String userCode = authentication.getPrincipal().toString();
		request.setAttribute("USERCODE", userCode);
		request.setAttribute("CURRENTROLE", CURRENTROLE);
		request.setAttribute("RISKASSESSMENTDATA", riskAssessmentNewService.searchRiskAssessmentData(ASSESSMENTUNIT, COMPASSREFERENCENO));
		request.setAttribute("UNQID", otherCommonService.getElementId());
		commonService.auditLog(authentication.getPrincipal().toString(), request, "Risk Assessment", "SEARCH", "Module Accessed");
		return "RiskAssessmentNew/SearchBottomPage";
	}
	
	@RequestMapping(value="/openNewRiskAssessmentNew", method=RequestMethod.POST)
	public String openNewRiskAssessment(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String assessmentUnit = request.getParameter("ASSESSMENTUNIT");
		String COMPASSREFERENCENO = "";
		String isNew = request.getParameter("ISNEWFORM");
		System.out.println(assessmentUnit);
		if(isNew.equals("Y")) {
			COMPASSREFERENCENO = riskAssessmentNewService.generateCompassRefNo();
		}
		else {
			COMPASSREFERENCENO = request.getParameter("CMREFNO");
		}
		
		System.out.println("compass ref no:"+COMPASSREFERENCENO);
		request.setAttribute("COMPASSREFERENCENO", COMPASSREFERENCENO);
		request.setAttribute("QUESTIONSFORMDETAILS", riskAssessmentNewService.getQuestionsFormDetails(assessmentUnit,COMPASSREFERENCENO));
		request.setAttribute("ASSESSMENTUNIT", assessmentUnit);
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("CURRENTROLE", request.getSession(false).getAttribute("CURRENTROLE") == null ? "N.A.":request.getSession(false).getAttribute("CURRENTROLE").toString());
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "QuestionnaireMasterNew", "OPEN", "Module Accessed");
		return "RiskAssessmentNew/questionsForm";

	}
	
	@RequestMapping(value={"/saveRaiseToRFINew"}, method=RequestMethod.POST)
	public ResponseEntity<Map<String,Object>> raiseToRfi(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String CURRENTROLE = (String) request.getSession(false).getAttribute("CURRENTROLE");
//		String data = request.getParameter("makerCheckerData");
		StringBuilder buffer = new StringBuilder();
	    BufferedReader reader = request.getReader();
	    String line;
	    while ((line = reader.readLine()) != null) {
	        buffer.append(line);
	        buffer.append(System.lineSeparator());
	    }
	    String data = buffer.toString();
	    String userCode = authentication.getPrincipal().toString();
	    String ipAddress = request.getRemoteAddr();
	    
		MakerCheckerDataModel makerCheckerData = new MakerCheckerDataModel(data, CURRENTROLE, userCode, ipAddress);
		Map<String, Object> caseRaisedData = riskAssessmentNewService.saveRaiseToRFI(makerCheckerData);
		System.out.println("qId:"+makerCheckerData.questionId);
		System.out.println("compass Reference NO.:"+makerCheckerData.compassRefNo);
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "Risk Assessment", "RAISETORFI", "Module Accessed");
		return ResponseEntity.ok(caseRaisedData);
	}
	
	@RequestMapping(value={"/getMakerCheckerListNew"}, method=RequestMethod.POST)
	public ResponseEntity<String> getMakerCheckerList(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		StringBuilder buffer = new StringBuilder();
	    BufferedReader reader = request.getReader();
	    String line;
	    while ((line = reader.readLine()) != null) {
	        buffer.append(line);
	        buffer.append(System.lineSeparator());
	    }
	    String data = buffer.toString();
	    System.out.println("string data:"+data);
	    String qId = new JSONObject(data).getString("qId");
	    String compassRefNo = new JSONObject(data).getString("compassRefNo");
	    System.out.println("row details:"+riskAssessmentNewService.getMakerCheckerList(qId,compassRefNo).toString());
		return ResponseEntity.ok(riskAssessmentNewService.getMakerCheckerList(qId,compassRefNo).toString());
	}
	
	@RequestMapping(value = "/generateCMReport", method=RequestMethod.GET) 
	public ModelAndView generateCMReport(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception {
		String compassRefNo = request.getParameter("compassRefNo");
		String userCode = authentication.getPrincipal().toString();
		String userRole = request.getSession(false) != null ? (String) request.getSession(false).getAttribute("CURRENTROLE") : "";
		String ipAddress = request.getRemoteAddr();
		
		Map<String, Object> mainMap = riskAssessmentNewService.generateCMReport(compassRefNo, userCode, userRole, ipAddress);
		Iterator<String> itr = mainMap.keySet().iterator();
		List<String> tabOrder = new Vector<String>();
		while(itr.hasNext()){
			tabOrder.add(itr.next());
		}
		SimpleDateFormat sdf = new SimpleDateFormat("ddMMyyyyHHmmss");
		Date date = new Date();
		mainMap.put("TABORDER", tabOrder);
		mainMap.put("FILENAME", compassRefNo+"_"+userCode+"_"+sdf.format(date));
		ModelAndView modelAndView = new ModelAndView(new MultiSheetExcelViewChart(), mainMap);
		//System.out.println("MAINMAP: "+mainMap);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "REPORTS", "DOWNLOAD", "File Downloaded");
		return modelAndView;	
	}
	
	@RequestMapping(value = "/generateCMReportNew", method=RequestMethod.GET) 
	public ModelAndView generateCMReportNew(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception {
		String compassRefNo = request.getParameter("compassRefNo");
		String assessmentUnit = request.getParameter("assessmentUnit");
		String userCode = authentication.getPrincipal().toString();
		String userRole = request.getSession(false) != null ? (String) request.getSession(false).getAttribute("CURRENTROLE") : "";
		String ipAddress = request.getRemoteAddr();
		
		Map<String, Object> mainMap = riskAssessmentNewService.generateCMReportNew(compassRefNo, assessmentUnit, userCode, userRole, ipAddress);
		Iterator<String> itr = mainMap.keySet().iterator();
		List<String> tabOrder = new Vector<String>();
		while(itr.hasNext()){
			tabOrder.add(itr.next());
		}
		SimpleDateFormat sdf = new SimpleDateFormat("ddMMyyyyHHmmss");
		Date date = new Date();
		mainMap.put("TABORDER", tabOrder);
		mainMap.put("FILENAME", compassRefNo+"_"+userCode+"_"+sdf.format(date));
		ModelAndView modelAndView = new ModelAndView(new MultiSheetExcelViewChartNew(), mainMap);
		//System.out.println("MAINMAP: "+mainMap);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "REPORTS", "DOWNLOAD", "File Downloaded");
		return modelAndView;	
	}
	
	@RequestMapping(value = "/generateCMReportSummary", method=RequestMethod.GET) 
	public ModelAndView generateCMReportSummary(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception {
		String assessmentPeriod = request.getParameter("ASSESSMENTPERIOD");
		System.out.println("In generateCMReportSummary controller assessmentPeriod: "+assessmentPeriod);
		String userCode = authentication.getPrincipal().toString();
		String userRole = request.getSession(false) != null ? (String) request.getSession(false).getAttribute("CURRENTROLE") : "";
		String ipAddress = request.getRemoteAddr();
		
		Map<String, Object> mainMap = riskAssessmentNewService.generateCMReportSummary(assessmentPeriod, userCode, userRole, ipAddress);
		Iterator<String> itr = mainMap.keySet().iterator();
		List<String> tabOrder = new Vector<String>();
		while(itr.hasNext()){
			tabOrder.add(itr.next());
		}
		SimpleDateFormat sdf = new SimpleDateFormat("ddMMyyyyHHmmss");
		Date date = new Date();
		mainMap.put("TABORDER", tabOrder);
		mainMap.put("FILENAME", assessmentPeriod+"_"+userCode+"_"+sdf.format(date));
		ModelAndView modelAndView = new ModelAndView(new MultiSheetExcelViewChartSummary(), mainMap);
		//System.out.println("MAINMAP: "+mainMap);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "REPORTS", "DOWNLOAD", "File Downloaded");
		return modelAndView;	
	}
	
	@RequestMapping(value="/mixedChartNew", method=RequestMethod.POST)
	public String chart(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String cmRefNo = request.getParameter("CRMREFNO");
		request.setAttribute("DATAPOINTS", riskAssessmentNewService.getGraphDataPointsNew(cmRefNo));
		
		return "RiskAssessmentNew/mixedChartNew";
	}
	
	@RequestMapping(value="/mixedChartSummary", method=RequestMethod.POST)
	public String chartSummary(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String assessmentPeriod = request.getParameter("ASSESSMENTPERIOD");
		System.out.println("In mixedChartSummary controller assessmentPeriod is "+assessmentPeriod);
		Object test = riskAssessmentNewService.getGraphDataPointsSummary(assessmentPeriod);
		System.out.println("TEST: "+test);
		request.setAttribute("DATAPOINTS", riskAssessmentNewService.getGraphDataPointsSummary(assessmentPeriod));
		
		return "RiskAssessmentNew/mixedChartSummary";
	}
	
	@RequestMapping(value={"/saveChartImageNew"}, method=RequestMethod.POST)
	public ResponseEntity<String> saveChartImage(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String CURRENTROLE = (String) request.getSession(false).getAttribute("CURRENTROLE");
//		String data = request.getParameter("makerCheckerData");
		StringBuilder buffer = new StringBuilder();
	    BufferedReader reader = request.getReader();
	    String line;
	    while ((line = reader.readLine()) != null) {
	        buffer.append(line);
	        buffer.append(System.lineSeparator());
	    }
	    String data = buffer.toString();
	    System.out.println("data:"+data);
	    JSONObject jObj = new JSONObject(data);
	    String ImageUrl = jObj.getString("data");
	    String imageId = riskAssessmentNewService.saveImageUrlData(ImageUrl);
		return ResponseEntity.ok(imageId);
	}
	
}
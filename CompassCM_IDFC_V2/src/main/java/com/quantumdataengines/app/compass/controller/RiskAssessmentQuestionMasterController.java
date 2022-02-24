package com.quantumdataengines.app.compass.controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.quantumdataengines.app.compass.otherservice.OtherCommonService;
import com.quantumdataengines.app.compass.service.CommonService;
import com.quantumdataengines.app.compass.service.master.GenericMasterService;
import com.quantumdataengines.app.compass.service.riskAssessmentQuestionMaster.RiskAssessmentQuestionMasterService;

@Controller
@RequestMapping(value= "/cmAdmin")
public class RiskAssessmentQuestionMasterController {
	
	@Autowired
	private CommonService commonService;
	@Autowired
	private OtherCommonService otherCommonService;
	@Autowired
	private RiskAssessmentQuestionMasterService riskAssessmentQuestionMasterService;
	@Autowired
	private GenericMasterService genericMasterService;
	
	@RequestMapping(value="/riskAssessmentQuestionList", method=RequestMethod.GET)
	public String getAssessmentQuestionList(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		String moduleType = request.getParameter("moduleType");
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String userCode = authentication.getPrincipal().toString();
		request.setAttribute("MASTERSEARCHFRAME", genericMasterService.getModuleParameters(moduleType, 
		userCode, userRole, request.getRemoteAddr()));
		request.setAttribute("MODULETYPE", moduleType);
		request.setAttribute("UNQID", otherCommonService.getElementId());
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "Risk Assessment Question List", "OPEN", "Module Accessed");
		return "RiskAssessmentQuestionMaster/index";
	}
		
	@RequestMapping(value="/getQuestionDetails", method=RequestMethod.GET)
	public String getQuestionDetails(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		String questionId = request.getParameter("questionId");
		String status = request.getParameter("status");
		//System.out.println(status);
		String questionVersion = request.getParameter("questionVersion");
		String moduleType = request.getParameter("moduleType");
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String userCode = authentication.getPrincipal().toString();
		String ipAddress = request.getRemoteAddr();
		String searchButton = request.getParameter("searchButton");
		//System.out.println(searchButton);

		request.setAttribute("QUESTIONDETAILS",riskAssessmentQuestionMasterService.getQuestionDetails(questionId,status,questionVersion,userCode,userRole,ipAddress));
		request.setAttribute("questionId", questionId);
		request.setAttribute("questionVersion", questionVersion);
		request.setAttribute("assessmentSection", request.getParameter("assessmentSection"));
		request.setAttribute("MODULETYPE", moduleType);
		request.setAttribute("USERROLE", userRole);
		request.setAttribute("USERCODE", userCode);
		request.setAttribute("searchButton", searchButton);
		request.setAttribute("UNQID", otherCommonService.getElementId());
		System.out.println(request.getParameter("assessmentSection"));
		commonService.auditLog(authentication.getPrincipal().toString(), request, "Risk Assessment Question List", "OPEN", "Module Accessed");
		return "RiskAssessmentQuestionMaster/QuestionDetails";
	}	
	
	@RequestMapping(value="/getRiskQuestionCategories", method=RequestMethod.GET)
	public String getRiskQuestionCategories(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		String moduleType = request.getParameter("moduleType");
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String userCode = authentication.getPrincipal().toString();
		request.setAttribute("MODULETYPE", moduleType);
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("USERROLE", userRole);
		request.setAttribute("USERCODE", userCode);
		request.setAttribute("QUESTIONCATEGORY", riskAssessmentQuestionMasterService.getQuestionCategory());
		commonService.auditLog(authentication.getPrincipal().toString(), request, "Risk Assessment Question Master", "OPEN", "Module Accessed");
		return "RiskAssessmentQuestionMaster/AddQuestions";
	}
	
	@RequestMapping(value="/addRiskAssessmentQuestion", method=RequestMethod.POST)
	@ResponseBody
	public String addRiskAssessmentQuestion(HttpServletRequest request, HttpServletResponse response,Authentication authentication)throws Exception{
		String userCode =authentication.getPrincipal().toString().replace(".", "");
		String userRole= (String) request.getSession(false).getAttribute("CURRENTROLE");;
		String ipAddress = request.getRemoteAddr();
		Map<String,String>questionData = new HashMap<String,String>();
		questionData.put("isEnabled", request.getParameter("isEnabled"));
		questionData.put("assessmentUnit", request.getParameter("assessmentUnit"));
		questionData.put("assessmentSectionCode", request.getParameter("assessmentSectionCode"));
		questionData.put("assessmentSubGroup", request.getParameter("assessmentSubGroup"));
		questionData.put("questionDescription", request.getParameter("questionDescription"));
		questionData.put("isFreeTextRequired", request.getParameter("isFreeTextRequired"));
		questionData.put("option1Id", request.getParameter("option1Id"));
		questionData.put("option1ImpactRiskValue", request.getParameter("option1ImpactRiskValue"));
		questionData.put("option1LikelihoodRiskValue", request.getParameter("option1LikelihoodRiskValue"));
		questionData.put("option2Id", request.getParameter("option2Id"));
		questionData.put("option2ImpactRiskValue", request.getParameter("option2ImpactRiskValue"));
		questionData.put("option2LikelihoodRiskValue", request.getParameter("option2LikelihoodRiskValue"));
		questionData.put("option3Id", request.getParameter("option3Id"));
		questionData.put("option3ImpactRiskValue", request.getParameter("option3ImpactRiskValue"));
		questionData.put("option3LikelihoodRiskValue", request.getParameter("option3LikelihoodRiskValue"));
		questionData.put("acOption1Name", request.getParameter("acOption1Name"));
		questionData.put("option1AssessmentCtrlScore", request.getParameter("option1AssessmentCtrlScore"));
		questionData.put("acOption2Name", request.getParameter("acOption2Name"));
		questionData.put("option2AssessmentCtrlScore", request.getParameter("option2AssessmentCtrlScore"));
		questionData.put("acOption3Name", request.getParameter("acOption3Name"));
		questionData.put("option3AssessmentCtrlScore", request.getParameter("option3AssessmentCtrlScore"));
		questionData.put("makerCode", request.getParameter("makerCode"));
		questionData.put("makerTimestamp", request.getParameter("makerTimestamp"));
		questionData.put("makerComments", request.getParameter("makerComments"));
		commonService.auditLog(authentication.getPrincipal().toString(), request, "Risk Assessment Question", "INSERT", "Module Accessed");
		return riskAssessmentQuestionMasterService.addRiskAssessmentQuestion(userCode,userRole,ipAddress,questionData);
	}
		
	@RequestMapping(value="/updateRiskAssessmentQuestion", method=RequestMethod.POST)
	@ResponseBody
	public String updateRiskAssessmentQuestion(HttpServletRequest request, HttpServletResponse response,Authentication authentication)throws Exception{
		System.out.println("qid = "+request.getParameter("questionId"));
		String userCode =authentication.getPrincipal().toString().replace(".", "");
		String userRole= (String) request.getSession(false).getAttribute("CURRENTROLE");;
		String ipAddress = request.getRemoteAddr();
		System.out.println("ip address = "+ipAddress);
		Map<String,String>questionData = new HashMap<String,String>();
		questionData.put("isEnabled", request.getParameter("isEnabled"));
		questionData.put("questionId", request.getParameter("questionId"));
		questionData.put("assessmentUnit", request.getParameter("assessmentUnit"));
		questionData.put("questionDescription", request.getParameter("questionDescription"));
		questionData.put("isFreeTextRequired", request.getParameter("isFreeTextRequired"));
		questionData.put("option1Id", request.getParameter("option1Id"));
		questionData.put("option1ImpactRiskValue", request.getParameter("option1ImpactRiskValue"));
		questionData.put("option1LikelihoodRiskValue", request.getParameter("option1LikelihoodRiskValue"));
		questionData.put("option2Id", request.getParameter("option2Id"));
		questionData.put("option2ImpactRiskValue", request.getParameter("option2ImpactRiskValue"));
		questionData.put("option2LikelihoodRiskValue", request.getParameter("option2LikelihoodRiskValue"));
		questionData.put("option3Id", request.getParameter("option3Id"));
		questionData.put("option3ImpactRiskValue", request.getParameter("option3ImpactRiskValue"));
		questionData.put("option3LikelihoodRiskValue", request.getParameter("option3LikelihoodRiskValue"));
		questionData.put("acOption1Name", request.getParameter("acOption1Name"));
		questionData.put("option1AssessmentCtrlScore", request.getParameter("option1AssessmentCtrlScore"));
		questionData.put("acOption2Name", request.getParameter("acOption2Name"));
		questionData.put("option2AssessmentCtrlScore", request.getParameter("option2AssessmentCtrlScore"));
		questionData.put("acOption3Name", request.getParameter("acOption3Name"));
		questionData.put("option3AssessmentCtrlScore", request.getParameter("option3AssessmentCtrlScore"));
		questionData.put("makerCode", request.getParameter("makerCode"));
		questionData.put("makerTimestamp", request.getParameter("makerTimestamp"));
		questionData.put("makerComments", request.getParameter("makerComments"));
		questionData.put("checkerCode", request.getParameter("checkerCode"));
		questionData.put("checkerTimestamp", request.getParameter("checkerTimestamp"));
		questionData.put("checkerComments", request.getParameter("checkerComments"));
		questionData.put("status", request.getParameter("status"));
		commonService.auditLog(authentication.getPrincipal().toString(), request, "Risk Assessment Question", "INSERT", "Module Accessed");
		return riskAssessmentQuestionMasterService.updateRiskAssessmentQuestion(userCode,userRole,ipAddress,questionData);
	}	
	
	@RequestMapping(value="/riskAssessmentSubGroup", method=RequestMethod.GET)
	public String riskAssessmentSubGroup(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		String moduleType = request.getParameter("moduleType");
		request.setAttribute("MODULETYPE", moduleType);
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("QUESTIONCATEGORY", riskAssessmentQuestionMasterService.getQuestionCategory());
		commonService.auditLog(authentication.getPrincipal().toString(), request, "Risk Assesssment", "OPEN", "Module Accessed");
		return "RiskAssessmentQuestionMaster/AddAssessmentSubGroup";
	}
	
	@RequestMapping(value="/riskAssessmentSubGroup", method=RequestMethod.POST)
	@ResponseBody
	public String addRiskAssessmentSubGroup(HttpServletRequest request, HttpServletResponse response,Authentication authentication)throws Exception{
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String userCode = authentication.getPrincipal().toString();
		String ipAddress = request.getRemoteAddr();
		Map<String,String>paramMap = new HashMap<String,String>();
		paramMap.put("assessmentUnit", request.getParameter("assessmentUnit"));
		paramMap.put("assessmentSectionCode", request.getParameter("assessmentSectionCode"));
		paramMap.put("assessmentSubGroup", request.getParameter("assessmentSubGroup"));
		paramMap.put("weightage", request.getParameter("weightage"));
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "ADD Risk Assessment Sub Group", "INSERT", "Module Accessed");
		return riskAssessmentQuestionMasterService.addRiskAssessmentSubGroup(paramMap,userCode,userRole,ipAddress);
	}

	@RequestMapping(value="/saveRiskAssessmentQuestionnaire", method=RequestMethod.POST)
	@ResponseBody
	public String saveRiskAssessmentQuestionnaire(HttpServletRequest request, HttpServletResponse response,Authentication authentication)throws Exception{
		String userCode =authentication.getPrincipal().toString().replace(".", "");
		String userRole= (String) request.getSession(false).getAttribute("CURRENTROLE");;
		String ipAddress = request.getRemoteAddr();
		Map<String,String>questionData = new HashMap<String,String>();
		questionData.put("questionId", request.getParameter("questionId") == null ? "" : request.getParameter("questionId"));
		questionData.put("isEnabled", request.getParameter("isEnabled"));
		questionData.put("assessmentUnit", request.getParameter("assessmentUnit"));
		questionData.put("assessmentSectionCode", request.getParameter("assessmentSectionCode"));
		questionData.put("assessmentSubGroup", request.getParameter("assessmentSubGroup"));
		questionData.put("question", request.getParameter("question"));
		questionData.put("isFreeTextRequired", request.getParameter("isFreeTextRequired"));
		questionData.put("option1Name", request.getParameter("option1Name"));
		questionData.put("option1ImpactRiskValue", request.getParameter("option1ImpactRiskValue"));
		questionData.put("option1LikelihoodRiskValue", request.getParameter("option1LikelihoodRiskValue"));
		questionData.put("option2Name", request.getParameter("option2Name"));
		questionData.put("option2ImpactRiskValue", request.getParameter("option2ImpactRiskValue"));
		questionData.put("option2LikelihoodRiskValue", request.getParameter("option2LikelihoodRiskValue"));
		questionData.put("option3Name", request.getParameter("option3Name"));
		questionData.put("option3ImpactRiskValue", request.getParameter("option3ImpactRiskValue"));
		questionData.put("option3LikelihoodRiskValue", request.getParameter("option3LikelihoodRiskValue"));
		questionData.put("acOption1Name", request.getParameter("acOption1Name"));
		questionData.put("option1AssessmentCtrlScore", request.getParameter("option1AssessmentCtrlScore"));
		questionData.put("acOption2Name", request.getParameter("acOption2Name"));
		questionData.put("option2AssessmentCtrlScore", request.getParameter("option2AssessmentCtrlScore"));
		questionData.put("acOption3Name", request.getParameter("acOption3Name"));
		questionData.put("option3AssessmentCtrlScore", request.getParameter("option3AssessmentCtrlScore"));
		questionData.put("makerCode", request.getParameter("makerCode"));
		questionData.put("makerTimestamp", request.getParameter("makerTimestamp"));
		questionData.put("makerComments", request.getParameter("makerComments"));
		questionData.put("status", request.getParameter("status"));
		questionData.put("checkerCode", request.getParameter("checkerCode"));
		questionData.put("checkerTimestamp", request.getParameter("checkerTimestamp"));
		questionData.put("checkerComments", request.getParameter("checkerComments"));
		if(request.getParameter("status").equals("P")) {
			commonService.auditLog(authentication.getPrincipal().toString(), request, "Risk Assessment Question", "INSERT", "Module Accessed");
		}else {
			commonService.auditLog(authentication.getPrincipal().toString(), request, "Risk Assessment Question", "UPDATE", "Module Accessed");
		}
		//System.out.println(riskAssessmentQuestionMasterService.saveRiskAssessmentQuestionnaire(questionData, userCode, userRole, ipAddress));
		return riskAssessmentQuestionMasterService.saveRiskAssessmentQuestionnaire(questionData, userCode, userRole, ipAddress);
	}
	
	@RequestMapping(value="/weightageConfig", method=RequestMethod.GET)
	public String getAssessmentWeightageList(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String userCode = authentication.getPrincipal().toString();
		
		request.setAttribute("WEIGHTAGELIST", riskAssessmentQuestionMasterService.getAssessmentWeightageList(userCode, userRole));
		request.setAttribute("UNQID", otherCommonService.getElementId());
		//System.out.println(riskAssessmentQuestionMasterService.getAssessmentWeightageList(userCode, userRole));
		commonService.auditLog(authentication.getPrincipal().toString(), request, "Risk Assessment Question List", "OPEN", "Module Accessed");
		return "RiskAssessmentWeightageConfiguration/index";
	}
	
	@RequestMapping(value="/saveWeightage", method=RequestMethod.POST)
	public @ResponseBody String saveWeightage(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		String fullData = request.getParameter("fullData");
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String userCode = authentication.getPrincipal().toString();
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "Risk Assessment Question List", "INSERT", "Module Accessed");
		return riskAssessmentQuestionMasterService.saveWeightage(fullData, userCode, userRole);
	}
}

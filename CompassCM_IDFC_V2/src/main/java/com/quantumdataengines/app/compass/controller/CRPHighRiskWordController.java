package com.quantumdataengines.app.compass.controller;

import java.util.ArrayList;
import java.util.Map;

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
import com.quantumdataengines.app.compass.service.crpHighRiskWord.CRPHighRiskWordService;

@Controller
@RequestMapping(value="/common")
public class CRPHighRiskWordController {
private static final Logger log = LoggerFactory.getLogger(CommonController.class);
	
	@Autowired
	private CommonService commonService;
	@Autowired
	private OtherCommonService otherCommonService;
	@Autowired
	private CRPHighRiskWordService crpHighRiskWordService;
	
	@RequestMapping(value="/crpHighRiskWord", method=RequestMethod.GET)
	public String crpHighRiskWord(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		
		String moduleType = request.getParameter("moduleType");
		request.setAttribute("MODULETYPE", moduleType);
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("USERROLE", request.getSession(false).getAttribute("CURRENTROLE") == null ? "N.A.":request.getSession(false).getAttribute("CURRENTROLE").toString());
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CRP HIGH RISK WORD", "OPEN", "Module Accessed");
		return "MasterModules/CRPHighRiskWord/index";
	}
	
	@RequestMapping(value="/openModalForNewEntry", method=RequestMethod.POST)
	public String openModalForNewEntry(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		String searchButton = request.getParameter("searchButton");
		String actionForModal = request.getParameter("actionForModal");
	    request.setAttribute("UNQID", otherCommonService.getElementId());
	    request.setAttribute("SEARCHBUTTON", searchButton);
	    request.setAttribute("ACTIONFORMODAL", actionForModal);
	    request.setAttribute("NEWSEQNO", crpHighRiskWordService.getNewSeqNo());
	    
	    commonService.auditLog(authentication.getPrincipal().toString(), request, "CRP HIGH RISK WORD", "OPEN", "Modal Opened for New Entry");
	    return "MasterModules/CRPHighRiskWord/recordsModal";
	}
	
	@RequestMapping(value="/saveOrUpdateWordRecord", method=RequestMethod.POST)
	public @ResponseBody String saveOrUpdateWordRecord(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		String fullData = request.getParameter("fullData");
		String actionToTake = request.getParameter("actionToTake");
		String currentUser = authentication.getPrincipal().toString();
		String currentRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String ipAddress = request.getRemoteAddr();
		//System.out.println(fullData);
	    request.setAttribute("UNQID", otherCommonService.getElementId());
	    
	    commonService.auditLog(authentication.getPrincipal().toString(), request, "CRP HIGH RISK WORD", "UPDATE", "CRP High Risk Word Record Saved/Updated");
	    return crpHighRiskWordService.saveOrUpdateWordRecord(fullData, actionToTake, currentUser, currentRole, ipAddress);
	}
	
	@RequestMapping(value="/getSeqNoDetails", method=RequestMethod.POST)
	public String getSeqNoDetails(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		String searchButton = request.getParameter("searchButton");
		String actionForModal = request.getParameter("actionForModal");
		String seqNo = request.getParameter("seqNo");
		
	    request.setAttribute("UNQID", otherCommonService.getElementId());
	    request.setAttribute("CURRENTUSER", authentication.getPrincipal().toString());
	    request.setAttribute("CURRENTROLE", (String) request.getSession(false).getAttribute("CURRENTROLE"));
	    request.setAttribute("IPADDRESS", request.getRemoteAddr());
	    request.setAttribute("SEARCHBUTTON", searchButton);
	    request.setAttribute("ACTIONFORMODAL", actionForModal);
	    request.setAttribute("RESULTDATA", crpHighRiskWordService.getSeqNoDetails(seqNo));
	    
	    commonService.auditLog(authentication.getPrincipal().toString(), request, "CRP HIGH RISK WORD", "OPEN", "Modal Opened for New Entry");
	    return "MasterModules/CRPHighRiskWord/recordsModal";
	}
	
	@RequestMapping(value="/approveOrReject", method=RequestMethod.POST)
	public @ResponseBody String approveOrReject(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		String action = request.getParameter("action");
		String seqNo = request.getParameter("seqNo");
		String checkerComments = request.getParameter("checkerComments");
		String currentUser = authentication.getPrincipal().toString();
		String currentRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String ipAddress = request.getRemoteAddr();
		//System.out.println(fullData);
	    request.setAttribute("UNQID", otherCommonService.getElementId());
	    
	    commonService.auditLog(authentication.getPrincipal().toString(), request, "CRP HIGH RISK WORD", "APPROVE/REJECT", "CRP High Risk Word Record Approved/Rejected");
	    return crpHighRiskWordService.approveOrReject(action, seqNo, checkerComments, currentUser, currentRole, ipAddress);
	}
	
}
package com.quantumdataengines.app.compass.controller.voiceOperation;

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

@Controller
@RequestMapping(value="/common")
public class VoiceOperation {
	@Autowired
	private CommonService commonService;
	@Autowired
	private OtherCommonService otherCommonService;
	
	@RequestMapping(value = "/voiceCommandOperationPage", method=RequestMethod.GET) 
	public String getDashboardTabView(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception {
		String fromDate = request.getParameter("fromDate");
		String toDate = request.getParameter("toDate");
		String sourceSystem = request.getParameter("sourceSystem");
		String userCode = authentication.getPrincipal().toString();
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("FromDate", fromDate);
		request.setAttribute("ToDate", toDate);
		request.setAttribute("SourceSystem", sourceSystem);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "VOICE OPERATION", "READ", "Module Accessed");
	    return "VoiceOperation/commandOperationPage";
    }
	
	
	@RequestMapping(value = "/mainVoiceOperations", method=RequestMethod.GET) 
	public @ResponseBody String mainVoiceOperations(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception {
		String result = "";
		String command = request.getParameter("command");
		if(command.equalsIgnoreCase("how many alerts are there for the day")){
			result = "Total 20 alerts have been generated for the day";
		}else if(command.equalsIgnoreCase("how many suspicions have been filed in the day")){
			result = "Total 6 suspicions have been filed in the day";
		}else if(command.equalsIgnoreCase("who has closed maximum number of alerts")){
			result = "AMLUser has closed maximum 12 alerts";
		}else if(command.equalsIgnoreCase("How many reports are pending to be filed")){
			result = "Cash Transaction report is yet to be filed, due date is 15th January, 2018"+
					"NTR report is yet to be filed, due date is 15th January, 2018"+
					"CBTR report is yet to be filed, due date is 15th January, 2018"+
					"As of now 4 STRs have been filed in this month, 3 has been approved but yet to be filed.";
		}
		commonService.auditLog(authentication.getPrincipal().toString(), request, "VOICE OPERATION", "ACCESS", "Module Accessed");
	    return result;
    }

}

package com.quantumdataengines.app.compass.controller.caseWorkFlow;

import java.util.Enumeration;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.quantumdataengines.app.compass.otherservice.OtherCommonService;
import com.quantumdataengines.app.compass.service.CommonService;

@Controller
@RequestMapping("/user")
public class ACWF_UserController {
	private static final Logger log = LoggerFactory.getLogger(ACWF_UserController.class);
	
	@Autowired
	private CommonService commonService;
	@Autowired
	private OtherCommonService otherCommonService;
	
	
	@RequestMapping(value="/pendingCase", method=RequestMethod.GET)
	public String pendingCase(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		/*
		Enumeration<String> paramEnum = request.getParameterNames();
		while (paramEnum.hasMoreElements()) {
			String paramName = paramEnum.nextElement();
			String paramValue = request.getParameter(paramName);
		}
		*/
		// return "MasterModules/InvestigationTools/TransactionDetails/index";
		commonService.auditLog(authentication.getPrincipal().toString(), request, "PENDING CASES", "OPEN", "Module Accessed");
		return "AMLCaseWorkFlow/User/PendingCases/index";
	}
}

package com.quantumdataengines.app.compass.controller;

import java.io.File;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.session.SessionInformation;
import org.springframework.security.core.session.SessionRegistryImpl;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.plivo.helper.api.client.RestAPI;
import com.plivo.helper.api.response.message.MessageResponse;
import com.plivo.helper.exception.PlivoException;
import com.quantumdataengines.app.compass.model.DomainUser;
import com.quantumdataengines.app.compass.otherservice.OtherCommonService;
import com.quantumdataengines.app.compass.schema.Configuration;
import com.quantumdataengines.app.compass.schema.Provider;
import com.quantumdataengines.app.compass.service.CommonService;
import com.quantumdataengines.app.compass.service.admin.AdminService;
import com.quantumdataengines.app.compass.service.master.GenericMasterService;
import com.quantumdataengines.app.compass.util.CommonUtil;
import com.quantumdataengines.app.compass.util.CompassSystemInfoHolder;
import com.quantumdataengines.app.compass.util.SessionContextHolder;

@Controller
//@RequestMapping(value="/admin")
@RequestMapping(value={"/admin","/amlo","/mlro","/mlroL1","/mlroL2"})
public class AdminController {
	private static final Logger log = LoggerFactory.getLogger(AdminController.class);
	
	@Autowired
	private AdminService adminService;
	@Autowired
	private CommonService commonService;
	@Autowired
	private OtherCommonService otherCommonService;
	@Autowired
	private SessionRegistryImpl sessionRegistry;
	@Autowired
	private GenericMasterService genericMasterService;
    private ServletContext context; 
	/*
	@RequestMapping(value={"/","/index"}, method=RequestMethod.GET)
	public String getAdminIndex(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		DomainUser domainUser = (DomainUser) authentication.getDetails();
		log.info("Opening admin index for : "+domainUser.getFirstName()+" "+domainUser.getLastName());
		
		Configuration config = commonService.getUserConfiguration();
		String path = config.getPaths().getIndexingPath()+File.separator+"NEWFOLDER";
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "ADMIN", "OPEN", "Module Accessed");
				
		return "adminIndexTemplete";
	}
	*/
	@RequestMapping(value="/systemParameters", method=RequestMethod.GET)
	public String systemParameters(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		Configuration config = commonService.getUserConfiguration();
		config.getAuthentication().getProvider();
		if(config.getAuthentication().getProvider().equals(Provider.DATABASE)){			
			request.setAttribute("AUTH", "DATABASE");
		}else{
			request.setAttribute("AUTH", "LDAP");
		}
		request.setAttribute("ROLE", (String) request.getSession(false).getAttribute("CURRENTROLE"));
		commonService.auditLog(authentication.getPrincipal().toString(), request, "SYSTEM PARAMETER", "OPEN", "Module Accessed");
		return "system_parameters/index";
	}
	
	@RequestMapping(value="/getSystemParameter", method=RequestMethod.POST)
	public @ResponseBody Map<String, String> getSystemParameter(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		commonService.auditLog(authentication.getPrincipal().toString(), request, "SYSTEM PARAMETER", "OPEN", "Module Accessed");
		return commonService.initilizingDBSystemParameters();
	}
	
	@RequestMapping(value="/saveSystemParameter", method=RequestMethod.POST)
	public @ResponseBody String saveSystemParameter(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		@SuppressWarnings("unchecked")
		Map<String, String[]> rawSystemParameters = request.getParameterMap();
		Map<String, String> systemParameters = new HashMap<String, String>();
		Iterator<String> paramItr = rawSystemParameters.keySet().iterator();
		while (paramItr.hasNext()) {
			String param = paramItr.next();
			String value = rawSystemParameters.get(param)[0];
			if(param.equals("EMAILPASSSWORD"))
				value = value.replace(" ", "+");
			systemParameters.put(param, value);
			
		}
		
		String message = adminService.saveSystemParameters(systemParameters);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "SYSTEM PARAMETER", "INSERT", "Data Saved");
		return message;
	}
	
	@RequestMapping(value="/getAllLoggedInUser", method=RequestMethod.POST)
	public @ResponseBody Map<String, Object> getAllLoggedInUser(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		List<Map<String, String>> getAllUserList = new ArrayList<Map<String, String>>();
		Map<String, HttpSession> allActiveSession = SessionContextHolder.getAllSessionActive();
		List<String> allActiveSessionIds = SessionContextHolder.getAllSessionIdsActive();		
		
		for(String sessionId : allActiveSessionIds){
			Map<String, String> userDetails = new HashMap<String, String>();
			HttpSession userSession = allActiveSession.get(sessionId);
			if(userSession != null){
				userDetails.put("SESSIONID", "<button class=\"btn btn-danger btn-xs\" onclick=\"dismissSession('"+sessionId+"')\">Dismiss</button>");
				userDetails.put("USERCODE", (String) userSession.getAttribute("USERCODE"));
				userDetails.put("ROLE", (String) userSession.getAttribute("CURRENTROLE"));
				userDetails.put("TERMINAL", (String) userSession.getAttribute("TERMINAL"));
				userDetails.put("CREATIONDATE", otherCommonService.getFormattedDate(new Date(userSession.getCreationTime()), "dd-MM-yyyy hh:mm aaa"));
				long min = (new Date().getTime() - userSession.getLastAccessedTime())/60000;
				userDetails.put("LASTACCESSED", otherCommonService.changeToDayTimeMin(new Long(min).toString()));
				getAllUserList.add(userDetails);
			}
		}
		List<Map<String, String>> resultMap = commonService.updateUsersSessionList(getAllUserList);
		
		Map<String, Object> finalMap = new HashMap<String, Object>();
		finalMap.put("draw", "1");
		finalMap.put("recordsTotal", resultMap.size());
		finalMap.put("recordsFiltered", resultMap.size());
		finalMap.put("data", resultMap);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "ADMIN", "READ", "Module Accessed");
		return finalMap;
	}
	
	@RequestMapping(value="/removeSessionForContext", method=RequestMethod.POST)
	public @ResponseBody String removeSessionForContext(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String sessionId = request.getParameter("SESSIONID");
		SessionInformation sessionInfo = sessionRegistry.getSessionInformation(sessionId);
		sessionInfo.expireNow();
		commonService.auditLog(authentication.getPrincipal().toString(), request, "ADMIN", "DELETE", "Data Deleted");
		return "Session terminated";
	}
	
	@RequestMapping(value="/getSystemInfo", method=RequestMethod.POST)
	public @ResponseBody Map<String, String> getSystemInfo(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		commonService.auditLog(authentication.getPrincipal().toString(), request, "ADMIN", "OPEN", "Module Accessed");
		return CompassSystemInfoHolder.getSystemAllInfo();
	}
	
	//29. auditLog
	@RequestMapping(value="/auditLog", method=RequestMethod.GET)
	public String auditLog(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String moduleType = request.getParameter("moduleType");
		request.setAttribute("MODULETYPE", moduleType);
		request.setAttribute("UNQID", otherCommonService.getElementId());
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		request.setAttribute("MASTERSEARCHFRAME", genericMasterService.getModuleParameters(moduleType, 
				authentication.getPrincipal().toString(), userRole, request.getRemoteAddr()));
		/*commonService.auditLog(authentication.getPrincipal().toString(), request, "ADMIN", "OPEN", "Module Accessed");*/
		commonService.auditLog(authentication.getPrincipal().toString(), request, "ADMIN", "OPEN", "Audit Log Module Accessed");
		return "AuditLog/index";
	}

	//31. systemLoginLog
	@RequestMapping(value="/systemLoginLog", method=RequestMethod.GET)
	public String systemLoginLog(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String moduleType = request.getParameter("moduleType");
		request.setAttribute("MODULETYPE", moduleType);
		request.setAttribute("UNQID", otherCommonService.getElementId());
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		request.setAttribute("MASTERSEARCHFRAME", genericMasterService.getModuleParameters(moduleType, 
				authentication.getPrincipal().toString(), userRole, request.getRemoteAddr()));
		commonService.auditLog(authentication.getPrincipal().toString(), request, "ADMIN", "OPEN", "System Login Log Module Accessed");
		return "SystemLoginLog/index";
	}

	//30. plivoSettings
	@RequestMapping(value="/getPlivoSettings", method=RequestMethod.POST)
	public String getPlivoSettings(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("PLIVOSETTINGS", adminService.getPlivoSettings());
		/*commonService.auditLog(authentication.getPrincipal().toString(), request, "ADMIN", "READ", "Module Accessed");*/
		commonService.auditLog(authentication.getPrincipal().toString(), request, "ADMIN", "READ", "Plivo Settings Accessed");
		return "common/PlivoSettings";
	}
	
	@RequestMapping(value="/updatePlivoSettings", method=RequestMethod.POST)
	public @ResponseBody String updatePlivoSettings(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String authId = request.getParameter("authId");
		String authToken = request.getParameter("authToken");
		String sourceNo = request.getParameter("sourceNo");
		String destNo = request.getParameter("destNo");
		
		request.setAttribute("PLIVOSETTINGS", adminService.getPlivoSettings());
		/*commonService.auditLog(authentication.getPrincipal().toString(), request, "ADMIN", "READ", "Module Accessed");*/
		commonService.auditLog(authentication.getPrincipal().toString(), request, "ADMIN", "UPDATE", "Plivo Settings Updated");
		return adminService.updatePlivoSettings(authId,authToken,sourceNo,destNo);
	}
	
	@RequestMapping(value="/sendTestMessage", method=RequestMethod.POST)
	public @ResponseBody String sendMessage(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String message = "";
		Map<String, String> plivoSettings = adminService.getPlivoSettings();
		System.out.println(plivoSettings);
		RestAPI api = new RestAPI(plivoSettings.get("AUTHID"), plivoSettings.get("AUTHTOKEN"), "v1");

		LinkedHashMap<String, String> parameters = new LinkedHashMap<String, String>();
        parameters.put("src", plivoSettings.get("SOURCENUMBER"));
        parameters.put("dst", request.getParameter("plivoTestDestNo")); 
        parameters.put("text", request.getParameter("plivoTestMsg"));
        parameters.put("url", "http://example.com/report/");
        parameters.put("method", "GET");
        System.out.println("message="+message);

        try {
            MessageResponse msgResponse = api.sendMessage(parameters);
            message = msgResponse.message;
            
            if (msgResponse.serverCode == 202) {
                adminService.savePlivoMessage(msgResponse.messageUuids.get(0).toString(), plivoSettings.get("AUTHID"), plivoSettings.get("AUTHTOKEN"), 
						authentication.getPrincipal().toString(), "TESTSMS");
            } else {
            	message = msgResponse.error;
            }
        
        } catch (PlivoException e) {
        	message = e.getLocalizedMessage();
        }
        commonService.auditLog(authentication.getPrincipal().toString(), request, "ADMIN", "INSERT", "Text Message Sent");
		return message;
	}
}
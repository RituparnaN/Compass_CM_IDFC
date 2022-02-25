package com.quantumdataengines.app.compass.controller;

import java.util.HashMap;
import java.util.Iterator;
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

import com.quantumdataengines.app.compass.model.DomainUser;
import com.quantumdataengines.app.compass.schema.Configuration;
import com.quantumdataengines.app.compass.schema.Provider;
import com.quantumdataengines.app.compass.service.CommonService;
import com.quantumdataengines.app.compass.service.admin.AdminService;
import com.quantumdataengines.app.compass.service.checker.CheckerService;

@Controller
@RequestMapping(value= "/cmUAMChecker")
public class CheckerController {
	
	private static final Logger log = LoggerFactory.getLogger(CheckerController.class);
	@Autowired
	private CheckerService checkerService;
	@Autowired
	private CommonService commonService;
	@Autowired
	private AdminService adminService;
	
	/*@RequestMapping(value={"/","/index"}, method=RequestMethod.GET)
	public String getAdminIndex(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		DomainUser domainUser = (DomainUser) authentication.getDetails();
		log.info("Opening checker index for : "+domainUser.getFirstName()+" "+domainUser.getLastName());
		//commonService.auditLog(authentication.getPrincipal().toString(), request, "ALERTCONFIGURATION", "OPEN", "Module Accessed");
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CHECKER", "OPEN", "Module Accessed");
		return "checkerIndexTemplete";
	}*/
	
	@RequestMapping(value="/approveUser", method=RequestMethod.GET)
	public String approveUser(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{		
		DomainUser domainUser = (DomainUser) authentication.getDetails();
		String loggedInUsercode = domainUser.getUsername();
		
		request.setAttribute("ALLUSERCODE", checkerService.getAllUserForCheck(loggedInUsercode));
		//System.out.println("controller = "+checkerService.getAllUserForCheck(loggedInUsercode)); 
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CHECKER", "OPEN", "Module Accessed");
		return "UserChecking/index";
	}
	
	@RequestMapping(value="/approveIPAddress", method=RequestMethod.GET)
	public String approveIPAddress(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		request.setAttribute("ALLIPADDRESS", checkerService.getAllIPAddressForCheck());
		/*commonService.auditLog(authentication.getPrincipal().toString(), request, "ALERTCONFIGURATION", "OPEN", "Module Accessed");*/
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CHECKER", "OPEN", "Module Accessed");
		return "IPAddressChecking/index";
	}
	
	@RequestMapping(value="/getIPDetailsForChecker", method=RequestMethod.POST)
	public String getIPDetailsForChecker(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String ipmakercode = request.getParameter("ipmakercode");
		String ipaddress = ipmakercode.split(",")[0];
		String makerCode = ipmakercode.split(",")[1];
		request.setAttribute("IPDETAILS", checkerService.getIPDetailsForChecker(ipaddress, makerCode));
		/*commonService.auditLog(authentication.getPrincipal().toString(), request, "ALERTCONFIGURATION", "READ", "Module Accessed");*/
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CHECKER", "READ", "Module Accessed");
		return "IPAddressChecking/SearchButtomFrame";
	}
	
	@RequestMapping(value="/checkIPAddressApprove", method=RequestMethod.POST)
	public @ResponseBody String checkIPAddressApprove(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String makercode = request.getParameter("makercode");
		String remarks = request.getParameter("remakrs");	
		String ipaddress = request.getParameter("ipaddress");	
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CHECKER", "INSERT", "IP Address Approved: "+ipaddress);
		return checkerService.approveIPAddress(ipaddress, makercode, remarks, authentication.getPrincipal().toString());
	}
	
	@RequestMapping(value="/checkIPAddressReject", method=RequestMethod.POST)
	public @ResponseBody String checkIPAddressReject(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String makercode = request.getParameter("makercode");
		String remarks = request.getParameter("remakrs");
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CHECKER", "INSERT", "IP Address Rejected");
		return checkerService.rejectIPAddress(makercode, remarks, authentication.getPrincipal().toString());
	}
	
	@RequestMapping(value="/getUserDetailsForChecker", method=RequestMethod.POST)
	public String getUserDetailsForChecker(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String[] userDetails = request.getParameter("userDetails").split(",");
		String userCode = userDetails[0];
		String makerCode = userDetails[1];
		request.setAttribute("USERDETAILS", checkerService.getUserDetailsForCheck(userCode, makerCode));
		request.setAttribute("MAKERCODE", userDetails[1]);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CHECKER", "READ", "Module Accessed");
		return "UserChecking/SearchButtomFrame";
	}
	
	@RequestMapping(value="/checkUserApprove", method=RequestMethod.POST)
	public @ResponseBody String checkUserApprove(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String makercode = request.getParameter("makercode");
		String remakrs = request.getParameter("remakrs");
		String userCode = request.getParameter("userCode");		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CHECKER", "INSERT", "User Approved: "+userCode);
		return checkerService.checkUserApprove(userCode, makercode, remakrs, authentication.getPrincipal().toString());
	}
	
	@RequestMapping(value="/checkUserReject", method=RequestMethod.POST)
	public @ResponseBody String checkUserReject(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String makercode = request.getParameter("makercode");
		String remakrs = request.getParameter("remakrs");
		String userCode = request.getParameter("userCode");
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CHECKER", "INSERT", "User Rejected: "+userCode);
		return checkerService.checkUserReject(userCode, makercode, remakrs, authentication.getPrincipal().toString());
	}
	

	
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
}

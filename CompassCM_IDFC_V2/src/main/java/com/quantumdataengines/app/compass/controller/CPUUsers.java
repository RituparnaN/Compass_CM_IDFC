package com.quantumdataengines.app.compass.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.quantumdataengines.app.compass.model.DomainUser;

@Controller
public class CPUUsers {
	private static final Logger log = LoggerFactory.getLogger(CPUUsers.class);
	
	@RequestMapping(value={"/cpuadmin/","/cpuadmin/index"}, method=RequestMethod.GET)
	public String getCpuAdminIndex(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		DomainUser domainUser = (DomainUser) authentication.getDetails();
		log.info("Opening admin index for : "+domainUser.getFirstName()+" "+domainUser.getLastName());
		return "cpuAdminIndexTemplete";
	}
	
	@RequestMapping(value={"/cpuchecker/","/cpuchecker/index"}, method=RequestMethod.GET)
	public String getCpuCheckerIndex(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		DomainUser domainUser = (DomainUser) authentication.getDetails();
		log.info("Opening admin index for : "+domainUser.getFirstName()+" "+domainUser.getLastName());
		return "cpuCheckerIndexTemplete";
	}
	
	@RequestMapping(value="/cpuChecker/CPUCaseWorkFlowChecker", method=RequestMethod.GET)
	public String CPUCaseWorkFlowChecker(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		return "CPUChecker/CPUCaseWorkflow/index";
	}
	
	@RequestMapping(value={"/cpumaker/","/cpumaker/index"}, method=RequestMethod.GET)
	public String getCpuMakerIndex(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		DomainUser domainUser = (DomainUser) authentication.getDetails();
		log.info("Opening admin index for : "+domainUser.getFirstName()+" "+domainUser.getLastName());
		return "cpuMakerIndexTemplete";
	}
}

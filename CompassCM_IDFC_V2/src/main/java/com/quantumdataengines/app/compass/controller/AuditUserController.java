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
// @RequestMapping(value="/audituser")
public class AuditUserController {
private static final Logger log = LoggerFactory.getLogger(AdminController.class);
	/*
	@RequestMapping(value={"/","/index"}, method=RequestMethod.GET)
	public String getUserIndex(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		DomainUser domainUser = (DomainUser) authentication.getDetails();
	*/	
		/*log.info("Opening AMLUser index for : "+domainUser.getFirstName()+" "+domainUser.getLastName());*/
    /*
		log.info("Opening Audit User index for : "+domainUser.getFirstName()+" "+domainUser.getLastName());
		return "auditUserIndexTemplete";
	}
	*/
	@RequestMapping(value={"/audituser/","/audituser/index"}, method=RequestMethod.GET)
	public String getAuditUserIndex(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		DomainUser domainUser = (DomainUser) authentication.getDetails();
		/*log.info("Opening AMLUser index for : "+domainUser.getFirstName()+" "+domainUser.getLastName());*/
		log.info("Opening Audit User index for : "+domainUser.getFirstName()+" "+domainUser.getLastName());
		return "auditUserIndexTemplete";
	}
	
	@RequestMapping(value={"/btguser/","/btguser/index"}, method=RequestMethod.GET)
	public String getBTGUserIndex(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		DomainUser domainUser = (DomainUser) authentication.getDetails();
		log.info("Opening BTG User index for : "+domainUser.getFirstName()+" "+domainUser.getLastName());
		return "btgUserIndexTemplete";
	}
	
	@RequestMapping(value={"/ituser/","/ituser/index"}, method=RequestMethod.GET)
	public String getITUserIndex(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		DomainUser domainUser = (DomainUser) authentication.getDetails();
		log.info("Opening IT User index for : "+domainUser.getFirstName()+" "+domainUser.getLastName());
		return "itUserIndexTemplete";
	}
	
	@RequestMapping(value={"/uamReportsReview/","/uamReportsReview/index"}, method=RequestMethod.GET)
	public String getUAMReportsReviewIndex(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		DomainUser domainUser = (DomainUser) authentication.getDetails();
		log.info("Opening UAMReportsReview User index for : "+domainUser.getFirstName()+" "+domainUser.getLastName());
		return "uamReportsReviewIndexTemplete";
	}
}

package com.quantumdataengines.app.compass.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.quantumdataengines.app.compass.model.DomainUser;
import com.quantumdataengines.app.compass.otherservice.OtherCommonService;

@Controller
// @RequestMapping(value="/amluser")
public class AMLUserController {

	private static final Logger log = LoggerFactory.getLogger(AdminController.class);

	@Autowired
	private OtherCommonService otherCommonService;
	
	/*
	@RequestMapping(value={"/","/index"}, method=RequestMethod.GET)
	public String getUserIndex(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		DomainUser domainUser = (DomainUser) authentication.getDetails();
		log.info("Opening AMLUser index for : "+domainUser.getFirstName()+" "+domainUser.getLastName());
		return "amlUserIndexTemplete";
	}
	*/

	@RequestMapping(value={"/amluser/","/amluser/index"}, method=RequestMethod.GET)
	public String getAMLUserIndex(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		DomainUser domainUser = (DomainUser) authentication.getDetails();
		request.setAttribute("UNQID", otherCommonService.getElementId());
		log.info("Opening AMLUser index for : "+domainUser.getFirstName()+" "+domainUser.getLastName());
		return "amlUserIndexTemplete";
	}

	@RequestMapping(value={"/amluserL1/","/amluserL1/index"}, method=RequestMethod.GET)
	public String getAMLUserL1Index(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		DomainUser domainUser = (DomainUser) authentication.getDetails();
		request.setAttribute("UNQID", otherCommonService.getElementId());
		log.info("Opening AMLUser index L1 for : "+domainUser.getFirstName()+" "+domainUser.getLastName());
		return "amlUserL1IndexTemplete";
	}

	@RequestMapping(value={"/amluserL2/","/amluserL2/index"}, method=RequestMethod.GET)
	public String getAMLUserL2Index(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		DomainUser domainUser = (DomainUser) authentication.getDetails();
		request.setAttribute("UNQID", otherCommonService.getElementId());
		log.info("Opening AMLUser index L2 for : "+domainUser.getFirstName()+" "+domainUser.getLastName());
		return "amlUserL2IndexTemplete";
	}

	@RequestMapping(value={"/amluserL3/","/amluserL3/index"}, method=RequestMethod.GET)
	public String getAMLUserL3Index(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		DomainUser domainUser = (DomainUser) authentication.getDetails();
		request.setAttribute("UNQID", otherCommonService.getElementId());
		log.info("Opening AMLUser index L3 for : "+domainUser.getFirstName()+" "+domainUser.getLastName());
		return "amlUserL3IndexTemplete";
	}
}

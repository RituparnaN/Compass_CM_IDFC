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
// @RequestMapping(value="/mlro")
public class MLROController {

	private static final Logger log = LoggerFactory.getLogger(AdminController.class);

	@Autowired
	private OtherCommonService otherCommonService;
	
	/*
	@RequestMapping(value={"/","/index"}, method=RequestMethod.GET)
	public String getUserIndex(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		DomainUser domainUser = (DomainUser) authentication.getDetails();
		log.info("Opening MLRO index for : "+domainUser.getFirstName()+" "+domainUser.getLastName());
		return "mlroIndexTemplete";
	}
	*/

	@RequestMapping(value={"/mlro/","/mlro/index"}, method=RequestMethod.GET)
	public String getMLROIndex(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		DomainUser domainUser = (DomainUser) authentication.getDetails();
		request.setAttribute("UNQID", otherCommonService.getElementId());
		log.info("Opening MLRO index for : "+domainUser.getFirstName()+" "+domainUser.getLastName());
		return "mlroIndexTemplete";
	}
	
	@RequestMapping(value={"/mlroL1/","/mlroL1/index"}, method=RequestMethod.GET)
	public String getMLROL1Index(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		DomainUser domainUser = (DomainUser) authentication.getDetails();
		request.setAttribute("UNQID", otherCommonService.getElementId());
		log.info("Opening MLROL1 index for : "+domainUser.getFirstName()+" "+domainUser.getLastName());
		return "mlroL1IndexTemplete";
	}
	
	@RequestMapping(value={"/mlroL2/","/mlroL2/index"}, method=RequestMethod.GET)
	public String getMLROL2Index(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		DomainUser domainUser = (DomainUser) authentication.getDetails();
		request.setAttribute("UNQID", otherCommonService.getElementId());
		log.info("Opening MLROL2 index for : "+domainUser.getFirstName()+" "+domainUser.getLastName());
		return "mlroL2IndexTemplete";
	}
}

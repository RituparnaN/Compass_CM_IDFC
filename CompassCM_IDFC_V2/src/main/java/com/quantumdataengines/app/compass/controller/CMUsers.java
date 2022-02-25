package com.quantumdataengines.app.compass.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

//import com.quantumdataengines.app.compass.model.DomainUser;

@Controller
public class CMUsers {
	private static final Logger log = LoggerFactory.getLogger(CMUsers.class);
	
	@RequestMapping(value={"/cmOfficer/","/cmOfficer/index"}, method=RequestMethod.GET)
	public String getCMOfficerIndex(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String CURRENTROLE = (String) request.getSession(false).getAttribute("CURRENTROLE");
		request.setAttribute("CURRENTROLE", CURRENTROLE);
		return "cmOfficerIndexTemplete";
	}
	
	@RequestMapping(value={"/cmManager/","/cmManager/index"}, method=RequestMethod.GET)
	public String getCMManagerIndex(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String CURRENTROLE = (String) request.getSession(false).getAttribute("CURRENTROLE");
		request.setAttribute("CURRENTROLE", CURRENTROLE);
		return "cmManagerIndexTemplete";
	}
	
	@RequestMapping(value={"/cmMaker/","/cmMaker/index"}, method=RequestMethod.GET)
	public String getCMMakerIndex(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String CURRENTROLE = (String) request.getSession(false).getAttribute("CURRENTROLE");
		request.setAttribute("CURRENTROLE", CURRENTROLE);
		return "cmMakerIndexTemplete";
	}
	
	@RequestMapping(value={"/cmChecker/","/cmChecker/index"}, method=RequestMethod.GET)
	public String getCMCheckerIndex(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String CURRENTROLE = (String) request.getSession(false).getAttribute("CURRENTROLE");
		request.setAttribute("CURRENTROLE", CURRENTROLE);
		return "cmCheckerIndexTemplete";
	}
	
	@RequestMapping(value={"/cmUAMMaker/","/cmUAMMaker/index"}, method=RequestMethod.GET)
	public String getCMUAMMakerIndex(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String CURRENTROLE = (String) request.getSession(false).getAttribute("CURRENTROLE");
		request.setAttribute("CURRENTROLE", CURRENTROLE);
		return "cmUAMMakerIndexTemplete";
	}
	
	@RequestMapping(value={"/cmUAMChecker/","/cmUAMChecker/index"}, method=RequestMethod.GET)
	public String getCMUAMCheckerIndex(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String CURRENTROLE = (String) request.getSession(false).getAttribute("CURRENTROLE");
		request.setAttribute("CURRENTROLE", CURRENTROLE);
		return "cmUAMCheckerIndexTemplete";
	}
	
	@RequestMapping(value={"/cmAdminMaker/","/cmAdminMaker/index"}, method=RequestMethod.GET)
	public String getCMAdminMakerIndex(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String CURRENTROLE = (String) request.getSession(false).getAttribute("CURRENTROLE");
		request.setAttribute("CURRENTROLE", CURRENTROLE);
		return "cmAdminMakerIndexTemplete";
	}
	
	@RequestMapping(value={"/cmAdminChecker/","/cmAdminChecker/index"}, method=RequestMethod.GET)
	public String getCMAdminCheckerIndex(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String CURRENTROLE = (String) request.getSession(false).getAttribute("CURRENTROLE");
		request.setAttribute("CURRENTROLE", CURRENTROLE);
		return "cmAdminCheckerIndexTemplete";
	}
}

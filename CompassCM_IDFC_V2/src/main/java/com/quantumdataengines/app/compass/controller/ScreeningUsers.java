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
public class ScreeningUsers {
	private static final Logger log = LoggerFactory.getLogger(ScreeningUsers.class);
	
	@RequestMapping(value={"/screeningMaker/","/screeningMaker/index"}, method=RequestMethod.GET)
	public String getScreeningMakerIndex(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String CURRENTROLE = (String) request.getSession(false).getAttribute("CURRENTROLE");
		request.setAttribute("CURRENTROLE", CURRENTROLE);
		return "screeningMakerIndexTemplete";
	}
	
	@RequestMapping(value={"/screeningChecker/","/screeningChecker/index"}, method=RequestMethod.GET)
	public String getScreeningCheckerIndex(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		return "screeningCheckerIndexTemplete";
	}
	
}

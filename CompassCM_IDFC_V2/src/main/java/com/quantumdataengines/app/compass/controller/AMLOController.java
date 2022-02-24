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
@RequestMapping(value="/amlo")
public class AMLOController {

   private static final Logger log = LoggerFactory.getLogger(AdminController.class);

	@Autowired
	private OtherCommonService otherCommonService;
	
	@RequestMapping(value={"/","/index"}, method=RequestMethod.GET)
	public String getUserIndex(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		DomainUser domainUser = (DomainUser) authentication.getDetails();
		request.setAttribute("UNQID", otherCommonService.getElementId());
		log.info("Opening AMLO index for : "+domainUser.getFirstName()+" "+domainUser.getLastName());
		return "amloIndexTemplete";
	}
}

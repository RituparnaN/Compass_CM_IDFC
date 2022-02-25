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
@RequestMapping(value="/admin")
public class AdminUserController {
	private static final Logger log = LoggerFactory.getLogger(AdminUserController.class);
	
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
	
}
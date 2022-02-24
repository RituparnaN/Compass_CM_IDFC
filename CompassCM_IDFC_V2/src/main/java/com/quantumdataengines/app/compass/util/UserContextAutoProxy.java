package com.quantumdataengines.app.compass.util;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.StringUtils;
import org.aspectj.lang.annotation.After;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Aspect
@Component
public class UserContextAutoProxy {
	
	private static final Logger log = LoggerFactory.getLogger(UserContextAutoProxy.class);
	@Autowired 
	private HttpServletRequest request;
	@Autowired
	private ConfigurationsDetails configDetails;
	
	public void setRequest(HttpServletRequest request) {
		this.request = request;
	}
	public void setConfigDetails(ConfigurationsDetails configDetails) {
		this.configDetails = configDetails;
	}
	
	@Before("execution(* com.quantumdataengines.app.compass.service..*.*(..))")
    public void setUserContext() throws Exception{
		HttpSession session = request.getSession(false);
		if(session != null){
			String instituteName = session.getAttribute("instituteName") != null ? session.getAttribute("instituteName").toString() : "";
			if(StringUtils.isNotEmpty(instituteName) && StringUtils.isNotBlank(instituteName)){
				log.debug("Setting UserContext for Institution : "+instituteName);
				UserContextHolder.setUserContextHolder(configDetails.getConfigurationForInstitution(instituteName));
			} else {
				log.error("Couldn't set UserContext for Institution : "+instituteName);
			}
		}
    }
	
	@After("execution(* com.quantumdataengines.app.compass.service..*.*(..))")
	public void clearContext(){
		log.debug("Removing UserContext...");
		UserContextHolder.clearContextHolder();
	}
}

package com.quantumdataengines.app.compass.util;

import java.util.Map;

import org.hibernate.SessionFactory;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


public class SessionFactoryRoutingUtil {
	
	private static final Logger log = LoggerFactory.getLogger(SessionFactoryRoutingUtil.class);
	private Map<String,SessionFactory> sessionFactories;
	
	public void setSessionFactories(Map<String, SessionFactory> sessionFactories) {
		this.sessionFactories = sessionFactories;
	}

	public SessionFactory getSessionFactory(){
		if(UserContextHolder.getUserContext() != null){
			String jndiName = UserContextHolder.getUserContext().getJndiDetails().getJndiName();
			log.info("Selecting SessionFactory[" +jndiName+"]...");
			return sessionFactories.get(jndiName);
		}else{
			log.warn("This is wrong selection of SessionFactory..");
			return sessionFactories.get("defaultJndi");
		}
	}
}

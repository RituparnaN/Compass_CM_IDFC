package com.quantumdataengines.app.compass.util;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.jdbc.datasource.lookup.AbstractRoutingDataSource;

import com.quantumdataengines.app.compass.schema.Configuration;

public class DataSourceRouterUtil extends AbstractRoutingDataSource{

	private static final Logger log = LoggerFactory.getLogger(DataSourceRouterUtil.class);

	@Override
	protected Object determineCurrentLookupKey() {		
		Configuration configuration = UserContextHolder.getUserContext();		
		if(configuration != null){
			String jndiName = configuration.getJndiDetails().getJndiName();
			log.debug("Selecting datasource["+jndiName+"]...");
			return jndiName;
		}else{
			log.debug("This is wrong selection of JNDI on startup..");
			return "defaultJndi";
		}		
	}
}
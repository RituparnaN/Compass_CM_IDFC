package com.quantumdataengines.app.compass.util;

import java.io.InputStream;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.xml.bind.JAXBContext;
import javax.xml.bind.Unmarshaller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

import com.quantumdataengines.app.compass.schema.Configuration;
import com.quantumdataengines.app.compass.schema.Configurations;

@Component
public class ConfigurationsDetails {
	
	private static final Logger log = LoggerFactory.getLogger(ConfigurationsDetails.class);

	public Map<String, Configuration> getConfigurationsDetails(){
		Map<String, Configuration> mapConfigurations = new HashMap<String, Configuration>();
		try{
			InputStream is = ConfigurationsDetails.class.getClassLoader()
					.getResourceAsStream("CompassConfiguration.xml");
			JAXBContext jaxbContext = JAXBContext.newInstance(Configurations.class);
			Unmarshaller jaxbUnmarshaller = jaxbContext.createUnmarshaller();
			Configurations configurations = (Configurations) jaxbUnmarshaller.unmarshal(is);
			
			List<Configuration> listconfigurations = configurations.getConfiguration();
			for(Configuration configuration : listconfigurations){
				mapConfigurations.put(configuration.getEntityName(), configuration);
			}
		}catch(Exception e){
			e.printStackTrace();
		}
		return mapConfigurations;
	}
	
	
	public List<String> getInstitutionsList() throws Exception{
		List<String> institutionList = new ArrayList<String>();
		Iterator<String> itrInstitution = getConfigurationsDetails().keySet().iterator();
		while(itrInstitution.hasNext()){
			institutionList.add(itrInstitution.next());
		}
		Collections.sort(institutionList);
		return institutionList;
	}
	
	public String getJndiNameFromInstitution(String institutionName) throws Exception{
		Configuration configuration = getConfigurationsDetails().get(institutionName);
		return configuration.getJndiDetails().getJndiName();
	}
	
	public Configuration getConfigurationForInstitution(String institutionName) throws Exception{
		log.debug("Selecting configuration for "+institutionName);
		return getConfigurationsDetails().get(institutionName);
	}
}

package com.quantumdataengines.app.compass.service.roboscanConfiguration;

import java.util.List;
import java.util.Map;

public interface RoboscanConfigService {
	public List<String> getAllRolesAvailable();
	//public List<Map<String, String>> getSectionNames();
	public List<Map<String,String>> getSectionNamesForRoleMapping(String roleId);
	public String assignSectionsToRole(String role, String listSectionsSelected);
	
}

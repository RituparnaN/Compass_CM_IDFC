package com.quantumdataengines.app.compass.service.roboscanConfiguration;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.quantumdataengines.app.compass.dao.roboscanConfiguration.RoboscanConfigDAO;;

@Service
public class RoboscanConfigServiceImpl implements RoboscanConfigService {
	
	@Autowired
	private RoboscanConfigDAO roboscanConfigDAO;

	public List<String> getAllRolesAvailable(){
		return roboscanConfigDAO.getAllRolesAvailable();
	}
	
	/*@Override
	public List<Map<String, String>> getSectionNames(){
		return roboscanConfigDAO.getSectionNames();
	}*/
	
	public List<Map<String,String>> getSectionNamesForRoleMapping(String roleId){
		return roboscanConfigDAO.getSectionNamesForRoleMapping(roleId);
	}

	@Override
	public String assignSectionsToRole(String role, String listSectionsSelected) {
		return roboscanConfigDAO.assignSectionsToRole(role, listSectionsSelected);
	}
	
}

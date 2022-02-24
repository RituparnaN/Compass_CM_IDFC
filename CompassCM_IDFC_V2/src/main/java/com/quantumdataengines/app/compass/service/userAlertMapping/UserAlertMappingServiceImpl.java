package com.quantumdataengines.app.compass.service.userAlertMapping;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.quantumdataengines.app.compass.dao.userAlertMapping.UserAlertMappingDAO;

@Service
public class UserAlertMappingServiceImpl implements UserAlertMappingService{

	@Autowired
	private UserAlertMappingDAO userAlertMappingDAO;

	@Override
	public Map<String, String> getUserDetails(String userRole) {
		return userAlertMappingDAO.getUserDetails(userRole);
	}

	@Override
	public Map<String, Object> searchUserALertMapping(String mappingType,
			String userLevel, String userCode) {
		return userAlertMappingDAO.searchUserALertMapping(mappingType, userLevel, userCode);
	}

	@Override
	public String saveAssignment(String fullData, String currentUser) {
		return userAlertMappingDAO.saveAssignment(fullData, currentUser);
	}
	
}

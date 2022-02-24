package com.quantumdataengines.app.compass.service.userCaseMapping;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.quantumdataengines.app.compass.dao.userCaseMapping.UserCaseMappingDAO;

@Service
public class UserCaseMappingServiceImpl implements UserCaseMappingService{

	@Autowired
	private UserCaseMappingDAO userCaseMappingDAO;

	@Override
	public List<Map<String, String>> getUserDetailsForUserCaseMapping(String userRole) {
		return userCaseMappingDAO.getUserDetailsForUserCaseMapping(userRole);
	}

	@Override
	public String saveUserCaseAssignment(String fullData, String makerComments, String currentUser, String currentRole, String ipAddress) {
		return userCaseMappingDAO.saveUserCaseAssignment(fullData, makerComments, currentUser, currentRole, ipAddress);
	}

	@Override
	public String approveOrRejectUserCaseAssignment(String fullData, String action, String checkerComments, String currentUser,
			String currentRole, String ipAddress) {
		return userCaseMappingDAO.approveOrRejectUserCaseAssignment(fullData, action, checkerComments, currentUser, currentRole, ipAddress);
	}
	
}

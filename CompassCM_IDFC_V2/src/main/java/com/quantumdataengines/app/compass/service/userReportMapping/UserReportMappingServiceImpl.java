package com.quantumdataengines.app.compass.service.userReportMapping;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.quantumdataengines.app.compass.dao.userReportMapping.UserReportMappingDAO;

@Service
public class UserReportMappingServiceImpl implements UserReportMappingService{

	@Autowired
	private UserReportMappingDAO userReportMappingDAO;

	@Override
	public Map<String, Object> userReportMapping() {
		return userReportMappingDAO.userReportMapping();
	}

	@Override
	public Map<String, Object> searchUserReportMapping(String selectedUserCode, String reportType, String reportId,
			String userCode, String userRole, String ipAddress) {
		return userReportMappingDAO.searchUserReportMapping(selectedUserCode, reportType, reportId, userCode, userRole, ipAddress);
	}

	@Override
	public String saveUserReportMapping(String fullData, String currentUser) {
		return userReportMappingDAO.saveUserReportMapping(fullData, currentUser);
	}
	
}

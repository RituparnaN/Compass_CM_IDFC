package com.quantumdataengines.app.compass.service.caseWorkFlow;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.quantumdataengines.app.compass.dao.caseWorkFlow.RoboScanDAO;
@Service
public class RoboScanServiceImpl implements RoboScanService {
	
	@Autowired
	private RoboScanDAO roboScanDao;

	@Override
	public List<String> getRoboscanConfigDetails(String roleId) {
		return roboScanDao.getRoboscanConfigDetails(roleId);
	}
	
	@Override
	public Map<String, Object> fetchRoboscanData(String caseNos,
			String userCode, String ipAddress, String CURRENTROLE) {
		
		return roboScanDao.fetchRoboscanData(caseNos, userCode, ipAddress, CURRENTROLE);
	}

	@Override
	public String saveRoboscanScreeningMapping(String roboscanCaseNo,
			String uniqueNumber, String fileName, String userCode,
			String userRole, String ipAddress) {
		return roboScanDao.saveRoboscanScreeningMapping(roboscanCaseNo, uniqueNumber, fileName, userCode, userRole, ipAddress);
	}
	
	public Map<String, String> getRoboscanScreeningDetails(String roboscanCaseNo){
		return roboScanDao.getRoboscanScreeningDetails(roboscanCaseNo);
	}
	

}

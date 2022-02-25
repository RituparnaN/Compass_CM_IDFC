package com.quantumdataengines.app.compass.service.dashBoardNew;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.quantumdataengines.app.compass.dao.dashBoardNew.DashBoardNewDAO;

@Service
public class DashBoardNewServiceImpl implements DashBoardNewService {

	@Autowired
	private DashBoardNewDAO DashBoardNewDAO;

	public Map<String, Object> getDashBoardNewInTabView(String fromDate, String toDate, 
			String userCode, String userRole, String sourceSystem){
		return DashBoardNewDAO.getDashBoardNewInTabView(fromDate, toDate, userCode, userRole, sourceSystem);
	}

/*	public Map<String, Object> getSwiftDashBoardInTabView(String fromDate, String toDate,
    		String userCode, String userRole, String messageFlowType){
		return DashBoardDAO.getSwiftDashBoardInTabView(fromDate, toDate, userCode, userRole, messageFlowType);
	}

	public Map<String, Object> getMISReportTabView(String fromDate, String toDate, 
			String userCode, String reportFrequency){
		return DashBoardDAO.getMISReportTabView(fromDate, toDate, userCode, reportFrequency);
	}
*/
	@Override
	public List<Map<String, Object>> getTotalAmluserWiseRecordStats(String fromDate, String toDate, 
    		String sourceSystem, String userCode, String userRole, String ipAddress) {
		return DashBoardNewDAO.getTotalAmluserWiseRecordStats(fromDate, toDate, sourceSystem, userCode, userRole, ipAddress);
	}

}
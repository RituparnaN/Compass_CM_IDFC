package com.quantumdataengines.app.compass.service.dashBoard;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.quantumdataengines.app.compass.dao.dashBoard.DashBoardDAO;

@Service
public class DashBoardServiceImpl implements DashBoardService {

	@Autowired
	private DashBoardDAO DashBoardDAO;

	public Map<String, Object> getDashBoardInTabView(String fromDate, String toDate, 
			String userCode, String userRole, String sourceSystem){
		return DashBoardDAO.getDashBoardInTabView(fromDate, toDate, userCode, userRole, sourceSystem);
	}

	public Map<String, Object> getSwiftDashBoardInTabView(String fromDate, String toDate,
    		String userCode, String userRole, String messageFlowType){
		return DashBoardDAO.getSwiftDashBoardInTabView(fromDate, toDate, userCode, userRole, messageFlowType);
	}

	public Map<String, Object> getMISReportTabView(String fromDate, String toDate, 
			String userCode, String reportFrequency){
		return DashBoardDAO.getMISReportTabView(fromDate, toDate, userCode, reportFrequency);
	}

	@Override
	public List<Map<String, Object>> getTotalAmluserWiseRecordStats(String fromDate, String toDate, 
    		String sourceSystem, String userCode, String userRole, String ipAddress) {
		return DashBoardDAO.getTotalAmluserWiseRecordStats(fromDate, toDate, sourceSystem, userCode, userRole, ipAddress);
	}
}
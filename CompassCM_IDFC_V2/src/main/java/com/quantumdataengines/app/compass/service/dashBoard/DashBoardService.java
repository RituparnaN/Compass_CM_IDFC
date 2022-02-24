package com.quantumdataengines.app.compass.service.dashBoard;

import java.util.List;
import java.util.Map;

public interface DashBoardService {
    public Map<String, Object> getDashBoardInTabView(String fromDate, String toDate, 
    		String userCode, String userRole, String sourceSystem);
    public Map<String, Object> getSwiftDashBoardInTabView(String fromDate, String toDate,
    		String userCode, String userRole, String messageFlowType);
        public Map<String, Object> getMISReportTabView(String fromDate, String toDate, 
    		String userCode, String reportFrequency);
     public List<Map<String, Object>> getTotalAmluserWiseRecordStats(String fromDate, String toDate, 
     		String sourceSystem, String userCode, String userRole, String ipAddress);
}
package com.quantumdataengines.app.compass.dao.overviewGlance;

import java.util.LinkedHashMap;
import java.util.Map;

public interface OverviewGlanceDAO {
	LinkedHashMap<String,Object> getETLSummary(String userCode, String userRole, String ipAddr);
	Map<String, Object> accountGlance(String userCode, String userRole, String ipAddr);
	Map<String, Object> customerGlance(String userCode, String userRole, String ipAddr);
	Map<String, Object> etlWorkflowData(String userCode, String userRole, String ipAddr);
	Map<String, Object> etlAlertData(String userCode, String userRole, String ipAddr);
	Map<String, Object> etlRegReportData(String userCode, String userRole, String ipAddr);
	Map<String, Object> etlUserRoleData(String userCode, String userRole, String ipAddr);
	Map<String, Object> etlAccountTypeStatusData(String userCode, String userRole, String ipAddr);
	Map<String, Object> etlCustomerTypeData(String userCode, String userRole, String ipAddr);
	Map<String, Object> etlCaseProductivityData(String userCode, String userRole, String ipAddr);
	Map<String, Object> getETLAlertData(String fromDate, String toDate, String reportType, String reportValue, String moduleType,
			String userCode, String userRole, String ipAddr);
	Map<String, Object> getETLRegulatoryReportData(String fromDate, String toDate, String reportType,
			String reportValue, String moduleType, String userCode, String userRole, String ipAddr);
}

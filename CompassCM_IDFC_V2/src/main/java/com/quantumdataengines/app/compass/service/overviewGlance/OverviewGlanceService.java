package com.quantumdataengines.app.compass.service.overviewGlance;

import java.util.LinkedHashMap;
import java.util.Map;

public interface OverviewGlanceService {
	LinkedHashMap<String,Object> getETLSummary(String userCode, String userRole, String ipAddr);
	Map<String, Object> mastersOverview(String userCode, String userRole, String ipAddr);
	Map<String, Object> etlWorkflowData(String userCode, String userRole, String ipAddr);
	Map<String, Object> etlAlertData(String userCode, String userRole, String ipAddr);
	Map<String, Object> etlRegReportData(String userCode, String userRole, String ipAddr);
	Map<String, Object> etlUserRoleData(String userCode, String userRole, String ipAddr);
	Map<String, Object> etlAccountTypeStatusData(String userCode, String userRole, String ipAddr);
	Map<String, Object> etlCustomerTypeData(String userCode, String userRole, String ipAddr);
	Map<String, Object> etlCaseProductivityData(String userCode, String userRole, String ipAddr);
	public Map<String, Object>  getETLAlertData(String fromDate, String toDate, String reportType, String reportValue, String moduleType,
			String userCode, String userRole, String ipAddr);
	public Map<String, Object> getETLRegulatoryReportData(String fromDate, String toDate, String reportType, String reportValue,
			String moduleType, String userCode, String userRole, String ipAddr);
}

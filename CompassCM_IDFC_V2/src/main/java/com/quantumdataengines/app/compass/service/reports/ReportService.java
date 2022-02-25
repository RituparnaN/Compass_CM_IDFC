package com.quantumdataengines.app.compass.service.reports;

import java.util.HashMap;

public interface ReportService {

	HashMap<String,Object> reportData(String userName, String reportId, String startDate, String endDate, String amount, String filter1, String filter2, String filter3);
	HashMap<String,Object> reportData(String userName, String builtCondition, String l_strReportID, String l_strNoOfParameters);
	String setReportRule(String username, String l_strReportID, String l_strReportCode,
			String l_strReportName, String l_strReportType, String l_strISEnabled, String builtCondition, String l_strAction, String l_strNoOfParameters, String l_strReportHeader, String l_strReportFooter);
	HashMap<String,Object> fetchReportDetails(String username, String l_strReportID);
	String[][] getReportColumns(String username, String l_strReportID, String builtCondition);
	String getRCGraph(String userCode, String fromDate, String customerId, String amount);
	String getABMGraph(String userCode, String fromDate, String accountNo);
	String getCPRGraph(String userCode, String fromDate, String toDate, String accountNo1, String accountNo2, String instrumentCode, String action);
	HashMap<String,Object> reportWidgetsMainData(String userName, String reportId);
	HashMap<String,Object> reportWidgetsData(String userName, String selectedTables, String joinConditions, 
			String reportColumns, String params, String aggregateConditions);
}
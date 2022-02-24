package com.quantumdataengines.app.compass.service.reports;

import java.util.Map;

public interface PPTReportsService {
	
	

	Map<String, Object> getPPTReportData(Map<String, String> paramValues);

	Map<String, Object> downloadPPTReport(Map<String, String> paramValues);

}

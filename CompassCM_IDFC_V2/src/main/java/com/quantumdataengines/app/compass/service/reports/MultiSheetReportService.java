package com.quantumdataengines.app.compass.service.reports;

import java.util.Map;

public interface MultiSheetReportService {
	public Map<String, Object> getExtractionLog(String fromDate, String toDate, String logType, String status);
}

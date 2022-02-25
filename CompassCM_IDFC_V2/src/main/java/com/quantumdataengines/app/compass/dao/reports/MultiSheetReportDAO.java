package com.quantumdataengines.app.compass.dao.reports;

import java.util.Map;

public interface MultiSheetReportDAO {
	public Map<String, Object> getExtractionLog(String fromDate, String toDate, String logType, String status);
}

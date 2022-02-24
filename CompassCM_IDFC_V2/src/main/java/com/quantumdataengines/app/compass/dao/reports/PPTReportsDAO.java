package com.quantumdataengines.app.compass.dao.reports;

import java.util.Map;

public interface PPTReportsDAO {

	Map<String, Object> getPPTReportData(Map<String, String> paramValues);

}

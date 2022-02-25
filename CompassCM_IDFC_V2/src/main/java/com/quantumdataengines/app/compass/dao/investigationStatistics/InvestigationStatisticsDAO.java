package com.quantumdataengines.app.compass.dao.investigationStatistics;

import java.util.List;
import java.util.Map;

public interface InvestigationStatisticsDAO {
	public List<Map<String, String>> getInvestigationStatistics(String userCode, String CURRENTROLE, String ipAddress);
}

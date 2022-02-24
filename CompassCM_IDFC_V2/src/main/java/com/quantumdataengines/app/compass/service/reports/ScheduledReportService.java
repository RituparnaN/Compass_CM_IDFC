package com.quantumdataengines.app.compass.service.reports;

import java.util.List;
import java.util.Map;

public interface ScheduledReportService {
	public List<Map<String, String>> getAllReportsDetails(String reportGroup);
	public Map<String, Object> getReportBenchmarkDetails(String reportId);
	public Map<String, String> getBenchmarkScheduleDetails(String userId, String reportId);
	public String saveOrUpdateReportBenchMark(String reportId, String userId, Map<String, String> paramMap);
	public void saveOrUpdateSchedulingDetailsForReport(String userId, String reportId, String schedulingFrequency, String generationDates);
	public void deleteScheduling(String userId, String reportId);
	public void deleteBenchmark(String userId, String reportId);
}

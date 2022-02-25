package com.quantumdataengines.app.compass.service.crpExecScheduler;

import java.util.Map;

public interface CRPExecSchedulerService {
	public Map<String, String> getCRPExecutedDetails();
	public String saveSchedulingDates(String EXECUTED_FROMDATE, String EXECUTED_TODATE, String EXECUTED_DATE, String SCHEDULED_FROMDATE, String SCHEDULED_TODATE, String EXECUTION_DATE, String currentUser);
}

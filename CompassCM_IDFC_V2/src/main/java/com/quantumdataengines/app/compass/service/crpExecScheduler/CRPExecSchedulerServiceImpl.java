package com.quantumdataengines.app.compass.service.crpExecScheduler;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.quantumdataengines.app.compass.dao.crpExecScheduler.CRPExecSchedulerDAO;

@Service
public class CRPExecSchedulerServiceImpl implements CRPExecSchedulerService{

	@Autowired
	private CRPExecSchedulerDAO crpExecSchedulerDAO;

	@Override
	public Map<String, String> getCRPExecutedDetails() {
		return crpExecSchedulerDAO.getCRPExecutedDetails();
	}

	@Override
	public String saveSchedulingDates(String EXECUTED_FROMDATE, String EXECUTED_TODATE, String EXECUTED_DATE, String SCHEDULED_FROMDATE, String SCHEDULED_TODATE, String EXECUTION_DATE, String currentUser) {
		return crpExecSchedulerDAO.saveSchedulingDates(EXECUTED_FROMDATE, EXECUTED_TODATE, EXECUTED_DATE, SCHEDULED_FROMDATE, SCHEDULED_TODATE, EXECUTION_DATE, currentUser);
	}

	
}

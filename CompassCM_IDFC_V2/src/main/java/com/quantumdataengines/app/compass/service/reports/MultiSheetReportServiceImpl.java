package com.quantumdataengines.app.compass.service.reports;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.quantumdataengines.app.compass.dao.reports.MultiSheetReportDAO;

@Service
public class MultiSheetReportServiceImpl implements MultiSheetReportService{
	
	@Autowired
	private MultiSheetReportDAO multiSheetReportDAO; 
	
	public void setMultiSheetReportDAO(MultiSheetReportDAO multiSheetReportDAO) {
		this.multiSheetReportDAO = multiSheetReportDAO;
	}

	public Map<String, Object> getExtractionLog(String fromDate, String toDate, String logType, String status) {
		return multiSheetReportDAO.getExtractionLog(fromDate, toDate, logType, status);
	}

}

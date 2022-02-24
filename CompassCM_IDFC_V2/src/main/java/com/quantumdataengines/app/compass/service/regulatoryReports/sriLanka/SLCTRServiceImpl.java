package com.quantumdataengines.app.compass.service.regulatoryReports.sriLanka;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.quantumdataengines.app.compass.dao.regulatoryReports.sriLanka.SLCTRDAO;

@Service
public class SLCTRServiceImpl implements SLCTRService{
	
	@Autowired
	private SLCTRDAO slCTRDAO;

	@Override	
	public String generateSLCTRReportingFile(String reportType, String reportingFileType, String fortNightOfReporting, String monthOfReporting, String yearOfReporting, String thresholdAmount, String userId){
		return slCTRDAO.generateSLCTRReportingFile(reportType, reportingFileType, fortNightOfReporting, monthOfReporting, yearOfReporting, thresholdAmount, userId);
	}
	
	@Override
	public List<String> getSLRegReportFileData(String tableName){
		return slCTRDAO.getSLRegReportFileData(tableName);
	}
}

package com.quantumdataengines.app.compass.service.regulatoryReports.sriLanka;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.quantumdataengines.app.compass.dao.regulatoryReports.sriLanka.SLOEFTDAO;

@Service
public class SLOEFTServiceImpl implements SLOEFTService{
	
	@Autowired
	private SLOEFTDAO slOEFTDAO;

	@Override	
	public String generateSLOEFTReportingFile(String reportType, String reportingFileType, String fortNightOfReporting, String monthOfReporting, String yearOfReporting, String thresholdAmount, String userId){
		return slOEFTDAO.generateSLOEFTReportingFile(reportType, reportingFileType, fortNightOfReporting, monthOfReporting, yearOfReporting, thresholdAmount, userId);
	}
	
	@Override
	public List<String> getSLRegReportFileData(String tableName){
		return slOEFTDAO.getSLRegReportFileData(tableName);
	}
}

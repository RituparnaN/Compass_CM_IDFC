package com.quantumdataengines.app.compass.service.regulatoryReports.sriLanka;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.quantumdataengines.app.compass.dao.regulatoryReports.sriLanka.SLIEFTDAO;

@Service
public class SLIEFTServiceImpl implements SLIEFTService{
	
	@Autowired
	private SLIEFTDAO slIEFTDAO;

	@Override	
	public String generateSLIEFTReportingFile(String reportType, String reportingFileType, String fortNightOfReporting, String monthOfReporting, String yearOfReporting, String thresholdAmount, String userId){
		return slIEFTDAO.generateSLIEFTReportingFile(reportType, reportingFileType, fortNightOfReporting, monthOfReporting, yearOfReporting, thresholdAmount, userId);
	}
	
	@Override
	public List<String> getSLRegReportFileData(String tableName){
		return slIEFTDAO.getSLRegReportFileData(tableName);
	}
}

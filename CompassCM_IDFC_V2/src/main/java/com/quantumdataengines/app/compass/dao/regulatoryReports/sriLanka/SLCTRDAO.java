package com.quantumdataengines.app.compass.dao.regulatoryReports.sriLanka;

import java.util.List;


public interface SLCTRDAO {
	public String generateSLCTRReportingFile(String reportType, String reportingFileType, String fortNightOfReporting, String monthOfReporting, String yearOfReporting, String thresholdAmount, String userId);
	public List<String> getSLRegReportFileData(String tableName);
}

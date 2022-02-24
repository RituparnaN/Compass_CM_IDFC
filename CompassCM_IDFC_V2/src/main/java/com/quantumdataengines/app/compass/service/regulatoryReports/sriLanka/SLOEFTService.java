package com.quantumdataengines.app.compass.service.regulatoryReports.sriLanka;

import java.util.List;

public interface SLOEFTService {
	public String generateSLOEFTReportingFile(String reportType, String reportingFileType, String fortNightOfReporting, String monthOfReporting, String yearOfReporting, String thresholdAmount, String userId);
	public List<String> getSLRegReportFileData(String tableName);
}

package com.quantumdataengines.app.compass.dao.regulatoryReports.india;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface RegulatoryReportsDAO {
    public String generateRegReportData(String reportType, String reportMonth, String reportYear, String userCode);
    public String generateReportXML(String reportType, String reportMonth, String reportYear, String reportFile, String batchType, String originalBatchID, String reasonOfRevision, String noOfLines, String userCode);    

	public Map<String, Object> generateRegulatoryExceptionFile(Map<String, String> paramMap);
	public Map<String, Object> downloadRegulatoryExcel(Map<String, String> paramMap);
		
	// GENERATED CTR FILES
	public Map<String, Object> viewGeneratedCTRFilesMaster(String reportingMonth, String reportingYear, String moduleType,String userCode, String userRole, String ipAdress);
	public String updateCTRDetails(Map<String, String> paramMap,
			String userCode, String selectedFileSeq);
	
	// GENERATED NTR FILES
	public Map<String, Object> viewGeneratedNTRFilesMaster(String reportingMonth, String reportingYear, String moduleType,String userCode, String userRole, String ipAdress);
	public String updateNTRDetails(Map<String, String> paramMap,
			String userCode, String selectedFileSeq);
	
	// GENERATED CBWTR FILES
	public Map<String, Object> viewGeneratedCBWTRFilesMaster(String reportingMonth, String reportingYear, String moduleType,String userCode, String userRole, String ipAdress);
	public String updateCBWTRDetails(Map<String, String> paramMap,
			String userCode, String selectedFileSeq);
	
}

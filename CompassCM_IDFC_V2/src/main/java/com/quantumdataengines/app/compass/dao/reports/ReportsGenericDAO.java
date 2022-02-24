package com.quantumdataengines.app.compass.dao.reports;

import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface ReportsGenericDAO {
	
	public Collection getListOfReports(String groupId, String userCode, String userRole);
	public String getReportName(String groupId, String reportId, String userCode, String userRole);
	public Map<String, Object> getListOfReportBenchMarks(String groupId, String reportId, String userCode, String userRole, String viewType);
	public List<Map<String, Object>> getReportBenchMarkDetails(String groupId, String reportId, String reportSerialNo, String userCode, String userRole, String viewType);
	//public boolean saveReportBenchMarkParameters(String reportId, String reportSerialNo, Map<String, String> paramMap, String userCode, String userRole, String ipAdress, String benchmarkParameters);
	public String saveReportBenchMarkParameters(String reportId, String reportSerialNo, Map<String, String> paramMap, String userCode, String userRole, String ipAdress, String benchmarkParameters, String configurationComments);
	public boolean deleteReportBenchMarkParameters(String reportId, String reportSerialNo, String requestType, String userCode, String userRole, String ipAdress);
	public Map<String,Object> generateReportWithBenchMarks(String groupId, String reportId, String reportSerialNo, Map<String, String> paramMap, String generationType, String userCode, String userRole, String ipAdress);
	
	public String generateReportXML(String a_strReportType, String l_strReportMonth, String l_strReportYear, String l_strReportFile, String l_strBatchType, String l_strOriginalBatchID, String l_strReasonOfRevision, String l_strNoOfLines, String userCode, String userRole);
	public List<Map<String, String>> chooseReportFile(String reportType, String reportMonth, String reportYear, String userCode, String userRole);
    public String generateRegReportData(String a_strReportType, String l_strReportMonth, String l_strReportYear, String userCode, String userRole);

    public HashMap<String,Object> RegMISReportData(String reportType, String reportingMonth, String reportingYear, String batchType, String reportedDate, String recordsCount, String originalBatchID, String reasonOfRevision, String actionType, String userCode, String userRole);
    public List<String> getReportFileData(String tableName, String userCode, String userRole);
    public Map<String, Object> getConsolidatedReportTabView(String fromDate, String toDate, 
    		String userCode, String userRole, String reportFrequency);
    
    public  List<Map<String, String>> fetchDetailsToResetReportColumns(String reportId, String userCode, String userRole);
    public String resetReportColumns(String reportId, String userCode, String userRole, String fullData);
    public String logReportGenerationRequest(String userCode, String userRole, String ipAddress, String viewType, String reportId, String reportParameter);
	public List<Map<String, Object>> getStaffReportParams(String reportId, String userCode, String userRole, String ipAddress);
    public Map<String, Object> getStaffMonitoringReportsData(String reportId, Map<String, String> paramDataMap, String userCode, String userRole, String ipAddress);
    public Map<String, Object> getReportData(String groupId, String reportId, String reportSerialNo, Map<String, String> paramMap, 
    		String generationType, String userCode, String userRole, String ipAddress);
}

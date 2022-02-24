package com.quantumdataengines.app.compass.service.reports;

import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.quantumdataengines.app.compass.dao.reports.ReportsGenericDAO;

@Service
public class ReportsGenericServiceImpl implements ReportsGenericService {

	@Autowired
	private ReportsGenericDAO reportsGenericDAO;

	@Override
    public Collection getListOfReports(String groupId, String userCode, String userRole){
        return reportsGenericDAO.getListOfReports(groupId, userCode, userRole);
    }

	@Override
	public String getReportName(String groupId, String reportId, String userCode, String userRole){
		return reportsGenericDAO.getReportName(groupId, reportId, userCode, userRole);
	}
	
	@Override
    public Map<String, Object> getListOfReportBenchMarks(String groupId, String reportId, String userCode, String userRole, String viewType){
        return reportsGenericDAO.getListOfReportBenchMarks(groupId, reportId, userCode, userRole, viewType);
    }

	@Override
    public List<Map<String, Object>> getReportBenchMarkDetails(String groupId, String reportId, String reportSerialNo, String userCode, String userRole, String viewType){
        return reportsGenericDAO.getReportBenchMarkDetails(groupId, reportId, reportSerialNo, userCode, userRole, viewType);
    }

	// public boolean saveReportBenchMarkParameters(String reportId, String reportSerialNo, Map<String, String> paramMap,
	@Override
	public String saveReportBenchMarkParameters(String reportId, String reportSerialNo, Map<String, String> paramMap, 
					String userCode, String userRole, String ipAdress, String benchmarkParameters, String configurationComments){
		return reportsGenericDAO.saveReportBenchMarkParameters(reportId, reportSerialNo, paramMap, userCode, userRole, ipAdress, benchmarkParameters, configurationComments);
	}
	
	@Override
    public boolean deleteReportBenchMarkParameters(String reportId, String reportSerialNo, String requestType, String userCode, String userRole, String ipAdress){
		return reportsGenericDAO.deleteReportBenchMarkParameters(reportId, reportSerialNo, requestType, userCode, userRole, ipAdress);
	}

	@Override
	public Map<String,Object> generateReportWithBenchMarks(String groupId, String reportId, String reportSerialNo, Map<String, String> paramMap, String generationType, String userCode, String userRole, String ipAdress){
		return reportsGenericDAO.generateReportWithBenchMarks(groupId, reportId, reportSerialNo, paramMap, generationType, userCode, userRole, ipAdress);
	}
    
    public String generateReportXML(String a_strReportType, String l_strReportMonth, String l_strReportYear, String l_strReportFile, String l_strBatchType, String l_strOriginalBatchID, String l_strReasonOfRevision, String l_strNoOfLines, String userCode, String userRole){
    	return reportsGenericDAO.generateReportXML(a_strReportType, l_strReportMonth, l_strReportYear, l_strReportFile, l_strBatchType, l_strOriginalBatchID, l_strReasonOfRevision, l_strNoOfLines, userCode, userRole);
    }
    
    public List<Map<String, String>> chooseReportFile(String reportType, String reportMonth, String reportYear, String userCode, String userRole){
    	return reportsGenericDAO.chooseReportFile(reportType, reportMonth, reportYear, userCode, userRole);
    }
    
    public String generateRegReportData(String a_strReportType, String l_strReportMonth, String l_strReportYear, String userCode, String userRole){
    	return reportsGenericDAO.generateRegReportData(a_strReportType, l_strReportMonth, l_strReportYear, userCode, userRole);
    }
    
    public HashMap<String,Object> RegMISReportData(String reportType, String reportingMonth, String reportingYear, String batchType, String reportedDate, String recordsCount, String originalBatchID, String reasonOfRevision, String actionType, String userCode, String userRole){
    	return reportsGenericDAO.RegMISReportData(reportType, reportingMonth, reportingYear, batchType, reportedDate, recordsCount, originalBatchID, reasonOfRevision, actionType, userCode, userRole);
    }
    
    public List<String> getReportFileData(String tableName, String userCode, String userRole){
    	return reportsGenericDAO.getReportFileData(tableName, userCode, userRole);
    }
    
    public Map<String, Object> getConsolidatedReportTabView(String fromDate, String toDate, 
    		String userCode, String userRole, String reportFrequency){
    	return reportsGenericDAO.getConsolidatedReportTabView(fromDate, toDate, 
        		userCode, userRole, reportFrequency);
    }

	@Override
	public  List<Map<String, String>> fetchDetailsToResetReportColumns(
			String reportId, String userCode, String userRole) {
		return reportsGenericDAO.fetchDetailsToResetReportColumns(reportId, userCode, userRole);
	}

	@Override
	public String resetReportColumns(String reportId, String userCode, String userRole, String fullData) {
		return reportsGenericDAO.resetReportColumns(reportId, userCode, userRole, fullData);
	}

	@Override
	public String logReportGenerationRequest(String userCode, String userRole, String ipAddress, String viewType, String reportId, String reportParameter){
		return reportsGenericDAO.logReportGenerationRequest(userCode, userRole, ipAddress, viewType, reportId, reportParameter);
	}
	@Override
	public List<Map<String, Object>> getStaffReportParams(String reportId, String userCode, String userRole, String ipAddress) {
		return reportsGenericDAO.getStaffReportParams(reportId, userCode, userRole, ipAddress);
	}
	
	@Override
	public Map<String, Object> getStaffMonitoringReportsData(String reportId, Map<String, String> paramDataMap, String userCode,
			String userRole, String ipAddress) {
		return reportsGenericDAO.getStaffMonitoringReportsData(reportId, paramDataMap, userCode, userRole, ipAddress);
	}

	@Override
	public Map<String, Object> getReportData(String groupId, String reportId, String reportSerialNo,
			Map<String, String> paramMap, String generationType, String userCode, String userRole, String ipAddress) {
		return reportsGenericDAO.getReportData(groupId, reportId, reportSerialNo, paramMap, generationType, userCode, userRole, ipAddress);
	}
}
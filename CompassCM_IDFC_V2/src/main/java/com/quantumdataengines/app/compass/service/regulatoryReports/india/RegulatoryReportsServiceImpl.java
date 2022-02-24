package com.quantumdataengines.app.compass.service.regulatoryReports.india;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.quantumdataengines.app.compass.dao.regulatoryReports.india.RegulatoryReportsDAO;

@Service
public class RegulatoryReportsServiceImpl implements RegulatoryReportsService {

	@Autowired
	private RegulatoryReportsDAO regulatoryReportsDAO;

    public String generateRegReportData(String reportType, String reportMonth, String reportYear, String userCode){
    	return regulatoryReportsDAO.generateRegReportData(reportType, reportMonth, reportYear, userCode);
    }

    public String generateReportXML(String reportType, String reportMonth, String reportYear, String reportFile, String batchType, String originalBatchID, String reasonOfRevision, String noOfLines, String userCode)
    {
    	return regulatoryReportsDAO.generateReportXML(reportType, reportMonth, reportYear, reportFile, batchType, originalBatchID, reasonOfRevision, noOfLines, userCode);
    }
    
	@Override
	public Map<String, Object> generateRegulatoryExceptionFile(Map<String, String> paramMap) {
		return regulatoryReportsDAO.generateRegulatoryExceptionFile(paramMap);
	}

	@Override
	public Map<String, Object> downloadRegulatoryExcel(Map<String, String> paramMap) {
		return regulatoryReportsDAO.downloadRegulatoryExcel(paramMap);
	}
	
 // GENERATED CTR FILES
 	@Override
 	public Map<String,Object> viewGeneratedCTRFilesMaster(String reportingMonth,String reportingYear, String moduleType, String userCode,String userRole, String ipAdress) {
 		return regulatoryReportsDAO.viewGeneratedCTRFilesMaster (reportingMonth,reportingYear, moduleType, userCode,userRole, ipAdress);
 	}

 	@Override
 	public String updateCTRDetails(Map<String, String> paramMap,
 			String userCode, String selectedFileSeq) {
 		return regulatoryReportsDAO.updateCTRDetails(paramMap, userCode, selectedFileSeq);
 	}
 	
 	// GENERATED NTR FILES
 	@Override
 	public Map<String,Object> viewGeneratedNTRFilesMaster(String reportingMonth,String reportingYear, String moduleType, String userCode,String userRole, String ipAdress) {
 		return regulatoryReportsDAO.viewGeneratedNTRFilesMaster (reportingMonth,reportingYear, moduleType, userCode,userRole, ipAdress);
 	}

 	@Override
 	public String updateNTRDetails(Map<String, String> paramMap,
 			String userCode, String selectedFileSeq) {
 		return regulatoryReportsDAO.updateNTRDetails(paramMap, userCode, selectedFileSeq);
 	}
 	
 	// GENERATED CBWTR FILES
 	@Override
 	public Map<String,Object> viewGeneratedCBWTRFilesMaster(String reportingMonth,String reportingYear, String moduleType, String userCode,String userRole, String ipAdress) {
 		return regulatoryReportsDAO.viewGeneratedCBWTRFilesMaster (reportingMonth,reportingYear, moduleType, userCode,userRole, ipAdress);
 	}

 	@Override
 	public String updateCBWTRDetails(Map<String, String> paramMap,
 			String userCode, String selectedFileSeq) {
 		return regulatoryReportsDAO.updateCBWTRDetails(paramMap, userCode, selectedFileSeq);
 	}

}
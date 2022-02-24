package com.quantumdataengines.app.compass.service.reports;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.quantumdataengines.app.compass.dao.reports.ReportDAO;

@Service
public class ReportServiceImpl implements ReportService {

	private ReportDAO ReportDAO;

	@Autowired
	public ReportServiceImpl(ReportDAO ReportDAO) {
		this.ReportDAO = ReportDAO;
	}

//	@Override
	public HashMap<String,Object> reportData(String userName, String reportId, String startDate, String endDate, String amount, String filter1, String filter2, String filter3) {
		return ReportDAO.reportData(userName, reportId, startDate, endDate, amount, filter1, filter2, filter3);
	}
	
//	@Override
	public HashMap<String,Object> reportData(String userName, String builtCondition, String l_strReportID, String l_strNoOfParameters) {
		return ReportDAO.reportData(userName, builtCondition, l_strReportID, l_strNoOfParameters);
	}

//	@Override
	public String setReportRule(String username, String l_strReportID, String l_strReportCode,
			String l_strReportName, String l_strReportType, String l_strISEnabled, String builtCondition, String l_strAction, String l_strNoOfParameters, String l_strReportHeader, String l_strReportFooter) {
		return ReportDAO.setReportRule(username, l_strReportID, l_strReportCode,
				l_strReportName, l_strReportType, l_strISEnabled, builtCondition, l_strAction, l_strNoOfParameters, l_strReportHeader, l_strReportFooter);
	}

	//	@Override
	public HashMap<String,Object> fetchReportDetails(String username, String l_strReportID) {
		return ReportDAO.fetchReportDetails(username, l_strReportID);
	}

	//	@Override
	public String[][] getReportColumns(String username, String l_strReportID, String builtCondition) {
		return ReportDAO.getReportColumns(username, l_strReportID, builtCondition);
	}
	
	//	@Override
	public String getRCGraph(String userCode, String fromDate, String customerId, String amount) {
		return ReportDAO.getRCGraph(userCode, fromDate, customerId, amount);
	}

	//	@Override
	public String getABMGraph(String userCode, String fromDate, String accountNo) {
		return ReportDAO.getABMGraph(userCode, fromDate, accountNo);
	}

	//	@Override
	public String getCPRGraph(String userCode, String fromDate, String toDate, String accountNo1, String accountNo2, String instrumentCode, String action) {
		return ReportDAO.getCPRGraph(userCode, fromDate, toDate, accountNo1, accountNo2, instrumentCode, action);
	}
	
	//	@Override
	public HashMap<String,Object> reportWidgetsMainData(String userName, String reportId){
		return ReportDAO.reportWidgetsMainData(userName, reportId);
	}
	
	//	@Override
	public HashMap<String,Object> reportWidgetsData(String userName, String selectedTables, String joinConditions, 
			String reportColumns, String params, String aggregateConditions){
				return ReportDAO.reportWidgetsData(userName, selectedTables, joinConditions, 
						reportColumns, params, aggregateConditions);
	}
}
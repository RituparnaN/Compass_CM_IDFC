package com.quantumdataengines.app.compass.service.missingFieldsReport;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.quantumdataengines.app.compass.dao.missingFieldsReport.MissingFieldsReportDAO;

@Service
public class MissingFieldsReportServiceImpl implements MissingFieldsReportService{

	@Autowired
	private MissingFieldsReportDAO missingFieldsReportDAO;

	@Override
	public List<Map<String, String>> getListOfBranchCodes() {
		return missingFieldsReportDAO.getListOfBranchCodes();
	}

	@Override
	public List<Map<String, String>> getListOfTemplates() {
		return missingFieldsReportDAO.getListOfTemplates();
	}

	@Override
	public Map<String, Object> searchMissingFieldsReport(String template,
			String branchCode, String complianceScore, String userCode,
			String ipAddress) {
		return missingFieldsReportDAO.searchMissingFieldsReport(template, branchCode, complianceScore, userCode, ipAddress);
	}

	
}

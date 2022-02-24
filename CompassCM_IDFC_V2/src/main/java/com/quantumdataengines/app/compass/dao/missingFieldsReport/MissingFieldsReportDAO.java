package com.quantumdataengines.app.compass.dao.missingFieldsReport;

import java.util.List;
import java.util.Map;


public interface MissingFieldsReportDAO {
	public List<Map<String, String>> getListOfBranchCodes();
	public List<Map<String, String>> getListOfTemplates();
	public Map<String, Object> searchMissingFieldsReport(String template, String branchCode, String complianceScore, String userCode, String ipAddress);
}

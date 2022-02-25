package com.quantumdataengines.app.compass.dao.reports;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface ReportWizardDAO {
	public List<Map<String, Object>> getAllBusinessObject();
	public Map<String, List<String>> getBusinessObjectsDetails(List<String> objectNameList);
	public List<String> getObjectColumns(String objectName);
	public String getColumnsDatatype(String objectName, String fieldName);
	public String saveReport(String reportObjects, String reportJoinDetails, String reportColumns, String conditionDetails, String aggregateConditions, 
			String reportId, String reportCode, String reportName, String reportHeader, String reportFooter, String isEnabled, String userCode,
			String objectHtml, String joinHtml, String reportHtml, String conditionHtml, String aggregateConditionHtml, String noOfParams);
	public String getObjectSelected(String reportId);
	public String createNewReportId();
	public String getReportDetails(String reportId, String section);
	public HashMap<String,Object> builReportData(String userName, String builtCondition, String reportID, String noOfParameters, HashMap<String,String> hashMap);
	public List<Map<String, String>> fetchReportBuilderParameters(String reportId, String parameterIndex);
	public String saveUpdateReportParameters(String noOfParam, String reportId, String parameterIndex, String userCode,
		     				 String parameterLabel,String parameterType, String isMandatory, String defaultValueType, String defaultValue);
	public String deleteReportParameters(String selected, String reportId);

}

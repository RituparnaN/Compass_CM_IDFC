package com.quantumdataengines.app.compass.service.reports;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface ReportWizardService {
	public List<Map<String, Object>> getAllBusinessObject();
	public String getBusinessObjectsDetails(List<String> objectNameList);
	public String formJoinField(List<String> objectNameList);
	public String getObjectColumns(String objectName);
	public String createSetConditionForm(List<String> objectNameList, String noOfParams);
	public String createReportColumnForm(List<String> objectNameList, List<Map<String, String>> selectedColumnsList);
	public String createSetAggregateConditionForm(List<String> objectNameList, String noOfParams);
	public String getColumnsDatatype(String objectName, String fieldName);
	public String saveReport(String reportObjects, String reportJoinDetails, String reportColumns, String conditionDetails, String aggregateConditions, 
			String reportId, String reportCode, String reportName, String reportHeader, String reportFooter, String isEnabled, String userCode,
			String objectHtml, String joinHtml, String reportHtml, String conditionHtml, String aggregateConditionHtml, String noOfParams);
	public String getObjectSelected(String reportId);
	public String createNewReportId();
	public String getReportDetails(String reportId, String section);
	public HashMap<String,Object> builReportData(String userName, String builtCondition, String reportId, String noOfParameters, HashMap<String,String> hashMap);
	public List<Map<String, String>> fetchReportBuilderParameters(String reportId, String parameterIndex);
	public String saveUpdateReportParameters(String noOfParam, String reportId, String parameterIndex, String userCode,
		     				 String parameterLabel,String parameterType, String isMandatory, String defaultValueType, String defaultValue);
	public String deleteReportParameters(String selected, String reportId);
}

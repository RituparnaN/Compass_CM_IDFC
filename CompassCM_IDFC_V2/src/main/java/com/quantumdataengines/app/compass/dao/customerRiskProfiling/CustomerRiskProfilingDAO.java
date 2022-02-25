package com.quantumdataengines.app.compass.dao.customerRiskProfiling;

import java.util.List;
import java.util.Map;

public interface CustomerRiskProfilingDAO {
	public List<Map<String, Object>> getAllBusinessObject(String userCode,String userRole, String remoteAddr);
	public String createNewRuleId(String userCode,String userRole, String remoteAddr);
	public Map<String, List<String>> getAllTableColumns(List<String> listObject,String userCode,String userRole, String remoteAddr);
    public String getColumnsDatatype(String objectName, String colName);
	public Map<String, String> getTableObjectColumns(String objectTableName,String userCode,String userRole, String remoteAddr);
	public Map<String, String> getCRPTableColumnValues(String tableName,String columnName,String userCode,String userRole, String remoteAddr);
	public Map<String, Object> saveCustomerRiskProfileRules(String tableNames, String ruleId,String ruleCode, String ruleName, String risk, String isEnable,
			String rule,String ruleConditionHTML, String userCode, String userRole, String remoteAddr, String makerComment,String CRPRuleFor);
	public String getCRPRulesDetails(String ruleID, String section,String userCode,String userRole, String remoteAddr);
	public String CRPobjectToSelect(String ruleID,String userCode,String userRole, String remoteAddr);
	public Map<String, Object> validateCRPRules(String rule, String ruleID, String userCode,String userRole, String remoteAddr);
	public Map<String, Object> getRuleDetails(String ruleID,String CRPRuleStatus, String userCode,String userRole, String remoteAddr);
	public String CRPRuleStatusChange(String ruleID, String comment,String cRPRuleStatus, String userCode, String userRole,String remoteAddr);	
}

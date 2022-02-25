package com.quantumdataengines.app.compass.service.master;

import java.util.List;
import java.util.Map;

public interface GenericMasterService {
	public List<Map<String, Object>> getModuleParameters(String moduleType, String userCode, String userRole, String ipAddress);
	public Map<String, Object> searchGenericMaster(Map<String, String> paramMap, String moduleType, String userCode, String userRole, String ipAddress);
	public Map<String, Object> getModuleDetails(String moduleCode, String moduleValue, String userCode, String groupCode, String ipAddress);
	public String saveSuspiciousTransaction(String alertNo, String txnDate, String txnMode, String debitcredit,
			String amount, String remarks, String userCode);
	public List<Map<String,String>> getSuspiciousTransaction(String alertNo);
	public Map<String, String> showSuspiciousTransactionDetails(String seqNo, String alertNo);
	public String deleteSuspiciousTransactionDetails(String seqNo, String alertNo);
	public String updateSuspiciousTransaction(String alertNo, String seqNo, String txnDate, String txnMode, String debitcredit,
			String amount, String remarks, String userCode);
	public String submitReportOfSuspicion(String alertNo, String reportingOn, String branchCode, String accountOrPersonName, String alertRating,
			   String accountNo, String customerId, String others, String address1, String address2, String typeOfSuspicion, String reasonForSuspicion,
			   String rasUserCode, String userCode, String userRole, String ipAddress);
	public Map<String, String> getOptionNameValueFromView(String viewName);
	public String updateCustomerEntityEnrichment(String fieldsData, String status, String customerId, String userCode, String groupCode, String ipAddress);
	public String updateCustomerOverRideRiskDetails(String fieldsData, String status, String customerId, String userCode, String groupCode, String ipAddress);
	public String updateProductExclusionDetails(String fieldsData, String status, String productCode, 
			String userCode, String groupCode, String ipAddress);
	public String updateSubGroupingCodeDetails(String fieldsData, String status, String transactionType, 
			String userCode, String groupCode, String ipAddress);
	public List<Map<String, String>> getLinkedTransactions(String alertNo);
	public List<String> getViewOrTableColumns(String objectName);
	public Map<String, Object> searchGenericModuleFields(String viewName, String searchBy, String searchString, String columnName);
	public List<Map<String, String>> openSubjectiveAlertWindow();
	public String generateSubjectiveAlert(String transactionNo, String alertCode, String userCode, String userRole);
	public List<Map<String, String>> viewAccountStatement(Map<String, String> paramTempMap);
	public Map<String, Object> searchMasterWithModuleType(Map<String, String> paramMap, String moduleType, String userCode, String userRole, String ipAddress);	
	public Map<String, Object> getDocumentFromWSDL(String customerId, String documentCode);
	
	/*CHANGES STARTED reset column (enable and disable)*/
	public Map<String,Object> saveDisabledColumnsData(String[] disabledColumns,String moduleCode,String userCode, String userRole, String ipAdress);
	/*CHANGES ENDED*/
	//public Map<String, Object> getFileTypeAndName(String parameters , String number, String isLoggedData, String userCode, String userRole, String ipAddress);
	
	/*public Map<String, Object> validationCheck(String accountNo, String customerId);*/
	
	public List<Map<String, String>> getRASUsersList(String userCode, String userRole, String ipAddress);
	public List<Map<String, Object>> getReasonForSuspicion(String tableName);
	public Map<String, String> getSuspicionScenarios(String tableName);
	public Map<String, Object> getFileTypeAndName(String parameters , String number,String userCode, String userRole, String ipAddress);
	
	public List<Map<String, String>> getNonCashChannelDetails(String channelType, String userCode,
			String ipAdress, String ap_fromDate, String ap_toDate, String ap_accountNo, String ap_custId);
	
	public List<Map<String, String>> getNonCashTransactionDetails(String counterPartyName, String channelType,
			String userCode, String ipAdress, String ap_fromDate, String ap_toDate, String ap_accountNo, String ap_custId);
	public Map<String, String> getEddQuestions(String accountType, String userCode, String userRole, 
			String ipAddress);
	public String saveEddQuestionRecords(String alertNo, String eddQuestions, String userCode, 
			String userRole, String ipAddress);
	public Map<String, String> viewEDDQuestionRecords(String caseNo, String userCode, String userRole, String ipAddress);
	public String updateEddQuestionRecords(String caseNo, String eddQuestions, String userCode, String userRole,
			String ipAddress);
	public Map<String, String> fetchAccountRelatedData(String accountNo, String userCode, String userRole, String ipAddress);
	public Map<String, Object> fetchAlertNoTxnNoMappings(String alertNo, String userCode, String userRole,
			String ipAddress);
	public Map<String, Object> fetchAccountNoBasedTransactions(String accountNo, String fromDate, String toDate, String userCode, String userRole,
			String ipAddress);
	public Map<String, Object> updateAccountRSPTransactions(String alertNo, String accountNo, String transactionNo,
			String action, String userCode, String userRole, String ipAddress);
	public int getEddQuestionCount(String caseNo, String userCode, String userRole, String ipAddress);
}

package com.quantumdataengines.app.compass.service.master;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.quantumdataengines.app.compass.dao.master.GenericMasterDAO;

@Service
public class GenericMasterServiceImpl implements GenericMasterService {
	
	@Autowired
	private GenericMasterDAO genericMasterDAO;
	
	@Override
	public List<Map<String, Object>> getModuleParameters(String moduleType, String userCode, String userRole, String ipAddress) {
		return genericMasterDAO.getModuleParameters(moduleType, userCode, userRole, ipAddress);
	}
	
	@Override
	public Map<String, Object> searchGenericMaster(Map<String, String> paramMap, String moduleType, String userCode, String userRole, String ipAddress) {
		return genericMasterDAO.searchGenericMaster(paramMap, moduleType, userCode, userRole, ipAddress);
	}

	@Override
	public Map<String, Object> getModuleDetails(String moduleCode, String moduleValue, String userCode, String groupCode, String ipAddress) {
		return genericMasterDAO.getModuleDetails(moduleCode, moduleValue, userCode, groupCode, ipAddress);
	}

	@Override
	public String saveSuspiciousTransaction(String alertNo, String txnDate,
			String txnMode, String debitcredit, String amount, String remarks,
			String userCode) {
		return genericMasterDAO.saveSuspiciousTransaction(alertNo, txnDate, txnMode, debitcredit, amount, remarks, userCode);
	}

	@Override
	public List<Map<String, String>> getSuspiciousTransaction(String alertNo) {
		return genericMasterDAO.getSuspiciousTransaction(alertNo);
	}

	@Override
	public Map<String, String> showSuspiciousTransactionDetails(String seqNo, String alertNo) {
		return genericMasterDAO.showSuspiciousTransactionDetails(seqNo, alertNo);
	}

	@Override
	public String deleteSuspiciousTransactionDetails(String seqNo, String alertNo) {
		return genericMasterDAO.deleteSuspiciousTransactionDetails(seqNo, alertNo);
	}

	@Override
	public String updateSuspiciousTransaction(String alertNo, String seqNo,
			String txnDate, String txnMode, String debitcredit, String amount,
			String remarks, String userCode) {
		return genericMasterDAO.updateSuspiciousTransaction(alertNo, seqNo, txnDate, txnMode, debitcredit, amount,
				remarks, userCode);
	}
   
	@Override
	public String submitReportOfSuspicion(String alertNo, String reportingOn, String branchCode, String accountOrPersonName, String alertRating,
			   String accountNo, String customerId, String others, String address1, String address2, String typeOfSuspicion, String reasonForSuspicion,
			   String rasUserCode, String userCode, String userRole, String ipAddress){
		return genericMasterDAO.submitReportOfSuspicion(alertNo, reportingOn, branchCode, accountOrPersonName, alertRating, accountNo, customerId, 
				others, address1, address2, typeOfSuspicion, reasonForSuspicion, rasUserCode, userCode, userRole, ipAddress);
	}
  
	@Override
	public Map<String, String> getOptionNameValueFromView(String viewName) {
		return genericMasterDAO.getOptionNameValueFromView(viewName);
	}

	@Override
	public String updateCustomerEntityEnrichment(String fieldsData, String status, String customerId, String userCode,
			String groupCode, String ipAddress) {
		return genericMasterDAO.updateCustomerEntityEnrichment(fieldsData, status, customerId, userCode, groupCode, ipAddress);
	}
	
	@Override
	public String updateCustomerOverRideRiskDetails(String fieldsData, String status, String customerId, String userCode, String groupCode, String ipAddress) {
		return genericMasterDAO.updateCustomerOverRideRiskDetails(fieldsData, status, customerId, userCode, groupCode, ipAddress);
	}
	
	@Override
	public List<Map<String, String>> getLinkedTransactions(String alertNo){
		return genericMasterDAO.getLinkedTransactions(alertNo);
	}

	@Override
	public List<String> getViewOrTableColumns(String objectName) {
		return genericMasterDAO.getViewOrTableColumns(objectName);
	}

	@Override
	public Map<String, Object> searchGenericModuleFields(String viewName,
			String searchBy, String searchString, String columnName) {
		return genericMasterDAO.searchGenericModuleFields(viewName, searchBy, searchString, columnName);
	}

	@Override
	public List<Map<String, String>> openSubjectiveAlertWindow() {
		return genericMasterDAO.openSubjectiveAlertWindow();
	}

	@Override
	public String generateSubjectiveAlert(String transactionNo, String alertCode, String userCode, String userRole) {
	return genericMasterDAO.generateSubjectiveAlert(transactionNo, alertCode, userCode, userRole);
	}

	@Override
	public List<Map<String, String>> viewAccountStatement(Map<String, String> paramTempMap) {
		return genericMasterDAO.viewAccountStatement(paramTempMap);
	}

	@Override
	public Map<String, Object> searchMasterWithModuleType(Map<String, String> paramMap, String moduleType, String userCode, String userRole, String ipAddress) {
		return genericMasterDAO.searchMasterWithModuleType(paramMap, moduleType, userCode, userRole, ipAddress);
	}

	@Override
	public Map<String, Object> getDocumentFromWSDL(String customerId, String documentCode) {
		return genericMasterDAO.getDocumentFromWSDL(customerId, documentCode);
	}

	/*CHANGES STARTED*/
	@Override
	public Map<String,Object> saveDisabledColumnsData(String[] disabledColumns,String moduleCode,String userCode, String userRole, String ipAdress) {
		return genericMasterDAO.saveDisabledColumnsData(disabledColumns, moduleCode,userCode, userRole, ipAdress);
	}
	/*CHANGES ENDED*/

	@Override
	public String updateProductExclusionDetails(String fieldsData, String status, String productCode, String userCode,
			String groupCode, String ipAddress) {
		return genericMasterDAO.updateProductExclusionDetails(fieldsData, status, productCode, userCode, groupCode, ipAddress);
	}

	@Override
	public String updateSubGroupingCodeDetails(String fieldsData, String status, String transactionType, String userCode,
			String groupCode, String ipAddress) {
		return genericMasterDAO.updateSubGroupingCodeDetails(fieldsData, status, transactionType, userCode, groupCode, ipAddress);
	}

	/*@Override
	public Map<String, Object> getFileTypeAndName(String parameters,String number, String isLoggedData, String userCode, String userRole, String ipAddress) {
		return genericMasterDAO.getFileTypeAndName(parameters,number,isLoggedData,userCode,userRole,ipAddress);
	}*/
	
	@Override
	public Map<String, Object> getFileTypeAndName(String parameters,String number,String userCode, String userRole, String ipAddress) {
		return genericMasterDAO.getFileTypeAndName(parameters,number,userCode,userRole,ipAddress);
	}

	@Override
	public List<Map<String, String>> getRASUsersList(String userCode,
			String userRole, String ipAddress) {
		return genericMasterDAO.getRASUsersList(userCode, userRole, ipAddress);
	}

	@Override
	public List<Map<String, Object>> getReasonForSuspicion(String tableName) {
		return genericMasterDAO.getReasonForSuspicion(tableName);
	}

	@Override
	public Map<String, String> getSuspicionScenarios(String tableName) {
		return genericMasterDAO.getSuspicionScenarios(tableName);
	}
	
	/*@Override
	public Map<String, Object> validationCheck(String accountNo, String customerId) {
		return genericMasterDAO.validationCheck(accountNo, customerId);
	}*/
	
	@Override
	public List<Map<String, String>> getNonCashChannelDetails(String channelType, String userCode,
			String ipAdress, String ap_fromDate, String ap_toDate, String ap_accountNo, String ap_custId) {
		return genericMasterDAO.getNonCashChannelDetails(channelType, userCode, ipAdress, 
				ap_fromDate, ap_toDate, ap_accountNo, ap_custId);
	}
	
	@Override
	public List<Map<String, String>> getNonCashTransactionDetails(String counterPartyName, String channelType,
			String userCode, String ipAdress, String ap_fromDate, String ap_toDate, String ap_accountNo,
			String ap_custId) {
		return genericMasterDAO.getNonCashTransactionDetails(counterPartyName, channelType, userCode, ipAdress, 
				ap_fromDate, ap_toDate, ap_accountNo, ap_custId);
	}
	@Override
	public Map<String, String> getEddQuestions(String accountType, String userCode, String userRole, String ipAddress) {
		return genericMasterDAO.getEddQuestions(accountType, userCode, userRole, ipAddress);
	}

	@Override
	public String saveEddQuestionRecords(String alertNo, String eddQuestions, String userCode, String userRole,
			String ipAddress) {
		return genericMasterDAO.saveEddQuestionRecords(alertNo, eddQuestions, userCode, userRole, ipAddress);
	}

	@Override
	public Map<String, String> viewEDDQuestionRecords(String caseNo, String userCode, String userRole, String ipAddress) {
		return genericMasterDAO.viewEDDQuestionRecords(caseNo, userCode, userRole, ipAddress);
	}

	@Override
	public String updateEddQuestionRecords(String caseNo, String eddQuestions, String userCode, String userRole,
			String ipAddress) {
		return genericMasterDAO.updateEddQuestionRecords(caseNo, eddQuestions, userCode, userRole, ipAddress);
	}

	@Override
	public Map<String, String> fetchAccountRelatedData(String accountNo, String userCode, String userRole, String ipAddress) {
		return genericMasterDAO.fetchAccountRelatedData(accountNo, userCode, userRole, ipAddress);
	}

	@Override
	public Map<String, Object> fetchAlertNoTxnNoMappings(String alertNo, String userCode, String userRole,
			String ipAddress) {
		return genericMasterDAO.fetchAlertNoTxnNoMappings(alertNo, userCode, userRole, ipAddress);
	}

	@Override
	public Map<String, Object> fetchAccountNoBasedTransactions(String accountNo, String fromDate, String toDate, String userCode, String userRole,
			String ipAddress) {
		return genericMasterDAO.fetchAccountNoBasedTransactions(accountNo, fromDate, toDate, userCode, userRole, ipAddress);
	}

	@Override
	public Map<String, Object> updateAccountRSPTransactions(String alertNo, String accountNo, String transactionNo,
			String action, String userCode, String userRole, String ipAddress) {
		return genericMasterDAO.updateAccountRSPTransactions(alertNo, accountNo, transactionNo, action, userCode, userRole, ipAddress);
	}

	@Override
	public int getEddQuestionCount(String caseNo, String userCode, String userRole, String ipAddress) {
		return genericMasterDAO.getEddQuestionCount(caseNo, userCode, 
				userRole, ipAddress);
	}

}

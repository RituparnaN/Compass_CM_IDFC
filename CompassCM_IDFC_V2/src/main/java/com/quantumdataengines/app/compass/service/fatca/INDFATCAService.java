package com.quantumdataengines.app.compass.service.fatca;

import java.util.List;
import java.util.Map;

public interface INDFATCAService {
	public Map<String, String> getIndianFATCAStatementDetails(String caseNo, String usercode);
	public List<Map<String, Object>> getReportAccountDetails(String caseNo);
	public void updateStatementDetails(Map<String, String> formData, String userCode);
	public void addUpdateINDFATCAAccount(String caseNo, String userCode, Map<String, String> formData, String action);
	public void deleteINDFATCAAccountDetails(String caseNo, String accountNo);
	public List<Map<String, String>> getAccountIndividualDetails(String caseNo, String accountNo);
	public List<Map<String, String>> getAccountEntityDetails(String caseNo, String accountNo);
	public List<Map<String, String>> getAccountControllingPersonDetails(String caseNo, String accountNo);
	public void saveUpdateINDFATCAIndividual(String caseNo, String accountNo, String idValue, String action, Map<String, String> formData, String userCode);
	public void saveUpdateINDFATCAEntity(String caseNo, String accountNo, String idValue, String action, Map<String, String> formData, String userCode);
	public void saveUpdateINDFATCAControllingPerson(String caseNo, String accountNo, String idValue, String action, Map<String, String> formData, String userCode);
	public void deleteIndividualEntityControllingPerson(String caseNo, String accountNo, String type, String typeId);
	public List<String> getReportFileData(String caseNo, String userId);
}

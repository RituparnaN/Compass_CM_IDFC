package com.quantumdataengines.app.compass.dao.fatca;

import java.util.List;
import java.util.Map;

public interface INDFATCADAO {
	public Map<String, String> getIndianFATCAStatementDetails(String caseNo, String usercode);
	public List<Map<String, Object>> getReportAccountDetails(String caseNo);
	public void updateStatementDetails(Map<String, String> formData, String userCode);
	public void addINDFATCAAccount(String caseNo, String userCode, Map<String, String> formData);
	public void updateINDFATCAAccount(String caseNo, String userCode, Map<String, String> formData);
	public void deleteINDFATCAAccountDetails(String caseNo, String accountNo);
	public List<Map<String, String>> getAccountIndividualDetails(String caseNo, String accountNo);
	public List<Map<String, String>> getAccountEntityDetails(String caseNo, String accountNo);
	public List<Map<String, String>> getAccountControllingPersonDetails(String caseNo, String accountNo);
	public void addINDFATCAIndividual(String caseNo, String accountNo, String userCode, Map<String, String> formData);
	public void updateINDFATCAIndividual(String caseNo, String accountNo, String idValue, String userCode, Map<String, String> formData);
	public void addINDFATCAEntity(String caseNo, String accountNo, String userCode, Map<String, String> formData);
	public void updateINDFATCAEntity(String caseNo, String accountNo, String userCode, String idValue, Map<String, String> formData);
	public void addINDFATCAControllingPerson(String caseNo, String accountNo, String userCode, Map<String, String> formData);
	public void updateINDFATCAControllingPerson(String caseNo, String accountNo, String userCode, String idValue, Map<String, String> formData);
	public void deleteINDFATCAIndividual(String caseNo, String accountNo, String individualId);
	public void deleteINDFATCAEntity(String caseNo, String accountNo, String entityId);
	public void deleteINDFATCAControllingPerson(String caseNo, String accountNo, String controllingPersonId);
	public List<String> getReportFileData(String caseNo, String userId);
}

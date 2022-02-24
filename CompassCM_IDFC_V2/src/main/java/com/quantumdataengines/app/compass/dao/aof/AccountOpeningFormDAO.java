package com.quantumdataengines.app.compass.dao.aof;

import java.io.File;
import java.util.List;
import java.util.Map;

public interface AccountOpeningFormDAO {
	public Map<String, String> getAllCountry();
	public String getCIFNoByAccountNo(String accountNo);
	public List<String> getAccountNosByCIFNo(String cifNo);
	public boolean checkCIFNoAccountNo(String cifNo, String accountNo);
	public boolean checkCIF(String cifNo);
	public boolean checkAccountNo(String accountNo);
	public Map<String, Object> getAccountOpeningFormData(String cifNumber, String accountNumber, String caseNo, String userCode, String userType);
	public Map<String, Object> getAccountHolderDetails(String accountHolderType, String cifNumber, String accountNumber, String lineNo);
	public Map<String, String> getValueAddedServiceDetails(String cifNumber, String accountNumber, String lineNo);
	public Map<String, Object> saveFormData(Map<String, String> formData, String caseNo, String UPDATEDBY, String status);
	public String uploadFormDocument(String caseNo, String cifNo, String accountNo, String docName, String fileName, File file, String status, String uploadBy);
	public Map<String, Object> downloadFormUploadFile(String uploadRefNo);
	public String saveValueAddedService(String caseNo, Map<String, String> formData, String UPDATEDBY, String status);
	public String saveAccountHolderDetails(String caseNo, Map<String, String> formData, String accountHolderType, String UPDATEDBY, String status, String lineNumber);
	public List<Map<String, String>> getFormStatus(String userId, String fromDate, String toDate, String status, boolean isChecker);
	public Map<String, String> getFormStatus(String cifNumber, String accNumber);
	public List<Map<String, String>> getFormAuditLog(String cifNumber);
	public String saveCheckerResponse(String caseNo, String cifNumber, String accountNo, String remark, String status, String checkedBy, String rejectedFileds, String reasonOfRejection);
	public String deleteDocument(String caseNo, String cifNo, String accountNo, String docRefNo, String userCode);
	public String getServerFilePath(String serverFileRefNo);
	public void truncateServerFilesTable();
	public int saveFetchedAccountOpeningMandateInfo(List<Map<String, String>> fetchedAOF);
	public Map<String, Object> getAccountDetails(String cifNo, String accountNo, String caseNo);
	public Map<String, Object> saveAccountData(Map<String, String> formData, String caseNo, String cifNumber, String accNumber, String USERCODE, String status);
	
	public int countCIFForAssign(String branchCode, String cifType, String cifNo, String accountNo, String excludeApproved);
	public Map<String, List<Map<String, String>>> getBranchCifTypeForAssignCIF();
	public Map<String, List<Map<String, String>>> getCheckerMakerCode();
	public int assignCIF(String branchCode, String cifType, String cifNo, String accountNo, String noOfCase, String makerCode, String checkerCode, String excludeApproved);
	public List<Map<String, String>> checkCasesForReAssign(String fromDate, String toDate, String branchCode, String cifType, String cifNumber, 
			String accountNo, String makerCode, String checkerCode);
	public int reassignCases(String makerId, String checkerId, String caseList);
	public int unassignCases(String caseList);
	public void saveMandateFetchStatus(String startDate, String endDate, String path, String count, String updateBy);
	public List<Map<String, String>> getAOFFetchLog();
}

package com.quantumdataengines.app.compass.service.regulatoryReports.india;

import java.io.File;
import java.util.HashMap;
import java.util.Map;

import com.quantumdataengines.app.compass.model.regulatoryReports.india_STR_TRF.ISTRTRFBranchDetailsVO;
import com.quantumdataengines.app.compass.model.regulatoryReports.india_STR_TRF.ISTRTRFEntityDetailsVO;
import com.quantumdataengines.app.compass.model.regulatoryReports.india_STR_TRF.ISTRTRFIndividualDetailsVO;
import com.quantumdataengines.app.compass.model.regulatoryReports.india_STR_TRF.ISTRTRFManualDetailsVO;
import com.quantumdataengines.app.compass.model.regulatoryReports.india_STR_TRF.ISTRTRFTransactionDetailsVO;

public interface INDSTRTRFService {
	public boolean addBranchDetailsToList(String caseNo, String branchSeqNo, String userCode, String terminalId, ISTRTRFBranchDetailsVO branchDetailsVO);
	public boolean addTransactionDetailsToList(String caseNo,String transactionSeqNo, String userCode, String terminalId, ISTRTRFTransactionDetailsVO transactionDetailsVO);
	public HashMap getINDSTRTRFReport(String caseNo, String userCode, String userRole);
    public void ExecuteSTRTRFXMLProcedures(String caseNo, String userCode);
    public boolean executeFileUploadProcedures(String caseNo, String transactionNo, String fullFilePath, 
			String tempTableName, int colCount, String userCode, String userRole, String ipAddress);
	public Map<String, Object> executeFile(File inputFile, String procName);	
	public HashMap getNewTransactionDetails(String transactionDate, String transactionType, String instrumentType, String currencyCode, String amountInRupees, String caseNo, String transactionSeqNo);
	public boolean deleteTransactionDetails(String transactionDate, String transactionType, String instrumentType, String currencyCode, String amountInRupees, String transactionSeqNo, String userCode, String caseNo);
	public HashMap getNewBranchDetails(String branchName, String branchRefNo, String caseNo, String branchSeqNo);
	public boolean deleteBranchDetails(String branchName, String branchRefNo, String branchSeqNo, String userCode, String caseNo);
	public HashMap getSTRTRFXMlFileContent(String caseNo, String userCode);
	public boolean saveISTRTRFManualDetails(String caseNo, String userCode, ISTRTRFManualDetailsVO objManualFormVO);
	public boolean saveSTRTRFTransactionFile(String caseNo, String fullFilePath, File inputFile, 
			String userCode, String userRole, String ipAddress);
	public boolean addEntityDetailsToList(String strCaseNo, String strUserCode, String strTerminalId, String strAccountNo, 
    		String relationFlag, String legalAccountNo, String legalCustomerId, String legalCustomerName, String legalBSRCode, 
    		ISTRTRFEntityDetailsVO legalDetailsDTO);
	public boolean addIndividualDetailsToList(String caseNo, String userCode, String terminalId, String accountNo, String relationFlag, 
			String counterAccountNo, String counterId, String counterName, String bsrCode, ISTRTRFIndividualDetailsVO individualDetailsVO);
}
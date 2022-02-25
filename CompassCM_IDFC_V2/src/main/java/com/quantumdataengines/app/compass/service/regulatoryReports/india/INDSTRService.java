package com.quantumdataengines.app.compass.service.regulatoryReports.india;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import com.quantumdataengines.app.compass.model.regulatoryReports.india.ISTRAccountDetailsVO;
import com.quantumdataengines.app.compass.model.regulatoryReports.india.ISTRIndividualDetailsVO;
import com.quantumdataengines.app.compass.model.regulatoryReports.india.ISTREntityDetailsVO;
import com.quantumdataengines.app.compass.model.regulatoryReports.india.ISTRManualDetailsVO;

public interface INDSTRService {
    public boolean addAccountDetailsToList(String caseNo, String userCode, String terminalId, String accountNo, ISTRAccountDetailsVO accountDetailsVO);
    public boolean addIndividualDetailsToList(String caseNo, String userCode, String terminalId, String accountNo, String relationFlag, String counterAccountNo, String counterPartyId, String counterPartyName, String bsrCode, ISTRIndividualDetailsVO individualDetailsVO);
    public boolean addEntityDetailsToList(String caseNo, String usercode, String terminalId, String accountNo, 
    		String relationFlag, String legalAccountNo, String legalCustomerId, String legalCustomerName, String legalBSRCode, ISTREntityDetailsVO legalPersonDetailsVO);
    public abstract boolean addTransactionsToList(String caseNo, String userCode, String terminalId, String transactionNo, ISTRAccountDetailsVO accountDetailsVO);
    
    public abstract HashMap getNewIndividualDetails(String counterPartyName, String counterPartyId, String accountNo, String caseNo);
    public abstract boolean deleteIndividualDetails(String counterPartyName, String counterPartyId, String accountNo, String userCode, String caseNo, String relationType);   
    public abstract HashMap getEntityDetails(String legalAccountNo, String legalCustomerName, String legalCustomerId, String caseNo);
    public abstract boolean deleteEntityDetails(String legalAccountNo, String legalCustomerName, String legalCustomerId, String userCode, String caseNo);
    public abstract HashMap getNewAccountDetails(String accountNo, String customerName, String caseNo);
    public abstract boolean deleteAccountDetails(String customerName, String accountNo, String dataType, String userCode, String caseNo);
    public abstract HashMap getNewTransactionDetails(String caseNo, String accountNo, String transactionNo);
    public abstract boolean deleteTransactionDetails(String caseNo, String transactionNo, String accountNo, String userCode);
    public abstract boolean saveISTRManualDetails(String caseNo, String userCode, ISTRManualDetailsVO manualDetailsVO);
    public HashMap getINDSTRReport(String caseNo, String userCode, String userRole);
    public HashMap getSTRXMlFileContent(String caseNo, String userCode);
    public boolean saveSTRTransactionFile(String caseNo, String accountNo, String fullFilePath, File inputFile, String userCode, String userRole, String ipAddress);
    public boolean autoSaveINDSTRTransactions(String caseNo, String accountNo, String fromDate, String toDate, String saveOrDelete, String userCode);
	public Map<String, Object> executeFile(File inputFile, String procName);
	public Map<String,Object> exportAccountTxnDetails(Map<String, String> paramMap);
	public Map<String,Object> exportConsildatedExceptionReport(Map<String, String> paramMap);
}
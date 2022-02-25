package com.quantumdataengines.app.compass.service.regulatoryReports.india;

import java.io.File;
import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.quantumdataengines.app.compass.dao.regulatoryReports.india.INDSTRDAO;
import com.quantumdataengines.app.compass.model.regulatoryReports.india.ISTRAccountDetailsVO;
import com.quantumdataengines.app.compass.model.regulatoryReports.india.ISTREntityDetailsVO;
import com.quantumdataengines.app.compass.model.regulatoryReports.india.ISTRIndividualDetailsVO;
import com.quantumdataengines.app.compass.model.regulatoryReports.india.ISTRManualDetailsVO;

@Service
public class INDSTRServiceImpl implements INDSTRService {
	private INDSTRDAO INDSTRDAO;
	@Autowired
	public INDSTRServiceImpl(INDSTRDAO INDSTRDAO) {
		this.INDSTRDAO = INDSTRDAO;
	}
    public boolean addAccountDetailsToList(String caseNo, String userCode, String terminalId, String accountNo, ISTRAccountDetailsVO accountDetailsVO){
		return INDSTRDAO.addAccountDetailsToList(caseNo, userCode, terminalId, accountNo, accountDetailsVO);
    }
    public boolean addIndividualDetailsToList(String caseNo, String userCode, String terminalId, String accountNo, String relationFlag, String counterAccountNo, String counterPartyId, String counterPartyName, String bsrCode, ISTRIndividualDetailsVO individualDetailsVO){
    	return INDSTRDAO.addIndividualDetailsToList(caseNo, userCode, terminalId, accountNo, relationFlag, counterAccountNo, counterPartyId, counterPartyName, bsrCode, individualDetailsVO);
    }
    public boolean addEntityDetailsToList(String caseNo, String usercode, String terminalId, String accountNo, 
    		String relationFlag, String legalAccountNo, String legalCustomerId, String legalCustomerName, String legalBSRCode, ISTREntityDetailsVO legalPersonDetailsVO){
    	return INDSTRDAO.addEntityDetailsToList(caseNo, usercode, terminalId, accountNo, 
        		relationFlag, legalAccountNo, legalCustomerId, legalCustomerName, legalBSRCode, legalPersonDetailsVO);
    }
    public boolean addTransactionsToList(String caseNo, String userCode, String terminalId, String transactionNo, ISTRAccountDetailsVO accountDetailsVO){
		return INDSTRDAO.addTransactionsToList(caseNo, userCode, terminalId, transactionNo, accountDetailsVO);
    }
    public HashMap getNewIndividualDetails(String counterPartyName, String counterPartyId, String accountNo, String caseNo){
		return INDSTRDAO.getNewIndividualDetails(counterPartyName, counterPartyId, accountNo, caseNo);
    }
    public boolean deleteIndividualDetails(String counterPartyName, String counterPartyId, String accountNo, String userCode, String caseNo, String relationType){
		return INDSTRDAO.deleteIndividualDetails(counterPartyName, counterPartyId, accountNo, userCode, caseNo, relationType);
    }
    public HashMap getEntityDetails(String legalAccountNo, String legalCustomerName, String legalCustomerId, String caseNo){
		return INDSTRDAO.getEntityDetails(legalAccountNo, legalCustomerName, legalCustomerId, caseNo);
    }
    public boolean deleteEntityDetails(String legalAccountNo, String legalCustomerName, String legalCustomerId, String userCode, String caseNo){
		return INDSTRDAO.deleteEntityDetails(legalAccountNo, legalCustomerName, legalCustomerId, userCode, caseNo);
    }
    public HashMap getNewAccountDetails(String accountNo, String customerName, String caseNo){
		return INDSTRDAO.getNewAccountDetails(accountNo, customerName, caseNo);
    }
    public boolean deleteAccountDetails(String customerName, String accountNo, String dataType, String userCode, String caseNo){
		return INDSTRDAO.deleteAccountDetails(customerName, accountNo, dataType, userCode, caseNo);
    }
    public HashMap getNewTransactionDetails(String caseNo, String accountNo, String transactionNo){
		return INDSTRDAO.getNewTransactionDetails(caseNo, accountNo, transactionNo);
    }
    public boolean deleteTransactionDetails(String caseNo, String transactionNo, String accountNo, String userCode){
		return INDSTRDAO.deleteTransactionDetails(caseNo, transactionNo, accountNo, userCode);
    }
    public boolean saveISTRManualDetails(String caseNo, String userCode, ISTRManualDetailsVO manualDetailsVO){
    	return INDSTRDAO.saveISTRManualDetails(caseNo, userCode, manualDetailsVO);
    }
	public HashMap getINDSTRReport(String caseNo, String userCode, String userRole) {
		return INDSTRDAO.getINDSTRReport(caseNo, userCode, userRole);
	}
	public HashMap getSTRXMlFileContent(String caseNo, String userCode){
		return INDSTRDAO.getSTRXMlFileContent(caseNo, userCode);
	}
	public boolean autoSaveINDSTRTransactions(String caseNo, String accountNo, String fromDate, String toDate, String saveOrDelete, String userCode){
		return INDSTRDAO.autoSaveINDSTRTransactions(caseNo, accountNo, fromDate, toDate, saveOrDelete, userCode);
	}
	public boolean saveSTRTransactionFile(String caseNo, String accountNo, String fullFilePath, File inputFile, String userCode, String userRole, String ipAddress) {
		return INDSTRDAO.saveSTRTransactionFile(caseNo, accountNo, fullFilePath, inputFile, userCode, userRole, ipAddress);
	}
	public Map<String, Object> executeFile(File inputFile, String procName){
		return INDSTRDAO.executeFile(inputFile, procName);
	}
	public Map<String,Object> exportAccountTxnDetails(Map<String, String> paramMap){
		return INDSTRDAO.exportAccountTxnDetails(paramMap);
	}
	public Map<String,Object> exportConsildatedExceptionReport(Map<String, String> paramMap){
		return INDSTRDAO.exportConsildatedExceptionReport(paramMap);
	}

}
package com.quantumdataengines.app.compass.service.regulatoryReports.india;

import java.io.File;
import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.quantumdataengines.app.compass.dao.regulatoryReports.india.INDSTRTRFDAO;
import com.quantumdataengines.app.compass.model.regulatoryReports.india_STR_TRF.ISTRTRFBranchDetailsVO;
import com.quantumdataengines.app.compass.model.regulatoryReports.india_STR_TRF.ISTRTRFEntityDetailsVO;
import com.quantumdataengines.app.compass.model.regulatoryReports.india_STR_TRF.ISTRTRFIndividualDetailsVO;
import com.quantumdataengines.app.compass.model.regulatoryReports.india_STR_TRF.ISTRTRFManualDetailsVO;
import com.quantumdataengines.app.compass.model.regulatoryReports.india_STR_TRF.ISTRTRFTransactionDetailsVO;

@Service
public class INDSTRTRFServiceImpl implements INDSTRTRFService {
	
	private INDSTRTRFDAO INDSTRTRFDAO;
	@Autowired
	public INDSTRTRFServiceImpl(INDSTRTRFDAO INDSTRTRFDAO) {
		this.INDSTRTRFDAO = INDSTRTRFDAO;
	}
	@Override
	public boolean addBranchDetailsToList(String caseNo, String branchSeqNo, String userCode, String terminalId,
			ISTRTRFBranchDetailsVO branchDetailsVO) {
		return INDSTRTRFDAO.addBranchDetailsToList(caseNo, branchSeqNo, userCode, terminalId, branchDetailsVO);
	}
	@Override
	public boolean addTransactionDetailsToList(String caseNo, String transactionSeqNo, String userCode, String terminalId, ISTRTRFTransactionDetailsVO transactionDetailsVO) {
		return INDSTRTRFDAO.addTransactionDetailsToList(caseNo, transactionSeqNo, userCode, terminalId, transactionDetailsVO);
	}
	@Override
	public HashMap getINDSTRTRFReport(String caseNo, String userCode, String userRole) {
		return INDSTRTRFDAO.getINDSTRTRFReport(caseNo, userCode, userRole);
	}
	@Override
	public void ExecuteSTRTRFXMLProcedures(String caseNo, String userCode) {
		
	}
	@Override
	public boolean executeFileUploadProcedures(String caseNo, String transactionNo, String fullFilePath,
			String tempTableName, int colCount, String userCode, String userRole, String ipAddress) {
		return INDSTRTRFDAO.executeFileUploadProcedures(caseNo, transactionNo, fullFilePath, tempTableName, colCount, userCode, userRole, ipAddress);
	}
	@Override
	public Map<String, Object> executeFile(File inputFile, String procName) {
		return INDSTRTRFDAO.executeFile(inputFile, procName);
	}
	@Override
	public HashMap getNewTransactionDetails(String transactionDate, String transactionType, String instrumentType,
			String currencyCode, String amountInRupees, String caseNo, String transactionSeqNo) {
		return INDSTRTRFDAO.getNewTransactionDetails(transactionDate, transactionType, instrumentType, currencyCode, amountInRupees, caseNo, transactionSeqNo);
	}
	@Override
	public boolean deleteTransactionDetails(String transactionDate, String transactionType, String instrumentType,
			String currencyCode, String amountInRupees, String transactionSeqNo, String userCode, String caseNo) {
		return INDSTRTRFDAO.deleteTransactionDetails(transactionDate, transactionType, instrumentType, currencyCode, amountInRupees, transactionSeqNo, userCode, caseNo);
	}
	@Override
	public HashMap getNewBranchDetails(String branchName, String branchRefNo, String caseNo, String branchSeqNo) {
		return INDSTRTRFDAO.getNewBranchDetails(branchName, branchRefNo, caseNo, branchSeqNo);
	}
	@Override
	public boolean deleteBranchDetails(String branchName, String branchRefNo, String branchSeqNo, String userCode, String caseNo) {
		return INDSTRTRFDAO.deleteBranchDetails(branchName, branchRefNo, branchSeqNo, userCode, caseNo);
	}
	@Override
	public HashMap getSTRTRFXMlFileContent(String caseNo, String userCode) {
		return INDSTRTRFDAO.getSTRTRFXMlFileContent(caseNo, userCode);
	}
	@Override
	public boolean saveISTRTRFManualDetails(String caseNo, String userCode, ISTRTRFManualDetailsVO manualDetailsVO) {
		return INDSTRTRFDAO.saveISTRTRFManualDetails(caseNo, userCode, manualDetailsVO);
	}
	@Override
	public boolean saveSTRTRFTransactionFile(String caseNo, String fullFilePath,
			File inputFile, String userCode, String userRole, String ipAddress) {
		return INDSTRTRFDAO.saveSTRTRFTransactionFile(caseNo, fullFilePath, inputFile, userCode, userRole, ipAddress);
	}
	@Override
	public boolean addEntityDetailsToList(String strCaseNo, String strUserCode, String strTerminalId,
			String strAccountNo, String relationFlag, String legalAccountNo, String legalCustomerId,
			String legalCustomerName, String legalBSRCode, ISTRTRFEntityDetailsVO legalDetailsDTO) {
		return INDSTRTRFDAO.addEntityDetailsToList(strCaseNo, strUserCode, strTerminalId, strAccountNo, relationFlag, 
				legalAccountNo, legalCustomerId, legalCustomerName, legalBSRCode, legalDetailsDTO);
	}
	@Override
	public boolean addIndividualDetailsToList(String caseNo, String userCode, String terminalId, String accountNo,
			String relationFlag, String counterAccountNo, String counterId, String counterName, String bsrCode,
			ISTRTRFIndividualDetailsVO individualDetailsVO) {
		return INDSTRTRFDAO.addIndividualDetailsToList(caseNo, userCode, terminalId, accountNo, relationFlag, counterAccountNo, 
				counterId, counterName, bsrCode, individualDetailsVO);
	}	
    
}
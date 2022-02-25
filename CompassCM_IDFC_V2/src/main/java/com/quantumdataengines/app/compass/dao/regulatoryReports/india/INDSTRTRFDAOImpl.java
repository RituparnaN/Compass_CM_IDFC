package com.quantumdataengines.app.compass.dao.regulatoryReports.india;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.StringTokenizer;
import java.util.Vector;

import javax.sql.DataSource;

import oracle.jdbc.OracleTypes;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Repository;

import com.quantumdataengines.app.compass.model.regulatoryReports.india.ISTREntityDetailsVO;
import com.quantumdataengines.app.compass.model.regulatoryReports.india.ISTRIndividualDetailsVO;
import com.quantumdataengines.app.compass.model.regulatoryReports.india_STR_TRF.ISTRTRFBranchDetailsVO;
import com.quantumdataengines.app.compass.model.regulatoryReports.india_STR_TRF.ISTRTRFEntityDetailsVO;
import com.quantumdataengines.app.compass.model.regulatoryReports.india_STR_TRF.ISTRTRFIndividualDetailsVO;
import com.quantumdataengines.app.compass.model.regulatoryReports.india_STR_TRF.ISTRTRFManualDetailsVO;
import com.quantumdataengines.app.compass.model.regulatoryReports.india_STR_TRF.ISTRTRFTransactionDetailsVO;
import com.quantumdataengines.app.compass.util.CommonUtil;
import com.quantumdataengines.app.compass.util.ConnectionUtil;

@Repository
public class INDSTRTRFDAOImpl implements INDSTRTRFDAO {
	
	@Autowired
	private ConnectionUtil connectionUtil;
	
	@Value("${compass.aml.config.schemaName}")
	private String schemaName;
	
	private static final Logger log = LoggerFactory.getLogger(INDSTRTRFDAOImpl.class);
	
	public Connection getConnection(){
		Connection connection = null;
		try{
			connection = connectionUtil.getConnection();
		}catch(Exception e){
			log.error("Error in creating db connection : INDSTRTRFDAOImpl -> "+e.getMessage());
			e.printStackTrace();
		}
		return connection;
	}
        
    public boolean saveISTRTRFManualDetails(String caseNo, String userCode, ISTRTRFManualDetailsVO manualFormVO)
    {
    	Connection connection = null;
    	CallableStatement callableStatement = null;
        boolean isSaved = false;
        System.out.println( stringConversion(manualFormVO.getSusGroundsP7()));
        System.out.println( stringConversion(manualFormVO.getSusGroundsP8()));
        try
        {
        	connection = connectionUtil.getConnection();
            callableStatement = connection.prepareCall("{CALL "+schemaName+"STP_ISTRTRFSAVEMANUALDETAILS(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");
            callableStatement.setString(1, caseNo);
            callableStatement.setString(2, manualFormVO.getSuspReason());
            callableStatement.setString(3, stringConversion(manualFormVO.getSusGroundsP7()));
            callableStatement.setString(4, stringConversion(manualFormVO.getSusGroundsP8()));
            callableStatement.setString(5, manualFormVO.getReportFlag());
            callableStatement.setString(6, manualFormVO.getMainPersonName());
            callableStatement.setString(7, manualFormVO.getSourceOfAlert());
            callableStatement.setString(8, stringConversion(manualFormVO.getAlertIndicators()));
            callableStatement.setString(9, manualFormVO.getSuspicionDueTo());   
            callableStatement.setString(10, manualFormVO.getAttemptedTransactions());
            callableStatement.setString(11, manualFormVO.getPriorityRating());
            callableStatement.setString(12, manualFormVO.getReportCoverage());
            callableStatement.setString(13, manualFormVO.getAdditionalDocuments());
            callableStatement.setString(14, manualFormVO.getLawEnforcementInformed());
            callableStatement.setString(15, stringConversion(manualFormVO.getLawEnforcementAgencyDetails()));
            callableStatement.setString(16, manualFormVO.getSignatureName());
            callableStatement.setString(17, manualFormVO.getReportingEntityName());
            callableStatement.setString(18, manualFormVO.getReportingEntityCategory());
            callableStatement.setString(19, manualFormVO.getReportingEntityCode());
            callableStatement.setString(20, manualFormVO.getReportingEntityFIUREID());
            callableStatement.setString(21, manualFormVO.getReportingBatchNo());
            callableStatement.setString(22, manualFormVO.getReportingBatchDate());
            callableStatement.setString(23, manualFormVO.getReportingBatchPertainingToMonth());
            callableStatement.setString(24, manualFormVO.getReportingBatchPertainingToYear());
            callableStatement.setString(25, manualFormVO.getReportingBatchType());
            callableStatement.setString(26, manualFormVO.getReportingOriginalBatchId());
            callableStatement.setString(27, manualFormVO.getPrincipalOfficersName());
            callableStatement.setString(28, manualFormVO.getPrincipalOfficersDesignation());
            callableStatement.setString(29, manualFormVO.getPrincipalOfficersAddress1());
            callableStatement.setString(30, manualFormVO.getPrincipalOfficersAddress2());
            callableStatement.setString(31, manualFormVO.getPrincipalOfficersAddress3());
            callableStatement.setString(32, manualFormVO.getPrincipalOfficersCity());
            callableStatement.setString(33, manualFormVO.getPrincipalOfficersState());
            callableStatement.setString(34, manualFormVO.getPrincipalOfficersCountry());
            callableStatement.setString(35, manualFormVO.getPrincipalOfficersAddressPinCode());
            callableStatement.setString(36, manualFormVO.getPrincipalOfficersTelephoneNo());
            callableStatement.setString(37, manualFormVO.getPrincipalOfficersMobileNo());
            callableStatement.setString(38, manualFormVO.getPrincipalOfficersFaxNo());
            callableStatement.setString(39, manualFormVO.getPrincipalOfficersEmailId());
            callableStatement.setString(40, manualFormVO.getReasonOfRevision());
            
            //int l_intSaved = callableStatement.executeUpdate();
            callableStatement.executeUpdate();
            //if(l_intSaved == 1)
            isSaved = true;
        }
        catch(Exception e)
        {
        	log.error("Error in ISTRTRFDAOImpl-> saveISTRTRFManualDetails " + e.toString());
            System.out.println("Error in ISTRTRFDAOImpl-> saveISTRTRFManualDetails " + e.toString());
            e.printStackTrace();
        }finally{
        	connectionUtil.closeResources(connection, callableStatement, null, null);
        }
        return isSaved;
    }
    
    private String stringConversion(String arrayTemp[])
    {
        StringBuffer strBuffer = new StringBuffer();
        for(int i = 0; i < arrayTemp.length; i++)
        {
        	strBuffer.append(arrayTemp[i]);
            if(i != arrayTemp.length - 1)
            	strBuffer.append("~");
        }
        return strBuffer.toString();
    }
    
    private HashMap<String, String> getISTRTRFCaseStatusDetails(String caseNo, String userCode, String userRole){
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		HashMap<String, String> caseStatusDetails = new HashMap<String, String>();
		String queryString = "";
		try{
			connection = connectionUtil.getConnection();
			caseStatusDetails.put("CASENO", caseNo);
			caseStatusDetails.put("USERCODE", userCode);
			caseStatusDetails.put("USERROLE", userRole);
			
			queryString = "SELECT CASESTATUS, USERCASESTATUS, AMLUSERCASESTATUS, "+
			          "       AMLOCASESTATUS, MLROCASESTATUS, "+
				      "       PREVIOUS_CASESTATUS, PREVIOUS_USERCODE, "+ 
                    "       PREVIOUS_USERROLE, CURRENT_CASESTATUS, "+ 
                    "       CURRENT_USERCODE, CURRENT_USERROLE, "+ 
                    "       ISMANUALCASE, CASESTATUS_SUBACTION "+
			          "  FROM "+schemaName+"TB_CASEWORKFLOWDETAILS "+
			          " WHERE CASENO = ? ";
			preparedStatement = connection.prepareStatement(queryString);
			preparedStatement.setString(1, caseNo);
			resultSet = preparedStatement.executeQuery();
			while (resultSet.next()) {
				caseStatusDetails.put("CASESTATUS", resultSet.getString("CASESTATUS"));
				caseStatusDetails.put("USERCASESTATUS", resultSet.getString("USERCASESTATUS"));
				caseStatusDetails.put("AMLUSERCASESTATUS", resultSet.getString("AMLUSERCASESTATUS"));
				caseStatusDetails.put("AMLOCASESTATUS", resultSet.getString("AMLOCASESTATUS"));
				caseStatusDetails.put("MLROCASESTATUS", resultSet.getString("MLROCASESTATUS"));
				caseStatusDetails.put("PREVIOUS_CASESTATUS", resultSet.getString("PREVIOUS_CASESTATUS"));
				caseStatusDetails.put("PREVIOUS_USERCODE", resultSet.getString("PREVIOUS_USERCODE"));
				caseStatusDetails.put("PREVIOUS_USERROLE", resultSet.getString("PREVIOUS_USERROLE"));
				caseStatusDetails.put("CURRENT_CASESTATUS", resultSet.getString("CURRENT_CASESTATUS"));
				caseStatusDetails.put("CURRENT_USERCODE", resultSet.getString("CURRENT_USERCODE"));
				caseStatusDetails.put("CURRENT_USERROLE", resultSet.getString("CURRENT_USERROLE"));
				caseStatusDetails.put("ISMANUALCASE", resultSet.getString("ISMANUALCASE"));
				caseStatusDetails.put("CASESTATUS_SUBACTION", resultSet.getString("CASESTATUS_SUBACTION"));
			}
		}catch(Exception e){
			log.error("Exception in INDSTRTRFDAOImpl -> ExecuteSTRXMLProcedures, Error Is:"+ e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		System.out.println(caseStatusDetails);
		return caseStatusDetails;
	}
    
    public boolean addBranchDetailsToList(String caseNo, String branchSeqNo, String userCode, String terminalId, ISTRTRFBranchDetailsVO branchDetailsVO)
    {
    	Connection connection = null;
        CallableStatement callableStatement = null;
        boolean isSaved = false;
        try
        {
        	connection = connectionUtil.getConnection();
            callableStatement = connection.prepareCall("{CALL "+schemaName+"STP_ISTRTRFADDUPDATENEWBRANCH(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");
            callableStatement.setString(1, caseNo);
            callableStatement.setString(2, userCode);
            callableStatement.setString(3, terminalId);
            callableStatement.setString(4, branchDetailsVO.getRepRole());
            callableStatement.setString(5, branchDetailsVO.getInstituteName());
            callableStatement.setString(6, branchDetailsVO.getInstituteBranchName());
            callableStatement.setString(7, branchDetailsVO.getInstituteRefNo());
            callableStatement.setString(8, branchDetailsVO.getInstituteAddress());
            callableStatement.setString(9, branchDetailsVO.getInstituteCity());
            callableStatement.setString(10, branchDetailsVO.getInstituteState());
            callableStatement.setString(11, branchDetailsVO.getInstituteCountry());
            callableStatement.setString(12, branchDetailsVO.getInstitutePin());
            callableStatement.setString(13, branchDetailsVO.getInstituteTelNo());
            callableStatement.setString(14, branchDetailsVO.getInstituteMobNo());
            callableStatement.setString(15, branchDetailsVO.getInstituteFaxNo());
            callableStatement.setString(16, branchDetailsVO.getInstituteEmail());
            callableStatement.setString(17, branchDetailsVO.getInstituteRemarks());
            callableStatement.setString(18, branchDetailsVO.getBiccode());
            callableStatement.setString(19, branchSeqNo);
            
            callableStatement.executeUpdate();
            isSaved = true;
        }
        catch(Exception e)
        {
        	e.printStackTrace();
        	log.error("Exception in ISTRTRFDAOImpl -> addBranchDetailsToList, Error Is:"+ e.toString());
            System.out.println("Exception in ISTRTRFDAOImpl -> addBranchDetailsToList, Error Is:"+ e.toString());
            e.toString();
        }finally{
        	connectionUtil.closeResources(connection, callableStatement, null, null);
        }
        return isSaved;
    }
    
    public boolean addTransactionDetailsToList(String caseNo, String transactionSeqNo, String userCode, String terminalId, ISTRTRFTransactionDetailsVO transactionDetailsVO)
    {
    	Connection connection = null;
        CallableStatement callableStatement = null;
        boolean isSaved = false;
       
        try
        {
        	connection = connectionUtil.getConnection();
            callableStatement = connection.prepareCall("{CALL "+schemaName+"STP_ISTRTRFADDUPDATENEWTRNC(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,"+
            		 "?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");
            callableStatement.setString(1, caseNo);
            callableStatement.setString(2, userCode);
            callableStatement.setString(3, terminalId);
            callableStatement.setString(4, transactionDetailsVO.getNameOfBank());
            callableStatement.setString(5, transactionDetailsVO.getTransactionDate());
            callableStatement.setString(6, transactionDetailsVO.getTransactionTime());
            callableStatement.setString(7, transactionDetailsVO.getTransactionNo());
            callableStatement.setString(8, transactionDetailsVO.getTransactionType());
            callableStatement.setString(9, transactionDetailsVO.getInstrumentType());
            callableStatement.setString(10, transactionDetailsVO.getTransactionInstitutionName());
            callableStatement.setString(11, transactionDetailsVO.getTransactionInstitutionRefNo());
            callableStatement.setString(12, transactionDetailsVO.getTransactionStateCode());
            callableStatement.setString(13, transactionDetailsVO.getTransactionCountryCode());
            callableStatement.setString(14, transactionDetailsVO.getTransactionAmount());
            callableStatement.setString(15, transactionDetailsVO.getTransactionAmtInForeignCurr());
            callableStatement.setString(16, transactionDetailsVO.getRiskRating());
            callableStatement.setString(17, transactionDetailsVO.getPurposeOfTransaction());
            callableStatement.setString(18, transactionDetailsVO.getTransactionCurrencyCode());
            callableStatement.setString(19, transactionDetailsVO.getPaymentInstrumentNo());
            callableStatement.setString(20, transactionDetailsVO.getPaymentInstrumentInstName());
            callableStatement.setString(21, transactionDetailsVO.getCustomerName());
            callableStatement.setString(22, transactionDetailsVO.getCustomerId());
            callableStatement.setString(23, transactionDetailsVO.getOccupation());
            callableStatement.setString(24, transactionDetailsVO.getDateOfBirth());
            callableStatement.setString(25, transactionDetailsVO.getGender());
            callableStatement.setString(26, transactionDetailsVO.getNationality());
            callableStatement.setString(27, transactionDetailsVO.getIdentificationType());
            callableStatement.setString(28, transactionDetailsVO.getIdentificationNo());
            callableStatement.setString(29, transactionDetailsVO.getIssuingAuthority());
            callableStatement.setString(30, transactionDetailsVO.getIssuingPlace());
            callableStatement.setString(31, transactionDetailsVO.getPanNo());
            callableStatement.setString(32, transactionDetailsVO.getUinNo());
            callableStatement.setString(33, transactionDetailsVO.getAddressLine());
            callableStatement.setString(34, transactionDetailsVO.getCity());
            callableStatement.setString(35, transactionDetailsVO.getState());
            callableStatement.setString(36, transactionDetailsVO.getCountry());
            callableStatement.setString(37, transactionDetailsVO.getPinCode());
            callableStatement.setString(38, transactionDetailsVO.getTelephone());
            callableStatement.setString(39, transactionDetailsVO.getMobile());
            callableStatement.setString(40, transactionDetailsVO.getFax());
            callableStatement.setString(41, transactionDetailsVO.getEmailId());
            callableStatement.setString(42, transactionDetailsVO.getAccountNo());
            callableStatement.setString(43, transactionDetailsVO.getAccountWithInstitutionName());
            callableStatement.setString(44, transactionDetailsVO.getRelatedInstitutionRefNo());
            callableStatement.setString(45, transactionDetailsVO.getRelatedInstitutionName());
            callableStatement.setString(46, transactionDetailsVO.getInstitutionRelationFlag());
            callableStatement.setString(47, transactionDetailsVO.getTransactionRemarks());
            callableStatement.setString(48, transactionDetailsVO.getInstrIssInstRefno());
            callableStatement.setString(49, transactionDetailsVO.getInstrCountryCode());
            callableStatement.setString(50, transactionDetailsVO.getPurposeCode());
            callableStatement.setString(51, transactionDetailsVO.getRltdInstRefNo());
            callableStatement.setString(52, transactionDetailsVO.getInstrHolderName());
            callableStatement.setString(53, transactionDetailsVO.getRltnshpBegDate());
            callableStatement.setString(54, transactionDetailsVO.getCumPurchaseTurnover());
            callableStatement.setString(55, transactionSeqNo);
            
            callableStatement.executeUpdate();
            isSaved = true;
        }
        catch(Exception e)
        {
        	e.printStackTrace();
        	log.error("Exception in ISTRTRFDAOImpl -> addTransactionDetailsToList, Error Is:"+ e.toString());
            System.out.println("Exception in ISTRTRFDAOImpl -> addTransactionDetailsToList, Error Is:"+ e.toString());
            e.toString();
        }finally{
        	connectionUtil.closeResources(connection, callableStatement, null, null);
        }
        
        return isSaved;
    }
   
    public HashMap getNewTransactionDetails(String transactionDate, String transactionType, String intrumentType, String currencyCode, String amountInRupees, 
    		String caseNo, String transactionSeqNo){
		Connection connection = null;
        CallableStatement callableStatement = null;
        ResultSet resultSet = null;
        HashMap hashMap = new HashMap();
        ISTRTRFTransactionDetailsVO transactionDetailsVO = null;
        try
        {
        	connection = connectionUtil.getConnection();
            callableStatement = connection.prepareCall("{CALL "+schemaName+"STP_ISTRTRFGETADDEDDETAILS(?,?,?,?,?,?,?,?,?,?,?,?)}");
            callableStatement.setString(1, caseNo);
            callableStatement.setString(2, "TRANSACTION");
            callableStatement.setString(3, transactionDate);
            callableStatement.setString(4, transactionType);
            callableStatement.setString(5, intrumentType);
            callableStatement.setString(6, currencyCode);
            callableStatement.setString(7, amountInRupees);
            callableStatement.setString(8, "");
            callableStatement.setString(9, "");
            callableStatement.setString(10, "");
            callableStatement.setString(11, transactionSeqNo);
            callableStatement.registerOutParameter(12, oracle.jdbc.OracleTypes.CURSOR);
            callableStatement.execute();
            resultSet = (ResultSet)callableStatement.getObject(12);
            while(resultSet.next()){
            	transactionDetailsVO = new ISTRTRFTransactionDetailsVO();
            	transactionDetailsVO.setNameOfBank(resultSet.getString("NAMEOFBANK"));
                transactionDetailsVO.setTransactionDate(resultSet.getString("TRANSACTIONDATE"));
                transactionDetailsVO.setTransactionTime(resultSet.getString("TRANSACTIONTIME"));
                transactionDetailsVO.setTransactionNo(resultSet.getString("TRANSACTIONNO"));
                transactionDetailsVO.setTransactionType(resultSet.getString("TRANSACTIONTYPE"));
                transactionDetailsVO.setInstrumentType(resultSet.getString("INSTRUMENTTYPE"));
                transactionDetailsVO.setTransactionInstitutionName(resultSet.getString("TRANSACTIONINSTITUTIONNAME"));
                transactionDetailsVO.setTransactionInstitutionRefNo(resultSet.getString("TRANSACTIONINSTITUTIONREFNO"));
                transactionDetailsVO.setTransactionStateCode(resultSet.getString("TRANSACTIONSTATECODE"));
                transactionDetailsVO.setTransactionCountryCode(resultSet.getString("TRANSACTIONCOUNTRYCODE"));
                transactionDetailsVO.setTransactionAmount(resultSet.getString("AMOUNT"));
                transactionDetailsVO.setTransactionAmtInForeignCurr(resultSet.getString("AMOUNTINFOREIGNCURRENCY"));
                transactionDetailsVO.setTransactionCurrencyCode(resultSet.getString("CURRENCYCODE"));
                transactionDetailsVO.setPurposeOfTransaction(resultSet.getString("PURPOSEOFTRANSACTIONS"));
                transactionDetailsVO.setRiskRating(resultSet.getString("RISKRATING"));
                transactionDetailsVO.setPaymentInstrumentNo(resultSet.getString("PAYMENTINSTRUMENTNO"));
                transactionDetailsVO.setPaymentInstrumentInstName(resultSet.getString("PAYMENTINSTRUMENTINSTNAME"));
                transactionDetailsVO.setCustomerName(resultSet.getString("CUSTOMERNAME"));
                transactionDetailsVO.setOccupation(resultSet.getString("OCCUPATION"));
                transactionDetailsVO.setDateOfBirth(resultSet.getString("DATEOFBIRTH"));
                transactionDetailsVO.setGender(resultSet.getString("GENDER"));
                transactionDetailsVO.setNationality(resultSet.getString("NATIONALITY"));
                transactionDetailsVO.setIdentificationType(resultSet.getString("IDENTIFICATIONTYPE"));
                transactionDetailsVO.setIdentificationNo(resultSet.getString("IDENTIFICATIONNUMBER"));
                transactionDetailsVO.setIssuingAuthority(resultSet.getString("ISSUINGAUTHORITY"));
                transactionDetailsVO.setIssuingPlace(resultSet.getString("ISSUINGPLACE"));
                transactionDetailsVO.setPanNo(resultSet.getString("PANNO"));
                transactionDetailsVO.setUinNo(resultSet.getString("UINNO"));
                transactionDetailsVO.setAddressLine(resultSet.getString("ADDRESSLINE"));
                transactionDetailsVO.setCity(resultSet.getString("CITY"));
                transactionDetailsVO.setState(resultSet.getString("STATECODE"));
                transactionDetailsVO.setCountry(resultSet.getString("COUNTRYCODE"));
                transactionDetailsVO.setPinCode(resultSet.getString("PINCODE"));
                transactionDetailsVO.setTelephone(resultSet.getString("TELEPHONE"));
                transactionDetailsVO.setMobile(resultSet.getString("MOBILE"));
                transactionDetailsVO.setFax(resultSet.getString("FAX"));
                transactionDetailsVO.setEmailId(resultSet.getString("EMAILID"));
                transactionDetailsVO.setAccountNo(resultSet.getString("ACCOUNTNO"));
                transactionDetailsVO.setAccountWithInstitutionName(resultSet.getString("ACCOUNTWITHINSTITUTIONNAME"));
                transactionDetailsVO.setRelatedInstitutionRefNo(resultSet.getString("ACCOUNTWITHINSTITUTIONREFNUM"));
                transactionDetailsVO.setRelatedInstitutionName(resultSet.getString("RELATEDINSTITUTIONNAME"));
                transactionDetailsVO.setInstitutionRelationFlag(resultSet.getString("INSTITUTIONRELATIONFLAG"));
                transactionDetailsVO.setTransactionRemarks(resultSet.getString("REMARKS"));
                transactionDetailsVO.setInstrIssInstRefno(resultSet.getString("INSTRISSINSTREFNO"));
                transactionDetailsVO.setInstrCountryCode(resultSet.getString("INSTRCOUNTRYCODE"));
                transactionDetailsVO.setPurposeCode(resultSet.getString("PURPOSECODE"));
                transactionDetailsVO.setRltdInstRefNo(resultSet.getString("RLTDINSTREFNO"));
                transactionDetailsVO.setInstrHolderName(resultSet.getString("INSTRHOLDERNAME"));
                transactionDetailsVO.setRltnshpBegDate(resultSet.getString("RLTNSHPBEGDATE"));
                transactionDetailsVO.setCumPurchaseTurnover(resultSet.getString("CUMPURCHASETURNOVER"));
                transactionDetailsVO.setTransactionSeqNo(resultSet.getString("TXNSEQNO"));
            }
           
            hashMap.put("TransactionDetailsDTO", transactionDetailsVO);
        }
        catch(Exception e)
        {
        	log.error("Exception in ISTRTRFDAOImpl -> getNewTransactionDetails " + e.toString());
            System.out.println("Exception in ISTRTRFDAOImpl -> getNewTransactionDetails " + e.toString());
            e.printStackTrace();
        }finally{
        	connectionUtil.closeResources(connection, callableStatement, resultSet, null);
        }
        return hashMap;
    }
    
    public boolean deleteTransactionDetails(String transactionDate, String transactionType, String intrumentType, String currencyCode, String amountInRupees, 
    		String transactionSeqNo, String userCode, String caseNo){
		Connection connection = null;
		CallableStatement callableStatement = null;
        boolean isDeleted = false;
       /* System.out.println("IN deleteTransactionDetails");
        System.out.println(transactionSeqNo+" - "+transactionDate+" - "+transactionType+" - "+intrumentType+" - "+currencyCode+" - "+amountInRupees+" - "+userCode+" - "+caseNo);*/
        try
        {
        	connection = connectionUtil.getConnection();
            callableStatement = connection.prepareCall("{CALL "+schemaName+"STP_ISTRTRFDELETEADDEDDETAILS(?,?,?,?,?,?,?,?,?,?,?)}");
            callableStatement.setString(1, caseNo);
            callableStatement.setString(2, "TRANSACTION");
            callableStatement.setString(3, userCode);
            callableStatement.setString(4, transactionDate);
            callableStatement.setString(5, transactionType);
            callableStatement.setString(6, intrumentType);
            callableStatement.setString(7, currencyCode);
            callableStatement.setString(8, amountInRupees);
            callableStatement.setString(9, "");
            callableStatement.setString(10, "");
            callableStatement.setString(11, transactionSeqNo);
            callableStatement.executeUpdate();
            isDeleted = true;
        }
        catch(Exception e)
        {
        	log.error("Exception in ISTRTRFDAOImpl->deleteTransactionDetails " + e.toString());
            System.out.println("Exception in ISTRTRFDAOImpl->deleteTransactionDetails " + e.toString());
            e.printStackTrace();
        }finally{
        	connectionUtil.closeResources(connection, callableStatement, null, null);
        }
      //  System.out.println(isDeleted);
        return isDeleted;
    }
    
    public HashMap getNewBranchDetails(String strBranchName, String strBranchRefNo, String caseNo, String branchSeqNo){
		Connection connection = null;
        CallableStatement callableStatement = null;
        ResultSet resultSet = null;
        HashMap hashMap = new HashMap();
        ISTRTRFBranchDetailsVO branchDetailsVO = null;
        
        try
        {
        	connection = connectionUtil.getConnection();
            callableStatement = connection.prepareCall("{CALL "+schemaName+"STP_ISTRTRFGETADDEDDETAILS(?,?,?,?,?,?,?,?,?,?,?,?)}");
            callableStatement.setString(1, caseNo);
            callableStatement.setString(2, "BRANCH");
            callableStatement.setString(3, "");
            callableStatement.setString(4, "");
            callableStatement.setString(5, "");
            callableStatement.setString(6, "");
            callableStatement.setString(7, "");
            callableStatement.setString(8, strBranchName);
            callableStatement.setString(9, strBranchRefNo);
            callableStatement.setString(10, branchSeqNo);
            callableStatement.setString(11, "");
            callableStatement.registerOutParameter(12, oracle.jdbc.OracleTypes.CURSOR);
            callableStatement.execute();
            resultSet = (ResultSet)callableStatement.getObject(12);
            while(resultSet.next()){
            	branchDetailsVO = new ISTRTRFBranchDetailsVO();
            	 branchDetailsVO.setRepRole(resultSet.getString("REPORTINGROLE"));
                 branchDetailsVO.setInstituteName(resultSet.getString("BANKNAME"));
                 branchDetailsVO.setInstituteBranchName(resultSet.getString("BRANCHNAME"));
                 branchDetailsVO.setInstituteRefNo(resultSet.getString("BRANCHREFERENCENUMBER"));
                 branchDetailsVO.setInstituteAddress(resultSet.getString("BRANCHADDR1"));
                 branchDetailsVO.setInstituteCity(resultSet.getString("CITY"));
                 branchDetailsVO.setInstituteState(resultSet.getString("STATECODE"));
                 branchDetailsVO.setInstituteCountry(resultSet.getString("BRANCHCOUNTRY"));
                 branchDetailsVO.setInstitutePin(resultSet.getString("BRANCHPINCODE"));
                 branchDetailsVO.setInstituteTelNo(resultSet.getString("BRANCHTELEPHONE"));
                 branchDetailsVO.setInstituteMobNo(resultSet.getString("MOBILE"));
                 branchDetailsVO.setInstituteFaxNo(resultSet.getString("BRANCHFAX"));
                 branchDetailsVO.setInstituteEmail(resultSet.getString("BRANCHEMAIL"));
                 branchDetailsVO.setInstituteRemarks(resultSet.getString("REMARKS"));
                 branchDetailsVO.setInstituteSeqNo(resultSet.getString("BRANCHSEQNO"));
                 branchDetailsVO.setBiccode(resultSet.getString("BICCODE"));
                // System.out.println("BRANCHSEQNO = "+resultSet.getString("BRANCHSEQNO"));
            }
           
            hashMap.put("BranchDetailsDTO", branchDetailsVO);
        }
        catch(Exception e)
        {
        	log.error("Exception in ISTDAOImpl -> getNewBranchDetails " + e.toString());
            System.out.println("Exception in ISTDAOImpl -> getNewBranchDetails " + e.toString());
            e.printStackTrace();
        }finally{
        	connectionUtil.closeResources(connection, callableStatement, resultSet, null);
        }
        return hashMap;
    }
    
    public boolean deleteBranchDetails(String strBranchName, String strBranchRefNo, String branchSeqNo, String userCode, String caseNo){
		Connection connection = null;
		CallableStatement callableStatement = null;
        boolean isDeleted = false;
        try
        {
        	connection = connectionUtil.getConnection();
            callableStatement = connection.prepareCall("{CALL "+schemaName+"STP_ISTRTRFDELETEADDEDDETAILS(?,?,?,?,?,?,?,?,?,?,?)}");
            callableStatement.setString(1, caseNo);
            callableStatement.setString(2, "BRANCH");
            callableStatement.setString(3, userCode);
            callableStatement.setString(4, "");
            callableStatement.setString(5, "");
            callableStatement.setString(6, "");
            callableStatement.setString(7, "");
            callableStatement.setString(8, "");
            callableStatement.setString(9, strBranchName);
            callableStatement.setString(10, strBranchRefNo);
            callableStatement.setString(11, branchSeqNo);
            callableStatement.executeUpdate();
            isDeleted = true;
        }
        catch(Exception e)
        {
        	log.error("Exception in ISTRTRFDAOImpl->deleteBranchDetails " + e.toString());
            System.out.println("Exception in ISTRTRFDAOImpl->deleteBranchDetails " + e.toString());
            e.printStackTrace();
        }finally{
        	connectionUtil.closeResources(connection, callableStatement, null, null);
        }
        return isDeleted;
    }
    
    public HashMap getINDSTRTRFReport(String caseNo, String userCode, String userRole){
    	System.out.println("getINDSTRTRFReport = "+caseNo);
    	//setINDSTRTRFReportData(caseNo);
		ISTRTRFManualDetailsVO manualDetailsVO = getINDSTRTRFManualDetails(caseNo);

		ArrayList allTransactionDetails = getINDSTRTRFAnnexureTransactionDetails(caseNo);
		ArrayList allBranchDetails = getINDSTRTRFAnnexureBranchDetails(caseNo);
		ArrayList allIndividualDetails = getINDSTRTRFAnnexureIndividualDetails(caseNo);
		ArrayList alllegalPersonDetails = getINDSTRTRFAnnexureLegalEntityDetails(caseNo);

		HashMap<String, String> caseStatusDetails = getISTRTRFCaseStatusDetails(caseNo, userCode, userRole);
		ArrayList alertIndicatorsList = getISTRTRFAlertIndicatorsList(caseNo);
		
		HashMap indSTRReports = new HashMap();
		indSTRReports.put("ManualFormDTO", manualDetailsVO);
		indSTRReports.put("TransactionDetailsDTO", allTransactionDetails);
		indSTRReports.put("BranchDetailsDTO", allBranchDetails);
		indSTRReports.put("ALIndvDetailsDTO", allIndividualDetails);
		indSTRReports.put("ALLegPerDetailsDTO", alllegalPersonDetails);
		indSTRReports.put("CaseStatusDetails", caseStatusDetails);
		indSTRReports.put("AlertIndicatorsList", alertIndicatorsList);
		
		//System.out.println("ManualFormDTO TXN SEQ"+manualDetailsVO.getTransactionSeqNo());
		//System.out.println("ManualFormDTO BRN SEQ"+manualDetailsVO.getBranchSeqNo());
		
		return indSTRReports;
    }
    
    private ArrayList getISTRTRFAlertIndicatorsList(String caseNo){
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		ArrayList alertIndicatorsList = new ArrayList();
		try{
			connection = connectionUtil.getConnection();
			preparedStatement = connection.prepareStatement("SELECT ALERTINDICATORNAME FROM "+schemaName+"TB_ALERTINDICATORS ORDER BY SEQNO ");
			resultSet = preparedStatement.executeQuery();
			while (resultSet.next()) {
				alertIndicatorsList.add(resultSet.getString("ALERTINDICATORNAME"));
			}
		}catch(Exception e){
			log.error("Exception in INDSTRDAOImpl -> ExecuteSTRXMLProcedures, Error Is:"+ e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return alertIndicatorsList;
	}
    
   /* 
   private void setINDSTRTRFReportData(String caseNo){
    	Connection connection = null;
    	Connection connection1 = null;
    	Connection connection2 = null;
    	Connection connection3 = null;
    	CallableStatement callableStatement = null;
    	//  Try block for Save STP_ISTRMANUALFORMRMDETAILS
		try{
			connection = connectionUtil.getConnection();
			callableStatement = connection.prepareCall("{CALL STP_ISTRMANUALFORMRMDETAILS(?)}");
			callableStatement.setString(1, caseNo);
			callableStatement.execute();			
		}catch(Exception e){
			log.error("Exception in INDSTRTRFDAOImpl -> setINDSTRTRFReportData -> STP_ISTRMANUALFORMRMDETAILS, Error Is:"+ e.toString());
			System.out.println("Exception in INDSTRTRFDAOImpl -> setINDSTRTRFReportData -> STP_ISTRMANUALFORMRMDETAILS, Error Is:"+ e.toString());
            e.toString();
		}finally{
			connectionUtil.closeResources(connection, callableStatement, null, null);
		}
		
		//  Try block for Save STP_ISTRINDIVIDUALDETAILS
		try{
			connection1 = getConnection();
			callableStatement = connection1.prepareCall("{CALL STP_ISTRINDIVIDUALDETAILS(?)}");
			callableStatement.setString(1, caseNo);
			callableStatement.execute();
		}catch(Exception e){
			log.error("Exception in INDSTRTRFDAOImpl -> setINDSTRTRFReportData -> STP_ISTRINDIVIDUALDETAILS, Error Is:"+ e.toString());
			System.out.println("Exception in INDSTRTRFDAOImpl -> setINDSTRTRFReportData -> STP_ISTRINDIVIDUALDETAILS, Error Is:"+ e.toString());
            e.toString();
		}finally{
			connectionUtil.closeResources(connection1, callableStatement, null, null);
		}
		
		//  Try block for Save STP_ISTRBRANCHDETAILS		
		try{
			connection3 = getConnection();
			callableStatement = connection3.prepareCall("{CALL STP_ISTRBRANCHDETAILS(?)}");
			callableStatement.setString(1, caseNo);
			callableStatement.execute();
		}catch(Exception e){
			log.error("Exception in INDSTRTRFDAOImpl -> setINDSTRTRFReportData -> STP_ISTRBRANCHDETAILS, Error Is:"+ e.toString());
			System.out.println("Exception in INDSTRTRFDAOImpl -> setINDSTRTRFReportData -> STP_ISTRBRANCHDETAILS, Error Is:"+ e.toString());
            e.toString();
		}finally{
			connectionUtil.closeResources(connection3, callableStatement, null, null);
		}
    }
*/
    
	private ISTRTRFManualDetailsVO getINDSTRTRFManualDetails(String caseNo) {
		System.out.println("getINDSTRTRFManualDetails casen0 ="+caseNo);
		ISTRTRFManualDetailsVO manualDetailsVO = new ISTRTRFManualDetailsVO();
		Connection connection = null;
		Connection connection1 = null;
		Connection connection2 = null;
		CallableStatement callableStatement = null;
		ResultSet resultSet = null;
		
		StringBuilder sbTransactionSeqNo = new StringBuilder();
		StringBuilder sbTransactionDate = new StringBuilder();
		StringBuilder sbTransactionType = new StringBuilder();
		StringBuilder sbTransactionInstrumentType = new StringBuilder();
		StringBuilder sbTransactionCurr = new StringBuilder();
		StringBuilder sbTransactionAmtInRupees = new StringBuilder();
		StringBuilder sbTransactionDataType = new StringBuilder();
        int intCountOfTransactions = 0;
        
        StringBuilder sbBranchSeqNo = new StringBuilder();
        StringBuilder sbBranchName = new StringBuilder();
		StringBuilder sbBranchRefNo = new StringBuilder();
		StringBuilder sbBranchDataType = new StringBuilder();
        int intCountOfBranches = 0;
        
        String strTransactionSeqNo[] = (String[])null;
        String strTransactionDate[] = (String[])null;
        String strTransactionType[] = (String[])null;
        String strTransactionInstrumentType[] = (String[])null;
        String strTransactionCurr[] = (String[])null;
        String strTransactionAmtInRupees[] = (String[])null;
        String strTransactionDataType[] = (String[])null;
        
        String branchSeqNo[] = (String[])null;
        String strBranchName[] = (String[])null;
        String strBranchRefNo[] = (String[])null;
        String strBranchDataType[] = (String[])null;
        
		try{
			connection = connectionUtil.getConnection();
			callableStatement = connection.prepareCall("{CALL "+schemaName+"STP_GETISTRTRFMANUALDETAILS(?,?)}");
			callableStatement.setString(1, caseNo);
			callableStatement.registerOutParameter(2, oracle.jdbc.OracleTypes.CURSOR);
			callableStatement.execute();
			resultSet = (ResultSet)callableStatement.getObject(2);
			while(resultSet.next()){
				manualDetailsVO.setReportingEntityName(resultSet.getString("PRINCNAMEOFBANK"));
                manualDetailsVO.setReportingEntityCategory(resultSet.getString("PRINCBANKCATEGORY"));
			    manualDetailsVO.setReportingEntityCode(resultSet.getString("PRINCBSRCODE"));
			    manualDetailsVO.setReportingEntityFIUREID(resultSet.getString("PRINCIDFIUIND"));
                manualDetailsVO.setReportingBatchNo(resultSet.getString("REPORTINGBATCHNO"));
			    manualDetailsVO.setReportingBatchDate(resultSet.getString("REPORTINGBATCHDATE"));
			    manualDetailsVO.setReportingBatchType(resultSet.getString("REPORTINGBATCHTYPE"));
			    manualDetailsVO.setReportingOriginalBatchId(resultSet.getString("REPORTINGORIGINALBATCHID"));
			    manualDetailsVO.setPrincipalOfficersName(resultSet.getString("PRINCOFFICERNAME"));
			    manualDetailsVO.setPrincipalOfficersDesignation(resultSet.getString("PRINCDESIGNATION"));
			    manualDetailsVO.setPrincipalOfficersAddress1(resultSet.getString("PRINCBUILDINGNO"));
			    manualDetailsVO.setPrincipalOfficersAddress2(resultSet.getString("PRINCSTREET"));
			    manualDetailsVO.setPrincipalOfficersAddress3(resultSet.getString("PRINCLOCALITY"));
                manualDetailsVO.setPrincipalOfficersCity(resultSet.getString("PRINCCITY"));
                manualDetailsVO.setPrincipalOfficersState(resultSet.getString("PRINCSTATE"));
                manualDetailsVO.setPrincipalOfficersAddressPinCode(resultSet.getString("PRINCPINCODE"));
			    manualDetailsVO.setPrincipalOfficersTelephoneNo(resultSet.getString("PRINCTELNO"));
			    manualDetailsVO.setPrincipalOfficersMobileNo(resultSet.getString("PRINCMOBILENO"));
			    manualDetailsVO.setPrincipalOfficersFaxNo(resultSet.getString("PRINCFAX"));
			    manualDetailsVO.setPrincipalOfficersEmailId(resultSet.getString("PRINCEMAIL"));
			    manualDetailsVO.setMainPersonName(resultSet.getString("MAINPERSONNAME"));
			    manualDetailsVO.setSourceOfAlert(resultSet.getString("SOURCEOFALERT"));
                manualDetailsVO.setAlertIndicators(stringArrayConversion(resultSet.getString("ALERTINDICATORS")));
			    manualDetailsVO.setSuspicionDueTo(resultSet.getString("SUSPICIONDUETO"));
			    manualDetailsVO.setAttemptedTransactions(resultSet.getString("ATTEMPTEDTRANSACTIONS"));
			    manualDetailsVO.setPriorityRating(resultSet.getString("PRIORITYRATING"));
			    manualDetailsVO.setReportCoverage(resultSet.getString("REPORTCOVERAGE"));
			    manualDetailsVO.setAdditionalDocuments(resultSet.getString("ADDITIONALDOCUMENTS"));
			    manualDetailsVO.setSusGroundsP7(stringArrayConversion(resultSet.getString("PART7SUSGROUNDS")));
                manualDetailsVO.setSusGroundsP8(stringArrayConversion(resultSet.getString("PART8SUSGROUNDS")));
			    manualDetailsVO.setLawEnforcementInformed(resultSet.getString("LAWENFORCEMENTINFORMED"));
                manualDetailsVO.setLawEnforcementAgencyDetails(stringArrayConversion(resultSet.getString("LAWENFORCEMENTAGENCYDETAILS")));
			    manualDetailsVO.setSignatureName(resultSet.getString("SIGNATURENAME"));
			    manualDetailsVO.setReasonOfRevision(resultSet.getString("REASONFORREPLACEMENT"));
			}
		}catch(Exception e){
			e.printStackTrace();
			log.error("Exception in INDSTRTRFDAOImpl -> getINDSTRTRFManualDetails -> STP_GETISTRTRFMANUALDETAILS, Error Is:"+ e.toString());
			System.out.println("Exception in INDSTRTRFDAOImpl -> getINDSTRTRFManualDetails -> STP_GETISTRTRFMANUALDETAILS, Error Is:"+ e.toString());
            e.toString();
		}finally{
			connectionUtil.closeResources(connection, callableStatement, resultSet, null);
		}
		
		//System.out.println("calling STP_GETISTRTRFLISTOFTXNS");
		//System.out.println("caseNo = "+caseNo);
		try{
			connection1 = connectionUtil.getConnection();
			callableStatement = connection1.prepareCall("{CALL "+schemaName+"STP_GETISTRTRFLISTOFTXNS(?,?)}");
			callableStatement.setString(1, caseNo);
			callableStatement.registerOutParameter(2, oracle.jdbc.OracleTypes.CURSOR);
			callableStatement.execute();
			resultSet = (ResultSet)callableStatement.getObject(2);
			while(resultSet.next()){
				sbTransactionSeqNo.append(resultSet.getString("TXNSEQNO")).append("~");
                sbTransactionDate.append(resultSet.getString("TRANSACTIONDATE")).append("~");
                sbTransactionType.append(resultSet.getString("TRANSACTIONTYPE")).append("~");
                sbTransactionInstrumentType.append(resultSet.getString("INSTRUMENTTYPE")).append("~");
                sbTransactionCurr.append(resultSet.getString("CURRENCYCODE")).append("~");
                sbTransactionAmtInRupees.append(resultSet.getString("AMOUNT")).append("~");
                sbTransactionDataType.append(resultSet.getString("DATATYPE")).append("~");
                intCountOfTransactions++;
            }
		//	System.out.println("intCountOfTransactions = "+intCountOfTransactions);
            if(intCountOfTransactions > 0){
            	strTransactionSeqNo = sbTransactionSeqNo.toString().split("~");
                strTransactionDate = sbTransactionDate.toString().split("~");
                strTransactionType = sbTransactionType.toString().split("~");
                strTransactionInstrumentType = sbTransactionInstrumentType.toString().split("~");
                strTransactionCurr = sbTransactionCurr.toString().split("~");
                strTransactionAmtInRupees = sbTransactionAmtInRupees.toString().split("~");
                strTransactionDataType = sbTransactionDataType.toString().split("~");
             /*   System.out.println("strTransactionDate = "+Arrays.toString(strTransactionDate));
                System.out.println("strTransactionType = "+Arrays.toString(strTransactionType));
                System.out.println("strTransactionInstrumentType = "+Arrays.toString(strTransactionInstrumentType));
                System.out.println("strTransactionCurr = "+Arrays.toString(strTransactionCurr));
                System.out.println("strTransactionAmtInRupees = "+Arrays.toString(strTransactionAmtInRupees));
                System.out.println("strTransactionDataType = "+Arrays.toString(strTransactionDataType));*/
            } else {
            	strTransactionSeqNo = new String[20];
            	strTransactionDate = new String[20];
                strTransactionType = new String[20];
                strTransactionInstrumentType = new String[20];
                strTransactionCurr = new String[20];
                strTransactionAmtInRupees = new String[20];
                strTransactionDataType = new String[20];
            }
		}catch(Exception e)
		{
			e.printStackTrace();
			log.error("Exception in INDSTRTRFDAOImpl -> getINDSTRTRFManualDetails -> STP_GETISTRTRFLISTOFTXNS, Error Is:"+ e.toString());
			System.out.println("Exception in INDSTRTRFDAOImpl -> getINDSTRTRFManualDetails -> STP_GETISTRTRFLISTOFTXNS, Error Is:"+ e.toString());
            e.toString();
		}finally{
			connectionUtil.closeResources(connection1, callableStatement, resultSet, null);
		}
		
		resultSet = null;
		try{
			connection2 = connectionUtil.getConnection();
			callableStatement = connection2.prepareCall("{CALL "+schemaName+"STP_GETISTRTRFLISTOFBRANCHES(?,?)}");
			callableStatement.setString(1, caseNo);
			callableStatement.registerOutParameter(2, oracle.jdbc.OracleTypes.CURSOR);
			callableStatement.execute();
			resultSet = (ResultSet)callableStatement.getObject(2);
			while(resultSet.next()){
				sbBranchSeqNo.append(resultSet.getString("BRANCHSEQNO")).append("~");
				sbBranchName.append(resultSet.getString("BANKNAME")).append("~");
                sbBranchRefNo.append(resultSet.getString("BRANCHREFERENCENUMBER")).append("~");
                sbBranchDataType.append(resultSet.getString("DATATYPE")).append("~");
                intCountOfBranches++;
               /* System.out.println("BranchSeqNo = "+resultSet.getString("BRANCHSEQNO"));
                System.out.println("BranchName = "+resultSet.getString("BANKNAME"));
                System.out.println("BranchRefNo = "+resultSet.getString("BRANCHREFERENCENUMBER"));
                System.out.println("BranchDataType = "+resultSet.getString("DATATYPE"));*/
            }
            if(intCountOfBranches > 0){
            	branchSeqNo = sbBranchSeqNo.toString().split("~");
                strBranchName = sbBranchName.toString().split("~");
                strBranchRefNo = sbBranchRefNo.toString().split("~");
                strBranchDataType = sbBranchDataType.toString().split("~");
            } else {
            	branchSeqNo = new String[20];
                strBranchName = new String[20];
                strBranchRefNo = new String[20];
                strBranchDataType = new String[20];
            }	
		}catch(Exception e)
		{
			log.error("Exception in INDSTRTRFDAOImpl -> getINDSTRTRFManualDetails -> STP_GETISTRTRFLISTOFBRANCHES, Error Is:"+ e.toString());
			System.out.println("Exception in INDSTRTRFDAOImpl -> getINDSTRTRFManualDetails -> STP_GETISTRTRFLISTOFBRANCHES, Error Is:"+ e.toString());
            e.toString();
            e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection2, callableStatement, resultSet, null);
		}
			
		manualDetailsVO.setNoOfTransactionRec(intCountOfTransactions);
        manualDetailsVO.setNoOfBranchRec(intCountOfBranches);
        
        manualDetailsVO.setTransactionSeqNo(strTransactionSeqNo);
        manualDetailsVO.setTransactionDate(strTransactionDate);
        manualDetailsVO.setTransactionType(strTransactionType);
        manualDetailsVO.setTransactionInstrumentType(strTransactionInstrumentType);
        manualDetailsVO.setTransactionCurrency(strTransactionCurr);
        manualDetailsVO.setTransactionAmtInRupees(strTransactionAmtInRupees);
        manualDetailsVO.setDataTypeForTransaction(strTransactionDataType);
        
        manualDetailsVO.setBranchSeqNo(branchSeqNo);
        manualDetailsVO.setBranchName(strBranchName);
        manualDetailsVO.setBranchRefNo(strBranchRefNo);
        manualDetailsVO.setDataTypeForBranch(strBranchDataType);
        
		return manualDetailsVO;
	}
	
	private ArrayList getINDSTRTRFAnnexureTransactionDetails(String caseNo){
		Connection connection = null;
		CallableStatement callableStatement = null;
		ResultSet resultSet = null;
		ArrayList alltransactionDetails = new ArrayList();
		//System.out.println("CALLING STP_GETISTRTRFANNEXTRNDETAILS");
		try{
			connection = connectionUtil.getConnection();
			callableStatement = connection.prepareCall("{CALL "+schemaName+"STP_GETISTRTRFANNEXTRNDETAILS(?,?)}");
            callableStatement.setString(1, caseNo);
            callableStatement.registerOutParameter(2, oracle.jdbc.OracleTypes.CURSOR);
            callableStatement.execute();
            ISTRTRFTransactionDetailsVO transactionDetailsVO;
            resultSet = (ResultSet)callableStatement.getObject(2); 
            while(resultSet.next()){
                transactionDetailsVO = new ISTRTRFTransactionDetailsVO();
                transactionDetailsVO.setNameOfBank(resultSet.getString("NAMEOFBANK"));
                transactionDetailsVO.setTransactionDate(resultSet.getString("TRANSACTIONDATE"));
                transactionDetailsVO.setTransactionTime(resultSet.getString("TRANSACTIONTIME"));
                transactionDetailsVO.setTransactionNo(resultSet.getString("TRANSACTIONNO"));
                transactionDetailsVO.setTransactionType(resultSet.getString("TRANSACTIONTYPE"));
                transactionDetailsVO.setInstrumentType(resultSet.getString("INSTRUMENTTYPE"));
                transactionDetailsVO.setTransactionInstitutionName(resultSet.getString("TRANSACTIONINSTITUTIONNAME"));
                transactionDetailsVO.setTransactionInstitutionRefNo(resultSet.getString("TRANSACTIONINSTITUTIONREFNO"));
                transactionDetailsVO.setTransactionStateCode(resultSet.getString("TRANSACTIONSTATECODE"));
                transactionDetailsVO.setTransactionCountryCode(resultSet.getString("TRANSACTIONCOUNTRYCODE"));
                transactionDetailsVO.setTransactionAmount(resultSet.getString("AMOUNT"));
                transactionDetailsVO.setTransactionAmtInForeignCurr(resultSet.getString("AMOUNTINFOREIGNCURRENCY"));
                transactionDetailsVO.setTransactionCurrencyCode(resultSet.getString("CURRENCYCODE"));
                transactionDetailsVO.setPurposeOfTransaction(resultSet.getString("PURPOSEOFTRANSACTIONS"));
                transactionDetailsVO.setRiskRating(resultSet.getString("RISKRATING"));
                transactionDetailsVO.setPaymentInstrumentNo(resultSet.getString("PAYMENTINSTRUMENTNO"));
                transactionDetailsVO.setPaymentInstrumentInstName(resultSet.getString("PAYMENTINSTRUMENTINSTNAME"));
                transactionDetailsVO.setCustomerName(resultSet.getString("CUSTOMERNAME"));
                transactionDetailsVO.setOccupation(resultSet.getString("OCCUPATION"));
                transactionDetailsVO.setDateOfBirth(resultSet.getString("DATEOFBIRTH"));
                transactionDetailsVO.setGender(resultSet.getString("GENDER"));
                transactionDetailsVO.setNationality(resultSet.getString("NATIONALITY"));
                transactionDetailsVO.setIdentificationType(resultSet.getString("IDENTIFICATIONTYPE"));
                transactionDetailsVO.setIdentificationNo(resultSet.getString("IDENTIFICATIONNUMBER"));
                transactionDetailsVO.setIssuingAuthority(resultSet.getString("ISSUINGAUTHORITY"));
                transactionDetailsVO.setIssuingPlace(resultSet.getString("ISSUINGPLACE"));
                transactionDetailsVO.setPanNo(resultSet.getString("PANNO"));
                transactionDetailsVO.setUinNo(resultSet.getString("UINNO"));
                transactionDetailsVO.setAddressLine(resultSet.getString("ADDRESSLINE"));
                transactionDetailsVO.setCity(resultSet.getString("CITY"));
                transactionDetailsVO.setState(resultSet.getString("STATECODE"));
                transactionDetailsVO.setCountry(resultSet.getString("COUNTRYCODE"));
                transactionDetailsVO.setPinCode(resultSet.getString("PINCODE"));
                transactionDetailsVO.setTelephone(resultSet.getString("TELEPHONE"));
                transactionDetailsVO.setMobile(resultSet.getString("MOBILE"));
                transactionDetailsVO.setFax(resultSet.getString("FAX"));
                transactionDetailsVO.setEmailId(resultSet.getString("EMAILID"));
                transactionDetailsVO.setAccountNo(resultSet.getString("ACCOUNTNO"));
                transactionDetailsVO.setAccountWithInstitutionName(resultSet.getString("ACCOUNTWITHINSTITUTIONNAME"));
                transactionDetailsVO.setRelatedInstitutionRefNo(resultSet.getString("RELATEDINSTITUTIONREFNUM"));
                transactionDetailsVO.setRelatedInstitutionName(resultSet.getString("RELATEDINSTITUTIONNAME"));
                transactionDetailsVO.setInstitutionRelationFlag(resultSet.getString("INSTITUTIONRELATIONFLAG"));
                transactionDetailsVO.setTransactionRemarks(resultSet.getString("REMARKS"));
                transactionDetailsVO.setInstrIssInstRefno(resultSet.getString("INSTRISSINSTREFNO"));
                transactionDetailsVO.setInstrCountryCode(resultSet.getString("INSTRCOUNTRYCODE"));
                transactionDetailsVO.setPurposeCode(resultSet.getString("PURPOSECODE"));                
                transactionDetailsVO.setRltdInstRefNo(resultSet.getString("RLTDINSTREFNO"));
                transactionDetailsVO.setInstrHolderName(resultSet.getString("INSTRHOLDERNAME"));
                transactionDetailsVO.setRltnshpBegDate(resultSet.getString("RLTNSHPBEGDATE"));
                transactionDetailsVO.setCumPurchaseTurnover(resultSet.getString("CUMPURCHASETURNOVER"));
             /* 
                System.out.println("TRANSACTIONTYPE = "+resultSet.getString("TRANSACTIONTYPE"));
                System.out.println("TRANSACTIONDATE = "+resultSet.getString("TRANSACTIONDATE"));
                System.out.println("CURRENCYCODE = "+resultSet.getString("CURRENCYCODE"));
                System.out.println("INSTRUMENTTYPE = "+resultSet.getString("INSTRUMENTTYPE"));
                System.out.println("AMOUNT = "+resultSet.getString("AMOUNT"));
                */
				alltransactionDetails.add(transactionDetailsVO);
            }
		}catch(Exception e)
		{
			e.printStackTrace();
			log.error("Exception in INDSTRTRFDAOImpl -> getINDSTRTRFAnnexureTransactionDetails, Error Is:"+ e.toString());
			System.out.println("Exception in INDSTRTRFDAOImpl -> getINDSTRTRFAnnexureTransactionDetails, Error Is:"+ e.toString());
            e.toString();
		}finally{
			connectionUtil.closeResources(connection, callableStatement, resultSet, null);
		}
		return alltransactionDetails;
	}
	
	private ArrayList getINDSTRTRFAnnexureBranchDetails(String caseNo){
		Connection connection = null;
		CallableStatement callableStatement = null;
		ResultSet resultSet = null;
		ResultSet resultSet1 = null;
		ArrayList allBranchDetails = new ArrayList();
        ISTRTRFBranchDetailsVO branchDetailsVO = null;
        
		try{
			connection = connectionUtil.getConnection();
			callableStatement = connection.prepareCall("{CALL "+schemaName+"STP_GETISTRTRFANNXBRNCHDETAIL(?,?)}");
            callableStatement.setString(1, caseNo);
            callableStatement.registerOutParameter(2, oracle.jdbc.OracleTypes.CURSOR);
            callableStatement.execute();
            resultSet = (ResultSet)callableStatement.getObject(2); 
            while(resultSet.next()){
                branchDetailsVO = new ISTRTRFBranchDetailsVO();
                branchDetailsVO.setRepRole(resultSet.getString("REPORTINGROLE"));
                branchDetailsVO.setInstituteName(resultSet.getString("BANKNAME"));
                branchDetailsVO.setInstituteBranchName(resultSet.getString("BRANCHNAME"));
                branchDetailsVO.setInstituteRefNo(resultSet.getString("BRANCHREFERENCENUMBER"));
                branchDetailsVO.setInstituteAddress(resultSet.getString("BRANCHADDR1"));
                branchDetailsVO.setInstituteState(resultSet.getString("STATECODE"));
                branchDetailsVO.setInstituteCountry(resultSet.getString("BRANCHCOUNTRY"));
                branchDetailsVO.setInstitutePin(resultSet.getString("BRANCHPINCODE"));
                branchDetailsVO.setInstituteTelNo(resultSet.getString("BRANCHTELEPHONE"));
                branchDetailsVO.setInstituteMobNo(resultSet.getString("MOBILE"));
                branchDetailsVO.setInstituteFaxNo(resultSet.getString("BRANCHFAX"));
                branchDetailsVO.setInstituteEmail(resultSet.getString("BRANCHEMAIL"));
                branchDetailsVO.setInstituteRemarks(resultSet.getString("REMARKS"));
                branchDetailsVO.setBiccode(resultSet.getString("BICCODE"));
                
                allBranchDetails.add(branchDetailsVO);
            }
		}catch(Exception e)
		{
			e.printStackTrace();
			log.error("Exception in INDSTRDAOImpl -> getINDSTRTRFAnnexureBranchDetails, Error Is:"+ e.toString());
			System.out.println("Exception in INDSTRDAOImpl -> getINDSTRTRFAnnexureBranchDetails, Error Is:"+ e.toString());
            e.toString();
		}finally{
			connectionUtil.closeResources(null, callableStatement, resultSet, null);
			connectionUtil.closeResources(connection, callableStatement, resultSet1, null);
		}
		return allBranchDetails;
	}
	
	public void ExecuteSTRTRFXMLProcedures(String caseNo, String userCode){
		Connection connection = null;
		Connection connection1 = null;
		PreparedStatement preparedStatement = null;
		CallableStatement callableStatement = null;
		ResultSet resultSet = null;
		try{
			connection = connectionUtil.getConnection();
			preparedStatement = connection.prepareStatement("SELECT PROCEDURENAME FROM TB_REGULATORYPROCLIST WHERE REPORTINGTYPE='STR_TRF' ORDER BY EXECUTIONORDER");
			resultSet = preparedStatement.executeQuery();
			while (resultSet.next()) {
				String l_strProcName = resultSet.getString(1);
				//System.out.println(l_strProcName);
				try{
					connection1 = getConnection();
					callableStatement = connection1.prepareCall("{CALL "+l_strProcName+"(?,?)}");
					callableStatement.setString(1, caseNo);
					callableStatement.setString(2, userCode);
					callableStatement.execute();
				}catch(Exception e){
					log.error("Exception in INDSTRDAOImpl -> ExecuteSTRXMLProcedures, Error Is:"+ e.getMessage());
					e.printStackTrace();
				}finally{
					connectionUtil.closeResources(connection1, callableStatement, null, null);
				}
			}
		}catch(Exception e){
			log.error("Exception in INDSTRDAOImpl -> ExecuteSTRXMLProcedures, Error Is:"+ e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
	}
	
	public HashMap getSTRTRFXMlFileContent(String caseNo, String userCode){
		HashMap trfXMLFileDetails = new HashMap();
		LinkedHashMap trfXMLFileContent = new LinkedHashMap();
		Connection connection = null;
		CallableStatement callableStatement = null;
		ResultSet resultSet1 = null;
		ResultSet resultSet2 = null;
		try{
			ExecuteSTRTRFXMLProcedures(caseNo, userCode);
			//System.out.println(caseNo+" "+userCode);
			connection = connectionUtil.getConnection();
			callableStatement = connection.prepareCall("{CALL "+schemaName+"STP_EXPORTSTRTRFXMLFILE(?,?,?,?)}");
            callableStatement.setString(1, caseNo);
            callableStatement.setString(2, userCode);
            callableStatement.registerOutParameter(3, oracle.jdbc.OracleTypes.CURSOR);
            callableStatement.registerOutParameter(4, oracle.jdbc.OracleTypes.CURSOR);
            callableStatement.execute();
            resultSet1 = (ResultSet)callableStatement.getObject(3);
            resultSet2 = (ResultSet)callableStatement.getObject(4);
            if(resultSet1.next()){
            	trfXMLFileDetails.put("FILENAME", resultSet1.getString(1));
            }
            while(resultSet2.next()){
            	trfXMLFileContent.put(resultSet2.getString(1), resultSet2.getString(2));
            }
            trfXMLFileDetails.put("FILECONTENT", trfXMLFileContent);
		}catch(Exception e)
		{
			e.printStackTrace();
			log.error("Exception in INDSTRTRFDAOImpl -> getSTRTRFXMlFileContent, Error Is:"+ e.toString());
			System.out.println("Exception in INDSTRTRFDAOImpl -> getSTRTRFXMlFileContent, Error Is:"+ e.toString());
            e.toString();
		}finally{
			connectionUtil.closeResources(connection, callableStatement, resultSet1, null);
		}
		//System.out.println("trfXMLFileDetails = "+trfXMLFileDetails);
		return trfXMLFileDetails;
	}
	
	private void deleteTempTableData(String caseNo, String tempTable, String userCode){
		String sql = " DELETE FROM "+tempTable+" A "+
		             "  WHERE A.CASENO = '"+tempTable+"'";
		           
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		try{
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.executeUpdate();
		}catch(Exception e){
			log.error("Error while deleting data from temprary table "+e.getMessage());
			e.printStackTrace();
		}finally {
			connectionUtil.closeResources(connection, preparedStatement, null, null);
		}
	}

	private void saveUploadFileData(String caseNo,String fullFilePath, File inputFile, 
			List<List<String>> uploadedData, String tempTable, int dataColCount, String userCode, String userRole, String ipAddress){
		String sql = "INSERT INTO "+tempTable+" VALUES(?, ";
		for(int i = 1; i <= dataColCount; i++){
			sql = sql + "?, ";
		}
		sql = sql + "?, ?, ?, FUN_DATETIMETOCHAR(SYSTIMESTAMP))";
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		
		try{
			//System.out.println("SQL 1 = "+sql);
			preparedStatement = connection.prepareStatement(sql);
			for(List<String> recordData : uploadedData){
				preparedStatement.setString(1, caseNo);
				int colIndex = 1;
				for(int i = 0; i < recordData.size(); i++){
					colIndex = colIndex + 1;
					preparedStatement.setString(colIndex, recordData.get(i));
				}
				colIndex = colIndex + 1;
				preparedStatement.setString(colIndex, userCode);
				colIndex = colIndex + 1;
				preparedStatement.setString(colIndex, userRole);
				colIndex = colIndex + 1;
				preparedStatement.setString(colIndex, ipAddress);
				preparedStatement.addBatch();
			}

			preparedStatement.executeBatch();
		}catch(Exception e){
			log.error("Error while saving data from file in db "+e.getMessage());
			e.printStackTrace();
		}finally {
			connectionUtil.closeResources(connection, preparedStatement, null, null);
		}
	}
	
	public boolean executeFileUploadProcedures(String caseNo, String transactionNo, String fullFilePath, 
				String tempTableName, int colCount, String userCode, String userRole, String ipAddress){
		boolean executed = false;
		Connection connection = connectionUtil.getConnection();
		CallableStatement callableStatement = null;
		try{
			callableStatement = connection.prepareCall("{CALL "+schemaName+"STP_SAVETXNSTRTRFFILEDATA(?,?,?,?,?,?,?,?)}");
			callableStatement.setString(1, caseNo);
			callableStatement.setString(2, transactionNo);
			callableStatement.setString(3, fullFilePath);
			callableStatement.setString(4, tempTableName);
			callableStatement.setString(5, colCount+"");
			callableStatement.setString(6, userCode);
			callableStatement.setString(7, userRole);
			callableStatement.setString(8, ipAddress);
			callableStatement.execute();
			executed = true;
		}catch(Exception e){
			log.error("Error while saving file in db "+e.getMessage());
			e.printStackTrace();
		}finally {
			connectionUtil.closeResources(connection, callableStatement, null, null);
		}
		return executed;
	}
	
	private String[] stringArrayConversion(String a_strTemp){
        String l_strSusGrounds[] = new String[30];
        if(a_strTemp != null){
            StringTokenizer l_strToken = new StringTokenizer(a_strTemp, "~");
            for(int i = 0; l_strToken.hasMoreTokens(); i++)
                l_strSusGrounds[i] = l_strToken.nextToken().trim();
        }
        return l_strSusGrounds;
    }
	
	public Map<String, Object> executeFile(File inputFile, String procName){
		Map<String, Object> mainMap = new HashMap<String, Object>();
		Connection connection = null;
		Statement statement  = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		BufferedReader burreredReader = null;
		String currentLine = "";
		String l_strWholeFileText = "";
		String message = "";
		try{
			burreredReader = new BufferedReader(new FileReader(inputFile));
			while((currentLine = burreredReader.readLine()) != null){
				l_strWholeFileText = l_strWholeFileText+currentLine+"\n";
			}
			statement = connection.createStatement();
			statement.execute(l_strWholeFileText);
		}catch(Exception e)
		{
			e.printStackTrace();
			message = message+e.getMessage()+". \n";
		}
		try{
			//preparedStatement = connection.prepareStatement("SELECT DISTINCT NAME FROM USER_SOURCE WHERE NAME=?");
			connection = connectionUtil.getConnection();
			preparedStatement = connection.prepareStatement("SELECT DISTINCT OBJECT_NAME FROM USER_OBJECTS WHERE OBJECT_NAME = ? ");
			preparedStatement.setString(1, procName);
			resultSet = preparedStatement.executeQuery();
			if(resultSet.next()){
				mainMap.put("PROCCREATED", true);
				message = "File successfully executed. ";
			}else{
				mainMap.put("PROCCREATED", false);
				message = "file execution failed. ";
			}
		}catch(Exception e){
			message = message+e.getMessage();
		}finally{
			mainMap.put("MESSAGE",message);
			connectionUtil.closeResources(connection, statement, resultSet, null);
			try{
				burreredReader.close();	
			}
			catch(Exception e){
				e.printStackTrace();
			}
		}
		return mainMap;
	}
	
	public boolean saveSTRTRFTransactionFile(String caseNo, String fullFilePath, File inputFile, String userCode, String userRole, 
			String ipAddress) {
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		boolean isSaved = false;
		String transactionNo = "";
		try{
			FileReader l_frInputFileReader = new FileReader(inputFile);
			connection = connectionUtil.getConnection();
			preparedStatement = connection.prepareStatement("INSERT INTO TB_STRTRFTRANSACTIONFILE (CASENO, FILEPATH, FILENAME, FILEDATA, UPLOADEDBY, UPLOADEDDATETIME) VALUES(?,?,?,?,?, SYSTIMESTAMP)");
			preparedStatement.setString(1, caseNo);
			preparedStatement.setString(2, fullFilePath);
			preparedStatement.setString(3, inputFile.getName());
			preparedStatement.setCharacterStream(4, l_frInputFileReader, (int) inputFile.length());
			preparedStatement.setString(5, userCode);
			int x = preparedStatement.executeUpdate();
			
			List<List<String>> fileContent = new Vector<List<String>>();
			String filePath = fullFilePath;
			File file = new File(filePath);
			BufferedReader br = null;
			br = new BufferedReader(new FileReader(file));
			String currentLine = "";
			int lineCount = 1;
			int colCount = 61;
			boolean shouldRun = true;
			
			while((currentLine = br.readLine()) != null){
				String[] content = CommonUtil.splitString(currentLine, "~");
				/*System.out.println("currentLine : "+currentLine+" And Length: "+content.length);
				System.out.println("LineCount = "+lineCount);
				System.out.println("ColCount = "+colCount);
				System.out.println("content length = "+content.length);
				System.out.println("txn val = "+content[0]);*/
				transactionNo = content[0];
				if(content.length == colCount){
					List<String> list = new Vector<String>();
					for(String part : content)
						list.add(part);
					fileContent.add(list);
				}else{
					shouldRun = false;
					isSaved = false;
					log.error("File content is not proper in "+inputFile.getName()+" at line no : "+lineCount);
				}
				lineCount++;
			}
			String tempTableName = "TB_STRTRFTRANSACTIONFILEDATA";
			try{
				deleteTempTableData(caseNo, tempTableName, userCode);
			}
			catch(Exception exp){
				isSaved = false;
			}
			try{
				saveUploadFileData(caseNo, fullFilePath, inputFile, 
					fileContent, tempTableName, colCount, userCode, userRole, ipAddress);
			}
			catch(Exception exp){
				isSaved = false;
			}
			try{
				executeFileUploadProcedures(caseNo, transactionNo, fullFilePath, tempTableName, colCount, userCode, userRole, ipAddress);
			}
			catch(Exception exp){
				isSaved = false;
			}
			isSaved = true;		
		}catch(Exception e){
			log.error("Exception in INDSTRTRFDAOImpl -> saveSTRTRFTransactionFile, Error Is:"+ e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, null, null);
		}
		return isSaved;
	}
	
	private ArrayList getINDSTRTRFAnnexureIndividualDetails(String caseNo){
		Connection connection = null;
		CallableStatement callableStatement = null;
		ResultSet resultSet = null;
		ArrayList allIndividualDetails = new ArrayList();
		try{
			connection = connectionUtil.getConnection();
			callableStatement = connection.prepareCall("{CALL "+schemaName+"STP_GETISTRTRFANNEXADETAILS(?,?,?,?)}");
            callableStatement.setString(1, caseNo);
            callableStatement.setString(2, "");
            callableStatement.setString(3, "");
            callableStatement.registerOutParameter(4, oracle.jdbc.OracleTypes.CURSOR);
            callableStatement.execute();
            ISTRIndividualDetailsVO individualDetailsVO;
            resultSet = (ResultSet)callableStatement.getObject(4); 
            while(resultSet.next()){
                individualDetailsVO = new ISTRIndividualDetailsVO();
                individualDetailsVO.setNameOfBank(resultSet.getString("nameOfBank"));
                individualDetailsVO.setBSRCode(resultSet.getString("bSRCode"));
                individualDetailsVO.setAnnexEnclosed(resultSet.getString("annexEnclosed"));
                individualDetailsVO.setFullName(resultSet.getString("fullName"));
                individualDetailsVO.setCustomerId(resultSet.getString("customerId"));
                individualDetailsVO.setAccountNo(resultSet.getString("accountNo"));
                individualDetailsVO.setFatherName(resultSet.getString("fatherName"));
                individualDetailsVO.setOccupation(resultSet.getString("occupation"));
                individualDetailsVO.setDob(resultSet.getString("dob"));
                individualDetailsVO.setSex(resultSet.getString("sex"));
                individualDetailsVO.setNationality(resultSet.getString("nationality"));
                individualDetailsVO.setIdDoc(resultSet.getString("idDoc"));
                individualDetailsVO.setIdNumber(resultSet.getString("idNumber"));
                individualDetailsVO.setIssuingAuth(resultSet.getString("issuingAuth"));
                individualDetailsVO.setPlaceOfIssue(resultSet.getString("placeOfIssue"));
                individualDetailsVO.setPanNo(resultSet.getString("panNo"));
                individualDetailsVO.setUinNo(resultSet.getString("UINNO"));
                individualDetailsVO.setAddBuildingNo(resultSet.getString("addBuildingNo"));
                individualDetailsVO.setAddStreet(resultSet.getString("addStreet"));
                individualDetailsVO.setAddLocality(resultSet.getString("addLocality"));
                individualDetailsVO.setAddCity(resultSet.getString("addCity"));
                individualDetailsVO.setAddState(resultSet.getString("addState"));
                individualDetailsVO.setAddCountry(resultSet.getString("addCountry"));
                individualDetailsVO.setAddPinCode(resultSet.getString("addPinCode"));
                individualDetailsVO.setAddTelNo(resultSet.getString("addTelNo"));
                individualDetailsVO.setAddFaxNo(resultSet.getString("addFaxNo"));
                individualDetailsVO.setAddMobileNo(resultSet.getString("addMobileNo"));
                individualDetailsVO.setAddEmail(resultSet.getString("addEmail"));
                individualDetailsVO.setAddEmployername(resultSet.getString("addEmployername"));
                individualDetailsVO.setSecaddBuildingNo(resultSet.getString("secaddBuildingNo"));
                individualDetailsVO.setSecaddStreet(resultSet.getString("secaddStreet"));
                individualDetailsVO.setSecaddLocality(resultSet.getString("secaddLocality"));
                individualDetailsVO.setSecaddCity(resultSet.getString("secaddCity"));
                individualDetailsVO.setSecaddState(resultSet.getString("secaddState"));
                individualDetailsVO.setSecaddCountry(resultSet.getString("secaddCountry"));
                individualDetailsVO.setSecaddPinCode(resultSet.getString("secaddPinCode"));
                individualDetailsVO.setSecaddTelNo(resultSet.getString("secaddTelNo"));
				allIndividualDetails.add(individualDetailsVO);
            }
		}catch(Exception e){
			log.error("Exception in INDSTRTRFDAOImpl -> getINDSTRTRFAnnexureIndividualDetails, Error Is:"+ e.toString());
			System.out.println("Exception in INDSTRTRFDAOImpl -> getINDSTRTRFAnnexureIndividualDetails, Error Is:"+ e.toString());
            e.toString();
		}finally{
			connectionUtil.closeResources(connection, callableStatement, resultSet, null);
		}
		return allIndividualDetails;
	}
	
	private ArrayList getINDSTRTRFAnnexureLegalEntityDetails(String caseNo){
		Connection connection = null;
		CallableStatement callableStatement = null;
		ResultSet resultSet = null;
		CallableStatement callableStatement1 = null;
		ResultSet resultSet1 = null;
		ArrayList alllegalPersonDetails = new ArrayList();
        ISTRTRFEntityDetailsVO legalPersonDetailsVO = null;
        
		try{
			connection = connectionUtil.getConnection();
			callableStatement = connection.prepareCall("{CALL "+schemaName+"STP_GETISTRTRFANNEXBDETAILS(?,?,?,?)}");
            callableStatement.setString(1, caseNo);
            callableStatement.setString(2, "");
            callableStatement.setString(3, "");
            callableStatement.registerOutParameter(4, oracle.jdbc.OracleTypes.CURSOR);
            callableStatement.execute();
            resultSet = (ResultSet)callableStatement.getObject(4); 
            while(resultSet.next()){
                String othRelPerId[] = new String[25];
                String othRelPerName[] = new String[25];
                String othRelPerCode[] = new String[25];
                String othRelPerInd_Legal[] = new String[25];
                legalPersonDetailsVO = new ISTRTRFEntityDetailsVO();
                legalPersonDetailsVO.setNameOfBank(resultSet.getString("NameOfBank"));
                legalPersonDetailsVO.setBSRCode(resultSet.getString("bSRCode"));
                legalPersonDetailsVO.setAnnexEnclosed(resultSet.getString("annexEnclosed"));
                legalPersonDetailsVO.setNameOfLegalPerson(resultSet.getString("nameOfLegalPerson"));
                legalPersonDetailsVO.setCustomerID(resultSet.getString("customerID"));
                legalPersonDetailsVO.setAccountNo(resultSet.getString("accountNo"));
                legalPersonDetailsVO.setNatureOfBusiness(resultSet.getString("natureOfBusiness"));
                legalPersonDetailsVO.setIncorporationDate(resultSet.getString("incorporationDate"));
                legalPersonDetailsVO.setConstitutionType(resultSet.getString("constitutionType"));
                legalPersonDetailsVO.setRegistrarionNumber(resultSet.getString("registrationNumber"));
                legalPersonDetailsVO.setRegisteringAuth(resultSet.getString("registeringAuth"));
                legalPersonDetailsVO.setRegisteringPlace(resultSet.getString("registeringPlace"));
                legalPersonDetailsVO.setPanNo(resultSet.getString("panNo"));
                legalPersonDetailsVO.setUinNO(resultSet.getString("UINNO"));
                legalPersonDetailsVO.setAddBuildingNo(resultSet.getString("addBuildingNo"));
                legalPersonDetailsVO.setAddStreet(resultSet.getString("addStreet"));
                legalPersonDetailsVO.setAddLocality(resultSet.getString("addLocality"));
                legalPersonDetailsVO.setAddCity(resultSet.getString("addCity"));
                legalPersonDetailsVO.setAddState(resultSet.getString("addState"));
                legalPersonDetailsVO.setAddCountry(resultSet.getString("addCountry"));
                legalPersonDetailsVO.setAddPinCode(resultSet.getString("addPinCode"));
                legalPersonDetailsVO.setAddTelNo(resultSet.getString("addTelNo"));
                legalPersonDetailsVO.setAddFaxNo(resultSet.getString("addFaxNo"));
                legalPersonDetailsVO.setAddMobilNo(resultSet.getString("AddMobileNo"));
                legalPersonDetailsVO.setAddEmail(resultSet.getString("addEmail"));
                legalPersonDetailsVO.setSecaddBuildingNo(resultSet.getString("COMM_ADDRESSLINE1"));
                legalPersonDetailsVO.setSecaddStreet(resultSet.getString("COMM_ADDRESSLINE2"));
                legalPersonDetailsVO.setSecaddLocality(resultSet.getString("COMM_CITY"));
                legalPersonDetailsVO.setSecaddState(resultSet.getString("COMM_STATE"));
                legalPersonDetailsVO.setSecaddCountry(resultSet.getString("COMM_COUNTRY"));
                legalPersonDetailsVO.setSecaddPinCode(resultSet.getString("COMM_PINCODE"));
                legalPersonDetailsVO.setSecaddTelNo(resultSet.getString("COMM_PHONENO"));
                legalPersonDetailsVO.setSecaddFaxNo(resultSet.getString("COMM_FAXNO"));
				int count = 0;
				callableStatement1 = connection.prepareCall("{CALL "+schemaName+"STP_GETISTRTRFANNEXBDIRECTORS(?,?,?,?)}");
                callableStatement1.setString(1, caseNo);
                callableStatement1.setString(2, resultSet.getString("customerID"));
                callableStatement1.setString(3, "");
                callableStatement1.registerOutParameter(4, oracle.jdbc.OracleTypes.CURSOR);
                callableStatement1.execute();
                resultSet1 = (ResultSet)callableStatement1.getObject(4); 
                while(resultSet1.next()){
                    othRelPerId[count] = resultSet1.getString("LEGALCUSTOMERID");
                    othRelPerName[count] = resultSet1.getString("LEGALCUSTOMERNAME");
                    othRelPerCode[count] = resultSet1.getString("RELATIONCODE");
                    othRelPerInd_Legal[count] = resultSet1.getString("IND_LEGAL");
                    if(++count > 5)
                        break;
                }
				legalPersonDetailsVO.setListofDirectorsPersonsName(othRelPerName);
				legalPersonDetailsVO.setListofDirectorsPersonsID(othRelPerId);
				legalPersonDetailsVO.setListofDirectorsPersonsRelation(othRelPerCode);
				legalPersonDetailsVO.setListofDirectorsAnnexAB(othRelPerInd_Legal);
                alllegalPersonDetails.add(legalPersonDetailsVO);
            }
		}catch(Exception e){
			log.error("Exception in INDSTRTRFDAOImpl -> getINDSTRTRFAnnexureLegalEntityDetails, Error Is:"+ e.toString());
			System.out.println("Exception in INDSTRTRFDAOImpl -> getINDSTRTRFAnnexureLegalEntityDetails, Error Is:"+ e.toString());
            e.toString();
		}finally{
			connectionUtil.closeResources(null, callableStatement, resultSet, null);
			connectionUtil.closeResources(connection, callableStatement, resultSet1, null);
		}
		return alllegalPersonDetails;
	}
	
	public boolean addIndividualDetailsToList(String caseNo, String userCode, String terminalId, String accountNo, String relationFlag, 
			String counterAccountNo, String counterId, String counterName, String bsrCode, ISTRTRFIndividualDetailsVO individualDetailsVO)
    {
    	Connection connection = null;
    	CallableStatement callableStatement = null;
        boolean isSaved = false;
        try
        {
        	connection = connectionUtil.getConnection();
            callableStatement = connection.prepareCall("{CALL "+schemaName+"STP_ISTRTRFADDUPDATNEWINDVDUAL(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");
            callableStatement.setString(1, caseNo);
            callableStatement.setString(2, userCode);
            callableStatement.setString(3, terminalId);
            callableStatement.setString(4, accountNo); 
         	callableStatement.setString(5, relationFlag); 
         	callableStatement.setString(6, counterAccountNo); 
         	callableStatement.setString(7, counterId);
         	callableStatement.setString(8, counterName); 
         	callableStatement.setString(9, bsrCode);
         	callableStatement.setString(10, individualDetailsVO.getNameOfBank());
            callableStatement.setString(11, individualDetailsVO.getFullName());
            callableStatement.setString(12, individualDetailsVO.getCustomerId());
            callableStatement.setString(13, individualDetailsVO.getRelationFlag());
            callableStatement.setString(14, individualDetailsVO.getFatherName());
            callableStatement.setString(15, individualDetailsVO.getOccupation());
            callableStatement.setString(16, individualDetailsVO.getDob());
            callableStatement.setString(17, individualDetailsVO.getSex());
            callableStatement.setString(18, individualDetailsVO.getNationality());
            callableStatement.setString(19, individualDetailsVO.getIdDoc());
            callableStatement.setString(20, individualDetailsVO.getIdNumber());
            callableStatement.setString(21, individualDetailsVO.getIssuingAuth());
            callableStatement.setString(22, individualDetailsVO.getPlaceOfIssue());
            callableStatement.setString(23, individualDetailsVO.getPanNo());
            callableStatement.setString(24, individualDetailsVO.getUinNo());
            callableStatement.setString(25, individualDetailsVO.getAddEmployername());
            callableStatement.setString(26, individualDetailsVO.getAddBuildingNo());
            callableStatement.setString(27, individualDetailsVO.getAddStreet());
            callableStatement.setString(28, individualDetailsVO.getAddLocality());
            callableStatement.setString(29, individualDetailsVO.getAddCity());
            callableStatement.setString(30, individualDetailsVO.getAddState());
            callableStatement.setString(31, individualDetailsVO.getAddCountry());
            callableStatement.setString(32, individualDetailsVO.getAddPinCode());
            callableStatement.setString(33, individualDetailsVO.getAddTelNo());
            callableStatement.setString(34, individualDetailsVO.getAddMobileNo());
            callableStatement.setString(35, individualDetailsVO.getAddFaxNo());
            callableStatement.setString(36, individualDetailsVO.getAddEmail());
            callableStatement.setString(37, individualDetailsVO.getSecaddBuildingNo());
            callableStatement.setString(38, individualDetailsVO.getSecaddStreet());
            callableStatement.setString(39, individualDetailsVO.getSecaddLocality());
            callableStatement.setString(40, individualDetailsVO.getSecaddCity());
            callableStatement.setString(41, individualDetailsVO.getSecaddState());
            callableStatement.setString(42, individualDetailsVO.getSecaddCountry());
            callableStatement.setString(43, individualDetailsVO.getSecaddPinCode());
            callableStatement.setString(44, individualDetailsVO.getSecaddTelNo());
            callableStatement.setString(45, individualDetailsVO.getAccountNo());
            
            callableStatement.executeUpdate();
            isSaved = true;
        }
        catch(Exception e)
        {
        	log.error("Exception in ISTRTRFDAOImpl -> addIndividualDetailsToList, Error Is:"+ e.toString());
            System.out.println("Exception in ISTRTRFDAOImpl -> addIndividualDetailsToList, Error Is:"+ e.toString());
            e.toString();
        }finally{
        	connectionUtil.closeResources(connection, callableStatement, null, null);
        }
        return isSaved;
    }
    
    public boolean addEntityDetailsToList(String strCaseNo, String strUserCode, String strTerminalId, String strAccountNo, 
    		String relationFlag, String legalAccountNo, String legalCustomerId, String legalCustomerName, String legalBSRCode, 
    		ISTRTRFEntityDetailsVO legalDetailsDTO)
    {
    	Connection connection = null;
        CallableStatement callableStatement = null;
        boolean isSaved = false;
        try
        {
        	connection = connectionUtil.getConnection();
	        callableStatement = connection.prepareCall("{CALL "+schemaName+"STP_ISTRTRFADDUPDATENEWLEGAL(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");
	        callableStatement.setString(1, strCaseNo);
	        callableStatement.setString(2, strUserCode);
	        callableStatement.setString(3, strTerminalId);
	        callableStatement.setString(4, strAccountNo);
	        callableStatement.setString(5, relationFlag);
	        callableStatement.setString(6, legalAccountNo);
	        callableStatement.setString(7, legalCustomerId);
	        callableStatement.setString(8, legalCustomerName);
	        callableStatement.setString(9, legalBSRCode);
	        callableStatement.setString(10, legalDetailsDTO.getNameOfBank());
	        callableStatement.setString(11, legalDetailsDTO.getNameOfLegalPerson());
	        callableStatement.setString(12, legalDetailsDTO.getCustomerID());
	        callableStatement.setString(13, legalDetailsDTO.getLegalRelationFlag());
	        callableStatement.setString(14, legalDetailsDTO.getNatureOfBusiness());
	        callableStatement.setString(15, legalDetailsDTO.getIncorporationDate());
	        callableStatement.setString(16, legalDetailsDTO.getConstitutionType());
	        callableStatement.setString(17, legalDetailsDTO.getRegistrarionNumber());
	        callableStatement.setString(18, legalDetailsDTO.getRegisteringAuth());
	        callableStatement.setString(19, legalDetailsDTO.getRegisteringPlace());
	        callableStatement.setString(20, legalDetailsDTO.getPanNo());
	        callableStatement.setString(21, legalDetailsDTO.getUinNO());
	        callableStatement.setString(22, legalDetailsDTO.getAddBuildingNo());
	        callableStatement.setString(23, legalDetailsDTO.getAddStreet());
	        callableStatement.setString(24, legalDetailsDTO.getAddLocality());
	        callableStatement.setString(25, legalDetailsDTO.getAddCity());
	        callableStatement.setString(26, legalDetailsDTO.getAddState());
	        callableStatement.setString(27, legalDetailsDTO.getAddCountry());
	        callableStatement.setString(28, legalDetailsDTO.getAddPinCode());
	        callableStatement.setString(29, legalDetailsDTO.getAddTelNo());
	        callableStatement.setString(30, legalDetailsDTO.getAddMobilNo());
	        callableStatement.setString(31, legalDetailsDTO.getAddFaxNo());
	        callableStatement.setString(32, legalDetailsDTO.getAddEmail());
	        callableStatement.setString(33, legalDetailsDTO.getSecaddBuildingNo());
	        callableStatement.setString(34, legalDetailsDTO.getSecaddStreet());
	        callableStatement.setString(35, legalDetailsDTO.getSecaddLocality());
	        callableStatement.setString(36, legalDetailsDTO.getSecaddCity());
	        callableStatement.setString(37, legalDetailsDTO.getSecaddState());
	        callableStatement.setString(38, legalDetailsDTO.getSecaddCountry());
	        callableStatement.setString(39, legalDetailsDTO.getSecaddPinCode());
	        callableStatement.setString(40, legalDetailsDTO.getSecaddTelNo());
	        callableStatement.setString(41, legalDetailsDTO.getSecaddFaxNo());
	        callableStatement.setString(42, legalDetailsDTO.getAccountNo());
	        callableStatement.executeUpdate();
	        isSaved = true;
        }
        catch(Exception e)
        {
        	log.error("Exception in ISTRTRFDAOImpl -> addEntityDetailsToList, Error Is:"+ e.toString());
            System.out.println("Exception in ISTRTRFDAOImpl -> addEntityDetailsToList, Error Is:"+ e.toString());
            e.printStackTrace();
        }finally{
        	connectionUtil.closeResources(connection, callableStatement, null, null);
        }
        return isSaved;
    }
}
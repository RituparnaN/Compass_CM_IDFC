package com.quantumdataengines.app.compass.dao.regulatoryReports.india;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
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

import com.quantumdataengines.app.compass.model.regulatoryReports.india.ISTRAccountDetailsVO;
import com.quantumdataengines.app.compass.model.regulatoryReports.india.ISTREntityDetailsVO;
import com.quantumdataengines.app.compass.model.regulatoryReports.india.ISTRIndividualDetailsVO;
import com.quantumdataengines.app.compass.model.regulatoryReports.india.ISTRManualDetailsVO;
import com.quantumdataengines.app.compass.util.CommonUtil;
import com.quantumdataengines.app.compass.util.ConnectionUtil;

@Repository
public class INDSTRDAOImpl implements INDSTRDAO {
	
	@Autowired
	private ConnectionUtil connectionUtil;
	
	@Value("${compass.aml.config.schemaName}")
	private String schemaName;
	
	private static final Logger log = LoggerFactory.getLogger(INDSTRDAOImpl.class);
	
	public Connection getConnection(){
		Connection connection = null;
		try{
			connection = connectionUtil.getConnection();
		}catch(Exception e){
			log.error("Error in creating db connection : INDSTRDAOImpl -> "+e.getMessage());
			e.printStackTrace();
		}
		return connection;
	}
	
	public HashMap getNewIndividualDetails(String counterName, String counterId, String accountNo, String caseNo){
		Connection connection = null;
        CallableStatement callableStatement = null;
        ResultSet resultSet = null;
        HashMap hashMap = new HashMap();
        ISTRIndividualDetailsVO individualDetailsVO = null;
        String relationFlag = "";
        String strAccountNo = "";
        try
        {
        	connection = connectionUtil.getConnection();
			callableStatement = connection.prepareCall("{CALL STP_ISTRGETADDEDDETAILS(?,?,?,?,?,?,?)}");
            callableStatement.setString(1, caseNo);
            callableStatement.setString(2, "INDIVIDUAL");
            callableStatement.setString(3, counterName);
            callableStatement.setString(4, counterId);
            callableStatement.setString(5, accountNo);
            callableStatement.setString(6, "");
            callableStatement.registerOutParameter(7, oracle.jdbc.OracleTypes.CURSOR);
            callableStatement.execute();
            resultSet = (ResultSet)callableStatement.getObject(7);
            while(resultSet.next()){
                individualDetailsVO = new ISTRIndividualDetailsVO();
                relationFlag = resultSet.getString("RELATIONFLAG");
                strAccountNo = resultSet.getString("ACCOUNTNO");
                individualDetailsVO.setNameOfBank(resultSet.getString("NAMEOFBANK"));
                individualDetailsVO.setBSRCode(resultSet.getString("BSRCODE"));
                individualDetailsVO.setFullName(resultSet.getString("FULLNAME"));
                individualDetailsVO.setCustomerId(resultSet.getString("CUSTOMERID"));
                individualDetailsVO.setAccountNo(resultSet.getString("ACCOUNTNO"));
                individualDetailsVO.setRelationFlag(resultSet.getString("RELATIONFLAG"));
                individualDetailsVO.setFatherName(resultSet.getString("FATHERNAME"));
                individualDetailsVO.setOccupation(resultSet.getString("OCCUPATION"));
                individualDetailsVO.setDob(resultSet.getString("DOB"));
                individualDetailsVO.setSex(resultSet.getString("SEX"));
                individualDetailsVO.setNationality(resultSet.getString("NATIONALITY"));
                individualDetailsVO.setIdDoc(resultSet.getString("IDDOC"));
                individualDetailsVO.setIdNumber(resultSet.getString("IDNUMBER"));
                individualDetailsVO.setIssuingAuth(resultSet.getString("ISSUINGAUTH"));
                individualDetailsVO.setPlaceOfIssue(resultSet.getString("PLACEOFISSUE"));
                individualDetailsVO.setPanNo(resultSet.getString("PANNO"));
                individualDetailsVO.setUinNo(resultSet.getString("UINNO"));
                individualDetailsVO.setAddBuildingNo(resultSet.getString("ADDBUILDINGNO"));
                individualDetailsVO.setAddStreet(resultSet.getString("ADDSTREET"));
                individualDetailsVO.setAddLocality(resultSet.getString("ADDLOCALITY"));
                individualDetailsVO.setAddCity(resultSet.getString("ADDCITY"));
                individualDetailsVO.setAddState(resultSet.getString("ADDSTATE"));
                individualDetailsVO.setAddCountry(resultSet.getString("ADDCOUNTRY"));
                individualDetailsVO.setAddPinCode(resultSet.getString("ADDPINCODE"));
                individualDetailsVO.setAddTelNo(resultSet.getString("ADDTELNO"));
                individualDetailsVO.setAddMobileNo(resultSet.getString("ADDMOBILENO"));
                individualDetailsVO.setAddFaxNo(resultSet.getString("ADDFAXNO"));
                individualDetailsVO.setAddEmail(resultSet.getString("ADDEMAIL"));
                individualDetailsVO.setAddEmployername(resultSet.getString("ADDEMPLOYERNAME"));
                individualDetailsVO.setSecaddBuildingNo(resultSet.getString("SECADDBUILDINGNO"));
                individualDetailsVO.setSecaddStreet(resultSet.getString("SECADDSTREET"));
                individualDetailsVO.setSecaddLocality(resultSet.getString("SECADDLOCALITY"));
                individualDetailsVO.setSecaddCity(resultSet.getString("SECADDCITY"));
                individualDetailsVO.setSecaddState(resultSet.getString("SECADDSTATE"));
                individualDetailsVO.setSecaddCountry(resultSet.getString("SECADDCOUNTRY"));
                individualDetailsVO.setSecaddPinCode(resultSet.getString("SECADDPINCODE"));
                individualDetailsVO.setSecaddTelNo(resultSet.getString("SECADDTELNO"));
            }
            hashMap.put("CounterAccountno", strAccountNo);
            hashMap.put("RelationFlag", relationFlag);
            hashMap.put("ALIndvDetailsDTO", individualDetailsVO);
        }
        catch(Exception e)
        {
        	log.error("Exception in ISTDAOImpl -> getNewIndividualDetails " + e.toString());
            System.out.println("Exception in ISTDAOImpl -> getNewIndividualDetails " + e.toString());
            e.printStackTrace();
        }finally{
        	connectionUtil.closeResources(connection, callableStatement, resultSet, null);
        }
        return hashMap;
    }
    
	public boolean deleteIndividualDetails(String counterName, String counterId, String accountNo, String userCode, String caseNo, String relationType){
		Connection connection = null;
		CallableStatement callableStatement = null;
        boolean isDeleted = false;
        try
        {
        	connection = connectionUtil.getConnection();
            callableStatement = connection.prepareCall("{CALL STP_ISTRDELETEADDEDDETAILS(?,?,?,?,?,?,?)}");
            callableStatement.setString(1, caseNo);
            callableStatement.setString(2, "Individuals");
            callableStatement.setString(3, userCode);
            callableStatement.setString(4, counterName);
            callableStatement.setString(5, counterId);
            callableStatement.setString(6, accountNo);
            callableStatement.setString(7, relationType);
            callableStatement.executeUpdate();
            isDeleted = true;
        }
        catch(Exception e)
        {
        	log.error("Exception in ISTRDAOImpl->deleteIndividualDetails " + e.toString());
            System.out.println("Exception in ISTRDAOImpl->deleteIndividualDetails " + e.toString());
            e.printStackTrace();
        }finally{
        	connectionUtil.closeResources(connection, callableStatement, null, null);
        }
        return isDeleted;
    }
    
    public HashMap getEntityDetails(String legalAccountNo, String legalCustomerName, String legalCustomerId, String caseNo){
    	Connection connection = null;
    	CallableStatement callableStatement = null;
        ResultSet resultSet = null;
        HashMap hashMap = new HashMap();
        ISTREntityDetailsVO legalPersonDetailsVO = null;
        String accountNo = "";
        String referenceType = "";
        try
        {
        	connection = connectionUtil.getConnection();
            callableStatement = connection.prepareCall("{CALL STP_ISTRGETADDEDDETAILS(?,?,?,?,?,?,?)}");
            callableStatement.setString(1, caseNo);
            callableStatement.setString(2, "LEGAL");
            callableStatement.setString(3, legalCustomerName);
            callableStatement.setString(4, legalCustomerId);
            callableStatement.setString(5, legalAccountNo);
            callableStatement.setString(6, "");
            callableStatement.registerOutParameter(7, oracle.jdbc.OracleTypes.CURSOR);
            callableStatement.execute();
            resultSet = (ResultSet)callableStatement.getObject(7);
            while(resultSet.next()){
                legalPersonDetailsVO = new ISTREntityDetailsVO();
                legalPersonDetailsVO.setNameOfBank(resultSet.getString("NAMEOFBANK"));
                legalPersonDetailsVO.setBSRCode(resultSet.getString("BSRCODE"));
                legalPersonDetailsVO.setNameOfLegalPerson(resultSet.getString("NAMEOFLEGALPERSON"));
                legalPersonDetailsVO.setCustomerID(resultSet.getString("CUSTOMERID"));
                legalPersonDetailsVO.setAccountNo(resultSet.getString("ACCOUNTNO"));
                legalPersonDetailsVO.setLegalRelationFlag(resultSet.getString("ANNEXENCLOSED"));
                accountNo = resultSet.getString("ACCOUNTNO");
                legalPersonDetailsVO.setNatureOfBusiness(resultSet.getString("NATUREOFBUSINESS"));
                legalPersonDetailsVO.setIncorporationDate(resultSet.getString("INCORPORATIONDATE"));
                referenceType = resultSet.getString("REFERENCETYPE");
                legalPersonDetailsVO.setConstitutionType(resultSet.getString("CONSTITUTIONTYPE"));
                legalPersonDetailsVO.setRegistrarionNumber(resultSet.getString("REGISTRATIONNUMBER"));
                legalPersonDetailsVO.setRegisteringAuth(resultSet.getString("REGISTERINGAUTH"));
                legalPersonDetailsVO.setRegisteringPlace(resultSet.getString("REGISTERINGPLACE"));
                legalPersonDetailsVO.setPanNo(resultSet.getString("PANNO"));
                legalPersonDetailsVO.setUinNO(resultSet.getString("UINNO"));
                legalPersonDetailsVO.setAddBuildingNo(resultSet.getString("ADDBUILDINGNO"));
                legalPersonDetailsVO.setAddStreet(resultSet.getString("ADDSTREET"));
                legalPersonDetailsVO.setAddLocality(resultSet.getString("ADDLOCALITY"));
                legalPersonDetailsVO.setAddCity(resultSet.getString("ADDCITY"));
                legalPersonDetailsVO.setAddState(resultSet.getString("ADDSTATE"));
                legalPersonDetailsVO.setAddCountry(resultSet.getString("ADDCOUNTRY"));
                legalPersonDetailsVO.setAddPinCode(resultSet.getString("ADDPINCODE"));
                legalPersonDetailsVO.setAddTelNo(resultSet.getString("ADDTELNO"));
                legalPersonDetailsVO.setAddMobilNo(resultSet.getString("ADDMOBILENO"));
                legalPersonDetailsVO.setAddFaxNo(resultSet.getString("ADDFAXNO"));
                legalPersonDetailsVO.setAddEmail(resultSet.getString("ADDEMAIL"));
                legalPersonDetailsVO.setSecaddBuildingNo(resultSet.getString("COMM_ADDRESSLINE1"));
                legalPersonDetailsVO.setSecaddStreet(resultSet.getString("COMM_ADDRESSLINE2"));
                legalPersonDetailsVO.setSecaddLocality(resultSet.getString("COMM_CITY"));
                legalPersonDetailsVO.setSecaddState(resultSet.getString("COMM_STATE"));
                legalPersonDetailsVO.setSecaddCountry(resultSet.getString("COMM_COUNTRY"));
                legalPersonDetailsVO.setSecaddPinCode(resultSet.getString("COMM_PINCODE"));
                legalPersonDetailsVO.setSecaddTelNo(resultSet.getString("COMM_PHONENO"));
                legalPersonDetailsVO.setSecaddFaxNo(resultSet.getString("COMM_FAXNO"));
                legalPersonDetailsVO.setSecaddFaxNo(resultSet.getString("COMM_FAXNO"));
            }
            hashMap.put("LegalAccountNo", accountNo);
            hashMap.put("LegalRefType", referenceType);
            hashMap.put("LegalEntDetailsDTO", legalPersonDetailsVO);
        }
        catch(Exception e)
        {
        	log.error("Exception in ISTRDAOImpl -> getEntityDetails " + e.toString());
            System.out.println("Exception in ISTRDAOImpl -> getEntityDetails " + e.toString());
            e.printStackTrace();
        }finally{
        	connectionUtil.closeResources(connection, callableStatement, resultSet, null);
        }
        return hashMap;
    }
    
    public boolean deleteEntityDetails(String legalAccountNo, String legalAccountName, String legalCustomerId, String userCode, String caseNo){
    	Connection connection = null;
    	CallableStatement callableStatement = null;
        boolean isDeleted = false;
        try
        {
        	connection = connectionUtil.getConnection();
            callableStatement = connection.prepareCall("{CALL STP_ISTRDELETEADDEDDETAILS(?,?,?,?,?,?,?)}");
            callableStatement.setString(1, caseNo);
            callableStatement.setString(2, "Legal");
            callableStatement.setString(3, userCode);
            callableStatement.setString(4, legalAccountName);
            callableStatement.setString(5, legalCustomerId);
            callableStatement.setString(6, legalAccountNo);
            callableStatement.setString(7, " ");
            callableStatement.executeUpdate();
            isDeleted = true;
        }
        catch(Exception e)
        {
        	log.error("Exception in ISTRDAOImpl->deleteEntityDetails " +e.toString());
            System.out.println("Exception in ISTRDAOImpl->deleteEntityDetails " +e.toString());
            e.printStackTrace();
        }finally{
        	connectionUtil.closeResources(connection, callableStatement, null, null);
        }
        return isDeleted;
    }
    
    public HashMap getNewAccountDetails(String accountNo, String customerName, String caseNo){
    	Connection connection = null;
    	CallableStatement callableStatement = null;
        ResultSet resultSet = null;
        HashMap hashMap = new HashMap();
        ISTRAccountDetailsVO accountDetailsVO = null;
        try
        {
        	connection = connectionUtil.getConnection();
            callableStatement = connection.prepareCall("{CALL STP_ISTRGETADDEDDETAILS(?,?,?,?,?,?,?)}");
            callableStatement.setString(1, caseNo);
            callableStatement.setString(2, "ACCOUNTS");
            callableStatement.setString(3, customerName);
            callableStatement.setString(4, "");
            callableStatement.setString(5, accountNo);
            callableStatement.setString(6, "");
            callableStatement.registerOutParameter(7, oracle.jdbc.OracleTypes.CURSOR);
            callableStatement.execute();
            resultSet = (ResultSet)callableStatement.getObject(7); 
            while(resultSet.next()){
                accountDetailsVO = new ISTRAccountDetailsVO();
        		accountDetailsVO.setNameOfBank(resultSet.getString("BANKNAME"));
                accountDetailsVO.setBSRcode(resultSet.getString("BANKBSRCODE"));
                accountDetailsVO.setBankName(resultSet.getString("BANKNAME"));
                accountDetailsVO.setBankBsrCode(resultSet.getString("BANKBSRCODE"));
                accountDetailsVO.setBankFIUId(resultSet.getString("BANKFIUID"));
                accountDetailsVO.setAnnexEnclosed(resultSet.getString("ANNEXENCLOSED"));
                accountDetailsVO.setBranchName(resultSet.getString("BRANCHNAME"));
                accountDetailsVO.setBranchReferenceNumberType(resultSet.getString("BRANCHREFERENCENUMBERTYPE"));
                accountDetailsVO.setBranchBsrCode(resultSet.getString("BRANCHBSRCODE"));
                accountDetailsVO.setBranchFIUId(resultSet.getString("BRANCHFIUID"));
                accountDetailsVO.setBranchAddressLine1(resultSet.getString("BRANCHADDRESSLINE1"));
                accountDetailsVO.setBranchAddressLine2(resultSet.getString("BRANCHADDRESSLINE2"));
                accountDetailsVO.setBranchAddressLine3(resultSet.getString("BRANCHADDRESSLINE3"));
                accountDetailsVO.setBranchCity(resultSet.getString("BRANCHCITY"));
                accountDetailsVO.setBranchState(resultSet.getString("BRANCHSTATE"));
                accountDetailsVO.setBranchCountry(resultSet.getString("BRANCHCOUNTRY"));
                accountDetailsVO.setBranchPinCode(resultSet.getString("BRANCHPINCODE"));
                accountDetailsVO.setBranchTelephoneNo(resultSet.getString("BRANCHTELEPHONENO"));
                accountDetailsVO.setBranchFaxNo(resultSet.getString("BRANCHFAXNO"));
                accountDetailsVO.setBranchMobileNo(resultSet.getString("BRANCHMOBILENO"));
                accountDetailsVO.setBranchEmailId(resultSet.getString("BRANCHEMAILID"));
                accountDetailsVO.setAccountNo(resultSet.getString("ACCOUNTNO"));
                accountDetailsVO.setAccountHolderName(resultSet.getString("ACCOUNTHOLDERNAME"));
                accountDetailsVO.setAccountType(resultSet.getString("ACCOUNTTYPE"));
                accountDetailsVO.setAccountHoldertype(resultSet.getString("ACCOUNTHOLDERTYPE"));
                accountDetailsVO.setAccountOpenDate(resultSet.getString("ACCOUNTOPENDATE"));
                accountDetailsVO.setAccountStatus(resultSet.getString("ACCOUNTSTATUS"));
                accountDetailsVO.setAccountTotalCredit(resultSet.getString("ACCOUNTTOTALCREDIT"));
                accountDetailsVO.setAccountTotalDebit(resultSet.getString("ACCOUNTTOTALDEBIT"));
                accountDetailsVO.setAccountTotalCashCredit(resultSet.getString("ACCOUNTTOTALCASHCREDIT"));
                accountDetailsVO.setAccountTotalCashDebit(resultSet.getString("ACCOUNTTOTALCASHDEBIT"));
                accountDetailsVO.setAccountRiskCategory(resultSet.getString("ACCOUNTRISKCATEGORY"));
                accountDetailsVO.setStrCustName(resultSet.getString("ACCOUNTHOLDERNAME"));
            }
            hashMap.put("ALAcctDetailsDTO", accountDetailsVO);
        }
        catch(Exception e)
        {
        	log.error("Exception in ISTDAOImpl->getNewAccountDetails " + e.toString());
            System.out.println("Exception in ISTDAOImpl->getNewAccountDetails " + e.toString());
            e.printStackTrace();
        }finally{
        	connectionUtil.closeResources(connection, callableStatement, resultSet, null);
        }
        return hashMap;
    }
    
    public boolean deleteAccountDetails(String customerName, String accountNo, String dataType, String userCode, String caseNo){
    	Connection connection = null;
    	CallableStatement callableStatement = null;
        boolean isDeleted = false;
        try
        {
        	connection = connectionUtil.getConnection();
            callableStatement = connection.prepareCall("{CALL STP_ISTRDELETEADDEDDETAILS(?,?,?,?,?,?,?)}");
            callableStatement.setString(1, caseNo);
            callableStatement.setString(2, "Accounts");
            callableStatement.setString(3, userCode);
            callableStatement.setString(4, customerName);
            callableStatement.setString(5, accountNo);
            //callableStatement.setString(6, " ");
            callableStatement.setString(6, dataType);
            callableStatement.setString(7, " ");
            callableStatement.executeUpdate();
            isDeleted = true;
        }
        catch(Exception e)
        {
        	log.error("Exception in ISTDAO->deleteAccountDetails " + e.toString());
            System.out.println("Exception in ISTDAO->deleteAccountDetails " + e.toString());
            e.printStackTrace();
        }finally{
        	connectionUtil.closeResources(connection, callableStatement, null, null);
        }
        return isDeleted;
    }
    
    public HashMap getNewTransactionDetails(String caseNo, String accountNo, String transactionNo){
    	Connection connection = null;
    	CallableStatement callableStatement = null;
        ResultSet resultSet = null;
        HashMap hashMap = new HashMap();
        ISTRAccountDetailsVO objISTRTransactionDtlsVO = null;
        try
        {
        	connection = connectionUtil.getConnection();
            callableStatement = connection.prepareCall("{CALL STP_ISTRGETADDEDDETAILS(?,?,?,?,?,?,?)}");
            callableStatement.setString(1, caseNo);
            callableStatement.setString(2, "TRANSACTIONS");
            callableStatement.setString(3, "");
            callableStatement.setString(4, "");
            callableStatement.setString(5, accountNo);
            callableStatement.setString(6, transactionNo);
            callableStatement.registerOutParameter(7, oracle.jdbc.OracleTypes.CURSOR);
            callableStatement.execute();
            resultSet = (ResultSet)callableStatement.getObject(7); 
            while(resultSet.next()){
                objISTRTransactionDtlsVO = new ISTRAccountDetailsVO();
                objISTRTransactionDtlsVO.setNameOfBank(resultSet.getString("NAMEOFBANK"));
                objISTRTransactionDtlsVO.setBSRcode(resultSet.getString("BSRCODE"));
                objISTRTransactionDtlsVO.setAccountNo(resultSet.getString("ACCOUNTNO"));
                objISTRTransactionDtlsVO.setTransactionNo(resultSet.getString("TRANSACTIONNO"));
                objISTRTransactionDtlsVO.setTransactiondetailsdate(resultSet.getString("TRANSACTIONTIMESTAMP"));
                objISTRTransactionDtlsVO.setTransactiondetailsmode(resultSet.getString("INSTRUMENTCODE"));
                objISTRTransactionDtlsVO.setTransactiondetailsDebit(resultSet.getString("DIPOSITORWITHDRAWAL"));
                objISTRTransactionDtlsVO.setTransactiondetailsAmount(resultSet.getString("AMOUNT"));
                objISTRTransactionDtlsVO.setTransactiondetailsRemarks(resultSet.getString("NARRATION"));
            }
            hashMap.put("ALTranDetailsDTO", objISTRTransactionDtlsVO);
        }
        catch(Exception ex)
        {
        	log.error("Exception in getNewTranDetails " + ex.toString());
            System.out.println("Exception in getNewTranDetails " + ex.toString());
            ex.printStackTrace();
        }finally{
        	connectionUtil.closeResources(connection, callableStatement, resultSet, null);
        }
        return hashMap;
    }
    
    public boolean deleteTransactionDetails(String caseNo, String transactionNo, String accountNo, String userCode){
    	Connection connection = null;
    	CallableStatement callableStatement = null;
        boolean isDeleted = false;
        try
        {
        	connection = connectionUtil.getConnection();
            callableStatement = connection.prepareCall("{CALL STP_ISTRDELETEADDEDDETAILS(?,?,?,?,?,?,?)}");
            callableStatement.setString(1, caseNo);
            callableStatement.setString(2, "Transactions");
            callableStatement.setString(3, userCode);
            callableStatement.setString(4, transactionNo);
            callableStatement.setString(5, accountNo);
            callableStatement.setString(6, " ");
            callableStatement.setString(7, " ");
            callableStatement.executeUpdate();
            isDeleted = true;
        }
        catch(Exception e)
        {
        	log.error("Exception in ISTRDAOImpl->deleteTransactionDetails " + e.toString());
            System.out.println("Exception in ISTRDAOImpl->deleteTransactionDetails " + e.toString());
            e.printStackTrace();
        }finally{
        	connectionUtil.closeResources(connection, callableStatement, null, null);
        }
        return isDeleted;
    }
    
    public boolean saveISTRManualDetails(String caseNo, String userCode, ISTRManualDetailsVO manualDetailsVO)
    {
    	Connection connection = null;
    	CallableStatement callableStatement = null;
        boolean isSaved = false;
        System.out.println("DAO = "+caseNo+" "+stringConversion(manualDetailsVO.getSusGroundsP7())+" "+manualDetailsVO.getMainPersonName());
        try
        {
        	connection = connectionUtil.getConnection();
            callableStatement = connection.prepareCall("{CALL STP_ISTRSAVEMANUALDETAILS(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");
            callableStatement.setString(1, caseNo);
            callableStatement.setString(2, manualDetailsVO.getSuspReason());
            callableStatement.setString(3, stringConversion(manualDetailsVO.getSusGroundsP7()));
            callableStatement.setString(4, stringConversion(manualDetailsVO.getSusGroundsP8()));
            callableStatement.setString(5, manualDetailsVO.getReportFlag());
            callableStatement.setString(6, manualDetailsVO.getRepBranchName());
            callableStatement.setString(7, manualDetailsVO.getRepBSRCode());
            callableStatement.setString(8, manualDetailsVO.getRepIDFIUIND());
            callableStatement.setString(9, manualDetailsVO.getRepBuildingNo());
            callableStatement.setString(10, manualDetailsVO.getRepStreet());
            callableStatement.setString(11, manualDetailsVO.getRepLocality());
            callableStatement.setString(12, manualDetailsVO.getRepCity());
            callableStatement.setString(13, manualDetailsVO.getRepState());
            callableStatement.setString(14, manualDetailsVO.getRepPinCode());
            callableStatement.setString(15, manualDetailsVO.getRepTelNo());
            callableStatement.setString(16, manualDetailsVO.getRepFaxNo());
            callableStatement.setString(17, manualDetailsVO.getRepEmail());
            callableStatement.setString(18, manualDetailsVO.getMainPersonName());
            callableStatement.setString(19, manualDetailsVO.getSourceOfAlert());
            callableStatement.setString(20, stringConversion(manualDetailsVO.getAlertIndicators()));
            callableStatement.setString(21, manualDetailsVO.getSuspicionDueTo());   
            callableStatement.setString(22, manualDetailsVO.getAttemptedTransactions());
            callableStatement.setString(23, manualDetailsVO.getPriorityRating());
            callableStatement.setString(24, manualDetailsVO.getReportCoverage());
            callableStatement.setString(25, manualDetailsVO.getAdditionalDocuments());
            callableStatement.setString(26, manualDetailsVO.getLawEnforcementInformed());
            callableStatement.setString(27, stringConversion(manualDetailsVO.getLawEnforcementAgencyDetails()));
            callableStatement.setString(28, manualDetailsVO.getSignatureName());
            
            callableStatement.setString(29, manualDetailsVO.getReportingEntityName());
            callableStatement.setString(30, manualDetailsVO.getReportingEntityCategory());
            callableStatement.setString(31, manualDetailsVO.getReportingEntityCode());
            callableStatement.setString(32, manualDetailsVO.getReportingEntityFIUREID());
            callableStatement.setString(33, manualDetailsVO.getReportingBatchNo());
            callableStatement.setString(34, manualDetailsVO.getReportingBatchDate());
            callableStatement.setString(35, manualDetailsVO.getReportingBatchPertainingToMonth());
            callableStatement.setString(36, manualDetailsVO.getReportingBatchPertainingToYear());
            callableStatement.setString(37, manualDetailsVO.getReportingBatchType());
            callableStatement.setString(38, manualDetailsVO.getReportingOriginalBatchId());
            callableStatement.setString(39, manualDetailsVO.getPrincipalOfficersName());
            callableStatement.setString(40, manualDetailsVO.getPrincipalOfficersDesignation());
            callableStatement.setString(41, manualDetailsVO.getPrincipalOfficersAddress1());
            callableStatement.setString(42, manualDetailsVO.getPrincipalOfficersAddress2());
            callableStatement.setString(43, manualDetailsVO.getPrincipalOfficersAddress3());
            callableStatement.setString(44, manualDetailsVO.getPrincipalOfficersCity());
            callableStatement.setString(45, manualDetailsVO.getPrincipalOfficersState());
            callableStatement.setString(46, manualDetailsVO.getPrincipalOfficersCountry());
            callableStatement.setString(47, manualDetailsVO.getPrincipalOfficersAddressPinCode());
            callableStatement.setString(48, manualDetailsVO.getPrincipalOfficersTelephoneNo());
            callableStatement.setString(49, manualDetailsVO.getPrincipalOfficersMobileNo());
            callableStatement.setString(50, manualDetailsVO.getPrincipalOfficersFaxNo());
            callableStatement.setString(51, manualDetailsVO.getPrincipalOfficersEmailId());
            callableStatement.setString(52, manualDetailsVO.getReasonOfRevision());
            
            //int l_intSaved = callableStatement.executeUpdate();
            callableStatement.executeUpdate();
            //if(l_intSaved == 1)
            isSaved = true;
        }
        catch(Exception e)
        {
        	log.error("Error in ISTRDAOImpl-> saveISTRManualDetails " + e.toString());
            System.out.println("Error in ISTRDAOImpl-> saveISTRManualDetails " + e.toString());
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
    
    public boolean addAccountDetailsToList(String caseNo, String userCode, String terminalId, String accountNo, ISTRAccountDetailsVO accountDetailsVO)
    {
    	Connection connection = null;
        CallableStatement callableStatement = null;
        boolean isSaved = false;
        try
        {
        	connection = connectionUtil.getConnection();
            callableStatement = connection.prepareCall("{CALL STP_ISTRADDUPDATENEWACCOUNTS(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");
            callableStatement.setString(1, caseNo);
            callableStatement.setString(2, userCode);
            callableStatement.setString(3, terminalId);
            callableStatement.setString(4, accountDetailsVO.getBankName());
            callableStatement.setString(5, accountDetailsVO.getBranchName());
            callableStatement.setString(6, accountDetailsVO.getBranchReferenceNumberType());
            callableStatement.setString(7, accountDetailsVO.getBranchBsrCode());
            callableStatement.setString(8, accountDetailsVO.getBranchAddressLine1());
            callableStatement.setString(9, accountDetailsVO.getBranchAddressLine2());
            callableStatement.setString(10, accountDetailsVO.getBranchAddressLine3());
            callableStatement.setString(11, accountDetailsVO.getBranchCity());
            callableStatement.setString(12, accountDetailsVO.getBranchState());
            callableStatement.setString(13, accountDetailsVO.getBranchCountry());
            callableStatement.setString(14, accountDetailsVO.getBranchPinCode());
            callableStatement.setString(15, accountDetailsVO.getBranchTelephoneNo());
            callableStatement.setString(16, accountDetailsVO.getBranchMobileNo());
            callableStatement.setString(17, accountDetailsVO.getBranchFaxNo());
            callableStatement.setString(18, accountDetailsVO.getBranchEmailId());
            callableStatement.setString(19, accountDetailsVO.getAccountNo());
            callableStatement.setString(20, accountDetailsVO.getAccountHolderName());
            callableStatement.setString(21, accountDetailsVO.getAccountType());
            callableStatement.setString(22, accountDetailsVO.getAccountHoldertype());
            callableStatement.setString(23, accountDetailsVO.getAccountOpenDate());
            callableStatement.setString(24, accountDetailsVO.getAccountStatus());
            callableStatement.setString(25, accountDetailsVO.getAccountTotalCredit());
            callableStatement.setString(26, accountDetailsVO.getAccountTotalDebit());
            callableStatement.setString(27, accountDetailsVO.getAccountTotalCashCredit());
            callableStatement.setString(28, accountDetailsVO.getAccountTotalCashDebit());
            callableStatement.setString(29, accountDetailsVO.getAccountRiskCategory());
            
            callableStatement.executeUpdate();
            isSaved = true;
        }
        catch(Exception e)
        {
        	log.error("Exception in ISTRDAOImpl -> addAccountDetailsToList, Error Is:"+ e.toString());
            System.out.println("Exception in ISTRDAOImpl -> addAccountDetailsToList, Error Is:"+ e.toString());
            e.toString();
        }finally{
        	connectionUtil.closeResources(connection, callableStatement, null, null);
        }
        return isSaved;
    }

    public boolean addIndividualDetailsToList(String caseNo, String userCode, String terminalId, String accountNo, String relationFlag, String counterAccountNo, String counterId, String counterName, String bsrCode, ISTRIndividualDetailsVO individualDetailsVO)
    {
    	Connection connection = null;
    	CallableStatement callableStatement = null;
        boolean isSaved = false;
        try
        {
        	connection = connectionUtil.getConnection();
            callableStatement = connection.prepareCall("{CALL STP_ISTRADDUPDATENEWINDIVIDUAL(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");
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
        	log.error("Exception in ISTRDAOImpl -> addIndividualDetailsToList, Error Is:"+ e.toString());
            System.out.println("Exception in ISTRDAOImpl -> addIndividualDetailsToList, Error Is:"+ e.toString());
            e.toString();
        }finally{
        	connectionUtil.closeResources(connection, callableStatement, null, null);
        }
        return isSaved;
    }
    
    public boolean addEntityDetailsToList(String strCaseNo, String strUserCode, String strTerminalId, String strAccountNo, 
    		String relationFlag, String legalAccountNo, String legalCustomerId, String legalCustomerName, String legalBSRCode, ISTREntityDetailsVO legalDetailsDTO)
    {
    	Connection connection = null;
        CallableStatement callableStatement = null;
        boolean isSaved = false;
        try
        {
        	connection = connectionUtil.getConnection();
	        callableStatement = connection.prepareCall("{CALL STP_ISTRADDUPDATENEWLEGAL(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");
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
        	log.error("Exception in ISTRDAOImpl -> addEntityDetailsToList, Error Is:"+ e.toString());
            System.out.println("Exception in ISTRDAOImpl -> addEntityDetailsToList, Error Is:"+ e.toString());
            e.printStackTrace();
        }finally{
        	connectionUtil.closeResources(connection, callableStatement, null, null);
        }
        return isSaved;
    }

    public boolean addTransactionsToList(String caseNo, String userCode, String terminalId, String transactionNo, ISTRAccountDetailsVO accountDetailsVO)
    {
    	Connection connection = null;
    	CallableStatement callableStatement = null;
        boolean isSaved = false;
        try
        {
        	connection = connectionUtil.getConnection();
	        callableStatement = connection.prepareCall("{CALL STP_ISTRADDUPDATENEWTRANLIST(?,?,?,?,?,?,?,?,?,?,?,?,?)}");
	        callableStatement.setString(1, caseNo);
	        callableStatement.setString(2, transactionNo);
	        callableStatement.setString(3, userCode);
	        callableStatement.setString(4, terminalId);
	        callableStatement.setString(5, accountDetailsVO.getAccountNo());
	        callableStatement.setString(6, accountDetailsVO.getTransactionNo());
	        callableStatement.setString(7, accountDetailsVO.getNameOfBank());
	        callableStatement.setString(8, accountDetailsVO.getBSRcode());
	        callableStatement.setString(9, accountDetailsVO.getTransactiondetailsdate());
	        callableStatement.setString(10, accountDetailsVO.getTransactiondetailsmode());
	        callableStatement.setString(11, accountDetailsVO.getTransactiondetailsDebit());
	        callableStatement.setString(12, accountDetailsVO.getTransactiondetailsAmount());
	        callableStatement.setString(13, accountDetailsVO.getTransactiondetailsRemarks());
	        callableStatement.executeUpdate();
	        isSaved = true;
        }
        catch(Exception e)
        {
        	log.error("Exception in ISTRDAOImpl -> addTransactionsToList, Error Is:"+ e.toString());
            System.out.println("Exception in ISTRDAOImpl -> addTransactionsToList, Error Is:"+ e.toString());
            e.toString();
        }finally{
        	connectionUtil.closeResources(connection, callableStatement, null, null);
        }
        return isSaved;
    }
    
    public HashMap getINDSTRReport(String caseNo, String userCode, String userRole){
    	setINDSTRReportData(caseNo);

		ISTRManualDetailsVO manualDetailsVO = getINDSTRManualDetails(caseNo);

		ArrayList allIndividualDetails = getINDSTRAnnexureIndividualDetails(caseNo);

		ArrayList alllegalPersonDetails = getINDSTRAnnexureLegalEntityDetails(caseNo);

		ArrayList allAccountDetails = getINDSTRAnnexureAccountDetails(caseNo);
		ArrayList alertIndicatorsList = getISTRAlertIndicatorsList(caseNo);
		HashMap<String, String> caseStatusDetails = getISTRCaseStatusDetails(caseNo, userCode, userRole);
		
		HashMap indSTRReport = new HashMap();
		indSTRReport.put("ManualFormDTO", manualDetailsVO);
		indSTRReport.put("ALIndvDetailsDTO", allIndividualDetails);
		indSTRReport.put("ALLegPerDetailsDTO", alllegalPersonDetails);
		indSTRReport.put("AcctDetailsDTO", allAccountDetails);
		indSTRReport.put("AlertIndicatorsList", alertIndicatorsList);
		indSTRReport.put("CaseStatusDetails", caseStatusDetails);
		
		return indSTRReport;
    }
    
    private void setINDSTRReportData(String caseNo){
    	Connection connection = null;
    	Connection connection1 = null;
    	Connection connection2 = null;
    	Connection connection3 = null;
    	CallableStatement callableStatement = null;

		try{
			connection = connectionUtil.getConnection();
			callableStatement = connection.prepareCall("{CALL STP_ISTRMANUALFORMRMDETAILS(?)}");
			callableStatement.setString(1, caseNo);
			callableStatement.execute();			
		}catch(Exception e){
			log.error("Exception in INDSTRDAOImpl -> setINDSTRReportData -> STP_ISTRMANUALFORMRMDETAILS, Error Is:"+ e.toString());
			System.out.println("Exception in INDSTRDAOImpl -> setINDSTRReportData -> STP_ISTRMANUALFORMRMDETAILS, Error Is:"+ e.toString());
            e.toString();
		}finally{
			connectionUtil.closeResources(connection, callableStatement, null, null);
		}
		
		try{
			connection1 = connectionUtil.getConnection();
			callableStatement = connection1.prepareCall("{CALL STP_ISTRINDIVIDUALDETAILS(?)}");
			callableStatement.setString(1, caseNo);
			callableStatement.execute();
		}catch(Exception e){
			log.error("Exception in INDSTRDAOImpl -> setINDSTRReportData -> STP_ISTRINDIVIDUALDETAILS, Error Is:"+ e.toString());
			System.out.println("Exception in INDSTRDAOImpl -> setINDSTRReportData -> STP_ISTRINDIVIDUALDETAILS, Error Is:"+ e.toString());
            e.toString();
		}finally{
			connectionUtil.closeResources(connection1, callableStatement, null, null);
		}
		
		try{
			connection2 = connectionUtil.getConnection();
			callableStatement = connection2.prepareCall("{CALL STP_ISTRLEGALPERSONDETAILS(?)}");
			callableStatement.setString(1, caseNo);
			callableStatement.execute();
		}catch(Exception e){
			log.error("Exception in INDSTRDAOImpl -> setINDSTRReportData -> STP_ISTRLEGALPERSONDETAILS, Error Is:"+ e.toString());
			System.out.println("Exception in INDSTRDAOImpl -> setINDSTRReportData -> STP_ISTRLEGALPERSONDETAILS, Error Is:"+ e.toString());
            e.toString();
		}finally{
			connectionUtil.closeResources(connection2, callableStatement, null, null);
		}
		
		try{
			connection3 = getConnection();
			callableStatement = connection3.prepareCall("{CALL STP_ISTRACCANDTRANSDETAILS(?)}");
			callableStatement.setString(1, caseNo);
			callableStatement.execute();
		}catch(Exception e){
			log.error("Exception in INDSTRDAOImpl -> setINDSTRReportData -> STP_ISTRACCANDTRANSDETAILS, Error Is:"+ e.toString());
			System.out.println("Exception in INDSTRDAOImpl -> setINDSTRReportData -> STP_ISTRACCANDTRANSDETAILS, Error Is:"+ e.toString());
            e.toString();
		}finally{
			connectionUtil.closeResources(connection3, callableStatement, null, null);
		}
    }

	private ISTRManualDetailsVO getINDSTRManualDetails(String caseNo) {
		ISTRManualDetailsVO manualDetailsVO = new ISTRManualDetailsVO();
		Connection connection = null;
		Connection connection1 = null;
		Connection connection2 = null;
		Connection connection3 = null;
		CallableStatement callableStatement = null;
		ResultSet resultSet = null;
		
		StringBuilder counterPartyName = new StringBuilder();
        StringBuilder counterPartyId = new StringBuilder();
        StringBuilder counterPartyAccountNo = new StringBuilder();
        StringBuilder counterPartyType = new StringBuilder();
        StringBuilder individualDataType = new StringBuilder();
        int countOfIndividuals = 0;
        
        StringBuilder legalCustomerName = new StringBuilder();
        StringBuilder legalCustomerId = new StringBuilder();
        StringBuilder legalAccountNo = new StringBuilder();
        StringBuilder legalDataType = new StringBuilder();
        int countOfLegals = 0;
        
        StringBuilder accountNos = new StringBuilder();
        StringBuilder accountNames = new StringBuilder();
        StringBuilder accountDataTypes = new StringBuilder();
        int countOfAccounts = 0;
                
        String countePartyIdsArray[] = (String[])null;
        String countePartyNamesArray[] = (String[])null;
        String counteAccountNosArray[] = (String[])null;
        String countePartyTypesArray[] = (String[])null;
        String individualsDataTypesArray[] = (String[])null;
        
        String legalCustomerIdsArray[] = (String[])null;
        String legalCustomerNamesArray[] = (String[])null;
        String legalAccountNosArray[] = (String[])null;
        String legalDataTypesArray[] = (String[])null;
        
        String accountNamesArray[] = (String[])null;
        String accountNosArray[] = (String[])null;
        String accountDataTypesArray[] = (String[])null;
		
		try{
			connection = connectionUtil.getConnection();
			callableStatement = connection.prepareCall("{CALL STP_GETISTRMANUALDETAILS(?,?,?,?)}");
			callableStatement.setString(1, caseNo);
			callableStatement.setString(2, "");
			callableStatement.setString(3, "");
			callableStatement.registerOutParameter(4, oracle.jdbc.OracleTypes.CURSOR);
			callableStatement.execute();
			resultSet = (ResultSet)callableStatement.getObject(4);
			while(resultSet.next()){
                manualDetailsVO.setReportSendingDate(resultSet.getString("reportSendingDate"));
                manualDetailsVO.setReportFlag(resultSet.getString("reportFlag"));
                manualDetailsVO.setReportSendingDateReplac(resultSet.getString("reportSendingDateReplac"));
                manualDetailsVO.setPrincNameOfBank(resultSet.getString("princNameOfBank"));
                manualDetailsVO.setPrincBSRCode(resultSet.getString("princBSRCode"));
                manualDetailsVO.setPrincIDFIUIND(resultSet.getString("princIDFIUIND"));
                manualDetailsVO.setPrincBankCategory(resultSet.getString("princBankCategory"));
                manualDetailsVO.setPrincOfficerName(resultSet.getString("princOfficerName"));
                manualDetailsVO.setPrincDesignation(resultSet.getString("princDesignation"));
                manualDetailsVO.setPrincBuildingNo(resultSet.getString("princBuildingNo"));
                manualDetailsVO.setPrincStreet(resultSet.getString("princStreet"));
                manualDetailsVO.setPrincLocality(resultSet.getString("princLocality"));
                manualDetailsVO.setPrincCity(resultSet.getString("princCity"));
                manualDetailsVO.setPrincState(resultSet.getString("princState"));
                manualDetailsVO.setPrincPinCode(resultSet.getString("princPinCode"));
                manualDetailsVO.setPrincTelNo(resultSet.getString("princTelNo"));
                manualDetailsVO.setPrincMobileNo(resultSet.getString("princMobileNo"));
                manualDetailsVO.setPrincFax(resultSet.getString("princFax"));
                manualDetailsVO.setPrincEmail(resultSet.getString("princEmail"));
                manualDetailsVO.setRepBranchName(resultSet.getString("repBranchName"));
                manualDetailsVO.setRepBSRCode(resultSet.getString("repBSRCode"));
                manualDetailsVO.setRepIDFIUIND(resultSet.getString("repIDFIUIND"));
                manualDetailsVO.setRepBuildingNo(resultSet.getString("repBuildingNo"));
                manualDetailsVO.setRepStreet(resultSet.getString("repStreet"));
                manualDetailsVO.setRepLocality(resultSet.getString("repLocality"));
                manualDetailsVO.setRepCity(resultSet.getString("repCity"));
                manualDetailsVO.setRepState(resultSet.getString("repState"));
                manualDetailsVO.setRepPinCode(resultSet.getString("repPinCode"));
                manualDetailsVO.setRepTelNo(resultSet.getString("repTelNo"));
                manualDetailsVO.setRepFaxNo(resultSet.getString("repFaxNo"));
                manualDetailsVO.setRepEmail(resultSet.getString("repEmail"));
                manualDetailsVO.setSuspReason(resultSet.getString("SusReason"));
                manualDetailsVO.setSusGroundsP7(stringArrayConversion(resultSet.getString("part7SusGrounds")));
                manualDetailsVO.setSusGroundsP8(stringArrayConversion(resultSet.getString("part8SusGrounds")));
                manualDetailsVO.setSuspOtherReason(resultSet.getString("OtherReason"));
			    manualDetailsVO.setMainPersonName(resultSet.getString("MainPersonName"));
			    manualDetailsVO.setSourceOfAlert(resultSet.getString("SourceOfAlert"));
                manualDetailsVO.setAlertIndicators(stringArrayConversion(resultSet.getString("AlertIndicators")));
			    manualDetailsVO.setSuspicionDueTo(resultSet.getString("SuspicionDueTo"));
			    manualDetailsVO.setAttemptedTransactions(resultSet.getString("AttemptedTransactions"));
			    manualDetailsVO.setPriorityRating(resultSet.getString("PriorityRating"));
			    manualDetailsVO.setReportCoverage(resultSet.getString("ReportCoverage"));
			    manualDetailsVO.setAdditionalDocuments(resultSet.getString("AdditionalDocuments"));
			    manualDetailsVO.setLawEnforcementInformed(resultSet.getString("LawEnforcementInformed"));
                manualDetailsVO.setLawEnforcementAgencyDetails(stringArrayConversion(resultSet.getString("LawEnforcementAgencyDetails")));
			    manualDetailsVO.setSignatureName(resultSet.getString("SignatureName"));
			    manualDetailsVO.setReasonOfRevision(resultSet.getString("REASONFORREPLACEMENT"));
			    manualDetailsVO.setReportingBatchNo(resultSet.getString("REPORTINGBATCHNO"));
			    manualDetailsVO.setReportingBatchDate(resultSet.getString("REPORTINGBATCHDATE"));
			    manualDetailsVO.setReportingBatchType(resultSet.getString("REPORTINGBATCHTYPE"));
			    manualDetailsVO.setReportingOriginalBatchId(resultSet.getString("REPORTINGORIGINALBATCHID"));
			    
			}
		}catch(Exception e){
			log.error("Exception in INDSTRDAOImpl -> getINDSTRManualDetails -> STP_GETISTRMANUALDETAILS, Error Is:"+ e.toString());
			System.out.println("Exception in INDSTRDAOImpl -> getINDSTRManualDetails -> STP_GETISTRMANUALDETAILS, Error Is:"+ e.toString());
            e.toString();
		}finally{
			connectionUtil.closeResources(connection, callableStatement, resultSet, null);
		}
		
		try{
			connection1 = connectionUtil.getConnection();
			callableStatement = connection1.prepareCall("{CALL STP_GETISTRLISTOFINDIVIDUALS(?,?,?,?)}");
			callableStatement.setString(1, caseNo);
			callableStatement.setString(2, "");
			callableStatement.setString(3, "");
			callableStatement.registerOutParameter(4, oracle.jdbc.OracleTypes.CURSOR);
			callableStatement.execute();
			resultSet = (ResultSet)callableStatement.getObject(4);
			while(resultSet.next()){
                counterPartyName.append(resultSet.getString("CounterPartyName")).append("~");
                counterPartyId.append(resultSet.getString("CounterPartyID")).append("~");
                counterPartyAccountNo.append(resultSet.getString("CounterAccountNo")).append("~");
                counterPartyType.append(resultSet.getString("JOINTHOLDERTYPE")).append("~");
				individualDataType.append(resultSet.getString("DATATYPE")).append("~");
                countOfIndividuals++;
            }
            if(countOfIndividuals > 0){
                countePartyIdsArray = counterPartyId.toString().split("~");
                countePartyNamesArray = counterPartyName.toString().split("~");
                counteAccountNosArray = counterPartyAccountNo.toString().split("~");
                countePartyTypesArray = counterPartyType.toString().split("~");
                individualsDataTypesArray = individualDataType.toString().split("~");
            } else {
                countePartyIdsArray = new String[20];
                countePartyNamesArray = new String[20];
                counteAccountNosArray = new String[20];
                countePartyTypesArray = new String[20];
                individualsDataTypesArray = new String[20];
            }
		}catch(Exception e){
			log.error("Exception in INDSTRDAOImpl -> getINDSTRManualDetails -> STP_GETISTRLISTOFINDIVIDUALS, Error Is:"+ e.toString());
			System.out.println("Exception in INDSTRDAOImpl -> getINDSTRManualDetails -> STP_GETISTRLISTOFINDIVIDUALS, Error Is:"+ e.toString());
            e.toString();
		}finally{
			connectionUtil.closeResources(connection1, callableStatement, resultSet, null);
		}
		
		try{
			connection2 = connectionUtil.getConnection();
			callableStatement = connection2.prepareCall("{CALL STP_GETISTRLISTOFLEGALS(?,?,?,?)}");
			callableStatement.setString(1, caseNo);
			callableStatement.setString(2, "");
			callableStatement.setString(3, "");
			callableStatement.registerOutParameter(4, oracle.jdbc.OracleTypes.CURSOR);
			callableStatement.execute();
			resultSet = (ResultSet)callableStatement.getObject(4); 
            while(resultSet.next()){
                legalCustomerId.append(resultSet.getString("RelativeCustomerId")).append("~");
                legalCustomerName.append(resultSet.getString("RelativeCustomerName")).append("~");
                legalAccountNo.append(resultSet.getString("ACCOUNTNO")).append("~");
                legalDataType.append(resultSet.getString("IND_LEGAL")).append("~");
                countOfLegals++;
            }
            if(countOfLegals > 0){
                legalCustomerIdsArray = legalCustomerId.toString().split("~");
                legalCustomerNamesArray = legalCustomerName.toString().split("~");
                legalAccountNosArray = legalAccountNo.toString().split("~");
                legalDataTypesArray = legalDataType.toString().split("~");
            } else {
                legalCustomerIdsArray = new String[20];
                legalCustomerNamesArray = new String[20];
                legalAccountNosArray = new String[20];
                legalDataTypesArray = new String[20];
            }
		}catch(Exception e){
			log.error("Exception in INDSTRDAOImpl -> getINDSTRManualDetails -> STP_GETISTRLISTOFLEGALS, Error Is:"+ e.toString());
			System.out.println("Exception in INDSTRDAOImpl -> getINDSTRManualDetails -> STP_GETISTRLISTOFLEGALS, Error Is:"+ e.toString());
            e.toString();
		}finally{
			connectionUtil.closeResources(connection2, callableStatement, resultSet, null);
		}
		
		resultSet = null;
		try{
			connection3 = getConnection();
			callableStatement = connection3.prepareCall("{CALL STP_GETISTRLISTOFACCOUNTS(?,?,?,?)}");
			callableStatement.setString(1, caseNo);
			callableStatement.setString(2, "");
			callableStatement.setString(3, "");
			callableStatement.registerOutParameter(4, oracle.jdbc.OracleTypes.CURSOR);
			callableStatement.execute();
			resultSet = (ResultSet)callableStatement.getObject(4);
			while(resultSet.next()){
				accountNos.append(resultSet.getString("ACCOUNTNO")).append("~");
                accountNames.append(resultSet.getString("ACCOUNTNAME")).append("~");
                accountDataTypes.append(resultSet.getString("DATATYPE")).append("~");
                countOfAccounts++;
            }
            if(countOfAccounts > 0){
                accountNosArray = accountNos.toString().split("~");
                accountNamesArray = accountNames.toString().split("~");
                accountDataTypesArray = accountDataTypes.toString().split("~");
            } else {
                accountNosArray = new String[20];
                accountNamesArray = new String[20];
                accountDataTypesArray = new String[20];
            }	
		}catch(Exception e){
			log.error("Exception in INDSTRDAOImpl -> getINDSTRManualDetails -> STP_GETISTRLISTOFACCOUNTS, Error Is:"+ e.toString());
			System.out.println("Exception in INDSTRDAOImpl -> getINDSTRManualDetails -> STP_GETISTRLISTOFACCOUNTS, Error Is:"+ e.toString());
            e.toString();
            e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection3, callableStatement, resultSet, null);
		}
		
		manualDetailsVO.setNoOfIndividualRec(countOfIndividuals);
        manualDetailsVO.setNoOfLegalRec(countOfLegals);
        manualDetailsVO.setNoOfAcctRec(countOfAccounts);
        manualDetailsVO.setAcctNameLinkedToTrans(accountNamesArray);
        manualDetailsVO.setAcctNoLinkedToTrans(accountNosArray);
        manualDetailsVO.setDataTypeForAccount(accountDataTypesArray);
        manualDetailsVO.setCounterName(countePartyNamesArray);
        manualDetailsVO.setCounterId(countePartyIdsArray);
        manualDetailsVO.setCounterAcc(counteAccountNosArray);
        manualDetailsVO.setCounterType(countePartyTypesArray);
        manualDetailsVO.setDataTypeForIndiv(individualsDataTypesArray);
        manualDetailsVO.setLegalId(legalCustomerIdsArray);
        manualDetailsVO.setLegalName(legalCustomerNamesArray);
        manualDetailsVO.setLegalAccountNo(legalAccountNosArray);
        
        manualDetailsVO.setDataTypeForLegal(legalDataTypesArray);	
        
		return manualDetailsVO;
	}
	
	private ArrayList getINDSTRAnnexureIndividualDetails(String caseNo){
		Connection connection = null;
		CallableStatement callableStatement = null;
		ResultSet resultSet = null;
		ArrayList allIndividualDetails = new ArrayList();
		try{
			connection = connectionUtil.getConnection();
			callableStatement = connection.prepareCall("{CALL STP_GETISTRANNEXADETAILS(?,?,?,?)}");
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
			log.error("Exception in INDSTRDAOImpl -> getINDSTRAnnexureIndividualDetails, Error Is:"+ e.toString());
			System.out.println("Exception in INDSTRDAOImpl -> getINDSTRAnnexureIndividualDetails, Error Is:"+ e.toString());
            e.toString();
		}finally{
			connectionUtil.closeResources(connection, callableStatement, resultSet, null);
		}
		return allIndividualDetails;
	}
	
	private ArrayList getINDSTRAnnexureLegalEntityDetails(String caseNo){
		Connection connection = null;
		CallableStatement callableStatement = null;
		ResultSet resultSet = null;
		CallableStatement callableStatement1 = null;
		ResultSet resultSet1 = null;
		ArrayList alllegalPersonDetails = new ArrayList();
        ISTREntityDetailsVO legalPersonDetailsVO = null;
        
		try{
			connection = connectionUtil.getConnection();
			callableStatement = connection.prepareCall("{CALL STP_GETISTRANNEXBDETAILS(?,?,?,?)}");
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
                legalPersonDetailsVO = new ISTREntityDetailsVO();
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
				callableStatement1 = connection.prepareCall("{CALL STP_GETISTRANNEXBDIRECTORS(?,?,?,?)}");
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
			log.error("Exception in INDSTRDAOImpl -> getINDSTRAnnexureLegalEntityDetails, Error Is:"+ e.toString());
			System.out.println("Exception in INDSTRDAOImpl -> getINDSTRAnnexureLegalEntityDetails, Error Is:"+ e.toString());
            e.toString();
		}finally{
			connectionUtil.closeResources(null, callableStatement, resultSet, null);
			connectionUtil.closeResources(connection, callableStatement, resultSet1, null);
		}
		return alllegalPersonDetails;
	}
	
	private ArrayList getINDSTRAnnexureAccountDetails(String caseNo){
		Connection connection = null;
		Connection connection1 = null;
		CallableStatement callableStatement = null;
		ResultSet resultSet = null;
		CallableStatement callableStatement1 = null;
		ResultSet resultSet1 = null;
		ArrayList allAccountDetails = new ArrayList();
		ISTRAccountDetailsVO accountDetailsVO = null;
		int count = 0;
        StringBuilder transactionNos = new StringBuilder();
        StringBuilder transactionDates = new StringBuilder();
        StringBuilder transactionModes = new StringBuilder();
        StringBuilder transactionDebitCredits = new StringBuilder();
        StringBuilder transactionAmounts = new StringBuilder();
        StringBuilder transactionRemarks = new StringBuilder();
        StringBuilder transactionDataTypes = new StringBuilder();
        int countofTransactions = 0;
        
		try{
			connection1 = connectionUtil.getConnection();
			callableStatement = connection1.prepareCall("{CALL STP_GETISTRANNEXCACCOUNTS(?,?,?,?)}");
            callableStatement.setString(1, caseNo);
            callableStatement.setString(2, "");
            callableStatement.setString(3, "");
            callableStatement.registerOutParameter(4, oracle.jdbc.OracleTypes.CURSOR);
            callableStatement.execute();
            resultSet = (ResultSet)callableStatement.getObject(4); 
            while(resultSet.next()){
				String resultedAccountNo = resultSet.getString("ACCOUNTNO");
				countofTransactions = 0;
                transactionNos.delete(0, transactionNos.length());
                transactionDates.delete(0, transactionDates.length());
                transactionModes.delete(0, transactionModes.length());
                transactionDebitCredits.delete(0, transactionDebitCredits.length());
                transactionAmounts.delete(0, transactionAmounts.length());
                transactionRemarks.delete(0, transactionRemarks.length());
                transactionDataTypes.delete(0, transactionDataTypes.length());
                String listofAccountHoldersID[] = new String[25];
                String listofAccountHoldersName[] = new String[25];
                String listofAccountHoldersAnnexAB[] = new String[25];
                String listofRelatedPersonsName[] = new String[25];
                String listofRelatedPersonsID[] = new String[25];
                String listofRelatedPersonsRelation[] = new String[25];
                accountDetailsVO = new ISTRAccountDetailsVO();
                /*accountDetailsVO.setNameOfBank(resultSet.getString("nameOfBank"));
                accountDetailsVO.setBSRcode(resultSet.getString("bSRcode"));
                accountDetailsVO.setAnnexEnclosed(resultSet.getString("annexEnclosed"));
                accountDetailsVO.setAccountNo(resultSet.getString("accountNo"));
                accountDetailsVO.setAccountType(resultSet.getString("accountType"));
                accountDetailsVO.setAccountHoldertype(resultSet.getString("accountHoldertype"));
                accountDetailsVO.setAccountOpenDate(resultSet.getString("accountOpenDate"));
                */
				accountDetailsVO.setNameOfBank(resultSet.getString("BANKNAME"));
                accountDetailsVO.setBSRcode(resultSet.getString("BANKBSRCODE"));
                accountDetailsVO.setBankName(resultSet.getString("BANKNAME"));
                accountDetailsVO.setBankBsrCode(resultSet.getString("BANKBSRCODE"));
                accountDetailsVO.setBankFIUId(resultSet.getString("BANKFIUID"));
                accountDetailsVO.setAnnexEnclosed(resultSet.getString("ANNEXENCLOSED"));
                accountDetailsVO.setBranchName(resultSet.getString("BRANCHNAME"));
                accountDetailsVO.setBranchReferenceNumberType(resultSet.getString("BRANCHREFERENCENUMBERTYPE"));
                accountDetailsVO.setBranchBsrCode(resultSet.getString("BRANCHBSRCODE"));
                accountDetailsVO.setBranchFIUId(resultSet.getString("BRANCHFIUID"));
                accountDetailsVO.setBranchAddressLine1(resultSet.getString("BRANCHADDRESSLINE1"));
                accountDetailsVO.setBranchAddressLine2(resultSet.getString("BRANCHADDRESSLINE2"));
                accountDetailsVO.setBranchAddressLine3(resultSet.getString("BRANCHADDRESSLINE3"));
                accountDetailsVO.setBranchCity(resultSet.getString("BRANCHCITY"));
                accountDetailsVO.setBranchState(resultSet.getString("BRANCHSTATE"));
                accountDetailsVO.setBranchCountry(resultSet.getString("BRANCHCOUNTRY"));
                accountDetailsVO.setBranchPinCode(resultSet.getString("BRANCHPINCODE"));
                accountDetailsVO.setBranchTelephoneNo(resultSet.getString("BRANCHTELEPHONENO"));
                accountDetailsVO.setBranchFaxNo(resultSet.getString("BRANCHFAXNO"));
                accountDetailsVO.setBranchMobileNo(resultSet.getString("BRANCHMOBILENO"));
                accountDetailsVO.setBranchEmailId(resultSet.getString("BRANCHEMAILID"));
                accountDetailsVO.setAccountNo(resultSet.getString("ACCOUNTNO"));
                accountDetailsVO.setAccountHolderName(resultSet.getString("ACCOUNTHOLDERNAME"));
                accountDetailsVO.setAccountType(resultSet.getString("ACCOUNTTYPE"));
                accountDetailsVO.setAccountHoldertype(resultSet.getString("ACCOUNTHOLDERTYPE"));
                accountDetailsVO.setAccountOpenDate(resultSet.getString("ACCOUNTOPENDATE"));
                accountDetailsVO.setAccountStatus(resultSet.getString("ACCOUNTSTATUS"));
                accountDetailsVO.setAccountTotalCredit(resultSet.getString("ACCOUNTTOTALCREDIT"));
                accountDetailsVO.setAccountTotalDebit(resultSet.getString("ACCOUNTTOTALDEBIT"));
                accountDetailsVO.setAccountTotalCashCredit(resultSet.getString("ACCOUNTTOTALCASHCREDIT"));
                accountDetailsVO.setAccountTotalCashDebit(resultSet.getString("ACCOUNTTOTALCASHDEBIT"));
                accountDetailsVO.setAccountRiskCategory(resultSet.getString("ACCOUNTRISKCATEGORY"));
                //accountDetailsVO.setWriteUpTxns(stringArrayConversion(resultSet.getString("WriteUpTxns")));
				accountDetailsVO.setWriteUpTxns(stringArrayConversion(""));
				
				count = 0;
				connection = connectionUtil.getConnection();
                callableStatement1 = connection.prepareCall("{CALL STP_GETISTRANNEXCHOLDERS(?,?,?,?)}");
                callableStatement1.setString(1, caseNo);
                callableStatement1.setString(2, "");
                callableStatement1.setString(3, resultedAccountNo);
                callableStatement1.registerOutParameter(4, oracle.jdbc.OracleTypes.CURSOR);
                callableStatement1.execute();
                resultSet1 = (ResultSet)callableStatement1.getObject(4); 
                while(count <= 5 && resultSet1.next()){
                    listofAccountHoldersID[count] = resultSet1.getString("CustomerId");
                    listofAccountHoldersName[count] = resultSet1.getString("CustomerName");
                    //listofAccountHoldersAnnexAB[l_intCount] = resultSet1.getString("AccountHolderType");
					listofAccountHoldersAnnexAB[count] = "A";
                    count = count+1;
                }
                connectionUtil.closeResources(connection, callableStatement1, resultSet1, null);
                
                count = 0;
                connection = connectionUtil.getConnection();
                callableStatement1 = connection.prepareCall("{CALL STP_GETISTRANNEXCRELATEDPRSN(?,?,?,?)}");
                callableStatement1.setString(1, caseNo);
                callableStatement1.setString(2, "");
                callableStatement1.setString(3, resultedAccountNo);
                callableStatement1.registerOutParameter(4, oracle.jdbc.OracleTypes.CURSOR);
                callableStatement1.execute();
                resultSet1 = (ResultSet)callableStatement1.getObject(4); 
                while(count <= 5 && resultSet1.next()){
                    listofRelatedPersonsID[count] = resultSet1.getString("RelativeCustomerId");
                    listofRelatedPersonsName[count] = resultSet1.getString("RelativeCustomerName");
                    listofRelatedPersonsRelation[count] = resultSet1.getString("RelationCode");
                    count = count+1;
                }
                connectionUtil.closeResources(connection, callableStatement1, resultSet1, null);
                count = 0;
                connection = connectionUtil.getConnection();
                callableStatement1 = connection.prepareCall("{CALL STP_GETISTRANNEXCTRANSACTIONS(?,?,?,?)}");
                callableStatement1.setString(1, caseNo);
                callableStatement1.setString(2, "");
				callableStatement1.setString(3, resultedAccountNo);
                callableStatement1.registerOutParameter(4, oracle.jdbc.OracleTypes.CURSOR);
                callableStatement1.execute();
                resultSet1 = (ResultSet)callableStatement1.getObject(4); 
                while(resultSet1.next()){
                    transactionNos.append(resultSet1.getString("TransactionNo")).append("~");
                    transactionDates.append(resultSet1.getString("TransactionTimeStamp")).append("~");
                    transactionModes.append(resultSet1.getString("InstrumentCode")).append("~");
                    transactionDebitCredits.append(resultSet1.getString("DipositOrWithdrawal")).append("~");
                    transactionAmounts.append(resultSet1.getString("Amount")).append("~");
                    transactionRemarks.append(resultSet1.getString("Narration")).append("~");
                    transactionDataTypes.append(resultSet1.getString("DataType")).append("~");
                    countofTransactions++;
                }
                String transacdetailsNo[];
                String transacdetailsdate[];
                String transacdetailsmode[];
                String transacdetailsDebit[];
                String transacdetailsAmount[];
                String transacdetailsRemarks[];
                String transacdetailsDataType[];
                
                if(countofTransactions > 0){
                    transacdetailsNo = transactionNos.toString().split("~");
                    transacdetailsdate = transactionDates.toString().split("~");
                    transacdetailsmode = transactionModes.toString().split("~");
                    transacdetailsDebit = transactionDebitCredits.toString().split("~");
                    transacdetailsAmount = transactionAmounts.toString().split("~");
                    transacdetailsRemarks = transactionRemarks.toString().split("~");
                    transacdetailsDataType = transactionDataTypes.toString().split("~");
                } else {
                    transacdetailsNo = new String[25];
                    transacdetailsdate = new String[25];
                    transacdetailsmode = new String[25];
                    transacdetailsDebit = new String[25];
                    transacdetailsAmount = new String[25];
                    transacdetailsRemarks = new String[25];
                    transacdetailsDataType = new String[25];
                }
                connectionUtil.closeResources(connection, callableStatement1, resultSet1, null);
                count = 0;
                connection = connectionUtil.getConnection();
                callableStatement1 = connection.prepareCall("{CALL STP_GETISTRANNEXCCUMULATIVE(?,?,?,?)}");
                callableStatement1.setString(1, caseNo);
                callableStatement1.setString(2, "");
                callableStatement1.setString(3, resultedAccountNo);
                callableStatement1.registerOutParameter(4, oracle.jdbc.OracleTypes.CURSOR);
                callableStatement1.execute();
                resultSet1 = (ResultSet)callableStatement1.getObject(4); 
                while(resultSet1.next()){
                    String l_strTemp = resultSet1.getString("DepositOrWithdrawal");
                    if(accountDetailsVO != null)
                        if(l_strTemp.equalsIgnoreCase("W"))
                            accountDetailsVO.setCummulativetotalsDebit(resultSet1.getString("Amount"));
                        else
                        if(l_strTemp.equalsIgnoreCase("D"))
                            accountDetailsVO.setCummulativetotalsCredit(resultSet1.getString("Amount"));
                }
                connectionUtil.closeResources(connection, callableStatement1, resultSet1, null);
                if(accountDetailsVO != null){
                    accountDetailsVO.setListofAccountHoldersID(listofAccountHoldersID);
                    accountDetailsVO.setListofAccountHoldersName(listofAccountHoldersName);
                    accountDetailsVO.setListofAccountHoldersAnnexAB(listofAccountHoldersAnnexAB);
                    accountDetailsVO.setListofRelatedPersonsID(listofRelatedPersonsID);
                    accountDetailsVO.setListofRelatedPersonsName(listofRelatedPersonsName);
                    accountDetailsVO.setListofRelatedPersonsRelation(listofRelatedPersonsRelation);
                    accountDetailsVO.setTransacdetailsNo(transacdetailsNo);
                    accountDetailsVO.setTransacdetailsdate(transacdetailsdate);
                    accountDetailsVO.setTransacdetailsmode(transacdetailsmode);
                    accountDetailsVO.setTransacdetailsDebit(transacdetailsDebit);
                    accountDetailsVO.setTransacdetailsAmount(transacdetailsAmount);
                    accountDetailsVO.setTransacdetailsRemarks(transacdetailsRemarks);
                    accountDetailsVO.setTransacdetailsDataType(transacdetailsDataType);
                    accountDetailsVO.setNoOfTransactions(countofTransactions);
                }
				allAccountDetails.add(accountDetailsVO);
            }
		}catch(Exception e){
			log.error("Exception in INDSTRDAOImpl -> getINDSTRAnnexureAccountDetails, Error Is:"+ e.toString());
			System.out.println("Exception in INDSTRDAOImpl -> getINDSTRAnnexureAccountDetails, Error Is:"+ e.toString());
            e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection1, callableStatement, resultSet, null);
			// connectionUtil.closeResources(connection, callableStatement1, resultSet1, null);
		}
		return allAccountDetails;
	}
	
	private ArrayList getISTRAlertIndicatorsList(String caseNo){
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
	
	private HashMap<String, String> getISTRCaseStatusDetails(String caseNo, String userCode, String userRole){
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
			log.error("Exception in INDSTRDAOImpl -> ExecuteSTRXMLProcedures, Error Is:"+ e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return caseStatusDetails;
	}
	
	public void ExecuteSTRXMLProcedures(String caseNo, String userCode){
		Connection connection = null;
		Connection connection1 = null;
		PreparedStatement preparedStatement = null;
		CallableStatement callableStatement = null;
		ResultSet resultSet = null;
		try{
			connection = connectionUtil.getConnection();
			preparedStatement = connection.prepareStatement("SELECT PROCEDURENAME FROM TB_REGULATORYPROCLIST WHERE REPORTINGTYPE='STR' ORDER BY EXECUTIONORDER");
			resultSet = preparedStatement.executeQuery();
			while (resultSet.next()) {
				String l_strProcName = resultSet.getString(1);
				try{
					connection1 = connectionUtil.getConnection();
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
	
	public HashMap getSTRXMlFileContent(String caseNo, String userCode){
		HashMap xmlFileDetails = new HashMap();
		LinkedHashMap xmlFileContents = new LinkedHashMap();
		Connection connection = null;
		CallableStatement callableStatement = null;
		ResultSet resultSet1 = null;
		ResultSet resultSet2 = null;
		try{
			ExecuteSTRXMLProcedures(caseNo, userCode);
			
			connection = connectionUtil.getConnection();
			callableStatement = connection.prepareCall("{CALL STP_EXPORTSTRXMLFILE(?,?,?,?)}");
            callableStatement.setString(1, caseNo);
            callableStatement.setString(2, userCode);
            callableStatement.registerOutParameter(3, oracle.jdbc.OracleTypes.CURSOR);
            callableStatement.registerOutParameter(4, oracle.jdbc.OracleTypes.CURSOR);
            callableStatement.execute();
            resultSet1 = (ResultSet)callableStatement.getObject(3);
            resultSet2 = (ResultSet)callableStatement.getObject(4);
            if(resultSet1.next()){
            	xmlFileDetails.put("FILENAME", resultSet1.getString(1));
            }
            while(resultSet2.next()){
            	xmlFileContents.put(resultSet2.getString(1), resultSet2.getString(2));
            }
            xmlFileDetails.put("FILECONTENT", xmlFileContents);
		}catch(Exception e){
			log.error("Exception in INDSTRDAOImpl -> getSTRXMlFileContent, Error Is:"+ e.toString());
			System.out.println("Exception in INDSTRDAOImpl -> getSTRXMlFileContent, Error Is:"+ e.toString());
            e.toString();
		}finally{
			connectionUtil.closeResources(connection, callableStatement, resultSet1, null);
		}
		return xmlFileDetails;
	}
	
	public boolean saveSTRTransactionFile(String caseNo, String accountNo, String fullFilePath, File inputFile, 
			String userCode, String userRole, String ipAddress) {
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		boolean isSaved = false;
		try{
			connection = connectionUtil.getConnection();
			FileReader inputFileReader = new FileReader(inputFile);			
			preparedStatement = connection.prepareStatement("INSERT INTO TB_STRTRANSACTIONFILE (CASENO, ACCOUNTNO, FILEPATH, FILENAME, FILEDATA, UPLOADEDBY, UPLOADEDDATETIME) VALUES(?,?,?,?,?,?, SYSTIMESTAMP)");
			preparedStatement.setString(1, caseNo);
			preparedStatement.setString(2, accountNo);
			preparedStatement.setString(3, fullFilePath);
			preparedStatement.setString(4, inputFile.getName());
			preparedStatement.setCharacterStream(5, inputFileReader, (int) inputFile.length());
			preparedStatement.setString(6, userCode);
			int x = preparedStatement.executeUpdate();
			
			List<List<String>> fileContent = new Vector<List<String>>();
			String filePath = fullFilePath;
			File file = new File(filePath);
			BufferedReader br = null;
			br = new BufferedReader(new FileReader(file));
			String currentLine = "";
			int lineCount = 1;
			int colCount = 9;
			boolean shouldRun = true;
			
			while((currentLine = br.readLine()) != null){
				String[] content = CommonUtil.splitString(currentLine, "~");
				System.out.println("currentLine : "+currentLine+" And Length: "+content.length);
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
			String tempTableName = "TB_STRTRANSACTIONFILEDATA";
			try{
				deleteTempTableData(caseNo, accountNo, tempTableName, userCode);
			}
			catch(Exception exp){
				isSaved = false;
			}
			try{
				saveUploadFileData(caseNo, accountNo, fullFilePath, inputFile, 
					fileContent, tempTableName, colCount, userCode, userRole, ipAddress);
			}
			catch(Exception exp){
				isSaved = false;
			}
			try{
				executeFileUploadProcedures(caseNo, accountNo, fullFilePath, tempTableName, colCount, userCode, userRole, ipAddress);
			}
			catch(Exception exp){
				isSaved = false;
			}
			isSaved = true;		
		}catch(Exception e){
			log.error("Exception in INDSTRDAOImpl -> saveSTRTransactionFile, Error Is:"+ e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, null, null);
		}
		return isSaved;
	}

	private void deleteTempTableData(String caseNo, String accountNo, String tempTable, String userCode){
		String sql = " DELETE FROM "+tempTable+" A "+
		             "  WHERE A.CASENO = '"+caseNo+"'"+
		             "    AND ACCOUNTNO = '"+accountNo+"'";

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

	private void saveUploadFileData(String caseNo, String accountNo, String fullFilePath, File inputFile, 
			List<List<String>> uploadedData, String tempTable, int dataColCount, String userCode, String userRole, String ipAddress){
		String sql = "INSERT INTO "+tempTable+" VALUES(";
		for(int i = 1; i <=  dataColCount; i++){
			sql = sql + "?, ";
		}
		sql = sql + "?, ?, ?, ?, ?, FUN_DATETIMETOCHAR(SYSTIMESTAMP))";
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		try{
			preparedStatement = connection.prepareStatement(sql);
			for(List<String> recordData : uploadedData){
				preparedStatement.setString(1, caseNo);
				preparedStatement.setString(2, accountNo);
				int colIndex = 2;
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
	
	public boolean executeFileUploadProcedures(String caseNo, String accountNo, String fullFilePath, 
				String tempTableName, int colCount, String userCode, String userRole, String ipAddress){
		boolean executed = false;
		Connection connection = connectionUtil.getConnection();
		CallableStatement callableStatement = null;
		try{
			callableStatement = connection.prepareCall("{CALL STP_SAVETRANSACTIONSTRFILEDATA(?,?,?,?,?,?,?,?)}");
			callableStatement.setString(1, caseNo);
			callableStatement.setString(2, accountNo);
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
	
	public boolean autoSaveINDSTRTransactions(String caseNo, String accountNo, String fromDate, String toDate, String saveOrDelete, String userCode){
		Connection connection = null;
		CallableStatement callableStatement = null;
		boolean isSaved = false;
		String strProcCall = "{CALL STP_ISTRADDUPDATETRANS_FROMDB(?,?,?,?,?)}";
		try{
			connection = connectionUtil.getConnection();
			if(saveOrDelete.equalsIgnoreCase("Delete"))
				strProcCall = "{CALL STP_ISTRDELETEADDEDTRAN_FROMDB(?,?,?,?,?)}";
			
			//callableStatement = connection.prepareCall("{CALL STP_ISTRADDUPDATETRANS_FROMDB(?,?,?,?,?)}");
            callableStatement = connection.prepareCall(strProcCall);
			callableStatement.setString(1, caseNo);            
            callableStatement.setString(2, fromDate);
            callableStatement.setString(3, toDate);
            callableStatement.setString(4, accountNo);
            callableStatement.setString(5, userCode);
            callableStatement.execute();
            isSaved = true;
		}catch(Exception e){
			log.error("Exception in INDSTRDAOImpl -> autoSaveINDSTRTransactions, Error Is:"+ e.toString());
			isSaved = false;
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, callableStatement, null, null);
		}
		return isSaved;
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
		}catch(Exception e){
			message = message+e.getMessage()+". \n";
		}
		try{
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
			}
		}
		return mainMap;
	}
	
	public Map<String,Object> exportAccountTxnDetails(Map<String, String> paramMap) 
	{
    	ArrayList<HashMap<String, String>> arrayList = new ArrayList<HashMap<String, String>>();
        Map<String, Object> reportData = new HashMap<String, Object>();
        String reportName = "TRANSACTIONS_DUMP_"+paramMap.get("CaseNo")+"_"+paramMap.get("AccountNo");
        String procedureName = "STP_ISTRGETACCOUNT_TXNSDUMP";
		String sql = prepareProcedureName(procedureName, paramMap);
        Connection connection = null;
        CallableStatement callableStatement = null;
        PreparedStatement pstatement = null;
    	ResultSet resultSet = null;
    	
    	String reportHeader = "";
        String reportFooter = "";
        String reportExecuteQuery = "";
        String queryString = "";
        String paramType = "";
        
        String columnHeaderName = "";
        
        try
        {
    		reportData.put("reportName", reportName);
    		connection = connectionUtil.getConnection();
        	int columnIndex = 0;
        	callableStatement = connection.prepareCall(sql);
            	
        	Iterator<String> itr = paramMap.keySet().iterator();
            while(itr.hasNext()){
        		columnIndex ++;
				String paramName = itr.next();
				String paramValue = paramMap.get(paramName);
				// callableStatement.setString(paramName, paramValue);
				callableStatement.setString(columnIndex, paramValue);
			}

        	columnIndex ++;
        	callableStatement.registerOutParameter(columnIndex, OracleTypes.CURSOR);
			callableStatement.execute();
			
			resultSet = (ResultSet) callableStatement.getObject(columnIndex);
			
			ResultSetMetaData resultSetMetaData = resultSet.getMetaData();
  	        String[] strHeadersArray = new String[resultSetMetaData.getColumnCount()];
  		    for(int count = strHeadersArray.length; count >=1; count--)
  		    	strHeadersArray[count-1]=resultSetMetaData.getColumnName(count);
  			
  		    while(resultSet.next())
  		    {	
  			HashMap<String, String> hashMapData = new HashMap<String, String>();
  			for(int count = strHeadersArray.length; count>=1; count--) {
  				columnHeaderName = strHeadersArray[count-1];
  				hashMapData.put(columnHeaderName,resultSet.getString(columnHeaderName));
  			}
  			arrayList.add(hashMapData);
  		    }
  		    reportData.put("Header", strHeadersArray);
  		    reportData.put("ReportData", arrayList);

        }
        catch(Exception e)
        {
        	log.error("Error in generateReportWithBenchMarks() - " + e.toString());
            System.out.println("Error in generateReportWithBenchMarks() - " + e.toString());
            e.printStackTrace();
        }
        finally
        {
            connectionUtil.closeResources(connection, callableStatement, resultSet, null);
        }
        return reportData;
	}
	
	public Map<String, Object> exportConsildatedExceptionReport(Map<String, String> paramMap){
    	Map<String, Object> mainMap = new LinkedHashMap<String, Object>();
    	Connection connection = null;
		CallableStatement callableStatement = null;
        ResultSet tabNameResultSet = null;
		Map<String, ResultSet> resultSetMap = new LinkedHashMap<String, ResultSet>();
		String[] arrTabName = null;
		try{
			connection = connectionUtil.getConnection();
			callableStatement = connection.prepareCall("{CALL STP_GETSTR_EXCEPTIONREPORTDATA(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");
			callableStatement.setString(1, paramMap.get("CaseNo"));
			callableStatement.setString(2, paramMap.get("UserCode"));
			callableStatement.setString(3, paramMap.get("UserRole"));
			callableStatement.setString(4, paramMap.get("IPAdress"));
            callableStatement.registerOutParameter(5, oracle.jdbc.OracleTypes.CURSOR);
            callableStatement.registerOutParameter(6, oracle.jdbc.OracleTypes.CURSOR);
            callableStatement.registerOutParameter(7, oracle.jdbc.OracleTypes.CURSOR);
            callableStatement.registerOutParameter(8, oracle.jdbc.OracleTypes.CURSOR);
            callableStatement.registerOutParameter(9, oracle.jdbc.OracleTypes.CURSOR);
            callableStatement.registerOutParameter(10, oracle.jdbc.OracleTypes.CURSOR);
            callableStatement.registerOutParameter(11, oracle.jdbc.OracleTypes.CURSOR);
            callableStatement.registerOutParameter(12, oracle.jdbc.OracleTypes.CURSOR);
            callableStatement.registerOutParameter(13, oracle.jdbc.OracleTypes.CURSOR);
            callableStatement.registerOutParameter(14, oracle.jdbc.OracleTypes.CURSOR);
            callableStatement.registerOutParameter(15, oracle.jdbc.OracleTypes.CURSOR);
            callableStatement.registerOutParameter(16, oracle.jdbc.OracleTypes.CURSOR);
            callableStatement.registerOutParameter(17, oracle.jdbc.OracleTypes.CURSOR);
            callableStatement.registerOutParameter(18, oracle.jdbc.OracleTypes.CURSOR);
            callableStatement.registerOutParameter(19, oracle.jdbc.OracleTypes.CURSOR);
            callableStatement.registerOutParameter(20, oracle.jdbc.OracleTypes.CURSOR);

            callableStatement.execute();
	            
            tabNameResultSet = (ResultSet)callableStatement.getObject(5);
            if(tabNameResultSet.next()){
            	arrTabName = CommonUtil.splitString(tabNameResultSet.getString(1), "^~^");
            }
            
            for(int i = 0; i < arrTabName.length; i++){
            	int resultSetInedx = i+6;
            	resultSetMap.put(arrTabName[i], (ResultSet)callableStatement.getObject(resultSetInedx));
            }
            
            Iterator<String> itr = resultSetMap.keySet().iterator();
			while (itr.hasNext()) {
				String sheetName = itr.next();
				ResultSet resultSet = resultSetMap.get(sheetName);
				
				ArrayList<ArrayList<String>> headerList = new ArrayList<ArrayList<String>>();
				ArrayList<ArrayList<String>> resultList = new ArrayList<ArrayList<String>>();
				
		    	ResultSetMetaData resultSetMetaData=resultSet.getMetaData();
		    	ArrayList<String> eachHeader = new ArrayList<String>();
		    	for(int i = 1; i <= resultSetMetaData.getColumnCount(); i++){
		    		eachHeader.add(resultSetMetaData.getColumnName(i));
		    	}
		    	headerList.add(eachHeader);
		    	
		    	while(resultSet.next()){
		    		ArrayList<String> eachRecord = new ArrayList<String>();
		    		for(int i = 1; i <= resultSetMetaData.getColumnCount(); i++){
		    			eachRecord.add(resultSet.getString(i));
		    		}
		    		resultList.add(eachRecord);
		    }
		    	
	    	HashMap<String, ArrayList<ArrayList<String>>> innerMap = new LinkedHashMap<String, ArrayList<ArrayList<String>>>();
	    	innerMap.put("listResultHeader", headerList);
	    	innerMap.put("listResultData", resultList);
	    	mainMap.put(sheetName, innerMap);
		}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, callableStatement, tabNameResultSet, null);
		}
		//System.out.println("STP_GETSTR_EXCEPTIONREPORTDATA result = "+mainMap);
		return mainMap;
    }

	private String prepareProcedureName(String procedureName, Map<String, String> paramMap){
		Iterator<String> itr = paramMap.keySet().iterator();
		String finalProcedureName = "{CALL "+procedureName+"(";
		while(itr.hasNext()){
			finalProcedureName = finalProcedureName + ":"+itr.next()+",";
		}
		finalProcedureName = finalProcedureName + ":RESULTSET)}";
		return finalProcedureName;
	}
	
}
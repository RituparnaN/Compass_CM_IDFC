package com.quantumdataengines.app.compass.dao.aof;

import java.io.File;
import java.io.FileInputStream;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import oracle.jdbc.internal.OracleTypes;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Repository;

import com.quantumdataengines.app.compass.util.ConnectionUtil;

@Repository
public class AccountOpeningFormDAOImpl implements AccountOpeningFormDAO{
	private static final Logger log = LoggerFactory.getLogger(AccountOpeningFormDAOImpl.class);
	
	@Autowired
	private ConnectionUtil connectionUtil;
	
	@Value("${compass.aml.config.schemaName}")
	private String schemaName;
	
	public Connection getConnection(){
		Connection connection = null;
		try{
			connection = connectionUtil.getConnection();
		}catch(Exception e){
			log.error("Error in creating db connection : AccountOpeningFormDAOImpl -> "+e.getMessage());
			e.printStackTrace();
		}
		return connection;
	}
	
	public Map<String, String> getAllCountry() {
		Map<String, String> allCountries = new LinkedHashMap<String, String>();
		Connection connection = getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareStatement("SELECT NATION_ID, LONG_DESC FROM "+schemaName+"TB_NATIONALITY ORDER BY 2");
			resultSet = preparedStatement.executeQuery();
			while (resultSet.next()) {
				allCountries.put(resultSet.getString("NATION_ID"), resultSet.getString("LONG_DESC"));
			}
		}catch(Exception e){
			log.error("Error while getting all country list : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return allCountries;
	}
	
	public String getCIFNoByAccountNo(String accountNo){
		String cifNo = "";
		Connection connection = getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareStatement("SELECT CIF_NO FROM "+schemaName+"TB_AMF WHERE ACCOUNT_NO = ?");
			preparedStatement.setString(1, accountNo);
			resultSet = preparedStatement.executeQuery();
			if (resultSet.next()) {
				cifNo = resultSet.getString("CIF_NO");
			}
		}catch(Exception e){
			log.error("Error while getting cif no from account no : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return cifNo;
	}
	
	public List<String> getAccountNosByCIFNo(String cifNo){
		List<String> accountNoList = new ArrayList<String>();
		Connection connection = getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareStatement("SELECT ACCOUNT_NO FROM "+schemaName+"TB_AMF WHERE CIF_NO = ?");
			preparedStatement.setString(1, cifNo);
			resultSet = preparedStatement.executeQuery();
			while (resultSet.next()) {
				accountNoList.add(resultSet.getString("ACCOUNT_NO"));
			}
		}catch(Exception e){
			log.error("Error while getting all account no for cif : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return accountNoList;
	}
	
	
	public boolean checkCIFNoAccountNo(String cifNo, String accountNo){
		boolean isValid = false;
		Connection connection = getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareStatement("SELECT COUNT(1) FROM "+schemaName+"TB_AMF WHERE CIF_NO = ? AND ACCOUNT_NO = ?");
			preparedStatement.setString(1, cifNo);
			preparedStatement.setString(2, accountNo);
			resultSet = preparedStatement.executeQuery();
			while (resultSet.next()) {
				if(resultSet.getInt(1) != 0)
					isValid = true;
			}
		}catch(Exception e){
			log.error("Error while getting all account no for cif : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return isValid;
	}
	
	public boolean checkCIF(String cifNo){
		boolean isValid = false;
		Connection connection = getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareStatement("SELECT COUNT(1) FROM "+schemaName+"TB_CIF WHERE CIF_NO = ?");
			preparedStatement.setString(1, cifNo);
			resultSet = preparedStatement.executeQuery();
			while (resultSet.next()) {
				if(resultSet.getInt(1) != 0)
					isValid = true;
			}
		}catch(Exception e){
			log.error("Error while checking cif no : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return isValid;
	}
	
	public boolean checkAccountNo(String accountNo){
		boolean isValid = false;
		Connection connection = getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareStatement("SELECT COUNT(1) FROM "+schemaName+"TB_AMF WHERE ACCOUNT_NO = ?");
			preparedStatement.setString(1, accountNo);
			resultSet = preparedStatement.executeQuery();
			while (resultSet.next()) {
				if(resultSet.getInt(1) != 0)
					isValid = true;
			}
		}catch(Exception e){
			log.error("Error while checking cif no : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return isValid;
	}
	
	public Map<String, Object> getAccountOpeningFormData(String cifNumber, String accountNumber, String caseNo, String userCode, String userType){
		Map<String, Object> accountOpeningFormDataMap = new HashMap<String, Object>();
		
		Map<String, String> cifData = new HashMap<String, String>();
		List<Map<String, String>> uploadData = new ArrayList<Map<String, String>>();
		Map<String, List<Map<String, String>>> accountMandateDataMap = new HashMap<String, List<Map<String, String>>>();
		List<Map<String, String>> jointHolderList = new ArrayList<Map<String, String>>();
		Map<String, String> formStatus = new HashMap<String, String>();
		String message = "";
		String canUpdate = "N";
		String canCheck = "N";
		
		Connection connection = getConnection();
		CallableStatement callableStatement = null;
		ResultSet cifResultSet = null;
		ResultSet uploadResultSet = null;
		ResultSet accountMandateResultSet = null;
		ResultSet jointHolderResultSet = null;
		ResultSet formStatusResultSet = null;
		ResultSet otherResultSet = null;
		try{
			callableStatement = connection.prepareCall("{CALL "+schemaName+"STP_AOF_GETFORMDATA(?,?,?,?,?,?,?,?,?,?,?)}");
			callableStatement.setString(1, caseNo);
			callableStatement.setString(2, cifNumber);
			callableStatement.setString(3, accountNumber);
			callableStatement.setString(4, userCode);
			callableStatement.setString(5, userType);
			
			callableStatement.registerOutParameter(6, OracleTypes.CURSOR);	//cif_data
			callableStatement.registerOutParameter(7, OracleTypes.CURSOR);	//upload
			callableStatement.registerOutParameter(8, OracleTypes.CURSOR);	//account and mandate
			callableStatement.registerOutParameter(9, OracleTypes.CURSOR);	//joint holder list
			callableStatement.registerOutParameter(10, OracleTypes.CURSOR);	//form status
			callableStatement.registerOutParameter(11, OracleTypes.CURSOR);	// case no, cif number, account number, message
			callableStatement.execute();
			
			cifResultSet = (ResultSet) callableStatement.getObject(6);
			uploadResultSet = (ResultSet) callableStatement.getObject(7);
			accountMandateResultSet = (ResultSet) callableStatement.getObject(8);
			jointHolderResultSet = (ResultSet) callableStatement.getObject(9);
			formStatusResultSet = (ResultSet) callableStatement.getObject(10);
			otherResultSet = (ResultSet) callableStatement.getObject(11);
			
			ResultSetMetaData cifResultSetMetaData = cifResultSet.getMetaData();
			int cifColumnCount = cifResultSetMetaData.getColumnCount();
			if(cifResultSet.next()){
				for(int i = 1; i <= cifColumnCount; i++){
					String columnName = cifResultSetMetaData.getColumnName(i);
					cifData.put(columnName, cifResultSet.getString(columnName));
				}
				accountOpeningFormDataMap.put("CIF_DATA", cifData);
			}
			
			ResultSetMetaData uploadResultSetMetaData = uploadResultSet.getMetaData();
			int uploadColumnCount = uploadResultSetMetaData.getColumnCount();
			while (uploadResultSet.next()) {
				Map<String, String> uploadDataMap = new HashMap<String, String>();
				for(int i = 1; i <= uploadColumnCount; i++){
					String columnName = uploadResultSetMetaData.getColumnName(i);
					uploadDataMap.put(columnName, uploadResultSet.getString(columnName));
				}
				uploadData.add(uploadDataMap);
			}
			accountOpeningFormDataMap.put("UPLOAD_DATA", uploadData);
			
			
			while (accountMandateResultSet.next()) {
				String accountNo = accountMandateResultSet.getString("ACCOUNT_NO");
				Map<String, String> mandateMap = new HashMap<String, String>(); 
				mandateMap.put("SEQ_NO", accountMandateResultSet.getString("SEQ_NO"));
				mandateMap.put("FILE_NAME", accountMandateResultSet.getString("FILE_NAME"));
				if(accountMandateDataMap.containsKey(accountNo)){
					accountMandateDataMap.get(accountNo).add(mandateMap);
				}else{
					List<Map<String, String>> mandateList = new ArrayList<Map<String, String>>();
					mandateList.add(mandateMap);
					accountMandateDataMap.put(accountNo, mandateList);
				}
			}
			accountOpeningFormDataMap.put("ACCOUNTS_AND_MANDATES", accountMandateDataMap);
			
			ResultSetMetaData jointHolderResultSetMetaData = jointHolderResultSet.getMetaData();
			int jointHolderColumnCount = jointHolderResultSetMetaData.getColumnCount();
			while (jointHolderResultSet.next()) {
				Map<String, String> jointHolderDataMap = new HashMap<String, String>();
				for(int i = 1; i <= jointHolderColumnCount; i++){
					String columnName = jointHolderResultSetMetaData.getColumnName(i);
					jointHolderDataMap.put(columnName, jointHolderResultSet.getString(columnName));
				}
				jointHolderList.add(jointHolderDataMap);
			}
			accountOpeningFormDataMap.put("JOINT_HOLDER", jointHolderList);
			
			ResultSetMetaData formStatusResultSetMetaData = formStatusResultSet.getMetaData();
			int formStatusColumnCount = formStatusResultSetMetaData.getColumnCount();
			if(formStatusResultSet.next()){
				for(int i = 1; i <= formStatusColumnCount; i++){
					String columnName = formStatusResultSetMetaData.getColumnName(i);
					formStatus.put(columnName, formStatusResultSet.getString(columnName));
				}
				accountOpeningFormDataMap.put("FORMSTATUS", formStatus);
			}
			
			if(otherResultSet.next()){
				caseNo = otherResultSet.getString("CASENO");
				accountNumber = otherResultSet.getString("ACCOUNT_NO");
				cifNumber = otherResultSet.getString("CIF_NO");
				message = otherResultSet.getString("MESSAGE");
				canCheck = otherResultSet.getString("CAN_EDIT");
				canUpdate = otherResultSet.getString("CAN_CHECK");
			}
			accountOpeningFormDataMap.put("CIF_NO", cifNumber);
			accountOpeningFormDataMap.put("ACCOUNT_NO", accountNumber);
			accountOpeningFormDataMap.put("CASE_NO", caseNo);
			accountOpeningFormDataMap.put("MESSAGE", message);
			accountOpeningFormDataMap.put("CAN_EDIT", canCheck);
			accountOpeningFormDataMap.put("CAN_CHECK", canUpdate);
		}catch(Exception e){
			log.error("Error while getting form data : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, callableStatement, null, null);
		}
		return accountOpeningFormDataMap;
	}
	
	public Map<String, Object> getAccountHolderDetails(String accountHolderType, String cifNumber, String accountNumber, String lineNo){
		Map<String, Object> returnMap = new HashMap<String, Object>();
		List<Map<String, String>> keyContactDetails = new ArrayList<Map<String, String>>();
		Map<String, String> accountHolderDetails = new HashMap<String, String>();
		Connection connection = getConnection();
		CallableStatement callableStatement = null;
		ResultSet resultSet = null;
		ResultSet keyContactResultSet = null;
		try{
			callableStatement = connection.prepareCall("{CALL "+schemaName+"STP_GETACCOUNTHOLDERDETAILS(?,?,?,?,?,?)}");
			callableStatement.setString(1, accountHolderType);
			callableStatement.setString(2, cifNumber);
			callableStatement.setString(3, accountNumber);
			callableStatement.setString(4, lineNo);
			callableStatement.registerOutParameter(5, OracleTypes.CURSOR);
			callableStatement.registerOutParameter(6, OracleTypes.CURSOR);
			callableStatement.execute();
			
			resultSet = (ResultSet) callableStatement.getObject(5);
			ResultSetMetaData resultSetMetaData = resultSet.getMetaData();
			int columnCount = resultSetMetaData.getColumnCount();
			if(resultSet.next()){
				for(int i = 1; i <= columnCount; i++){
					String columnName = resultSetMetaData.getColumnName(i);
					accountHolderDetails.put(columnName, resultSet.getString(columnName));
				}
			}			
			returnMap.put("ACCOUNTHOLDER", accountHolderDetails);
			
			keyContactResultSet = (ResultSet) callableStatement.getObject(6);
			ResultSetMetaData keyContactResultSetMetaData = keyContactResultSet.getMetaData();
			int keyContactCount = keyContactResultSetMetaData.getColumnCount();
			while(keyContactResultSet.next()){
				Map<String, String> keyContact = new HashMap<String, String>();
				for(int i = 1; i <= keyContactCount; i++){
					String columnName = keyContactResultSetMetaData.getColumnName(i);
					keyContact.put(columnName, keyContactResultSet.getString(columnName));
				}
				keyContactDetails.add(keyContact);
			}
			returnMap.put("KEYCONTACTS", keyContactDetails);
			
		}catch(Exception e){
			log.error("Error while getting account holder details : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, callableStatement, resultSet, null);
		}
		return returnMap;
	}
	
	public Map<String, Object> getAccountDetails(String cifNo, String accountNo, String caseNo){
		Map<String, Object> allAccountDetails = new HashMap<String, Object>();
		Map<String, String> accountDetails = new HashMap<String, String>();
		List<Map<String, String>> jointHolderList = new ArrayList<Map<String, String>>();
		Map<String, String> formStatus = new HashMap<String, String>();
		
		Connection connection = getConnection();
		CallableStatement callableStatement = null;
		ResultSet resultSet = null;
		ResultSet formStatusResultSet = null;
		ResultSet jointHolderResultSet = null;
		try{
			callableStatement = connection.prepareCall("{CALL "+schemaName+"STP_AOF_ACCOUNTDETAILS(?,?,?,?,?,?)}");
			callableStatement.setString(1, caseNo);
			callableStatement.setString(2, cifNo);
			callableStatement.setString(3, accountNo);
			callableStatement.registerOutParameter(4, OracleTypes.CURSOR);
			callableStatement.registerOutParameter(5, OracleTypes.CURSOR);
			callableStatement.registerOutParameter(6, OracleTypes.CURSOR);	
			callableStatement.execute();
			
			resultSet = (ResultSet) callableStatement.getObject(4);
			ResultSetMetaData resultSetMetaData = resultSet.getMetaData();
			int columnCount = resultSetMetaData.getColumnCount();
			if(resultSet.next()){
				for(int i = 1; i <= columnCount; i++){
					String columnName = resultSetMetaData.getColumnName(i);
					accountDetails.put(columnName, resultSet.getString(columnName));
				}
			}
			allAccountDetails.put("ACCOUNT_DATA", accountDetails);
			
			formStatusResultSet = (ResultSet) callableStatement.getObject(5);
			ResultSetMetaData formStatusResultSetMetaData = formStatusResultSet.getMetaData();
			int formStatusColumnCount = formStatusResultSetMetaData.getColumnCount();
			if(formStatusResultSet.next()){
				for(int i = 1; i <= formStatusColumnCount; i++){
					String columnName = formStatusResultSetMetaData.getColumnName(i);
					formStatus.put(columnName, formStatusResultSet.getString(columnName));
				}
				allAccountDetails.put("FORMSTATUS", formStatus);
			}
			
			jointHolderResultSet = (ResultSet) callableStatement.getObject(6);
			ResultSetMetaData jointHolderResultSetMetaData = jointHolderResultSet.getMetaData();
			int jointHolderColumnCount = jointHolderResultSetMetaData.getColumnCount();
			while (jointHolderResultSet.next()) {
				Map<String, String> jointHolderDataMap = new HashMap<String, String>();
				for(int i = 1; i <= jointHolderColumnCount; i++){
					String columnName = jointHolderResultSetMetaData.getColumnName(i);
					jointHolderDataMap.put(columnName, jointHolderResultSet.getString(columnName));
				}
				jointHolderList.add(jointHolderDataMap);
			}
			allAccountDetails.put("JOINT_HOLDER", jointHolderList);
			
			
		}catch(Exception e){
			log.error("Error while getting account details : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, callableStatement, resultSet, null);
		}
		return allAccountDetails;
	}
	
	public Map<String, String> getValueAddedServiceDetails(String cifNumber, String accountNumber, String lineNo){
		Map<String, String> valueAddedServiceDetails = new HashMap<String, String>();
		Connection connection = getConnection();
		CallableStatement callableStatement = null;
		ResultSet resultSet = null;
		try{
			callableStatement = connection.prepareCall("{CALL "+schemaName+"STP_GETVALUEADDEDSERVICE(?,?,?,?)}");
			callableStatement.setString(1, cifNumber);
			callableStatement.setString(2, accountNumber);
			callableStatement.setString(3, lineNo);
			callableStatement.registerOutParameter(4, OracleTypes.CURSOR);
			callableStatement.execute();
			resultSet = (ResultSet) callableStatement.getObject(4);
			ResultSetMetaData resultSetMetaData = resultSet.getMetaData();
			int columnCount = resultSetMetaData.getColumnCount();
			if(resultSet.next()){
				for(int i = 1; i <= columnCount; i++){
					String columnName = resultSetMetaData.getColumnName(i);
					valueAddedServiceDetails.put(columnName, resultSet.getString(columnName));
				}
			}
		}catch(Exception e){
			log.error("Error while getting value added service details : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, callableStatement, resultSet, null);
		}
		return valueAddedServiceDetails;
		
	}
	
	public Map<String, Object> saveFormData(Map<String, String> formData, String caseNo, String UPDATEDBY, String status){
		Map<String, Object> returnObject = new HashMap<String, Object>();
		String message = "";
		/*
		String sql = 
				"UPDATE TB_CIF "+
				"   SET MUDARABA_AAGGR_DATE = TO_DATE(?,'DD/MM/YYYY'), MUDARABA_AGGR_PLCE = ?, MUDARABA_AGGR_1 = ?, MUDARABA_AGGR_2 = ?, MUDARABA_AGGR_3 = ?, "+
				"		PSR_ACC_TYPE_1 = ?, PSR_ACC_TYPE_1_OTR = ?, PSR_BANK_1 = ?, PSR_CUSTOMER_1 = ?, PSR_ACC_TYPE_2 = ?, "+
				"		PSR_ACC_TYPE_2_OTR = ?, PSR_BANK_2 = ?, PSR_CUSTOMER_2 = ?, EXIST_BANK_ACC_NO_1 = ?, EXIST_BANK_ACC_TYPE_1 = ?, "+
				"		EXIST_BANK_ACC_TYPE_1_OTR = ?, EXIST_BANK_ACC_BRANCH_1 = ?, EXIST_BANK_ACC_NO_2 = ?, EXIST_BANK_ACC_TYPE_2 = ?, EXIST_BANK_ACC_TYPE_2_OTR = ?, "+
				"		EXIST_BANK_ACC_BRANCH_2 = ?, EXIST_OTHER_ACC_NO_1 = ?, EXIST_OTHER_ACC_TYPE_1 = ?, EXIST_OTHER_ACC_TYPE_1_OTR = ?, EXIST_OTHER_ACC_BRANCH_1 = ?, "+
				"		EXIST_OTHER_ACC_NO_2 = ?, EXIST_OTHER_ACC_TYPE_2 = ?, EXIST_OTHER_ACC_TYPE_2_OTR = ?, EXIST_OTHER_ACC_BRANCH_2 = ?, INSTRUCTION_TO_BANK = ?, "+
				"		CORP_AOM_COMPLETED = ?, CORP_INCROP_CERT_COPY = ?, COPR_CERT_COPY_TYPE = ?, COPR_ART_ASSOC_COMP = ?, CORP_RC_FORM = ?, "+
				"		CORP_RC_FORM_TYPE = ?, COPR_COMMRC_BUSS_CERT = ?, CORP_BORD_RESOL_CERT = ?, CORP_REG_ADDR_COPY_FRM_13_36 = ?, CORP_ADDR_VERF_DOC = ?, "+
				"		CORP_AUTH_SIGNTR_COPY = ?, COPR_DIR_SIGNTR_NIC_PASPRT = ?, CORP_DIR_SIGNTR_KYC = ?, CORP_OTHER_DOC = ?, CORP_OTHER_DOC_NAME = ?, "+
				"		MNR_GURDN_RELATN = ?, MNR_TITLE = ?, MNR_FULLNAME = ?, MNR_DOB = TO_DATE(?,'DD/MM/YYYY'), MNR_BIRTHCERT_NO = ?, "+
				"		MNR_BIRTHCERT_ISS_DATE = TO_DATE(?,'DD/MM/YYYY'), MNR_NATIONALITY = ?, MNR_GENDER = ?, MNR_ADDR1 = ?, MNR_ADDR2 = ?, "+
				"		MNR_ADDR3 = ?, MNR_TELEPHONE = ?, MNR_OCCUPATION = ?, MNR_GURDN_CORRESPONDENCE = ?, MNR_GURDN_TAX_DECL = ?, NDN_VRF_BY_NIC = ?, "+
				"		NDN_VRF_BY_ARM_FRCE = ?, NDN_VRF_BY_PASSPORT = ?, NDN_VRF_BY_DL = ?, NDN_VRF_BY_POSTALID = ?, NDN_VRF_BY_MARIG_CERT = ?, "+
				"		NDN_VRF_BY_BRANCH = ?, NDN_VRF_BY_OTR = ?, NDN_VRF_BY_OTR_NAME = ?, ADDR_VERF_UTILITY_BILL = ?, ADDR_VERF_UTILITY_BILL_NAME = ?, "+
				"		ADDR_VERF_BANK_STMNT = ?, ADDR_VERF_TENANCY_AGGR = ?, ADDR_VERF_EMP_CONTRACT = ?, ADDR_VERF_NIC = ?, ADDR_VERF_PUB_AUTH_LTTR = ?, "+
				"		ADDR_VERF_INCOM_TAX_RECPT = ?, ADDR_VERF_OTR = ?, ADDR_VERF_OTR_NAME = ?, DOC_AOM = ?, DOC_SIGN_CARD = ?, "+
				"		DOC_NIC_PP_DL = ?, DOC_MUDARABA_AGGR = ?, DOC_MINOR_BIRTH_CERT = ?, DOC_NIC_GUARDIAN = ?, DOC_REG_CERT = ?, "+
				"		DOC_RULES_CONSTITUTION = ?, DOC_OFF_BEARERS_MEET_EXTRCT = ?, DOC_ACC_OPEN_RESOL_MEET = ?, DOC_KYC = ?, DOC_BUSS_REG = ?, "+
				"		DOC_ADDR_VERF_COPY = ?, DOC_OTHER = ?, DOC_OTHER_NANE = ?, CLIENT_BLACK_LISTED = ?, CIF_PRIORITY = ?, "+
				"		BANK_USER_CIF_TYPE = ?, DEVISION_CODE = ?, DEPT_CODE = ?, ACCOUNT_TYPE = ?, BRNCH_APPROVL_ACC_OPND_DATE = TO_DATE(?,'DD/MM/YYYY'), "+
				"		BRNCH_APPROVL_ACC_OPND_BY = ?, BRNCH_APPROVL_AUTH_OFF = ?, BRNCH_APPROVL_AUDT_OFF = ?, CPU_OP_RECV_DATE = TO_DATE(?,'DD/MM/YYYY'), CPU_OP_CIF_COMPLETED = ?, "+
				"		CPU_OP_DOC_CHECKED = ?, CPU_OP_STANDING_ORDER_SETUP = ?, CPU_OP_MANDATE_COMPLETED = ?, CPU_OP_SIGN_SCANNED = ?, CPU_OP_STATEMENT_SETUP = ?, "+
				"		CPU_OP_DATA_INPUT_BY = ?, CPU_OP_AUTH_OFF1 = ?, CPU_OP_AUTH_OFF2 = ?, CPU_OP_AUTD_OFF = ?, UPDATETIMESTAMP = SYSTIMESTAMP, UPDATEDBY = ? "+
				" WHERE CIF_NO = ?";
		
		String sql = 
				"UPDATE TB_CIF "+
				"   SET MUDARABA_AAGGR_DATE = TO_DATE(?,'DD/MM/YYYY'), MUDARABA_AGGR_PLCE = ?, MUDARABA_AGGR_1 = ?, MUDARABA_AGGR_2 = ?, MUDARABA_AGGR_3 = ?, "+
				"		PSR_ACC_TYPE_1 = ?, PSR_ACC_TYPE_1_OTR = ?, PSR_BANK_1 = ?, PSR_CUSTOMER_1 = ?, PSR_ACC_TYPE_2 = ?, "+
				"		PSR_ACC_TYPE_2_OTR = ?, PSR_BANK_2 = ?, PSR_CUSTOMER_2 = ?, INSTRUCTION_TO_BANK = ?, "+
				"		CORP_AOM_COMPLETED = ?, CORP_INCROP_CERT_COPY = ?, COPR_CERT_COPY_TYPE = ?, COPR_ART_ASSOC_COMP = ?, CORP_RC_FORM = ?, "+
				"		CORP_RC_FORM_TYPE = ?, COPR_COMMRC_BUSS_CERT = ?, CORP_BORD_RESOL_CERT = ?, CORP_REG_ADDR_COPY_FRM_13_36 = ?, CORP_ADDR_VERF_DOC = ?, "+
				"		CORP_AUTH_SIGNTR_COPY = ?, COPR_DIR_SIGNTR_NIC_PASPRT = ?, CORP_DIR_SIGNTR_KYC = ?, CORP_OTHER_DOC = ?, CORP_OTHER_DOC_NAME = ?, "+
				"		MNR_GURDN_RELATN = ?, MNR_TITLE = ?, MNR_FULLNAME = ?, MNR_DOB = TO_DATE(?,'DD/MM/YYYY'), MNR_BIRTHCERT_NO = ?, "+
				"		MNR_BIRTHCERT_ISS_DATE = TO_DATE(?,'DD/MM/YYYY'), MNR_NATIONALITY = ?, MNR_GENDER = ?, MNR_ADDR1 = ?, MNR_ADDR2 = ?, "+
				"		MNR_ADDR3 = ?, MNR_TELEPHONE = ?, MNR_OCCUPATION = ?, MNR_GURDN_CORRESPONDENCE = ?, MNR_GURDN_TAX_DECL = ?, NDN_VRF_BY_NIC = ?, "+
				"		NDN_VRF_BY_ARM_FRCE = ?, NDN_VRF_BY_PASSPORT = ?, NDN_VRF_BY_DL = ?, NDN_VRF_BY_POSTALID = ?, NDN_VRF_BY_MARIG_CERT = ?, "+
				"		NDN_VRF_BY_BRANCH = ?, NDN_VRF_BY_OTR = ?, NDN_VRF_BY_OTR_NAME = ?, ADDR_VERF_UTILITY_BILL = ?, ADDR_VERF_UTILITY_BILL_NAME = ?, "+
				"		ADDR_VERF_BANK_STMNT = ?, ADDR_VERF_TENANCY_AGGR = ?, ADDR_VERF_EMP_CONTRACT = ?, ADDR_VERF_NIC = ?, ADDR_VERF_PUB_AUTH_LTTR = ?, "+
				"		ADDR_VERF_INCOM_TAX_RECPT = ?, ADDR_VERF_OTR = ?, ADDR_VERF_OTR_NAME = ?, DOC_AOM = ?, DOC_SIGN_CARD = ?, "+
				"		DOC_NIC_PP_DL = ?, DOC_MUDARABA_AGGR = ?, DOC_MINOR_BIRTH_CERT = ?, DOC_NIC_GUARDIAN = ?, DOC_REG_CERT = ?, "+
				"		DOC_RULES_CONSTITUTION = ?, DOC_OFF_BEARERS_MEET_EXTRCT = ?, DOC_ACC_OPEN_RESOL_MEET = ?, DOC_KYC = ?, DOC_BUSS_REG = ?, "+
				"		DOC_ADDR_VERF_COPY = ?, DOC_OTHER = ?, DOC_OTHER_NANE = ?, CLIENT_BLACK_LISTED = ?, CIF_PRIORITY = ?, "+
				"		BANK_USER_CIF_TYPE = ?, DEVISION_CODE = ?, DEPT_CODE = ?, ACCOUNT_TYPE = ?, BRNCH_APPROVL_ACC_OPND_DATE = TO_DATE(?,'DD/MM/YYYY'), "+
				"		BRNCH_APPROVL_ACC_OPND_BY = ?, BRNCH_APPROVL_AUTH_OFF = ?, BRNCH_APPROVL_AUDT_OFF = ?, CPU_OP_RECV_DATE = TO_DATE(?,'DD/MM/YYYY'), CPU_OP_CIF_COMPLETED = ?, "+
				"		CPU_OP_DOC_CHECKED = ?, CPU_OP_STANDING_ORDER_SETUP = ?, CPU_OP_MANDATE_COMPLETED = ?, CPU_OP_SIGN_SCANNED = ?, CPU_OP_STATEMENT_SETUP = ?, "+
				"		CPU_OP_DATA_INPUT_BY = ?, CPU_OP_AUTH_OFF1 = ?, CPU_OP_AUTH_OFF2 = ?, CPU_OP_AUTD_OFF = ?, UPDATETIMESTAMP = SYSTIMESTAMP, UPDATEDBY = ? "+
				" WHERE CIF_NO = ?";
				*/
		String sql = 
				"UPDATE "+schemaName+"TB_CIF "+
				"   SET MUDARABA_AAGGR_DATE = TO_DATE(?,'DD/MM/YYYY'), MUDARABA_AGGR_PLCE = ?, MUDARABA_AGGR_1 = ?, MUDARABA_AGGR_2 = ?, MUDARABA_AGGR_3 = ?, "+
				"		PSR_ACC_TYPE_1 = ?, PSR_ACC_TYPE_1_OTR = ?, PSR_BANK_1 = ?, PSR_CUSTOMER_1 = ?, PSR_ACC_TYPE_2 = ?, "+
				"		PSR_ACC_TYPE_2_OTR = ?, PSR_BANK_2 = ?, PSR_CUSTOMER_2 = ?, INSTRUCTION_TO_BANK = ?, "+
				"		CORP_AOM_COMPLETED = ?, CORP_INCROP_CERT_COPY = ?, COPR_CERT_COPY_TYPE = ?, COPR_ART_ASSOC_COMP = ?, CORP_RC_FORM = ?, "+
				"		CORP_RC_FORM_TYPE = ?, COPR_COMMRC_BUSS_CERT = ?, CORP_BORD_RESOL_CERT = ?, CORP_REG_ADDR_COPY_FRM_13_36 = ?, CORP_ADDR_VERF_DOC = ?, "+
				"		CORP_AUTH_SIGNTR_COPY = ?, COPR_DIR_SIGNTR_NIC_PASPRT = ?, CORP_DIR_SIGNTR_KYC = ?, CORP_OTHER_DOC = ?, CORP_OTHER_DOC_NAME = ?, "+
				"		MNR_GURDN_RELATN = ?, MNR_TITLE = ?, MNR_FULLNAME = ?, MNR_DOB = TO_DATE(?,'DD/MM/YYYY'), MNR_BIRTHCERT_NO = ?, "+
				"		MNR_BIRTHCERT_ISS_DATE = TO_DATE(?,'DD/MM/YYYY'), MNR_NATIONALITY = ?, MNR_GENDER = ?, MNR_ADDR1 = ?, MNR_ADDR2 = ?, "+
				"		MNR_ADDR3 = ?, MNR_TELEPHONE = ?, MNR_OCCUPATION = ?, MNR_GURDN_CORRESPONDENCE = ?, MNR_GURDN_TAX_DECL = ?, NDN_VRF_BY_NIC = ?, "+
				"		NDN_VRF_BY_ARM_FRCE = ?, NDN_VRF_BY_PASSPORT = ?, NDN_VRF_BY_DL = ?, NDN_VRF_BY_POSTALID = ?, NDN_VRF_BY_MARIG_CERT = ?, "+
				"		NDN_VRF_BY_BRANCH = ?, NDN_VRF_BY_OTR = ?, NDN_VRF_BY_OTR_NAME = ?, ADDR_VERF_UTILITY_BILL = ?, ADDR_VERF_UTILITY_BILL_NAME = ?, "+
				"		ADDR_VERF_BANK_STMNT = ?, ADDR_VERF_TENANCY_AGGR = ?, ADDR_VERF_EMP_CONTRACT = ?, ADDR_VERF_NIC = ?, ADDR_VERF_PUB_AUTH_LTTR = ?, "+
				"		ADDR_VERF_INCOM_TAX_RECPT = ?, ADDR_VERF_OTR = ?, ADDR_VERF_OTR_NAME = ?, DOC_AOM = ?, DOC_SIGN_CARD = ?, "+
				"		DOC_NIC_PP_DL = ?, DOC_MUDARABA_AGGR = ?, DOC_MINOR_BIRTH_CERT = ?, DOC_NIC_GUARDIAN = ?, DOC_REG_CERT = ?, "+
				"		DOC_RULES_CONSTITUTION = ?, DOC_OFF_BEARERS_MEET_EXTRCT = ?, DOC_ACC_OPEN_RESOL_MEET = ?, DOC_KYC = ?, DOC_BUSS_REG = ?, "+
				"		DOC_ADDR_VERF_COPY = ?, DOC_OTHER = ?, DOC_OTHER_NANE = ?, CLIENT_BLACK_LISTED = ?, CIF_PRIORITY = ?, "+
				"		BANK_USER_CIF_TYPE = ?, DEVISION_CODE = ?, DEPT_CODE = ?, ACCOUNT_TYPE = ?, CPU_OP_RECV_DATE = TO_DATE(?,'DD/MM/YYYY'), CPU_OP_CIF_COMPLETED = ?, "+
				"		CPU_OP_DOC_CHECKED = ?, CPU_OP_STANDING_ORDER_SETUP = ?, CPU_OP_MANDATE_COMPLETED = ?, CPU_OP_SIGN_SCANNED = ?, CPU_OP_STATEMENT_SETUP = ?, "+
				"		CPU_OP_DATA_INPUT_BY = ?, CPU_OP_AUTH_OFF1 = ?, CPU_OP_AUTH_OFF2 = ?, CPU_OP_AUTD_OFF = ?, UPDATETIMESTAMP = SYSTIMESTAMP, UPDATEDBY = ?, "+
				"		EXIST_BANK_ACC_NO_1 = ?, EXIST_BANK_ACC_TYPE_1 = ?, "+
				"		EXIST_BANK_ACC_TYPE_1_OTR = ?, EXIST_BANK_ACC_BRANCH_1 = ?, EXIST_BANK_ACC_NO_2 = ?, EXIST_BANK_ACC_TYPE_2 = ?, EXIST_BANK_ACC_TYPE_2_OTR = ?, "+
				"		EXIST_BANK_ACC_BRANCH_2 = ?, EXIST_OTHER_ACC_NO_1 = ?, EXIST_OTHER_ACC_TYPE_1 = ?, EXIST_OTHER_ACC_TYPE_1_OTR = ?, EXIST_OTHER_ACC_BRANCH_1 = ?, "+
				"		EXIST_OTHER_ACC_NO_2 = ?, EXIST_OTHER_ACC_TYPE_2 = ?, EXIST_OTHER_ACC_TYPE_2_OTR = ?, EXIST_OTHER_ACC_BRANCH_2 = ?, "+
				"		RISK_RATING_FINAL = ?, RISK_RATING_FINAL_VALUE = ?, RISK_RATING_CAT4 = ?, RISK_RATING_CAT3 = ?, RISK_RATING_CAT2 = ?, RISK_RATING_CAT1 = ?, "+
				"		RISK_RATING_CAT4LOW1 = ?, RISK_RATING_CAT4MID1 = ?, RISK_RATING_CAT4HIGH1 = ?, RISK_RATING_CAT4LOW2 = ?, RISK_RATING_CAT4MID2 = ?, "+
				"		RISK_RATING_CAT4HIGH2 = ?, RISK_RATING_CAT5 = ? "+
				" WHERE CIF_NO = ?";
		Connection connection = getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareStatement(sql);
			
			//MUDARABA_AAGGR_DATE = TO_DATE(?,'DD/MM/YYYY'), MUDARABA_AGGR_PLCE = ?, MUDARABA_AGGR_1 = ?, MUDARABA_AGGR_2 = ?, MUDARABA_AGGR_3 = ?, "+
			preparedStatement.setString(1, formData.get("MUDARABA_AAGGR_DATE"));
			preparedStatement.setString(2, formData.get("MUDARABA_AGGR_PLCE"));
			preparedStatement.setString(3, formData.get("MUDARABA_AGGR_1"));
			preparedStatement.setString(4, formData.get("MUDARABA_AGGR_2"));
			preparedStatement.setString(5, formData.get("MUDARABA_AGGR_3"));
			
			//PSR_ACC_TYPE_1 = ?, PSR_ACC_TYPE_1_OTR = ?, PSR_BANK_1 = ?, PSR_CUSTOMER_1 = ?, PSR_ACC_TYPE_2 = ?, "+
			preparedStatement.setString(6, formData.get("PSR_ACC_TYPE_1"));
			preparedStatement.setString(7, formData.get("PSR_ACC_TYPE_1_OTR"));
			preparedStatement.setString(8, formData.get("PSR_BANK_1"));
			preparedStatement.setString(9, formData.get("PSR_CUSTOMER_1"));
			preparedStatement.setString(10, formData.get("PSR_ACC_TYPE_2"));
			
			//PSR_ACC_TYPE_2_OTR = ?, PSR_BANK_2 = ?, PSR_CUSTOMER_2 = ?, INSTRUCTION_TO_BANK = ?, "+
			preparedStatement.setString(11, formData.get("PSR_ACC_TYPE_2_OTR"));
			preparedStatement.setString(12, formData.get("PSR_BANK_2"));
			preparedStatement.setString(13, formData.get("PSR_CUSTOMER_2"));
			preparedStatement.setString(14, formData.get("INSTRUCTION_TO_BANK"));
			
			//CORP_AOM_COMPLETED = ?, CORP_INCROP_CERT_COPY = ?, COPR_CERT_COPY_TYPE = ?, COPR_ART_ASSOC_COMP = ?, CORP_RC_FORM = ?, "+
			preparedStatement.setString(15, formData.get("CORP_AOM_COMPLETED"));
			preparedStatement.setString(16, formData.get("CORP_INCROP_CERT_COPY"));
			preparedStatement.setString(17, formData.get("COPR_CERT_COPY_TYPE"));
			preparedStatement.setString(18, formData.get("COPR_ART_ASSOC_COMP"));
			preparedStatement.setString(19, formData.get("CORP_RC_FORM"));
			
			//CORP_RC_FORM_TYPE = ?, COPR_COMMRC_BUSS_CERT = ?, CORP_BORD_RESOL_CERT = ?, CORP_REG_ADDR_COPY_FRM_13_36 = ?, CORP_ADDR_VERF_DOC = ?, "+
			preparedStatement.setString(20, formData.get("CORP_RC_FORM_TYPE"));
			preparedStatement.setString(21, formData.get("COPR_COMMRC_BUSS_CERT"));
			preparedStatement.setString(22, formData.get("CORP_BORD_RESOL_CERT"));
			preparedStatement.setString(23, formData.get("CORP_REG_ADDR_COPY_FRM_13_36"));
			preparedStatement.setString(24, formData.get("CORP_ADDR_VERF_DOC"));
			
			//CORP_AUTH_SIGNTR_COPY = ?, COPR_DIR_SIGNTR_NIC_PASPRT = ?, CORP_DIR_SIGNTR_KYC = ?, CORP_OTHER_DOC = ?, CORP_OTHER_DOC_NAME = ?, "+
			preparedStatement.setString(25, formData.get("CORP_AUTH_SIGNTR_COPY"));
			preparedStatement.setString(26, formData.get("COPR_DIR_SIGNTR_NIC_PASPRT"));
			preparedStatement.setString(27, formData.get("CORP_DIR_SIGNTR_KYC"));
			preparedStatement.setString(28, formData.get("CORP_OTHER_DOC"));
			preparedStatement.setString(29, formData.get("CORP_OTHER_DOC_NAME"));
			
			//MNR_GURDN_RELATN = ?, MNR_TITLE = ?, MNR_FULLNAME = ?, MNR_DOB = TO_DATE(?,'DD/MM/YYYY'), MNR_BIRTHCERT_NO = ?, "+
			preparedStatement.setString(30, formData.get("MNR_GURDN_RELATN"));
			preparedStatement.setString(31, formData.get("MNR_TITLE"));
			preparedStatement.setString(32, formData.get("MNR_FULLNAME"));
			preparedStatement.setString(33, formData.get("MNR_DOB"));
			preparedStatement.setString(34, formData.get("MNR_BIRTHCERT_NO"));
			
			//MNR_BIRTHCERT_ISS_DATE = TO_DATE(?,'DD/MM/YYYY'), MNR_NATIONALITY = ?, MNR_GENDER = ?, MNR_ADDR1 = ?, MNR_ADDR2 = ?, "+
			preparedStatement.setString(35, formData.get("MNR_BIRTHCERT_ISS_DATE"));
			preparedStatement.setString(36, formData.get("MNR_NATIONALITY"));
			preparedStatement.setString(37, formData.get("MNR_GENDER"));
			preparedStatement.setString(38, formData.get("MNR_ADDR1"));
			preparedStatement.setString(39, formData.get("MNR_ADDR2"));
			
			//MNR_ADDR3 = ?, MNR_TELEPHONE = ?, MNR_OCCUPATION = ?, MNR_GURDN_CORRESPONDENCE = ?, MNR_GURDN_TAX_DECL = ?, NDN_VRF_BY_NIC = ?, "+
			preparedStatement.setString(40, formData.get("MNR_ADDR3"));
			preparedStatement.setString(41, formData.get("MNR_TELEPHONE"));
			preparedStatement.setString(42, formData.get("MNR_OCCUPATION"));
			preparedStatement.setString(43, formData.get("MNR_GURDN_CORRESPONDENCE"));
			preparedStatement.setString(44, formData.get("MNR_GURDN_TAX_DECL"));
			preparedStatement.setString(45, formData.get("NDN_VRF_BY_NIC"));
			
			//NDN_VRF_BY_ARM_FRCE = ?, NDN_VRF_BY_PASSPORT = ?, NDN_VRF_BY_DL = ?, NDN_VRF_BY_POSTALID = ?, NDN_VRF_BY_MARIG_CERT = ?, "+
			preparedStatement.setString(46, formData.get("NDN_VRF_BY_ARM_FRCE"));
			preparedStatement.setString(47, formData.get("NDN_VRF_BY_PASSPORT"));
			preparedStatement.setString(48, formData.get("NDN_VRF_BY_DL"));
			preparedStatement.setString(49, formData.get("NDN_VRF_BY_POSTALID"));
			preparedStatement.setString(50, formData.get("NDN_VRF_BY_MARIG_CERT"));
			
			//NDN_VRF_BY_BRANCH = ?, NDN_VRF_BY_OTR = ?, NDN_VRF_BY_OTR_NAME = ?, ADDR_VERF_UTILITY_BILL = ?, ADDR_VERF_UTILITY_BILL_NAME = ?, "+
			preparedStatement.setString(51, formData.get("NDN_VRF_BY_BRANCH"));
			preparedStatement.setString(52, formData.get("NDN_VRF_BY_OTR"));
			preparedStatement.setString(53, formData.get("NDN_VRF_BY_OTR_NAME"));
			preparedStatement.setString(54, formData.get("ADDR_VERF_UTILITY_BILL"));
			preparedStatement.setString(55, formData.get("ADDR_VERF_UTILITY_BILL_NAME"));
			
			//ADDR_VERF_BANK_STMNT = ?, ADDR_VERF_TENANCY_AGGR = ?, ADDR_VERF_EMP_CONTRACT = ?, ADDR_VERF_NIC = ?, ADDR_VERF_PUB_AUTH_LTTR = ?, "+
			preparedStatement.setString(56, formData.get("ADDR_VERF_BANK_STMNT"));
			preparedStatement.setString(57, formData.get("ADDR_VERF_TENANCY_AGGR"));
			preparedStatement.setString(58, formData.get("ADDR_VERF_EMP_CONTRACT"));
			preparedStatement.setString(59, formData.get("ADDR_VERF_NIC"));
			preparedStatement.setString(60, formData.get("ADDR_VERF_PUB_AUTH_LTTR"));
			
			//ADDR_VERF_INCOM_TAX_RECPT = ?, ADDR_VERF_OTR = ?, ADDR_VERF_OTR_NAME = ?, DOC_AOM = ?, DOC_SIGN_CARD = ?, "+
			preparedStatement.setString(61, formData.get("ADDR_VERF_INCOM_TAX_RECPT"));
			preparedStatement.setString(62, formData.get("ADDR_VERF_OTR"));
			preparedStatement.setString(63, formData.get("ADDR_VERF_OTR_NAME"));
			preparedStatement.setString(64, formData.get("DOC_AOM"));
			preparedStatement.setString(65, formData.get("DOC_SIGN_CARD"));
			
			//DOC_NIC_PP_DL = ?, DOC_MUDARABA_AGGR = ?, DOC_MINOR_BIRTH_CERT = ?, DOC_NIC_GUARDIAN = ?, DOC_REG_CERT = ?, "+
			preparedStatement.setString(66, formData.get("DOC_NIC_PP_DL"));
			preparedStatement.setString(67, formData.get("DOC_MUDARABA_AGGR"));
			preparedStatement.setString(68, formData.get("DOC_MINOR_BIRTH_CERT"));
			preparedStatement.setString(69, formData.get("DOC_NIC_GUARDIAN"));
			preparedStatement.setString(70, formData.get("DOC_REG_CERT"));
			
			//DOC_RULES_CONSTITUTION = ?, DOC_OFF_BEARERS_MEET_EXTRCT = ?, DOC_ACC_OPEN_RESOL_MEET = ?, DOC_KYC = ?, DOC_BUSS_REG = ?, "+
			preparedStatement.setString(71, formData.get("DOC_RULES_CONSTITUTION"));
			preparedStatement.setString(72, formData.get("DOC_OFF_BEARERS_MEET_EXTRCT"));
			preparedStatement.setString(73, formData.get("DOC_ACC_OPEN_RESOL_MEET"));
			preparedStatement.setString(74, formData.get("DOC_KYC"));
			preparedStatement.setString(75, formData.get("DOC_BUSS_REG"));
			
			//DOC_ADDR_VERF_COPY = ?, DOC_OTHER = ?, DOC_OTHER_NANE = ?, CLIENT_BLACK_LISTED = ?, CIF_PRIORITY = ?, "+
			preparedStatement.setString(76, formData.get("DOC_ADDR_VERF_COPY"));
			preparedStatement.setString(77, formData.get("DOC_OTHER"));
			preparedStatement.setString(78, formData.get("DOC_OTHER_NANE"));
			preparedStatement.setString(79, formData.get("CLIENT_BLACK_LISTED"));
			preparedStatement.setString(80, formData.get("CIF_PRIORITY"));
			
			//BANK_USER_CIF_TYPE = ?, DEVISION_CODE = ?, DEPT_CODE = ?, ACCOUNT_TYPE = ?, BRNCH_APPROVL_ACC_OPND_DATE = TO_DATE(?,'DD/MM/YYYY'), "+
			preparedStatement.setString(81, formData.get("BANK_USER_CIF_TYPE"));
			preparedStatement.setString(82, formData.get("DEVISION_CODE"));
			preparedStatement.setString(83, formData.get("DEPT_CODE"));
			preparedStatement.setString(84, formData.get("ACCOUNT_TYPE"));
			//preparedStatement.setString(85, formData.get("BRNCH_APPROVL_ACC_OPND_DATE"));
			
			//BRNCH_APPROVL_ACC_OPND_BY = ?, BRNCH_APPROVL_AUTH_OFF = ?, BRNCH_APPROVL_AUDT_OFF = ?, CPU_OP_RECV_DATE = TO_DATE(?,'DD/MM/YYYY'), CPU_OP_CIF_COMPLETED = ?, "+
			//preparedStatement.setString(86, formData.get("BRNCH_APPROVL_ACC_OPND_BY"));
			//preparedStatement.setString(87, formData.get("BRNCH_APPROVL_AUTH_OFF"));
			//preparedStatement.setString(88, formData.get("BRNCH_APPROVL_AUDT_OFF"));
			preparedStatement.setString(85, formData.get("CPU_OP_RECV_DATE"));
			preparedStatement.setString(86, formData.get("CPU_OP_CIF_COMPLETED"));
			
			//CPU_OP_DOC_CHECKED = ?, CPU_OP_STANDING_ORDER_SETUP = ?, CPU_OP_MANDATE_COMPLETED = ?, CPU_OP_SIGN_SCANNED = ?, CPU_OP_STATEMENT_SETUP = ?, "+
			preparedStatement.setString(87, formData.get("CPU_OP_DOC_CHECKED"));
			preparedStatement.setString(88, formData.get("CPU_OP_STANDING_ORDER_SETUP"));
			preparedStatement.setString(89, formData.get("CPU_OP_MANDATE_COMPLETED"));
			preparedStatement.setString(90, formData.get("CPU_OP_SIGN_SCANNED"));
			preparedStatement.setString(91, formData.get("CPU_OP_STATEMENT_SETUP"));
			
			//CPU_OP_DATA_INPUT_BY = ?, CPU_OP_AUTH_OFF1 = ?, CPU_OP_AUTH_OFF2 = ?, CPU_OP_AUTD_OFF = ?, UPDATETIMESTAMP = SYSTIMESTAMP, UPDATEDBY = ? "+
			preparedStatement.setString(92, formData.get("CPU_OP_DATA_INPUT_BY"));
			preparedStatement.setString(93, formData.get("CPU_OP_AUTH_OFF1"));
			preparedStatement.setString(94, formData.get("CPU_OP_AUTH_OFF2"));
			preparedStatement.setString(95, formData.get("CPU_OP_AUTD_OFF"));
			preparedStatement.setString(96, UPDATEDBY);
			
			preparedStatement.setString(97, formData.get("EXIST_BANK_ACC_NO_1"));
			preparedStatement.setString(98, formData.get("EXIST_BANK_ACC_TYPE_1"));
			preparedStatement.setString(99, formData.get("EXIST_BANK_ACC_TYPE_1_OTR"));
			preparedStatement.setString(100, formData.get("EXIST_BANK_ACC_BRANCH_1"));
			preparedStatement.setString(101, formData.get("EXIST_BANK_ACC_NO_2"));
			preparedStatement.setString(102, formData.get("EXIST_BANK_ACC_TYPE_2"));
			preparedStatement.setString(103, formData.get("EXIST_BANK_ACC_TYPE_2_OTR"));
			preparedStatement.setString(104, formData.get("EXIST_BANK_ACC_BRANCH_2"));
			preparedStatement.setString(105, formData.get("EXIST_OTHER_ACC_NO_1"));
			preparedStatement.setString(106, formData.get("EXIST_OTHER_ACC_TYPE_1"));
			preparedStatement.setString(107, formData.get("EXIST_OTHER_ACC_TYPE_1_OTR"));
			preparedStatement.setString(108, formData.get("EXIST_OTHER_ACC_BRANCH_1"));
			preparedStatement.setString(109, formData.get("EXIST_OTHER_ACC_NO_2"));
			preparedStatement.setString(110, formData.get("EXIST_OTHER_ACC_TYPE_2"));
			preparedStatement.setString(111, formData.get("EXIST_OTHER_ACC_TYPE_2_OTR"));
			preparedStatement.setString(112, formData.get("EXIST_OTHER_ACC_BRANCH_2"));
			preparedStatement.setString(113, formData.get("RISK_RATING_FINAL"));
			preparedStatement.setString(114, formData.get("RISK_RATING_FINAL_VALUE"));
			preparedStatement.setString(115, formData.get("RISK_RATING_CAT4"));
			preparedStatement.setString(116, formData.get("RISK_RATING_CAT3"));
			preparedStatement.setString(117, formData.get("RISK_RATING_CAT2"));
			preparedStatement.setString(118, formData.get("RISK_RATING_CAT1"));
			
			preparedStatement.setString(119, formData.get("RISK_RATING_CAT4LOW1"));
			preparedStatement.setString(120, formData.get("RISK_RATING_CAT4MID1"));
			preparedStatement.setString(121, formData.get("RISK_RATING_CAT4HIGH1"));
			preparedStatement.setString(122, formData.get("RISK_RATING_CAT4LOW2"));
			preparedStatement.setString(123, formData.get("RISK_RATING_CAT4MID2"));
			preparedStatement.setString(124, formData.get("RISK_RATING_CAT4HIGH2"));
			preparedStatement.setString(125, formData.get("RISK_RATING_CAT5"));
			
			preparedStatement.setString(126, formData.get("CIF_NO"));
			
			int i = preparedStatement.executeUpdate();
			if(i == 1){
				message = "CIF has been saved successfully";
				updateCIFAccountStatus(caseNo, formData.get("CIF_NO"), "", UPDATEDBY, status, message);	
				saveAuditLog(caseNo, formData.get("CIF_NO"), "", message, UPDATEDBY, status);
			}
		}catch(Exception e){
			log.error("Error while saving form data : "+e.getMessage());
			e.printStackTrace();
			message = "Saved Failed";
			saveAuditLog(caseNo, formData.get("CIF_NO"), "", message+e.toString(), UPDATEDBY, "E");
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		returnObject.put("MESSAGE", message);
		return returnObject;
	}
	
	public Map<String, Object> saveAccountData(Map<String, String> formData, String caseNo, String cifNumber, String accNumber, String UPDATEDBY, String status){
		Map<String, Object> returnObject = new HashMap<String, Object>();
		Connection connection = getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String message = "";
		String sql = 
				"UPDATE "+schemaName+"TB_AMF "+
				"	SET PORPOSE_OF_ACCOUNT_SA = ?, PORPOSE_OF_ACCOUNT_BT = ?, PORPOSE_OF_ACCOUNT_LR = ?, PORPOSE_OF_ACCOUNT_SCW = ?, PORPOSE_OF_ACCOUNT_SPI = ?, "+
				"		PORPOSE_OF_ACCOUNT_FIR = ?, PORPOSE_OF_ACCOUNT_IP = ?, PORPOSE_OF_ACCOUNT_ST = ?, PORPOSE_OF_ACCOUNT_UBP = ?, PORPOSE_OF_ACCOUNT_UF = ?, "+
				"		PORPOSE_OF_ACCOUNT_OT = ?, PORPOSE_OF_ACCOUNT_OTR = ?, SOURCE_OF_FUND_S = ?, SOURCE_OF_FUND_B = ?, SOURCE_OF_FUND_FR = ?, "+
				"		SOURCE_OF_FUND_EP = ?, SOURCE_OF_FUND_IP = ?, SOURCE_OF_FUND_D = ?, SOURCE_OF_FUND_CI = ?, SOURCE_OF_FUND_OT = ?, SOURCE_OF_FUND_OTR  = ?, ACCOUNT_DEPOSITE = ?, "+
				"       INITIAL_DEPOSITE = ?, INVST_PERIOD_YEAR = ?, INVST_PERIOD_MONTH = ?, INVST_AMOUNT = ?, DEPOSIT_MODE = ?, "+
				"		DEPOSIT_CHQ_NO = ?, PROFIT_PAYMENT_METHOD = ?, PROFIT_PAYMENT_ACC_NO = ?, PROFIT_PAYMENT_ACC_NAME = ?, PROFIT_PAYMENT_BANK = ?, "+
				"		PROFIT_PAYMENT_BRANCH = ?, CORRESPONDENCE_TYPE = ?, SAVINGS_ACC_STMNT_TYPE = ?, SAVINGS_ACC_STMNT_FREQ = ?, SAVINGS_ACC_STMNT_FREQ_OTR = ?, "+
				"		CURRENT_ACC_STMNT_FREQ = ?, CURRENT_ACC_STMNT_FREQ_OTR = ?, STMNT_DISPTCH_MODE = ?, STMNT_DISPTCH_EMAIL = ?, CHEQUE_BOOK_PAGE = ?, "+
				"		INTRODUCTOR_RELN_YEAR = ?, INTRODUCTOR_NAME = ?, INTRODUCTOR_ID_NO = ?, INTRODUCTOR_ADDR = ?, INTRODUCTOR_ACC_NO = ?, "+
				"		INTRODUCTOR_DESG = ?, INTRODUCTOR_TEL_NO = ?, INTRODUCTOR_OFF_NO = ?, INTRODUCTOR_MOB_NO = ?, ACC_SIGN_TYPE = ?, "+
				"		ACC_SIGN_TYPE_OTR = ?, MUDARABA_AAGGR_DATE = TO_DATE(?,'DD/MM/YYYY'), MUDARABA_AGGR_PLCE = ?, MUDARABA_AGGR_1 = ?, MUDARABA_AGGR_2 = ?, "+
				"		MUDARABA_AGGR_3 = ?, PSR_ACC_TYPE_1 = ?, PSR_ACC_TYPE_1_OTR = ?, PSR_BANK_1 = ?, PSR_CUSTOMER_1 = ?, "+
				"		PSR_ACC_TYPE_2 = ?, PSR_ACC_TYPE_2_OTR = ?, PSR_BANK_2 = ?, PSR_CUSTOMER_2 = ?, ACC_CANVASSED_BY_EMP_NAME = ?, "+
				"		ACC_CANVASSED_BY_EMP_NO = ?, ACC_CANVASSED_BY_BRANCH = ?, TERM_INVST_CERT_NO = ?, TERM_INVST_CERT_ISS_DATE = ?, TERM_INVST_TAX_NO = ?, "+
				"		INCOME_DET = ?, ACCOUNT_WITHDRAWAL = ?, BRNCH_APPROVL_ACC_OPND_DATE= TO_DATE(?,'DD/MM/YYYY'), BRNCH_APPROVL_ACC_OPND_BY = ?, "+
				"		BRNCH_APPROVL_AUTH_OFF = ?, BRNCH_APPROVL_AUDT_OFF = ?, UPDATEDBY = ?, UPDATETIMESTAMP = SYSTIMESTAMP "+
				" WHERE CIF_NO = ? "+
				"   AND ACCOUNT_NO = ?";
		try{
			preparedStatement = connection.prepareStatement(sql);
			
			//PORPOSE_OF_ACCOUNT_SA = ?, PORPOSE_OF_ACCOUNT_BT = ?, PORPOSE_OF_ACCOUNT_LR = ?, PORPOSE_OF_ACCOUNT_SCW = ?, PORPOSE_OF_ACCOUNT_SPI = ?, "+
			preparedStatement.setString(1, formData.get("PORPOSE_OF_ACCOUNT_SA"));
			preparedStatement.setString(2, formData.get("PORPOSE_OF_ACCOUNT_BT"));
			preparedStatement.setString(3, formData.get("PORPOSE_OF_ACCOUNT_LR"));
			preparedStatement.setString(4, formData.get("PORPOSE_OF_ACCOUNT_SCW"));
			preparedStatement.setString(5, formData.get("PORPOSE_OF_ACCOUNT_SPI"));
			
			//PORPOSE_OF_ACCOUNT_FIR = ?, PORPOSE_OF_ACCOUNT_IP = ?, PORPOSE_OF_ACCOUNT_ST = ?, PORPOSE_OF_ACCOUNT_UBP = ?, PORPOSE_OF_ACCOUNT_UF = ?, "+
			preparedStatement.setString(6, formData.get("PORPOSE_OF_ACCOUNT_FIR"));
			preparedStatement.setString(7, formData.get("PORPOSE_OF_ACCOUNT_IP"));
			preparedStatement.setString(8, formData.get("PORPOSE_OF_ACCOUNT_ST"));
			preparedStatement.setString(9, formData.get("PORPOSE_OF_ACCOUNT_UBP"));
			preparedStatement.setString(10, formData.get("PORPOSE_OF_ACCOUNT_UF"));
			
			//PORPOSE_OF_ACCOUNT_OT = ?, PORPOSE_OF_ACCOUNT_OTR = ?, SOURCE_OF_FUND_S = ?, SOURCE_OF_FUND_B = ?, SOURCE_OF_FUND_FR = ?, "+
			preparedStatement.setString(11, formData.get("PORPOSE_OF_ACCOUNT_OT"));
			preparedStatement.setString(12, formData.get("PORPOSE_OF_ACCOUNT_OTR"));
			preparedStatement.setString(13, formData.get("SOURCE_OF_FUND_S"));
			preparedStatement.setString(14, formData.get("SOURCE_OF_FUND_B"));
			preparedStatement.setString(15, formData.get("SOURCE_OF_FUND_FR"));
			
			//SOURCE_OF_FUND_EP = ?, SOURCE_OF_FUND_IP = ?, SOURCE_OF_FUND_D = ?, SOURCE_OF_FUND_CI = ?, SOURCE_OF_FUND_OT = ?, SOURCE_OF_FUND_OTR  = ?, ACCOUNT_DEPOSITE = ?, "+
			preparedStatement.setString(16, formData.get("SOURCE_OF_FUND_EP"));
			preparedStatement.setString(17, formData.get("SOURCE_OF_FUND_IP"));
			preparedStatement.setString(18, formData.get("SOURCE_OF_FUND_D"));
			preparedStatement.setString(19, formData.get("SOURCE_OF_FUND_CI"));
			preparedStatement.setString(20, formData.get("SOURCE_OF_FUND_OT"));
			preparedStatement.setString(21, formData.get("SOURCE_OF_FUND_OTR"));
			preparedStatement.setString(22, formData.get("ACCOUNT_DEPOSITE"));
			
			//INITIAL_DEPOSITE = ?, INVST_PERIOD_YEAR = ?, INVST_PERIOD_MONTH = ?, INVST_AMOUNT = ?, DEPOSIT_MODE = ?, "+
			preparedStatement.setString(23, formData.get("INITIAL_DEPOSITE"));
			preparedStatement.setString(24, formData.get("INVST_PERIOD_YEAR"));
			preparedStatement.setString(25, formData.get("INVST_PERIOD_MONTH"));
			preparedStatement.setString(26, formData.get("INVST_AMOUNT"));
			preparedStatement.setString(27, formData.get("DEPOSIT_MODE"));
			
			//DEPOSIT_CHQ_NO = ?, PROFIT_PAYMENT_METHOD = ?, PROFIT_PAYMENT_ACC_NO = ?, PROFIT_PAYMENT_ACC_NAME = ?, PROFIT_PAYMENT_BANK = ?, "+
			preparedStatement.setString(28, formData.get("DEPOSIT_CHQ_NO"));
			preparedStatement.setString(29, formData.get("PROFIT_PAYMENT_METHOD"));
			preparedStatement.setString(30, formData.get("PROFIT_PAYMENT_ACC_NO"));
			preparedStatement.setString(31, formData.get("PROFIT_PAYMENT_ACC_NAME"));
			preparedStatement.setString(32, formData.get("PROFIT_PAYMENT_BANK"));
			
			//PROFIT_PAYMENT_BRANCH = ?, CORRESPONDENCE_TYPE = ?, SAVINGS_ACC_STMNT_TYPE = ?, SAVINGS_ACC_STMNT_FREQ = ?, SAVINGS_ACC_STMNT_FREQ_OTR = ?, "+
			preparedStatement.setString(33, formData.get("PROFIT_PAYMENT_BRANCH"));
			preparedStatement.setString(34, formData.get("CORRESPONDENCE_TYPE"));
			preparedStatement.setString(35, formData.get("SAVINGS_ACC_STMNT_TYPE"));
			preparedStatement.setString(36, formData.get("SAVINGS_ACC_STMNT_FREQ"));
			preparedStatement.setString(37, formData.get("SAVINGS_ACC_STMNT_FREQ_OTR"));
			
			//CURRENT_ACC_STMNT_FREQ = ?, CURRENT_ACC_STMNT_FREQ_OTR = ?, STMNT_DISPTCH_MODE = ?, STMNT_DISPTCH_EMAIL = ?, CHEQUE_BOOK_PAGE = ?, "+
			preparedStatement.setString(38, formData.get("CURRENT_ACC_STMNT_FREQ"));
			preparedStatement.setString(39, formData.get("CURRENT_ACC_STMNT_FREQ_OTR"));
			preparedStatement.setString(40, formData.get("STMNT_DISPTCH_MODE"));
			preparedStatement.setString(41, formData.get("STMNT_DISPTCH_EMAIL"));
			preparedStatement.setString(42, formData.get("CHEQUE_BOOK_PAGE"));
			
			//INTRODUCTOR_RELN_YEAR = ?, INTRODUCTOR_NAME = ?, INTRODUCTOR_ID_NO = ?, INTRODUCTOR_ADDR = ?, INTRODUCTOR_ACC_NO = ?, "+
			preparedStatement.setString(43, formData.get("INTRODUCTOR_RELN_YEAR"));
			preparedStatement.setString(44, formData.get("INTRODUCTOR_NAME"));
			preparedStatement.setString(45, formData.get("INTRODUCTOR_ID_NO"));
			preparedStatement.setString(46, formData.get("INTRODUCTOR_ADDR"));
			preparedStatement.setString(47, formData.get("INTRODUCTOR_ACC_NO"));
			
			//INTRODUCTOR_DESG = ?, INTRODUCTOR_TEL_NO = ?, INTRODUCTOR_OFF_NO = ?, INTRODUCTOR_MOB_NO = ?, ACC_SIGN_TYPE = ?, "+
			preparedStatement.setString(48, formData.get("INTRODUCTOR_DESG"));
			preparedStatement.setString(49, formData.get("INTRODUCTOR_TEL_NO"));
			preparedStatement.setString(50, formData.get("INTRODUCTOR_OFF_NO"));
			preparedStatement.setString(51, formData.get("INTRODUCTOR_MOB_NO"));
			preparedStatement.setString(52, formData.get("ACC_SIGN_TYPE"));
			
			//ACC_SIGN_TYPE_OTR = ?, MUDARABA_AAGGR_DATE = TO_DATE(?,'DD/MM/YYYY'), MUDARABA_AGGR_PLCE = ?, MUDARABA_AGGR_1 = ?, MUDARABA_AGGR_2 = ?, "+
			preparedStatement.setString(53, formData.get("ACC_SIGN_TYPE_OTR"));
			preparedStatement.setString(54, formData.get("MUDARABA_AAGGR_DATE"));
			preparedStatement.setString(55, formData.get("MUDARABA_AGGR_PLCE"));
			preparedStatement.setString(56, formData.get("MUDARABA_AGGR_1"));
			preparedStatement.setString(57, formData.get("MUDARABA_AGGR_2"));
			
			//MUDARABA_AGGR_3 = ?, PSR_ACC_TYPE_1 = ?, PSR_ACC_TYPE_1_OTR = ?, PSR_BANK_1 = ?, PSR_CUSTOMER_1 = ?, "+
			preparedStatement.setString(58, formData.get("MUDARABA_AGGR_3"));
			preparedStatement.setString(59, formData.get("PSR_ACC_TYPE_1"));
			preparedStatement.setString(60, formData.get("PSR_ACC_TYPE_1_OTR"));
			preparedStatement.setString(61, formData.get("PSR_BANK_1"));
			preparedStatement.setString(62, formData.get("PSR_CUSTOMER_1"));
			
			//PSR_ACC_TYPE_2 = ?, PSR_ACC_TYPE_2_OTR = ?, PSR_BANK_2 = ?, PSR_CUSTOMER_2 = ?, ACC_CANVASSED_BY_EMP_NAME = ?, "+
			preparedStatement.setString(63, formData.get("PSR_ACC_TYPE_2"));
			preparedStatement.setString(64, formData.get("PSR_ACC_TYPE_2_OTR"));
			preparedStatement.setString(65, formData.get("PSR_BANK_2"));
			preparedStatement.setString(66, formData.get("PSR_CUSTOMER_2"));
			preparedStatement.setString(67, formData.get("ACC_CANVASSED_BY_EMP_NAME"));
			
			//ACC_CANVASSED_BY_EMP_NO = ?, ACC_CANVASSED_BY_BRANCH = ?, TERM_INVST_CERT_NO = ?, TERM_INVST_CERT_ISS_DATE = ?, TERM_INVST_TAX_NO = ?, "+
			preparedStatement.setString(68, formData.get("ACC_CANVASSED_BY_EMP_NO"));
			preparedStatement.setString(69, formData.get("ACC_CANVASSED_BY_BRANCH"));
			preparedStatement.setString(70, formData.get("TERM_INVST_CERT_NO"));
			preparedStatement.setString(71, formData.get("TERM_INVST_CERT_ISS_DATE"));
			preparedStatement.setString(72, formData.get("TERM_INVST_TAX_NO"));
			
			preparedStatement.setString(73, formData.get("INCOME_DET"));
			preparedStatement.setString(74, formData.get("ACCOUNT_WITHDRAWAL"));
			
			preparedStatement.setString(75, formData.get("BRNCH_APPROVL_ACC_OPND_DATE"));
			preparedStatement.setString(76, formData.get("BRNCH_APPROVL_ACC_OPND_BY"));
			preparedStatement.setString(77, formData.get("BRNCH_APPROVL_AUTH_OFF"));
			preparedStatement.setString(78, formData.get("BRNCH_APPROVL_AUDT_OFF"));
			//
			preparedStatement.setString(79, UPDATEDBY);
			preparedStatement.setString(80, cifNumber);
			preparedStatement.setString(81, accNumber);
			
			int x = preparedStatement.executeUpdate();
			if(x == 1){
				message = "Account details has been saved successfully";
				updateCIFAccountStatus(caseNo, cifNumber, accNumber, UPDATEDBY, status, message);	
				saveAuditLog(caseNo, cifNumber, accNumber, message, UPDATEDBY, status);
			}
		}catch(Exception e){
			log.error("Error while saving form data : "+e.getMessage());
			e.printStackTrace();
			message = "Saved Failed";
			saveAuditLog(caseNo, cifNumber, accNumber, message+e.toString(), UPDATEDBY, "E");
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		returnObject.put("MESSAGE", message);
		return returnObject;
	}
	
	
	
	private void updateCIFAccountStatus(String caseNo, String cifNumber, String accountNumber, String updatedBy, String status, String remark) throws Exception{
		Connection connection = getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareStatement("UPDATE "+schemaName+"TB_ACCOUNTOPENINGFORMLOG SET DATA_UPDATED_BY = ?, DATA_UPDATE_TIMESTAMP = SYSTIMESTAMP, STATUS = ?, UPDATETIMESTAMP = SYSTIMESTAMP WHERE CASENO = ? ");
			preparedStatement.setString(1, updatedBy);
			preparedStatement.setString(2, status);
			preparedStatement.setString(3, caseNo);
			preparedStatement.executeUpdate();
		}catch(Exception e){
			log.error("Error while updating status : "+e.getMessage());
			e.printStackTrace();
			throw e;
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
	}
	
	public void saveAuditLog(String caseNo, String cifNo, String accNo, String message, String updatedBy, String status){
		Connection connection = getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareStatement("INSERT INTO "+schemaName+"TB_AOFAUDITLOG(CASENO, CIF_NO, ACCOUNT_NO, STATUS, MESSAGE, UPDATEDBY, UPDATETIMESTAMP) VALUES(?,?,?,?,?,?,SYSTIMESTAMP)" );
			preparedStatement.setString(1, caseNo);
			preparedStatement.setString(2, cifNo);
			preparedStatement.setString(3, accNo);
			preparedStatement.setString(4, status);
			preparedStatement.setString(5, message);
			preparedStatement.setString(6, updatedBy);
			preparedStatement.executeUpdate();
		}catch(Exception e){
			log.error("Error while updating status : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
	}
	
	public String uploadFormDocument(String caseNo, String cifNo, String accountNo, String docName, String fileName, File file, String status, String uploadBy){
		String returnMessage = "";
		FileInputStream fileInputStream = null;
		Connection connection = getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
	        byte[] bFile = new byte[(int) file.length()];
	        fileInputStream = new FileInputStream(file);
		    fileInputStream.read(bFile);
		    
			preparedStatement = connection.prepareStatement("INSERT INTO "+schemaName+"TB_AOFDOCUPLOAD(CASENO, UPLOAD_REF_NO,CIF_NO,ACCOUNT_NO,DOC_NAME,FILENAME,FILECONTENT,UPLOADBY,UPLOADTIMESTAMP) VALUES(?,?,?,?,?,?,?,?,SYSTIMESTAMP)");
			preparedStatement.setString(1, caseNo);
			preparedStatement.setInt(2, getUploadSequenceNo());
			preparedStatement.setString(3, cifNo);
			preparedStatement.setString(4, accountNo);
			preparedStatement.setString(5, docName);
			preparedStatement.setString(6, fileName);
			preparedStatement.setBytes(7, bFile);
			preparedStatement.setString(8, uploadBy);
			preparedStatement.executeUpdate();
			returnMessage = "File "+docName+" uploaded successfully";
			updateCIFAccountStatus(caseNo, cifNo, accountNo, uploadBy, status, returnMessage);
			saveAuditLog(caseNo, cifNo, accountNo, returnMessage, uploadBy, status);
		}catch(Exception e){
			returnMessage = "Error while uploading file. ";
			log.error("Error while uploading file : "+e.getMessage());
			e.printStackTrace();
			saveAuditLog(caseNo, cifNo, accountNo, returnMessage+e.toString(), uploadBy, status);
		}finally{
			try{
				fileInputStream.close();
			}catch(Exception e){}			
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return returnMessage;
	}
	
	public int getUploadSequenceNo(){
		int seq_no = 0;
		Connection connection = getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareStatement("SELECT "+schemaName+"SEQ_AOFDOCUPLOAD.NEXTVAL UPLOADSEQNO FROM DUAL");
			resultSet = preparedStatement.executeQuery();
			if (resultSet.next()) {
				seq_no = resultSet.getInt("UPLOADSEQNO");
			}
		}catch(Exception e){
			log.error("Error while getting upload sequence : "+e.getMessage());
			e.printStackTrace();
		}finally{			
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return seq_no;
	}
	
	public Map<String, Object> downloadFormUploadFile(String uploadRefNo){
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Connection connection = getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareStatement("SELECT DOC_NAME, FILENAME, FILECONTENT FROM "+schemaName+"TB_AOFDOCUPLOAD WHERE UPLOAD_REF_NO = ?");
			preparedStatement.setInt(1, Integer.parseInt(uploadRefNo));
			resultSet = preparedStatement.executeQuery();
			if(resultSet.next()){
				resultMap.put("DOC_NAME", resultSet.getString("DOC_NAME"));
				resultMap.put("FILENAME", resultSet.getString("FILENAME"));
				resultMap.put("FILECONTENT", resultSet.getBinaryStream("FILECONTENT"));
			}
		}catch(Exception e){
			log.error("Error while downloading file : "+e.getMessage());
			e.printStackTrace();
		}finally{			
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return resultMap;
	}
	
	public String saveValueAddedService(String caseNo, Map<String, String> formData, String UPDATEDBY, String status){
		Connection connection = getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String message = "";
		String sql = "UPDATE "+schemaName+"TB_VALUE_ADDED_SERVICES "+
					  "   SET CARD_TYPE = ?, NAME_ON_CARD = ?, OTHER_LINKED_ACCOUNT_NO = ?, ENABLE_EBANKING = ?, EBANKING_USERNAME_1 = ?, "+
					  "       EBANKING_USERNAME_2 = ?, EBANKING_USERNAME_3 = ?, ENABLE_SMS_ALERT = ?, SMS_ALERT_MOBILE_NO =?, "+
					  "		  ACC_HLDR_MOTHER_MAIDEN_NAME = ?, UPDATEDBY = ?, UPDATETIMESTAMP = SYSTIMESTAMP "+
					  " WHERE CIF_NO = ? "+
					  "   AND ACCOUNT_NO = ? "+
					  "   AND LINE_NO = ?";
		try{
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, formData.get("CARD_TYPE"));
			preparedStatement.setString(2, formData.get("NAME_ON_CARD"));
			preparedStatement.setString(3, formData.get("OTHER_LINKED_ACCOUNT_NO"));
			preparedStatement.setString(4, formData.get("ENABLE_EBANKING"));
			preparedStatement.setString(5, formData.get("EBANKING_USERNAME_1"));
			
			preparedStatement.setString(6, formData.get("EBANKING_USERNAME_2"));
			preparedStatement.setString(7, formData.get("EBANKING_USERNAME_3"));
			preparedStatement.setString(8, formData.get("ENABLE_SMS_ALERT"));
			preparedStatement.setString(9, formData.get("SMS_ALERT_MOBILE_NO"));
			
			preparedStatement.setString(10, formData.get("ACC_HLDR_MOTHER_MAIDEN_NAME"));
			preparedStatement.setString(11, UPDATEDBY);
				
			preparedStatement.setString(12, formData.get("CIF_NO"));
			preparedStatement.setString(13, formData.get("ACCOUNT_NO"));
			preparedStatement.setString(14, formData.get("LINE_NO"));
			int x = preparedStatement.executeUpdate();
			if(x != 0){
				message = "Value added service Successfully updated";
				updateCIFAccountStatus(caseNo, formData.get("CIF_NO"), formData.get("ACCOUNT_NO"), UPDATEDBY, status, message);
				saveAuditLog(caseNo, formData.get("CIF_NO"), formData.get("ACCOUNT_NO"), message+" for line no "+formData.get("LINE_NO"), UPDATEDBY, status);
			}else{
				message = "Value added service updatation failed";
			}
		}catch(Exception e){
			message = "Error ocurred while saving value added service for line no "+formData.get("LINE_NO")+" : "+e.toString();
			saveAuditLog(caseNo, formData.get("CIF_NO"), formData.get("ACCOUNT_NO"), message, UPDATEDBY, status);
			log.error("Error while downloading file : "+e.getMessage());
			e.printStackTrace();
		}finally{			
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return message;
	}
	
	public String saveAccountHolderDetails(String caseNo, Map<String, String> formData, String accountHolderType, String UPDATEDBY, String status, String lineNumber){
		String tableName = ""+schemaName+"TB_CIF";
		if(accountHolderType.equals("JOINT")){
			tableName = ""+schemaName+"TB_CIF_JOINT_DET";
		}
		String message = "";
				
		String sql = "UPDATE "+tableName+" "+
					 "   SET RELATION_WITH_PRIMARY = ?, FMLY_RELATION_WITH_PRIMARY = ?, RELATION_WITH_PRIMARY_OTR = ?, TITLE = ?, TITLE_OTR = ?, "+
					 "		 FULLNAME = ?, OTHERNAME = ?, GENDER = ?, MARITAL_STATUS = ?, FIRST_NATION_CODE = ?, "+
					 "		 SECOND_NATION_CODE = ?, CURRENT_RESIDENT = ?, PREV_NATION_CODE = ?, PREV_NATION_RES_FROM = TO_DATE(?, 'DD/MM/YYYY'), PREV_NATION_RES_TO = TO_DATE(?, 'DD/MM/YYYY'), "+
					 "		 ID_TYPE = ?, ID_TYPE_OTR = ?, ID_NO = ?, ID_ISSUE_DATE = TO_DATE(?, 'DD/MM/YYYY'), ID_EXPIR_DATE = TO_DATE(?, 'DD/MM/YYYY'), "+
					 "		 BIRTH_DATE = TO_DATE(?, 'DD/MM/YYYY'), BIRTH_PLACE = ?, BIRTH_CERT_NO = ?, BIRTH_CERT_ISSUE_DATE = TO_DATE(?, 'DD/MM/YYYY'), ADDRESS_LINE_1 = ?, "+
					 "		 ADDRESS_LINE_2 = ?, ADDRESS_LINE_3 = ?, PREM_ADDRESS_STATUS = ?, CORS_ADDRESS_LINE_1 = ?, CORS_ADDRESS_LINE_2 = ?, "+
					 "		 CORS_ADDRESS_LINE_3 = ?, REG_NUMBER = ?, TAX_TIN_NO = ?, CONTACT_RES_NO = ?, CONTACT_OFF_NO = ?, "+
					 "		 CONTACT_MOB_NO = ?, CONTACT_FAX_NO = ?, EMAIL = ?, WEBSITE = ?, KEY_CONTACT_1_NAME = ?, "+
					 "		 KEY_CONTACT_1_DESG = ?, KEY_CONTACT_1_TEL = ?, KEY_CONTACT_1_MOB = ?, KEY_CONTACT_1_EMAIL = ?, KEY_CONTACT_1_IDNO = ?, KEY_CONTACT_1_COMMENTS = ?, KEY_CONTACT_2_NAME = ?, "+
					 "		 KEY_CONTACT_2_DESG = ?, KEY_CONTACT_2_TEL = ?, KEY_CONTACT_2_MOB = ?, KEY_CONTACT_2_EMAIL = ?, KEY_CONTACT_2_IDNO = ?, KEY_CONTACT_2_COMMENTS = ?, OCCUPATION = ?, "+
					 "		 DESIGNATION = ?, OWNERSHIP_PER = ?, EMPLOYER_NAME = ?, EMPLOYMENT_FROM = TO_DATE(?, 'DD/MM/YYYY'), EMPLOYMENT_TO = TO_DATE(?, 'DD/MM/YYYY'), "+
					 "		 EMPLOYER_ADDRESS = ?, NATURE_OF_BUSINESS = ?, INCOME_DET = ?, PUBLIC_POSITION_HELD = ?, OTHER_CONN_BUSINESS = ?, SPOUSE_NAME = ?, "+
					 "		 SPOUSE_EMP_DESG = ?, ASSET_RES_PROP = ?, ASSET_RES_PROP_VAL = ?, ASSET_MOTOR_VECH = ?, ASSET_MOTOR_VECH_VAL = ?, "+
					 "		 ASSET_LAND_BUILD = ?, ASSET_LAND_BUILD_VAL = ?, ASSET_INSVT_SHARES = ?, ASSET_INSVT_SHARES_VAL = ?, ASSET_OTHER = ?, "+
					 "		 ASSET_OTHER_VAL = ?, TAX_PAYER = ?, TAX_FILE_NO = ?, TAX_DECLR_SUBMITTED = ?, TAX_DECLR_SUBMITTED_YEAR = ?, "+
					 "		 DUAL_CITIZEN = ?, DUAL_CITIZEN_NATION_CODE = ?, REGULR_TRVL_RIMIT = ?, REGULR_TRVL_RIMIT_NATION_CODE = ?, FRGN_PWR_ATRNY = ?, "+
					 "		 FRGN_PWR_ATRNY_NATION_CODE = ?, PUR_IN_SL = ?, UPDATEDBY = ?, UPDATETIMESTAMP = SYSTIMESTAMP, "+
					 "		 EXIST_BANK_ACC_NO_1 = ?, EXIST_BANK_ACC_TYPE_1 = ?, "+
					 "		 EXIST_BANK_ACC_TYPE_1_OTR = ?, EXIST_BANK_ACC_BRANCH_1 = ?, EXIST_BANK_ACC_NO_2 = ?, EXIST_BANK_ACC_TYPE_2 = ?, EXIST_BANK_ACC_TYPE_2_OTR = ?, "+
					 "		 EXIST_BANK_ACC_BRANCH_2 = ?, EXIST_OTHER_ACC_NO_1 = ?, EXIST_OTHER_ACC_TYPE_1 = ?, EXIST_OTHER_ACC_TYPE_1_OTR = ?, EXIST_OTHER_ACC_BRANCH_1 = ?, "+
					 "		 EXIST_OTHER_ACC_NO_2 = ?, EXIST_OTHER_ACC_TYPE_2 = ?, EXIST_OTHER_ACC_TYPE_2_OTR = ?, EXIST_OTHER_ACC_BRANCH_2 = ?, "+
					 "		 NATURE_PURPOSE_BUSINESS_M = ?, NATURE_PURPOSE_BUSINESS_R = ?, NATURE_PURPOSE_BUSINESS_CR = ?, NATURE_PURPOSE_BUSINESS_WT = ?, NATURE_PURPOSE_BUSINESS_P = ?, "+
					 "		 NATURE_PURPOSE_BUSINESS_ST = ?, NATURE_PURPOSE_BUSINESS_ST_N = ?, NATURE_PURPOSE_BUSINESS_IE = ?, NATURE_PURPOSE_BUSINESS_PS = ?, NATURE_PURPOSE_BUSINESS_OTR = ?, "+
					 "		 NATURE_PURPOSE_BUSINESS_OTR_N = ?, EXISTING_FACILITIES_OD = ?, EXISTING_FACILITIES_IEF = ?, EXISTING_FACILITIES_L = ?, EXISTING_FACILITIES_OTR = ?, "+
					 "		 EXISTING_FACILITIES_OTR_NAME = ?, SUBSIDIARY_ASSOCIATION_ORG = ?, SUBSIDIARY_ORG_OF = ?, ASSOCIATION_ORG_OF = ?, ANNUAL_TUENOVER_CURRYEAR = ?, "+
					 "		 ANNUAL_TUENOVER_PREVYEAR = ?, NETPROFIT_CURRYEAR = ?, NETPROFIT_PREVYEAR = ?, ACCUMULATED_PROFIT_CURRYEAR = ?, ACCUMULATED_PROFIT_PREVYEAR = ?, "+
					 "		 AUDIT_FINANCIAL_STATEMENT_A = ?, PORPOSE_OF_ACCOUNT_SA = ?, PORPOSE_OF_ACCOUNT_BT = ?, PORPOSE_OF_ACCOUNT_LR = ?, PORPOSE_OF_ACCOUNT_SCW = ?, "+
					 "		 PORPOSE_OF_ACCOUNT_SPI = ?, PORPOSE_OF_ACCOUNT_FIR = ?, PORPOSE_OF_ACCOUNT_IP = ?, PORPOSE_OF_ACCOUNT_ST = ?, PORPOSE_OF_ACCOUNT_UBP = ?, "+
					 "		 PORPOSE_OF_ACCOUNT_UF = ?, PORPOSE_OF_ACCOUNT_OT = ?, PORPOSE_OF_ACCOUNT_OTR = ?, SOURCE_OF_FUND_S = ?, SOURCE_OF_FUND_B = ?, SOURCE_OF_FUND_FR = ?, "+
					 "		 SOURCE_OF_FUND_EP = ?, SOURCE_OF_FUND_IP = ?, SOURCE_OF_FUND_D = ?, SOURCE_OF_FUND_CI = ?, SOURCE_OF_FUND_OT = ?, SOURCE_OF_FUND_OTR = ?, ACCOUNT_DEPOSITE = ?, ACCOUNT_WITHDRAWAL = ?, "+
					 "		 INITIAL_DEPOSITE = ?, RISK_RATING_FINAL = ?, RISK_RATING_FINAL_VALUE = ?, RISK_RATING_CAT4 = ?, RISK_RATING_CAT3 = ?, RISK_RATING_CAT2 = ?, RISK_RATING_CAT1 = ?, "+
					 "		 RISK_RATING_CAT4LOW1 = ?, RISK_RATING_CAT4MID1 = ?, RISK_RATING_CAT4HIGH1 = ?, RISK_RATING_CAT4LOW2 = ?, RISK_RATING_CAT4MID2 = ?, "+
					 "		 RISK_RATING_CAT4HIGH2 = ?, RISK_RATING_CAT5 = ? "+
					 " WHERE CIF_NO = ? ";
		if(accountHolderType.equals("JOINT")){
			sql = sql + " AND LINE_NO = '"+lineNumber+"'";
		}
		
		Connection connection = getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareStatement(sql);
			
			//RELATION_WITH_PRIMARY = ?, FMLY_RELATION_WITH_PRIMARY = ?, RELATION_WITH_PRIMARY_OTR = ?, TITLE = ?, TITLE_OTR = ?, "+
			preparedStatement.setString(1, formData.get("RELATION_WITH_PRIMARY"));
			preparedStatement.setString(2, formData.get("FMLY_RELATION_WITH_PRIMARY"));
			preparedStatement.setString(3, formData.get("RELATION_WITH_PRIMARY_OTR"));
			preparedStatement.setString(4, formData.get("TITLE"));
			preparedStatement.setString(5, formData.get("TITLE_OTR"));
			
			//FULLNAME = ?, OTHERNAME = ?, GENDER = ?, MARITAL_STATUS = ?, FIRST_NATION_CODE = ?, "+
			preparedStatement.setString(6, formData.get("FULLNAME"));
			preparedStatement.setString(7, formData.get("OTHERNAME"));
			preparedStatement.setString(8, formData.get("GENDER"));
			preparedStatement.setString(9, formData.get("MARITAL_STATUS"));
			preparedStatement.setString(10, formData.get("FIRST_NATION_CODE"));
			
			//SECOND_NATION_CODE = ?, CURRENT_RESIDENT = ?, PREV_NATION_CODE = ?, PREV_NATION_RES_FROM = TO_DATE(?, 'DD/MM/YYYY'), PREV_NATION_RES_TO = TO_DATE(?, 'DD/MM/YYYY'), "+
			preparedStatement.setString(11, formData.get("SECOND_NATION_CODE"));
			preparedStatement.setString(12, formData.get("CURRENT_RESIDENT"));
			preparedStatement.setString(13, formData.get("PREV_NATION_CODE"));
			preparedStatement.setString(14, formData.get("PREV_NATION_RES_FROM"));
			preparedStatement.setString(15, formData.get("PREV_NATION_RES_TO"));
			
			//ID_TYPE = ?, ID_TYPE_OTR = ?, ID_NO = ?, ID_ISSUE_DATE = TO_DATE(?, 'DD/MM/YYYY'), ID_EXPIR_DATE = TO_DATE(?, 'DD/MM/YYYY'), "+
			preparedStatement.setString(16, formData.get("ID_TYPE"));
			preparedStatement.setString(17, formData.get("ID_TYPE_OTR"));
			preparedStatement.setString(18, formData.get("ID_NO"));
			preparedStatement.setString(19, formData.get("ID_ISSUE_DATE"));
			preparedStatement.setString(20, formData.get("ID_EXPIR_DATE"));
			
			//BIRTH_DATE = TO_DATE(?, 'DD/MM/YYYY'), BIRTH_PLACE = ?, BIRTH_CERT_NO = ?, BIRTH_CERT_ISSUE_DATE = TO_DATE(?, 'DD/MM/YYYY'), ADDRESS_LINE_1 = ?, "+
			preparedStatement.setString(21, formData.get("BIRTH_DATE"));
			preparedStatement.setString(22, formData.get("BIRTH_PLACE"));
			preparedStatement.setString(23, formData.get("BIRTH_CERT_NO"));
			preparedStatement.setString(24, formData.get("BIRTH_CERT_ISSUE_DATE"));
			preparedStatement.setString(25, formData.get("ADDRESS_LINE_1"));
			
			//ADDRESS_LINE_2 = ?, ADDRESS_LINE_3 = ?, PREM_ADDRESS_STATUS = ?, CORS_ADDRESS_LINE_1 = ?, CORS_ADDRESS_LINE_2 = ?, "+
			preparedStatement.setString(26, formData.get("ADDRESS_LINE_2"));
			preparedStatement.setString(27, formData.get("ADDRESS_LINE_3"));
			preparedStatement.setString(28, formData.get("PREM_ADDRESS_STATUS"));
			preparedStatement.setString(29, formData.get("CORS_ADDRESS_LINE_1"));
			preparedStatement.setString(30, formData.get("CORS_ADDRESS_LINE_2"));

			//CORS_ADDRESS_LINE_3 = ?, REG_NUMBER = ?, TAX_TIN_NO = ?, CONTACT_RES_NO = ?, CONTACT_OFF_NO = ?, "+
			preparedStatement.setString(31, formData.get("CORS_ADDRESS_LINE_3"));
			preparedStatement.setString(32, formData.get("REG_NUMBER"));
			preparedStatement.setString(33, formData.get("TAX_TIN_NO"));
			preparedStatement.setString(34, formData.get("CONTACT_RES_NO"));
			preparedStatement.setString(35, formData.get("CONTACT_OFF_NO"));
			
			//CONTACT_MOB_NO = ?, CONTACT_FAX_NO = ?, EMAIL = ?, WEBSITE = ?, KEY_CONTACT_1_NAME = ?, "+
			preparedStatement.setString(36, formData.get("CONTACT_MOB_NO"));
			preparedStatement.setString(37, formData.get("CONTACT_FAX_NO"));
			preparedStatement.setString(38, formData.get("EMAIL"));
			preparedStatement.setString(39, formData.get("WEBSITE"));
			preparedStatement.setString(40, formData.get("KEY_CONTACT_1_NAME"));
			
			//KEY_CONTACT_1_DESG = ?, KEY_CONTACT_1_TEL = ?, KEY_CONTACT_1_MOB = ?, KEY_CONTACT_1_EMAIL = ?, KEY_CONTACT_1_IDNO = ?, KEY_CONTACT_1_COMMENTS = ?, KEY_CONTACT_2_NAME = ?, "+
			preparedStatement.setString(41, formData.get("KEY_CONTACT_1_DESG"));
			preparedStatement.setString(42, formData.get("KEY_CONTACT_1_TEL"));
			preparedStatement.setString(43, formData.get("KEY_CONTACT_1_MOB"));
			preparedStatement.setString(44, formData.get("KEY_CONTACT_1_EMAIL"));
			preparedStatement.setString(45, formData.get("KEY_CONTACT_1_IDNO"));
			preparedStatement.setString(46, formData.get("KEY_CONTACT_1_COMMENTS"));
			preparedStatement.setString(47, formData.get("KEY_CONTACT_2_NAME"));
			
			//KEY_CONTACT_2_DESG = ?, KEY_CONTACT_2_TEL = ?, KEY_CONTACT_2_MOB = ?, KEY_CONTACT_2_EMAIL = ?, KEY_CONTACT_2_IDNO = ?, KEY_CONTACT_2_COMMENTS = ?, OCCUPATION = ?, "+
			preparedStatement.setString(48, formData.get("KEY_CONTACT_2_DESG"));
			preparedStatement.setString(49, formData.get("KEY_CONTACT_2_TEL"));
			preparedStatement.setString(50, formData.get("KEY_CONTACT_2_MOB"));
			preparedStatement.setString(51, formData.get("KEY_CONTACT_2_EMAIL"));
			preparedStatement.setString(52, formData.get("KEY_CONTACT_2_IDNO"));
			preparedStatement.setString(53, formData.get("KEY_CONTACT_2_COMMENTS"));
			preparedStatement.setString(54, formData.get("OCCUPATION"));
			
			//DESIGNATION = ?, OWNERSHIP_PER = ?, EMPLOYER_NAME = ?, EMPLOYMENT_FROM = TO_DATE(?, 'DD/MM/YYYY'), EMPLOYMENT_TO = TO_DATE(?, 'DD/MM/YYYY'), "+
			preparedStatement.setString(55, formData.get("DESIGNATION"));
			preparedStatement.setString(56, formData.get("OWNERSHIP_PER"));
			preparedStatement.setString(57, formData.get("EMPLOYER_NAME"));
			preparedStatement.setString(58, formData.get("EMPLOYMENT_FROM"));
			preparedStatement.setString(59, formData.get("EMPLOYMENT_TO"));
			
			//EMPLOYER_ADDRESS = ?, INCOME_DET = ?, PUBLIC_POSITION_HELD = ?, OTHER_CONN_BUSINESS = ?, SPOUSE_NAME = ?, "+
			preparedStatement.setString(60, formData.get("EMPLOYER_ADDRESS"));
			preparedStatement.setString(61, formData.get("NATURE_OF_BUSINESS"));
			preparedStatement.setString(62, formData.get("INCOME_DET"));
			preparedStatement.setString(63, formData.get("PUBLIC_POSITION_HELD"));
			preparedStatement.setString(64, formData.get("OTHER_CONN_BUSINESS"));
			preparedStatement.setString(65, formData.get("SPOUSE_NAME"));
			
			//SPOUSE_EMP_DESG = ?, ASSET_RES_PROP = , ASSET_RES_PROP_VAL = ?, ASSET_MOTOR_VECH = ?, ASSET_MOTOR_VECH_VAL = ?, "+
			preparedStatement.setString(66, formData.get("SPOUSE_EMP_DESG"));
			preparedStatement.setString(67, formData.get("ASSET_RES_PROP"));
			preparedStatement.setString(68, formData.get("ASSET_RES_PROP_VAL"));
			preparedStatement.setString(69, formData.get("ASSET_MOTOR_VECH"));
			preparedStatement.setString(70, formData.get("ASSET_MOTOR_VECH_VAL"));
			
			//ASSET_LAND_BUILD = ?, ASSET_LAND_BUILD_VAL = ?, ASSET_INSVT_SHARES = ?, ASSET_INSVT_SHARES_VAL = ?, ASSET_OTHER = ?, "+
			preparedStatement.setString(71, formData.get("ASSET_LAND_BUILD"));
			preparedStatement.setString(72, formData.get("ASSET_LAND_BUILD_VAL"));
			preparedStatement.setString(73, formData.get("ASSET_INSVT_SHARES"));
			preparedStatement.setString(74, formData.get("ASSET_INSVT_SHARES_VAL"));
			preparedStatement.setString(75, formData.get("ASSET_OTHER"));
			
			//ASSET_OTHER_VAL = ?, TAX_PAYER = ?, TAX_FILE_NO = ?, TAX_DECLR_SUBMITTED = ?, TAX_DECLR_SUBMITTED_YEAR = ?, "+
			preparedStatement.setString(76, formData.get("ASSET_OTHER_VAL"));
			preparedStatement.setString(77, formData.get("TAX_PAYER"));
			preparedStatement.setString(78, formData.get("TAX_FILE_NO"));
			preparedStatement.setString(79, formData.get("TAX_DECLR_SUBMITTED"));
			preparedStatement.setString(80, formData.get("TAX_DECLR_SUBMITTED_YEAR"));
			
			//DUAL_CITIZEN = ?, DUAL_CITIZEN_NATION_CODE = ?, REGULR_TRVL_RIMIT = ?, REGULR_TRVL_RIMIT_NATION_CODE = ?, FRGN_PWR_ATRNY = ?, "+
			preparedStatement.setString(81, formData.get("DUAL_CITIZEN"));
			preparedStatement.setString(82, formData.get("DUAL_CITIZEN_NATION_CODE"));
			preparedStatement.setString(83, formData.get("REGULR_TRVL_RIMIT"));
			preparedStatement.setString(84, formData.get("REGULR_TRVL_RIMIT_NATION_CODE"));
			preparedStatement.setString(85, formData.get("FRGN_PWR_ATRNY"));
			
			//FRGN_PWR_ATRNY_NATION_CODE = ?, PUR_IN_SL = ?, UPDATEDBY = ?, UPDATETIMESTAMP = SYSTIMESTAMP "+
			preparedStatement.setString(86, formData.get("FRGN_PWR_ATRNY_NATION_CODE"));
			preparedStatement.setString(87, formData.get("PUR_IN_SL"));
			preparedStatement.setString(88, formData.get("UPDATEDBY"));
			
			preparedStatement.setString(89, formData.get("EXIST_BANK_ACC_NO_1"));
			preparedStatement.setString(90, formData.get("EXIST_BANK_ACC_TYPE_1"));
			
			//EXIST_BANK_ACC_TYPE_1_OTR = ?, EXIST_BANK_ACC_BRANCH_1 = ?, EXIST_BANK_ACC_NO_2 = ?, EXIST_BANK_ACC_TYPE_2 = ?, EXIST_BANK_ACC_TYPE_2_OTR = ?, "+
			preparedStatement.setString(91, formData.get("EXIST_BANK_ACC_TYPE_1_OTR"));
			preparedStatement.setString(92, formData.get("EXIST_BANK_ACC_BRANCH_1"));
			preparedStatement.setString(93, formData.get("EXIST_BANK_ACC_NO_2"));
			preparedStatement.setString(94, formData.get("EXIST_BANK_ACC_TYPE_2"));
			preparedStatement.setString(95, formData.get("EXIST_BANK_ACC_TYPE_2_OTR"));
			
			//EXIST_BANK_ACC_BRANCH_2 = ?, EXIST_OTHER_ACC_NO_1 = ?, EXIST_OTHER_ACC_TYPE_1 = ?, EXIST_OTHER_ACC_TYPE_1_OTR = ?, EXIST_OTHER_ACC_BRANCH_1 = ?, "+
			preparedStatement.setString(96, formData.get("EXIST_BANK_ACC_BRANCH_2"));
			preparedStatement.setString(97, formData.get("EXIST_OTHER_ACC_NO_1"));
			preparedStatement.setString(98, formData.get("EXIST_OTHER_ACC_TYPE_1"));
			preparedStatement.setString(99, formData.get("EXIST_OTHER_ACC_TYPE_1_OTR"));
			preparedStatement.setString(100, formData.get("EXIST_OTHER_ACC_BRANCH_1"));
			
			//EXIST_OTHER_ACC_NO_2 = ?, EXIST_OTHER_ACC_TYPE_2 = ?, EXIST_OTHER_ACC_TYPE_2_OTR = ?, EXIST_OTHER_ACC_BRANCH_2 = ?, INSTRUCTION_TO_BANK = ?, "+
			preparedStatement.setString(101, formData.get("EXIST_OTHER_ACC_NO_2"));
			preparedStatement.setString(102, formData.get("EXIST_OTHER_ACC_TYPE_2"));
			preparedStatement.setString(103, formData.get("EXIST_OTHER_ACC_TYPE_2_OTR"));
			preparedStatement.setString(104, formData.get("EXIST_OTHER_ACC_BRANCH_2"));
			
			preparedStatement.setString(105, formData.get("NATURE_PURPOSE_BUSINESS_M"));
			preparedStatement.setString(106, formData.get("NATURE_PURPOSE_BUSINESS_R"));
			preparedStatement.setString(107, formData.get("NATURE_PURPOSE_BUSINESS_CR"));
			preparedStatement.setString(108, formData.get("NATURE_PURPOSE_BUSINESS_WT"));
			preparedStatement.setString(109, formData.get("NATURE_PURPOSE_BUSINESS_P"));
			
			preparedStatement.setString(110, formData.get("NATURE_PURPOSE_BUSINESS_ST"));
			preparedStatement.setString(111, formData.get("NATURE_PURPOSE_BUSINESS_ST_N"));
			preparedStatement.setString(112, formData.get("NATURE_PURPOSE_BUSINESS_IE"));
			preparedStatement.setString(113, formData.get("NATURE_PURPOSE_BUSINESS_PS"));
			preparedStatement.setString(114, formData.get("NATURE_PURPOSE_BUSINESS_OTR"));
			
			preparedStatement.setString(115, formData.get("NATURE_PURPOSE_BUSINESS_OTR_N"));
			preparedStatement.setString(116, formData.get("EXISTING_FACILITIES_OD"));
			preparedStatement.setString(117, formData.get("EXISTING_FACILITIES_IEF"));
			preparedStatement.setString(118, formData.get("EXISTING_FACILITIES_L"));
			preparedStatement.setString(119, formData.get("EXISTING_FACILITIES_OTR"));
			
			preparedStatement.setString(120, formData.get("EXISTING_FACILITIES_OTR_NAME"));
			preparedStatement.setString(121, formData.get("SUBSIDIARY_ASSOCIATION_ORG"));
			preparedStatement.setString(122, formData.get("SUBSIDIARY_ORG_OF"));
			preparedStatement.setString(123, formData.get("ASSOCIATION_ORG_OF"));
			preparedStatement.setString(124, formData.get("ANNUAL_TUENOVER_CURRYEAR"));
			
			preparedStatement.setString(125, formData.get("ANNUAL_TUENOVER_PREVYEAR"));
			preparedStatement.setString(126, formData.get("NETPROFIT_CURRYEAR"));
			preparedStatement.setString(127, formData.get("NETPROFIT_PREVYEAR"));
			preparedStatement.setString(128, formData.get("ACCUMULATED_PROFIT_CURRYEAR"));
			preparedStatement.setString(129, formData.get("ACCUMULATED_PROFIT_PREVYEAR"));
			
			preparedStatement.setString(130, formData.get("AUDIT_FINANCIAL_STATEMENT_A"));
			preparedStatement.setString(131, formData.get("PORPOSE_OF_ACCOUNT_SA"));
			preparedStatement.setString(132, formData.get("PORPOSE_OF_ACCOUNT_BT"));
			preparedStatement.setString(133, formData.get("PORPOSE_OF_ACCOUNT_LR"));
			
			preparedStatement.setString(134, formData.get("PORPOSE_OF_ACCOUNT_SCW"));
			preparedStatement.setString(135, formData.get("PORPOSE_OF_ACCOUNT_SPI"));
			preparedStatement.setString(136, formData.get("PORPOSE_OF_ACCOUNT_FIR"));
			preparedStatement.setString(137, formData.get("PORPOSE_OF_ACCOUNT_IP"));
			preparedStatement.setString(138, formData.get("PORPOSE_OF_ACCOUNT_ST"));
			
			preparedStatement.setString(139, formData.get("PORPOSE_OF_ACCOUNT_UBP"));
			preparedStatement.setString(140, formData.get("PORPOSE_OF_ACCOUNT_UF"));
			preparedStatement.setString(141, formData.get("PORPOSE_OF_ACCOUNT_OT"));
			preparedStatement.setString(142, formData.get("PORPOSE_OF_ACCOUNT_OTR"));
			preparedStatement.setString(143, formData.get("SOURCE_OF_FUND_S"));
			
			preparedStatement.setString(144, formData.get("SOURCE_OF_FUND_B"));
			preparedStatement.setString(145, formData.get("SOURCE_OF_FUND_FR"));
			preparedStatement.setString(146, formData.get("SOURCE_OF_FUND_EP"));
			preparedStatement.setString(147, formData.get("SOURCE_OF_FUND_IP"));
			preparedStatement.setString(148, formData.get("SOURCE_OF_FUND_D"));
			
			preparedStatement.setString(149, formData.get("SOURCE_OF_FUND_CI"));
			preparedStatement.setString(150, formData.get("SOURCE_OF_FUND_OT"));
			preparedStatement.setString(151, formData.get("SOURCE_OF_FUND_OTR"));
			preparedStatement.setString(152, formData.get("ACCOUNT_DEPOSITE"));
			preparedStatement.setString(153, formData.get("ACCOUNT_WITHDRAWAL"));
			preparedStatement.setString(154, formData.get("INITIAL_DEPOSITE"));
			
			preparedStatement.setString(155, formData.get("RISK_RATING_FINAL"));
			preparedStatement.setString(156, formData.get("RISK_RATING_FINAL_VALUE"));
			preparedStatement.setString(157, formData.get("RISK_RATING_CAT4"));
			preparedStatement.setString(158, formData.get("RISK_RATING_CAT3"));
			preparedStatement.setString(159, formData.get("RISK_RATING_CAT2"));
			preparedStatement.setString(160, formData.get("RISK_RATING_CAT1"));
			
			preparedStatement.setString(161, formData.get("RISK_RATING_CAT4LOW1"));
			preparedStatement.setString(162, formData.get("RISK_RATING_CAT4MID1"));
			preparedStatement.setString(163, formData.get("RISK_RATING_CAT4HIGH1"));
			preparedStatement.setString(164, formData.get("RISK_RATING_CAT4LOW2"));
			preparedStatement.setString(165, formData.get("RISK_RATING_CAT4MID2"));
			preparedStatement.setString(166, formData.get("RISK_RATING_CAT4HIGH2"));
			preparedStatement.setString(167, formData.get("RISK_RATING_CAT5"));
			
			preparedStatement.setString(168, formData.get("CIF_NO"));
		
			int x = preparedStatement.executeUpdate();
			if(x != 0){
				message = "Account holder details successfully saved";
			}else{
				message = "Failed to save account holder details";
			}
			updateCIFAccountStatus(caseNo, formData.get("CIF_NO"), formData.get("ACCOUNT_NO"), UPDATEDBY, status, message);
			saveAuditLog(caseNo, formData.get("CIF_NO"), formData.get("ACCOUNT_NO"), message, UPDATEDBY, status);
		}catch(Exception e){
			message = "Error ocurred while saving account holder data : "+e.toString();
			saveAuditLog(caseNo, formData.get("CIF_NO"), formData.get("ACCOUNT_NO"), message, UPDATEDBY, status);
			log.error("Error while downloading file : "+e.getMessage());
			e.printStackTrace();
		}finally{			
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return message;
	}
	
	public List<Map<String, String>> getFormStatus(String userId, String fromDate, String toDate, String status, boolean isChecker){
		List<Map<String, String>> getFormStatus = new ArrayList<Map<String, String>>();
		String sql = "";
		
		if(isChecker){
			sql =    "SELECT A.CASENO CASENO, A.CIF_NO CIF_NO, C.LONG_DESC CIF_TYPE_NAME, A.ACCOUNT_NO ACCOUNT_NO, TO_CHAR(A.DATA_UPDATE_TIMESTAMP,'DD/MM/YYYY HH24:MI:SS') DATA_UPDATE_TIMESTAMP, "+
				 	 "		 CASE A.STATUS WHEN 'U' THEN 'Not Submitted' WHEN 'P' THEN 'Pending' WHEN 'A' THEN 'Approved' WHEN 'R' THEN 'Rejected' END STATUS "+
					 "  FROM "+schemaName+"TB_ACCOUNTOPENINGFORMLOG A, "+schemaName+"TB_CIF B "+
				 	 "  LEFT OUTER JOIN "+schemaName+"TB_CIF_TYPE C "+
					 "    ON B.CIF_TYPE = C.TYPE_CODE "+
				 	 " WHERE DATA_CHECKED_BY = '"+userId+"' "+
					 "   AND A.CIF_NO = B.CIF_NO "+
				 	 "   AND A.STATUS = ? ";
		}else{
			sql =    "SELECT A.CASENO CASENO, A.CIF_NO CIF_NO, C.LONG_DESC CIF_TYPE_NAME, A.ACCOUNT_NO ACCOUNT_NO, TO_CHAR(A.DATA_UPDATE_TIMESTAMP,'DD/MM/YYYY HH24:MI:SS') DATA_UPDATE_TIMESTAMP, "+
				 	 "		 CASE A.STATUS WHEN 'U' THEN 'Pending' WHEN 'P' THEN 'Submitted' WHEN 'A' THEN 'Approved' WHEN 'R' THEN 'Rejected' END STATUS "+
				 	 "  FROM "+schemaName+"TB_ACCOUNTOPENINGFORMLOG A, "+schemaName+"TB_CIF B "+
				 	 "  LEFT OUTER JOIN "+schemaName+"TB_CIF_TYPE C "+
					 "    ON B.CIF_TYPE = C.TYPE_CODE "+
				 	 " WHERE DATA_UPDATED_BY = '"+userId+"' "+
				 	 "   AND A.CIF_NO = B.CIF_NO "+
				 	 "   AND A.STATUS = ? ";
		}
		if(fromDate != null && fromDate.trim().length() > 0){
			sql =sql+"   AND A.UPDATETIMESTAMP >= TO_TIMESTAMP('"+fromDate+"','DD/MM/YYYY') ";
		}
		if(toDate != null && toDate.trim().length() > 0){
			sql =sql+"   AND A.UPDATETIMESTAMP < TO_TIMESTAMP('"+toDate+"','DD/MM/YYYY')+1 ";
		}
		sql = sql+   " ORDER BY A.UPDATETIMESTAMP DESC";
		// System.out.println("Search SQL: "+sql);
		Connection connection = getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, status);
			resultSet = preparedStatement.executeQuery();
			while (resultSet.next()) {
				Map<String, String> map = new HashMap<String, String>();
				map.put("CASE_NO", resultSet.getString("CASENO"));
				map.put("CIF_NO", resultSet.getString("CIF_NO"));
				map.put("CIF_TYPE_NAME", resultSet.getString("CIF_TYPE_NAME"));
				map.put("ACCOUNT_NO", resultSet.getString("ACCOUNT_NO"));
				map.put("DATA_UPDATE_TIMESTAMP", resultSet.getString("DATA_UPDATE_TIMESTAMP"));
				map.put("STATUS", resultSet.getString("STATUS"));
				getFormStatus.add(map);
			}
		}catch(Exception e){
			log.error("Error while getting form status : "+e.getMessage());
			e.printStackTrace();
		}finally{			
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return getFormStatus;
	}
	
	public Map<String, String> getFormStatus(String cifNumber, String accNumber){
		Map<String, String> formStatus = new HashMap<String, String>();
		String sql = "SELECT DATA_UPDATED_BY, TO_CHAR(DATA_UPDATE_TIMESTAMP,'DD/MM/YYYY HH24:MI:SS') DATA_UPDATE_TIMESTAMP, "+
					 "	     CASE STATUS WHEN 'U' THEN 'Not Submitted' WHEN 'P' THEN 'Pending' WHEN 'A' THEN 'Approved' WHEN 'R' THEN 'Rejected' END STATUS, "+
					 "		 DATA_CHECKED_BY, REMARKS, REJECTED_SECTION, DETAILS_REASON, TO_CHAR(DATA_CHECK_TIMESTAMP, 'DD/MM/YYYY HH24:MI:SS') DATA_CHECK_TIMESTAMP "+
					 "  FROM "+schemaName+"TB_ACCOUNTOPENINGFORMLOG "+
					 " WHERE CIF_NO = ?";
		if(accNumber != null && !"null".equals(accNumber)){
			sql =sql+"   AND ACCOUNT_NO = '"+accNumber+"'";
		}
		sql = sql +  " ORDER BY UPDATETIMESTAMP DESC";
		Connection connection = getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareCall(sql);
			preparedStatement.setString(1, cifNumber);
			resultSet = preparedStatement.executeQuery();
			if(resultSet.next()){
				formStatus.put("DATA_UPDATED_BY", resultSet.getString("DATA_UPDATED_BY"));
				formStatus.put("DATA_UPDATE_TIMESTAMP", resultSet.getString("DATA_UPDATE_TIMESTAMP"));
				formStatus.put("STATUS", resultSet.getString("STATUS"));
				formStatus.put("DATA_CHECKED_BY", resultSet.getString("DATA_CHECKED_BY"));
				formStatus.put("REMARKS", resultSet.getString("REMARKS"));
				formStatus.put("DETAILS_REASON", resultSet.getString("DETAILS_REASON"));
				formStatus.put("REJECTED_SECTION", resultSet.getString("REJECTED_SECTION"));
				formStatus.put("DATA_CHECK_TIMESTAMP", resultSet.getString("DATA_CHECK_TIMESTAMP"));
			}
		}catch(Exception e){
			log.error("Error while getting form status : "+e.getMessage());
			e.printStackTrace();
		}finally{			
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return formStatus;
	}
	
	public List<Map<String, String>> getFormAuditLog(String caseNo){
		List<Map<String, String>> auditLog = new ArrayList<Map<String, String>>();
		Connection connection = getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareCall("SELECT CIF_NO, ACCOUNT_NO, MESSAGE, UPDATEDBY, TO_CHAR(UPDATETIMESTAMP,'DD/MM/YYYY HH24:MI:SS') UPDATETIMESTAMP, "+
													   "       CASE STATUS WHEN 'U' THEN 'Not Submitted' WHEN 'P' THEN 'Pending' WHEN 'A' THEN 'Approved' WHEN 'R' THEN 'Rejected' END STATUS "+
													   "  FROM "+schemaName+"TB_AOFAUDITLOG WHERE CASENO = ? ORDER BY UPDATETIMESTAMP DESC");
			preparedStatement.setString(1, caseNo);
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()){
				Map<String, String> formStatus = new HashMap<String, String>();
				formStatus.put("CIF_NO", resultSet.getString("CIF_NO"));
				formStatus.put("ACCOUNT_NO", resultSet.getString("ACCOUNT_NO"));
				formStatus.put("MESSAGE", resultSet.getString("MESSAGE"));
				formStatus.put("UPDATEDBY", resultSet.getString("UPDATEDBY"));
				formStatus.put("UPDATETIMESTAMP", resultSet.getString("UPDATETIMESTAMP"));
				formStatus.put("STATUS", resultSet.getString("STATUS"));
				auditLog.add(formStatus);
			}
		}catch(Exception e){
			log.error("Error while getting form status : "+e.getMessage());
			e.printStackTrace();
		}finally{			
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return auditLog;
	}
	
	public String saveCheckerResponse(String caseNo, String cifNumber, String accountNo, String remark, String status, String checkedBy, String rejectedFileds, String reasonOfRejection){
		String response = "";
		String sql = "UPDATE "+schemaName+"TB_ACCOUNTOPENINGFORMLOG "+
					 "   SET STATUS = ?, DATA_CHECKED_BY = ?, DATA_CHECK_TIMESTAMP = SYSTIMESTAMP, REMARKS = ?, REJECTED_SECTION = ?, DETAILS_REASON = ?, UPDATETIMESTAMP = SYSTIMESTAMP "+
					 " WHERE CASENO = ? ";
				
		Connection connection = getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareCall(sql);
			preparedStatement.setString(1, status);
			preparedStatement.setString(2, checkedBy);
			preparedStatement.setString(3, remark);
			preparedStatement.setString(4, rejectedFileds);
			preparedStatement.setString(5, reasonOfRejection);
			preparedStatement.setString(6, caseNo);
			int i = preparedStatement.executeUpdate();
			if(i != 0){
				if(status.equals("A")){
					response = "Successfully approved";
				}else{
					response = "Successfully rejected";
				}
			}else{
				if(status.equals("A")){
					response = "Error occured while approving";
				}else{
					response = "Error occured while rejecting";
				}
			}
			
			if(status.equals("A"))
				saveAuditLog(caseNo, cifNumber, accountNo, "[Remark: "+remark+"]	[Response: "+response+"]", checkedBy, status);
			else
				saveAuditLog(caseNo, cifNumber, accountNo, "[Remark: "+remark+"] [RejectFields: "+reasonOfRejection+"] [Response: "+response+"]", checkedBy, status);
			
		}catch(Exception e){
			log.error("Error while getting form status : "+e.getMessage());
			e.printStackTrace();
		}finally{			
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return response;
	}
	
	public String deleteDocument(String caseNo, String cifNo, String accountNo, String docRefNo, String userCode){
		String str = "";
		Connection connection = getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareStatement("DELETE FROM "+schemaName+"TB_AOFDOCUPLOAD WHERE UPLOAD_REF_NO = ?");
			preparedStatement.setString(1, docRefNo);
			preparedStatement.executeUpdate();
			str = "1";
			updateCIFAccountStatus(caseNo, cifNo, accountNo, userCode, "U", "Document (RefNo: "+docRefNo+") removed");
			saveAuditLog(caseNo, cifNo, accountNo, "Document (RefNo: "+docRefNo+") removed", userCode, "U");
		}catch(Exception e){
			log.error("Error while deleting document : "+e.getMessage());
			str = "0";
			e.printStackTrace();
		}finally{			
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return str;
	}
	
	public String getServerFilePath(String serverFileRefNo){
		int seq_no = Integer.parseInt(serverFileRefNo);
		String path = "";
		Connection connection = getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareStatement("SELECT FILE_PATH FROM "+schemaName+"TB_AOF_SERVERFILES WHERE SEQ_NO = ?");
			preparedStatement.setInt(1, seq_no);
			resultSet = preparedStatement.executeQuery();
			if(resultSet.next()){
				path = resultSet.getString("FILE_PATH");
			}
		}catch(Exception e){
			log.error("Error while deleting document : "+e.getMessage());
			e.printStackTrace();
		}finally{			
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return path;
	}
	
	public void truncateServerFilesTable(){
		Connection connection = getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareStatement("TRUNCATE TABLE "+schemaName+"TB_AOF_SERVERFILES");
			preparedStatement.execute();
		}catch(Exception e){
			log.error("Error while truncating table : "+e.getMessage());
			e.printStackTrace();
		}finally{			
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
	}
	
	public int saveFetchedAccountOpeningMandateInfo(List<Map<String, String>> fetchedAOF){
		int max = 0;
		Connection connection = getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareStatement("SELECT MAX(SEQ_NO) SEQ_NO FROM "+schemaName+"TB_AOF_SERVERFILES");
			resultSet = preparedStatement.executeQuery();
			if(resultSet.next())
				max = resultSet.getInt("SEQ_NO");
			
			preparedStatement = connection.prepareStatement("INSERT INTO "+schemaName+"TB_AOF_SERVERFILES(SEQ_NO,ACCOUNT_NO,FILE_NAME,FILE_PATH) VALUES(?,?,?,?)");
			for(int i = 0; i < fetchedAOF.size(); i++){
				max++;
				Map<String, String> aofInfo = fetchedAOF.get(i);
				preparedStatement.setInt(1, max);
				preparedStatement.setString(2, aofInfo.get("ACCOUNT_NO"));
				preparedStatement.setString(3, aofInfo.get("FILE_NAME"));
				preparedStatement.setString(4, aofInfo.get("FILE_PATH"));
				preparedStatement.addBatch();
			}
			preparedStatement.executeBatch();
		}catch(Exception e){
			log.error("Error while saving fetched AOF info : "+e.getMessage());
			e.printStackTrace();
		}finally{			
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return max;
	}
	
	public void saveMandateFetchStatus(String startDate, String endDate, String path, String count, String updateBy){
		Connection connection = getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareStatement("INSERT INTO "+schemaName+"TB_AOF_MANDATEFETCHLOG(STARTDATE, ENDDATE, PARENTPATH, MANDATECOUNT, UPDATEDBY, UPDATETIMESTAMP)"+
															"VALUES (?,?,?,?,?,SYSTIMESTAMP)");
			preparedStatement.setString(1, startDate);
			preparedStatement.setString(2, endDate);
			preparedStatement.setString(3, path);
			preparedStatement.setString(4, count);
			preparedStatement.setString(5, updateBy);
			preparedStatement.executeUpdate();
		}catch(Exception e){
			log.error("Error while saving fetched AOF log : "+e.getMessage());
			e.printStackTrace();
		}finally{			
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
	}
	
	public List<Map<String, String>> getAOFFetchLog(){
		List<Map<String, String>> fetchLog = new ArrayList<Map<String, String>>();
		Connection connection = getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareStatement("SELECT STARTDATE, ENDDATE, PARENTPATH, MANDATECOUNT, UPDATEDBY FROM "+schemaName+"TB_AOF_MANDATEFETCHLOG ORDER BY UPDATETIMESTAMP DESC");
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()){
				Map<String, String> fatch = new HashMap<String, String>();
				fatch.put("STARTDATE", resultSet.getString("STARTDATE"));
				fatch.put("ENDDATE", resultSet.getString("ENDDATE"));
				fatch.put("PARENTPATH", resultSet.getString("PARENTPATH"));
				fatch.put("MANDATECOUNT", resultSet.getString("MANDATECOUNT"));
				fatch.put("UPDATEDBY", resultSet.getString("UPDATEDBY"));
				fetchLog.add(fatch);
			}
		}catch(Exception e){
			log.error("Error while saving fetched AOF log : "+e.getMessage());
			e.printStackTrace();
		}finally{			
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return fetchLog;
	}
	
	public int countCIFForAssign(String branchCode, String cifType, String cifNo, String accountNo, String excludeApproved){
		int count = 0;
		Connection connection = getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String sql = "SELECT COUNT(A.CIF_NO) CIF_COUNT"+
					 "  FROM "+schemaName+"TB_CIF A ";
		if(excludeApproved.equals("Y")){
			sql = sql+ " WHERE A.CIF_NO NOT IN (SELECT B.CIF_NO "+
					   "							FROM "+schemaName+"TB_ACCOUNTOPENINGFORMLOG B "+
					   "						   WHERE B.STATUS IN ('U','P','R','A')) ";
		}else{
			sql = sql+ " WHERE A.CIF_NO NOT IN (SELECT B.CIF_NO "+
					   "							FROM "+schemaName+"TB_ACCOUNTOPENINGFORMLOG B "+
					   "						   WHERE B.STATUS IN ('U','P','R')) ";
		}
					 
		//			 "   AND A.CIF_NO IN (SELECT Y.CIF_NO FROM TB_AOF_SERVERFILES X, TB_AMF Y WHERE X.ACCOUNT_NO = Y.ACCOUNT_NO) ";
		if(branchCode != null && branchCode.length() > 0)
			sql = sql + "AND A.CIF_BRANCHCODE = '"+branchCode+"'";
		if(cifType != null && cifType.length() > 0)
			sql = sql + "AND A.CIF_TYPE = '"+cifType+"'";
		if(cifNo != null && cifNo.length() > 0)
			sql = sql + "AND A.CIF_NO IN ('"+cifNo.replace(",", "','")+"')";
		if(accountNo != null && accountNo.length() > 0)
			sql = sql + "AND A.CIF_NO IN (SELECT CIF_NO FROM "+schemaName+"TB_AMF WHERE ACCOUNT_NO IN ('"+accountNo.replace(",", "','")+"'))";
		try{
			preparedStatement = connection.prepareStatement(sql);
			resultSet = preparedStatement.executeQuery();
			if(resultSet.next())
				count = resultSet.getInt("CIF_COUNT");
		}catch(Exception e){
			log.error("Error getting calculated CIF : "+e.getMessage());
			e.printStackTrace();
		}finally{			
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return count;
	}
	
	public Map<String, List<Map<String, String>>> getBranchCifTypeForAssignCIF(){
		Map<String, List<Map<String, String>>> branchCifType = new HashMap<String, List<Map<String, String>>>();
		List<Map<String, String>> branchList = new ArrayList<Map<String, String>>();
		List<Map<String, String>> cifTypeList = new ArrayList<Map<String, String>>();
		Connection connection = getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareStatement("SELECT BRANCHCODE, BRANCHNAME FROM "+schemaName+"TB_BRANCHMASTER");
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()){
				Map<String, String> branchDetails = new HashMap<String, String>();
				branchDetails.put("BRANCHCODE", resultSet.getString("BRANCHCODE"));
				branchDetails.put("BRANCHNAME", resultSet.getString("BRANCHNAME"));
				branchList.add(branchDetails);
			}
			
			preparedStatement = connection.prepareStatement("SELECT TYPE_CODE, LONG_DESC FROM TB_CIF_TYPE");
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()){
				Map<String, String> cifTypeDetails = new HashMap<String, String>();
				cifTypeDetails.put("TYPECODE", resultSet.getString("TYPE_CODE"));
				cifTypeDetails.put("TYPENAME", resultSet.getString("LONG_DESC"));
				cifTypeList.add(cifTypeDetails);
			}
		}catch(Exception e){
			log.error("Error while getting branchs and cif types : "+e.getMessage());
			e.printStackTrace();
		}finally{			
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		branchCifType.put("BRANCH", branchList);
		branchCifType.put("CIF_TYPE", cifTypeList);
		return branchCifType;
	}
	
	public Map<String, List<Map<String, String>>> getCheckerMakerCode(){
		Map<String, List<Map<String, String>>> checkerMakerCode = new HashMap<String, List<Map<String, String>>>();
		List<Map<String, String>> checker = new ArrayList<Map<String, String>>();
		List<Map<String, String>> maker = new ArrayList<Map<String, String>>();
		Connection connection = getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareStatement("SELECT A.USERCODE USERCODE, A.USERNAME USERNAME "+
															"  FROM "+schemaName+"TB_USER A, "+schemaName+"TB_USERGROUPMAPPING B "+
															" WHERE A.USERCODE = B.USERCODE "+
															"   AND B.GROUPCODE = 'CPUMaker'"+
															"   AND A.ISENABLED = 'Y'");
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()){
				Map<String, String> makerDetails = new HashMap<String, String>();
				makerDetails.put("USERCODE", resultSet.getString("USERCODE"));
				makerDetails.put("USERNAME", resultSet.getString("USERNAME"));
				maker.add(makerDetails);
			}
			
			preparedStatement = connection.prepareStatement("SELECT A.USERCODE USERCODE, A.USERNAME USERNAME "+
															"  FROM "+schemaName+"TB_USER A, "+schemaName+"TB_USERGROUPMAPPING B "+
															" WHERE A.USERCODE = B.USERCODE "+
															"   AND B.GROUPCODE = 'CPUChecker'"+
															"   AND A.ISENABLED = 'Y'");
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()){
				Map<String, String> checkerDetails = new HashMap<String, String>();
				checkerDetails.put("USERCODE", resultSet.getString("USERCODE"));
				checkerDetails.put("USERNAME", resultSet.getString("USERNAME"));
				checker.add(checkerDetails);
			}
		}catch(Exception e){
			log.error("Error while getting maker and checker users : "+e.getMessage());
			e.printStackTrace();
		}finally{			
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		checkerMakerCode.put("CHECKER", checker);
		checkerMakerCode.put("MAKER", maker);
		return checkerMakerCode;
	}
	
	public int assignCIF(String branchCode, String cifType, String cifNo, String accountNo, String noOfCase, String makerCode, String checkerCode, String excludeApproved){
		String sql = "INSERT INTO "+schemaName+"TB_ACCOUNTOPENINGFORMLOG( "+
					 "       CASENO, CIF_NO, ACCOUNT_NO, DATA_UPDATED_BY, DATA_UPDATE_TIMESTAMP, STATUS, "+
					 "		 DATA_CHECKED_BY, DATA_CHECK_TIMESTAMP, "+
					 "       REMARKS, REJECTED_SECTION, DETAILS_REASON, UPDATETIMESTAMP) "+
					 "SELECT SEQ_AOF_CASENO.NEXTVAL, A.CIF_NO CIF_NO, NULL ACCOUNT_NO, '"+makerCode+"' DATA_UPDATED_BY, "+
					 "		 NULL DATA_UPDATE_TIMESTAMP, 'U' STATUS, "+
					 "		 '"+checkerCode+"' DATA_CHECKED_BY, NULL DATA_CHECK_TIMESTAMP, "+
					 "       NULL REMARKS, NULL REJECTED_SECTION, NULL DETAILS_REASON, SYSTIMESTAMP UPDATETIMESTAMP "+
					 "  FROM "+schemaName+"TB_CIF A ";
		if(excludeApproved.equals("Y")){
			sql = sql+ " WHERE A.CIF_NO NOT IN (SELECT B.CIF_NO "+
					   "						  FROM "+schemaName+"TB_ACCOUNTOPENINGFORMLOG B "+
					   "						 WHERE B.STATUS IN ('U','P','R','A')) ";
		}else{
			sql = sql+ " WHERE A.CIF_NO NOT IN (SELECT B.CIF_NO "+
					   "						  FROM "+schemaName+"TB_ACCOUNTOPENINGFORMLOG B "+
					   "						 WHERE B.STATUS IN ('U','P','R')) ";
		}
		//			 "   AND A.CIF_NO IN (SELECT Y.CIF_NO FROM TB_AOF_SERVERFILES X, TB_AMF Y WHERE X.ACCOUNT_NO = Y.ACCOUNT_NO) ";
		if(branchCode != null && branchCode.length() > 0)
			sql = sql + "AND A.CIF_BRANCHCODE = '"+branchCode+"'";
		if(cifType != null && cifType.length() > 0)
			sql = sql + "AND A.CIF_TYPE = '"+cifType+"'";
		if(cifNo != null && cifNo.length() > 0)
			sql = sql + "AND A.CIF_NO IN ('"+cifNo.replace(",", "','")+"')";
		if(accountNo != null && accountNo.length() > 0)
			sql = sql + "AND A.CIF_NO IN (SELECT CIF_NO FROM "+schemaName+"TB_AMF WHERE ACCOUNT_NO IN ('"+accountNo.replace(",", "','")+"'))";
		sql = sql + "    AND ROWNUM <= "+noOfCase;
		int assigned = 0;
		Connection connection = getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareStatement(sql);
			assigned = preparedStatement.executeUpdate();
		}catch(Exception e){
			log.error("Error while assigning CIF to users : "+e.getMessage());
			e.printStackTrace();
		}finally{			
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return assigned;
	}
	
	public List<Map<String, String>> checkCasesForReAssign(String fromDate, String toDate, String branchCode, String cifType, String cifNumber, 
			String accountNo, String makerCode, String checkerCode){
		List<Map<String, String>> caseList = new ArrayList<Map<String, String>>();
		Connection connection = getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String sql = "SELECT A.CASENO CASENO, A.CIF_NO CIF_NO, B.FULLNAME FULLNAME, C.LONG_DESC CIF_TYPE_NAME, A.DATA_UPDATED_BY DATA_UPDATED_BY, A.DATA_CHECKED_BY DATA_CHECKED_BY, "+
					 "       CASE A.STATUS WHEN 'U' THEN 'Pending with Maker' WHEN 'P' THEN 'Pending with Checker' ELSE 'Rejected' END STATUS, "+
					 "       TO_CHAR(A.UPDATETIMESTAMP,'DD/MM/YYYY HH24:MI:SS') UPDATETIMESTAMP "+
					 "  FROM "+schemaName+"TB_ACCOUNTOPENINGFORMLOG A, "+schemaName+"TB_CIF B "+
					 "  LEFT OUTER JOIN TB_CIF_TYPE C "+
					 "    ON B.CIF_TYPE = C.TYPE_CODE "+
					 " WHERE A.CIF_NO = B.CIF_NO "+
					 "   AND A.STATUS IN ('U','P','R') ";
		if(branchCode != null && branchCode.length() > 0)
			sql = sql + "AND B.CIF_BRANCHCODE = '"+branchCode+"'";
		if(cifType != null && cifType.length() > 0)
			sql = sql + "AND B.CIF_TYPE = '"+cifType+"'";
		if(cifNumber != null && cifNumber.length() > 0)
			sql = sql + "AND A.CIF_NO IN ('"+cifNumber.replace(",", "','")+"')";
		if(accountNo != null && accountNo.length() > 0)
			sql = sql + "AND A.CIF_NO IN (SELECT CIF_NO FROM "+schemaName+"TB_AMF WHERE ACCOUNT_NO IN ('"+accountNo.replace("'", "','")+"'))";
		if(makerCode != null && makerCode.length() > 0)
			sql = sql + "AND A.DATA_UPDATED_BY = '"+makerCode+"'";
		if(checkerCode != null && checkerCode.length() > 0)
			sql = sql + "AND A.DATA_CHECKED_BY = '"+checkerCode+"'";
		// System.out.println("SQL : "+sql);
		try{
			preparedStatement = connection.prepareStatement(sql);
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()){
				Map<String, String> caseDetails = new HashMap<String, String>();
				caseDetails.put("CASENO", resultSet.getString("CASENO"));
				caseDetails.put("CIF_NO", resultSet.getString("CIF_NO"));
				caseDetails.put("FULLNAME", resultSet.getString("FULLNAME"));
				caseDetails.put("CIF_TYPE", resultSet.getString("CIF_TYPE_NAME"));
				caseDetails.put("MAKER", resultSet.getString("DATA_UPDATED_BY"));
				caseDetails.put("CHECKER", resultSet.getString("DATA_CHECKED_BY"));
				caseDetails.put("STATUS", resultSet.getString("STATUS"));
				caseDetails.put("UPDATETIMESTAMP", resultSet.getString("UPDATETIMESTAMP"));
				caseList.add(caseDetails);
			}
		}catch(Exception e){
			log.error("Error while checking cases for reassign : "+e.getMessage());
			e.printStackTrace();
		}finally{			
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return caseList;
	}
	
	public int reassignCases(String makerId, String checkerId, String caseList){
		int count = 0;
		Connection connection = getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String sql = "UPDATE "+schemaName+"TB_ACCOUNTOPENINGFORMLOG SET DATA_UPDATED_BY = ?, DATA_CHECKED_BY = ? WHERE CASENO IN ("+caseList+")";
		try{
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, makerId);
			preparedStatement.setString(2, checkerId);
			count = preparedStatement.executeUpdate();
		}catch(Exception e){
			log.error("Error while checking cases for reassign : "+e.getMessage());
			e.printStackTrace();
		}finally{			
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return count;
	}
	
	public int unassignCases(String caseList){
		int count = 0;
		Connection connection = getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String sql = "INSERT INTO "+schemaName+"TB_ACCOUNTOPENINGFORMLOG_LOG SELECT * FROM "+schemaName+"TB_ACCOUNTOPENINGFORMLOG WHERE CASENO IN ("+caseList+") AND STATUS = 'U'";
		try{
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.executeUpdate();
			
			sql = "DELETE FROM "+schemaName+"TB_ACCOUNTOPENINGFORMLOG WHERE CASENO IN ("+caseList+") AND STATUS = 'U'";
			preparedStatement = connection.prepareStatement(sql);
			count = preparedStatement.executeUpdate();
		}catch(Exception e){
			log.error("Error while unassigning cases : "+e.getMessage());
			e.printStackTrace();
		}finally{			
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return count;
	}
}
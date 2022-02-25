package com.quantumdataengines.app.compass.dao.fatca;

import java.io.File;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
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

import com.quantumdataengines.app.compass.schema.Configuration;
import com.quantumdataengines.app.compass.util.ConnectionUtil;
import com.quantumdataengines.app.compass.util.fatca.FATCAFileGeneration;
import com.quantumdataengines.app.compass.util.fatca.FATCAMessage;
import com.quantumdataengines.app.compass.util.fatca.FATCAReportingStatus;

@Repository
public class FATCADAOImpl implements FATCADAO{
	
private static final Logger log = LoggerFactory.getLogger(FATCADAOImpl.class);

	@Autowired
	private ConnectionUtil connectionUtil;
	
	@Value("${compass.aml.config.schemaName}")
	private String schemaName;
	
	public Connection getConnection(){
		Connection connection = null;
		try{
			connection = connectionUtil.getConnection();
		}catch(Exception e){
			log.error("Error in creating db connection : FATCADAOImpl -> "+e.getMessage());
			e.printStackTrace();
		}
		return connection;
	}
	
	public Map<String, String> getFATCAFormData(String caseNo, String userCode){
		Map<String, String> formData = new HashMap<String, String>();
		Connection connection  = getConnection();
		CallableStatement callableStatement = null;
		ResultSet resultSet = null;
		try{
			callableStatement = connection.prepareCall("{CALL "+schemaName+"STP_GETFATCAFORMDATA(?,?,?)}");
			callableStatement.setString(1, caseNo);
			callableStatement.setString(2, userCode);
			callableStatement.registerOutParameter(3, OracleTypes.CURSOR);
			callableStatement.execute();
			resultSet = (ResultSet) callableStatement.getObject(3);
			
			ResultSetMetaData resultSetMetaData = resultSet.getMetaData();
			int resultSetColumnCount = resultSetMetaData.getColumnCount();
			if(resultSet.next()){
				for(int i = 1; i <= resultSetColumnCount; i++){
					String columnName = resultSetMetaData.getColumnName(i);
					formData.put(columnName, resultSet.getString(columnName));
				}
			}
		}catch(Exception e){
			log.error("Error while getting FATCA report : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, callableStatement, resultSet, null);
		}
		return formData;
	}
	
	public List<String[]> getAllTitles(){
		List<String[]> allTitle = new ArrayList<String[]>();
		Connection connection  = getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareStatement("SELECT TITLENAME, TITLEDESCRIPTION FROM "+schemaName+"TB_LISTOFTITLES");
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()){
				String[] title = new String[2];
				title[0] = resultSet.getString("TITLENAME");
				title[1] = resultSet.getString("TITLEDESCRIPTION");
				allTitle.add(title);
			}
		}catch(Exception e){
			log.error("Error while getting all titles : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return allTitle;
	}
	
	public List<String[]> getAllCountry(){
		List<String[]> allCountries = new ArrayList<String[]>();
		Connection connection  = getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareStatement("SELECT ISO_COUNTRY, COUNTRYNAME FROM "+schemaName+"TB_COUNTRYMASTER");
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()){
				String[] country = new String[2];
				country[0] = resultSet.getString("ISO_COUNTRY");
				country[1] = resultSet.getString("COUNTRYNAME");
				allCountries.add(country);
			}
		}catch(Exception e){
			log.error("Error while getting all countries : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return allCountries;
	}
	
	public boolean saveFATCAReport(Map<String, String> paramMap, String caseNo, String userCode){
		
		String IF_GIIN_1 = paramMap.get("IF_GIIN_1")+paramMap.get("IF_GIIN_2")+paramMap.get("IF_GIIN_3")+paramMap.get("IF_GIIN_4")+paramMap.get("IF_GIIN_5")+paramMap.get("IF_GIIN_6")+
						   "."+
						   paramMap.get("IF_GIIN_7")+paramMap.get("IF_GIIN_8")+paramMap.get("IF_GIIN_9")+paramMap.get("IF_GIIN_10")+paramMap.get("IF_GIIN_11")+
						   "."+
						   paramMap.get("IF_GIIN_12")+paramMap.get("IF_GIIN_13")+
						   "."+
						   paramMap.get("IF_GIIN_14")+paramMap.get("IF_GIIN_15")+paramMap.get("IF_GIIN_16");
		
		String IF_SPNSR_ENTY_GIIN = paramMap.get("IF_SPNSR_ENTY_GIIN_1")+paramMap.get("IF_SPNSR_ENTY_GIIN_2")+paramMap.get("IF_SPNSR_ENTY_GIIN_3")+paramMap.get("IF_SPNSR_ENTY_GIIN_4")+paramMap.get("IF_SPNSR_ENTY_GIIN_5")+paramMap.get("IF_SPNSR_ENTY_GIIN_6")+
							"."+
							paramMap.get("IF_SPNSR_ENTY_GIIN_7")+paramMap.get("IF_SPNSR_ENTY_GIIN_8")+paramMap.get("IF_SPNSR_ENTY_GIIN_9")+paramMap.get("IF_SPNSR_ENTY_GIIN_10")+paramMap.get("IF_SPNSR_ENTY_GIIN_11")+
							"."+
							paramMap.get("IF_SPNSR_ENTY_GIIN_12")+paramMap.get("IF_SPNSR_ENTY_GIIN_13")+
							"."+
							paramMap.get("IF_SPNSR_ENTY_GIIN_14")+paramMap.get("IF_SPNSR_ENTY_GIIN_15")+paramMap.get("IF_SPNSR_ENTY_GIIN_16");
		
		
		boolean isSaved = false;
		Connection connection  = getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String sql = "UPDATE "+schemaName+"TB_FATCAREPORT "+
					 "   SET REPORT_TYPE_C = ?, REPORT_TYPE_A = ?, REPORT_TYPE_V = ?, MESSAGE_REF_ID = ?, CORR_MESSAGE_REF_ID = ?, "+
					 "	     DOC_REF_ID = ?, CORR_DOC_REF_ID = ?, REPORTING_PERIOD = ?, REPORTING_TIMESTAMP = ?, IF_NAME = ?, "+
					 "		 IF_ROOM_STREET = ?, IF_CITY = ?, IF_STATE= ?, IF_COUNTRY = ?, IF_POSTALCODE = ?, "+
					 "		 IF_GIIN = ?, IF_TIN = ?, IF_SPNSR_ENTY_NAME = ?, IF_SPNSR_ENTY_ROOM_STREET = ?, IF_SPNSR_ENTY_CITY = ?, "+
					 "		 IF_SPNSR_ENTY_STATE = ?, IF_SPNSR_ENTY_COUNTRY = ?, IF_SPNSR_ENTY_POSTALCODE = ?, IF_SPNSR_ENTY_GIIN = ?, IF_SPNSR_ENTY_TIN = ?, "+
					 "		 PRT_POOL_REPORT_TYPE = ?, PRT_ACCOUNT_NO = ?, PRT_AGGR_PAYMNT_AMNT = ?, PRT_AGGR_ACCOUNT_BAL = ?, PRT_CURRENCY_CODE = ?, "+
					 "		 EMAIL_ID = ?, UPDATEDBY = ?, UPDATETIMESTAMP = SYSTIMESTAMP "+
					 " WHERE CASENO = ? ";
		try{
			preparedStatement = connection.prepareStatement(sql);
			
			//REPORT_TYPE_C = ?, REPORT_TYPE_A = ?, REPORT_TYPE_V = ?, MESSAGE_REF_ID = ?, CORR_MESSAGE_REF_ID = ?, "+
			preparedStatement.setString(1, paramMap.get("REPORT_TYPE_FATCA2"));
			preparedStatement.setString(2, paramMap.get("REPORT_TYPE_FATCA4"));
			preparedStatement.setString(3, paramMap.get("REPORT_TYPE_FATCA3"));
			preparedStatement.setString(4, paramMap.get("MESSAGE_REF_ID"));
			preparedStatement.setString(5, paramMap.get("CORR_MESSAGE_REF_ID"));
			
			//DOC_REF_ID = ?, CORR_DOC_REF_ID = ?, REPORTING_PERIOD = ?, REPORTING_TIMESTAMP = ?, IF_NAME = ?, "+
			preparedStatement.setString(6, paramMap.get("DOC_REF_ID"));
			preparedStatement.setString(7, paramMap.get("CORR_DOC_REF_ID"));
			preparedStatement.setString(8, paramMap.get("REPORTING_PERIOD")+"-12-31");
			preparedStatement.setString(9, paramMap.get("REPORTING_TIMESTAMP_DATE")+"T"+paramMap.get("REPORTING_TIMESTAMP_TIME")+"Z");
			preparedStatement.setString(10, paramMap.get("IF_NAME"));
			
			//IF_ROOM_STREET = ?, IF_CITY = ?, IF_STATE= ?, IF_COUNTRY = ?, IF_POSTALCODE = ?, "+
			preparedStatement.setString(11, paramMap.get("IF_ROOM_STREET"));
			preparedStatement.setString(12, paramMap.get("IF_CITY"));
			preparedStatement.setString(13, paramMap.get("IF_STATE"));
			preparedStatement.setString(14, paramMap.get("IF_COUNTRY"));
			preparedStatement.setString(15, paramMap.get("IF_POSTALCODE"));
			
			//IF_GIIN = ?, IF_TIN = ?, IF_SPNSR_ENTY_NAME = ?, IF_SPNSR_ENTY_ROOM_STREET = ?, IF_SPNSR_ENTY_CITY = ?, "+
			preparedStatement.setString(16, IF_GIIN_1);
			preparedStatement.setString(17, paramMap.get("IF_TIN"));
			preparedStatement.setString(18, paramMap.get("IF_SPNSR_ENTY_NAME"));
			preparedStatement.setString(19, paramMap.get("IF_SPNSR_ENTY_ROOM_STREET"));
			preparedStatement.setString(20, paramMap.get("IF_SPNSR_ENTY_CITY"));
			
			//IF_SPNSR_ENTY_STATE = ?, IF_SPNSR_ENTY_COUNTRY = ?, IF_SPNSR_ENTY_GIIN = ?, IF_SPNSR_ENTY_TIN = ?, "+
			preparedStatement.setString(21, paramMap.get("IF_SPNSR_ENTY_STATE"));
			preparedStatement.setString(22, paramMap.get("IF_SPNSR_ENTY_COUNTRY"));
			preparedStatement.setString(23, paramMap.get("IF_SPNSR_ENTY_POSTALCODE"));
			preparedStatement.setString(24, IF_SPNSR_ENTY_GIIN);
			preparedStatement.setString(25, paramMap.get("IF_SPNSR_ENTY_TIN"));
			
			//PRT_POOL_REPORT_TYPE = ?, PRT_ACCOUNT_NO = ?, PRT_AGGR_PAYMNT_AMNT = ?, PRT_AGGR_ACCOUNT_BAL = ?, PRT_CURRENCY_CODE = ?, "+
			preparedStatement.setString(26, paramMap.get("PRT_POOL_REPORT_TYPE"));
			preparedStatement.setString(27, paramMap.get("PRT_ACCOUNT_NO"));
			preparedStatement.setString(28, paramMap.get("PRT_AGGR_PAYMNT_AMNT"));
			preparedStatement.setString(29, paramMap.get("PRT_AGGR_ACCOUNT_BAL"));
			preparedStatement.setString(30, paramMap.get("PRT_CURRENCY_CODE"));
			
			preparedStatement.setString(31, paramMap.get("EMAIL_ID"));
			preparedStatement.setString(32, userCode);
			preparedStatement.setString(33, caseNo);
		
			int x = preparedStatement.executeUpdate();
			if(x != 0)
				isSaved = true;
		}catch(Exception e){
			log.error("Error while saving FATCA report : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return isSaved;
	}
	
	public Map<String, String> fatcaSettings(){
		Map<String, String> fatcaSettings = new HashMap<String, String>();
		Connection connection  = getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String sql = "SELECT SENDER_PRIVATEKEY_TYPE, SENDER_PRIVATEKEY_PATH, SENDER_PRIVATEKEY_ALIAS, SENDER_PRIVATEKEY_PASS, SENDER_PRIVATEKEY_STOREPASS, "+
					 "		 SENDER_PUBLICKEY_TYPE, SENDER_PUBLICKEY_PATH, SENDER_PUBLICKEY_ALIAS, SENDER_PUBLICKEY_PASS, SENDER_GIIN, SENDERE_EMAIL, "+
					 "		 SENDING_MODEL, APPROVER_PUBLICKEY_TYPE, APPROVER_PUBLICKEY_PATH, APPROVER_PUBLICKEY_ALIAS, APPROVER_PUBLICKEY_PASS, "+
					 "		 APPROVER_GIIN, IRS_PUBLICKEY_TYPE, IRS_PUBLICKEY_PATH, IRS_PUBLICKEY_ALIAS, IRS_PUBLICKEY_PASS, IRS_GIIN "+
					 "  FROM "+schemaName+"TB_FATCASETTINGS";
		
		try{
			preparedStatement = connection.prepareStatement(sql);
			resultSet = preparedStatement.executeQuery();
			if(resultSet.next()){
				fatcaSettings.put("SENDER_PRIVATEKEY_TYPE", resultSet.getString("SENDER_PRIVATEKEY_TYPE"));
				fatcaSettings.put("SENDER_PRIVATEKEY_PATH", resultSet.getString("SENDER_PRIVATEKEY_PATH"));
				fatcaSettings.put("SENDER_PRIVATEKEY_ALIAS", resultSet.getString("SENDER_PRIVATEKEY_ALIAS"));
				fatcaSettings.put("SENDER_PRIVATEKEY_PASS", resultSet.getString("SENDER_PRIVATEKEY_PASS"));
				fatcaSettings.put("SENDER_PRIVATEKEY_STOREPASS", resultSet.getString("SENDER_PRIVATEKEY_STOREPASS"));
				fatcaSettings.put("SENDER_PUBLICKEY_TYPE", resultSet.getString("SENDER_PUBLICKEY_TYPE"));
				fatcaSettings.put("SENDER_PUBLICKEY_PATH", resultSet.getString("SENDER_PUBLICKEY_PATH"));
				fatcaSettings.put("SENDER_PUBLICKEY_ALIAS", resultSet.getString("SENDER_PUBLICKEY_ALIAS"));
				fatcaSettings.put("SENDER_PUBLICKEY_PASS", resultSet.getString("SENDER_PUBLICKEY_PASS"));
				fatcaSettings.put("SENDER_GIIN", resultSet.getString("SENDER_GIIN"));
				fatcaSettings.put("SENDERE_EMAIL", resultSet.getString("SENDERE_EMAIL"));
				fatcaSettings.put("SENDING_MODEL", resultSet.getString("SENDING_MODEL"));
				fatcaSettings.put("APPROVER_PUBLICKEY_TYPE", resultSet.getString("APPROVER_PUBLICKEY_TYPE"));
				fatcaSettings.put("APPROVER_PUBLICKEY_PATH", resultSet.getString("APPROVER_PUBLICKEY_PATH"));
				fatcaSettings.put("APPROVER_PUBLICKEY_ALIAS", resultSet.getString("APPROVER_PUBLICKEY_ALIAS"));
				fatcaSettings.put("APPROVER_PUBLICKEY_PASS", resultSet.getString("APPROVER_PUBLICKEY_PASS"));
				fatcaSettings.put("APPROVER_GIIN", resultSet.getString("APPROVER_GIIN"));
				fatcaSettings.put("IRS_PUBLICKEY_TYPE", resultSet.getString("IRS_PUBLICKEY_TYPE"));
				fatcaSettings.put("IRS_PUBLICKEY_PATH", resultSet.getString("IRS_PUBLICKEY_PATH"));
				fatcaSettings.put("IRS_PUBLICKEY_ALIAS", resultSet.getString("IRS_PUBLICKEY_ALIAS"));
				fatcaSettings.put("IRS_PUBLICKEY_PASS", resultSet.getString("IRS_PUBLICKEY_PASS"));
				fatcaSettings.put("IRS_GIIN", resultSet.getString("IRS_GIIN"));
			}
		}catch(Exception e){
			log.error("Error while saving FATCA report : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return fatcaSettings;
	}
	
	public boolean updateFATCASettings(Map<String, String> formData, String userCode){
		int x = 0;
		Connection connection  = getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String sql = "UPDATE "+schemaName+"TB_FATCASETTINGS "+
					 "   SET SENDER_PRIVATEKEY_TYPE = ?, SENDER_PRIVATEKEY_PATH = ?, SENDER_PRIVATEKEY_ALIAS = ?, SENDER_PRIVATEKEY_PASS = ?, SENDER_PRIVATEKEY_STOREPASS = ?, "+
					 "		 SENDER_PUBLICKEY_TYPE = ?, SENDER_PUBLICKEY_PATH = ?, SENDER_PUBLICKEY_ALIAS = ?, SENDER_PUBLICKEY_PASS = ?, SENDER_GIIN = ?, SENDERE_EMAIL = ?, "+
					 "		 SENDING_MODEL = ?, APPROVER_PUBLICKEY_TYPE = ?, APPROVER_PUBLICKEY_PATH = ?, APPROVER_PUBLICKEY_ALIAS = ?, APPROVER_PUBLICKEY_PASS = ?, "+
					 "		 APPROVER_GIIN = ?, IRS_PUBLICKEY_TYPE = ?, IRS_PUBLICKEY_PATH = ?, IRS_PUBLICKEY_ALIAS = ?, IRS_PUBLICKEY_PASS = ?, IRS_GIIN = ?, "+
					 "		 UPDATEDBY = ?, UPDATETIMESTAMP = SYSTIMESTAMP ";
		
		try{
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, formData.get("SENDER_PRIVATEKEY_TYPE"));
			preparedStatement.setString(2, formData.get("SENDER_PRIVATEKEY_PATH"));
			preparedStatement.setString(3, formData.get("SENDER_PRIVATEKEY_ALIAS"));
			preparedStatement.setString(4, formData.get("SENDER_PRIVATEKEY_PASS"));
			preparedStatement.setString(5, formData.get("SENDER_PRIVATEKEY_STOREPASS"));
			preparedStatement.setString(6, formData.get("SENDER_PUBLICKEY_TYPE"));
			preparedStatement.setString(7, formData.get("SENDER_PUBLICKEY_PATH"));
			preparedStatement.setString(8, formData.get("SENDER_PUBLICKEY_ALIAS"));
			preparedStatement.setString(9, formData.get("SENDER_PUBLICKEY_PASS"));
			preparedStatement.setString(10, formData.get("SENDER_GIIN"));
			preparedStatement.setString(11, formData.get("SENDERE_EMAIL"));
			preparedStatement.setString(12, formData.get("SENDING_MODEL"));
			preparedStatement.setString(13, formData.get("APPROVER_PUBLICKEY_TYPE"));
			preparedStatement.setString(14, formData.get("APPROVER_PUBLICKEY_PATH"));
			preparedStatement.setString(15, formData.get("APPROVER_PUBLICKEY_ALIAS"));
			preparedStatement.setString(16, formData.get("APPROVER_PUBLICKEY_PASS"));
			preparedStatement.setString(17, formData.get("APPROVER_GIIN"));
			preparedStatement.setString(18, formData.get("IRS_PUBLICKEY_TYPE"));
			preparedStatement.setString(19, formData.get("IRS_PUBLICKEY_PATH"));
			preparedStatement.setString(20, formData.get("IRS_PUBLICKEY_ALIAS"));
			preparedStatement.setString(21, formData.get("IRS_PUBLICKEY_PASS"));
			preparedStatement.setString(22, formData.get("IRS_GIIN"));
			preparedStatement.setString(23, userCode);
			x = preparedStatement.executeUpdate();
		}catch(Exception e){
			log.error("Error while saving FATCA report : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return x != 0 ? true : false;
	}
	
	public boolean saveIndividualDetails(Map<String, String> paramMap, String caseNo, String lineNo, String userCode){
		boolean isSaved = false;
		Connection connection = getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			if("0".equals(lineNo)){
				preparedStatement = connection.prepareStatement("SELECT NVL(MAX(LINENO),0)+1 AS LINENO FROM "+schemaName+"TB_FATCAINDIVIDUAL WHERE CASENO = ?");
				preparedStatement.setString(1, caseNo);
				resultSet = preparedStatement.executeQuery();
				if(resultSet.next())
					lineNo = new Integer(resultSet.getInt("LINENO")).toString();
				
				String sql = "INSERT INTO "+schemaName+"TB_FATCAINDIVIDUAL(CASENO, LINENO, FI_ACCOUNTNUMBER, II_TITLE, II_FIRSTNAME, II_MIDDLENAME, II_LASTNAME, II_NAME, II_ROOM_STREET, II_CITY, II_STATE, "+
							 "		 II_COUNTRY, II_POSTALCODE, II_NATOINALITY, II_TIN, II_DOB, II_BIRTHCITY, II_BIRTHCOUNTRY, II_BIRTHFORMARCOUNTRY, UPDATEDBY, UPDATETIMESTAMP) "+
							 "VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,SYSTIMESTAMP)";
				preparedStatement = connection.prepareStatement(sql);
				preparedStatement.setString(1, caseNo);
				preparedStatement.setString(2, lineNo);
				preparedStatement.setString(3, paramMap.get("FI_ACCOUNTNUMBER"));
				preparedStatement.setString(4, paramMap.get("II_TITLE"));
				preparedStatement.setString(5, paramMap.get("II_FIRSTNAME"));
				preparedStatement.setString(6, paramMap.get("II_MIDDLENAME"));
				preparedStatement.setString(7, paramMap.get("II_LASTNAME"));
				preparedStatement.setString(8, paramMap.get("II_NAME"));
				preparedStatement.setString(9, paramMap.get("II_ROOM_STREET"));
				preparedStatement.setString(10, paramMap.get("II_CITY"));
				preparedStatement.setString(11, paramMap.get("II_STATE"));
				preparedStatement.setString(12, paramMap.get("II_COUNTRY"));
				preparedStatement.setString(13, paramMap.get("II_POSTALCODE"));
				preparedStatement.setString(14, paramMap.get("II_NATOINALITY"));
				preparedStatement.setString(15, paramMap.get("II_TIN"));
				preparedStatement.setString(16, paramMap.get("II_DOB"));
				preparedStatement.setString(17, paramMap.get("II_BIRTHCITY"));
				preparedStatement.setString(18, paramMap.get("II_BIRTHCOUNTRY"));
				preparedStatement.setString(19, paramMap.get("II_BIRTHFORMARCOUNTRY"));
				preparedStatement.setString(20, userCode);
			}else{
				String sql = "UPDATE "+schemaName+"TB_FATCAINDIVIDUAL "+
							 "   SET FI_ACCOUNTNUMBER = ?, II_TITLE = ?, II_FIRSTNAME = ?, II_MIDDLENAME = ?, II_LASTNAME = ?, II_NAME = ?, "+
							 "		 II_ROOM_STREET = ?, II_CITY = ?, II_STATE = ?, II_COUNTRY = ?, II_POSTALCODE = ?, "+
							 "		 II_NATOINALITY = ?, II_TIN = ?, II_DOB = ?, II_BIRTHCITY = ?, II_BIRTHCOUNTRY = ?, "+
							 "		 II_BIRTHFORMARCOUNTRY = ?, UPDATEDBY = ?, UPDATETIMESTAMP = SYSTIMESTAMP "+
							 " WHERE CASENO = ? "+
							 "   AND LINENO = ? ";
				preparedStatement = connection.prepareStatement(sql);
				preparedStatement.setString(1, paramMap.get("FI_ACCOUNTNUMBER"));
				preparedStatement.setString(2, paramMap.get("II_TITLE"));
				preparedStatement.setString(3, paramMap.get("II_FIRSTNAME"));
				preparedStatement.setString(4, paramMap.get("II_MIDDLENAME"));
				preparedStatement.setString(5, paramMap.get("II_LASTNAME"));
				preparedStatement.setString(6, paramMap.get("II_NAME"));
				preparedStatement.setString(7, paramMap.get("II_ROOM_STREET"));
				preparedStatement.setString(8, paramMap.get("II_CITY"));
				preparedStatement.setString(9, paramMap.get("II_STATE"));
				preparedStatement.setString(10, paramMap.get("II_COUNTRY"));
				preparedStatement.setString(11, paramMap.get("II_POSTALCODE"));
				preparedStatement.setString(12, paramMap.get("II_NATOINALITY"));
				preparedStatement.setString(13, paramMap.get("II_TIN"));
				preparedStatement.setString(14, paramMap.get("II_DOB"));
				preparedStatement.setString(15, paramMap.get("II_BIRTHCITY"));
				preparedStatement.setString(16, paramMap.get("II_BIRTHCOUNTRY"));
				preparedStatement.setString(17, paramMap.get("II_BIRTHFORMARCOUNTRY"));
				preparedStatement.setString(18, userCode);
				preparedStatement.setString(19, caseNo);
				preparedStatement.setString(20, lineNo);
			}
			
			int x = preparedStatement.executeUpdate();
			if(x != 0)
				isSaved = true;
		}catch(Exception e){
			log.error("Error while saving FATCA Individual Details : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return isSaved;
	}
	
	public List<Map<String, String>> getIndividualDetails(String caseNo, String lineNo, String userCode){
		List<Map<String, String>> individualDetailsList = new ArrayList<Map<String, String>>();
		Connection connection  = getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String sql = "SELECT LINENO, FI_ACCOUNTNUMBER, II_TITLE, II_FIRSTNAME, II_MIDDLENAME, II_LASTNAME, II_NAME, II_ROOM_STREET, II_CITY, II_STATE, "+
					 "		 II_COUNTRY, II_POSTALCODE, II_NATOINALITY, II_TIN, II_DOB, II_BIRTHCITY, II_BIRTHCOUNTRY, II_BIRTHFORMARCOUNTRY "+
					 "  FROM "+schemaName+"TB_FATCAINDIVIDUAL "+
					 " WHERE CASENO = ? ";
		if(lineNo != null){
			sql = sql+" AND LINENO = ?";
		}
		try{
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, caseNo);
			if(lineNo != null){
				preparedStatement.setString(2, lineNo);
			}
			resultSet = preparedStatement.executeQuery();
			
			ResultSetMetaData resultSetMetaData = resultSet.getMetaData();
			int resultSetColumnCount = resultSetMetaData.getColumnCount();
			while(resultSet.next()){
				Map<String, String> formData = new HashMap<String, String>();
				for(int i = 1; i <= resultSetColumnCount; i++){
					String columnName = resultSetMetaData.getColumnName(i);
					formData.put(columnName, resultSet.getString(columnName));
				}
				individualDetailsList.add(formData);
			}
		}catch(Exception e){
			log.error("Error while getting individual details : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return individualDetailsList;
	}
	
	public boolean saveAccountHolderDetails(Map<String, String> paramMap, String caseNo, String lineNo, String userCode){
		boolean isSaved = false;
		Connection connection = getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			if("0".equals(lineNo)){
				preparedStatement = connection.prepareStatement("SELECT NVL(MAX(LINENO),0)+1 AS LINENO FROM "+schemaName+"TB_FATCAACCOUNTHOLDER WHERE CASENO = ?");
				preparedStatement.setString(1, caseNo);
				resultSet = preparedStatement.executeQuery();
				if(resultSet.next())
					lineNo = new Integer(resultSet.getInt("LINENO")).toString();
				
				String sql = "INSERT INTO "+schemaName+"TB_FATCAACCOUNTHOLDER(CASENO, LINENO, ACC_HLDR_TITLE, ACC_HLDR_FIRSTNAME, ACC_HLDR_MIDDLENAME, ACC_HLDR_LASTNAME, "+
							 "		 ACC_HLDR_NAME, ACC_HLDR_ROOM_STREET, ACC_HLDR_CITY, ACC_HLDR_STATE, ACC_HLDR_COUNTRY, ACC_HLDR_POSTALCODE, ACC_HLDR_NATIONALITY, "+
							 "		 ACC_HLDR_TIN, ACC_HLDR_DOB, ACC_HLDR_BIRTHCITY, ACC_HLDR_BIRTHCOUNTRY, ACC_HLDR_BIRTHFORMARCOUNTRY, ACC_HLDR_OWNR_DOC_FFI, "+
							 "		 ACC_HLDR_PSSV_NFFE, ACC_HLDR_NONPRTCIPTING_FFI, ACC_HLDR_US_PERSON, ACC_HLDR_DRCT_REPORTING, FI_ACCOUNT_NO, FI_ACCOUNT_BAL, "+
							 "		 FI_INTEREST, FI_CURRENCY_CODE, FI_GROSS_PRCD_RDMPTN, FI_DIVIDENTS, FI_OTHERS, UPDATEDBY, UPDATETIMESTAMP) "+
							 "VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,SYSTIMESTAMP)";
				preparedStatement = connection.prepareStatement(sql);
				preparedStatement.setString(1, caseNo);
				preparedStatement.setString(2, lineNo);
				preparedStatement.setString(3, paramMap.get("ACC_HLDR_TITLE"));
				preparedStatement.setString(4, paramMap.get("ACC_HLDR_FIRSTNAME"));
				preparedStatement.setString(5, paramMap.get("ACC_HLDR_MIDDLENAME"));
				preparedStatement.setString(6, paramMap.get("ACC_HLDR_LASTNAME"));
				preparedStatement.setString(7, paramMap.get("ACC_HLDR_NAME"));
				preparedStatement.setString(8, paramMap.get("ACC_HLDR_ROOM_STREET"));
				preparedStatement.setString(9, paramMap.get("ACC_HLDR_CITY"));
				preparedStatement.setString(10, paramMap.get("ACC_HLDR_STATE"));
				preparedStatement.setString(11, paramMap.get("ACC_HLDR_COUNTRY"));
				preparedStatement.setString(12, paramMap.get("ACC_HLDR_POSTALCODE"));
				preparedStatement.setString(13, paramMap.get("ACC_HLDR_NATIONALITY"));
				
				preparedStatement.setString(14, paramMap.get("ACC_HLDR_TIN"));
				preparedStatement.setString(15, paramMap.get("ACC_HLDR_DOB"));
				preparedStatement.setString(16, paramMap.get("ACC_HLDR_BIRTHCITY"));
				preparedStatement.setString(17, paramMap.get("ACC_HLDR_BIRTHCOUNTRY"));
				preparedStatement.setString(18, paramMap.get("ACC_HLDR_BIRTHFORMARCOUNTRY"));
				preparedStatement.setString(19, paramMap.get("ACC_HLDR_OWNR_DOC_FFI"));
				preparedStatement.setString(20, paramMap.get("ACC_HLDR_PSSV_NFFE"));
				preparedStatement.setString(21, paramMap.get("ACC_HLDR_NONPRTCIPTING_FFI"));
				preparedStatement.setString(22, paramMap.get("ACC_HLDR_US_PERSON"));
				preparedStatement.setString(23, paramMap.get("ACC_HLDR_DRCT_REPORTING"));
				preparedStatement.setString(24, paramMap.get("FI_ACCOUNT_NO"));
				preparedStatement.setString(25, paramMap.get("FI_ACCOUNT_BAL"));
				preparedStatement.setString(26, paramMap.get("FI_INTEREST"));
				preparedStatement.setString(27, paramMap.get("FI_CURRENCY_CODE"));
				preparedStatement.setString(28, paramMap.get("FI_GROSS_PRCD_RDMPTN"));
				preparedStatement.setString(29, paramMap.get("FI_DIVIDENTS"));
				preparedStatement.setString(30, paramMap.get("FI_OTHERS"));
				preparedStatement.setString(31, userCode);
			}else{
				String sql = "UPDATE "+schemaName+"TB_FATCAACCOUNTHOLDER "+
							 "   SET ACC_HLDR_TITLE = ?, ACC_HLDR_FIRSTNAME = ?, ACC_HLDR_MIDDLENAME = ?, ACC_HLDR_LASTNAME = ?, ACC_HLDR_NAME = ?, "+
							 "		 ACC_HLDR_ROOM_STREET = ?, ACC_HLDR_CITY = ?, ACC_HLDR_STATE = ?, ACC_HLDR_COUNTRY = ?, ACC_HLDR_POSTALCODE = ?, "+
							 "		 ACC_HLDR_NATIONALITY = ?, ACC_HLDR_TIN = ?, ACC_HLDR_DOB = ?, ACC_HLDR_BIRTHCITY = ?, ACC_HLDR_BIRTHCOUNTRY = ?, "+
							 "		 ACC_HLDR_BIRTHFORMARCOUNTRY = ?, ACC_HLDR_OWNR_DOC_FFI = ?, ACC_HLDR_PSSV_NFFE = ?, ACC_HLDR_NONPRTCIPTING_FFI = ?, ACC_HLDR_US_PERSON = ?, "+
							 "		 ACC_HLDR_DRCT_REPORTING = ?, FI_ACCOUNT_NO = ?, FI_ACCOUNT_BAL = ?, FI_INTEREST = ?, FI_CURRENCY_CODE = ?, "+
							 "		 FI_GROSS_PRCD_RDMPTN = ?, FI_DIVIDENTS = ?, FI_OTHERS = ?, UPDATEDBY = ?, UPDATETIMESTAMP = SYSTIMESTAMP "+
							 " WHERE CASENO = ? "+
							 "   AND LINENO = ? ";
				preparedStatement = connection.prepareStatement(sql);
				//ACC_HLDR_TITLE = ?, ACC_HLDR_FIRSTNAME = ?, ACC_HLDR_MIDDLENAME = ?, ACC_HLDR_LASTNAME = ?, ACC_HLDR_NAME = ?, "+
				preparedStatement.setString(1, paramMap.get("ACC_HLDR_TITLE"));
				preparedStatement.setString(2, paramMap.get("ACC_HLDR_FIRSTNAME"));
				preparedStatement.setString(3, paramMap.get("ACC_HLDR_MIDDLENAME"));
				preparedStatement.setString(4, paramMap.get("ACC_HLDR_LASTNAME"));
				preparedStatement.setString(5, paramMap.get("ACC_HLDR_NAME"));
				
				//ACC_HLDR_ROOM_STREET = ?, ACC_HLDR_CITY = ?, ACC_HLDR_STATE = ?, ACC_HLDR_COUNTRY = ?, ACC_HLDR_POSTALCODE = ?, "+
				preparedStatement.setString(6, paramMap.get("ACC_HLDR_ROOM_STREET"));
				preparedStatement.setString(7, paramMap.get("ACC_HLDR_CITY"));
				preparedStatement.setString(8, paramMap.get("ACC_HLDR_STATE"));
				preparedStatement.setString(9, paramMap.get("ACC_HLDR_COUNTRY"));
				preparedStatement.setString(10, paramMap.get("ACC_HLDR_POSTALCODE"));
				
				//ACC_HLDR_NATIONALITY = ?, ACC_HLDR_TIN = ?, ACC_HLDR_DOB = ?, ACC_HLDR_BIRTHCITY = ?, ACC_HLDR_BIRTHCOUNTRY = ?, "+
				preparedStatement.setString(11, paramMap.get("ACC_HLDR_NATIONALITY"));
				preparedStatement.setString(12, paramMap.get("ACC_HLDR_TIN"));
				preparedStatement.setString(13, paramMap.get("ACC_HLDR_DOB"));
				preparedStatement.setString(14, paramMap.get("ACC_HLDR_BIRTHCITY"));
				preparedStatement.setString(15, paramMap.get("ACC_HLDR_BIRTHCOUNTRY"));
				
				//ACC_HLDR_BIRTHFORMARCOUNTRY = ?, ACC_HLDR_OWNR_DOC_FFI = ?, ACC_HLDR_PSSV_NFFE = ?, ACC_HLDR_NONPRTCIPTING_FFI = ?, ACC_HLDR_US_PERSON = ?, "+
				preparedStatement.setString(16, paramMap.get("ACC_HLDR_BIRTHFORMARCOUNTRY"));
				preparedStatement.setString(17, paramMap.get("ACC_HLDR_OWNR_DOC_FFI"));
				preparedStatement.setString(18, paramMap.get("ACC_HLDR_PSSV_NFFE"));
				preparedStatement.setString(19, paramMap.get("ACC_HLDR_NONPRTCIPTING_FFI"));
				preparedStatement.setString(20, paramMap.get("ACC_HLDR_US_PERSON"));
				
				//ACC_HLDR_DRCT_REPORTING = ?, FI_ACCOUNT_NO = ?, FI_ACCOUNT_BAL = ?, FI_INTEREST = ?, FI_CURRENCY_CODE = ?, "+
				preparedStatement.setString(21, paramMap.get("ACC_HLDR_DRCT_REPORTING"));
				preparedStatement.setString(22, paramMap.get("FI_ACCOUNT_NO"));
				preparedStatement.setString(23, paramMap.get("FI_ACCOUNT_BAL"));
				preparedStatement.setString(24, paramMap.get("FI_INTEREST"));
				preparedStatement.setString(25, paramMap.get("FI_CURRENCY_CODE"));
				
				//FI_GROSS_PRCD_RDMPTN = ?, FI_DIVIDENTS = ?, FI_OTHERS = ?, UPDATEDBY = ?, "+
				preparedStatement.setString(26, paramMap.get("FI_GROSS_PRCD_RDMPTN"));
				preparedStatement.setString(27, paramMap.get("FI_DIVIDENTS"));
				preparedStatement.setString(28, paramMap.get("FI_OTHERS"));
				
				preparedStatement.setString(29, userCode);
				preparedStatement.setString(30, caseNo);
				preparedStatement.setString(31, lineNo);
			}
			
			int x = preparedStatement.executeUpdate();
			if(x != 0)
				isSaved = true;
		}catch(Exception e){
			log.error("Error while saving FATCA Individual Details : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return isSaved;
	}
	
	public List<Map<String, String>> getAccountHolderDetails(String caseNo, String lineNo, String userCode){
		List<Map<String, String>> accountHolderDetailsList = new ArrayList<Map<String, String>>();
		Connection connection  = getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String sql = "SELECT CASENO, LINENO, ACC_HLDR_TITLE, ACC_HLDR_FIRSTNAME, ACC_HLDR_MIDDLENAME, ACC_HLDR_LASTNAME, ACC_HLDR_NAME, "+
					 "		 ACC_HLDR_ROOM_STREET, ACC_HLDR_CITY, ACC_HLDR_STATE, ACC_HLDR_COUNTRY, ACC_HLDR_POSTALCODE, ACC_HLDR_NATIONALITY, "+
					 "		 ACC_HLDR_TIN, ACC_HLDR_DOB, ACC_HLDR_BIRTHCITY, ACC_HLDR_BIRTHCOUNTRY, ACC_HLDR_BIRTHFORMARCOUNTRY, "+
					 "		 ACC_HLDR_OWNR_DOC_FFI, ACC_HLDR_PSSV_NFFE, ACC_HLDR_NONPRTCIPTING_FFI, ACC_HLDR_US_PERSON, ACC_HLDR_DRCT_REPORTING, "+
					 "		 FI_ACCOUNT_NO, FI_ACCOUNT_BAL, FI_INTEREST, FI_CURRENCY_CODE, FI_GROSS_PRCD_RDMPTN, FI_DIVIDENTS, FI_OTHERS "+
					 "  FROM "+schemaName+"TB_FATCAACCOUNTHOLDER "+
					 " WHERE CASENO = ? ";
		if(lineNo != null){
			sql = sql+" AND LINENO = ?";
		}
		try{
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, caseNo);
			if(lineNo != null){
				preparedStatement.setString(2, lineNo);
			}
			resultSet = preparedStatement.executeQuery();
			
			ResultSetMetaData resultSetMetaData = resultSet.getMetaData();
			int resultSetColumnCount = resultSetMetaData.getColumnCount();
			while(resultSet.next()){
				Map<String, String> formData = new HashMap<String, String>();
				for(int i = 1; i <= resultSetColumnCount; i++){
					String columnName = resultSetMetaData.getColumnName(i);
					formData.put(columnName, resultSet.getString(columnName));
				}
				accountHolderDetailsList.add(formData);
			}
		}catch(Exception e){
			log.error("Error while getting account holder details : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return accountHolderDetailsList;
	}
	
	public boolean deleteindividualDetails(String caseNo, String lineNo, String userCode){
		boolean isDeleted = false;
		Connection connection  = getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareStatement("DELETE FROM "+schemaName+"TB_FATCAINDIVIDUAL WHERE CASENO = ?  AND LINENO = ? ");
			preparedStatement.setString(1, caseNo);
			preparedStatement.setString(2, lineNo);
			int x = preparedStatement.executeUpdate();
			if(x != 0)
				isDeleted = true;
		}catch(Exception e){
			log.error("Error while deleting FATCA Individual Details : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return isDeleted;
	}
	
	public boolean deleteAccountHolderDetails(String caseNo, String lineNo, String userCode){
		boolean isDeleted = false;
		Connection connection  = getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareStatement("DELETE FROM "+schemaName+"TB_FATCAACCOUNTHOLDER WHERE CASENO = ?  AND LINENO = ? ");
			preparedStatement.setString(1, caseNo);
			preparedStatement.setString(2, lineNo);
			int x = preparedStatement.executeUpdate();
			if(x != 0)
				isDeleted = true;
		}catch(Exception e){
			log.error("Error while deleting FATCA Account Holder Details : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return isDeleted;
	}
	
	public HashMap getForm8966XmlFileContent(Configuration configurarion, String caseNo, String userCode){
		HashMap hmFatca8966XMLFileDetails = new HashMap();
		LinkedHashMap lhmFatca8966XMLFileContent = new LinkedHashMap();
		Connection connection = connectionUtil.getConnection(configurarion.getJndiDetails().getJndiName());
		CallableStatement callableStatement = null;
		ResultSet resultSet1 = null;
		ResultSet resultSet2 = null;
		try{
			executeFATCAXMLProcedures(configurarion, caseNo, userCode, "FATCA8966");
			
			callableStatement = connection.prepareCall("{CALL "+schemaName+"STP_EXPORTFATCA8966XMLFILE(?,?,?,?)}");
            callableStatement.setString(1, caseNo);
            callableStatement.setString(2, userCode);
            callableStatement.registerOutParameter(3, oracle.jdbc.OracleTypes.CURSOR);
            callableStatement.registerOutParameter(4, oracle.jdbc.OracleTypes.CURSOR);
            callableStatement.execute();
            resultSet1 = (ResultSet)callableStatement.getObject(3);
            resultSet2 = (ResultSet)callableStatement.getObject(4);
            if(resultSet1.next()){
            	hmFatca8966XMLFileDetails.put("FILENAME", resultSet1.getString(1));
            }
            while(resultSet2.next()){
            	lhmFatca8966XMLFileContent.put(resultSet2.getString(1), resultSet2.getString(2));
            }
            hmFatca8966XMLFileDetails.put("FILECONTENT", lhmFatca8966XMLFileContent);
		}catch(Exception e){
			log.error("Exception in FATCADAOImpl -> getForm8966XmlFileContent, Error Is:"+ e.toString());
			System.out.println("Exception in FATCADAOImpl -> getForm8966XmlFileContent, Error Is:"+ e.toString());
            e.toString();
		}finally{
			connectionUtil.closeResources(connection, callableStatement, null, null);
		}
		return hmFatca8966XMLFileDetails;
	}
	
	public void executeFATCAXMLProcedures(Configuration configurarion, String caseNo, String userCode, String reportType){
		Connection connection = connectionUtil.getConnection(configurarion.getJndiDetails().getJndiName());
		Connection connection1 = null;
		PreparedStatement preparedStatement = null;
		CallableStatement callableStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareStatement("SELECT PROCEDURENAME FROM "+schemaName+"TB_REGULATORYPROCLIST WHERE REPORTINGTYPE = ? ORDER BY EXECUTIONORDER");
			preparedStatement.setString(1, reportType);
			resultSet = preparedStatement.executeQuery();
			while (resultSet.next()) {
				String l_strProcName = resultSet.getString(1);
				try{
					connection1 = connectionUtil.getConnection(configurarion.getJndiDetails().getJndiName());
					callableStatement = connection1.prepareCall("{CALL "+schemaName+""+l_strProcName+"(?,?)}");
					callableStatement.setString(1, caseNo);
					callableStatement.setString(2, userCode);
					callableStatement.execute();
				}catch(Exception e){
					log.error("Exception in FATCADAOImpl -> executeFATCAXMLProcedures, Error Is:"+ e.getMessage());
					e.printStackTrace();
				}finally{
					connectionUtil.closeResources(connection1, callableStatement, null, null);
				}
			}
		}catch(Exception e){
			log.error("Exception in FATCADAOImpl -> executeFATCAXMLProcedures, Error Is:"+ e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
	}
	
	public Map<String, String> getFATCASettings(Configuration configuration){
		Map<String, String> fatcaSettings = new HashMap<String, String>();
		Connection connection = getConnection();
		if(configuration != null)
			connection = connectionUtil.getConnection(configuration.getJndiDetails().getJndiName());
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			String sql = "SELECT SENDER_PRIVATEKEY_TYPE, SENDER_PRIVATEKEY_PATH, SENDER_PRIVATEKEY_ALIAS, SENDER_PRIVATEKEY_PASS, "+
						 "		 SENDER_PRIVATEKEY_STOREPASS, SENDER_PUBLICKEY_TYPE, SENDER_PUBLICKEY_PATH, SENDER_PUBLICKEY_ALIAS, "+
						 "		 SENDER_PUBLICKEY_PASS, SENDER_GIIN, SENDERE_EMAIL, SENDING_MODEL, APPROVER_PUBLICKEY_TYPE, "+
						 "		 APPROVER_PUBLICKEY_PATH, APPROVER_PUBLICKEY_ALIAS, APPROVER_PUBLICKEY_PASS, APPROVER_GIIN, "+
						 "		 IRS_PUBLICKEY_TYPE, IRS_PUBLICKEY_PATH, IRS_PUBLICKEY_ALIAS, IRS_PUBLICKEY_PASS, IRS_GIIN, TAXYEAR "+
						 "  FROM "+schemaName+"TB_FATCASETTINGS ";
			preparedStatement = connection.prepareStatement(sql);
			resultSet = preparedStatement.executeQuery();
			if(resultSet.next()){
				fatcaSettings.put("SENDER_PRIVATEKEY_TYPE", resultSet.getString("SENDER_PRIVATEKEY_TYPE"));
				fatcaSettings.put("SENDER_PRIVATEKEY_PATH", resultSet.getString("SENDER_PRIVATEKEY_PATH"));
				fatcaSettings.put("SENDER_PRIVATEKEY_ALIAS", resultSet.getString("SENDER_PRIVATEKEY_ALIAS"));
				fatcaSettings.put("SENDER_PRIVATEKEY_PASS", resultSet.getString("SENDER_PRIVATEKEY_PASS"));
				
				fatcaSettings.put("SENDER_PRIVATEKEY_STOREPASS", resultSet.getString("SENDER_PRIVATEKEY_STOREPASS"));
				fatcaSettings.put("SENDER_PUBLICKEY_TYPE", resultSet.getString("SENDER_PUBLICKEY_TYPE"));
				fatcaSettings.put("SENDER_PUBLICKEY_PATH", resultSet.getString("SENDER_PUBLICKEY_PATH"));
				fatcaSettings.put("SENDER_PUBLICKEY_ALIAS", resultSet.getString("SENDER_PUBLICKEY_ALIAS"));
				
				fatcaSettings.put("SENDER_PUBLICKEY_PASS", resultSet.getString("SENDER_PUBLICKEY_PASS"));
				fatcaSettings.put("SENDER_GIIN", resultSet.getString("SENDER_GIIN"));
				fatcaSettings.put("SENDERE_EMAIL", resultSet.getString("SENDERE_EMAIL"));
				fatcaSettings.put("SENDING_MODEL", resultSet.getString("SENDING_MODEL"));
				fatcaSettings.put("APPROVER_PUBLICKEY_TYPE", resultSet.getString("APPROVER_PUBLICKEY_TYPE"));
				
				fatcaSettings.put("APPROVER_PUBLICKEY_PATH", resultSet.getString("APPROVER_PUBLICKEY_PATH"));
				fatcaSettings.put("APPROVER_PUBLICKEY_ALIAS", resultSet.getString("APPROVER_PUBLICKEY_ALIAS"));
				fatcaSettings.put("APPROVER_PUBLICKEY_PASS", resultSet.getString("APPROVER_PUBLICKEY_PASS"));
				fatcaSettings.put("APPROVER_GIIN", resultSet.getString("APPROVER_GIIN"));
				
				fatcaSettings.put("IRS_PUBLICKEY_TYPE", resultSet.getString("IRS_PUBLICKEY_TYPE"));
				fatcaSettings.put("IRS_PUBLICKEY_PATH", resultSet.getString("IRS_PUBLICKEY_PATH"));
				fatcaSettings.put("IRS_PUBLICKEY_ALIAS", resultSet.getString("IRS_PUBLICKEY_ALIAS"));
				fatcaSettings.put("IRS_PUBLICKEY_PASS", resultSet.getString("IRS_PUBLICKEY_PASS"));
				fatcaSettings.put("IRS_GIIN", resultSet.getString("IRS_GIIN"));
				fatcaSettings.put("TAXYEAR", resultSet.getString("TAXYEAR"));
			}
		}catch(Exception e){
			log.error("Error while getting FATCA Settings : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return fatcaSettings;
	}

	public void storeFATCAStatus(Configuration configuration, String caseNo, FATCAFileGeneration fatcaFileGeneration, List<FATCAMessage> fatcaMessageList) {
		Connection connection = connectionUtil.getConnection(configuration.getJndiDetails().getJndiName());
		PreparedStatement preparedStatement = null;
		String sql = "";
		try{
			if(checkFATCAStatusAvailable(configuration, caseNo, true)){
				sql = "UPDATE "+schemaName+"TB_FATCACASESTATUS "+
					  "   SET STATUS = ?, PROGRESSSTATUS = ?, STARTTIME = ?, ENDTIME = ?, GENERATEDBY = ?, "+
					  "		  MESSAGE = ?, CASEFOLDERPATH = ?, FATCAPACKAGEFOLDER = ?, COMPASSXMLFILE = ?, COMPASSXMLFILEVALID = ?, "+
					  "		  UPLOADEDXMLFILE = ?, UPLOADEDXMLFILEVALID = ?, XMLFILEPROCESSED = ?, SIGNEDXMLFILE = ?, GENERATEDZIPFILE = ?, "+
					  "		  IRSNOTIFICATIONFOLDER = ?, IRSNOTIFICATIONFILE = ?, IRSPAYLOADFILE = ?, IRSMETADATAFILE = ?, ISPLAYLOADREAD = ?, "+
					  "		  IRSPAYLOADREADFILE = ?, IRSNOTIFICATIONCLASS = ?, UPDATETIMESTAMP = SYSTIMESTAMP "+
					  "	WHERE CASENO = ?";
				preparedStatement = connection.prepareStatement(sql);
				preparedStatement.setString(1, new Integer(fatcaFileGeneration.getStatus()).toString());
				preparedStatement.setString(2, new Integer(fatcaFileGeneration.getProgressStatus()).toString());
				preparedStatement.setString(3, fatcaFileGeneration.getStartDate());
				preparedStatement.setString(4, fatcaFileGeneration.getEndDate());
				preparedStatement.setString(5, fatcaFileGeneration.getGeneratedBy());
				preparedStatement.setString(6, fatcaFileGeneration.getMessage());
				preparedStatement.setString(7, fatcaFileGeneration.getCaseFolderPath());
				preparedStatement.setString(8, fatcaFileGeneration.getFatcaPackageFolder());
				preparedStatement.setString(9, fatcaFileGeneration.getOriginalXMLFile() != null ? fatcaFileGeneration.getOriginalXMLFile().getAbsolutePath() : "");
				preparedStatement.setString(10, fatcaFileGeneration.isOriginalFileValid() == true ? "1" : "0");
				preparedStatement.setString(11, fatcaFileGeneration.getUploadedXMLFile() != null ? fatcaFileGeneration.getUploadedXMLFile().getAbsolutePath() : "");
				preparedStatement.setString(12, fatcaFileGeneration.isUploadedFileValid() == true ? "1" : "0");
				preparedStatement.setString(13, fatcaFileGeneration.getXmlFileToProcess() != null ? fatcaFileGeneration.getXmlFileToProcess().getAbsolutePath() : "");
				preparedStatement.setString(14, fatcaFileGeneration.getSignedXMLFile() != null ? fatcaFileGeneration.getSignedXMLFile().getAbsolutePath() : "");
				preparedStatement.setString(15, fatcaFileGeneration.getGeneratedZipFile() != null ? fatcaFileGeneration.getGeneratedZipFile().getAbsolutePath() : "");
				preparedStatement.setString(16, fatcaFileGeneration.getIRSNotificationFolder());
				preparedStatement.setString(17, fatcaFileGeneration.getIRSNotificationFile() != null ? fatcaFileGeneration.getIRSNotificationFile().getAbsolutePath() : "");
				preparedStatement.setString(18, fatcaFileGeneration.getIRSPayloadFile() != null ? fatcaFileGeneration.getIRSPayloadFile().getAbsolutePath() : "");
				preparedStatement.setString(19, fatcaFileGeneration.getIRSMetadataFile() != null ? fatcaFileGeneration.getIRSMetadataFile().getAbsolutePath() : "");
				preparedStatement.setString(20, fatcaFileGeneration.isPlayloadRead() == true ? "1" : "0");
				preparedStatement.setString(21, fatcaFileGeneration.getIRSPayloadReadFile() != null ? fatcaFileGeneration.getIRSPayloadReadFile().getAbsolutePath() : "");
				preparedStatement.setString(22, fatcaFileGeneration.getIRSNotificationType() != null ? fatcaFileGeneration.getIRSNotificationType().getName() : "");
				preparedStatement.setString(23, caseNo);
				preparedStatement.executeUpdate();
			}else{
				sql = "INSERT INTO "+schemaName+"TB_FATCACASESTATUS(CASENO, STATUS, PROGRESSSTATUS, STARTTIME, ENDTIME, GENERATEDBY, MESSAGE, "+
					  "		  CASEFOLDERPATH, FATCAPACKAGEFOLDER, COMPASSXMLFILE, COMPASSXMLFILEVALID, UPLOADEDXMLFILE, "+
					  "		  UPLOADEDXMLFILEVALID, XMLFILEPROCESSED, SIGNEDXMLFILE, GENERATEDZIPFILE, IRSNOTIFICATIONFOLDER, "+
					  "		  IRSNOTIFICATIONFILE, IRSPAYLOADFILE, IRSMETADATAFILE, ISPLAYLOADREAD, IRSPAYLOADREADFILE, IRSNOTIFICATIONCLASS, UPDATETIMESTAMP) "+
					  "VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,SYSTIMESTAMP)";
				preparedStatement = connection.prepareStatement(sql);
				preparedStatement.setString(1, caseNo);
				preparedStatement.setString(2, new Integer(fatcaFileGeneration.getStatus()).toString());
				preparedStatement.setString(3, new Integer(fatcaFileGeneration.getProgressStatus()).toString());
				preparedStatement.setString(4, fatcaFileGeneration.getStartDate());
				preparedStatement.setString(5, fatcaFileGeneration.getEndDate());
				preparedStatement.setString(6, fatcaFileGeneration.getGeneratedBy());
				preparedStatement.setString(7, fatcaFileGeneration.getMessage());
				preparedStatement.setString(8, fatcaFileGeneration.getCaseFolderPath());
				preparedStatement.setString(9, fatcaFileGeneration.getFatcaPackageFolder());
				preparedStatement.setString(10, fatcaFileGeneration.getOriginalXMLFile() != null ? fatcaFileGeneration.getOriginalXMLFile().getAbsolutePath() : "");
				preparedStatement.setString(11, fatcaFileGeneration.isOriginalFileValid() == true ? "1" : "0");
				preparedStatement.setString(12, fatcaFileGeneration.getUploadedXMLFile() != null ? fatcaFileGeneration.getUploadedXMLFile().getAbsolutePath() : "");
				preparedStatement.setString(13, fatcaFileGeneration.isUploadedFileValid() == true ? "1" : "0");
				preparedStatement.setString(14, fatcaFileGeneration.getXmlFileToProcess() != null ? fatcaFileGeneration.getXmlFileToProcess().getAbsolutePath() : "");
				preparedStatement.setString(15, fatcaFileGeneration.getSignedXMLFile() != null ? fatcaFileGeneration.getSignedXMLFile().getAbsolutePath() : "");
				preparedStatement.setString(16, fatcaFileGeneration.getGeneratedZipFile() != null ? fatcaFileGeneration.getGeneratedZipFile().getAbsolutePath() : "");
				preparedStatement.setString(17, fatcaFileGeneration.getIRSNotificationFolder());
				preparedStatement.setString(18, fatcaFileGeneration.getIRSNotificationFile() != null ? fatcaFileGeneration.getIRSNotificationFile().getAbsolutePath() : "");
				preparedStatement.setString(19, fatcaFileGeneration.getIRSPayloadFile() != null ? fatcaFileGeneration.getIRSPayloadFile().getAbsolutePath() : "");
				preparedStatement.setString(20, fatcaFileGeneration.getIRSMetadataFile() != null ? fatcaFileGeneration.getIRSMetadataFile().getAbsolutePath() : "");
				preparedStatement.setString(21, fatcaFileGeneration.isPlayloadRead() == true ? "1" : "0");
				preparedStatement.setString(22, fatcaFileGeneration.getIRSPayloadReadFile() != null ? fatcaFileGeneration.getIRSPayloadReadFile().getAbsolutePath() : "");
				preparedStatement.setString(23, fatcaFileGeneration.getIRSNotificationType() != null ? fatcaFileGeneration.getIRSNotificationType().getName() : "");
				preparedStatement.executeUpdate();
			}
			
			connectionUtil.closeResources(connection, preparedStatement, null, null);
			
			int seqNo = 1;
			connection = connectionUtil.getConnection(configuration.getJndiDetails().getJndiName());
			preparedStatement = connection.prepareStatement("INSERT INTO "+schemaName+"TB_FATCAMESSAGELIST(CASENO, SEQNO, TIMESTAMP, MESSAGE) VALUES (?,?,?,?)");
			for(FATCAMessage fatcaMessage : fatcaMessageList){
				preparedStatement.setString(1, caseNo);
				preparedStatement.setInt(2, seqNo);
				preparedStatement.setString(3, fatcaMessage.getTimestamp());
				preparedStatement.setString(4, fatcaMessage.getMessage());
				preparedStatement.addBatch();
				seqNo++;
			}
			preparedStatement.executeBatch();
		}catch(Exception e){
			log.error("Error while saving FATCA status : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, null, null);
		}
	}
	
	public boolean checkFATCAStatusAvailable(Configuration configuration, String caseNo, boolean deleteMessage){
		boolean isAvailable = false;
		Connection connection = connectionUtil.getConnection(configuration.getJndiDetails().getJndiName());
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			if(deleteMessage){
				preparedStatement = connection.prepareStatement("DELETE FROM "+schemaName+"TB_FATCAMESSAGELIST WHERE CASENO = ?");
				preparedStatement.setString(1, caseNo);
				preparedStatement.executeUpdate();
				
				connectionUtil.closeResources(connection, preparedStatement, resultSet, null);			
				connection = connectionUtil.getConnection(configuration.getJndiDetails().getJndiName());
			}
			
			preparedStatement = connection.prepareStatement("SELECT COUNT(1) FROM "+schemaName+"TB_FATCACASESTATUS WHERE CASENO = ?");
			preparedStatement.setString(1, caseNo);
			resultSet = preparedStatement.executeQuery();
			if(resultSet.next())
				if(resultSet.getInt(1) > 0) 
					isAvailable = true;
		}catch(Exception e){
			log.error("Error while saving FATCA status : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return isAvailable;
	}
	
	public void removeFATCAStatus(String caseNo){
		Connection connection = getConnection();
		PreparedStatement preparedStatement = null;
		try{
			preparedStatement = connection.prepareStatement("DELETE FROM "+schemaName+"TB_FATCAMESSAGELIST WHERE CASENO = ?");
			preparedStatement.setString(1, caseNo);
			preparedStatement.executeUpdate();
			
			connectionUtil.closeResources(connection, preparedStatement, null, null);
			connection = getConnection();
			
			preparedStatement = connection.prepareStatement("DELETE FROM "+schemaName+"TB_FATCACASESTATUS WHERE CASENO = ?");
			preparedStatement.setString(1, caseNo);
			preparedStatement.executeUpdate();
		}catch(Exception e){
			log.error("Error while saving FATCA status : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, null, null);
		}
	}
	
	private Date stringToDate(String date){
		Date currDate = new Date();
		try{
			SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss.SSS");
			currDate = sdf.parse(date);
		}catch(Exception e){}
		return date == null ? null : currDate;
	}
	
	public void loadFATCAStatusFromDB(Configuration configuration, String caseNo){
		if(checkFATCAStatusAvailable(configuration, caseNo, false)){
			Connection connection = connectionUtil.getConnection(configuration.getJndiDetails().getJndiName());
			PreparedStatement preparedStatement = null;
			ResultSet resultSet = null;
			try{
				preparedStatement = connection.prepareStatement("SELECT STATUS, PROGRESSSTATUS, STARTTIME, ENDTIME, GENERATEDBY, "+
																"       MESSAGE, CASEFOLDERPATH, FATCAPACKAGEFOLDER, COMPASSXMLFILE, "+
																"		COMPASSXMLFILEVALID, UPLOADEDXMLFILE, UPLOADEDXMLFILEVALID, "+
																"		XMLFILEPROCESSED, SIGNEDXMLFILE, GENERATEDZIPFILE, IRSNOTIFICATIONFOLDER, "+
																"		IRSNOTIFICATIONFILE, IRSPAYLOADFILE, IRSMETADATAFILE "+
																"  FROM "+schemaName+"TB_FATCACASESTATUS "+
																" WHERE CASENO = ?");
				preparedStatement.setString(1, caseNo);
				resultSet = preparedStatement.executeQuery();
				if(resultSet.next()){					
					FATCAReportingStatus.setFATCAReportingStatus(caseNo, null);
					FATCAFileGeneration fatcaFileGeneration = new FATCAFileGeneration();
					fatcaFileGeneration.setStatus(resultSet.getString("STATUS") != null ? Integer.parseInt(resultSet.getString("STATUS")) : 0);
					fatcaFileGeneration.setProgressStatus(resultSet.getString("PROGRESSSTATUS") != null ? Integer.parseInt(resultSet.getString("PROGRESSSTATUS")) : 0);
					fatcaFileGeneration.setStartDate(stringToDate(resultSet.getString("STARTTIME")));
					fatcaFileGeneration.setEndDate(stringToDate(resultSet.getString("ENDTIME")));
					fatcaFileGeneration.setGeneratedBy(resultSet.getString("GENERATEDBY"));
					fatcaFileGeneration.setMessage(resultSet.getString("MESSAGE"));
					fatcaFileGeneration.setCaseFolderPath(resultSet.getString("CASEFOLDERPATH"));
					fatcaFileGeneration.setFatcaPackageFolder(resultSet.getString("FATCAPACKAGEFOLDER"));
					fatcaFileGeneration.setOriginalXMLFile(resultSet.getString("COMPASSXMLFILE") != null ? new File(resultSet.getString("COMPASSXMLFILE")) : null);
					fatcaFileGeneration.setOriginalFileValid(resultSet.getString("COMPASSXMLFILEVALID").equals("1") ? true : false);
					fatcaFileGeneration.setUploadedXMLFile(resultSet.getString("UPLOADEDXMLFILE") != null ? new File(resultSet.getString("UPLOADEDXMLFILE")) : null);
					fatcaFileGeneration.setUploadedFileValid(resultSet.getString("UPLOADEDXMLFILEVALID").equals("1") ? true : false);
					fatcaFileGeneration.setXmlFileToProcess(resultSet.getString("XMLFILEPROCESSED") != null ? new File(resultSet.getString("XMLFILEPROCESSED")) : null);
					fatcaFileGeneration.setSignedXMLFile(resultSet.getString("SIGNEDXMLFILE") != null ? new File(resultSet.getString("SIGNEDXMLFILE")) : null);
					fatcaFileGeneration.setGeneratedZipFile(resultSet.getString("GENERATEDZIPFILE") != null ? new File(resultSet.getString("GENERATEDZIPFILE")) : null);
					fatcaFileGeneration.setIRSNotificationFolder(resultSet.getString("IRSNOTIFICATIONFOLDER"));
					fatcaFileGeneration.setIRSNotificationFile(resultSet.getString("IRSNOTIFICATIONFILE") != null ? new File(resultSet.getString("IRSNOTIFICATIONFILE")) : null);
					fatcaFileGeneration.setIRSPayloadFile(resultSet.getString("IRSPAYLOADFILE") != null ? new File(resultSet.getString("IRSPAYLOADFILE")) : null);
					fatcaFileGeneration.setIRSMetadataFile(resultSet.getString("IRSMETADATAFILE") != null ? new File(resultSet.getString("IRSMETADATAFILE")) : null);
					FATCAReportingStatus.setFATCAReportingStatus(caseNo, fatcaFileGeneration);
				}
				
				connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
				connection = connectionUtil.getConnection(configuration.getJndiDetails().getJndiName());
				
				preparedStatement = connection.prepareStatement("SELECT TIMESTAMP, MESSAGE FROM "+schemaName+"TB_FATCAMESSAGELIST WHERE CASENO = ? ORDER BY SEQNO ASC");
				preparedStatement.setString(1, caseNo);
				resultSet = preparedStatement.executeQuery();
				while(resultSet.next()){
					FATCAReportingStatus.setFATCAMessage(caseNo, new FATCAMessage(stringToDate(resultSet.getString("TIMESTAMP")), resultSet.getString("MESSAGE")));
				}
			}catch(Exception e){
				log.error("Error while saving FATCA status : "+e.getMessage());
				e.printStackTrace();
			}finally{
				connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
			}
		}
	}
}

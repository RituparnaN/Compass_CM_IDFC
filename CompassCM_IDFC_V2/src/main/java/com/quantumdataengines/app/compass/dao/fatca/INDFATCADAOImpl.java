package com.quantumdataengines.app.compass.dao.fatca;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Repository;

import com.quantumdataengines.app.compass.util.ConnectionUtil;

@Repository
public class INDFATCADAOImpl implements INDFATCADAO{

	private static final Logger log = LoggerFactory.getLogger(INDFATCADAOImpl.class);
	
	@Autowired
	private ConnectionUtil connectionUtil;
	
	@Value("${compass.aml.config.schemaName}")
	private String schemaName;
	
	public Map<String, String> getIndianFATCAStatementDetails(String caseNo, String usercode){
		Map<String, String> mainMap = new HashMap<String, String>();
		Connection connection = connectionUtil.getConnection();
		CallableStatement callableStatement = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			callableStatement = connection.prepareCall("{CALL "+schemaName+"STP_SETINDFATCAFORMRMDETAILS(?, ?)}");
			callableStatement.setString(1, caseNo);
			callableStatement.setString(2, usercode);
			callableStatement.execute();
			
			preparedStatement = connection.prepareStatement("SELECT REPORTINGENTITYNAME, ITDREIN, GIIN, REGNO, REPORTINGENTITYCAT, "+
															"		STATEMENTTYPE, STATEMENTNO, ORIGINALSTATEMENTID, REASONOFCORRECTION, "+
															"		STATEMENTDATE, REPORTINGPERIOD, REPORTTYPE, NOOFREPORTS, PRINCIPALOFFICERNAME, "+
															"		PRINCIPALOFFICERDESGN, PRINCIPALOFFICERADDRESS, PRINCIPALOFFICERCITY, "+
															"		PRINCIPALOFFICERPOSTALCODE, STATECODE, COUNTRYCODE, TELEPHONE, MOBILE, FAX, EMAIL "+
															"  FROM "+schemaName+"TB_INDFATCASTATEMENTDETAILS "+
															" WHERE CASENO = ?");
			preparedStatement.setString(1, caseNo);
			resultSet = preparedStatement.executeQuery();
			if(resultSet.next()){
				mainMap.put("REPORTINGENTITYNAME", resultSet.getString("REPORTINGENTITYNAME"));
				mainMap.put("ITDREIN", resultSet.getString("ITDREIN"));
				mainMap.put("GIIN", resultSet.getString("GIIN"));
				mainMap.put("REGNO", resultSet.getString("REGNO"));
				mainMap.put("REPORTINGENTITYCAT", resultSet.getString("REPORTINGENTITYCAT"));
				mainMap.put("STATEMENTTYPE", resultSet.getString("STATEMENTTYPE"));
				mainMap.put("STATEMENTNO", resultSet.getString("STATEMENTNO"));
				mainMap.put("ORIGINALSTATEMENTID", resultSet.getString("ORIGINALSTATEMENTID"));
				mainMap.put("REASONOFCORRECTION", resultSet.getString("REASONOFCORRECTION"));
				mainMap.put("STATEMENTDATE", resultSet.getString("STATEMENTDATE"));
				mainMap.put("REPORTINGPERIOD", resultSet.getString("REPORTINGPERIOD"));
				mainMap.put("REPORTTYPE", resultSet.getString("REPORTTYPE"));
				mainMap.put("NOOFREPORTS", resultSet.getString("NOOFREPORTS"));
				mainMap.put("PRINCIPALOFFICERNAME", resultSet.getString("PRINCIPALOFFICERNAME"));
				mainMap.put("PRINCIPALOFFICERDESGN", resultSet.getString("PRINCIPALOFFICERDESGN"));
				mainMap.put("PRINCIPALOFFICERADDRESS", resultSet.getString("PRINCIPALOFFICERADDRESS"));
				mainMap.put("PRINCIPALOFFICERCITY", resultSet.getString("PRINCIPALOFFICERCITY"));
				mainMap.put("PRINCIPALOFFICERPOSTALCODE", resultSet.getString("PRINCIPALOFFICERPOSTALCODE"));
				mainMap.put("STATECODE", resultSet.getString("STATECODE"));
				mainMap.put("COUNTRYCODE", resultSet.getString("COUNTRYCODE"));
				mainMap.put("TELEPHONE", resultSet.getString("TELEPHONE"));
				mainMap.put("MOBILE", resultSet.getString("MOBILE"));
				mainMap.put("FAX", resultSet.getString("FAX"));
				mainMap.put("EMAIL", resultSet.getString("EMAIL"));
				
			}
		}catch(Exception e){
			log.error("Error while getting Indian Fatca satement details : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return mainMap;
	}
	
	public List<Map<String, Object>> getReportAccountDetails(String caseNo){
		List<Map<String, Object>> mainList = new ArrayList<Map<String, Object>>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareStatement("SELECT REPORTSERIALNO, ORIGINALREPORTSERIALNO, ACCOUNTTYPE, ACCOUNTNUMBER, ACCOUNTNUMBERTYPE, ACCOUNTHOLDERNAME, "+
															"		ACCOUNTSTATUS, ACCOUNTTREATMENT, SELFCERTIFICATION, DOCSTATUS, ACCOUNTCLOSEDDATE, "+
															"		BRANCHNUMBERTYPE, BRANCHREFNO, BRANCHNAME, BRANCHADDR, BRANCHCITY, BRANCHPOSTALCODE, "+
															"		BRANCHSTATECODE, BRANCHCOUNTRYCODE, BRANCHTELEPHONE, BRANCHMOBILE, BRANCHFAX, "+
															"		BRANCHEMAIL, ACCOUNTBALANCE, AGGRGROSSINSTPAID, AGGRGROSSDVDNTPAID, GROSSPROCEEDFROMSALE, "+
															"		AGGRGROSSAMNTALLOTHINCOME, AGGRGROSSAMNTCRDT, AGGRGROSSAMNTDEBT "+
															"  FROM "+schemaName+"TB_INDFATCAREPORTDETAILS "+
															" WHERE CASENO = ?");
			preparedStatement.setString(1, caseNo);
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()){
				Map<String, Object> mainMap = new HashMap<String, Object>();
				String accountNo = resultSet.getString("ACCOUNTNUMBER");
				
				mainMap.put("REPORTSERIALNO", resultSet.getString("REPORTSERIALNO"));
				mainMap.put("ORIGINALREPORTSERIALNO", resultSet.getString("ORIGINALREPORTSERIALNO"));
				mainMap.put("ACCOUNTTYPE", resultSet.getString("ACCOUNTTYPE"));
				mainMap.put("ACCOUNTNUMBER", resultSet.getString("ACCOUNTNUMBER"));
				mainMap.put("ACCOUNTNUMBERTYPE", resultSet.getString("ACCOUNTNUMBERTYPE"));
				mainMap.put("ACCOUNTHOLDERNAME", resultSet.getString("ACCOUNTHOLDERNAME"));
				mainMap.put("ACCOUNTSTATUS", resultSet.getString("ACCOUNTSTATUS"));
				mainMap.put("ACCOUNTTREATMENT", resultSet.getString("ACCOUNTTREATMENT"));
				mainMap.put("SELFCERTIFICATION", resultSet.getString("SELFCERTIFICATION"));
				mainMap.put("DOCSTATUS", resultSet.getString("DOCSTATUS"));
				mainMap.put("ACCOUNTCLOSEDDATE", resultSet.getString("ACCOUNTCLOSEDDATE"));
				mainMap.put("BRANCHNUMBERTYPE", resultSet.getString("BRANCHNUMBERTYPE"));
				mainMap.put("BRANCHREFNO", resultSet.getString("BRANCHREFNO"));
				mainMap.put("BRANCHNAME", resultSet.getString("BRANCHNAME"));
				mainMap.put("BRANCHADDR", resultSet.getString("BRANCHADDR"));
				mainMap.put("BRANCHCITY", resultSet.getString("BRANCHCITY"));
				mainMap.put("BRANCHPOSTALCODE", resultSet.getString("BRANCHPOSTALCODE"));
				mainMap.put("BRANCHSTATECODE", resultSet.getString("BRANCHSTATECODE"));
				mainMap.put("BRANCHCOUNTRYCODE", resultSet.getString("BRANCHCOUNTRYCODE"));
				mainMap.put("BRANCHTELEPHONE", resultSet.getString("BRANCHTELEPHONE"));
				mainMap.put("BRANCHMOBILE", resultSet.getString("BRANCHMOBILE"));
				mainMap.put("BRANCHFAX", resultSet.getString("BRANCHFAX"));
				mainMap.put("BRANCHEMAIL", resultSet.getString("BRANCHEMAIL"));
				mainMap.put("ACCOUNTBALANCE", resultSet.getString("ACCOUNTBALANCE"));
				mainMap.put("AGGRGROSSINSTPAID", resultSet.getString("AGGRGROSSINSTPAID"));
				mainMap.put("AGGRGROSSDVDNTPAID", resultSet.getString("AGGRGROSSDVDNTPAID"));
				mainMap.put("GROSSPROCEEDFROMSALE", resultSet.getString("GROSSPROCEEDFROMSALE"));
				mainMap.put("AGGRGROSSAMNTALLOTHINCOME", resultSet.getString("AGGRGROSSAMNTALLOTHINCOME"));
				mainMap.put("AGGRGROSSAMNTCRDT", resultSet.getString("AGGRGROSSAMNTCRDT"));
				mainMap.put("AGGRGROSSAMNTDEBT", resultSet.getString("AGGRGROSSAMNTDEBT"));
				
				List<Map<String, String>> individualDetails = getAccountIndividualDetails(caseNo, accountNo);
				List<Map<String, String>> entityDetails = getAccountEntityDetails(caseNo, accountNo);
				List<Map<String, String>> controllingPersonDetails = getAccountControllingPersonDetails(caseNo, accountNo);
				
				mainMap.put("INDIVIDUALDETAILS", individualDetails);
				mainMap.put("ENTITYDETAILS", entityDetails);
				mainMap.put("CONTROLLINGPERSONDETAILS", controllingPersonDetails);
				
				mainList.add(mainMap);
			}
		}catch(Exception e){
			log.error("Error while getting Indian Fatca satement details : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return mainList;
	}
	
	public List<Map<String, String>> getAccountIndividualDetails(String caseNo, String accountNo){
		List<Map<String, String>> indvMap = new ArrayList<Map<String, String>>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareStatement("SELECT INDIVIDUALID, NAME, CUSTOMERID, FATHERNAME, SPOUSENAME, GENDER, PAN, ADHAARNO, IDTYPE, "+
															"		IDNO, OCCUPATIONTYPE, OCCUPATION, DATEOFBIRTH, NATIONALITY, COUNTRYOFRESIDENCE, "+
															"		PLACEOFBIRTH, COUNTRYOFBIRTH, TIN, TINISSUNINGCOUNTRY, ADDRTYPE, ADDR, CITY ,"+
															"		POSTALCODE, STATECODE, COUNTRYCODE, TELEPHONE, OTHERCONTACTNO, REMARKS "+
															"  FROM "+schemaName+"TB_INDFATCAINDIVIDUALDETAILS "+
															" WHERE CASENO = ? "+
															"   AND ACCOUNTNO = ?");
			preparedStatement.setString(1, caseNo);
			preparedStatement.setString(2, accountNo);
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()){
				Map<String, String> mainMap = new HashMap<String, String>();
				mainMap.put("INDIVIDUALID", resultSet.getString("INDIVIDUALID"));
				mainMap.put("NAME", resultSet.getString("NAME"));
				mainMap.put("CUSTOMERID", resultSet.getString("CUSTOMERID"));
				mainMap.put("FATHERNAME", resultSet.getString("FATHERNAME"));
				mainMap.put("SPOUSENAME", resultSet.getString("SPOUSENAME"));
				mainMap.put("GENDER", resultSet.getString("GENDER"));
				mainMap.put("PAN", resultSet.getString("PAN"));
				mainMap.put("ADHAARNO", resultSet.getString("ADHAARNO"));
				mainMap.put("IDTYPE", resultSet.getString("IDTYPE"));
				mainMap.put("IDNO", resultSet.getString("IDNO"));
				mainMap.put("OCCUPATIONTYPE", resultSet.getString("OCCUPATIONTYPE"));
				mainMap.put("OCCUPATION", resultSet.getString("OCCUPATION"));
				mainMap.put("DATEOFBIRTH", resultSet.getString("DATEOFBIRTH"));
				mainMap.put("NATIONALITY", resultSet.getString("NATIONALITY"));
				mainMap.put("COUNTRYOFRESIDENCE", resultSet.getString("COUNTRYOFRESIDENCE"));
				mainMap.put("PLACEOFBIRTH", resultSet.getString("PLACEOFBIRTH"));
				mainMap.put("COUNTRYOFBIRTH", resultSet.getString("COUNTRYOFBIRTH"));
				mainMap.put("TIN", resultSet.getString("TIN"));
				mainMap.put("TINISSUNINGCOUNTRY", resultSet.getString("TINISSUNINGCOUNTRY"));
				mainMap.put("ADDRTYPE", resultSet.getString("ADDRTYPE"));
				mainMap.put("ADDR", resultSet.getString("ADDR"));
				mainMap.put("CITY", resultSet.getString("CITY"));
				mainMap.put("POSTALCODE", resultSet.getString("POSTALCODE"));
				mainMap.put("STATECODE", resultSet.getString("STATECODE"));
				mainMap.put("COUNTRYCODE", resultSet.getString("COUNTRYCODE"));
				mainMap.put("TELEPHONE", resultSet.getString("TELEPHONE"));
				mainMap.put("OTHERCONTACTNO", resultSet.getString("OTHERCONTACTNO"));
				mainMap.put("REMARKS", resultSet.getString("REMARKS"));
				
				indvMap.add(mainMap);
			}
		}catch(Exception e){
			log.error("Error while getting Indian Fatca INDIVIDUAL details : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return indvMap;
	}
	
	public List<Map<String, String>> getAccountEntityDetails(String caseNo, String accountNo){
		List<Map<String, String>> entityMap = new ArrayList<Map<String, String>>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareStatement("SELECT ENTITYID, NAME, CUSTOMERID, USACCOUNTHOLDERTYPE, OTHACCOUNTHOLDERTYPE, CONSTITUTIONTYPE, "+
															"		DATEOFINCORPORATION, NATUREOFBUSINESS, PAN, IDTYPE, IDNO, IDISSUINGCOUNTRY, PLACEOFINCORPORATION, "+
															"		COUNTRYOFINCORPORATION, COUNTRYOFRESIDENCE, TIN, TINISSUNINGCOUNTRY, ADDRTYPE, ADDR, CITY, "+
															"		POSTALCODE, STATECODE, COUNTRYCODE, TELEPHONENO, OTHCONTACTNO, REMARKS "+
															"  FROM "+schemaName+"TB_INDFATCAENTITYDETAILS "+
															" WHERE CASENO = ? "+
															"   AND ACCOUNTNO = ?");
			preparedStatement.setString(1, caseNo);
			preparedStatement.setString(2, accountNo);
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()){
				Map<String, String> mainMap = new HashMap<String, String>();
				mainMap.put("ENTITYID", resultSet.getString("ENTITYID"));
				mainMap.put("NAME", resultSet.getString("NAME"));
				mainMap.put("CUSTOMERID", resultSet.getString("CUSTOMERID"));
				mainMap.put("USACCOUNTHOLDERTYPE", resultSet.getString("USACCOUNTHOLDERTYPE"));
				mainMap.put("OTHACCOUNTHOLDERTYPE", resultSet.getString("OTHACCOUNTHOLDERTYPE"));
				mainMap.put("CONSTITUTIONTYPE", resultSet.getString("CONSTITUTIONTYPE"));
				
				mainMap.put("DATEOFINCORPORATION", resultSet.getString("DATEOFINCORPORATION"));
				mainMap.put("NATUREOFBUSINESS", resultSet.getString("NATUREOFBUSINESS"));
				mainMap.put("PAN", resultSet.getString("PAN"));
				mainMap.put("IDTYPE", resultSet.getString("IDTYPE"));
				mainMap.put("IDNO", resultSet.getString("IDNO"));
				mainMap.put("IDISSUINGCOUNTRY", resultSet.getString("IDISSUINGCOUNTRY"));
				mainMap.put("PLACEOFINCORPORATION", resultSet.getString("PLACEOFINCORPORATION"));
				
				mainMap.put("COUNTRYOFINCORPORATION", resultSet.getString("COUNTRYOFINCORPORATION"));
				mainMap.put("COUNTRYOFRESIDENCE", resultSet.getString("COUNTRYOFRESIDENCE"));
				mainMap.put("TIN", resultSet.getString("TIN"));
				mainMap.put("TINISSUNINGCOUNTRY", resultSet.getString("TINISSUNINGCOUNTRY"));
				mainMap.put("ADDRTYPE", resultSet.getString("ADDRTYPE"));
				mainMap.put("ADDR", resultSet.getString("ADDR"));
				mainMap.put("CITY", resultSet.getString("CITY"));
				
				mainMap.put("POSTALCODE", resultSet.getString("POSTALCODE"));
				mainMap.put("STATECODE", resultSet.getString("STATECODE"));
				mainMap.put("COUNTRYCODE", resultSet.getString("COUNTRYCODE"));
				mainMap.put("TELEPHONENO", resultSet.getString("TELEPHONENO"));
				mainMap.put("OTHCONTACTNO", resultSet.getString("OTHCONTACTNO"));
				mainMap.put("REMARKS", resultSet.getString("REMARKS"));
				
				entityMap.add(mainMap);
			}
		}catch(Exception e){
			log.error("Error while getting Indian Fatca Entity details : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return entityMap;
	}
	
	public List<Map<String, String>> getAccountControllingPersonDetails(String caseNo, String accountNo){
		List<Map<String, String>> controllingPersonMap = new ArrayList<Map<String, String>>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareStatement("SELECT CONTROLLINGPERSONID, PERSONTYPE, NAME, CUSTOMERID, FATHERNAME, SPOUSENAME, GENDER, "+
															"		PAN, ADHAARNO, IDTYPE, IDNO, OCCUPATIONTYPE, OCCUPATION, DATEOFBIRTH, NATIONALITY, COUNTRYOFRESIDENCE, "+
															"		PLACEOFBIRTH, COUNTRYOFBIRTH, TIN, TINISSUNINGCOUNTRY, ADDRTYPE, ADDR, CITY, POSTALCODE, "+
															"		STATECODE, COUNTRYCODE, TELEPHONE, OTHERCONTACTNO, REMARKS "+
															"  FROM "+schemaName+"TB_INDFATCACONTROLLINGPERSON "+
															" WHERE CASENO = ? "+
															"   AND ACCOUNTNO = ?");
			preparedStatement.setString(1, caseNo);
			preparedStatement.setString(2, accountNo);
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()){
				Map<String, String> mainMap = new HashMap<String, String>();
				mainMap.put("CONTROLLINGPERSONID", resultSet.getString("CONTROLLINGPERSONID"));
				mainMap.put("PERSONTYPE", resultSet.getString("PERSONTYPE"));
				mainMap.put("NAME", resultSet.getString("NAME"));
				mainMap.put("CUSTOMERID", resultSet.getString("CUSTOMERID"));
				mainMap.put("FATHERNAME", resultSet.getString("FATHERNAME"));
				mainMap.put("SPOUSENAME", resultSet.getString("SPOUSENAME"));
				mainMap.put("GENDER", resultSet.getString("GENDER"));
				
				mainMap.put("PAN", resultSet.getString("PAN"));
				mainMap.put("ADHAARNO", resultSet.getString("ADHAARNO"));
				mainMap.put("IDTYPE", resultSet.getString("IDTYPE"));
				mainMap.put("IDNO", resultSet.getString("IDNO"));
				mainMap.put("OCCUPATIONTYPE", resultSet.getString("OCCUPATIONTYPE"));
				mainMap.put("OCCUPATION", resultSet.getString("OCCUPATION"));
				mainMap.put("DATEOFBIRTH", resultSet.getString("DATEOFBIRTH"));
				mainMap.put("NATIONALITY", resultSet.getString("NATIONALITY"));
				mainMap.put("COUNTRYOFRESIDENCE", resultSet.getString("COUNTRYOFRESIDENCE"));
				
				mainMap.put("PLACEOFBIRTH", resultSet.getString("PLACEOFBIRTH"));
				mainMap.put("COUNTRYOFBIRTH", resultSet.getString("COUNTRYOFBIRTH"));
				mainMap.put("TIN", resultSet.getString("TIN"));
				mainMap.put("TINISSUNINGCOUNTRY", resultSet.getString("TINISSUNINGCOUNTRY"));
				mainMap.put("ADDRTYPE", resultSet.getString("ADDRTYPE"));
				mainMap.put("ADDR", resultSet.getString("ADDR"));
				mainMap.put("CITY", resultSet.getString("CITY"));
				mainMap.put("POSTALCODE", resultSet.getString("POSTALCODE"));
				mainMap.put("STATECODE", resultSet.getString("STATECODE"));				
				mainMap.put("COUNTRYCODE", resultSet.getString("COUNTRYCODE"));
				mainMap.put("TELEPHONE", resultSet.getString("TELEPHONE"));
				mainMap.put("OTHERCONTACTNO", resultSet.getString("OTHERCONTACTNO"));
				mainMap.put("REMARKS", resultSet.getString("REMARKS"));
				
				controllingPersonMap.add(mainMap);
			}
		}catch(Exception e){
			log.error("Error while getting Indian Fatca Controlling Person details : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return controllingPersonMap;
	}
	
	public void updateStatementDetails(Map<String, String> formData, String userCode){
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareStatement("UPDATE "+schemaName+"TB_INDFATCASTATEMENTDETAILS "+
															"	SET REPORTINGENTITYNAME = ?, ITDREIN = ?, GIIN = ?, REGNO = ?, REPORTINGENTITYCAT = ?, "+
															"		STATEMENTTYPE = ?, STATEMENTNO = ?, ORIGINALSTATEMENTID = ?, REASONOFCORRECTION = ?, "+
															"		STATEMENTDATE = ?, REPORTINGPERIOD = ?, REPORTTYPE = ?, NOOFREPORTS = ?, PRINCIPALOFFICERNAME = ?, "+
															"		PRINCIPALOFFICERDESGN = ?, PRINCIPALOFFICERADDRESS = ?, PRINCIPALOFFICERCITY = ?, "+
															"		PRINCIPALOFFICERPOSTALCODE = ?, STATECODE = ?, COUNTRYCODE = ?, TELEPHONE = ?, MOBILE = ?, FAX = ?, EMAIL = ?, "+
															"		UPDATEBY = ?, UPDATETIMESTAMP = SYSTIMESTAMP "+
															" WHERE CASENO = ?");
			preparedStatement.setString(1, formData.get("REPORTINGENTITYNAME"));
			preparedStatement.setString(2, formData.get("ITDREIN"));
			preparedStatement.setString(3, formData.get("GIIN"));
			preparedStatement.setString(4, formData.get("REGNO"));
			preparedStatement.setString(5, formData.get("REPORTINGENTITYCAT"));
			preparedStatement.setString(6, formData.get("STATEMENTTYPE"));
			preparedStatement.setString(7, formData.get("STATEMENTNO"));
			preparedStatement.setString(8, formData.get("ORIGINALSTATEMENTID"));
			preparedStatement.setString(9, formData.get("REASONOFCORRECTION"));
			preparedStatement.setString(10, formData.get("STATEMENTDATE"));
			preparedStatement.setString(11, formData.get("REPORTINGPERIOD"));
			preparedStatement.setString(12, formData.get("REPORTTYPE"));
			preparedStatement.setString(13, formData.get("NOOFREPORTS"));
			preparedStatement.setString(14, formData.get("PRINCIPALOFFICERNAME"));
			preparedStatement.setString(15, formData.get("PRINCIPALOFFICERDESGN"));
			preparedStatement.setString(16, formData.get("PRINCIPALOFFICERADDRESS"));
			preparedStatement.setString(17, formData.get("PRINCIPALOFFICERCITY"));
			preparedStatement.setString(18, formData.get("PRINCIPALOFFICERPOSTALCODE"));
			preparedStatement.setString(19, formData.get("STATECODE"));
			preparedStatement.setString(20, formData.get("COUNTRYCODE"));
			preparedStatement.setString(21, formData.get("TELEPHONE"));
			preparedStatement.setString(22, formData.get("MOBILE"));
			preparedStatement.setString(23, formData.get("FAX"));
			preparedStatement.setString(24, formData.get("EMAIL"));
			preparedStatement.setString(25, userCode);
			preparedStatement.setString(26, formData.get("CASENO"));
			preparedStatement.executeUpdate();
		}catch(Exception e){
			log.error("Error while updating FATCA statement : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
	}
	
	public void addINDFATCAAccount(String caseNo, String userCode, Map<String, String> formData){
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		CallableStatement callableStatement = null;
		ResultSet resultSet = null;
		try{
			
			callableStatement = connection.prepareCall("{CALL "+schemaName+"STP_INDFATCAADDACCTDETAILS(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");
			callableStatement.setString(1, caseNo);
			callableStatement.setString(2, formData.get("REPORTSERIALNO"));
			callableStatement.setString(3, formData.get("ORIGINALREPORTSERIALNO"));
			callableStatement.setString(4, formData.get("ACCOUNTTYPE"));
			callableStatement.setString(5, formData.get("ACCOUNTNUMBER"));
			callableStatement.setString(6, formData.get("ACCOUNTNUMBERTYPE"));
			callableStatement.setString(7, formData.get("ACCOUNTHOLDERNAME"));
			callableStatement.setString(8, formData.get("ACCOUNTSTATUS"));
			callableStatement.setString(9, formData.get("ACCOUNTTREATMENT"));
			callableStatement.setString(10, formData.get("SELFCERTIFICATION"));
			callableStatement.setString(11, formData.get("DOCSTATUS"));
			callableStatement.setString(12, formData.get("ACCOUNTCLOSEDDATE"));
			callableStatement.setString(13, formData.get("BRANCHNUMBERTYPE"));
			callableStatement.setString(14, formData.get("BRANCHREFNO"));
			callableStatement.setString(15, formData.get("BRANCHNAME"));
			callableStatement.setString(16, formData.get("BRANCHADDR"));
			callableStatement.setString(17, formData.get("BRANCHCITY"));
			callableStatement.setString(18, formData.get("BRANCHPOSTALCODE"));
			callableStatement.setString(19, formData.get("BRANCHSTATECODE"));
			callableStatement.setString(20, formData.get("BRANCHCOUNTRYCODE"));
			callableStatement.setString(21, formData.get("BRANCHTELEPHONE"));
			callableStatement.setString(22, formData.get("BRANCHMOBILE"));
			callableStatement.setString(23, formData.get("BRANCHFAX"));
			callableStatement.setString(24, formData.get("BRANCHEMAIL"));
			callableStatement.setString(25, formData.get("ACCOUNTBALANCE"));
			callableStatement.setString(26, formData.get("AGGRGROSSINSTPAID"));
			callableStatement.setString(27, formData.get("AGGRGROSSDVDNTPAID"));
			callableStatement.setString(28, formData.get("GROSSPROCEEDFROMSALE"));
			callableStatement.setString(29, formData.get("AGGRGROSSAMNTALLOTHINCOME"));
			callableStatement.setString(30, formData.get("AGGRGROSSAMNTCRDT"));
			callableStatement.setString(31, formData.get("AGGRGROSSAMNTDEBT"));
			callableStatement.setString(32, userCode);

			callableStatement.executeUpdate();
			/*
			preparedStatement = connection.prepareStatement("INSERT INTO "+schemaName+"TB_INDFATCAREPORTDETAILS(CASENO, REPORTSERIALNO, ORIGINALREPORTSERIALNO, ACCOUNTTYPE, ACCOUNTNUMBER, "+
															"		ACCOUNTNUMBERTYPE, ACCOUNTHOLDERNAME, ACCOUNTSTATUS, ACCOUNTTREATMENT, SELFCERTIFICATION, DOCSTATUS, ACCOUNTCLOSEDDATE, "+
															"		BRANCHNUMBERTYPE, BRANCHREFNO, BRANCHNAME, BRANCHADDR, BRANCHCITY, BRANCHPOSTALCODE, BRANCHSTATECODE, "+
															"		BRANCHCOUNTRYCODE, BRANCHTELEPHONE, BRANCHMOBILE, BRANCHFAX, BRANCHEMAIL, ACCOUNTBALANCE, AGGRGROSSINSTPAID, "+
															"		AGGRGROSSDVDNTPAID, GROSSPROCEEDFROMSALE, AGGRGROSSAMNTALLOTHINCOME, AGGRGROSSAMNTCRDT, AGGRGROSSAMNTDEBT, "+
															"		UPDATEBY, UPDATETIMESTAMP) "+
															"VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,SYSTIMESTAMP)");
			preparedStatement.setString(1, caseNo);
			preparedStatement.setString(2, formData.get("REPORTSERIALNO"));
			preparedStatement.setString(3, formData.get("ORIGINALREPORTSERIALNO"));
			preparedStatement.setString(4, formData.get("ACCOUNTTYPE"));
			preparedStatement.setString(5, formData.get("ACCOUNTNUMBER"));
			preparedStatement.setString(6, formData.get("ACCOUNTNUMBERTYPE"));
			preparedStatement.setString(7, formData.get("ACCOUNTHOLDERNAME"));
			preparedStatement.setString(8, formData.get("ACCOUNTSTATUS"));
			preparedStatement.setString(9, formData.get("ACCOUNTTREATMENT"));
			preparedStatement.setString(10, formData.get("SELFCERTIFICATION"));
			preparedStatement.setString(11, formData.get("DOCSTATUS"));
			preparedStatement.setString(12, formData.get("ACCOUNTCLOSEDDATE"));
			preparedStatement.setString(13, formData.get("BRANCHNUMBERTYPE"));
			preparedStatement.setString(14, formData.get("BRANCHREFNO"));
			preparedStatement.setString(15, formData.get("BRANCHNAME"));
			preparedStatement.setString(16, formData.get("BRANCHADDR"));
			preparedStatement.setString(17, formData.get("BRANCHCITY"));
			preparedStatement.setString(18, formData.get("BRANCHPOSTALCODE"));
			preparedStatement.setString(19, formData.get("BRANCHSTATECODE"));
			preparedStatement.setString(20, formData.get("BRANCHCOUNTRYCODE"));
			preparedStatement.setString(21, formData.get("BRANCHTELEPHONE"));
			preparedStatement.setString(22, formData.get("BRANCHMOBILE"));
			preparedStatement.setString(23, formData.get("BRANCHFAX"));
			preparedStatement.setString(24, formData.get("BRANCHEMAIL"));
			preparedStatement.setString(25, formData.get("ACCOUNTBALANCE"));
			preparedStatement.setString(26, formData.get("AGGRGROSSINSTPAID"));
			preparedStatement.setString(27, formData.get("AGGRGROSSDVDNTPAID"));
			preparedStatement.setString(28, formData.get("GROSSPROCEEDFROMSALE"));
			preparedStatement.setString(29, formData.get("AGGRGROSSAMNTALLOTHINCOME"));
			preparedStatement.setString(30, formData.get("AGGRGROSSAMNTCRDT"));
			preparedStatement.setString(31, formData.get("AGGRGROSSAMNTDEBT"));
			preparedStatement.setString(32, userCode);
			preparedStatement.executeUpdate();
		    */
		}catch(Exception e){
			log.error("Error while adding FATCA account : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
	}

	// @Override
	public void updateINDFATCAAccount(String caseNo, String userCode, Map<String, String> formData) {
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareStatement("UPDATE "+schemaName+"TB_INDFATCAREPORTDETAILS "+
															"	SET	REPORTSERIALNO = ?, ORIGINALREPORTSERIALNO = ?, ACCOUNTTYPE = ?, ACCOUNTNUMBERTYPE = ?, ACCOUNTHOLDERNAME = ?, "+
															"		ACCOUNTSTATUS = ?, ACCOUNTTREATMENT = ?, SELFCERTIFICATION = ?, DOCSTATUS = ?, ACCOUNTCLOSEDDATE = ?, "+
															"		BRANCHNUMBERTYPE = ?, BRANCHREFNO = ?, BRANCHNAME = ?, BRANCHADDR = ?, BRANCHCITY = ?, BRANCHPOSTALCODE = ?, "+
															"		BRANCHSTATECODE = ?, BRANCHCOUNTRYCODE = ?, BRANCHTELEPHONE = ?, BRANCHMOBILE = ?, BRANCHFAX = ?, "+
															"		BRANCHEMAIL = ?, ACCOUNTBALANCE = ?, AGGRGROSSINSTPAID = ?, AGGRGROSSDVDNTPAID = ?, GROSSPROCEEDFROMSALE = ?, "+
															"		AGGRGROSSAMNTALLOTHINCOME = ?, AGGRGROSSAMNTCRDT = ?, AGGRGROSSAMNTDEBT = ?, UPDATEBY = ?, UPDATETIMESTAMP = SYSTIMESTAMP "+
															" WHERE CASENO = ? "+
															"   AND ACCOUNTNUMBER = ?");
			preparedStatement.setString(1, formData.get("REPORTSERIALNO"));
			preparedStatement.setString(2, formData.get("ORIGINALREPORTSERIALNO"));
			preparedStatement.setString(3, formData.get("ACCOUNTTYPE"));
			preparedStatement.setString(4, formData.get("ACCOUNTNUMBERTYPE"));
			preparedStatement.setString(5, formData.get("ACCOUNTHOLDERNAME"));
			preparedStatement.setString(6, formData.get("ACCOUNTSTATUS"));
			preparedStatement.setString(7, formData.get("ACCOUNTTREATMENT"));
			preparedStatement.setString(8, formData.get("SELFCERTIFICATION"));
			preparedStatement.setString(9, formData.get("DOCSTATUS"));
			preparedStatement.setString(10, formData.get("ACCOUNTCLOSEDDATE"));
			preparedStatement.setString(11, formData.get("BRANCHNUMBERTYPE"));
			preparedStatement.setString(12, formData.get("BRANCHREFNO"));
			preparedStatement.setString(13, formData.get("BRANCHNAME"));
			preparedStatement.setString(14, formData.get("BRANCHADDR"));
			preparedStatement.setString(15, formData.get("BRANCHCITY"));
			preparedStatement.setString(16, formData.get("BRANCHPOSTALCODE"));
			preparedStatement.setString(17, formData.get("BRANCHSTATECODE"));
			preparedStatement.setString(18, formData.get("BRANCHCOUNTRYCODE"));
			preparedStatement.setString(19, formData.get("BRANCHTELEPHONE"));
			preparedStatement.setString(20, formData.get("BRANCHMOBILE"));
			preparedStatement.setString(21, formData.get("BRANCHFAX"));
			preparedStatement.setString(22, formData.get("BRANCHEMAIL"));
			preparedStatement.setString(23, formData.get("ACCOUNTBALANCE"));
			preparedStatement.setString(24, formData.get("AGGRGROSSINSTPAID"));
			preparedStatement.setString(25, formData.get("AGGRGROSSDVDNTPAID"));
			preparedStatement.setString(26, formData.get("GROSSPROCEEDFROMSALE"));
			preparedStatement.setString(27, formData.get("AGGRGROSSAMNTALLOTHINCOME"));
			preparedStatement.setString(28, formData.get("AGGRGROSSAMNTCRDT"));
			preparedStatement.setString(29, formData.get("AGGRGROSSAMNTDEBT"));
			preparedStatement.setString(30, userCode);
			preparedStatement.setString(31, caseNo);
			preparedStatement.setString(32, formData.get("ACCOUNTNUMBER"));
			preparedStatement.executeUpdate();
		}catch(Exception e){
			log.error("Error while adding FATCA account : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
	}
	
	public void deleteINDFATCAAccountDetails(String caseNo, String accountNo){
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareStatement("DELETE FROM "+schemaName+"TB_INDFATCAREPORTDETAILS WHERE CASENO = ? AND ACCOUNTNUMBER = ? ");
			preparedStatement.setString(1, caseNo);
			preparedStatement.setString(2, accountNo);
			preparedStatement.executeUpdate();
		}catch(Exception e){
			log.error("Error while deleting FATCA account : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
	}
	
	public void addINDFATCAIndividual(String caseNo, String accountNo, String userCode, Map<String, String> formData){
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		CallableStatement callableStatement = null;
		ResultSet resultSet = null;
		try{
			callableStatement = connection.prepareCall("{CALL "+schemaName+"STP_INDFATCAADDINDIDETAILS(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");
			
			callableStatement.setString(1, caseNo);
			callableStatement.setString(2, accountNo);
			callableStatement.setString(3, generateID("INDVIDUAL"));
			callableStatement.setString(4, formData.get("NAME"));
			callableStatement.setString(5, formData.get("CUSTOMERID"));
			callableStatement.setString(6, formData.get("FATHERNAME"));
			
			callableStatement.setString(7, formData.get("SPOUSENAME"));
			callableStatement.setString(8, formData.get("GENDER"));
			callableStatement.setString(9, formData.get("PAN"));
			callableStatement.setString(10, formData.get("ADHAARNO"));
			callableStatement.setString(11, formData.get("IDTYPE"));
			callableStatement.setString(12, formData.get("IDNO"));
			callableStatement.setString(13, formData.get("OCCUPATIONTYPE"));
			callableStatement.setString(14, formData.get("OCCUPATION"));
			callableStatement.setString(15, formData.get("DATEOFBIRTH"));
			callableStatement.setString(16, formData.get("NATIONALITY"));
			
			callableStatement.setString(17, formData.get("COUNTRYOFRESIDENCE"));
			callableStatement.setString(18, formData.get("PLACEOFBIRTH"));
			callableStatement.setString(19, formData.get("COUNTRYOFBIRTH"));
			callableStatement.setString(20, formData.get("TIN"));
			callableStatement.setString(21, formData.get("TINISSUNINGCOUNTRY"));
			callableStatement.setString(22, formData.get("ADDRTYPE"));
			callableStatement.setString(23, formData.get("ADDR"));
			callableStatement.setString(24, formData.get("CITY"));
			callableStatement.setString(25, formData.get("POSTALCODE"));
			callableStatement.setString(26, formData.get("STATECODE"));
			callableStatement.setString(27, formData.get("COUNTRYCODE"));
			callableStatement.setString(28, formData.get("TELEPHONE"));
			callableStatement.setString(29, formData.get("OTHERCONTACTNO"));
			callableStatement.setString(30, formData.get("REMARKS"));
			callableStatement.setString(31, userCode);
			callableStatement.executeUpdate();
			
			/*
			preparedStatement = connection.prepareStatement("INSERT INTO "+schemaName+"TB_INDFATCAINDIVIDUALDETAILS(CASENO, ACCOUNTNO, INDIVIDUALID, NAME, CUSTOMERID, FATHERNAME, "+
															"		SPOUSENAME, GENDER, PAN, ADHAARNO, IDTYPE, IDNO, OCCUPATIONTYPE, OCCUPATION, DATEOFBIRTH, NATIONALITY, "+
															"		COUNTRYOFRESIDENCE, PLACEOFBIRTH, COUNTRYOFBIRTH, TIN, TINISSUNINGCOUNTRY, ADDRTYPE, ADDR, CITY, "+
															"		POSTALCODE, STATECODE, COUNTRYCODE, TELEPHONE, OTHERCONTACTNO, REMARKS, UPDATEBY, UPDATETIMESTAMP) "+
															"VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,SYSTIMESTAMP)");
			preparedStatement.setString(1, caseNo);
			preparedStatement.setString(2, accountNo);
			preparedStatement.setString(3, generateID("INDVIDUAL"));
			preparedStatement.setString(4, formData.get("NAME"));
			preparedStatement.setString(5, formData.get("CUSTOMERID"));
			preparedStatement.setString(6, formData.get("FATHERNAME"));
			
			preparedStatement.setString(7, formData.get("SPOUSENAME"));
			preparedStatement.setString(8, formData.get("GENDER"));
			preparedStatement.setString(9, formData.get("PAN"));
			preparedStatement.setString(10, formData.get("ADHAARNO"));
			preparedStatement.setString(11, formData.get("IDTYPE"));
			preparedStatement.setString(12, formData.get("IDNO"));
			preparedStatement.setString(13, formData.get("OCCUPATIONTYPE"));
			preparedStatement.setString(14, formData.get("OCCUPATION"));
			preparedStatement.setString(15, formData.get("DATEOFBIRTH"));
			preparedStatement.setString(16, formData.get("NATIONALITY"));
			
			preparedStatement.setString(17, formData.get("COUNTRYOFRESIDENCE"));
			preparedStatement.setString(18, formData.get("PLACEOFBIRTH"));
			preparedStatement.setString(19, formData.get("COUNTRYOFBIRTH"));
			preparedStatement.setString(20, formData.get("TIN"));
			preparedStatement.setString(21, formData.get("TINISSUNINGCOUNTRY"));
			preparedStatement.setString(22, formData.get("ADDRTYPE"));
			preparedStatement.setString(23, formData.get("ADDR"));
			preparedStatement.setString(24, formData.get("CITY"));
			preparedStatement.setString(25, formData.get("POSTALCODE"));
			preparedStatement.setString(26, formData.get("STATECODE"));
			preparedStatement.setString(27, formData.get("COUNTRYCODE"));
			preparedStatement.setString(28, formData.get("TELEPHONE"));
			preparedStatement.setString(29, formData.get("OTHERCONTACTNO"));
			preparedStatement.setString(30, formData.get("REMARKS"));
			preparedStatement.setString(31, userCode);
			preparedStatement.executeUpdate();
			*/
		}catch(Exception e){
			log.error("Error while adding FATCA individual : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
	}
	
	public void updateINDFATCAIndividual(String caseNo, String accountNo, String idValue, String userCode, Map<String, String> formData){
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareStatement("UPDATE "+schemaName+"TB_INDFATCAINDIVIDUALDETAILS "+
															"	SET NAME = ?, CUSTOMERID = ?, FATHERNAME = ?, SPOUSENAME = ?, GENDER = ?, PAN = ?, "+
															"		ADHAARNO = ?, IDTYPE = ?, IDNO = ?, OCCUPATIONTYPE = ?, OCCUPATION = ?, DATEOFBIRTH = ?, "+
															"		NATIONALITY = ?, COUNTRYOFRESIDENCE = ?, PLACEOFBIRTH = ?, COUNTRYOFBIRTH = ?, TIN = ?, "+
															"		TINISSUNINGCOUNTRY = ?, ADDRTYPE = ?, ADDR = ?, CITY = ?, POSTALCODE = ?, STATECODE = ?, "+
															"		COUNTRYCODE = ?, TELEPHONE = ?, OTHERCONTACTNO = ?, REMARKS = ?, UPDATEBY = ?, UPDATETIMESTAMP = SYSTIMESTAMP "+
															" WHERE CASENO = ? "+
															"   AND ACCOUNTNO = ? "+
															"   AND INDIVIDUALID = ?");
			preparedStatement.setString(1, formData.get("NAME"));
			preparedStatement.setString(2, formData.get("CUSTOMERID"));
			preparedStatement.setString(3, formData.get("FATHERNAME"));			
			preparedStatement.setString(4, formData.get("SPOUSENAME"));
			preparedStatement.setString(5, formData.get("GENDER"));
			preparedStatement.setString(6, formData.get("PAN"));
			preparedStatement.setString(7, formData.get("ADHAARNO"));
			preparedStatement.setString(8, formData.get("IDTYPE"));
			preparedStatement.setString(9, formData.get("IDNO"));
			preparedStatement.setString(10, formData.get("OCCUPATIONTYPE"));
			preparedStatement.setString(11, formData.get("OCCUPATION"));
			preparedStatement.setString(12, formData.get("DATEOFBIRTH"));
			preparedStatement.setString(13, formData.get("NATIONALITY"));			
			preparedStatement.setString(14, formData.get("COUNTRYOFRESIDENCE"));
			preparedStatement.setString(15, formData.get("PLACEOFBIRTH"));
			preparedStatement.setString(16, formData.get("COUNTRYOFBIRTH"));
			preparedStatement.setString(17, formData.get("TIN"));
			preparedStatement.setString(18, formData.get("TINISSUNINGCOUNTRY"));
			preparedStatement.setString(19, formData.get("ADDRTYPE"));
			preparedStatement.setString(20, formData.get("ADDR"));
			preparedStatement.setString(21, formData.get("CITY"));
			preparedStatement.setString(22, formData.get("POSTALCODE"));
			preparedStatement.setString(23, formData.get("STATECODE"));
			preparedStatement.setString(24, formData.get("COUNTRYCODE"));
			preparedStatement.setString(25, formData.get("TELEPHONE"));
			preparedStatement.setString(26, formData.get("OTHERCONTACTNO"));
			preparedStatement.setString(27, formData.get("REMARKS"));
			preparedStatement.setString(28, userCode);
			preparedStatement.setString(29, caseNo);
			preparedStatement.setString(30, accountNo);
			preparedStatement.setString(31, idValue);
			preparedStatement.executeUpdate();
		}catch(Exception e){
			log.error("Error while adding FATCA individual : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
	}
	
	public String generateID(String type){
		String id="";
		try{
			SimpleDateFormat sdf = new SimpleDateFormat("ddMMyyyyHHmmssSSS");
			id = type+sdf.format(new Date());
		}catch(Exception e){
			e.printStackTrace();
		}
		return id;
	}
	
	public void addINDFATCAEntity(String caseNo, String accountNo, String userCode, Map<String, String> formData){
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		CallableStatement callableStatement = null;
		ResultSet resultSet = null;
		try{
			callableStatement = connection.prepareCall("{CALL "+schemaName+"STP_INDFATCAADDENTITYDETAILS(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");
			callableStatement.setString(1, caseNo);
			callableStatement.setString(2, accountNo);
			callableStatement.setString(3, generateID("ENTITY"));
			callableStatement.setString(4, formData.get("NAME"));
			callableStatement.setString(5, formData.get("CUSTOMERID"));
			callableStatement.setString(6, formData.get("USACCOUNTHOLDERTYPE"));
			
			callableStatement.setString(7, formData.get("OTHACCOUNTHOLDERTYPE"));
			callableStatement.setString(8, formData.get("CONSTITUTIONTYPE"));
			callableStatement.setString(9, formData.get("DATEOFINCORPORATION"));
			callableStatement.setString(10, formData.get("NATUREOFBUSINESS"));
			callableStatement.setString(11, formData.get("PAN"));
			callableStatement.setString(12, formData.get("IDTYPE"));
			callableStatement.setString(13, formData.get("IDNO"));
			
			callableStatement.setString(14, formData.get("IDISSUINGCOUNTRY"));
			callableStatement.setString(15, formData.get("PLACEOFINCORPORATION"));
			callableStatement.setString(16, formData.get("COUNTRYOFINCORPORATION"));			
			callableStatement.setString(17, formData.get("COUNTRYOFRESIDENCE"));
			callableStatement.setString(18, formData.get("TIN"));
			
			callableStatement.setString(19, formData.get("TINISSUNINGCOUNTRY"));
			callableStatement.setString(20, formData.get("ADDRTYPE"));
			callableStatement.setString(21, formData.get("ADDR"));
			callableStatement.setString(22, formData.get("CITY"));
			callableStatement.setString(23, formData.get("POSTALCODE"));
			callableStatement.setString(24, formData.get("STATECODE"));
			callableStatement.setString(25, formData.get("COUNTRYCODE"));
			callableStatement.setString(26, formData.get("TELEPHONENO"));
			callableStatement.setString(27, formData.get("OTHCONTACTNO"));
			callableStatement.setString(28, formData.get("REMARKS"));
			callableStatement.setString(29, userCode);
			callableStatement.executeUpdate();

			/*
			preparedStatement = connection.prepareStatement("INSERT INTO "+schemaName+"TB_INDFATCAENTITYDETAILS(CASENO, ACCOUNTNO, ENTITYID, NAME, CUSTOMERID, USACCOUNTHOLDERTYPE, "+
															"		OTHACCOUNTHOLDERTYPE, CONSTITUTIONTYPE, DATEOFINCORPORATION, NATUREOFBUSINESS, PAN, IDTYPE, IDNO, "+
															"		IDISSUINGCOUNTRY, PLACEOFINCORPORATION, COUNTRYOFINCORPORATION, COUNTRYOFRESIDENCE, TIN, "+
															"		TINISSUNINGCOUNTRY, ADDRTYPE, ADDR, CITY, POSTALCODE, STATECODE, COUNTRYCODE, TELEPHONENO, "+
															"		OTHCONTACTNO, REMARKS, UPDATEBY, UPDATETIMESTAMP) "+
															"VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,SYSTIMESTAMP)");
			preparedStatement.setString(1, caseNo);
			preparedStatement.setString(2, accountNo);
			preparedStatement.setString(3, generateID("ENTITY"));
			preparedStatement.setString(4, formData.get("NAME"));
			preparedStatement.setString(5, formData.get("CUSTOMERID"));
			preparedStatement.setString(6, formData.get("USACCOUNTHOLDERTYPE"));
			
			preparedStatement.setString(7, formData.get("OTHACCOUNTHOLDERTYPE"));
			preparedStatement.setString(8, formData.get("CONSTITUTIONTYPE"));
			preparedStatement.setString(9, formData.get("DATEOFINCORPORATION"));
			preparedStatement.setString(10, formData.get("NATUREOFBUSINESS"));
			preparedStatement.setString(11, formData.get("PAN"));
			preparedStatement.setString(12, formData.get("IDTYPE"));
			preparedStatement.setString(13, formData.get("IDNO"));
			
			preparedStatement.setString(14, formData.get("IDISSUINGCOUNTRY"));
			preparedStatement.setString(15, formData.get("PLACEOFINCORPORATION"));
			preparedStatement.setString(16, formData.get("COUNTRYOFINCORPORATION"));			
			preparedStatement.setString(17, formData.get("COUNTRYOFRESIDENCE"));
			preparedStatement.setString(18, formData.get("TIN"));
			
			preparedStatement.setString(19, formData.get("TINISSUNINGCOUNTRY"));
			preparedStatement.setString(20, formData.get("ADDRTYPE"));
			preparedStatement.setString(21, formData.get("ADDR"));
			preparedStatement.setString(22, formData.get("CITY"));
			preparedStatement.setString(23, formData.get("POSTALCODE"));
			preparedStatement.setString(24, formData.get("STATECODE"));
			preparedStatement.setString(25, formData.get("COUNTRYCODE"));
			preparedStatement.setString(26, formData.get("TELEPHONENO"));
			preparedStatement.setString(27, formData.get("OTHCONTACTNO"));
			preparedStatement.setString(28, formData.get("REMARKS"));
			preparedStatement.setString(29, userCode);
			preparedStatement.executeUpdate();
			*/
		}catch(Exception e){
			log.error("Error while adding FATCA entity : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
	}
	
	public void updateINDFATCAEntity(String caseNo, String accountNo, String userCode, String idValue, Map<String, String> formData){
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareStatement("UPDATE "+schemaName+"TB_INDFATCAENTITYDETAILS "+
															"	SET	NAME = ?, CUSTOMERID = ?, USACCOUNTHOLDERTYPE = ?, OTHACCOUNTHOLDERTYPE = ?, CONSTITUTIONTYPE = ?, "+
															"		DATEOFINCORPORATION = ?, NATUREOFBUSINESS = ?, PAN = ?, IDTYPE = ?, IDNO = ?, IDISSUINGCOUNTRY = ?, "+
															"		PLACEOFINCORPORATION = ?, COUNTRYOFINCORPORATION = ?, COUNTRYOFRESIDENCE = ?, TIN = ?, "+
															"		TINISSUNINGCOUNTRY = ?, ADDRTYPE = ?, ADDR = ?, CITY = ?, POSTALCODE = ?, STATECODE = ?, COUNTRYCODE = ?, "+
															"		TELEPHONENO = ?, OTHCONTACTNO = ?, REMARKS = ?, UPDATEBY = ?, UPDATETIMESTAMP = SYSTIMESTAMP) "+
															" WHERE CASENO = ? "+
															"	AND ACCOUNTNO = ? "+
															"   AND ENTITYID = ?");
			preparedStatement.setString(1, formData.get("NAME"));
			preparedStatement.setString(2, formData.get("CUSTOMERID"));
			preparedStatement.setString(3, formData.get("USACCOUNTHOLDERTYPE"));			
			preparedStatement.setString(4, formData.get("OTHACCOUNTHOLDERTYPE"));
			preparedStatement.setString(5, formData.get("CONSTITUTIONTYPE"));
			
			preparedStatement.setString(6, formData.get("DATEOFINCORPORATION"));
			preparedStatement.setString(7, formData.get("NATUREOFBUSINESS"));
			preparedStatement.setString(8, formData.get("PAN"));
			preparedStatement.setString(9, formData.get("IDTYPE"));
			preparedStatement.setString(10, formData.get("IDNO"));			
			preparedStatement.setString(11, formData.get("IDISSUINGCOUNTRY"));
			
			preparedStatement.setString(12, formData.get("PLACEOFINCORPORATION"));
			preparedStatement.setString(13, formData.get("COUNTRYOFINCORPORATION"));			
			preparedStatement.setString(14, formData.get("COUNTRYOFRESIDENCE"));
			preparedStatement.setString(15, formData.get("TIN"));
			
			preparedStatement.setString(16, formData.get("TINISSUNINGCOUNTRY"));
			preparedStatement.setString(17, formData.get("ADDRTYPE"));
			preparedStatement.setString(18, formData.get("ADDR"));
			preparedStatement.setString(19, formData.get("CITY"));
			preparedStatement.setString(20, formData.get("POSTALCODE"));
			preparedStatement.setString(21, formData.get("STATECODE"));
			preparedStatement.setString(22, formData.get("COUNTRYCODE"));
			
			preparedStatement.setString(23, formData.get("TELEPHONENO"));
			preparedStatement.setString(24, formData.get("OTHCONTACTNO"));
			preparedStatement.setString(25, formData.get("REMARKS"));
			preparedStatement.setString(26, userCode);
			preparedStatement.setString(27, caseNo);
			preparedStatement.setString(28, accountNo);
			preparedStatement.setString(29, idValue);
			preparedStatement.executeUpdate();
		}catch(Exception e){
			log.error("Error while updating FATCA entity : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
	}
	
	public void addINDFATCAControllingPerson(String caseNo, String accountNo, String userCode, Map<String, String> formData){
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		CallableStatement callableStatement = null;
		ResultSet resultSet = null;
		try{
			callableStatement = connection.prepareCall("{CALL "+schemaName+"STP_INDFATCAADDCNTRLNGDETAILS(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");
			
			callableStatement.setString(1, caseNo);
			callableStatement.setString(2, accountNo);
			callableStatement.setString(3, generateID("CONTROLLINGPERSON"));
			callableStatement.setString(4, formData.get("PERSONTYPE"));
			callableStatement.setString(5, formData.get("NAME"));
			callableStatement.setString(6, formData.get("CUSTOMERID"));
			callableStatement.setString(7, formData.get("FATHERNAME"));
			
			callableStatement.setString(8, formData.get("SPOUSENAME"));
			callableStatement.setString(9, formData.get("GENDER"));
			callableStatement.setString(10, formData.get("PAN"));
			callableStatement.setString(11, formData.get("ADHAARNO"));
			callableStatement.setString(12, formData.get("IDTYPE"));
			callableStatement.setString(13, formData.get("IDNO"));
			callableStatement.setString(14, formData.get("OCCUPATIONTYPE"));
			callableStatement.setString(15, formData.get("OCCUPATION"));
			callableStatement.setString(16, formData.get("DATEOFBIRTH"));
			callableStatement.setString(17, formData.get("NATIONALITY"));
			
			callableStatement.setString(18, formData.get("COUNTRYOFRESIDENCE"));
			callableStatement.setString(19, formData.get("PLACEOFBIRTH"));
			callableStatement.setString(20, formData.get("COUNTRYOFBIRTH"));
			callableStatement.setString(21, formData.get("TIN"));
			callableStatement.setString(22, formData.get("TINISSUNINGCOUNTRY"));
			callableStatement.setString(23, formData.get("ADDRTYPE"));
			callableStatement.setString(24, formData.get("ADDR"));
			callableStatement.setString(25, formData.get("CITY"));
			callableStatement.setString(26, formData.get("POSTALCODE"));
			callableStatement.setString(27, formData.get("STATECODE"));
			callableStatement.setString(28, formData.get("COUNTRYCODE"));
			callableStatement.setString(29, formData.get("TELEPHONE"));
			callableStatement.setString(30, formData.get("OTHERCONTACTNO"));
			callableStatement.setString(31, formData.get("REMARKS"));
			callableStatement.setString(32, userCode);
			callableStatement.executeUpdate();
			
			/*
			preparedStatement = connection.prepareStatement("INSERT INTO "+schemaName+"TB_INDFATCACONTROLLINGPERSON(CASENO, ACCOUNTNO, CONTROLLINGPERSONID, PERSONTYPE, NAME, CUSTOMERID, "+
															"		FATHERNAME, SPOUSENAME, GENDER, PAN, ADHAARNO, IDTYPE, IDNO, OCCUPATIONTYPE, OCCUPATION, DATEOFBIRTH, "+
															"		NATIONALITY, COUNTRYOFRESIDENCE, PLACEOFBIRTH, COUNTRYOFBIRTH, TIN, TINISSUNINGCOUNTRY, ADDRTYPE, "+
															"		ADDR, CITY, POSTALCODE, STATECODE, COUNTRYCODE, TELEPHONE, OTHERCONTACTNO, REMARKS, UPDATEBY, UPDATETIMESTAMP) "+
															"VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,SYSTIMESTAMP)");
			preparedStatement.setString(1, caseNo);
			preparedStatement.setString(2, accountNo);
			preparedStatement.setString(3, generateID("CONTROLLINGPERSON"));
			preparedStatement.setString(4, formData.get("PERSONTYPE"));
			preparedStatement.setString(5, formData.get("NAME"));
			preparedStatement.setString(6, formData.get("CUSTOMERID"));
			preparedStatement.setString(7, formData.get("FATHERNAME"));
			
			preparedStatement.setString(8, formData.get("SPOUSENAME"));
			preparedStatement.setString(9, formData.get("GENDER"));
			preparedStatement.setString(10, formData.get("PAN"));
			preparedStatement.setString(11, formData.get("ADHAARNO"));
			preparedStatement.setString(12, formData.get("IDTYPE"));
			preparedStatement.setString(13, formData.get("IDNO"));
			preparedStatement.setString(14, formData.get("OCCUPATIONTYPE"));
			preparedStatement.setString(15, formData.get("OCCUPATION"));
			preparedStatement.setString(16, formData.get("DATEOFBIRTH"));
			preparedStatement.setString(17, formData.get("NATIONALITY"));
			
			preparedStatement.setString(18, formData.get("COUNTRYOFRESIDENCE"));
			preparedStatement.setString(19, formData.get("PLACEOFBIRTH"));
			preparedStatement.setString(20, formData.get("COUNTRYOFBIRTH"));
			preparedStatement.setString(21, formData.get("TIN"));
			preparedStatement.setString(22, formData.get("TINISSUNINGCOUNTRY"));
			preparedStatement.setString(23, formData.get("ADDRTYPE"));
			preparedStatement.setString(24, formData.get("ADDR"));
			preparedStatement.setString(25, formData.get("CITY"));
			preparedStatement.setString(26, formData.get("POSTALCODE"));
			preparedStatement.setString(27, formData.get("STATECODE"));
			preparedStatement.setString(28, formData.get("COUNTRYCODE"));
			preparedStatement.setString(29, formData.get("TELEPHONE"));
			preparedStatement.setString(30, formData.get("OTHERCONTACTNO"));
			preparedStatement.setString(31, formData.get("REMARKS"));
			preparedStatement.setString(32, userCode);
			preparedStatement.executeUpdate();
			*/
		}catch(Exception e){
			log.error("Error while adding FATCA individual : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
	}
	
	public void updateINDFATCAControllingPerson(String caseNo, String accountNo, String userCode, String idValue, Map<String, String> formData){
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareStatement("UPDATE "+schemaName+"TB_INDFATCACONTROLLINGPERSON "+
															"	SET	PERSONTYPE = ?, NAME = ?, CUSTOMERID = ?, FATHERNAME = ?, "+
															"		SPOUSENAME = ?, GENDER = ?, PAN = ?, ADHAARNO = ?, IDTYPE = ?, IDNO = ?, "+
															"		OCCUPATIONTYPE = ?, OCCUPATION = ?, DATEOFBIRTH = ?, NATIONALITY = ?, COUNTRYOFRESIDENCE = ?, "+
															"		PLACEOFBIRTH = ?, COUNTRYOFBIRTH = ?, TIN = ?, TINISSUNINGCOUNTRY = ?, ADDRTYPE = ?, ADDR = ?, "+
															"		CITY = ?, POSTALCODE = ?, STATECODE = ?, COUNTRYCODE = ?, TELEPHONE = ?, OTHERCONTACTNO = ?, "+
															"		REMARKS = ?, UPDATEBY = ?, UPDATETIMESTAMP = SYSTIMESTAMP "+
															" WHERE CASENO = ? "+
															"   AND ACCOUNTNO = ? "+
															"   AND CONTROLLINGPERSONID = ?");
			preparedStatement.setString(1, formData.get("PERSONTYPE"));
			preparedStatement.setString(2, formData.get("NAME"));
			preparedStatement.setString(3, formData.get("CUSTOMERID"));
			preparedStatement.setString(4, formData.get("FATHERNAME"));
			
			preparedStatement.setString(5, formData.get("SPOUSENAME"));
			preparedStatement.setString(6, formData.get("GENDER"));
			preparedStatement.setString(7, formData.get("PAN"));
			preparedStatement.setString(8, formData.get("ADHAARNO"));
			preparedStatement.setString(9, formData.get("IDTYPE"));
			preparedStatement.setString(10, formData.get("IDNO"));
			
			preparedStatement.setString(11, formData.get("OCCUPATIONTYPE"));
			preparedStatement.setString(12, formData.get("OCCUPATION"));
			preparedStatement.setString(13, formData.get("DATEOFBIRTH"));
			preparedStatement.setString(14, formData.get("NATIONALITY"));			
			preparedStatement.setString(15, formData.get("COUNTRYOFRESIDENCE"));
			
			preparedStatement.setString(16, formData.get("PLACEOFBIRTH"));
			preparedStatement.setString(17, formData.get("COUNTRYOFBIRTH"));
			preparedStatement.setString(18, formData.get("TIN"));
			preparedStatement.setString(19, formData.get("TINISSUNINGCOUNTRY"));
			preparedStatement.setString(20, formData.get("ADDRTYPE"));
			preparedStatement.setString(21, formData.get("ADDR"));
			
			preparedStatement.setString(22, formData.get("CITY"));
			preparedStatement.setString(23, formData.get("POSTALCODE"));
			preparedStatement.setString(24, formData.get("STATECODE"));
			preparedStatement.setString(25, formData.get("COUNTRYCODE"));
			preparedStatement.setString(26, formData.get("TELEPHONE"));
			preparedStatement.setString(27, formData.get("OTHERCONTACTNO"));
			preparedStatement.setString(28, formData.get("REMARKS"));
			preparedStatement.setString(29, userCode);
			preparedStatement.setString(30, caseNo);
			preparedStatement.setString(31, accountNo);
			preparedStatement.setString(32, idValue);
			
			preparedStatement.executeUpdate();
		}catch(Exception e){
			log.error("Error while adding FATCA controlling person : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
	}
	
	public void deleteINDFATCAIndividual(String caseNo, String accountNo, String individualId){
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareStatement("DELETE FROM "+schemaName+"TB_INDFATCAINDIVIDUALDETAILS WHERE CASENO = ? AND ACCOUNTNO = ? AND INDIVIDUALID = ?");
			preparedStatement.setString(1, caseNo);
			preparedStatement.setString(2, accountNo);
			preparedStatement.setString(3, individualId);
			preparedStatement.executeUpdate();
		}catch(Exception e){
			log.error("Error while deleting FATCA individual : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
	}
	
	public void deleteINDFATCAEntity(String caseNo, String accountNo, String entityId){
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareStatement("DELETE FROM "+schemaName+"TB_INDFATCAENTITYDETAILS WHERE CASENO = ? AND ACCOUNTNO = ? AND ENTITYID = ?");
			preparedStatement.setString(1, caseNo);
			preparedStatement.setString(2, accountNo);
			preparedStatement.setString(3, entityId);
			preparedStatement.executeUpdate();
		}catch(Exception e){
			log.error("Error while deleting FATCA individual : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
	}
	
	public void deleteINDFATCAControllingPerson(String caseNo, String accountNo, String controllingPersonId){
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareStatement("DELETE FROM "+schemaName+"TB_INDFATCACONTROLLINGPERSON WHERE CASENO = ? AND ACCOUNTNO = ? AND CONTROLLINGPERSONID = ?");
			preparedStatement.setString(1, caseNo);
			preparedStatement.setString(2, accountNo);
			preparedStatement.setString(3, controllingPersonId);
			preparedStatement.executeUpdate();
		}catch(Exception e){
			log.error("Error while deleting FATCA individual : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
	}
	
	private void generateReportFileData(String caseNo, String userId){
		Connection connection = connectionUtil.getConnection();
		CallableStatement callableStatement = null;
		ResultSet resultSet = null;
		try{
			callableStatement = connection.prepareCall("CALL "+schemaName+"STP_GENERATEINDFATCAXMLFILE(?,?)");
			callableStatement.setString(1, caseNo);
			callableStatement.setString(2, userId);
			callableStatement.execute();
		}catch(Exception e){
			log.error("Error while generating FATCA XML data : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, callableStatement, resultSet, null);
		}
	}
	
	public List<String> getReportFileData(String caseNo, String userId){
		generateReportFileData(caseNo, userId);
		List<String> fileData = new LinkedList<String>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareStatement("SELECT CHARACTERSET FROM "+schemaName+"TB_INDFATCA_FILEGENERATION WHERE CASENO = ? ORDER BY SEQNO ASC");
			preparedStatement.setString(1, caseNo);
			resultSet = preparedStatement.executeQuery();
			while (resultSet.next()) {
				fileData.add(resultSet.getString("CHARACTERSET"));
			}
		}catch(Exception e){
			log.error("Error while fetching FATCA XML data : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return fileData;
	}
}
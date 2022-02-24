package com.quantumdataengines.app.compass.dao.regulatoryReports.UK;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.util.LinkedHashMap;
import java.util.Map;

import oracle.jdbc.internal.OracleTypes;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Repository;

import com.quantumdataengines.app.compass.util.ConnectionUtil;

@Repository
public class UKSARDAOImpl implements UKSARDAO{
	
	@Autowired
	private ConnectionUtil connectionUtil;
	
	@Value("${compass.aml.config.schemaName}")
	private String schemaName;
	
	public Map<String, String> fetchUKSARData(String caseNo, String userCode, String ipAddress, String CURRENTROLE){
		Map<String, String> dataMap = new LinkedHashMap<String, String>();
		Connection connection = null;
		CallableStatement callableStatement = null;
		try{
			connection = connectionUtil.getConnection();
			callableStatement = connection.prepareCall("{CALL "+schemaName+"STP_GETUKSARDATA(?,?,?,?,?)}");
			callableStatement.setString(1, caseNo);
			callableStatement.setString(2, userCode);
			callableStatement.setString(3, ipAddress);
			callableStatement.setString(4, CURRENTROLE);
			callableStatement.registerOutParameter(5, OracleTypes.CURSOR);
			callableStatement.execute();
			ResultSet resultSet = (ResultSet) callableStatement.getObject(5);
			
			ResultSetMetaData resultSetMetaData = resultSet.getMetaData();
			
			while(resultSet.next()){
				for(int colIndex = 1; colIndex <= resultSetMetaData.getColumnCount(); colIndex++){
					String columnName = resultSetMetaData.getColumnName(colIndex);
					dataMap.put(columnName, resultSet.getString(columnName));
				}
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, callableStatement, null, null);
		}
		return dataMap;
	}
	
	@SuppressWarnings("resource")
	public String saveUKSAR(Map<String,String> paramMap, String caseNo, String userCode){
		String response = "" ;
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		int count = 0;
		try{
			String sql = "SELECT COUNT(1) CASENOCOUNT FROM "+schemaName+"TB_UKSAR WHERE CASENO = ? ";
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, caseNo);
			resultSet = preparedStatement.executeQuery();
			if (resultSet.next()){
				count = resultSet.getInt("CASENOCOUNT");
			}
			
			if(count == 0){
				sql = "INSERT INTO "+schemaName+"TB_UKSAR(INSTITUTIONNAME, INSTITUTIONTYPE, REGULATOR, REGULATORID, CD1FORENAME, "+
					  "		  CD1SURNAME, CD1POSITION, CD1ADDRESS, CD1TELEPHONE, CD1FAX, "+
					  "	      CD1EMAIL, CD2FORENAME, CD2SURNAME, CD2POSITION, CD2ADDRESS, "+
					  "		  CD2TELEPHONE, CD2FAX, CD2EMAIL, REPORTINGINSTITUTION, YOURREF, "+
					  "		  DISCLOSUREREASON1, BRANCHOFFICE, ISCONSENTREQ, DISCLOSUREDATE, DISCLOSUREREPORTTYPE, "+
					  "       DISCLOSUREID1, DISCLOSUREID2, DISCLOSUREID3, NOOFSUBDETAILSMAINSUB, NOOFADDDETAILSMAINSUB, "+
					  "		  NOOFSUBDETAILSASSOSUB, NOOFADDDETAILSASSOSUB, NOOFTNXDETAIL, NOOFREASONFORDISCSHEETS, NOOFPAGES, "+
					  "		  SUBJECTTYPE, SUBJECTTYPENUM1, SUBJECTTYPENUM2, INDVSUBSTATUS, IDSURNAME, "+
					  "	   	  IDFORENAME1, IDFORENAME2, OCCUPATION, DOB, GENDER, "+
					  "		  TITLE, OTHERTITLE, REASONFORASSO1, LEGALENTITYSTATUS, LEGALENTITYNAME, "+
					  " 	  LEGALENTITYNO, VATNO, COUNTRYOFREG, BUSINESSTYPE, REASONFORASSO2, "+
					  "	   	  SUBJECTREFTO, ASSOCIATENO, SUBJECTNAME, PREMISENONAME1, CURRENTPREMISE1, "+
					  "		  TYPEOFPREMISE1, STREET1, CITYORTOWN1, COUNTY1, POSTCODE1, "+
					  "		  COUNTRY1, PREMISENONAME2, CURRENTPREMISE2, TYPEOFPREMISE2, STREET2, "+
					  "		  CITYORTOWN2, COUNTY2, POSTCODE2, COUNTRY2, PREMISENONAME3, "+
					  "		  CURRENTPREMISE3, TYPEOFPREMISE3, STREET3, CITYORTOWN3, COUNTY3, "+
					  "		  POSTCODE3, COUNTRY3, INFOTYPE1, UNQINFOIDENTIFIER1, EXTRAINFO1, "+
					  "		  INFOTYPE2, UNQINFOIDENTIFIER2, EXTRAINFO2, MAISUBACINSTITUTIONNAME, ACCOUNTNAME, "+
					  "		  SORTCODE, ACCOUNTNO, BUSIRELATIONSTART, BUSIRELATIONFINISH, ACCBAL, "+
					  "		  BALDATE, TURNOVERPERIOD, CREDITTURNOVER, DEBITTURNOVER, ACTIVITYTYPE1, "+
					  "		  ACTIVITYDATE1, AMOUNT1, CURRENCY1, TNXCREDITDEBIT1, OTHERPARTYNAME1, "+
					  "		  TNXINSTITUTIONNAME1, TNXACCNO1, ACTIVITYTYPE2, ACTIVITYDATE2, AMOUNT2, "+
					  "		  CURRENCY2, TNXCREDITDEBIT2, OTHERPARTYNAME2, TNXINSTITUTIONNAME2, TNXACCNO2, "+
					  "		  ACTIVITYTYPE3, ACTIVITYDATE3, AMOUNT3, CURRENCY3, TNXCREDITDEBIT3, "+
					  "		  OTHERPARTYNAME3, TNXINSTITUTIONNAME3, TNXACCNO3, ACTIVITYTYPE4, ACTIVITYDATE4, "+
					  "		  AMOUNT4, CURRENCY4, TNXCREDITDEBIT4, OTHERPARTYNAME4, TNXINSTITUTIONNAME4, "+
					  "		  TNXACCNO4, MAINSUBNAME, DRUGS, MISSINGTRADER, IMMIGRATION, "+
					  "		  TOBACCOEXCISEFRAUD, PERSONALTAXFRAUD, CORPORATETAXFRAUD, OTHEROFFENCES, DISCLOSUREREASON2, "+
					  "		  MAINSUBNAMECONT, DISCLOSUREREASONCONT, CASENO, UPDATEDBY, UPDATEDTIMESTAMP) "+ 
					  "VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?, "+
					  "		   ?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?, "+
					  "		   ?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?, "+
					  "		   ?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,SYSTIMESTAMP) " ;
				preparedStatement = connection.prepareStatement(sql);
				preparedStatement.setString(1, paramMap.get("INSTITUTIONNAME"));
				preparedStatement.setString(2, paramMap.get("INSTITUTIONTYPE"));
				preparedStatement.setString(3, paramMap.get("REGULATOR"));
				preparedStatement.setString(4, paramMap.get("REGULATORID"));
				preparedStatement.setString(5, paramMap.get("CD1FORENAME"));
				preparedStatement.setString(6, paramMap.get("CD1SURNAME"));
				preparedStatement.setString(7, paramMap.get("CD1POSITION"));
				preparedStatement.setString(8, paramMap.get("CD1ADDRESS"));
				preparedStatement.setString(9, paramMap.get("CD1TELEPHONE"));
				preparedStatement.setString(10, paramMap.get("CD1FAX"));
				preparedStatement.setString(11, paramMap.get("CD1EMAIL"));
				preparedStatement.setString(12, paramMap.get("CD2FORENAME"));
				preparedStatement.setString(13, paramMap.get("CD2SURNAME"));
				preparedStatement.setString(14, paramMap.get("CD2POSITION"));
				preparedStatement.setString(15, paramMap.get("CD2ADDRESS"));
				preparedStatement.setString(16, paramMap.get("CD2TELEPHONE"));
				preparedStatement.setString(17, paramMap.get("CD2FAX"));
				preparedStatement.setString(18, paramMap.get("CD2EMAIL"));
				preparedStatement.setString(19, paramMap.get("REPORTINGINSTITUTION"));
				preparedStatement.setString(20, paramMap.get("YOURREF"));
				preparedStatement.setString(21, paramMap.get("DISCLOSUREREASON1"));
				preparedStatement.setString(22, paramMap.get("BRANCHOFFICE"));
				preparedStatement.setString(23, paramMap.get("ISCONSENTREQ"));
				preparedStatement.setString(24, paramMap.get("DISCLOSUREDATE"));
				preparedStatement.setString(25, paramMap.get("DISCLOSUREREPORTTYPE"));
				preparedStatement.setString(26, paramMap.get("DISCLOSUREID1"));
				preparedStatement.setString(27, paramMap.get("DISCLOSUREID2"));
				preparedStatement.setString(28, paramMap.get("DISCLOSUREID3"));
				preparedStatement.setString(29, paramMap.get("NOOFSUBDETAILSMAINSUB"));
				preparedStatement.setString(30, paramMap.get("NOOFADDDETAILSMAINSUB"));
				preparedStatement.setString(31, paramMap.get("NOOFSUBDETAILSASSOSUB"));
				preparedStatement.setString(32, paramMap.get("NOOFADDDETAILSASSOSUB"));
				preparedStatement.setString(33, paramMap.get("NOOFTNXDETAIL"));
				preparedStatement.setString(34, paramMap.get("NOOFREASONFORDISCSHEETS"));
				preparedStatement.setString(35, paramMap.get("NOOFPAGES"));
				preparedStatement.setString(36, paramMap.get("SUBJECTTYPE"));
				preparedStatement.setString(37, paramMap.get("SUBJECTTYPENUM1"));
				preparedStatement.setString(38, paramMap.get("SUBJECTTYPENUM2"));
				preparedStatement.setString(39, paramMap.get("INDVSUBSTATUS"));
				preparedStatement.setString(40, paramMap.get("IDSURNAME"));
				preparedStatement.setString(41, paramMap.get("IDFORENAME1"));
				preparedStatement.setString(42, paramMap.get("IDFORENAME2"));
				preparedStatement.setString(43, paramMap.get("OCCUPATION"));
				preparedStatement.setString(44, paramMap.get("DOB"));
				preparedStatement.setString(45, paramMap.get("GENDER"));
				preparedStatement.setString(46, paramMap.get("TITLE"));
				preparedStatement.setString(47, paramMap.get("OTHERTITLE"));
				preparedStatement.setString(48, paramMap.get("REASONFORASSO1"));
				preparedStatement.setString(49, paramMap.get("LEGALENTITYSTATUS"));
				preparedStatement.setString(50, paramMap.get("LEGALENTITYNAME"));
				preparedStatement.setString(51, paramMap.get("LEGALENTITYNO"));
				preparedStatement.setString(52, paramMap.get("VATNO"));
				preparedStatement.setString(53, paramMap.get("COUNTRYOFREG"));
				preparedStatement.setString(54, paramMap.get("BUSINESSTYPE"));
				preparedStatement.setString(55, paramMap.get("REASONFORASSO2"));
				preparedStatement.setString(56, paramMap.get("SUBJECTREFTO"));
				preparedStatement.setString(57, paramMap.get("ASSOCIATENO"));
				preparedStatement.setString(58, paramMap.get("SUBJECTNAME"));
				preparedStatement.setString(59, paramMap.get("PREMISENONAME1"));
				preparedStatement.setString(60, paramMap.get("CURRENTPREMISE1"));
				preparedStatement.setString(61, paramMap.get("TYPEOFPREMISE1"));
				preparedStatement.setString(62, paramMap.get("STREET1"));
				preparedStatement.setString(63, paramMap.get("CITYORTOWN1"));
				preparedStatement.setString(64, paramMap.get("COUNTY1"));
				preparedStatement.setString(65, paramMap.get("POSTCODE1"));
				preparedStatement.setString(66, paramMap.get("COUNTRY1"));
				preparedStatement.setString(67, paramMap.get("PREMISENONAME2"));
				preparedStatement.setString(68, paramMap.get("CURRENTPREMISE2"));
				preparedStatement.setString(69, paramMap.get("TYPEOFPREMISE2"));
				preparedStatement.setString(70, paramMap.get("STREET2"));
				preparedStatement.setString(71, paramMap.get("CITYORTOWN2"));
				preparedStatement.setString(72, paramMap.get("COUNTY2"));
				preparedStatement.setString(73, paramMap.get("POSTCODE2"));
				preparedStatement.setString(74, paramMap.get("COUNTRY2"));
				preparedStatement.setString(75, paramMap.get("PREMISENONAME3"));
				preparedStatement.setString(76, paramMap.get("CURRENTPREMISE3"));
				preparedStatement.setString(77, paramMap.get("TYPEOFPREMISE3"));
				preparedStatement.setString(78, paramMap.get("STREET3"));
				preparedStatement.setString(79, paramMap.get("CITYORTOWN3"));
				preparedStatement.setString(80, paramMap.get("COUNTY3"));
				preparedStatement.setString(81, paramMap.get("POSTCODE3"));
				preparedStatement.setString(82, paramMap.get("COUNTRY3"));
				preparedStatement.setString(83, paramMap.get("INFOTYPE1"));
				preparedStatement.setString(84, paramMap.get("UNQINFOIDENTIFIER1"));
				preparedStatement.setString(85, paramMap.get("EXTRAINFO1"));
				preparedStatement.setString(86, paramMap.get("INFOTYPE2"));
				preparedStatement.setString(87, paramMap.get("UNQINFOIDENTIFIER2"));
				preparedStatement.setString(88, paramMap.get("EXTRAINFO2"));
				preparedStatement.setString(89, paramMap.get("MAISUBACINSTITUTIONNAME"));
				preparedStatement.setString(90, paramMap.get("ACCOUNTNAME"));
				preparedStatement.setString(91, paramMap.get("SORTCODE"));
				preparedStatement.setString(92, paramMap.get("ACCOUNTNO"));
				preparedStatement.setString(93, paramMap.get("BUSIRELATIONSTART"));
				preparedStatement.setString(94, paramMap.get("BUSIRELATIONFINISH"));
				preparedStatement.setString(95, paramMap.get("ACCBAL"));
				preparedStatement.setString(96, paramMap.get("BALDATE"));
				preparedStatement.setString(97, paramMap.get("TURNOVERPERIOD"));
				preparedStatement.setString(98, paramMap.get("CREDITTURNOVER"));
				preparedStatement.setString(99, paramMap.get("DEBITTURNOVER"));
				preparedStatement.setString(100, paramMap.get("ACTIVITYTYPE1"));
				preparedStatement.setString(101, paramMap.get("ACTIVITYDATE1"));
				preparedStatement.setString(102, paramMap.get("AMOUNT1"));
				preparedStatement.setString(103, paramMap.get("CURRENCY1"));
				preparedStatement.setString(104, paramMap.get("TNXCREDITDEBIT1"));
				preparedStatement.setString(105, paramMap.get("OTHERPARTYNAME1"));
				preparedStatement.setString(106, paramMap.get("TNXINSTITUTIONNAME1"));
				preparedStatement.setString(107, paramMap.get("TNXACCNO1"));
				preparedStatement.setString(108, paramMap.get("ACTIVITYTYPE2"));
				preparedStatement.setString(109, paramMap.get("ACTIVITYDATE2"));
				preparedStatement.setString(110, paramMap.get("AMOUNT2"));
				preparedStatement.setString(111, paramMap.get("CURRENCY2"));
				preparedStatement.setString(112, paramMap.get("TNXCREDITDEBIT2"));
				preparedStatement.setString(113, paramMap.get("OTHERPARTYNAME2"));
				preparedStatement.setString(114, paramMap.get("TNXINSTITUTIONNAME2"));
				preparedStatement.setString(115, paramMap.get("TNXACCNO2"));
				preparedStatement.setString(116, paramMap.get("ACTIVITYTYPE3"));
				preparedStatement.setString(117, paramMap.get("ACTIVITYDATE3"));
				preparedStatement.setString(118, paramMap.get("AMOUNT3"));
				preparedStatement.setString(119, paramMap.get("CURRENCY3"));
				preparedStatement.setString(120, paramMap.get("TNXCREDITDEBIT3"));
				preparedStatement.setString(121, paramMap.get("OTHERPARTYNAME3"));
				preparedStatement.setString(122, paramMap.get("TNXINSTITUTIONNAME3"));
				preparedStatement.setString(123, paramMap.get("TNXACCNO3"));
				preparedStatement.setString(124, paramMap.get("ACTIVITYTYPE4"));
				preparedStatement.setString(125, paramMap.get("ACTIVITYDATE4"));
				preparedStatement.setString(126, paramMap.get("AMOUNT4"));
				preparedStatement.setString(127, paramMap.get("CURRENCY4"));
				preparedStatement.setString(128, paramMap.get("TNXCREDITDEBIT4"));
				preparedStatement.setString(129, paramMap.get("OTHERPARTYNAME4"));
				preparedStatement.setString(130, paramMap.get("TNXINSTITUTIONNAME4"));
				preparedStatement.setString(131, paramMap.get("TNXACCNO4"));
				preparedStatement.setString(132, paramMap.get("MAINSUBNAME"));
				preparedStatement.setString(133, paramMap.get("DRUGS"));
				preparedStatement.setString(134, paramMap.get("MISSINGTRADER"));
				preparedStatement.setString(135, paramMap.get("IMMIGRATION"));
				preparedStatement.setString(136, paramMap.get("TOBACCOEXCISEFRAUD"));
				preparedStatement.setString(137, paramMap.get("PERSONALTAXFRAUD"));
				preparedStatement.setString(138, paramMap.get("CORPORATETAXFRAUD"));
				preparedStatement.setString(139, paramMap.get("OTHEROFFENCES"));
				preparedStatement.setString(140, paramMap.get("DISCLOSUREREASON2"));
				preparedStatement.setString(141, paramMap.get("MAINSUBNAMECONT"));
				preparedStatement.setString(142, paramMap.get("DISCLOSUREREASONCONT"));
				preparedStatement.setString(143, caseNo);
				preparedStatement.setString(144, userCode);
				preparedStatement.executeUpdate();
				response="Successfully saved.";
				}
			else{
				sql = "UPDATE "+schemaName+"TB_UKSAR SET INSTITUTIONNAME = ?, INSTITUTIONTYPE = ?, REGULATOR = ?, REGULATORID = ?, CD1FORENAME = ?, "+
					  "		  CD1SURNAME = ?, CD1POSITION = ?, CD1ADDRESS = ?, CD1TELEPHONE = ?, CD1FAX = ?, "+
					  "	      CD1EMAIL = ?, CD2FORENAME = ?, CD2SURNAME = ?, CD2POSITION = ?, CD2ADDRESS = ?, "+
					  "		  CD2TELEPHONE = ?, CD2FAX = ?, CD2EMAIL = ?, REPORTINGINSTITUTION = ?, YOURREF = ?, "+
					  "		  DISCLOSUREREASON1 = ?, BRANCHOFFICE = ?, ISCONSENTREQ = ?, DISCLOSUREDATE = ?, DISCLOSUREREPORTTYPE = ?, "+
					  "       DISCLOSUREID1 = ?, DISCLOSUREID2 = ?, DISCLOSUREID3 = ?, NOOFSUBDETAILSMAINSUB = ?, NOOFADDDETAILSMAINSUB = ?, "+
					  "		  NOOFSUBDETAILSASSOSUB = ?, NOOFADDDETAILSASSOSUB = ?, NOOFTNXDETAIL = ?, NOOFREASONFORDISCSHEETS = ?, NOOFPAGES = ?, "+
					  "		  SUBJECTTYPE = ?, SUBJECTTYPENUM1 = ?, SUBJECTTYPENUM2 = ?, INDVSUBSTATUS = ?, IDSURNAME = ?, "+
					  "	   	  IDFORENAME1 = ?, IDFORENAME2 = ?, OCCUPATION = ?, DOB = ?, GENDER = ?, "+
					  "		  TITLE = ?, OTHERTITLE = ?, REASONFORASSO1 = ?, LEGALENTITYSTATUS = ?, LEGALENTITYNAME = ?, "+
					  " 	  LEGALENTITYNO = ?, VATNO = ?, COUNTRYOFREG = ?, BUSINESSTYPE = ?, REASONFORASSO2 = ?, "+
					  "	   	  SUBJECTREFTO = ?, ASSOCIATENO = ?, SUBJECTNAME = ?, PREMISENONAME1 = ?, CURRENTPREMISE1 = ?, "+
					  "		  TYPEOFPREMISE1 = ?, STREET1 = ?, CITYORTOWN1 = ?, COUNTY1 = ?, POSTCODE1 = ?, "+
					  "		  COUNTRY1 = ?, PREMISENONAME2 = ?, CURRENTPREMISE2 = ?, TYPEOFPREMISE2 = ?, STREET2 = ?, "+
					  "		  CITYORTOWN2 = ?, COUNTY2 = ?, POSTCODE2 = ?, COUNTRY2 = ?, PREMISENONAME3 = ?, "+
					  "		  CURRENTPREMISE3 = ?, TYPEOFPREMISE3 = ?, STREET3 = ?, CITYORTOWN3 = ?, COUNTY3 = ?, "+
					  "		  POSTCODE3 = ?, COUNTRY3 = ?, INFOTYPE1 = ?, UNQINFOIDENTIFIER1 = ?, EXTRAINFO1 = ?, "+
					  "		  INFOTYPE2 = ?, UNQINFOIDENTIFIER2 = ?, EXTRAINFO2 = ?, MAISUBACINSTITUTIONNAME = ?, ACCOUNTNAME = ?, "+
					  "		  SORTCODE = ?, ACCOUNTNO = ?, BUSIRELATIONSTART = ?, BUSIRELATIONFINISH = ?, ACCBAL = ?, "+
					  "		  BALDATE = ?, TURNOVERPERIOD = ?, CREDITTURNOVER = ?, DEBITTURNOVER = ?, ACTIVITYTYPE1 = ?, "+
					  "		  ACTIVITYDATE1 = ?, AMOUNT1 = ?, CURRENCY1 = ?, TNXCREDITDEBIT1 = ?, OTHERPARTYNAME1 = ?, "+
					  "		  TNXINSTITUTIONNAME1 = ?, TNXACCNO1 = ?, ACTIVITYTYPE2 = ?, ACTIVITYDATE2 = ?, AMOUNT2 = ?, "+
					  "		  CURRENCY2 = ?, TNXCREDITDEBIT2 = ?, OTHERPARTYNAME2 = ?, TNXINSTITUTIONNAME2 = ?, TNXACCNO2 = ?, "+
					  "		  ACTIVITYTYPE3 = ?, ACTIVITYDATE3 = ?, AMOUNT3 = ?, CURRENCY3 = ?, TNXCREDITDEBIT3 = ?, "+
					  "		  OTHERPARTYNAME3 = ?, TNXINSTITUTIONNAME3 = ?, TNXACCNO3 = ?, ACTIVITYTYPE4 = ?, ACTIVITYDATE4 = ?, "+
					  "		  AMOUNT4 = ?, CURRENCY4 = ?, TNXCREDITDEBIT4 = ?, OTHERPARTYNAME4 = ?, TNXINSTITUTIONNAME4 = ?, "+
					  "		  TNXACCNO4 = ?, MAINSUBNAME = ?, DRUGS = ?, MISSINGTRADER = ?, IMMIGRATION = ?, "+
					  "		  TOBACCOEXCISEFRAUD = ?, PERSONALTAXFRAUD = ?, CORPORATETAXFRAUD = ?, OTHEROFFENCES = ?, DISCLOSUREREASON2 = ?, "+
					  "		  MAINSUBNAMECONT = ?, DISCLOSUREREASONCONT = ?, UPDATEDBY = ?, UPDATEDTIMESTAMP = SYSTIMESTAMP "+ 
					  " WHERE CASENO = ? " ;
					preparedStatement = connection.prepareStatement(sql);
					preparedStatement.setString(1, paramMap.get("INSTITUTIONNAME"));
					preparedStatement.setString(2, paramMap.get("INSTITUTIONTYPE"));
					preparedStatement.setString(3, paramMap.get("REGULATOR"));
					preparedStatement.setString(4, paramMap.get("REGULATORID"));
					preparedStatement.setString(5, paramMap.get("CD1FORENAME"));
					preparedStatement.setString(6, paramMap.get("CD1SURNAME"));
					preparedStatement.setString(7, paramMap.get("CD1POSITION"));
					preparedStatement.setString(8, paramMap.get("CD1ADDRESS"));
					preparedStatement.setString(9, paramMap.get("CD1TELEPHONE"));
					preparedStatement.setString(10, paramMap.get("CD1FAX"));
					preparedStatement.setString(11, paramMap.get("CD1EMAIL"));
					preparedStatement.setString(12, paramMap.get("CD2FORENAME"));
					preparedStatement.setString(13, paramMap.get("CD2SURNAME"));
					preparedStatement.setString(14, paramMap.get("CD2POSITION"));
					preparedStatement.setString(15, paramMap.get("CD2ADDRESS"));
					preparedStatement.setString(16, paramMap.get("CD2TELEPHONE"));
					preparedStatement.setString(17, paramMap.get("CD2FAX"));
					preparedStatement.setString(18, paramMap.get("CD2EMAIL"));
					preparedStatement.setString(19, paramMap.get("REPORTINGINSTITUTION"));
					preparedStatement.setString(20, paramMap.get("YOURREF"));
					preparedStatement.setString(21, paramMap.get("DISCLOSUREREASON1"));
					preparedStatement.setString(22, paramMap.get("BRANCHOFFICE"));
					preparedStatement.setString(23, paramMap.get("ISCONSENTREQ"));
					preparedStatement.setString(24, paramMap.get("DISCLOSUREDATE"));
					preparedStatement.setString(25, paramMap.get("DISCLOSUREREPORTTYPE"));
					preparedStatement.setString(26, paramMap.get("DISCLOSUREID1"));
					preparedStatement.setString(27, paramMap.get("DISCLOSUREID2"));
					preparedStatement.setString(28, paramMap.get("DISCLOSUREID3"));
					preparedStatement.setString(29, paramMap.get("NOOFSUBDETAILSMAINSUB"));
					preparedStatement.setString(30, paramMap.get("NOOFADDDETAILSMAINSUB"));
					preparedStatement.setString(31, paramMap.get("NOOFSUBDETAILSASSOSUB"));
					preparedStatement.setString(32, paramMap.get("NOOFADDDETAILSASSOSUB"));
					preparedStatement.setString(33, paramMap.get("NOOFTNXDETAIL"));
					preparedStatement.setString(34, paramMap.get("NOOFREASONFORDISCSHEETS"));
					preparedStatement.setString(35, paramMap.get("NOOFPAGES"));
					preparedStatement.setString(36, paramMap.get("SUBJECTTYPE"));
					preparedStatement.setString(37, paramMap.get("SUBJECTTYPENUM1"));
					preparedStatement.setString(38, paramMap.get("SUBJECTTYPENUM2"));
					preparedStatement.setString(39, paramMap.get("INDVSUBSTATUS"));
					preparedStatement.setString(40, paramMap.get("IDSURNAME"));
					preparedStatement.setString(41, paramMap.get("IDFORENAME1"));
					preparedStatement.setString(42, paramMap.get("IDFORENAME2"));
					preparedStatement.setString(43, paramMap.get("OCCUPATION"));
					preparedStatement.setString(44, paramMap.get("DOB"));
					preparedStatement.setString(45, paramMap.get("GENDER"));
					preparedStatement.setString(46, paramMap.get("TITLE"));
					preparedStatement.setString(47, paramMap.get("OTHERTITLE"));
					preparedStatement.setString(48, paramMap.get("REASONFORASSO1"));
					preparedStatement.setString(49, paramMap.get("LEGALENTITYSTATUS"));
					preparedStatement.setString(50, paramMap.get("LEGALENTITYNAME"));
					preparedStatement.setString(51, paramMap.get("LEGALENTITYNO"));
					preparedStatement.setString(52, paramMap.get("VATNO"));
					preparedStatement.setString(53, paramMap.get("COUNTRYOFREG"));
					preparedStatement.setString(54, paramMap.get("BUSINESSTYPE"));
					preparedStatement.setString(55, paramMap.get("REASONFORASSO2"));
					preparedStatement.setString(56, paramMap.get("SUBJECTREFTO"));
					preparedStatement.setString(57, paramMap.get("ASSOCIATENO"));
					preparedStatement.setString(58, paramMap.get("SUBJECTNAME"));
					preparedStatement.setString(59, paramMap.get("PREMISENONAME1"));
					preparedStatement.setString(60, paramMap.get("CURRENTPREMISE1"));
					preparedStatement.setString(61, paramMap.get("TYPEOFPREMISE1"));
					preparedStatement.setString(62, paramMap.get("STREET1"));
					preparedStatement.setString(63, paramMap.get("CITYORTOWN1"));
					preparedStatement.setString(64, paramMap.get("COUNTY1"));
					preparedStatement.setString(65, paramMap.get("POSTCODE1"));
					preparedStatement.setString(66, paramMap.get("COUNTRY1"));
					preparedStatement.setString(67, paramMap.get("PREMISENONAME2"));
					preparedStatement.setString(68, paramMap.get("CURRENTPREMISE2"));
					preparedStatement.setString(69, paramMap.get("TYPEOFPREMISE2"));
					preparedStatement.setString(70, paramMap.get("STREET2"));
					preparedStatement.setString(71, paramMap.get("CITYORTOWN2"));
					preparedStatement.setString(72, paramMap.get("COUNTY2"));
					preparedStatement.setString(73, paramMap.get("POSTCODE2"));
					preparedStatement.setString(74, paramMap.get("COUNTRY2"));
					preparedStatement.setString(75, paramMap.get("PREMISENONAME3"));
					preparedStatement.setString(76, paramMap.get("CURRENTPREMISE3"));
					preparedStatement.setString(77, paramMap.get("TYPEOFPREMISE3"));
					preparedStatement.setString(78, paramMap.get("STREET3"));
					preparedStatement.setString(79, paramMap.get("CITYORTOWN3"));
					preparedStatement.setString(80, paramMap.get("COUNTY3"));
					preparedStatement.setString(81, paramMap.get("POSTCODE3"));
					preparedStatement.setString(82, paramMap.get("COUNTRY3"));
					preparedStatement.setString(83, paramMap.get("INFOTYPE1"));
					preparedStatement.setString(84, paramMap.get("UNQINFOIDENTIFIER1"));
					preparedStatement.setString(85, paramMap.get("EXTRAINFO1"));
					preparedStatement.setString(86, paramMap.get("INFOTYPE2"));
					preparedStatement.setString(87, paramMap.get("UNQINFOIDENTIFIER2"));
					preparedStatement.setString(88, paramMap.get("EXTRAINFO2"));
					preparedStatement.setString(89, paramMap.get("MAISUBACINSTITUTIONNAME"));
					preparedStatement.setString(90, paramMap.get("ACCOUNTNAME"));
					preparedStatement.setString(91, paramMap.get("SORTCODE"));
					preparedStatement.setString(92, paramMap.get("ACCOUNTNO"));
					preparedStatement.setString(93, paramMap.get("BUSIRELATIONSTART"));
					preparedStatement.setString(94, paramMap.get("BUSIRELATIONFINISH"));
					preparedStatement.setString(95, paramMap.get("ACCBAL"));
					preparedStatement.setString(96, paramMap.get("BALDATE"));
					preparedStatement.setString(97, paramMap.get("TURNOVERPERIOD"));
					preparedStatement.setString(98, paramMap.get("CREDITTURNOVER"));
					preparedStatement.setString(99, paramMap.get("DEBITTURNOVER"));
					preparedStatement.setString(100, paramMap.get("ACTIVITYTYPE1"));
					preparedStatement.setString(101, paramMap.get("ACTIVITYDATE1"));
					preparedStatement.setString(102, paramMap.get("AMOUNT1"));
					preparedStatement.setString(103, paramMap.get("CURRENCY1"));
					preparedStatement.setString(104, paramMap.get("TNXCREDITDEBIT1"));
					preparedStatement.setString(105, paramMap.get("OTHERPARTYNAME1"));
					preparedStatement.setString(106, paramMap.get("TNXINSTITUTIONNAME1"));
					preparedStatement.setString(107, paramMap.get("TNXACCNO1"));
					preparedStatement.setString(108, paramMap.get("ACTIVITYTYPE2"));
					preparedStatement.setString(109, paramMap.get("ACTIVITYDATE2"));
					preparedStatement.setString(110, paramMap.get("AMOUNT2"));
					preparedStatement.setString(111, paramMap.get("CURRENCY2"));
					preparedStatement.setString(112, paramMap.get("TNXCREDITDEBIT2"));
					preparedStatement.setString(113, paramMap.get("OTHERPARTYNAME2"));
					preparedStatement.setString(114, paramMap.get("TNXINSTITUTIONNAME2"));
					preparedStatement.setString(115, paramMap.get("TNXACCNO2"));
					preparedStatement.setString(116, paramMap.get("ACTIVITYTYPE3"));
					preparedStatement.setString(117, paramMap.get("ACTIVITYDATE3"));
					preparedStatement.setString(118, paramMap.get("AMOUNT3"));
					preparedStatement.setString(119, paramMap.get("CURRENCY3"));
					preparedStatement.setString(120, paramMap.get("TNXCREDITDEBIT3"));
					preparedStatement.setString(121, paramMap.get("OTHERPARTYNAME3"));
					preparedStatement.setString(122, paramMap.get("TNXINSTITUTIONNAME3"));
					preparedStatement.setString(123, paramMap.get("TNXACCNO3"));
					preparedStatement.setString(124, paramMap.get("ACTIVITYTYPE4"));
					preparedStatement.setString(125, paramMap.get("ACTIVITYDATE4"));
					preparedStatement.setString(126, paramMap.get("AMOUNT4"));
					preparedStatement.setString(127, paramMap.get("CURRENCY4"));
					preparedStatement.setString(128, paramMap.get("TNXCREDITDEBIT4"));
					preparedStatement.setString(129, paramMap.get("OTHERPARTYNAME4"));
					preparedStatement.setString(130, paramMap.get("TNXINSTITUTIONNAME4"));
					preparedStatement.setString(131, paramMap.get("TNXACCNO4"));
					preparedStatement.setString(132, paramMap.get("MAINSUBNAME"));
					preparedStatement.setString(133, paramMap.get("DRUGS"));
					preparedStatement.setString(134, paramMap.get("MISSINGTRADER"));
					preparedStatement.setString(135, paramMap.get("IMMIGRATION"));
					preparedStatement.setString(136, paramMap.get("TOBACCOEXCISEFRAUD"));
					preparedStatement.setString(137, paramMap.get("PERSONALTAXFRAUD"));
					preparedStatement.setString(138, paramMap.get("CORPORATETAXFRAUD"));
					preparedStatement.setString(139, paramMap.get("OTHEROFFENCES"));
					preparedStatement.setString(140, paramMap.get("DISCLOSUREREASON2"));
					preparedStatement.setString(141, paramMap.get("MAINSUBNAMECONT"));
					preparedStatement.setString(142, paramMap.get("DISCLOSUREREASONCONT"));
					preparedStatement.setString(143, userCode);
					preparedStatement.setString(144, caseNo);
					preparedStatement.executeUpdate();
					response="Successfully updated.";
			}
		}catch(Exception e){
			response="Error while saving/updating.";
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return response;
		
	}
}


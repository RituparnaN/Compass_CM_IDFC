package com.quantumdataengines.app.compass.dao.regulatoryReports.sriLanka;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.util.HashMap;
import java.util.Map;

import oracle.jdbc.internal.OracleTypes;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Repository;

import com.quantumdataengines.app.compass.util.ConnectionUtil;

@Repository
public class SLSTRDAOImpl implements SLSTRDAO{
	private static final Logger log = LoggerFactory.getLogger(SLSTRDAOImpl.class);
	@Autowired
	private ConnectionUtil connectionUtil;
	
	@Value("${compass.aml.config.schemaName}")
	private String schemaName;
	
	public Connection getConnection(){
		Connection connection = null;
		try{
			connection = connectionUtil.getConnection();
		}catch(Exception e){
			log.error("Error in creating db connection : SLSTRDAOImpl -> "+e.getMessage());
			e.printStackTrace();
		}
		return connection;
	}
	
	public Map<String, String> getSLSTR(String caseNo, String userCode) {
		Map<String, String> getSLSTR = new HashMap<String, String>();
		Connection connection = getConnection();
		CallableStatement callableStatement = null;
		ResultSet resultSet = null;
		try{
			callableStatement = connection.prepareCall("{CALL "+schemaName+"GET_SLSTR(?,?,?)}");
			callableStatement.setString(1, caseNo);
			callableStatement.setString(2, userCode);
			callableStatement.registerOutParameter(3, OracleTypes.CURSOR);
			callableStatement.execute();
			resultSet = (ResultSet) callableStatement.getObject(3);
			
			ResultSetMetaData resultSetMetaData = resultSet.getMetaData();
			int noOfColumn = resultSetMetaData.getColumnCount();
			if(resultSet.next()){
				for(int i = 1; i <= noOfColumn; i++){
					String columnName = resultSetMetaData.getColumnName(i);
					getSLSTR.put(columnName, resultSet.getString(columnName));
				}
			}
		}catch(Exception e){
			e.printStackTrace();
			log.error("Error while getting SL STR data : "+e.toString());
		}finally{
			connectionUtil.closeResources(connection, callableStatement, resultSet, null);
		}
		return getSLSTR;
	}

	public boolean saveSLSTR(String caseNo, Map<String, String> formData, String updatedBy) {
		boolean isSaved = false;
		Connection connection = getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String sql = "UPDATE "+schemaName+"TB_SLSTR "+
					 "   SET DATEOFSENDINGREPORT = TO_DATE(?,'DD/MM/YYYY'), EARLIERREPORTREPLACEMENT = ?, ORIGINALREPORTDATE = TO_DATE(?,'DD/MM/YYYY'), FULLNAME = ?, NICPASSPORTNATBUSSNO = ?, "+
					 "		 GENDER = ?, RESIDENCECOUNTRY = ?, BUSINESSEMPLOYMENTTYPE = ?, OCCUPATION = ?, OCCUPATIONDESC = ?, "+
					 "		 EMPLOYERNAME = ?, RESREGADDRESS = ?, COUNTRY = ?, OTHERBUSSRELETEDACCDETAILS = ?, TELEPHONENO = ?, "+
					 "		 LASTREVIEWDATE = TO_DATE(?,'DD/MM/YYYY'), CUSTOMERRELATION = ?, FULLNAME1 = ?, NICPASSPORTNATBUSSNO1 = ?, GENDER1 = ?, "+
					 "		 RESIDENCECOUNTRY1 = ?, BUSINESSEMPLOYMENTTYPE1 = ?, OCCUPATION1 = ?, OCCUPATIONDESC1 = ?, EMPLOYERNAME1 = ?, "+
					 "		 RESREGADDRESS1 = ?, TOWN = ?, OTHERBUSSRELETEDACCDETAILS1 = ?, ACCOUNTNUMBER = ?, ACCOUNTTYPE = ?, "+
					 "		 BRANCH = ?, BRANCHADDRESS = ?, FREQUENCY = ?, TRANSACTIONDATE = TO_DATE(?,'DD/MM/YYYY'), TOTALAMOUNT = ?, "+
					 "		 AMOUNTFOREIGNCURRENCY = ?, TRANSACTIONBENEFICIARY = ?, SUSPICIOUSTXTTYPE = ?, GROUNDOFSUSPICION = ?, GROUNDOFSUSPICIONOTHER = ?, "+
					 "		 NATUREDETAILS = ?, REPORTINGDATE = TO_DATE(?,'DD/MM/YYYY'), REPORTINGOFFICER = ?, COMPLIANCEOFFICERNAME = ?, NAME = ?, "+
					 "		 DESIGNATION = ?, ADDRESS = ?, CONTACTNO = ?, EMAIL = ?, FAX = ?, "+
					 "		 UPDATEDBY = ?, UPDATETIMESTAMP = SYSTIMESTAMP, "+
					 "		 ACCOUNTOPENEDDATE = TO_DATE(?,'DD/MM/YYYY'), ACCOUNTSTATUS = ?, "+
					 "		 CURRENCYCODE = ?, CURRENTBALANCE = ?, CURRENTBALANCEFOREIGNCURRENCY = ? "+
					 " WHERE CASENO = ?";
		try{
			preparedStatement = connection.prepareStatement(sql);
			
			//DATEOFSENDINGREPORT = TO_DATE(?,'DD/MM/YYYY'), EARLIERREPORTREPLACEMENT = ?, ORIGINALREPORTDATE = ?, FULLNAME = ?, NICPASSPORTNATBUSSNO = ?, "+
			preparedStatement.setString(1, formData.get("DATEOFSENDINGREPORT"));
			preparedStatement.setString(2, formData.get("EARLIERREPORTREPLACEMENT"));
			preparedStatement.setString(3, formData.get("ORIGINALREPORTDATE"));
			preparedStatement.setString(4, formData.get("FULLNAME"));
			preparedStatement.setString(5, formData.get("NICPASSPORTNATBUSSNO"));
			
			//GENDER = ?, RESIDENCECOUNTRY = ?, BUSINESSEMPLOYMENTTYPE = ?, OCCUPATION = ?, OCCUPATIONDESC = ?, "+
			preparedStatement.setString(6, formData.get("GENDER"));
			preparedStatement.setString(7, formData.get("RESIDENCECOUNTRY"));
			preparedStatement.setString(8, formData.get("BUSINESSEMPLOYMENTTYPE"));
			preparedStatement.setString(9, formData.get("OCCUPATION"));
			preparedStatement.setString(10, formData.get("OCCUPATIONDESC"));
			
			//EMPLOYERNAME = ?, RESREGADDRESS = ?, COUNTRY = ?, OTHERBUSSRELETEDACCDETAILS = ?, TELEPHONENO = ?, "+
			preparedStatement.setString(11, formData.get("EMPLOYERNAME"));
			preparedStatement.setString(12, formData.get("RESREGADDRESS"));
			preparedStatement.setString(13, formData.get("COUNTRY"));
			preparedStatement.setString(14, formData.get("OTHERBUSSRELETEDACCDETAILS"));
			preparedStatement.setString(15, formData.get("TELEPHONENO"));

			//LASTREVIEWDATE = ?, CUSTOMERRELATION = ?, FULLNAME1 = ?, NICPASSPORTNATBUSSNO1 = ?, GENDER1 = ?, "+
			preparedStatement.setString(16, formData.get("LASTREVIEWDATE"));
			preparedStatement.setString(17, formData.get("CUSTOMERRELATION"));
			preparedStatement.setString(18, formData.get("FULLNAME1"));
			preparedStatement.setString(19, formData.get("NICPASSPORTNATBUSSNO1"));
			preparedStatement.setString(20, formData.get("GENDER1"));
			
			//RESIDENCECOUNTRY1 = ?, BUSINESSEMPLOYMENTTYPE1 = ?, OCCUPATION1 = ?, OCCUPATIONDESC1 = ?, EMPLOYERNAME1 = ?, "+
			preparedStatement.setString(21, formData.get("RESIDENCECOUNTRY1"));
			preparedStatement.setString(22, formData.get("BUSINESSEMPLOYMENTTYPE1"));
			preparedStatement.setString(23, formData.get("OCCUPATION1"));
			preparedStatement.setString(24, formData.get("OCCUPATIONDESC1"));
			preparedStatement.setString(25, formData.get("EMPLOYERNAME1"));
			
			//RESREGADDRESS1 = ?, TOWN = ?, OTHERBUSSRELETEDACCDETAILS1 = ?, ACCOUNTNUMBER = ?, ACCOUNTTYPE = ?, "+
			preparedStatement.setString(26, formData.get("RESREGADDRESS1"));
			preparedStatement.setString(27, formData.get("TOWN"));
			preparedStatement.setString(28, formData.get("OTHERBUSSRELETEDACCDETAILS1"));
			preparedStatement.setString(29, formData.get("ACCOUNTNUMBER"));
			preparedStatement.setString(30, formData.get("ACCOUNTTYPE"));
			
			//BRANCH = ?, BRANCHADDRESS = ?, FREQUENCY = ?, TRANSACTIONDATE = TO_DATE(?,'DD/MM/YYYY'), TOTALAMOUNT = ?, "+
			preparedStatement.setString(31, formData.get("BRANCH"));
			preparedStatement.setString(32, formData.get("BRANCHADDRESS"));
			preparedStatement.setString(33, formData.get("FREQUENCY"));
			preparedStatement.setString(34, formData.get("TRANSACTIONDATE"));
			preparedStatement.setString(35, formData.get("TOTALAMOUNT"));

			//AMOUNTFOREIGNCURRENCY = ?, TRANSACTIONBENEFICIARY = ?, SUSPICIOUSTXTTYPE = ?, GROUNDOFSUSPICION = ?, GROUNDOFSUSPICIONOTHER = ?, "+
			preparedStatement.setString(36, formData.get("AMOUNTFOREIGNCURRENCY"));
			preparedStatement.setString(37, formData.get("TRANSACTIONBENEFICIARY"));
			preparedStatement.setString(38, formData.get("SUSPICIOUSTXTTYPE"));
			preparedStatement.setString(39, formData.get("GROUNDOFSUSPICION"));
			preparedStatement.setString(40, formData.get("GROUNDOFSUSPICIONOTHER"));

			//NATUREDETAILS = ?, REPORTINGDATE = ?, REPORTINGOFFICER = ?, COMPLIANCEOFFICERNAME = ?, NAME = ?, "+
			preparedStatement.setString(41, formData.get("NATUREDETAILS"));
			preparedStatement.setString(42, formData.get("REPORTINGDATE"));
			preparedStatement.setString(43, formData.get("REPORTINGOFFICER"));
			preparedStatement.setString(44, formData.get("COMPLIANCEOFFICERNAME"));
			preparedStatement.setString(45, formData.get("NAME"));

			//DESIGNATION = ?, ADDRESS = ?, CONTACTNO = ?, EMAIL = ?, FAX = ?, "+
			preparedStatement.setString(46, formData.get("DESIGNATION"));
			preparedStatement.setString(47, formData.get("ADDRESS"));
			preparedStatement.setString(48, formData.get("CONTACTNO"));
			preparedStatement.setString(49, formData.get("EMAIL"));
			preparedStatement.setString(50, formData.get("FAX"));
			
			preparedStatement.setString(51, updatedBy);
			
			//preparedStatement.setString(52, caseNo);
			preparedStatement.setString(52, formData.get("ACCOUNTOPENEDDATE"));
			preparedStatement.setString(53, formData.get("ACCOUNTSTATUS"));
			preparedStatement.setString(54, formData.get("CURRENCYCODE"));
			preparedStatement.setString(55, formData.get("CURRENTBALANCE"));
			preparedStatement.setString(56, formData.get("CURRENTBALANCEFOREIGNCURRENCY"));
			preparedStatement.setString(57, caseNo);
			
			int x = preparedStatement.executeUpdate();
			if(x != 0)
				isSaved = true;
		}catch(Exception e){
			e.printStackTrace();
			log.error("Error while saving SL STR data : "+e.toString());
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return isSaved;
	}
}

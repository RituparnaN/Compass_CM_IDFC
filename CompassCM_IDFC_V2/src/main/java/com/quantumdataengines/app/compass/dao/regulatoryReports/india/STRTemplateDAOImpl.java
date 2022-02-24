package com.quantumdataengines.app.compass.dao.regulatoryReports.india;

import java.io.BufferedReader;
import java.io.IOException;
import java.sql.CallableStatement;
import java.sql.Clob;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import oracle.jdbc.OracleTypes;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Repository;

import com.quantumdataengines.app.compass.util.ConnectionUtil;

@Repository
public class STRTemplateDAOImpl implements STRTemplateDAO {

	private static final Logger log = LoggerFactory.getLogger(STRTemplateDAOImpl.class);
	
	@Autowired
	private ConnectionUtil connectionUtil;
	
	@Value("${compass.aml.config.schemaName}")
	private String schemaName;
	
	public Connection getConnection(){
		Connection connection = null;
		try{
			connection = connectionUtil.getConnection();
		}catch(Exception e){
			log.error("Error in creating db connection : STRTemplateDAOImpl -> "+e.getMessage());
			e.printStackTrace();
		}
		return connection;
	}
	
	public List<String> getAllVariables(){
		List<String> allVariables = new ArrayList<String>();
		Connection connection = getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String queryString = "";
		try{
			queryString = "SELECT SEQUENCENUMBER, VARIABLENAME, VARIABLEDESCRIPTION FROM "+schemaName+"TB_STRVARIABLE ORDER BY SEQUENCENUMBER";
			preparedStatement = connection.prepareStatement(queryString);
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()){
				allVariables.add(resultSet.getString("VARIABLENAME"));
				allVariables.add(resultSet.getString("VARIABLEDESCRIPTION"));
			}
		}catch(Exception e){
			log.error("Error while getting all STR variables : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return allVariables;
	}
	
	public Map<String, String> getTemplateDetails(String templateId){
		Map<String, String> templateDetails = new HashMap<String, String>();
		Connection connection = getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareStatement("SELECT TEMPLATEID, TEMPLATENAME, GROUNDOFSUSPICION, SOURCEOFALERT, ALERTREDFLAGINDICATOR, "+
															"		STRREASON, INVESTIGATIONDETAILS, LEAINFORMED, LEADETAILS, STATUS, ATTEMPTEDTRANSACTIONS, "+
															"		PRIORITYRATING, REPORTCOVERAGE, ADDITIONALDOCUMENTS, UPDATEDBY, TO_CHAR(UPDATETIMESTAMP, 'DD/MM/YYYY') UPDATETIMESTAMP "+
															"  FROM "+schemaName+"TB_STRTEMPLATE "+
															" WHERE TEMPLATEID = ?");
			preparedStatement.setString(1, templateId);
			resultSet = preparedStatement.executeQuery();
			if(resultSet.next()){
				templateDetails.put("TEMPLATEID", resultSet.getString("TEMPLATEID"));
				templateDetails.put("TEMPLATENAME", resultSet.getString("TEMPLATENAME"));
				templateDetails.put("GROUNDOFSUSPICION", clobStringConversion(resultSet.getClob("GROUNDOFSUSPICION")));
				templateDetails.put("SOURCEOFALERT", resultSet.getString("SOURCEOFALERT"));
				templateDetails.put("ALERTREDFLAGINDICATOR", resultSet.getString("ALERTREDFLAGINDICATOR"));
				templateDetails.put("STRREASON", resultSet.getString("STRREASON"));
				templateDetails.put("INVESTIGATIONDETAILS", clobStringConversion(resultSet.getClob("INVESTIGATIONDETAILS")));
				templateDetails.put("LEAINFORMED", resultSet.getString("LEAINFORMED"));
				templateDetails.put("LEADETAILS", resultSet.getString("LEADETAILS"));
				templateDetails.put("STATUS", resultSet.getString("STATUS"));
				templateDetails.put("ATTEMPTEDTRANSACTIONS", resultSet.getString("ATTEMPTEDTRANSACTIONS"));
				templateDetails.put("PRIORITYRATING", resultSet.getString("PRIORITYRATING"));
				templateDetails.put("REPORTCOVERAGE", resultSet.getString("REPORTCOVERAGE"));
				templateDetails.put("ADDITIONALDOCUMENTS", resultSet.getString("ADDITIONALDOCUMENTS"));
				templateDetails.put("UPDATEDBY", resultSet.getString("UPDATEDBY"));
				templateDetails.put("UPDATETIMESTAMP", resultSet.getString("UPDATETIMESTAMP"));
			}
		}catch(Exception e){
			log.error("Error while getting STR template details : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return templateDetails;
	}
	
	public List<Map<String, String>> getAllSTRTemplate(){
		List<Map<String, String>> allTemplates = new ArrayList<Map<String, String>>();
		Connection connection = getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareStatement("SELECT TEMPLATEID, TEMPLATENAME, GROUNDOFSUSPICION, SOURCEOFALERT, ALERTREDFLAGINDICATOR, "+
															"		STRREASON, INVESTIGATIONDETAILS, LEAINFORMED, LEADETAILS, STATUS, ATTEMPTEDTRANSACTIONS, "+
															"		PRIORITYRATING, REPORTCOVERAGE, ADDITIONALDOCUMENTS, UPDATEDBY, TO_CHAR(UPDATETIMESTAMP, 'DD/MM/YYYY') UPDATETIMESTAMP "+
															"  FROM "+schemaName+"TB_STRTEMPLATE ORDER BY STATUS DESC, UPDATETIMESTAMP DESC");
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()){
				Map<String, String> templateDetails = new HashMap<String, String>();
				templateDetails.put("TEMPLATEID", resultSet.getString("TEMPLATEID"));
				templateDetails.put("TEMPLATENAME", resultSet.getString("TEMPLATENAME"));
				templateDetails.put("GROUNDOFSUSPICION", clobStringConversion(resultSet.getClob("GROUNDOFSUSPICION")));
				templateDetails.put("SOURCEOFALERT", resultSet.getString("SOURCEOFALERT"));
				templateDetails.put("ALERTREDFLAGINDICATOR", resultSet.getString("ALERTREDFLAGINDICATOR"));
				templateDetails.put("STRREASON", resultSet.getString("STRREASON"));				
				templateDetails.put("INVESTIGATIONDETAILS", clobStringConversion(resultSet.getClob("INVESTIGATIONDETAILS")));
				templateDetails.put("LEAINFORMED", resultSet.getString("LEAINFORMED"));
				templateDetails.put("LEADETAILS", resultSet.getString("LEADETAILS"));				
				templateDetails.put("STATUS", resultSet.getString("STATUS"));
				templateDetails.put("ATTEMPTEDTRANSACTIONS", resultSet.getString("ATTEMPTEDTRANSACTIONS"));
				templateDetails.put("PRIORITYRATING", resultSet.getString("PRIORITYRATING"));
				templateDetails.put("REPORTCOVERAGE", resultSet.getString("REPORTCOVERAGE"));
				templateDetails.put("ADDITIONALDOCUMENTS", resultSet.getString("ADDITIONALDOCUMENTS"));
				templateDetails.put("UPDATEDBY", resultSet.getString("UPDATEDBY"));
				templateDetails.put("UPDATETIMESTAMP", resultSet.getString("UPDATETIMESTAMP"));
				allTemplates.add(templateDetails);
			}
		}catch(Exception e){
			log.error("Error while getting ALL STR template details : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return allTemplates;
	}
	
	public List<Map<String, String>> getAllTypeOfSuspicions(){
		List<Map<String, String>> allTypeOfSuspicions = new ArrayList<Map<String, String>>();
		Connection connection = getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareStatement("SELECT CODE ALERTID, DESCRIPTION ALERTNAME "+
															"  FROM "+schemaName+"TB_TYPEOFSUSPICIONLIST "+
															" ORDER BY SEQNO ASC ");
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()){
				Map<String, String> suspicionDetails = new HashMap<String, String>();
				suspicionDetails.put("ALERTID", resultSet.getString("ALERTID"));
				suspicionDetails.put("ALERTNAME", resultSet.getString("ALERTNAME"));
				allTypeOfSuspicions.add(suspicionDetails);
			}
		}catch(Exception e){
			log.error("Error while getting ALL STR template details : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return allTypeOfSuspicions;
	}
	
	public String addUpdateSTRTemplate(Map<String, String> formData, String userCode){
		String templateId = "";
		Connection connection = getConnection();
		CallableStatement callableStatement = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			if("UPDATE".equals(formData.get("ACTION"))){
				templateId = formData.get("TEMPLATEID");
				preparedStatement = connection.prepareStatement("UPDATE "+schemaName+"TB_STRTEMPLATE "+
																"   SET TEMPLATENAME = ?, GROUNDOFSUSPICION = ?, SOURCEOFALERT = ?, "+
																"		ALERTREDFLAGINDICATOR = ?, STRREASON = ?, INVESTIGATIONDETAILS = ?, "+
																"		LEAINFORMED = ?, LEADETAILS = ?, ATTEMPTEDTRANSACTIONS = ?, PRIORITYRATING = ?, "+
																"		REPORTCOVERAGE = ?, ADDITIONALDOCUMENTS = ?, STATUS = ?, UPDATEDBY = ?, UPDATETIMESTAMP = SYSTIMESTAMP "+
																" WHERE TEMPLATEID = ?");
				preparedStatement.setString(1, formData.get("TEMPLATENAME"));
				preparedStatement.setString(2, formData.get("GROUNDOFSUSPICION"));
				preparedStatement.setString(3, formData.get("SOURCEOFALERT"));
				preparedStatement.setString(4, formData.get("ALERTREDFLAGINDICATOR"));
				preparedStatement.setString(5, formData.get("STRREASON"));
				preparedStatement.setString(6, formData.get("INVESTIGATIONDETAILS"));				
				preparedStatement.setString(7, formData.get("LEAINFORMED"));
				preparedStatement.setString(8, formData.get("LEADETAILS"));
				preparedStatement.setString(9, formData.get("ATTEMPTEDTRANSACTIONS"));
				preparedStatement.setString(10, formData.get("PRIORITYRATING"));
				preparedStatement.setString(11, formData.get("REPORTCOVERAGE"));
				preparedStatement.setString(12, formData.get("ADDITIONALDOCUMENTS"));
				preparedStatement.setString(13, formData.get("STATUS"));
				preparedStatement.setString(14, userCode);
				preparedStatement.setString(15, templateId);
				preparedStatement.executeUpdate();
			}else{
				preparedStatement = connection.prepareStatement("SELECT "+schemaName+"SEQ_STRTEMPLATE.NEXTVAL SEQNO FROM DUAL");
				resultSet = preparedStatement.executeQuery();
				if(resultSet.next())
					templateId = "STRTEMPLATE_"+resultSet.getString("SEQNO");
				
				
				preparedStatement = connection.prepareStatement("INSERT INTO "+schemaName+"TB_STRTEMPLATE(TEMPLATENAME, GROUNDOFSUSPICION, SOURCEOFALERT, ALERTREDFLAGINDICATOR, STRREASON, "+
																"		INVESTIGATIONDETAILS, LEAINFORMED, LEADETAILS, ATTEMPTEDTRANSACTIONS, PRIORITYRATING, REPORTCOVERAGE, ADDITIONALDOCUMENTS, STATUS, TEMPLATEID, UPDATEDBY, UPDATETIMESTAMP) "+
																"VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,SYSTIMESTAMP)");
				preparedStatement.setString(1, formData.get("TEMPLATENAME"));
				preparedStatement.setString(2, formData.get("GROUNDOFSUSPICION"));
				preparedStatement.setString(3, formData.get("SOURCEOFALERT"));
				preparedStatement.setString(4, formData.get("ALERTREDFLAGINDICATOR"));
				preparedStatement.setString(5, formData.get("STRREASON"));
				preparedStatement.setString(6, formData.get("INVESTIGATIONDETAILS"));
				preparedStatement.setString(7, formData.get("LEAINFORMED"));
				preparedStatement.setString(8, formData.get("LEADETAILS"));
				preparedStatement.setString(9, formData.get("ATTEMPTEDTRANSACTIONS"));
				preparedStatement.setString(10, formData.get("PRIORITYRATING"));
				preparedStatement.setString(11, formData.get("REPORTCOVERAGE"));
				preparedStatement.setString(12, formData.get("ADDITIONALDOCUMENTS"));
				preparedStatement.setString(13, formData.get("STATUS"));
				preparedStatement.setString(14, templateId);
				preparedStatement.setString(15, userCode);				
				preparedStatement.executeUpdate();
			}
			
			callableStatement = connection.prepareCall("{CALL "+schemaName+"STP_SETSTRTEMPLATEALERTCODE(?,?)}");
			callableStatement.setString(1, templateId);
			callableStatement.setString(2, userCode);
			callableStatement.execute();
			
		}catch(Exception e){
			log.error("Error adding or updating STR template : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return templateId;
	}
	
	public String generateAutoSTR(Map<String, String> formDate, String userId, String groupCode){
		String message = "";
		Connection connection = getConnection();
		CallableStatement callableStatement = null;
		try{
			callableStatement = connection.prepareCall("{CALL "+schemaName+"STP_GENERATEAUTOSTR(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");
			callableStatement.setString(1, formDate.get("PRIMARYCUSTOMERID"));
			callableStatement.setString(2, formDate.get("SECONDARYCUSTOMERID"));
			callableStatement.setString(3, formDate.get("ACCOUNTNUMBERS"));
			callableStatement.setString(4, formDate.get("TRANSACTIONFROMDATE"));
			callableStatement.setString(5, formDate.get("TRANSACTIONTODATE"));
			callableStatement.setString(6, formDate.get("GROUNDOFSUSPICION"));
			callableStatement.setString(7, formDate.get("SOURCEOFALERT"));
			callableStatement.setString(8, formDate.get("ALERTREDFLAGINDICATOR"));
			callableStatement.setString(9, formDate.get("STRREASON"));
			callableStatement.setString(10, formDate.get("ATTEMPTEDTRANSACTIONS"));
			callableStatement.setString(11, formDate.get("PRIORITYRATING"));
			callableStatement.setString(12, formDate.get("REPORTCOVERAGE"));
			callableStatement.setString(13, formDate.get("ADDITIONALDOCUMENTS"));
			callableStatement.setString(14, formDate.get("INVESTIGATIONDETAILS"));
			callableStatement.setString(15, formDate.get("LEAINFORMED"));
			callableStatement.setString(16, formDate.get("LEADETAILS"));
			callableStatement.setString(17, formDate.get("TEMPLATEID"));
			callableStatement.setString(18, formDate.get("AMLUSERCODE"));
			callableStatement.setString(19, formDate.get("REFERENCECASENO"));
			callableStatement.setString(20, formDate.get("REFERENCECASEDATE"));
			callableStatement.setString(21, userId);
			callableStatement.setString(22, groupCode);
			/*callableStatement.setString(23, formDate.containsKey("RF1INDICATOR")?formDate.get("RF1INDICATOR"):"N");
			callableStatement.setString(24, formDate.containsKey("RF2INDICATOR")?formDate.get("RF2INDICATOR"):"N");
			callableStatement.setString(25, formDate.containsKey("RF3INDICATOR")?formDate.get("RF3INDICATOR"):"N");
			callableStatement.setString(26, formDate.containsKey("RF4INDICATOR")?formDate.get("RF4INDICATOR"):"N");
			callableStatement.setString(27, formDate.containsKey("RF5INDICATOR")?formDate.get("RF5INDICATOR"):"N");*/
			callableStatement.setString(23, formDate.get("RF1INDICATOR"));
			callableStatement.setString(24, formDate.get("RF2INDICATOR"));
			callableStatement.setString(25, formDate.get("RF3INDICATOR"));
			callableStatement.setString(26, formDate.get("RF4INDICATOR"));
			callableStatement.setString(27, formDate.get("RF5INDICATOR"));
			callableStatement.setString(28, formDate.get("TYPEOFSUSPICION"));
			callableStatement.execute();
			message = "STR generated";
		}catch(Exception e){
			message = "Failed to generate STR";
			log.error("Error generating Auto STR : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, callableStatement, null, null);
		}
		return message;
	}
	
	public List<Map<String, String>> selectAccountNumbers(String primaryCustomerId, String secondaryCustomerId){
		List<Map<String, String>> accountDetails = new ArrayList<Map<String, String>>();
		Connection connection = getConnection();
		CallableStatement callableStatement = null;
		ResultSet resultSet = null;
		try{
			callableStatement = connection.prepareCall("{CALL "+schemaName+"STP_GETACCOUNTSFORSTRTEMPLATE(?,?,?)}");
			callableStatement.setString(1, primaryCustomerId);
			callableStatement.setString(2, secondaryCustomerId);
			callableStatement.registerOutParameter(3, OracleTypes.CURSOR);
			callableStatement.execute();
			
			resultSet = (ResultSet) callableStatement.getObject(3);
			ResultSetMetaData resultSetMetaData = resultSet.getMetaData();
			int columnCount = resultSetMetaData.getColumnCount();
			while(resultSet.next()){
				Map<String, String> account = new HashMap<String, String>();
				for(int i = 1; i <= columnCount; i++){
					String columnName = resultSetMetaData.getColumnName(i);
					account.put(columnName, resultSet.getString(columnName));
				}
				accountDetails.add(account);
			}
		}catch(Exception e){
			log.error("Error fetching account numbers for Auto-STR : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, callableStatement, resultSet, null);
		}
		return accountDetails;
	}
	
	public String generateGOS(String primaryCustomerId, String secondaryCustomerId, String accountNumbers, String templateId, String fromDate, String toDate, String caseNo)
    {
        Connection connection = getConnection();
		CallableStatement callableStatement = null;
		ResultSet resultSet = null;
		String groundOfSuspicion = "";
        try
        {
            callableStatement = connection.prepareCall("{CALL "+schemaName+"STP_GENERATEGROUNDOFSUSPICION(?,?,?,?,?,?,?,?)}");
            callableStatement.setString(1, primaryCustomerId);
            callableStatement.setString(2, secondaryCustomerId);
            callableStatement.setString(3, accountNumbers);
            callableStatement.setString(4, templateId);
            callableStatement.setString(5, fromDate);
            callableStatement.setString(6, toDate);
            callableStatement.setString(7, caseNo);
            callableStatement.registerOutParameter(8, OracleTypes.CURSOR);
            callableStatement.execute();
            resultSet = (ResultSet)callableStatement.getObject(8);
            if(resultSet.next()) {
                groundOfSuspicion = clobStringConversion(resultSet.getClob("GROUNDOFSUSPICION"));
            }
        }
        catch(Exception e)
        {
            log.error((new StringBuilder("Error fetching GOS for Auto-STR : ")).append(e.getMessage()).toString());
            e.printStackTrace();
        }finally{
			connectionUtil.closeResources(connection, callableStatement, resultSet, null);
		}
        return groundOfSuspicion;
    }
	
	public static String clobStringConversion(Clob clb) throws IOException, SQLException{
	      if (clb == null)
	    	  return  "";
	            
	      StringBuffer str = new StringBuffer();
	      String strng;
	      BufferedReader bufferRead = new BufferedReader(clb.getCharacterStream());
	      while ((strng=bufferRead .readLine())!=null)
	       str.append(strng);
	   
	      return str.toString();
	    }
	
}

package com.quantumdataengines.app.compass.dao.exceptionList;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Repository;

import com.quantumdataengines.app.compass.util.CommonUtil;
import com.quantumdataengines.app.compass.util.ConnectionUtil;

@Repository
public class LEAlistDAOImpl implements LEAlistDAO {

	@Autowired
	private ConnectionUtil connectionUtil;
	
	@Value("${compass.aml.config.schemaName}")
	private String schemaName;
	
	@SuppressWarnings("resource")
	@Override
	public String saveLEAList(Map<String,String> dataMap, String userCode, String userRole){
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String message = "";
		String seqNo = "";
		String status = "P";
		//System.out.println("DataMap = "+dataMap);
		try{
			String sql="SELECT "+schemaName+"SEQ_LEALIST.NEXTVAL FROM DUAL";
			preparedStatement = connection.prepareStatement(sql);
			resultSet = preparedStatement.executeQuery();
			if (resultSet.next()) {
				seqNo = Integer.toString(resultSet.getInt(1));
			}
			
			sql = "INSERT INTO "+schemaName+"TB_LEALIST( "+
			      "	      SERIALNO, LISTCODE, FIRST_NAME, MIDDLE_NAME, SURNAME, GENDER, "+
				  "		  SOURCE_OF_LETTER_MAIL, ADDRESS_LINE, IDENTIFICATION_TYPE, IDENTIFICATION_NUMBER, LETTER_RECEIVED_DATE, "+
			      "		  SCRUBBING_DATE, SCRUBBING_RESULT_MATCH, CUSTOMER_NAME, CUSTOMER_UCIC, CUSTOMER_ACCOUNT, "+
				  "		  CUSTOMER_HOME_BRANCH, MAKERCODE, STATUS, MAKERTIMESTAMP, CHECKERCODE, CHECKERTIMESTAMP, UPDATETIMESTAMP, UPDATEDBY)"+
				  "VALUES (?,?,?,?,?,?,"+
				  "  	   ?,?,?,?, FUN_CHARTODATE(?),"+
				  "  	   FUN_CHARTODATE(?),?,?,?,?,"+
				  "  	   ?,?,?,SYSTIMESTAMP,?,?,SYSTIMESTAMP,?)";
		
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, dataMap.get("serialNo"));
			preparedStatement.setString(2, "LEA_"+seqNo);
			preparedStatement.setString(3, dataMap.get("firstName"));
			preparedStatement.setString(4, dataMap.get("middleName"));
			preparedStatement.setString(5, dataMap.get("surname"));
			preparedStatement.setString(6, dataMap.get("gender"));
			preparedStatement.setString(7, dataMap.get("sourceOfLetterMail"));
			preparedStatement.setString(8, dataMap.get("addressLine"));
			preparedStatement.setString(9, dataMap.get("identificationType"));
			preparedStatement.setString(10, dataMap.get("identificationNumber"));
			preparedStatement.setString(11, dataMap.get("letterReceivedDate"));
			preparedStatement.setString(12, dataMap.get("scrubbingDate"));
			preparedStatement.setString(13, dataMap.get("scrubbingResultMatch"));
			preparedStatement.setString(14, dataMap.get("customerName"));
			preparedStatement.setString(15, dataMap.get("customerUCIC"));
			preparedStatement.setString(16, dataMap.get("customerAccount"));
			preparedStatement.setString(17, dataMap.get("customerHomeBranch"));
			preparedStatement.setString(18, userCode);
			preparedStatement.setString(19, status);
			preparedStatement.setString(20, "");
			preparedStatement.setString(21, "");
			preparedStatement.setString(22, userCode);
			
			int count = preparedStatement.executeUpdate();
			if(count == 1){
				message ="LEA List successfully saved.";
			}else
				message ="LEA List is not saved.";
		}catch(Exception e){
			message ="Error while saving LEA List.";
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, null, null);
		}
		return message;
	}
	
	public Map<String, Object> searchLEAList(String listCode, String serialNo, String listStatus, String userRole){
		Map<String, Object> mainMap = new HashMap<String, Object>();
		List<Map<String, String>> mainList = new Vector<Map<String,String>>();
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			String sql = "SELECT LISTCODE, SERIALNO, FIRST_NAME, MIDDLE_NAME, SURNAME, GENDER, STATUS, "+
						 "		 SOURCE_OF_LETTER_MAIL, ADDRESS_LINE, IDENTIFICATION_TYPE, IDENTIFICATION_NUMBER, TO_CHAR(LETTER_RECEIVED_DATE,'DD/MM/YYYY') LETTER_RECEIVED_DATE, "+
					     "		 TO_CHAR(SCRUBBING_DATE,'DD/MM/YYYY') SCRUBBING_DATE, SCRUBBING_RESULT_MATCH, CUSTOMER_NAME, CUSTOMER_UCIC, CUSTOMER_ACCOUNT, "+
						 "		 CUSTOMER_HOME_BRANCH, MAKERCODE, MAKERTIMESTAMP, CHECKERCODE, CHECKERTIMESTAMP, UPDATETIMESTAMP, UPDATEDBY "+
						 "  FROM "+schemaName+"TB_LEALIST "+
			             " WHERE 1=1 ";
			
			if(listCode != null && listCode.length()>0)
				sql = sql + " AND LISTCODE = ? ";			
			if(listStatus != null && listStatus.length()>0)
				sql = sql + " AND STATUS = ? ";
			if(serialNo != null && serialNo.length()>0)
				sql = sql + " AND SERIALNO = ? ";
		
			int count = 1;
			connection = connectionUtil.getConnection();
			preparedStatement = connection.prepareStatement(sql);
			if(listCode != null && listCode.length()>0){
				preparedStatement.setString(count, listCode);
				count++;
			}
			if(listStatus != null && listStatus.length()>0){
				preparedStatement.setString(count, listStatus);
				count++;
			}
			if(serialNo != null && serialNo.length()>0){
				preparedStatement.setString(count, serialNo);
				count++;
			}
			
			resultSet = preparedStatement.executeQuery();
			count = 1;
			
			List<String> headers = new Vector<String>();
			ResultSetMetaData resultSetMetaData = resultSet.getMetaData();
			int numberofcols = resultSetMetaData.getColumnCount();
			for(count = 1; count <= numberofcols; count++ ){
				String colname = resultSetMetaData.getColumnName(count);
				headers.add(CommonUtil.changeColumnName(colname));
			}
			
			while(resultSet.next()){
				Map<String, String> dataMap = new LinkedHashMap<String, String>();
				for(int colIndex = 1; colIndex <= resultSetMetaData.getColumnCount(); colIndex++){
					String columnName = resultSetMetaData.getColumnName(colIndex);
					dataMap.put(columnName, resultSet.getString(columnName));
				}
				mainList.add(dataMap);
			}
			
			
			mainMap.put("HEADER", headers);
			mainMap.put("DATA", mainList);
		}catch(Exception e){
			e.printStackTrace();	
		}finally{
			connectionUtil.closeResources(connection, preparedStatement,resultSet,null);		
		}
	return mainMap;
	}
	
	@Override
	public Map<String, String> showLEAListDetails(String listcode, String actionType, String userRole){
		Map<String, String> dataMap = new HashMap<String, String>();
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String sql = "SELECT SERIALNO, LISTCODE, FIRST_NAME, MIDDLE_NAME, SURNAME, GENDER,  "+
					 "		 SOURCE_OF_LETTER_MAIL, ADDRESS_LINE, IDENTIFICATION_TYPE, IDENTIFICATION_NUMBER, TO_CHAR(LETTER_RECEIVED_DATE,'DD/MM/YYYY') LETTER_RECEIVED_DATE, "+
				     "		 TO_CHAR(SCRUBBING_DATE,'DD/MM/YYYY') SCRUBBING_DATE, SCRUBBING_RESULT_MATCH, CUSTOMER_NAME, CUSTOMER_UCIC, CUSTOMER_ACCOUNT, "+
					 "		 CUSTOMER_HOME_BRANCH, MAKERCODE, MAKERTIMESTAMP, CHECKERCODE, CHECKERTIMESTAMP, UPDATETIMESTAMP, UPDATEDBY "+
					 "  FROM "+schemaName+"TB_LEALIST "+
		             " WHERE LISTCODE = ? ";
		
		try{
			connection = connectionUtil.getConnection();
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, listcode);
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()){
				dataMap.put("SERIALNO", resultSet.getString("SERIALNO"));
				dataMap.put("LISTCODE", resultSet.getString("LISTCODE"));
				dataMap.put("FIRST_NAME", resultSet.getString("FIRST_NAME"));
				dataMap.put("MIDDLE_NAME", resultSet.getString("MIDDLE_NAME"));
				dataMap.put("SURNAME", resultSet.getString("SURNAME"));
				dataMap.put("GENDER", resultSet.getString("GENDER"));
				dataMap.put("SOURCE_OF_LETTER_MAIL", resultSet.getString("SOURCE_OF_LETTER_MAIL"));
				dataMap.put("ADDRESS_LINE", resultSet.getString("ADDRESS_LINE"));
				dataMap.put("IDENTIFICATION_TYPE", resultSet.getString("IDENTIFICATION_TYPE"));
				dataMap.put("IDENTIFICATION_NUMBER", resultSet.getString("IDENTIFICATION_NUMBER"));
				dataMap.put("LETTER_RECEIVED_DATE", resultSet.getString("LETTER_RECEIVED_DATE"));
				dataMap.put("SCRUBBING_DATE", resultSet.getString("SCRUBBING_DATE"));
				dataMap.put("SCRUBBING_RESULT_MATCH", resultSet.getString("SCRUBBING_RESULT_MATCH"));
				dataMap.put("CUSTOMER_NAME", resultSet.getString("CUSTOMER_NAME"));
				dataMap.put("CUSTOMER_UCIC", resultSet.getString("CUSTOMER_UCIC"));
				dataMap.put("CUSTOMER_ACCOUNT", resultSet.getString("CUSTOMER_ACCOUNT"));
				dataMap.put("CUSTOMER_HOME_BRANCH", resultSet.getString("CUSTOMER_HOME_BRANCH"));
				
				if(actionType == "showLEAList"){
					dataMap.put("MAKERCODE", resultSet.getString("MAKERCODE"));
					dataMap.put("MAKERTIMESTAMP", resultSet.getString("MAKERTIMESTAMP"));
					dataMap.put("CHECKERCODE", resultSet.getString("CHECKERCODE"));
					dataMap.put("CHECKERTIMESTAMP", resultSet.getString("CHECKERTIMESTAMP"));
					dataMap.put("UPDATETIMESTAMP", resultSet.getString("UPDATETIMESTAMP"));
					dataMap.put("UPDATEDBY", resultSet.getString("UPDATEDBY"));
				}
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return dataMap;
	}
	
	@Override
	public String updateLEAList(Map<String,String> dataMap, String listCode, String userCode, String userRole){
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String message = "";
		String status = "P";
		//System.out.println("DataMap = "+dataMap);
		try{
			String sql = "UPDATE "+schemaName+"TB_LEALIST SET "+
					     "	     FIRST_NAME = ?, MIDDLE_NAME = ?, SURNAME = ?, GENDER = ?, "+
						 "		 SOURCE_OF_LETTER_MAIL = ?, ADDRESS_LINE = ?, IDENTIFICATION_TYPE = ?, IDENTIFICATION_NUMBER = ?, LETTER_RECEIVED_DATE = FUN_CHARTODATE(?), "+
						 "  	 SCRUBBING_DATE = FUN_CHARTODATE(?), SCRUBBING_RESULT_MATCH = ?, CUSTOMER_NAME = ?, CUSTOMER_UCIC = ?, CUSTOMER_ACCOUNT = ?, "+
						 "	 	 CUSTOMER_HOME_BRANCH = ?, MAKERCODE = ?, MAKERTIMESTAMP = SYSTIMESTAMP, CHECKERCODE = ?, CHECKERTIMESTAMP = ?, UPDATETIMESTAMP = SYSTIMESTAMP, "+
						 "  	 STATUS = ?, SERIALNO = ?, UPDATEDBY = ? "+
						 " WHERE LISTCODE = ? ";
		
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, dataMap.get("firstName"));
			preparedStatement.setString(2, dataMap.get("middleName"));
			preparedStatement.setString(3, dataMap.get("surname"));
			preparedStatement.setString(4, dataMap.get("gender"));
			preparedStatement.setString(5, dataMap.get("sourceOfLetterMail"));
			preparedStatement.setString(6, dataMap.get("addressLine"));
			preparedStatement.setString(7, dataMap.get("identificationType"));
			preparedStatement.setString(8, dataMap.get("identificationNumber"));
			preparedStatement.setString(9, dataMap.get("letterReceivedDate"));
			preparedStatement.setString(10, dataMap.get("scrubbingDate"));
			preparedStatement.setString(11, dataMap.get("scrubbingResultMatch"));
			preparedStatement.setString(12, dataMap.get("customerName"));
			preparedStatement.setString(13, dataMap.get("customerUCIC"));
			preparedStatement.setString(14, dataMap.get("customerAccount"));
			preparedStatement.setString(15, dataMap.get("customerHomeBranch"));
			preparedStatement.setString(16, userCode);
			preparedStatement.setString(17, "");
			preparedStatement.setString(18, "");
			preparedStatement.setString(19, status);
			preparedStatement.setString(20, dataMap.get("serialNo"));
			preparedStatement.setString(21, userCode);
			preparedStatement.setString(22, listCode);

		    //System.out.println("sql = "+sql);	
			int count = preparedStatement.executeUpdate();
			if(count == 1){
				message ="LEA List successfully updated.";
			}else
				message ="LEA List is not updated.";
		}catch(Exception e){
			message ="Error while updating LEA List.";
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, null, null);
		}
		return message;
	}
	
	@Override
	public String approveOrRejectLEAList(String listCode, String status, String userCode) {
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		String message = "";
		
		try{
			String sql = "UPDATE "+schemaName+"TB_LEALIST "+
						 "   SET STATUS = ?, CHECKERCODE = ?, CHECKERTIMESTAMP = SYSTIMESTAMP, "+
						 "       UPDATETIMESTAMP = SYSTIMESTAMP, UPDATEDBY = ? "+
						 " WHERE LISTCODE = ? ";
		
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, status);
			preparedStatement.setString(2, userCode);
			preparedStatement.setString(3, userCode);
			preparedStatement.setString(4, listCode);

			int count = preparedStatement.executeUpdate();
			if(count == 1){
				if(("A").equals(status)){
					message ="LEA List successfully approved.";
				}else if(("R").equals(status)){
					message ="LEA List successfully rejected.";
				}
			}else{
				if(("A").equals(status)){
					message ="LEA List is not approved.";
				}else if(("R").equals(status)){
					message ="LEA List is not rejected.";
				}
			}
		}catch(Exception e){
			message ="Error while approving/rejecting LEA List.";
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, null, null);
		}
		return message;
	}
	/*public String deleteLEAList(String listCode){
		String result = "";
		listCode = listCode.replaceAll(",", "','");
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		String sql = "";
		try{
			sql = "DELETE FROM "+schemaName+"TB_LEALIST WHERE LISTCODE IN ('"+listCode+"')";
			connection = connectionUtil.getConnection();
			preparedStatement = connection.prepareStatement(sql);
			//preparedStatement.setString(1, listCode);
			int count = preparedStatement.executeUpdate();
			//System.out.println(count);
			result = "LEAList record(s) is/are deleted";
		}catch(Exception e){
			result = "Error while deleting LEAList record(s)";
			e.printStackTrace();	
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, null, null);		
		}
		return result;
	}*/
}

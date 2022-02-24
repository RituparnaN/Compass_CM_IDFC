package com.quantumdataengines.app.compass.dao.scanning;

import java.sql.Connection;
import java.sql.CallableStatement;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import oracle.jdbc.OracleTypes;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Repository;

import com.quantumdataengines.app.compass.util.CommonUtil;
import com.quantumdataengines.app.compass.util.ConnectionUtil;

@Repository
public class TemplateScreeningDAOImpl implements TemplateScreeningDAO {

	@Autowired
	private ConnectionUtil connectionUtil;
	
	@Value("${compass.aml.config.schemaName}")
	private String schemaName;
	
	@Override
	public Map<String, Object> searchTemplateScreening(String templateId, String templateName, String templateType, String templateDate, String userCode, String userRole, String ipAddress, String subModuleCode) {
		Map<String, Object> resultMap = new HashMap<String, Object>();		
		List<Map<String, String>> mainList = new Vector<Map<String,String>>();
		Connection connection = null;
		//PreparedStatement preparedStatement = null;
		CallableStatement callableStatement = null;
		ResultSet resultSet = null;
		//String queryString = "";
		try{
			connection = connectionUtil.getConnection();
			/*
			queryString= "SELECT SEQNO TEMPLATESCAN, A.TEMPLATEID, A.TEMPLATENAME, A.TEMPLATETYPE, "+
					     "       FUN_DATETOCHAR(A.TEMPLATEDATE) TEMPLATEDATE, A.SCREENINGSTATUS,  "+
					     "       A.USERCODE, A.USERBRANCHCODE, A.USERROLE, A.USERIPADDRESS,A.ISFREEZED "+
						 "  FROM "+schemaName+"TB_TEMPLATESCREENING_MASTER A "+
						 " WHERE NVL(A.USERBRANCHCODE,'ALL') IN (SELECT NVL(B.BRANCHCODE,'ALL') FROM TB_USER B) ";
			if(templateId != null && templateId.length()>0)
				queryString = queryString + " AND UPPER(TEMPLATEID) LIKE '%"+templateId.trim().toUpperCase()+"%'";
			if(templateName != null && templateName.length()>0)
				queryString = queryString + " AND UPPER(TEMPLATENAME) LIKE '%"+templateName.trim().toUpperCase()+"%'";
			if(templateType != null && templateType.length()>0 && !templateType.equalsIgnoreCase("A"))
				queryString = queryString + " AND TEMPLATETYPE = '"+templateType+"'";
			if(templateDate != null && templateDate.length()>0)
				queryString = queryString + " AND TEMPLATEDATE = FUN_CHARTODATE('"+templateDate+"')";
			
			queryString = queryString + " ORDER BY SEQNO DESC ";
			preparedStatement = connection.prepareStatement(queryString);
			resultSet = preparedStatement.executeQuery();
			*/
			callableStatement = connection.prepareCall("{CALL "+schemaName+"STP_TEMPLATEBASED_GETLIST(?,?,?,?,?,?,?,?,?)}");
			callableStatement.setString(1, templateId);
			callableStatement.setString(2, templateName);
			callableStatement.setString(3, templateType);
			callableStatement.setString(4, templateDate);
			callableStatement.setString(5, subModuleCode);
			callableStatement.setString(6, userCode);
			callableStatement.setString(7, userRole);
			callableStatement.setString(8, ipAddress);
			callableStatement.registerOutParameter(9, OracleTypes.CURSOR);
			callableStatement.execute();
			resultSet = (ResultSet) callableStatement.getObject(9);

			List<String> headers = new Vector<String>();
			ResultSetMetaData resultSetMetaData = resultSet.getMetaData();
			int numberofcols = resultSetMetaData.getColumnCount();
			for(int count = 1; count <= numberofcols; count++ ){
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
			resultMap.put("HEADER", headers);
			resultMap.put("DATA", mainList);
		}catch(Exception e){
			e.printStackTrace();	
		}finally{
			//connectionUtil.closeResources(connection, preparedStatement,resultSet,null);
			connectionUtil.closeResources(connection, callableStatement,resultSet,null);
		}
		return resultMap;
	}
	
	public Map<String, Object> createTemplateScreening(String templateId, String templateName, String templateType, String userCode, String userRole, String ipAddress){
		Map<String, Object> resultMap = new HashMap<String, Object>();		
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		int templateCreated = 0;
		int existingCount = 0 ;
		int seqNo = 0 ;
		String userBranchCode = "";
		String queryString = "";
		try{
			connection = connectionUtil.getConnection();
			
			queryString = " SELECT COUNT(1) EXISTINGCOUNT "+
						  "   FROM "+schemaName+"TB_TEMPLATESCREENING_MASTER A "+
                          "  WHERE UPPER(TRIM(TEMPLATEID)) = ? ";
			preparedStatement = connection.prepareStatement(queryString);
			preparedStatement.setString(1, templateId.trim().toUpperCase());
			resultSet = preparedStatement.executeQuery();
			if(resultSet.next()){
				existingCount = resultSet.getInt("EXISTINGCOUNT");
			}
			
			if(existingCount > 0 ){
				resultMap.put("RESULTMESSAGE", "Template With This TemplateId Alredy Exists");
			}
			else{
			queryString = " SELECT "+schemaName+"SEQ_TEMPLATESCREENING.NEXTVAL AS SEQNO, NVL(BRANCHCODE,'ALL') USERBRANCHCODE "+
                          "  FROM TB_USER A "+
                          " WHERE USERCODE = ? ";
			preparedStatement = connection.prepareStatement(queryString);
			preparedStatement.setString(1, userCode);
			resultSet = preparedStatement.executeQuery();
			if(resultSet.next()){
				seqNo = resultSet.getInt("SEQNO");
				userBranchCode = resultSet.getString("USERBRANCHCODE");
			}
			
			queryString = " INSERT INTO "+schemaName+"TB_TEMPLATESCREENING_MASTER( "+
			              "        SEQNO, TEMPLATEID, TEMPLATENAME, TEMPLATETYPE, TEMPLATEDATE, "+
			              "        TEMPLATE_VERSIONNO, REFERENCE_TEMPLATEID, REFERENCE_TEMPLATENAME, "+
						  "        USERCODE, USERBRANCHCODE, USERROLE, USERIPADDRESS, "+
						  "		   UPDATETIMESTAMP, UPDATEDBY) "+
						  " VALUES(?,?,?,?,SYSTIMESTAMP,?,?,?,?,?,?,?,SYSTIMESTAMP,?) ";
			preparedStatement = connection.prepareStatement(queryString);
			preparedStatement.setInt(1, seqNo);
			preparedStatement.setString(2, templateId.trim());
			preparedStatement.setString(3, templateName.trim());
			preparedStatement.setString(4, templateType);
			preparedStatement.setString(5, "1");
			preparedStatement.setString(6, templateId);
			preparedStatement.setString(7, templateName);
			preparedStatement.setString(8, userCode);
			preparedStatement.setString(9, userBranchCode);
			preparedStatement.setString(10, userRole);
			preparedStatement.setString(11, ipAddress);
			preparedStatement.setString(12, userCode);
			preparedStatement.executeUpdate();
			
			resultMap.put("RESULTMESSAGE", "Created Successfully");
			templateCreated++;
		}
		}catch(Exception e){
			resultMap.put("RESULTMESSAGE", "Error while creating template");
			e.printStackTrace();	
		}finally{
			connectionUtil.closeResources(connection, preparedStatement,resultSet,null);		
		}

		if(templateCreated>0)
		{
			resultMap = searchTemplateScreening(templateId, templateName, templateType, "", userCode, userRole, ipAddress,"N.A.");
		}
		
		
		//System.out.println("DAOIMPL"+resultMap);
		return resultMap;
	}
	
	public Map<String, Object> templateScreeningDetail(String templateId, String userCode, String userRole, String ipAddress, String subModuleCode){
		Map<String, Object> resultMap = new HashMap<String, Object>();		
		List<Map<String, String>> mainList = new Vector<Map<String,String>>();
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		PreparedStatement preparedStatement2 = null;
		ResultSet resultSet = null;
		ResultSet resultSet2 = null;
		String queryString = "";
		String queryString2 = "";
		String isFreez = "";
		try{
			queryString = "SELECT FIELDTYPE, FIELDVALUE, SEQNO "+
						  "  FROM "+schemaName+"TB_TEMPLATESCREENING_DATA "+
			              " WHERE TEMPLATEID = ? "+
			              " ORDER BY SEQNO DESC ";
			connection = connectionUtil.getConnection();
			preparedStatement = connection.prepareStatement(queryString);
			preparedStatement.setString(1, templateId);
			resultSet = preparedStatement.executeQuery();

			List<String> headers = new Vector<String>();
			ResultSetMetaData resultSetMetaData = resultSet.getMetaData();
			int numberofcols = resultSetMetaData.getColumnCount();
			for(int count = 1; count <= numberofcols; count++ ){
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
			resultMap.put("TEMPLATEDETAILHEADER", headers);
			resultMap.put("TEMPLATEDETAILDATA", mainList);
			
			queryString2 = "SELECT ISFREEZED FROM "+schemaName+"TB_TEMPLATESCREENING_MASTER WHERE TEMPLATEID = ? ";
			preparedStatement2 = connection.prepareStatement(queryString2);
			preparedStatement2.setString(1, templateId);
			resultSet2 = preparedStatement2.executeQuery();
			
			while(resultSet2.next()){
				isFreez = resultSet2.getString("ISFREEZED");
			}
			
			resultMap.put("ISFREEZED", isFreez);
			
			
			
			
		}catch(Exception e){
			e.printStackTrace();	
		}finally{
			connectionUtil.closeResources(connection, preparedStatement,resultSet,null);		
		}
		Map<String, Object> mainData = new HashMap<String, Object>();
		
		mainData = searchTemplateScreening(templateId, "","","", userCode, userRole, ipAddress, subModuleCode);
		
		resultMap.put("TEMPLATEHEADER", mainData.get("HEADER"));
		resultMap.put("TEMPLATEDATA", mainData.get("DATA"));
		
		return resultMap;
	}
	
	public String insertDetailForTemplateScreening(String templateId, String templateName, String nameValue, String countryValue, String idValue, String userCode, String userRole, String ipAddress){
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		int seqNo = 0;
		String result = "";
		String queryString = "";
		
		String fieldTypes = "";
		
		try{
			connection = connectionUtil.getConnection();
			/*
			preparedStatement = connection.prepareStatement("SELECT "+schemaName+"SEQ_TEMPLATESCREENING_DATA.NEXTVAL AS SEQNO FROM DUAL");
			resultSet = preparedStatement.executeQuery();
			
			if(resultSet.next()){
				seqNo = resultSet.getInt("SEQNO");
			}
			*/
			if(nameValue != null && !nameValue.equalsIgnoreCase("")){
				queryString = " INSERT INTO "+schemaName+"TB_TEMPLATESCREENING_DATA( "+
							  "        SEQNO, TEMPLATEID, FIELDTYPE, FIELDVALUE, "+
							  "        UPDATEDBY, UPDATETIMESTAMP) "+
							  " SELECT "+schemaName+"SEQ_TEMPLATESCREENING_DATA.NEXTVAL, ?, ?, ?, "+
							  "        ?, SYSTIMESTAMP "+
							  "   FROM DUAL ";
			
				preparedStatement = connection.prepareStatement(queryString);
				preparedStatement.setString(1, templateId);
				preparedStatement.setString(2, "NAME");
				preparedStatement.setString(3, nameValue);
				preparedStatement.setString(4, userCode);
				preparedStatement.executeUpdate();
				
				fieldTypes = " Name, ";
			}
			if(countryValue != null && !countryValue.equalsIgnoreCase("")){
				queryString = " INSERT INTO "+schemaName+"TB_TEMPLATESCREENING_DATA( "+
				              "        SEQNO, TEMPLATEID, FIELDTYPE, FIELDVALUE, "+
				              "        UPDATEDBY, UPDATETIMESTAMP) "+
							  " SELECT "+schemaName+"SEQ_TEMPLATESCREENING_DATA.NEXTVAL, ?, ?, ?, "+
							  "        ?, SYSTIMESTAMP "+
							  "   FROM DUAL ";
				
				preparedStatement = connection.prepareStatement(queryString);
				preparedStatement.setString(1, templateId);
				preparedStatement.setString(2, "COUNTRY");
				preparedStatement.setString(3, countryValue);
				preparedStatement.setString(4, userCode);
				preparedStatement.executeUpdate();
				
				fieldTypes = fieldTypes + " Country ";
			}
			if(idValue != null && !idValue.equalsIgnoreCase("")){
				queryString = " INSERT INTO "+schemaName+"TB_TEMPLATESCREENING_DATA( "+
				              "        SEQNO, TEMPLATEID, FIELDTYPE, FIELDVALUE, "+
				              "        UPDATEDBY, UPDATETIMESTAMP) "+
							  " SELECT "+schemaName+"SEQ_TEMPLATESCREENING_DATA.NEXTVAL, ?, ?, ?, "+
							  "        ?, SYSTIMESTAMP "+
							  "   FROM DUAL ";
				
				preparedStatement = connection.prepareStatement(queryString);
				preparedStatement.setString(1, templateId);
				preparedStatement.setString(2, "IDVALUE");
				preparedStatement.setString(3, idValue);
				preparedStatement.setString(4, userCode);
				preparedStatement.executeUpdate();
				
				fieldTypes = fieldTypes + " IDValue ";
			}
			
			result = fieldTypes + " Successfully Added";
		}catch(Exception e){
			result = "Error while Adding "+fieldTypes+" Name";
			e.printStackTrace();	
		}finally{
			connectionUtil.closeResources(connection, preparedStatement,resultSet,null);		
		}
		return result;
	}
	
	public String deleteTemplateDetails(String templateId, String templateName, String seqNo, String userCode, String userRole, String ipAddress){
		String result = "";
		seqNo = "'"+seqNo.replaceAll(",", "','")+"'";
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		String queryString = "";
		try{
			queryString = " DELETE FROM "+schemaName+"TB_TEMPLATESCREENING_DATA"+
						  "  WHERE SEQNO IN ("+seqNo+") "+
						  "    AND TEMPLATEID = ? ";
			connection = connectionUtil.getConnection();
			preparedStatement = connection.prepareStatement(queryString);
			//preparedStatement.setString(1, seqNo);
			preparedStatement.setString(1, templateId);
			preparedStatement.executeUpdate();
			result = "details are deleted";
		}catch(Exception e){
			result = "Error while deleting Template Details";
			e.printStackTrace();	
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, null, null);		
		}
		return result;
	}
	
	public String getTemplateFieldValues(String templateSeqNo, String fieldType){
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String queryString = "";
		String fieldValues = "";
		try{
			queryString = " SELECT B.FIELDVALUE "+
			              "   FROM "+schemaName+"TB_TEMPLATESCREENING_MASTER A, "+schemaName+"TB_TEMPLATESCREENING_DATA B "+
						  "  WHERE A.SEQNO = ? " +
						  "    AND A.TEMPLATEID = B.TEMPLATEID "+
						  "    AND B.FIELDTYPE = ? "+
						  "  ORDER BY B.SEQNO ";
			connection = connectionUtil.getConnection();
			preparedStatement = connection.prepareStatement(queryString);
			preparedStatement.setString(1, templateSeqNo);
			preparedStatement.setString(2, fieldType);
			resultSet = preparedStatement.executeQuery();
			
			while(resultSet.next()){
				fieldValues = fieldValues + resultSet.getString("FIELDVALUE")+"#";
			}
		}catch(Exception e){
			e.printStackTrace();	
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);		
		}
		return fieldValues;
	}
	
	public String saveScreeningMapping(String templateSeqNo, String uniqueNumber, String fileName, String userCode, String userRole, String ipAddress){
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String queryString = "";
		try{
			connection = connectionUtil.getConnection();
			queryString = "INSERT INTO "+schemaName+"TB_TEMPLATE_SCREENINGMAPPING ( "+
                          "       SEQNO, UNIQUENUMBER, FILENAME, "+
                          "       USERCODE, USERROLE, IPADDRESS, "+
                          "       UPDATEDBY, UPDATETIMESTAMP) "+
                          " VALUES(?,?,?,?,?,?,?,SYSTIMESTAMP) ";
			preparedStatement = connection.prepareStatement(queryString);
			preparedStatement.setString(1, templateSeqNo);
			preparedStatement.setString(2, uniqueNumber);
			preparedStatement.setString(3, fileName);
			preparedStatement.setString(4, userCode);
			preparedStatement.setString(5, userRole);
			preparedStatement.setString(6, ipAddress);
			preparedStatement.setString(7, userCode);
			preparedStatement.executeUpdate();
			
			queryString = "UPDATE "+schemaName+"TB_TEMPLATESCREENING_MASTER A "+
			              "   SET A.SCREENINGREFERENCENO = ?, "+
			              "       A.SCREENINGSTATUS = 'Y' "+
			              " WHERE SEQNO = ? ";
			preparedStatement = connection.prepareStatement(queryString);
			preparedStatement.setString(1, fileName); 
			preparedStatement.setString(2, templateSeqNo); 
			preparedStatement.executeUpdate();

		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}	
		return "";
	}
	
	// function for create and freeze
	public Map<String, Object> createAndFreeze(String templateSeqNo, String templateId, String userCode, String userRole, String ipAddress)
	{
		Map<String, Object> resultMap = new HashMap<String, Object>();		
		List<Map<String, String>> mainList = new Vector<Map<String,String>>();
		Connection connection = connectionUtil.getConnection();
		CallableStatement callableStatement = null;
		ResultSet resultSet = null;
		
		try{
			callableStatement = connection.prepareCall("{CALL "+schemaName+"STP_TEMPLATEBASED_FREEZE(?,?,?,?,?,?)}");
			callableStatement.setString(1, templateSeqNo);
			callableStatement.setString(2, templateId);
			callableStatement.setString(3, userCode);
			callableStatement.setString(4, userRole);
			callableStatement.setString(5, ipAddress);
			callableStatement.registerOutParameter(6, OracleTypes.CURSOR);
			callableStatement.execute();
			resultSet = (ResultSet) callableStatement.getObject(6);
			
			List<String> headers = new Vector<String>();
			ResultSetMetaData resultSetMetaData = resultSet.getMetaData();
			int numberofcols = resultSetMetaData.getColumnCount();
			for(int count = 1; count <= numberofcols; count++ ){
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
			
			resultMap.put("HEADER", headers);
			resultMap.put("DATA", mainList);
			resultMap.put("FreezedStatus", true);
			
		}catch(Exception e){
			resultMap.put("FreezedStatus", false);
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, callableStatement, resultSet, null);
		}
		
		return resultMap;
	}
	
	// function for create new version
	public Map<String, Object> createNewVersion(String templateSeqNo, String templateId, String userCode, String userRole, String ipAddress)
	{
		Map<String, Object> resultMap = new HashMap<String, Object>();		
		List<Map<String, String>> mainList = new Vector<Map<String,String>>();
		Connection connection = connectionUtil.getConnection();
		CallableStatement callableStatement = null;
		ResultSet resultSet = null;
		
		try{
			callableStatement = connection.prepareCall("{CALL "+schemaName+"STP_TEMPLATEBASED_NEWVERSION(?,?,?,?,?,?)}");
			callableStatement.setString(1, templateSeqNo);
			callableStatement.setString(2, templateId);
			callableStatement.setString(3, userCode);
			callableStatement.setString(4, userRole);
			callableStatement.setString(5, ipAddress);
			callableStatement.registerOutParameter(6, OracleTypes.CURSOR);
			callableStatement.execute();
			resultSet = (ResultSet) callableStatement.getObject(6);
			
			List<String> headers = new Vector<String>();
			ResultSetMetaData resultSetMetaData = resultSet.getMetaData();
			int numberofcols = resultSetMetaData.getColumnCount();
			for(int count = 1; count <= numberofcols; count++ ){
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
			
			resultMap.put("HEADER", headers);
			resultMap.put("DATA", mainList);
			
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, callableStatement, resultSet, null);
		}
		
		return resultMap;
	}

	@Override
	public Map checkTemplateId(String templateId) {
		
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		int existingCount = 0 ;
		Map output = new HashMap();
		
		
		
		try{
			connection = connectionUtil.getConnection();
			
			String queryString = " SELECT COUNT(1) EXISTINGCOUNT "+
						  "   FROM "+schemaName+"TB_TEMPLATESCREENING_MASTER A "+
                          "  WHERE UPPER(TRIM(TEMPLATEID)) = ? ";
			preparedStatement = connection.prepareStatement(queryString);
			preparedStatement.setString(1, templateId.trim().toUpperCase());
			resultSet = preparedStatement.executeQuery();
			if(resultSet.next()){
				existingCount = resultSet.getInt("EXISTINGCOUNT");
			}
			
			if(existingCount > 0 ){
				output.put("message", "Template With This TemplateId Alredy Exists");
				output.put("duplicate", true);
			}
			else{
				output.put("message", "Template With This TemplateId does not Exists");
				output.put("duplicate", false);
			}
		}catch(Exception e){
			output.put("message", "Error while Checking uniquness of template id");
			output.put("duplicate", true);
			e.printStackTrace();	
		}finally{
			connectionUtil.closeResources(connection, preparedStatement,resultSet,null);		
		}
		return output;
	}
	
	@Override
	public Map<String, String> getTemplateScreeningDetails(String templateSeqNo) {
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String queryString = "";
		HashMap<String, String> screeningDetails = new HashMap<String, String>();
		try{
			connection = connectionUtil.getConnection();
			queryString = " SELECT ISFREEZED, SCREENINGREFERENCENO "+
						  "   FROM "+schemaName+"TB_TEMPLATESCREENING_MASTER A "+
                          "  WHERE SEQNO = ? ";
			preparedStatement = connection.prepareStatement(queryString);
			preparedStatement.setString(1, templateSeqNo);
			resultSet = preparedStatement.executeQuery();
			if(resultSet.next()){
				screeningDetails.put("isFreezed", resultSet.getString("ISFREEZED"));
				screeningDetails.put("screeningReferenceNo", resultSet.getString("SCREENINGREFERENCENO"));
			}
		}catch(Exception e){
			e.printStackTrace();	
		}finally{
			connectionUtil.closeResources(connection, preparedStatement,resultSet,null);		
		}
		return screeningDetails;
	}
	
	// function for create and freeze
	public Map<String, Object> updateTemplateScreeningStatus(String templateSeqNo, String templateScreeningStatus, String userComments, String userCode, String userRole, String ipAddress)
	{
		Map<String, Object> resultMap = new HashMap<String, Object>();		
		List<Map<String, String>> mainList = new Vector<Map<String,String>>();
		Connection connection = connectionUtil.getConnection();
		CallableStatement callableStatement = null;
		ResultSet resultSet = null;
		
		try{
			callableStatement = connection.prepareCall("{CALL "+schemaName+"STP_TEMPLATEBASED_UPDATESTATUS(?,?,?,?,?,?,?)}");
			callableStatement.setString(1, templateSeqNo);
			callableStatement.setString(2, templateScreeningStatus);
			callableStatement.setString(3, userComments);
			callableStatement.setString(4, userCode);
			callableStatement.setString(5, userRole);
			callableStatement.setString(6, ipAddress);
			callableStatement.registerOutParameter(7, OracleTypes.CURSOR);
			callableStatement.execute();
			resultSet = (ResultSet) callableStatement.getObject(7);
			
			List<String> headers = new Vector<String>();
			ResultSetMetaData resultSetMetaData = resultSet.getMetaData();
			int numberofcols = resultSetMetaData.getColumnCount();
			for(int count = 1; count <= numberofcols; count++ ){
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
			
			resultMap.put("HEADER", headers);
			resultMap.put("DATA", mainList);
			resultMap.put("TemplateScreeningStatus", true);
			
		}catch(Exception e){
			resultMap.put("TemplateScreeningStatus", false);
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, callableStatement, resultSet, null);
		}
		
		return resultMap;
	}

}

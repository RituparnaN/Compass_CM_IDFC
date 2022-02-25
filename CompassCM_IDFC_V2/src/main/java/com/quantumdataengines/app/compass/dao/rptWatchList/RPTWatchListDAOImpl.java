package com.quantumdataengines.app.compass.dao.rptWatchList;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import oracle.jdbc.OracleTypes;
import oracle.jdbc.oracore.OracleType;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Repository;

import com.quantumdataengines.app.compass.util.CommonUtil;
import com.quantumdataengines.app.compass.util.ConnectionUtil;

@Repository
public class RPTWatchListDAOImpl implements RPTWatchListDAO{
	
	private static final Logger log = LoggerFactory.getLogger(RPTWatchListDAOImpl.class);
	
	@Autowired
	private ConnectionUtil connectionUtil;
	
	@Value("${compass.aml.config.schemaName}")
	private String schemaName;
	
	public String createRPTList(String listCode, String listName, String description, String listType, String userCode){
		String message = "";
		int existingCount = 0;
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareStatement("SELECT COUNT(1) COUNTVAL FROM "+schemaName+"TB_RPTWATCHLIST WHERE TRIM(UPPER(LISTCODE)) = TRIM(UPPER(?))");
			preparedStatement.setString(1, listCode);
			resultSet = preparedStatement.executeQuery();
			if(resultSet.next())
				existingCount = resultSet.getInt("COUNTVAL");
			
			if(existingCount > 0){
				message = "RPT WatchList with List Code "+listCode+" is already available. Please enter a unique List Code and try again";
			}else{
				connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
				connection = connectionUtil.getConnection();
				preparedStatement = connection.prepareStatement("INSERT INTO "+schemaName+"TB_RPTWATCHLIST(LISTCODE, LISTNAME, DESCRIPTION, LISTTYPE, UPDATETIMESTAMP, UPDATEDBY, STATUS) "+
																"VALUES(?,?,?,?,SYSTIMESTAMP,?,?)");
				preparedStatement.setString(1, listCode);
				preparedStatement.setString(2, listName);
				preparedStatement.setString(3, description);
				preparedStatement.setString(4, listType);
				preparedStatement.setString(5, userCode);
				preparedStatement.setString(6, "EM");
				preparedStatement.executeUpdate();
				message = "CREATED";
			}
		}catch(Exception e){
			message = "Error while creating RPT Watch List";
			log.error("Error while creating RPT Watch List : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return message;
	}
	
	public Map<String, String> openRPTWatchListDetails(String listCode, String userCode, String userRole, String ipAddress){
		Map<String, String> rptDetails = new HashMap<String, String>();
		Connection connection = connectionUtil.getConnection();
		CallableStatement callableStatement = null;
		ResultSet resultSet = null;
		try{
			callableStatement = connection.prepareCall("{CALL "+schemaName+"STP_SEARCHRPTWATCHLIST(?,?,?,?,?,?,?,?)}");
			callableStatement.setString(1, listCode);
			callableStatement.setString(2, "");
			callableStatement.setString(3, "");
			callableStatement.setString(4, "");
			callableStatement.setString(5, userCode);
			callableStatement.setString(6, userRole);
			callableStatement.setString(7, ipAddress);
			callableStatement.registerOutParameter(8, OracleTypes.CURSOR);
			callableStatement.execute();
			
			resultSet = (ResultSet) callableStatement.getObject(8);
			ResultSetMetaData resultSetMetaData = resultSet.getMetaData();
						
			if(resultSet.next()){
				for(int colIndex = 1; colIndex <= resultSetMetaData.getColumnCount(); colIndex++){
					String columnName = resultSetMetaData.getColumnName(colIndex);
					rptDetails.put(CommonUtil.changeColumnName(columnName), resultSet.getString(columnName));
				}
			}
		}catch(Exception e){
			log.error("Error while fetching RPT WatchList Details : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, callableStatement, resultSet, null);
		}
		return rptDetails;
	}
	
	public Map<String, Object> openRPTWatchListCustomerDetails(String listCode, String entityName, String entityId, String idNo, String entityStatus){
		Map<String, Object> rptDetails = new HashMap<String, Object>();
		List<String> header = new Vector<String>();
		List<List<String>> data = new Vector<List<String>>();
		Connection connection = connectionUtil.getConnection();
		CallableStatement callableStatement = null;
		ResultSet resultSet = null;
		try{
			callableStatement = connection.prepareCall("{CALL STP_GETRPTLISTCUSTOMERDETAILS(?,?,?,?,?,?)}");
			callableStatement.setString(1, listCode);
			callableStatement.setString(2, entityName);
			callableStatement.setString(3, entityId);
			callableStatement.setString(4, idNo);
			callableStatement.setString(5, entityStatus);
			callableStatement.registerOutParameter(6, OracleTypes.CURSOR);
			callableStatement.execute();
			
			resultSet = (ResultSet) callableStatement.getObject(6);
			ResultSetMetaData resultSetMetaData = resultSet.getMetaData();
						
			for(int colIndex = 1; colIndex <= resultSetMetaData.getColumnCount(); colIndex++){
				header.add(CommonUtil.changeColumnName(resultSetMetaData.getColumnName(colIndex)));
			}
			
			while(resultSet.next()){
				List<String> record = new Vector<String>();
				for(int colIndex = 1; colIndex <= resultSetMetaData.getColumnCount(); colIndex++){
					String colName = resultSetMetaData.getColumnName(colIndex);
					record.add(resultSet.getString(colName));
				}
				data.add(record);
			}
			
			rptDetails.put("HEADER", header);
			rptDetails.put("DATA", data);
		}catch(Exception e){
			log.error("Error while fetching RPT WatchList Details : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, callableStatement, resultSet, null);
		}
		return rptDetails;
	}
	
	public Map<String, Object> getRPTAddEntityDetails(){
		Map<String, Object> addEntityDetails = new HashMap<String, Object>();
		Map<String, String> rptAdmins = new HashMap<String, String>();
		List<String> dropdown1List = new Vector<String>();
		List<String> dropdown2List = new Vector<String>();
		List<String> entityNameList = new Vector<String>();
		
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String query = "SELECT A.USERCODE, A.FIRSTNAME ||' '|| A.LASTNAME USERNAME FROM TB_USER A, TB_USERROLEMAPPING B WHERE A.USERCODE = B.USERCODE AND B.ROLEID='RPTADMIN' AND A.ACCOUNTENABLE = 'Y'";
		try{
			preparedStatement = connection.prepareStatement(query);
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()){
				rptAdmins.put(resultSet.getString("USERCODE"), resultSet.getString("USERNAME"));
			}
			
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
			
			connection = connectionUtil.getConnection();
			query = "SELECT DISTINCT DROPDOWN1 FROM "+schemaName+"TB_RPTDROPDOWNLIST WHERE DROPDOWN1 IS NOT NULL";
			preparedStatement = connection.prepareStatement(query);
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()){
				dropdown1List.add(resultSet.getString("DROPDOWN1"));
			}

			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
			
			connection = connectionUtil.getConnection();
			query = "SELECT DISTINCT DROPDOWN2 FROM "+schemaName+"TB_RPTDROPDOWNLIST WHERE DROPDOWN2 IS NOT NULL";
			preparedStatement = connection.prepareStatement(query);
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()){
				dropdown2List.add(resultSet.getString("DROPDOWN2"));
			}

			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
			
			connection = connectionUtil.getConnection();
			query = "SELECT DISTINCT ENTITYNAME FROM "+schemaName+"TB_RPTCUSTOMERMAPPINGLIST";
			preparedStatement = connection.prepareStatement(query);
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()){
				entityNameList.add(resultSet.getString("ENTITYNAME"));
			}
			
			addEntityDetails.put("RPTADMINS", rptAdmins);
			addEntityDetails.put("DROPDOWN1", dropdown1List); 
			addEntityDetails.put("DROPDOWN2", dropdown2List); 
			addEntityDetails.put("ENTITYNAMES", entityNameList);
		}catch(Exception e){
			log.error("Error while getting RPT details : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return addEntityDetails;
	}
	
	public String addUpdateEntity(String listCode, String listName, String entityName, String entityId, String idType, String idNo,
			String relatedThrough, String shareHolding, String relation, String subRelation,
			String dropdown1, String dropdown2, String remarks, String status, String authorizer, String userCode){
		String  message = "";
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String query = "";
		try{
			if("NEW".equals(entityId)){
				query = "INSERT INTO "+schemaName+"TB_RPTCUSTOMERMAPPINGLIST(LISTCODE, LISTNAME, ENTITYID, ENTITYNAME, IDTYPE, IDNO, "+
						"		RELATEDTHROUGH, SHAREHOLDING, RELATION, SUBRELATION, DROPDOWN1, DROPDOWN2, ISENABLED, "+
						"		STATUS, UPDATEDBY, CHECKEDBY, UPDATETIMESTAMP) "+
						"VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,SYSTIMESTAMP)";
				preparedStatement = connection.prepareStatement("SELECT "+schemaName+"SEQ_RPTENTITYID.NEXTVAL ENTITYID FROM DUAL");
				resultSet = preparedStatement.executeQuery();
				if(resultSet.next())
					entityId = listCode+"-"+resultSet.getInt("ENTITYID");
				
				preparedStatement = connection.prepareStatement(query);
				preparedStatement.setString(1, listCode);
				preparedStatement.setString(2, listName);
				preparedStatement.setString(3, entityId);
				preparedStatement.setString(4, entityName);
				preparedStatement.setString(5, idType);
				preparedStatement.setString(6, idNo);
				preparedStatement.setString(7, relatedThrough);
				preparedStatement.setString(8, shareHolding);
				preparedStatement.setString(9, relation);
				preparedStatement.setString(10, subRelation);
				preparedStatement.setString(11, dropdown1);
				preparedStatement.setString(12, dropdown2);
				preparedStatement.setString(13, "Y");
				preparedStatement.setString(14, "PA");
				preparedStatement.setString(15, userCode);
				preparedStatement.setString(16, authorizer);
				preparedStatement.executeUpdate();
				message = "RPT Entity has been successfully added";
			} else {
				query = "UPDATE "+schemaName+"TB_RPTCUSTOMERMAPPINGLIST SET LISTCODE = ?, LISTNAME = ?, ENTITYNAME = ?, IDTYPE = ?, IDNO = ?, "+
						"		RELATEDTHROUGH = ?, SHAREHOLDING = ?, RELATION = ?, SUBRELATION = ?, DROPDOWN1 = ?, DROPDOWN2 = ?, ISENABLED = ?, "+
						"		STATUS = ?, UPDATEDBY = ?, CHECKEDBY = ?, UPDATETIMESTAMP = SYSTIMESTAMP "+
						" WHERE ENTITYID = ? ";
				preparedStatement = connection.prepareStatement(query);
				preparedStatement.setString(1, listCode);
				preparedStatement.setString(2, listName);
				preparedStatement.setString(3, entityName);
				preparedStatement.setString(4, idType);
				preparedStatement.setString(5, idNo);
				preparedStatement.setString(6, relatedThrough);
				preparedStatement.setString(7, shareHolding);
				preparedStatement.setString(8, relation);
				preparedStatement.setString(9, subRelation);
				preparedStatement.setString(10, dropdown1);
				preparedStatement.setString(11, dropdown2);
				preparedStatement.setString(12, "Y");
				preparedStatement.setString(13, "PA");
				preparedStatement.setString(14, userCode);
				preparedStatement.setString(15, authorizer);
				preparedStatement.setString(16, entityId);
				preparedStatement.executeUpdate();
				message = "RPT Entity has been successfully updated";
			}
		}catch(Exception e){
			message = "Error while adding/updating RPT Entity";
			log.error("Error while adding/updating RPT Entity : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return message;
	}
	
	public String updateRPTWatchList(String listCode, String listName, String description, String listType, String userCode){
		String message = "";
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String query = "UPDATE "+schemaName+"TB_RPTWATCHLIST SET LISTNAME = ?, DESCRIPTION = ?, LISTTYPE = ?, UPDATEDBY = ?, UPDATETIMESTAMP = SYSTIMESTAMP WHERE LISTCODE = ? ";
		try{
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, listName);
			preparedStatement.setString(2, description);
			preparedStatement.setString(3, listType);
			preparedStatement.setString(4, userCode);
			preparedStatement.setString(5, listCode);
			preparedStatement.executeUpdate();
			message = "RPT WatchList has been successfully updated";
		}catch(Exception e){
			message = "Error while updating RPT WatchList";
			log.error("Error while updating RPT WatchList : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return message;
	}
	
	public String removeDisableRPTWatchList(String entityID, String status, String isEnabled, String userCode){
		String message = "";
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String query = "UPDATE "+schemaName+"TB_RPTCUSTOMERMAPPINGLIST SET ISENABLED = ?, STATUS = ?, UPDATEDBY = ?, UPDATETIMESTAMP = SYSTIMESTAMP WHERE ENTITYID = ? ";
		try{
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, isEnabled);
			preparedStatement.setString(2, status);
			preparedStatement.setString(3, userCode);
			preparedStatement.setString(4, entityID);
			preparedStatement.executeUpdate();
			message = "RPT WatchList has been successfully modified";
		}catch(Exception e){
			message = "Error while updating RPT WatchList";
			log.error("Error while updating RPT WatchList : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return message;
	}
	
	public Map<String, Object> getPendingEntityForCheck(String userCode){
		Map<String, Object> pendingEntityList = new HashMap<String, Object>();
		List<String> header = new Vector<String>();
		List<List<String>> data = new Vector<List<String>>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String query =  "SELECT ROWNUM AS ROWPOSITION, A.LISTCODE RPTLISTCODE, A.LISTNAME, B.LISTTYPE, A.ENTITYID RPTENTITYID,  A.ENTITYNAME, A.IDTYPE, "+
				   		"	    A.IDNO, A.RELATEDTHROUGH, A.SHAREHOLDING, A.RELATION, A.SUBRELATION, A.DROPDOWN1, A.DROPDOWN2, "+
				   		"	    CASE A.ISENABLED WHEN 'Y' THEN 'ENABLED' ELSE 'DISABLED' END ISENABLED, "+
				   		"	    CASE A.STATUS WHEN 'PA' THEN 'PENDING FOR APPROVAL' WHEN 'PD' THEN 'PENDING FOR REMOVAL' "+
				   		"	    WHEN 'A' THEN 'APPROVED' ELSE 'REJECTED' END STATUS, FUN_DATETOCHAR(A.UPDATETIMESTAMP) ADDEDON, "+
				   		"	    A.UPDATEDBY ADDEDBY "+
				   		"  FROM "+schemaName+"TB_RPTCUSTOMERMAPPINGLIST A  "+
				   		"  LEFT OUTER JOIN "+schemaName+"TB_RPTWATCHLIST B ON A.LISTCODE = B.LISTCODE "+
				   		" WHERE A.CHECKEDBY = ? "+
				   		"   AND A.STATUS IN ('PA','PD')";
		try{
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, userCode);
			resultSet = preparedStatement.executeQuery();
			
			ResultSetMetaData resultSetMetaData = resultSet.getMetaData();
			
			for(int colIndex = 1; colIndex <= resultSetMetaData.getColumnCount(); colIndex++){
				header.add(CommonUtil.changeColumnName(resultSetMetaData.getColumnName(colIndex)));
			}
			
			while(resultSet.next()){
				List<String> record = new Vector<String>();
				for(int colIndex = 1; colIndex <= resultSetMetaData.getColumnCount(); colIndex++){
					String colName = resultSetMetaData.getColumnName(colIndex);
					record.add(resultSet.getString(colName));
				}
				data.add(record);
			}
			
			pendingEntityList.put("HEADER", header);
			pendingEntityList.put("DATA", data);
		}catch(Exception e){
			log.error("Error while getting Pending Entity List for checking : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return pendingEntityList;
	}
	
	public String approveEntity(String entityId, String remarks){
		String message = "";
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		int removeCount = 0;
		String status = "A";
		try{
			preparedStatement = connection.prepareStatement("SELECT COUNT(1) REMOVECOUNT FROM "+schemaName+"TB_RPTCUSTOMERMAPPINGLIST WHERE ISENABLED = 'N' AND STATUS = 'PD' AND ENTITYID = ?"); 
			preparedStatement.setString(1, entityId);
			resultSet = preparedStatement.executeQuery();
			if(resultSet.next())
				removeCount = resultSet.getInt("REMOVECOUNT");
			
			if(removeCount > 0){
				status = "REM";
			}
			
			preparedStatement = connection.prepareStatement("UPDATE "+schemaName+"TB_RPTCUSTOMERMAPPINGLIST SET STATUS = ?, REMARK = ?, CHECKERDATETIME = SYSTIMESTAMP WHERE ENTITYID = ?");
			preparedStatement.setString(1, status);
			preparedStatement.setString(2, remarks);
			preparedStatement.setString(3, entityId);
			preparedStatement.executeUpdate();
			
			if(removeCount > 0){
				preparedStatement = connection.prepareStatement("INSERT INTO "+schemaName+"TB_RPTCUSTOMERMAPPINGLIST_REM SELECT * FROM "+schemaName+"TB_RPTCUSTOMERMAPPINGLIST WHERE ENTITYID = ?");
				preparedStatement.setString(1, entityId);
				preparedStatement.executeUpdate();
				
				preparedStatement = connection.prepareStatement("DELETE FROM "+schemaName+"TB_RPTCUSTOMERMAPPINGLIST WHERE ENTITYID = ?");
				preparedStatement.setString(1, entityId);
				preparedStatement.executeUpdate();
				
				message = "RPT WatchList Entity Removed";
			}else{
				message = "RPT WatchList Entity Approved";
			}
			
		}catch(Exception e){
			message = "Error while approving RPT Entity";
			log.error("Error while approving RPT Entity : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return message;
	}
	
	public Map<String, String> rejectEntity(String entityId, String remarks){
		Map<String, String> messageMap = new HashMap<String, String>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		messageMap.put("ACTIONSTATUS", "0");
		messageMap.put("ACTIONMSG", "");
		String isEnabled = "";
		try{
			preparedStatement = connection.prepareStatement("UPDATE "+schemaName+"TB_RPTCUSTOMERMAPPINGLIST SET STATUS = ?, REMARK = ?, CHECKERDATETIME = SYSTIMESTAMP WHERE ENTITYID = ?");
			preparedStatement.setString(1, "R");
			preparedStatement.setString(2, remarks);
			preparedStatement.setString(3, entityId);
			preparedStatement.executeUpdate();
			
			preparedStatement = connection.prepareStatement("SELECT ISENABLED, STATUS FROM "+schemaName+"TB_RPTCUSTOMERMAPPINGLIST WHERE ENTITYID = ?"); 
			preparedStatement.setString(1, entityId);
			resultSet = preparedStatement.executeQuery();
			if(resultSet.next()){
				isEnabled = resultSet.getString("ISENABLED");
			}
			
			if(isEnabled.equals("N")){
				messageMap.put("ACTIONSTATUS", "1");
				messageMap.put("MOD", "Y-A");
				messageMap.put("ACTIONMSG", "RPT WatchList Entity DISABLE/REMOVE rejected. Do you want to make the same entity ENABLED?");
			}else{
				messageMap.put("ACTIONSTATUS", "1");
				messageMap.put("MOD", "N-A");
				messageMap.put("ACTIONMSG", "RPT WatchList Entity ENABLE rejected. Do you want to make the same entity DISABLED?");
			}
			
			
		}catch(Exception e){
			messageMap.put("ACTIONSTATUS", "0");
			messageMap.put("ACTIONMSG", "Error while rejecting RPT Entity");
			log.error("Error while rejecting RPT Entity : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return messageMap;
	}
	
	public String toggleStatusUponRejection(String ENTITYID, String STATUS){
		String isEnabled = CommonUtil.splitString(STATUS, "-")[0];
		String status = CommonUtil.splitString(STATUS, "-")[1];
		String message = "";
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareStatement("UPDATE "+schemaName+"TB_RPTCUSTOMERMAPPINGLIST SET ISENABLED = ?, STATUS = ? WHERE ENTITYID = ?");
			preparedStatement.setString(1, isEnabled);
			preparedStatement.setString(2, status);
			preparedStatement.setString(3, ENTITYID);
			preparedStatement.executeUpdate();
			message = "Status Updated";
		}catch(Exception e){
			message = "Error while updating RPT Entity status";
			log.error("Error while updating RPT Entity status : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return message;
	}
}

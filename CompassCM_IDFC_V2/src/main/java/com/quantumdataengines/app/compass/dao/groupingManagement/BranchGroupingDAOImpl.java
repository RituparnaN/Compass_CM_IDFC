package com.quantumdataengines.app.compass.dao.groupingManagement;

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
public class BranchGroupingDAOImpl implements BranchGroupingDAO {

	@Autowired
	private ConnectionUtil connectionUtil;
	
	@Value("${compass.aml.config.schemaName}")
	private String schemaName;
	
	@Override
	public Map<String, Object> searchBranchGrouping(String groupCode, String groupName, String description, String riskRating) {
		Map<String, Object> resultMap = new HashMap<String, Object>();		
		List<Map<String, String>> mainList = new Vector<Map<String,String>>();
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String sql= "";
		int count = 1;
		
		try{
			sql= "SELECT GROUPCODE GROUPCODE, GROUPNAME GROUPNAME, DESCRIPTION DESCRIPTION, "+
			     "		RISKRATING RISKRATING, FUN_DATETOCHAR (UPDATETIMESTAMP) CREATEDTIME, UPDATEDBY CREATEDBY "+
			     "  FROM "+schemaName+"TB_BRANCHGROUP "+
			     " WHERE 1 = 1 ";
			if(groupCode != null && groupCode.length()>0)
				//sql = sql + "AND GROUPCODE = '"+groupCode+"'";
				sql = sql + " AND GROUPCODE = ? ";
			if(groupName != null && groupName.length()>0)
				//sql = sql + "AND GROUPNAME = '"+groupName+"'";
				sql = sql + " AND GROUPNAME = ? ";
			if(description != null && description.length()>0)
				//sql = sql + "AND DESCRIPTION = '"+description+"'";
				sql = sql + " AND DESCRIPTION = ? ";
			if(riskRating != null && riskRating.length()>0)
				//sql = sql + "AND RISKRATING = '"+riskRating+"'";
				sql = sql + " AND RISKRATING = ? ";

			connection = connectionUtil.getConnection();
			preparedStatement = connection.prepareStatement(sql);

			if(groupCode != null && groupCode.length()>0){
				preparedStatement.setString(count, groupCode);
				count++;
			}
			if(groupName != null && groupName.length()>0){
				preparedStatement.setString(count, groupName);
				count++;
			}
			if(description != null && description.length()>0){
				preparedStatement.setString(count, description);
				count++;
			}
			if(riskRating != null && riskRating.length()>0){
				preparedStatement.setString(count, riskRating);
			}
			
			resultSet = preparedStatement.executeQuery();
			count = 1;
			
			List<String> headers = new Vector<String>();
			ResultSetMetaData resultSetMetaData = resultSet.getMetaData();
			int numberofcols = resultSetMetaData.getColumnCount();
			//for(int count = 1; count <= numberofcols; count++ ){
			for(count = 1; count <= numberofcols; count++ ){
				String colname = resultSetMetaData.getColumnName(count);
				headers.add(CommonUtil.changeColumnName(colname));
			}
			/*
			while(resultSet.next()){				
				Map<String, String> dataMap = new LinkedHashMap<String, String>();
				for(String header : headers){
					dataMap.put(header, resultSet.getString(header));
				}
				mainList.add(dataMap);
			}
			*/
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
			connectionUtil.closeResources(connection, preparedStatement,resultSet,null);		
		}
	return resultMap;
	}

	
	@SuppressWarnings("resource")
	@Override
	public Map<String, Object> createBranchGrouping(String groupCode, String groupName, String description, String riskRating, String userCode) {
		int i_riskRating = Integer.parseInt(riskRating);
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String sql = "";
		int count = 0;
		try{
			//String sql = "SELECT COUNT(1) GROUPCODECOUNT FROM "+schemaName+"TB_BRANCHGROUP WHERE GROUPCODE = ?";
			sql = " SELECT COUNT(1) GROUPCODECOUNT "+
			      "   FROM "+schemaName+"TB_BRANCHGROUP "+
			      "  WHERE GROUPCODE = ? ";
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, groupCode);
			resultSet = preparedStatement.executeQuery();
			if(resultSet.next()){
				count = resultSet.getInt("GROUPCODECOUNT"); 
			}
			
			if(count == 0){
				sql= "INSERT INTO "+schemaName+"TB_BRANCHGROUP("+
				     "       GROUPCODE, GROUPNAME, DESCRIPTION, RISKRATING, "+
					 "		 REGION_TYPE, UPDATETIMESTAMP, UPDATEDBY) "+
					 "VALUES (?,?,?,?,'',SYSTIMESTAMP,?) ";
			
				preparedStatement = connection.prepareStatement(sql);
				preparedStatement.setString(1, groupCode);
				preparedStatement.setString(2, groupName);
				preparedStatement.setString(3, description);
				preparedStatement.setInt(4, i_riskRating);
				preparedStatement.setString(5, userCode);
				preparedStatement.executeUpdate();
			}else{
				return searchBranchGrouping(groupCode, "", "", "");
			}
			
		}catch(Exception e){
			e.printStackTrace();	
		}finally{
			connectionUtil.closeResources(connection, preparedStatement,resultSet,null);		
		}
		return searchBranchGrouping(groupCode, groupName, description, riskRating);
	}
	
	public String deleteBranchGrouping(String groupCodeToDelete){
		String result = "";
		groupCodeToDelete = groupCodeToDelete.replaceAll(",", "','");
		//groupCodeToDelete = "'"+groupCodeToDelete+"'";
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		String sql = "";
		try{
			//sql = "DELETE FROM "+schemaName+"TB_BRANCHGROUP WHERE GROUPCODE IN ("+groupCodeToDelete+")";
			sql = "DELETE FROM "+schemaName+"TB_BRANCHGROUP WHERE GROUPCODE IN (?)";
			connection = connectionUtil.getConnection();
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, groupCodeToDelete);
			preparedStatement.executeUpdate(sql);
			result = "Branch Group deleted successfully.";
		}catch(Exception e){
			e.printStackTrace();
			result = "Error while deleting.";
		}finally{
			connectionUtil.closeResources(connection, preparedStatement,  null, null);
		}
		return result;
	}
	
	public Map<String, String> fetchBranchGroupingDetailsForUpdate(String groupCode){
		Map<String, String> branchGroupingDetailsMap = new HashMap<String, String>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareStatement("SELECT GROUPCODE GROUPCODE, GROUPNAME GROUPNAME, DESCRIPTION DESCRIPTION, "+
															"		RISKRATING RISKRATING, UPDATEDBY UPDATEDBY, FUN_DATETOCHAR(UPDATETIMESTAMP) UPDATETIME"+
															"  FROM "+schemaName+"TB_BRANCHGROUP "+
															" WHERE GROUPCODE = ?");
			preparedStatement.setString(1, groupCode);
			resultSet = preparedStatement.executeQuery();
			if (resultSet.next()) {
				branchGroupingDetailsMap.put("GROUPCODE", resultSet.getString("GROUPCODE"));
				branchGroupingDetailsMap.put("GROUPNAME", resultSet.getString("GROUPNAME"));
				branchGroupingDetailsMap.put("DESCRIPTION", resultSet.getString("DESCRIPTION"));
				branchGroupingDetailsMap.put("RISKRATING", resultSet.getString("RISKRATING"));
				branchGroupingDetailsMap.put("UPDATEDBY", resultSet.getString("UPDATEDBY"));
				branchGroupingDetailsMap.put("UPDATETIME", resultSet.getString("UPDATETIME"));
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement,resultSet,null);	
		}
		return branchGroupingDetailsMap;
	}
	
	public String updateBranchGroupingDetails(String groupCode, String groupName, String description, String riskRating, String userCode){
		int i_riskRating = Integer.parseInt(riskRating);
		String result ;
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
				
		String sql = "UPDATE "+schemaName+"TB_BRANCHGROUP SET GROUPNAME = ?, DESCRIPTION = ?, "+
					 "		 RISKRATING = ?, REGION_TYPE = '', UPDATETIMESTAMP = SYSTIMESTAMP, "+
					 "		 UPDATEDBY = ? " +
					 " WHERE GROUPCODE = ?";
		
		try{
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, groupName);
			preparedStatement.setString(2, description);
			preparedStatement.setInt(3, i_riskRating);
			preparedStatement.setString(4, userCode);
			preparedStatement.setString(5, groupCode);
			int x = preparedStatement.executeUpdate();
			result = "Branch Group Details Updated Successfully";			
		}catch(Exception e){
			e.printStackTrace();
			result = "Something went wrong while updating";
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, null, null);	
		}
		return result;
	}
	
	public List<Map<String, String>> branchGroupingRecordDetails(String groupCode){
		List<Map<String, String>> dataList = new Vector<Map<String,String>>();
		
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String sql = "SELECT A.GROUPCODE GROUPCODE, A.BRANCHCODE BRANCHCODE, B.BRANCHNAME BRANCHNAME, "+
					 "		 A.UPDATETIMESTAMP ADDEDON, A.UPDATEDBY ADDEDBY "+ 
				     "  FROM "+schemaName+"TB_BRANCHGROUPMAPPING A "+
					 "  LEFT OUTER JOIN "+schemaName+"TB_BRANCHMASTER B ON A.BRANCHCODE = B.BRANCHCODE "+
				     " WHERE A.GROUPCODE = ?";

		try{
			connection = connectionUtil.getConnection();
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, groupCode);
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()){
				Map<String, String> dataMap = new HashMap<String, String>();
				dataMap.put("GROUPCODE", resultSet.getString("GROUPCODE"));
				dataMap.put("BRANCHCODE", resultSet.getString("BRANCHCODE"));
				dataMap.put("BRANCHNAME", resultSet.getString("BRANCHNAME"));
				dataMap.put("ADDEDON", resultSet.getString("ADDEDON"));
				dataMap.put("ADDEDBY", resultSet.getString("ADDEDBY"));
				dataList.add(dataMap);
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		
		return dataList;
	}
	
	public String deleteBranchRecord(String branchCodeToDelete, String groupCodeToDelete){
		String result = "";
		branchCodeToDelete = branchCodeToDelete.replaceAll(",", "','");
		//branchCodeToDelete = "'"+branchCodeToDelete+"'";
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		String sql = "";
		try{
			sql = " DELETE FROM "+schemaName+"TB_BRANCHGROUPMAPPING "+
				//"  WHERE BRANCHCODE IN ("+branchCodeToDelete+") "+
			      "  WHERE BRANCHCODE IN (?) "+
				  "    AND GROUPCODE = ?";
			connection = connectionUtil.getConnection();
			preparedStatement = connection.prepareStatement(sql); 
			//preparedStatement.setString(1, groupCodeToDelete);
			preparedStatement.setString(1, branchCodeToDelete);
			preparedStatement.setString(2, groupCodeToDelete);
			preparedStatement.executeUpdate();
			result = "Branch Group Record deleted successfully.";
		}catch(Exception e){
			e.printStackTrace();
			result = "Error while deleting.";
		}finally{
			connectionUtil.closeResources(connection, preparedStatement,  null, null);
		}
		return result;
	}

	public List<Map<String, String>> searchBranchForGrouping (String branchCode, String branchName){
		List<Map<String, String>> mainList = new Vector<Map<String, String>>();
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String sql = "";
    	int count = 1;
    	try{
    		sql = "  SELECT BRANCHCODE BRANCHCODE, BRANCHNAME BRANCHNAME, BRANCHAREA BRANCHAREA, "+
			      "		   BRANCHADDR1 BRANCHADDR1, BRANCHADDR2 BRANCHADDR2, BRANCHADDR3 BRANCHADDR3, "+
			      "		   BRANCHADDR4 BRANCHADDR4 "+
			      "	  FROM "+schemaName+"TB_BRANCHMASTER "+
			      "  WHERE 1 = 1 ";
    		
			if(branchCode != null && branchCode.length()>0)
				//sql = sql + "AND BRANCHCODE = '"+branchCode+"'" ;
				sql = sql + "AND BRANCHCODE = ? " ;
			
			if (branchName != null && branchName.length()>0)
				//sql = sql + "AND BRANCHNAME = '"+branchName+"'" ;
				sql = sql + "AND BRANCHNAME = ? " ;
			
			sql = sql + "AND ROWNUM <= 500";

    		connection = connectionUtil.getConnection();
    		preparedStatement = connection.prepareStatement(sql);

			if(branchCode != null && branchCode.length()>0){
				preparedStatement.setString(count, branchCode);
				count++;
			}
			
			if (branchName != null && branchName.length()>0){
				preparedStatement.setString(count, branchName);
    	    }
			
    		resultSet = preparedStatement.executeQuery();
    		while(resultSet.next()){
    			Map<String, String> dataMap = new HashMap<String, String>();
    			dataMap.put("BRANCHCODE", resultSet.getString("BRANCHCODE"));
    			dataMap.put("BRANCHNAME", resultSet.getString("BRANCHNAME"));
    			dataMap.put("BRANCHAREA", resultSet.getString("BRANCHAREA"));
    			dataMap.put("BRANCHADDR1", resultSet.getString("BRANCHADDR1"));
    			dataMap.put("BRANCHADDR2", resultSet.getString("BRANCHADDR2"));
    			dataMap.put("BRANCHADDR3", resultSet.getString("BRANCHADDR3"));
    			dataMap.put("BRANCHADDR4", resultSet.getString("BRANCHADDR4"));
    			mainList.add(dataMap);
    		}
       	}catch(Exception e ){
    		e.printStackTrace();
    	}finally{
    		connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
    	}
    	return mainList;
	}
	
	public String addBranchToGroup(String selectedBranchCodes, String userCode, String groupCode){
		selectedBranchCodes = selectedBranchCodes.replace(",", "','");
		String result = "";
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		String sql = "";
					
		try{
			sql = "INSERT INTO "+schemaName+"TB_BRANCHGROUPMAPPING("+
			      "       GROUPCODE, BRANCHCODE, UPDATEDBY, UPDATETIMESTAMP) "+
			      "SELECT ? GROUPCODE, A.BRANCHCODE, ? UPDATEDBY, SYSTIMESTAMP "+
			      "  FROM "+schemaName+"TB_BRANCHMASTER A "+
			      //" WHERE A.BRANCHCODE IN ('"+selectedBranchCodes+"') "+
			      " WHERE A.BRANCHCODE IN (?) "+
			      "   AND A.BRANCHCODE NOT IN (SELECT B.BRANCHCODE "+
			      "								FROM "+schemaName+"TB_BRANCHGROUPMAPPING B "+
			      "							   WHERE B.GROUPCODE = ?)";

			connection = connectionUtil.getConnection();
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, groupCode);
			preparedStatement.setString(2, userCode);
			//preparedStatement.setString(3, groupCode);
			preparedStatement.setString(3, selectedBranchCodes);
			preparedStatement.setString(4, groupCode);
			int x = preparedStatement.executeUpdate();
			result = x+" no of branch(es) added to Group";
		}catch(Exception e){
			result = "Error while adding branches to Group";
			e.printStackTrace();	
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, null, null);		
		}
		return result;
	}
	
}

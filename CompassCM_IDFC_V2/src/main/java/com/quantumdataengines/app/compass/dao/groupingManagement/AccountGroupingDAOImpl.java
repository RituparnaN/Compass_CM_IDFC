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
public class AccountGroupingDAOImpl implements AccountGroupingDAO {

	@Autowired
	private ConnectionUtil connectionUtil;
	
	@Value("${compass.aml.config.schemaName}")
	private String schemaName;
	
	@Override
	public Map<String, Object> searchAccountGrouping(String groupCode, String groupName, String description, String riskRating) {
		Map<String, Object> resultMap = new HashMap<String, Object>();		
		List<Map<String, String>> mainList = new Vector<Map<String,String>>();
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String sql= "";
		int count = 1;
		try{
			sql= "SELECT GROUPCODE GROUPCODE, GROUPNAME GROUPNAME, DESCRIPTION DESCRIPTION, "+
			     "		 RISKRATING RISKRATING, FUN_DATETOCHAR (UPDATETIMESTAMP) CREATEDTIME, UPDATEDBY CREATEDBY "+
			     "  FROM "+schemaName+"TB_ACCOUNTGROUP "+
			     " WHERE 1 = 1 ";
			if(groupCode != null && groupCode.length()>0)
				//sql = sql + " AND GROUPCODE = '"+groupCode+"' ";
				sql = sql + " AND GROUPCODE = ? ";
			if(groupName != null && groupName.length()>0)
				//sql = sql + " AND GROUPNAME = '"+groupName+"' ";
				sql = sql + " AND GROUPNAME = ? ";
			if(description != null && description.length()>0)
				//sql = sql + " AND DESCRIPTION = '"+description+"' ";
				sql = sql + " AND DESCRIPTION = ? ";
			if(riskRating != null && riskRating.length()>0)
				//sql = sql + " AND RISKRATING = '"+riskRating+"' ";
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
	public Map<String, Object> createAccountGrouping(String groupCode, String groupName, String description, String riskRating, String userCode) {
		int i_riskRating = Integer.parseInt(riskRating);
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		int count = 0;
		try{
			String sql = " SELECT COUNT(1) GROUPCODECOUNT "+
			             "   FROM "+schemaName+"TB_ACCOUNTGROUP "+
			             "  WHERE GROUPCODE = ?";
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, groupCode);
			resultSet = preparedStatement.executeQuery();
			if(resultSet.next()){
				count = resultSet.getInt("GROUPCODECOUNT"); 
			}
			
			if(count == 0){
				sql= "INSERT INTO "+schemaName+"TB_ACCOUNTGROUP("+
				     "       GROUPCODE, GROUPNAME, DESCRIPTION, RISKRATING, "+
					 "		 REGION_TYPE, UPDATETIMESTAMP, UPDATEDBY) "+
					 " VALUES(?,?,?,?,'',SYSTIMESTAMP,?) ";
			
				preparedStatement = connection.prepareStatement(sql);
				preparedStatement.setString(1, groupCode);
				preparedStatement.setString(2, groupName);
				preparedStatement.setString(3, description);
				preparedStatement.setInt(4, i_riskRating);
				preparedStatement.setString(5, userCode);
				preparedStatement.executeUpdate();
			}else{
				return searchAccountGrouping(groupCode, "", "", "");
			}
			
		}catch(Exception e){
			e.printStackTrace();	
		}finally{
			connectionUtil.closeResources(connection, preparedStatement,resultSet,null);		
		}
		return searchAccountGrouping(groupCode, groupName, description, riskRating);
	}
	
	public String deleteAccountGrouping(String groupCodeToDelete){
		String result = "";
		groupCodeToDelete = groupCodeToDelete.replaceAll(",", "','");
		//groupCodeToDelete = "'"+groupCodeToDelete+"'";
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		String sql = "";
		try{
			//String sql = "DELETE FROM "+schemaName+"TB_ACCOUNTGROUP WHERE GROUPCODE IN ("+groupCodeToDelete+")";
			sql = "DELETE FROM "+schemaName+"TB_ACCOUNTGROUP WHERE GROUPCODE IN (?)";
			connection = connectionUtil.getConnection();
			preparedStatement = connection.prepareStatement(sql); 
			preparedStatement.setString(1, groupCodeToDelete);
			preparedStatement.executeUpdate(sql);
			result = "Account Group deleted successfully.";
		}catch(Exception e){
			e.printStackTrace();
			result = "Error while deleting.";
		}finally{
			connectionUtil.closeResources(connection, preparedStatement,  null, null);
		}
		return result;
	}
	
	public Map<String, String> fetchAccountGroupingDetailsForUpdate(String groupCode){
		Map<String, String> accountGroupingDetailsMap = new HashMap<String, String>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareStatement("SELECT GROUPCODE GROUPCODE, GROUPNAME GROUPNAME, DESCRIPTION DESCRIPTION, "+
															"		RISKRATING RISKRATING, UPDATEDBY UPDATEDBY, FUN_DATETOCHAR(UPDATETIMESTAMP) UPDATETIME"+
															"  FROM "+schemaName+"TB_ACCOUNTGROUP "+
															" WHERE GROUPCODE = ?");
			preparedStatement.setString(1, groupCode);
			resultSet = preparedStatement.executeQuery();
			if (resultSet.next()) {
				accountGroupingDetailsMap.put("GROUPCODE", resultSet.getString("GROUPCODE"));
				accountGroupingDetailsMap.put("GROUPNAME", resultSet.getString("GROUPNAME"));
				accountGroupingDetailsMap.put("DESCRIPTION", resultSet.getString("DESCRIPTION"));
				accountGroupingDetailsMap.put("RISKRATING", resultSet.getString("RISKRATING"));
				accountGroupingDetailsMap.put("UPDATEDBY", resultSet.getString("UPDATEDBY"));
				accountGroupingDetailsMap.put("UPDATETIME", resultSet.getString("UPDATETIME"));
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement,resultSet,null);	
		}
		return accountGroupingDetailsMap;
	}
	
	public String updateAccountGroupingDetails(String groupCode, String groupName, String description, String riskRating, String userCode){
		int i_riskRating = Integer.parseInt(riskRating);
		String result ;
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
				
		String sql = "UPDATE "+schemaName+"TB_ACCOUNTGROUP SET GROUPNAME = ?, DESCRIPTION = ?, "+
					 "		 RISKRATING = ?, REGION_TYPE = '', UPDATETIMESTAMP = SYSTIMESTAMP, "+
					 "		 UPDATEDBY = ? "+
					 " WHERE GROUPCODE = ?";
		
		try{
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, groupName);
			preparedStatement.setString(2, description);
			preparedStatement.setInt(3, i_riskRating);
			preparedStatement.setString(4, userCode);
			preparedStatement.setString(5, groupCode);
			int x = preparedStatement.executeUpdate();
			result = "Account Group Details Updated Successfully";			
		}catch(Exception e){
			e.printStackTrace();
			result = "Something went wrong while updating";
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, null, null);	
		}
		return result;
	}
	public List<Map<String, String>> accountGroupingRecordDetails(String groupCode){
		List<Map<String, String>> dataList = new Vector<Map<String,String>>();
		
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String sql = "SELECT A.GROUPCODE GROUPCODE, A.ACCOUNTNO ACCOUNTNO, B.CUSTOMERID CUSTOMERID, "+
					 "       B.CUSTOMERNAME CUSTOMERNAME, A.UPDATETIMESTAMP ADDEDON, A.UPDATEDBY ADDEDBY"+ 
					 "  FROM "+schemaName+"TB_ACCOUNTGROUPMAPPING A "+
					 "  LEFT OUTER JOIN "+schemaName+"TB_ACCOUNTSMASTER B ON A.ACCOUNTNO = B.ACCOUNTNO "+
					 " WHERE A.GROUPCODE = ?";

		try{
			connection = connectionUtil.getConnection();
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, groupCode);
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()){
				Map<String, String> dataMap = new HashMap<String, String>();
				dataMap.put("GROUPCODE", resultSet.getString("GROUPCODE"));
				dataMap.put("ACCOUNTNO", resultSet.getString("ACCOUNTNO"));
				dataMap.put("CUSTOMERID", resultSet.getString("CUSTOMERID"));
				dataMap.put("CUSTOMERNAME", resultSet.getString("CUSTOMERNAME"));
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

	public String deleteAccountRecord(String accountNosToDelete, String groupCodeToDelete){
		String result = "";
		accountNosToDelete = accountNosToDelete.replaceAll(",", "','");
		//accNoToDelete = "'"+accountNosToDelete+"'";
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		String sql = "";
		try{
			sql = "DELETE FROM "+schemaName+"TB_ACCOUNTGROUPMAPPING "+
				//" WHERE ACCOUNTNO IN ("+accountNosToDelete+") "+
			      " WHERE ACCOUNTNO IN (?) "+
				  "   AND GROUPCODE = ?";
			connection = connectionUtil.getConnection();
			preparedStatement = connection.prepareStatement(sql); 
			//preparedStatement.setString(1, groupCodeToDelete);
			preparedStatement.setString(1, accountNosToDelete);
			preparedStatement.setString(2, groupCodeToDelete);
			preparedStatement.executeUpdate();
			result = "Account Group Record deleted successfully.";
		}catch(Exception e){
			e.printStackTrace();
			result = "Error while deleting.";
		}finally{
			connectionUtil.closeResources(connection, preparedStatement,  null, null);
		}
		return result;
	}

	public List<Map<String, String>> searchAccountForGrouping (String accountNo, String accountName){
		List<Map<String, String>> mainList = new Vector<Map<String, String>>();
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String sql = "s";
    	int count = 1;		
    	try{
    		sql = "  SELECT ACCOUNTNO ACCOUNTNO, CUSTOMERID CUSTOMERID, "+
		          "         REPLACE(REPLACE(REPLACE(CUSTOMERNAME ,CHR(10)),CHR(13)),CHR(39)) CUSTOMERNAME, "+
			      "		   BRANCHCODE BRANCHCODE, PRODUCTCODE PRODUCTCODE, "+
			      "         FUN_DATETOCHAR(ACCOUNTOPENEDDATE) ACCOUNTOPENEDDATE, "+
			      "		   RISKRATING RISKRATING "+
			      "	  FROM "+schemaName+"TB_ACCOUNTSMASTER "+
			      "  WHERE 1 = 1 ";

			if(accountNo != null && accountNo.length()>0)
				//sql = sql + " AND ACCOUNTNO = '"+accountNo+"' " ;
				sql = sql + " AND ACCOUNTNO = ? " ;
			
			if (accountName != null && accountName.length()>0)
				//sql = sql + " AND CUSTOMERNAME = '"+accountName+"' " ;
				sql = sql + " AND CUSTOMERNAME = ? " ;
			
			sql = sql + " AND ROWNUM <= 500 ";

    		connection = connectionUtil.getConnection();
    		preparedStatement = connection.prepareStatement(sql);
    		if(accountNo != null && accountNo.length()>0){
    			preparedStatement.setString(count, accountNo);
    			count++;
    		}
			if (accountName != null && accountName.length()>0){
    			preparedStatement.setString(count, accountName);
    		}
			
    		resultSet = preparedStatement.executeQuery();
    		while(resultSet.next()){
    			Map<String, String> dataMap = new HashMap<String, String>();
    			dataMap.put("ACCOUNTNO", resultSet.getString("ACCOUNTNO"));
    			dataMap.put("CUSTOMERID", resultSet.getString("CUSTOMERID"));
    			dataMap.put("CUSTOMERNAME", resultSet.getString("CUSTOMERNAME"));
    			dataMap.put("BRANCHCODE", resultSet.getString("BRANCHCODE"));
    			dataMap.put("PRODUCTCODE", resultSet.getString("PRODUCTCODE"));
    			dataMap.put("ACCOUNTOPENEDDATE", resultSet.getString("ACCOUNTOPENEDDATE"));
    			dataMap.put("RISKRATING", resultSet.getString("RISKRATING"));
    			mainList.add(dataMap);
    		}
       	}catch(Exception e ){
    		e.printStackTrace();
    	}finally{
    		connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
    	}
    	return mainList;
	}
	
	public String addAccountToGroup(String selectedAccountNos, String userCode, String groupCode){
		selectedAccountNos = selectedAccountNos.replace(",", "','");
		String result = "";
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		String sql ="";

		try{
			sql ="INSERT INTO "+schemaName+"TB_ACCOUNTGROUPMAPPING("+
			     "       GROUPCODE, ACCOUNTNO, UPDATEDBY, UPDATETIMESTAMP) "+
			     "SELECT ? GROUPCODE, A.ACCOUNTNO, ? UPDATEDBY, SYSTIMESTAMP "+
			     "  FROM "+schemaName+"TB_ACCOUNTSMASTER A "+
			   //" WHERE A.ACCOUNTNO IN ('"+selectedAccountNos+"') "+
			     " WHERE A.ACCOUNTNO IN (?) "+
			     "   AND A.ACCOUNTNO NOT IN (SELECT B.ACCOUNTNO "+
			     "								FROM "+schemaName+"TB_ACCOUNTGROUPMAPPING B "+
			     "							   WHERE B.GROUPCODE = ?)";

			connection = connectionUtil.getConnection();
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, groupCode);
			preparedStatement.setString(2, userCode);
			//preparedStatement.setString(3, groupCode);
			preparedStatement.setString(3, selectedAccountNos);
			preparedStatement.setString(4, groupCode);
			int x = preparedStatement.executeUpdate();
			result = x+" no of account(s) added to Group";
		}catch(Exception e){
			result = "Error while adding account(s) to Group";
			e.printStackTrace();	
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, null, null);		
		}
		return result;
	}
	

	
}

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
public class WatchlistDAOImpl implements WatchlistDAO {

	@Autowired
	private ConnectionUtil connectionUtil;
	
	@Value("${compass.aml.config.schemaName}")
	private String schemaName;
	
	@Override
	public Map<String, Object> searchManageWatchlist(String listCode, String listName, String description, String riskRating) {
		Map<String, Object> resultMap = new HashMap<String, Object>();		
		List<Map<String, String>> mainList = new Vector<Map<String,String>>();
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String sql= "SELECT LISTCODE LISTCODE, LISTNAME LISTNAME, DESCRIPTION DESCRIPTION, "+
					"		RISKRATING RISKRATING, FUN_DATETOCHAR (UPDATETIMESTAMP) CREATEDTIME, UPDATEDBY CREATEDBY "+
					"  FROM "+schemaName+"TB_WATCHLIST "+
					" WHERE 1 = 1 ";
		/*
		if(listCode != null && listCode.length()>0)
			sql = sql + "AND LISTCODE = '"+listCode+"'";
		if(listName != null && listName.length()>0)
			sql = sql + "AND LISTNAME = '"+listName+"'";
		if(description != null && description.length()>0)
			sql = sql + "AND DESCRIPTION = '"+description+"'";
		if(riskRating != null && riskRating.length()>0)
			sql = sql + "AND RISKRATING = '"+riskRating+"'";
		*/
		
		if(listCode != null && listCode.length()>0)
			sql = sql + " AND LISTCODE = ? ";
		if(listName != null && listName.length()>0)
			sql = sql + " AND LISTNAME = ? ";
		if(description != null && description.length()>0)
			sql = sql + " AND DESCRIPTION = ? ";
		if(riskRating != null && riskRating.length()>0)
			sql = sql + " AND RISKRATING = ? ";
		
		try{
			int count = 1;
			connection = connectionUtil.getConnection();
			preparedStatement = connection.prepareStatement(sql);
			if(listCode != null && listCode.length()>0){
				preparedStatement.setString(count, listCode);
				count++;
			}
			if(listName != null && listName.length()>0){
				preparedStatement.setString(count, listName);
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
	
	public String deleteWatchlist(String listCodeToDelete){
		String result = "";
		listCodeToDelete = listCodeToDelete.replaceAll(",", "','");
		//listCodeToDelete = "'"+listCodeToDelete+"'";
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		//String sql = "DELETE FROM "+schemaName+"TB_WATCHLIST WHERE LISTCODE IN ("+listCodeToDelete+")";
		String sql = "";
		try{
			sql = "DELETE FROM "+schemaName+"TB_WATCHLIST WHERE LISTCODE IN (?)";
			connection = connectionUtil.getConnection();
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, listCodeToDelete);
			preparedStatement.executeUpdate();
			result = "WatchLists are deleted";
		}catch(Exception e){
			result = "Error while deleting WatchLists";
			e.printStackTrace();	
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, null, null);		
		}
		return result;
	}
	
	@SuppressWarnings("resource")
	@Override
	public Map<String, Object> createWatchlist(String listCode, String listName, String description, String riskRating, String userCode) {
		int i_riskRating = Integer.parseInt(riskRating);
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		int count = 0;		
		try{
			String sql = "SELECT COUNT(1) LISTCODECOUNT FROM "+schemaName+"TB_WATCHLIST WHERE LISTCODE = ?";
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, listCode);
			resultSet = preparedStatement.executeQuery();
			if(resultSet.next()){
				count = resultSet.getInt("LISTCODECOUNT"); 
			}
			if(count == 0){
				sql= "INSERT INTO "+schemaName+"TB_WATCHLIST (LISTCODE, LISTNAME, DESCRIPTION, RISKRATING, REGION_TYPE, "+
						"		UPDATETIMESTAMP, UPDATEDBY) "+
						"VALUES (?,?,?,?,'',SYSTIMESTAMP,?) ";
			
				preparedStatement = connection.prepareStatement(sql);
				preparedStatement.setString(1, listCode);
				preparedStatement.setString(2, listName);
				preparedStatement.setString(3, description);
				preparedStatement.setInt(4, i_riskRating);
				preparedStatement.setString(5, userCode);
				preparedStatement.executeUpdate();
			}else{
				return searchManageWatchlist(listCode, "", "", "");
			}
			
		}catch(Exception e){
			e.printStackTrace();	
		}finally{
			connectionUtil.closeResources(connection, preparedStatement,resultSet,null);		
		}
		return searchManageWatchlist(listCode, listName, description, riskRating);
	}
	
	public String updateWatchlist(String listCode, String listName, String description, String riskRating, String userCode){
		int i_riskRating = Integer.parseInt(riskRating);
		String result ;
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		
		String sql = "UPDATE "+schemaName+"TB_WATCHLIST SET LISTNAME = ?, DESCRIPTION = ?, "+
					 "		 RISKRATING = ?, REGION_TYPE = '', UPDATETIMESTAMP = SYSTIMESTAMP, "+
					 "		 UPDATEDBY = ? WHERE LISTCODE = ?";
		
		try{
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, listName);
			preparedStatement.setString(2, description);
			preparedStatement.setInt(3, i_riskRating);
			preparedStatement.setString(4, userCode);
			preparedStatement.setString(5, listCode);
			preparedStatement.executeUpdate();
			result = "Watchlist Updated Successfully";			
		}catch(Exception e){
			e.printStackTrace();
			result = "Something went wrong while updating";
		}finally{
			connectionUtil.closeResources(connection, preparedStatement,resultSet,null);	
		}
		return result;
	}
	
	public Map<String, String> fetchWatchlistForUpdate(String listCode){
		Map<String, String> watchListDetailsMap = new HashMap<String, String>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareStatement("SELECT LISTCODE LISTCODE, LISTNAME LISTNAME, DESCRIPTION DESCRIPTION, "+
															"		RISKRATING RISKRATING, UPDATEDBY UPDATEDBY, FUN_DATETOCHAR(UPDATETIMESTAMP) UPDATETIME"+
															"  FROM "+schemaName+"TB_WATCHLIST "+
															" WHERE LISTCODE = ?");
			preparedStatement.setString(1, listCode);
			resultSet = preparedStatement.executeQuery();
			if (resultSet.next()) {
				watchListDetailsMap.put("LISTCODE", resultSet.getString("LISTCODE"));
				watchListDetailsMap.put("LISTNAME", resultSet.getString("LISTNAME"));
				watchListDetailsMap.put("DESCRIPTION", resultSet.getString("DESCRIPTION"));
				watchListDetailsMap.put("RISKRATING", resultSet.getString("RISKRATING"));
				watchListDetailsMap.put("UPDATEDBY", resultSet.getString("UPDATEDBY"));
				watchListDetailsMap.put("UPDATETIME", resultSet.getString("UPDATETIME"));
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement,resultSet,null);	
		}
		return watchListDetailsMap;
	}
	
	public List<Map<String, String>> fetchWatchlistDetails(String listCode){
		List<Map<String,String>> watchListDetailsMap = new Vector<Map<String,String>>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareStatement("SELECT LISTCODE LISTCODE, UNQID UNQID, CUSTOMERID CUSTOMERID, "+
															"		CUSTOMERNAME CUSTOMERNAME, ISNONCUSTOMER ISNONCUSTOMER, "+
															"		UPDATEDBY UPDATEDBY, FUN_DATETOCHAR(UPDATETIMESTAMP) UPDATETIME"+
															"  FROM "+schemaName+"TB_WATCHLISTDETAILS "+
															" WHERE LISTCODE = ?");
				preparedStatement.setString(1, listCode);
				resultSet = preparedStatement.executeQuery();
				while (resultSet.next()) {
				Map<String, String> dataMap = new HashMap<String, String>();
				dataMap.put("LISTCODE", resultSet.getString("LISTCODE"));
				dataMap.put("UNQID", resultSet.getString("UNQID"));
				dataMap.put("CUSTOMERID", resultSet.getString("CUSTOMERID"));
				dataMap.put("CUSTOMERNAME", resultSet.getString("CUSTOMERNAME"));
				dataMap.put("ISNONCUSTOMER", resultSet.getString("ISNONCUSTOMER"));
				dataMap.put("UPDATEDBY", resultSet.getString("UPDATEDBY"));
				dataMap.put("UPDATETIME", resultSet.getString("UPDATETIME"));
				watchListDetailsMap.add(dataMap);
				}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return watchListDetailsMap;
	}
	
	public String addNonCustomerToWatchlist(String listCode, String unqid, String nonCustomerName, String userCode){
		String result = "";
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareStatement("INSERT INTO "+schemaName+"TB_WATCHLISTDETAILS(LISTCODE, UNQID, CUSTOMERNAME, ISNONCUSTOMER, UPDATEDBY, UPDATETIMESTAMP) "+
															"VALUES (?,?,?,'Y',?,SYSTIMESTAMP)");
			preparedStatement.setString(1, listCode);
			preparedStatement.setString(2, unqid);
			preparedStatement.setString(3, nonCustomerName);
			preparedStatement.setString(4, userCode);
			preparedStatement.executeUpdate();
			result = "Non-Customer has been successfully added";
		}catch(Exception e){
			result = "Error while adding Non-Customer";
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return result;
	}
	
	public String deleteWatchlistRecord(String unqIdToDelete){
		String result = "";
		unqIdToDelete = unqIdToDelete.replaceAll(",", "','");
		//unqIdToDelete = "'"+unqIdToDelete+"'";
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		// String sql = "DELETE FROM "+schemaName+"TB_WATCHLISTDETAILS WHERE UNQID IN ("+unqIdToDelete+")";
		String sql = "";
		try{
			sql = "DELETE FROM "+schemaName+"TB_WATCHLISTDETAILS WHERE UNQID IN (?)";
			connection = connectionUtil.getConnection();
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, unqIdToDelete);
			preparedStatement.executeUpdate();
			result = "WatchLists are deleted";
		}catch(Exception e){
			result = "Error while deleting WatchLists";
			e.printStackTrace();	
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, null, null);		
		}
		return result;
	}
	
	public List<Map<String, String>> searchCustomerToAdd(String customerId, String customerName, String riskRating, String branchCode){
		List<Map<String, String>> mainList = new Vector<Map<String, String>>();
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String sql = "SELECT CUSTOMERID, CUSTOMERNAME, "+
					 "		 CASE RISKRATING WHEN '1' THEN 'LOW' "+
					 "		 WHEN '2' THEN 'MEDIUM' "+
					 "		 ELSE 'HIGH' END RISKRATING, BRANCHCODE, "+
					 "       CUSTOMERTYPE, MINOR, FUN_DATETOCHAR(CREATEDDATETIME) CREATEDDATETIME "+
					 "  FROM "+schemaName+"TB_CUSTOMERMASTER "+
					 " WHERE 1 = 1 ";
		
		if(customerId != null && customerId.length() > 0)
			//sql = sql + " AND CUSTOMERID = '"+customerId+"'";
			sql = sql + " AND CUSTOMERID = ? ";
		
		if(customerName != null && customerName.length() > 0)
			//sql = sql + " AND CUSTOMERNAME = '"+customerName+"'";
			sql = sql + " AND CUSTOMERNAME = ? ";
		
		if(riskRating != null && riskRating.length() > 0)
			//sql = sql + " AND RISKRATING = '"+riskRating+"'";
			sql = sql + " AND RISKRATING = ?";
		
		if(branchCode != null && branchCode.length() > 0)
			//sql = sql + " AND BRANCHCODE = '"+branchCode+"'";
			sql = sql + " AND BRANCHCODE = ? ";
		
		sql = sql + " AND ROWNUM <= 500";
		
		
		try{
			int count = 1;
			connection = connectionUtil.getConnection();
			preparedStatement = connection.prepareStatement(sql);
			if(customerId != null && customerId.length() > 0){
				preparedStatement.setString(count, customerId);
			    count++;
		    }
			
			if(customerName != null && customerName.length() > 0){
				preparedStatement.setString(count, customerName);
			    count++;
		    }
			
			if(riskRating != null && riskRating.length() > 0){
				preparedStatement.setString(count, riskRating);
			    count++;
		    }
			
			if(branchCode != null && branchCode.length() > 0){
				preparedStatement.setString(count, branchCode);
		    }
			
			resultSet = preparedStatement.executeQuery();
			while (resultSet.next()) {
				Map<String, String> dataMap = new HashMap<String, String>();
				dataMap.put("CUSTOMERID", resultSet.getString("CUSTOMERID"));
				dataMap.put("CUSTOMERNAME", resultSet.getString("CUSTOMERNAME"));
				dataMap.put("RISKRATING", resultSet.getString("RISKRATING"));
				dataMap.put("BRANCHCODE", resultSet.getString("BRANCHCODE"));
				dataMap.put("CUSTOMERTYPE", resultSet.getString("CUSTOMERTYPE"));
				dataMap.put("MINOR", resultSet.getString("MINOR"));
				dataMap.put("CREATEDDATETIME", resultSet.getString("CREATEDDATETIME"));
				
				mainList.add(dataMap);
			}
		}catch(Exception e){
			e.printStackTrace();	
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, null, null);		
		}
		return mainList;
	}
	
	public String addCustomerIdsToWatchlist(String listCode, String selectedCustomerIds, String userCode){
		selectedCustomerIds = selectedCustomerIds.replace(",", "','");
		String result = "";
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		String sql = "";
		try{
			sql = " INSERT INTO "+schemaName+"TB_WATCHLISTDETAILS (LISTCODE, UNQID, CUSTOMERID, CUSTOMERNAME, ISNONCUSTOMER, UPDATEDBY, UPDATETIMESTAMP) "+
			      " SELECT ? LISTCODE, LOWER(DBMS_RANDOM.STRING('X','25')) UNQID, A.CUSTOMERID CUSTOMERID, A.CUSTOMERNAME CUSTOMERNAME,"+
			      " 		 'N' ISNONCUSTOMER, ? UPDATEDBY, SYSTIMESTAMP UPDATETIMESTAMP"+
			      "  FROM "+schemaName+"TB_CUSTOMERMASTER A "+
	 	          " WHERE A.CUSTOMERID IN ('"+selectedCustomerIds+"')";
			     // " WHERE A.CUSTOMERID IN (?)";

			connection = connectionUtil.getConnection();
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, listCode);
			preparedStatement.setString(2, userCode);
			//preparedStatement.setString(3, selectedCustomerIds);
			
			int x = preparedStatement.executeUpdate();
			result = x+" no of customer(s) added in WatchList";
		}catch(Exception e){
			result = "Error while adding customers to WatchList";
			e.printStackTrace();	
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, null, null);		
		}
		return result;
	}
	
}

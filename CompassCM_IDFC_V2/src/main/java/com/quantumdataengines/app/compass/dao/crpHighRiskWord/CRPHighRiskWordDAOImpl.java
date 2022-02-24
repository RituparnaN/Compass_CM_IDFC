package com.quantumdataengines.app.compass.dao.crpHighRiskWord;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.util.ArrayList;
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
public class CRPHighRiskWordDAOImpl implements CRPHighRiskWordDAO{

	@Autowired
	private ConnectionUtil connectionUtil;
	
	@Value("${compass.aml.config.schemaName}")
	private String schemaName;
	
	@Override
	public int getNewSeqNo() {
		int result = 0;
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		int seqNo = 0;
		try{
			connection = connectionUtil.getConnection();			
			preparedStatement = connection.prepareStatement("SELECT MAX(SEQNO) SEQNO FROM "+schemaName+"TB_CRP_HIGHRISKWORD");
			resultSet = preparedStatement.executeQuery();
			if(resultSet.next()){
				seqNo = resultSet.getInt("SEQNO");
				seqNo = seqNo+1;
			}
			result = seqNo;
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, null, null);
		}
		return result;
	}
	
	public String saveOrUpdateWordRecord(String fullData, String actionToTake, String currentUser, String currentRole, String ipAddress){
		List<List<String>> mainList = new Vector<List<String>>();
		
		String[] arrStr = CommonUtil.splitString(fullData, ";");
		for(String strData : arrStr){
			String[] arrData1 = CommonUtil.splitString(strData, "--");
			if(arrData1.length == 6){
				List<String> dataList = new Vector<String>();
				for(String strData1 : arrData1)
					dataList.add(strData1);
				mainList.add(dataList);
				//System.out.println("mainList="+mainList);
			}
		}
		String result = "";
		String sql = "";
		String seqNo = "";
		Boolean logNeeded = false;
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		
		try{
			if(actionToTake.equals("Save")){
				sql =   " INSERT INTO "+schemaName+"TB_CRP_HIGHRISKWORD ( "+
						"		  SEQNO, WORD, RISKVALUE, STATUS, ISENABLED, "+
						"		  UPDATEDBY, UPDATETIMESTAMP, UPDATEDBYUSERROLE, IPADDRESS, MAKERCODE, "+
						"		  MAKERTIMESTAMP, MAKERCOMMENTS, CHECKERCODE, CHECKERTIMESTAMP, CHECKERCOMMENTS) "+
						" VALUES (?, ?, ?, ?, ?, "+
						"         ?, SYSTIMESTAMP, ?, ?, ?, "+
						"		  SYSTIMESTAMP, ?, ?, to_timestamp(?,'YYYY-MM-DD HH24.MI.SSXFF'), ?) ";
				preparedStatement = connection.prepareStatement(sql);
				
				for(List<String> list : mainList){
					seqNo = list.get(0);
					preparedStatement.setString(1, list.get(0));
					preparedStatement.setString(2, list.get(1));
					preparedStatement.setString(3, list.get(2));
					preparedStatement.setString(4, list.get(4));
					preparedStatement.setString(5, list.get(3));
					preparedStatement.setString(6, currentUser);
					preparedStatement.setString(7, currentRole);
					preparedStatement.setString(8, ipAddress);
					preparedStatement.setString(9, currentUser);
					preparedStatement.setString(10, list.get(5));
					preparedStatement.setString(11, "");
					preparedStatement.setString(12, "");
					preparedStatement.setString(13, "");
					preparedStatement.addBatch();
				}
				preparedStatement.executeBatch();
				logNeeded = true;
				result = "Record saved successfully.";
			}
			else{
				sql =  " UPDATE "+schemaName+"TB_CRP_HIGHRISKWORD "+
					   "    SET  WORD = ?, RISKVALUE = ?, STATUS = ?, ISENABLED = ?, "+
					   "		 UPDATEDBY = ?, UPDATETIMESTAMP = SYSTIMESTAMP, UPDATEDBYUSERROLE = ?, IPADDRESS = ?, MAKERCODE = ?, "+
					   "		 MAKERTIMESTAMP = SYSTIMESTAMP, MAKERCOMMENTS = ?, CHECKERCODE = ?, CHECKERTIMESTAMP = ?, CHECKERCOMMENTS = ? "+
			           "  WHERE SEQNO = ? ";
				preparedStatement = connection.prepareStatement(sql);
				
				for(List<String> list : mainList){
					seqNo = list.get(0);
					preparedStatement.setString(1, list.get(1));
					preparedStatement.setString(2, list.get(2));
					preparedStatement.setString(3, list.get(4));
					preparedStatement.setString(4, list.get(3));
					preparedStatement.setString(5, currentUser);
					preparedStatement.setString(6, currentRole);
					preparedStatement.setString(7, ipAddress);
					preparedStatement.setString(8, currentUser);
					preparedStatement.setString(9, list.get(5));
					preparedStatement.setString(10, "");
					preparedStatement.setString(11, "");
					preparedStatement.setString(12, "");
					preparedStatement.setString(13, list.get(0));
					preparedStatement.addBatch();
				}
				preparedStatement.executeBatch();
				logNeeded = true;
				result = "Record updated successfully.";
			}
			if(logNeeded){
				getNewDataForLog(seqNo);
			}
		}catch(Exception e){
			e.printStackTrace();
			if(actionToTake.equals("Save")){
				result = "Error while saving.";
			}else{
				result = "Entry while updating.";
			}
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, null, null);
		}
		return result;
	}
	
	public List<Map<String, String>> getSeqNoDetails(String seqNo){
		List<Map<String, String>> wholeList = new Vector<Map<String,String>>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
		String sql= "";
		
		sql = 	" SELECT SEQNO, WORD, RISKVALUE, "+
				" 		 DECODE(STATUS, 'P', 'Pending', 'A', 'Approved', 'R', 'Rejected') STATUS, "+
				" 		 DECODE(ISENABLED, 'Y', 'Yes', 'N', 'No') ISENABLED, UPDATEDBY, UPDATETIMESTAMP, UPDATEDBYUSERROLE, "+
				"		 IPADDRESS, MAKERCODE, MAKERTIMESTAMP, MAKERCOMMENTS, CHECKERCODE, CHECKERTIMESTAMP, CHECKERCOMMENTS "+
				"   FROM "+schemaName+"TB_CRP_HIGHRISKWORD WHERE SEQNO = ? ";
		
				preparedStatement = connection.prepareStatement(sql);
				preparedStatement.setString(1, seqNo);
				resultSet = preparedStatement.executeQuery();
				
			while(resultSet.next()){
				Map<String, String> dataMap = new LinkedHashMap<String, String>();
				dataMap.put("SEQNO", resultSet.getString("SEQNO"));
				dataMap.put("WORD", resultSet.getString("WORD"));
				dataMap.put("RISKVALUE", resultSet.getString("RISKVALUE"));
				dataMap.put("STATUS", resultSet.getString("STATUS"));
				dataMap.put("ISENABLED", resultSet.getString("ISENABLED"));
				dataMap.put("UPDATEDBY", resultSet.getString("UPDATEDBY"));
				dataMap.put("UPDATETIMESTAMP", resultSet.getString("UPDATETIMESTAMP"));
				dataMap.put("UPDATEDBYUSERROLE", resultSet.getString("UPDATEDBYUSERROLE"));
				dataMap.put("IPADDRESS", resultSet.getString("IPADDRESS"));
				dataMap.put("MAKERCODE", resultSet.getString("MAKERCODE"));
				dataMap.put("MAKERTIMESTAMP", resultSet.getString("MAKERTIMESTAMP"));
				dataMap.put("MAKERCOMMENTS", resultSet.getString("MAKERCOMMENTS"));
				dataMap.put("CHECKERCODE", resultSet.getString("CHECKERCODE"));
				dataMap.put("CHECKERTIMESTAMP", resultSet.getString("CHECKERTIMESTAMP"));
				dataMap.put("CHECKERCOMMENTS", resultSet.getString("CHECKERCOMMENTS"));
				
				wholeList.add(dataMap);
			}
		}catch(Exception e){
			e.printStackTrace();	
		}finally{
			connectionUtil.closeResources(connection, preparedStatement,resultSet,null);		
		}
		//System.out.println(wholeList);
		return wholeList;
	}
	
	@Override
	public String approveOrReject(String action, String seqNo, String checkerComments,
			String currentUser, String currentRole, String ipAddress) {
		String result = "";
		String sql = "";
		String status = "";
		Boolean logNeeded = false;
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		
		List<Map<String, String>> list = getSeqNoDetails(seqNo);
		//System.out.println("list = "+list);
		
		try{
			if(action.equals("Approve")){
				sql =  " UPDATE "+schemaName+"TB_CRP_HIGHRISKWORD "+
					   "    SET  WORD = ?, RISKVALUE = ?, STATUS = ?, ISENABLED = ?, "+
					   "		 UPDATEDBY = ?, UPDATETIMESTAMP = SYSTIMESTAMP, UPDATEDBYUSERROLE = ?, IPADDRESS = ?, "+
					   "		 CHECKERCODE = ?, CHECKERTIMESTAMP = SYSTIMESTAMP, CHECKERCOMMENTS = ? "+
			           "  WHERE SEQNO = ? ";
				preparedStatement = connection.prepareStatement(sql);
				
				for(Map<String, String> Data : list){
					status = "A";
					char isEnabledGot = Data.get("ISENABLED").charAt(0);
					String isEnabled = Character.toString(isEnabledGot);
					
					preparedStatement.setString(1, Data.get("WORD"));
					preparedStatement.setString(2, Data.get("RISKVALUE"));
					preparedStatement.setString(3, status);
					preparedStatement.setString(4, isEnabled);
					preparedStatement.setString(5, currentUser);
					preparedStatement.setString(6, currentRole);
					preparedStatement.setString(7, ipAddress);
					preparedStatement.setString(8, currentUser);
					preparedStatement.setString(9, checkerComments);
					preparedStatement.setString(10, seqNo);
					preparedStatement.addBatch();
				}
				preparedStatement.executeBatch();
				logNeeded = true;
				result = "Record approved successfully.";
			}
			else if(action.equals("Reject")){
				sql =  " UPDATE "+schemaName+"TB_CRP_HIGHRISKWORD "+
					   "    SET  STATUS = ?, UPDATEDBY = ?, UPDATETIMESTAMP = SYSTIMESTAMP, UPDATEDBYUSERROLE = ?, IPADDRESS = ?, "+
					   "		 CHECKERCODE = ?, CHECKERTIMESTAMP = SYSTIMESTAMP, CHECKERCOMMENTS = ? "+
			           "  WHERE SEQNO = ? ";
				preparedStatement = connection.prepareStatement(sql);
				for(Map<String, String> Data : list){
					status = "R";
					preparedStatement.executeBatch();
					preparedStatement.setString(1, status);
					preparedStatement.setString(2, currentUser);
					preparedStatement.setString(3, currentRole);
					preparedStatement.setString(4, ipAddress);
					preparedStatement.setString(5, currentUser);
					preparedStatement.setString(6, checkerComments);
					preparedStatement.setString(7, seqNo);
					preparedStatement.addBatch();
				}
				preparedStatement.executeBatch();
				logNeeded = true;
				result = "Record rejected successfully.";
			}
			if(logNeeded){
				getNewDataForLog(seqNo);
			}
		}catch(Exception e){
			e.printStackTrace();
			if(action.equals("Approve")){
				result = "Error while approving.";
			}else if(action.equals("Reject")){
				result = "Entry while rejecting.";
			}
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, null, null);
		}
		return result;
	}
	
	public Boolean getNewDataForLog(String seqNo){
		Map<String,String> row = new LinkedHashMap <String,String>();
		String sql = "";
		sql = " SELECT SEQNO, WORD, RISKVALUE, STATUS, ISENABLED, UPDATEDBY, "+
			  "		   UPDATETIMESTAMP, UPDATEDBYUSERROLE, IPADDRESS, MAKERCODE, "+
			  "		   MAKERTIMESTAMP, MAKERCOMMENTS, CHECKERCODE, CHECKERTIMESTAMP, CHECKERCOMMENTS "+
			  "   FROM "+schemaName+"TB_CRP_HIGHRISKWORD "+
			  "  WHERE UPDATETIMESTAMP = ( "+
			  "		   SELECT MAX(UPDATETIMESTAMP) "+
			  "          FROM "+schemaName+"TB_CRP_HIGHRISKWORD) "+
			  "    AND SEQNO = ? ";
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			connection = connectionUtil.getConnection();
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, seqNo);
			resultSet = preparedStatement.executeQuery();
			ResultSetMetaData resultSetMetaData = resultSet.getMetaData();
			while(resultSet.next()){
				for(int colIndex = 1; colIndex <= resultSetMetaData.getColumnCount(); colIndex++){
					String columnName = resultSetMetaData.getColumnName(colIndex);
					row.put(columnName, resultSet.getString(columnName));
				}
			}
			//System.out.println("Last Updated row first = "+row);
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement,resultSet,null);		
		}
		return insertDataInLog(row);
	}
	
	public  Boolean insertDataInLog (Map<String,String> Data){
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		PreparedStatement preparedStatement1 = null;
		Boolean isSuccess = true;
		ResultSet resultSet = null;
		ResultSet resultSet1 = null;
		String sql = " INSERT INTO "+schemaName+"TB_CRP_HIGHRISKWORD_LOG ( "+
					 "		  LOG_SEQNO, SEQNO, WORD, RISKVALUE, STATUS, ISENABLED, UPDATEDBY, "+
					 "		  UPDATETIMESTAMP, UPDATEDBYUSERROLE, IPADDRESS, MAKERCODE, MAKERTIMESTAMP, MAKERCOMMENTS, "+
					 "		  CHECKERCODE, CHECKERTIMESTAMP, CHECKERCOMMENTS) "+
					 " VALUES (?, ?, ?, ?, ?, ?, ?,"+
					 "        to_timestamp(?,'YYYY-MM-DD HH24.MI.SSXFF'), ?, ?, ?, to_timestamp(?,'YYYY-MM-DD HH24.MI.SSXFF'), ?, "+
					 "		  ?, to_timestamp(?,'YYYY-MM-DD HH24.MI.SSXFF'), ?) ";
		
		String log_seqNo = "";
		char statusGot = Data.get("STATUS").charAt(0);
		String status = Character.toString(statusGot);
		char isEnabledGot = Data.get("ISENABLED").charAt(0);
		String isEnabled = Character.toString(isEnabledGot);
		
		try{
			connection = connectionUtil.getConnection();			
			preparedStatement = connection.prepareStatement("SELECT "+schemaName+"SEQ_CRPHIGHRISKWORD_LOG.NEXTVAL AS LOG_SEQNO FROM DUAL");
			resultSet = preparedStatement.executeQuery();
			if(resultSet.next()){
				log_seqNo = resultSet.getString("LOG_SEQNO");
			}
			preparedStatement1 = connection.prepareStatement(sql);
			preparedStatement1.setString(1, log_seqNo);
			preparedStatement1.setString(2, Data.get("SEQNO"));
			preparedStatement1.setString(3, Data.get("WORD"));
			preparedStatement1.setString(4, Data.get("RISKVALUE"));
			preparedStatement1.setString(5, status);
			preparedStatement1.setString(6, isEnabled);
			preparedStatement1.setString(7, Data.get("UPDATEDBY"));
			preparedStatement1.setString(8, Data.get("UPDATETIMESTAMP"));
			preparedStatement1.setString(9, Data.get("UPDATEDBYUSERROLE"));
			preparedStatement1.setString(10, Data.get("IPADDRESS"));
			preparedStatement1.setString(11, Data.get("MAKERCODE"));
			preparedStatement1.setString(12, Data.get("MAKERTIMESTAMP"));
			preparedStatement1.setString(13, Data.get("MAKERCOMMENTS"));
			preparedStatement1.setString(14, Data.get("CHECKERCODE"));
			preparedStatement1.setString(15, Data.get("CHECKERTIMESTAMP"));
			preparedStatement1.setString(16, Data.get("CHECKERCOMMENTS"));
			
			resultSet1 = preparedStatement1.executeQuery();
			
		}catch(Exception e){
			isSuccess = true;
			e.printStackTrace();	
		}finally{
			connectionUtil.closeResources(connection, preparedStatement,resultSet,null);		
			connectionUtil.closeResources(connection, preparedStatement1,resultSet1,null);
		}
		return isSuccess;
	}

}

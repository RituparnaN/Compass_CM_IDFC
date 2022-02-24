package com.quantumdataengines.app.compass.dao.userNotes;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Repository;

import com.quantumdataengines.app.compass.dao.Query;
import com.quantumdataengines.app.compass.util.CommonUtil;
import com.quantumdataengines.app.compass.util.ConnectionUtil;

@Repository
public class UserNotesDAOImpl implements UserNotesDAO{
	
	@Autowired
	private ConnectionUtil connectionUtil;

	@Value("${compass.aml.config.schemaName}")
	private String schemaName;
	
	@Override
	public List<Map<String, String>> getNotesData(String userCode, String currentRole, String ipAddress) {
		List<Map<String, String>> dataList = new ArrayList<Map<String, String>>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		
		try {
			//String sql = " SELECT SEQNO, NOTES, TO_CHAR(UPDATEDTIMESTAMP,'DD/MM/YYYY HH24.MI.SS') UPDATEDTIMESTAMP "+
			String sql = " SELECT SEQNO, NOTES, REMINDERTIME, TO_CHAR(UPDATEDTIMESTAMP,'DD/MM/YYYY HH24:MI') UPDATEDTIMESTAMP "+
						 " FROM "+schemaName+"TB_USERNOTES WHERE UPDATEDBY = '"+userCode+"' ORDER BY SEQNO DESC ";
			preparedStatement = connection.prepareStatement(sql);
			resultSet = preparedStatement.executeQuery();
			
			while(resultSet.next()) {
				Map<String, String> dataMap = new LinkedHashMap<String, String>();
				dataMap.put("SEQNO",resultSet.getString("SEQNO"));
				dataMap.put("NOTES",resultSet.getString("NOTES"));
				dataMap.put("REMINDERTIME",resultSet.getString("REMINDERTIME"));
				//dataMap.put("UPDATEDBY",resultSet.getString("UPDATEDBY"));
				dataMap.put("UPDATEDTIMESTAMP",resultSet.getString("UPDATEDTIMESTAMP"));
				//dataMap.put("IPADDRESS",resultSet.getString("IPADDRESS"));
				dataList.add(dataMap);
			}
			//System.out.println("dataList = "+dataList);
		}catch(Exception e){
			e.printStackTrace();
		}finally {
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return dataList;
	}

	@Override
	public String saveUserNotes(String newNoteContent, String newNoteReminderDatetime, String userCode, String currentRole, String ipAddress) {
		String response = "" ;
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		
		try{
			String sql = "	INSERT INTO "+schemaName+"TB_USERNOTES "+
						 "	(SEQNO , NOTES , REMINDERTIME, UPDATEDBY , UPDATEDTIMESTAMP, IPADDRESS)  "+
						 "	VALUES (?, ?, ?, ?, SYSTIMESTAMP, ?) ";
			
			int seqNo = 0;
			preparedStatement = connection.prepareStatement("SELECT "+schemaName+"SEQ_USERNOTES.NEXTVAL AS SEQNO FROM DUAL");
			resultSet = preparedStatement.executeQuery();
			if(resultSet.next()){
				seqNo = resultSet.getInt("SEQNO");
			}
			
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setInt(1, seqNo);
			preparedStatement.setString(2, newNoteContent);
			preparedStatement.setString(3, newNoteReminderDatetime);
			preparedStatement.setString(4, userCode);
			preparedStatement.setString(5, ipAddress);
			
			preparedStatement.executeUpdate();
			response = "Note successfully saved.";
					
		}catch(Exception e){
			response = "Error while saving the note.";
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		
		//System.out.println(response);
		return response;
	}
	
	
	@Override
	public String deleteUserNotes(String seqNoList) {
		List<String> mainList = new ArrayList<String>();
		String response = "" ;
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		
		String[] seqNoArray = CommonUtil.splitString(seqNoList, ",");
		for(int i = 0; i <= seqNoArray.length-2; i++) {
			mainList.add(seqNoArray[i]);
		}
		
		try{
			String sql = "	DELETE FROM "+schemaName+"TB_USERNOTES "+
						 "	WHERE SEQNO = ? ";
			
			preparedStatement = connection.prepareStatement(sql);
			for(String seqNo: mainList) {
				preparedStatement.setInt(1, Integer.parseInt(seqNo));
				preparedStatement.addBatch();
			}
			preparedStatement.executeBatch();
			response = "Notes successfully deleted.";
					
		}catch(Exception e){
			response = "Error while deleting the note.";
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		
		return response;
	}

	@Override
	public List<Map<String, String>> getAllNotesData(Connection connection) {
		List<Map<String, String>> dataList = new ArrayList<Map<String, String>>();
		//Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		
		try {
			String sql = " SELECT NOTES, REMINDERTIME, UPDATEDBY, UPDATEDTIMESTAMP "+
					 	 " FROM "+schemaName+"TB_USERNOTES ORDER BY SEQNO DESC ";
			preparedStatement = connection.prepareStatement(sql);
			resultSet = preparedStatement.executeQuery();
			
			while(resultSet.next()) {
				Map<String, String> dataMap = new LinkedHashMap<String, String>();
				//dataMap.put("SEQNO",resultSet.getString("SEQNO"));
				dataMap.put("NOTES",resultSet.getString("NOTES"));
				dataMap.put("REMINDERTIME",resultSet.getString("REMINDERTIME"));
				dataMap.put("UPDATEDBY",resultSet.getString("UPDATEDBY"));
				dataMap.put("UPDATEDTIMESTAMP",resultSet.getString("UPDATEDTIMESTAMP"));
				//dataMap.put("IPADDRESS",resultSet.getString("IPADDRESS"));
				dataList.add(dataMap);
			}
			//System.out.println("dataList = "+dataList);
		}catch(Exception e){
			e.printStackTrace();
		}
		return dataList;
	}
}

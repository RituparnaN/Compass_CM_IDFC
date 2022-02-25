package com.quantumdataengines.app.compass.dao.scanning;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Repository;

import com.quantumdataengines.app.compass.util.CommonUtil;
import com.quantumdataengines.app.compass.util.ConnectionUtil;

@Repository
public class NoiseWordsDAOImpl implements NoiseWordsDAO {
	
	@Autowired
	private ConnectionUtil connectionUtil;

	@Value("${compass.aml.config.schemaName}")
	private String schemaName;
	
	@SuppressWarnings("resource")
	@Override
	public String saveNoiseWord(String noiseWord, String isEnabled, String userCode, String ipAddress) {
		String response = "" ;
		Connection connection = null; 
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;		
		String sql = "";
		if("ALL".equals(isEnabled)) {
			isEnabled = "Y";
		}
		
		try{
			connection = connectionUtil.getConnection();
			if(!checkIfExists(noiseWord)) {
				String seqNo = "";
				preparedStatement = connection.prepareStatement("SELECT "+schemaName+"SEQ_NOISEWORDS.NEXTVAL AS SEQNO FROM DUAL");
				resultSet = preparedStatement.executeQuery();
				if(resultSet.next()){
					seqNo = resultSet.getString("SEQNO");
				}
				
				sql = "	INSERT INTO "+schemaName+"TB_NOISEWORDSCONFIGURATION( "+
					  "	       SEQNO, NOISEWORD, ISENABLED, UPDATEDBY, IPADDRESS, UPDATETIMESTAMP)  "+
					  "	VALUES (?, ?, ?, ?, ?, SYSTIMESTAMP) ";
				
				preparedStatement = connection.prepareStatement(sql);
				preparedStatement.setString(1, seqNo);
				preparedStatement.setString(2, noiseWord);
				preparedStatement.setString(3, isEnabled);
				preparedStatement.setString(4, userCode);
				preparedStatement.setString(5, ipAddress);
				
				preparedStatement.executeUpdate();
				response = "Noise word successfully saved.";
				
				sql = "	INSERT INTO "+schemaName+"TB_NOISEWORDSCONFIGURATION_LOG( "+
					  "	       SEQNO, NOISEWORD, ISENABLED, UPDATEDBY, IPADDRESS, UPDATETIMESTAMP, LOGGEDBY, LOGGEDTIMESTAMP)  "+
					  "	SELECT SEQNO, NOISEWORD, ISENABLED, UPDATEDBY, IPADDRESS, UPDATETIMESTAMP, ?, SYSTIMESTAMP "+
					  "   FROM "+schemaName+"TB_NOISEWORDSCONFIGURATION "+
					  "  WHERE SEQNO = ? ";
			
				preparedStatement = connection.prepareStatement(sql);
			    preparedStatement.setString(1, userCode);
			    preparedStatement.setString(2, seqNo);
			    preparedStatement.executeUpdate();
				
			}else {
				return "This noise word already exists.";
			}
					
		}catch(Exception e){
			response = "Error while saving the word.";
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		
		//System.out.println(" = "+response);
		return response;
	}

	@SuppressWarnings("resource")
	@Override
	public String updateNoiseWord(String noiseWordsList, String userCode, String ipAddress) {
		String response = "" ;
		Connection connection = null; 
		PreparedStatement preparedStatement = null;
		String sql = "";
		
		List<String> allNoiseWordsList = new ArrayList();
		String[] noiseWordsArray = CommonUtil.splitString(noiseWordsList, "---");
		for(String noiseWord: noiseWordsArray) {
			if(!noiseWord.isEmpty() && noiseWord != " ") {
				allNoiseWordsList.add(noiseWord);
			}
		}
		//System.out.println(" allNoiseWordsList = "+allNoiseWordsList);
		
		try{
			connection = connectionUtil.getConnection();
			sql = "	UPDATE "+schemaName+"TB_NOISEWORDSCONFIGURATION SET "+
				  "	       ISENABLED = ?, UPDATEDBY = ?, IPADDRESS = ?, UPDATETIMESTAMP = SYSTIMESTAMP "+
				  "	 WHERE NOISEWORD = ? ";
			
			preparedStatement = connection.prepareStatement(sql);
			for(String eachRecord: allNoiseWordsList) {
				preparedStatement.setString(1, eachRecord.split("=")[1]);
				preparedStatement.setString(2, userCode);
				preparedStatement.setString(3, ipAddress);
				preparedStatement.setString(4, eachRecord.split("=")[0]);
				preparedStatement.addBatch();
			}
			preparedStatement.executeBatch();
			response = "Noise words successfully updated.";
			
			sql = "	INSERT INTO "+schemaName+"TB_NOISEWORDSCONFIGURATION_LOG( "+
				  "	       SEQNO, NOISEWORD, ISENABLED, UPDATEDBY, IPADDRESS, UPDATETIMESTAMP, LOGGEDBY, LOGGEDTIMESTAMP)  "+
				  "	SELECT SEQNO, NOISEWORD, ISENABLED, UPDATEDBY, IPADDRESS, UPDATETIMESTAMP, ?, SYSTIMESTAMP "+
				  "   FROM "+schemaName+"TB_NOISEWORDSCONFIGURATION "+
				  "  WHERE NOISEWORD = ? ";
			
			preparedStatement = connection.prepareStatement(sql);
			for(String eachRecord: allNoiseWordsList) {
			    preparedStatement.setString(1, userCode);
				preparedStatement.setString(2, eachRecord.split("=")[0]);
				preparedStatement.addBatch();
			}
			preparedStatement.executeBatch();
					
		}catch(Exception e){
			response = "Error while updating the words.";
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, null, null);
		}
		
		//System.out.println(" response= "+response);
		return response;
	}
	
	public boolean checkIfExists(String noiseWord) {
		boolean condition = false;
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String sql = "";
		try{
			connection = connectionUtil.getConnection();
			sql = "	SELECT * FROM "+schemaName+"TB_NOISEWORDSCONFIGURATION "+
				  "	 WHERE NOISEWORD = ? ";
			
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, noiseWord);
			resultSet = preparedStatement.executeQuery();
			
			if(resultSet.next()) {
				condition = true;
			}
					
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		//System.out.println(" condition = "+condition);
		return condition;
	}

	@Override
	public List<String> loadAllNoiseWordInMemory() {
		//ConnectionUtil _conUtil = new ConnectionUtil();
		//Connection connection = _conUtil.getHardcoreConnection();
		//Connection connection = _conUtil.getConnection("COMPAML");
		Connection connection = null; 
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		List<String> noiseWord = new ArrayList<String>();
		String sql = "";
		try{
			connection = connectionUtil.getConnection();
			//connection = connectionUtil.getConnection("COMPAML");
			sql = "SELECT UPPER(TRIM(NOISEWORD)) NOISEWORD FROM "+schemaName+"TB_NOISEWORDSCONFIGURATION WHERE ISENABLED = ? ";
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, "Y");
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()){
				noiseWord.add(" "+resultSet.getString("NOISEWORD")+" ");
			}
			System.out.println("In NoiseWordsDAOImpl, noiseWord : "+noiseWord);
		}catch(Exception e){
			System.out.println("Exception occur during initilizing loading of noise word = "+e.getMessage());
			e.printStackTrace();
		}finally{
			//_conUtil.closeResources(connection, preparedStatement, null, null);
			connectionUtil.closeResources(connection, preparedStatement, null, null);
		}
		return noiseWord;
	}
	
}
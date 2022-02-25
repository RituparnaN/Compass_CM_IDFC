package com.quantumdataengines.app.compass.dao.admin;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.quantumdataengines.app.compass.util.ConnectionUtil;

@Repository
public class AdminDAOImpl implements AdminDAO{
private static final Logger log = LoggerFactory.getLogger(AdminDAOImpl.class);
	
	@Autowired
	private ConnectionUtil connectionUtil;
	
	@Override
	public String saveSystemParameters(Map<String, String> systemParametersMap){
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String message = "";
		try{
			Iterator<String> paramItr = systemParametersMap.keySet().iterator();
			preparedStatement = connection.prepareStatement(Query.SAVESYSTEMPARAMETERS);
			while (paramItr.hasNext()) {
				String param = paramItr.next();
				String value = systemParametersMap.get(param);
				preparedStatement.setString(1, value);
				preparedStatement.setString(2, param);
				preparedStatement.addBatch();
			}
			preparedStatement.executeBatch();
			message = "System Parameters are successfully saved";
		}catch(Exception e){
			message = "Error occured while saving system parameters";
			log.error("Error occured while saving system parameters : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return message;
	}
	
	@Override
	public Map<String, String> getPlivoSettings(){
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		Map<String, String> plivoSettings = new HashMap<String, String>();
		try{
			preparedStatement = connection.prepareStatement("SELECT AUTHID, AUTHTOKEN, SOURCENUMBER, DESTINATIONNUMBER "+
															"  FROM TB_PLIVOSETTINGS");
			resultSet = preparedStatement.executeQuery();
			while (resultSet.next()) {
				plivoSettings.put("AUTHID", resultSet.getString("AUTHID"));
				plivoSettings.put("AUTHTOKEN", resultSet.getString("AUTHTOKEN"));
				plivoSettings.put("SOURCENUMBER", resultSet.getString("SOURCENUMBER"));
				plivoSettings.put("DESTINATIONNUMBER", resultSet.getString("DESTINATIONNUMBER"));
			}
		}catch(Exception e){
			log.error("Error occured while saving system parameters : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return plivoSettings;
	}
	
	@Override
	public String updatePlivoSettings(String authId, String authToken,
			String sourceNo, String destNo){
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		String result = "";
		Map<String, String> plivoSettings = new HashMap<String, String>();
		try{
			preparedStatement = connection.prepareStatement("UPDATE TB_PLIVOSETTINGS SET AUTHID = ?, AUTHTOKEN = ?, "+
															"		SOURCENUMBER = ?, DESTINATIONNUMBER = ? ");
			preparedStatement.setString(1, authId);
			preparedStatement.setString(2, authToken);
			preparedStatement.setString(3, sourceNo);
			preparedStatement.setString(4, destNo);
			preparedStatement.executeUpdate();
			result = "Settings Updated.";
		}catch(Exception e){
			log.error("Error occured while saving system parameters : "+e.getMessage());
			e.printStackTrace();
			result = "Error while updating settings.";
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, null, null);
		}
		return result;
	}
	
	@SuppressWarnings("resource")
	public void savePlivoMessage(Map<String, String> messageDetails, String userCode){
		String seqNo = "";
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String sql = "";
		try{
			sql="SELECT SEQ_PLIVOMESSAGE.NEXTVAL FROM DUAL";
			preparedStatement = connection.prepareStatement(sql);
			resultSet = preparedStatement.executeQuery();
			if (resultSet.next()) {
				seqNo = Integer.toString(resultSet.getInt(1));
			}
			System.out.println(seqNo);
			sql="INSERT INTO TB_PLIVOCALLSMSLOG(SEQNO, SENDERNUMBER, RECIPIENTNUMBER, "+
				"		MESSAGEID, MESSAGESTATE, TOTALAMOUNT, MESSAGETIME, MESSAGETYPE, "+
				"		UNIT, ERRORS, USERCODE, UPDATETIMESTAMP) " + 
				"VALUES (?,?,?,?,?,?,?,?,?,?,?,SYSTIMESTAMP)";
			
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, seqNo);
			preparedStatement.setString(2, messageDetails.get("SENDERNUMBER"));
			preparedStatement.setString(3, messageDetails.get("RECIPIENTNUMBER"));
			preparedStatement.setString(4, messageDetails.get("MESSAGEID"));
			preparedStatement.setString(5, messageDetails.get("MESSAGESTATE"));
			preparedStatement.setString(6, messageDetails.get("TOTALAMOUNT"));
			preparedStatement.setString(7, messageDetails.get("MESSAGETIME"));
			preparedStatement.setString(8, messageDetails.get("MESSAGETYPE"));
			preparedStatement.setString(9, messageDetails.get("UNIT"));
			preparedStatement.setString(10, messageDetails.get("ERRORS"));
			preparedStatement.setString(11, userCode);
			preparedStatement.executeUpdate();
			System.out.println(sql);

		}catch(Exception e){
			log.error("Error occured while saving plivo message : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
	}


}

package com.quantumdataengines.app.compass.dao.etl.emailSettings;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.quantumdataengines.app.compass.schema.Configuration;
import com.quantumdataengines.app.compass.util.ConnectionUtil;

@Repository
public class ETLEmailSettingsDAOImpl implements ETLEmailSettingsDAO{
	
	private static final Logger log = LoggerFactory.getLogger(ETLEmailSettingsDAOImpl.class);
	@Autowired
	private ConnectionUtil connectionUtil;
	
	@Override
	public Map<String, String> getEmailSettings(Configuration configuration){
		Map<String, String> emailSettings = new HashMap<String, String>();
		Connection connection = connectionUtil.getConnection(configuration.getJndiDetails().getJndiName());
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String query = "SELECT PARAMETERNAME,PARAMETERVALUE "+
					   "  FROM TB_ETLEMAILDETAILS";
		try{
			preparedStatement = connection.prepareStatement(query);
			resultSet = preparedStatement.executeQuery();
			while (resultSet.next()) {
				emailSettings.put(resultSet.getString("PARAMETERNAME"), resultSet.getString("PARAMETERVALUE"));
			}
		}catch(Exception e){
			log.error("Error while getting etl email settings : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return emailSettings;
	}
	
	public String saveEmailSettings(Map<String, String> emailSettings){
		String settingsSaved = "";
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String query = "UPDATE TB_ETLEMAILDETAILS SET PARAMETERVALUE = ? "+
					   " WHERE PARAMETERNAME = ?";
		try{
			preparedStatement = connection.prepareStatement(query);
			List<String> allParameters = new ArrayList<String>(emailSettings.keySet());
			for(String parameter : allParameters){				
				preparedStatement.setString(1, emailSettings.get(parameter));
				preparedStatement.setString(2, parameter);
				preparedStatement.addBatch();
			}
			preparedStatement.executeBatch();
			settingsSaved = "Email settings successfully saved";
		}catch(Exception e){
			settingsSaved = "Error while saving email settings";
			log.error("Error while saving etl email settings : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return settingsSaved;
	}
}

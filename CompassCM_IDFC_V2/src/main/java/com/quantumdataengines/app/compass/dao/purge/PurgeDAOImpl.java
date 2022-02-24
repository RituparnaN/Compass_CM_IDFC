package com.quantumdataengines.app.compass.dao.purge;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;

import oracle.jdbc.OracleTypes;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Repository;

import com.quantumdataengines.app.compass.util.ConnectionUtil;

@Repository
public class PurgeDAOImpl implements PurgeDAO{

	@Autowired
	private ConnectionUtil connectionUtil;

	@Value("${compass.aml.config.schemaName}")
	private String schemaName;
	
	@Override
	public String purgeUpdate(String month, String year, String table,
			String actionType, String currentUser, String currentRole,
			String ipAddress) {
		Connection connection = connectionUtil.getConnection();
		CallableStatement callableStatement = null;
		ResultSet resultSet = null;
		String message = "";
		String procedureName = "STP_ARCHIVALRESTOREPROCESS";
		try{
			callableStatement = connection.prepareCall("{CALL "+schemaName+""+procedureName+"(?,?,?,?,?,?,?,?)}");
			callableStatement.setString(1,month);
			callableStatement.setString(2,year);
			callableStatement.setString(3,table);
			callableStatement.setString(4,actionType);
			callableStatement.setString(5,currentUser);
			callableStatement.setString(6,currentRole);
			callableStatement.setString(7,ipAddress);
			callableStatement.registerOutParameter(8, OracleTypes.CURSOR);  
			callableStatement.execute();
			message = "Records updated successfully.";

		}catch(Exception e){
			message = "Error While Updating.";
			System.out.println("error while updating via procedure = "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, callableStatement, resultSet, null);
		}
		return message;
	}
	
}

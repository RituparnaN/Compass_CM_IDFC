package com.quantumdataengines.app.listScanning.dao;

import java.sql.Connection;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.quantumdataengines.app.compass.util.ConnectionUtil;

@Component
public class DatabaseConnectionFactory {
	
	private static Connection connection = null;
	
	private DatabaseConnectionFactory() {
	}
	
	
	public static Connection getConnection(String strDataBaseName) {
		return ConnectionUtil.getDBConnection();
	}
	
	public static Connection getConnection() {
		return ConnectionUtil.getDBConnection();
	}
	
}
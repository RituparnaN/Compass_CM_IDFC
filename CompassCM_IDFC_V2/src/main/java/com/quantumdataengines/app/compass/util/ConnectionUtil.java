package com.quantumdataengines.app.compass.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

@Component
public class ConnectionUtil{
	
	private static final Logger log = LoggerFactory.getLogger(ConnectionUtil.class);
	@Autowired
	private DataSource dataSource;
	@Autowired
	private DataSource otherDataSource;
	@Autowired
	private SessionFactoryRoutingUtil sessionFactoryRoutingUtil;
	private Connection connection;
	
	private static Connection dbConnection;
	@Autowired
	private static DataSource dbDataSource;
	@Value("${compass.aml.config.jndiContext}")
	private String jndiContext;

	public void setDataSource(DataSource dataSource) {
		this.dataSource = dataSource;
	}
	
	public Connection getConnection(){
		try{
			StackTraceElement[] arrStackTraceElement = new Exception().getStackTrace();
			for(StackTraceElement stackTraceElement : arrStackTraceElement){
				if(stackTraceElement.getClassName().contains("dao"))
					log.debug("Database connection request from "+stackTraceElement.getMethodName()
						+" in "+stackTraceElement.getClassName());
			}
			connection = dataSource.getConnection();
			if(connection == null)
				connection = getConnection("COMPAML");
			
		}catch(Exception e){
			log.error("Error while getting db connection from DataSource["+dataSource+"] : "+e.getMessage());
			e.printStackTrace();
		}
		return connection;
	}
	
	public Connection getOtherConnection(){
		try{
			connection = otherDataSource.getConnection();
		}catch(Exception e){
			log.error("Error while getting db connection from DataSource["+dataSource+"] : "+e.getMessage());
			e.printStackTrace();
		}
		return connection;
	}
	
	public Connection getConnection(String jndiName){		
		DataSource localDataSource = null;
		Connection localConnection = null;
		try{
			StackTraceElement[] arrStackTraceElement = new Exception().getStackTrace();
			for(StackTraceElement stackTraceElement : arrStackTraceElement){
				if(stackTraceElement.getClassName().contains("dao"))
					log.debug("Database connection request from "+stackTraceElement.getMethodName()
						+" in "+stackTraceElement.getClassName());
			}
			
			Context context = new InitialContext();
			localDataSource = (DataSource) context.lookup(jndiContext+jndiName);
			localConnection = localDataSource.getConnection();
		}catch(Exception e){
			log.error("Error while getting db connection from DataSource["+localDataSource+"] : "+e.getMessage());
			e.printStackTrace();
		}
		return localConnection;
	}
	
	public static Connection getDBConnection(){
		try{
			StackTraceElement[] arrStackTraceElement = new Exception().getStackTrace();
			for(StackTraceElement stackTraceElement : arrStackTraceElement){
				if(stackTraceElement.getClassName().contains("dao"))
					log.debug("Database connection request from "+stackTraceElement.getMethodName()
						+" in "+stackTraceElement.getClassName());
			}
			System.out.println("dbDataSource : "+dbDataSource);
			dbConnection = dbDataSource.getConnection();
			System.out.println("dbConnection : "+dbConnection);
		}catch(Exception e){
			log.error("Error while getting db connection from DataSource["+dbDataSource+"] : "+e.getMessage());
			e.printStackTrace();
		}
		return dbConnection;
	}

	public SessionFactory getSessionFactory() throws Exception{
		StackTraceElement[] arrStackTraceElement = new Exception().getStackTrace();
		for(StackTraceElement stackTraceElement : arrStackTraceElement){
			if(stackTraceElement.getClassName().contains("dao"))
				log.debug("SessionFactory request from "+stackTraceElement.getMethodName()
					+" in "+stackTraceElement.getClassName());
		}     
        return sessionFactoryRoutingUtil.getSessionFactory();
	}
	
	public Session getHibernateSession() throws Exception{
		return getSessionFactory().openSession();
	}
	
	public void closeResources(Connection connection, Statement statement, ResultSet resultSet, Session session){
		try{
			if(connection != null)
				connection.close();
			if(statement != null)
				statement.close();
			if(resultSet != null)
				resultSet.close();
			if(session != null && session.isOpen())
				session.disconnect();
			
		}catch(Exception e){
			log.error("Error while closing db resource : "+e.getMessage());
			e.printStackTrace();
		}
	}
	public  Connection getDBConnectObject(String driverDetails, String jdbcURL, String jdbcUser, String jdbcPassword){
		try{
			// System.out.println("driverDetails: "+driverDetails);
			Class.forName(driverDetails);
			// System.out.println("compassEncryptorDecryptor.decrypt(jdbcPassword) "+jdbcPassword);
			connection = DriverManager.getConnection(jdbcURL, jdbcUser, jdbcPassword);
			//System.out.println("connection = "+connection);
		}catch(Exception e){
			log.error("Error while getting hardcore jdbc connection = "+e.getMessage());
			e.printStackTrace();
		}
		return connection;
	}
}
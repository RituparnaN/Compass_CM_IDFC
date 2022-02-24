package com.quantumdataengines.app.compass.dao.regulatoryReports.sriLanka;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import oracle.jdbc.internal.OracleTypes;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Repository;

import com.quantumdataengines.app.compass.util.ConnectionUtil;

@Repository
public class SLIEFTDAOImpl implements SLIEFTDAO{
	private static final Logger log = LoggerFactory.getLogger(SLIEFTDAOImpl.class);
	@Autowired
	private ConnectionUtil connectionUtil;
	
	@Value("${compass.aml.config.schemaName}")
	private String schemaName;
	
	public Connection getConnection(){
		Connection connection = null;
		try{
			connection = connectionUtil.getConnection();
		}catch(Exception e){
			log.error("Error in creating db connection : SLIEFTDAOImpl -> "+e.getMessage());
			e.printStackTrace();
		}
		return connection;
	}
	
	@Override
	public String generateSLIEFTReportingFile(String reportType, String reportingFileType, String fortNightOfReporting, String monthOfReporting, String yearOfReporting, String thresholdAmount, String userId){
		Connection connection = null;
        CallableStatement callableStatement = null;
        String l_strMessage = ""; 
        try {
            connection = getConnection();
            callableStatement = connection.prepareCall("{CALL "+schemaName+"STP_GENERATESLREGREPORTDATA(?,?,?,?,?,?,?)}");
            callableStatement.setString(1, reportType);
            callableStatement.setString(2, reportingFileType);
            callableStatement.setString(3, fortNightOfReporting);
            callableStatement.setString(4, monthOfReporting);
            callableStatement.setString(5, yearOfReporting);
            callableStatement.setString(6, thresholdAmount);
            callableStatement.setString(7, userId);
            callableStatement.execute();
            l_strMessage = "Data for "+reportType+" has been generated.";
        } catch(Exception e) {
        	l_strMessage = "Error occured during data generation for "+reportType;
        	log.error("Error in SLIEFTDAOImpl->generateSLRegulatoryXML "+reportType+" : "+e.getMessage());
        	e.printStackTrace();
        }finally{
        	connectionUtil.closeResources(connection, callableStatement, null, null);
        }
    	return l_strMessage;
    }
    
	@Override
	public List<String> getSLRegReportFileData(String tableName){
    	List<String> filedata = new Vector<String>();
    	Connection connection = null;
    	PreparedStatement preparedStatement = null;
    	ResultSet resultSet = null;
    	try{
        	connection = getConnection();	
            preparedStatement = connection.prepareStatement("SELECT CHARACTERSET FROM "+tableName+" ORDER BY SEQNO");
    		resultSet = preparedStatement.executeQuery();
    		while (resultSet.next()) {
    			filedata.add(resultSet.getString("CHARACTERSET"));
			}
    	}catch(Exception e){
    		log.error("Error in SLIEFTDAOImpl->getSLRegReportFileData "+tableName+" : "+e.getMessage());
        	e.printStackTrace();
    	}finally{
        	connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
        }
    	return filedata;
    }


}

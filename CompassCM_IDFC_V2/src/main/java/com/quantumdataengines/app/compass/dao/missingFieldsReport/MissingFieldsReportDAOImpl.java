package com.quantumdataengines.app.compass.dao.missingFieldsReport;

import java.sql.CallableStatement;
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

import oracle.jdbc.OracleTypes;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Repository;

import com.quantumdataengines.app.compass.util.CommonUtil;
import com.quantumdataengines.app.compass.util.ConnectionUtil;

@Repository
public class MissingFieldsReportDAOImpl implements MissingFieldsReportDAO{

	@Autowired
	private ConnectionUtil connectionUtil;
	
	@Value("${compass.aml.config.schemaName}")
	private String schemaName;
	
	public List<Map<String, String>> getListOfBranchCodes(){
		List<Map<String, String>> branchList = new ArrayList<Map<String,String>>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String sql = "SELECT BRANCHCODE, BRANCHNAME FROM "+schemaName+"TB_BRANCHMASTER ";
		try{
			preparedStatement = connection.prepareStatement(sql);
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()){
				Map<String, String> branch = new LinkedHashMap<String, String>();
				branch.put("BRANCHCODE", resultSet.getString("BRANCHCODE"));
				branch.put("BRANCHNAME", resultSet.getString("BRANCHNAME"));
				branchList.add(branch);	
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);	
		}
		return branchList;		
	}
	
	public List<Map<String, String>> getListOfTemplates(){
		List<Map<String, String>> templatesList = new ArrayList<Map<String,String>>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String sql = "SELECT TEMPLATEID, TEMPLATENAME FROM "+schemaName+"TB_MMLISTMASTER ";
		try{
			preparedStatement = connection.prepareStatement(sql);
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()){
				Map<String, String> template = new LinkedHashMap<String, String>();
				template.put("TEMPLATEID", resultSet.getString("TEMPLATEID"));
				template.put("TEMPLATENAME", resultSet.getString("TEMPLATENAME"));
				templatesList.add(template);	
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);	
		}
		return templatesList;		
	}
	
	@Override
	public Map<String, Object> searchMissingFieldsReport(String template, String branchCode, String complianceScore, String userCode, String ipAddress) {
		Map<String, Object> resultMap = new HashMap<String, Object>();		
		List<Map<String, String>> mainList = new Vector<Map<String,String>>();
		Connection connection = connectionUtil.getConnection();
		CallableStatement callableStatement= null;
		ResultSet resultSet = null;
		
		String procedure = "{CALL "+schemaName+"STP_MISSINGMANDATORYREPORT(:TEMPLATE, :BRANCHCODE, :COMPLIANCESCORE, :IPADDRESS, :USERCODE, :RESULTSET)}";
		
		try{
			callableStatement = connection.prepareCall(procedure);
			callableStatement.setString("TEMPLATE", template);
			callableStatement.setString("BRANCHCODE", branchCode);
			callableStatement.setString("COMPLIANCESCORE", complianceScore);
			callableStatement.setString("USERCODE", userCode);
			callableStatement.setString("IPADDRESS", ipAddress);
			callableStatement.registerOutParameter("RESULTSET", OracleTypes.CURSOR);
			callableStatement.execute();
			resultSet = (ResultSet) callableStatement.getObject("RESULTSET");
			
			List<String> headers = new Vector<String>();
			ResultSetMetaData resultSetMetaData = resultSet.getMetaData();
			int numberofcols = resultSetMetaData.getColumnCount();
			for(int count = 1; count <= numberofcols; count++ ){
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
			resultMap.put("RECORDDATA", mainList);
		}catch(Exception e){
			e.printStackTrace();	
		}finally{
			connectionUtil.closeResources(connection, callableStatement, resultSet, null);		
		}
	return resultMap;
	}
}
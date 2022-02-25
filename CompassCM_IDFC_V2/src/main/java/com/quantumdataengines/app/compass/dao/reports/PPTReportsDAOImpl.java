package com.quantumdataengines.app.compass.dao.reports;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import oracle.jdbc.OracleTypes;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.quantumdataengines.app.compass.util.ConnectionUtil;

@Repository
public class PPTReportsDAOImpl implements PPTReportsDAO {
	
	@Autowired
	private ConnectionUtil connectionUtil;

	@Override
	public Map<String, Object> getPPTReportData(Map<String, String> paramValues) {
		
		// TODO Auto-generated method stub
		String fromDate = paramValues.get("FROMDATE");
		String toDate = paramValues.get("TODATE");
		String userCode = paramValues.get("USERCODE");
		String userRole = paramValues.get("USERROLE");
		String ipAdress = paramValues.get("IPADRESS");
		Map<String,Object> mainData = new HashMap<String,Object>();
		
		Map<String,Object> reportStats = new HashMap<String,Object>();
		Map<String,Object> alertDetails = new HashMap<String,Object>();
		Map<String,Object> branchWisealertDetails = new HashMap<String,Object>();
		Map<String,Object> customerRiskDetails = new HashMap<String,Object>();
		
		List<String>ColumnNames = new ArrayList<String>();
		List<List<String>> tableData = new ArrayList<List<String>>();
		Connection connection = null;
		CallableStatement callableStatement = null;
		ResultSet resultSet = null;
		ResultSetMetaData rsmd = null;
		try{
			connection = connectionUtil.getConnection();
			callableStatement = connection.prepareCall("{CALL STP_PPTREPORTDATA(?,?,?,?,?,?,?,?,?)}");
			callableStatement.setString(1, fromDate);
			callableStatement.setString(2, toDate);
			callableStatement.setString(3, userCode);
			callableStatement.setString(4, userRole);
			callableStatement.setString(5, ipAdress);
			callableStatement.registerOutParameter(6, OracleTypes.CURSOR);
			callableStatement.registerOutParameter(7, OracleTypes.CURSOR);
			callableStatement.registerOutParameter(8, OracleTypes.CURSOR);
			callableStatement.registerOutParameter(9, OracleTypes.CURSOR);
			callableStatement.execute();
			//for first slide reprot statistic
			resultSet = (ResultSet) callableStatement.getObject(6);
			rsmd = resultSet.getMetaData();
			
			ColumnNames = getColumnName(rsmd);
			while(resultSet.next()){
				List<String> row = new ArrayList<String>();
				for(String colName:ColumnNames){
					row.add(resultSet.getString(colName));
				}
				tableData.add(row);
			}
			reportStats.put("COLUMNNAME",ColumnNames);
			reportStats.put("TABLEBODYDATA",tableData);
			
			//for second slide
			resultSet = (ResultSet) callableStatement.getObject(7); 
			rsmd = resultSet.getMetaData(); 
			ColumnNames = new ArrayList<String>();;
			tableData = new ArrayList<List<String>>();;
			ColumnNames = getColumnName(rsmd);
			while(resultSet.next()){
				List<String> row = new ArrayList<String>();
				for(String colName:ColumnNames){
					row.add(resultSet.getString(colName));
				}
				tableData.add(row);
				
				/*alertDetails.put("TOTALGENERATEDALERT", resultSet.getString("TOTALGENERATEDALERT"));
				alertDetails.put("PENDINGALERTS", resultSet.getString("PENDINGALERTS"));*/
			}
			alertDetails.put("COLUMNNAME",ColumnNames);
			alertDetails.put("TABLEBODYDATA",tableData);
			
			resultSet = (ResultSet) callableStatement.getObject(8); 
			rsmd = resultSet.getMetaData(); 
			ColumnNames = new ArrayList<String>();;
			tableData = new ArrayList<List<String>>();;
			ColumnNames = getColumnName(rsmd);
			while(resultSet.next()){
				List<String> row = new ArrayList<String>();
				for(String colName:ColumnNames){
					row.add(resultSet.getString(colName));
				}
				tableData.add(row);
				
			}
			branchWisealertDetails.put("COLUMNNAME",ColumnNames);
			branchWisealertDetails.put("TABLEBODYDATA",tableData);
			
			//for 3rd slide
			resultSet = (ResultSet) callableStatement.getObject(9);
			rsmd = resultSet.getMetaData(); 
			ColumnNames = new ArrayList<String>();;
			tableData = new ArrayList<List<String>>();;
			ColumnNames = getColumnName(rsmd);
			while(resultSet.next()){
				List<String> row = new ArrayList<String>();
				for(String colName:ColumnNames){
					row.add(resultSet.getString(colName));
				}
				tableData.add(row);
				//customerRiskDetails.put(resultSet.getString("RISKRATING"), resultSet.getString("TOTLALCUSTOMER"));
			}
			customerRiskDetails.put("COLUMNNAME",ColumnNames);
			customerRiskDetails.put("TABLEBODYDATA",tableData);
			
			mainData.put("REPORTSTATS",reportStats);
			mainData.put("ALERTDETAILS",alertDetails );
			mainData.put("BRANCHWISEALERTDETAILS",branchWisealertDetails );
			mainData.put("CUSTOMERRISKDETAILS", customerRiskDetails);
			
		}catch(Exception e){
			System.out.println("error message = "+e.getMessage());
			e.printStackTrace();
			
		}
		//System.out.println("data = "+mainData);
		return mainData;
	}
	
	private List<String> getColumnName(ResultSetMetaData rsmd){
		List<String> colnames = new ArrayList<String>();
		try{
			int colNo = rsmd.getColumnCount();
			for (int i=1;i<=colNo;i++) {
			    String colName = rsmd.getColumnName(i);
			    colnames.add(colName);
			}
		} catch (SQLException e) {
			System.out.println("error while getting column Name = "+e.getMessage());
			e.printStackTrace();
		}
		return colnames;
		
	}
	
	

}

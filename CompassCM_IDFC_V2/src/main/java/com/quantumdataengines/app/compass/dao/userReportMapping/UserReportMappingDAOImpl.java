package com.quantumdataengines.app.compass.dao.userReportMapping;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Repository;

import com.quantumdataengines.app.compass.util.CommonUtil;
import com.quantumdataengines.app.compass.util.ConnectionUtil;

import oracle.jdbc.OracleTypes;

@Repository
public class UserReportMappingDAOImpl implements UserReportMappingDAO{

	@Autowired
	private ConnectionUtil connectionUtil;
	
	@Value("${compass.aml.config.schemaName}")
	private String schemaName;
	
	@SuppressWarnings("resource")
	@Override
	public Map<String, Object> userReportMapping(){
		Map<String, Object> dataMap = new LinkedHashMap<String, Object>();
		List<String> rolesList =  new LinkedList<String>();
		
		Map<String, Object> userRoleMapping = new LinkedHashMap<String, Object>();
		List<String> reportTypesList =  new LinkedList<String>();
		
		Map<String, Object> reportsMap = new LinkedHashMap<String, Object>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		
		try{
			String sql = "SELECT ROLEID FROM TB_ROLE ORDER BY ROLEID ";

			preparedStatement = connection.prepareStatement(sql);
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()){
				rolesList.add(resultSet.getString(1));
			}
			
			for(String roleId : rolesList) {
				sql = "SELECT USERCODE FROM TB_USERROLEMAPPING "+
					  " WHERE ROLEID = ? "+
					  " ORDER BY USERCODE ";

				preparedStatement = connection.prepareStatement(sql);
				preparedStatement.setString(1, roleId);
				resultSet = preparedStatement.executeQuery();
				
				List<String> usersList =  new LinkedList<String>();
				
				while(resultSet.next()){
					usersList.add(resultSet.getString("USERCODE"));
				}				
				userRoleMapping.put(roleId, usersList);
			}
			
			sql = "SELECT DISTINCT REPORTTYPE FROM "+schemaName+"TB_REPORTDETAILS ORDER BY REPORTTYPE ";

			preparedStatement = connection.prepareStatement(sql);
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()){
				reportTypesList.add(resultSet.getString(1));
			}
			
			for(String reporttype : reportTypesList) {
				sql = "SELECT REPORTID, REPORTNAME FROM "+schemaName+"TB_REPORTDETAILS "+
					  " WHERE REPORTTYPE = ? "+
					  " ORDER BY REPORTID ";

				preparedStatement = connection.prepareStatement(sql);
				preparedStatement.setString(1, reporttype);
				resultSet = preparedStatement.executeQuery();
				
				List<Object> reportIdsList =  new LinkedList<Object>();
				
				while(resultSet.next()){
					Map<String, String> reportDetailsMap = new LinkedHashMap<String, String>();
					reportDetailsMap.put(resultSet.getString("REPORTID"), resultSet.getString("REPORTNAME"));
					reportIdsList.add(reportDetailsMap);
				}
								
				reportsMap.put(reporttype, reportIdsList);
			}
			
			dataMap.put("USERROLEMAPPING", userRoleMapping);
			dataMap.put("REPORTSMAPPING", reportsMap);
			
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		//System.out.println(dataMap);
		return dataMap;
	}
	
	@SuppressWarnings("resource")
	public Map<String, Object> searchUserReportMapping(String selectedUserCode, String reportType, String reportId, String userCode, String userRole, String ipAddress){
		Map<String, Object> resultMap = new HashMap<String, Object>();	
		List<String> headers = new Vector<String>();
		List<Map<String, String>> mainList = new Vector<Map<String,String>>();
		Connection connection = connectionUtil.getConnection();
		CallableStatement callableStatement = null;
		ResultSet resultSet = null;
		int count = 1;
		try{
			/*System.out.println("1"+ selectedUserCode);
			System.out.println("2"+ reportType);
			System.out.println("3"+ reportId);
			System.out.println("4"+ userCode);
			System.out.println("5"+ userRole);
			System.out.println("6"+ ipAddress);*/
			
			callableStatement = connection.prepareCall("{CALL "+schemaName+"STP_SEARCHUSERREPORTMAPPING(?,?,?,?,?,?,?)}");
			callableStatement.setString(1, selectedUserCode);
			callableStatement.setString(2, reportType);
			callableStatement.setString(3, reportId);
			callableStatement.setString(4, userCode);
			callableStatement.setString(5, userRole);
			callableStatement.setString(6, ipAddress);
			callableStatement.registerOutParameter(7, OracleTypes.CURSOR);
			callableStatement.execute();
			
			resultSet = (ResultSet) callableStatement.getObject(7);
							
			ResultSetMetaData resultSetMetaData = resultSet.getMetaData();
			int numberofcols = resultSetMetaData.getColumnCount();
			for(count = 1; count <= numberofcols; count++ ){
				String colname = resultSetMetaData.getColumnName(count);
				headers.add(colname);
				//headers.add(CommonUtil.changeColumnName(colname));
			}
			
			while(resultSet.next()){
				Map<String, String> dataMap = new LinkedHashMap<String, String>();
				for(int colIndex = 1; colIndex <= resultSetMetaData.getColumnCount(); colIndex++){
					String columnName = resultSetMetaData.getColumnName(colIndex);
					dataMap.put(columnName, resultSet.getString(columnName));
				}
				mainList.add(dataMap);
			}
			//}	
			resultMap.put("HEADER", headers);
			resultMap.put("RECORDDATA", mainList);
			//}
		}catch(Exception e){
			e.printStackTrace();	
		}finally{
			connectionUtil.closeResources(connection, callableStatement, resultSet,null);		
		}
		System.out.println("searchdata = "+resultMap);
		return resultMap;
	}
		
	@SuppressWarnings("resource")
	public String saveUserReportMapping(String fullData, String currentUser){
		List<List<String>> mainList = new Vector<List<String>>();
		String[] arrStr = CommonUtil.splitString(fullData, "|~|");
		for(String strData : arrStr){
			String[] arrData1 = CommonUtil.splitString(strData, ",");
			if(arrData1.length == 4){
				List<String> dataList = new Vector<String>();
				for(String strData1 : arrData1)
					dataList.add(strData1);
				mainList.add(dataList);
			}
		}
		
		String result = "";
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String mappingSeqNo = "";
		String sql = "";
		try{
			
				sql = "DELETE FROM "+schemaName+"TB_USERREPORTMAPPING "+
					  " WHERE USERCODE = ? "+ 
					  "	  AND REPORTID = ? ";
				
				preparedStatement= connection.prepareStatement(sql);
				
				for(List<String> list : mainList){
					preparedStatement.setString(1, list.get(1));
					preparedStatement.setString(2, list.get(2));
					
					preparedStatement.addBatch();
				}
				
				preparedStatement.executeBatch();
				
				
				sql = "INSERT INTO "+schemaName+"TB_USERREPORTMAPPING(ISENABLED, USERCODE, REPORTID, REPORTTYPE, UPDATEDBY, UPDATETIMESTAMP) "+
					  " VALUES (?,?,?,?,?, SYSTIMESTAMP) ";
				preparedStatement= connection.prepareStatement(sql);
				
				for(List<String> list : mainList){
					preparedStatement.setString(1, list.get(0));
					preparedStatement.setString(2, list.get(1));
					preparedStatement.setString(3, list.get(2));
					preparedStatement.setString(4, list.get(3));
					preparedStatement.setString(5, currentUser);
					
					preparedStatement.addBatch();
				}
				
				preparedStatement.executeBatch();
				
				result = "Mapping inserted successfully";
			
		}catch(Exception e){
			e.printStackTrace();
			result = "Error while saving the mapping.";
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		System.out.println(result);
		return result;
	}
}

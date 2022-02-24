package com.quantumdataengines.app.compass.dao.userAlertMapping;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Repository;

import com.quantumdataengines.app.compass.util.CommonUtil;
import com.quantumdataengines.app.compass.util.ConnectionUtil;

@Repository
public class UserAlertMappingDAOImpl implements UserAlertMappingDAO{

	@Autowired
	private ConnectionUtil connectionUtil;
	
	@Value("${compass.aml.config.schemaName}")
	private String schemaName;
	
	@Override
	public Map<String, String> getUserDetails(String userRole){
		Map<String, String> dataMap = new LinkedHashMap<String, String>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		
		String sql = "SELECT A.USERCODE OPTIONNAME, A.FIRSTNAME ||' '|| A.LASTNAME OPTIONVALUE "+
					 "  FROM TB_USER A "+
					 " INNER JOIN TB_USERROLEMAPPING B ON A.USERCODE = B.USERCODE "+
					 " WHERE UPPER(B.ROLEID) LIKE ? " ;
		try{
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, "%"+userRole.trim().toUpperCase()+"%");
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()){
				dataMap.put(resultSet.getString("OPTIONNAME"), resultSet.getString("OPTIONVALUE"));
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return dataMap;
	}
	
		@SuppressWarnings("resource")
		public Map<String, Object> searchUserALertMapping(String mappingType, String userLevel, String userCode){
			
			Map<String, Object> resultMap = new HashMap<String, Object>();		
			List<Map<String, String>> mainList = new Vector<Map<String,String>>();
			Connection connection = connectionUtil.getConnection();
			PreparedStatement preparedStatement = null;
			ResultSet resultSet = null;
			int count = 1;
			try{
				String sql= "DELETE FROM "+schemaName+"TT_ALERTUSERMAPPED ";
				preparedStatement = connection.prepareStatement(sql);
				preparedStatement.executeUpdate();
				
				sql= "INSERT INTO "+schemaName+"TT_ALERTUSERMAPPED(USERCODE, USERLEVEL, MAPPEDFIELDTYPE, MAPPEDFIELDVALUE) ";
				if(mappingType.equalsIgnoreCase("AlertCodeMapping")){
					sql= sql + " SELECT A.USERCODE, ?, 'AlertCodeMapping' MAPPEDFIELDTYPE, B.ALERTCODE "+
							   "   FROM TB_USER A, "+schemaName+"TB_ALERTMASTER B, TB_USERROLEMAPPING C "+
							   "  WHERE A.USERCODE = C.USERCODE "+
							   "    AND B.ISENABLED = 'Y' ";
				}
				else if(mappingType.equalsIgnoreCase("BranchMapping")){
					sql= sql + " SELECT A.USERCODE, ?, 'BranchMapping' MAPPEDFIELDTYPE, B.BRANCHCODE  "+
	                           "   FROM TB_USER A, "+schemaName+"TB_BRANCHMASTER B, TB_USERROLEMAPPING C "+
	                           "  WHERE A.USERCODE = C.USERCODE ";
				}
				else if(mappingType.equalsIgnoreCase("AccountMapping")){
					sql= sql + " SELECT A.USERCODE, ?, 'AccountMapping' MAPPEDFIELDTYPE, B.ACCOUNTNO "+
							   "   FROM TB_USER A, "+schemaName+"TB_ACCOUNTSMASTER B, TB_USERROLEMAPPING C "+
							   "  WHERE A.USERCODE = C.USERCODE ";
				}
				else if(mappingType.equalsIgnoreCase("ProductCodeMapping")){
					sql= sql + " SELECT A.USERCODE, ?, 'ProductCodeMapping' MAPPEDFIELDTYPE, B.PRODUCTCODE "+
							   "   FROM TB_USER A, "+schemaName+"TB_PRODUCTSMASTER B, TB_USERROLEMAPPING C "+
							   "  WHERE A.USERCODE = C.USERCODE ";
				}
				else if(mappingType.equalsIgnoreCase("CustomerTypeMapping")){
					sql= sql + " SELECT A.USERCODE, ?, 'CustomerTypeMapping' MAPPEDFIELDTYPE , B.CUSTOMERTYPE "+
							   "   FROM TB_USER A, "+schemaName+"TB_CUSTOMERTYPEMASTER B, TB_USERROLEMAPPING C "+
							   "  WHERE A.USERCODE = C.USERCODE ";
				}
				else if(mappingType.equalsIgnoreCase("RiskRatingMapping")){
					sql= sql + " SELECT A.USERCODE, ?, 'RiskRatingMapping' MAPPEDFIELDTYPE , B.RISKRATING "+
	                           "   FROM TB_USER A, "+
	                           " (SELECT 'LOW' RISKRATING FROM DUAL UNION SELECT 'MEDIUM' RISKRATING FROM DUAL UNION SELECT 'HIGH' RISKRATING FROM DUAL ) B, "+
	                           " TB_USERROLEMAPPING C "+
	                           "  WHERE A.USERCODE = C.USERCODE " ;
	         	}
				
				if(userLevel != null && !userLevel.equals("") && !userLevel.equalsIgnoreCase("ALL"))
					//sql = sql + " AND C.ROLEID = '"+userLevel+"' ";
					sql = sql + " AND C.ROLEID LIKE ? ";
				
				if(userCode != null && userCode.length()>0  && !userCode.equalsIgnoreCase("ALL"))
					//sql = sql + " AND A.USERCODE = '"+userCode+"' ";
					sql = sql + " AND A.USERCODE = ? ";
				
				preparedStatement= connection.prepareStatement(sql);
				preparedStatement.setString(1, userLevel);
				count++;
				if(userLevel != null && !userLevel.equals("") && !userLevel.equalsIgnoreCase("ALL")){
					preparedStatement.setString(count, "%"+userLevel.trim().toUpperCase()+"%");
					count++;
				}
				if(userCode != null && userCode.length()>0  && !userCode.equalsIgnoreCase("ALL")){
					preparedStatement.setString(count, userCode);
				}
				preparedStatement.executeUpdate();
				count = 1;
				
				sql = "SELECT X.* FROM ( "+
					  "SELECT A.* FROM ( "+
				      "SELECT CASE WHEN TRIM(B.USERCODE) IS NULL THEN 'N' ELSE 'Y' END AS ISSELECTED, "+
				      "       A.USERCODE, A.USERLEVEL, A.MAPPEDFIELDTYPE, A.MAPPEDFIELDVALUE, "+
				      "       TRIM(NVL(B.UPDATEDBY, '')) UPDATEDBY, TRIM(FUN_DATETOCHAR(B.UPDATETIMESTAMP)) UPDATETIMESTAMP "+
					  "	 FROM "+schemaName+"TT_ALERTUSERMAPPED A "+
			          "  LEFT OUTER JOIN "+schemaName+"TB_USERSALERTMAPPING B "+
			          "    ON A.USERCODE = B.USERCODE " +
			          "   AND A.USERLEVEL = B.USERLEVEL "+
			          "   AND A.MAPPEDFIELDTYPE = B.MAPPEDFIELDTYPE "+
			          "   AND A.MAPPEDFIELDVALUE = B.MAPPEDFIELDVALUE ";
				
				if(mappingType != null && mappingType.length()>0 && !mappingType.equalsIgnoreCase("ALL"))
					//sql = sql + " AND A.MAPPEDFIELDTYPE = '"+mappingType+"' ";
					sql = sql + " AND A.MAPPEDFIELDTYPE = ? ";
				if(userLevel != null && userLevel.length()>0 && !mappingType.equalsIgnoreCase("ALL"))
					//sql = sql + " AND A.USERLEVEL = '"+userLevel+"' ";
					sql = sql + " AND A.USERLEVEL LIKE ? ";
				if(userCode != null && userCode.length()>0 && !userCode.equalsIgnoreCase("ALL"))
					//sql = sql + " AND A.USERCODE = '"+userCode+"' ";
					sql = sql + " AND A.USERCODE = ? ";

				sql = sql + " ) A ORDER BY ISSELECTED DESC, MAPPEDFIELDTYPE, MAPPEDFIELDVALUE ) X ";
				
				preparedStatement = connection.prepareStatement(sql);
				if(mappingType != null && mappingType.length()>0 && !mappingType.equalsIgnoreCase("ALL")){
					preparedStatement.setString(count, mappingType);
					count++;
				}
				if(userLevel != null && userLevel.length()>0 && !userLevel.equalsIgnoreCase("ALL")){
					preparedStatement.setString(count, "%"+userLevel.trim().toUpperCase()+"%");
					count++;
				}
				if(userCode != null && userCode.length()>0 && !userCode.equalsIgnoreCase("ALL")){
					preparedStatement.setString(count, userCode);
				}
				resultSet = preparedStatement.executeQuery();
				count = 1;
				
				List<String> headers = new Vector<String>();
				ResultSetMetaData resultSetMetaData = resultSet.getMetaData();
				int numberofcols = resultSetMetaData.getColumnCount();
				//for(int count = 1; count <= numberofcols; count++ ){
				for(count = 1; count <= numberofcols; count++ ){
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
				connectionUtil.closeResources(connection, preparedStatement,resultSet,null);		
			}
			return resultMap;
		}
		
		@SuppressWarnings("resource")
		public String saveAssignment(String fullData, String currentUser){
			List<List<String>> mainList = new Vector<List<String>>();
			
			String[] arrStr = CommonUtil.splitString(fullData, ";");
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
			try{
				String sql = "DELETE FROM "+schemaName+"TB_USERSALERTMAPPING "+
				          	 " WHERE USERCODE = ? "+
				          	 "   AND USERLEVEL = ? "+	
				          	 "   AND MAPPEDFIELDTYPE = ? ";
				          	 // "   AND MAPPEDFIELDVALUE = ? " ;
				preparedStatement= connection.prepareStatement(sql);
				for(int i=0; i <= 0; i++){
					List<String> list = mainList.get(i);
					preparedStatement.setString(1, list.get(0));
					preparedStatement.setString(2, list.get(1));
					preparedStatement.setString(3, list.get(2));
					// preparedStatement.setString(4, list.get(3));
					preparedStatement.addBatch();
				}
				preparedStatement.executeBatch();
				
				sql = "INSERT INTO "+schemaName+"TB_USERSALERTMAPPING(USERCODE, USERLEVEL, MAPPEDFIELDTYPE, MAPPEDFIELDVALUE, UPDATEDBY, UPDATETIMESTAMP ) "+
					  " VALUES (?,?,?,?,?, SYSTIMESTAMP) ";
				preparedStatement= connection.prepareStatement(sql);
				for(List<String> list : mainList){
					preparedStatement.setString(1, list.get(0));
					preparedStatement.setString(2, list.get(1));
					preparedStatement.setString(3, list.get(2));
					preparedStatement.setString(4, list.get(3));
					preparedStatement.setString(5, currentUser);
					if(!list.get(3).equalsIgnoreCase("NOT.AVAILABLE")){
					  preparedStatement.addBatch();
					}
				}
				preparedStatement.executeBatch();
				result = "Record assigned successfully";
			}catch(Exception e){
				e.printStackTrace();
				result = "Error while assigning.";
			}finally{
				connectionUtil.closeResources(connection, preparedStatement, null, null);
			}
			return result;
		}
}

package com.quantumdataengines.app.compass.dao.roboscanConfiguration;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Repository;

import com.quantumdataengines.app.compass.util.ConnectionUtil;

@Repository
public class RoboscanConfigDAOImpl implements RoboscanConfigDAO{
	
	@Autowired
	private ConnectionUtil connectionUtil;
	
	@Value("${compass.aml.config.schemaName}")
	private String schemaName;
	
	public List<String> getAllRolesAvailable(){
		List<String> allRoles = new Vector<String>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String query = "SELECT ROLEID FROM TB_ROLE ORDER BY ROLEID ";
		try{
			preparedStatement = connection.prepareStatement(query);
			resultSet = preparedStatement.executeQuery();
			while (resultSet.next()) {
				allRoles.add(resultSet.getString("ROLEID"));
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return allRoles;
	}
	
	/*public List<Map<String, String>> getSectionNames(){
		List<Map<String, String>> dataList = new Vector<Map<String, String>>();
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String sql = "SELECT SERIALNO, SECTIONNAME "+
					 "	FROM "+schemaName+"TB_ROBOSCANSECTIONMASTER ";
		try{
			connection = connectionUtil.getConnection();
			preparedStatement = connection.prepareStatement(sql);
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()){
				Map<String, String> dataMap = new LinkedHashMap<String, String>();
				dataMap.put("SERIALNO", resultSet.getString("SERIALNO"));
				dataMap.put("SECTIONNAME", resultSet.getString("SECTIONNAME"));
			dataList.add(dataMap);	
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return dataList;
	}	*/
	
	public List<Map<String,String>> getSectionNamesForRoleMapping(String roleId){
		List<Map<String, String>> dataList = new Vector<Map<String, String>>();
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String sql = "SELECT SERIALNO, SECTIONNAME, DESCRIPTION, "+
					 "		 CASE WHEN B.ROLEID IS NOT NULL THEN 'Y' ELSE 'N' END AS ISSELECTED "+
					 "  FROM "+schemaName+"TB_ROBOSCANSECTIONMASTER A "+
					 "	LEFT OUTER JOIN "+schemaName+"TB_ROBOSCANCONFIG B ON B.ROLEID = ? "+
					 "		AND ','||B.SELECTEDPARTS||',' LIKE '%,'||A.SECTIONNAME||',%' "+
					 " ORDER BY SERIALNO ";
		try{
			connection = connectionUtil.getConnection();
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, roleId);
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()){
				Map<String,String> dataMap = new LinkedHashMap<String, String>();
				dataMap.put("SERIALNO", resultSet.getString("SERIALNO"));
				dataMap.put("SECTIONNAME", resultSet.getString("SECTIONNAME"));
				dataMap.put("ISSELECTED", resultSet.getString("ISSELECTED"));
				dataMap.put("DESCRIPTION", resultSet.getString("DESCRIPTION"));
				
				dataList.add(dataMap);
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		//System.out.println(dataList);
		return dataList;
	}	
	
	@SuppressWarnings("resource")
	public String assignSectionsToRole(String role, String selectedSections){
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		String result = null;
		//System.out.println(selectedSections);
		String sectionsList = selectedSections.substring(0, selectedSections.length()-1);
		//System.out.println(sectionsList);
		
		try{
				String query1 = "DELETE FROM "+schemaName+"TB_ROBOSCANCONFIG WHERE ROLEID = ? ";
				preparedStatement = connection.prepareStatement(query1);
				preparedStatement.setString(1, role);
				preparedStatement.executeQuery();
				
				String query2 = "INSERT INTO "+schemaName+"TB_ROBOSCANCONFIG "+
								"VALUES (?,?,?, SYSTIMESTAMP)";
				preparedStatement = connection.prepareStatement(query2);
				preparedStatement.setString(1, role);
				preparedStatement.setString(2, sectionsList);
				preparedStatement.setString(3, role);
				preparedStatement.executeQuery();
				result = "Sections have been assigned to "+role+" successfully.";
		}catch(Exception e){
			e.printStackTrace();
			result = "Error while assigning sections to "+role;
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, null, null);
		}
		//System.out.println(result);
		return result;
	}
}

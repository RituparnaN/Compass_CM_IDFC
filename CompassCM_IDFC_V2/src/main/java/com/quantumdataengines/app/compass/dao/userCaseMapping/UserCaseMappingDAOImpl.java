package com.quantumdataengines.app.compass.dao.userCaseMapping;

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

@Repository
public class UserCaseMappingDAOImpl implements UserCaseMappingDAO{

	@Autowired
	private ConnectionUtil connectionUtil;
	
	@Value("${compass.aml.config.schemaName}")
	private String schemaName;
	
	@Override
	public List<Map<String, String>> getUserDetailsForUserCaseMapping(String userRole){
		List<Map<String, String>> dataList = new LinkedList<Map<String,String>>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		
		String sql = "SELECT A.USERCODE USERCODE, A.FIRSTNAME ||' '|| A.LASTNAME OPTIONVALUE , "+
					 "		 NVL(C.PERCENTAGE,0) PERCENTAGE, CASE WHEN C.USERCODE IS NULL THEN 'N' ELSE 'Y' END ISENABLED, "+
					 "		 NVL(C.PERCENTAGE_PENDING,0) PERCENTAGE_PENDING, "+
					 "		 DECODE(C.STATUS, 'P', 'Pending', 'A', 'Approved', 'R', 'Rejected') STATUS "+
					 "  FROM TB_USER A "+
					 " INNER JOIN TB_USERROLEMAPPING B ON A.USERCODE = B.USERCODE "+
					 "  LEFT OUTER JOIN "+schemaName+"TB_AMLUSER_CASEDISTRIBUTION C ON A.USERCODE = C.USERCODE "+ 
					 " WHERE B.ROLEID LIKE ?||'%' "+
					 "	ORDER BY C.STATUS ";
		try{
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, userRole);
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()){
				Map<String,String> dataMap = new HashMap<String, String>();
				dataMap.put("USERCODE", resultSet.getString("USERCODE"));
				dataMap.put("PERCENTAGE", resultSet.getString("PERCENTAGE"));
				dataMap.put("PERCENTAGE_PENDING", resultSet.getString("PERCENTAGE_PENDING"));
				dataMap.put("ISENABLED", resultSet.getString("ISENABLED"));
				dataMap.put("STATUS", resultSet.getString("STATUS"));
				
				dataList.add(dataMap);
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return dataList;
	}
	
	@SuppressWarnings("resource")
	public String saveUserCaseAssignment(String fullData, String makerComments, String currentUser, String currentRole, String ipAddress){
		List<List<String>> mainList = new Vector<List<String>>();
		String status = "P";
		String[] arrStr = CommonUtil.splitString(fullData, ";");
		for(String strData : arrStr){
			String[] arrData1 = CommonUtil.splitString(strData, ",");
			if(arrData1.length == 2){
				List<String> dataList = new Vector<String>();
				for(String strData1 : arrData1)
					dataList.add(strData1);
				mainList.add(dataList);
				// System.out.println("mainList="+mainList);
			}
		}
		String result = "";
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		
		try{
			//Fetching Usercode and Count
			ResultSet resultSet = null;
			Map<String, String> dataMap = new LinkedHashMap<String, String>();
			
			String sql = "SELECT USERCODE, PERCENTAGE FROM "+schemaName+"TB_AMLUSER_CASEDISTRIBUTION "+
		          	 	 " WHERE USERCODE = ? ";
			preparedStatement= connection.prepareStatement(sql);
			for(List<String> list : mainList){
				preparedStatement.setString(1, list.get(0));
				resultSet = preparedStatement.executeQuery();
				while(resultSet.next()){
					dataMap.put(resultSet.getString("USERCODE"), resultSet.getString("PERCENTAGE"));
				}
			}
			//System.out.println("dataMap = "+dataMap);
			
			//Deleting record
			sql = "DELETE FROM "+schemaName+"TB_AMLUSER_CASEDISTRIBUTION "+
			      " WHERE USERCODE = ? ";
			preparedStatement= connection.prepareStatement(sql);
			for(List<String> list : mainList){
				preparedStatement.setString(1, list.get(0));
				preparedStatement.addBatch();
			}
			preparedStatement.executeBatch();
			
			//Inserting record
			sql =   " INSERT INTO "+schemaName+"TB_AMLUSER_CASEDISTRIBUTION ( "+
					" 			USERCODE, PERCENTAGE, PERCENTAGE_PENDING, STATUS, UPDATEDBYUSERCODE,  "+
					" 			UPDATEDBYUSERROLE, IPADDRESS, UPDATETIMESTAMP, MAKERCODE, MAKERTIMESTAMP, "+
					" 			MAKERCOMMENTS, CHECKERCODE, CHECKERTIMESTAMP, CHECKERCOMMENTS ) "+
				  
					" VALUES (?, ?, ?, ?, ?, "+
					"		  ?, ?, SYSTIMESTAMP, ?, SYSTIMESTAMP, "+
					"		  ?, ?, ?, ? ) ";
			preparedStatement= connection.prepareStatement(sql);
			for(List<String> list : mainList){
				preparedStatement.setString(1, list.get(0));
				preparedStatement.setString(2, dataMap.get(list.get(0)));
				preparedStatement.setString(3, list.get(1));
				preparedStatement.setString(4, status);
				preparedStatement.setString(5, currentUser);
				preparedStatement.setString(6, currentRole);
				preparedStatement.setString(7, ipAddress);
				preparedStatement.setString(8, currentUser);
				preparedStatement.setString(9, makerComments);
				preparedStatement.setString(10, "");
				preparedStatement.setString(11, "");
				preparedStatement.setString(12, "");
				preparedStatement.addBatch();
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

	@Override
	public String approveOrRejectUserCaseAssignment(String fullData, String action, String checkerComments, String currentUser,
			String currentRole, String ipAddress) {

		//System.out.println("approveOrRejectUserCaseAssignment:  ");
		
		List<List<String>> mainList = new Vector<List<String>>();
		String status = "";
		String[] arrStr = CommonUtil.splitString(fullData, ";");
		for(String strData : arrStr){
			String[] arrData1 = CommonUtil.splitString(strData, ",");
			if(arrData1.length == 3){
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
			
			String sql =    " UPDATE "+schemaName+"TB_AMLUSER_CASEDISTRIBUTION SET "+
							" 			PERCENTAGE = ?, PERCENTAGE_PENDING = ?, STATUS = ?, UPDATEDBYUSERCODE = ?,  "+
							" 			UPDATEDBYUSERROLE = ?, IPADDRESS = ?, UPDATETIMESTAMP = SYSTIMESTAMP, CHECKERCODE = ?, "+
							" 			CHECKERTIMESTAMP = SYSTIMESTAMP, CHECKERCOMMENTS = ? "+
							" WHERE USERCODE = ? ";
			if(("A").equals(action)) {
				status = "A";
				preparedStatement= connection.prepareStatement(sql);
				for(List<String> list : mainList){
					preparedStatement.setString(1, list.get(2));
					preparedStatement.setString(2, "");
					preparedStatement.setString(3, status);
					preparedStatement.setString(4, currentUser);
					preparedStatement.setString(5, currentRole);
					preparedStatement.setString(6, ipAddress);
					preparedStatement.setString(7, currentUser);
					preparedStatement.setString(8, checkerComments);
					preparedStatement.setString(9, list.get(0));
					preparedStatement.addBatch();
				}
				preparedStatement.executeBatch();
				result = "Records approved successfully.";
				
			}else if(("R").equals(action)){
				status = "R";
				preparedStatement= connection.prepareStatement(sql);
				for(List<String> list : mainList){
					preparedStatement.setString(1, list.get(1));
					preparedStatement.setString(2, "");
					preparedStatement.setString(3, status);
					preparedStatement.setString(4, currentUser);
					preparedStatement.setString(5, currentRole);
					preparedStatement.setString(6, ipAddress);
					preparedStatement.setString(7, currentUser);
					preparedStatement.setString(8, checkerComments);
					preparedStatement.setString(9, list.get(0));
					preparedStatement.addBatch();
				}
				preparedStatement.executeBatch();
				result = "Records rejected successfully.";
				
			}
			sql =   " INSERT INTO "+schemaName+"TB_AMLUSER_CASEDISTRI_AUDILOG "+
			        " SELECT A.* FROM "+schemaName+"TB_AMLUSER_CASEDISTRIBUTION A ";
			//System.out.println("sql:  "+sql);
			preparedStatement= connection.prepareStatement(sql);
			preparedStatement.executeUpdate();
			//System.out.println("Executed:  "+sql);
			
		}catch(Exception e){
			e.printStackTrace();
			result = "Error while approval/rejection.";
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, null, null);
		}
		return result;
	}
}

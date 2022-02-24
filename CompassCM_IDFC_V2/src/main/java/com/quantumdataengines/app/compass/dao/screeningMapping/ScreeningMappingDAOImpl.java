package com.quantumdataengines.app.compass.dao.screeningMapping;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
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
public class ScreeningMappingDAOImpl implements ScreeningMappingDAO{
	
	@Autowired
	private ConnectionUtil connectionUtil;
	
	@Value("${compass.aml.config.schemaName}")
	private String schemaName;
	
	public List<Map<String, String>> getListData(){
		List<Map<String, String>> dataList = new ArrayList<Map<String, String>>();
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String sql = "SELECT LISTCODE,  LISTCODE AS LISTNAME "+ 
					 "  FROM "+schemaName+"TB_EXCEPTIONLISTMASTER "+
					 " WHERE 1=1 "+
					 "   AND (LISTCODE NOT LIKE 'MT%' OR LISTTYPE IN ('BLACKLIST','SELECTEDBLACKLIST') ) ";
		try{
			connection = connectionUtil.getConnection();
			preparedStatement = connection.prepareStatement(sql);
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()){
				Map<String, String> dataMap = new HashMap<String, String>();
				dataMap.put("LISTCODE", resultSet.getString("LISTCODE"));
				dataMap.put("LISTNAME", resultSet.getString("LISTNAME"));
				dataList.add(dataMap);
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return dataList;
	}
	
	public Map<String, String> middleFrame(String sourceList, String destinationList){
		Map<String, String> dataMap = new LinkedHashMap<String, String>();
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String sql = "SELECT SOURCELISTCODE, SEARCHLISTCODE, SEARCHLEVEL, ISENABLE "+
	                 "  FROM "+schemaName+"TB_EXCEPTIONLISTCODEMAPPING "+
	                 " WHERE SOURCELISTCODE= ? "+
				     "   AND SEARCHLISTCODE= ? " ;
		try{
			connection = connectionUtil.getConnection();
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, sourceList);
			preparedStatement.setString(2, destinationList);
			resultSet = preparedStatement.executeQuery();
			if(resultSet.next()){
				dataMap.put("ISENABLE", resultSet.getString("ISENABLE"));
				dataMap.put("SOURCELISTCODE", resultSet.getString("SOURCELISTCODE"));
				dataMap.put("SEARCHLISTCODE", resultSet.getString("SEARCHLISTCODE"));
				dataMap.put("SEARCHLEVEL", resultSet.getString("SEARCHLEVEL"));
			}else{
				dataMap.put("ISENABLE", "0");
				dataMap.put("SOURCELISTCODE", sourceList);
				dataMap.put("SEARCHLISTCODE", destinationList);
				dataMap.put("SEARCHLEVEL", "");
			}
		}catch(Exception e ){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return dataMap;
	}
	
	@SuppressWarnings({ "resource", "null" })
	public String updateScreeningMapping(String chkbox, String sourceList, String destinationList,
											String mappingLevel, String userCode){		
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		String result = "";
		ResultSet resultSet = null;
		String sql = "";
		int count = 0;
		int mappingCode = 0;
		try{
			sql = "SELECT COUNT(*) MAPPINGCOUNT "+
				  "  FROM "+schemaName+"TB_EXCEPTIONLISTCODEMAPPING "+
				  " WHERE  SOURCELISTCODE = ? " +
				  "  AND SEARCHLISTCODE = ? ";
			connection = connectionUtil.getConnection();
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, sourceList);
			preparedStatement.setString(2, destinationList);
			resultSet = preparedStatement.executeQuery();
			if(resultSet.next()){
				count = resultSet.getInt("MAPPINGCOUNT");
			}
			
			if(count == 0){					
				sql = "SELECT MAX(MAPPINGCODE)+1  MAXMAPPINGCODE FROM "+schemaName+"TB_EXCEPTIONLISTCODEMAPPING ";
				preparedStatement = connection.prepareStatement(sql);
				resultSet = preparedStatement.executeQuery();
				if(resultSet.next()){
					mappingCode = resultSet.getInt("MAXMAPPINGCODE");
				}
				
				sql = "INSERT INTO "+schemaName+"TB_EXCEPTIONLISTCODEMAPPING(MAPPINGCODE, SOURCELISTCODE, SEARCHLISTCODE, "+
					  "		  SEARCHLEVEL, UPDATETIMESTAMP, UPDATEDBY, ISENABLE) "+
					  "VALUES (?,?,?,?,SYSTIMESTAMP,?,?) ";
				preparedStatement = connection.prepareStatement(sql);
				preparedStatement.setString(1, new Integer(mappingCode).toString());
				preparedStatement.setString(2, sourceList);
				preparedStatement.setString(3, destinationList);
				preparedStatement.setString(4, mappingLevel);
				preparedStatement.setString(5, userCode);
				preparedStatement.setString(6, chkbox);
				resultSet = preparedStatement.executeQuery();
				
			}else{
				sql = "UPDATE "+schemaName+"TB_EXCEPTIONLISTCODEMAPPING "+
					  "   SET SEARCHLEVEL = ?, ISENABLE = ?, "+
					  "       UPDATETIMESTAMP = SYSTIMESTAMP, UPDATEDBY = ? "+
					  " WHERE SOURCELISTCODE = ? AND SEARCHLISTCODE = ? ";
				preparedStatement = connection.prepareStatement(sql);
				preparedStatement.setString(1, mappingLevel);
				preparedStatement.setString(2, chkbox);
				preparedStatement.setString(3, userCode);
				preparedStatement.setString(4, sourceList);
				preparedStatement.setString(5, destinationList);
				preparedStatement.executeUpdate();
				result = "Updated Successfully";
			}
		}catch(Exception e){
			e.printStackTrace();
			result = "Error while updating";
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return result;
	}
	
	@SuppressWarnings("resource")
	public String deleteScreeningMapping(String sourceList, String destinationList){
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String result = "";
		int mappingCodeToDel = 0;
		try{
			String sql = "SELECT MAPPINGCODE "+
						 "  FROM "+schemaName+"TB_EXCEPTIONLISTCODEMAPPING "+
						 " WHERE SOURCELISTCODE = ? AND SEARCHLISTCODE = ? ";
			connection = connectionUtil.getConnection();
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, sourceList);
			preparedStatement.setString(2, destinationList);
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()){
				mappingCodeToDel = resultSet.getInt("MAPPINGCODE");
			}
			sql = "DELETE FROM "+schemaName+"TB_EXCEPTIONLISTCODEMAPPING "+
						 " WHERE SOURCELISTCODE = ? AND SEARCHLISTCODE = ? ";
		
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, sourceList);
			preparedStatement.setString(2, destinationList);
			preparedStatement.executeUpdate();
			
			sql = "DELETE FROM "+schemaName+"TB_EXCEPTIONLISTFIELDSMAPPING "+
					 " WHERE MAPPINGCODE = ? ";
	
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setInt(1, mappingCodeToDel);
			preparedStatement.executeUpdate();
			result = "Deleted successfully";

		}catch(Exception e){
			e.printStackTrace();
			result = "Error while deleting";
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, null, null);
		}
		return result;
	}
	
	public List<Map<String, String>> bottomFrame(String sourceList, String destinationList){
		List<Map<String, String>> dataList = new Vector<Map<String,String>>();
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String sql = "SELECT ROWNUM AS ROWPOSITION, X.* FROM ( "+
	                 "SELECT A.*, CASE WHEN TRIM(C.SCORE) IS NOT NULL THEN 'true' ELSE 'false' END ISCHECKED, "+
	                 "            CASE WHEN TRIM(C.SCORE) IS NOT NULL THEN ''||C.SCORE ELSE '90' END SCORERANK FROM "+
	                 " ( "+
	                 "SELECT A.LISTCODE IMPORTLIST, A.FIELDNAME IMPORTFIELD, B.LISTCODE SCREENLIST, "+
	                 "       B.FIELDNAME SCREENFIELD, A.CATEGORY IMPORTCATEGORY, B.CATEGORY SCREENCATEGORY "+
				     "  FROM "+schemaName+"TB_EXCEPTIONLISTFIELDSINFO A , "+schemaName+"TB_EXCEPTIONLISTFIELDSINFO B "+ 
				     " WHERE A.LISTCODE= ? "+
				     "   AND B.LISTCODE= ? "+
	                 "   And A.CATEGORY IN ('name','address') "+
				     "   AND A.CATEGORY = B.CATEGORY "+
				     " Order By A.CATEGORY, A.ListCode ) A   "+
					 " LEFT OUTER JOIN "+schemaName+"TB_EXCEPTIONLISTCODEMAPPING B ON A.IMPORTLIST = B.SOURCELISTCODE AND A.SCREENLIST = B.SEARCHLISTCODE "+
	                 " LEFT OUTER JOIN "+schemaName+"TB_EXCEPTIONLISTFIELDSMAPPING C ON B.MAPPINGCODE = C.MAPPINGCODE "+
	                 "   AND A.IMPORTFIELD = C.SOURCEFIELD AND A.SCREENFIELD = C.SEARCHFIELD ) X ORDER BY ISCHECKED DESC, IMPORTFIELD ASC ";
		
		try{
			connection = connectionUtil.getConnection();
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, sourceList);
			preparedStatement.setString(2, destinationList);
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()){
				Map<String, String> dataMap = new LinkedHashMap<String, String>();
				dataMap.put("ISCHECKED", resultSet.getString("ISCHECKED"));
				dataMap.put("IMPORTLIST", resultSet.getString("IMPORTLIST"));
				dataMap.put("IMPORTFIELD", resultSet.getString("IMPORTFIELD"));
				dataMap.put("SCREENLIST", resultSet.getString("SCREENLIST"));
				dataMap.put("SCREENFIELD", resultSet.getString("SCREENFIELD"));
				dataMap.put("SCORERANK", resultSet.getString("SCORERANK"));
				
			dataList.add(dataMap);
			}
		}catch(Exception e ){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return dataList;
	}

	@SuppressWarnings("resource")
	public String updateFieldScreeningMapping(String fullData, String userCode){ 
		List<Map<String, String>> dataList = new ArrayList<Map<String, String>>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String sourceList = "";
		String destinationList = "";
		String sql = "";
		String result = "";
		int mappingCode = 0;
		int serialNo = 0;
		
		String[] arrRecords = CommonUtil.splitString(fullData, ";");		
		for(String strRecord : arrRecords){
			String[] arrFields = CommonUtil.splitString(strRecord, ",");			
			Map<String, String> dataMap = new LinkedHashMap<String, String>();
			for(String strField : arrFields){
				String[] arrData = CommonUtil.splitString(strField, "=");
				if(arrData.length == 2){
					dataMap.put(arrData[0], arrData[1]);
				}
			}
			if(dataMap.size()>0)
				dataList.add(dataMap);
		}
		
		if(dataList.size() > 0){
			sourceList = dataList.get(0).get("sourceList");
			destinationList = dataList.get(0).get("destinationList");
			try{
				sql = "SELECT MAPPINGCODE FROM "+schemaName+"TB_EXCEPTIONLISTCODEMAPPING "+
					  " WHERE SOURCELISTCODE = ? AND SEARCHLISTCODE = ? ";
				preparedStatement = connection.prepareStatement(sql);
				preparedStatement.setString(1, sourceList);
				preparedStatement.setString(2, destinationList);
				resultSet = preparedStatement.executeQuery();
				if(resultSet.next()){
					mappingCode = resultSet.getInt("MAPPINGCODE");
				}
				sql = "DELETE FROM "+schemaName+"TB_EXCEPTIONLISTFIELDSMAPPING "+
					  " WHERE MAPPINGCODE = ? ";
				preparedStatement = connection.prepareStatement(sql);
				preparedStatement.setInt(1, mappingCode);
				preparedStatement.executeUpdate();
				result = "Deleted";
				
				sql = "SELECT MAX(SERIALNO) SERIALNO FROM "+schemaName+"TB_EXCEPTIONLISTFIELDSMAPPING";
				preparedStatement = connection.prepareStatement(sql);
				resultSet = preparedStatement.executeQuery();
				if(resultSet.next()){
					serialNo = resultSet.getInt("SERIALNO"); 
				}
				sql = "INSERT INTO "+schemaName+"TB_EXCEPTIONLISTFIELDSMAPPING(SERIALNO, MAPPINGCODE, SOURCEFIELD, "+
					  "		  SEARCHFIELD, SCORE, UPDATETIMESTAMP, UPDATEDBY) "+
					  "VALUES (?,?,?,?,?,SYSTIMESTAMP,?) ";
				preparedStatement = connection.prepareStatement(sql);
				for(Map<String, String> serialNoMap : dataList){
					serialNo = serialNo + 1;
					preparedStatement.setInt(1, serialNo);
					preparedStatement.setInt(2, mappingCode);
					preparedStatement.setString(3, serialNoMap.get("sourceField"));
					preparedStatement.setString(4, serialNoMap.get("destinationField"));
					preparedStatement.setString(5, serialNoMap.get("rank"));
					preparedStatement.setString(6, userCode);
					preparedStatement.addBatch();
				}
				preparedStatement.executeBatch();
				result = "Updated successfully.";
			}catch(Exception e){
				e.printStackTrace();
			}finally{
				connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
			}
		}else{
			result = "Select atleast one checkbox to update.";
		}
		
		return result;
	}

	
}

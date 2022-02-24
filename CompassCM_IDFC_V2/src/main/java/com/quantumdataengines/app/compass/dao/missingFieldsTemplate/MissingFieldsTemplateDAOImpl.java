package com.quantumdataengines.app.compass.dao.missingFieldsTemplate;

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
public class MissingFieldsTemplateDAOImpl implements MissingFieldsTemplateDAO{

	@Autowired
	private ConnectionUtil connectionUtil;
	
	@Value("${compass.aml.config.schemaName}")
	private String schemaName;
	
	@SuppressWarnings("resource")
	public Map<String,Map<String, String>> getRequiredFields(){
		Map<String,Map<String, String>> mainMap = new LinkedHashMap<String, Map<String,String>>();
		Map<String, String> fieldsMap = new HashMap<String, String>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		
		try{
			String sql = " SELECT PRODUCTCODE, DESCRIPTION FROM "+schemaName+"TB_PRODUCTSMASTER ";
			preparedStatement = connection.prepareStatement(sql);
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()){
				fieldsMap.put(resultSet.getString("PRODUCTCODE"), resultSet.getString("DESCRIPTION"));
			}
			mainMap.put("PRODUCT",fieldsMap);
			
			fieldsMap = new HashMap<String, String>();
			sql = " SELECT CUSTOMERTYPE, DESCRIPTION FROM "+schemaName+"TB_CUSTOMERTYPEMASTER ";
			preparedStatement = connection.prepareStatement(sql);
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()){
				fieldsMap.put(resultSet.getString("CUSTOMERTYPE"), resultSet.getString("DESCRIPTION"));
			}
			mainMap.put("CUSTOMER",fieldsMap);
			
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
	return mainMap;
	}
	
	@Override
	public Map<String, Object> searchMissingFields(String templateId, String templateName, String productCode, String custType, 
														  String isEnabled) {
		Map<String, Object> resultMap = new HashMap<String, Object>();		
		List<Map<String, String>> mainList = new Vector<Map<String,String>>();
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String sql= "";
		int count = 0;
		
		try{
			sql= "SELECT TEMPLATEID, TEMPLATENAME, PRODUCTCODE, CUSTOMERTYPE, ISENABLED, "+
                 "      FUN_DATETOCHAR(UPDATETIMESTAMP) UPDATEDON, A.UPDATEDBY UPDATEDBY "+ 
		         " FROM "+schemaName+"TB_MMLISTMASTER A "+
		         "WHERE 1=1 ";

			if(templateId != null && templateId.length()>0)
				//sql = sql + " AND TEMPLATEID = '"+templateId+"' ";
				sql = sql + " AND TEMPLATEID = ? ";
			if(templateName != null && templateName.length()>0)
				//sql = sql + " AND TEMPLATENAME = '"+templateName+"' ";
				sql = sql + " AND TEMPLATENAME = ? ";
			if(productCode != null && productCode.length()>0 && !productCode.equalsIgnoreCase("ALL"))
				//sql = sql + " AND PRODUCTCODE = '"+productCode+"' ";
				sql = sql + " AND PRODUCTCODE = ? ";
			if(custType != null && custType.length()>0 && !custType.equalsIgnoreCase("ALL"))
				//sql = sql + " AND CUSTOMERTYPE = '"+custType+"' ";
				sql = sql + " AND CUSTOMERTYPE = ? ";
			if(isEnabled != null && isEnabled.length()>0)
				//sql = sql + " AND ISENABLED = '"+isEnabled+"' ";
				sql = sql + " AND ISENABLED = '"+isEnabled+"' ";
			
			connection = connectionUtil.getConnection();
			preparedStatement = connection.prepareStatement(sql);
			if(templateId != null && templateId.length()>0){
				preparedStatement.setString(count, templateId);
				count++;
			}
			if(templateName != null && templateName.length()>0){
				preparedStatement.setString(count, templateName);
				count++;
			}
			if(productCode != null && productCode.length()>0 && !productCode.equalsIgnoreCase("ALL")){
				preparedStatement.setString(count, productCode);
				count++;
			}
			if(custType != null && custType.length()>0 && !custType.equalsIgnoreCase("ALL")){
				preparedStatement.setString(count, custType);
				count++;
			}
			if(isEnabled != null && isEnabled.length()>0){
				preparedStatement.setString(count, isEnabled);
				count++;
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

	@Override
	@SuppressWarnings("resource")
	public Map<String, Object> addMissingFieldsTemplate(String templateId, String templateName, String productCode, String custType, 
			String isEnabled, String userCode, String CURRENTROLE) {
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			String sql= "SELECT "+schemaName+"KYC_MISSING_TEMPLATESEQ.NEXTVAL AS COUNTVAL FROM DUAL ";
			preparedStatement = connection.prepareStatement(sql);
			resultSet = preparedStatement.executeQuery();
			if(resultSet.next()){
				templateId = new Integer (resultSet.getInt("COUNTVAL")).toString(); 
			}
			
			sql= "INSERT INTO "+schemaName+"TB_MMLISTMASTER("+
			     "       TEMPLATEID, TEMPLATENAME, PRODUCTCODE, CUSTOMERTYPE, "+
				 "		 ISENABLED, UPDATETIMESTAMP, UPDATEDBY ) "+
				 "VALUES (? ,?,?,?,?, SYSTIMESTAMP,?) ";
				 
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, templateId);
			preparedStatement.setString(2, templateName);
			preparedStatement.setString(3, productCode);
			preparedStatement.setString(4, custType);
			preparedStatement.setString(5, isEnabled);
			preparedStatement.setString(6, userCode);
			preparedStatement.executeUpdate();
		}catch(Exception e){
			e.printStackTrace();	
		}finally{
			connectionUtil.closeResources(connection, preparedStatement,resultSet,null);		
		}
	return searchMissingFields(templateId, "", "", "", "");
	}

	@Override
	public Map<String,String> fetchMissingFieldsToUpdate(String selectedTempId, String selectedTempName, String	selectedProductCode,
									String selectedCustomerType, String selectedIsEnabled){
		Map<String, String> screeningExceptionMap = new HashMap<String, String>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			String sql = "SELECT A.TEMPLATEID, A.TEMPLATENAME, A.PRODUCTCODE, "+ 
						 "       A.CUSTOMERTYPE, A.ACCOUNTSTATUS, A.ISENABLED "+
						 "  FROM "+schemaName+"TB_MMLISTMASTER A "+
						 " WHERE A.TEMPLATEID = ? " ;
		
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, selectedTempId);
			resultSet = preparedStatement.executeQuery();
			if(resultSet.next()){
			screeningExceptionMap.put("TEMPLATEID", resultSet.getString("TEMPLATEID"));
			screeningExceptionMap.put("TEMPLATENAME", resultSet.getString("TEMPLATENAME"));
			screeningExceptionMap.put("PRODUCTCODE", resultSet.getString("PRODUCTCODE"));
			screeningExceptionMap.put("CUSTOMERTYPE", resultSet.getString("CUSTOMERTYPE"));
			screeningExceptionMap.put("ISENABLED", resultSet.getString("ISENABLED"));
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return screeningExceptionMap; 
		}

	public String updateMissingFields(String templateId, String templateName, String productCode, String custType, 
			String isEnabled, String userCode, String CURRENTROLE){
		String result;
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			String sql = "UPDATE "+schemaName+"TB_MMLISTMASTER A "+
					 	 "   SET A.TEMPLATENAME = ?, A.PRODUCTCODE = ?, "+
					 	 "		 A.CUSTOMERTYPE = ?, A.ISENABLED = ?, "+
					 	 " 		 A.UPDATETIMESTAMP = SYSTIMESTAMP, A.UPDATEDBY = ? "+
					 	 " WHERE A.TEMPLATEID = ? ";
			connection = connectionUtil.getConnection();
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, templateName);
			preparedStatement.setString(2, productCode);
			preparedStatement.setString(3, custType);
			preparedStatement.setString(4, isEnabled);
			preparedStatement.setString(5, userCode);
			preparedStatement.setString(6, templateId);
			preparedStatement.executeUpdate();
			result = "Missing Fields Updated Successfully.";
		}catch(Exception e){
			e.printStackTrace();
			result = "Error while updating.";
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return result;
	}

	@Override
	public Map<String, Object> searchAddFieldsToTemplate(String template, String detailType) {
		Map<String, Object> resultMap = new HashMap<String, Object>();		
		List<Map<String, String>> mainList = new Vector<Map<String,String>>();
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String sql= "";
		try{
			sql= "SELECT A.* FROM (SELECT A.* FROM ( "+ 
				 "SELECT B.TEMPLATEID, A.TABLENAME, A.FIELDNAME, A.SCREENNAME, "+ 
				 "       A.DISPLAYLABEL, NVL(B.COMPLIANCESCORE,'1') COMPLIANCESCORE, "+ 
				 "       CASE WHEN TRIM(B.FIELDNAME) IS NULL THEN 'false' ELSE 'true' END AS ISCHECKED, COLUMNID "+ 
				 "  FROM "+schemaName+"TB_MMLISTFIELDS A "+
				 "  LEFT OUTER JOIN "+schemaName+"TB_MMLISTDETAIL B ON A.TABLENAME = B.TABLENAME AND A.FIELDNAME = B.FIELDNAME "+ 
			   //"  AND B.TEMPLATEID = '"+template+"' "+
			   //" WHERE A.TABLENAME =  '"+detailType+"' ) "+
				 "  AND B.TEMPLATEID = ? "+
				 " WHERE A.TABLENAME =  ? ) "+
				 " A ORDER BY ISCHECKED DESC, COLUMNID ASC ) A ";

			connection = connectionUtil.getConnection();
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, template);
			preparedStatement.setString(2, detailType);
			resultSet = preparedStatement.executeQuery();
			
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
			connectionUtil.closeResources(connection, preparedStatement,resultSet,null);		
		}
	return resultMap;
	}

	@SuppressWarnings("resource")
	public String updateComplianceScore(String fullData, String searchTemplate, String detailType){
		String result;
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			String sql = "DELETE FROM "+schemaName+"TB_MMLISTDETAIL A "+
						 " WHERE A.TEMPLATEID = ? "+
						 "   AND A.TABLENAME = ? ";
			preparedStatement =connection.prepareStatement(sql);
			preparedStatement.setString(1, searchTemplate);
			preparedStatement.setString(2, detailType);
			preparedStatement.executeUpdate();
			
			sql = "INSERT INTO "+schemaName+"TB_MMLISTDETAIL ( "+
				  "		  TEMPLATEID, TABLENAME, FIELDNAME, "+
				  "		  SCREENNAME, DISPLAYLABEL, COMPLIANCESCORE) "+
				  " VALUES(?,?,?,?,?,?) " ;
			preparedStatement =connection.prepareStatement(sql);
			String[] arrData = CommonUtil.splitString(fullData, ";");
			for(String strData : arrData){
				String[] arrData1 = CommonUtil.splitString(strData, ",");
				if(arrData1.length == 3){
					preparedStatement.setString(1, searchTemplate);
					preparedStatement.setString(2, arrData1[0]);
					preparedStatement.setString(3, arrData1[1]);
					preparedStatement.setString(4, arrData1[0]);
					preparedStatement.setString(5, arrData1[1]);
					preparedStatement.setString(6, arrData1[2]);
					preparedStatement.addBatch();
				}
			}
			preparedStatement.executeBatch();
			result = "Missing Fields Updated Successfully.";
		}catch(Exception e){
			e.printStackTrace();
			result = "Error while updating.";
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, null, null);
		}
		return result;
	}
}

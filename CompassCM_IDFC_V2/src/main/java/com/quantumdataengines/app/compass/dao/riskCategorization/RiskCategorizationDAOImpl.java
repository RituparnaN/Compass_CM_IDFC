package com.quantumdataengines.app.compass.dao.riskCategorization;

import java.sql.CallableStatement;
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
public class RiskCategorizationDAOImpl implements RiskCategorizationDAO{
	
	@Autowired
	private ConnectionUtil connectionUtil;
	
	@Value("${compass.aml.config.schemaName}")
	private String schemaName;
	
	public List<Map<String, String>> getRiskParameterList(){
		List<Map<String, String>> riskParameterList = new Vector<Map<String, String>>();
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			String sql = "SELECT RISKPARAMETERID, RISKPARAMETERNAME, RISKPARAMETERWEIGHTAGE, "+
					 	 "		 ISRISKPARAMETERMARKED, ISFROMTOREQ "+
					 	 "  FROM "+schemaName+"TB_RISKPARAMETERS "+
					 	 "ORDER BY RISKPARAMETERID ASC ";
			connection = connectionUtil.getConnection();
			preparedStatement = connection.prepareStatement(sql);
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()){				
				Map<String, String> riskParameterMap = new HashMap<String, String>();
				riskParameterMap.put("RISKPARAMETERID", resultSet.getString("RISKPARAMETERID"));
				riskParameterMap.put("RISKPARAMETERNAME", resultSet.getString("RISKPARAMETERNAME"));
				riskParameterMap.put("RISKPARAMETERWEIGHTAGE", resultSet.getString("RISKPARAMETERWEIGHTAGE"));
				riskParameterMap.put("ISRISKPARAMETERMARKED", resultSet.getString("ISRISKPARAMETERMARKED"));
				riskParameterMap.put("ISFROMTOREQ", resultSet.getString("ISFROMTOREQ"));
				riskParameterList.add(riskParameterMap);
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return riskParameterList;
	}
	
	public void saveParameterList(String strRiskParameters){
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		String sql = "UPDATE "+schemaName+"TB_RISKPARAMETERS "+
					 "   SET ISRISKPARAMETERMARKED = ? "+
					 " WHERE RISKPARAMETERID = ? ";
		try{
			connection = connectionUtil.getConnection();
			preparedStatement = connection.prepareStatement(sql);
			String[] arrRiskParameters = CommonUtil.splitString(strRiskParameters, ",");
			for(String strRiskParameter : arrRiskParameters){
				if(strRiskParameter.length() > 0){
					String[] arrRiskParameter = CommonUtil.splitString(strRiskParameter, "=");
					preparedStatement.setString(1, arrRiskParameter[1]);
					preparedStatement.setString(2, arrRiskParameter[0]);
					preparedStatement.addBatch();
				}
			}
			preparedStatement.executeBatch();
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, null, null);
		}
	}
	
	public List<Map<String,String>> searchRiskAssignment(String searchParamId){
		List<Map<String, String>> dataList = new Vector<Map<String,String>>();
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String sql = " SELECT SUBPARAMETERCODE, SUBPARAMETERDESCRIPTION, SUBPARAMETERRISKVALUE, PRIORITYRISKVALUE "+ 
					 "	 FROM "+schemaName+"TB_RISKSUBPARAMETERS "+ 
					 "  WHERE RISKPARAMETERID = ? "+
					 " UNION ALL "+
					 " SELECT SUBPARAMETERCODE, SUBPARAMETERDESCRIPTION, SUBPARAMETERRISKVALUE, PRIORITYRISKVALUE "+ 
					 "	 FROM "+schemaName+"TB_RISKRANGEPARAMETERS "+ 
					 "  WHERE RISKPARAMETERID = ? ";

		try{
			connection = connectionUtil.getConnection();
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, searchParamId);
			preparedStatement.setString(2, searchParamId);
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()){
				Map<String, String> dataMap = new LinkedHashMap<String, String>();
				dataMap.put("SUBPARAMETERCODE", resultSet.getString("SUBPARAMETERCODE"));
				dataMap.put("SUBPARAMETERDESCRIPTION", resultSet.getString("SUBPARAMETERDESCRIPTION"));
				dataMap.put("SUBPARAMETERRISKVALUE", resultSet.getString("SUBPARAMETERRISKVALUE"));
				dataMap.put("PRIORITYRISKVALUE", resultSet.getString("PRIORITYRISKVALUE"));
				dataList.add(dataMap);
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return dataList;
	}
	
	public void updateRiskAssignmentValue(String fullData, String paramId){
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		String iSFromToReqValue = "N";
		String sql = "UPDATE "+schemaName+"TB_RISKSUBPARAMETERS "+
					 "	 SET SUBPARAMETERRISKVALUE = ?, PRIORITYRISKVALUE = ? "+
					 " WHERE RISKPARAMETERID = ? "+
					 "   AND SUBPARAMETERCODE = ? ";
		try{
			iSFromToReqValue = fetchISFromToReqValue(paramId) ;
			
			if(iSFromToReqValue.equalsIgnoreCase("Y")){
			sql = "UPDATE "+schemaName+"TB_RISKRANGEPARAMETERS A "+
			   	  "	  SET SUBPARAMETERRISKVALUE = ?, PRIORITYRISKVALUE = ? "+
			   	  " WHERE RISKPARAMETERID = ? "+
				  "   AND SUBPARAMETERCODE = ? ";
			}
			connection  = connectionUtil.getConnection();
			preparedStatement = connection.prepareStatement(sql);
			System.out.println("full data = "+fullData);
			String[] arrFullData = CommonUtil.splitString(fullData, ",");
			for(String strData : arrFullData){
				if(strData.length()>0){
					String[] arrData = CommonUtil.splitString(strData, "=");
					String subRiskParameterValue = arrData[1].split("~")[0];
					String priorityRiskValue = arrData[1].split("~")[1];
					
					preparedStatement.setString(1, subRiskParameterValue);
					preparedStatement.setString(2, priorityRiskValue);
					preparedStatement.setString(3, paramId);
					preparedStatement.setString(4, arrData[0]);
					preparedStatement.addBatch();
				}
			}
			preparedStatement.executeBatch();
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, null, null);
		}
	}
	
	public String fetchISFromToReqValue(String paramId){
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String isFromToReq = "N";
		String sql = "SELECT ISFROMTOREQ "+
					 "  FROM "+schemaName+"TB_RISKPARAMETERS "+
					 " WHERE RISKPARAMETERID = ? ";
		try{
			connection = connectionUtil.getConnection();
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, paramId);
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()){
				isFromToReq = resultSet.getString("ISFROMTOREQ");
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return isFromToReq;
	}
	
	@SuppressWarnings("resource")
	public String saveNewRiskParam(String paramId, String paramCode, String paramDesc, String paramRangeFrom,
									String paramRangeTo, String paramRiskValue,String priorityRiskValue, String userCode){
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String result = "";
		String sql = "INSERT INTO "+schemaName+"TB_RISKRANGEPARAMETERS(RISKPARAMETERID, SUBPARAMETERCODE, "+
					 "		 SUBPARAMETERDESCRIPTION, SUBRISKPARAMETER_FROMVALUE, SUBRISKPARAMETER_TOVALUE, "+
					 "       SUBPARAMETERRISKVALUE, PRIORITYRISKVALUE, UPDATEDBY, UPDATETIMESTAMP) "+
					 "VALUES (?,?,?,?,?,?,?,?,SYSTIMESTAMP) ";
		try{
			connection = connectionUtil.getConnection();
			
		//	connection = connectionUtil.getConnection();
			preparedStatement = connection.prepareStatement(" SELECT "+schemaName+"SEQ_RISKRANGEPARAMETERS.NEXTVAL SEQVAL FROM DUAL ");
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()){
				paramCode = paramCode + "_" + resultSet.getString("SEQVAL");
			}
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setInt(1, Integer.parseInt(paramId));
			preparedStatement.setString(2, paramCode);
			preparedStatement.setString(3, paramDesc);
			preparedStatement.setInt(4, Integer.parseInt(paramRangeFrom));
			preparedStatement.setInt(5, Integer.parseInt(paramRangeTo));
			preparedStatement.setInt(6, Integer.parseInt(paramRiskValue));
			preparedStatement.setInt(7, Integer.parseInt(priorityRiskValue));
			preparedStatement.setString(8, userCode);
			preparedStatement.executeUpdate();
			result = "Added Successfully";
		}catch(Exception e){
			e.printStackTrace();
			result = "Error while adding.";
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return result;
	}
	
	public Map<String, String> fetchParamCodeToDeleteRiskParameter(String searchParamId, String paramCode){
		Map<String, String> dataMap = new HashMap<String, String>();
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String sql = "SELECT RISKPARAMETERID, SUBPARAMETERCODE, SUBPARAMETERDESCRIPTION, SUBRISKPARAMETER_FROMVALUE, "+
					 "		 SUBRISKPARAMETER_TOVALUE, SUBPARAMETERRISKVALUE, PRIORITYRISKVALUE "+
					 "  FROM "+schemaName+"TB_RISKRANGEPARAMETERS "+
					 " WHERE RISKPARAMETERID = ? "+
					 "   AND SUBPARAMETERCODE = ? ";
		try{
			connection = connectionUtil.getConnection();
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, searchParamId);
			preparedStatement.setString(2, paramCode);
			resultSet  = preparedStatement.executeQuery();
			while(resultSet.next()){
				dataMap.put("RISKPARAMETERID", resultSet.getString("RISKPARAMETERID"));
				dataMap.put("SUBPARAMETERCODE", resultSet.getString("SUBPARAMETERCODE"));
				dataMap.put("SUBPARAMETERDESCRIPTION", resultSet.getString("SUBPARAMETERDESCRIPTION"));
				dataMap.put("SUBRISKPARAMETER_FROMVALUE", resultSet.getString("SUBRISKPARAMETER_FROMVALUE"));
				dataMap.put("SUBRISKPARAMETER_TOVALUE", resultSet.getString("SUBRISKPARAMETER_TOVALUE"));
				dataMap.put("SUBPARAMETERRISKVALUE", resultSet.getString("SUBPARAMETERRISKVALUE"));
				dataMap.put("PRIORITYRISKVALUE", resultSet.getString("PRIORITYRISKVALUE"));
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return dataMap;
}
	
	public String deleteNewRiskParam(String paramId, String paramCode){
			Connection connection = null;
			PreparedStatement preparedStatement = null;
			String result = "";
			String sql = "DELETE FROM "+schemaName+"TB_RISKRANGEPARAMETERS "+
						 " WHERE RISKPARAMETERID= ? "+
						 "   AND SUBPARAMETERCODE  = ? ";
			try{
				connection = connectionUtil.getConnection();
				preparedStatement = connection.prepareStatement(sql);
				preparedStatement.setString(1, paramId);
				preparedStatement.setString(2, paramCode);
				preparedStatement.executeUpdate();
				result = "Deleted Successfully";
			}catch(Exception e){
				e.printStackTrace();
				result = "Error while deleting";
			}finally{
				connectionUtil.closeResources(connection, preparedStatement, null, null);
			}
			return result;
	}
	
	public String updateNewRiskParam(String paramId, String paramCode, String paramDesc, String paramRangeFrom,
									String paramRangeTo, String paramRiskValue, String priorityRiskValue, String userCode){
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		String result = "";
		String sql = "UPDATE "+schemaName+"TB_RISKRANGEPARAMETERS "+
					 "   SET SUBPARAMETERDESCRIPTION = ?, SUBRISKPARAMETER_FROMVALUE = ?, "+
					 "       SUBRISKPARAMETER_TOVALUE = ?, SUBPARAMETERRISKVALUE = ? , PRIORITYRISKVALUE = ?, "+
					 "       UPDATEDBY = ?, UPDATETIMESTAMP = SYSTIMESTAMP "+
					 " WHERE RISKPARAMETERID = ? "+
					 "   AND SUBPARAMETERCODE  = ? ";
		try{
			connection = connectionUtil.getConnection();
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, paramDesc);
			preparedStatement.setString(2, paramRangeFrom);
			preparedStatement.setString(3, paramRangeTo);
			preparedStatement.setString(4, paramRiskValue);
			preparedStatement.setNString(5, priorityRiskValue);
			preparedStatement.setString(6, userCode);
			preparedStatement.setString(7, paramId);
			preparedStatement.setString(8, paramCode);
			preparedStatement.executeUpdate();
			result = "Updated Successfully";
		}catch(Exception e){
			e.printStackTrace();
			result = "Error while updating";
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, null, null);
		}
		return result;
}
	
	public void updateParameterWeightageList(String strParameters){
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		String sql = "UPDATE "+schemaName+"TB_RISKPARAMETERS "+
					 "	 SET RISKPARAMETERWEIGHTAGE = ? "+
					 " WHERE RISKPARAMETERID = ? ";
		try{
			connection  = connectionUtil.getConnection();
			preparedStatement = connection.prepareStatement(sql);
			String[] arrStrParameters = CommonUtil.splitString(strParameters, ",");
			for(String strParameter : arrStrParameters){
				if(strParameter.length()>0){
					String[] arrStrParameter = CommonUtil.splitString(strParameter, "=");
					preparedStatement.setString(1, arrStrParameter[1]);
					preparedStatement.setString(2, arrStrParameter[0]);
					preparedStatement.addBatch();
				}
			}
			preparedStatement.executeBatch();
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, null, null);
		}
	}
	
	public String calculateRisk(String userCode, String CURRENTROLE, String ipAddress){
		Connection connection = null;
		CallableStatement callableStatement = null;
		String result = "";
		try{
			connection = connectionUtil.getConnection();
			callableStatement = connection.prepareCall("{CALL "+schemaName+"STP_CALCULATEACCOUNTTRISK(?,?,?)}");
			callableStatement.setString(1, userCode);
			callableStatement.setString(2, CURRENTROLE);
			callableStatement.setString(3, ipAddress);
			callableStatement.execute();
			result = "Risk calculated successfully";
		}catch(Exception e){
			e.printStackTrace();
			result = "Error occured while calculating risk.";
		}finally{
			connectionUtil.closeResources(connection, callableStatement, null, null);
		}
		return result;
	}

	
	@SuppressWarnings("resource")
	public Map<String,Map<String, String>> getRequiredFields(){
		Map<String,Map<String, String>> mainMap = new LinkedHashMap<String, Map<String,String>>();
		Map<String, String> fieldsMap = new HashMap<String, String>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		
		try{
			String sql = " SELECT PRODUCTCODE, PRODUCTCODE||' - '||DESCRIPTION DESCRIPTION FROM "+schemaName+"TB_PRODUCTSMASTER ";
			preparedStatement = connection.prepareStatement(sql);
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()){
				fieldsMap.put(resultSet.getString("PRODUCTCODE"), resultSet.getString("DESCRIPTION"));
			}
			mainMap.put("PRODUCT",fieldsMap);
			
			fieldsMap = new HashMap<String, String>();
			sql = " SELECT CUSTOMERTYPE, CUSTOMERTYPE||' - '||DESCRIPTION DESCRIPTION FROM "+schemaName+"TB_CUSTOMERTYPEMASTER ";
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
	public Map<String, Object> searchRiskParamFields(String templateId, String templateName, String productCode, String custType, 
														  String isEnabled) {
		Map<String, Object> resultMap = new HashMap<String, Object>();		
		List<Map<String, String>> mainList = new Vector<Map<String,String>>();
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String sql= "";
		int count = 0;
		
		try{
			sql= "SELECT TEMPLATEID, TEMPLATENAME, PRODUCTCODE, CUSTOMERTYPE, PRODUCTCODERISKVALUE, CUSTOMERTYPERISKVALUE, "+
                 "       ISENABLED, FUN_DATETOCHAR(UPDATETIMESTAMP) UPDATEDON, A.UPDATEDBY UPDATEDBY "+ 
		         " FROM "+schemaName+"TB_RISKPARAMETERTEMPLATES A WHERE 1=1 ";

			if(templateId != null && templateId.length()>0)
				//sql = sql + " AND TEMPLATEID = '"+templateId+"' ";
				sql = sql + " AND TEMPLATEID = ?";
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
				sql = sql + " AND ISENABLED = ? ";

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
			}
			resultSet = preparedStatement.executeQuery();
			count = 1;
			
			List<String> headers = new Vector<String>();
			ResultSetMetaData resultSetMetaData = resultSet.getMetaData();
			int numberofcols = resultSetMetaData.getColumnCount();
			//for(int count = 1; count <= numberofcols; count++ ){
			for(count = 1; count <= numberofcols; count++ ){
				String colname = resultSetMetaData.getColumnName(count);
				headers.add(colname);
			}
			
			while(resultSet.next()){				
				Map<String, String> dataMap = new LinkedHashMap<String, String>();
				for(String header : headers){
					dataMap.put(header, resultSet.getString(header));
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
	public Map<String, Object> addRiskParamFieldsTemplate(String templateId, String templateName, String productCode, String custType, 
			String productCodeRiskValue, String custTypeRiskValue, String isEnabled, String userCode, String CURRENTROLE) {
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			String sql= "SELECT "+schemaName+"RISKPARAMETERS_TEMPLATESEQ.NEXTVAL AS COUNTVAL FROM DUAL ";
			preparedStatement = connection.prepareStatement(sql);
			resultSet = preparedStatement.executeQuery();
			if(resultSet.next()){
				templateId = new Integer (resultSet.getInt("COUNTVAL")).toString(); 
			}
			
			sql= "INSERT INTO "+schemaName+"TB_RISKPARAMETERTEMPLATES( TEMPLATEID, TEMPLATENAME, PRODUCTCODE, "+
				 "		 CUSTOMERTYPE, PRODUCTCODERISKVALUE, CUSTOMERTYPERISKVALUE, ISENABLED, UPDATETIMESTAMP, UPDATEDBY ) "+
				 "VALUES (? ,?,?,?,?,?,?, SYSTIMESTAMP,?) ";
				 
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, templateId);
			preparedStatement.setString(2, templateName);
			preparedStatement.setString(3, productCode);
			preparedStatement.setString(4, custType);
			preparedStatement.setString(5, productCodeRiskValue);
			preparedStatement.setString(6, custTypeRiskValue);
			preparedStatement.setString(7, isEnabled);
			preparedStatement.setString(8, userCode);
			preparedStatement.executeUpdate();
		}catch(Exception e){
			e.printStackTrace();	
		}finally{
			connectionUtil.closeResources(connection, preparedStatement,resultSet,null);		
		}
	return searchRiskParamFields(templateId, "", "", "", "");
	}

	@Override
	public Map<String,String> fetchRiskParamFieldsToUpdate(String selectedTempId, String selectedTempName, String	selectedProductCode,
									String selectedCustomerType, String selectedIsEnabled){
		Map<String, String> screeningExceptionMap = new HashMap<String, String>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			String sql = "SELECT TEMPLATEID, TEMPLATENAME, PRODUCTCODE, CUSTOMERTYPE, "+ 
						 "      PRODUCTCODERISKVALUE, CUSTOMERTYPERISKVALUE, ACCOUNTSTATUS, ISENABLED "+
						 "  FROM "+schemaName+"TB_RISKPARAMETERTEMPLATES "+
						 " WHERE TEMPLATEID = ? " ;
		
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, selectedTempId);
			resultSet = preparedStatement.executeQuery();
			if(resultSet.next()){
			screeningExceptionMap.put("TEMPLATEID", resultSet.getString("TEMPLATEID"));
			screeningExceptionMap.put("TEMPLATENAME", resultSet.getString("TEMPLATENAME"));
			screeningExceptionMap.put("PRODUCTCODE", resultSet.getString("PRODUCTCODE"));
			screeningExceptionMap.put("CUSTOMERTYPE", resultSet.getString("CUSTOMERTYPE"));
			screeningExceptionMap.put("PRODUCTCODERISKVALUE", resultSet.getString("PRODUCTCODERISKVALUE"));
			screeningExceptionMap.put("CUSTOMERTYPERISKVALUE", resultSet.getString("CUSTOMERTYPERISKVALUE"));
			screeningExceptionMap.put("ISENABLED", resultSet.getString("ISENABLED"));
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return screeningExceptionMap; 
		}

	public String updateRiskParamFields(String templateId, String templateName, String productCode, String custType, 
			String productCodeRiskValue, String custTypeRiskValue, String isEnabled, String userCode, String CURRENTROLE){
		String result;
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			String sql = "UPDATE "+schemaName+"TB_RISKPARAMETERTEMPLATES "+
					 	 "   SET TEMPLATENAME = ?, PRODUCTCODE = ?, "+
					 	 "		 CUSTOMERTYPE = ?, PRODUCTCODERISKVALUE = ?, "+
					 	 "		 CUSTOMERTYPERISKVALUE = ?, ISENABLED = ?, "+
					 	 " 		 UPDATETIMESTAMP = SYSTIMESTAMP, UPDATEDBY = ? "+
					 	 " WHERE TEMPLATEID = ? ";
			connection = connectionUtil.getConnection();
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, templateName);
			preparedStatement.setString(2, productCode);
			preparedStatement.setString(3, custType);
			preparedStatement.setString(4, productCodeRiskValue);
			preparedStatement.setString(5, custTypeRiskValue);
			preparedStatement.setString(6, isEnabled);
			preparedStatement.setString(7, userCode);
			preparedStatement.setString(8, templateId);
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
		String sql= "SELECT A.TEMPLATEID, A.RISKPARAMETER, A.PARAMETERCODE, A.RISKPARAMDISPLAY, A.PARAMETERDESCRIPTION, A.PARAMETERRISKVALUE, A.ISCHECKED "+
		            "  FROM ( SELECT A.* FROM "+
		            " ( "+ 
					" SELECT B.TEMPLATEID, A.TABLENAME RISKPARAMETER, A.FIELDNAME PARAMETERCODE, A.SCREENNAME RISKPARAMDISPLAY,"+  
					"       A.DISPLAYLABEL PARAMETERDESCRIPTION, NVL(B.COMPLIANCESCORE,'1') PARAMETERRISKVALUE, "+ 
					"       CASE WHEN TRIM(B.FIELDNAME) IS NULL THEN 'false' ELSE 'true' END AS ISCHECKED, "+
					"       COLUMNID PARAMETERORDER "+ 
					"  FROM "+schemaName+"TB_RISKPARAMETERTEMPLATEFIELDS A "+
					"  LEFT OUTER JOIN "+schemaName+"TB_RISKPARAMETERTEMPLATEDETAIL B ON A.TABLENAME = B.TABLENAME AND A.FIELDNAME = B.FIELDNAME "+ 
				 //"  AND B.TEMPLATEID = '"+template+"' "+
				 //" WHERE A.TABLENAME =  '"+detailType+"' "+
					"  AND B.TEMPLATEID = ?"+
					" WHERE A.TABLENAME =  ? "+
					" ) A ORDER BY ISCHECKED DESC, PARAMETERORDER ASC "+
					"       ) A ";
		try{
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
	public String updateComplianceScore(String fullData, String searchTemplate){
		String result;
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			String sql = "DELETE FROM "+schemaName+"TB_RISKPARAMETERTEMPLATEDETAIL "+
						 " WHERE TEMPLATEID = ? ";
			preparedStatement =connection.prepareStatement(sql);
			preparedStatement.setString(1, searchTemplate);
			preparedStatement.executeUpdate();
			
			sql = "INSERT INTO "+schemaName+"TB_RISKPARAMETERTEMPLATEDETAIL "+
				  "		  (TEMPLATEID, TABLENAME, FIELDNAME, "+
				  "		  SCREENNAME, DISPLAYLABEL, COMPLIANCESCORE) "+
				  "VALUES (?,?,?,?,?,?) " ;
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

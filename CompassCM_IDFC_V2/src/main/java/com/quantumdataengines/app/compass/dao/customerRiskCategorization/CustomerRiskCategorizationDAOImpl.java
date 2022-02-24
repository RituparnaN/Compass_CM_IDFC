package com.quantumdataengines.app.compass.dao.customerRiskCategorization;

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

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.access.method.P;
import org.springframework.stereotype.Repository;

import com.quantumdataengines.app.compass.util.CommonUtil;
import com.quantumdataengines.app.compass.util.ConnectionUtil;

@Repository
public class CustomerRiskCategorizationDAOImpl implements CustomerRiskCategorizationDAO{
	
	@Autowired
	private ConnectionUtil connectionUtil;
	
	@Value("${compass.aml.config.schemaName}")
	private String schemaName;
	
	public List<Map<String, String>> getStaticRiskParameterList(String customerType){
		List<Map<String, String>> staticRiskParametersList = new Vector<Map<String, String>>();
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String sql = "";
		try{
			if(!customerType.equalsIgnoreCase("A")){
				sql = "SELECT RISKPARAMETERID, CUSTOMERTYPE, RISKPARAMETERNAME, RISKPARAMETERWEIGHTAGE, "+
					  "		  ISRISKPARAMETERMARKED, ISFROMTOREQ "+
					  "  FROM "+schemaName+"TB_CRC_STATIC_PARAMETERS "+
					  " WHERE CUSTOMERTYPE = ? "+
					  "ORDER BY RISKPARAMETERID ASC ";
				connection = connectionUtil.getConnection();
				preparedStatement = connection.prepareStatement(sql);
				preparedStatement.setString(1, customerType);
				resultSet = preparedStatement.executeQuery();
			}else{
				sql = "SELECT RISKPARAMETERID, CUSTOMERTYPE, RISKPARAMETERNAME, RISKPARAMETERWEIGHTAGE, "+
					  "		  ISRISKPARAMETERMARKED, ISFROMTOREQ "+
					  "  FROM "+schemaName+"TB_CRC_STATIC_PARAMETERS "+
					  "ORDER BY RISKPARAMETERID ASC ";
				connection = connectionUtil.getConnection();
				preparedStatement = connection.prepareStatement(sql);
				resultSet = preparedStatement.executeQuery();
			}
			//System.out.println(sql+" "+customerType);
			while(resultSet.next()){				
				Map<String, String> staticRiskParameterMap = new HashMap<String, String>();
				staticRiskParameterMap.put("RISKPARAMETERID", resultSet.getString("RISKPARAMETERID"));
				staticRiskParameterMap.put("CUSTOMERTYPE", resultSet.getString("CUSTOMERTYPE"));
				staticRiskParameterMap.put("RISKPARAMETERNAME", resultSet.getString("RISKPARAMETERNAME"));
				staticRiskParameterMap.put("RISKPARAMETERWEIGHTAGE", resultSet.getString("RISKPARAMETERWEIGHTAGE"));
				staticRiskParameterMap.put("ISRISKPARAMETERMARKED", resultSet.getString("ISRISKPARAMETERMARKED"));
				staticRiskParameterMap.put("ISFROMTOREQ", resultSet.getString("ISFROMTOREQ"));
				
				staticRiskParametersList.add(staticRiskParameterMap);
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return staticRiskParametersList;
	}
	
	public List<Map<String, String>> getDynamicRiskParameterList(String customerType){
		List<Map<String, String>> dynamicRiskParametersList = new Vector<Map<String, String>>();
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String sql = "";
		try{
			if(!customerType.equalsIgnoreCase("A")){
				sql = "SELECT RISKPARAMETERID, CUSTOMERTYPE, RISKPARAMETERNAME, RISKPARAMETERWEIGHTAGE, "+
					  "		  ISRISKPARAMETERMARKED, ISFROMTOREQ "+
				 	  "  FROM "+schemaName+"TB_CRC_DYNAMIC_PARAMETERS "+
					  " WHERE CUSTOMERTYPE = ? "+
					  " ORDER BY RISKPARAMETERID ASC ";
				connection = connectionUtil.getConnection();
				preparedStatement = connection.prepareStatement(sql);
				preparedStatement.setString(1, customerType);
				resultSet = preparedStatement.executeQuery();
			}
			else{
				sql = "SELECT RISKPARAMETERID, CUSTOMERTYPE, RISKPARAMETERNAME, RISKPARAMETERWEIGHTAGE, "+
					  "		  ISRISKPARAMETERMARKED, ISFROMTOREQ "+
				 	  "  FROM "+schemaName+"TB_CRC_DYNAMIC_PARAMETERS "+
					  " ORDER BY RISKPARAMETERID ASC ";
				connection = connectionUtil.getConnection();
				preparedStatement = connection.prepareStatement(sql);
				resultSet = preparedStatement.executeQuery();
			}
			
			while(resultSet.next()){				
				Map<String, String> dynamicRiskParameterMap = new HashMap<String, String>();
				dynamicRiskParameterMap.put("RISKPARAMETERID", resultSet.getString("RISKPARAMETERID"));
				dynamicRiskParameterMap.put("CUSTOMERTYPE", resultSet.getString("CUSTOMERTYPE"));
				dynamicRiskParameterMap.put("RISKPARAMETERNAME", resultSet.getString("RISKPARAMETERNAME"));
				dynamicRiskParameterMap.put("RISKPARAMETERWEIGHTAGE", resultSet.getString("RISKPARAMETERWEIGHTAGE"));
				dynamicRiskParameterMap.put("ISRISKPARAMETERMARKED", resultSet.getString("ISRISKPARAMETERMARKED"));
				dynamicRiskParameterMap.put("ISFROMTOREQ", resultSet.getString("ISFROMTOREQ"));
				
				dynamicRiskParametersList.add(dynamicRiskParameterMap);
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return dynamicRiskParametersList;
	}
	
	public void saveStaticParameterList(String strRiskParameters){
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		String sql = "UPDATE "+schemaName+"TB_CRC_STATIC_PARAMETERS "+
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
	
	public void saveDynamicParameterList(String strRiskParameters){
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		String sql = "UPDATE "+schemaName+"TB_CRC_DYNAMIC_PARAMETERS "+
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
	
	public List<Map<String,String>> searchStaticRiskAssignment(String searchParamId, String customerType){
		List<Map<String, String>> dataList = new Vector<Map<String,String>>();
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String sql = " SELECT SUBPARAMETERCODE, SUBPARAMETERDESCRIPTION, SUBPARAMETERRISKVALUE "+ 
					 "	 FROM "+schemaName+"TB_CRC_STATIC_SUBPARAMETERS "+ 
					 "  WHERE RISKPARAMETERID = ? "+
					 "    AND CUSTOMERTYPE = ? ";
		try{
			connection = connectionUtil.getConnection();
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, searchParamId);
			preparedStatement.setString(2, customerType);
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()){
				Map<String, String> dataMap = new LinkedHashMap<String, String>();
				dataMap.put("SUBPARAMETERCODE", resultSet.getString("SUBPARAMETERCODE"));
				dataMap.put("SUBPARAMETERDESCRIPTION", resultSet.getString("SUBPARAMETERDESCRIPTION"));
				dataMap.put("SUBPARAMETERRISKVALUE", resultSet.getString("SUBPARAMETERRISKVALUE"));
				dataList.add(dataMap);
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return dataList;
	}
	
	public List<Map<String,String>> searchDynamicRiskAssignment(String searchParamId, String customerType){
		List<Map<String, String>> dataList = new Vector<Map<String,String>>();
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String sql = " SELECT SUBPARAMETERCODE, SUBPARAMETERDESCRIPTION, SUBPARAMETERRISKVALUE "+ 
					 "	 FROM "+schemaName+"TB_CRC_DYNAMIC_SUBPARAMETERS "+ 
					 "  WHERE RISKPARAMETERID = ? "+
					 "    AND CUSTOMERTYPE = ? "+
					 " UNION ALL "+
					 " SELECT SUBPARAMETERCODE, SUBPARAMETERDESCRIPTION, SUBPARAMETERRISKVALUE "+ 
					 "	 FROM "+schemaName+"TB_DYNAMIC_CRC_RANGEPARAMETERS "+ 
					 "  WHERE RISKPARAMETERID = ? ";

		try{
			connection = connectionUtil.getConnection();
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, searchParamId);
			preparedStatement.setString(2, customerType);
			preparedStatement.setString(3, searchParamId);
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()){
				Map<String, String> dataMap = new LinkedHashMap<String, String>();
				dataMap.put("SUBPARAMETERCODE", resultSet.getString("SUBPARAMETERCODE"));
				dataMap.put("SUBPARAMETERDESCRIPTION", resultSet.getString("SUBPARAMETERDESCRIPTION"));
				dataMap.put("SUBPARAMETERRISKVALUE", resultSet.getString("SUBPARAMETERRISKVALUE"));
				dataList.add(dataMap);
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return dataList;
	}
	
	public void updateStaticRiskAssignmentValue(String fullData, String paramId){
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		String sql = "";
		try{
			   sql = "UPDATE "+schemaName+"TB_CRC_STATIC_SUBPARAMETERS "+
					 "	 SET SUBPARAMETERRISKVALUE = ? "+
					 " WHERE RISKPARAMETERID = ? "+
					 "   AND SUBPARAMETERCODE = ? ";
			connection  = connectionUtil.getConnection();
			preparedStatement = connection.prepareStatement(sql);
			String[] arrFullData = CommonUtil.splitString(fullData, ",");
			for(String strData : arrFullData){
				if(strData.length()>0){
					String[] arrData = CommonUtil.splitString(strData, "=");
					preparedStatement.setString(1, arrData[1]);
					preparedStatement.setString(2, paramId);
					preparedStatement.setString(3, arrData[0]);
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
	
	public void updateDynamicRiskAssignmentValue(String fullData, String paramId){
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		String iSFromToReqValue = "N";
		String sql = "";
		try{
			sql = "UPDATE "+schemaName+"TB_CRC_DYNAMIC_SUBPARAMETERS "+
			      "	 SET SUBPARAMETERRISKVALUE = ? "+
			      "WHERE RISKPARAMETERID = ? "+
			      "  AND SUBPARAMETERCODE = ? ";

			iSFromToReqValue = fetchISFromToReqValueForDynamicCRC(paramId) ;
			if(iSFromToReqValue.equalsIgnoreCase("Y")){
			sql = "UPDATE "+schemaName+"TB_DYNAMIC_CRC_RANGEPARAMETERS A "+
			   	  "	  SET SUBPARAMETERRISKVALUE = ? "+
			   	  " WHERE RISKPARAMETERID = ? "+
				  "   AND SUBPARAMETERCODE = ? ";
			}
			connection  = connectionUtil.getConnection();
			preparedStatement = connection.prepareStatement(sql);
			String[] arrFullData = CommonUtil.splitString(fullData, ",");
			for(String strData : arrFullData){
				if(strData.length()>0){
					String[] arrData = CommonUtil.splitString(strData, "=");
					preparedStatement.setString(1, arrData[1]);
					preparedStatement.setString(2, paramId);
					preparedStatement.setString(3, arrData[0]);
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
	
	public String fetchISFromToReqValueForDynamicCRC(String paramId){
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String isFromToReq = "N";
		String sql = "SELECT ISFROMTOREQ "+
					 "  FROM "+schemaName+"TB_CRC_DYNAMIC_PARAMETERS "+
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
	public String saveNewDynamicRiskParam(String paramId, String paramCode, String paramDesc, String paramRangeFrom,
									String paramRangeTo, String paramRiskValue, String paramOccupation, String userCode){
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String result = "";
		String sql = "INSERT INTO "+schemaName+"TB_DYNAMIC_CRC_RANGEPARAMETERS(RISKPARAMETERID, SUBPARAMETERCODE, "+
					 "		 SUBPARAMETERDESCRIPTION, SUBRISKPARAMETER_FROMVALUE, SUBRISKPARAMETER_TOVALUE, "+
					 "       SUBPARAMETERRISKVALUE, SUBRISKPARAMETER_OCCU_CODE, UPDATEDBY, UPDATETIMESTAMP) "+
					 "VALUES (?,?,?,?,?,?,?,?,SYSTIMESTAMP) ";
		try{			
			connection = connectionUtil.getConnection();
			preparedStatement = connection.prepareStatement(" SELECT "+schemaName+"SEQ_DYNAMICRISKRANGEPARAMETERS.NEXTVAL SEQVAL FROM DUAL ");
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()){
				paramCode = paramCode + "_" + resultSet.getString("SEQVAL");
			}
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, paramId);
			preparedStatement.setString(2, paramCode);
			preparedStatement.setString(3, paramDesc);
			preparedStatement.setInt(4, Integer.parseInt(paramRangeFrom));
			preparedStatement.setInt(5, Integer.parseInt(paramRangeTo));
			preparedStatement.setInt(6, Integer.parseInt(paramRiskValue));
			preparedStatement.setString(7, paramOccupation);
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
	
	public Map<String, String> fetchParamCodeToDeleteDynamicRiskParameter(String searchParamId, String paramCode){
		Map<String, String> dataMap = new HashMap<String, String>();
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String sql = "SELECT RISKPARAMETERID, SUBPARAMETERCODE, SUBPARAMETERDESCRIPTION, SUBRISKPARAMETER_FROMVALUE, "+
					 "		 SUBRISKPARAMETER_TOVALUE, SUBPARAMETERRISKVALUE, SUBRISKPARAMETER_OCCU_CODE "+
					 "  FROM "+schemaName+"TB_DYNAMIC_CRC_RANGEPARAMETERS "+
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
				dataMap.put("SUBRISKPARAMETER_OCCU_CODE", resultSet.getString("SUBRISKPARAMETER_OCCU_CODE"));
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return dataMap;
	}
	
	public String deleteNewDynamicRiskParam(String paramId, String paramCode){
			Connection connection = null;
			PreparedStatement preparedStatement = null;
			String result = "";
			String sql = "";
			try{
				sql = " DELETE FROM "+schemaName+"TB_DYNAMIC_CRC_RANGEPARAMETERS "+
				 	  "  WHERE RISKPARAMETERID= ? "+
				      "   AND SUBPARAMETERCODE  = ? ";
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
	
	public String updateNewDynamicRiskParam(String paramId, String paramCode, String paramDesc, String paramRangeFrom,
									String paramRangeTo, String paramRiskValue, String paramOccupation, String userCode){
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		String result = "";
		String sql = "UPDATE "+schemaName+"TB_DYNAMIC_CRC_RANGEPARAMETERS "+
					 "   SET SUBPARAMETERDESCRIPTION = ?, SUBRISKPARAMETER_FROMVALUE = ?, SUBRISKPARAMETER_TOVALUE = ?, "+
					 "       SUBPARAMETERRISKVALUE = ? , SUBRISKPARAMETER_OCCU_CODE = ?, "+
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
			preparedStatement.setString(5, paramOccupation);
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
	
	public void updateStaticRiskWeightageList(String staticRiskWeightages){
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		//System.out.println("DAO_staticRiskWeightages = "+staticRiskWeightages);
		String sql = "UPDATE "+schemaName+"TB_CRC_STATIC_PARAMETERS "+
					 "	 SET RISKPARAMETERWEIGHTAGE = ? "+
					 " WHERE RISKPARAMETERID = ? ";
		try{
			connection  = connectionUtil.getConnection();
			preparedStatement = connection.prepareStatement(sql);
			String[] arrStrParameters = CommonUtil.splitString(staticRiskWeightages, ",");
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
	
	public void updateDynamicRiskWeightageList(String dynamicRiskWeightages){
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		//System.out.println("DAO_dynamicRiskWeightages = "+dynamicRiskWeightages);
		String sql = "UPDATE "+schemaName+"TB_CRC_DYNAMIC_PARAMETERS "+
					 "	 SET RISKPARAMETERWEIGHTAGE = ? "+
					 " WHERE RISKPARAMETERID = ? ";
		try{
			connection  = connectionUtil.getConnection();
			preparedStatement = connection.prepareStatement(sql);
			String[] arrStrParameters = CommonUtil.splitString(dynamicRiskWeightages, ",");
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
	
	public String calculateStaticRisk(String userCode, String CURRENTROLE, String ipAddress){
		Connection connection = null;
		CallableStatement callableStatement = null;
		String result = "";
		String riskType = "STATIC";
		try{
			connection = connectionUtil.getConnection();
			callableStatement = connection.prepareCall("{CALL "+schemaName+"STP_CALCULATEACCOUNTTRISK(?,?,?,?)}");
			callableStatement.setString(1, userCode);
			callableStatement.setString(2, CURRENTROLE);
			callableStatement.setString(3, ipAddress);
			callableStatement.setString(4, riskType);
			callableStatement.execute();
			result = "Static Risk calculated successfully";
		}catch(Exception e){
			e.printStackTrace();
			result = "Error occured while calculating risk.";
		}finally{
			connectionUtil.closeResources(connection, callableStatement, null, null);
		}
		return result;
	}
	
	public String calculateDynamicRisk(String userCode, String CURRENTROLE, String ipAddress){
		Connection connection = null;
		CallableStatement callableStatement = null;
		String result = "";
		String riskType = "DYNAMIC";
		try{
			connection = connectionUtil.getConnection();
			callableStatement = connection.prepareCall("{CALL "+schemaName+"STP_CALCULATEACCOUNTTRISK(?,?,?,?)}");
			callableStatement.setString(1, userCode);
			callableStatement.setString(2, CURRENTROLE);
			callableStatement.setString(3, ipAddress);
			callableStatement.setString(4, riskType);
			callableStatement.execute();
			result = "Dynamic Risk calculated successfully";
		}catch(Exception e){
			e.printStackTrace();
			result = "Error occured while calculating risk.";
		}finally{
			connectionUtil.closeResources(connection, callableStatement, null, null);
		}
		return result;
	}
	
	public List<Map<String,String>> getOccupationCodes(){
		Connection connection = null;
		PreparedStatement preparedStatement= null;
		ResultSet resultSet = null;
		List<Map<String,String>> codesList = new Vector<Map<String,String>>();
		
		try{
			String sql = "SELECT CODE, DESCRIPTION FROM "+schemaName+"TB_OCCUPATIONCODEDETAILS ";
			connection = connectionUtil.getConnection();
			preparedStatement = connection.prepareStatement(sql);
			resultSet = preparedStatement.executeQuery();
			
			while(resultSet.next()){
				Map<String,String> codesMap = new LinkedHashMap<String, String>();
				codesMap.put("CODE",resultSet.getString("CODE"));
				codesMap.put("DESCRIPTION",resultSet.getString("DESCRIPTION"));
				
				codesList.add(codesMap);
			}
			
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		//System.out.println(codesList);
		return codesList;
	}
/*		
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
		String sql= "SELECT TEMPLATEID, TEMPLATENAME, PRODUCTCODE, CUSTOMERTYPE, PRODUCTCODERISKVALUE, CUSTOMERTYPERISKVALUE, "+
		            "       ISENABLED, FUN_DATETOCHAR(UPDATETIMESTAMP) UPDATEDON, A.UPDATEDBY UPDATEDBY "+ 
				     " FROM "+schemaName+"TB_RISKPARAMETERTEMPLATES A WHERE 1=1 ";
		
		if(templateId != null && templateId.length()>0)
			sql = sql + " AND TEMPLATEID = '"+templateId+"' ";
		if(templateName != null && templateName.length()>0)
			sql = sql + " AND TEMPLATENAME = '"+templateName+"' ";
		if(productCode != null && productCode.length()>0 && !productCode.equalsIgnoreCase("ALL"))
			sql = sql + " AND PRODUCTCODE = '"+productCode+"' ";
		if(custType != null && custType.length()>0 && !productCode.equalsIgnoreCase("ALL"))
			sql = sql + " AND CUSTOMERTYPE = '"+custType+"' ";
		if(isEnabled != null && isEnabled.length()>0)
			sql = sql + " AND ISENABLED = '"+isEnabled+"' ";
		
		try{
			connection = connectionUtil.getConnection();
			preparedStatement = connection.prepareStatement(sql);
			resultSet = preparedStatement.executeQuery();
			
			List<String> headers = new Vector<String>();
			ResultSetMetaData resultSetMetaData = resultSet.getMetaData();
			int numberofcols = resultSetMetaData.getColumnCount();
			for(int count = 1; count <= numberofcols; count++ ){
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
					"  AND B.TEMPLATEID = '"+template+"' "+
					" WHERE A.TABLENAME =  '"+detailType+"' "+
					" ) A ORDER BY ISCHECKED DESC, PARAMETERORDER ASC "+
					"       ) A ";
		try{
			connection = connectionUtil.getConnection();
			preparedStatement = connection.prepareStatement(sql);
			resultSet = preparedStatement.executeQuery();
			
			List<String> headers = new Vector<String>();
			ResultSetMetaData resultSetMetaData = resultSet.getMetaData();
			int numberofcols = resultSetMetaData.getColumnCount();
			for(int count = 1; count <= numberofcols; count++ ){
				String colname = resultSetMetaData.getColumnName(count);
				headers.add(CommonUtil.changeColumnName(colname));
			}
			
			while(resultSet.next()){				
				Map<String, String> dataMap = new LinkedHashMap<String, String>();
				for(String header : headers){
					dataMap.put(header, resultSet.getString(header));
				}
				mainList.add(dataMap);
			}
			
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
*/
}

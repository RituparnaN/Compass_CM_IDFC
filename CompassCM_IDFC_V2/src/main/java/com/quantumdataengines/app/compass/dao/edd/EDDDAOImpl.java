package com.quantumdataengines.app.compass.dao.edd;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Repository;

import com.quantumdataengines.app.compass.util.ConnectionUtil;

@Repository
public class EDDDAOImpl implements EDDDAO{
	
	@Autowired
	private ConnectionUtil connectionUtil;
	
	@Value("${compass.aml.config.schemaName}")
	private String schemaName;
	
	@Override
	public List<Map<String, String>> showEDDRecords (String caseNoForEDD){
		List<Map<String, String>> dataList = new Vector<Map<String,String>>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			String sql = "SELECT S_NUMBER, USERCODE, UPDATETIMESTAMP FROM "+schemaName+"TB_EDDSAVEDCUSTOMERDATA "+
						 " WHERE ALERTNUMBER = ?";
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, caseNoForEDD);
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()){
				Map<String, String> dataMap = new LinkedHashMap<String, String>();
				dataMap.put("S_NUMBER", new Integer(resultSet.getInt("S_NUMBER")).toString());
				dataMap.put("USERCODE", resultSet.getString("USERCODE"));
				dataMap.put("UPDATETIMESTAMP", resultSet.getString("UPDATETIMESTAMP"));
				dataList.add(dataMap);
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return dataList;
	}
	
	public Map<String, List<String>> getEDDMasterData(){
		Map<String, List<String>> dataMap = new LinkedHashMap<String, List<String>>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			String sql = "SELECT  KYCDOCUMENTATIONOPINION, TNOVERIFICATION, ADDRESSVERIFIEDBY, ADDRESSVERIFICATIONFINDINGS, "+
						 "		  SIGNATORY_AVAILABILITY, CUSTOMERREACTION, BUSINESSPREMISE_TYPE, BUSINESSPREMISE_SIZE, "+
						 "		  STAFFSTRENGTH, LEGALCONSTITUTION, BUSINESS_YEARS, CUSTOMERINDUSTRY, BUSINESS_SEGMENT, "+
						 "		  PRACTICEDTRANSACTIONPATTERN, CREDIT_TYPES, DEDIT_TYPES, TRANSACTIONPATTERNINDICATOR, "+
						 "		  TRANSACTIONOBSERVATION, FINAL_RELATIONSHIP, OTHERRELEVANT_DETAILS "+
						 "  FROM  "+schemaName+"TB_EDDMASTERDATA ";
			preparedStatement = connection.prepareStatement(sql);
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()){
				addToEDDList(resultSet, dataMap, "KYCDOCUMENTATIONOPINION");
				addToEDDList(resultSet, dataMap, "TNOVERIFICATION");
				addToEDDList(resultSet, dataMap, "ADDRESSVERIFIEDBY");
				addToEDDList(resultSet, dataMap, "ADDRESSVERIFICATIONFINDINGS");
				addToEDDList(resultSet, dataMap, "SIGNATORY_AVAILABILITY");
				addToEDDList(resultSet, dataMap, "CUSTOMERREACTION");
				addToEDDList(resultSet, dataMap, "BUSINESSPREMISE_TYPE");
				addToEDDList(resultSet, dataMap, "BUSINESSPREMISE_SIZE");
				addToEDDList(resultSet, dataMap, "STAFFSTRENGTH");
				addToEDDList(resultSet, dataMap, "LEGALCONSTITUTION");
				addToEDDList(resultSet, dataMap, "BUSINESS_YEARS");
				addToEDDList(resultSet, dataMap, "CUSTOMERINDUSTRY");
				addToEDDList(resultSet, dataMap, "BUSINESS_SEGMENT");
				addToEDDList(resultSet, dataMap, "PRACTICEDTRANSACTIONPATTERN");
				addToEDDList(resultSet, dataMap, "CREDIT_TYPES");
				addToEDDList(resultSet, dataMap, "DEDIT_TYPES");
				addToEDDList(resultSet, dataMap, "TRANSACTIONPATTERNINDICATOR");
				addToEDDList(resultSet, dataMap, "TRANSACTIONOBSERVATION");
				addToEDDList(resultSet, dataMap, "FINAL_RELATIONSHIP");
				addToEDDList(resultSet, dataMap, "OTHERRELEVANT_DETAILS");
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return dataMap;
	}
	
	private void addToEDDList(ResultSet resultSet, Map<String, List<String>> mainData, String fieldName) throws Exception{
		List<String> list = mainData.get(fieldName);
		if(list == null){
			list = new Vector<String>();
			if(resultSet.getString(fieldName) != null)
				list.add(resultSet.getString(fieldName));
			mainData.put(fieldName, list);
		}else{
			if(resultSet.getString(fieldName) != null)
				list.add(resultSet.getString(fieldName));
		}
	}
	
	public String saveEDD(Map<String,String> paramMap, String seqNo, String userCode){
		String response = "" ;
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		try{
			String sql = "INSERT INTO "+schemaName+"TB_EDDSAVEDCUSTOMERDATA(S_NUMBER, ALERTNUMBER, USERCODE, KYCDOCUMENTATIONOPINION, "+
						 "			  TNOVERIFICATION, ADDRESSVERIFIEDBY, ADDRESSVERIFICATIONFINDINGS, CONTACTEDPERSON_NAME, "+
						 "			  CONTACTEDPERSON_DESIGNATION, SIGNATORY_AVAILABILITY, CUSTOMERREACTION, BUSINESSPREMISE_TYPE, "+
						 "			  BUSINESSPREMISE_SIZE, STAFFSTRENGTH, LEGALCONSTITUTION, BUSINESS_NETWORTHINLACS, "+
						 "			  BUSINESS_TURNOVERINLACS, BUSINESS_YEARS, CUSTOMERINDUSTRY, BUSINESS_SEGMENT, "+
						 "			  PRACTICEDTRANSACTIONPATTERN, CREDIT_TYPES, DEDIT_TYPES, TRANSACTIONPATTERNINDICATOR, "+
						 "			  TRANSACTIONOBSERVATION, CUSTOMERRESPONSE_SATISFACTION, OTHERICICI_RELATIONSHIP, FINAL_RELATIONSHIP, "+
						 "			  NARRATION, OTHERRELEVANT_DETAILS, UPDATETIMESTAMP) "+
						 "VALUES ("+schemaName+"EDD_SEQ.NEXTVAL,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,SYSTIMESTAMP) ";
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, paramMap.get("caseNoForEDD"));
			preparedStatement.setString(2, userCode);
			preparedStatement.setString(3, paramMap.get("KYCDOCUMENTATIONOPINION"));
			preparedStatement.setString(4, paramMap.get("TNOVERIFICATION"));
			preparedStatement.setString(5, paramMap.get("ADDRESSVERIFIEDBY"));
			preparedStatement.setString(6, paramMap.get("ADDRESSVERIFICATIONFINDINGS"));
			preparedStatement.setString(7, paramMap.get("CONTACTEDPERSON_NAME"));
			preparedStatement.setString(8, paramMap.get("CONTACTEDPERSON_DESIGNATION"));
			preparedStatement.setString(9, paramMap.get("SIGNATORY_AVAILABILITY"));
			preparedStatement.setString(10, paramMap.get("CUSTOMERREACTION"));
			preparedStatement.setString(11, paramMap.get("BUSINESSPREMISE_TYPE"));
			preparedStatement.setString(12, paramMap.get("BUSINESSPREMISE_SIZE"));
			preparedStatement.setString(13, paramMap.get("STAFFSTRENGTH"));
			preparedStatement.setString(14, paramMap.get("LEGALCONSTITUTION"));
			preparedStatement.setString(15, paramMap.get("BUSINESS_NETWORTHINLACS"));
			preparedStatement.setString(16, paramMap.get("BUSINESS_TURNOVERINLACS"));
			preparedStatement.setString(17, paramMap.get("BUSINESS_YEARS"));
			preparedStatement.setString(18, paramMap.get("CUSTOMERINDUSTRY"));
			preparedStatement.setString(19, paramMap.get("BUSINESS_SEGMENT"));
			preparedStatement.setString(20, paramMap.get("PRACTICEDTRANSACTIONPATTERN"));
			preparedStatement.setString(21, paramMap.get("CREDIT_TYPES"));
			preparedStatement.setString(22, paramMap.get("DEDIT_TYPES"));
			preparedStatement.setString(23, paramMap.get("TRANSACTIONPATTERNINDICATOR"));
			preparedStatement.setString(24, paramMap.get("TRANSACTIONOBSERVATION"));
			preparedStatement.setString(25, paramMap.get("CUSTOMERRESPONSE_SATISFACTION"));
			preparedStatement.setString(26, paramMap.get("OTHERICICI_RELATIONSHIP"));
			preparedStatement.setString(27, paramMap.get("FINAL_RELATIONSHIP"));
			preparedStatement.setString(28, paramMap.get("NARRATION"));
			preparedStatement.setString(29, paramMap.get("OTHERRELEVANT_DETAILS"));
			preparedStatement.executeUpdate();
			response = " EDD saved successfully ";
		}catch(Exception e){
			response = "Error while saving EDD ";
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, null, null);
		}
		return response;
	}

	public Map<String, String> fetchDetailsToUpdateEDD(String seqNo){
		Map<String, String> fetchDetailsToUpdateEDDMap = new HashMap<String, String>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareStatement("SELECT S_NUMBER, ALERTNUMBER, USERCODE, KYCDOCUMENTATIONOPINION, "+
						 									"	    TNOVERIFICATION, ADDRESSVERIFIEDBY, ADDRESSVERIFICATIONFINDINGS, "+
						 									"		CONTACTEDPERSON_NAME, CONTACTEDPERSON_DESIGNATION, SIGNATORY_AVAILABILITY, "+
						 									"		CUSTOMERREACTION, BUSINESSPREMISE_TYPE, BUSINESSPREMISE_SIZE, STAFFSTRENGTH, "+
						 									"		LEGALCONSTITUTION, BUSINESS_NETWORTHINLACS, BUSINESS_TURNOVERINLACS, "+
						 									"		BUSINESS_YEARS, CUSTOMERINDUSTRY, BUSINESS_SEGMENT, PRACTICEDTRANSACTIONPATTERN, "+
						 									"		CREDIT_TYPES, DEDIT_TYPES, TRANSACTIONPATTERNINDICATOR, TRANSACTIONOBSERVATION, "+
						 									"		CUSTOMERRESPONSE_SATISFACTION, OTHERICICI_RELATIONSHIP, FINAL_RELATIONSHIP, "+
						 									"		NARRATION, OTHERRELEVANT_DETAILS "+
															"  FROM "+schemaName+"TB_EDDSAVEDCUSTOMERDATA "+
															" WHERE S_NUMBER = ? ");
			preparedStatement.setString(1, seqNo);
			resultSet = preparedStatement.executeQuery();
			if (resultSet.next()) {
				fetchDetailsToUpdateEDDMap.put("KYCDOCUMENTATIONOPINION", resultSet.getString("KYCDOCUMENTATIONOPINION"));
				fetchDetailsToUpdateEDDMap.put("TNOVERIFICATION", resultSet.getString("TNOVERIFICATION"));
				fetchDetailsToUpdateEDDMap.put("ADDRESSVERIFIEDBY", resultSet.getString("ADDRESSVERIFIEDBY"));
				fetchDetailsToUpdateEDDMap.put("ADDRESSVERIFICATIONFINDINGS", resultSet.getString("ADDRESSVERIFICATIONFINDINGS"));
				fetchDetailsToUpdateEDDMap.put("CONTACTEDPERSON_NAME", resultSet.getString("CONTACTEDPERSON_NAME"));
				fetchDetailsToUpdateEDDMap.put("CONTACTEDPERSON_DESIGNATION", resultSet.getString("CONTACTEDPERSON_DESIGNATION"));
				fetchDetailsToUpdateEDDMap.put("SIGNATORY_AVAILABILITY", resultSet.getString("SIGNATORY_AVAILABILITY"));
				fetchDetailsToUpdateEDDMap.put("CUSTOMERREACTION", resultSet.getString("CUSTOMERREACTION"));
				fetchDetailsToUpdateEDDMap.put("BUSINESSPREMISE_TYPE", resultSet.getString("BUSINESSPREMISE_TYPE"));
				fetchDetailsToUpdateEDDMap.put("BUSINESSPREMISE_SIZE", resultSet.getString("BUSINESSPREMISE_SIZE"));
				fetchDetailsToUpdateEDDMap.put("STAFFSTRENGTH", resultSet.getString("STAFFSTRENGTH"));
				fetchDetailsToUpdateEDDMap.put("LEGALCONSTITUTION", resultSet.getString("LEGALCONSTITUTION"));
				fetchDetailsToUpdateEDDMap.put("BUSINESS_NETWORTHINLACS", resultSet.getString("BUSINESS_NETWORTHINLACS"));
				fetchDetailsToUpdateEDDMap.put("BUSINESS_TURNOVERINLACS", resultSet.getString("BUSINESS_TURNOVERINLACS"));
				fetchDetailsToUpdateEDDMap.put("BUSINESS_YEARS", resultSet.getString("BUSINESS_YEARS"));
				fetchDetailsToUpdateEDDMap.put("CUSTOMERINDUSTRY", resultSet.getString("CUSTOMERINDUSTRY"));
				fetchDetailsToUpdateEDDMap.put("BUSINESS_SEGMENT", resultSet.getString("BUSINESS_SEGMENT"));
				fetchDetailsToUpdateEDDMap.put("PRACTICEDTRANSACTIONPATTERN", resultSet.getString("PRACTICEDTRANSACTIONPATTERN"));
				fetchDetailsToUpdateEDDMap.put("CREDIT_TYPES", resultSet.getString("CREDIT_TYPES"));
				fetchDetailsToUpdateEDDMap.put("DEDIT_TYPES", resultSet.getString("DEDIT_TYPES"));
				fetchDetailsToUpdateEDDMap.put("TRANSACTIONPATTERNINDICATOR", resultSet.getString("TRANSACTIONPATTERNINDICATOR"));
				fetchDetailsToUpdateEDDMap.put("TRANSACTIONOBSERVATION", resultSet.getString("TRANSACTIONOBSERVATION"));
				fetchDetailsToUpdateEDDMap.put("CUSTOMERRESPONSE_SATISFACTION", resultSet.getString("CUSTOMERRESPONSE_SATISFACTION"));
				fetchDetailsToUpdateEDDMap.put("OTHERICICI_RELATIONSHIP", resultSet.getString("OTHERICICI_RELATIONSHIP"));
				fetchDetailsToUpdateEDDMap.put("FINAL_RELATIONSHIP", resultSet.getString("FINAL_RELATIONSHIP"));
				fetchDetailsToUpdateEDDMap.put("NARRATION", resultSet.getString("NARRATION"));
				fetchDetailsToUpdateEDDMap.put("OTHERRELEVANT_DETAILS", resultSet.getString("OTHERRELEVANT_DETAILS"));
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement,resultSet,null);	
		}
		return fetchDetailsToUpdateEDDMap;
	}

	
	public String updateEDD(Map<String,String> paramMap, String seqNo, String userCode){
		String response = "" ;
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		try{
			String sql = "UPDATE "+schemaName+"TB_EDDSAVEDCUSTOMERDATA SET USERCODE = ?, "+
						 "		 KYCDOCUMENTATIONOPINION = ?, TNOVERIFICATION = ?, ADDRESSVERIFIEDBY = ?, "+
						 "		 ADDRESSVERIFICATIONFINDINGS = ?, CONTACTEDPERSON_NAME = ?, CONTACTEDPERSON_DESIGNATION = ?, "+
						 "		 SIGNATORY_AVAILABILITY = ?, CUSTOMERREACTION = ?, BUSINESSPREMISE_TYPE = ?, BUSINESSPREMISE_SIZE = ? , "+
						 "		 STAFFSTRENGTH = ?, LEGALCONSTITUTION = ?, BUSINESS_NETWORTHINLACS = ?, BUSINESS_TURNOVERINLACS = ?, "+
						 "		 BUSINESS_YEARS = ?, CUSTOMERINDUSTRY = ?, BUSINESS_SEGMENT = ?, PRACTICEDTRANSACTIONPATTERN = ?, "+
						 "		 CREDIT_TYPES = ?, DEDIT_TYPES = ?, TRANSACTIONPATTERNINDICATOR = ?, TRANSACTIONOBSERVATION = ?, "+
						 "		 CUSTOMERRESPONSE_SATISFACTION = ?, OTHERICICI_RELATIONSHIP = ?, FINAL_RELATIONSHIP = ?, "+
						 "		 NARRATION = ?, OTHERRELEVANT_DETAILS = ?, UPDATETIMESTAMP = SYSTIMESTAMP "+
						 " WHERE S_NUMBER = ? "+
						 "   AND ALERTNUMBER = ? ";
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, userCode);
			preparedStatement.setString(2, paramMap.get("KYCDOCUMENTATIONOPINION"));
			preparedStatement.setString(3, paramMap.get("TNOVERIFICATION"));
			preparedStatement.setString(4, paramMap.get("ADDRESSVERIFIEDBY"));
			preparedStatement.setString(5, paramMap.get("ADDRESSVERIFICATIONFINDINGS"));
			preparedStatement.setString(6, paramMap.get("CONTACTEDPERSON_NAME"));
			preparedStatement.setString(7, paramMap.get("CONTACTEDPERSON_DESIGNATION"));
			preparedStatement.setString(8, paramMap.get("SIGNATORY_AVAILABILITY"));
			preparedStatement.setString(9, paramMap.get("CUSTOMERREACTION"));
			preparedStatement.setString(10, paramMap.get("BUSINESSPREMISE_TYPE"));
			preparedStatement.setString(11, paramMap.get("BUSINESSPREMISE_SIZE"));
			preparedStatement.setString(12, paramMap.get("STAFFSTRENGTH"));
			preparedStatement.setString(13, paramMap.get("LEGALCONSTITUTION"));
			preparedStatement.setString(14, paramMap.get("BUSINESS_NETWORTHINLACS"));
			preparedStatement.setString(15, paramMap.get("BUSINESS_TURNOVERINLACS"));
			preparedStatement.setString(16, paramMap.get("BUSINESS_YEARS"));
			preparedStatement.setString(17, paramMap.get("CUSTOMERINDUSTRY"));
			preparedStatement.setString(18, paramMap.get("BUSINESS_SEGMENT"));
			preparedStatement.setString(19, paramMap.get("PRACTICEDTRANSACTIONPATTERN"));
			preparedStatement.setString(20, paramMap.get("CREDIT_TYPES"));
			preparedStatement.setString(21, paramMap.get("DEDIT_TYPES"));
			preparedStatement.setString(22, paramMap.get("TRANSACTIONPATTERNINDICATOR"));
			preparedStatement.setString(23, paramMap.get("TRANSACTIONOBSERVATION"));
			preparedStatement.setString(24, paramMap.get("CUSTOMERRESPONSE_SATISFACTION"));
			preparedStatement.setString(25, paramMap.get("OTHERICICI_RELATIONSHIP"));
			preparedStatement.setString(26, paramMap.get("FINAL_RELATIONSHIP"));
			preparedStatement.setString(27, paramMap.get("NARRATION"));
			preparedStatement.setString(28, paramMap.get("OTHERRELEVANT_DETAILS"));
			preparedStatement.setString(29, seqNo);
			preparedStatement.setString(30, paramMap.get("caseNoForEDD"));
			preparedStatement.executeUpdate();
			response = " EDD updated successfully ";
		}catch(Exception e){
			response = "Error while updating EDD ";
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, null, null);
		}
		return response;
	}

	
}

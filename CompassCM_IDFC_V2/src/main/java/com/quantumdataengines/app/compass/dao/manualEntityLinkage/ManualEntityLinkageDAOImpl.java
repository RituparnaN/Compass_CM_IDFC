package com.quantumdataengines.app.compass.dao.manualEntityLinkage;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.quantumdataengines.app.compass.util.ConnectionUtil;

@Repository
public class ManualEntityLinkageDAOImpl implements ManualEntityLinkageDAO {
	@Autowired
	private ConnectionUtil connectionUtil;
	

	@Override
	public Map<String, String> getEntityRelationTypes(String userCode, String userRole, String ipAddress) {
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		Map<String,String>relationTypes = new LinkedHashMap<>();
		try{
			preparedStatement = connection.prepareStatement("SELECT RELATIONCODE,RELATIONNAME FROM TB_ENTITYRELATIONTYPE ");
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()) {
				relationTypes.put(resultSet.getString("RELATIONCODE"),resultSet.getString("RELATIONNAME") );
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally {
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return relationTypes;
	}


	@Override
	public Map<String, List<String>> getCustomerAccountList(String sourceCustomerId, String destinationCustomerId,
			String userCode, String userRole, String ipAddress) {
		Map<String, List<String>> customerAccount = new HashMap<>();
		customerAccount.put(sourceCustomerId, getAccountList(sourceCustomerId));
		customerAccount.put(destinationCustomerId, getAccountList(destinationCustomerId));
		return customerAccount;
	}
	
	private List<String> getAccountList(String customerid) {
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		List<String> accountList  = new ArrayList<String>();
		try{
			
			preparedStatement = connection.prepareStatement("SELECT ACCOUNTNO FROM TB_ACCOUNTSMASTER WHERE CUSTOMERID = ? ");
			preparedStatement.setString(1, customerid);
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()) {
				String accountNO = resultSet.getString("ACCOUNTNO");
				accountList.add(accountNO);			
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally {
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);	
		}
		return accountList;
		
	}


	@Override
	public String saveEntityLinkage(Map<String, String> entityRelationDetails, String userCode,String userRole, String ipAddress) {
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			String query = " INSERT INTO TB_ENTITYTRACER_MANUALLINKAGE (RECORDNO,SOURCECUSTOMERID,SOURCEACCOUNTNO,"
					     + " DESTINATIONCUSTOMERID,DESTINATIONACCOUNTNO,RELATIONSHIPCODE,ISENABLED,"
					     + " MAKERUSERCODE,MAKERREMARKS,MAKERUSERROLE,MAKERIPADDRESS,MAKERTIMESTAMP)"
					     + " VALUES (?,?,?, ?,?,?,?, ?,?,?,?, SYSTIMESTAMP) ";
			preparedStatement = connection.prepareStatement(query);
			String [] soucreAccountNos = entityRelationDetails.get("SOURCEACCOUNTNO").split(",");
			String [] destinationAccountNos =  entityRelationDetails.get("DESTINATIONACCOUNTNO").split(",");
			String sourceCustomerId = entityRelationDetails.get("SOURCECUSTOMERID");
			String destinationCustomerId = entityRelationDetails.get("DESTINATIONCUSTOMERID");
			String relationshipCode = entityRelationDetails.get("RELATIONSHIPCODE");
			String remarks = entityRelationDetails.get("REMARKS");;
			
			for(String sAccount:soucreAccountNos) {
				for(String dAccount:destinationAccountNos) {
					preparedStatement.setString(1,getEntityRelationSeqNo() );
					  preparedStatement.setString(2,sourceCustomerId );
					  preparedStatement.setString(3,sAccount );
					  preparedStatement.setString(4,destinationCustomerId );
					  preparedStatement.setString(5,dAccount );
					  preparedStatement.setString(6,relationshipCode );
					  preparedStatement.setString(7,"Y" );
					  preparedStatement.setString(8,userCode );
					  preparedStatement.setString(9,remarks);
					  preparedStatement.setString(10,userRole );
					  preparedStatement.setString(11,ipAddress ); 
					  preparedStatement.addBatch();
					
				}
			}
			preparedStatement.executeBatch();
			return "Relation Successfully Added";
		}catch(Exception e){
			e.printStackTrace();
			return "Error while adding entiity relation";
		}finally {
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);	
		}
		
		
	}
	
	
	private String  getEntityRelationSeqNo() {
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String seqNo = null;
		try {
			preparedStatement = connection.prepareStatement("SELECT SEQ_MANUAL_ENTITY_LINKAGE.NEXTVAL AS SEQNO FROM DUAL");
			resultSet = preparedStatement.executeQuery();
			if(resultSet.next()){
				seqNo = resultSet.getString("SEQNO");
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);	
		}
		return seqNo;
		
	}
	

}

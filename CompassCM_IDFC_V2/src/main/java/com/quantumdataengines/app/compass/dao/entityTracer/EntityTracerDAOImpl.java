package com.quantumdataengines.app.compass.dao.entityTracer;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Repository;

import com.quantumdataengines.app.compass.util.CommonUtil;
import com.quantumdataengines.app.compass.util.ConnectionUtil;

@Repository
public class EntityTracerDAOImpl implements EntityTracerDAO {
	
	@Autowired
	private ConnectionUtil connectionUtil;
			
	@Value("${compass.aml.config.schemaName}")
	private String schemaName;
	
	public Map<String, Object> getLinkedTracer(String accountNumber, String customerId, String customerName, String fromDate, String toDate, 
			boolean isStaticLinks, boolean isTransactionLinks, int minLinksCount, String counterAccountNo, int levelCount, String l_strExcludedProductCode,
			String counterAccountGroup){
		Map<String, Object> mainMap = new LinkedHashMap<String, Object>();
		// String counterAccountGroup = "";
		if(customerId == null || customerId.equals("")){
			customerId = getCustomerIdForAccount(accountNumber);
		}
		List<List<String>> headerRow = new ArrayList<List<String>>();
		List<String> headerColumn = new ArrayList<String>();
		headerColumn.add("ACCOUNTNO");
		headerColumn.add("LINKEDTYPE");
		headerColumn.add("LINKEDACCOUNTNO");
		headerColumn.add("LINKEDCUSTOMERID");
		headerColumn.add("LINKEDNAME");
		headerColumn.add("FORCELINK");
		// headerColumn.add("LINKEDCUSTOMERTYPE");
		headerColumn.add("IFEXISTINGTAB");
		headerColumn.add("TRANSACTEDCOUNT");
		headerColumn.add("TRANSACTEDAMOUNT");
		headerColumn.add("DUPLICATEVALUE");
		headerColumn.add("TOTALALERTEDCOUNT");
		headerColumn.add("TOTALCTCYCOUNT");
		headerColumn.add("ENTITYICON");
		headerColumn.add("TRANSACTIONRISK");
		headerColumn.add("CUSTOMERRISK");
		headerColumn.add("FORCELINKCOMMENTS");
		headerRow.add(headerColumn);

		List<String> tabOrder = new ArrayList<String>();
		Map<String, String> searchedAccounts = new HashMap<String, String>();
		Map<String, Map<String, Map<String, String>>> accountsToSearch = new HashMap<String, Map<String, Map<String, String>>>();
		
		Map<String, Map<String, String>> accountsMap = new HashMap<String, Map<String, String>>();
		Map<String, String> accountMap = new HashMap<String, String>();
		accountMap.put("ACCOUNTNO", accountNumber);
		accountMap.put("CUSTOMERID", customerId);
		accountMap.put("CUSTOMERNAME", customerName);
		accountsMap.put(accountNumber, accountMap);
		
		for(int levelIncrementCount = 1; levelIncrementCount <= levelCount; levelIncrementCount++){
			String tabName = "Level_"+levelIncrementCount;
			int nextTabIndex = levelIncrementCount+1;
			String nextTabName = "Level_"+nextTabIndex;
			// System.out.println("Starting "+tabName+" tab preparation...");
			tabOrder.add(tabName);
			if(levelIncrementCount == 1){
				accountsToSearch.put(tabName, accountsMap);
			}
			
			accountsMap = new HashMap<String, Map<String, String>>();			
			List<List<String>> rowResult = new ArrayList<List<String>>();
			
			Map<String, List<Map<String, String>>> searchResult = getLinkedAccounts(accountsToSearch, tabName, fromDate, toDate, isStaticLinks, 
					isTransactionLinks, minLinksCount, counterAccountNo, l_strExcludedProductCode, counterAccountGroup);
			Iterator<String> mainItr = searchResult.keySet().iterator();
			while (mainItr.hasNext()) {
				String accountNoSearched = mainItr.next();
				searchedAccounts.put(accountNoSearched, tabName);
				// System.out.println("accountNoSearched : "+accountNoSearched+", "+searchedAccounts.size());
				List<Map<String, String>> linksDetailsList = searchResult.get(accountNoSearched);
				for(Map<String, String> linkDetails : linksDetailsList){
					List<String> columnResult = new ArrayList<String>();
					String linkedName = linkDetails.get("LINKEDNAME");
					String linkedType = linkDetails.get("LINKEDTYPE");
					String[] forceLinkWithComments = linkDetails.get("FORCELINK").split("~");
					//System.out.println(forceLinkWithComments.length);
					String forceLink = "";
					String forceLinkComments = "";
					if(forceLinkWithComments.length == 2){
						forceLink = forceLinkWithComments[0];
						forceLinkComments = forceLinkWithComments[1];
					}else{
						forceLink = forceLinkWithComments[0];
						forceLinkComments = "NA";
					}
					
					/*for(String f: forceLinkWithComments){
						String forceLink = "";
						String forceLinkComments = "";
					}*/
					
					
					String linkedAccountNo = linkDetails.get("LINKEDACCOUNTNO");
					String linkedCustomerId = linkDetails.get("LINKEDCUSTOMERID");
					String linkedCustomerType = linkDetails.get("LINKEDCUSTOMERTYPE");
					String duplicateValue = linkDetails.get("DUPLICATEVALUE");
					String transactedCount = linkDetails.get("TRANSACTEDCOUNT");
					String transactedAmount = linkDetails.get("TRANSACTEDAMOUNT");
					String totalAlertedCount = linkDetails.get("TOTALALERTEDCOUNT");
					String totalCTCYCount = linkDetails.get("TOTALCTCYCOUNT");
					String entityIcon = linkDetails.get("ENTITYICON");
					String transactionRisk = linkDetails.get("TRANSACTIONRISK");
					String customerRisk = linkDetails.get("CUSTOMERRISK");
					String accountFoundInTab = "N.A."; 
					
					
					if(searchedAccounts.containsKey(linkedAccountNo)){
						accountFoundInTab = searchedAccounts.get(linkedAccountNo);
					}else{						
						Map<String, String> newAccountToSearchMap = new HashMap<String, String>();
						newAccountToSearchMap.put("ACCOUNTNO", linkedAccountNo);
						newAccountToSearchMap.put("CUSTOMERID", linkedCustomerId);
						newAccountToSearchMap.put("CUSTOMERNAME", linkedName);
						if(linkedCustomerType.equalsIgnoreCase("I")){
						  accountsMap.put(linkedAccountNo, newAccountToSearchMap);
						}
						//accountsMap.put(linkedAccountNo, newAccountToSearchMap);
					}
					
					columnResult.add(accountNoSearched);
					columnResult.add(linkedType);
					columnResult.add(linkedAccountNo);
					columnResult.add(linkedCustomerId);
					columnResult.add(linkedName);
					columnResult.add(forceLink);
					// columnResult.add(linkedCustomerType);
					columnResult.add(accountFoundInTab);
					columnResult.add(transactedCount);
					columnResult.add(transactedAmount);
					columnResult.add(duplicateValue);
   					columnResult.add(totalAlertedCount);
					columnResult.add(totalCTCYCount);
					columnResult.add(entityIcon);
					columnResult.add(transactionRisk);
					columnResult.add(customerRisk);
					columnResult.add(forceLinkComments);
					rowResult.add(columnResult);
				}
			}
			accountsToSearch.put(nextTabName, accountsMap);
			Map<String, List<List<String>>> tabMap = new LinkedHashMap<String, List<List<String>>>();
			tabMap.put("listResultHeader", headerRow);
			tabMap.put("listResultData", rowResult);
			mainMap.put(tabName, tabMap);
		}
		mainMap.put("TABORDER", tabOrder);
		return mainMap;
	}
	
	public Map<String, Object> getLinkedTracerForGraph(String accountNumber, String customerId, String customerName, String fromDate, String toDate, 
			boolean isStaticLinks, boolean isTransactionLinks, int minLinksCount, String counterAccountNo, int levelCount, String l_strExcludedProductCode,
			String counterAccountGroup){
		Map<String, Object> mainMap = new LinkedHashMap<String, Object>();
		// String counterAccountGroup = "";

		Map<String, String> searchedAccounts = new HashMap<String, String>();
		Map<String, Map<String, Map<String, String>>> accountsToSearch = new HashMap<String, Map<String, Map<String, String>>>();
		
		Map<String, Map<String, String>> accountsMap = new HashMap<String, Map<String, String>>();
		Map<String, String> accountMap = new HashMap<String, String>();
		accountMap.put("ACCOUNTNO", accountNumber);
		accountMap.put("CUSTOMERID", customerId);
		accountMap.put("CUSTOMERNAME", customerName);
		accountsMap.put(accountNumber, accountMap);
		
		for(int levelIncrementCount = 1; levelIncrementCount <= levelCount; levelIncrementCount++){
			String tabName = "Level_"+levelIncrementCount;
			int nextTabIndex = levelIncrementCount+1;
			String nextTabName = "Level_"+nextTabIndex;
			// System.out.println("Starting "+tabName+" tab preparation...");
			
			if(levelIncrementCount == 1){
				accountsToSearch.put(tabName, accountsMap);
			}
			
			accountsMap = new HashMap<String, Map<String, String>>();			
			List<Map<String, String>> rowResult = new ArrayList<Map<String, String>>();
			
			Map<String, List<Map<String, String>>> searchResult = getLinkedAccounts(accountsToSearch, tabName, fromDate, toDate, isStaticLinks, 
					isTransactionLinks, minLinksCount, counterAccountNo, l_strExcludedProductCode, counterAccountGroup);
			Iterator<String> mainItr = searchResult.keySet().iterator();
			while (mainItr.hasNext()) {
				String accountNoSearched = mainItr.next();
				searchedAccounts.put(accountNoSearched, tabName);
				// System.out.println("accountNoSearched : "+accountNoSearched+", "+searchedAccounts.size());
				List<Map<String, String>> linksDetailsList = searchResult.get(accountNoSearched);
				for(Map<String, String> linkDetails : linksDetailsList){
					Map<String, String> columnResult = new LinkedHashMap<String, String>();
					
					String linkedName = linkDetails.get("LINKEDNAME");
					String linkedType = linkDetails.get("LINKEDTYPE");
					String forceLink = linkDetails.get("FORCELINK");
					String linkedAccountNo = linkDetails.get("LINKEDACCOUNTNO");
					String linkedCustomerId = linkDetails.get("LINKEDCUSTOMERID");
					String linkedCustomerType = linkDetails.get("LINKEDCUSTOMERTYPE");
					String duplicateValue = linkDetails.get("DUPLICATEVALUE");
					String transactedCount = linkDetails.get("TRANSACTEDCOUNT");
					String transactedAmount = linkDetails.get("TRANSACTEDAMOUNT");
					String accountFoundInTab = "N.A."; 
					String totalAlertedCount = linkDetails.get("TOTALALERTEDCOUNT");
					String totalCTCYCount = linkDetails.get("TOTALCTCYCOUNT");
					String entityIcon = linkDetails.get("ENTITYICON");
					String transactionRisk = linkDetails.get("TRANSACTIONRISK");
					String customerRisk = linkDetails.get("CUSTOMERRISK");
					
					if(searchedAccounts.containsKey(linkedAccountNo)){
						accountFoundInTab = searchedAccounts.get(linkedAccountNo);
					}else{						
						Map<String, String> newAccountToSearchMap = new HashMap<String, String>();
						newAccountToSearchMap.put("ACCOUNTNO", linkedAccountNo);
						newAccountToSearchMap.put("CUSTOMERID", linkedCustomerId);
						newAccountToSearchMap.put("CUSTOMERNAME", linkedName);
						if(linkedCustomerType.equalsIgnoreCase("I")){
						  accountsMap.put(linkedAccountNo, newAccountToSearchMap);
						}
						//accountsMap.put(linkedAccountNo, newAccountToSearchMap);
					}
					
					columnResult.put("SEARCHACCOUNTNO", accountNoSearched);
					columnResult.put("LINKEDNAME", linkedName);
					columnResult.put("LINKEDTYPE", linkedType);
					columnResult.put("LINKEDACCOUNTNO", linkedAccountNo);
					columnResult.put("LINKEDCUSTOMERID", linkedCustomerId);
					columnResult.put("LINKEDCUSTOMERTYPE", linkedCustomerType);
					columnResult.put("FORCELINK", forceLink);
					// columnResult.add(linkedCustomerType);
					columnResult.put("IFEXISTINGTAB",accountFoundInTab);
					columnResult.put("TRANSACTEDCOUNT", transactedCount);
					columnResult.put("TRANSACTEDAMOUNT", transactedAmount);
					columnResult.put("DUPLICATEVALUE", duplicateValue);
					columnResult.put("TOTALALERTEDCOUNT", totalAlertedCount);
					columnResult.put("TOTALCTCYCOUNT", totalCTCYCount);
					columnResult.put("ENTITYICON", entityIcon);
					columnResult.put("TRANSACTIONRISK", transactionRisk);
					columnResult.put("CUSTOMERRISK", customerRisk);
					rowResult.add(columnResult);
				}
			}
			accountsToSearch.put(nextTabName, accountsMap);
			Map<String, List<Map<String, String>>> tabMap = new LinkedHashMap<String, List<Map<String, String>>>();
			tabMap.put("listResultData", rowResult);
			mainMap.put(tabName, tabMap);
		}
		return mainMap;
	}
	
	private Map<String, List<Map<String, String>>> getLinkedAccounts(Map<String, Map<String, Map<String, String>>> accountsToSearch, 
			String tabName, String fromDate, String toDate, boolean isStaticLinks, boolean isTransactionLinks, int minLinksCount, 
			String counterAccountNo, String l_strExcludedProductCode, String counterAccountGroup){
		Map<String, List<Map<String, String>>> mainMap = new LinkedHashMap<String, List<Map<String, String>>>();
		try{
			Map<String, Map<String, String>> accountsList = accountsToSearch.get(tabName);
			Iterator<String> itr = accountsList.keySet().iterator();
			while (itr.hasNext()) {
				String accountKey = itr.next();
				Map<String, String> accountMap = accountsList.get(accountKey);
				String accountNoToSearch = accountMap.get("ACCOUNTNO");
				String customerIdToSearch = accountMap.get("CUSTOMERID");
				String customerNameToSearch = accountMap.get("CUSTOMERNAME");
				
				List<Map<String, String>> resultlist = getLinkedDetails(accountNoToSearch, customerIdToSearch, customerNameToSearch, 
						fromDate, toDate, isStaticLinks, isTransactionLinks, minLinksCount, counterAccountNo, l_strExcludedProductCode, counterAccountGroup);
				mainMap.put(accountNoToSearch, resultlist);
			}
		}catch(Exception e){
			e.printStackTrace();
		}
		return mainMap;
	}
	
	
	public List<Map<String, String>> getLinkedDetails(String accountNo, String customerId, String customerName, String fromDate, String toDate, 
			boolean isStaticLinks, boolean isTransactionLinks, int minLinksCount, 
			String counterAccountNo, String l_strExcludedProductCode, String counterAccountGroup){
		List<Map<String, String>> resultMainList = new ArrayList<Map<String, String>>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String queryString = "";
		counterAccountGroup = "";
		l_strExcludedProductCode = ","+l_strExcludedProductCode+",";
		try{
			if(isStaticLinks) {
				try{
					queryString = "SELECT ROWNUM AS ROWPOSITION, JOINTACCOUNTNO LINKEDACCOUNTNO, JOINTCUSTOMERID LINKEDCUSTOMERID, JOINTHOLDERNAME LINKEDNAME, "+
								  "		  JOINTHOLDERTYPE LINKEDTYPE, "+
								  "		  NVL(TRIM(A.CUSTOMERRELATIONCODE),'N.A.') AS RELATIONCODE, "+
								  "		  FUN_DATETOCHAR(INEFFECTIVE_DATE) INEFFECTIVE_DATE, FUN_DATETOCHAR(A.UPDATETIMESTAMP) UPDATEDON, A.UPDATEDBY UPDATEDBY, "+
							      "       'N.A.' DUPLICATEVALUE, 'N.A.' TRANSACTEDCOUNT, 'N.A.' TRANSACTEDAMOUNT, "+
								  "       JOINTHOLDERTYPE ENTITYICON, 'N.A.' TRANSACTIONRISK, 'N.A.' CUSTOMERRISK "+
								  "  FROM "+schemaName+"TB_JOINTHOLDERDETAILS A "+
							      " WHERE A.JOINTACCOUNTNO = ? "; 
					/*queryString = "SELECT A.NOMINEENAME LINKEDNAME, 'NOMINEE' LINKEDTYPE, 'N.A.' LINKEDACCOUNTNO, 'N.A.'  LINKEDCUSTOMERID, "+
			          			  "       'N.A.' DUPLICATEVALUE, 'N.A.' TRANSACTEDCOUNT, 'N.A.' TRANSACTEDAMOUNT "+
			          			  "	 FROM "+schemaName+"TB_NOMINEEDETAILS A "+
			          			  " WHERE A.ACCOUNTNO = ? "; */
					preparedStatement = connection.prepareStatement(queryString);
					preparedStatement.setString(1, accountNo);
					resultSet = preparedStatement.executeQuery();
					while (resultSet.next()) {
						Map<String, String> resultMap = new HashMap<String, String>();
						resultMap.put("LINKEDNAME", resultSet.getString("LINKEDNAME"));
						resultMap.put("LINKEDTYPE", resultSet.getString("LINKEDTYPE"));
						resultMap.put("FORCELINK", getForceLinkDetails(accountNo, resultSet.getString("LINKEDCUSTOMERID"),
								resultSet.getString("LINKEDACCOUNTNO"), resultSet.getString("LINKEDNAME"), resultSet.getString("LINKEDTYPE")));
						resultMap.put("LINKEDACCOUNTNO", resultSet.getString("LINKEDACCOUNTNO"));
						resultMap.put("LINKEDCUSTOMERID", resultSet.getString("LINKEDCUSTOMERID"));
						resultMap.put("LINKEDCUSTOMERTYPE", "I" );
						resultMap.put("DUPLICATEVALUE", resultSet.getString("DUPLICATEVALUE"));
						resultMap.put("TRANSACTEDCOUNT", resultSet.getString("TRANSACTEDCOUNT"));
						resultMap.put("TRANSACTEDAMOUNT", resultSet.getString("TRANSACTEDAMOUNT"));
						resultMap.put("TOTALALERTEDCOUNT", "N.A.");
						resultMap.put("TOTALCTCYCOUNT", "N.A.");
						resultMap.put("ENTITYICON", resultSet.getString("ENTITYICON"));
						resultMap.put("TRANSACTIONRISK", resultSet.getString("TRANSACTIONRISK"));
						resultMap.put("CUSTOMERRISK", resultSet.getString("CUSTOMERRISK"));
						resultMainList.add(resultMap);
					}
				}catch(Exception ex){
					ex.printStackTrace();
				}finally{
					try{ if(preparedStatement != null){preparedStatement.close();}}catch(Exception e){}
				}
				
				try{
					queryString = "SELECT A.INTRODUCERNAME LINKEDNAME, 'INTRODUCER' LINKEDTYPE, 'N.A.' LINKEDACCOUNTNO, "+
			          			  "       NVL(TRIM(INTRODUCERCUSTOMERID),'N.A.') LINKEDCUSTOMERID, "+
			          			  "       'N.A.' DUPLICATEVALUE, 'N.A.' TRANSACTEDCOUNT, 'N.A.' TRANSACTEDAMOUNT, "+
								  "       A.CUSTOMERTYPE LINKEDCUSTOMERTYPE, "+
								  "       A.CUSTOMERTYPE||'.png' ENTITYICON, 'N.A.' TRANSACTIONRISK, A.RISKRATING CUSTOMERRISK "+
			          			  "	 FROM "+schemaName+"TB_CUSTOMERMASTER A "+
			          			  " WHERE A.CUSTOMERID = ? "+
								  "   AND NVL(TRIM(INTRODUCERCUSTOMERID),TRIM(A.INTRODUCERNAME)) IS NOT NULL ";
								  
					preparedStatement = connection.prepareStatement(queryString);
					preparedStatement.setString(1, customerId);
					resultSet = preparedStatement.executeQuery();
					while (resultSet.next()) {
						Map<String, String> resultMap = new HashMap<String, String>();
						resultMap.put("LINKEDNAME", resultSet.getString("LINKEDNAME"));
						resultMap.put("LINKEDTYPE", resultSet.getString("LINKEDTYPE"));
						resultMap.put("FORCELINK", getForceLinkDetails(accountNo, resultSet.getString("LINKEDCUSTOMERID"),
								resultSet.getString("LINKEDACCOUNTNO"), resultSet.getString("LINKEDNAME"), resultSet.getString("LINKEDTYPE")));
						resultMap.put("LINKEDACCOUNTNO", resultSet.getString("LINKEDACCOUNTNO"));
						resultMap.put("LINKEDCUSTOMERID", resultSet.getString("LINKEDCUSTOMERID"));
						//resultMap.put("LINKEDCUSTOMERTYPE", "I");
						resultMap.put("LINKEDCUSTOMERTYPE", resultSet.getString("LINKEDCUSTOMERTYPE"));
						resultMap.put("DUPLICATEVALUE", resultSet.getString("DUPLICATEVALUE"));
						resultMap.put("TRANSACTEDCOUNT", resultSet.getString("TRANSACTEDCOUNT"));
						resultMap.put("TRANSACTEDAMOUNT", resultSet.getString("TRANSACTEDAMOUNT"));
						resultMap.put("TOTALALERTEDCOUNT", "N.A.");
						resultMap.put("TOTALCTCYCOUNT", "N.A.");
						resultMap.put("ENTITYICON", resultSet.getString("ENTITYICON"));
						resultMap.put("TRANSACTIONRISK", resultSet.getString("TRANSACTIONRISK"));
						resultMap.put("CUSTOMERRISK", resultSet.getString("CUSTOMERRISK"));
						resultMainList.add(resultMap);
					}
				}catch(Exception ex){
					ex.printStackTrace();
				}finally{
					try{ if(preparedStatement != null){preparedStatement.close();}}catch(Exception e){}
				}
				
				String voterIdentityCardNo = "";
				String drivingLicenseNo = "";
				String passportNo = "";
				String panNo = "";
				String mobileNo = "";

				try{
					queryString = " SELECT NVL(TRIM(VOTERIDENTITYCARDNO),'NOTAVAILABLE') VOTERIDENTITYCARDNO, "+
			          			  "        NVL(TRIM(DRIVINGLICENSENO),'NOTAVAILABLE') DRIVINGLICENSENO, "+
			          			  "        NVL(TRIM(PASSPORTNO),'NOTAVAILABLE') PASSPORTNO, NVL(TRIM(PANNO),'NOTAVAILABLE') PANNO, "+
			          			  "		   NVL(TRIM(MOBILENO_10DIGITS), 'NOTAVAILABLE') MOBILENO "+
			          			  "   FROM "+schemaName+"TB_CUSTOMERMASTER A "+
			          			  "  WHERE A.CUSTOMERID = ? ";
					preparedStatement = connection.prepareStatement(queryString);
					preparedStatement.setString(1, customerId);
					resultSet = preparedStatement.executeQuery();
					while (resultSet.next()) {
						voterIdentityCardNo = resultSet.getString("VOTERIDENTITYCARDNO");
						drivingLicenseNo = resultSet.getString("DRIVINGLICENSENO");
						passportNo = resultSet.getString("PASSPORTNO");
						panNo = resultSet.getString("PANNO");
						mobileNo = resultSet.getString("MOBILENO");
					}
					
					
					queryString = "SELECT A.CUSTOMERNAME LINKEDNAME, 'DUPLICATE PANNO' LINKEDTYPE, NVL(B.ACCOUNTNO, 'N.A.') LINKEDACCOUNTNO, A.CUSTOMERID LINKEDCUSTOMERID, "+
			          			  "       PANNO DUPLICATEVALUE, 'N.A.' TRANSACTEDCOUNT, 'N.A.' TRANSACTEDAMOUNT,  A.CUSTOMERTYPE LINKEDCUSTOMERTYPE, "+
								  "       A.CUSTOMERTYPE||'.png' ENTITYICON, 'N.A.' TRANSACTIONRISK, A.RISKRATING CUSTOMERRISK "+
			          			  "	 FROM "+schemaName+"TB_CUSTOMERMASTER A "+
			          			  "  LEFT OUTER JOIN "+schemaName+"TB_ACCOUNTSMASTER B ON A.CUSTOMERID = B.CUSTOMERID "+
			          			  " WHERE A.PANNO = ? ";//+
//			          			  "   AND A.CUSTOMERID <> '"+l_strCustomerId+"' " ; 
					preparedStatement = connection.prepareStatement(queryString);
					preparedStatement.setString(1, panNo);
					resultSet = preparedStatement.executeQuery();
					while (resultSet.next()) {
						if(!resultSet.getString("LINKEDCUSTOMERID").equals(customerId)) {
							Map<String, String> resultMap = new HashMap<String, String>();
							resultMap.put("LINKEDNAME", resultSet.getString("LINKEDNAME"));
							resultMap.put("LINKEDTYPE", resultSet.getString("LINKEDTYPE"));
							resultMap.put("FORCELINK", getForceLinkDetails(accountNo, resultSet.getString("LINKEDCUSTOMERID"),
									resultSet.getString("LINKEDACCOUNTNO"), resultSet.getString("LINKEDNAME"), resultSet.getString("LINKEDTYPE")));
							resultMap.put("LINKEDACCOUNTNO", resultSet.getString("LINKEDACCOUNTNO"));
							resultMap.put("LINKEDCUSTOMERID", resultSet.getString("LINKEDCUSTOMERID"));
							//resultMap.put("LINKEDCUSTOMERTYPE", "I");
							resultMap.put("LINKEDCUSTOMERTYPE", resultSet.getString("LINKEDCUSTOMERTYPE"));
							resultMap.put("DUPLICATEVALUE", resultSet.getString("DUPLICATEVALUE"));
							resultMap.put("TRANSACTEDCOUNT", resultSet.getString("TRANSACTEDCOUNT"));
							resultMap.put("TRANSACTEDAMOUNT", resultSet.getString("TRANSACTEDAMOUNT"));
							resultMap.put("TOTALALERTEDCOUNT", "N.A.");
							resultMap.put("TOTALCTCYCOUNT", "N.A.");
							resultMap.put("ENTITYICON", resultSet.getString("ENTITYICON"));
							resultMap.put("TRANSACTIONRISK", resultSet.getString("TRANSACTIONRISK"));
							resultMap.put("CUSTOMERRISK", resultSet.getString("CUSTOMERRISK"));

							resultMainList.add(resultMap);
						}
					}
					
					
					queryString = "SELECT A.CUSTOMERNAME LINKEDNAME, 'DUPLICATE PASSPORTNO' LINKEDTYPE, NVL(B.ACCOUNTNO, 'N.A.') LINKEDACCOUNTNO,  "+
			          			  "       A.CUSTOMERID LINKEDCUSTOMERID, PASSPORTNO DUPLICATEVALUE, 'N.A.' TRANSACTEDCOUNT, 'N.A.' TRANSACTEDAMOUNT, "+
								  "		  A.CUSTOMERTYPE LINKEDCUSTOMERTYPE, "+
			          			  "       A.CUSTOMERTYPE||'.png' ENTITYICON, 'N.A.' TRANSACTIONRISK, A.RISKRATING CUSTOMERRISK "+
			          			  "	 FROM "+schemaName+"TB_CUSTOMERMASTER A "+
			          			  "  LEFT OUTER JOIN "+schemaName+"TB_ACCOUNTSMASTER B ON A.CUSTOMERID = B.CUSTOMERID "+
			          			  " WHERE A.PASSPORTNO = ? ";//+
//			          			  "   AND A.CUSTOMERID <> '"+l_strCustomerId+"' " ;					
					preparedStatement = connection.prepareStatement(queryString);
					preparedStatement.setString(1, passportNo);
					resultSet = preparedStatement.executeQuery();
					while (resultSet.next()) {
						if(!resultSet.getString("LINKEDCUSTOMERID").equals(customerId)) {
							Map<String, String> resultMap = new HashMap<String, String>();
							resultMap.put("LINKEDNAME", resultSet.getString("LINKEDNAME"));
							resultMap.put("LINKEDTYPE", resultSet.getString("LINKEDTYPE"));
							resultMap.put("FORCELINK", getForceLinkDetails(accountNo, resultSet.getString("LINKEDCUSTOMERID"),
									resultSet.getString("LINKEDACCOUNTNO"), resultSet.getString("LINKEDNAME"), resultSet.getString("LINKEDTYPE")));
							resultMap.put("LINKEDACCOUNTNO", resultSet.getString("LINKEDACCOUNTNO"));
							resultMap.put("LINKEDCUSTOMERID", resultSet.getString("LINKEDCUSTOMERID"));
							//resultMap.put("LINKEDCUSTOMERTYPE", "I");
							resultMap.put("LINKEDCUSTOMERTYPE", resultSet.getString("LINKEDCUSTOMERTYPE"));
							resultMap.put("DUPLICATEVALUE", resultSet.getString("DUPLICATEVALUE"));
							resultMap.put("TRANSACTEDCOUNT", resultSet.getString("TRANSACTEDCOUNT"));
							resultMap.put("TRANSACTEDAMOUNT", resultSet.getString("TRANSACTEDAMOUNT"));
							resultMap.put("TOTALALERTEDCOUNT", "N.A.");
							resultMap.put("TOTALCTCYCOUNT", "N.A.");
							resultMap.put("ENTITYICON", resultSet.getString("ENTITYICON"));
							resultMap.put("TRANSACTIONRISK", resultSet.getString("TRANSACTIONRISK"));
							resultMap.put("CUSTOMERRISK", resultSet.getString("CUSTOMERRISK"));
							resultMainList.add(resultMap);
						}
					}
					
					
					queryString = "SELECT A.CUSTOMERNAME LINKEDNAME, 'DUPLICATE MOBILENO' LINKEDTYPE, NVL(B.ACCOUNTNO, 'N.A.') LINKEDACCOUNTNO, A.CUSTOMERID LINKEDCUSTOMERID, "+
			          			  "       MOBILENO_10DIGITS DUPLICATEVALUE, 'N.A.' TRANSACTEDCOUNT, 'N.A.' TRANSACTEDAMOUNT, "+
								  "		  A.CUSTOMERTYPE LINKEDCUSTOMERTYPE, "+
			          			  "       A.CUSTOMERTYPE||'.png' ENTITYICON, 'N.A.' TRANSACTIONRISK, A.RISKRATING CUSTOMERRISK "+
			          			  "	 FROM "+schemaName+"TB_CUSTOMERMASTER A "+
			          			  "  LEFT OUTER JOIN "+schemaName+"TB_ACCOUNTSMASTER B ON A.CUSTOMERID = B.CUSTOMERID "+
			          			  " WHERE A.MOBILENO_10DIGITS = ? ";//+
	//		          			  "   AND A.CUSTOMERID <> '"+l_strCustomerId+"' " ; 
					preparedStatement = connection.prepareStatement(queryString);
					preparedStatement.setString(1, mobileNo);
					resultSet = preparedStatement.executeQuery();
					while (resultSet.next()) {
						if(!resultSet.getString("LINKEDCUSTOMERID").equals(customerId)) {
							Map<String, String> resultMap = new HashMap<String, String>();
							resultMap.put("LINKEDNAME", resultSet.getString("LINKEDNAME"));
							resultMap.put("LINKEDTYPE", resultSet.getString("LINKEDTYPE"));
							resultMap.put("FORCELINK", getForceLinkDetails(accountNo, resultSet.getString("LINKEDCUSTOMERID"),
									resultSet.getString("LINKEDACCOUNTNO"), resultSet.getString("LINKEDNAME"), resultSet.getString("LINKEDTYPE")));
							resultMap.put("LINKEDACCOUNTNO", resultSet.getString("LINKEDACCOUNTNO"));
							resultMap.put("LINKEDCUSTOMERID", resultSet.getString("LINKEDCUSTOMERID"));
							resultMap.put("LINKEDCUSTOMERTYPE", "I");
							resultMap.put("DUPLICATEVALUE", resultSet.getString("DUPLICATEVALUE"));
							resultMap.put("TRANSACTEDCOUNT", resultSet.getString("TRANSACTEDCOUNT"));
							resultMap.put("TRANSACTEDAMOUNT", resultSet.getString("TRANSACTEDAMOUNT"));
							resultMap.put("TOTALALERTEDCOUNT", "N.A.");
							resultMap.put("TOTALCTCYCOUNT", "N.A.");
							resultMap.put("ENTITYICON", resultSet.getString("ENTITYICON"));
							resultMap.put("TRANSACTIONRISK", resultSet.getString("TRANSACTIONRISK"));
							resultMap.put("CUSTOMERRISK", resultSet.getString("CUSTOMERRISK"));
							resultMainList.add(resultMap);
						}
					}
					
					/*
					queryString = "SELECT A.CUSTOMERNAME LINKEDNAME, 'DUPLICATE DRIVINGLICENSENO' LINKEDTYPE, 'N.A.' LINKEDACCOUNTNO, "+
			          			  "       A.CUSTOMERID LINKEDCUSTOMERID, DRIVINGLICENSENO DUPLICATEVALUE, 'N.A.' TRANSACTEDCOUNT, 'N.A.' TRANSACTEDAMOUNT "+
			          			  "	 FROM "+schemaName+"TB_CUSTOMERMASTER A "+
			          			  " WHERE A.DRIVINGLICENSENO = ? ";
//								  "   AND A.CUSTOMERID <> '"+l_strCustomerId+"' " ;		
					preparedStatement = connection.prepareStatement(queryString);
					preparedStatement.setString(1, drivingLicenseNo);
					resultSet = preparedStatement.executeQuery();
					while (resultSet.next()) {
						if(!resultSet.getString("LINKEDCUSTOMERID").equals(customerId)) {
							Map<String, String> resultMap = new HashMap<String, String>();
							resultMap.put("LINKEDNAME", resultSet.getString("LINKEDNAME"));
							resultMap.put("LINKEDTYPE", resultSet.getString("LINKEDTYPE"));
							resultMap.put("FORCELINK", "None");
							resultMap.put("LINKEDACCOUNTNO", resultSet.getString("LINKEDACCOUNTNO"));
							resultMap.put("LINKEDCUSTOMERID", resultSet.getString("LINKEDCUSTOMERID"));
							resultMap.put("LINKEDCUSTOMERTYPE", "I");
							resultMap.put("DUPLICATEVALUE", resultSet.getString("DUPLICATEVALUE"));
							resultMap.put("TRANSACTEDCOUNT", resultSet.getString("TRANSACTEDCOUNT"));
							resultMap.put("TRANSACTEDAMOUNT", resultSet.getString("TRANSACTEDAMOUNT"));
							
							resultMainMap.put("DRIVINGLICENSEDETAILS", resultMap);
						}
					}
					
					
					queryString = "SELECT A.CUSTOMERNAME LINKEDNAME, 'DUPLICATE VOTERIDENTITYCARDNO' LINKEDTYPE, 'N.A.' LINKEDACCOUNTNO, "+
								  "       A.CUSTOMERID LINKEDCUSTOMERID, VOTERIDENTITYCARDNO DUPLICATEVALUE, 'N.A.' TRANSACTEDCOUNT, "+
								  "       'N.A.' TRANSACTEDAMOUNT "+
								  "	 FROM "+schemaName+"TB_CUSTOMERMASTER A "+
								  " WHERE A.VOTERIDENTITYCARDNO = ? ";//+
//					  "   AND A.CUSTOMERID <> '"+l_strCustomerId+"' " ;		
					preparedStatement = connection.prepareStatement(queryString);
					preparedStatement.setString(1, voterIdentityCardNo);
					resultSet = preparedStatement.executeQuery();
					while (resultSet.next()) {
						if(!resultSet.getString("LINKEDCUSTOMERID").equals(customerId)) {
							Map<String, String> resultMap = new HashMap<String, String>();
							resultMap.put("LINKEDNAME", resultSet.getString("LINKEDNAME"));
							resultMap.put("LINKEDTYPE", resultSet.getString("LINKEDTYPE"));
							resultMap.put("FORCELINK", "None");
							resultMap.put("LINKEDACCOUNTNO", resultSet.getString("LINKEDACCOUNTNO"));
							resultMap.put("LINKEDCUSTOMERID", resultSet.getString("LINKEDCUSTOMERID"));
							resultMap.put("LINKEDCUSTOMERTYPE", "I");
							resultMap.put("DUPLICATEVALUE", resultSet.getString("DUPLICATEVALUE"));
							resultMap.put("TRANSACTEDCOUNT", resultSet.getString("TRANSACTEDCOUNT"));
							resultMap.put("TRANSACTEDAMOUNT", resultSet.getString("TRANSACTEDAMOUNT"));
							
							resultMainMap.put("VOTERIDENTITYCARDDETAILS", resultMap);
						}
					}
					
					*/
				}catch(Exception ex){
					ex.printStackTrace();
				}finally{
					try{ if(preparedStatement != null){preparedStatement.close();}}catch(Exception e){}
				}
			}
			
			//isTransactionLinks = false;
			if(isTransactionLinks){
				/*
				queryString = "SELECT CASE WHEN INSTR(A.COUNTERPARTYNAME,',') > 1 "+
		          "            THEN SUBSTR(A.COUNTERPARTYNAME,1,INSTR(A.COUNTERPARTYNAME,',')-1) "+
		          "            ELSE A.COUNTERPARTYNAME END LINKEDNAME, "+
		        */      
				String strProductCode = "N.A.";
				//queryString = "SELECT PRODUCTCODE FROM "+schemaName+"TB_ACCOUNTSMASTER A WHERE A.ACCOUNTNO = '"+accountNo+"' ";
				queryString = "SELECT PRODUCTCODE FROM "+schemaName+"TB_ACCOUNTSMASTER A WHERE A.ACCOUNTNO = ? ";
				// System.out.println("Accounts queryString:  "+queryString);
				preparedStatement = connection.prepareStatement(queryString);
				preparedStatement.setString(1, accountNo);
				resultSet = preparedStatement.executeQuery();
				while(resultSet.next()){
					strProductCode = ","+resultSet.getString("PRODUCTCODE")+","; 
				}
				
				queryString = "SELECT A.COUNTERPARTYNAME LINKEDNAME, "+
					          "       'TRANSACTION' LINKEDTYPE, COUNTERACCOUNTNO LINKEDACCOUNTNO, "+
					          "       NVL(TRIM(A.COUNTERPARTYID),'N.A.') LINKEDCUSTOMERID, COUNTERPARTYTYPE LINKEDCUSTOMERTYPE, "+
					          "       'N.A.' DUPLICATEVALUE, TRANSACTEDCOUNT, TRANSACTEDAMOUNT, TOTALALERTEDCOUNT, TOTALCTCYCOUNT, "+
					          "		  COUNTERENTITYICON, TRANSACTIONRISK, 'N.A.' CUSTOMERRISK "+
					          "  FROM "+
					          " ( SELECT ACCOUNTNO , COUNTERACCOUNTNO, NVL(TRIM(COUNTERPARTYID),'N.A.') COUNTERPARTYID, "+
					          "          NVL(TRIM(COUNTERPARTYTYPE),'I') COUNTERPARTYTYPE, COUNT(*) TRANSACTEDCOUNT, "+
				              "          SUM(AMOUNT) TRANSACTEDAMOUNT, "+
					          //"          LISTAGG(COUNTERPARTYNAME, ',') WITHIN GROUP (ORDER BY ACCOUNTNO) AS COUNTERPARTYNAME "+
					          "          MAX(COUNTERPARTYNAME) AS COUNTERPARTYNAME, "+
					          "          SUM(COUNTOFALERTS) TOTALALERTEDCOUNT, "+
				              "          SUM(CASE WHEN ISCRYPTOTRANSACTIONS = 'Y' THEN 1 ELSE 0 END) TOTALCTCYCOUNT, "+
					          "          NVL(TRIM(CUSTOMERTYPE||'.png'),'entity.png') COUNTERENTITYICON,  A.RISKSCORE TRANSACTIONRISK "+
					  		  "	    FROM "+schemaName+"TB_TRANSACTIONS A "+
							  "	   WHERE 1 = 1 ";
				
				//if(strProductCode.equalsIgnoreCase("DUMMY"))
				// System.out.println("starting accountNo:  "+accountNo);
				// System.out.println("l_strExcludedProductCode:  "+l_strExcludedProductCode+" and strProductCode: "+strProductCode);
				// System.out.println("l_strExcludedProductCode.contains(strProductCode): "+l_strExcludedProductCode.contains(strProductCode));
				if(l_strExcludedProductCode.contains(strProductCode))
					queryString = queryString + " AND 1 = 0 ";
				/*
				if(fromDate != null && !fromDate.equals(""))
					queryString = queryString + " AND A.TRANSACTIONDATETIME >= FUN_CHARTODATE('"+fromDate+"' ) "; 
				if(toDate != null && !toDate.equals("")) 
					queryString = queryString + " AND A.TRANSACTIONDATETIME <  FUN_CHARTODATE('"+toDate+"' ) + 1 "; 

				queryString = queryString + 
		          			  "      AND A.ACCOUNTNO = '"+accountNo+"' ";

				if(counterAccountNo != null && !counterAccountNo.equals("")) 
					queryString = queryString + 
		          			  "      AND A.COUNTERACCOUNTNO = '"+counterAccountNo+"' ";
				else
					queryString = queryString + 
							  "      AND TRIM(A.COUNTERACCOUNTNO) IS NOT NULL ";
                
				if(counterAccountGroup != null && !counterAccountGroup.equals("")) 
					queryString = queryString + 
		          			  "      AND A.COUNTERACCOUNTNO IN "+
		          			  "  (SELECT B.ACCOUNTNO FROM "+schemaName+"TB_ACCOUNTGROUPMAPPING B WHERE B.GROUPCODE = '"+counterAccountGroup+"') ";
                */
				if(fromDate != null && !fromDate.equals(""))
					queryString = queryString + " AND A.TRANSACTIONDATETIME >= FUN_CHARTODATE(?) "; 
				if(toDate != null && !toDate.equals("")) 
					queryString = queryString + " AND A.TRANSACTIONDATETIME <  FUN_CHARTODATE(?) + 1 "; 

				queryString = queryString + 
		          			  "      AND A.ACCOUNTNO = ? ";

				if(counterAccountNo != null && !counterAccountNo.equals("")) 
					queryString = queryString + 
		          			  "      AND A.COUNTERACCOUNTNO = ? ";
				else
					queryString = queryString + 
							  "      AND TRIM(A.COUNTERACCOUNTNO) IS NOT NULL ";
                
				if(counterAccountGroup != null && !counterAccountGroup.equals("")) 
					queryString = queryString + 
		          			  "      AND A.COUNTERACCOUNTNO IN "+
		          			  "  (SELECT B.ACCOUNTNO FROM "+schemaName+"TB_ACCOUNTGROUPMAPPING B WHERE B.GROUPCODE = ?) ";

				/* 
				queryString = queryString + 
    			  "      AND A.PRODUCTCODE NOT IN ('DUMMY') ";
                */ 
				/*
				queryString = queryString + 
    			  "      AND A.TRANSACTIONTYPE LIKE 'T%' ";
    			*/
				queryString = queryString + 
				  			  "    GROUP BY ACCOUNTNO , COUNTERACCOUNTNO, NVL(TRIM(COUNTERPARTYID),'N.A.'), NVL(TRIM(COUNTERPARTYTYPE),'I'), "+
				  			  "			 NVL(TRIM(CUSTOMERTYPE||'.png'),'entity.png'), RISKSCORE ";
				if(minLinksCount > 1)
					//queryString = queryString + " HAVING COUNT(1) >= "+minLinksCount+" ";
					queryString = queryString + " HAVING COUNT(1) >= ? ";

				queryString = queryString + " ) A "; 
				
				 System.out.println("queryString:  "+queryString);
				 //System.out.println(fromDate+" --- "+toDate+" --- "+accountNo+" --- "+counterAccountNo+" --- "+minLinksCount);
				int count = 1;
				preparedStatement = connection.prepareStatement(queryString);
				if(fromDate != null && !fromDate.equals("")){
					preparedStatement.setString(count, fromDate);
				    count++;
			    }    
				if(toDate != null && !toDate.equals("")){
					preparedStatement.setString(count, toDate);
				    count++;
			    }     
				preparedStatement.setString(count, accountNo);
			    count++;

				if(counterAccountNo != null && !counterAccountNo.equals("")){
					preparedStatement.setString(count, counterAccountNo);
				    count++;
			    }
                
				if(counterAccountGroup != null && !counterAccountGroup.equals("")){
					preparedStatement.setString(count, counterAccountGroup);
				    count++;
			    } 
				if(minLinksCount > 1){
					preparedStatement.setInt(count, minLinksCount);
				    count++;
			    } 
				resultSet = preparedStatement.executeQuery();
				while(resultSet.next()){
					Map<String, String> resultMap = new HashMap<String, String>();
					resultMap.put("LINKEDNAME", resultSet.getString("LINKEDNAME"));
					resultMap.put("LINKEDTYPE", resultSet.getString("LINKEDTYPE"));
					resultMap.put("FORCELINK", getForceLinkDetails(accountNo, resultSet.getString("LINKEDCUSTOMERID"),
							resultSet.getString("LINKEDACCOUNTNO"), resultSet.getString("LINKEDNAME"), resultSet.getString("LINKEDTYPE")));
					resultMap.put("LINKEDACCOUNTNO", resultSet.getString("LINKEDACCOUNTNO"));
					resultMap.put("LINKEDCUSTOMERID", resultSet.getString("LINKEDCUSTOMERID"));
					resultMap.put("LINKEDCUSTOMERTYPE", resultSet.getString("LINKEDCUSTOMERTYPE"));
					resultMap.put("DUPLICATEVALUE", resultSet.getString("DUPLICATEVALUE"));
					resultMap.put("TRANSACTEDCOUNT", resultSet.getString("TRANSACTEDCOUNT"));
					resultMap.put("TRANSACTEDAMOUNT", resultSet.getString("TRANSACTEDAMOUNT"));
					resultMap.put("TOTALALERTEDCOUNT", resultSet.getString("TOTALALERTEDCOUNT"));
					resultMap.put("TOTALCTCYCOUNT", resultSet.getString("TOTALCTCYCOUNT"));
					resultMap.put("ENTITYICON", resultSet.getString("COUNTERENTITYICON"));
					resultMap.put("TRANSACTIONRISK", resultSet.getString("TRANSACTIONRISK"));
					resultMap.put("CUSTOMERRISK", resultSet.getString("CUSTOMERRISK"));
					//System.out.println(resultMap);
					resultMainList.add(resultMap);
				}
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		//System.out.println(resultMainList);
		return resultMainList;
	}
	
	public String getForceLinkDetails(String accountNo, String linkedCustId, String linkedAccountNo, String linkedCustName, String linkType){
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String forceLinkWithComments = "None";
		try{
			String queryString = "SELECT FORCEDLINKEDTYPE, NVL(USERCOMMENTS, 'None') USERCOMMENTS "+
	  		  					 "  FROM "+schemaName+"TB_ACCOUNTFORCEDLINK A "+
	  		  					 " WHERE A.ACCOUNTNO = ? "+
	  		  					 "   AND LINKEDCUSTID = (CASE WHEN LINKEDCUSTID = 'N.A.' THEN LINKEDCUSTID ELSE ? END) "+
	  		  					 "   AND LINKEDACCTNO = (CASE WHEN LINKEDACCTNO = 'N.A.' THEN LINKEDACCTNO ELSE ? END) "+
	  		  					 "   AND LINKEDCUSTNAME = ? "+
	  		  					 "   AND LINKEDTYPE = ? ";
			preparedStatement = connection.prepareStatement(queryString);
			preparedStatement.setString(1, accountNo);
			preparedStatement.setString(2, linkedCustId);
			preparedStatement.setString(3, linkedAccountNo);
			preparedStatement.setString(4, linkedCustName);
			preparedStatement.setString(5, linkType);
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()){
				forceLinkWithComments = resultSet.getString("FORCEDLINKEDTYPE")+"~"+resultSet.getString("USERCOMMENTS");
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return forceLinkWithComments;
	}
	
	public String getExcludedProductCodes(){
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String productCodes = "";
		try{
			preparedStatement = connection.prepareStatement("SELECT EXCLUDEDPRODUCTCODES FROM "+schemaName+"TB_ENTITYTRACER_CONFIG ");
			resultSet = preparedStatement.executeQuery();
			while (resultSet.next()) {
				productCodes = resultSet.getString("EXCLUDEDPRODUCTCODES");
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return productCodes;
	}
	
	public ArrayList<String> getAccountGroups(){
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		ArrayList<String> accountGropus = new ArrayList<String>();
		try{
			preparedStatement = connection.prepareStatement("SELECT GROUPCODE FROM "+schemaName+"TB_ACCOUNTGROUPMAPPING ");
			resultSet = preparedStatement.executeQuery();
			while (resultSet.next()) {
				accountGropus.add(resultSet.getString("GROUPCODE"));
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return accountGropus;
	}
	
	public HashMap<String, Object> getInitialParameters(){
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String productCodes = "";
		ArrayList<String> accountGropus = new ArrayList<String>();
		HashMap<String, Object> initialParameters = new HashMap<String, Object>();
		try{
			preparedStatement = connection.prepareStatement("SELECT EXCLUDEDPRODUCTCODES FROM "+schemaName+"TB_ENTITYTRACER_CONFIG ");
			resultSet = preparedStatement.executeQuery();
			while (resultSet.next()) {
				productCodes = resultSet.getString("EXCLUDEDPRODUCTCODES");
			}
			initialParameters.put("EXCLUDEDPRODUCTCODES", productCodes);
			
			preparedStatement = connection.prepareStatement("SELECT GROUPCODE FROM "+schemaName+"TB_ACCOUNTGROUPMAPPING ");
			resultSet = preparedStatement.executeQuery();
			while (resultSet.next()) {
				accountGropus.add(resultSet.getString("GROUPCODE"));
			}
			initialParameters.put("ACCOUNTGROUPS", accountGropus);
			
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return initialParameters;
	}
	
	public String saveEntityLinkedDetails(String accountNumber, String customerId, String customerName, String fromDate, String toDate, 
			String isStaticLinks, String isTransactionLinks, int minLinksCount, String counterAccountNo, 
			int levelCount, String productCode, String userCode) {
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareStatement("UPDATE "+schemaName+"TB_ENTITYTRACER_CONFIG SET EXCLUDEDPRODUCTCODES = ? ");
			preparedStatement.setString(1, productCode);
			preparedStatement.executeUpdate();
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return productCode;
	}
	
	public void saveEntityForceLink(String forceLink, String accountNo, String linkType, String linkedAccountNo, String linkedCustId, 
			String linkCustName, String userComments, String updateBy, String terminalId){
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		int countVal = 0;
		try{
			String queryString = "SELECT COUNT(*) FROM "+schemaName+"TB_ACCOUNTFORCEDLINK "+
	          					 " WHERE ACCOUNTNO = ? "+
	          					 "   AND LINKEDCUSTID = ? "+
	          					 "   AND LINKEDACCTNO = ? "+
	          					 "   AND LINKEDCUSTNAME = ? "+
	          					 "   AND LINKEDTYPE = ? ";
			preparedStatement = connection.prepareStatement(queryString);
			preparedStatement.setString(1, accountNo);
			preparedStatement.setString(2, linkedCustId);
			preparedStatement.setString(3, linkedAccountNo);
			preparedStatement.setString(4, linkCustName);
			preparedStatement.setString(5, linkType);
			resultSet = preparedStatement.executeQuery();
			if(resultSet.next()) {
				countVal = resultSet.getInt(1);
			}

			if(countVal == 0) {
				queryString = "INSERT INTO "+schemaName+"TB_ACCOUNTFORCEDLINK(ACCOUNTNO, LINKEDCUSTID, LINKEDACCTNO, LINKEDCUSTNAME, LINKEDTYPE, FORCEDLINKEDTYPE, "+
							  "       USERCOMMENTS, UPDATEDBY , UPDATETIMESTAMP) VALUES(?, ?, ?, ?, ?, ?, ?, ?, SYSTIMESTAMP) ";
				preparedStatement= connection.prepareStatement(queryString);
				preparedStatement.setString(1, accountNo);
				preparedStatement.setString(2, linkedCustId);
				preparedStatement.setString(3, linkedAccountNo);
				preparedStatement.setString(4, linkCustName);
				preparedStatement.setString(5, linkType);
				preparedStatement.setString(6, forceLink);
				preparedStatement.setString(7, userComments);
				preparedStatement.setString(8, updateBy);
			} else {
				queryString = "UPDATE "+schemaName+"TB_ACCOUNTFORCEDLINK SET FORCEDLINKEDTYPE = ?, USERCOMMENTS = ?, UPDATEDBY = ?, UPDATETIMESTAMP = SYSTIMESTAMP "+
							  " WHERE ACCOUNTNO = ? "+
							  "   AND LINKEDCUSTID = ? "+
							  "   AND LINKEDACCTNO = ? "+
							  "   AND LINKEDCUSTNAME = ? "+
							  "   AND LINKEDTYPE = ? ";
				preparedStatement= connection.prepareStatement(queryString);
				preparedStatement.setString(1, forceLink);
				preparedStatement.setString(2, userComments);
				preparedStatement.setString(3, updateBy);
				preparedStatement.setString(4, accountNo);
				preparedStatement.setString(5, linkedCustId);
				preparedStatement.setString(6, linkedAccountNo);
				preparedStatement.setString(7, linkCustName);
				preparedStatement.setString(8, linkType);
			}
			preparedStatement.executeUpdate();
			
			queryString = " INSERT INTO "+schemaName+"TB_USERLOG (USERCODE, LOGMESSAGE, LOGDATETIME, TERMINALNAME, MODULE, LOGTYPE) " +
		      			  " VALUES (?,'Forced Link updated for account no '||'"+accountNo+"', SYSTIMESTAMP, ?,'LINKTRACER','0') ";
			preparedStatement = connection.prepareStatement(queryString);
			preparedStatement.setString(1, updateBy);
			preparedStatement.setString(2, terminalId);
			preparedStatement.executeUpdate();

		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
	}
	
	public List<Map<String, String>> getLinkedTransactions(String fromDate, String toDate, String accountNo, String linkedAcctountNo){
		List<Map<String, String>> linkedTxns = new ArrayList<Map<String, String>>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String sql = "";
		int count = 1;
		try{
			sql = "SELECT ROWNUM AS ROWPOSITION, TRANSACTIONNO, TRANSACTIONBATCHID||'/'||TRANSACTIONID TRANSACTIONID, "+
			      "       INSTRUMENTCODE, INSTRUMENTNO, FUN_DATETOCHAR(INSTRUMENTDATE) INSTRUMENTDATE,  "+
	              "       CUSTOMERID, ACCOUNTNO, BRANCHCODE, AMOUNT, TRANSACTIONTYPE,  "+ 
			      "       CASE WHEN DEPOSITORWITHDRAWAL = 'D' THEN 'CREDIT' ELSE 'DEBIT' END DEPOSITORWITHDRAWAL, "+
	              "       TO_CHAR(TRANSACTIONDATETIME,'DD-MON-YYYY') TRANSACTIONDATE,  NVL(TRIM(COUNTERPARTYID),'N.A.') COUNTERPARTYID, "+  
			      "       COUNTERPARTYTYPE, COUNTERBRANCHCODE, COUNTERBANKCODE, ACCTCURRENCYCODE, CURRENCYCODE, RATECODE, "+ 
			      "       CONVERSIONRATE, NARRATION, CHANNELID, COUNTERCOUNTRYCODE, CHANNELTYPE, COUNTERPARTYADDRESS, "+ 
			      "       CUSTOMERNAME, ACCOUNTTYPE, PRODUCTCODE, COUNTERPARTYNAME, COUNTERACCOUNTNO, FLOWCODE "+
			      "  FROM "+schemaName+"TB_TRANSACTIONS A "+
			      " WHERE 1 = 1 ";
			if(fromDate != null && !fromDate.equals("")) 
				// sql = sql + " AND A.TRANSACTIONDATETIME >= TO_TIMESTAMP('"+l_strFromDate+"','DD/MM/YYYY') ";
				sql = sql + " AND A.TRANSACTIONDATETIME >= FUN_CHARTODATE(?) ";
			if(toDate != null && !toDate.equals("")) 
				// sql = sql + " AND A.TRANSACTIONDATETIME <  TO_TIMESTAMP('"+l_strToDate+"','DD/MM/YYYY') + 1 ";
				sql = sql + " AND A.TRANSACTIONDATETIME <  FUN_CHARTODATE(?) + 1 ";
			if(accountNo != null && !accountNo.equals("")) 
				// sql = sql + " AND A.ACCOUNTNO = '"+l_strAccountNo+"' ";
				sql = sql + " AND A.ACCOUNTNO = ? ";
			if(linkedAcctountNo != null && !linkedAcctountNo.equals("")) 
				// sql = sql + " AND A.COUNTERACCOUNTNO = '"+l_strLinkedAcctNo+"' ";
				sql = sql + " AND A.COUNTERACCOUNTNO = ? ";

			preparedStatement = connection.prepareStatement(sql);
			if(fromDate != null && !fromDate.equals("")){ 
				preparedStatement.setString(count, fromDate);
				count++;
			}
			if(toDate != null && !toDate.equals("")){ 
				preparedStatement.setString(count, toDate);
				count++;
			}
			if(accountNo != null && !accountNo.equals("")){ 
				preparedStatement.setString(count, accountNo);
				count++;
			}
			if(linkedAcctountNo != null && !linkedAcctountNo.equals("")){ 
				preparedStatement.setString(count, linkedAcctountNo);
			}

			resultSet = preparedStatement.executeQuery();
			while (resultSet.next()) {
				Map<String, String> txns = new LinkedHashMap<String, String>();
				txns.put(CommonUtil.changeColumnName("ROWPOSITION"),resultSet.getString("ROWPOSITION"));
				txns.put(CommonUtil.changeColumnName("TRANSACTIONNO"),resultSet.getString("TRANSACTIONNO"));
				txns.put(CommonUtil.changeColumnName("TRANSACTIONID"),resultSet.getString("TRANSACTIONID"));
				txns.put(CommonUtil.changeColumnName("TRANSACTIONTYPE"),resultSet.getString("TRANSACTIONTYPE"));
				txns.put(CommonUtil.changeColumnName("CUSTOMERID"),resultSet.getString("CUSTOMERID"));
				txns.put(CommonUtil.changeColumnName("INSTRUMENTCODE"),resultSet.getString("INSTRUMENTCODE"));
				txns.put(CommonUtil.changeColumnName("INSTRUMENTNO"),resultSet.getString("INSTRUMENTNO"));
				txns.put(CommonUtil.changeColumnName("INSTRUMENTDATE"),resultSet.getString("INSTRUMENTDATE"));
				txns.put(CommonUtil.changeColumnName("ACCOUNTNO"),resultSet.getString("ACCOUNTNO"));
				txns.put(CommonUtil.changeColumnName("BRANCHCODE"),resultSet.getString("BRANCHCODE"));
				txns.put(CommonUtil.changeColumnName("AMOUNT"),resultSet.getString("AMOUNT"));
				txns.put(CommonUtil.changeColumnName("DEPOSITORWITHDRAWAL"),resultSet.getString("DEPOSITORWITHDRAWAL"));
				txns.put(CommonUtil.changeColumnName("TRANSACTIONDATE"),resultSet.getString("TRANSACTIONDATE"));
				txns.put(CommonUtil.changeColumnName("COUNTERPARTYID"),resultSet.getString("COUNTERPARTYID"));
				txns.put(CommonUtil.changeColumnName("COUNTERPARTYTYPE"),resultSet.getString("COUNTERPARTYTYPE"));
				txns.put(CommonUtil.changeColumnName("COUNTERBRANCHCODE"),resultSet.getString("COUNTERBRANCHCODE"));
				txns.put(CommonUtil.changeColumnName("COUNTERBANKCODE"),resultSet.getString("COUNTERBANKCODE"));
				txns.put(CommonUtil.changeColumnName("ACCTCURRENCYCODE"),resultSet.getString("ACCTCURRENCYCODE"));
				txns.put(CommonUtil.changeColumnName("CURRENCYCODE"),resultSet.getString("CURRENCYCODE"));
				txns.put(CommonUtil.changeColumnName("RATECODE"),resultSet.getString("RATECODE"));
				txns.put(CommonUtil.changeColumnName("CONVERSIONRATE"),resultSet.getString("CONVERSIONRATE"));
				txns.put(CommonUtil.changeColumnName("NARRATION"),resultSet.getString("NARRATION"));
				txns.put(CommonUtil.changeColumnName("CHANNELID"),resultSet.getString("CHANNELID"));
				txns.put(CommonUtil.changeColumnName("COUNTERCOUNTRYCODE"),resultSet.getString("COUNTERCOUNTRYCODE"));
				txns.put(CommonUtil.changeColumnName("CHANNELTYPE"),resultSet.getString("CHANNELTYPE"));
				txns.put(CommonUtil.changeColumnName("COUNTERPARTYADDRESS"),resultSet.getString("COUNTERPARTYADDRESS"));
				txns.put(CommonUtil.changeColumnName("CUSTOMERNAME"),resultSet.getString("CUSTOMERNAME"));
				txns.put(CommonUtil.changeColumnName("ACCOUNTTYPE"),resultSet.getString("ACCOUNTTYPE"));
				txns.put(CommonUtil.changeColumnName("PRODUCTCODE"),resultSet.getString("PRODUCTCODE"));
				txns.put(CommonUtil.changeColumnName("COUNTERPARTYNAME"),resultSet.getString("COUNTERPARTYNAME"));
				txns.put(CommonUtil.changeColumnName("COUNTERACCOUNTNO"),resultSet.getString("COUNTERACCOUNTNO"));
				linkedTxns.add(txns);
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return linkedTxns;
	}
	
	public String getCustomerIdForAccount(String accountNumber) {
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String customerId = "";
		try{
			preparedStatement = connection.prepareStatement("SELECT A.CUSTOMERID FROM "+schemaName+"TB_ACCOUNTSMASTER A WHERE A.ACCOUNTNO = ? ");
			preparedStatement.setString(1, accountNumber);
			resultSet = preparedStatement.executeQuery();
			while (resultSet.next()) {
				customerId = resultSet.getString("CUSTOMERID");
			}
			preparedStatement.executeUpdate();
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return customerId;
	}
}
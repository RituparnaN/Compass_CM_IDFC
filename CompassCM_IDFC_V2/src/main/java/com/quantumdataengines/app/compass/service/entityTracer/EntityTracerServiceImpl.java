package com.quantumdataengines.app.compass.service.entityTracer;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.hibernate.mapping.Array;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.quantumdataengines.app.compass.dao.entityTracer.EntityTracerDAO;

@Service
public class EntityTracerServiceImpl implements EntityTracerService {
	@Autowired
	private EntityTracerDAO EntityTracerDAO;
	
	public Map<String, Object> getLinkedTracer(String accountNumber, String customerId, String customerName, String fromDate, String toDate, 
			boolean isStaticLinks, boolean isTransactionLinks, int minLinksCount, String counterAccountNo, int levelCount, String productCode,
			String counterAccountGroup){
		return EntityTracerDAO.getLinkedTracer(accountNumber, customerId, customerName, fromDate, 
				toDate, isStaticLinks, isTransactionLinks, minLinksCount, counterAccountNo, levelCount, productCode, counterAccountGroup);
	}
	
	public Map<String, Object> getLinkedTracerForGraph(String accountNumber, String customerId, String customerName, String fromDate, String toDate, 
			boolean isStaticLinks, boolean isTransactionLinks, int minLinksCount, String counterAccountNo, int levelCount, String productCode,
			String counterAccountGroup){
		
		Map<String, Object> mainMap = EntityTracerDAO.getLinkedTracerForGraph(accountNumber, customerId, customerName, fromDate, 
				toDate, isStaticLinks, isTransactionLinks, minLinksCount, counterAccountNo, levelCount, productCode, counterAccountGroup); 
		
		Map<String, Object> dataMap = new HashMap<String, Object>();
		
		
		Map<String, List<Map<String, String>>> levelMap = (Map<String, List<Map<String, String>>>) mainMap.get("Level_1");
		List<Map<String, String>> listResultData = levelMap.get("listResultData");
				
		Map<String, List<Object>> childObj = new HashMap<String, List<Object>>();
		List<Object> objList = new ArrayList<Object>();
		
		for(Map<String, String> m1 : listResultData){
			String SEARCHACCOUNTNO = m1.get("SEARCHACCOUNTNO");
			String ENTITYICON = m1.get("ENTITYICON");
			String CUSTOMERRISK = m1.get("CUSTOMERRISK");
			String LINKEDTYPE = m1.get("LINKEDTYPE");
			String TRANSACTIONRISK = m1.get("TRANSACTIONRISK");
			dataMap.put("name", SEARCHACCOUNTNO);
			dataMap.put("levelName", "1");
			dataMap.put("ENTITYICON", ENTITYICON);
			dataMap.put("CUSTOMERRISK", CUSTOMERRISK);
			dataMap.put("LINKEDTYPE", LINKEDTYPE);
			dataMap.put("TRANSACTIONRISK", TRANSACTIONRISK);
			Map<String, Object> node = getNode(m1);
			if(dataMap.get("children") != null){
				List<Map<String, Object>> list = (List<Map<String, Object>>) dataMap.get("children");
				list.add(node);
			}else{
				List<Map<String, Object>> list = new ArrayList<Map<String,Object>>();
				list.add(node);
				dataMap.put("children", list);
			}
			objList.add(node);
		}
		
		childObj.put("2", objList);
		
		
		for(int i = 2; i <= levelCount; i++){
			Map<String, List<Map<String, String>>> newlevelMap = (Map<String, List<Map<String, String>>>) mainMap.get("Level_"+i);
			List<Map<String, String>> newListResultData = newlevelMap.get("listResultData");
						
			List<Object> newObjList = childObj.get(i+"");
			List<Object> levelObjectList = new ArrayList<Object>();
			
			for(Object obj : newObjList){
				Map<String, Object> childMap = (Map<String, Object>) obj;
								
				String LINKEDACCOUNTNO = (String) childMap.get("name");
				
				for(Map<String, String> m1 : newListResultData){
					String SEARCHACCOUNTNO = m1.get("SEARCHACCOUNTNO");
					
					if(LINKEDACCOUNTNO.equals(SEARCHACCOUNTNO)){
						childMap.put("name", SEARCHACCOUNTNO);
						childMap.put("levelName", i+"");
						Map<String, Object> node = getNode(m1);
						
						if(childMap.get("children") != null){
							List<Map<String, Object>> list = (List<Map<String, Object>>) childMap.get("children");
							list.add(node);
						}else{
							List<Map<String, Object>> list = new ArrayList<Map<String,Object>>();
							list.add(node);
							childMap.put("children", list);
						}
						levelObjectList.add(node);
					}
				}
			}
			int nextLevel = i+1;
			childObj.put(nextLevel+"", levelObjectList);
		}		
		return dataMap;
	}
	
	public Map<String, Object> getNode(Map<String, String> mainMap){
		Map<String, Object> dataMap = new HashMap<String, Object>();
		dataMap.put("SEARCHACCOUNTNO", mainMap.get("SEARCHACCOUNTNO"));
		dataMap.put("name", mainMap.get("LINKEDACCOUNTNO"));
		dataMap.put("LINKEDNAME", mainMap.get("LINKEDNAME"));
		dataMap.put("LINKEDTYPE", mainMap.get("LINKEDTYPE"));
		dataMap.put("LINKEDACCOUNTNO", mainMap.get("LINKEDACCOUNTNO"));
		dataMap.put("LINKEDCUSTOMERID", mainMap.get("LINKEDCUSTOMERID"));
		dataMap.put("LINKEDCUSTOMERTYPE", mainMap.get("LINKEDCUSTOMERTYPE"));
		dataMap.put("FORCELINK", mainMap.get("FORCELINK"));
		dataMap.put("IFEXISTINGTAB", mainMap.get("IFEXISTINGTAB"));
		dataMap.put("TRANSACTEDAMOUNT", mainMap.get("TRANSACTEDAMOUNT"));
		dataMap.put("TRANSACTEDCOUNT", mainMap.get("TRANSACTEDCOUNT"));
		dataMap.put("DUPLICATEVALUE", mainMap.get("DUPLICATEVALUE"));
		dataMap.put("ENTITYICON", mainMap.get("ENTITYICON"));
		dataMap.put("TRANSACTIONRISK", mainMap.get("TRANSACTIONRISK"));
		dataMap.put("CUSTOMERRISK", mainMap.get("CUSTOMERRISK"));
		dataMap.put("children", new ArrayList<Map<String, Object>>());
		return dataMap;
	}
	
	public String getExcludedProductCodes(){
		return EntityTracerDAO.getExcludedProductCodes();
	}

	public ArrayList<String> getAccountGroups(){
		return EntityTracerDAO.getAccountGroups();
	}
	
	public HashMap<String, Object> getInitialParameters(){
		return EntityTracerDAO.getInitialParameters();
	}
	
	public String saveEntityLinkedDetails(String accountNumber, String customerId, String customerName, String fromDate, String toDate, 
			String isStaticLinks, String isTransactionLinks, int minLinksCount, String counterAccountNo, 
			int levelCount, String productCode, String userCode) {
		return EntityTracerDAO.saveEntityLinkedDetails(accountNumber, customerId, customerName, fromDate, toDate, 
				isStaticLinks, isTransactionLinks, minLinksCount, counterAccountNo, 
				levelCount, productCode, userCode);
	}
	
	public void saveEntityForceLink(String forceLink, String accountNo, String linkType, String linkedAccountNo, String linkedCustId, 
			String linkCustName, String userComments, String updateBy, String terminalId){
		EntityTracerDAO.saveEntityForceLink(forceLink, accountNo, linkType, linkedAccountNo, linkedCustId, linkCustName, userComments, updateBy, terminalId);
	}
	
	public List<Map<String, String>> getLinkedTransactions(String l_strFromDate, String l_strToDate, String l_strAccountNo, String l_strLinkedAcctNo){
		return EntityTracerDAO.getLinkedTransactions(l_strFromDate, l_strToDate, l_strAccountNo, l_strLinkedAcctNo);
	}
}
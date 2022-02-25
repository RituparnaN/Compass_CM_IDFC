package com.quantumdataengines.app.compass.service.entityTracer;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


public interface EntityTracerService {
	public Map<String, Object> getLinkedTracer(String accountNumber, String customerId, String customerName, String fromDate, String toDate, 
			boolean isStaticLinks, boolean isTransactionLinks, int minLinksCount, String counterAccountNo, int levelCount, String productCode, String counterAccountGroup);
	public Map<String, Object> getLinkedTracerForGraph(String accountNumber, String customerId, String customerName, String fromDate, String toDate, 
			boolean isStaticLinks, boolean isTransactionLinks, int minLinksCount, String counterAccountNo, int levelCount, String productCode,
			String counterAccountGroup);
	public String getExcludedProductCodes();
	public ArrayList<String> getAccountGroups();
	public HashMap<String, Object> getInitialParameters();
	public String saveEntityLinkedDetails(String accountNumber, String customerId, String customerName, String fromDate, String toDate, 
			String isStaticLinks, String isTransactionLinks, int minLinksCount, String counterAccountNo, 
			int levelCount, String productCode, String userCode);
	public void saveEntityForceLink(String forceLink, String accountNo, String linkType, String linkedAccountNo, String linkedCustId, 
			String linkCustName, String userComments, String updateBy, String terminalId);
	public List<Map<String, String>> getLinkedTransactions(String l_strFromDate, String l_strToDate, String l_strAccountNo, String l_strLinkedAcctNo);
}
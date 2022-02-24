package com.quantumdataengines.app.compass.dao.groupingManagement;

import java.util.List;
import java.util.Map;

public interface AccountGroupingDAO{
	public Map<String, Object> searchAccountGrouping(String groupCode, String groupName, String description, String riskRating);
	public Map<String, Object> createAccountGrouping(String groupCode, String groupName, String description, String riskRating, String userCode) ;
	public String deleteAccountGrouping(String groupCodeToDelete);
	public String updateAccountGroupingDetails(String groupCode, String groupName, String description, String riskRating, String userCode);
	public Map<String, String> fetchAccountGroupingDetailsForUpdate(String groupCode);
	public List<Map<String, String>> accountGroupingRecordDetails(String groupCode);
	public String deleteAccountRecord(String accNoToDelete, String groupCodeToDelete);
	public List<Map<String, String>> searchAccountForGrouping (String accountNo, String accountName);
	public String addAccountToGroup(String selectedAccountNos, String userCode, String groupCode);
}
package com.quantumdataengines.app.compass.service.groupingManagement;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.quantumdataengines.app.compass.dao.groupingManagement.AccountGroupingDAO;

@Service
public class AccountGroupingServiceImpl implements AccountGroupingService{
	@Autowired
	private AccountGroupingDAO accountGroupingDAO;

	@Override
	public Map<String, Object> searchAccountGrouping(String groupCode, String groupName, String description, String riskRating) {
		return accountGroupingDAO.searchAccountGrouping(groupCode, groupName, description, riskRating);
	}


	@Override
	public Map<String, Object> createAccountGrouping(String groupCode,
			String groupName, String description, String riskRating,
			String userCode) {
		return accountGroupingDAO.createAccountGrouping(groupCode, groupName, description, riskRating, userCode);
		}


	@Override
	public String deleteAccountGrouping(String groupCodeToDelete) {
		return accountGroupingDAO.deleteAccountGrouping(groupCodeToDelete);
	}


	@Override
	public String updateAccountGroupingDetails(String groupCode,
			String groupName, String description, String riskRating,
			String userCode) {
		return accountGroupingDAO.updateAccountGroupingDetails(groupCode, groupName, description, riskRating, userCode);
	}


	@Override
	public Map<String, String> fetchAccountGroupingDetailsForUpdate(
			String groupCode) {
		return accountGroupingDAO.fetchAccountGroupingDetailsForUpdate(groupCode);
	}


	@Override
	public List<Map<String, String>> accountGroupingRecordDetails(
			String groupCode) {
		return accountGroupingDAO.accountGroupingRecordDetails(groupCode);
	}


	@Override
	public String deleteAccountRecord(String accNoToDelete,
			String groupCodeToDelete) {
		return accountGroupingDAO.deleteAccountRecord(accNoToDelete, groupCodeToDelete);
	}


	@Override
	public List<Map<String, String>> searchAccountForGrouping(String accountNo,
			String accountName) {
		return accountGroupingDAO.searchAccountForGrouping(accountNo, accountName);
	}


	@Override
	public String addAccountToGroup(String selectedAccountNos, String userCode,
			String groupCode) {
		return accountGroupingDAO.addAccountToGroup(selectedAccountNos, userCode, groupCode);
	}


	}
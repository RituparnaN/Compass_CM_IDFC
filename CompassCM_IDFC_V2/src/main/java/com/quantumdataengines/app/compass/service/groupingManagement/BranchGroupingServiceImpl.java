package com.quantumdataengines.app.compass.service.groupingManagement;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.quantumdataengines.app.compass.dao.groupingManagement.BranchGroupingDAO;

@Service
public class BranchGroupingServiceImpl implements BranchGroupingService{
	@Autowired
	private BranchGroupingDAO branchGroupingDAO;

	@Override
	public Map<String, Object> searchBranchGrouping(String groupCode, String groupName, String description, String riskRating) {
		return branchGroupingDAO.searchBranchGrouping(groupCode, groupName, description, riskRating);
	}


	@Override
	public Map<String, Object> createBranchGrouping(String groupCode,
			String groupName, String description, String riskRating,
			String userCode) {
		return branchGroupingDAO.createBranchGrouping(groupCode, groupName, description, riskRating, userCode);
		}


	@Override
	public String deleteBranchGrouping(String groupCodeToDelete) {
		return branchGroupingDAO.deleteBranchGrouping(groupCodeToDelete);
	}


	@Override
	public String updateBranchGroupingDetails(String groupCode,
			String groupName, String description, String riskRating,
			String userCode) {
		return branchGroupingDAO.updateBranchGroupingDetails(groupCode, groupName, description, riskRating, userCode);
	}


	@Override
	public Map<String, String> fetchBranchGroupingDetailsForUpdate(
			String groupCode) {
		return branchGroupingDAO.fetchBranchGroupingDetailsForUpdate(groupCode);
	}


	@Override
	public List<Map<String, String>> branchGroupingRecordDetails(
			String groupCode) {
		return branchGroupingDAO.branchGroupingRecordDetails(groupCode);
	}


	@Override
	public String deleteBranchRecord(String branchCodeToDelete,
			String groupCodeToDelete) {
		return branchGroupingDAO.deleteBranchRecord(branchCodeToDelete, groupCodeToDelete);
	}


	@Override
	public List<Map<String, String>> searchBranchForGrouping(String branchCode,
			String branchName) {
		return branchGroupingDAO.searchBranchForGrouping(branchCode, branchName);
	}


	@Override
	public String addBranchToGroup(String selectedBranchCodes, String userCode, String groupCode) {
		return branchGroupingDAO.addBranchToGroup(selectedBranchCodes, userCode, groupCode);
	}


	

	
}
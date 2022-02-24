package com.quantumdataengines.app.compass.service.groupingManagement;

import java.util.List;
import java.util.Map;

public interface BranchGroupingService {
	public Map<String, Object> searchBranchGrouping(String groupCode, String groupName, String description, String riskRating);
	public Map<String, Object> createBranchGrouping(String groupCode, String groupName, String description, String riskRating, String userCode) ;
	public String deleteBranchGrouping(String groupCodeToDelete);
	public String updateBranchGroupingDetails(String groupCode, String groupName, String description, String riskRating, String userCode);
	public Map<String, String> fetchBranchGroupingDetailsForUpdate(String groupCode);
	public List<Map<String, String>> branchGroupingRecordDetails(String groupCode);
	public String deleteBranchRecord(String branchCodeToDelete, String groupCodeToDelete);
	public List<Map<String, String>> searchBranchForGrouping (String branchCode, String branchName);
	public String addBranchToGroup(String selectedBranchCodes, String userCode, String groupCode);
	
}


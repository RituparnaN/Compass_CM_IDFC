package com.quantumdataengines.app.compass.service.exceptionList;

import java.util.List;
import java.util.Map;


public interface WatchlistService {
	public Map<String, Object> searchManageWatchlist(String listCode, String listName, String description, String riskRating) ;
	public String deleteWatchlist(String listCodeToDelete);
	public Map<String, Object> createWatchlist(String listCode, String listName, String description, String riskRating, String userCode);
	public String updateWatchlist(String listCode, String listName, String description, String riskRating, String userCode);
	public Map<String, String> fetchWatchlistForUpdate(String listCode);
	public List<Map<String, String>> fetchWatchlistDetails(String listCode);
	public String addNonCustomerToWatchlist(String listCode, String unqid, String nonCustomerName, String userCode);
	public String deleteWatchlistRecord(String unqIdToDelete);
	public List<Map<String, String>> searchCustomerToAdd(String customerId, String customerName, String riskRating, String branchCode);
	public String addCustomerIdsToWatchlist(String listCode, String selectedCustomerIds, String userCode);
}

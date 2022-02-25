package com.quantumdataengines.app.compass.service.exceptionList;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.quantumdataengines.app.compass.dao.exceptionList.WatchlistDAO;

@Service
public class WatchlistServiceImpl implements WatchlistService {

	@Autowired
	private WatchlistDAO watchlistDAO;

	@Override
	public Map<String, Object> searchManageWatchlist(String listCode,
			String listName, String description, String riskRating) {
		return watchlistDAO.searchManageWatchlist(listCode, listName,
				description, riskRating);
	}

	@Override
	public String deleteWatchlist(String listCodeToDelete) {
		return watchlistDAO.deleteWatchlist(listCodeToDelete);
	}

	@Override
	public Map<String, Object> createWatchlist(String listCode, String listName, String description, String riskRating, String userCode) {
		return watchlistDAO.createWatchlist(listCode, listName, description, riskRating, userCode);
	}
	
	@Override
	public String updateWatchlist(String listCode, String listName, 
			String description, String riskRating, String userCode){
		return watchlistDAO.updateWatchlist(listCode, listName, description, riskRating, userCode);		
	}

	@Override
	public Map<String, String> fetchWatchlistForUpdate(String listCode) {
		return watchlistDAO.fetchWatchlistForUpdate(listCode);
	}
	
	@Override
	public List<Map<String, String>> fetchWatchlistDetails(String listCode){
		return watchlistDAO.fetchWatchlistDetails(listCode);
	}

	@Override
	public String addNonCustomerToWatchlist(String listCode, String unqid, String nonCustomerName, String userCode) {
		return watchlistDAO.addNonCustomerToWatchlist(listCode, unqid, nonCustomerName, userCode);
	}
	
	@Override
	public String deleteWatchlistRecord(String unqIdToDelete){
		return watchlistDAO.deleteWatchlistRecord(unqIdToDelete);
	}

	@Override
	public List<Map<String, String>> searchCustomerToAdd(String customerId, String customerName, String riskRating, String branchCode) {
		return watchlistDAO.searchCustomerToAdd(customerId, customerName, riskRating, branchCode);
	}
	
	@Override
	public String addCustomerIdsToWatchlist(String listCode, String selectedCustomerIds, String userCode){
		return watchlistDAO.addCustomerIdsToWatchlist(listCode, selectedCustomerIds, userCode);
	}
	
}

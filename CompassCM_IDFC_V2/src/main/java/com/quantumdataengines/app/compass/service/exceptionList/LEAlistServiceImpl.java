package com.quantumdataengines.app.compass.service.exceptionList;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.quantumdataengines.app.compass.dao.exceptionList.LEAlistDAO;

@Service
public class LEAlistServiceImpl implements LEAlistService {

	@Autowired
	private LEAlistDAO lealistDAO;

	@Override
	public String saveLEAList(Map<String,String> dataMap, String userCode, String userRole) {
		return lealistDAO.saveLEAList(dataMap, userCode, userRole);
	}

	@Override
	public Map<String, Object> searchLEAList(String listCode, String serialNo,
			String listStatus, String userRole) {
		return lealistDAO.searchLEAList(listCode, serialNo, listStatus, userRole);
	}

	@Override
	public Map<String, String> showLEAListDetails(String listcode,
			String actionType, String userRole) {
		return lealistDAO.showLEAListDetails(listcode, actionType, userRole);
	}

	@Override
	public String updateLEAList(Map<String, String> dataMap, String listCode,
			String userCode, String userRole) {
		return lealistDAO.updateLEAList(dataMap, listCode, userCode, userRole);
	}

	@Override
	public String approveOrRejectLEAList(String listCode, String status, String userCode) {
		return lealistDAO.approveOrRejectLEAList(listCode, status, userCode);
	}
	
	/*@Override
	public String deleteLEAList(String listCode) {
		return lealistDAO.deleteLEAList(listCode);
	}*/	
}

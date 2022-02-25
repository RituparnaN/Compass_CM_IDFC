package com.quantumdataengines.app.compass.service.exceptionList;

import java.util.List;
import java.util.Map;


public interface LEAlistService {
	public String saveLEAList(Map<String,String> dataMap, String userCode, String userRole);
	public Map<String, Object> searchLEAList(String listCode, String serialNo, String listStatus, String userRole);
	public Map<String, String> showLEAListDetails(String listcode, String actionType, String userRole);
	public String updateLEAList(Map<String,String> dataMap, String listCode, String userCode, String userRole);
	/*public String deleteLEAList(String listCode);*/
	public String approveOrRejectLEAList(String listCode, String status, String userCode);
}

package com.quantumdataengines.app.compass.dao.checker;

import java.util.List;
import java.util.Map;

public interface CheckerDAO {
	public List<Map<String, String>> getAllIPAddressForCheck();
	public Map<String, String> getIPDetailsForChecker(String ipAddress, String makerCode);
	public String approveIPAddress(String ipAddress, String makerCode, String remarks, String createdBy);
	public String rejectIPAddress(String makerCode, String remarks, String createdBy);
	public List<Map<String, String>> getAllUserForCheck(String loggedInUsercode);
	public Map<String, Object> getUserDetailsForCheck(String userCode, String makerCode);
	public String checkUserReject(String userCode, String makerCode, String remarks, String createdBy);
	public String checkUserApprove(String userCode, String makerCode, String remarks, String createdBy);
}

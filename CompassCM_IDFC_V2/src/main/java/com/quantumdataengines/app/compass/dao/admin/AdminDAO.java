package com.quantumdataengines.app.compass.dao.admin;

import java.util.Map;

public interface AdminDAO {
	public String saveSystemParameters(Map<String, String> systemParametersMap);
	public Map<String, String> getPlivoSettings();
	public String updatePlivoSettings(String authId, String authToken, String sourceNo, String destNo);
	public void savePlivoMessage(Map<String, String> messageDetails, String userCode);
}

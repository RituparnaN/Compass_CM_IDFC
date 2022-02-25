package com.quantumdataengines.app.compass.service.admin;

import java.util.Map;

public interface AdminService {
	public String saveSystemParameters(Map<String, String> systemParametersMap);
	public Map<String, String> getPlivoSettings();
	public String updatePlivoSettings(String authId, String authToken, String sourceNo, String destNo);
	public void savePlivoMessage(String messageId, String authId, String authToken, String userCode, String messageType);
}

package com.quantumdataengines.app.compass.dao.alertConfiguration;

import java.util.List;
import java.util.Map;

public interface AlertCodesDAO {
	public List<Map<String, String>> getAlertCodeForAlertType(String alertType);
	public Map<String, String> searchAlertCodeDetails(String alertType, String alertCode);
	public Map<String, String> createSubjectiveAlert(String alertCode, String alertName, String description, 
			String alertMsg, String alertPriority, String alertEnabled, String userCode);
	public String updateAlertDetails(String alertCode, String alertName, String description, 
			String alertMsg, String alertPriority, String alertEnabled, String userCode);
}

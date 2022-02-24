package com.quantumdataengines.app.compass.service.alertConfiguration;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.quantumdataengines.app.compass.dao.alertConfiguration.AlertCodesDAO;

@Service
public class AlertCodesServiceImpl implements AlertCodesService {
	@Autowired
	private AlertCodesDAO alertCodesDAO;

	@Override
	public List<Map<String, String>> getAlertCodeForAlertType(String alertType){
		return alertCodesDAO.getAlertCodeForAlertType(alertType);
	}
	
	@Override
	public Map<String, String> searchAlertCodeDetails(String alertType,
			String alertCode) {
		return alertCodesDAO.searchAlertCodeDetails(alertType, alertCode);
	}

	@Override
	public Map<String, String> createSubjectiveAlert(String alertCode,
			String alertName, String description, String alertMsg,
			String alertPriority, String alertEnabled, String userCode) {
		return alertCodesDAO.createSubjectiveAlert(alertCode, alertName, description, alertMsg, alertPriority, alertEnabled, userCode);
	}

	@Override
	public String updateAlertDetails(String alertCode, String alertName,
			String description, String alertMsg, String alertPriority,
			String alertEnabled, String userCode) {
		return alertCodesDAO.updateAlertDetails(alertCode, alertName, description, alertMsg, alertPriority, alertEnabled, userCode);
	}

	
	
}

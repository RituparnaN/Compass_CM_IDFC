package com.quantumdataengines.app.compass.service.alertConfiguration;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.quantumdataengines.app.compass.dao.alertConfiguration.AlertScoringDAO;


@Service
public class AlertScoringServiceImpl implements AlertScoringService{
	@Autowired
	private AlertScoringDAO alertScoringDAO;

	@Override
	public List<Map<String, String>> getAlertParameterList() {
		return alertScoringDAO.getAlertParameterList();
	}

	@Override
	public void saveAlertParameterList(String strAlertParameters) {
		alertScoringDAO.saveAlertParameterList(strAlertParameters);
	}

	@Override
	public String calculateAlertScore(String userCode, String CURRENTROLE,
			String ipAddress) {
		return alertScoringDAO.calculateAlertScore(userCode, CURRENTROLE, ipAddress);
	}

	@Override
	public List<Map<String, String>> searchAlertScoreAssignment(
			String searchParamId) {
		return alertScoringDAO.searchAlertScoreAssignment(searchParamId);
	}

	@Override
	public void updateAlertScoreAssignmentValue(String fullData, String paramId) {
		alertScoringDAO.updateAlertScoreAssignmentValue(fullData, paramId);		
	}
	
}

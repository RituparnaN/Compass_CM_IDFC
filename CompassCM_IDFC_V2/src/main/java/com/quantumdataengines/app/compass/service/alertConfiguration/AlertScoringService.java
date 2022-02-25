package com.quantumdataengines.app.compass.service.alertConfiguration;

import java.util.List;
import java.util.Map;

public interface AlertScoringService {
	public List<Map<String, String>> getAlertParameterList();
	public void saveAlertParameterList(String strAlertParameters);
	public String calculateAlertScore(String userCode, String CURRENTROLE, String ipAddress);
	public List<Map<String,String>> searchAlertScoreAssignment(String searchParamId);
	public void updateAlertScoreAssignmentValue(String fullData, String paramId);
}

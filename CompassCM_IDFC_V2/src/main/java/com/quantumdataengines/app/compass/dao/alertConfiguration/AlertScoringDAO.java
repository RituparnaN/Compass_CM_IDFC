package com.quantumdataengines.app.compass.dao.alertConfiguration;

import java.util.List;
import java.util.Map;

public interface AlertScoringDAO {
	public List<Map<String, String>> getAlertParameterList();
	public void saveAlertParameterList(String strAlertParameters);
	public String calculateAlertScore(String userCode, String CURRENTROLE, String ipAddress);
	public List<Map<String,String>> searchAlertScoreAssignment(String searchParamId);
	public void updateAlertScoreAssignmentValue(String fullData, String paramId);
}

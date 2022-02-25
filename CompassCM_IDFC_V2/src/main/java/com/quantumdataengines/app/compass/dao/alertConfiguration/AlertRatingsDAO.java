package com.quantumdataengines.app.compass.dao.alertConfiguration;

import java.util.List;
import java.util.Map;

public interface AlertRatingsDAO {
	public List<Map<String, String>> getAlertCode();
	public List<Map<String, String>> getAlertMsg(String alertCode);
	public List<Map<String, String>> searchAlertRatingsDetails(String alertCode, String alertMsg);
	public String updateAlertRatingsValues(String fullData, String userCode);
	public String processAlertRatingUploadedFile(String PROCESSPROCEDURE, String userCode);
}

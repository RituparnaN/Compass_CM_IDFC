package com.quantumdataengines.app.compass.service.alertConfiguration;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.quantumdataengines.app.compass.dao.CommonDAO;
import com.quantumdataengines.app.compass.dao.alertConfiguration.AlertRatingsDAO;

@Service
public class AlertRatingsServiceImpl implements AlertRatingsService{

	@Autowired
	public AlertRatingsDAO alertRatingsDAO ;
	@Autowired
	public CommonDAO commonDAO;
	
	@Override
	public List<Map<String, String>> getAlertCode(){
		return alertRatingsDAO.getAlertCode();
	}
	
	@Override
	public List<Map<String, String>> getAlertMsg(String alertCode){
		return alertRatingsDAO.getAlertMsg(alertCode);
	}

	@Override
	public List<Map<String, String>> searchAlertRatingsDetails(
			String alertCode, String alertMsg) {
		return alertRatingsDAO.searchAlertRatingsDetails(alertCode, alertMsg);
	}

	@Override
	public String updateAlertRatingsValues(String fullData, String userCode) {
		return alertRatingsDAO.updateAlertRatingsValues(fullData, userCode);
	}
	
	@Override
	public String processAlertRatingUploadedFile(String moduleRefId, String userCode) {
		Map<String, Object> uploadConfig = commonDAO.getFileUploadConfig(moduleRefId);
		String PROCESSPROCEDURE = (String) uploadConfig.get("PROCESSPROCEDURE");
		return alertRatingsDAO.processAlertRatingUploadedFile(PROCESSPROCEDURE, userCode);
	}
}

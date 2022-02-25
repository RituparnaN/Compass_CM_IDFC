package com.quantumdataengines.app.compass.service.falsePositive;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.quantumdataengines.app.compass.dao.CommonDAO;
import com.quantumdataengines.app.compass.dao.falsePositive.FalsePositiveDAO;

@Service
public class FalsePositiveServiceImpl implements FalsePositiveService{

	@Autowired
	private FalsePositiveDAO falsePositiveDAO;
	@Autowired
	private CommonDAO commonDAO;
	
	
	@Override
	public Map<String, Object> searchFalsePositives(String custId,
			String accNo, String alertCode, String alertMsg, String activeFrom,
			String activeTo, String isEnabled, String reason, String toleranceLevel, String status, String userRole) {
		return falsePositiveDAO.searchFalsePositives(custId, accNo, alertCode, alertMsg, activeFrom, activeTo, isEnabled, reason, toleranceLevel, status, userRole);
	}

	@Override
	public Map<String, Object> addFalsePositive(String custId, String accNo,
			String alertCode, String alertMsg, String activeFrom,
			String activeTo, String isEnabled, String reason,
			String toleranceLevel, String status, String adminComments, String userCode, String CURRENTROLE) {
		return falsePositiveDAO.addFalsePositive(custId, accNo, alertCode, alertMsg, activeFrom, activeTo, isEnabled, reason, toleranceLevel, status, adminComments, userCode, CURRENTROLE);
	}


	@Override
	public Map<String,String> fetchFalsePositiveToUpdate(String selectedCustId, String selectedAccNo,
			 String selectedAlertCode, String selectedStatus){
		return falsePositiveDAO.fetchFalsePositiveToUpdate(selectedCustId, selectedAccNo, selectedAlertCode, selectedStatus);
	}

	@Override
	public String processFalsePositiveUploadedFile(String moduleRefId, String userCode) {
		Map<String, Object> uploadConfig = commonDAO.getFileUploadConfig(moduleRefId);
		String PROCESSPROCEDURE = (String) uploadConfig.get("PROCESSPROCEDURE");
		return falsePositiveDAO.processFalsePositiveUploadedFile(PROCESSPROCEDURE, userCode);
	}
	
	@Override
	public String updateFalsePositive(String custId, String accNo,
			String alertCode, String alertMsg, String activeFrom,
			String activeTo, String isEnabled, String reason, String toleranceLevel,
			String status, String adminComments, String userCode,
			String CURRENTROLE) {
		return falsePositiveDAO.updateFalsePositive(custId, accNo, alertCode, alertMsg, activeFrom, activeTo, isEnabled, reason, toleranceLevel, status, adminComments, userCode, CURRENTROLE);
	}
	
	@Override
	public String rejectFalsePositive(
			String selectedCustId, String selectedAccNo,
			String selectedAlertCode, String mlroComments, String userCode) {
		return falsePositiveDAO.rejectFalsePositive(selectedCustId, selectedAccNo, selectedAlertCode, mlroComments, userCode);
	}

	@Override
	public String approveFalsePositive(String selectedCustId, String selectedAccNo, String selectedAlertCode, 
			String selectedAlertMessage, String selectedActiveFrom, String selectedActiveTo, 
			String selectedReason, String selectedIsEnabled, String selectedToleranceLevel, String selectedAdminComments,
			String selectedAdminTimestamp, String selectedMlroComments, String userCode) {
		return falsePositiveDAO.approveFalsePositive(selectedCustId, selectedAccNo, selectedAlertCode, selectedAlertMessage, selectedActiveFrom, selectedActiveTo, selectedReason, selectedIsEnabled, selectedToleranceLevel, selectedAdminComments, selectedAdminTimestamp, selectedMlroComments, userCode);
	}

	@Override
	public List<Map<String, String>> getAlertMessages(String alertCode) {
		return falsePositiveDAO.getAlertMessages(alertCode);
	}
	
}

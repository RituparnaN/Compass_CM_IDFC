package com.quantumdataengines.app.compass.dao.falsePositive;

import java.util.List;
import java.util.Map;

public interface FalsePositiveDAO {
	public List<Map<String, String>> getAlertMessages(String alertCode);
	public Map<String, Object> searchFalsePositives(String custId, String accNo, String alertCode, String alertMsg, 
			String activeFrom, String activeTo, String isEnabled, String reason, String toleranceLevel, String status, String userRole);
	public Map<String, Object> addFalsePositive(String custId, String accNo, String alertCode, String alertMsg, 
			String activeFrom, String activeTo, String isEnabled, String reason, String toleranceLevel, String status, String adminComments, String userCode, String CURRENTROLE);
	public Map<String,String> fetchFalsePositiveToUpdate(String selectedCustId, String selectedAccNo,
			 String selectedAlertCode, String selectedStatus);
	public String processFalsePositiveUploadedFile(String PROCESSPROCEDURE, String userCode);
	public String updateFalsePositive(String custId, String accNo, String alertCode, String alertMsg, 
			String activeFrom, String activeTo, String isEnabled, 
			String reason, String toleranceLevel, String status, String adminComments, String userCode, String CURRENTROLE);
	public String rejectFalsePositive(String selectedCustId, String selectedAccNo, String selectedAlertCode, String mlroComments, String userCode);
	public String approveFalsePositive(String selectedCustId, String selectedAccNo, String selectedAlertCode, 
			String selectedAlertMessage, String selectedActiveFrom, String selectedActiveTo, 
			String selectedReason, String selectedIsEnabled, String selectedToleranceLevel,String selectedAdminComments,
			String selectedAdminTimestamp, String selectedMlroComments, String userCode);
}

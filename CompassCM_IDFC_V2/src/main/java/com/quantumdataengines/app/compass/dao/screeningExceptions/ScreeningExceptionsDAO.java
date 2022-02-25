package com.quantumdataengines.app.compass.dao.screeningExceptions;

import java.util.Map;

public interface ScreeningExceptionsDAO {
	public Map<String, String> returnMatchedList();
	public Map<String, Object> searchScreeningExceptions(String custId, String custName, String matchedList, String matchedEntity, 
			  String isEnabled, String listId, String reason);
	public Map<String, Object> addScreeningException(String custId, String custName, String matchedList, String reason, 
			 String matchedEntity, String isEnabled, String listId, String userCode, String CURRENTROLE);
	public Map<String,String> fetchScreeningExceptionToUpdate(String selectedCustId, String selectedCustName,
			String selectedMatchedEntity);
	public String updateScreeningException(String custId, String custName, String matchedList, String reason, 
			 String matchedEntity, String isEnabled, String listId, String userCode, String CURRENTROLE);
}

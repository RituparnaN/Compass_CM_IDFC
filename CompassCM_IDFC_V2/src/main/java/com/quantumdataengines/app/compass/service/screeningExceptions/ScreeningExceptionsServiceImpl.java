package com.quantumdataengines.app.compass.service.screeningExceptions;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.quantumdataengines.app.compass.dao.screeningExceptions.ScreeningExceptionsDAO;


@Service
public class ScreeningExceptionsServiceImpl implements ScreeningExceptionsService{

	@Autowired
	private ScreeningExceptionsDAO screeningExceptionsDAO;

	@Override
	public Map<String, String> returnMatchedList() {
		return screeningExceptionsDAO.returnMatchedList();
	}

	@Override
	public Map<String, Object> searchScreeningExceptions(String custId,
			String custName, String matchedList, String matchedEntity,
			String isEnabled, String listId, String reason) {
		return screeningExceptionsDAO.searchScreeningExceptions(custId, custName, matchedList, matchedEntity, isEnabled, listId, reason);
	}

	@Override
	public Map<String, Object> addScreeningException(String custId,
			String custName, String matchedList, String reason,
			String matchedEntity, String isEnabled, String listId,
			String userCode, String CURRENTROLE) {
		return screeningExceptionsDAO.addScreeningException(custId, custName, matchedList, reason, matchedEntity, isEnabled, listId, userCode, CURRENTROLE);
	}

	@Override
	public Map<String, String> fetchScreeningExceptionToUpdate(
			String selectedCustId, String selectedCustName,
			String selectedMatchedEntity) {
		return screeningExceptionsDAO.fetchScreeningExceptionToUpdate(selectedCustId, selectedCustName, selectedMatchedEntity);
	}

	@Override
	public String updateScreeningException(String custId, String custName,
			String matchedList, String reason, String matchedEntity,
			String isEnabled, String listId, String userCode, String CURRENTROLE) {
		return screeningExceptionsDAO.updateScreeningException(custId, custName, matchedList, reason, matchedEntity, isEnabled, listId, userCode, CURRENTROLE);
	}

	
	
	}

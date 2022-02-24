package com.quantumdataengines.app.compass.service.exceptionList;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.quantumdataengines.app.compass.dao.exceptionList.ListDetailsDAO;

@Service
public class ListDetailsServiceImpl implements ListDetailsService{
	
	@Autowired
	private ListDetailsDAO listDetailsDAO;
	
	@Override
	public List<Map<String, String>> showListDetails(){
		return listDetailsDAO.showListDetails();
	}

	@Override
	public Map<String, Object> getExceptionListRecords(String listCode,
			String listCode_Id, String listCode_Name) {
		return listDetailsDAO.getExceptionListRecords(listCode, listCode_Id, listCode_Name);
	}

	@Override
	public Map<String, Object> getExceptionListIdDetails(String listCode,
			String listId, String viewType) {
		return listDetailsDAO.getExceptionListIdDetails(listCode, listId, viewType);
	}
	
	@Override
	public Map<String, Object> getRecordDetails(String recordId) {
		return listDetailsDAO.getRecordDetails(recordId);
	}
	
	@Override
	public String getRecordProfileNote(String uploadId, String recordId){
		return listDetailsDAO.getRecordProfileNote(uploadId, recordId);
	}
}

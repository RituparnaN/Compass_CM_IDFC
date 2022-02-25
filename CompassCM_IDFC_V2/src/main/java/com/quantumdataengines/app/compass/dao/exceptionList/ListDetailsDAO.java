package com.quantumdataengines.app.compass.dao.exceptionList;

import java.util.List;
import java.util.Map;

public interface ListDetailsDAO {

	public  List<Map<String, String>> showListDetails();
	public Map<String, Object> getExceptionListRecords(String listCode, String listCode_Id, String listCode_Name);
	public Map<String, Object> getExceptionListIdDetails(String listCode, String listId, String viewType);
	public Map<String, Object> getRecordDetails(String recordId);
	public String getRecordProfileNote(String uploadId, String recordId);
}

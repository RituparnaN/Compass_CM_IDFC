package com.quantumdataengines.app.compass.service.scanning;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Vector;

import com.quantumdataengines.app.compass.model.scanning.MatchResultVO;

public interface OnlineScanningService {
	ArrayList<HashMap<String,String>> getScanningResults(String userCode, String type, String nameEnglish, String idNumber, String nationality, String passportId, String residence, String birthPlace, String params);
	ArrayList<HashMap<String,String>> getEntityScanning(String userCode, String entityName, String listName, String matchScore);
	//void createIndexes(String sourceName, String importId);
	LinkedHashMap getScanReport(String reportId, HashMap a_hmSearchData);
	public boolean insertRecord(String a_strColumnName,String a_strColumnValue);
	public HashMap getSearchValues(String a_strColumnName,String a_strColumnValue);
	public ArrayList getListDetails(String listname, String listid,String l_strViewType);
	public Map getFileMatches(MatchResultVO l_matchVO);
	public Vector exportToFile(MatchResultVO l_CMatchResultVO);
	public ArrayList getRecords(MatchResultVO l_CMatchResultVO);
	public void updateRecord(String a_action,String a_selected,String a_userCode, String a_strFileName, String a_comments);
	public String insertFile(String a_reportid,String a_filedir,String a_data,String a_fileactualname,String a_templateid,String a_user,String a_delimiter,String a_blacklistid,String a_whitelistid,HashMap l_hmSearchData);
	public String insertFileNew(String a_reportid,String a_filedir,String a_data,String a_fileactualname,String a_templateid,String a_user,String a_delimiter,String a_blacklistid,String a_whitelistid,HashMap l_hmSearchData);
	public Vector getFileNames(String a_action);
	public HashMap<String,Object> getAuditRecords(String a_fromdate,String a_todate,String a_filename,String a_fileimport,String a_counter);
	public Map<String, Object> getFileImportDetailss(File fileName, String entityName);
	public String getComments(String uniqueNumber);
	public ArrayList<HashMap<String,String>> getFieldScanSummaryDetails(String uniqueNumber, String fileName, String sbNameValuePairs, String userCode, String userRole, String ipAddress);
	public String getUniqueNumber(String filename, String templateSeqNo);
}
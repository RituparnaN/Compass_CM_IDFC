package com.quantumdataengines.app.compass.dao.scanning;


import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Vector;
import java.util.Collection;

import com.quantumdataengines.app.compass.model.scanning.MatchResultVO;
import com.quantumdataengines.app.listScanning.model.FieldVO;
import com.quantumdataengines.app.listScanning.model.RecordVO;
import com.quantumdataengines.app.listScanning.dataInfoReaders.main.IndexFieldVO;

public interface OnlineScanningDAO {
	public ArrayList<HashMap<String,String>> getOnlineScanningResults(String userCode, String type, String nameEnglish, String idNumber, String nationality, String passportId, String residence, String birthPlace, String params);
	public ArrayList<HashMap<String,String>> getOnlineEntityScanning(String userCode, String entityName, String listName, String matchScore);
    public FieldVO[] getSelectedFieldProperties(int a_intReportID);
    public RecordVO getSelectedRecordProperties(int a_intReportID);
    public HashMap<String,Vector<IndexFieldVO>> getSelectedIndexingInfo(int a_intReportID);
    public HashMap<String,IndexFieldVO> getSelectedIndexingInfo(String a_strListCode);
    public String getSelectedListCode(int a_intReportID);
    public Collection getSelectedSearchSettings(int a_intReportID);
    public Collection getSelectedFieldMappingInfo(int a_intReportID,String a_strListCode,String a_strUser,String a_strTemplateId,String a_isFileImport);
    public void saveOnlineSearchResults(Collection a_alResults,int a_intImportId,String a_strUniqueId, String a_fileName ,String isFileImport , String a_UserCode , String a_blacklistid,String a_strTemplateId);	
    public Map getSavedFileMatches(String a_FileName,String isFileImport,int counter);
	public String saveSelectedImportFile(String a_reportid,String a_filedir,String a_data,String a_fileactualname,String a_templateid,String a_user,String a_delimiter,String a_blacklistid,String a_whitelistid);
	public HashMap<String,Object> getSavedFileImportLog(String reportId, String templateId, String userId);
	public String getSavedSwiftFileImportLog(String fileName, String userCode);
	
	public boolean saveOnlineRecords(String a_strColumnName,String a_strColumnValue);
	public HashMap getSavedSearchValues(String a_strColumnName,String a_strColumnValue);
	public ArrayList getSelectedListDetails(String listname, String listid,String l_strViewType);
	public Map getSavedFileMatches(MatchResultVO l_matchVO);
	public Vector exportSavedDataToFile(MatchResultVO l_CMatchResultVO);
	public ArrayList getSavedRecords(MatchResultVO l_CMatchResultVO);
	public void updateActionRecord(String a_action,String a_selected,String a_userCode, String a_strFileName, String a_comments);
	public Vector getImportedFileNames(String a_action);
	public HashMap<String,Object> getSavedAuditRecords(String a_fromdate,String a_todate,String a_filename,String a_fileimport,String a_counter)	;
	public String getComments(String uniqueNumber);
	public ArrayList<HashMap<String,String>> getFieldScanSummaryDetails(String uniqueNumber, String fileName, String sbNameValuePairs, String userCode, String userRole, String ipAddress);
	public String getUniqueNumber(String filename, String templateSeqNo);
}

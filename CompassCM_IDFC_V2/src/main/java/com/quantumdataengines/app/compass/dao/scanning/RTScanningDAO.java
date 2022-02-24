package com.quantumdataengines.app.compass.dao.scanning;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.Vector;
import java.util.Collection;

import com.quantumdataengines.app.compass.model.scanning.MatchResultVO;
import com.quantumdataengines.app.listScanning.model.FieldVO;
import com.quantumdataengines.app.listScanning.model.RecordVO;
import com.quantumdataengines.app.listScanning.dataInfoReaders.main.IndexFieldVO;


public interface RTScanningDAO {
	ArrayList<HashMap<String,String>> getRealtimeScanningResults(String userCode, String type, String nameEnglish, String idNumber, String nationality, String passportId, String residence, String birthPlace, String params);
	ArrayList<HashMap<String,String>> getRealtimeEntityScanning(String userCode, String entityName, String listName, String matchScore);
    public FieldVO[] getSelectedFieldProperties(int a_intReportID);
    public RecordVO getSelectedRecordProperties(int a_intReportID);
    public HashMap<String,Vector<IndexFieldVO>> getSelectedIndexingInfo(int a_intReportID);
    public HashMap<String,IndexFieldVO> getSelectedIndexingInfo(String a_strListCode);
    public String getSelectedListCode(int a_intReportID);
    public Collection getSelectedSearchSettings(int a_intReportID);
    public Collection getSelectedSearchSettings(int a_intReportID, HashMap a_hmSearchData);
    public Collection getSelectedFieldMappingInfo(int a_intReportID,String a_strListCode,String a_strUser,String a_strTemplateId,String a_isFileImport);
    public void saveRealtimeSearchResults(Collection a_alResults,int a_intImportId,String a_strUniqueId, String a_fileName ,String isFileImport , String a_UserCode , String a_blacklistid,String a_strTemplateId);	
    public Map getSavedFileMatches(String a_FileName,String isFileImport,int counter);
    public Map getSavedFileMatches(MatchResultVO l_matchVO);
    public String saveSelectedImportFile(String a_reportid,String a_filedir,String a_data,String a_fileactualname,String a_templateid,String a_user,String a_delimiter,String a_blacklistid,String a_whitelistid);
    public String saveSelectedImportFileNew(String a_reportid,String a_filedir,String a_data,String a_fileactualname,String a_templateid,String a_user,String a_delimiter,String tableName);
	HashMap<String,Object> getSavedFileImportLog(String reportId, String templateId, String userId);
	String getSavedSwiftFileImportLog(String fileName, String userCode);
	public Map<String, Object> getFileImportDetailss(File fileName, String entityName);
}

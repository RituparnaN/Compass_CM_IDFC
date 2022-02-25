package com.quantumdataengines.app.compass.service.scanning;

import java.io.File;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Vector;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.quantumdataengines.app.compass.dao.scanning.OnlineScanningDAO;
import com.quantumdataengines.app.compass.dao.scanning.RTScanningDAO;
import com.quantumdataengines.app.compass.model.scanning.MatchResultVO;
import com.quantumdataengines.app.compass.schema.Configuration;
import com.quantumdataengines.app.compass.service.scanning.search.SearchEngineImpl;
import com.quantumdataengines.app.compass.util.ConnectionUtil;
//import com.quantumdataengines.aml.dao.ScanningDAO;
import com.quantumdataengines.app.compass.util.UserContextHolder;

@Service
public class OnlineScanningServiceImpl implements OnlineScanningService {

	private OnlineScanningDAO OnlineScanningDAO;
	private RTScanningDAO RTScanningDAO;
	//private ScanningDAO ScanningDAO;
	private SearchEngineImpl objSearchEngineImpl = null;
	@Autowired
	private ConnectionUtil connectionUtil;
	private static final Logger log = LoggerFactory.getLogger(OnlineScanningServiceImpl.class);
	
	@Autowired
	public OnlineScanningServiceImpl(OnlineScanningDAO OnlineScanningDAO, RTScanningDAO RTScanningDAO) {
		this.OnlineScanningDAO = OnlineScanningDAO;
		this.RTScanningDAO = RTScanningDAO;
		//this.ScanningDAO = ScanningDAO;
	}

//	@Override
    public ArrayList<HashMap<String,String>> getScanningResults(String userCode, String type, String nameEnglish, String idNumber, String nationality, String passportId, String residence, String birthPlace, String params)
    {
        return OnlineScanningDAO.getOnlineScanningResults(userCode, type, nameEnglish, idNumber, nationality, passportId, residence, birthPlace, params);
    }
    public ArrayList<HashMap<String,String>> getEntityScanning(String userCode, String entityName, String listName, String matchScore)
    {
        return OnlineScanningDAO.getOnlineEntityScanning(userCode, entityName, listName, matchScore);
    }

//	@Override
    public boolean insertRecord(String a_strColumnName,String a_strColumnValue)
    {
        return OnlineScanningDAO.saveOnlineRecords(a_strColumnName,a_strColumnValue);
    }

//	@Override
    public HashMap getSearchValues(String a_strColumnName,String a_strColumnValue)
    {
        return OnlineScanningDAO.getSavedSearchValues(a_strColumnName,a_strColumnValue);
    }

//	@Override
    public ArrayList getListDetails(String listname, String listid,String l_strViewType)   
    {
        return OnlineScanningDAO.getSelectedListDetails(listname, listid, l_strViewType);
    }

//	@Override
    public Map getFileMatches(MatchResultVO l_matchVO)
    {
        return OnlineScanningDAO.getSavedFileMatches(l_matchVO);
    }
    
//	@Override
    public Vector exportToFile(MatchResultVO l_CMatchResultVO)
    {
        return OnlineScanningDAO.exportSavedDataToFile(l_CMatchResultVO);
    }
    
//	@Override
    public ArrayList getRecords(MatchResultVO l_CMatchResultVO)    
    {
        return OnlineScanningDAO.getSavedRecords(l_CMatchResultVO);
    }

//	@Override
    public Vector getFileNames(String a_action)
    {
        return OnlineScanningDAO.getImportedFileNames(a_action);
    }

//	@Override
    public HashMap<String,Object> getAuditRecords(String a_fromdate,String a_todate,String a_filename,String a_fileimport,String a_counter)	
    {
        return OnlineScanningDAO.getSavedAuditRecords(a_fromdate, a_todate, a_filename, a_fileimport, a_counter);
    }

//	@Override
    public void updateRecord(String a_action,String a_selected,String a_userCode, String a_strFileName, String a_comments)
    {
        OnlineScanningDAO.updateActionRecord(a_action, a_selected, a_userCode, a_strFileName, a_comments);
    }
    

//	@Override
    public String getComments(String uniqueNumber)
    {
    	return OnlineScanningDAO.getComments(uniqueNumber);
    }

//	@Override
    public String insertFile(String a_reportid, String a_filedir, String a_data, String a_fileactualname, 
    		String a_templateid, String a_user, String a_delimiter, String a_blacklistid, String a_whitelistid, 
    		HashMap l_hmSearchData) {
    
    Configuration configuration = UserContextHolder.getUserContext();
    String DailyImportFilesPath = configuration.getPaths().getIndexingPath()+File.separator+"DailyImportFiles";
    File DailyImportFilesDir = new File(DailyImportFilesPath);
    if(!DailyImportFilesDir.exists())
    	DailyImportFilesDir.mkdirs();
    
	String strResultMessage = RTScanningDAO.saveSelectedImportFile(a_reportid,DailyImportFilesPath,a_data,a_fileactualname,a_templateid,a_user,a_delimiter,a_blacklistid,a_whitelistid);
	try {
		//String onlineScanningImportId = ApplicationProperties.getInstance().getProperty("NonCustomerImportId").trim();
		//String onlineScanningListId = ApplicationProperties.getInstance().getProperty("DenyListImportId").trim();
		//String useThread = ApplicationProperties.getInstance().getProperty("UseThread").trim();
		String onlineScanningImportId = "199";
		//String strIsToUseThread = "no";
		// System.out.println("In OnlineScanningServiceImple - message: "+strResultMessage);
		if(strResultMessage.equals("File Succesfully Imported")) {
		//System.out.println("In OnlineScanningServiceImple - a_reportid.equals(onlineScanningImportId): "+a_reportid.equals(onlineScanningImportId));
			if(a_reportid.equals(onlineScanningImportId)) {
				SearchEngineImpl l_SearchEngineImpl = new SearchEngineImpl("TT_IMPORT"+a_reportid+"_"+a_user,Integer.parseInt(a_reportid),SearchEngineImpl.l_intDB_SOURCE,RTScanningDAO,a_fileactualname,a_user,a_blacklistid);
				l_SearchEngineImpl.initializeListSearch(Integer.parseInt(a_reportid),a_templateid,"Y",l_hmSearchData);
				Date start = new Date();
				/*
				if(strIsToUseThread.equalsIgnoreCase("yes"))
					l_SearchEngineImpl.listSearchUsingthread();
				else
					l_SearchEngineImpl.listSearch(); 
				*/
				//l_SearchEngineImpl.listSearch();
				l_SearchEngineImpl.listSearch(connectionUtil.getConnection());
				Date end = new Date();
				long time = end.getTime()-start.getTime();
				// System.out.println("Total Search Time In Millis -"+time);
			}
		}
	} catch(Exception e) {
		log.error("Error occured in insertFile : "+e.getMessage());
	e.printStackTrace();
	}
	finally
	{
	return strResultMessage;
	}
    }
    
    public String insertFileNew(String a_reportid,String a_filedir,String a_data,String a_fileactualname,String a_templateid,String a_user,String a_delimiter,String a_blacklistid,String a_whitelistid,HashMap l_hmSearchData)
    {
    String strResultMessage = "";
    StringBuilder userCorrectedName = new StringBuilder(a_user.replace(".", "_"));
    String tableName = "TT_IMPORT"+"_"+userCorrectedName.reverse();
    
    // System.out.println("tableName : "+tableName);
    
    try {
	strResultMessage = RTScanningDAO.saveSelectedImportFileNew(a_reportid,a_filedir,a_data,a_fileactualname,a_templateid,a_user,a_delimiter,tableName);
	//String onlineScanningImportId = ApplicationProperties.getInstance().getProperty("NonCustomerImportId").trim();
	//String onlineScanningListId = ApplicationProperties.getInstance().getProperty("DenyListImportId").trim();
	//String useThread = ApplicationProperties.getInstance().getProperty("UseThread").trim();
	String onlineScanningImportId = "199";
	//String strIsToUseThread = "no";
	// System.out.println("In OnlineScanningServiceImple - message: "+strResultMessage);
	if(strResultMessage.equals("File Succesfully Imported"))
	{
	//System.out.println("In OnlineScanningServiceImple - a_reportid.equals(onlineScanningImportId): "+a_reportid.equals(onlineScanningImportId));
	if(a_reportid.equals(onlineScanningImportId))
	{
		
	// SearchEngineImpl l_SearchEngineImpl = new SearchEngineImpl("TT_IMPORT"+a_reportid+"_"+a_user,Integer.parseInt(a_reportid),SearchEngineImpl.l_intDB_SOURCE,RTScanningDAO,a_fileactualname,a_user,a_blacklistid);
	SearchEngineImpl l_SearchEngineImpl = new SearchEngineImpl(tableName,Integer.parseInt(a_reportid),SearchEngineImpl.l_intDB_SOURCE,RTScanningDAO,a_fileactualname,a_user,a_blacklistid);
	l_SearchEngineImpl.initializeListSearch(Integer.parseInt(a_reportid),a_templateid,"Y",l_hmSearchData);
	Date start = new Date();
	/*
	if(strIsToUseThread.equalsIgnoreCase("yes"))
		l_SearchEngineImpl.listSearchUsingthread();
	else
		l_SearchEngineImpl.listSearch(); 
	*/
	//l_SearchEngineImpl.listSearch();
	l_SearchEngineImpl.listSearch(connectionUtil.getConnection());
	Date end = new Date();
	long time = end.getTime()-start.getTime();
	// System.out.println("Total Search Time In Millis -"+time);
	}
	}
	}
	catch(Exception e)
	{
		log.error("Error occured in insertFile : "+e.getMessage());
	e.printStackTrace();
	}
	finally
	{
	return strResultMessage;
	}
    }
    public Map<String, Object> getFileImportDetailss(File fileName, String entityName){
    	return RTScanningDAO.getFileImportDetailss(fileName, entityName);    	
    }
    public LinkedHashMap  getScanReport(String reportId, HashMap a_hmSearchData)
	{
	LinkedHashMap  linkedHashMapScanReport = new LinkedHashMap();
	try
	{			
	String usercode = a_hmSearchData.get("LoggedInUser")==null?" ":a_hmSearchData.get("LoggedInUser").toString();
	a_hmSearchData.remove("LoggedInUser");
	objSearchEngineImpl = new SearchEngineImpl(RTScanningDAO,usercode);
	//System.out.println("Time In Millis Initialize Single Search Begin-"+System.currentTimeMillis());
	//objSearchEngineImpl.initializeListSearch(Integer.parseInt("6"),"NA","N");
	objSearchEngineImpl.initializeListSearch(Integer.parseInt(reportId),"NA","N",a_hmSearchData);
	//objSearchEngineImpl.initializeListSearch(Integer.parseInt("121"),"NA","N");
	//objSearchEngineImpl.initializeListSearch(Integer.parseInt("122"),"NA","N");
	//objSearchEngineImpl.initializeListSearch(Integer.parseInt("123"),"NA","N");
	//System.out.println("Time In Millis Initialize Single Search End-"+System.currentTimeMillis());
	long startTime = System.currentTimeMillis();
	// System.out.println("Time In Millis Start Single Search- "+startTime);
	linkedHashMapScanReport = (LinkedHashMap )objSearchEngineImpl.listSearch(a_hmSearchData);
	long endTime = System.currentTimeMillis();
	// System.out.println("Time In Millis End Single Search- "+endTime);
	// System.out.println("Total Search Time In Millis :- "+(endTime-startTime));
	}
	catch(Exception e)
	{
		log.error("Error occured in getScanReport : "+e.getMessage());
		e.printStackTrace();
	}	
	//System.out.println("Time In Millis getScanReport End- "+System.currentTimeMillis());
	return linkedHashMapScanReport;
	}   
	
	public ArrayList<HashMap<String,String>> getFieldScanSummaryDetails(String uniqueNumber, String fileName, String sbNameValuePairs, String userCode, String userRole, String ipAddress){
        return OnlineScanningDAO.getFieldScanSummaryDetails(uniqueNumber, fileName, sbNameValuePairs, userCode, userRole, ipAddress);
    }

	@Override
	public String getUniqueNumber(String filename, String templateSeqNo) {
		return OnlineScanningDAO.getUniqueNumber(filename, templateSeqNo);
	}
}
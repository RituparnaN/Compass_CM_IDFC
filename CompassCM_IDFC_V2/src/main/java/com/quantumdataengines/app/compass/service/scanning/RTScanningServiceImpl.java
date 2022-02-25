package com.quantumdataengines.app.compass.service.scanning;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.quantumdataengines.app.compass.dao.scanning.RTScanningDAO;
import com.quantumdataengines.app.compass.model.scanning.MatchResultVO;
import com.quantumdataengines.app.compass.service.scanning.search.SearchEngineImpl;
//import com.quantumdataengines.aml.dao.ScanningDAO;

@Service
public class RTScanningServiceImpl implements RTScanningService {

	private RTScanningDAO RTScanningDAO;
	private SearchEngineImpl objSearchEngineImpl = null;
	private static final Logger log = LoggerFactory.getLogger(RTScanningServiceImpl.class);
	
	@Autowired
	public RTScanningServiceImpl(RTScanningDAO RTScanningDAO) {
		this.RTScanningDAO = RTScanningDAO;
		//this.ScanningDAO = ScanningDAO;
	}

//	@Override
    public ArrayList<HashMap<String,String>> getScanningResults(String userCode, String type, String nameEnglish, String idNumber, String nationality, String passportId, String residence, String birthPlace, String params)
    {
        return RTScanningDAO.getRealtimeScanningResults(userCode, type, nameEnglish, idNumber, nationality, passportId, residence, birthPlace, params);
    }
    public ArrayList<HashMap<String,String>> getEntityScanning(String userCode, String entityName, String listName, String matchScore)
    {
        return RTScanningDAO.getRealtimeEntityScanning(userCode, entityName, listName, matchScore);
    }

    //	@Override
	public Map getFileMatches(MatchResultVO l_matchVO)
    {
        return RTScanningDAO.getSavedFileMatches(l_matchVO);
    }

    public LinkedHashMap  getScanReport(HashMap a_hmSearchData)
	{
		LinkedHashMap  l_vScanReport = new LinkedHashMap ();
		try
		{			
			String usercode = a_hmSearchData.get("LoggedInUser")==null?" ":a_hmSearchData.get("LoggedInUser").toString();
			a_hmSearchData.remove("LoggedInUser");
			objSearchEngineImpl = new SearchEngineImpl(RTScanningDAO,usercode);
			//System.out.println("Time In Millis Initialize Single Search Begin-"+System.currentTimeMillis());
			objSearchEngineImpl.initializeListSearch(Integer.parseInt("6"),"NA","N");
			//objSearchEngineImpl.initializeListSearch(Integer.parseInt("121"),"NA","N");
			//objSearchEngineImpl.initializeListSearch(Integer.parseInt("122"),"NA","N");
			//objSearchEngineImpl.initializeListSearch(Integer.parseInt("123"),"NA","N");
			//System.out.println("Time In Millis Initialize Single Search End-"+System.currentTimeMillis());
			System.out.println("Time In Millis Start Single Search- "+System.currentTimeMillis());
			l_vScanReport = (LinkedHashMap )objSearchEngineImpl.listSearch(a_hmSearchData);
			System.out.println("Time In Millis End Single Search- "+System.currentTimeMillis());
	
		}
		catch(Exception e)
		{
			log.error("Error occured : "+e.getMessage());
			e.printStackTrace();
		}	
		//System.out.println("Time In Millis getScanReport End- "+System.currentTimeMillis());
		return l_vScanReport;
	}

}
package com.quantumdataengines.app.compass.service.scanning;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;

import com.quantumdataengines.app.compass.model.scanning.MatchResultVO;

public interface RTScanningService {
	ArrayList<HashMap<String,String>> getScanningResults(String userCode, String type, String nameEnglish, String idNumber, String nationality, String passportId, String residence, String birthPlace, String params);
	ArrayList<HashMap<String,String>> getEntityScanning(String userCode, String entityName, String listName, String matchScore);
	//void createIndexes(String sourceName, String importId);
	LinkedHashMap getScanReport(HashMap a_hmSearchData);
	public Map getFileMatches(MatchResultVO l_matchVO);
}
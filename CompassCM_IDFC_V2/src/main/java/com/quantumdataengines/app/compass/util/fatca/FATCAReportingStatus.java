package com.quantumdataengines.app.compass.util.fatca;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.CopyOnWriteArrayList;

public class FATCAReportingStatus {
	FATCAReportingStatus fatcaReportingStatus = new FATCAReportingStatus();
	
	private FATCAReportingStatus(){}
	
	static Map<String, List<FATCAMessage>> fatcaMessageMap = new HashMap<String, List<FATCAMessage>>();
	static Map<String, FATCAFileGeneration> fatcaFileGenerationLog = new HashMap<String, FATCAFileGeneration>();
	
	public static List<FATCAMessage> getFATCAMessageList(String caseNo){
		return fatcaMessageMap.get(caseNo);
	}
	
	public static FATCAFileGeneration getFATCAFileGeneration(String caseNo){
		return fatcaFileGenerationLog.get(caseNo);
	}
	
	public static void setFATCAReportingStatus(String caseNo, FATCAFileGeneration fatcaFileGeneration){
		fatcaFileGenerationLog.put(caseNo, fatcaFileGeneration);
		if(fatcaFileGeneration == null)
			fatcaMessageMap.put(caseNo, null);
	}
	
	public static void setFATCAMessage(String caseNo, FATCAMessage fatcaMessage){
		List<FATCAMessage> fatcaMessageList = fatcaMessageMap.get(caseNo);
		if(fatcaMessageList == null){
			fatcaMessageList = new CopyOnWriteArrayList<FATCAMessage>();
		}
		if(fatcaMessage != null)
			fatcaMessageList.add(fatcaMessage);
		fatcaMessageMap.put(caseNo, fatcaMessageList);
	}
	
	public List<FATCAMessage> getAllMessagees(String caseNo){
		return fatcaMessageMap != null ? fatcaMessageMap.get(caseNo) : new ArrayList<FATCAMessage>();
	}
}

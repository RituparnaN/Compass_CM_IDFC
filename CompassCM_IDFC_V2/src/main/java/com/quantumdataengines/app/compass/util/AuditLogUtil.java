package com.quantumdataengines.app.compass.util;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.CopyOnWriteArrayList;

import com.quantumdataengines.app.compass.model.AuditLog;

public class AuditLogUtil {
	private static AuditLogUtil auditLogUtil = new AuditLogUtil();
	private static Map<String, List<AuditLog>> auditLogMap = new LinkedHashMap<String, List<AuditLog>>();
	private static boolean processing = false;
	
	private AuditLogUtil (){}
	
	public static void newInstance(String keyName){
		auditLogMap.put(keyName, new CopyOnWriteArrayList<AuditLog>());
	}
	
	public static Map<String, List<AuditLog>> getAuditLogList(){
		return auditLogMap;
	}
	
	public static void setProcessing(boolean processing){
		AuditLogUtil.processing = processing;
	}
	
	public static void add(String instituteName, AuditLog auditLog){
		while(processing){
			
		}
		if(auditLogMap.get(instituteName) == null){
			AuditLogUtil.newInstance(instituteName);
		}
		auditLogMap.get(instituteName).add(auditLog);
	}
}

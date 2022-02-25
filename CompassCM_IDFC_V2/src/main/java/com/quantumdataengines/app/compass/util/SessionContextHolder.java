package com.quantumdataengines.app.compass.util;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

public class SessionContextHolder {
	private static Map<String, HttpSession> sessionHolder = new HashMap<String, HttpSession>();
	
	private SessionContextHolder(){}
	
	public static Map<String, HttpSession> getAllSessionActive(){
		return sessionHolder;
	}
	
	public static List<String> getAllSessionIdsActive(){
		List<String> allSessionIds = new ArrayList<String>(sessionHolder.keySet());
		return allSessionIds;
	}
	
	public static HttpSession getActiveSession(String sessionId){
		return sessionHolder.get(sessionId);
	}
	
	public static void setSession(String sessionId, HttpSession session){
		sessionHolder.put(sessionId, session);
	}
	
	public static void removeSession(String sessionId){
		sessionHolder.remove(sessionId);
	}
}

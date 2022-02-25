package com.quantumdataengines.app.compass.util;

import java.util.HashMap;
import java.util.Map;

public class CompassSystemInfoHolder {
	private static final Map<String, String> systemInfo = new HashMap<String, String>();
	
	private CompassSystemInfoHolder(){}
	
	public static Map<String, String> getSystemAllInfo(){
		return systemInfo;
	}
	
	public static void setSystemInfo(String info, String value){
		systemInfo.put(info, value);
	}
	
	public static String getSysteInfo(String info){
		return systemInfo.get(info) != null ? systemInfo.get(info) : "Not found";
	}
}

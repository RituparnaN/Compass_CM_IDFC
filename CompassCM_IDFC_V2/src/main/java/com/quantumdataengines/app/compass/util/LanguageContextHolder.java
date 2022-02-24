package com.quantumdataengines.app.compass.util;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.quantumdataengines.app.compass.view.CompassHashMapImpl;

public class LanguageContextHolder {
	private static Map<String, CompassHashMapImpl<String, String>> allLanguage = new HashMap<String, CompassHashMapImpl<String, String>>();
	
	private LanguageContextHolder(){}
	
	public static List<String> getAllLanguageCodeInstalled(){
		List<String> allLangCode = new ArrayList<String>(allLanguage.keySet());
		return allLangCode;
	}
	
	public static Map<String, String> getLanguage(String languageCode){
		return allLanguage.get(languageCode);
	}
	
	public static void setLanguageCode(String languageCode, CompassHashMapImpl<String, String> languageProperties){
		allLanguage.put(languageCode, languageProperties);
	}
}

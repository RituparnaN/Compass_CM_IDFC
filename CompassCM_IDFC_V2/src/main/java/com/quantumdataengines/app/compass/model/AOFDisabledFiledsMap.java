package com.quantumdataengines.app.compass.model;

import java.util.ArrayList;
import java.util.List;

public class AOFDisabledFiledsMap {
	static List<String> disabledFileds;
	static AOFDisabledFiledsMap aofDisabledFiledsMap;
	
	private AOFDisabledFiledsMap (){}
	
	public static void init(){
		aofDisabledFiledsMap = new AOFDisabledFiledsMap();
		disabledFileds = new ArrayList<String>();
	}
	
	public static void setFiled(String field){
		disabledFileds.add(field);
	}
	
	public static boolean isFieldDisabled(String field){
		return disabledFileds.contains(field);
	}
}

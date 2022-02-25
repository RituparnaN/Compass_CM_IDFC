package com.quantumdataengines.app.compass.model;

import java.util.ArrayList;
import java.util.List;

public class CDDDisabledFieldsMap {
	static List<String> disabledFields;
	static CDDDisabledFieldsMap cddDisabledFieldsMap;
	
	private CDDDisabledFieldsMap (){}
	
	public static void init(){
		cddDisabledFieldsMap = new CDDDisabledFieldsMap();
		disabledFields = new ArrayList<String>();
	}
	
	public static void setField(String field){
		disabledFields.add(field);
	}
	
	public static boolean isFieldDisabled(String field){
		return disabledFields.contains(field);
	}
}

package com.quantumdataengines.app.compass.view;

import java.util.HashMap;

public class CompassHashMapImpl<k,v> extends HashMap<String,String>{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Override
	public String get(Object key) {
		if(super.get(key) == null)
			return (String) key;
		else
			return super.get(key);
	}	
}

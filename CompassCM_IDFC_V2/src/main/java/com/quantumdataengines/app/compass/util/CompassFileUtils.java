package com.quantumdataengines.app.compass.util;

import java.io.File;

import org.springframework.stereotype.Component;

@Component
public class CompassFileUtils {
	
	
	public boolean isValidFileName(String fileName){
		try {
	    	File f = File.createTempFile(fileName, ".tmp");
	    	String path = f.getCanonicalPath();
	    	f.delete();
	    	return true;
	    }
	    catch (Exception e) {
	    	return false;
	    }
	}

}

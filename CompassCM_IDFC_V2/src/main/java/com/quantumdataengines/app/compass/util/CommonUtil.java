package com.quantumdataengines.app.compass.util;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.lang.invoke.MethodHandles;
import java.sql.Clob;
import java.sql.SQLException;
import java.util.Properties;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServletRequest;

import org.springframework.core.io.Resource;
import org.springframework.core.io.support.PathMatchingResourcePatternResolver;

import eu.bitwalker.useragentutils.Browser;
import eu.bitwalker.useragentutils.UserAgent;

public class CommonUtil {
	public static String[] splitString(String stringToSplit, String delimiter) {
        String[] aRet;
        int iLast;
        int iFrom;
        int iFound;
        int iRecords;

        // return Blank Array if stringToSplit == "")
        if (stringToSplit.equals("")) {
            return new String[0];
        }

        // count Field Entries
        iFrom = 0;
        iRecords = 0;
        while (true) {
            iFound = stringToSplit.indexOf(delimiter, iFrom);
            if (iFound == -1) {
                break;
            }
            iRecords++;
            iFrom = iFound + delimiter.length();
        }
        iRecords = iRecords + 1;

        // populate aRet[]
        aRet = new String[iRecords];
        if (iRecords == 1) {
            aRet[0] = stringToSplit;
        } else {
            iLast = 0;
            iFrom = 0;
            iFound = 0;
            for (int i = 0; i < iRecords; i++) {
                iFound = stringToSplit.indexOf(delimiter, iFrom);
                if (iFound == -1) { // at End
                    aRet[i] = stringToSplit.substring(iLast + delimiter.length(), stringToSplit.length());
                } else if (iFound == 0) { // at Beginning
                    aRet[i] = "";
                } else { // somewhere in middle
                    aRet[i] = stringToSplit.substring(iFrom, iFound);
                }
                iLast = iFound;
                iFrom = iFound + delimiter.length();
            }
        }
        return aRet;
    }
	
	public static String changeColumnName(String actualColumnName){
		String revisedColumnName = "";
		if(actualColumnName.contains("app."))
			revisedColumnName = actualColumnName;
		else
			revisedColumnName = "app.common."+actualColumnName;
		return revisedColumnName;
	}
	
	public static boolean validateEmailAddress(String emailAddress) {
		Pattern  regexPattern = Pattern.compile("^[(a-zA-Z-0-9-\\_\\+\\.)]+@[(a-z-A-z)]+\\.[(a-zA-z)]{2,3}$");
		Matcher regMatcher   = regexPattern.matcher(emailAddress);
	    if(regMatcher.matches()){
	        return true;
	    } else {
	    return false;
	    }
	}
	
	public static Properties loadProperties(){
		Properties properties = new Properties();
        InputStream is = null;
        try {
        	ClassLoader classLoader = MethodHandles.lookup().getClass().getClassLoader();
            PathMatchingResourcePatternResolver resolver = new PathMatchingResourcePatternResolver(classLoader);
			
            //PathMatchingResourcePatternResolver resolver = new PathMatchingResourcePatternResolver();
            
	        // Ant-style path matching
	        Resource[] resources = resolver.getResources("classpath:properties/*.properties");

	        for (Resource resource : resources) {
	        	//File propFile = resource.getFile();
	        	//System.out.println("Loading properties from : "+propFile.getAbsolutePath());
	            is = resource.getInputStream();
	            properties.load(is);
	        }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return properties;
    }
	
	public static String getBrowserFingerPrint(HttpServletRequest request){
		UserAgent userAgent = UserAgent.parseUserAgentString(request.getHeader("User-Agent"));
		Browser browser = userAgent.getBrowser();
		//String browserName = "Browser : "+userAgent.getBrowser().getName() +", Version : "+ userAgent.getBrowserVersion().getVersion();
		
		return browser.getName()+userAgent.getBrowserVersion().getVersion();
	}
	
	public static String clobStringConversion(Clob clb) throws IOException, SQLException{
	  if (clb == null)
		  return  "";
			
	  StringBuffer str = new StringBuffer();
	  String strng;
	  BufferedReader bufferRead = new BufferedReader(clb.getCharacterStream());
	  while ((strng=bufferRead .readLine())!=null)
	   str.append(strng);
   
	  return str.toString();
	}
	
}

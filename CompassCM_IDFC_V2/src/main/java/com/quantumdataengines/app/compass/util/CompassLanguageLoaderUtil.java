package com.quantumdataengines.app.compass.util;

import java.io.BufferedReader;
import java.io.File;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.Properties;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.core.io.Resource;
import org.springframework.core.io.support.PathMatchingResourcePatternResolver;

import com.quantumdataengines.app.compass.view.CompassHashMapImpl;

public class CompassLanguageLoaderUtil {
	
	private static final Logger log = LoggerFactory.getLogger(CompassLanguageLoaderUtil.class);
	
	public void loadLanguagesInstalled() throws Exception{
		try{
			ClassLoader loader = CompassLanguageLoaderUtil.class.getClassLoader();
			Properties properties = new Properties();
			
			PathMatchingResourcePatternResolver resolver = new PathMatchingResourcePatternResolver();

	        // Ant-style path matching
	        //Resource[] resources = resolver.getResources("/language/**");
			Resource[] resources = resolver.getResources("language/**/*.properties");
	        System.out.println("REsources = "+resources);
	        System.out.println("Lang file : "+resources.length);

	        for (Resource resource : resources) {
	        	File languageFile = resource.getFile();
	        	System.out.println("Absolute Path = "+languageFile.getAbsolutePath());
	        	String fileName = languageFile.getName();
	        	System.out.println("fileName= "+fileName);
	            InputStream is = resource.getInputStream();
	            
	            CompassHashMapImpl<String, String> propertyMap = new CompassHashMapImpl<String, String>();
				String langCode = fileName.substring(fileName.indexOf("_")+1, fileName.indexOf("."));
				log.info("Loading language from file "+fileName+" for language code "+langCode);
				
				System.out.println("Loading language from file "+fileName+" for language code "+langCode);
				
				BufferedReader reader1 = new BufferedReader(new InputStreamReader(loader.getResourceAsStream("language/"+fileName), "UTF-8"));
				properties.load(reader1);
				for(String propKey : properties.stringPropertyNames()){
					propertyMap.put(propKey, properties.getProperty(propKey));
				}
				log.info("Language for language code "+langCode+" loaded");
				System.out.println("Language for language code "+langCode+" loaded");
				LanguageContextHolder.setLanguageCode(langCode, propertyMap);
				reader1.close();
	        }
	        /*
			File file = new File(loader.getResource("language").getFile());
			
			System.out.println("file.isDirectory() : "+ file.isDirectory()+" file path : "+file.getAbsolutePath()+"  "+file.getName());
			
			for(File languageFile : file.listFiles()){
				String fileName = languageFile.getName();
				CompassHashMapImpl<String, String> propertyMap = new CompassHashMapImpl<String, String>();
				String langCode = fileName.substring(fileName.indexOf("_")+1, fileName.indexOf("."));
				log.info("Loading language from file "+fileName+" for language code "+langCode);
				
				BufferedReader reader1 = new BufferedReader(new InputStreamReader(loader.getResourceAsStream("language/"+fileName), "UTF-8"));
				properties.load(reader1);
				for(String propKey : properties.stringPropertyNames()){
					propertyMap.put(propKey, properties.getProperty(propKey));
				}
				log.info("Language for language code "+langCode+" loadded");
				LanguageContextHolder.setLanguageCode(langCode, propertyMap);
				reader1.close();
			}
			
			
			BufferedReader reader = new BufferedReader(new InputStreamReader(loader.getResourceAsStream("language"), "UTF-8"));
			Properties properties = new Properties();
			String fileName;
			
			System.out.println("reader : "+reader);
			
			while ((fileName = reader.readLine()) != null) {
				CompassHashMapImpl<String, String> propertyMap = new CompassHashMapImpl<String, String>();
				String langCode = fileName.substring(fileName.indexOf("_")+1, fileName.indexOf("."));
				log.info("Loading language from file "+fileName+" for language code "+langCode);
				
				BufferedReader reader1 = new BufferedReader(new InputStreamReader(loader.getResourceAsStream("language/"+fileName), "UTF-8"));
				properties.load(reader1);
				for(String propKey : properties.stringPropertyNames()){
					propertyMap.put(propKey, properties.getProperty(propKey));
				}
				log.info("Language for language code "+langCode+" loadded");
				LanguageContextHolder.setLanguageCode(langCode, propertyMap);
				reader1.close();
			}
			reader.close();
			*/
		}catch(Exception e){
			log.error("Error while loading languages : "+e.getMessage());
			throw e;
		}
	}
}

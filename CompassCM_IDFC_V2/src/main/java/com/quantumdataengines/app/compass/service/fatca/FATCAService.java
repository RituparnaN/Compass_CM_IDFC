package com.quantumdataengines.app.compass.service.fatca;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.quantumdataengines.app.compass.schema.Configuration;

public interface FATCAService {
	public Map<String, String> getFATCAFormData(String caseNo, String userCode);
	public List<String[]> getAllTitles();
	public List<String[]> getAllCountry();
	public boolean saveFATCAReport(Map<String, String> paramMap, String caseNo, String userCode);
	public boolean saveIndividualDetails(Map<String, String> paramMap, String caseNo, String lineNo, String userCode);
	public boolean saveAccountHolderDetails(Map<String, String> paramMap, String caseNo, String lineNo, String userCode);
	public List<Map<String, String>> getIndividualDetails(String caseNo, String lineNo, String userCode);
	public List<Map<String, String>> getAccountHolderDetails(String caseNo, String lineNo, String userCode);
	public boolean deleteindividualDetails(String caseNo, String lineNo, String userCode);
	public boolean deleteAccountHolderDetails(String caseNo, String lineNo, String userCode);
	public HashMap getForm8966XmlFileContent(String caseNo, String userCode);
	public Map<String, String> fatcaSettings();
	public boolean updateFATCASettings(Map<String, String> formData, String userCode);
	
	public Map<String, String> getFATCASettings();
	public Thread fatcaFileGeneration(final String caseNo, final String contextPath);
	public boolean validateXMLFile(String caseNo, String sourceXMLFile);
	public Thread fatcaFileProcessing(final String caseNo, final File xmlFile);
	public Thread unpackIRSNotification(String caseNo);
	public File generateCaseFolder(String caseFolder);
	public void storeFATCAStatus(Configuration configuration, String caseNo);
	public void removeFATCAStatus(String caseNo);
	public void loadFATCAStatusFromDB(Configuration configuration, String caseNo);
	public Map<String, Object> checkIRSNotificationFile(File zipFile);
}

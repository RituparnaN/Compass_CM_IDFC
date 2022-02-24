package com.quantumdataengines.app.compass.dao.fatca;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.quantumdataengines.app.compass.schema.Configuration;
import com.quantumdataengines.app.compass.util.fatca.FATCAFileGeneration;
import com.quantumdataengines.app.compass.util.fatca.FATCAMessage;

public interface FATCADAO {
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
	public HashMap getForm8966XmlFileContent(Configuration configurarion, String caseNo, String userCode);
	public Map<String, String> fatcaSettings();
	public boolean updateFATCASettings(Map<String, String> formData, String userCode);
	
	public Map<String, String> getFATCASettings(Configuration configurarion);
	public void storeFATCAStatus(Configuration configuration, String caseNo, FATCAFileGeneration fatcaFileGeneration, List<FATCAMessage> fatcaMessageList);
	public void removeFATCAStatus(String caseNo);
	public void loadFATCAStatusFromDB(Configuration configuration, String caseNo);
}

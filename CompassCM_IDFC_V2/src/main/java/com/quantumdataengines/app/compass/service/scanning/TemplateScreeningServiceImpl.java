package com.quantumdataengines.app.compass.service.scanning;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.quantumdataengines.app.compass.dao.scanning.TemplateScreeningDAO;

@Service
public class TemplateScreeningServiceImpl implements TemplateScreeningService {

	@Autowired
	private TemplateScreeningDAO TemplateScreeningDAO;
	
	@Override
	public Map checkTemplateId(String templateId) {
		
		return TemplateScreeningDAO.checkTemplateId(templateId);
	}
	
	@Override
	public Map<String, Object> searchTemplateScreening(String templateId, String templateName, String templateType, String templateDate, String userCode, String userRole, String ipAddress, String subModuleCode) {
		return TemplateScreeningDAO.searchTemplateScreening(templateId, templateName, templateType, templateDate, userCode, userRole, ipAddress, subModuleCode);
	}
	
	@Override
	public Map<String, Object> createTemplateScreening(String templateId, String templateName, String templateType, String userCode, String userRole, String ipAddress){
		return TemplateScreeningDAO.createTemplateScreening(templateId, templateName, templateType, userCode, userRole, ipAddress);
	}
	
	@Override
	public Map<String, Object> templateScreeningDetail(String templateId, String userCode, String userRole, String ipAddress, String subModuleCode)
	{
		return TemplateScreeningDAO.templateScreeningDetail(templateId, userCode, userRole, ipAddress, subModuleCode);
	}
	
	@Override
	public String insertDetailForTemplateScreening(String templateId, String templateName, String nameValue, String countryValue, String idValue, String userCode, String userRole, String ipAddress)
	{
		return TemplateScreeningDAO.insertDetailForTemplateScreening(templateId, templateName, nameValue, countryValue, idValue, userCode, userRole, ipAddress);
	}
	
	@Override
	public String deleteTemplateDetails(String templateId,String templateName, String seqNo, String userCode, String userRole, String ipAddress)
	{
		return TemplateScreeningDAO.deleteTemplateDetails(templateId, templateName, seqNo, userCode, userRole, ipAddress);
	}
	
	@Override
	public String getTemplateFieldValues(String templateSeqNo, String fieldType){
		return TemplateScreeningDAO.getTemplateFieldValues(templateSeqNo, fieldType);
	}
	
	@Override
	public String saveScreeningMapping(String templateSeqNo, String uniqueNumber, String fileName, String userCode, String userRole, String ipAddress){
		return TemplateScreeningDAO.saveScreeningMapping(templateSeqNo, uniqueNumber, fileName, userCode, userRole, ipAddress);
	}
	
	@Override
	public Map<String, Object> createAndFreeze(String templateSeqNo, String templateId, String userCode, String userRole, String ipAddress)
	{
		return TemplateScreeningDAO.createAndFreeze(templateSeqNo, templateId, userCode, userRole, ipAddress);
	}
	
	@Override
	public Map<String, Object> createNewVersion(String templateSeqNo, String templateId, String userCode, String userRole, String ipAddress)
	{
		return TemplateScreeningDAO.createNewVersion(templateSeqNo, templateId, userCode, userRole, ipAddress);
	}

	@Override
	public Map<String, String> getTemplateScreeningDetails(String templateSeqNo){
		return TemplateScreeningDAO.getTemplateScreeningDetails(templateSeqNo);
	}
	

	public Map<String, Object> updateTemplateScreeningStatus(String templateSeqNo, String templateScreeningStatus, String userComments, String userCode, String userRole, String ipAddress){
		return TemplateScreeningDAO.updateTemplateScreeningStatus(templateSeqNo, templateScreeningStatus, userComments, userCode, userRole, ipAddress);
	}

}
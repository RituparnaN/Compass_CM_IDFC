package com.quantumdataengines.app.compass.service.regulatoryReports.nepal;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.quantumdataengines.app.compass.dao.regulatoryReports.nepal.NepalSTRDAO;

@Service
public class NepalSTRServiceImpl implements NepalSTRService{

	@Autowired
	private NepalSTRDAO nepalSTRDAO;

	@Override
	public Map<String, String> fetchNepalSTRData(String caseNo,
			String userCode, String ipAddress, String CURRENTROLE) {
		return nepalSTRDAO.fetchNepalSTRData(caseNo, userCode, ipAddress, CURRENTROLE);
	}

	@Override
	public String saveNEPAL_STR(Map<String, String> paramMap, String caseNo,
			String userCode) {
		return nepalSTRDAO.saveNEPAL_STR(paramMap, caseNo, userCode);
	}
	
	@Override
	public Map<String, Object> getNepalSTRXMLFileContent(String caseNo, String userCode, String ipAddress, String CURRENTROLE){
		return nepalSTRDAO.getNepalSTRXMLFileContent(caseNo, userCode, ipAddress, CURRENTROLE);
	}
}

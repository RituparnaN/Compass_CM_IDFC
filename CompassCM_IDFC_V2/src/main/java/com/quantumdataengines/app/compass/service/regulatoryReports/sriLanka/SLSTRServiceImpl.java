package com.quantumdataengines.app.compass.service.regulatoryReports.sriLanka;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.quantumdataengines.app.compass.dao.regulatoryReports.sriLanka.SLSTRDAO;

@Service
public class SLSTRServiceImpl implements SLSTRService{
	
	@Autowired
	private SLSTRDAO slSTRDAO;

	public Map<String, String> getSLSTR(String caseNo, String userCode) {
		return slSTRDAO.getSLSTR(caseNo, userCode);
	}

	public boolean saveSLSTR(String caseNo, Map<String, String> formData, String updatedBy) {
		return slSTRDAO.saveSLSTR(caseNo, formData, updatedBy);
	}

}

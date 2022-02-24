package com.quantumdataengines.app.compass.service.regulatoryReports.maldives;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Service;

import com.quantumdataengines.app.compass.dao.regulatoryReports.maldives.MaldivesSTRDAO;

@Service
public class MaldivesSTRServiceImpl implements MaldivesSTRService{

	@Autowired
	private MaldivesSTRDAO maldivesSTRDao;

	@Override
	public Map<String, String> fetchMaldivesSTRData(String caseNo, String userCode, 
			String ipAddress, String CURRENTROLE) {
		return maldivesSTRDao.fetchMaldivesSTRData(caseNo, userCode, ipAddress, CURRENTROLE);
	}

	@Override
	public String saveMALDIVES_STR(Map<String,String> paramMap, String caseNo, String userCode) {
		System.out.println("saveMALDIVES_STR in service "+caseNo);
		return maldivesSTRDao.saveMALDIVES_STR(paramMap, caseNo, userCode);
	}
}

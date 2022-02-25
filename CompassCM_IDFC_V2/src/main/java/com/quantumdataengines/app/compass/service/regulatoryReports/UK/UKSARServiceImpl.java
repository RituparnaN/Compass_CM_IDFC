package com.quantumdataengines.app.compass.service.regulatoryReports.UK;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.quantumdataengines.app.compass.dao.regulatoryReports.UK.UKSARDAO;

@Service
public class UKSARServiceImpl implements UKSARService{

	@Autowired
	private UKSARDAO ukSARDao;

	@Override
	public Map<String, String> fetchUKSARData(String caseNo, String userCode,
			String ipAddress, String CURRENTROLE) {
		return ukSARDao.fetchUKSARData(caseNo, userCode, ipAddress, CURRENTROLE);
	}

	@Override
	public String saveUKSAR(Map<String, String> paramMap, String caseNo,
			String userCode) {
		return ukSARDao.saveUKSAR(paramMap, caseNo, userCode);
	}
}

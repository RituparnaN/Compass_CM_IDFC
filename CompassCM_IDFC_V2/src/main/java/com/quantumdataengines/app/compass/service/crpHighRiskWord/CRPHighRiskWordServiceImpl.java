package com.quantumdataengines.app.compass.service.crpHighRiskWord;


import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.quantumdataengines.app.compass.dao.crpHighRiskWord.CRPHighRiskWordDAO;

@Service
public class CRPHighRiskWordServiceImpl implements CRPHighRiskWordService{

	@Autowired
	private CRPHighRiskWordDAO crpHighRiskWordDAO;

	@Override
	public int getNewSeqNo() {
		return crpHighRiskWordDAO.getNewSeqNo();
	}
	
	@Override
	public String saveOrUpdateWordRecord(String fullData, String actionToTake, String currentUser, String currentRole, String ipAddress) {
		return crpHighRiskWordDAO.saveOrUpdateWordRecord(fullData, actionToTake, currentUser, currentRole, ipAddress);
	}
	
	@Override
	public List<Map<String, String>> getSeqNoDetails(String seqNo) {
		return crpHighRiskWordDAO.getSeqNoDetails(seqNo);
	}
	
	@Override
	public String approveOrReject(String action, String seqNo, String checkerComments, String currentUser, String currentRole, String ipAddress){
		return crpHighRiskWordDAO.approveOrReject(action, seqNo, checkerComments, currentUser, currentRole, ipAddress);
	}
}

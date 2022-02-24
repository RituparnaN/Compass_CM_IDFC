package com.quantumdataengines.app.compass.service.edd;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.quantumdataengines.app.compass.dao.edd.EDDDAO;

@Service
public class EDDServiceImpl implements EDDService{
	@Autowired
	private EDDDAO edddao;

	@Override
	public List<Map<String, String>> showEDDRecords (String caseNoForEDD) {
		return edddao.showEDDRecords(caseNoForEDD);
	}

	@Override
	public Map<String, List<String>> getEDDMasterData() {
		return edddao.getEDDMasterData();
	}

	@Override
	public String saveEDD(Map<String, String> paramMap, String seqNo,
			String userCode) {
		return edddao.saveEDD(paramMap, seqNo, userCode);
	}

	@Override
	public String updateEDD(Map<String, String> paramMap, String seqNo,
			String userCode) {
		return edddao.updateEDD(paramMap, seqNo, userCode);
	}

	@Override
	public Map<String, String> fetchDetailsToUpdateEDD(String seqNo) {
		return edddao.fetchDetailsToUpdateEDD(seqNo);
	}
	

}

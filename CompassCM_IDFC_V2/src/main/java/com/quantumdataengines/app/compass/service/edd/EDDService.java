package com.quantumdataengines.app.compass.service.edd;

import java.util.List;
import java.util.Map;

public interface EDDService {
	public List<Map<String, String>> showEDDRecords (String caseNoForEDD);
	public Map<String, List<String>> getEDDMasterData();
	public String saveEDD(Map<String,String> paramMap, String seqNo, String userCode);
	public Map<String, String> fetchDetailsToUpdateEDD(String seqNo);
	public String updateEDD(Map<String,String> paramMap, String seqNo, String userCode);
}

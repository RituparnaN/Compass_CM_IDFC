package com.quantumdataengines.app.compass.service.crpHighRiskWord;

import java.util.List;
import java.util.Map;

public interface CRPHighRiskWordService {
	public int getNewSeqNo();
	public String saveOrUpdateWordRecord(String fullData, String actionToTake, String currentUser, String currentRole, String ipAddress);
	public List<Map<String, String>> getSeqNoDetails(String seqNo);
	public String approveOrReject(String action, String seqNo, String checkerComments, String currentUser, String currentRole, String ipAddress);
}

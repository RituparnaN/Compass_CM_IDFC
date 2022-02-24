package com.quantumdataengines.app.compass.service.graphicalMasterModule;

import java.util.List;
import java.util.Map;

public interface GraphicalMasterService {

	public Map<String,Object> getGraphicalMasterData(String userCode, String userRole,String remoteAddr, String moduleType);

	/*public Map<String,Object> getGraphDetails(String columnName, String columnValue, String moduleType, String userCode, String userRole, String remoteAddr);*/

	

	public List<Map<String, String>> savingAccGraphicalMaster(String userCode, String userRole,String remoteAddr);

	public Map<String,Object> getAccountMasterDataView1(String userCode, String userRole,String remoteAddr, String moduleType);

	public Map<String, Object> getKeyValueData(String userCode,String userRole, String remoteAddr, String moduleType);

	public Map<String, Object> getUserStatsData(String userCode, String userRole,String remoteAddr, String moduleType);

	public Map<String, Object> searchPendingCases(Map<String, String> paramMap, String moduleType, String userCode, String userRole, String ipAddress);

	public Map<String, Object> customerPeerGroup(Map<String, String> paramMap, String moduleType,String userCode, String userRole, String remoteAddr);

	public Map<String, Object> getCustomerPeerGroupDetail(Map<String, String> paramMap,String moduleType, String userCode, String userRole, String ipAdress);
	

}

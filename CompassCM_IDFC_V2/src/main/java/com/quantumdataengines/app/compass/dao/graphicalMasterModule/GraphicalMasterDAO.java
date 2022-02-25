package com.quantumdataengines.app.compass.dao.graphicalMasterModule;

import java.util.List;
import java.util.Map;

public interface GraphicalMasterDAO {

	Map<String, Object> getGraphicalMasterData(String userCode, String userRole,String remoteAddr, String moduleType);

	/*Map<String, Object> getGraphDetails(String columnName, String columnValue, String moduleType, String userCode, String userRole, String remoteAddr);*/
	List<Map<String, String>> savingAccGraphicalMaster(String userCode, String userRole,String remoteAddr);
	Map<String, Object> getAccountMasterDataView1(String userCode,String userRole, String remoteAddr, String moduleType);
	Map<String, Object> getKeyValueData(String userCode,String userRole, String remoteAddr, String moduleType);
	Map<String, Object> getUserStatsData(String userCode, String userRole,String remoteAddr, String moduleType);
	Map<String, Object> searchPendingCases(Map<String, String> paramMap,String moduleType, String userCode, String userRole,String ipAddress);
	Map<String, Object> customerPeerGroup(Map<String, String> paramMap, String moduleType, String userCode,String userRole, String remoteAddr);
	Map<String, Object> getCustomerPeerGroupDetail(Map<String, String> paramMap, String moduleType, String userCode,String userRole, String ipAdress);

}

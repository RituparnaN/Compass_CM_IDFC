package com.quantumdataengines.app.compass.dao.offlineAlerts;

import java.util.Collection;
import java.util.List;
import java.util.Map;

public interface OfflineAlertsDAO {
	public Collection getListOfAlerts(String groupId, String userRole, String viewType);
	public String getAlertName(String alertId);
	public Map<String, Object> getListOfAlertBenchMarks(String alertId, String userRole, String viewType);
	public Map<String, Object> getAlertDetails(String alertId, String userRole);
    public String updateAlertDetailsandComments(String alertId, String alertName, String alertSubGroup, String alertSubGroupOrder, String alertFrequency, String seqNo, 
      	   String isEnabled, String lastAlertedTxnDate, String sourceSystem, String makerCode, String makerComments, String checkerCode, String checkerComments, 
      	   String status, String userCode, String userRole, String ipAddress);
	public List<Map<String, Object>> getAlertBenchMarkDetails(String alertId, String alertSerialNo, String alertApprovalStatus, String userRole, String viewType);
	public Map<String, Object> getAlertBenchMarkStatusDetails(String alertId, String alertSerialNo, String alertApprovalStatus, String userRole, String viewType);
	public boolean saveAlertBenchMarkParameters(String alertId, String alertSerialNo, Map<String, String> paramMap, String userCode, String userRole, String ipAdress, String userLogcomments);
	public boolean deleteAlertBenchMarkParameters(String alertId, String alertSerialNo, String requestType, String userCode, String userRole, String ipAdress, String userLogcomments);
	public String generateAlertWithBenchMarks(String alertId, String alertSerialNo, Map<String, String> paramMap, String generationType, String userCode, String userRole, String ipAdress);
	public String simulateAlertWithBenchMarks(String alertId, String alertSerialNo, Map<String, String> paramMap, String generationType, String userCode, String userRole, String ipAdress);
	public boolean approveAlertBenchMarkParameters(String alertId, String alertSerialNo, Map<String, String> paramMap, String requestType, String benchMarkStatus, String userCode, String userRole, String ipAdress, String userLogcomments);
	public boolean rejectAlertBenchMarkParameters(String alertId, String alertSerialNo, Map<String, String> paramMap, String requestType, String benchMarkStatus, String userCode, String userRole, String ipAdress, String userLogcomments);
    public List<String> getAlertSubGroup(String groupId);
    public String getAlertGroupName(String groupId);
    public boolean saveAlertBenchMarkParamsForSimulation(String alertId, String alertSerialNo, Map<String, String> paramMap, 
    		String userCode, String userRole, String ipAddress);
    public boolean deleteAlertBenchMarkParamsForSimulation(String alertId, String alertSerialNo, String requestType, 
    		String userCode, String userRole, String ipAddress, String userLogcomments);
}

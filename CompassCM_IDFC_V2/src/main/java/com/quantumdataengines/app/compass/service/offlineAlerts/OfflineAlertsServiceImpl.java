package com.quantumdataengines.app.compass.service.offlineAlerts;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.quantumdataengines.app.compass.dao.master.GenericMasterDAO;
import com.quantumdataengines.app.compass.dao.offlineAlerts.OfflineAlertsDAO;

@Service
public class OfflineAlertsServiceImpl implements OfflineAlertsService {

	@Autowired
	private OfflineAlertsDAO offlineAlertsDAO;

	@Override
    public Collection getListOfAlerts(String groupId, String userRole, String viewType){
        return offlineAlertsDAO.getListOfAlerts(groupId, userRole, viewType);
    }

	@Override
	public String getAlertName(String alertId){
		return offlineAlertsDAO.getAlertName(alertId);
	}
	
	@Override
    public Map<String, Object> getListOfAlertBenchMarks(String alertId, String userRole, String viewType){
        return offlineAlertsDAO.getListOfAlertBenchMarks(alertId, userRole, viewType);
    }

	@Override
	public Map<String, Object> getAlertDetails(String alertId, String userRole){
		return offlineAlertsDAO.getAlertDetails(alertId, userRole);
	}
	
	@Override
	 public String updateAlertDetailsandComments(String alertId, String alertName, String alertSubGroup, String alertSubGroupOrder, String alertFrequency, String seqNo, 
	   		String isEnabled, String lastAlertedTxnDate, String sourceSystem, String makerCode, String makerComments, String checkerCode, String checkerComments, 
	   		String status, String userCode, String userRole, String ipAddress){
		return offlineAlertsDAO.updateAlertDetailsandComments(alertId, alertName, alertSubGroup, alertSubGroupOrder, alertFrequency, seqNo, isEnabled, lastAlertedTxnDate, sourceSystem, 
				makerCode, makerComments, checkerCode, checkerComments, status, userCode, userRole, ipAddress);
	}
	
	@Override
    public List<Map<String, Object>> getAlertBenchMarkDetails(String alertId, String alertSerialNo, String alertApprovalStatus, String userRole, String viewType){
        return offlineAlertsDAO.getAlertBenchMarkDetails(alertId, alertSerialNo, alertApprovalStatus, userRole, viewType);
    }

	@Override
    public Map<String, Object> getAlertBenchMarkStatusDetails(String alertId, String alertSerialNo, String alertApprovalStatus, String userRole, String viewType){
    	return offlineAlertsDAO.getAlertBenchMarkStatusDetails(alertId, alertSerialNo, alertApprovalStatus, userRole, viewType);
	}

	@Override
	public boolean saveAlertBenchMarkParameters(String alertId, String alertSerialNo, Map<String, String> paramMap, String userCode, String userRole, String ipAdress, String userLogcomments){
		return offlineAlertsDAO.saveAlertBenchMarkParameters(alertId, alertSerialNo, paramMap, userCode, userRole, ipAdress, userLogcomments);
	}
	
	@Override
    public boolean deleteAlertBenchMarkParameters(String alertId, String alertSerialNo, String requestType, String userCode, String userRole, String ipAdress, String userLogcomments){
		return offlineAlertsDAO.deleteAlertBenchMarkParameters(alertId, alertSerialNo, requestType, userCode, userRole, ipAdress, userLogcomments);
	}

	@Override
	public String generateAlertWithBenchMarks(String alertId, String alertSerialNo, Map<String, String> paramMap, String generationType, String userCode, String userRole, String ipAdress){
		return offlineAlertsDAO.generateAlertWithBenchMarks(alertId, alertSerialNo, paramMap, generationType, userCode, userRole, ipAdress);
	}
	
	@Override
	public String simulateAlertWithBenchMarks(String alertId, String alertSerialNo, Map<String, String> paramMap, String generationType, String userCode, String userRole, String ipAdress){
		return offlineAlertsDAO.simulateAlertWithBenchMarks(alertId, alertSerialNo, paramMap, generationType, userCode, userRole, ipAdress);
	}

	@Override
	public boolean approveAlertBenchMarkParameters(String alertId, String alertSerialNo, Map<String, String> paramMap, String requestType, String benchMarkStatus, String userCode, String userRole, String ipAdress, String userLogcomments){
		return offlineAlertsDAO.approveAlertBenchMarkParameters(alertId, alertSerialNo, paramMap, requestType, benchMarkStatus, userCode, userRole, ipAdress, userLogcomments);
	}

	@Override
	public boolean rejectAlertBenchMarkParameters(String alertId, String alertSerialNo, Map<String, String> paramMap, String requestType, String benchMarkStatus, String userCode, String userRole, String ipAdress, String userLogcomments){
		return offlineAlertsDAO.rejectAlertBenchMarkParameters(alertId, alertSerialNo, paramMap, requestType, benchMarkStatus, userCode, userRole, ipAdress, userLogcomments);
	}
	
	@Override
	public List<String> getAlertSubGroup(String groupId){
		return offlineAlertsDAO.getAlertSubGroup(groupId);
	}
	
	@Override
	public String getAlertGroupName(String groupId){
		return offlineAlertsDAO.getAlertGroupName(groupId);
	}

	@Override
	public boolean saveAlertBenchMarkParamsForSimulation(String alertId, String alertSerialNo, Map<String, String> paramMap, String userCode, 
			String userRole, String ipAddress) {
		return offlineAlertsDAO.saveAlertBenchMarkParamsForSimulation(alertId, alertSerialNo, paramMap, userCode, userRole, ipAddress);
	}

	@Override
	public boolean deleteAlertBenchMarkParamsForSimulation(String alertId, String alertSerialNo, String requestType,
			String userCode, String userRole, String ipAddress, String userLogcomments) {
		System.out.println("to del");
		return offlineAlertsDAO.deleteAlertBenchMarkParamsForSimulation(alertId, alertSerialNo, requestType, userCode, userRole, ipAddress, userLogcomments);
	}

}
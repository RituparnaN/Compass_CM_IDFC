package com.quantumdataengines.app.compass.service.graphicalMasterModule;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.quantumdataengines.app.compass.dao.graphicalMasterModule.GraphicalMasterDAO;

@Service
public class GraphicalMasterServiceImpl implements GraphicalMasterService {
	
	@Autowired
	GraphicalMasterDAO graphicalMasterDAO;
	

	@Override
	public Map<String, Object> getGraphicalMasterData(String userCode,String userRole, String remoteAddr,String moduleType) {
		return graphicalMasterDAO.getGraphicalMasterData(userCode,userRole,remoteAddr,moduleType);
		
	}
	
	


	/*@Override
	public Map<String, Object> getGraphDetails(String columnName,String columnValue, String moduleType,  String userCode, String userRole,String remoteAddr) {
		return graphicalMasterDAO.getGraphDetails(columnName,columnValue,moduleType,userCode,userRole,remoteAddr);
	}*/

	@Override
	public List<Map<String, String>> savingAccGraphicalMaster(String userCode, String userRole,String remoteAddr) {
		return graphicalMasterDAO.savingAccGraphicalMaster(userCode,userRole,remoteAddr);
	}




	@Override
	public Map<String, Object> getAccountMasterDataView1(String userCode,String userRole, String remoteAddr, String moduleType) {
		return graphicalMasterDAO.getAccountMasterDataView1(userCode,userRole,remoteAddr,moduleType);
		
	}




	@Override
	public Map<String, Object> getKeyValueData(String userCode,String userRole, String remoteAddr, String moduleType) {
		
		return graphicalMasterDAO.getKeyValueData(userCode,userRole,remoteAddr,moduleType);
	}




	@Override
	public Map<String, Object> getUserStatsData(String userCode,String userRole, String remoteAddr, String moduleType) {
		return graphicalMasterDAO.getUserStatsData(userCode,userRole,remoteAddr,moduleType);
	}




	@Override
	public Map<String, Object> searchPendingCases(Map<String, String> paramMap, String moduleType, String userCode,String userRole, String ipAddress) {
		return graphicalMasterDAO.searchPendingCases(paramMap, moduleType, userCode, userRole, ipAddress);
		
	}




	@Override
	public Map<String, Object> customerPeerGroup(Map<String, String> paramMap,String moduleType,String userCode, String userRole, String remoteAddr) {
		return graphicalMasterDAO.customerPeerGroup(paramMap, moduleType, userCode, userRole, remoteAddr);
	}




	@Override
	public Map<String, Object> getCustomerPeerGroupDetail(Map<String, String> paramMap, String moduleType, String userCode,String userRole, String ipAdress) {
		
		return graphicalMasterDAO.getCustomerPeerGroupDetail(paramMap, moduleType, userCode, userRole, ipAdress);
	}


	

}

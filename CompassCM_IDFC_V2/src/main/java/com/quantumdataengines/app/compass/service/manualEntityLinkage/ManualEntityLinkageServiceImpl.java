package com.quantumdataengines.app.compass.service.manualEntityLinkage;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.quantumdataengines.app.compass.dao.manualEntityLinkage.ManualEntityLinkageDAO;

@Service
public class ManualEntityLinkageServiceImpl implements ManualEntityLinkageService {
	
	@Autowired
	private ManualEntityLinkageDAO manualEntityLinkageDAO;

	@Override
	public Map<String, String> getEntityRelationTypes(String userCode, String userRole, String ipAddress) {
		return manualEntityLinkageDAO.getEntityRelationTypes( userCode,  userRole,  ipAddress);
	}

	@Override
	public Map<String, List<String>> getCustomerAccountList(String sourceCustomerId, String destinationCustomerId,
			String userCode, String userRole, String ipAddress) {
		
		return manualEntityLinkageDAO.getCustomerAccountList( sourceCustomerId,  destinationCustomerId,userCode,  userRole,  ipAddress);
	}

	@Override
	public String saveEntityLinkage(Map<String, String> entityRelationDetails, String userCode,
			String userRole, String ipAddress) {
		
		return manualEntityLinkageDAO.saveEntityLinkage(entityRelationDetails,userCode,userRole,ipAddress);
	}

}

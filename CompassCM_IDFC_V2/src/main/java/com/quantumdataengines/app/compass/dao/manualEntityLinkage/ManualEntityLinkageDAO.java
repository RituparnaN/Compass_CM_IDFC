package com.quantumdataengines.app.compass.dao.manualEntityLinkage;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface ManualEntityLinkageDAO {

	Map<String, String> getEntityRelationTypes(String userCode, String userRole, String ipAddress);

	Map<String, List<String>> getCustomerAccountList(String sourceCustomerId, String destinationCustomerId,String userCode, String userRole, String ipAddress);

	String saveEntityLinkage(Map<String, String> entityRelationDetails, String userCode, String userRole,
			String ipAddress);

}

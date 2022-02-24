package com.quantumdataengines.app.compass.service.rptWatchList;

import java.util.Map;

public interface RPTWatchListService {
	public String createRPTList(String listCode, String listName, String description, String listType, String userCode);
	public Map<String, String> openRPTWatchListDetails(String listCode, String userCode, String userRole, String ipAddress);
	public Map<String, Object> openRPTWatchListCustomerDetails(String listCode, String entityName, String entityId, String idNo, String entityStatus);
	public Map<String, Object> getRPTAddEntityDetails();
	public String addUpdateEntity(String listCode, String listName, String entityName, String entityId, String idType, String idNo,
			String relatedThrough, String shareHolding, String relation, String subRelation,
			String dropdown1, String dropdown2, String remarks, String status, String authorizer, String userCode);
	public String updateRPTWatchList(String listCode, String listName, String description, String listType, String userCode);
	public String removeDisableRPTWatchList(String entityID, String status, String isEnabled, String userCode);
	public Map<String, Object> getPendingEntityForCheck(String userCode);
	public String approveEntity(String entityId, String remarks);
	public Map<String, String> rejectEntity(String entityId, String remarks);
	public String toggleStatusUponRejection(String ENTITYID, String STATUS);
}

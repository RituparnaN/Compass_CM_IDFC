package com.quantumdataengines.app.compass.service.rptWatchList;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.quantumdataengines.app.compass.dao.rptWatchList.RPTWatchListDAO;

@Service
public class RPTWatchListServiceImpl implements RPTWatchListService{

	@Autowired
	private RPTWatchListDAO rptWatchListDAO;
	
	@Override
	public String createRPTList(String listCode, String listName, String description, String listType, String userCode) {
		return rptWatchListDAO.createRPTList(listCode, listName, description, listType, userCode);
	}

	@Override
	public Map<String, String> openRPTWatchListDetails(String listCode, String userCode, String userRole, String ipAddress) {
		return rptWatchListDAO.openRPTWatchListDetails(listCode, userCode, userRole, ipAddress);
	}

	@Override
	public Map<String, Object> openRPTWatchListCustomerDetails(String listCode, String entityName, String entityId, String idNo, String entityStatus) {
		return rptWatchListDAO.openRPTWatchListCustomerDetails(listCode, entityName, entityId, idNo, entityStatus);
	}

	@Override
	public Map<String, Object> getRPTAddEntityDetails() {
		return rptWatchListDAO.getRPTAddEntityDetails();
	}

	@Override
	public String addUpdateEntity(String listCode, String listName,
			String entityName, String entityId, String idType, String idNo,
			String relatedThrough, String shareHolding, String relation,
			String subRelation, String dropdown1, String dropdown2,
			String remarks, String status, String authorizer, String userCode) {
		return rptWatchListDAO.addUpdateEntity(listCode, listName, entityName, entityId, 
				idType, idNo, relatedThrough, shareHolding, relation, subRelation, dropdown1, 
				dropdown2, remarks, status, authorizer, userCode);
	}

	@Override
	public String updateRPTWatchList(String listCode, String listName, String description, String listType, String userCode) {
		return rptWatchListDAO.updateRPTWatchList(listCode, listName, description, listType, userCode);
	}

	@Override
	public String removeDisableRPTWatchList(String entityID, String status, String isEnabled, String userCode) {
		return rptWatchListDAO.removeDisableRPTWatchList(entityID, status, isEnabled, userCode);
	}

	@Override
	public Map<String, Object> getPendingEntityForCheck(String userCode) {
		return rptWatchListDAO.getPendingEntityForCheck(userCode);
	}

	@Override
	public String approveEntity(String entityId, String remarks) {
		return rptWatchListDAO.approveEntity(entityId, remarks);
	}

	@Override
	public Map<String, String> rejectEntity(String entityId, String remarks) {
		return rptWatchListDAO.rejectEntity(entityId, remarks);
	}
	
	@Override
	public String toggleStatusUponRejection(String ENTITYID, String STATUS){
		return rptWatchListDAO.toggleStatusUponRejection(ENTITYID, STATUS);
	}
}

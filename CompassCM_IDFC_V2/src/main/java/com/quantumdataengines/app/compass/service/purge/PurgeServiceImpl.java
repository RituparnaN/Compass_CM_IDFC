package com.quantumdataengines.app.compass.service.purge;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.quantumdataengines.app.compass.dao.purge.PurgeDAO;

@Service
public class PurgeServiceImpl implements PurgeService{

	@Autowired
	private PurgeDAO purgeDAO;

	@Override
	public String purgeUpdate(String month, String year, String table,
			String actionType, String currentUser, String currentRole,
			String ipAddress) {
		return purgeDAO.purgeUpdate(month, year, table, actionType, currentUser, currentRole, ipAddress);
	}
	
}

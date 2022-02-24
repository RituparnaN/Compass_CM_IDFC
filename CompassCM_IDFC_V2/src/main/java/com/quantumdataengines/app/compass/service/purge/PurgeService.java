package com.quantumdataengines.app.compass.service.purge;

public interface PurgeService {

	String purgeUpdate(String month, String year, String table,
			String actionType, String currentUser, String currentRole,
			String ipAddress);
	
}

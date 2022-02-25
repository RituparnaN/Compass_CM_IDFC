package com.quantumdataengines.app.compass.dao.purge;

public interface PurgeDAO {

	String purgeUpdate(String month, String year, String table,
			String actionType, String currentUser, String currentRole,
			String ipAddress);
	
}

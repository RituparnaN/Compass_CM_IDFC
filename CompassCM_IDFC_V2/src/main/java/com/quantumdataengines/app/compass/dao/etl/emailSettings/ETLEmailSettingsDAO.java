package com.quantumdataengines.app.compass.dao.etl.emailSettings;

import java.util.Map;

import com.quantumdataengines.app.compass.schema.Configuration;

public interface ETLEmailSettingsDAO {
	public Map<String, String> getEmailSettings(Configuration configuration);
	public String saveEmailSettings(Map<String, String> emailSettings);
}

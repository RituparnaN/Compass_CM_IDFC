package com.quantumdataengines.app.compass.service.etl.emailsettings;

import java.util.Map;

import com.quantumdataengines.app.compass.schema.EtlEmail;

public interface ETLEmailSettingService {
	public EtlEmail getETLEmailDetails();
	public Map<String, String> getEmailSettings();
	public String saveEmailSettings(Map<String, String> emailSettings);
	public String sendETLTestEmail(String password);
}

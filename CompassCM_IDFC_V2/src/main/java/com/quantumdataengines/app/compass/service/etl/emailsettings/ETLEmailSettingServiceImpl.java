package com.quantumdataengines.app.compass.service.etl.emailsettings;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.quantumdataengines.app.compass.dao.etl.emailSettings.ETLEmailSettingsDAO;
import com.quantumdataengines.app.compass.schema.Configuration;
import com.quantumdataengines.app.compass.schema.EtlEmail;
import com.quantumdataengines.app.compass.util.EmailSenderUtil;
import com.quantumdataengines.app.compass.util.UserContextHolder;

@Service
public class ETLEmailSettingServiceImpl implements ETLEmailSettingService{

	@Autowired
	private ETLEmailSettingsDAO eTLEmailSettingDAO;
	@Autowired
	private EmailSenderUtil emailSenderUtil;
	
	@Override
	public EtlEmail getETLEmailDetails() {
		Configuration configuration = UserContextHolder.getUserContext();
		return configuration.getEmail().getEtlEmail();
	}

	@Override
	public Map<String, String> getEmailSettings() {
		Configuration configuration = UserContextHolder.getUserContext();
		Map<String, String> etlEmailDetails = eTLEmailSettingDAO.getEmailSettings(configuration);
		etlEmailDetails.put("AUTHID", configuration.getEmail().getEtlEmail().getEtlAuthId().getValue());
		etlEmailDetails.put("FROMID", configuration.getEmail().getEtlEmail().getEtlEmailId().getValue());
		return etlEmailDetails;
	}

	@Override
	public String saveEmailSettings(Map<String, String> emailSettings) {
		return eTLEmailSettingDAO.saveEmailSettings(emailSettings);
	}

	@Override
	public String sendETLTestEmail(String password) {
		String message = "";
		String emailPassword = "";
		Configuration configuration = UserContextHolder.getUserContext();
		Map<String, String> etlEmailDetails = eTLEmailSettingDAO.getEmailSettings(configuration);
		if(!"".equals(password)){
			emailPassword = password.replace(" ", "+");
		}else{
			emailPassword = etlEmailDetails.get("ETLEMAILPASSWORD");
		}
		try{
			String subject = "CompassETL email testing";
			String content = "Hello,<br/>This email has been sent from Compass application to test email setting configuration.<br/><br/>Thank you,<br/>CompassETL";
			emailSenderUtil.sendEmail(configuration, emailPassword, true, true, null, null, null, null, subject, content);
			message = "Email sent";
		}catch(Exception e){
			message = "Error while sending email "+e.getMessage();
			e.printStackTrace();
		}
		return message;
	}

}

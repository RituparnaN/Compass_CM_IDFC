package com.quantumdataengines.app.compass.service.admin;

import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.plivo.helper.api.client.RestAPI;
import com.plivo.helper.api.response.call.CDR;
import com.plivo.helper.api.response.message.Message;
import com.plivo.helper.exception.PlivoException;
import com.quantumdataengines.app.compass.dao.admin.AdminDAO;

@Service
public class AdminServiceImpl implements AdminService{
private static final Logger log = LoggerFactory.getLogger(AdminServiceImpl.class);
	
	@Autowired
	private AdminDAO adminDAO;
	
	@Override
	public String saveSystemParameters(Map<String, String> systemParametersMap){
		log.info("Saving system parameters...");
		return adminDAO.saveSystemParameters(systemParametersMap);	
	}

	@Override
	public Map<String, String> getPlivoSettings() {
		return adminDAO.getPlivoSettings();
	}

	@Override
	public String updatePlivoSettings(String authId, String authToken,
			String sourceNo, String destNo) {
		return adminDAO.updatePlivoSettings(authId, authToken, sourceNo, destNo);
	}
	
	@Override
	public void savePlivoMessage(String messageId, String authId, String authToken, String userCode, String messageType){
		Map<String, String> messageDetails = null;
		if(messageType.contains("SMS")){
			messageDetails = getPlivoSMSStatus(messageId, authId, authToken);
		}else{
			messageDetails = getPlivoCallStatus(messageId, authId, authToken);
		}
		adminDAO.savePlivoMessage(messageDetails, userCode);
	}
	
	public Map<String, String> getPlivoSMSStatus(String messageId, String authId, String authToken){
		Map<String, String> messageDetails = new HashMap<String, String>();
		RestAPI api = new RestAPI(authId, authToken, "v1");
		LinkedHashMap<String, String> parameters = new LinkedHashMap<String, String>();
		parameters.put("record_id", messageId);
		try {
			Message msg = api.getMessage(parameters);
			messageDetails.put("SENDERNUMBER", msg.fromNumber);
			messageDetails.put("RECIPIENTNUMBER", msg.toNumber);
			messageDetails.put("MESSAGEID", msg.messageUUID);
			messageDetails.put("MESSAGESTATE", msg.messageState);
			messageDetails.put("TOTALAMOUNT", msg.totalAmount);
			messageDetails.put("MESSAGETIME", msg.messageTime);
			messageDetails.put("MESSAGETYPE", "SMS");
			messageDetails.put("UNIT", msg.units != null ?  msg.units.toString() : "");
			messageDetails.put("ERRORS", msg.error);
		} catch (PlivoException e) {
			System.out.println(e.getLocalizedMessage());
		}
		return messageDetails;
	}
	
	public Map<String, String> getPlivoCallStatus(String callId, String authId, String authToken){
		Map<String, String> messageDetails = new HashMap<String, String>();
		RestAPI api = new RestAPI(authId, authToken, "v1");
		LinkedHashMap<String, String> parameters = new LinkedHashMap<String, String>();
		parameters.put("record_id", callId);
		try {
			CDR cdr = api.getCDR(parameters);
			messageDetails.put("SENDERNUMBER", cdr.fromNumber);
			messageDetails.put("RECIPIENTNUMBER", cdr.toNumber);
			messageDetails.put("MESSAGEID", cdr.callUUID);
			messageDetails.put("MESSAGESTATE", cdr.serverCode != null ? cdr.serverCode.toString() : "");
			messageDetails.put("TOTALAMOUNT", cdr.totalRate);
			messageDetails.put("MESSAGETIME", cdr.endTime);
			messageDetails.put("MESSAGETYPE", "CALL");
			messageDetails.put("UNIT", cdr.callDuration != null ? cdr.callDuration.toString() : "");
			messageDetails.put("ERRORS", cdr.error);
		} catch (PlivoException e) {
			System.out.println(e.getLocalizedMessage());
		}
		return messageDetails;
	}
}

package com.quantumdataengines.app.compass.util.fatca;

import java.text.SimpleDateFormat;
import java.util.Date;

public class FATCAMessage {
	private String timestamp;
	private String message;
	
	private String dateToString(Date date){
		SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss.SSS");
		return sdf.format(date);
	}
	
	@SuppressWarnings("unused")
	private FATCAMessage(){}
	
	public FATCAMessage(Date timestamp, String message) {
		this.timestamp = dateToString(timestamp);
		this.message = message;
	}
	
	public String getTimestamp() {
		return timestamp;
	}
	public String getMessage() {
		return message;
	}
}

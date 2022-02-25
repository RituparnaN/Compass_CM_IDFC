package com.quantumdataengines.app.compass.model;

public class ExtractionDBMessage {
	private int rowNum;
	private String dateTime;
	private String processName;
	private String statusMessage;
	
	public ExtractionDBMessage(int rowNum, String dateTime, String processName, String statusMessage) {
		this.rowNum = rowNum;
		this.dateTime = dateTime;
		this.processName = processName;
		this.statusMessage = statusMessage;
	}
	
	public int getRowNum() {
		return rowNum;
	}
	public void setRowNum(int rowNum) {
		this.rowNum = rowNum;
	}
	public String getDateTime() {
		return dateTime;
	}
	public void setDateTime(String dateTime) {
		this.dateTime = dateTime;
	}
	public String getProcessName() {
		return processName;
	}
	public void setProcessName(String processName) {
		this.processName = processName;
	}
	public String getStatusMessage() {
		return statusMessage;
	}
	public void setStatusMessage(String statusMessage) {
		this.statusMessage = statusMessage;
	}
}

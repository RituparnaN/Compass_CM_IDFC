package com.quantumdataengines.app.compass.util.fatca;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Date;

public class FATCAFileGeneration {
	private int status;
	private int progressStatus;
	private String startDate;
	private String endDate;
	private String generatedBy;
	private String message;
	private String caseFolderPath;
	private String fatcaPackageFolder;
	private File originalXMLFile;
	private boolean isOriginalFileValid;
	private File uploadedXMLFile;
	private boolean isUploadedFileValid;
	private File xmlFileToProcess;
	private File signedXMLFile;
	private File generatedZipFile;
	private File IRSNotificationFile;
	private String IRSNotificationFolder;
	private File IRSPayloadFile;
	private File IRSMetadataFile;
	private boolean isPlayloadRead;
	private File IRSPayloadReadFile;
	private Class IRSNotificationType;
	
	private String dateToString(Date date){
		SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss.SSS");
		return date != null ? sdf.format(date) : null;
	}
	
	public int getStatus() {
		return status;
	}
	public void setStatus(int status) {
		this.status = status;
	}
	public String getStartDate() {
		return startDate;
	}
	public void setStartDate(Date startDate) {
		this.startDate = dateToString(startDate);
	}
	public String getEndDate() {
		return endDate;
	}
	public void setEndDate(Date endDate) {
		this.endDate = dateToString(endDate);
	}
	public String getGeneratedBy() {
		return generatedBy;
	}
	public void setGeneratedBy(String generatedBy) {
		this.generatedBy = generatedBy;
	}

	public String getCaseFolderPath() {
		return caseFolderPath;
	}
	public void setCaseFolderPath(String caseFolderPath) {
		this.caseFolderPath = caseFolderPath;
	}

	public int getProgressStatus() {
		return progressStatus;
	}

	public void setProgressStatus(int progressStatus) {
		this.progressStatus = progressStatus;
	}

	public File getOriginalXMLFile() {
		return originalXMLFile;
	}

	public void setOriginalXMLFile(File originalXMLFile) {
		this.originalXMLFile = originalXMLFile;
	}

	public File getUploadedXMLFile() {
		return uploadedXMLFile;
	}

	public void setUploadedXMLFile(File uploadedXMLFile) {
		this.uploadedXMLFile = uploadedXMLFile;
	}

	public File getGeneratedZipFile() {
		return generatedZipFile;
	}

	public void setGeneratedZipFile(File generatedZipFile) {
		this.generatedZipFile = generatedZipFile;
	}

	public File getIRSNotificationFile() {
		return IRSNotificationFile;
	}

	public void setIRSNotificationFile(File iRSNotificationFile) {
		IRSNotificationFile = iRSNotificationFile;
	}

	public boolean isOriginalFileValid() {
		return isOriginalFileValid;
	}

	public void setOriginalFileValid(boolean isOriginalFileValid) {
		this.isOriginalFileValid = isOriginalFileValid;
	}

	public boolean isUploadedFileValid() {
		return isUploadedFileValid;
	}

	public void setUploadedFileValid(boolean isUploadedFileValid) {
		this.isUploadedFileValid = isUploadedFileValid;
	}

	public File getXmlFileToProcess() {
		return xmlFileToProcess;
	}

	public void setXmlFileToProcess(File xmlFileToProcess) {
		this.xmlFileToProcess = xmlFileToProcess;
	}

	public File getSignedXMLFile() {
		return signedXMLFile;
	}

	public void setSignedXMLFile(File signedXMLFile) {
		this.signedXMLFile = signedXMLFile;
	}

	public String getFatcaPackageFolder() {
		return fatcaPackageFolder;
	}

	public void setFatcaPackageFolder(String fatcaPackageFolder) {
		this.fatcaPackageFolder = fatcaPackageFolder;
	}

	public String getIRSNotificationFolder() {
		return IRSNotificationFolder;
	}

	public void setIRSNotificationFolder(String iRSNotificationFolder) {
		IRSNotificationFolder = iRSNotificationFolder;
	}

	public File getIRSPayloadFile() {
		return IRSPayloadFile;
	}

	public void setIRSPayloadFile(File iRSPayloadFile) {
		IRSPayloadFile = iRSPayloadFile;
	}

	public File getIRSMetadataFile() {
		return IRSMetadataFile;
	}

	public void setIRSMetadataFile(File iRSMetadataFile) {
		IRSMetadataFile = iRSMetadataFile;
	}

	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
	}

	public File getIRSPayloadReadFile() {
		return IRSPayloadReadFile;
	}
	
	public void setIRSPayloadReadFile(File iRSPayloadReadFile) {
		IRSPayloadReadFile = iRSPayloadReadFile;
	}

	public Class getIRSNotificationType() {
		return IRSNotificationType;
	}

	public void setIRSNotificationType(Class iRSNotificationType) {
		IRSNotificationType = iRSNotificationType;
	}

	public boolean isPlayloadRead() {
		return isPlayloadRead;
	}

	public void setPlayloadRead(boolean isPlayloadRead) {
		this.isPlayloadRead = isPlayloadRead;
	}
}

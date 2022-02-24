package com.quantumdataengines.app.compass.model.scanning;

public class MatchVO {
	
	private String userCode=null;
	private String recordStatus=null;
	private String scanningFromDate=null ;
	private String scanningToDate=null ;
	private String processingFromDate=null ;
	private String processingToDate=null ;
	private String fileName=null ;
	private String fileImport=null;
	private String counter=null;
	private String loggedUser=null;
	private String uniqueId=null;
	private String action=null;
    private String alertNo=null;
    private String amlco=null;
    private String comments=null;

	public MatchVO()
	{
	}

	public void setComments( java.lang.String comments )
	{
	    this.comments = comments;
	}

	public java.lang.String getComments( )
	{
	    return comments;
	}

	public void setAmlco( java.lang.String amlco )
	{
	    this.amlco = amlco;
	}

	public java.lang.String getAmlco( )
	{
	    return amlco;
	}

	public void setAlertNo( java.lang.String alertNo )
	{
	    this.alertNo = alertNo;
	}

	public java.lang.String getAlertNo( )
	{
	    return alertNo;
	}

	public void setAction( java.lang.String action )
	{
		this.action = action;
	}

	public java.lang.String getAction( )
	{
		return action;
	}

	public void setUserCode( java.lang.String userCode )
	{
		this.userCode = userCode;
	}

	public java.lang.String getUserCode( )
	{
		return userCode;
	}

	public void setUniqueId( java.lang.String uniqueId )
	{
		this.uniqueId = uniqueId;
	}

	public java.lang.String getUniqueId( )
	{
		return uniqueId;
	}

	public void setScanningToDate( java.lang.String scanningToDate )
	{
		this.scanningToDate = scanningToDate;
	}

	public java.lang.String getScanningToDate( )
	{
		return scanningToDate;
	}

	public void setScanningFromDate( java.lang.String scanningFromDate )
	{
		this.scanningFromDate = scanningFromDate;
	}

	public java.lang.String getScanningFromDate( )
	{
		return scanningFromDate;
	}

	public void setRecordStatus( java.lang.String recordStatus )
	{
		this.recordStatus = recordStatus;
	}

	public java.lang.String getRecordStatus( )
	{
		return recordStatus;
	}

	public void setProcessingToDate( java.lang.String processingToDate )
	{
		this.processingToDate = processingToDate;
	}

	public java.lang.String getProcessingToDate( )
	{
		return processingToDate;
	}

	public void setProcessingFromDate( java.lang.String processingFromDate )
	{
		this.processingFromDate = processingFromDate;
	}

	public java.lang.String getProcessingFromDate( )
	{
		return processingFromDate;
	}

	public void setLoggedUser( java.lang.String loggedUser )
	{
		this.loggedUser = loggedUser;
	}

	public java.lang.String getLoggedUser( )
	{
		return loggedUser;
	}

	public void setFileName( java.lang.String fileName )
	{
		this.fileName = fileName;
	}

	public java.lang.String getFileName( )
	{
		return fileName;
	}

	public void setFileImport( java.lang.String fileImport )
	{
		this.fileImport = fileImport;
	}

	public java.lang.String getFileImport( )
	{
		return fileImport;
	}

	public void setCounter( java.lang.String counter )
	{
		this.counter = counter;
	}
	public java.lang.String getCounter( )
	{
		return counter;
	}
}

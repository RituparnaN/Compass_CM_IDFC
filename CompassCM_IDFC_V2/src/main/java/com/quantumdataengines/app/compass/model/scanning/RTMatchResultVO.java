package com.quantumdataengines.app.compass.model.scanning;

public class RTMatchResultVO  implements java.io.Serializable
{
	/**
	 * 
	 */
	private static final long serialVersionUID = 5713199060341743338L;
	private String sourceInfo=null;
	private String uniqueNumber=null;
	private String listName=null ;
	private String listId=null ;
	private String rank=null ;
	private String matchedInfo=null ;
	private String matchDate=null ;
	private String status=null;
	private String comments=null;
	private String serialNo1=null;
	private String customerName=null;
	private String userComments=null;
	
	public RTMatchResultVO()
	{
	}

	public String getSourceInfo() {
		return sourceInfo;
	}

	public void setSourceInfo(String sourceInfo) {
		this.sourceInfo = sourceInfo;
	}

	public String getUniqueNumber() {
		return uniqueNumber;
	}

	public void setUniqueNumber(String uniqueNumber) {
		this.uniqueNumber = uniqueNumber;
	}

	public String getListName() {
		return listName;
	}

	public void setListName(String listName) {
		this.listName = listName;
	}

	public String getListId() {
		return listId;
	}

	public void setListId(String listId) {
		this.listId = listId;
	}

	public String getRank() {
		return rank;
	}

	public void setRank(String rank) {
		this.rank = rank;
	}

	public String getMatchedInfo() {
		return matchedInfo;
	}

	public void setMatchedInfo(String matchedInfo) {
		this.matchedInfo = matchedInfo;
	}

	public String getMatchDate() {
		return matchDate;
	}

	public void setMatchDate(String matchDate) {
		this.matchDate = matchDate;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getComments() {
		return comments;
	}

	public void setComments(String comments) {
		this.comments = comments;
	}

	public String getSerialNo1() {
		return serialNo1;
	}

	public void setSerialNo1(String serialNo1) {
		this.serialNo1 = serialNo1;
	}

	public String getCustomerName() {
		return customerName;
	}

	public void setCustomerName(String customerName) {
		this.customerName = customerName;
	}

	public String getUserComments() {
		return userComments;
	}

	public void setUserComments(String userComments) {
		this.userComments = userComments;
	}
	
}

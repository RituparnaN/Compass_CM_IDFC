package com.quantumdataengines.app.compass.model;

public class ExtractionProcedure {
	private int groupId;
	private int procedureNumber;
	private String procedureName;
	private boolean inParallel;
	private boolean isEnable;
	
	public ExtractionProcedure(int groupId, int procedureNumber, String procedureName, boolean inParallel, boolean isEnable) {
		this.groupId = groupId;
		this.procedureNumber = procedureNumber;
		this.procedureName = procedureName;
		this.inParallel = inParallel;
		this.isEnable = isEnable;
	}
	
	public int getGroupId() {
		return groupId;
	}
	public void setGroupId(int groupId) {
		this.groupId = groupId;
	}
	public int getProcedureNumber() {
		return procedureNumber;
	}
	public void setProcedureNumber(int procedureNumber) {
		this.procedureNumber = procedureNumber;
	}
	public String getProcedureName() {
		return procedureName;
	}
	public void setProcedureName(String procedureName) {
		this.procedureName = procedureName;
	}
	public boolean isInParallel() {
		return inParallel;
	}
	public void setInParallel(boolean inParallel) {
		this.inParallel = inParallel;
	}
	public boolean isEnable() {
		return isEnable;
	}
	public void setEnable(boolean isEnable) {
		this.isEnable = isEnable;
	}
	
	
}

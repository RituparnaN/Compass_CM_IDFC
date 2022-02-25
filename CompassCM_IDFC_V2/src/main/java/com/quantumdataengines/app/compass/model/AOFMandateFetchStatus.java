package com.quantumdataengines.app.compass.model;

import java.util.Date;
import java.util.LinkedList;
import java.util.List;

public class AOFMandateFetchStatus {
	private static AOFMandateFetchStatus aofMandateFetchStatus = new AOFMandateFetchStatus();;
	private static List<String> directoryPathStack;
	private int status = 0;
	private int count = 0;
	private int pathCount = 0;
	private Date startDate;
	private Date endDate;
	private Thread thread;
	
	private AOFMandateFetchStatus(){}
	
	public static AOFMandateFetchStatus newInstance(){		
		directoryPathStack = new LinkedList<String>();
		return aofMandateFetchStatus;
	}
	
	public void setStatusRunning(){
		status = 1;
	}
	
	public void setStatusCompleted(){
		status = 2;
	}
	
	public int getStatus(){
		return status;
	}
	
	public static AOFMandateFetchStatus getInstance(){
		return aofMandateFetchStatus;
	}
	
	public void setNewPath(String path){
		directoryPathStack.add(path);
		pathCount = directoryPathStack.size();
	}
	
	public String getNextPath(){
		if(directoryPathStack.size() > 0)
			return directoryPathStack.get(0);
		else
			return null;
	}
	
	public void removePath(String path){
		directoryPathStack.remove(path);
		pathCount = directoryPathStack.size();
	}

	public int getCount() {
		return count;
	}
	
	public int getPathCount() {
		return pathCount;
	}

	public void setCount(int completed) {
		count = completed;
	}

	public Thread getThread() {
		return thread;
	}

	public void setThread(Thread thread) {
		this.thread = thread;
	}

	public Date getStartDate() {
		return startDate;
	}

	public void setStartDate(Date startDate) {
		this.startDate = startDate;
	}

	public Date getEndDate() {
		return endDate;
	}

	public void setEndDate(Date endDate) {
		this.endDate = endDate;
	}
}

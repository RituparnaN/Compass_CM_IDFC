package com.quantumdataengines.app.compass.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.IOUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.util.HtmlUtils;

import com.quantumdataengines.app.compass.model.ChatMessage;
import com.quantumdataengines.app.compass.model.DomainUser;
import com.quantumdataengines.app.compass.model.EmailRefresh;
import com.quantumdataengines.app.compass.model.Extraction;
import com.quantumdataengines.app.compass.otherservice.OtherCommonService;
import com.quantumdataengines.app.compass.service.CommonService;
import com.quantumdataengines.app.compass.util.ChatMessageHolder;
import com.quantumdataengines.app.compass.util.CommonUtil;
import com.quantumdataengines.app.compass.util.CompassFileUtils;
import com.quantumdataengines.app.compass.util.EmailRefreshUtil;

@Controller
@RequestMapping(value="/common")
public class CommonController {
	
	@Autowired
	private EmailRefreshUtil emailRefreshUtil;
	@Autowired
	private CommonService commonService;
	@Autowired
	private OtherCommonService otherCommonService;
	@Autowired 
	private CompassFileUtils compassFileUtils;
	
	private static final Logger log = LoggerFactory.getLogger(CommonController.class);
	
	@RequestMapping(value="/processTaskStatus", method=RequestMethod.POST)
	public @ResponseBody Map<String, Map<String, String>> processTaskStatus(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		Map<String, Map<String, String>> mainMap = new HashMap<String, Map<String,String>>();
		
		Map<String, String> dataMap = new HashMap<String, String>();
		String instituteName = (String) request.getSession(false).getAttribute("instituteName");
		if(instituteName == null){
			dataMap.put("RELOAD", "0");
			mainMap.put("RELOAD", dataMap);
		}else{
			dataMap.put("RELOAD", "1");
			mainMap.put("RELOAD", dataMap);
			
			dataMap = new HashMap<String, String>();
			Map<String, String> systemParameters = commonService.initilizingDBSystemParameters();
			EmailRefresh emailRefresh = emailRefreshUtil.getEmailRefreshDetails().get(instituteName);
			if(systemParameters.get("EMAILAUTOREFRESH").equals("N")){
				dataMap.put("process", "Email auto refresh is turned off<br/><br/><center>"+
						"<button type=\"button\" class=\"btn btn-xs btn-primary\" onclick=\"navigate('Email Refresh Log','emailRefreshLog','common/emailRefreshLog','1')\">View Log</button>&nbsp;&nbsp;&nbsp;"+
						"<button type=\"button\" class=\"btn btn-xs btn-success\" onclick=\"refreshEmail(this)\">Refresh Now</button>"+
						"</center>");
				dataMap.put("percentage", "");
			}else{
				if(emailRefresh == null || emailRefresh.getStatus() != 1){
					String lastEmailRefreshDate = commonService.lastEmailRefresgLog();
					if("".equals(lastEmailRefreshDate)){
						dataMap.put("process", "System will automatically synchronize email server in next batch task execution<br/><br/><center>"+
						"<button type=\"button\" class=\"btn btn-xs btn-primary\" onclick=\"navigate('Email Refresh Log','emailRefreshLog','common/emailRefreshLog','1')\">View Log</button>&nbsp;&nbsp;&nbsp;"+
						"<button type=\"button\" class=\"btn btn-xs btn-success\" onclick=\"refreshEmail(this)\">Refresh Now</button>"+
						"</center>");
						dataMap.put("percentage", "");
					}else{
						dataMap.put("process", "<em style=\"font-size: 12px\">"+lastEmailRefreshDate+"</em><br/><center>"+
								"<button type=\"button\" class=\"btn btn-xs btn-primary\" onclick=\"navigate('Email Refresh Log','emailRefreshLog','common/emailRefreshLog','1')\">View Log</button>&nbsp;&nbsp;&nbsp;"+
								"<button type=\"button\" class=\"btn btn-xs btn-success\" onclick=\"refreshEmail(this)\">Refresh Now</button>"+
								"</center>");
						dataMap.put("percentage", "");
					}
				}else{
					dataMap.put("percentage", new Integer(emailRefresh.getPercentage()).toString()+"% completed");
					dataMap.put("process", "<span>Started : "+emailRefresh.getStartTime()+"<br/>Folder : "+emailRefresh.getFolder()+"("+emailRefresh.getNoOfComplete()+"/"+emailRefresh.getNoOfEmailFound()+")</span>"+
										   "<br/><div class=\"progress progress-striped active\">"+
										   "<div class=\"progress-bar progress-bar-primary\" role=\"progressbar\""+
										   "aria-valuenow=\""+emailRefresh.getPercentage()+"\" aria-valuemin=\"0\" aria-valuemax=\"100\""+
										   "style=\"width: "+emailRefresh.getPercentage()+"%\"><span class=\"sr-only\">"+emailRefresh.getPercentage()+"% Complete</span></div></div>"+
										   "<span>"+emailRefresh.getStatusMessage()+"</span>");
				}
			}
			mainMap.put("EMAILREFRESH", dataMap);
			
			Extraction extraction = commonService.getExtractionStatus();
			dataMap = new HashMap<String, String>();
			if(extraction != null){
				if(extraction.getStatus() == 1){
					dataMap.put("percentage", new Integer(extraction.getPercentage()).toString()+"% completed");
					dataMap.put("process", "<span>Process Date : <em style=\"font-size: 12px\">"+extraction.getStrProcessStartDate()+"</em>"+
										   "<br/>Started : <em style=\"font-size: 12px\">"+extraction.getStrStartDate()+"</em>"+
										   "<br/>"+extraction.getTimeMessage()+" : <em style=\"font-size: 12px\">"+extraction.getTimeValue()+"</em></span>"+
										   "<br/><div class=\"progress progress-striped active\">"+
										   "<div class=\"progress-bar progress-bar-success\" role=\"progressbar\""+
										   "aria-valuenow=\""+extraction.getPercentage()+"\" aria-valuemin=\"0\" aria-valuemax=\"100\""+
										   "style=\"width: "+extraction.getPercentage()+"%\"><span class=\"sr-only\">"+extraction.getPercentage()+"% Complete</span></div></div>"+
										   "<span><em style=\"font-size: 12px\">"+extraction.getLastMessage()+"</em></span>");
				}else{
					dataMap.put("percentage", "");
					dataMap.put("process", "Process Date : <em style=\"font-size: 12px\">"+extraction.getStrProcessStartDate()+"</em>"+
										   "<br/>Started : <em style=\"font-size: 12px\">"+extraction.getStrStartDate()+"</em>"+
										   "<br/>"+extraction.getStrEndDateMessage()+" : <em style=\"font-size: 12px\">"+extraction.getStrEndDateValue()+"</em>"+
										   "<br/>"+extraction.getTimeMessage()+" : <em style=\"font-size: 12px\">"+extraction.getTimeValue()+"</em></span>");
					
				}
			}else{
				dataMap.put("percentage", "");
				dataMap.put("process", "Extraction process is not yet started");
			}
			mainMap.put("EXTRACTIONDETAILS", dataMap);
			
			List<Map<String, String>> emailNotification = commonService.getEmailNotification(authentication.getPrincipal().toString(), "N");
			dataMap = new HashMap<String, String>();
			dataMap.put("emailCount", new Integer(emailNotification.size()).toString());
			int count = 1;
			int seenEmailCount = 0;
			String emailString = "";
			if(emailNotification.size() < 3){
				seenEmailCount = 3 - emailNotification.size();
			}
			
			for(int index = 0; count <= 3 && index < emailNotification.size(); count++){
				Map<String, String> emailDetails = emailNotification.get(index);
				emailString = emailString+ "<li onclick='compassEmailExchange.openEmail(\""+request.getContextPath()+"\",\""+emailDetails.get("CASENO")+"\", \""+emailDetails.get("MESSAGEINTERNALNO")+"\", \""+emailDetails.get("FOLDERTYPE")+"\")'>"+
										   "<a href='javascript:void(0)'><div><strong>"+emailDetails.get("SENDERID")+"</strong>"+
							  			   "<span class='pull-right text-muted'><em style='font-size:10px'>"+emailDetails.get("UPDATETIMESTAMP")+"</em></span></div>"+
										   "<div>"+emailDetails.get("SUBJECT")+"</div>"+
										   "</a></li><li class='divider'></li>";
				index++;
			}
			if(seenEmailCount > 0){
				emailNotification = commonService.getEmailNotification(authentication.getPrincipal().toString(), "Y");
				for(int x = 0; count <= 3 && x < emailNotification.size(); count++){
					Map<String, String> emailDetails = emailNotification.get(x);
					emailString = emailString+ "<li onclick='compassEmailExchange.openEmail(\""+request.getContextPath()+"\",\""+emailDetails.get("CASENO")+"\", \""+emailDetails.get("MESSAGEINTERNALNO")+"\", \""+emailDetails.get("FOLDERTYPE")+"\")'>"+
											   "<a href='javascript:void(0)'><div>"+emailDetails.get("SENDERID")+""+
								  			   "<span class='pull-right text-muted'><em style='font-size:10px'>"+emailDetails.get("UPDATETIMESTAMP")+"</em></span></div>"+
											   "<div>"+emailDetails.get("SUBJECT")+"</div>"+
											   "</a></li><li class='divider'></li>";
					x++;
				}
			}
			dataMap.put("emailString", emailString);
			mainMap.put("EMAILNOTIFICATION", dataMap);
		}
		commonService.auditLog(authentication.getPrincipal().toString(), request, "COMMON", "SEARCH", "Module Accessed");
		return mainMap;
	}
	
	@RequestMapping(value="/processTaskStatusNew", method=RequestMethod.POST)
	public @ResponseBody Map<String, Map<String, String>> processTaskStatusNew(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		Map<String, Map<String, String>> mainMap = new HashMap<String, Map<String,String>>();
		
		Map<String, String> dataMap = new HashMap<String, String>();
		String instituteName = (String) request.getSession(false).getAttribute("instituteName");
		//System.out.println("instituteName = "+instituteName);
		if(instituteName == null){
			dataMap.put("RELOAD", "0");
			mainMap.put("RELOAD", dataMap);
		}else{
			dataMap.put("RELOAD", "1");
			mainMap.put("RELOAD", dataMap);
			
			dataMap = new HashMap<String, String>();
			Map<String, String> systemParameters = commonService.initilizingDBSystemParameters();
			EmailRefresh emailRefresh = emailRefreshUtil.getEmailRefreshDetails().get(instituteName);
			if(systemParameters.get("EMAILAUTOREFRESH").equals("N")){
				dataMap.put("process", "Email auto refresh is turned off<br/><br/><center>"+
						"<button type=\"button\" class=\"btn btn-xs btn-primary\" onclick=\"navigate('Email Refresh Log','emailRefreshLog','common/emailRefreshLog','1')\">View Log</button>&nbsp;&nbsp;&nbsp;"+
						"<button type=\"button\" class=\"btn btn-xs btn-success\" onclick=\"refreshEmail(this)\">Refresh Now</button>"+
						"</center>");
				dataMap.put("percentage", "");
			}else{
				if(emailRefresh == null || emailRefresh.getStatus() != 1){
					String lastEmailRefreshDate = commonService.lastEmailRefresgLog();
					if("".equals(lastEmailRefreshDate)){
						dataMap.put("process", "System will automatically synchronize email server in next batch task execution<br/><br/><center>"+
						"<button type=\"button\" class=\"btn btn-xs btn-primary\" onclick=\"navigate('Email Refresh Log','emailRefreshLog','common/emailRefreshLog','1')\">View Log</button>&nbsp;&nbsp;&nbsp;"+
						"<button type=\"button\" class=\"btn btn-xs btn-success\" onclick=\"refreshEmail(this)\">Refresh Now</button>"+
						"</center>");
						dataMap.put("percentage", "");
					}else{
						dataMap.put("process", "<em style=\"font-size: 12px\">"+lastEmailRefreshDate+"</em><br/><center>"+
								"<button type=\"button\" class=\"btn btn-xs btn-primary\" onclick=\"navigate('Email Refresh Log','emailRefreshLog','common/emailRefreshLog','1')\">View Log</button>&nbsp;&nbsp;&nbsp;"+
								"<button type=\"button\" class=\"btn btn-xs btn-success\" onclick=\"refreshEmail(this)\">Refresh Now</button>"+
								"</center>");
						dataMap.put("percentage", "");
					}
				}else{
					dataMap.put("percentage", new Integer(emailRefresh.getPercentage()).toString()+"% completed");
					dataMap.put("process", "<span>Started : "+emailRefresh.getStartTime()+"<br/>Folder : "+emailRefresh.getFolder()+"("+emailRefresh.getNoOfComplete()+"/"+emailRefresh.getNoOfEmailFound()+")</span>"+
										   "<br/><div class=\"progress progress-striped active\">"+
										   "<div class=\"progress-bar progress-bar-primary\" role=\"progressbar\""+
										   "aria-valuenow=\""+emailRefresh.getPercentage()+"\" aria-valuemin=\"0\" aria-valuemax=\"100\""+
										   "style=\"width: "+emailRefresh.getPercentage()+"%\"><span class=\"sr-only\">"+emailRefresh.getPercentage()+"% Complete</span></div></div>"+
										   "<span>"+emailRefresh.getStatusMessage()+"</span>");
				}
			}
			mainMap.put("EMAILREFRESH", dataMap);
			/*
			Extraction extraction = commonService.getExtractionStatus();
			dataMap = new HashMap<String, String>();
			if(extraction != null){
				if(extraction.getStatus() == 1){
					dataMap.put("percentage", new Integer(extraction.getPercentage()).toString()+"% completed");
					dataMap.put("process", "<span>Process Date : <em style=\"font-size: 12px\">"+extraction.getStrProcessStartDate()+"</em>"+
										   "<br/>Started : <em style=\"font-size: 12px\">"+extraction.getStrStartDate()+"</em>"+
										   "<br/>"+extraction.getTimeMessage()+" : <em style=\"font-size: 12px\">"+extraction.getTimeValue()+"</em></span>"+
										   "<br/><div class=\"progress progress-striped active\">"+
										   "<div class=\"progress-bar progress-bar-success\" role=\"progressbar\""+
										   "aria-valuenow=\""+extraction.getPercentage()+"\" aria-valuemin=\"0\" aria-valuemax=\"100\""+
										   "style=\"width: "+extraction.getPercentage()+"%\"><span class=\"sr-only\">"+extraction.getPercentage()+"% Complete</span></div></div>"+
										   "<span><em style=\"font-size: 12px\">"+extraction.getLastMessage()+"</em></span>");
				}else{
					dataMap.put("percentage", "");
					dataMap.put("process", "Process Date : <em style=\"font-size: 12px\">"+extraction.getStrProcessStartDate()+"</em>"+
										   "<br/>Started : <em style=\"font-size: 12px\">"+extraction.getStrStartDate()+"</em>"+
										   "<br/>"+extraction.getStrEndDateMessage()+" : <em style=\"font-size: 12px\">"+extraction.getStrEndDateValue()+"</em>"+
										   "<br/>"+extraction.getTimeMessage()+" : <em style=\"font-size: 12px\">"+extraction.getTimeValue()+"</em></span>");
					
				}
			}else{
				dataMap.put("percentage", "");
				dataMap.put("process", "Extraction process is not yet started");
			}
			mainMap.put("EXTRACTIONDETAILS", dataMap);
			*/
			List<Map<String, String>> emailNotification = commonService.getEmailNotification(authentication.getPrincipal().toString(), "N");
			dataMap = new HashMap<String, String>();
			dataMap.put("emailCount", new Integer(emailNotification.size()).toString());
			int count = 1;
			int seenEmailCount = 0;
			String emailString = "";
			if(emailNotification.size() < 3){
				seenEmailCount = 3 - emailNotification.size();
			}
			
			for(int index = 0; count <= 3 && index < emailNotification.size(); count++){
				Map<String, String> emailDetails = emailNotification.get(index);
				emailString = emailString+ "<li onclick='compassEmailExchange.openEmail(\""+request.getContextPath()+"\",\""+emailDetails.get("CASENO")+"\", \""+emailDetails.get("MESSAGEINTERNALNO")+"\", \""+emailDetails.get("FOLDERTYPE")+"\")'>"+
										   "<a href='javascript:void(0)'><div><strong>"+emailDetails.get("SENDERID")+"</strong>"+
							  			   "<span class='pull-right text-muted'><em style='font-size:10px'>"+emailDetails.get("UPDATETIMESTAMP")+"</em></span></div>"+
										   "<div>"+emailDetails.get("SUBJECT")+"</div>"+
										   "</a></li><li class='divider'></li>";
				index++;
			}
			if(seenEmailCount > 0){
				emailNotification = commonService.getEmailNotification(authentication.getPrincipal().toString(), "Y");
				for(int x = 0; count <= 3 && x < emailNotification.size(); count++){
					Map<String, String> emailDetails = emailNotification.get(x);
					emailString = emailString+ "<li onclick='compassEmailExchange.openEmail(\""+request.getContextPath()+"\",\""+emailDetails.get("CASENO")+"\", \""+emailDetails.get("MESSAGEINTERNALNO")+"\", \""+emailDetails.get("FOLDERTYPE")+"\")'>"+
											   "<a href='javascript:void(0)'><div>"+emailDetails.get("SENDERID")+""+
								  			   "<span class='pull-right text-muted'><em style='font-size:10px'>"+emailDetails.get("UPDATETIMESTAMP")+"</em></span></div>"+
											   "<div>"+emailDetails.get("SUBJECT")+"</div>"+
											   "</a></li><li class='divider'></li>";
					x++;
				}
			}
			dataMap.put("emailString", emailString);
			mainMap.put("EMAILNOTIFICATION", dataMap);
		}
		commonService.auditLog(authentication.getPrincipal().toString(), request, "COMMON", "SEARCH", "Module Accessed");
		return mainMap;
	}
	
	@RequestMapping(value="/getAllChatUser", method=RequestMethod.POST)
	public @ResponseBody String getAllChatUser(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String htmlString = "";
		String chatStatus = (String) request.getSession(false).getAttribute("CHATSTATUS");
		if(chatStatus != null){
			if(chatStatus.equals("A"))
				htmlString = "<li onclick=\"changeChatStatus('A')\" style=\"cursor:pointer\"><a href=\"javascript:void(0)\"> "+
							 "Available<span class=\"pull-right text-muted badge small\"><i class=\"fa fa-circle fa-fw\" style=\"color:lime\"></a></i></span></li>";
			else
				htmlString = "<li onclick=\"changeChatStatus('A')\" style=\"cursor:pointer\"><a href=\"javascript:void(0)\">Available</a></li>";
			
			if(chatStatus.equals("B"))
				htmlString = htmlString+"<li onclick=\"changeChatStatus('B')\" style=\"cursor:pointer\"><a href=\"javascript:void(0)\"> "+
						 "Busy<span class=\"pull-right text-muted badge small\"><i class=\"fa fa-circle fa-fw\" style=\"color:red\"></i></span></a></li>";
			else
				htmlString = htmlString+"<li onclick=\"changeChatStatus('B')\" style=\"cursor:pointer\"><a href=\"javascript:void(0)\">Busy</a></li>";
			
			if(chatStatus.equals("O"))
				htmlString = htmlString+"<li onclick=\"changeChatStatus('O')\" style=\"cursor:pointer\"><a href=\"javascript:void(0)\"> "+
						 "Offline<span class=\"pull-right text-muted badge small\"><i class=\"fa fa-circle fa-fw\" style=\"color:black\"></i></span></a></li>";
			else
				htmlString = htmlString+"<li onclick=\"changeChatStatus('O')\" style=\"cursor:pointer\"><a href=\"javascript:void(0)\">Offline</a></li>";
			
			htmlString = htmlString + "<li class=\"divider\"></li>\n";
			
			if(chatStatus.equals("O")){
				htmlString = htmlString + "<li style=\"text-align:center;\">You are not online for chat</li>";
			}else{
				Map<String, Map<String, String>> allUser = commonService.getAllOnlinePerson(authentication.getPrincipal().toString());
				List<String> allUserCode = new ArrayList<String>(allUser.keySet());
				for(String userCode : allUserCode){
					Map<String, String> userDetails = allUser.get(userCode);			
					String chatWindowId = userDetails.get("CHATWINDOWID").replace(".", "");
					
					htmlString = htmlString + "<li><a href=\"javascript:void(0)\" onclick=\"register_popup('"+chatWindowId+"','"+userDetails.get("USERNAME")+"','"+userDetails.get("USERCODE")+"','"+userDetails.get("MESSAGEMAXNO")+"',false)\">"+
								 "<div><i class=\"fa fa-circle fa-fw\" ";
					if(userDetails.get("STATUS").equals("A")){
						htmlString = htmlString + " style=\"color:lime\"> ";
					}else if(userDetails.get("STATUS").equals("B")){
						htmlString = htmlString + "style=\"color:red\"> ";
					}else{
						htmlString = htmlString + "style=\"color:black\"> ";
					}
					htmlString = htmlString + "</i> "+userDetails.get("USERNAME");
					
					if(userDetails.get("UNSEENMESSAGECOUNT").length() > 0){
						htmlString = htmlString + "<span class=\"pull-right text-muted badge small\">"+userDetails.get("UNSEENMESSAGECOUNT")+"</span>";
					}
					htmlString = htmlString + "</div></a></li>\n";
				}
			}
		}
		commonService.auditLog(authentication.getPrincipal().toString(), request, "COMMON", "SEARCH", "Module Accessed");
		return htmlString;
	}
	
	@RequestMapping(value="/getUserOnlineStatus", method=RequestMethod.POST)
	public @ResponseBody Map<String,String> getUserOnlineStatus(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String userCode = request.getParameter("userCode");
		commonService.auditLog(authentication.getPrincipal().toString(), request, "COMMON", "SEARCH", "Module Accessed");
		return commonService.getUserOnlineStatus(authentication.getPrincipal().toString(), userCode);
	}
	
	@RequestMapping(value="/emailRefreshLog", method=RequestMethod.GET)
	public String emailRefreshLog(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		request.setAttribute("EMAILREFRESHLOG", commonService.getAllEmailRefreshLog());
		commonService.auditLog(authentication.getPrincipal().toString(), request, "COMMON", "SEARCH", "Email Refreshed");
		return "common/emailRefreshLog";
	}
	
	@RequestMapping(value="/sendChatMessage", method=RequestMethod.POST)
	public @ResponseBody void sendChatMessage(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		Random random = new Random();
		log.info("Sending chat message...");
		DomainUser domainUser = (DomainUser) authentication.getDetails();
		String fromUser = authentication.getPrincipal().toString();
		String fromUserName = domainUser.getFirstName()+"  "+domainUser.getLastName();
		String toUser = request.getParameter("USERTO");
		String toUsername = request.getParameter("USERTONAME");
		String messageID = domainUser.getUsername()+new Integer(random.nextInt()).toString();
		String chatWindowId = request.getParameter("CHATWINDOWID");
		String message = request.getParameter("CHATMESSAGE");
		commonService.auditLog(authentication.getPrincipal().toString(), request, "COMMON", "INSERT", "Message Sent");
		commonService.sendChatMessage(fromUser, toUser, fromUserName, toUsername, messageID, message, chatWindowId);
	}
	
	@RequestMapping(value="/changeChatStatus", method=RequestMethod.POST)
	public @ResponseBody void changeChatStatus(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String currentStatus = (String) request.getSession(false).getAttribute("CHATSTATUS");
		DomainUser domainUser = (DomainUser) authentication.getDetails();
		String status = request.getParameter("STATUS");
		request.getSession(false).setAttribute("CHATSTATUS", status);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "COMMON", "UPDATE", "User Updated Chat Status");
		commonService.changeChatStatus(authentication.getPrincipal().toString(), currentStatus, status, domainUser.getFirstName()+" "+domainUser.getLastName());
	}
	
	@RequestMapping(value="/getUserChatStatus", method=RequestMethod.POST)
	public @ResponseBody String getUserChatStatus(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		
		return request.getSession(false) != null ? (String) request.getSession(false).getAttribute("CHATSTATUS") : "";
	}
	
	@RequestMapping(value="/getMessageMaxNo", method=RequestMethod.POST)
	public @ResponseBody String getMessageMaxNo(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String chatWindowId = request.getParameter("chatWindowId");
		String maxNo = commonService.getMessageMaxNo(chatWindowId);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "COMMON", "SEARCH", "Message Max No. Read");	
		return maxNo;
	}
	
	@RequestMapping(value="/getChatMessageForUser", method=RequestMethod.POST)
	public @ResponseBody Map<String, Map<String, ChatMessage>> getChatMessageForUser(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String userCode = authentication.getPrincipal().toString().replace(".", "");
		commonService.auditLog(authentication.getPrincipal().toString(), request, "COMMON", "SEARCH", "Message For User");
		return ChatMessageHolder.getChatMessageForUser(userCode, authentication.getPrincipal().toString());
	}
	
	@RequestMapping(value="/loadPreviosMessage", method=RequestMethod.POST)
	public @ResponseBody String loadPreviosMessage(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String chatWindowId = request.getParameter("chatWindowId");
		String messageMaxNo = request.getParameter("messagemaxno");
		int intMessageMaxNo = Integer.parseInt(messageMaxNo);
		int intMessageMinNo = intMessageMaxNo - 10;
		commonService.auditLog(authentication.getPrincipal().toString(), request, "COMMON", "OPEN", "Module Accessed");
		return commonService.loadPreviuosMessage(chatWindowId, authentication.getPrincipal().toString(), intMessageMaxNo, intMessageMinNo);
	}
	
	@RequestMapping(value="/loadUnseenMessage", method=RequestMethod.POST)
	public @ResponseBody String loadUnseenMessage(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String chatWindowId = request.getParameter("chatWindowId");
		commonService.auditLog(authentication.getPrincipal().toString(), request, "COMMON", "OPEN", "Module Accessed");
		return commonService.loadUnseenMessage(chatWindowId, authentication.getPrincipal().toString());
	}
	
	@RequestMapping(value="/refreshEmail", method=RequestMethod.POST)
	public @ResponseBody String refreshEmail(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		Map<String, String> systemParameters = commonService.initilizingDBSystemParameters();
		String emailPassword = systemParameters.get("EMAILPASSSWORD");
		String subjectsToIgnore = systemParameters.get("SUBJECTESCAPESTRING");
		String emailSearchString = systemParameters.get("CASESEARCHSTRING");
		String sentRefresh = systemParameters.get("SENTFOLDERREFRESH");
		String sentFolderName = systemParameters.get("SENTFOLDERNAME");
		String inboxRefresh = systemParameters.get("INBOXFOLDERREFRESH");
		String inboxFolderName = systemParameters.get("INBOXFOLDERNAME");
		int lookupDays = 1;
		try{
			lookupDays = Integer.parseInt(systemParameters.get("LOOKUPDAYS"));
		}catch(Exception e){}
		
		if(inboxRefresh.equals("Y")){
			commonService.refreshEmail(authentication.getPrincipal().toString(), emailPassword,
					lookupDays, inboxFolderName, "INBOX", emailSearchString, subjectsToIgnore);
		}
			
		if(sentRefresh.equals("Y")){
			commonService.refreshEmail(authentication.getPrincipal().toString(), emailPassword,
					lookupDays, sentFolderName, "SENT", emailSearchString, subjectsToIgnore);
		}
		commonService.auditLog(authentication.getPrincipal().toString(), request, "COMMON", "INSERT", "Email Refreshed");
		return "";
	}
	
	@RequestMapping(value="/getFileUploadConfig", method=RequestMethod.POST)
	public @ResponseBody Map<String, Object> getFileUploadConfig(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String moduleRef = request.getParameter("moduleRefId");
		String moduleUnqNo = request.getParameter("moduleUnqNo");
		Map<String, Object> uploadConfig = commonService.getFileUploadConfig(moduleRef);
		List<Map<String, String>> uploadedFileConfig = commonService.getFilesInfoForModuleUnqNo(moduleUnqNo);
		uploadConfig.put("UPLOADEDFILES", uploadedFileConfig);
		uploadConfig.put("UNQID", otherCommonService.getElementId());
		commonService.auditLog(authentication.getPrincipal().toString(), request, "COMMON", "OPEN", "File Uploader Opened For"+moduleRef);
		return uploadConfig;
	}
	
	@RequestMapping(value="/genericFileUpload", method = RequestMethod.POST)
	public @ResponseBody String genericFileUpload(MultipartHttpServletRequest request, HttpServletResponse response, Authentication authentication) {
		String uploadModuleRefId = request.getParameter("uploadRefId");
		String uploadSeqNo = request.getParameter("unqId");
		String seqNo = request.getParameter("seqNo");
		String CURRENTROLE = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String moduleUnqNo = request.getParameter("moduleUnqNo");
		String result = "";

		Iterator<String> itrator = request.getFileNames();
		MultipartFile multiFile = request.getFile(itrator.next());
		
		Map<String, Object> uploadConfig = commonService.getFileUploadConfig(uploadModuleRefId);
		String allowFileTypes = uploadConfig.get("ALLOWFILETYPES").toString();
		String blockFileTypes = uploadConfig.get("BLOCKFILETYPES").toString();
		/*System.out.println("allowed type = "+allowFileTypes);
		System.out.println("blocked type type = "+blockFileTypes);
		*/String [] allowedFileTypeArr = allowFileTypes.split(",");
		String [] blockFileTypeArr = blockFileTypes.split(",");
		String fileNameWithExtension = multiFile.getOriginalFilename();
		
		if(!compassFileUtils.isValidFileName(fileNameWithExtension)){
			return "this File Name "+fileNameWithExtension+" is not allowed";
		}
		
		//System.out.println("fName = "+fileNameWithExtension);
		if(CommonUtil.splitString(fileNameWithExtension, ".").length == 2){
    		String filename = fileNameWithExtension.split("\\.")[0]; 
        	String extension = fileNameWithExtension.split("\\.")[1];
    		//for checking allowed file type
    		boolean isAllowed = false;
    		if(allowFileTypes.equalsIgnoreCase("ALL")){
    			for(String ext:blockFileTypeArr){
    				if(extension.equals(ext)){
    					isAllowed = false;
						break;
    				}else{
    					isAllowed = true;
    				}
    			}
    			
    		}else{
    			for(String ext:allowedFileTypeArr){
        			if(extension.equals(ext)){
        				isAllowed = true;
						break;
        			}
        		}
    		}
    		
    		
    		
			if(isAllowed){
				commonService.saveUploadedFile(seqNo, (String) uploadConfig.get("FOLDERNAME"), uploadModuleRefId, 
			    		uploadSeqNo, moduleUnqNo, multiFile, authentication.getPrincipal().toString(), CURRENTROLE, request.getRemoteAddr());
			    result = request.getFile("file") +" uploaded! uploadRefId = "+uploadModuleRefId+", uploadSeqNo="+uploadSeqNo;
			}else{
				result = "Filetype restricted for upload.";
			}
		}else{
			result = "Filetype restricted for upload. Only one dot(.) is allowed in file name. ";
		}
		
	   /* commonService.saveUploadedFile(seqNo, (String) uploadConfig.get("FOLDERNAME"), uploadModuleRefId, 
	    		uploadSeqNo, moduleUnqNo, multiFile, authentication.getPrincipal().toString(), CURRENTROLE, request.getRemoteAddr());
	   */ 
	   commonService.auditLog(authentication.getPrincipal().toString(), request, "COMMON", "INSERT", "File Uploaded"+uploadModuleRefId+", Sequence No: "+seqNo);
	   
	   System.out.println("result = "+result);
	   return  result;//request.getFile("file") +" uploaded! uploadRefId = "+uploadModuleRefId+", uploadSeqNo="+uploadSeqNo;
	}
	
	@RequestMapping(value="/getAttachmentFolder", method = RequestMethod.POST)
	public @ResponseBody String getAttachmentFolder(){
		return otherCommonService.getElementId();
	}
	
	@RequestMapping(value="/emailAttachments", method = RequestMethod.POST)
	public @ResponseBody String emailAttachments(MultipartHttpServletRequest request, HttpServletResponse response, Authentication authentication) {
		String caseNo = request.getParameter("caseNo");
		String attachmentFolder = request.getParameter("attachmentFolder");
		
		Iterator<String> itrator = request.getFileNames();
		MultipartFile multiFile = request.getFile(itrator.next());
		
		
		commonService.saveEmailAttachments(caseNo, multiFile, attachmentFolder);
	    commonService.auditLog(authentication.getPrincipal().toString(), request, "COMMON", "INSERT", "File "+multiFile.getName()+" attached with email for case no "+caseNo);
	    return attachmentFolder;
	}
	
	@RequestMapping(value="/sendEmail", method = RequestMethod.POST)
	public @ResponseBody Map<String, String> sendEmail(HttpServletRequest request, HttpServletResponse response, Authentication authentication) {
		Map<String, String> responseMap = new HashMap<String, String>();
		String caseNo = request.getParameter("caseNo");
		String to = request.getParameter("to"); 
		String cc = request.getParameter("cc");
		String bcc = "";
		if(request.getParameter("bcc") != null || request.getParameter("bcc") != "") {
			bcc = request.getParameter("bcc");
		}
		String subject = request.getParameter("subject");
		String content = request.getParameter("content");
		//content = HtmlUtils.htmlUnescape(content);
		// System.out.println("content:  "+content);
		String attachmentFolder = request.getParameter("attachmentFolder");
		String isDraft = request.getParameter("isDraft");
		String emailNo = request.getParameter("emailNo");
		String userCode = authentication.getPrincipal().toString();
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String ipAddress = request.getRemoteAddr();
		// System.out.println("content:   "+content);
		String toArr[] = CommonUtil.splitString(to, ";");
		String ccArr[] = CommonUtil.splitString(cc, ";");
		String bccArr[] = {};
		if(bcc != null && bcc != "") {
			bccArr = CommonUtil.splitString(bcc, ";");
		}
		
		List<String> toList = new Vector<String>();
		
		for(String toStr : toArr){
			if(toStr.trim().length() > 0){
				toList.add(toStr.trim());
			}
		}
		
		List<String> ccList = new Vector<String>();
		
		for(String ccStr : ccArr){
			if(ccStr.trim().length() > 0){
				ccList.add(ccStr.trim());
			}
		}
		
		List<String> bccList = new Vector<String>();
		
		for(String bccStr : bccArr){
			if(bccStr.trim().length() > 0){
				bccList.add(bccStr.trim());
			}
		}
		
		//System.out.println("controller bccList = "+bccList+" caseNo = "+caseNo);
		responseMap = commonService.sendEMail(caseNo, toList, ccList, bccList, subject, content, attachmentFolder, userCode, isDraft, emailNo);
		System.out.println("responseMap of sendEmail = "+responseMap);
	    commonService.auditLog(userCode, request, "COMMON", "INSERT", "Sending Email for caseno : "+caseNo);
	    return responseMap;
	}
	
	@RequestMapping(value="/genericFileProcess", method = RequestMethod.POST)
	public @ResponseBody List<Map<String, String>> genericFileProcess(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String uploadRefNo = request.getParameter("uploadRefNo");
		String moduleRefId = request.getParameter("moduleRefId");
		String CURRENTROLE = (String) request.getSession(false).getAttribute("CURRENTROLE");
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "COMMON", "INSERT", "Uploaded File Under Process For Upload Reference No: "+uploadRefNo+", Module Reference No: "+moduleRefId);
		return commonService.processFile(uploadRefNo, moduleRefId, authentication.getPrincipal().toString(), CURRENTROLE, request.getRemoteAddr());
	}
	
	@RequestMapping(value="/attachCCRUploadedFile", method = RequestMethod.POST)
	public String attachCCRUploadedFile(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String uploadRefNo = request.getParameter("uploadRefNo");
		String moduleRefId = request.getParameter("moduleRefId");
		
		Calendar cal = Calendar.getInstance();
		cal.add(Calendar.MONTH, -1);		
		
		request.setAttribute("months", otherCommonService.getMonths());
		request.setAttribute("currentMonth", cal.get(Calendar.MONTH));
		request.setAttribute("years", otherCommonService.getYears());
		request.setAttribute("currentYear", cal.get(Calendar.YEAR));
		request.setAttribute("FILEINFO", commonService.getFileInfo(uploadRefNo, moduleRefId, null));
		request.setAttribute("uploadRefNo", uploadRefNo);
		request.setAttribute("moduleRefId", moduleRefId);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "COMMON", "SEARCH", "Module Accessed");
		return "common/FileAttach/CCRFileAttach";
	}
	
	@RequestMapping(value="/fileAttachConfirmation", method = RequestMethod.POST)
	public String attachCaseEvicence(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String uploadRefNo = request.getParameter("uploadRefNo");
		String moduleRefId = request.getParameter("moduleRefId");
		String moduleUnqNo = request.getParameter("moduleUnqNo");
		
		request.setAttribute("FILEINFO", commonService.getFileInfo(uploadRefNo, moduleRefId, moduleUnqNo));
		request.setAttribute("uploadRefNo", uploadRefNo);
		request.setAttribute("moduleRefId", moduleRefId);
		request.setAttribute("moduleUnqNo", moduleUnqNo);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "COMMON", "SEARCH", "Module Accessed");
		return "common/FileAttach/CommonFileAttach";
	}
	
	@RequestMapping(value="/attachAndProcessCCRUploadedFile", method = RequestMethod.POST)
	public @ResponseBody boolean attachAndProcessCCRUploadedFile(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String uploadRefNo = request.getParameter("uploadRefNo");
		String moduleRefNo = request.getParameter("moduleRefNo");
		String month = request.getParameter("month");
		String year = request.getParameter("year");
		String CURRENTROLE = (String) request.getSession(false).getAttribute("CURRENTROLE");
		
		Map<String, Object> uploadConfig = commonService.getFileUploadConfig(moduleRefNo);
		String PROCESSPROCEDURE = (String) uploadConfig.get("PROCESSPROCEDURE");
		commonService.auditLog(authentication.getPrincipal().toString(), request, "COMMON", "SEARCH", "Module Accessed");
		return commonService.processCCRUploadedFile(PROCESSPROCEDURE, uploadRefNo, moduleRefNo, month, year, authentication.getPrincipal().toString(), 
				CURRENTROLE, request.getRemoteAddr());
	}
	
	@RequestMapping(value="/downloadServerFile", method = RequestMethod.GET)
	public @ResponseBody String downloadServerFile(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		response.setHeader("Set-Cookie", "fileDownload=true; path=/");
		response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
		
		String seqNo = request.getParameter("seqNo");
		String uploadRefNo = request.getParameter("uploadRefNo");
		String moduleRefNo = request.getParameter("moduleRefNo");
		String moduleUnqNo = request.getParameter("moduleUnqNo");
		Map<String, Object> fileInfo = commonService.getFileContentForDownload(seqNo, uploadRefNo, moduleUnqNo);
		
		File file = (File) fileInfo.get("FILE");
		String fileName = (String) fileInfo.get("FILENAME");
		
		InputStream fileInputStream = new FileInputStream(file);
		response.setHeader("Content-Disposition", "attachment;filename=\"" +fileName+ "\"");
        response.setContentType("application/octet-stream");
        OutputStream out = response.getOutputStream();
		IOUtils.copy(fileInputStream, out);
		out.flush();
	    out.close();
	    fileInputStream.close();
	    file.delete();
	    commonService.auditLog(authentication.getPrincipal().toString(), request, "COMMON", "DOWNLOAD", "File Downloaded"+fileName);
		return null;
	}
	
	@RequestMapping(value="/downloadEmailAttachment", method = RequestMethod.GET)
	public @ResponseBody String downloadEmailAttachment(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		response.setHeader("Set-Cookie", "fileDownload=true; path=/");
		response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
		
		String caseNo = request.getParameter("caseNo");
		String messageNumber = request.getParameter("messageNumber");
		String attachmentNumebr = request.getParameter("attachmentNumebr");
				
		Map<String, Object> fileInfo = commonService.downloadEmailAttachment(caseNo, messageNumber, attachmentNumebr);
		
		File file = (File) fileInfo.get("FILE");
		String fileName = (String) fileInfo.get("FILENAME");
		
		InputStream fileInputStream = new FileInputStream(file);
		response.setHeader("Content-Disposition", "attachment;filename=\"" +fileName+ "\"");
        response.setContentType("application/octet-stream");
        OutputStream out = response.getOutputStream();
		IOUtils.copy(fileInputStream, out);
		out.flush();
	    out.close();
	    fileInputStream.close();
	    file.delete();
	    commonService.auditLog(authentication.getPrincipal().toString(), request, "COMMON", "DOWNLOAD", "Email Attachment Downloaded"+fileName);
		return null;
	}
	
	@RequestMapping(value="/removeServerFile", method = RequestMethod.POST)
	public @ResponseBody String removeServerFile(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		String seqNo = request.getParameter("seqNo");
		String uploadRefNo = request.getParameter("uploadRefNo");
		String moduleRefNo = request.getParameter("moduleRefNo");
		String moduleUnqNo = request.getParameter("moduleUnqNo");
		
		String userCode = authentication.getPrincipal().toString(); 
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String ipAddress = request.getRemoteAddr();
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "COMMON", "DELETE", "Server File Deleted");
		return commonService.removeServerFile(seqNo, uploadRefNo, moduleRefNo, moduleUnqNo,
				userCode, userRole, ipAddress);
	}
	
	@RequestMapping(value="/showEmail", method = RequestMethod.POST)
	public String showEmail(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		String caseNo = request.getParameter("caseNo");
		String emailNumber = request.getParameter("emailNumber");
		String folderType = request.getParameter("folderType");
		//String formId = request.getParameter("formId");
		request.setAttribute("caseNo", caseNo);
		request.setAttribute("emailNumber", emailNumber);
		request.setAttribute("folderType", folderType);
		//request.setAttribute("parentFormId", formId);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "COMMON", "OPEN", "Module Accessed");
		return "common/EmailExchange/index";
	}
	
	@RequestMapping(value="/showAllMessage", method = RequestMethod.POST)
	public String showAllMessage(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		String caseNo = request.getParameter("caseNo");
		String folder = request.getParameter("folder");
		
		request.setAttribute("EMAILDETAIL", commonService.getEmailDetails(caseNo, folder, "", authentication.getPrincipal().toString()));
		
		request.setAttribute("caseNo", caseNo);
		request.setAttribute("folder", folder);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "COMMON", "READ", "Module Accessed");
		return "common/EmailExchange/ShowAllMessage";
	}
	
	@RequestMapping(value="/showMessage", method = RequestMethod.POST)
	public String showMessage(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		String caseNo = request.getParameter("caseNo");
		String emailNumber = request.getParameter("emailNumber");
		String folder = request.getParameter("folder");
		
		request.setAttribute("EMAILDETAIL", commonService.getEmailDetails(caseNo, folder, emailNumber, authentication.getPrincipal().toString()));
		request.setAttribute("EMAILATTACHMENTS", commonService.getEmailAttachments(caseNo, emailNumber));
		
		request.setAttribute("caseNo", caseNo);
		request.setAttribute("emailNumber", emailNumber);
		request.setAttribute("folder", folder);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "COMMON", "READ", "Module Accessed");
		return "common/EmailExchange/ShowMessage";
	}
	
	@RequestMapping(value="/getFolderEmailCount", method = RequestMethod.POST)
	public @ResponseBody String getFolderEmailCount(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		String folder = request.getParameter("folder");
		String caseNo = request.getParameter("caseNo");
		
		return commonService.getFolderEmailCount(folder, caseNo);
	}
	
	@RequestMapping(value="/composeMessage", method = RequestMethod.POST)
	public String composeMessage(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		String caseNo = request.getParameter("caseNo");
		String emailNo = request.getParameter("emailNo");
		String folderType = request.getParameter("folderType");
		String composeType = request.getParameter("composeType");
		//String parentFormId = request.getParameter("parentFormId");
		String CURRENTROLE = request.getSession(false) != null ? (String) request.getSession(false).getAttribute("CURRENTROLE") : "";
		Map<String, String> emailDetails = commonService.composeEmail(caseNo, emailNo, folderType, composeType, 
				authentication.getPrincipal().toString(), CURRENTROLE);
		if(composeType.equals("NEW")){
			emailDetails.put("SUBJECT", emailDetails.get("SUBJECT")+caseNo+", ");
		}
		
		if(composeType.equals("DRAFTS")){
			request.setAttribute("EMAILATTACHMENTS", commonService.getEmailAttachments(caseNo, emailNo));
		}
		//System.out.println("EmailAttachments  - "+commonService.getEmailAttachments(caseNo, emailNo));
		commonService.getEmailDetails(caseNo, folderType, emailNo, authentication.getPrincipal().toString());
		request.setAttribute("emailDetails", emailDetails);
		request.setAttribute("caseNo", caseNo);
		request.setAttribute("emailNo", emailNo);
		request.setAttribute("folderType", folderType);
		request.setAttribute("composeType", composeType);
		request.setAttribute("messageId", emailDetails.get("MESSAGEID"));
		request.setAttribute("UNQID", otherCommonService.getElementId());
		//System.out.println("From Controller = "+emailDetails);
		return "common/EmailExchange/ComposeMessage";
	}
	
	@RequestMapping(value="/getEmailIdsForMapping", method = RequestMethod.POST)
	public @ResponseBody Map<String, Object> getEmailIdsForMapping(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		String mappingCode = request.getParameter("mappingCode");
		
		return commonService.getEmailIdsForMapping(mappingCode, 0);
	}
	
	@RequestMapping(value="getDashboardGraph", method=RequestMethod.GET)
	public String getDashboardGraph(HttpServletRequest request, HttpServletResponse response, 
						Authentication authentication) throws Exception{
		String CURRENTROLE = request.getSession(false) != null ? (String) request.getSession(false).getAttribute("CURRENTROLE") : "";
		String ipAddress = request.getRemoteAddr();
		System.out.println("requesting commonService.getDashboardGraphData ");
		
		Map<String, Object> dashBoardGraphData = commonService.getDashboardGraphData(authentication.getPrincipal().toString(), CURRENTROLE, ipAddress);

		//CUSTOMER RISK
		List<Map<String, String>> customerRiskGraph = new ArrayList<Map<String,String>>();
		List<Map<String, String>> customersRiskData = (ArrayList<Map<String, String>>)dashBoardGraphData.get("CUSTOMERSRISK_GRAPHDATA");
		for(int count = 0; count < customersRiskData.size(); count++){
			customerRiskGraph.add((HashMap<String, String>)customersRiskData.get(count));
		}
		System.out.println("customerRiskGraph = "+customerRiskGraph);
		//ACCOUNT RISK
		List<Map<String, String>> accountRiskGraph = new ArrayList<Map<String,String>>();
		List<Map<String, String>> accountsRiskData = (ArrayList<Map<String, String>>)dashBoardGraphData.get("ACCOUNTSRISK_GRAPHDATA");
		for(int count = 0; count < accountsRiskData.size(); count++){
			accountRiskGraph.add((HashMap<String, String>)accountsRiskData.get(count));
		}
		System.out.println("accountRiskGraph = "+accountRiskGraph);
		//ALERT STATISTICS
		List<Map<String, String>> alertStatisticsGraph = new ArrayList<Map<String,String>>();
		List<Map<String, String>> alertStatisticsData = (ArrayList<Map<String, String>>)dashBoardGraphData.get("ALERTSTATISTICS_GRAPHDATA");
		for(int count = 0; count < alertStatisticsData.size(); count++){
			alertStatisticsGraph.add((HashMap<String, String>)alertStatisticsData.get(count));
		}
		System.out.println("alertStatisticsGraph = "+alertStatisticsGraph);
		//TOP N Alerts
		List<Map<String, String>> nTopmostAlertsGraph = new ArrayList<Map<String,String>>();
		List<Map<String, String>> nTopmostAlertsData = (ArrayList<Map<String, String>>)dashBoardGraphData.get("NTOPMOSTALERTS_GRAPHDATA");
		for(int count = 0; count < nTopmostAlertsData.size(); count++){
			nTopmostAlertsGraph.add((HashMap<String, String>)nTopmostAlertsData.get(count));
		}

		/*
		Map<String, String> customerRiskMap1 = new HashMap<String, String>();
		customerRiskMap1.put("name", "HIGH");
		customerRiskMap1.put("value", dashBoardGraphData.get("CUSTOMERS_HIGH").toString());
		customerRiskMap1.put("percentage", "0");
		
		Map<String, String> customerRiskMap2 = new HashMap<String, String>();
		customerRiskMap2.put("name", "MEDIUM");
		customerRiskMap2.put("value", dashBoardGraphData.get("CUSTOMERS_MEDIUM").toString());
		customerRiskMap2.put("percentage", "86.62");
		
		Map<String, String> customerRiskMap3 = new HashMap<String, String>();
		customerRiskMap3.put("name", "LOW");
		customerRiskMap3.put("value", dashBoardGraphData.get("CUSTOMERS_LOW").toString());
		customerRiskMap3.put("percentage", "13.38");
		
		customerRiskGraph.add(customerRiskMap1);
		customerRiskGraph.add(customerRiskMap2);
		customerRiskGraph.add(customerRiskMap3);
		
		//ACCOUNT RISK
		List<Map<String, String>> accountRiskGraph = new ArrayList<Map<String,String>>();
		Map<String, String> accountRiskMap1 = new HashMap<String, String>();
		accountRiskMap1.put("name", "HIGH");
		accountRiskMap1.put("value", dashBoardGraphData.get("ACCOUNTS_HIGH").toString());
		accountRiskMap1.put("percentage", "0");
		
		Map<String, String> accountRiskMap2 = new HashMap<String, String>();
		accountRiskMap2.put("name", "MEDIUM");
		accountRiskMap2.put("value", dashBoardGraphData.get("ACCOUNTS_MEDIUM").toString());
		accountRiskMap2.put("percentage", "86.62");
		
		Map<String, String> accountRiskMap3 = new HashMap<String, String>();
		accountRiskMap3.put("name", "LOW");
		accountRiskMap3.put("value", dashBoardGraphData.get("ACCOUNTS_LOW").toString());
		accountRiskMap3.put("percentage", "13.38");
		
		accountRiskGraph.add(accountRiskMap1);
		accountRiskGraph.add(accountRiskMap2);
		accountRiskGraph.add(accountRiskMap3);
		
		//ALERT STATISTICS
		List<Map<String, String>> alertStatistics = new ArrayList<Map<String,String>>();
		Map<String, String> alertStatisticsMap1 = new HashMap<String, String>();
		alertStatisticsMap1.put("name", "PENDING CASES");
		alertStatisticsMap1.put("value", "493");
		alertStatisticsMap1.put("percentage", "86.64");
		
		Map<String, String> alertStatisticsMap3 = new HashMap<String, String>();
		alertStatisticsMap3.put("name", "CLOSED CASES");
		alertStatisticsMap3.put("value", "70");
		alertStatisticsMap3.put("percentage", "12.36");
				
		Map<String, String> alertStatisticsMap4 = new HashMap<String, String>();
		//alertStatisticsMap4.put("name", "REPORTED AS STR");
		if(CURRENTROLE.indexOf("FATCA") > 0 ) { 
		alertStatisticsMap4.put("name", "REPORTED AS FATCA/CRS");
		}else if(CURRENTROLE.equalsIgnoreCase("ROLE_INVESTIGATOR") || CURRENTROLE.equalsIgnoreCase("ROLE_OFFICER") || CURRENTROLE.equalsIgnoreCase("ROLE_MANAGER")) { 
		alertStatisticsMap4.put("name", "CONFIRMED FRAUD");
		}else {
		alertStatisticsMap4.put("name", "REPORTED AS STR");
		}
		alertStatisticsMap4.put("value", "2");
		alertStatisticsMap4.put("percentage", "0.5");
		
		Map<String, String> alertStatisticsMap5 = new HashMap<String, String>();
		alertStatisticsMap5.put("name", "ADDED TO FALSE POSITIVE");
		alertStatisticsMap5.put("value", "1");
		alertStatisticsMap5.put("percentage", "0.5");
		
		alertStatistics.add(alertStatisticsMap1);
		alertStatistics.add(alertStatisticsMap3);
		alertStatistics.add(alertStatisticsMap4);
		alertStatistics.add(alertStatisticsMap5);
		*/

		request.setAttribute("CUSTOMERRISKGRAPH", customerRiskGraph);
		request.setAttribute("ACCOUNTRISKGRAPH", accountRiskGraph);
		request.setAttribute("ALERTSTATISTICS", alertStatisticsGraph);
		request.setAttribute("NTOPMOSTALERTS", nTopmostAlertsGraph);
		System.out.println("Returing common/Graphs/dashboardGraph ");
		return "common/Graphs/dashboardGraph";
	}	
	@RequestMapping(value="/getCheckerDashboard", method=RequestMethod.POST)
	public String getCheckerDashboard(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		return "Under process";
	}
	
	@RequestMapping(value="/getEmailAttachmentsDetails", method=RequestMethod.POST)
	public @ResponseBody List<Map<String, String>> getEmailAttachmentsDetails(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String caseNo = request.getParameter("caseNo");
		String emailNumber = request.getParameter("emailNo");
		//System.out.println("Entries "+caseNo+" "+emailNumber);
		List<Map<String, String>> mainList = commonService.getEmailAttachments(caseNo, emailNumber);
		//System.out.println("mainList = "+mainList);
		return mainList;
	}
	
	@RequestMapping(value="/deleteDraftEmail", method=RequestMethod.POST)
	public String deleteDraftEmail(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String caseNo = request.getParameter("caseNo");
		String emailNumber = request.getParameter("emailNo");
		String isDraft = request.getParameter("isDraft");
		//System.out.println("Entries "+caseNo+" "+emailNumber);
		commonService.deleteDraftEmail(caseNo, emailNumber, isDraft);
		//System.out.println("deleteResult = "+deleteResult);
		//return "redirect:/showEmail";
		return "common/EmailExchange/ShowAllMessage";
	}
	
	//Adding email questions  
	@RequestMapping(value="/getEmailQuestions", method=RequestMethod.GET)
	public String getEmailQuestions(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String caseNo = request.getParameter("caseNo");
		String previousQuestions = request.getParameter("previousQuestions");
		String userCode = authentication.getPrincipal().toString();
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String remoteAddr = request.getRemoteAddr();
		String newWindow = request.getParameter("newWindow") == null ? "":request.getParameter("newWindow");
		List<Map<String, Object>> output = commonService.getEmailQuestions(caseNo,userCode,userRole,remoteAddr);
		//System.out.println("email questions in controller are = "+output);
		Map<String,Object> groups = commonService.getEmailGroups(caseNo,userCode,userRole,remoteAddr);
		request.setAttribute("CASENO", caseNo);
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("QUESTIONS", output);
		request.setAttribute("GROUPS", groups);
		request.setAttribute("PREVIOUSQUESTIONS", previousQuestions);
		request.setAttribute("NEWWINDOW", newWindow);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "COMMON", "READ", "Module Accessed");
		return "common/EmailExchange/emailQuestions";
	}
	
	@RequestMapping(value="/validationCheck", method=RequestMethod.POST)
	public @ResponseBody List<Map<String,String>> validationCheck(HttpServletRequest request, HttpServletResponse response, 
					Authentication authentication) throws Exception{
		String custId = request.getParameter("customerId");
		String accNo = request.getParameter("accountNo");
		String isValidMessage = "";
		//System.out.println("AC="accNo+", CI"+custId);
//		System.out.println(commonService.validationCheck(custId,accNo));
		/*if(commonService.validationCheck(custId,accNo) == true){
			isValidMessage = "CustomerId/AccountNo is valid";
		}else{
			isValidMessage = "CustomerId/AccountNo is not valid";
		}
		return isValidMessage;*/
		commonService.auditLog(authentication.getPrincipal().toString(), request, "COMMON", "SEARCH", "Module Accessed");
		return commonService.validationCheck(custId,accNo);
	}
	
	
	@RequestMapping(value="/getEmailQuestionForEdit", method=RequestMethod.GET)
	public  String getEmailQuestionForEdit(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String emailQuestionID = request.getParameter("emailQuestionID");
		request.setAttribute("submitButton", request.getParameter("submitButton"));
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("DETAILS", commonService.getEmailQuestions(emailQuestionID));
		commonService.auditLog(authentication.getPrincipal().toString(), request, "COMMON", "READ", "Module Accessed");
		return "MasterModules/EmailQuestionRepositoryMaster/editQuestion";
	}
	
	
	
	@RequestMapping(value="/insertUpdateEamilQuestion", method=RequestMethod.POST)
	public @ResponseBody  String editEamilQuestion(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		Map<String,String>inputParam = new HashMap<String,String>();
		inputParam.put("QUESTIONID", request.getParameter("questionID"));
		inputParam.put("QUESTION", request.getParameter("question"));
		inputParam.put("QUESTIONGROUPTITLE", request.getParameter("questionGroupTitle"));
		inputParam.put("QUESTIONGROUP", request.getParameter("questionGroup"));
		String auditAction = request.getParameter("action");
		String userCode = authentication.getPrincipal().toString(); 
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String ipAddress = request.getRemoteAddr();
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "COMMON", auditAction, "Module Accessed");
		return commonService.insertUpdateEamilQuestion(inputParam,userCode,userRole,ipAddress);
	}
	
	@RequestMapping(value="/addNewEmailQuestions", method=RequestMethod.GET)
	public String addNewEmailQuestions(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String userCode = authentication.getPrincipal().toString(); 
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String ipAddress = request.getRemoteAddr();
		
		Map<String,Object> output = new HashMap<String,Object>();
		output = commonService.getQuestionIdAndGroupdetails(userCode,userRole,ipAddress);
		request.setAttribute("DETAILS",output);
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("submitButton",request.getParameter("submitButton"));
		commonService.auditLog(userCode, request, "COMMON", "READ", "Module Accessed");
		return "MasterModules/EmailQuestionRepositoryMaster/addQuestion";
	}
	
	@RequestMapping(value="/getFileUploadErrorDetails", method=RequestMethod.POST)
	public String getFileUploadErrorDetails(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String uploadRefNo = request.getParameter("uploadRefNo");
		String moduleRefId = request.getParameter("moduleRefId");
		String filename = request.getParameter("filename");
		String userCode = authentication.getPrincipal().toString(); 
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String ipAddress = request.getRemoteAddr();
		
		request.setAttribute("uploadRefNo",uploadRefNo);
		request.setAttribute("moduleRefId",moduleRefId);
		request.setAttribute("FILENAME",filename);
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("ErrorDetails", commonService.getFileUploadErrorDetails(uploadRefNo, moduleRefId, filename, userCode, userRole, ipAddress));
		commonService.auditLog(authentication.getPrincipal().toString(), request, "COMMON", "SEARCH", "Module Accessed");		
		return "common/FileAttach/FileUploadErrorDetails";
	}
	
	// open email questions in new window
	@RequestMapping(value="/getEmailQuestionsForNewWindow", method=RequestMethod.GET)
	public String getEmailQuestionsForNewWindow(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String caseNo = request.getParameter("caseNo");
		String previousQuestions = request.getParameter("previousQuestions");
		String userCode = authentication.getPrincipal().toString();
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String remoteAddr = request.getRemoteAddr();
		List<Map<String, Object>> output = commonService.getEmailQuestions(caseNo,userCode,userRole,remoteAddr);
		//System.out.println("email questions in controller are = "+output);
		Map<String,Object> groups = commonService.getEmailGroups(caseNo,userCode,userRole,remoteAddr);
		request.setAttribute("CASENO", caseNo);
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("QUESTIONS", output);
		request.setAttribute("GROUPS", groups);
		request.setAttribute("PREVIOUSQUESTIONS", previousQuestions);
		return "common/EmailExchange/emailQuestionsInNewWindow";
	}
	
	@RequestMapping(value="/composeMessageInNewWindow", method = RequestMethod.GET)
	public String composeMessageInNewWindow(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		String caseNo = request.getParameter("caseNo");
		String emailNo = request.getParameter("emailNo");
		String folderType = request.getParameter("folderType");
		String composeType = request.getParameter("composeType");
		//String parentFormId = request.getParameter("parentFormId");
		String CURRENTROLE = request.getSession(false) != null ? (String) request.getSession(false).getAttribute("CURRENTROLE") : "";
		Map<String, String> emailDetails = commonService.composeEmail(caseNo, emailNo, folderType, composeType, 
				authentication.getPrincipal().toString(), CURRENTROLE);
		if(composeType.equals("NEW")){
			emailDetails.put("SUBJECT", emailDetails.get("SUBJECT")+caseNo+", ");
		}
		request.setAttribute("emailDetails", emailDetails);
		request.setAttribute("caseNo", caseNo);
		request.setAttribute("emailNo", emailNo);
		request.setAttribute("folderType", folderType);
		request.setAttribute("composeType", composeType);
		//request.setAttribute("parentFormId", parentFormId);
		//System.out.println(parentFormId);
		return "common/EmailExchange/ComposeMessageInNewWindow";
	}
	
	@RequestMapping(value="/showStaffEmail", method = RequestMethod.POST)
	public String showStaffEmail(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		String reportId = request.getParameter("reportId");
		String reportCaseNo = request.getParameter("reportCaseNo");
		String fromDate = request.getParameter("fromDate");
		String toDate = request.getParameter("toDate");
		String staffAccNo = request.getParameter("staffAccNo");
		String emailNumber = request.getParameter("emailNumber");
		String folderType = request.getParameter("folderType");

		request.setAttribute("reportId", reportId);
		request.setAttribute("reportCaseNo", reportCaseNo);
		request.setAttribute("fromDate", fromDate);
		request.setAttribute("toDate", toDate);
		request.setAttribute("staffAccNo", staffAccNo);
		request.setAttribute("emailNumber", emailNumber);
		request.setAttribute("folderType", folderType);
		//System.out.println(fromDate+", "+toDate+", "+staffAccNo+", "+folderType);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "COMMON", "OPEN", "Module Accessed");
		return "common/StaffEmailExchange/index";
	}
	
	@RequestMapping(value="/showAllStaffMessage", method = RequestMethod.POST)
	public String showAllStaffMessage(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		String caseNo = request.getParameter("caseNo");
		String folder = request.getParameter("folder");
		String userCode = authentication.getPrincipal().toString(); 
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		request.setAttribute("EMAILDETAIL", commonService.getEmailDetails(caseNo, folder, "", authentication.getPrincipal().toString()));
		//System.out.println("EMAILDETAIL = "+commonService.getEmailDetails(caseNo, folder, "", authentication.getPrincipal().toString()));
		request.setAttribute("caseNo", caseNo);
		request.setAttribute("folder", folder);
		request.setAttribute("userCode", userCode);
		request.setAttribute("userRole", userRole);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "COMMON", "READ", "Module Accessed");
		return "common/StaffEmailExchange/ShowAllMessage";
	}
	
	@RequestMapping(value="/showStaffMessage", method = RequestMethod.POST)
	public String showStaffMessage(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		String caseNo = request.getParameter("caseNo");
		String emailNumber = request.getParameter("emailNumber");
		String folder = request.getParameter("folder");
		String userCode = authentication.getPrincipal().toString(); 
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		
		request.setAttribute("EMAILDETAIL", commonService.getEmailDetails(caseNo, folder, emailNumber, authentication.getPrincipal().toString()));
		request.setAttribute("EMAILATTACHMENTS", commonService.getEmailAttachments(caseNo, emailNumber));
		//System.out.println("EMAILDETAIL = "+commonService.getEmailDetails(caseNo, folder, emailNumber, authentication.getPrincipal().toString()));
		request.setAttribute("caseNo", caseNo);
		request.setAttribute("emailNumber", emailNumber);
		request.setAttribute("folder", folder);
		request.setAttribute("userCode", userCode);
		request.setAttribute("userRole", userRole);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "COMMON", "READ", "Module Accessed");
		return "common/StaffEmailExchange/ShowMessage";
	}
	
	
	@RequestMapping(value="/composeStaffMessage", method = RequestMethod.POST)
	public String composeStaffMessage(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		String reportId = request.getParameter("reportId");
		String reportCaseNo = request.getParameter("reportCaseNo");
		String emailNo = request.getParameter("emailNo");
		String folderType = request.getParameter("folderType");
		String composeType = request.getParameter("composeType");
		String userCode = authentication.getPrincipal().toString(); 
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String fromDate = request.getParameter("fromDate");
		String toDate = request.getParameter("toDate");
		String staffAccNo = request.getParameter("staffAccNo");
		//System.out.println("get details for compose = "+reportId+", "+reportRowId+", "+fromDate+", "+toDate+", "+staffAccNo+", "+folderType);
		Map<String, String> emailDetails = commonService.composeStaffEmail(reportCaseNo, reportId, fromDate, toDate, staffAccNo, emailNo, folderType, 
				composeType, authentication.getPrincipal().toString(), userRole);
		if(composeType.equals("NEW")){
			emailDetails.put("SUBJECT", emailDetails.get("SUBJECT"));
		}

		request.setAttribute("emailDetails", emailDetails);
		request.setAttribute("reportId", reportId);
		request.setAttribute("reportCaseNo", reportCaseNo);
		request.setAttribute("emailNo", emailNo);
		request.setAttribute("folderType", folderType);
		request.setAttribute("composeType", composeType);
		request.setAttribute("messageId", emailDetails.get("MESSAGEID"));
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("userCode", userCode);
		request.setAttribute("userRole", userRole);
		request.setAttribute("fromDate", fromDate);
		request.setAttribute("toDate", toDate);
		request.setAttribute("staffAccNo", staffAccNo);
		//System.out.println("From Controller = "+emailDetails);
		return "common/StaffEmailExchange/ComposeMessage";
	}

}

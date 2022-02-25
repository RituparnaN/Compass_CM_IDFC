package com.quantumdataengines.app.compass.dao;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.sql.Blob;
import java.sql.CallableStatement;
import java.sql.Clob;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import oracle.jdbc.OracleTypes;
import oracle.jdbc.proxy.annotation.Pre;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Repository;

import com.quantumdataengines.app.compass.batchservice.SystemBatchJobService;
import com.quantumdataengines.app.compass.model.AuditLog;
import com.quantumdataengines.app.compass.otherservice.OtherCommonService;
import com.quantumdataengines.app.compass.schema.Configuration;
import com.quantumdataengines.app.compass.util.CommonUtil;
import com.quantumdataengines.app.compass.util.ConnectionUtil;

@Repository
public class CommonDAOImpl implements CommonDAO{
	
private static final Logger log = LoggerFactory.getLogger(CommonDAOImpl.class);
	
	@Autowired
	private ConnectionUtil connectionUtil;
	@Autowired
	private SystemBatchJobService systemBatchService;
	@Autowired
	private OtherCommonService commonService;
	
	@Value("${compass.aml.config.schemaName}")
	private String schemaName;
	
	@Override
	public String getUserBranchCode(String userCode){
		String branchCode = "ALL";
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareStatement("SELECT BRANCHCODE FROM TB_USER WHERE USERCODE = ?");
			preparedStatement.setString(1, userCode);
			resultSet = preparedStatement.executeQuery();
			while (resultSet.next()) {
				branchCode = resultSet.getString("BRANCHCODE");
			}
			
		}catch(Exception e){
			log.error("Error while getting user branch code : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return branchCode;
	}
	
	@Override
	public Map<String, String> initilizingDBSystemParameters(Configuration configuration) {
		Map<String, String> systemParameters = new LinkedHashMap<String, String>();
		if(configuration != null){
			Connection connection = connectionUtil.getConnection(configuration.getJndiDetails().getJndiName());
			PreparedStatement preparedStatement = null;
			ResultSet resultSet = null;
			log.debug("intializing system parameters...");
			try{
				preparedStatement = connection.prepareStatement(Query.GETALLSYSTEMPARAMS);
				resultSet = preparedStatement.executeQuery();
				while (resultSet.next()) {
					systemParameters.put(resultSet.getString("PARAMETERNAME"), 
							resultSet.getString("PARAMETERVALUE"));
//					System.out.println(resultSet.getString("PARAMETERNAME")+", "+
//							resultSet.getString("PARAMETERVALUE"));
				}
				
			}catch(Exception e){
				log.error("Error while getting system parameters from database : "+e.getMessage());
				e.printStackTrace();
			}finally{
				connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
			}
		}
		return systemParameters;
	}
	
	@Override
	public Map<String, Map<String, Map<String, Map<String, String>>>> userModule(String userCode, String groupCode){
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		Map<String, Map<String, String>> userAssignedModules = new LinkedHashMap<String, Map<String,String>>();
		Map<String, Map<String, String>> roleAssignedModules = new LinkedHashMap<String, Map<String,String>>();
		Map<String, Map<String, Map<String, Map<String, String>>>> userModules = new LinkedHashMap<String, Map<String, Map<String, Map<String, String>>>>();
		try{
			preparedStatement = connection.prepareStatement(Query.GETUSERSASSIGNEDMODULES);
			preparedStatement.setString(1, userCode);
			preparedStatement.setString(2, groupCode);
			resultSet = preparedStatement.executeQuery();
			while (resultSet.next()) {
				Map<String, String> moduleDetails = new LinkedHashMap<String, String>();
				moduleDetails.put("MODULECODE", resultSet.getString("MODULECODE"));
				moduleDetails.put("MAINORSUBMODULE", resultSet.getString("MAINORSUBMODULE"));
				moduleDetails.put("MAINMODULECODE", resultSet.getString("MAINMODULECODE"));
				userAssignedModules.put(resultSet.getString("MODULECODE"), moduleDetails);
			}
		}catch(Exception e){
			log.error("Error while getting user modules : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		
		connection = connectionUtil.getConnection();
		preparedStatement = null;
		resultSet = null;
		
		if(userAssignedModules.size() > 0){
			log.info("User "+userCode+" from "+groupCode+" has custom modules assigned. Loading modules...");
			Iterator<String> moduleCodeItr = userAssignedModules.keySet().iterator();
			while (moduleCodeItr.hasNext()) {
				String moduleCode = moduleCodeItr.next();
				String mainSubModule = userAssignedModules.get(moduleCode).get("MAINORSUBMODULE");
				String mainModuleCode = userAssignedModules.get(moduleCode).get("MAINMODULECODE");
				
				if(mainSubModule.equalsIgnoreCase("M")){
					if(userModules.containsKey(moduleCode)){
					}else{
						userModules.put(moduleCode, getFullModule(groupCode, moduleCode));
					}
				}else{
					if(userModules.containsKey(mainModuleCode)){
						userModules.get(mainModuleCode).get("SUBMODULE").put(moduleCode, getSubModuleDetails(moduleCode));
					}else{
						List<String> moduleCodes = new ArrayList<String>();
						moduleCodes.add(mainModuleCode);
						moduleCodes.add(moduleCode);
						userModules.put(mainModuleCode, getOnlyMainModuleAndSubModule(moduleCodes));
					}
				}
			}
		}else{
			log.info("Loading modules for User "+userCode+" from "+groupCode+"...");
			try{
				preparedStatement = connection.prepareStatement(Query.GETROLEASSIGNEDMODULES);
				//preparedStatement = connection.prepareStatement(Query.GETROLEASSIGNEDMODULESFORSEARCH)
				preparedStatement.setString(1, groupCode);
				resultSet = preparedStatement.executeQuery();
				while (resultSet.next()) {
					Map<String, String> moduleDetails = new LinkedHashMap<String, String>();
					moduleDetails.put("MODULECODE", resultSet.getString("MODULECODE"));
					moduleDetails.put("MAINORSUBMODULE", resultSet.getString("MAINORSUBMODULE"));
					moduleDetails.put("MAINMODULECODE", resultSet.getString("MAINMODULECODE"));
					roleAssignedModules.put(resultSet.getString("MODULECODE"), moduleDetails);
				}
			}catch(Exception e){
				log.error("Error while getting user modules : "+e.getMessage());
				e.printStackTrace();
			}finally{
				connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
			}
			
			Iterator<String> moduleCodeItr = roleAssignedModules.keySet().iterator();
			while (moduleCodeItr.hasNext()) {
				String moduleCode = moduleCodeItr.next();
				String mainSubModule = roleAssignedModules.get(moduleCode).get("MAINORSUBMODULE");
				String mainModuleCode = roleAssignedModules.get(moduleCode).get("MAINMODULECODE");
				
				if(mainSubModule.equalsIgnoreCase("M")){
					if(userModules.containsKey(moduleCode)){
					}else{
						userModules.put(moduleCode, getFullModule(groupCode, moduleCode));
					}
				}else{
					if(userModules.containsKey(mainModuleCode)){
						userModules.get(mainModuleCode).get("SUBMODULE").put(moduleCode, getSubModuleDetails(moduleCode));
					}else{
						List<String> moduleCodes = new ArrayList<String>();
						moduleCodes.add(mainModuleCode);
						moduleCodes.add(moduleCode);
						userModules.put(mainModuleCode, getOnlyMainModuleAndSubModule(moduleCodes));
					}
				}
			}
		}
		return userModules;
	}
	
	
	private Map<String, String> getSubModuleDetails(String moduleCode){
		Map<String, String> moduleDetails = new LinkedHashMap<String, String>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareStatement(Query.GETMODULEDETAILSBYMODULE);
			preparedStatement.setString(1, moduleCode);
			resultSet = preparedStatement.executeQuery();
			while (resultSet.next()) {
				moduleDetails.put("MODULECODE", resultSet.getString("MODULECODE"));
				moduleDetails.put("MODULENAME", resultSet.getString("MODULENAME"));
				moduleDetails.put("MODULEURL", resultSet.getString("MODULEURL"));
				moduleDetails.put("MAINORSUBMODULE", resultSet.getString("MAINORSUBMODULE"));
				moduleDetails.put("MAINMODULECODE", resultSet.getString("MAINMODULECODE"));
				moduleDetails.put("DISPLAYORDER", resultSet.getString("DISPLAYORDER"));
				moduleDetails.put("ISMULTIPLE", resultSet.getString("ISMULTIPLE"));
			}
		}catch(Exception e){
			log.error("Error while getting user modules : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return moduleDetails;
	}
	
	
	private Map<String, Map<String, Map<String, String>>> getOnlyMainModuleAndSubModule(List<String> moduleCodes){
		Map<String, Map<String, Map<String, String>>> moduleDetails = new LinkedHashMap<String, Map<String, Map<String, String>>>();
		Map<String, Map<String, String>> mainModule = new LinkedHashMap<String, Map<String, String>>();
		Map<String, Map<String, String>> subModule = new LinkedHashMap<String, Map<String, String>>();
		
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			for(String moduleCode : moduleCodes){
				preparedStatement = connection.prepareStatement(Query.GETMODULEDETAILSBYMODULE);
				preparedStatement.setString(1, moduleCode);
				resultSet = preparedStatement.executeQuery();
				while (resultSet.next()) {
					if("M".equals(resultSet.getString("MAINORSUBMODULE"))){
						Map<String, String> module = new HashMap<String, String>();
						module.put("MODULECODE", resultSet.getString("MODULECODE"));
						module.put("MODULENAME", resultSet.getString("MODULENAME"));
						module.put("MODULEURL", resultSet.getString("MODULEURL"));
						module.put("MAINORSUBMODULE", resultSet.getString("MAINORSUBMODULE"));
						module.put("MAINMODULECODE", resultSet.getString("MAINMODULECODE"));
						module.put("DISPLAYORDER", resultSet.getString("DISPLAYORDER"));
						module.put("ISMULTIPLE", resultSet.getString("ISMULTIPLE"));
						mainModule.put(resultSet.getString("MODULECODE"), module);
					}else{
						Map<String, String> module = new HashMap<String, String>();
						module.put("MODULECODE", resultSet.getString("MODULECODE"));
						module.put("MODULENAME", resultSet.getString("MODULENAME"));
						module.put("MODULEURL", resultSet.getString("MODULEURL"));
						module.put("MAINORSUBMODULE", resultSet.getString("MAINORSUBMODULE"));
						module.put("MAINMODULECODE", resultSet.getString("MAINMODULECODE"));
						module.put("DISPLAYORDER", resultSet.getString("DISPLAYORDER"));
						module.put("ISMULTIPLE", resultSet.getString("ISMULTIPLE"));
						subModule.put(resultSet.getString("MODULECODE"), module);
					}
				}
			}			
			moduleDetails.put("MAINMODULE", mainModule);
			moduleDetails.put("SUBMODULE", subModule);
		}catch(Exception e){
			log.error("Error while getting main module and sub module : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return moduleDetails;
	}
	
	private Map<String, Map<String, Map<String, String>>> getFullModule(String groupCode, String mainModuleId){
		Map<String, Map<String, Map<String, String>>> moduleDetails = new LinkedHashMap<String, Map<String, Map<String, String>>>();
		Map<String, Map<String, String>> mainModule = new LinkedHashMap<String, Map<String, String>>();
		Map<String, Map<String, String>> subModule = new LinkedHashMap<String, Map<String, String>>();
		
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareStatement(Query.GETMODULEDETAILSBYMAINMODULE);
			preparedStatement.setString(1, mainModuleId);
			preparedStatement.setString(2, groupCode);
			resultSet = preparedStatement.executeQuery();
			while (resultSet.next()) {
				if("M".equals(resultSet.getString("MAINORSUBMODULE"))){
					Map<String, String> module = new HashMap<String, String>();
					module.put("MODULECODE", resultSet.getString("MODULECODE"));
					module.put("MODULENAME", resultSet.getString("MODULENAME"));
					module.put("MODULEURL", resultSet.getString("MODULEURL"));
					module.put("MAINORSUBMODULE", resultSet.getString("MAINORSUBMODULE"));
					module.put("MAINMODULECODE", resultSet.getString("MAINMODULECODE"));
					module.put("DISPLAYORDER", resultSet.getString("DISPLAYORDER"));
					module.put("ISMULTIPLE", resultSet.getString("ISMULTIPLE"));
					mainModule.put(resultSet.getString("MODULECODE"), module);
				}else{
					Map<String, String> module = new HashMap<String, String>();
					module.put("MODULECODE", resultSet.getString("MODULECODE"));
					module.put("MODULENAME", resultSet.getString("MODULENAME"));
					module.put("MODULEURL", resultSet.getString("MODULEURL"));
					module.put("MAINORSUBMODULE", resultSet.getString("MAINORSUBMODULE"));
					module.put("MAINMODULECODE", resultSet.getString("MAINMODULECODE"));
					module.put("DISPLAYORDER", resultSet.getString("DISPLAYORDER"));
					module.put("ISMULTIPLE", resultSet.getString("ISMULTIPLE"));
					subModule.put(resultSet.getString("MODULECODE"), module);
				}
			}
			moduleDetails.put("MAINMODULE", mainModule);
			moduleDetails.put("SUBMODULE", subModule);
			
		}catch(Exception e){
			log.error("Error while getting user modules : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return moduleDetails;
	}
	
	@Override
	public String changeProfilePriprity(String userCode, String profile){
		String message = "";
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareStatement(Query.CHANGEPROFILEPRIORITY1);
			preparedStatement.setString(1, userCode);
			preparedStatement.executeUpdate();
			
			preparedStatement = connection.prepareStatement(Query.CHANGEPROFILEPRIORITY2);
			preparedStatement.setString(1, userCode);
			preparedStatement.setString(2, profile);
			preparedStatement.executeUpdate();
			message = "Profile priority has been successfully changed. Will reflect on your next login.";
		}catch(Exception e){
			message = "Error while changing user profile priority";
			log.error("Error while changing user profile priority : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return message;
	}
	
	@Override
	public String lastEmailRefresgLog(String folderType){
		String logMassage = "";
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareStatement(Query.GETLASTEMAILREFRESGLOG);
			preparedStatement.setString(1, folderType);
			resultSet = preparedStatement.executeQuery();
			if(resultSet.next()){
				logMassage = folderType+" synchronization "+resultSet.getString("STATUS")+"<br/>"+resultSet.getString("REFRESHTIME");
				String message = resultSet.getString("MESSAGE");
				if("ERROR".equals(resultSet.getString("STATUS"))){
					if(message.length() > 25)
						logMassage = logMassage +", <font color='red'>"+ message.substring(0, 22)+"...</font>";
					else
						logMassage = logMassage +", <font color='red'>"+ message+"</font>";
				}
			}
		}catch(Exception e){
			log.error("Error while getting last email log : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return logMassage;
	}

	@Override
	public List<Map<String, String>> getAllEmailRefreshLog() {
		List<Map<String, String>> resultList = new Vector<Map<String, String>>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareStatement(Query.GETALLEMAILREFRESHLOG);
			resultSet = preparedStatement.executeQuery();
			while (resultSet.next()) {
				Map<String, String> dataMap = new HashMap<String, String>();
				dataMap.put("REFRESHTIME", resultSet.getString("REFRESHTIME"));
				dataMap.put("EMAILCOUNT", resultSet.getString("EMAILCOUNT"));
				dataMap.put("STATUS", resultSet.getString("STATUS"));
				dataMap.put("MESSAGE", resultSet.getString("MESSAGE"));
				dataMap.put("FOLDER", resultSet.getString("FOLDER"));
				dataMap.put("UPDATEDBY", resultSet.getString("UPDATEDBY"));
				resultList.add(dataMap);
			}
		}catch(Exception e){
			log.error("Error while getting all email log : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return resultList;
	}
	
	@Override
	public boolean updateLanguage(String userCode, String langCode){
		boolean isValid = false;
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareStatement("UPDATE TB_USER SET LANGUAGE = ? WHERE USERCODE = ?");
			preparedStatement.setString(1, langCode);
			preparedStatement.setString(2, userCode);
			preparedStatement.executeUpdate();
			isValid = true;
		}catch(Exception e){
			log.error("Error while updating language for user : "+e.getMessage());
			isValid = false;
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return isValid;
	}
	
	@Override
	public boolean updateLabelDirection(String userCode, String labelDirection){
		boolean isValid = false;
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareStatement("UPDATE TB_USER SET LABELDIRECTION = ? WHERE USERCODE = ?");
			preparedStatement.setString(1, labelDirection);
			preparedStatement.setString(2, userCode);
			preparedStatement.executeUpdate();
			isValid = true;
		}catch(Exception e){
			log.error("Error while updating label direction for user : "+e.getMessage());
			isValid = false;
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return isValid;
	}
	
	@Override
	public List<Map<String, String>> updateUsersSessionList(List<Map<String, String>> allUserDetails){
		List<Map<String, String>> allUserUpdatedDetails = new ArrayList<Map<String, String>>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String query = "SELECT FIRSTNAME, LASTNAME FROM TB_USER WHERE USERCODE = ?";
		try{
			for(Map<String, String> userMap : allUserDetails){
				String userCode = userMap.get("USERCODE");
				preparedStatement = connection.prepareStatement(query);
				preparedStatement.setString(1, userCode);
				resultSet = preparedStatement.executeQuery();
				if(resultSet.next()){
					userMap.put("NAME", resultSet.getString("FIRSTNAME")+" "+resultSet.getString("LASTNAME"));
					allUserUpdatedDetails.add(userMap);
				}
			}
		}catch(Exception e){
			log.error("Error while updating details for user : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return allUserUpdatedDetails;
	}
	
	public void refreshEmail(Configuration configuration, String userCode, String emailPassword, int lookupDays, String folderName, 
			String folderType, String emailSearchString, String subjectsToIgnore){
		Connection connection = connectionUtil.getConnection();
		try{
			systemBatchService.emailRefreshJob(connection, configuration, userCode, emailPassword, lookupDays, folderName, folderType, emailSearchString, subjectsToIgnore);
		}catch(Exception e){
			log.error("Error while starting email refresh : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, null, null, null);
		}
	}
	
	@Override
	public Map<String, Map<String, String>> getAllOfflineUser(String allOnLineUsers, String currentUser){
		Map<String, Map<String, String>> offlineMap = new LinkedHashMap<String, Map<String, String>>();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String query = "SELECT USERCODE, FIRSTNAME, LASTNAME FROM TB_USER WHERE USERCODE NOT IN ("+allOnLineUsers+") AND CHATENABLE = 'Y' AND ACCOUNTENABLE = 'Y'";
		
		if(allOnLineUsers != null && allOnLineUsers.length() > 0){
			Connection connection = null;
			try{
				connection = connectionUtil.getConnection();
				preparedStatement = connection.prepareStatement(query);
				resultSet = preparedStatement.executeQuery();
				while(resultSet.next()){
					String chatWindowId = commonService.getChatWindowId(currentUser, resultSet.getString("USERCODE"));
					Map<String, Integer> messageInfo = getMessageMaxNoANDUnSeenCount(chatWindowId.replace(".", ""), currentUser);
					int messageUnseenCount = messageInfo.get("UNSEENMESSAGECOUNT");
					
					Map<String, String> userMap = new HashMap<String, String>();
					userMap.put("USERCODE", resultSet.getString("USERCODE"));
					userMap.put("USERNAME", resultSet.getString("FIRSTNAME")+" "+resultSet.getString("LASTNAME"));
					userMap.put("STATUS", "O");
					userMap.put("CHATWINDOWID", chatWindowId);
					
					userMap.put("MESSAGEMAXNO", new Integer(messageInfo.get("MESSAGEMAXNO")).toString());
					if(messageUnseenCount > 0)
						userMap.put("UNSEENMESSAGECOUNT", new Integer(messageInfo.get("UNSEENMESSAGECOUNT")).toString());
					else
						userMap.put("UNSEENMESSAGECOUNT", "");
					offlineMap.put(resultSet.getString("USERCODE"), userMap);
				}
			}catch(Exception e){
				log.error("Error while updating details for user : "+e.getMessage());
				e.printStackTrace();
			}finally{
				connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
			}
			
		}
		return offlineMap;
	}
	
	
	public Map<String, Integer> getMessageMaxNoANDUnSeenCount(String chatWindowId, String userCode){
		int messageMaxNo = 0;
		int unseenCount = 0;
		Map<String, Integer> resultMap = new HashMap<String, Integer>();
		Connection connection = connectionUtil.getConnection();
		CallableStatement callableStatement = null;
		ResultSet resultSet = null;
		try{
			callableStatement = connection.prepareCall("{CALL "+schemaName+"STP_GETCHATMAXNOANDUNSEENCOUNT(?,?,?)}");
			callableStatement.setString(1, chatWindowId);
			callableStatement.setString(2, userCode);
			callableStatement.registerOutParameter(3, OracleTypes.CURSOR);
			callableStatement.execute();
			resultSet = (ResultSet) callableStatement.getObject(3);
			if(resultSet.next()){
				messageMaxNo = resultSet.getInt("MSGMAXNO");
				unseenCount = resultSet.getInt("UNSEENMSGCOUNT");
			}
			
		}catch(Exception e){
			log.error("Error while getting message info : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, callableStatement, resultSet, null);
		}
		resultMap.put("MESSAGEMAXNO", messageMaxNo);
		resultMap.put("UNSEENMESSAGECOUNT", unseenCount);
		return resultMap;
	}
	
	public String getMessageMaxNo(String chatWindowId){
		String messageMaxNo = "0";
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String query = "SELECT NVL(MAX(MESSAGESEQNO),0) MESSAGESEQNO FROM TB_CHATMESSAGES WHERE CHATWINDOWID = ?";
		try{
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, chatWindowId);
			resultSet = preparedStatement.executeQuery();
			if(resultSet.next())
				messageMaxNo = new Integer(resultSet.getInt("MESSAGESEQNO")).toString();
		}catch(Exception e){
			log.error("Error while getting message max no : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return messageMaxNo;
	}

	@Override
	public void saveChatMessage(String jndiName, String chatWindowId, String messageId, String fromUser, String toUser, String messageContent, String seenFlag) {
		int messageSeqNo = 0;
		Connection connection = connectionUtil.getConnection(jndiName);
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String query = "SELECT NVL(MAX(MESSAGESEQNO),0)+1 AS MESSAGESEQNO FROM TB_CHATMESSAGES WHERE CHATWINDOWID = ?";
		try{
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, chatWindowId);
			resultSet = preparedStatement.executeQuery();
			if(resultSet.next())
				messageSeqNo = resultSet.getInt("MESSAGESEQNO");
			
			query = "INSERT INTO TB_CHATMESSAGES(MESSAGESEQNO,CHATWINDOWID,MESSAGEID,FROMUSER,TOUSER,MESSAGECONTENT,MESSAGETIMESTAMP,SEENFLAG) "+
					"VALUES (?,?,?,?,?,?,SYSTIMESTAMP,?)";
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setInt(1, messageSeqNo);
			preparedStatement.setString(2, chatWindowId);
			preparedStatement.setString(3, messageId);
			preparedStatement.setString(4, fromUser);
			preparedStatement.setString(5, toUser);
			preparedStatement.setString(6, messageContent);
			preparedStatement.setString(7, seenFlag);
			preparedStatement.executeUpdate();
		}catch(Exception e){
			log.error("Error while saving chat message : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
	}
	
	public String loadPreviuosMessage(String chatWindowId, String userCode, int messageMaxNo, int messageminNo){
		String htmlString = "";
		if(messageminNo > 0){
			htmlString = "<li class=\"clearfix\"><center><em><a href=\"javascript:void(0)\" onclick=\"loadPreviosMessages('"+chatWindowId+"', '"+messageminNo+"',true)\">Load more message</a></em></center></li>";
		}else{
			htmlString = "<li><center><em>No more message available</em></center></li>";
		}
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String query = "SELECT MESSAGESEQNO, CHATWINDOWID, MESSAGEID, "+
					   "       FROMUSER, (SELECT FIRSTNAME ||' '|| LASTNAME FROM TB_USER WHERE USERCODE = FROMUSER) AS FROMUSERNAME, "+
					   "       TOUSER, (SELECT FIRSTNAME ||' '|| LASTNAME FROM TB_USER WHERE USERCODE = TOUSER) AS TOUSERNAME, "+
					   "	   MESSAGECONTENT, TO_CHAR(MESSAGETIMESTAMP, 'DD/MM/YYYY HH24:MI:SS') AS MESSAGETIMESTAMP "+
					   "  FROM TB_CHATMESSAGES "+
					   " WHERE CHATWINDOWID = ? "+
					   "   AND MESSAGESEQNO > ? "+
					   "   AND MESSAGESEQNO <= ? "+
					   " ORDER BY MESSAGESEQNO ASC";
		String seenQuery = "UPDATE TB_CHATMESSAGES SET SEENFLAG = 'Y' WHERE TOUSER = ? AND CHATWINDOWID = ?";
		try{
			preparedStatement = connection.prepareStatement(seenQuery);
			preparedStatement.setString(1, userCode);
			preparedStatement.setString(2, chatWindowId);
			preparedStatement.executeUpdate();
			
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, chatWindowId);
			preparedStatement.setInt(2, messageminNo);
			preparedStatement.setInt(3, messageMaxNo);
			resultSet = preparedStatement.executeQuery();
			while (resultSet.next()) {
				if(resultSet.getString("FROMUSER").equals(userCode)){
					htmlString = htmlString+"<li class=\"clearfix\"><div class=\"chat-body clearfix\"><div class=\"header\">";
					htmlString = htmlString+"<strong class=\"pull-right  primary-font\">ME</strong>";
					htmlString = htmlString+"<small class=\"pull-left text-muted\"><i class=\"fa fa-clock-o fa-fw\"></i>"+resultSet.getString("MESSAGETIMESTAMP")+"</small>";
					htmlString = htmlString+"</div><br/><p class=\"pull-right\">"+resultSet.getString("MESSAGECONTENT")+"</p></div></li>";
				}else{
					htmlString = htmlString+"<li class=\"clearfix\"><div class=\"chat-body clearfix\"><div class=\"header\">";
					htmlString = htmlString+"<strong class=\"pull-left  primary-font\">"+resultSet.getString("FROMUSERNAME")+"</strong>";
					htmlString = htmlString+"<small class=\"pull-right text-muted\"><i class=\"fa fa-clock-o fa-fw\"></i>"+resultSet.getString("MESSAGETIMESTAMP")+"</small>";
					htmlString = htmlString+"</div><br/><p>"+resultSet.getString("MESSAGECONTENT")+"</p></div></li>";
				}
			}
		}catch(Exception e){
			log.error("Error while loading previos message : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return htmlString;
	}
	
	@SuppressWarnings("resource")
	public String loadUnseenMessage(String chatWindowId, String userCode){
		String htmlString = "";
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String query = "SELECT MESSAGESEQNO, CHATWINDOWID, MESSAGEID, "+
					   "       FROMUSER, (SELECT FIRSTNAME ||' '|| LASTNAME FROM TB_USER WHERE USERCODE = FROMUSER) AS FROMUSERNAME, "+
					   "       TOUSER, (SELECT FIRSTNAME ||' '|| LASTNAME FROM TB_USER WHERE USERCODE = TOUSER) AS TOUSERNAME, "+
					   "	   MESSAGECONTENT, TO_CHAR(MESSAGETIMESTAMP, 'DD/MM/YYYY HH24:MI:SS') AS MESSAGETIMESTAMP "+
					   "  FROM TB_CHATMESSAGES "+
					   " WHERE CHATWINDOWID = ? "+
					   "   AND SEENFLAG = 'N' "+
					   " ORDER BY MESSAGESEQNO ASC";
		String seenQuery = "UPDATE TB_CHATMESSAGES SET SEENFLAG = 'Y' WHERE TOUSER = ? AND CHATWINDOWID = ?";
		try{
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, chatWindowId);
			resultSet = preparedStatement.executeQuery();
			while (resultSet.next()) {
				if(resultSet.getString("FROMUSER").equals(userCode)){
					htmlString = htmlString+"<li class=\"clearfix\"><div class=\"chat-body clearfix\"><div class=\"header\">";
					htmlString = htmlString+"<strong class=\"pull-right  primary-font\">ME</strong>";
					htmlString = htmlString+"<small class=\"pull-left text-muted\"><i class=\"fa fa-clock-o fa-fw\"></i>"+resultSet.getString("MESSAGETIMESTAMP")+"</small>";
					htmlString = htmlString+"</div><br/><p class=\"pull-right\">"+resultSet.getString("MESSAGECONTENT")+"</p></div></li>";
				}else{
					htmlString = htmlString+"<li class=\"clearfix\"><div class=\"chat-body clearfix\"><div class=\"header\">";
					htmlString = htmlString+"<strong class=\"pull-left  primary-font\">"+resultSet.getString("FROMUSERNAME")+"</strong>";
					htmlString = htmlString+"<small class=\"pull-right text-muted\"><i class=\"fa fa-clock-o fa-fw\"></i>"+resultSet.getString("MESSAGETIMESTAMP")+"</small>";
					htmlString = htmlString+"</div><br/><p>"+resultSet.getString("MESSAGECONTENT")+"</p></div></li>";
				}
			}
			
			preparedStatement = connection.prepareStatement(seenQuery);
			preparedStatement.setString(1, userCode);
			preparedStatement.setString(2, chatWindowId);
			preparedStatement.executeUpdate();
		}catch(Exception e){
			log.error("Error while loading previos message : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return htmlString;
	}
	
	public String getFolderEmailCount(String folderType, String caseNo){
		String emailCount = "0";
		/*
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String sql = "SELECT COUNT(1) EMAILCOUNT FROM TB_EMAILEXCHANGEDETAILS "+
					 " WHERE FOLDERTYPE = ? "+
					 "   AND EMAILREFERENCENO = ? ";
		if(folderType.equals("INBOX")){
			sql = sql + " AND SEENFLAG = 'N'";
		}
		try{
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, folderType);
			preparedStatement.setString(2, caseNo);
			resultSet = preparedStatement.executeQuery();
			if(resultSet.next())
				emailCount = resultSet.getString("EMAILCOUNT");
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		*/
		return emailCount;
	}
	
	public List<Map<String, String>> getEmailNotification(String userCode, String seenFlag){
		List<Map<String, String>> emailNotification = new Vector<Map<String, String>>();
		/*
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String sql = "";
		try{
			sql = "SELECT EMAILREFERENCENO CASENO, MESSAGEINTERNALNO, SENDERID, SUBJECT, FOLDERTYPE, TO_CHAR(UPDATETIMESTAMP, 'DD/MM/YYYY HH24:MI:SS') UPDATETIMESTAMP "+
				  "  FROM TB_EMAILEXCHANGEDETAILS "+
				  " WHERE EMAILREFERENCENO IN ( "+
				  " SELECT CASENO FROM "+schemaName+"TB_CASEWORKFLOWDETAILS WHERE USERCODE = ? "+
				  "  UNION "+
				  " SELECT CASENO FROM "+schemaName+"TB_CASEWORKFLOWDETAILS WHERE AMLUSERCODE = ? "+
				  "  UNION "+
				  " SELECT CASENO FROM "+schemaName+"TB_CASEWORKFLOWDETAILS WHERE AMLOUSERCODE = ? "+
				  "  UNION "+
				  " SELECT CASENO FROM "+schemaName+"TB_CASEWORKFLOWDETAILS WHERE MLROUSERCODE = ? "+
				  "  UNION "+
				  " SELECT CASENO FROM "+schemaName+"TB_FATCACASEWORKFLOWDETAILS WHERE USERCODE = ? "+
				  "  UNION "+
				  " SELECT CASENO FROM "+schemaName+"TB_FATCACASEWORKFLOWDETAILS WHERE AMLUSERCODE = ? "+
				  "  UNION "+
				  " SELECT CASENO FROM "+schemaName+"TB_FATCACASEWORKFLOWDETAILS WHERE AMLOUSERCODE = ? "+
				  "  UNION "+
				  " SELECT CASENO FROM "+schemaName+"TB_FATCACASEWORKFLOWDETAILS WHERE MLROUSERCODE = ? "+
				  " ) "+
				  "   AND SEENFLAG = ? "+
				  "   AND FOLDERTYPE = 'INBOX' "+
				  " ORDER BY UPDATETIMESTAMP DESC ";
			
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, userCode);
			preparedStatement.setString(2, userCode);
			preparedStatement.setString(3, userCode);
			preparedStatement.setString(4, userCode);
			preparedStatement.setString(5, userCode);
			preparedStatement.setString(6, userCode);
			preparedStatement.setString(7, userCode);
			preparedStatement.setString(8, userCode);
			preparedStatement.setString(9, seenFlag);
			resultSet = preparedStatement.executeQuery();
			while (resultSet.next()) {
				Map<String, String> emailDetails = new HashMap<String, String>();
				emailDetails.put("CASENO", resultSet.getString("CASENO"));
				emailDetails.put("MESSAGEINTERNALNO", resultSet.getString("MESSAGEINTERNALNO"));
				emailDetails.put("SENDERID", resultSet.getString("SENDERID"));
				emailDetails.put("SUBJECT", resultSet.getString("SUBJECT"));
				emailDetails.put("FOLDERTYPE", resultSet.getString("FOLDERTYPE"));
				emailDetails.put("UPDATETIMESTAMP", resultSet.getString("UPDATETIMESTAMP"));
				emailNotification.add(emailDetails);
			}
		}catch(Exception e){
			System.out.println("Error While executing the query, sql: "+sql);
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		*/
		/*
		Connection connection = connectionUtil.getConnection();
		System.out.println("connection : "+connection+"  userCode:  "+userCode+"  seenFlag: "+seenFlag);
		
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String sql = "";
		try{
			sql = "SELECT A.EMAILREFERENCENO CASENO, A.MESSAGEINTERNALNO, A.SENDERID, "+
		          "       A.SUBJECT, A.FOLDERTYPE, TO_CHAR(A.UPDATETIMESTAMP, 'DD/MM/YYYY HH24:MI:SS') UPDATETIMESTAMP "+
				  "  FROM TB_EMAILEXCHANGEDETAILS A, "+schemaName+"TB_CASEWORKFLOWDETAILS B "+
				  " WHERE A.EMAILREFERENCENO = B.CASENO "+
				  "   AND B.ASSIGNEDUSERCODE = ? "+
				  "   AND SEENFLAG = ? "+
				  "   AND FOLDERTYPE = 'INBOX' "+
				  " ORDER BY UPDATETIMESTAMP DESC ";
			System.out.println("sql : "+sql);
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, userCode);
			preparedStatement.setString(2, seenFlag);
			resultSet = preparedStatement.executeQuery();
			while (resultSet.next()) {
				Map<String, String> emailDetails = new HashMap<String, String>();
				emailDetails.put("CASENO", resultSet.getString("CASENO"));
				emailDetails.put("MESSAGEINTERNALNO", resultSet.getString("MESSAGEINTERNALNO"));
				emailDetails.put("SENDERID", resultSet.getString("SENDERID"));
				emailDetails.put("SUBJECT", resultSet.getString("SUBJECT"));
				emailDetails.put("FOLDERTYPE", resultSet.getString("FOLDERTYPE"));
				emailDetails.put("UPDATETIMESTAMP", resultSet.getString("UPDATETIMESTAMP"));
				emailNotification.add(emailDetails);
			}
		}catch(Exception e){
			System.out.println("Error While executing the query, sql: "+sql);
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		*/
		return emailNotification;
	}
	
	public Map<String, Object> getFileUploadConfig(String moduleRef){
		Map<String, Object> fileUploadConfig = new HashMap<String, Object>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String query = "SELECT MODULEREF, MODULENAME, FILEMAXSIZE, FOLDERNAME, ALLOWFILETYPES, BLOCKFILETYPES, "+
					   "	   SELECTFILECOUNT, READFLAG, DELIMITER, TEMPTABLE, ATTACHFILEURL, PROCESSPROCEDURE "+
					   "  FROM "+schemaName+"TB_FILEUPLOADCONFIG "+
					   " WHERE MODULEREF = ?";
		try{
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, moduleRef);
			resultSet = preparedStatement.executeQuery();
			while (resultSet.next()) {
				fileUploadConfig.put("MODULEREF", resultSet.getString("MODULEREF"));
				fileUploadConfig.put("MODULENAME", resultSet.getString("MODULENAME"));
				fileUploadConfig.put("FILEMAXSIZE", resultSet.getString("FILEMAXSIZE"));
				fileUploadConfig.put("FOLDERNAME", resultSet.getString("FOLDERNAME"));
				fileUploadConfig.put("ALLOWFILETYPES", resultSet.getString("ALLOWFILETYPES"));
				fileUploadConfig.put("BLOCKFILETYPES", resultSet.getString("BLOCKFILETYPES"));
				fileUploadConfig.put("SELECTFILECOUNT", resultSet.getString("SELECTFILECOUNT"));
				fileUploadConfig.put("READFLAG", resultSet.getString("READFLAG"));
				fileUploadConfig.put("DELIMITER", resultSet.getString("DELIMITER"));
				fileUploadConfig.put("TEMPTABLE", resultSet.getString("TEMPTABLE"));
				fileUploadConfig.put("ATTACHFILEURL", resultSet.getString("ATTACHFILEURL"));
				fileUploadConfig.put("PROCESSPROCEDURE", resultSet.getString("PROCESSPROCEDURE"));
			}
		}catch(Exception e){
			log.error("Error while loading previous message : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return fileUploadConfig;
	}
	
	private String changeFileName(String fileName, String uploadRef, String moduleUnqNo){
		String onlyFileName = fileName.substring(0, fileName.lastIndexOf("."));
		String ext =  fileName.substring(fileName.lastIndexOf("."));
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String query = "SELECT COUNT(1) FILECOUNT FROM "+schemaName+"TB_FILEUPLOADLOG WHERE FILENAME LIKE '"+onlyFileName+"%' ";
		
		if(moduleUnqNo != null && moduleUnqNo != "" && moduleUnqNo.trim().length() > 0){
			query = query + " AND MODULEUNQNO = '"+moduleUnqNo+"' ";
		}else{
			query = query + " AND UPLOADREFNO = '"+uploadRef+"' ";
		}
		
		try{
			preparedStatement = connection.prepareStatement(query);
			resultSet = preparedStatement.executeQuery();
			if(resultSet.next()){
				int count = resultSet.getInt("FILECOUNT");
				if(count > 0){
					onlyFileName = onlyFileName + " ("+count+")";
				}
			}
		}catch(Exception e){
			log.error("Error while saving file in db "+e.getMessage());
			e.printStackTrace();
		}finally {
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		
		return onlyFileName+ext;
	}
	
	public void saveUploadedFile(String uploadSeqNo, String uploadRef, String uploadModuleRefId, String moduleUnqNo, String fileName, String filePath, String fileSize, 
			File file, String userCode, String userRole, String ipAddress){		
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String query = "INSERT INTO "+schemaName+"TB_FILEUPLOADLOG(SEQNO, UPLOADREFNO, MODULEREF, MODULEUNQNO, FILENAME, FILEPATH, FILESIZE, FILECONTENT, "+
					   "	   UPLOADEDBY, UPLOADERROLE, TERMINALID, UPLOADTIMESTMP) "+
					   "VALUES (?,?,?,?,?,?,?,?,?,?,?,SYSTIMESTAMP)";
		try{
			if(moduleUnqNo == null)
				moduleUnqNo = uploadRef;
			else if(moduleUnqNo != null && moduleUnqNo.equalsIgnoreCase(""))
				moduleUnqNo = uploadRef;
			
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, uploadSeqNo);
			preparedStatement.setString(2, uploadRef);
			preparedStatement.setString(3, uploadModuleRefId);
			preparedStatement.setString(4, moduleUnqNo);
			preparedStatement.setString(5, changeFileName(fileName, uploadRef, moduleUnqNo));
			preparedStatement.setString(6, filePath);
			preparedStatement.setString(7, fileSize);
			
			FileInputStream fis = new FileInputStream(file);
			preparedStatement.setBinaryStream(8, fis, fis.available());
			preparedStatement.setString(9, userCode);
			preparedStatement.setString(10, userRole);
			preparedStatement.setString(11, ipAddress);
			preparedStatement.executeUpdate();
			fis.close();
		}catch(Exception e){
			log.error("Error while saving file in db "+e.getMessage());
			e.printStackTrace();
		}finally {
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
	}
	
	public String saveUploadFileData(String uploadRefNo, String moduleRefId, List<List<String>> uploadedData, String tempTable, int dataColCount, 
			File file, String fileName, String userCode, String userRole, String ipAddress){
		String resultMessage = "Process Started";
		String sql = "INSERT INTO "+schemaName+""+tempTable+" VALUES(";
		for(int i = 1; i <=  dataColCount; i++){
			sql = sql + "?, ";
		}
		sql = sql + "?, ?, ?, ?, ?, ?, SYSTIMESTAMP, SEQ_UPLOADEDFILERECORD.NEXTVAL)";
		// System.out.println("SQL:  "+sql);
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		//String errorMessage = "";
		try{
			preparedStatement = connection.prepareStatement(sql);
			for(List<String> recordData : uploadedData){
				int colIndex = 0;
				for(int i = 0; i < recordData.size(); i++){
					colIndex = i + 1;
					preparedStatement.setString(colIndex, recordData.get(i));
				}
				colIndex = colIndex + 1;
				preparedStatement.setString(colIndex, uploadRefNo);
				colIndex = colIndex + 1;
				preparedStatement.setString(colIndex, moduleRefId);
				colIndex = colIndex + 1;
				preparedStatement.setString(colIndex, uploadRefNo);
				colIndex = colIndex + 1;
				preparedStatement.setString(colIndex, userCode);
				colIndex = colIndex + 1;
				preparedStatement.setString(colIndex, userRole);
				colIndex = colIndex + 1;
				preparedStatement.setString(colIndex, ipAddress);
				preparedStatement.addBatch();
			}
			preparedStatement.executeBatch();
			resultMessage = setFileUploadMakerLog(moduleRefId, uploadRefNo, file, fileName, tempTable ,userCode, userRole, ipAddress);
			
		}catch(Exception e){
			log.error("Error while saving data from file in db "+e.getMessage());
			//errorMessage = "Error while saving data from file in db "+e.getMessage();
			e.printStackTrace();
		}finally {
			connectionUtil.closeResources(connection, preparedStatement, null, null);
		}
		return resultMessage;
	}
	
	// public boolean executeFileUploadProcedures(String procedureName, String uploadRefNo, String moduleRefId, String tempTableName, String fileName, String filePath, String userCode, String userRole, String ipAddress) {
	public String executeFileUploadProcedures(String procedureName, String uploadRefNo, String moduleRefId, String tempTableName, String fileName, String filePath, String userCode, String userRole, String ipAddress) {
		boolean executed = false;
		Connection connection = connectionUtil.getConnection();
		CallableStatement callableStatement = null;
		ResultSet resultSet = null;
		String message = "";
		try{
			callableStatement = connection.prepareCall("{CALL "+schemaName+""+procedureName+"(:UPLOADREFERENCNO, :MODULEREFERENCEID, :TEMPORARYTABLENAME, :FILENAME, :FILEPATH, :USERCODE, :USERROLE, :IPADDRESS, :RESULTSET)}");
			callableStatement.setString("UPLOADREFERENCNO", uploadRefNo);
			callableStatement.setString("MODULEREFERENCEID", moduleRefId);
			callableStatement.setString("TEMPORARYTABLENAME", tempTableName);
			callableStatement.setString("FILENAME", fileName);
			callableStatement.setString("FILEPATH", filePath);
			callableStatement.setString("USERCODE", userCode);
			callableStatement.setString("USERROLE", userRole);
			callableStatement.setString("IPADDRESS", ipAddress);
			callableStatement.registerOutParameter("RESULTSET", OracleTypes.CURSOR);
			callableStatement.execute();
			
			resultSet = (ResultSet) callableStatement.getObject("RESULTSET");
			while(resultSet.next()){
				message = resultSet.getString(1);
			}
			// System.out.println("message: "+message);
			log.error("message in executeFileUploadProcedures: "+message);
			executed = true;
		}catch(Exception e){
			log.error("Error while saving file in db "+e.getMessage());
			message = "Error while saving file in db ";
			e.printStackTrace();
		}finally {
			connectionUtil.closeResources(connection, callableStatement, null, null);
		}
		return message;
	}
	
	public List<Map<String, String>> getFileInfo(String uploadRef, String uploadModuleRefId, String moduleUnqNo){
		List<Map<String, String>> fileInfoList = new Vector<Map<String,String>>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String query = "SELECT A.SEQNO, A.UPLOADREFNO, A.MODULEREF, B.MODULENAME, A.MODULEUNQNO, A.FILENAME, A.FILEPATH, A.FILESIZE, A.FILECONTENT, "+
					   "	   A.UPLOADEDBY, A.UPLOADERROLE, A.TERMINALID, "+
					   "	   CASE A.UPLOADREFNO WHEN ? THEN 'JUST NOW' ELSE FUN_DATETOCHAR(A.UPLOADTIMESTMP) END UPLOADTIMESTMP "+
					   "  FROM "+schemaName+"TB_FILEUPLOADLOG A "+
					   "  LEFT OUTER JOIN "+schemaName+"TB_FILEUPLOADCONFIG B ON A.MODULEREF = B.MODULEREF "+
					   " WHERE 1 = 1";
		if(moduleUnqNo != null && moduleUnqNo != "" && moduleUnqNo.trim().length() > 0){
			query = query + " AND MODULEUNQNO = '"+moduleUnqNo+"' ";
		}else{
			query = query + " AND A.UPLOADREFNO = '"+uploadRef+"' AND A.MODULEREF = '"+uploadModuleRefId+"' ";
		}
					   
		query = query + " ORDER BY A.UPLOADTIMESTMP ASC ";
		try{
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, uploadRef);
			resultSet = preparedStatement.executeQuery();
			while (resultSet.next()) {
				double size = Integer.parseInt(resultSet.getString("FILESIZE"));
				double d_size = size / 1024;
				Map<String, String> fileInfoMap = new HashMap<String, String>();
				fileInfoMap.put("SEQNO", resultSet.getString("SEQNO"));
				fileInfoMap.put("UPLOADREFNO", resultSet.getString("UPLOADREFNO"));
				fileInfoMap.put("MODULEREF", resultSet.getString("MODULEREF"));
				fileInfoMap.put("MODULENAME", resultSet.getString("MODULENAME"));
				fileInfoMap.put("MODULEUNQNO", resultSet.getString("MODULEUNQNO"));
				fileInfoMap.put("FILENAME", resultSet.getString("FILENAME"));
				fileInfoMap.put("FILEPATH", resultSet.getString("FILEPATH"));
				fileInfoMap.put("FILESIZE", (new DecimalFormat("0.00").format(d_size))+" KB");
				fileInfoMap.put("UPLOADEDBY", resultSet.getString("UPLOADEDBY"));
				fileInfoMap.put("UPLOADERROLE", resultSet.getString("UPLOADERROLE"));
				fileInfoMap.put("TERMINALID", resultSet.getString("TERMINALID"));
				fileInfoMap.put("UPLOADTIMESTMP", resultSet.getString("UPLOADTIMESTMP"));
				fileInfoList.add(fileInfoMap);
			}
		}catch(Exception e){
			log.error("Error while saving file in db "+e.getMessage());
			e.printStackTrace();
		}finally {
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return fileInfoList;
	}
	
	public List<Map<String, String>> getFilesInfoForModuleUnqNo(String moduleRefNo){
		List<Map<String, String>> fileInfoList = new Vector<Map<String,String>>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String query = "SELECT A.SEQNO, A.UPLOADREFNO, A.MODULEREF, A.FILENAME, A.FILEPATH, A.FILESIZE, A.FILECONTENT, "+
					   "	   A.UPLOADEDBY, A.UPLOADERROLE, A.TERMINALID, FUN_DATETOCHAR(A.UPLOADTIMESTMP) UPLOADTIMESTMP "+
					   "  FROM "+schemaName+"TB_FILEUPLOADLOG A "+
					   " WHERE A.MODULEUNQNO = ? ";
		try{
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, moduleRefNo);
			resultSet = preparedStatement.executeQuery();
			while (resultSet.next()) {
				double size = Integer.parseInt(resultSet.getString("FILESIZE"));
				double d_size = size / 1024;
				Map<String, String> fileInfoMap = new HashMap<String, String>();
				fileInfoMap.put("SEQNO", resultSet.getString("SEQNO"));
				fileInfoMap.put("UPLOADREFNO", resultSet.getString("UPLOADREFNO"));
				fileInfoMap.put("MODULEREF", resultSet.getString("MODULEREF"));
				fileInfoMap.put("FILENAME", resultSet.getString("FILENAME"));
				fileInfoMap.put("FILEPATH", resultSet.getString("FILEPATH"));
				fileInfoMap.put("FILESIZE", (new DecimalFormat("0.00").format(d_size))+" KB");
				fileInfoMap.put("UPLOADEDBY", resultSet.getString("UPLOADEDBY"));
				fileInfoMap.put("UPLOADERROLE", resultSet.getString("UPLOADERROLE"));
				fileInfoMap.put("TERMINALID", resultSet.getString("TERMINALID"));
				fileInfoMap.put("UPLOADTIMESTMP", resultSet.getString("UPLOADTIMESTMP"));
				fileInfoList.add(fileInfoMap);
			}
		}catch(Exception e){
			log.error("Error while saving file in db "+e.getMessage());
			e.printStackTrace();
		}finally {
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return fileInfoList;
	}
	
	@SuppressWarnings("resource")
	public int truncateAndGetTempTableColCount(String tableName){
		int colCount = 0;
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareStatement("TRUNCATE TABLE "+tableName);
			System.out.println(tableName);
			preparedStatement.execute();
			
			preparedStatement = connection.prepareStatement("SELECT COUNT(1) COLCOUNT FROM USER_TAB_COLUMNS WHERE TABLE_NAME = ?");
			preparedStatement.setString(1, tableName);
			resultSet = preparedStatement.executeQuery();
			if(resultSet.next())
				colCount = resultSet.getInt("COLCOUNT");
		}catch(Exception e){
			log.error("Error while saving file in db "+e.getMessage());
			e.printStackTrace();
		}finally {
			connectionUtil.closeResources(connection, preparedStatement, null, null);
		}
		return colCount;
	}
	
	public boolean processCCRUploadedFile(String procName, String uploadRefId, String moduleRefId, String month, String year,
			String userCode, String roleCode, String ipAddress){
		boolean executed = false;
		Connection connection = connectionUtil.getConnection();
		CallableStatement callableStatement = null;
		try{
			callableStatement = connection.prepareCall("{CALL "+procName+"(?,?,?,?,?,?,?)}");
			callableStatement.setString(1, uploadRefId);
			callableStatement.setString(2, moduleRefId);
			callableStatement.setString(3, month);
			callableStatement.setString(4, year);
			callableStatement.setString(5, userCode);
			callableStatement.setString(6, roleCode);
			callableStatement.setString(7, ipAddress);
			callableStatement.execute();
			executed = true;
		}catch(Exception e){
			log.error("Error while saving file in db "+e.getMessage());
			e.printStackTrace();
		}finally {
			connectionUtil.closeResources(connection, callableStatement, null, null);
		}
		return executed;
	}
	
	public List<Map<String, Object>> getFileContentForDownload(String seqNo, String uploadInfo, String moduleUnqNo){
		List<Map<String, Object>> fileContent = new ArrayList<Map<String, Object>>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String sql = "SELECT FILENAME, FILECONTENT "+
					 "  FROM "+schemaName+"TB_FILEUPLOADLOG "+
					 " WHERE 1 = 1 ";
		if(seqNo != null && seqNo.length() > 0){
			sql = sql + " AND SEQNO = '"+seqNo+"' ";
		}
		if(uploadInfo != null && uploadInfo.length() > 0){
			sql = sql + " AND UPLOADREFNO = '"+uploadInfo+"' ";
		}
		if(moduleUnqNo != null && moduleUnqNo.length() > 0){
			sql = sql + " AND MODULEUNQNO = '"+moduleUnqNo+"' ";
		}
		try{
			connection = connectionUtil.getConnection();
			preparedStatement = connection.prepareStatement(sql);
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()){				
				Map<String, Object> fileInfo = new HashMap<String, Object>();
				fileInfo.put("FILENAME", resultSet.getString("FILENAME"));
				Blob blob = resultSet.getBlob("FILECONTENT");
				int blobLength = (int) blob.length();
				fileInfo.put("FILECONTENT", blob.getBytes(1, blobLength));
				fileContent.add(fileInfo);
				blob.free();
			}
		}catch(Exception e){
			log.error("Error while getting file for download "+e.getMessage());
			e.printStackTrace();
		}finally {
			connectionUtil.closeResources(connection, preparedStatement, null, null);
		}
		return fileContent;
	}
	
	public List<Map<String, Object>> downloadEmailAttachment(String caseNo, String messageNumber, String attachmentNumebr){
		List<Map<String, Object>> fileContent = new ArrayList<Map<String, Object>>();
		
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String sql = "SELECT FILENAME, FILECONTENT "+
					 "  FROM TB_EMAILATTACHMENTDETAILS "+
					 " WHERE EMAILREFERENCENO = '"+caseNo+"' ";
		
		if(messageNumber != null && messageNumber.length() > 0){
			sql = sql + " AND MESSAGEINTERNALNO = '"+messageNumber+"' ";
		}
		
		if(attachmentNumebr != null && attachmentNumebr.length() > 0){
			sql = sql + " AND ATTACHMENTNO = '"+attachmentNumebr+"' ";
		}
				
		try{
			connection = connectionUtil.getConnection();
			preparedStatement = connection.prepareStatement(sql);
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()){				
				Map<String, Object> fileInfo = new HashMap<String, Object>();
				fileInfo.put("FILENAME", resultSet.getString("FILENAME"));
				Blob blob = resultSet.getBlob("FILECONTENT");
				int blobLength = (int) blob.length();
				fileInfo.put("FILECONTENT", blob.getBytes(1, blobLength));
				fileContent.add(fileInfo);
				blob.free();
			}
		}catch(Exception e){
			log.error("Error while getting file for download "+e.getMessage());
			e.printStackTrace();
		}finally {
			connectionUtil.closeResources(connection, preparedStatement, null, null);
		}
		
		return fileContent;
	}
	
	public String removeServerFile(String seqNo, String uploadRefNo, String moduleRefNo, String moduleUnqNo,
		   String userCode, String userRole, String ipAddress){
		String result = "";
		String query = "";
		int count = 0;
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		try{
			query = " INSERT INTO "+schemaName+"TB_FILEDELETEDLOG(" +
				    "        SEQNO, UPLOADREFNO, MODULEREF, MODULEUNQNO, "+
				    "        FILENAME, FILEPATH, FILESIZE, FILECONTENT, "+
			        "	     UPLOADEDBY, UPLOADERROLE, TERMINALID, UPLOADTIMESTMP, " +
			        "        DELETEDBYCODE, DELETEDBYROLE, DELETEDBYTERMINALID, DELETEDTIMESTMP "+
			        " ) "+
			        " SELECT A.SEQNO, A.UPLOADREFNO, A.MODULEREF, A.MODULEUNQNO, "+
			        "        A.FILENAME, A.FILEPATH, A.FILESIZE, A.FILECONTENT, "+
			        "  	     A.UPLOADEDBY, A.UPLOADERROLE, A.TERMINALID, A.UPLOADTIMESTMP," +
			        "        ?,?,?,SYSTIMESTAMP "+
			        "   FROM "+schemaName+"TB_FILEUPLOADLOG A "+
			        "  WHERE A.SEQNO = ? "+
			        "    AND A.UPLOADREFNO = ? ";
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, userCode);
			preparedStatement.setString(2, userRole);
			preparedStatement.setString(3, ipAddress);
			preparedStatement.setString(4, seqNo);
			preparedStatement.setString(5, uploadRefNo);
			count = preparedStatement.executeUpdate();
			
			query = " DELETE FROM "+schemaName+"TB_FILEUPLOADLOG A "+
			        "  WHERE A.SEQNO = ? "+
			        "    AND A.UPLOADREFNO = ? ";
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, seqNo);
			preparedStatement.setString(2, uploadRefNo);
			count = preparedStatement.executeUpdate();
			if(count == 1)
				result = "Successfully removed";
		}catch(Exception e){
			result = "Error while removing file";
			log.error("Error while removing file in db "+e.getMessage());
			e.printStackTrace();
		}finally {
			connectionUtil.closeResources(connection, preparedStatement, null, null);
		}
		return result;
	}
	
	public void updateSeenFlag(String caseNo, String emailNumber, String userCode){
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		String sql = "UPDATE TB_EMAILEXCHANGEDETAILS A SET A.SEENFLAG = 'Y', A.READBY = ?, A.READDATE = SYSTIMESTAMP "+
					 " WHERE A.EMAILREFERENCENO = ? "+
					 "   AND A.MESSAGEINTERNALNO = ? "+
					 "   AND A.SEENFLAG = 'N' ";
		try{
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, userCode);
			preparedStatement.setString(2, caseNo);
			preparedStatement.setString(3, emailNumber);
			preparedStatement.executeUpdate();
		}catch(Exception e){
			log.error("Error while getting email from db "+e.getMessage());
			e.printStackTrace();
		}finally {
			connectionUtil.closeResources(connection, preparedStatement, null, null);
		}
	}
	
	public List<Map<String, String>> getEmailAttachments(String caseNo, String emailNumber){
		List<Map<String, String>> emailAttachments = new Vector<Map<String, String>>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String sql = "SELECT A.EMAILREFERENCENO CASENO, A.MESSAGEID, A.MESSAGEUNIQUENO, A.MESSAGEINTERNALNO, A.ATTACHMENTNO, A.FILENAME, A.FILETYPE, A.FILESIZE "+
					 "  FROM TB_EMAILATTACHMENTDETAILS A "+
					 " WHERE A.EMAILREFERENCENO = ? "+
					 "   AND A.MESSAGEINTERNALNO = ? ";
		try{
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, caseNo);
			preparedStatement.setString(2, emailNumber);
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()){
				double size = Integer.parseInt(resultSet.getString("FILESIZE"));
				double d_size = size / 1024;
				Map<String, String> attachments = new HashMap<String, String>();
				attachments.put("CASENO", resultSet.getString("CASENO"));
				attachments.put("MESSAGEID", resultSet.getString("MESSAGEID"));
				attachments.put("MESSAGEUNIQUENO", resultSet.getString("MESSAGEUNIQUENO"));
				attachments.put("MESSAGEINTERNALNO", resultSet.getString("MESSAGEINTERNALNO"));
				attachments.put("ATTACHMENTNO", resultSet.getString("ATTACHMENTNO"));
				attachments.put("FILENAME", resultSet.getString("FILENAME"));
				attachments.put("FILETYPE", resultSet.getString("FILETYPE"));
				attachments.put("FILESIZE", (new DecimalFormat("0.00").format(d_size))+" KB");
				emailAttachments.add(attachments);
			}
		}catch(Exception e){
			log.error("Error while getting email from db "+e.getMessage());
			e.printStackTrace();
		}finally {
			connectionUtil.closeResources(connection, preparedStatement, null, null);
		}
		return emailAttachments;
	}
	
	public List<Map<String, String>> getEmailDetails(String caseNo, String folderType, String emailNumber, String userCode){
		boolean updateSeenFlag = false;
		List<Map<String, String>> emailDetails = new Vector<Map<String, String>>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String sql = "SELECT A.EMAILREFERENCENO CASENO, A.MESSAGEID, A.MESSAGEUNIQUENO, A.MESSAGEINTERNALNO, A.SENDERID, "+
					 "		 A.RECIPIENTSTO, A.RECIPIENTSCC, A.RECIPIENTSBCC, A.SUBJECT, A.SENTDATE, A.RECEIVEDDATE, A.MESSAGECONTENT, "+
					 "		 A.UPDATEDBY, FUN_DATETIMETOCHAR(A.UPDATETIMESTAMP) UPDATETIMESTAMP, A.FOLDERTYPE, A.SEENFLAG, "+
					 "		 (SELECT COUNT(1) FROM TB_EMAILATTACHMENTDETAILS B WHERE B.EMAILREFERENCENO = ? AND B.MESSAGEINTERNALNO = A.MESSAGEINTERNALNO) ATTACHMENTCOUNT "+
					 "  FROM TB_EMAILEXCHANGEDETAILS A "+
					 " WHERE A.EMAILREFERENCENO = ? "+
					 "   AND A.FOLDERTYPE = ? ";
		if(emailNumber != null && emailNumber.trim().length() > 0){
			sql = sql + " AND A.MESSAGEINTERNALNO = '"+emailNumber+"' ";
			updateSeenFlag = true;
		}
		sql = sql + " ORDER BY A.UPDATETIMESTAMP DESC ";
		try{
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, caseNo);
			preparedStatement.setString(2, caseNo);
			preparedStatement.setString(3, folderType);
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()){
				Map<String, String> email = new HashMap<String, String>();
				email.put("CASENO", resultSet.getString("CASENO"));
				email.put("MESSAGEID", resultSet.getString("MESSAGEID"));
				email.put("MESSAGEUNIQUENO", resultSet.getString("MESSAGEUNIQUENO"));
				email.put("MESSAGEINTERNALNO", resultSet.getString("MESSAGEINTERNALNO"));
				email.put("SENDERID", resultSet.getString("SENDERID"));
				email.put("RECIPIENTSTO", resultSet.getString("RECIPIENTSTO"));
				email.put("RECIPIENTSCC", resultSet.getString("RECIPIENTSCC"));
				email.put("RECIPIENTSBCC", resultSet.getString("RECIPIENTSBCC"));
				email.put("SUBJECT", resultSet.getString("SUBJECT"));
				email.put("SENTDATE", resultSet.getString("SENTDATE"));
				email.put("RECEIVEDDATE", resultSet.getString("RECEIVEDDATE"));
				email.put("MESSAGECONTENT", resultSet.getString("MESSAGECONTENT"));
				email.put("UPDATEDBY", resultSet.getString("UPDATEDBY"));
				email.put("UPDATETIMESTAMP", resultSet.getString("UPDATETIMESTAMP"));
				email.put("FOLDERTYPE", resultSet.getString("FOLDERTYPE"));
				email.put("SEENFLAG", resultSet.getString("SEENFLAG"));
				email.put("ATTACHMENTCOUNT", resultSet.getString("ATTACHMENTCOUNT"));
				emailDetails.add(email);
			}
			
			if(updateSeenFlag){
				updateSeenFlag(caseNo, emailNumber, userCode);
			}
		}catch(Exception e){
			log.error("Error while getting email from db "+e.getMessage());
			e.printStackTrace();
		}finally {
			connectionUtil.closeResources(connection, preparedStatement, null, null);
		}
		return emailDetails;
	}
	
	public Map<String, Object> getEmailIdsForMapping(String emailCodes, int escalationOrder){
		String found = "0";
		Map<String, Object> emailIdsMap = new LinkedHashMap<String, Object>();
		List<String> toAddress = new ArrayList<String>();
		List<String> ccAddress = new ArrayList<String>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String query =  "";
		
		if(escalationOrder == 2){
			query = "SELECT SECONDESCALATIONTOADDRESS, SECONDESCALATIONCCADDRESS " +
					"  FROM "+schemaName+"TB_EMAILIDSLISTMAPPING "+
					" WHERE 1 = 1";
		}else if(escalationOrder == 3){
			query = "SELECT THIRDESCALATIONTOADDRESS, THIRDESCALATIONCCADDRESS " +
					"  FROM "+schemaName+"TB_EMAILIDSLISTMAPPING "+
					" WHERE 1 = 1";
		}else{
			query = "SELECT FIRSTESCALATIONTOADDRESS, FIRSTESCALATIONCCADDRESS " +
					"  FROM "+schemaName+"TB_EMAILIDSLISTMAPPING "+
					" WHERE 1 = 1";
		}
		
		query = query + " AND EMAILCODE IN ('"+emailCodes.replaceAll(",", "','")+"')";
		try{
			preparedStatement = connection.prepareStatement(query);
			resultSet = preparedStatement.executeQuery();
			
		    while (resultSet.next()) {
				toAddress.add(resultSet.getString(1));
				ccAddress.add(resultSet.getString(2));
				found = "1";
			}
			String[] arrToAddress = new String[toAddress.size()];
			for(int i = 0; i < toAddress.size(); i++){
				arrToAddress[i] = toAddress.get(i);
			}
			emailIdsMap.put("TO", arrToAddress);
			String[] arrCcAddress = new String[ccAddress.size()];
			for(int i = 0; i < ccAddress.size(); i++){
				arrCcAddress[i] = ccAddress.get(i);
			}
			emailIdsMap.put("CC", arrCcAddress);
			emailIdsMap.put("STATUS", found);
		}catch(Exception e){
			log.error("Error while fetching email list : "+e.getMessage());
			e.printStackTrace();
		}
		return emailIdsMap;
	}
	
	public Map<String, String> composeEmail(String caseNo, String emailNo, String folderType, String composeType, String userCode, String userRole){
		Map<String, String> emailComposeDetails = new HashMap<String, String>();
		Connection connection = connectionUtil.getConnection();
		CallableStatement callableStatement = null;
		ResultSet resultSet = null;
		try{
			callableStatement = connection.prepareCall("{CALL STP_COMPOSEEMAIL(?,?,?,?,?,?,?,?)}");
			callableStatement.setString(1, caseNo);
			callableStatement.setString(2, emailNo);
			callableStatement.setString(3, folderType);
			callableStatement.setString(4, composeType);
			callableStatement.setString(5, userCode);
			callableStatement.setString(6, userRole);
			callableStatement.registerOutParameter(7, OracleTypes.CURSOR);
			callableStatement.registerOutParameter(8, OracleTypes.CURSOR);
			callableStatement.execute();
			
			resultSet = (ResultSet) callableStatement.getObject(7);
			while(resultSet.next()){
				emailComposeDetails.put("MESSAGEID", resultSet.getString("MESSAGEID"));
				emailComposeDetails.put("RECIPIENTSTO", resultSet.getString("RECIPIENTSTO"));
				emailComposeDetails.put("RECIPIENTSCC", resultSet.getString("RECIPIENTSCC"));
				emailComposeDetails.put("SUBJECT", resultSet.getString("SUBJECT"));
				// emailComposeDetails.put("MESSAGECONTENT", "NEW".equals(composeType) ? resultSet.getString("MESSAGECONTENT") : clobStringConversion(resultSet.getClob("MESSAGECONTENT")));
				emailComposeDetails.put("MESSAGECONTENT", "NEW".equals(composeType) ? clobStringConversion(resultSet.getClob("MESSAGECONTENT")) : clobStringConversion(resultSet.getClob("MESSAGECONTENT")));
			}
			
		}catch(Exception e){
			log.error("Error while fetching email compose details : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, callableStatement, resultSet, null);
		}
		return emailComposeDetails;
	}
	
	public static String clobStringConversion(Clob clb) throws IOException, SQLException{
	      if (clb == null)
	    	  return  "";
	            
	      StringBuffer str = new StringBuffer();
	      String strng;
	      BufferedReader bufferRead = new BufferedReader(clb.getCharacterStream());
	      while ((strng=bufferRead .readLine())!=null)
	       str.append(strng);
	   
	      return str.toString();
	    }
	
	public Map<String, Object> getDashboardGraphData(String userCode, String userRole, String ipAddress){
		// System.out.println("getDashboardGraphData:   ");
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		CallableStatement callableStatement = null;
		Map<String, Object> dashBoardGraphData = new HashMap<String, Object>();
		Map<String, String> customersRiskData = new HashMap<String, String>();
		List<Map<String, String>> customersRiskList = new ArrayList<Map<String, String>>();
		Map<String, String> accountsRiskData = new HashMap<String, String>();
		List<Map<String, String>> accountsRiskList = new ArrayList<Map<String, String>>();
		Map<String, String> alertStatisticsData = new HashMap<String, String>();
		List<Map<String, String>> alertStatisticsList = new ArrayList<Map<String, String>>();
		Map<String, String> nTopMostAlertsData = new HashMap<String, String>();
		List<Map<String, String>> nTopMostAlertsList = new ArrayList<Map<String, String>>();
		
		// String sql = "";
		try{
			/*
			dashBoardGraphData.put("CUSTOMERS_HIGH", "0");
			dashBoardGraphData.put("CUSTOMERS_MEDIUM", "0");
			dashBoardGraphData.put("CUSTOMERS_LOW", "0");
			dashBoardGraphData.put("CUSTOMERS_TOTAL", "0");
			dashBoardGraphData.put("ACCOUNTS_HIGH", "0");
			dashBoardGraphData.put("ACCOUNTS_MEDIUM", "0");
			dashBoardGraphData.put("ACCOUNTS_LOW", "0");
			dashBoardGraphData.put("ACCOUNTS_TOTAL", "0");
			
			sql = " SELECT CUSTOMERS_HIGH, CUSTOMERS_MEDIUM, "+
                  "        CUSTOMERS_LOW, ACCOUNTS_HIGH, "+
                  "        ACCOUNTS_MEDIUM, ACCOUNTS_LOW "+
                  "   FROM "+schemaName+"TB_DESKTOPRELATEDDATA ";
			preparedStatement = connection.prepareStatement(sql);;
			resultSet = preparedStatement.executeQuery();
			while (resultSet.next()) {
				dashBoardGraphData.put("CUSTOMERS_HIGH", resultSet.getString("CUSTOMERS_HIGH"));
				dashBoardGraphData.put("CUSTOMERS_MEDIUM", resultSet.getString("CUSTOMERS_MEDIUM"));
				dashBoardGraphData.put("CUSTOMERS_LOW", resultSet.getString("CUSTOMERS_LOW"));
				dashBoardGraphData.put("CUSTOMERS_TOTAL", (resultSet.getInt("CUSTOMERS_HIGH")+resultSet.getInt("CUSTOMERS_MEDIUM")+resultSet.getInt("CUSTOMERS_LOW"))+"");
				dashBoardGraphData.put("ACCOUNTS_HIGH", resultSet.getString("ACCOUNTS_HIGH"));
				dashBoardGraphData.put("ACCOUNTS_MEDIUM", resultSet.getString("ACCOUNTS_MEDIUM"));
				dashBoardGraphData.put("ACCOUNTS_LOW", resultSet.getString("ACCOUNTS_LOW"));
				dashBoardGraphData.put("ACCOUNTS_TOTAL", (resultSet.getInt("ACCOUNTS_HIGH")+resultSet.getInt("ACCOUNTS_MEDIUM")+resultSet.getInt("ACCOUNTS_LOW"))+"");
			}*/
			callableStatement = connection.prepareCall("{CALL STP_DASHBOARDGRAPHDATA(?,?,?,?,?,?,?)}");
			callableStatement.setString(1, userCode);
			callableStatement.setString(2, userRole);
			callableStatement.setString(3, ipAddress);
			callableStatement.registerOutParameter(4, OracleTypes.CURSOR);
			callableStatement.registerOutParameter(5, OracleTypes.CURSOR);
			callableStatement.registerOutParameter(6, OracleTypes.CURSOR);
			callableStatement.registerOutParameter(7, OracleTypes.CURSOR);
			callableStatement.execute();
			resultSet = (ResultSet) callableStatement.getObject(4);
			while (resultSet.next()) {
				customersRiskData = new HashMap<String, String>();
				customersRiskData.put("name", resultSet.getString("CUSTOMERS_RISK_NAME"));
				customersRiskData.put("value", resultSet.getString("CUSTOMERS_RISK_VALUE"));
				customersRiskData.put("percentage", resultSet.getString("CUSTOMERS_RISK_PERCENTAGE"));
				customersRiskList.add(customersRiskData);
			}
			dashBoardGraphData.put("CUSTOMERSRISK_GRAPHDATA", customersRiskList);
			
			resultSet = null;
			resultSet = (ResultSet) callableStatement.getObject(5);
			while (resultSet.next()) {
				accountsRiskData = new HashMap<String, String>();
				accountsRiskData.put("name", resultSet.getString("ACCOUNTS_RISK_NAME"));
				accountsRiskData.put("value", resultSet.getString("ACCOUNTS_RISK_VALUE"));
				accountsRiskData.put("percentage", resultSet.getString("ACCOUNTS_RISK_PERCENTAGE"));
				accountsRiskList.add(accountsRiskData);
			}
			dashBoardGraphData.put("ACCOUNTSRISK_GRAPHDATA", accountsRiskList);

			resultSet = null;
			resultSet = (ResultSet) callableStatement.getObject(6);
			while (resultSet.next()) {
				alertStatisticsData = new HashMap<String, String>();
				alertStatisticsData.put("name", resultSet.getString("FIELD_NAME"));
				alertStatisticsData.put("value", resultSet.getString("FIELD_VALUE"));
				alertStatisticsData.put("percentage", resultSet.getString("FIELD_PERCENTAGE"));
				alertStatisticsList.add(alertStatisticsData);
			}
			dashBoardGraphData.put("ALERTSTATISTICS_GRAPHDATA", alertStatisticsList);
			
			resultSet = null;
			resultSet = (ResultSet) callableStatement.getObject(7);
			while (resultSet.next()) {
				nTopMostAlertsData = new HashMap<String, String>();
				nTopMostAlertsData.put("ALERTCODE", resultSet.getString("ALERTCODE"));
				nTopMostAlertsData.put("ALERTSCOUNT", resultSet.getString("ALERTSCOUNT"));
				nTopMostAlertsList.add(nTopMostAlertsData);
			}
			dashBoardGraphData.put("NTOPMOSTALERTS_GRAPHDATA", nTopMostAlertsList);
		}catch(Exception e){
			log.error("Error while getting data for getDashboardGraphData : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return dashBoardGraphData;
	}
	
	@Override
	public void storeAuditLogNew(AuditLog auditLog) {
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		int count = 0;
	    
		try{
			preparedStatement = connection.prepareStatement("INSERT INTO "+schemaName+"TB_SYSTEMAUDITLOG(USERCODE, USERROLE, LOGINDATETIME, SESSIONID, MODULEACCESSED, ACCESSTYPE, "+
															"		ACCESSEDTIME, MESSAGE, URLACCESSED, QUERYPARAMS, TERMINALID, TERMINALNAME, TERMINALAGENT, LOGDATETIME) "+
															"VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?)");

			preparedStatement.setString(1, auditLog.getUserCode());
			preparedStatement.setString(2, auditLog.getUserRole());
			preparedStatement.setTimestamp(3, convertDateToTimestamp(auditLog.getLoginTime()));
			preparedStatement.setString(4, auditLog.getSessionId());
			preparedStatement.setString(5, auditLog.getModuleAccessed());
			preparedStatement.setString(6, auditLog.getAccessType());
			preparedStatement.setTimestamp(7, convertDateToTimestamp(auditLog.getAccessTime()));
			preparedStatement.setString(8, auditLog.getMessage());
			preparedStatement.setString(9, auditLog.getUrlAccessed());
			preparedStatement.setString(10, auditLog.getQueryParam());
			preparedStatement.setString(11, auditLog.getTerminalId());
			preparedStatement.setString(12, auditLog.getTerminalName());
			preparedStatement.setString(13, auditLog.getTerminalAgent());
			preparedStatement.setTimestamp(14, convertDateToTimestamp(auditLog.getLogDateTime()));
			preparedStatement.executeUpdate();

		}catch(Exception e){
			e.printStackTrace();
			log.error("Error while storing audit log : "+e.getMessage());
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, null, null);
		}
	}
	
	private Timestamp convertDateToTimestamp(Date date){
		Calendar cal = Calendar.getInstance();
		cal.setTime(date);
		cal.set(Calendar.MILLISECOND, 0);
		return new Timestamp(cal.getTimeInMillis());
	}
	
	@Override
	public String getEmailAddresses(Connection connection, String usercode) {
		//Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String emailAddress = "";
		
		try {
			String sql = " SELECT EMAILID "+
						 " FROM "+schemaName+"TB_USER WHERE USERCODE = ? ";
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, usercode);
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()) {
				emailAddress = resultSet.getString("EMAILID");
			}
			System.out.println("emailAddress = "+emailAddress);
		}catch(Exception e){
			e.printStackTrace();
		}
		return emailAddress;
	}
	
	//Adding email questions
	@Override
	public List<Map<String, Object>> getEmailQuestions(String caseNo,String userCode, String userRole, String remoteAddr) {
		List<Map<String,Object>> output = new LinkedList<Map<String,Object>>();
		
		List<String> question = new ArrayList<String>();
		Connection connection = connectionUtil.getConnection();
		ResultSet resultSet = null;
		PreparedStatement preparedStatement = null;
		try{
			preparedStatement = connection.prepareStatement(" SELECT QUESTIONGROUP,QUESTION FROM "+schemaName+"TB_EMAIL_QUESTION_REPOSITORY ");
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()){	
				Map<String,Object> questionMap = new LinkedHashMap<String,Object>();
				if(!questionMap.containsKey(resultSet.getString("QUESTIONGROUP"))){
					 question = new ArrayList<String>();
				}
				question.add(resultSet.getString("QUESTION"));
				questionMap.put(resultSet.getString("QUESTIONGROUP"), question);
				//System.out.println("questionMap = "+questionMap);
				output.add(questionMap);
			}
			
		}catch(Exception e){
			e.printStackTrace();
			log.error("Error while getting email questions : "+e.getMessage());
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, null, null);
		}
		//System.out.println(output);
		return output;
	}
	
	public List<Map<String, String>> validationCheck(String custId, String accNo){
		System.out.println(custId+", "+accNo);
		List<Map<String, String>> dataList = new ArrayList<Map<String,String>>();
		Map<String, String> dataMap = new HashMap<String, String>();
		String isValidMsg = "";
		boolean isValid = false;
		Connection connection = connectionUtil.getConnection();
		Connection connection1 = connectionUtil.getConnection();
		ResultSet resultSet = null;
		ResultSet resultSet1 = null;
		CallableStatement callableStatement = null;
		PreparedStatement preparedStatement = null;
		String sql = "";
		try{
			callableStatement = connection.prepareCall("{CALL "+schemaName+"STP_VALIDATIONCHECK(?,?,?)}");
			callableStatement.setString(1, accNo);
			callableStatement.setString(2, custId);
			callableStatement.registerOutParameter(3, OracleTypes.CURSOR);
			callableStatement.execute();
			resultSet = (ResultSet) callableStatement.getObject(3);
			if(resultSet.next()){
				//System.out.println(resultSet.getInt("EXISTINGCOUNT"));
				if(resultSet.getInt("EXISTINGCOUNT") >= 1){
					isValid = true;
					if(custId != null && !"".equals(custId))
						isValidMsg = "CustomerId is valid.";
					else if(accNo != null && !"".equals(accNo))
						isValidMsg = "AccountNo is valid.";
				}else{
					isValid = false;
					if(custId != null && !"".equals(custId))
						isValidMsg = "CustomerId is not valid.";
					else if(accNo != null && !"".equals(accNo))
						isValidMsg = "AccountNo is not valid.";
				}
			}
			if(isValid){
				sql = "SELECT BRANCHCODE FROM "+schemaName+"TB_ACCOUNTSMASTER "+
					  " WHERE 1 = 1 ";
				if(custId != null && !"".equals(custId)){
					sql = sql + " AND CUSTOMERID = ? ";
				}
				if(accNo != null && !"".equals(accNo)){
					sql = sql + " AND ACCOUNTNO = ? ";
				}
				
				int count = 1;	
				preparedStatement = connection1.prepareStatement(sql);
				if(custId != null && !"".equals(custId)){
					preparedStatement.setString(count, custId);
					count++;
				}
				if(accNo != null && !"".equals(accNo)){
					preparedStatement.setString(count, accNo);
				}
				
				resultSet1 = preparedStatement.executeQuery();
				
				if(resultSet1.next()) {
					dataMap.put("BRANCHCODE", resultSet1.getString("BRANCHCODE"));
					dataMap.put("VALIDATIONMSG", isValidMsg);
				}
			}else{
				dataMap.put("BRANCHCODE", "ALL");
				dataMap.put("VALIDATIONMSG", isValidMsg);
			}
			dataList.add(dataMap);
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection1, preparedStatement, resultSet1, null);
			connectionUtil.closeResources(connection, callableStatement, resultSet, null);
		}
		//System.out.println(dataList);
		return dataList;
	}
	
	/*public boolean validationCheck(String custId, String accNo){
		//System.out.println(custId+", "+accNo);
		boolean isValid = false;
		Connection connection = connectionUtil.getConnection();
		ResultSet resultSet = null;
		CallableStatement callableStatement = null;
		try{
			callableStatement = connection.prepareCall("{CALL "+schemaName+"STP_VALIDATIONCHECK(?,?,?)}");
			callableStatement.setString(1, accNo);
			callableStatement.setString(2, custId);
			callableStatement.registerOutParameter(3, OracleTypes.CURSOR);
			callableStatement.execute();
			resultSet = (ResultSet) callableStatement.getObject(3);
			if(resultSet.next()){
				//System.out.println(resultSet.getInt("EXISTINGCOUNT"));
				if(resultSet.getInt("EXISTINGCOUNT") >= 1)
					isValid = true;
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, callableStatement, null, null);
		}
		return isValid;
	}*/
	
	public String saveFileUploadComments(String parameters, String selectedFiles, String status, String markAll, 
			String comments,String userCode, String userRole,String ipAddress){
		// System.out.println(parameters);
		Connection connection = connectionUtil.getConnection();
		ResultSet resultSet = null;
		CallableStatement callableStatement = null;
		String message = ""; 
		try{
			// callableStatement = connection.prepareCall("{CALL "+schemaName+"STP_SETACTION_FILEUPLOADS(?,?,?,?,?,?,?,?,?,?,?)}");
			callableStatement = connection.prepareCall("{CALL "+schemaName+"STP_SETACTION_FILEUPLOADS(:FROMDATE, :TODATE, :FILEUPLOADTYPE, :STATUS,"+
								" :SELECTEDSEQUENCENOS, :MARKALL, :COMMENTS, :USERCODE, :USERROLE, :IPADDRESS, :RESULTSET)}");
			
			String[] arrParams = CommonUtil.splitString(parameters, ",");
			
			for(String strParam : arrParams){
				if(strParam.length()>0){
					String[] arrParam = CommonUtil.splitString(strParam, "=");
					
					callableStatement.setString(arrParam[0].substring(arrParam[0].indexOf("_")+1), arrParam[1].replaceAll("}", ""));
				}
			}

			callableStatement.setString("STATUS", status);
			callableStatement.setString("SELECTEDSEQUENCENOS", selectedFiles);
			callableStatement.setString("MARKALL", markAll);
			callableStatement.setString("COMMENTS", comments);
			callableStatement.setString("USERCODE", userCode);
			callableStatement.setString("USERROLE", userRole);
			callableStatement.setString("IPADDRESS", ipAddress);
			callableStatement.registerOutParameter("RESULTSET", OracleTypes.CURSOR);
			callableStatement.execute();

			resultSet = (ResultSet) callableStatement.getObject("RESULTSET");
			while(resultSet.next()){
				message = resultSet.getString(1);
			}
			// System.out.println("message: "+message);
			log.error("message in saveFileUploadComments: "+message);
			
			if("A".equals(status)){
				message = "Successfully approved uploaded file(s).";
			}else{
				message = "Successfully rejected uploaded file(s).";
			}
			
			
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, callableStatement, null, null);
		}
		return message;
	}
	
	public String deleteDraftEmail(String caseNo, String emailNumber, String isDraft){
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		String result = "";
		String folderType = "";
		int count = 0 ;
		if("Y".equalsIgnoreCase(isDraft))
			folderType = "DRAFTS";
		
		try {
			String sql = "DELETE FROM TB_EMAILEXCHANGEDETAILS "+
						 " WHERE EMAILREFERENCENO = ? "+
						 "   AND MESSAGEINTERNALNO = ? "+
						 "   AND FOLDERTYPE = ? ";
			connection = connectionUtil.getConnection();
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, caseNo);
			preparedStatement.setString(2, emailNumber);
			preparedStatement.setString(3, folderType);
			count = preparedStatement.executeUpdate();
			if(count == 1) {
				result = "Draft email deleted successfully.";
			}else {
				result = "Error while deleting draft email.";
			}
			//System.out.println(result);
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			connectionUtil.closeResources(connection, preparedStatement, null, null);
		}
		return result;
	}
	
	//Adding email groups
	@Override
	public Map<String, Object> getEmailGroups(String caseNo,String userCode, String userRole, String remoteAddr) {
		Map<String,Object>groups = new HashMap<String,Object>();
		Connection connection = connectionUtil.getConnection();
		ResultSet resultSet = null;
		PreparedStatement preparedStatement = null;
		try{
			preparedStatement = connection.prepareStatement(" SELECT DISTINCT QUESTIONGROUP, QUESTIONGROUPTITLE FROM "+schemaName+"TB_EMAIL_QUESTION_REPOSITORY ");
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()){				
				groups.put(resultSet.getString("QUESTIONGROUP"), resultSet.getString("QUESTIONGROUPTITLE"));
			}
		}catch(Exception e){
			e.printStackTrace();
			log.error("Error while getting email groups : "+e.getMessage());
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, null, null);
		}
		return groups;
	}

	@Override
	public Map<String,Object> getEmailQuestions(String emailQuestionID) {
		Map<String,Object>result = new HashMap<String,Object>();
		Map<String,String>emailQuestionDetils = new HashMap<String,String>();
		Map<String,String>emailGroupDetails = new HashMap<String,String>();
		Connection connection = connectionUtil.getConnection();
		ResultSet resultSet = null;
		PreparedStatement preparedStatement = null;
		try{
			String sql = " SELECT QUESTIONID EMAILQUESTIONID, QUESTIONGROUPTITLE,QUESTION,UPDATEDBY,UPDATETIMESTAMP "+
						"  FROM "+schemaName+"TB_EMAIL_QUESTION_REPOSITORY WHERE QUESTIONID = ? ";
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, emailQuestionID);
			resultSet = preparedStatement.executeQuery();
			resultSet.next();
			emailQuestionDetils.put("EMAILQUESTIONID", resultSet.getString("EMAILQUESTIONID"));
			emailQuestionDetils.put("QUESTION", resultSet.getString("QUESTION"));
			emailQuestionDetils.put("QUESTIONGROUPTITLE", resultSet.getString("QUESTIONGROUPTITLE"));
			emailQuestionDetils.put("UPDATEDBY", resultSet.getString("UPDATEDBY"));
			emailQuestionDetils.put("UPDATETIMESTAMP", resultSet.getString("UPDATETIMESTAMP"));
			
			sql = " SELECT DISTINCT(QUESTIONGROUPTITLE) , QUESTIONGROUP  FROM "+schemaName+"TB_EMAIL_QUESTION_REPOSITORY ";
			preparedStatement = connection.prepareStatement(sql);
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()){
				emailGroupDetails.put(resultSet.getString("QUESTIONGROUPTITLE"), resultSet.getString("QUESTIONGROUP"));
			}
			result.put("EMAILQUESTIONDETAILS",emailQuestionDetils);
			result.put("EMAILGROUPDETAILS",emailGroupDetails);
			
		}catch(Exception e){
			log.error("Error while getting email question details : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, null, null);
		}
		return result;
	}

	@Override
	public String insertUpdateEamilQuestion(Map<String, String> inputParam,String userCode, String userRole, String ipAddress) {
		String message = "";
		Connection connection = connectionUtil.getConnection();
		ResultSet resultSet = null;
		PreparedStatement preparedStatement = null;
		boolean isNew = true;
		try{
			preparedStatement = connection.prepareStatement("SELECT QUESTIONID  FROM "+schemaName+"TB_EMAIL_QUESTION_REPOSITORY WHERE QUESTIONID =? ");
			preparedStatement.setString(1, inputParam.get("QUESTIONID"));
			resultSet = preparedStatement.executeQuery();
			if(resultSet.next()){
				isNew = false;
			}
			System.out.println("is new  = "+isNew);
			if(!isNew){
				try{
					String query = " UPDATE "+schemaName+"TB_EMAIL_QUESTION_REPOSITORY SET QUESTIONGROUP = ? ,QUESTIONGROUPTITLE = ?, "+
								   " QUESTION = ?, UPDATEDBY = ?, UPDATETIMESTAMP = SYSTIMESTAMP "+
								   " WHERE QUESTIONID = ? ";
					preparedStatement = connection.prepareStatement(query);
					preparedStatement.setString(1, inputParam.get("QUESTIONGROUP"));
					preparedStatement.setString(2, inputParam.get("QUESTIONGROUPTITLE"));
					preparedStatement.setString(3, inputParam.get("QUESTION"));
					preparedStatement.setString(4, userCode);
					preparedStatement.setString(5, inputParam.get("QUESTIONID"));
					preparedStatement.executeUpdate();
					message = " Successfully Updated";
				}catch(Exception e){
					message = "Error";
					log.error("Error while Updating email questions: "+e.getMessage());
					e.printStackTrace();
				}
			}
			else{
				try{
					String query = " INSERT INTO "+schemaName+"TB_EMAIL_QUESTION_REPOSITORY (QUESTIONID,QUESTIONGROUP,QUESTIONGROUPTITLE,"+
						        " QUESTION,UPDATEDBY,UPDATETIMESTAMP )values (?,?,?,?,?,SYSTIMESTAMP) ";
					preparedStatement = connection.prepareStatement(query);
					preparedStatement.setString(1, inputParam.get("QUESTIONID"));
					preparedStatement.setString(2, inputParam.get("QUESTIONGROUP"));
					preparedStatement.setString(3, inputParam.get("QUESTIONGROUPTITLE"));
					preparedStatement.setString(4, inputParam.get("QUESTION"));
					preparedStatement.setString(5, userCode);
					preparedStatement.executeQuery();
					message = " Successfully Added";
				}catch(Exception e){
					message = "Error";
					log.error("Error while inserting email questions: "+e.getMessage());
					e.printStackTrace();
				}
			}
		}catch(Exception e){
			message = "Error";
			log.error("Error checking existing question during insert or update : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, null, null);
		}
		
		return message;
	}

	@Override
	public Map<String, Object> getQuestionIdAndGroupdetails(String userCode,String userRole, String ipAddress) {
		Connection connection = connectionUtil.getConnection();
		ResultSet resultSet = null;
		PreparedStatement preparedStatement = null;
		Map<String,Object>output = new HashMap<String,Object>();
		Map<String,String>emailGroupDetails = new HashMap<String,String>();
		String sql ,emailQuestionID = "";
		try{
			sql = " SELECT DISTINCT(QUESTIONGROUPTITLE) , QUESTIONGROUP  FROM "+schemaName+"TB_EMAIL_QUESTION_REPOSITORY ";
			preparedStatement = connection.prepareStatement(sql);
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()){
				emailGroupDetails.put(resultSet.getString("QUESTIONGROUPTITLE"), resultSet.getString("QUESTIONGROUP"));
			}
			sql = " SELECT SEQ_EMAIL_QUESTION.NEXTVAL QUESTIONID FROM DUAL ";
			preparedStatement = connection.prepareStatement(sql);
			resultSet = preparedStatement.executeQuery();
			resultSet.next();
			emailQuestionID = resultSet.getString("QUESTIONID");
			output.put("EMAILQUESTIONDETAILS",emailGroupDetails);
			output.put("EMAILQUESTIONID",emailQuestionID);
			
			System.out.println(output);
		}catch(Exception e){
			log.error("Error while getting question ID : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return output;
	}
	
		private String setFileUploadMakerLog(String mappingType, String uploadRefNo, File fileInputFile, String fileName, String tempTableName, 
			String userCode, String groupCode, String ipAddress){
		Connection connection = null; 
		CallableStatement callableStatement = null;
		String resultMessage = "Error While Updating The Status";
		try{
			connection = connectionUtil.getConnection();
			callableStatement = connection.prepareCall("{CALL "+schemaName+"STP_SETFILEUPLOADMAKERLOG(?,?,?,?,?,?,?,?)}");
			callableStatement.setString(1, mappingType);
			callableStatement.setString(2, uploadRefNo);
			FileInputStream fis = new FileInputStream(fileInputFile);
			callableStatement.setBinaryStream(3, fis, fis.available());
			callableStatement.setString(4, fileName);
			callableStatement.setString(5, tempTableName);
			callableStatement.setString(6, userCode);
			callableStatement.setString(7, groupCode);
			callableStatement.setString(8, ipAddress);
			callableStatement.execute();
			
			resultMessage = "File successfully uploaded, Please Contact Checker To Approve";
		}catch(Exception e){
			log.error("Error in setFileUploadMakerLog : "+e.getMessage());
			e.printStackTrace();
			resultMessage = "Error While Updating The Status ";
		}finally{
			connectionUtil.closeResources(connection, callableStatement, null, null);
		}
		return resultMessage;
	}
	
	public Map<String, Object> getFileUploadErrorDetails(String uploadRefNo, String moduleRefId, String filename, 
								String userCode, String userRole, String ipAddress){
		Map<String, Object> mainMap = new HashMap<String, Object>();
		Connection connection = connectionUtil.getConnection();
		CallableStatement callableStatement = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		ResultSet resultSet1 = null; 
		ResultSet resultSet2 = null;
		List<ResultSet> resultSetList = new Vector<ResultSet>();
		int noOfResultSet = 0;
		String tabNames = "";
		String tabDisplay = "";
		try{
			
			preparedStatement = connection.prepareStatement("SELECT COUNT(IN_OUT) COUNT FROM USER_ARGUMENTS WHERE OBJECT_NAME = ? AND IN_OUT = ?");
			preparedStatement.setString(1, "STP_GETFILEUPLOADERRORDETAILS");
			preparedStatement.setString(2, "IN/OUT");
			resultSet = preparedStatement.executeQuery();
			if(resultSet.next())
				noOfResultSet = resultSet.getInt("COUNT");

			//System.out.println("noOfResultSet = "+noOfResultSet);
			
			String sql = "{CALL STP_GETFILEUPLOADERRORDETAILS(:UPLOADREFNO, :MODULEREFID, :FILENAME, :USERCODE, :GROUPCODE, :IPADDRESS, :RESULTSET1, :RESULTSET2, ";
			for(int i = 3; i <= noOfResultSet; i++){
				if(i == noOfResultSet)
					sql = sql + ":RESULTSET"+i+" ";
				else
					sql = sql + ":RESULTSET"+i+", ";
			}
			sql = sql + ")}";
			
			// sql = "{CALL STP_GETFILEUPLOADERRORDETAILS(:UPLOADREFNO, :MODULEREFID, :FILENAME, :USERCODE, :GROUPCODE, :IPADDRESS, :RESULTSET1, :RESULTSET2, :RESULTSET3, :RESULTSET4, :RESULTSET5, :RESULTSET6, :RESULTSET7) } ";
			
			callableStatement = connection.prepareCall(sql);
			callableStatement.setString("UPLOADREFNO", uploadRefNo);
			callableStatement.setString("MODULEREFID", moduleRefId);
			callableStatement.setString("FILENAME", filename);
			callableStatement.setString("USERCODE", userCode);
			callableStatement.setString("GROUPCODE", userRole);
			callableStatement.setString("IPADDRESS", ipAddress);
			
			callableStatement.registerOutParameter("RESULTSET1", OracleTypes.CURSOR);
			callableStatement.registerOutParameter("RESULTSET2", OracleTypes.CURSOR);
			
			for(int i = 3; i <= noOfResultSet; i++){
				String indexName = "RESULTSET"+i;
				callableStatement.registerOutParameter(indexName, OracleTypes.CURSOR);
			}
			
			callableStatement.execute();
			
			resultSet1 = (ResultSet) callableStatement.getObject("RESULTSET1");
			if(resultSet1.next()){
				tabNames = resultSet1.getString("TABNAMES");
			}
			List<String> tabNameList = Arrays.asList(CommonUtil.splitString(tabNames, "^~^"));
			mainMap.put("TABNAMES", tabNameList);
			
			resultSet2 = (ResultSet) callableStatement.getObject("RESULTSET2");
			if(resultSet2.next()){
				tabDisplay = resultSet2.getString("TABDISPLAY");
			}
			List<String> tabDisplayList = Arrays.asList(CommonUtil.splitString(tabDisplay, "^~^"));
			Map<String, String> tabDisplayMap = new LinkedHashMap<String, String>();
			for(int i = 0; i < tabDisplayList.size(); i++){
				tabDisplayMap.put(Integer.toString(i), tabDisplayList.get(i));
			}
			mainMap.put("TABDISPLAY", tabDisplayMap);
			
			for(int i = 3; i <= noOfResultSet; i++){
				ResultSet resultSet3 = (ResultSet) callableStatement.getObject("RESULTSET"+i);
				resultSetList.add(resultSet3);
			}
			//System.out.println("resultSetList = "+resultSetList.size());
			for(int i = 0; i < resultSetList.size(); i++){
				//System.out.println(i);
				mainMap.put(Integer.toString(i), processResultSet(resultSetList.get(i)));
				//System.out.println(mainMap);
			}
			
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, callableStatement, resultSet, null);
		}
		//System.out.println(mainMap);
		return mainMap;
	}
	
	private List<Map<String, String>> processResultSet(ResultSet resultSet) throws Exception{
		List<Map<String, String>> fieldsDetails = new Vector<Map<String, String>>();
		List<String> headers = new Vector<String>();
		ResultSetMetaData resultSetMetaData = resultSet.getMetaData();
		for(int colIndex = 1; colIndex <= resultSetMetaData.getColumnCount(); colIndex++){
			headers.add(resultSetMetaData.getColumnName(colIndex));
		}
		
		while (resultSet.next()) {
			Map<String, String> field = new LinkedHashMap<String, String>();
			for(String header : headers){
				// field.put(header, resultSet.getString(header));
				field.put(CommonUtil.changeColumnName(header), resultSet.getString(header));
			}
			fieldsDetails.add(field);
		}
		//System.out.println("fieldsDetails = "+fieldsDetails);
		return fieldsDetails;
	}
	
		public Map<String, String> composeStaffEmail(String reportCaseNo, String reportId, String fromDate, String toDate, String staffAccNo, 
			String emailNo, String folderType, String composeType,String userCode, String userRole) {
		Map<String, String> emailComposeDetails = new HashMap<String, String>();
		Connection connection = connectionUtil.getConnection();
		CallableStatement callableStatement = null;
		ResultSet resultSet = null;
		//System.out.println("caseid ="+reportRowId+",from "+fromDate+",to "+toDate+",acc "+staffAccNo+", "+emailNo+", "+folderType+", "+composeType+", "+userCode+", "+userRole+", "+reportId);
		try{
			callableStatement = connection.prepareCall("{CALL STP_COMPOSEEMAILFORSTAFF(?,?,?,?,?,?,?,?,?,?,?,?)}");
			callableStatement.setString(1, reportCaseNo);
			callableStatement.setString(2, emailNo);
			callableStatement.setString(3, folderType);
			callableStatement.setString(4, composeType);
			callableStatement.setString(5, userCode);
			callableStatement.setString(6, userRole);
			callableStatement.setString(7, reportId);
			callableStatement.setString(8, staffAccNo);
			callableStatement.setString(9, fromDate);
			callableStatement.setString(10, toDate);
			callableStatement.registerOutParameter(11, OracleTypes.CURSOR);
			callableStatement.registerOutParameter(12, OracleTypes.CURSOR);
			callableStatement.execute();
			
			resultSet = (ResultSet) callableStatement.getObject(11);
			while(resultSet.next()){
				emailComposeDetails.put("MESSAGEID", resultSet.getString("MESSAGEID"));
				emailComposeDetails.put("RECIPIENTSTO", resultSet.getString("RECIPIENTSTO"));
				emailComposeDetails.put("RECIPIENTSCC", resultSet.getString("RECIPIENTSCC"));
				emailComposeDetails.put("RECIPIENTSBCC", resultSet.getString("RECIPIENTSBCC"));
				emailComposeDetails.put("SUBJECT", resultSet.getString("SUBJECT"));
				emailComposeDetails.put("MESSAGECONTENT", "NEW".equals(composeType) ? clobStringConversion(resultSet.getClob("MESSAGECONTENT")) : clobStringConversion(resultSet.getClob("MESSAGECONTENT")));
			}
			
		}catch(Exception e){
			log.error("Error while fetching email compose details : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, callableStatement, resultSet, null);
		}
		return emailComposeDetails;
	}
	
	public String sendEmailFromPortal(String alertNo, String rasUserCode, String subject, String content, String uid, String logonMailId, 
			String givenName, String sn, String cn, String userPassword, String userCode, String userRole, String ipAddress) {
		Connection connection = connectionUtil.getConnection();
		CallableStatement callableStatement = null;
		ResultSet resultSet = null;
		System.out.println("daoimpl = "+alertNo+", "+rasUserCode+", "+subject+", "+content+", "+uid+", "+logonMailId+", "+givenName+", "+sn+", "+cn+", "+userPassword+", "+userCode+", "+userRole+", "+ipAddress);
		try {
			String sql = "{CALL "+schemaName+"STP_SENDEMAILFROMPORTAL(?,?,?,?,?,?,?,?,?,?,?,?,?,?)}";
			callableStatement = connection.prepareCall(sql);
			callableStatement.setString(1, alertNo);
			callableStatement.setString(2, rasUserCode);
			callableStatement.setString(3, subject);
			callableStatement.setString(4, content);
			callableStatement.setString(5, uid);
			callableStatement.setString(6, logonMailId);
			callableStatement.setString(7, givenName);
			callableStatement.setString(8, sn);
			callableStatement.setString(9, cn);
			callableStatement.setString(10, userPassword);
			callableStatement.setString(11, userCode);
			callableStatement.setString(12, userRole);
			callableStatement.setString(13, ipAddress);
			callableStatement.registerOutParameter(14, OracleTypes.CURSOR);
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			connectionUtil.closeResources(connection, callableStatement, resultSet, null);
		}
	return "Sent email from Portal";	
	}
	
	@Override
	public List<Map<String, String>> getCountWiseModules(String userCode, String ipAddress) {
		List<Map<String, String>> dataList = new ArrayList<Map<String, String>>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;

		try {
			String sql ="SELECT * FROM "+
						"		( "+
						" 		 SELECT COUNT(REPLACE(UPPER(B.MODULEACCESSED),' ','')) TIMESVISITED, UPPER(A.MODULECODE) MODULECODE, A.MODULENAME "+ 
						" 		   FROM ( "+
						" 				 SELECT A.MODULECODE, A.MAINMODULECODE, A.MODULENAME "+
						"   			   FROM TB_MODULE A "+
						"  				  WHERE A.MAINMODULECODE IN (SELECT MAINMODULECODE FROM TB_MODULE WHERE MAINORSUBMODULE = 'S') "+
						"              	    AND MAINORSUBMODULE = 'S' "+
						"  				  UNION "+
						" 				 SELECT A.MODULECODE,A.MAINMODULECODE, A.MODULENAME "+
						"   			   FROM TB_MODULE A "+
						"  				  WHERE MAINMODULECODE IN "+
						"       				(SELECT MAINMODULECODE "+
						"          				   FROM ( "+
						"               				 SELECT COUNT(DISTINCT MODULECODE),A.MAINMODULECODE "+
						"                 				   FROM TB_MODULE A "+
						"                				  GROUP BY A.MAINMODULECODE "+
						"               				 HAVING COUNT(DISTINCT MODULECODE) = 1 "+
						"               				) "+
						"       				)"+
						"				)A , "+schemaName+"TB_SYSTEMAUDITLOG B "+
						" WHERE UPPER(A.MODULECODE) = REPLACE(UPPER(B.MODULEACCESSED),' ','') "+
						"   AND B.USERCODE = ? "+
						"   AND REPLACE(UPPER(B.MODULEACCESSED),' ','') <> 'MOSTVISITEDMODULES' "+
						" GROUP BY REPLACE(UPPER(B.MODULEACCESSED),' ',''), A.MODULECODE, A.MODULENAME "+
						" ORDER BY COUNT(REPLACE(UPPER(B.MODULEACCESSED),' ','')) DESC "+
						" ) WHERE ROWNUM <= 5";
			
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, userCode);
			resultSet = preparedStatement.executeQuery();
	
			while(resultSet.next()) {
				Map<String, String> dataMap = new LinkedHashMap<String, String>();
				
				dataMap.put(resultSet.getString("MODULECODE"), resultSet.getString("MODULENAME"));
				dataList.add(dataMap);
			}
			//System.out.println("dataList = "+dataList);
		}catch(Exception e){
			e.printStackTrace();
		}finally {
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return dataList;
	}
	
	public Map<String, Object> getEmailExchangeDetails(String moduleValue, String moduleType, String userCode, String userRole, String ipAddress){
		Map<String, Object> emailExchangeDetails = new LinkedHashMap<String, Object>();
		Connection connection = connectionUtil.getConnection();
		CallableStatement callableStatement = null;
		ResultSet resultSet = null;
		System.out.println("moduleValue = "+moduleValue+" moduleType = "+moduleType+" userCode = "+userCode+" userRole = "+userRole+" ipAddress = "+ipAddress);
		try{
			callableStatement = connection.prepareCall("{CALL STP_GETEMAILEXCHANGEDETAILS(?,?,?,?,?)}");
			callableStatement.setString(1, moduleValue);
			callableStatement.setString(2, moduleType);
			callableStatement.setString(3, userCode);
			callableStatement.setString(4, userRole);
			callableStatement.setString(5, ipAddress);
			callableStatement.execute();
			resultSet = (ResultSet) callableStatement.getResultSet();
			
			ResultSetMetaData resultSetMetaData = resultSet.getMetaData();
			int columnCount = resultSetMetaData.getColumnCount();
			
			if(resultSet.next()){
				for(int i = 1; i <= columnCount; i++){
					String columnName = resultSetMetaData.getColumnName(i);
					emailExchangeDetails.put(columnName, resultSet.getString(columnName));
				}
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, callableStatement, null, null);
		}
		return emailExchangeDetails;
	}

}

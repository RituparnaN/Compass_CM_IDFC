package com.quantumdataengines.app.compass.dao;

import java.io.File;
import java.sql.Connection;
import java.util.List;
import java.util.Map;

import com.quantumdataengines.app.compass.model.AuditLog;
import com.quantumdataengines.app.compass.schema.Configuration;

public interface CommonDAO {
	public String getUserBranchCode(String userCode);
	public Map<String, String> initilizingDBSystemParameters(Configuration configuration);
	public Map<String, Map<String, Map<String, Map<String, String>>>> userModule(String userCode, String groupCode);
	public String changeProfilePriprity(String userCode, String profile);
	public String lastEmailRefresgLog(String folderType);
	public List<Map<String, String>> getAllEmailRefreshLog();
	public boolean updateLanguage(String userCode, String langCode);
	public boolean updateLabelDirection(String userCode, String labelDirection);
	public List<Map<String, String>> updateUsersSessionList(List<Map<String, String>> allUserDetails);
	public void refreshEmail(Configuration configuration, String userCode, String emailPassword, int lookupDays, String folderName, 
			String folderType, String emailSearchString, String subjectsToIgnore);
	public Map<String, Map<String, String>> getAllOfflineUser(String allOnLineUsers, String currentUser);
	public Map<String, Integer> getMessageMaxNoANDUnSeenCount(String chatWindowId, String userCode);
	public String getMessageMaxNo(String chatWindowId);
	public void saveChatMessage(String jndiName, String chatWindowId, String messageId, String fromUser, String toUser, String messageContent, String seenFlag);
	public String loadPreviuosMessage(String chatWindowId, String userCode, int messageMaxNo, int messageminNo);
	public String loadUnseenMessage(String chatWindowId, String userCode);
	public List<Map<String, String>> getEmailNotification(String userCode, String seenFlag);
	public Map<String, Object> getFileUploadConfig(String moduleRef);
	public void saveUploadedFile(String uploadSeqNo, String uploadRef, String uploadModuleRefId, String moduleUnqNo, String fileName, String filePath, String fileSize, 
			File file, String userCode, String userRole, String ipAddress);
	public List<Map<String, String>> getFileInfo(String uploadRef, String uploadModuleRefId, String moduleUnqNo);
	public int truncateAndGetTempTableColCount(String tableName);
	public boolean processCCRUploadedFile(String procName, String uploadRefId, String moduleRefId, String month, String year,
			String userCode, String roleCode, String ipAddress);
	public List<Map<String, Object>> getFileContentForDownload(String seqNo, String uploadInfo, String moduleUnqNo);
	public List<Map<String, String>> getFilesInfoForModuleUnqNo(String moduleRefNo);
	public String removeServerFile(String seqNo, String uploadRefNo, String moduleRefNo, String moduleUnqNo, String userCode, String userRole, String ipAddress);
	public String getFolderEmailCount(String folderType, String caseNo);
	public List<Map<String, String>> getEmailDetails(String caseNo, String folderType, String emailNumber, String userCode);
	public List<Map<String, String>> getEmailAttachments(String caseNo, String emailNumber);
	public List<Map<String, Object>> downloadEmailAttachment(String caseNo, String messageNumber, String attachmentNumebr);
	public Map<String, Object> getEmailIdsForMapping(String emailCodes, int escalationOrder);
	public Map<String, String> composeEmail(String caseNo, String emailNo, String folderType, String composeType, String userCode, String userRole);
	public Map<String, Object> getDashboardGraphData(String userCode, String userRole, String ipAddress);
	//public void saveUploadFileData(String uploadRefNo, String moduleRefId, List<List<String>> uploadedData, String tempTable, int dataColCount, String userCode, String userRole, String ipAddress);
	public String saveUploadFileData(String uploadRefNo, String moduleRefId, List<List<String>> uploadedData, String tempTable, int dataColCount, File file, String fileName, String userCode, String userRole, String ipAddress);
	
	/*
	public boolean executeFileUploadProcedures(String procedureName, String uploadRefNo, String moduleRefId, String tempTableName, String fileName, String filePath, String userCode, String userRole, String ipAddress);
	*/
	public List<Map<String, String>> getCountWiseModules(String userCode, String ipAddress);
	public String getEmailAddresses(Connection connection, String usercode);
	public String executeFileUploadProcedures(String procedureName, String uploadRefNo, String moduleRefId, String tempTableName, String fileName, String filePath, String userCode, String userRole, String ipAddress);
	public void storeAuditLogNew(AuditLog auditLog);
	public List<Map<String, Object>> getEmailQuestions(String caseNo,String userCode, String userRole, String remoteAddr);
	//public boolean validationCheck(String custId, String accNo);
	public List<Map<String, String>> validationCheck(String custId, String accNo);
	public String saveFileUploadComments(String parameters, String selectedFiles, String status, String markAll, 
			String comments,String userCode, String userRole,String ipAddress);
	public Map<String, Object> getEmailGroups(String caseNo,String userCode, String userRole, String remoteAddr);
	public Map<String,Object> getEmailQuestions(String emailQuestionID);
	public String insertUpdateEamilQuestion(Map<String, String> inputParam,String userCode, String userRole, String ipAddress);
	public Map<String, Object> getQuestionIdAndGroupdetails(String userCode, String userRole, String ipAddress);
	public Map<String, Object> getFileUploadErrorDetails(String uploadRefNo, String moduleRefId, String filename, 
			String userCode, String userRole, String ipAddress);
	public String sendEmailFromPortal(String alertNo, String rasUserCode, String subject, String content, String uid, String logonMailId, 
			String givenName, String sn, String cn, String userPassword, String userCode, String userRole, String ipAddress);
    public String deleteDraftEmail(String caseNo, String emailNumber, String isDraft);
	public Map<String, String> composeStaffEmail(String reportCaseNo, String reportId, String fromDate, String toDate, String staffAccNo, 
			String emailNo, String folderType, String composeType,String userCode, String userRole);
	public Map<String, Object> getEmailExchangeDetails(String moduleValue, String moduleType, String userCode, String userRole, String ipAddress);		
}

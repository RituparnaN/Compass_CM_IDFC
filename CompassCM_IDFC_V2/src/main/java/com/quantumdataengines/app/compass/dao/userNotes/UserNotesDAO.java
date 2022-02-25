package com.quantumdataengines.app.compass.dao.userNotes;

import java.sql.Connection;
import java.util.List;
import java.util.Map;

public interface UserNotesDAO {
	public List<Map<String, String>> getNotesData(String userCode, String currentRole, String ipAddress);
	public String saveUserNotes(String newNoteContent, String newNoteReminderDatetime, String userCode, String currentRole, String ipAddress);
	public String deleteUserNotes(String seqNoList);
	public List<Map<String, String>> getAllNotesData(Connection connection);
}

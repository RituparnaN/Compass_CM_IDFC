package com.quantumdataengines.app.compass.service.userNotes;

import java.util.List;
import java.util.Map;

public interface UserNotesService {
	public List<Map<String, String>> getNotesData(String userCode, String currentRole, String ipAddress);
	public String saveUserNotes(String newNoteContent, String newNoteReminderDatetime, String userCode, String currentRole, String ipAddress);
	public String deleteUserNotes(String seqNoList);
}

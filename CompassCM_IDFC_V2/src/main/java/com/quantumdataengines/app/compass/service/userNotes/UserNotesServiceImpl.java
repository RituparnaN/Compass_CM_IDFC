package com.quantumdataengines.app.compass.service.userNotes;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.quantumdataengines.app.compass.dao.userNotes.UserNotesDAO;

@Service
public class UserNotesServiceImpl implements UserNotesService{
	
	@Autowired
	private UserNotesDAO userNotesDAO;
	
	@Override
	public List<Map<String, String>> getNotesData(String userCode, String currentRole, String ipAddress) {
		return userNotesDAO.getNotesData(userCode, currentRole, ipAddress);
	}

	@Override
	public String saveUserNotes(String newNoteContent, String newNoteReminderDatetime, String userCode, String currentRole, String ipAddress) {
		return userNotesDAO.saveUserNotes(newNoteContent, newNoteReminderDatetime, userCode, currentRole, ipAddress);
	}
	
	@Override
	public String deleteUserNotes(String seqNoList) {
		return userNotesDAO.deleteUserNotes(seqNoList);
	}
}

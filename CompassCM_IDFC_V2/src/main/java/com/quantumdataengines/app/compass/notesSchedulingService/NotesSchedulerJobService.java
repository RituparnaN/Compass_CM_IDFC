package com.quantumdataengines.app.compass.notesSchedulingService;

import java.sql.Connection;
import java.util.List;
import java.util.Map;

public interface NotesSchedulerJobService {
	public List<Map<String, String>> getAllNotesData(Connection connection);
	public String getEmailAddresses(Connection connection, String usercode);
}

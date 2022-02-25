package com.quantumdataengines.app.compass.notesSchedulingService;

import java.sql.Connection;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.quantumdataengines.app.compass.dao.CommonDAO;
import com.quantumdataengines.app.compass.dao.SystemBatchJobDAO;
import com.quantumdataengines.app.compass.dao.userNotes.UserNotesDAO;
import com.quantumdataengines.app.compass.model.AuditLog;
import com.quantumdataengines.app.compass.model.EmailRefresh;
import com.quantumdataengines.app.compass.schema.Configuration;
import com.quantumdataengines.app.compass.util.EmailReceiverUtil;
import com.quantumdataengines.app.compass.util.EmailRefreshUtil;

@Service
public class NotesSchedulerJobServiceImpl implements NotesSchedulerJobService{
	
	@Autowired
	private UserNotesDAO userNotesDAO;
	
	@Autowired
	private CommonDAO commonDAO;
	
	private static final Logger log = LoggerFactory.getLogger(NotesSchedulerJobServiceImpl.class);
	
	@Override
	public List<Map<String, String>> getAllNotesData(Connection connection) {
		return userNotesDAO.getAllNotesData(connection);
	}
	
	@Override
	public String getEmailAddresses(Connection connection, String usercode) {
		return commonDAO.getEmailAddresses(connection, usercode);
	}
	
}

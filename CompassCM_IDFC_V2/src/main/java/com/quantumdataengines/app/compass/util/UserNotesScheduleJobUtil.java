package com.quantumdataengines.app.compass.util;

import java.sql.Connection;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.quantumdataengines.app.compass.batchservice.SystemBatchJobService;
import com.quantumdataengines.app.compass.notesSchedulingService.NotesSchedulerJobService;
import com.quantumdataengines.app.compass.schema.Configuration;
import com.quantumdataengines.app.compass.service.CommonService;

@Component
public class UserNotesScheduleJobUtil {
	private static final Logger log = LoggerFactory.getLogger(UserNotesScheduleJobUtil.class);
	@Autowired
	private ConfigurationsDetails configurationsDetails;
	@Autowired
	private ConnectionUtil connectionUtil;
	
	@Autowired
	private NotesSchedulerJobService notesSchedulerJobService;
	
	@Autowired
	private SystemBatchJobService reportScheduleJobService;
	
	@Autowired
	private EmailSenderUtil emailSenderUtil;
	
	
	@Scheduled(cron = "${compass.aml.config.userNotesScheduleJobCron}")
	public void UserNotesSchedulerThread() throws Exception{
		List<String> instituteList = configurationsDetails.getInstitutionsList();
		List<Thread> userNotesScheduleJobThreadList = new ArrayList<Thread>();	

		for (final String instituteName : instituteList) {
			Thread thread = new Thread(new Runnable() {
				@Override
				public void run() {
					
					log.info("Staring scheduled user notes email task execution for "+instituteName);
					try{
						String instituteJndiName = configurationsDetails.getJndiNameFromInstitution(instituteName);
						Configuration configuration = configurationsDetails.getConfigurationForInstitution(instituteName);
						Map<String, String> systemParameters = null;
						Connection connection = null;				
						
						try{
							connection = connectionUtil.getConnection(instituteJndiName);
							systemParameters = reportScheduleJobService.initilizingDBSystemParameters(connection);
							log.info("System parameters initialized for "+instituteName);
							sendUserNotesEmail(configuration, systemParameters, connection);
						}catch(Exception e){
							e.printStackTrace();
							log.error("Error while performing scheduled user notes email job for institute "+instituteName+" : "+e.getMessage());
						}finally{
							connectionUtil.closeResources(connection, null, null, null);
						}
						
					}catch(Exception e){
						e.printStackTrace();
						log.error("Error ocurred while sending scheduled report email for :" +instituteName);
					}
				}
			});
			userNotesScheduleJobThreadList.add(thread);
		}

		for(Thread thread : userNotesScheduleJobThreadList){
			try{
				thread.start();
			}
			catch(Exception e){}
		}
	}
	
	
	protected void sendUserNotesEmail(Configuration configuration, Map<String, String> systemParameters, 
			Connection connection) {
		try{
			String emailPassword = "";
			if(systemParameters != null) {
				emailPassword = systemParameters.get("EMAILPASSSWORD");
				String currentTimeStamp = new SimpleDateFormat("dd/MM/yyyy HH:mm").format(new Date());
				List<Map<String, String>> allUserNotesData = notesSchedulerJobService.getAllNotesData(connection);
				
				for(Map<String, String> eachRecord: allUserNotesData) {
					String usercode = "";
					String subject = "";
					StringBuilder content = new StringBuilder();
					//System.out.println(currentTimeStamp +"---"+ eachRecord.get("REMINDERTIME"));
					if(eachRecord.get("REMINDERTIME") != null && eachRecord.get("REMINDERTIME").equals(currentTimeStamp)) {
						usercode = eachRecord.get("UPDATEDBY");
						String emailAddress = notesSchedulerJobService.getEmailAddresses(connection, usercode);
						String[] toEmailIds = new String[] {emailAddress};
						
						subject = "Compass Reminder for User Notes at "+eachRecord.get("REMINDERTIME");
						content.append("<p>The reminder note is: </p>");
						//content.append("-------------------------------");
						content.append("<p style='font-weight: bold'>"+eachRecord.get("NOTES")+"</p>");
						
						emailSenderUtil.sendEmail(configuration, emailPassword, false, false, toEmailIds, null, null, null, subject, content.toString());
					}
				}
			}
			
		}catch(Exception e){
			e.printStackTrace();
		}
	}
	
}

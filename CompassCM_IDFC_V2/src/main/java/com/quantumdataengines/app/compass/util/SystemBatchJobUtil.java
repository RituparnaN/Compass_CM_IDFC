package com.quantumdataengines.app.compass.util;

import java.sql.Connection;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.concurrent.CopyOnWriteArrayList;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.quantumdataengines.app.compass.batchservice.SystemBatchJobService;
import com.quantumdataengines.app.compass.model.AuditLog;
import com.quantumdataengines.app.compass.schema.Configuration;
import com.quantumdataengines.app.compass.schema.Provider;

@Component
public class SystemBatchJobUtil {
	private static final Logger log = LoggerFactory.getLogger(SystemBatchJobUtil.class);
	@Autowired
	private ConfigurationsDetails configurationsDetails;
	@Autowired
	private ConnectionUtil connectionUtil;
	@Autowired
	private SystemBatchJobService systemBatchJobService;
	/*
	@Scheduled(cron = "${compass.aml.config.auditLogJobCron}")
	public void auditLogJob() throws Exception{
		log.debug("Staring audit log job...");
		AuditLogUtil.setProcessing(true);
		Map<String, List<AuditLog>> auditLogList = AuditLogUtil.getAuditLogList();
		Iterator<String> itr = auditLogList.keySet().iterator();
		while(itr.hasNext()){
			String entityName = itr.next();
			Configuration configuration = configurationsDetails.getConfigurationForInstitution(entityName);
			List<AuditLog> auditList = new CopyOnWriteArrayList<AuditLog>(auditLogList.get(entityName));
			
			if(auditList.size() > 0){
				log.debug("Audit logging started for "+entityName+".");
				String jndiName = configuration.getJndiDetails().getJndiName();
				systemBatchJobService.storeAuditLog(jndiName, auditList);
				log.debug("Audit log stored for "+entityName+".");
			}
			
			AuditLogUtil.newInstance(entityName);
		}
		AuditLogUtil.setProcessing(false);
		log.debug("System Audit logging Completed");
	}
	*/
	
	@Scheduled(cron = "${compass.aml.config.systemBatchJobCron}")
	public void runSystemBatchJob() throws Exception{
		List<String> instituteList = configurationsDetails.getInstitutionsList();
		List<Thread> systemBatchJobThreadList = new ArrayList<Thread>();	
		
		for (final String instituteName : instituteList) {
			Thread thread = new Thread(new Runnable() {
				@Override
				public void run() {
					
					log.info("Staring system batch task execution for "+instituteName);
					try{
						String instituteJndiName = configurationsDetails.getJndiNameFromInstitution(instituteName);
						Configuration configuration = configurationsDetails.getConfigurationForInstitution(instituteName);
						Map<String, String> systemParameters = null;
						Connection connection = null;				
						
						try{
							connection = connectionUtil.getConnection(instituteJndiName);
							systemParameters = systemBatchJobService.initilizingDBSystemParameters(connection);
							log.info("System parameters initialized for "+instituteName);
						}catch(Exception e){
							e.printStackTrace();
							log.error("Error while performing system batch job for institute "+instituteName+" : "+e.getMessage());
						}finally{
							connectionUtil.closeResources(connection, null, null, null);
						}
						
						// account expiry batch job
						try{
							connection = connectionUtil.getConnection(instituteJndiName);
							systemBatchJobService.accountExpiryJob(connection);
							log.info("account expiry job completed for "+instituteName);
						}catch(Exception e){
							e.printStackTrace();
							log.error("Error while performing system batch job for institute "+instituteName+" : "+e.getMessage());
						}finally{
							connectionUtil.closeResources(connection, null, null, null);
						}
						
						// Password expiry batch job 
						if(configuration.getAuthentication().getProvider().equals(Provider.DATABASE)){
							try{
								int expiryDay = 0;
								try{
									expiryDay = Integer.parseInt(systemParameters.get("PASSWORDEXPIRY"));
								}catch(Exception e){}
								if(expiryDay != 0){
									connection = connectionUtil.getConnection(instituteJndiName);
									systemBatchJobService.passwordExpiryJob(connection, expiryDay);
									log.info("password expiry job completed for "+instituteName);
								}								
							}catch(Exception e){
								e.printStackTrace();
								log.error("Error while performing system batch job for institute "+instituteName+" : "+e.getMessage());
							}finally{
								connectionUtil.closeResources(connection, null, null, null);
							}
						}
						
						
						// email auto refresh batch job
						String emailPassword = systemParameters.get("EMAILPASSSWORD");
						String subjectsToIgnore = systemParameters.get("SUBJECTESCAPESTRING");
						String emailSearchString = systemParameters.get("CASESEARCHSTRING");
						String sentRefresh = systemParameters.get("SENTFOLDERREFRESH");
						String sentFolderName = systemParameters.get("SENTFOLDERNAME");
						String inboxRefresh = systemParameters.get("INBOXFOLDERREFRESH");
						String inboxFolderName = systemParameters.get("INBOXFOLDERNAME");
						String emailAutoRefresh = systemParameters.get("EMAILAUTOREFRESH");
						int lookupDays = 1;
						try{
							lookupDays = Integer.parseInt(systemParameters.get("LOOKUPDAYS"));
						}catch(Exception e){}
						if(emailAutoRefresh.equals("Y")){
							if(inboxRefresh.equals("Y")){
								try{
									log.info("email[inbox] refresh job initiated for "+instituteName);
									connection = connectionUtil.getConnection(instituteJndiName);
									systemBatchJobService.emailRefreshJob(connection, configuration, "SYSTEM", 
											emailPassword, lookupDays, inboxFolderName, "INBOX", emailSearchString, subjectsToIgnore);
									log.info("email[inbox] refresh job completed for "+instituteName);
								}catch(Exception e){
									e.printStackTrace();
									log.error("Error while performing system batch job for institute "+instituteName+" : "+e.getMessage());
								}finally{
									connectionUtil.closeResources(connection, null, null, null);
								}
							}
							
							if(sentRefresh.equals("Y")){
								try{
									log.info("email[sent] refresh job initiated for "+instituteName);
									connection = connectionUtil.getConnection(instituteJndiName);
									systemBatchJobService.emailRefreshJob(connection, configuration, "SYSTEM", 
											emailPassword, lookupDays, sentFolderName, "SENT", emailSearchString, subjectsToIgnore);
									log.info("email[sent] refresh job completed for "+instituteName);
								}catch(Exception e){
									e.printStackTrace();
									log.error("Error while performing system batch job for institute "+instituteName+" : "+e.getMessage());
								}finally{
									connectionUtil.closeResources(connection, null, null, null);
								}
							}
						}
					}catch(Exception e){
						e.printStackTrace();
						log.error("Error ocurred while executing system batch task for :" +instituteName);
					}
					
				}
			});
			
			systemBatchJobThreadList.add(thread);
		}
		
		
		for(Thread thread : systemBatchJobThreadList){
			try{
			thread.start();
			}catch(Exception e){}
		}
	}
}

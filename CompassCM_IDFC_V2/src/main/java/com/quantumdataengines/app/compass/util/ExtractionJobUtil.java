package com.quantumdataengines.app.compass.util;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Vector;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.quantumdataengines.app.compass.dao.etl.emailSettings.ETLEmailSettingsDAO;
import com.quantumdataengines.app.compass.dao.etl.extraction.ExtractionDAO;
import com.quantumdataengines.app.compass.model.Extraction;
import com.quantumdataengines.app.compass.model.ExtractionDBMessage;
import com.quantumdataengines.app.compass.model.ExtractionProcedure;
import com.quantumdataengines.app.compass.model.RunningProcedure;
import com.quantumdataengines.app.compass.otherservice.OtherCommonService;
import com.quantumdataengines.app.compass.schema.Configuration;

@Component
public class ExtractionJobUtil {
	private static final Logger log = LoggerFactory.getLogger(ExtractionJobUtil.class);

	@Autowired
	private ExtractionUtil extractionUtil;
	@Autowired
	private OtherCommonService otherCommonService;
	@Autowired
	private ExtractionDAO extractionDAO;
	@Autowired
	private ETLEmailSettingsDAO eTLEmailSettingsDAO;
	@Autowired
	private EmailSenderUtil emailSenderUtil;
	
	public Thread ExtractionThreadStartPoint(final Configuration configuration, final String a_strFromdate, final String a_strToDate, final String a_strUserCode){
		Thread m_threadExtractionMain = new Thread(new Runnable() {
			public void run() {
				Extraction extraction = extractionUtil.getInstance(configuration.getEntityName());
				List<ExtractionProcedure> totalProceList = extractionDAO.getAllProcedureList(configuration);				
				log.info("Total "+totalProceList.size()+" procedures will be executed");
				extraction.setTotalProceduresList(totalProceList);
				
				List<Integer> l_listAllGroupId = extractionDAO.getAllGroup(configuration);
				int l_intGruopSize = l_listAllGroupId.size();				
				log.info("No of groups : "+l_intGruopSize);
				
				int l_intProcessCheckingInterval = 10000;				
				log.info("Interval : 10 seconds");
				
				List<ExtractionProcedure> l_listParallelProcList = new Vector<ExtractionProcedure>();
				List<ExtractionProcedure> l_listNonParallelProcList = new Vector<ExtractionProcedure>();				
				List<ExtractionProcedure> l_listAllProceduresInGroup = new Vector<ExtractionProcedure>();
				
				boolean nextGroupExecutionFlag = true;
				boolean sequentialExecutionFlag = true;
				int completePercentage;
				int groupFlag = 0;
				Thread progressThread = ProgressBarStatusThreadStartPoint(configuration);
				extraction.setProcessThread(progressThread);
				progressThread.start();
				do{					
					completePercentage = extraction.getPercentage();
					
					if(completePercentage != 100){
						while (nextGroupExecutionFlag && (groupFlag < l_intGruopSize)) {
							nextGroupExecutionFlag = false;
							sequentialExecutionFlag = true;
							l_listParallelProcList = new Vector<ExtractionProcedure>();
							l_listNonParallelProcList = new Vector<ExtractionProcedure>();
							
							l_listAllProceduresInGroup = extractionDAO.getAllProcedureInGroup(configuration, l_listAllGroupId.get(groupFlag));
							log.info("No of procedures in the group id "+l_listAllGroupId.get(groupFlag)+" : "+l_listAllProceduresInGroup.size());
							for(ExtractionProcedure a_listProc : l_listAllProceduresInGroup){
								if(a_listProc.isInParallel()){
									l_listParallelProcList.add(a_listProc);
								}else{
									l_listNonParallelProcList.add(a_listProc);
								}
							}
							
							log.info(l_listParallelProcList.size()+" procedures for the group id "+l_listAllGroupId.get(groupFlag)+" will be executed in parallel");
							log.info(l_listNonParallelProcList.size()+" procedures for the group id "+l_listAllGroupId.get(groupFlag)+" will be executed in sequence");
							
							if(l_listParallelProcList.size() > 0){
								log.info("Starting parallel execution...");
								ParallelThreadStartPoint(configuration, l_listParallelProcList, a_strFromdate, a_strToDate, a_strUserCode).start();
							}						
							groupFlag++;
						}
						// If the current group is having sequential execution order and the parallel execution is completed then execute sequential order
						int l = groupFlag - 1;
						int l_intProcedureCompletedInGroup = extraction.getProceduresCompletedInGroup(l_listAllGroupId.get(l));
						if((l_listNonParallelProcList.size() > 0) && sequentialExecutionFlag && (l_intProcedureCompletedInGroup == l_listParallelProcList.size())){
							sequentialExecutionFlag = false;
							log.info("Starting sequential execution...");
							SequentialThreadStartPoint(configuration, l_listNonParallelProcList, a_strFromdate, a_strToDate, a_strUserCode).start();
						}
						
						if(l_listAllProceduresInGroup.size() > 0)
							log.info("Procedure Completed In The GROUP("+l_listAllGroupId.get(l)+"): "+l_intProcedureCompletedInGroup+" OUT OF "+l_listAllProceduresInGroup.size()+"");
												
						try {
							if(l_intProcedureCompletedInGroup != l_listAllProceduresInGroup.size()){
								// Put the progress thread in the sleep.
								Thread.sleep(l_intProcessCheckingInterval);
							}else{
								// Group Job completed. Need the while loop to be executed.
								l_listAllProceduresInGroup = new Vector<ExtractionProcedure>();
								nextGroupExecutionFlag = true;
							}
						} catch (InterruptedException e) {
							e.printStackTrace();
						}
					}
				}while(completePercentage < 100);
			}
		});
		extractionUtil.getInstance(configuration.getEntityName()).setMainThread(m_threadExtractionMain);
		return m_threadExtractionMain;
	}
	
	private Thread ProgressBarStatusThreadStartPoint(final Configuration configuration){		
		Thread m_threadProgressStatus = new Thread(new Runnable() {			
			public void run() {
				boolean shouldRun = true;
				Extraction extraction = extractionUtil.getInstance(configuration.getEntityName());
				while (shouldRun) {
					try{
						Thread.sleep(3000);
					}catch(Exception e){}
					
					try{
						int completePercentage = extraction.getPercentage();
						if(completePercentage < 100){
							if(extraction.getStatus() == 1){
								extraction.setTimeMessage("Time Elapsed");
								extraction.setTimeValue(timeDiffString(extraction.getStartDate(), new Date()));
								extraction.setStrEndDateMessage("Status");
								extraction.setStrEndDateValue("Running");
							}							
						}else{
							extraction.setEndDate(new Date());
							extraction.setStrEndDateMessage("Completed");
							extraction.setStrEndDateValue(otherCommonService.getFormattedDate(new Date(), "dd/MM/yyyy HH:mm:ss"));
							extraction.setStatus(2);
							extraction.setTimeMessage("Time Taken");
							extraction.setTimeValue(timeDiffString(extraction.getStartDate(), new Date()));
							shouldRun = false;
							extraction.setLastMessage("Completed");
							sendETLEmail(configuration);
							stopAllThread(configuration, "ETL Successful");
						}
					}catch(Exception e){
						log.error("Error while getting progress percentage.");
					}
					
					try{
						extraction.setCompletedProceduresList(extractionDAO.getCompletedProcedureList(configuration));
						List<ExtractionDBMessage> extractionDBMessage = extractionDAO.getProcessMessage(configuration);
						extraction.setExtractionDBMessageList(extractionDBMessage);
						extraction.setLastMessage(extractionDBMessage != null && extractionDBMessage.size() > 0 ? extractionDBMessage.get(0).getStatusMessage() : "");
					}catch(Exception e){
						log.error("Error while getting the progress message");
					}

					try{
						Thread.sleep(7000);
					}catch(Exception e){
						
					}
				}
			}
		});
		m_threadProgressStatus.setName("ProgressBarStatusThread");
		return m_threadProgressStatus;
	}
	
	private Thread ParallelThreadStartPoint(final Configuration configuration, final List<ExtractionProcedure> a_listParallelProcList, 
			final String a_strFromdate, final String a_strToDate, final String a_strUserCode){
		Thread m_threadParallelMain = new Thread(new Runnable() {
			public void run() {
				Extraction extraction = extractionUtil.getInstance(configuration.getEntityName());
				log.info("Processes creating for the parallel execution for "+a_listParallelProcList.size()+" procedures");
				int l_intNumberOfThreads = a_listParallelProcList.size();
				ExecutorService executor = Executors.newFixedThreadPool(l_intNumberOfThreads);
				List<Thread> l_threadChildThreadList = getThreadsOfProcedureForParallelExecution(configuration, a_listParallelProcList, a_strFromdate, a_strToDate, a_strUserCode);
				extraction.setParallelThread(l_threadChildThreadList);
				for(Thread a_threadChildThread : l_threadChildThreadList){
					executor.execute(a_threadChildThread);
				}
				executor.shutdown();
			}
		});
		extractionUtil.getInstance(configuration.getEntityName()).setParallelMainThread(m_threadParallelMain);
		m_threadParallelMain.setName("ParallelThread");
		return m_threadParallelMain;
	}
	
	private List<Thread> getThreadsOfProcedureForParallelExecution(final Configuration configuration, List<ExtractionProcedure> a_listParallelProcList, final String a_strFromdate, 
			final String a_strToDate, final String a_strUserCode){
		int l_intThreadIndex = 1;
		List<Thread> l_listThread = new Vector<Thread>();
		for(final ExtractionProcedure a_objProc : a_listParallelProcList){
			Thread l_threadChildThread = new Thread(new Runnable() {
				public void run(){
					String l_strProcName = a_objProc.getProcedureName();
					log.info("Executing procedure : "+l_strProcName);
					ExecuteProcedure(configuration, a_objProc, a_strFromdate, a_strToDate, a_strUserCode);
				}
			});
			l_threadChildThread.setName("ChildThread"+l_intThreadIndex);
			l_listThread.add(l_threadChildThread);
			l_intThreadIndex++;
		}
		return l_listThread;
	}
	
	private Thread SequentialThreadStartPoint(final Configuration configuration,final List<ExtractionProcedure> a_listNonParallelProcList, final String a_strFromdate, 
			final String a_strToDate, final String a_strUserCode){
		Thread m_threadSequentialMain = new Thread(new Runnable() {
				public void run(){
					try{
						ExecuteProcedureNormally(configuration, a_listNonParallelProcList, a_strFromdate, a_strToDate, a_strUserCode);
					}catch(Exception e){
						log.error("Error occured from SequentialThreadStartPoint : "+e.getMessage());
						e.printStackTrace();
					}
				}
			});
		extractionUtil.getInstance(configuration.getEntityName()).setSequentialhread(m_threadSequentialMain);
		m_threadSequentialMain.setName("SequentialThread");
		return m_threadSequentialMain;
	}
	
	private boolean ExecuteProcedureNormally(Configuration configuration, List<ExtractionProcedure> a_listNonParallelProcList, 
			String a_strFromdate, String a_strToDate, String a_strUserCode) throws Exception{
		for(ExtractionProcedure a_objProc : a_listNonParallelProcList){
			String l_strProcName = a_objProc.getProcedureName();
			log.info("Executing procedure : "+l_strProcName);
			ExecuteProcedure(configuration, a_objProc, a_strFromdate, a_strToDate, a_strUserCode);
		}
		return true;
	}
	
	private void ExecuteProcedure(Configuration configuration, ExtractionProcedure a_objProc, String a_strFromdate, String a_strToDate, String userCode){
		Date executionStartDate = new Date();
		Extraction extraction = extractionUtil.getInstance(configuration.getEntityName());
		RunningProcedure currentProc = new RunningProcedure();
		try{currentProc.setStartDate(otherCommonService.getFormattedDate(executionStartDate, "dd/MM/yyyy HH:mm:ss"));}catch(Exception e){};
		currentProc.setProcesure(a_objProc);
		currentProc.setStatus("Running");
		currentProc.setCompleteTime("");
		currentProc.setEndDate("");
		Map<Integer, Map<String, RunningProcedure>> mainMap = extraction.getRunningProc();
		Map<String, RunningProcedure> secondMap = null;
		if(mainMap.containsKey(a_objProc.getGroupId())){
			secondMap = mainMap.get(a_objProc.getGroupId());
			secondMap.put(a_objProc.getProcedureName(), currentProc);	
		}else{
			secondMap = new HashMap<String, RunningProcedure>();
			secondMap.put(a_objProc.getProcedureName(), currentProc);
			mainMap.put(a_objProc.getGroupId(), secondMap);
		}
		try{
			if(a_objProc.isEnable()){
				extractionDAO.ExecuteProcedure(configuration, a_objProc, a_strFromdate, a_strToDate, userCode);
				currentProc.setStatus("Completed");
			}else{
				extractionDAO.saveSkippedProcedureInProcessLog(configuration, a_objProc);
				currentProc.setStatus("Skipped");
			}
			
			Date executionEndDate = new Date();
			String timeTaken = timeDiffString(executionStartDate, executionEndDate);			
			try{currentProc.setEndDate(otherCommonService.getFormattedDate(executionEndDate, "dd/MM/yyyy HH:mm:ss"));}catch(Exception e){};
			currentProc.setCompleteTime(timeTaken);
			
			secondMap.remove(a_objProc.getProcedureName());
			secondMap.put(a_objProc.getProcedureName(), currentProc);
			log.info("Execution completed for "+a_objProc.getProcedureName()+". Started At : "+otherCommonService.getFormattedDate(executionStartDate, "dd/MM/yyyy HH:mm:ss")+" Time taken -> "+timeTaken);
		}catch(Exception e){
			try{currentProc.setEndDate(otherCommonService.getFormattedDate(new Date(), "dd/MM/yyyy HH:mm:ss"));}catch(Exception ex){};
			currentProc.setStatus("Interrupted");
			currentProc.setCompleteTime("-");			
			secondMap.remove(a_objProc.getProcedureName());
			secondMap.put(a_objProc.getProcedureName(), currentProc);
			log.error("Extraction interrupted in "+a_objProc.getProcedureName());
			extraction.setEndDate(new Date());
			extraction.setStrEndDateMessage("Interrupted");
			extraction.setStrEndDateValue(otherCommonService.getFormattedDate(new Date(), "dd/MM/yyyy HH:mm:ss"));
			extraction.setStatus(3);
			try{extraction.addExtractionErrorMessageList(new ExtractionDBMessage(-1, otherCommonService.getFormattedDate(new Date(), "dd/MM/yyyy HH:mm:ss"), a_objProc.getProcedureName(), e.getMessage()));}catch(Exception ex){}
			try{extraction.setLastMessage("Error while executing process "+a_objProc.getProcedureName()+" : "+e.getMessage());}catch(Exception ex){}
			sendETLEmail(configuration);
			stopAllThread(configuration, e.getMessage());
			e.printStackTrace();
		}
	}
	
	public String timeDiffString(Date startDate, Date endDate){
		long l_longTimeDiff = endDate.getTime() - startDate.getTime();
		long l_longHour = l_longTimeDiff/3600000;
		long l_longMin = (l_longTimeDiff - (l_longHour*3600000))/60000;
		long l_longSec = (l_longTimeDiff - (l_longHour*3600000) - (l_longMin*60000))/1000;
		return l_longHour+" hour "+l_longMin+" minute "+l_longSec+" second";
	}
	
	public void cancelOperation(Configuration configuration){
		try{
			Extraction extraction = extractionUtil.getInstance(configuration.getEntityName());
			Map<Integer, Map<String, RunningProcedure>> mainMap = extraction.getRunningProc();
			extraction.setEndDate(new Date());
			extraction.setStrEndDateMessage("Cancelled");
			extraction.setStrEndDateValue(otherCommonService.getFormattedDate(new Date(), "dd/MM/yyyy HH:mm:ss"));
			extraction.setStatus(4);
			try{
				Iterator<Integer> itr1 = mainMap.keySet().iterator();
				while (itr1.hasNext()) {
					int groupID = itr1.next();
					Map<String, RunningProcedure> secondMap = mainMap.get(groupID);
					Iterator<String> itr2 = secondMap.keySet().iterator();
					while (itr2.hasNext()) {
						String procName = itr2.next();
						RunningProcedure runningProc = secondMap.get(procName);
						if(runningProc.getEndDate().equals("Running")){
							try{runningProc.setEndDate(otherCommonService.getFormattedDate(new Date(), "dd/MM/yyyy HH:mm:ss"));}catch(Exception ex){};
							runningProc.setStatus("Cancelled");
							runningProc.setCompleteTime("-");
						}							
					}
				}
			}catch(Exception ex){}
			extraction.setLastMessage("Extraction terminated");
			sendETLEmail(configuration);
			stopAllThread(configuration, "Operation Cancelled");
		}catch(Exception e){
			
		}
	}
	
	@SuppressWarnings("deprecation")
	private void stopAllThread(Configuration configuration, String message){
		Extraction extraction = extractionUtil.getInstance(configuration.getEntityName());
		Thread mainThread = extraction.getMainThread();
		Thread parallelMailThread = extraction.getParallelMainThread();
		List<Thread> parallelThreads = extraction.getParallelThread();
		Thread sequentialThread = extraction.getSequentialhread();
		Thread progressThread = extraction.getProcessThread();
		
		try{
			progressThread.stop();
		}catch(Exception e){}
		
		try{
			sequentialThread.stop();
		}catch(Exception e){}
		
		for(Thread thread : parallelThreads){
			try{
				thread.stop();
			}catch(Exception e){}
		}
		
		try{
			parallelMailThread.stop();
		}catch(Exception e){}
		try{
			mainThread.stop();
		}catch(Exception e){}
	}
	
	private void sendETLEmail(Configuration configuration){
		List<String> successRecpientsTO = new ArrayList<String>();
		List<String> successRecpientsCC = new ArrayList<String>();
		List<String> failRecpientsTO = new ArrayList<String>();
		List<String> failRecpientsCC = new ArrayList<String>();
		
		Extraction extraction = extractionUtil.getInstance(configuration.getEntityName());
		Map<String, String> emailSettings = eTLEmailSettingsDAO.getEmailSettings(configuration);
		String password = emailSettings.get("ETLEMAILPASSWORD");
		
		try{
			String[] successRecpTOArr = emailSettings.get("SUCCESSRECIPIENTSTO").split(";");
			for(String successRecpTO : successRecpTOArr){
				if(successRecpTO != null && !successRecpTO.equals("")){
					successRecpientsTO.add(successRecpTO);
				}
			}
		}catch(Exception e){}
		
		try{
			String[] successRecpCCArr = emailSettings.get("SUCCESSRECIPIENTSCC").split(";");
			for(String successRecpCC : successRecpCCArr){
				if(successRecpCC != null && !successRecpCC.equals("")){
					successRecpientsCC.add(successRecpCC);
				}
			}
		}catch(Exception e){}
		
		try{
			String[] failRecpTOArr = emailSettings.get("FAILCANCELRECIPIENTSTO").split(";");
			for(String failRecpTO : failRecpTOArr){
				if(failRecpTO != null && !failRecpTO.equals("")){
					failRecpientsTO.add(failRecpTO);
				}
			}
		}catch(Exception e){}
		
		try{
			String[] failRecpCCArr = emailSettings.get("FAILCANCELRECIPIENTSCC").split(";");
			for(String failRecpCC : failRecpCCArr){
				if(failRecpCC != null && !failRecpCC.equals("")){
					failRecpientsCC.add(failRecpCC);
				}
			}
		}catch(Exception e){}
		
		
		int status = extraction.getStatus();
		String content = "";
		String subject = "";
		if(status == 2){
			subject = "CompassETL AutoEmail : CompassETL has been successfully completed for process date "+extraction.getStrProcessStartDate();
			content = "Hello, <br/>This is an auto email sent from CompassETL to notify you that the ETL process has been successfully completed. "+
					  "Please find more information below about the process.<br/><br/>"+
					  "<table style=\"width: 100%;text-align: center;\""+
					  "<tr><th width=\"30%\">Process Date</th><td width=\"70%\">"+extraction.getStrProcessStartDate()+"-"+extraction.getStrProcessEndDate()+"</td></tr>"+
					  "<tr><th width=\"30%\">Started</th><td width=\"70%\">"+extraction.getStrStartDate()+"</td></tr>"+
					  "<tr><th width=\"30%\">"+extraction.getStrEndDateMessage()+"</th><td width=\"70%\">"+extraction.getStrEndDateValue()+"</td></tr>"+
					  "<tr><th width=\"30%\">"+extraction.getTimeMessage()+"</th><td width=\"70%\">"+extraction.getTimeValue()+"</td></tr>"+
					  "</table><br/><br/>Thank you,<br/>CompassETL";
			try{
				extraction.setLastMessage("Sending email...");
				emailSenderUtil.sendEmail(configuration, password, false, true, 
					successRecpientsTO.toArray(new String[successRecpientsTO.size()]), 
					successRecpientsCC.toArray(new String[successRecpientsCC.size()]), 
					null, null, subject, content);
			}catch(Exception e){
				log.error("Error while sending email at ETL completion : "+e.getMessage());
				e.printStackTrace();
			}
		}
		if(status == 3){
			List<ExtractionDBMessage> errorMessageList = extraction.getExtractionErrorMessageList();
			subject = "CompassETL AutoEmail : Error interrupted CompassETL for process date "+extraction.getStrProcessStartDate();
			content = "Hello, <br/>This is an auto email sent from CompassETL to notify you that the ETL process has been interrupted due to an error. "+
					  "Please find more information below about the process.<br/><br/>"+
					  "<table style=\"width: 100%;text-align: center;\""+
					  "<tr><th width=\"30%\">Process Date</th><td width=\"70%\">"+extraction.getStrProcessStartDate()+"-"+extraction.getStrProcessEndDate()+"</td></tr>"+
					  "<tr><th width=\"30%\">Started</th><td width=\"70%\">"+extraction.getStrStartDate()+"</td></tr>"+
					  "<tr><th width=\"30%\">"+extraction.getStrEndDateMessage()+"</th><td width=\"70%\">"+extraction.getStrEndDateValue()+"</td></tr>"+
					  "<tr><th width=\"30%\">"+extraction.getTimeMessage()+"</th><td width=\"70%\">"+extraction.getTimeValue()+"</td></tr>";
					  
			for(ExtractionDBMessage extractionDBMessage : errorMessageList){
				content = content + "<tr style=\"color:red\"><th width=\"30%\">"+extractionDBMessage.getProcessName()+"</th><td width=\"70%\">"+extractionDBMessage.getStatusMessage()+"</td></tr>";
			}
			content = content + "</table><br/><br/>Thank you,<br/>CompassETL";
			if("Y".equals(emailSettings.get("SENDEMAILONFAIL"))){
				extraction.setLastMessage("Sending email...");
				List<String> toAddress = failRecpientsTO;
				List<String> ccAddress = failRecpientsCC;
				if("Y".equals(emailSettings.get("SUCCESSFAILIDSSAME"))){
					toAddress = successRecpientsTO;
					ccAddress = successRecpientsCC;
				}
				try{
					emailSenderUtil.sendEmail(configuration, password, false, true, 
							toAddress.toArray(new String[toAddress.size()]), 
							ccAddress.toArray(new String[ccAddress.size()]), 
						null, null, subject, content);
				}catch(Exception e){
					log.error("Error while sending email at ETL interruption : "+e.getMessage());
					e.printStackTrace();
				}
			}
		}
		if(status == 4){
			subject = "CompassETL AutoEmail : CompassETL has been terminated for process date "+extraction.getStrProcessStartDate();
			content = "Hello, <br/>This is an auto email sent from CompassETL to notify you that the ETL process has been manually terminated. "+
					  "Please find more information below about the process.<br/><br/>"+
					  "<table style=\"width: 100%;text-align: center;\""+
					  "<tr><th width=\"30%\">Process Date</th><td width=\"70%\">"+extraction.getStrProcessStartDate()+"-"+extraction.getStrProcessEndDate()+"</td></tr>"+
					  "<tr><th width=\"30%\">Started</th><td width=\"70%\">"+extraction.getStrStartDate()+"</td></tr>"+
					  "<tr><th width=\"30%\">"+extraction.getStrEndDateMessage()+"</th><td width=\"70%\">"+extraction.getStrEndDateValue()+"</td></tr>"+
					  "<tr><th width=\"30%\">"+extraction.getTimeMessage()+"</th><td width=\"70%\">"+extraction.getTimeValue()+"</td></tr>"+
					  "</table><br/><br/>Thank you,<br/>CompassETL";
			
			if("Y".equals(emailSettings.get("SENDEMAILONCANCEL"))){
				extraction.setLastMessage("Sending email...");
				List<String> toAddress = failRecpientsTO;
				List<String> ccAddress = failRecpientsCC;
				if("Y".equals(emailSettings.get("SUCCESSFAILIDSSAME"))){
					toAddress = successRecpientsTO;
					ccAddress = successRecpientsCC;
				}
				try{
					emailSenderUtil.sendEmail(configuration, password, false, true, 
							toAddress.toArray(new String[toAddress.size()]), 
							ccAddress.toArray(new String[ccAddress.size()]), 
						null, null, subject, content);
				}catch(Exception e){
					log.error("Error while sending email at ETL termination : "+e.getMessage());
					e.printStackTrace();
				}
			}
		}
	}
}

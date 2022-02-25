package com.quantumdataengines.app.compass.util;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.util.Date;

import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.AfterThrowing;
import org.aspectj.lang.annotation.Aspect;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import com.quantumdataengines.app.compass.batchservice.SystemBatchJobService;

@Aspect
@Component
public class ExceptionLoggerAutoProxy {
	
	private static final Logger log = LoggerFactory.getLogger(ExceptionLoggerAutoProxy.class);
	@Value("${compass.aml.config.enableExceptionLogger}")
	private String enableExceptionLogger;
	@Value("${compass.aml.paths.exceptionlogger}")
	private String exceptionLoggerPath;
	
	@Autowired
	private SystemBatchJobService systemBatchJobService;
	
	@AfterThrowing(pointcut = "execution(public * com.quantumdataengines.app.compass.controller..*(..))", throwing = "e")
	public void ExceptionLogger(JoinPoint joinPoint, Exception e){
		if(enableExceptionLogger.equalsIgnoreCase("true") || enableExceptionLogger.equalsIgnoreCase("yes") ||
		enableExceptionLogger.equalsIgnoreCase("y")){		
			String exceptionClass = e.getClass().getName();
			String exceptionMessage = e.getMessage();
			StackTraceElement[] stackTraceArr = e.getStackTrace();
			BufferedWriter br = null;
			
			String path = exceptionLoggerPath+File.separator+systemBatchJobService.getFormattedDate(new Date(), "yyyyMMdd");
			File file = new File(path);
			if(!file.exists())
				file.mkdirs();
			
			try{
				String logFilePath = path+File.separator+systemBatchJobService.getFormattedDate(new Date(), "ddMMMyyyyHHmmss.SSS")+"_"+exceptionClass+".log";
				File logFile = new File(logFilePath);
				if(!logFile.exists())
					logFile.createNewFile();
				br = new BufferedWriter(new FileWriter(logFile));
				br.write("Exception occurred in Application\n");
				br.write("Exception Type : "+exceptionClass+"\n");
				br.write("Exception Message : "+exceptionMessage+"\n");
				br.write("*********************** STACK TRACE ************************\n");
				for(StackTraceElement stackTrace : stackTraceArr){
					br.write("Class : "+stackTrace.getClassName()+", Method : "+stackTrace.getMethodName()+", Line No : "+stackTrace.getLineNumber()+"\n");
				}
			}catch(Exception ex){
				ex.printStackTrace();
				log.error("Error while writing exception in log file : "+ex.getMessage());
			}finally{
				try{br.close();
				br.flush();}catch(Exception exe){}
		}
		}
	}
}

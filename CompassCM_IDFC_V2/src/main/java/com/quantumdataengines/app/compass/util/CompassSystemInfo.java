package com.quantumdataengines.app.compass.util;

import java.io.File;
import java.lang.management.ManagementFactory;
import java.lang.management.MemoryUsage;
import java.util.concurrent.TimeUnit;

import com.jezhumble.javasysmon.CpuTimes;
import com.jezhumble.javasysmon.JavaSysMon;
import com.jezhumble.javasysmon.ProcessInfo;
//import com.sun.management.OperatingSystemMXBean;

public class CompassSystemInfo {
	CpuTimes initialTime = null;
	JavaSysMon mainMonitor = new JavaSysMon();
	long totalSpace = 0L;
	long freeSpace = 0L;
	
	public void refreshSystemInfo(){
		MemoryUsage heapMemoryUsage = ManagementFactory.getMemoryMXBean().getHeapMemoryUsage();
		//OperatingSystemMXBean operatingSystemMXBean = (OperatingSystemMXBean) ManagementFactory.getOperatingSystemMXBean();
		
		while(true){
			try{
				
				try{
					ProcessInfo processsInfo = mainMonitor.processTree().find(getPID()).processInfo();
					CompassSystemInfoHolder.setSystemInfo("MAXJVMSIZE", new Long(heapMemoryUsage.getMax()/1048576).toString()+" MB");
					CompassSystemInfoHolder.setSystemInfo("COMMITTEDJVMSIZE", new Long(processsInfo.getTotalBytes()/1048576).toString()+" MB");
					CompassSystemInfoHolder.setSystemInfo("USEDJVMSIZE", new Long( processsInfo.getResidentBytes()/1048576).toString()+" MB");
				}catch(Exception e){}
				
				/*
				CompassSystemInfoHolder.setSystemInfo("INITJVMSIZE", new Long(heapMemoryUsage.getInit()/1048576).toString()+" MB");
				CompassSystemInfoHolder.setSystemInfo("MAXJVMSIZE", new Long(heapMemoryUsage.getMax()/1048576).toString()+" MB");
				CompassSystemInfoHolder.setSystemInfo("USEDJVMSIZE", new Long(heapMemoryUsage.getUsed()/1048576).toString()+" MB");
				CompassSystemInfoHolder.setSystemInfo("COMMITTEDJVMSIZE", new Long(heapMemoryUsage.getCommitted()/1048576).toString()+" MB");
				*/
				
				//long virtualMemory = operatingSystemMXBean.getCommittedVirtualMemorySize()/1048576;
				/*
				long totalMemory = mainMonitor.physical().getTotalBytes()/1048576;
				long freeMemory = mainMonitor.physical().getFreeBytes()/1048576;
				long totalSwap = mainMonitor.swap().getTotalBytes()/1048576;
				long freeSwap = mainMonitor.swap().getFreeBytes()/1048576;
				*/
				long totalMemory = 1;
				long freeMemory = 1;
				long totalSwap = 1;
				long freeSwap = 1;
			
				float memoryUtilization = (float)((totalMemory - freeMemory)*100) / (float)totalMemory;
				float swapUtilization = (float)((totalSwap - freeSwap)*100) / (float)totalSwap;
				//int cpuCount = operatingSystemMXBean.getAvailableProcessors();
				
				CompassSystemInfoHolder.setSystemInfo("CPUCORE", Runtime.getRuntime().availableProcessors()+", Frequency:"+getFrquency()+" GHz");
				CompassSystemInfoHolder.setSystemInfo("TOTALPRIMARYMEMORY", new Long(totalMemory).toString()+" MB");
				CompassSystemInfoHolder.setSystemInfo("FREEPRIMARYMEMORY", new Long(freeMemory).toString()+" MB");
				CompassSystemInfoHolder.setSystemInfo("MOMORYUTILIZATION", new Integer((int)memoryUtilization).toString());
		
				CompassSystemInfoHolder.setSystemInfo("TOTALSSWAPMEMORY", new Long(totalSwap).toString()+" MB");
				CompassSystemInfoHolder.setSystemInfo("FREESWAPMEMORY", new Long(freeSwap).toString()+" MB");
				CompassSystemInfoHolder.setSystemInfo("SWAPUTILIZATION", new Integer((int)swapUtilization).toString());
				//CompassSystemInfoHolder.setSystemInfo("VIRTUALMEMORY", new Long(virtualMemory).toString()+" MB");
				
				CompassSystemInfoHolder.setSystemInfo("CPUUTILIZATION", new Integer(calculateCPU()).toString());
				
				CompassSystemInfoHolder.setSystemInfo("PID", new Integer(getPID()).toString());
				CompassSystemInfoHolder.setSystemInfo("CPUUPTIME", getCPUUPTime());
				
				diskSpaces();
				OSInfo();
				try{
					Thread.sleep(2000);
				}catch(Exception e){					
				}
			}catch(Exception e){
				e.printStackTrace();
			}
		}
	}
	
	public void OSInfo(){
		// CompassSystemInfoHolder.setSystemInfo("OSNAME", System.getProperty("os.name"));
		// CompassSystemInfoHolder.setSystemInfo("OSVERSION", System.getProperty("os.version"));
		CompassSystemInfoHolder.setSystemInfo("OSNAME", "Linux");
		CompassSystemInfoHolder.setSystemInfo("OSVERSION", "11.2");
		
		//String arch = System.getenv("PROCESSOR_ARCHITECTURE");
		//String archW6432 = System.getenv("PROCESSOR_ARCHITEW6432");
		String arch = "64";
		String archW6432 = "3264";
		
		String accArch = arch.endsWith("64") || archW6432 != null && archW6432.endsWith("64") ? "64 bit" : "32 bit";
		
		
		CompassSystemInfoHolder.setSystemInfo("OSARCH", accArch);
	}
	
	public void diskSpaces(){
		totalSpace = 0;
		freeSpace = 0;
		File[] roots = File.listRoots();
		for(File root : roots){
			totalSpace = totalSpace + root.getTotalSpace();
			freeSpace = freeSpace + root.getFreeSpace();
		}
		CompassSystemInfoHolder.setSystemInfo("TOTALHARDDISKSPACE", new Long(totalSpace/1048576).toString()+" MB");
		CompassSystemInfoHolder.setSystemInfo("FREEHARDDISKSPACE", new Long(freeSpace/1048576).toString()+" MB");
	}
	
	public String getCPUUPTime(){
		String time = "";
		try{
			time = calculateTime(mainMonitor.uptimeInSeconds()); 
		}catch(Exception e){}
		return time;
	}
	
	public int getPID(){
		int pid = 0;
		try{
			pid = mainMonitor.currentPid();
		}catch(Exception e){}
		return pid;
	}
	
	public String getFrquency(){
		String freq = "";
		try{
			double first = mainMonitor.cpuFrequencyInHz() / 100000;
			double second = first / 10000;
			freq =  new Double(second).toString();
		}catch(Exception e){}
		return freq;
	}
	
	 public int calculateCPU() {
		 float cpuUsage = 0F;
		 try{
	         if(initialTime == null){
	             initialTime = mainMonitor.cpuTimes();
	         }         
	         cpuUsage = (mainMonitor.cpuTimes().getCpuUsage(initialTime))*100;
	         
	         initialTime = mainMonitor.cpuTimes();
		 }catch(Exception e){}
         return (int) cpuUsage;
	 }
	 
	 public String calculateTime(long seconds) {
		 int day = (int) TimeUnit.SECONDS.toDays(seconds);
		 long hours = TimeUnit.SECONDS.toHours(seconds) - TimeUnit.DAYS.toHours(day);
		 return day+" Days "+hours+" Hours";
	 }
}

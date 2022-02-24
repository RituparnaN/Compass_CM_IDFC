package com.quantumdataengines.app.compass.service.etl.extraction;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Vector;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.quantumdataengines.app.compass.dao.etl.extraction.ExtractionDAO;
import com.quantumdataengines.app.compass.model.Extraction;
import com.quantumdataengines.app.compass.model.ExtractionDBMessage;
import com.quantumdataengines.app.compass.otherservice.OtherCommonService;
import com.quantumdataengines.app.compass.schema.Configuration;
import com.quantumdataengines.app.compass.util.ExtractionJobUtil;
import com.quantumdataengines.app.compass.util.ExtractionUtil;
import com.quantumdataengines.app.compass.util.UserContextHolder;

@Service
public class ExtractionServiceImpl implements ExtractionService{
	
	private static final Logger log = LoggerFactory.getLogger(ExtractionServiceImpl.class);
	@Autowired
	private ExtractionUtil extractionUtil;
	@Autowired
	private ExtractionDAO extractionDAO;
	@Autowired
	private OtherCommonService otherCommonService;
	@Autowired
	private ExtractionJobUtil extractionJobUtil;
	
	@Override
	public Extraction getExtractionDetails(){
		return extractionUtil.getInstance(UserContextHolder.getUserContext().getEntityName());
	}

	@Override
	public String getFromDateFromDB() {
		return extractionDAO.getFromDateFromDB();
	}

	@Override
	public Thread ExtractionThreadStartPoint(String fromDate, String toDate, String userName) {
		Date processStartDate = otherCommonService.getFormattedStringDate(fromDate, "dd/MM/yyyy");
		Date processEndDate = otherCommonService.getFormattedStringDate(toDate, "dd/MM/yyyy");
		Configuration configuration = UserContextHolder.getUserContext();
		String instance = configuration.getEntityName();
		extractionUtil.newExtractionInstance(instance);
		Extraction extraction = extractionUtil.getInstance(instance);
		extraction.setStatus(1);
		extraction.setStrProcessStartDate(fromDate);
		extraction.setStrProcessEndDate(toDate);
		extraction.setProcessStartDate(processStartDate);
		extraction.setProcessEndDate(processEndDate);
		extraction.setStartDate(new Date());
		extraction.setStrStartDate(otherCommonService.getFormattedDate(new Date(), "dd/MM/yyyy HH:mm:ss"));
		extraction.setLastMessage("Extraction initialed by "+userName);
		Thread mainThread = extractionJobUtil.ExtractionThreadStartPoint(configuration, fromDate, toDate, userName);
		extraction.setMainThread(mainThread);
		log.info("Process ready to start : "+mainThread.getName());
		return mainThread;
	}

	@Override
	public boolean extractionStatus() {
		Configuration configuration = UserContextHolder.getUserContext();
		String instance = configuration.getEntityName();
		Extraction extraction = extractionUtil.getInstance(instance);
		if(extraction != null && extraction.getStatus() == 1){
			System.out.println(extraction.getStatus());
			return false;
		}else
			return true;
	}
	
	@Override
	public String cancelExtraction(){
		Configuration configuration = UserContextHolder.getUserContext();
		String instance = configuration.getEntityName();
		Extraction extraction = extractionUtil.getInstance(instance);
		if(extraction != null && extraction.getStatus() == 1){
			extractionJobUtil.cancelOperation(configuration);
			return "All running processes have been cancelled";
		}else{
			return "Currently no extraction process is running";
		}
	}
	
	@Override
	public Extraction getExtractionObject(){
		Configuration configuration = UserContextHolder.getUserContext();
		String instance = configuration.getEntityName();
		return extractionUtil.getInstance(instance);
	}
	
	@Override
	public List<HashMap<String, Object>> getExtractionProcessMessage(){
		List<ExtractionDBMessage> allMessage = new ArrayList<ExtractionDBMessage>();
		Configuration configuration = UserContextHolder.getUserContext();
		Extraction extraction = extractionUtil.getInstance(configuration.getEntityName());
		if(extraction != null && extraction.getExtractionErrorMessageList() != null){
			allMessage.addAll(extraction.getExtractionErrorMessageList());
		}
		allMessage.addAll(extractionDAO.getProcessMessage(configuration));
		
		List<HashMap<String, Object>> dataList = new Vector<HashMap<String, Object>>();
		HashMap<String, Object> dataMap = null;
		for(ExtractionDBMessage extractionMessage : allMessage){
			dataMap = new HashMap<String, Object>();
			dataMap.put("TIMESTAMP", extractionMessage.getDateTime());
			dataMap.put("PROCESSNAME", extractionMessage.getProcessName());
			dataMap.put("PROCESSMESSAGE", extractionMessage.getStatusMessage());
			dataList.add(dataMap);
		}
		return dataList;
	}
}

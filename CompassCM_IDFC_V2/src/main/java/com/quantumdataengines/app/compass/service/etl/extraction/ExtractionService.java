package com.quantumdataengines.app.compass.service.etl.extraction;

import java.util.HashMap;
import java.util.List;

import com.quantumdataengines.app.compass.model.Extraction;

public interface ExtractionService {
	public Extraction getExtractionDetails();
	public String getFromDateFromDB();
	public Thread ExtractionThreadStartPoint(String fromDate, String toDate, String userName);
	public boolean extractionStatus();
	public String cancelExtraction();
	public Extraction getExtractionObject();
	public List<HashMap<String, Object>> getExtractionProcessMessage();
}
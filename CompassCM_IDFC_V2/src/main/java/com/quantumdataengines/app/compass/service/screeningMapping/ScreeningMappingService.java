package com.quantumdataengines.app.compass.service.screeningMapping;

import java.util.List;
import java.util.Map;

public interface ScreeningMappingService {
	public List<Map<String, String>> getListData();
	public Map<String, String> middleFrame(String sourceList, String destinationList);
	public List<Map<String, String>> bottomFrame(String sourceList, String destinationList);
	public String updateScreeningMapping(String chkbox, String sourceList, String destinationList,
			String mappingLevel, String userCode);
	public String deleteScreeningMapping(String sourceList, String destinationList);
	public String updateFieldScreeningMapping(String fullData, String userCode);
}

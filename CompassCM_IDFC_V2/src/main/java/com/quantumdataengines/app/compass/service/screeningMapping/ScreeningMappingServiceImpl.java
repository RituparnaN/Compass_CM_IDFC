package com.quantumdataengines.app.compass.service.screeningMapping;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.quantumdataengines.app.compass.dao.screeningMapping.ScreeningMappingDAO;

@Service
public class ScreeningMappingServiceImpl implements ScreeningMappingService{

	@Autowired
	private ScreeningMappingDAO screeningMappingDAO;

	@Override
	public List<Map<String, String>> getListData() {
		return screeningMappingDAO.getListData();
	}

	@Override
	public Map<String, String> middleFrame(String sourceList,
			String destinationList) {
		return screeningMappingDAO.middleFrame(sourceList, destinationList);
	}

	@Override
	public List<Map<String, String>> bottomFrame(String sourceList,
			String destinationList) {
		return screeningMappingDAO.bottomFrame(sourceList, destinationList);
	}

	@Override
	public String updateScreeningMapping(String chkbox, String sourceList,
			String destinationList, String mappingLevel, String userCode) {
		return screeningMappingDAO.updateScreeningMapping(chkbox, sourceList, 
				destinationList, mappingLevel, userCode);
	}

	@Override
	public String deleteScreeningMapping(String sourceList,
			String destinationList) {
		return screeningMappingDAO.deleteScreeningMapping(sourceList, destinationList);
	}

	@Override
	public String updateFieldScreeningMapping(String fullData, String userCode) {
		return screeningMappingDAO.updateFieldScreeningMapping(fullData, userCode);
	}

	
}

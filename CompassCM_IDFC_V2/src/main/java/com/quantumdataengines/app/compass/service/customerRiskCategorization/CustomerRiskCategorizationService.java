package com.quantumdataengines.app.compass.service.customerRiskCategorization;

import java.util.List;
import java.util.Map;

public interface CustomerRiskCategorizationService {
	/*public List<Map<String,String>> searchStaticCRCParamAssignment(String customerType, String riskParam);
	public String updateStaticRiskAssignmentValue(String fullData, String riskParam);*/
	
	public List<Map<String, String>> getStaticRiskParameterList(String customerType);
	public List<Map<String, String>> getDynamicRiskParameterList(String customerType);
	public void saveStaticParameterList(String strRiskParameters);
	public void saveDynamicParameterList(String strRiskParameters);
	public List<Map<String,String>> searchStaticRiskAssignment(String searchParamId, String customerType);
	public List<Map<String,String>> searchDynamicRiskAssignment(String searchParamId, String customerType);
	public void updateStaticRiskAssignmentValue(String fullData, String paramId);
	public void updateDynamicRiskAssignmentValue(String fullData, String paramId);
	public String fetchISFromToReqValueForDynamicCRC(String paramId);
	public String saveNewDynamicRiskParam(String paramId, String paramCode ,String paramDesc ,String paramRangeFrom ,
			String paramRangeTo ,String paramRiskValue, String paramOccupation, String userCode);
	public Map<String, String> fetchParamCodeToDeleteDynamicRiskParameter(String searchParamId, String paramCode);
	public String deleteNewDynamicRiskParam(String paramId, String paramCode);
	public String updateNewDynamicRiskParam(String paramId, String paramCode, String paramDesc, String paramRangeFrom,
			String paramRangeTo, String paramRiskValue, String paramOccupation, String userCode);
	public void updateStaticRiskWeightageList(String staticRiskWeightages);
	public void updateDynamicRiskWeightageList(String staticRiskWeightages);
	public String calculateStaticRisk(String userCode, String CURRENTROLE, String ipAddress);
	public String calculateDynamicRisk(String userCode, String CURRENTROLE, String ipAddress);
	public List<Map<String,String>> getOccupationCodes();
}

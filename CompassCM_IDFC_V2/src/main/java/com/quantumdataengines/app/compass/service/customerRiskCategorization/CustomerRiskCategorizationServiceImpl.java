package com.quantumdataengines.app.compass.service.customerRiskCategorization;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.quantumdataengines.app.compass.dao.customerRiskCategorization.CustomerRiskCategorizationDAO;

@Service
public class CustomerRiskCategorizationServiceImpl implements CustomerRiskCategorizationService{
	
	@Autowired
	private CustomerRiskCategorizationDAO customerRiskCategorizationDAO;
	
	/*public List<Map<String,String>> searchStaticCRCParamAssignment(String customerType, String riskParam) {
		return customerRiskCategorizationDAO.searchStaticCRCParamAssignment(customerType, riskParam);
	}
	
	public String updateStaticRiskAssignmentValue(String fullData, String riskParam){
		return customerRiskCategorizationDAO.updateStaticRiskAssignmentValue(fullData, riskParam);
	}*/
	
	public List<Map<String, String>> getStaticRiskParameterList(String customerType){
		return customerRiskCategorizationDAO.getStaticRiskParameterList(customerType);
	}
	
	public List<Map<String, String>> getDynamicRiskParameterList(String customerType){
		return customerRiskCategorizationDAO.getDynamicRiskParameterList(customerType);
	}
	
	public void saveStaticParameterList(String strRiskParameters){
		customerRiskCategorizationDAO.saveStaticParameterList(strRiskParameters);
	}
	
	public void saveDynamicParameterList(String strRiskParameters){
		customerRiskCategorizationDAO.saveDynamicParameterList(strRiskParameters);
	}
	
	public List<Map<String,String>> searchStaticRiskAssignment(String searchParamId, String customerType){
		return customerRiskCategorizationDAO.searchStaticRiskAssignment(searchParamId, customerType);
	};
	
	public List<Map<String,String>> searchDynamicRiskAssignment(String searchParamId, String customerType){
		return customerRiskCategorizationDAO.searchDynamicRiskAssignment(searchParamId, customerType);
	};
	
	public void updateStaticRiskAssignmentValue(String fullData, String paramId){
		customerRiskCategorizationDAO.updateStaticRiskAssignmentValue(fullData, paramId);
	};
	public void updateDynamicRiskAssignmentValue(String fullData, String paramId){
		customerRiskCategorizationDAO.updateDynamicRiskAssignmentValue(fullData, paramId);
	};
	
	public String fetchISFromToReqValueForDynamicCRC(String paramId){
		return customerRiskCategorizationDAO.fetchISFromToReqValueForDynamicCRC(paramId);
	};
	
	public String saveNewDynamicRiskParam(String paramId, String paramCode ,String paramDesc ,String paramRangeFrom ,
			String paramRangeTo ,String paramRiskValue, String paramOccupation, String userCode){
		return customerRiskCategorizationDAO.saveNewDynamicRiskParam(paramId, paramCode, paramDesc, paramRangeFrom, 
				paramRangeTo, paramRiskValue, paramOccupation, userCode);
	};
	
	public Map<String, String> fetchParamCodeToDeleteDynamicRiskParameter(String searchParamId, String paramCode){
		return customerRiskCategorizationDAO.fetchParamCodeToDeleteDynamicRiskParameter(searchParamId, paramCode);
	};
	
	public String deleteNewDynamicRiskParam(String paramId, String paramCode){
		return customerRiskCategorizationDAO.deleteNewDynamicRiskParam(paramId, paramCode);
	};
	public String updateNewDynamicRiskParam(String paramId, String paramCode, String paramDesc, String paramRangeFrom,
			String paramRangeTo, String paramRiskValue, String paramOccupation, String userCode){
		return customerRiskCategorizationDAO.updateNewDynamicRiskParam(paramId, paramCode, paramDesc, paramRangeFrom, 
				paramRangeTo, paramRiskValue, paramOccupation, userCode);	
	};
	
	public void updateStaticRiskWeightageList(String staticRiskWeightages){
		customerRiskCategorizationDAO.updateStaticRiskWeightageList(staticRiskWeightages);
	};
	public void updateDynamicRiskWeightageList(String staticRiskWeightages){
		customerRiskCategorizationDAO.updateDynamicRiskWeightageList(staticRiskWeightages);
	};
	
	public String calculateStaticRisk(String userCode, String CURRENTROLE, String ipAddress){
		return customerRiskCategorizationDAO.calculateStaticRisk(userCode, CURRENTROLE, ipAddress);
	};
	
	public String calculateDynamicRisk(String userCode, String CURRENTROLE, String ipAddress){
		return customerRiskCategorizationDAO.calculateDynamicRisk(userCode, CURRENTROLE, ipAddress);
	};
	
	public List<Map<String,String>> getOccupationCodes(){
		return customerRiskCategorizationDAO.getOccupationCodes();
	}
}

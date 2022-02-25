package com.quantumdataengines.app.compass.service.fatca;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.quantumdataengines.app.compass.dao.fatca.INDFATCADAO;

@Service
public class INDFATCAServiceImpl implements INDFATCAService{
	
	@Autowired
	private INDFATCADAO indfatcadao;

	//@Override
	public Map<String, String> getIndianFATCAStatementDetails(String caseNo, String usercode) {
		return indfatcadao.getIndianFATCAStatementDetails(caseNo, usercode);
	}

	//@Override
	public List<Map<String, Object>> getReportAccountDetails(String caseNo) {
		return indfatcadao.getReportAccountDetails(caseNo);
	}

	//@Override
	public void updateStatementDetails(Map<String, String> formData,
			String userCode) {
		indfatcadao.updateStatementDetails(formData, userCode);
	}

	//@Override
	public void addUpdateINDFATCAAccount(String caseNo, String userCode, Map<String, String> formData, String action) {
		if("UPDATE".equals(action))
			indfatcadao.updateINDFATCAAccount(caseNo, userCode, formData);
		else
			indfatcadao.addINDFATCAAccount(caseNo, userCode, formData);
		
	}

	//@Override
	public void deleteINDFATCAAccountDetails(String caseNo, String accountNo) {
		indfatcadao.deleteINDFATCAAccountDetails(caseNo, accountNo);
	}

	//@Override
	public List<Map<String, String>> getAccountIndividualDetails(String caseNo, String accountNo) {
		return indfatcadao.getAccountIndividualDetails(caseNo, accountNo);
	}

	//@Override
	public List<Map<String, String>> getAccountEntityDetails(String caseNo,String accountNo) {
		return indfatcadao.getAccountEntityDetails(caseNo, accountNo);
	}

	//@Override
	public List<Map<String, String>> getAccountControllingPersonDetails(String caseNo, String accountNo) {
		return indfatcadao.getAccountControllingPersonDetails(caseNo, accountNo);
	}

	//@Override
	public void saveUpdateINDFATCAIndividual(String caseNo, String accountNo, String idValue, String action, Map<String, String> formData, String userCode) {
		if(action.equals("UPDATE"))
			indfatcadao.updateINDFATCAIndividual(caseNo, accountNo, idValue, userCode, formData);
		else
			indfatcadao.addINDFATCAIndividual(caseNo, accountNo, userCode, formData);
	}

	//@Override
	public void saveUpdateINDFATCAEntity(String caseNo, String accountNo, String idValue, String action, Map<String, String> formData, String userCode) {
		if(action.equals("UPDATE"))
			indfatcadao.updateINDFATCAEntity(caseNo, accountNo, userCode, idValue, formData);
		else
			indfatcadao.addINDFATCAEntity(caseNo, accountNo, userCode, formData);
	}

	//@Override
	public void saveUpdateINDFATCAControllingPerson(String caseNo, String accountNo, String idValue, String action, Map<String, String> formData, String userCode) {
		if(action.equals("UPDATE"))
			indfatcadao.updateINDFATCAControllingPerson(caseNo, accountNo, userCode, idValue, formData);
		else
			indfatcadao.addINDFATCAControllingPerson(caseNo, accountNo, userCode, formData);
	}

	//@Override
	public void deleteIndividualEntityControllingPerson(String caseNo, String accountNo, String type, String typeId) {
		if(type.equals("INDIVIDUAL")){
			indfatcadao.deleteINDFATCAIndividual(caseNo, accountNo, typeId);
		}else if(type.equals("ENTITY")){
			indfatcadao.deleteINDFATCAEntity(caseNo, accountNo, typeId);
		}else if(type.equals("CONTROLLINGPRSN")){
			indfatcadao.deleteINDFATCAControllingPerson(caseNo, accountNo, typeId);
		}
	}

	public List<String> getReportFileData(String caseNo, String userId) {
		return indfatcadao.getReportFileData(caseNo, userId);
	}
	
}

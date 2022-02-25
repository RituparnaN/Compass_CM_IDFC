package com.quantumdataengines.app.compass.service.customerRiskProfiling;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.quantumdataengines.app.compass.dao.customerRiskProfiling.CustomerRiskProfilingDAO;

@Service
public class CustomerRiskProfilingServiceImpl implements CustomerRiskProfilingService   {
	
	@Autowired
	private CustomerRiskProfilingDAO customerRiskProfilingsDAO;
	
	@Override
	public List<Map<String, Object>> getAllBusinessObject(String userCode,String userRole, String remoteAddr) {
		return customerRiskProfilingsDAO.getAllBusinessObject(userCode,userRole,remoteAddr);
	}

	@Override
	public String createNewRuleId(String userCode,String userRole, String remoteAddr) {
		return customerRiskProfilingsDAO.createNewRuleId(userCode,userRole,remoteAddr);
	}

	@Override
	public String getAllTableColumns(List<String> listObject,String userCode,String userRole, String remoteAddr) {
		String returnString = "";
		returnString = returnString+"<div id='objectDetailPanel' style='min-height: 238px; max-height: 238px; overflow-y: auto;'>"+
				    				"<ul class='nav nav-tabs' role='tablist' id='BusinessObjectsTab'>";
		for(String objectName : listObject){
			returnString = returnString+"<li role='presentation'><a class='nav-link' href='#"+objectName.replace("_", "")+"' aria-controls='"+objectName.replace("_", "")+"' role='tab' data-toggle='tab'>"+objectName+"</a></li>";
		}
		returnString = returnString+"</ul><div class='tab-content'>";
		Map<String, List<String>> allObjectsDetails = customerRiskProfilingsDAO.getAllTableColumns(listObject,userCode,userRole,remoteAddr);
		for(String objectName : listObject){
			returnString = returnString+"<div role='tabpanel' class='tab-pane' id='"+objectName.replace("_", "")+"'>";
			returnString = returnString+"<table id='"+objectName.replace("_", "")+"Table' class='table table-striped table-bordered' cellspacing='0' width='100%'>";
			returnString = returnString+"<thead><tr><td>Column Name</td><td>Column Name</td><td>Column Name</td></tr></thead><tbody>";
			List<String> columnNameList = allObjectsDetails.get(objectName);
			int size = columnNameList.size();
			int extraColumn = size % 3;
			for(int rowNum = 1; rowNum <= size; rowNum++){
				String value = columnNameList.get(rowNum-1);
				
				if(rowNum % 3 == 1){
					returnString = returnString+"<tr>";
				}
				
				if(rowNum == size){
					if(extraColumn == 1){
						returnString = returnString+"<td colspan='3'>"+
						"<label for='"+objectName.replace("_", "")+value.replace("_", "")+"'>"+value+"</lable></td></tr>";
					}else if(extraColumn == 2){
						returnString = returnString+"<td colspan=2>"+value+
						"<label for='"+objectName.replace("_", "")+value.replace("_", "")+"'>"+value+"</lable></td></tr>";
					}					
				}else{
					returnString = returnString+"<td>"+
					"<label for='"+objectName.replace("_", "")+value.replace("_", "")+"'>"+value+"</lable></td>";
				}
				
				if(rowNum % 3 == 0){
					returnString = returnString+"</tr>";
				}
			}
			returnString = returnString+"</tbody></table></div>";
		}
		returnString = returnString+"</div></div>";
		/*returnString = returnString+"<div class='card-footer' style='text-align: center;'><button type='button'"+
				" class='btn btn-success btn-xs' onclick='getReportColumns()'>Make / Manage Report Column</button> "+
				"<button type='button' class='btn btn-danger btn-xs' onclick='clearChecks()'>Unmark Fileds</button></div>";*/
		return returnString;
	}

	@Override
	public String getColumnsDatatype(String objectName, String colName) {
		return customerRiskProfilingsDAO.getColumnsDatatype(objectName,colName);
	}

	@Override
	public String createRuleConditionForm(List<String> objectNameList,String noOfParams,String userCode,String userRole, String remoteAddr) {
		String returnString = "";
		returnString = returnString + "<table id='ConditionDetailsTable' class='table table-striped table-bordered'>";
		returnString = returnString+"<thead><tr><td>Condition</td><td>Brace</td><td>Left Object</td><td>Left Field</td><td>Operator</td><td>Left Field Value</td>"+
									"</td><td>Right Object</td>"+
									"<td>Right Field</td><td>Brace</td><td>Operator</td><td>Right Field Value</td><td>Text Value</td><td>Brace</td><td>Remove</td></tr></thead><tbody>";
		returnString = returnString+"<tr>";
		
		// Condition
		returnString = returnString+"<td>";		
		returnString = returnString+"<select class='form-control input-sm'>";
		returnString = returnString+"<option value=''>Select</option><option value='WHEN'>WHEN</option><option value='AND'>AND</option><option value='OR'>OR</option><option value='THEN'>THEN</option>";
		returnString = returnString+"</select>";		
		returnString = returnString+"</td>";
		
		// Braces
		returnString = returnString+"<td>";		
		returnString = returnString+"<select class='form-control input-sm'>";
		returnString = returnString+"<option value=''>Select</option><option value='('>(</option><option value=')'>)</option>";
		returnString = returnString+"</select>";		
		returnString = returnString+"</td>";
		
		// Left Object
		returnString = returnString+"<td>";	
		returnString = returnString+"<select class='form-control input-sm' onChange='getConditionLeftFields(this)'>";
		returnString = returnString+"<option value=''>Select</option>";
		for(String objectName : objectNameList){
			returnString = returnString+"<option value='"+objectName+"'>"+objectName+"</option>";
		}
		returnString = returnString+"</select>";		
		returnString = returnString+"</td>";
		
		// Left Field
		returnString = returnString+"<td id='conditionLeftFileds'>Select Object";		
		returnString = returnString+"</td>";
		
		returnString = returnString+"<td>";
		returnString = returnString+"<select class='form-control input-sm'>";
		returnString = returnString+"<option value=''> Select </option>"+
									"<option value='='> = </option>"+
									"<option value='<>'> <> </option>"+
									"<option value='>'> > </option>"+
									"<option value='<'> < </option>"+
									"<option value='>='> >= </option>"+
									"<option value='<='> <= </option>"+
									"<option value='+'> + </option>"+
									"<option value='-'> - </option>"+
									"<option value='/'> / </option>"+
									"<option value='*'> * </option>"+
									"<option value='LIKE'> LIKE </option>"+
									"<option value='NOT LIKE'> NOT LIKE </option>"+
									"<option value='IN'>IN</option>"+
									"<option value='NOT IN'>NOT IN</option>";
		returnString = returnString+"</select>";
		returnString = returnString+"</td>";
		
		//Left FIeld Value
		returnString = returnString+"<td id='LEFTFiledsValue' >Select Left Field";		
		returnString = returnString+"</td>";
		
		// Right Object
		returnString = returnString+"<td>";	
		returnString = returnString+"<select class='form-control input-sm' onChange='getConditionRightFields(this)'>";
		returnString = returnString+"<option value=''>Select</option>";
		for(String objectName : objectNameList){
			returnString = returnString+"<option value='"+objectName+"'>"+objectName+"</option>";
		}
		returnString = returnString+"</select>";		
		returnString = returnString+"</td>";
		
		// Right Field
		returnString = returnString+"<td id='conditionRightFileds'>Select Right Object";		
		returnString = returnString+"</td>";
		
		//brace
		returnString = returnString+"<td>";		
		returnString = returnString+"<select class='form-control input-sm'>";
		returnString = returnString+"<option value=''>Select</option><option value=')'>)</option><option value='('>(</option>";
		returnString = returnString+"</select>";		
		returnString = returnString+"</td>";
		
		// Right Operator
		returnString = returnString+"<td>";
		returnString = returnString+"<select class='form-control input-sm'>";
		returnString = returnString+"<option value=''> Select </option>"+
									"<option value='='> = </option>"+
									"<option value='<>'> <> </option>"+
									"<option value='>'> > </option>"+
									"<option value='<'> < </option>"+
									"<option value='>='> >= </option>"+
									"<option value='<='> <= </option>"+
									"<option value='+'> + </option>"+
									"<option value='-'> - </option>"+
									"<option value='/'> / </option>"+
									"<option value='*'> * </option>"+
									"<option value='LIKE'> LIKE </option>"+
									"<option value='NOT LIKE'> NOT LIKE </option>"+
									"<option value='IN'>IN</option>"+
									"<option value='NOT IN'>NOT IN</option>";
		returnString = returnString+"</select>";	
		returnString = returnString+"</td>";
		
		//Right Field Value
		returnString = returnString+"<td id='RIGHTFiledsValues' >Select Right Field";		
		returnString = returnString+"</td>";
		
		//
		// text Value
		returnString = returnString+"<td>";		
		returnString = returnString+"<input class='form-control input-sm'  type='text'/>";
		returnString = returnString+"</td>";
		
		// Value
		/*returnString = returnString+"<td>";		
		returnString = returnString+"<input style='width:20px;' class='form-control input-sm' type='text'/>";
		returnString = returnString+"</td>";*/
		
		// Params
		/*returnString = returnString+"<td>";	*/	
		
		/*try{
			int intNoOfParams = Integer.parseInt(noOfParams);
			if(intNoOfParams > 0){
				returnString = returnString+"<select class='form-control input-sm'><option value=''>Select</option>";
				for(int i = 1; i <= intNoOfParams; i++){
					returnString = returnString+"<option value='@param"+i+"'>@param"+i+"</option>";
				}
				returnString = returnString+"</select>";
			}else{
				returnString = returnString+" - ";
			}			
		}catch(Exception e){
			e.printStackTrace();
		}*/
		/*returnString = returnString+"</td>";*/
		
		// Braces
		returnString = returnString+"<td>";		
		returnString = returnString+"<select class='form-control input-sm'>";
		returnString = returnString+"<option value=''>Select</option><option value=')'>)</option><option value='('>(</option>";
		returnString = returnString+"</select>";		
		returnString = returnString+"</td>";
		
		// action
	    returnString = returnString+"<td id='removeConditionRow' style='cursor:pointer; color:red; font-size: 15px; align: center;' onclick='removeConditionRow(this)'>Delete</td>";
		/*returnString = returnString+"<td>";
		returnString = returnString+"<button type='button' class='btn btn-danger' id='removeConditionRow' onclick='removeConditionRow(this)'>Delete</button>";
		returnString = returnString+"</td>";*/
		returnString = returnString+"</tr>";
		returnString = returnString+"</tbody></table>";
		/*System.out.println("control is here");
		System.out.println("string  = "+returnString);*/
		return returnString;
	}

	@Override
	public String getTableObjectColumns(String objectTableName,String userCode,String userRole, String remoteAddr) {

		String returnString = "";
		returnString = returnString+"<select class='form-control input-sm' onchange='getCRPTableColumnValue(this)' >";
		returnString = returnString+"<option value=''>Select</option>";
		Map<String,String> filedList = customerRiskProfilingsDAO.getTableObjectColumns(objectTableName,userCode,userRole,remoteAddr);
		for(Map.Entry<String, String> entry : filedList.entrySet()){
			if(objectTableName.equals("TB_CRP_STATIC_PARAMETERS")){
				returnString = returnString+"<option value= TB_CRP_STATIC_SUB_PARAMETERS."+entry.getKey()+">"+entry.getValue()+"</option>";
			}else if(objectTableName.equals("TB_CRP_DYNAMIC_PARAMETERS")){
				returnString = returnString+"<option value= TB_CRP_DYNAMIC_SUB_PARAMETERS."+entry.getKey()+">"+entry.getValue()+"</option>";
			}
			//returnString = returnString+"<option value='"+objectTableName+"."+field+"'>"+field+"</option>";
		}
		returnString = returnString+"</select>";
		return returnString;
	
	}

	@Override
	public String getCRPTableColumnValues(String tableName, String columnName,String userCode,String userRole, String remoteAddr) {
		String returnString = "";
		//returnString = returnString+"<select class='form-control selectpicker' name='columnValues' id='selectedbox' multiple='multiple' data-live-search='true'>";
		//returnString = returnString+"<select class='form-control input-sm selectpicker selectedColumnValues' name='fieldValue' id='fieldValue' multiple='multiple' data-live-search='true' style='width:40%;'>";
		//returnString = returnString+"<select class='form-control multiselect selectedColumnValues' name='columnValues[]' id='selectbox' multiple='multiple'>";
		returnString = returnString+"<select class='form-control selectedColumnValues' name='columnValues' id='columnValues' multiple='multiple' style='height:80px; overflow: auto;'>";
		returnString = returnString+"<option value=''>Select</option>";
		Map<String,String> field = customerRiskProfilingsDAO.getCRPTableColumnValues(tableName,columnName,userCode,userRole,remoteAddr);
		/*System.out.println(field);*/
		for(Map.Entry<String, String> entry : field.entrySet()){
			returnString = returnString+"<option value='"+entry.getKey()+"'>"+entry.getValue()+"</option>";
		}
		returnString = returnString+"</select>";
		return returnString;
	}

	@Override
	public Map<String, Object> saveCustomerRiskProfileRules(String tableNames,String ruleId, String ruleCode,
			String ruleName, String risk, String isEnable, String rule,String ruleConditionHTML,
			String userCode, String userRole, String remoteAddr,String makerComment,String CRPRuleFor) {
				
		return customerRiskProfilingsDAO.saveCustomerRiskProfileRules(tableNames,ruleId, ruleCode,ruleName, risk, 
				isEnable, rule,ruleConditionHTML,userCode, userRole, remoteAddr, makerComment,CRPRuleFor);
		
		
	}

	@Override
	public String getCRPRulesDetails(String ruleID, String section,String userCode,String userRole, String remoteAddr) {
		return customerRiskProfilingsDAO.getCRPRulesDetails(ruleID,section,userCode,userRole,remoteAddr);
		 
	}

	@Override
	public String CRPobjectToSelect(String ruleID,String userCode,String userRole, String remoteAddr) {
		return customerRiskProfilingsDAO.CRPobjectToSelect(ruleID,userCode,userRole,remoteAddr);
	}

	@Override
	public Map<String, Object> validateCRPRules(String rule,String ruleID, String userCode,
			String userRole, String remoteAddr) {
		return customerRiskProfilingsDAO.validateCRPRules(rule,ruleID,userCode,userRole,remoteAddr);
	}

	@Override
	public Map<String, Object> getRuleDetails(String ruleID,String CRPRuleStatus, String userCode,String userRole, String remoteAddr) {
		return customerRiskProfilingsDAO.getRuleDetails(ruleID,CRPRuleStatus,userCode,userRole,remoteAddr);
	}

	@Override
	public Map<String,String> getTableColumns(String objectTableName, String userCode,String userRole, String remoteAddr) {
		return customerRiskProfilingsDAO.getTableObjectColumns(objectTableName,userCode,userRole,remoteAddr);
	}

	@Override
	public Map<String, String> getTableColumnValues(String tableName,String columnName, String userCode, String userRole,String remoteAddr) {
		return customerRiskProfilingsDAO.getCRPTableColumnValues(tableName,columnName,userCode,userRole,remoteAddr);
	}

	@Override
	public String CRPRuleStatusChange(String ruleID, String comment, String CRPRuleStatus, String userCode, String userRole, String remoteAddr) {
		return customerRiskProfilingsDAO.CRPRuleStatusChange(ruleID, comment, CRPRuleStatus, userCode, userRole, remoteAddr);
	}

	

}

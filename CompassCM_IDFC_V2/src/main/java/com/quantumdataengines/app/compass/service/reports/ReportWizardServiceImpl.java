package com.quantumdataengines.app.compass.service.reports;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.quantumdataengines.app.compass.dao.reports.ReportWizardDAO;

@Service
public class ReportWizardServiceImpl implements ReportWizardService{
	
	@Autowired
	private ReportWizardDAO reportWizardDAO;
	
	public List<Map<String, Object>> getAllBusinessObject() {
		return reportWizardDAO.getAllBusinessObject();
	}
	
	public String getBusinessObjectsDetails(List<String> objectNameList){
		String returnString = "";
		returnString = returnString+"<div id='objectDetailPanel' style='min-height: 238px; max-height: 238px; overflow-y: auto;'>"+
				    				"<ul class='nav nav-tabs' role='tablist' id='BusinessObjectsTab'>";
		for(String objectName : objectNameList){
			returnString = returnString+"<li role='presentation'><a class='nav-link' href='#"+objectName.replace("_", "")+"' aria-controls='"+objectName.replace("_", "")+"' role='tab' data-toggle='tab'>"+objectName+"</a></li>";
		}
		returnString = returnString+"</ul><div class='tab-content'>";
		Map<String, List<String>> allObjectsDetails = reportWizardDAO.getBusinessObjectsDetails(objectNameList);
		for(String objectName : objectNameList){
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
						"<input type='checkbox' id='"+objectName.replace("_", "")+value.replace("_", "")+"' value='"+objectName+"."+value+
						"'/>&nbsp;&nbsp;<label for='"+objectName.replace("_", "")+value.replace("_", "")+"'>"+value+"</lable></td></tr>";
					}else if(extraColumn == 2){
						returnString = returnString+"<td colspan=2>"+value+
						"<input type='checkbox' id='"+objectName.replace("_", "")+value.replace("_", "")+"' value='"+objectName+"."+value+
						"'/>&nbsp;&nbsp;<label for='"+objectName.replace("_", "")+value.replace("_", "")+"'>"+value+"</lable></td></tr>";
					}					
				}else{
					returnString = returnString+"<td>"+
					"<input type='checkbox' id='"+objectName.replace("_", "")+value.replace("_", "")+"' value='"+objectName+"."+value+
					"'/>&nbsp;&nbsp;<label for='"+objectName.replace("_", "")+value.replace("_", "")+"'>"+value+"</lable></td>";
				}
				
				if(rowNum % 3 == 0){
					returnString = returnString+"</tr>";
				}
			}
			returnString = returnString+"</tbody></table></div>";
		}
		returnString = returnString+"</div></div>";
		returnString = returnString+"<div class='card-footer' style='text-align: center;'><button type='button'"+
				" class='btn btn-success btn-xs' onclick='getReportColumns()'>Make / Manage Report Column</button> "+
		//		"<button type='button' class='btn btn-info btn-xs' onclick='getConditionColumns()'>Make Condition Column</button> "+
				"<button type='button' class='btn btn-danger btn-xs' onclick='clearChecks()'>Unmark Fileds</button></div>";
		return returnString;
	}
	
	public String formJoinField(List<String> objectNameList){
		String returnString = "";
		returnString = returnString + "<table id='JoinDetailsTable' class='table table-striped table-bordered' cellspacing='0' width='100%'>";
		returnString = returnString+"<thead><tr><td>Left Object</td><td>Join Type</td><td>Right Object</td><td>Left Fields</td><td>Operator</td><td>Right Fields</td><td>%</td><td>Value</td><td>Remove</td></tr></thead><tbody>";
		returnString = returnString+"<tr>";
		
		// Left Table
		returnString = returnString+"<td>";	
		returnString = returnString+"<select class='form-control input-sm' onChange='getLeftFields(this)'>";
		returnString = returnString+"<option value=''>Select</option>";
		for(String objectName : objectNameList){
			returnString = returnString+"<option value='"+objectName+"'>"+objectName+"</option>";
		}
		returnString = returnString+"</select>";		
		returnString = returnString+"</td>";
		
		// Join type
		returnString = returnString+"<td>";		
		returnString = returnString+"<select class='form-control input-sm'>";
		returnString = returnString+"<option value='LEFT OUTER JOIN'>LEFT OUTER</option><option value='INNER JOIN'>INNER</option><option value='RIGHT OUTER JOIN'>RIGHT OUTER</option>"+
									"<option value='AND'>AND</option><option value='OR'>OR</option>";
		returnString = returnString+"</select>";		
		returnString = returnString+"</td>";
		
		// Right Table
		returnString = returnString+"<td>";		
		returnString = returnString+"<select class='form-control input-sm' onChange='getRightFields(this)'>";
		returnString = returnString+"<option value=''>Select</option>";
		for(String objectName : objectNameList){
			returnString = returnString+"<option value='"+objectName+"'>"+objectName+"</option>";
		}
		returnString = returnString+"</select>";		
		returnString = returnString+"</td>";
		
		// Left fields
		returnString = returnString+"<td id='leftObjectFields'>Select Left Object";
		returnString = returnString+"</td>";
		
		// operator
		returnString = returnString+"<td>";
		returnString = returnString+"<select class='form-control input-sm'>";
		returnString = returnString+"<option value='='> = </option>"+
									"<option value='<>'> <> </option>"+
									"<option value='>'> > </option>"+
									"<option value='<'> < </option>"+
									"<option value='>='> >= </option>"+
									"<option value='<='> <= </option>";
		returnString = returnString+"</select>";	
		returnString = returnString+"</td>";
		
		// right fields
		returnString = returnString+"<td id='rightObjectFields'>Select Right Object";		
		returnString = returnString+"</td>";
		
		// %
		returnString = returnString+"<td><input type='text' class='form-control input-sm' />";		
		returnString = returnString+"</td>";
		
		// value
		returnString = returnString+"<td><input type='text' class='form-control input-sm' />";		
		returnString = returnString+"</td>";
		
		// action
		returnString = returnString+"<td id='removeJoinRow' style='cursor:pointer' onclick='removeJoinRow(this)'>Delete</td>";
		returnString = returnString+"</tr>";
		returnString = returnString+"</tbody></table>";
		return returnString;
	}
	
	public String getObjectColumns(String objectName){
		String returnString = "";
		returnString = returnString+"<select class='form-control input-sm' onchange='getColumnDatatype(this)'>";
		returnString = returnString+"<option value=''>Select</option>";
		List<String> filedList = reportWizardDAO.getObjectColumns(objectName);
		for(String field : filedList){
			returnString = returnString+"<option value='"+objectName+"."+field+"'>"+field+"</option>";
		}
		returnString = returnString+"</select>";
		return returnString;
	}
	
	public String createReportColumnForm(List<String> objectNameList, List<Map<String, String>> selectedColumnsList){
		String returnString = "";
		returnString = returnString + "<table id='ReportColumnDetailsTable' class='table table-striped table-bordered' cellspacing='0' width='100%'>";
		returnString = returnString+"<thead><tr><td>Aggregate</td><td>Object</td><td>Field</td><td>Display Name</td><td>Remove</td></tr></thead><tbody>";
		
		for(Map<String, String> selectedColumn : selectedColumnsList){
			String selectedObjectName = selectedColumn.get("OBJECT").trim();
			String selectedFieldName = selectedColumn.get("FIELD").trim();
			returnString = returnString+"<tr>";
			
			// Aggregate
			returnString = returnString+"<td>";		
			returnString = returnString+"<select class='form-control input-sm'>";
			returnString = returnString+"<option value='NONE'>NONE</option><option value='SUM'>SUM OF</option><option value='COUNT'>COUNT OF</option>";
			returnString = returnString+"<option value='AVG'>AVERAGE OF</option><option value='MAX'>MAXIMUM OF</option><option value='MIN'>MINIMUM OF</option>";
			returnString = returnString+"</select>";		
			returnString = returnString+"</td>";
			
			// Object			
			returnString = returnString+"<td>";	
			returnString = returnString+"<select class='form-control input-sm' onChange='getReportFields(this)'>";
			returnString = returnString+"<option value=''>Select</option>";
			for(String objectName : objectNameList){
				String isSelected = "";
				if(selectedObjectName.equals(objectName.trim())){
					isSelected = "selected";
				}else{
					isSelected = "";
				}
				returnString = returnString+"<option value='"+objectName+"' "+isSelected+">"+objectName+"</option>";
			}
			returnString = returnString+"</select>";		
			returnString = returnString+"</td>";
			
			// Fields
			returnString = returnString+"<td id='reportFileds'>";
			returnString = returnString+"<select class='form-control input-sm'>";
			returnString = returnString+"<option value=''>Select</option>";
			List<String> filedList = reportWizardDAO.getObjectColumns(selectedObjectName);
			for(String field : filedList){
				String isSelected = "";
				if(selectedFieldName.equals(field)){
					isSelected = "selected";
				}else{
					isSelected = "";
				}
				returnString = returnString+"<option value='"+selectedObjectName+"."+field+"' "+isSelected+">"+field+"</option>";
			}
			returnString = returnString+"</select>";	
			returnString = returnString+"</td>";
			
			// Column Display
			returnString = returnString+"<td>";		
			returnString = returnString+"<input class='form-control input-sm' type='text'/>";
			returnString = returnString+"</td>";
			
			// action
			returnString = returnString+"<td id='removeReportRow' style='cursor:pointer' onclick='removeReportRow(this)'>Delete</td>";
			returnString = returnString+"</tr>";
		}
		returnString = returnString+"</tbody></table>";
		return returnString;
	}
	
	public String createSetConditionForm(List<String> objectNameList, String noOfParams){
		String returnString = "";
		returnString = returnString + "<table id='ConditionDetailsTable' class='table table-striped table-bordered' cellspacing='0' width='100%'>";
		returnString = returnString+"<thead><tr><td>Condition</td><td>Brace</td><td>Left Object</td><td>Left Field</td><td>Operator</td><td>Right Object</td>"+
									"<td>Right Field</td><td>Value</td><td>%</td><td>Params</td><td>Brace</td><td>Remove</td></tr></thead><tbody>";
		returnString = returnString+"<tr>";
		
		// Condition
		returnString = returnString+"<td>";		
		returnString = returnString+"<select class='form-control input-sm'>";
		returnString = returnString+"<option value=''>Select</option><option value='AND'>AND</option><option value='OR'>OR</option>";
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
		
		// Operator
		returnString = returnString+"<td>";
		returnString = returnString+"<select class='form-control input-sm'>";
		returnString = returnString+"<option value='='> = </option>"+
									"<option value='<>'> <> </option>"+
									"<option value='>'> > </option>"+
									"<option value='<'> < </option>"+
									"<option value='>='> >= </option>"+
									"<option value='<='> <= </option>"+
									"<option value='LIKE'> LIKE </option>"+
									"<option value='NOT LIKE'> NOT LIKE </option>";
		returnString = returnString+"</select>";	
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
		returnString = returnString+"<td id='conditionRightFileds'>Select Object";		
		returnString = returnString+"</td>";
		
		// Value
		returnString = returnString+"<td>";		
		returnString = returnString+"<input class='form-control input-sm' type='text'/>";
		returnString = returnString+"</td>";
		
		// Value
		returnString = returnString+"<td>";		
		returnString = returnString+"<input style='width:20px;' class='form-control input-sm' type='text'/>";
		returnString = returnString+"</td>";
		
		// Params
		returnString = returnString+"<td>";		
		
		try{
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
		}
		returnString = returnString+"</td>";
		
		// Braces
		returnString = returnString+"<td>";		
		returnString = returnString+"<select class='form-control input-sm'>";
		returnString = returnString+"<option value=''>Select</option><option value=')'>)</option><option value='('>(</option>";
		returnString = returnString+"</select>";		
		returnString = returnString+"</td>";
		
		// action
		returnString = returnString+"<td id='removeConditionRow' style='cursor:pointer' onclick='removeConditionRow(this)'>Delete</td>";
		returnString = returnString+"</tr>";
		returnString = returnString+"</tbody></table>";
		return returnString;
	}
	
	public String createSetAggregateConditionForm(List<String> objectNameList, String noOfParams){
		String returnString = "";
		returnString = returnString + "<fieldset><legend>GROUP BY <button type='button' class='btn btn-primary btn-xs' onclick='addACGroupRow()'>Add Row</button></legend> "+
					"<table id='ACGroup' class='table table-striped table-bordered' cellspacing='0' width='100%'>"+
					"<thead><tr><td width='40%'>Object</td><td width='40%'>Field</td><td width='20%'>Remove</td></tr></thead><tbody>";
		returnString = returnString+"<tr>";
		
		// Object
		returnString = returnString+"<td>";	
		returnString = returnString+"<select class='form-control input-sm' onChange='getACGroupFields(this)'>";
		returnString = returnString+"<option value=''>Select</option>";
		for(String objectName : objectNameList){
			returnString = returnString+"<option value='"+objectName+"'>"+objectName+"</option>";
		}
		returnString = returnString+"</select>";		
		returnString = returnString+"</td>";
		
		// Filed
		returnString = returnString+"<td id='ACGroupFileds'>Select Object";		
		returnString = returnString+"</td>";
		
		returnString = returnString+"<td onclick='removeACGroup(this)' style='cursor : pointer'>Delete</td>";
		returnString = returnString+"</tr>";
		returnString = returnString+"</tbody></table></fieldset>";
		
		returnString = returnString + "<fieldset><legend>HAVING <button type='button' class='btn btn-primary btn-xs' onclick='addACHavingRow()'>Add Row</button></legend> "+
					"<table id='ACHaving' class='table table-striped table-bordered' cellspacing='0' width='100%'>"+
					"<thead><tr><td>Condition</td><td>Aggregate</td><td>Object</td><td>Field</td> "+
					"<td>Operator</td><td>Datatype</td><td>Value</td><td>Params</td><td>Remove</td></tr></thead><tbody>";
		returnString = returnString+"<tr>";
		
		// Condition
		returnString = returnString+"<td>";		
		returnString = returnString+"<select class='form-control input-sm'>";
		returnString = returnString+"<option value='AND'>AND</option><option value='OR'>OR</option>";
		returnString = returnString+"</select>";		
		returnString = returnString+"</td>";
		
		// Aggregate
		returnString = returnString+"<td>";
		returnString = returnString+"<select class='form-control input-sm'>";
		returnString = returnString+"<option value='SUM'>SUM OF</option><option value='COUNT'>COUNT OF</option>";
		returnString = returnString+"<option value='AVG'>AVERAGE OF</option><option value='MAX'>MAXIMUM OF</option><option value='MIN'>MINIMUM OF</option>";
		returnString = returnString+"</select>";		
		returnString = returnString+"</td>";
		
		// Object
		returnString = returnString+"<td>";	
		returnString = returnString+"<select class='form-control input-sm' onChange='getACHavingFields(this)'>";
		returnString = returnString+"<option value=''>Select</option>";
		for(String objectName : objectNameList){
			returnString = returnString+"<option value='"+objectName+"'>"+objectName+"</option>";
		}
		returnString = returnString+"</select>";		
		returnString = returnString+"</td>";
		
		// Filed
		returnString = returnString+"<td id='ACHavingFileds'>Select Object";		
		returnString = returnString+"</td>";
		
		// Operator
		returnString = returnString+"<td>";
		returnString = returnString+"<select class='form-control input-sm'>";
		returnString = returnString+"<option value='='> = </option>"+
									"<option value='<>'> <> </option>"+
									"<option value='>'> > </option>"+
									"<option value='<'> < </option>"+
									"<option value='>='> >= </option>"+
									"<option value='<='> <= </option>";
		returnString = returnString+"</select>";	
		returnString = returnString+"</td>";
		
		// Datatype
		returnString = returnString+"<td>";		
		returnString = returnString+"<select class='form-control input-sm' onChange='checkDatatype(this)'>";
		returnString = returnString+"<option value='TEXT'>TEXT</option><option value='NUMBER'>NUMBER</option><option value='DATE'>DATE</option>";
		returnString = returnString+"</select>";		
		returnString = returnString+"</td>";
		
		// Value
		returnString = returnString+"<td>";		
		returnString = returnString+"<input class='form-control input-sm' type='text'/>";
		returnString = returnString+"</td>";
		
		// Params
		returnString = returnString+"<td>";		
		
		try{
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
		}
		returnString = returnString+"</td>";
		
		returnString = returnString+"<td onclick='removeACHaving(this)' >Delete</td>";
		returnString = returnString+"</tr>";
		returnString = returnString+"</tbody></table></fieldset>";
		return returnString;
	}
	
	public String getColumnsDatatype(String objectName, String fieldName){
		return reportWizardDAO.getColumnsDatatype(objectName, fieldName);
	}
	
	public String saveReport(String reportObjects, String reportJoinDetails, String reportColumns, String conditionDetails, String aggregateConditions, 
			String reportId, String reportCode, String reportName, String reportHeader, String reportFooter, String isEnabled, String userCode,
			String objectHtml, String joinHtml, String reportHtml, String conditionHtml, String aggregateConditionHtml, String noOfParams){
		
		return reportWizardDAO.saveReport(reportObjects, reportJoinDetails, reportColumns, conditionDetails, aggregateConditions, reportId, reportCode,
				reportName, reportHeader, reportFooter, isEnabled, userCode, objectHtml, joinHtml, reportHtml, conditionHtml, aggregateConditionHtml, noOfParams);
	}
	
	public String getObjectSelected(String reportId){
		return reportWizardDAO.getObjectSelected(reportId);
	}
	
	public String createNewReportId(){
		return reportWizardDAO.createNewReportId();
	}
	
	public String getReportDetails(String reportId, String section){
		return reportWizardDAO.getReportDetails(reportId, section);
	}
	
	public HashMap<String,Object> builReportData(String userName, String builtCondition, String reportID, String noOfParameters, HashMap<String,String> hashMap){
		return reportWizardDAO.builReportData(userName, builtCondition, reportID, noOfParameters, hashMap);
	}

	@Override
	public List<Map<String, String>> fetchReportBuilderParameters(
			String reportId, String parameterIndex) {
		return reportWizardDAO.fetchReportBuilderParameters(reportId, parameterIndex);
	}

	@Override
	public String saveUpdateReportParameters(String noOfParam, String reportId,
			String parameterIndex, String userCode, String parameterLabel,
			String parameterType, String isMandatory, String defaultValueType,
			String defaultValue) {
		return reportWizardDAO.saveUpdateReportParameters(noOfParam, reportId, parameterIndex, userCode, parameterLabel, parameterType, isMandatory, defaultValueType, defaultValue);
	}
	
	@Override
	public String deleteReportParameters(String selected, String reportId){
		return reportWizardDAO.deleteReportParameters(selected, reportId);
	}
}

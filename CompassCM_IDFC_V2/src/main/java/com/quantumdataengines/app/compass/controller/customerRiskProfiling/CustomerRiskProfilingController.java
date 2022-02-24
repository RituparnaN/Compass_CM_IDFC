package com.quantumdataengines.app.compass.controller.customerRiskProfiling;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.quantumdataengines.app.compass.otherservice.OtherCommonService;
import com.quantumdataengines.app.compass.service.CommonService;
import com.quantumdataengines.app.compass.service.customerRiskProfiling.CustomerRiskProfilingService;
import com.quantumdataengines.app.compass.service.master.GenericMasterService;
import com.quantumdataengines.app.compass.util.CommonUtil;

@Controller
@RequestMapping(value="/admin")
public class CustomerRiskProfilingController {
	
	@Autowired
	private CommonService commonService;
	@Autowired
	private OtherCommonService otherCommonService;
	@Autowired
	private GenericMasterService genericMasterService; 
	@Autowired
	private CustomerRiskProfilingService customerRiskProfilingService;
	
	@RequestMapping(value="/customerRiskProfiling", method=RequestMethod.GET)
	public String riskCategorization(HttpServletRequest request,HttpServletResponse response, Authentication authentication){
	String moduleType = request.getParameter("moduleType");
	String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
	request.setAttribute("MASTERSEARCHFRAME", genericMasterService.getModuleParameters(moduleType, 
			authentication.getPrincipal().toString(), userRole, request.getRemoteAddr()));
	request.setAttribute("MODULETYPE", moduleType);
	request.setAttribute("UNQID", otherCommonService.getElementId());
	request.setAttribute("USERROLE", userRole);
	commonService.auditLog(authentication.getPrincipal().toString(), request, "CUSTOMER RISK RULES", "OPEN", "Module Accessed");
	return "CustomerRiskProfiling/index";
	}
	
	
	@RequestMapping(value="/createNewRule", method=RequestMethod.GET)
	public String createNewReport(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String userCode = authentication.getPrincipal().toString();
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String remoteAddr = request.getRemoteAddr();
		request.setAttribute("BUSINESSOBJECTS", customerRiskProfilingService.getAllBusinessObject(userCode,userRole,remoteAddr));
		request.setAttribute("ruleID", customerRiskProfilingService.createNewRuleId(userCode,userRole,remoteAddr));
		/*if(message != null && message != ""){
			request.setAttribute("message", message);
			message = "";
		}*/
		
		request.setAttribute("LOGGEDUSER", authentication.getPrincipal().toString());
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CUSTOMER RISK RULES", "OPEN", "Module Accessed");
		return "CustomerRiskProfiling/newRule";
	}
	
	@RequestMapping(value="/getAllTableColumns", method=RequestMethod.POST)
	public @ResponseBody String getAllObjectColumns(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		List<String> listObject = new ArrayList<String>();
		String values = request.getParameter("value");
		String[] arrTablesDisplayNames = CommonUtil.splitString(values, "|");
		for(int i = 0; i < arrTablesDisplayNames.length; i++){
			String[] arrTableDetails = CommonUtil.splitString(arrTablesDisplayNames[i], "^");
			if(arrTableDetails.length > 0){
				listObject.add(arrTableDetails[0]);
			}
		}
		String userCode = authentication.getPrincipal().toString();
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String remoteAddr = request.getRemoteAddr();
		request.setAttribute("LOGGEDUSER", authentication.getPrincipal().toString());
		commonService.auditLog(authentication.getPrincipal().toString(), request, "REPORTS", "SEARCH", "Module Accessed");
		return customerRiskProfilingService.getAllTableColumns(listObject,userCode,userRole,remoteAddr);
	}
	
	
	@RequestMapping(value="/buildRules", method=RequestMethod.POST)
	public @ResponseBody Map<String,Object>  buildCondition(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String returnString = "";
		String value = request.getParameter("value");
		String[] arrRowData = CommonUtil.splitString(value, "|");
		for(int rowIndex = 0; rowIndex < arrRowData.length; rowIndex++){
			String[] arrColData = CommonUtil.splitString(arrRowData[rowIndex], "^");
			if(arrColData.length == 14){/*
				for(int i = 0;i<arrColData.length;i++){
					System.out.println("index = "+i+"   value = "+arrColData[i]);
				}*/
				String[] strArr = CommonUtil.splitString(arrColData[3], ".");
				String dataType = "";
				if(strArr.length == 2){
					String objectName = strArr[0];
					String colName = strArr[1];					
					//dataType = customerRiskProfilingService.getColumnsDatatype(objectName, colName);
				}
				returnString = returnString +" "+ arrColData[0] +" "+ arrColData[1] +" "+ arrColData[3] +" "+ arrColData[4]+" ";
				
				if(arrColData[4].trim().length() > 0){
					if(arrColData[5].trim().length() > 0){
						Map<String,Object>  dataTypeChk = chkDatatypeAndValue(arrColData[3],arrColData[4],arrColData[5]);
						if(!(Boolean) dataTypeChk.get("STATUS")){
							return dataTypeChk;
						}
						returnString += formatQueryAccOperator(arrColData[4].trim(),arrColData[5].trim());
					}
				}
				returnString += arrColData[7].trim()+" "+arrColData[8].trim()+" "+arrColData[9].trim();
				if(arrColData[9].trim().length() > 0){
					if(arrColData[10].trim().length() > 0){
						Map<String,Object>  dataTypeChk = chkDatatypeAndValue(arrColData[7],arrColData[9],arrColData[10]);
						if(!(Boolean) dataTypeChk.get("STATUS")){
							return dataTypeChk;
						}
						returnString += formatQueryAccOperator(arrColData[9].trim(),arrColData[10].trim());
					}
				}
				
				
				if(arrColData[11].trim().length() > 0){
					if(arrColData[7].trim().length() > 0 && arrColData[10].trim().length() == 0){
						Map<String,Object>  dataTypeChk = chkDatatypeAndValue(arrColData[7],arrColData[9],arrColData[11]);
						if(!(Boolean) dataTypeChk.get("STATUS")){
							return dataTypeChk;
						}
						returnString += formatQueryAccOperator(arrColData[9].trim(),arrColData[11].trim());
					}else if(arrColData[3].trim().length() > 0 && arrColData[5].trim().length() == 0){
						Map<String,Object>  dataTypeChk = chkDatatypeAndValue(arrColData[3],arrColData[4],arrColData[11]);
						if(!(Boolean) dataTypeChk.get("STATUS")){
							return dataTypeChk;
						}
						returnString += formatQueryAccOperator(arrColData[4].trim(),arrColData[11].trim());
					}else if(arrColData[0].trim().equals("THEN")){
						returnString += " '"+arrColData[11]+"' ";
					}
				}
				
				
				
				/*if(arrColData[6].trim().length() > 0){
					if(arrColData[8].trim().length() > 0){
						returnString = returnString +" (("+arrColData[8]+" * "+ arrColData[6]+")/100)";
					}else{
						returnString = returnString + arrColData[6];
					}
				}else if(arrColData[9].trim().length() > 0){
					if(arrColData[8].trim().length() > 0){
						returnString = returnString +" (("+arrColData[8]+" * "+ arrColData[9]+")/100)";
					}else{
						returnString = returnString + arrColData[9];
					}
				}else if(arrColData[7].trim().length() > 0){
					if(dataType.contains("DATE") || dataType.contains("TIMESTAMP")){
						returnString = returnString+" TO_TIMESTAMP('"+arrColData[7]+"','DD/MM/YYYY') ";
					}else if(dataType.contains("NUMBER")){
						returnString = returnString + arrColData[7];
					}else
						returnString = returnString + " '"+arrColData[7]+"'";
				}*/
				
				returnString = returnString +" "+ arrColData[12]+" ";
			}else{/*
				System.out.println("more param");
				System.out.println("length = "+arrColData.length);*/
			}
		}
		request.setAttribute("LOGGEDUSER", authentication.getPrincipal().toString());
		commonService.auditLog(authentication.getPrincipal().toString(), request, "Customer Risk Profiling", "INSERT", "Module Accessed");
		/*System.out.println("final string = "+returnString);*/
		Map<String,Object>output = new HashMap<String,Object>();
		output.put("STATUS",true);
		output.put("RULE",returnString);
		output.put("MESSAGE","SUCCESS");
		return output;
	}
	
	public  String formatQueryAccOperator(String Op , String val){
		String str = "";
		String[] strArr = CommonUtil.splitString(val, ",");
		if(Op.equals("IN") || Op.equals("NOT IN")){
			str += " ( ";
			for(int i = 0; i < strArr.length;i++){
				str +=  "'"+strArr[i]+"'";
				if(i != strArr.length-1){
					str += " , "; 
				}
			}
			str += " ) ";
		}else if(Op.equals("/")){
			str += val;
		}else if(Op.equals("LIKE")|| Op.equals("NOT LIKE")){
			str += "'%"+val+"%'";
		}
		else{
			//str += " '"+val+"' ";
			if(val.matches("[0-9.]*")){
				str +=  val;
			}else{
				str +=  "'"+val+"'";
			}
		}/*
		System.out.println("val  "+val);
		System.out.println("operator string = "+str);*/
		return str;
		
	}
	
	public Map<String,Object> chkDatatypeAndValue(String TableAndColumnName,String OP,String values){
		Map<String,Object>output = new HashMap<String,Object>();
		String [] NumberDataTypeOp = {"/","*","+","-","=",">","<",">=","<=","<>","LIKE","NOT LIKE","IN","NOT IN"};
		String [] varcharDataTypeOp = {"=","<>","LIKE","NOT LIKE","IN","NOT IN"};
		Boolean status = null;
		String message = "";
		String tableName = "";
		String[] tableAndCOlumn = TableAndColumnName.split("\\.");
		//System.out.println("value = "+values);
		/*if(tableAndCOlumn[0].equals("TB_CRP_STATIC_SUB_PARAMETERS")){
			tableName = "TB_CRP_STATIC_PARAMETERS";
		}else if(tableAndCOlumn[0].equals("TB_CRP_DYNAMIC_SUB_PARAMETERS")){
			tableName = "TB_CRP_DYNAMIC_PARAMETERS";
		}
		String fieldName = tableAndCOlumn[1];  
		String dataType = customerRiskProfilingService.getColumnsDatatype(tableName,fieldName);
		System.out.println("value = "+values+" op = "+OP);*/
		/*if(values.matches("(\\d+)(\\.)?(\\d+)?") && Arrays.asList(NumberDataTypeOp).contains(OP)  ){*/
		if(values.matches("(?<=^| )\\d+(\\.\\d+)?(?=$| )|(?<=^| )\\.\\d+(?=$| )") && Arrays.asList(NumberDataTypeOp).contains(OP)  ){
			status = true;
		}else if(values.matches("[a-zA-Z0-9 ,]+") && Arrays.asList(varcharDataTypeOp).contains(OP)){
			status = true;
		}else{
			System.out.println(values);
			status = false;
			message = "The current operator can not apply on this column datatype and value";
		}
		output.put("STATUS", status);
		output.put("MESSAGE", message);
		return output;
	}

	
	@RequestMapping(value="/createRuleConditionForm", method=RequestMethod.POST)
	public @ResponseBody String createSetConditionForm(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String objectsForConditions = request.getParameter("objectsForConditions");
		String noOfParams = request.getParameter("noOfParams"); 
		List<String> listObject = new ArrayList<String>();
		String[] arrTablesDisplayNames = CommonUtil.splitString(objectsForConditions, "|");
		for(int i = 0; i < arrTablesDisplayNames.length; i++){
			String[] arrTableDetails = CommonUtil.splitString(arrTablesDisplayNames[i], "^");
			if(arrTableDetails.length > 0){
				listObject.add(arrTableDetails[0]);
			}
		}
		String userCode = authentication.getPrincipal().toString();
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String remoteAddr = request.getRemoteAddr();
		request.setAttribute("LOGGEDUSER", authentication.getPrincipal().toString());
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CUSTOMER RISK RULES", "INSERT", "Module Accessed");
		return customerRiskProfilingService.createRuleConditionForm(listObject, noOfParams,userCode,userRole,remoteAddr);
	}
	
	
	@RequestMapping(value="/getTableObjectColumns", method=RequestMethod.POST)
	public @ResponseBody String getTableObjectColumns(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String objectTableName = request.getParameter("objectName");
		String userCode = authentication.getPrincipal().toString();
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String remoteAddr = request.getRemoteAddr();
		request.setAttribute("LOGGEDUSER", authentication.getPrincipal().toString());
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CUSTOMER RISK RULES", "SEARCH", "Module Accessed");
		//System.out.println(customerRiskProfilingService.getTableObjectColumns(objectTableName));
		return customerRiskProfilingService.getTableObjectColumns(objectTableName,userCode,userRole,remoteAddr);
	}
	
	@RequestMapping(value = "/getCRPTableColumnValue", method=RequestMethod.POST)
	public @ResponseBody String getCRPTableColumnValues(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String tableName = request.getParameter("tableName");
		String columnName = request.getParameter("columnName");
		String userCode = authentication.getPrincipal().toString();
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String remoteAddr = request.getRemoteAddr();
		request.setAttribute("LOGGEDUSER", authentication.getPrincipal().toString());
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CUSTOMER RISK RULES", "SEARCH", "Module Accessed");
		return customerRiskProfilingService.getCRPTableColumnValues(tableName,columnName,userCode,userRole,remoteAddr);
	}
	
	//for saving Customer Risk Profule Rules...
	@RequestMapping(value = "/saveCRPRules", method=RequestMethod.POST)
	public @ResponseBody String saveCustomerRiskProfileRules(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String objects = request.getParameter("objects");
		String ruleId = request.getParameter("ruleID");
		String ruleCode = request.getParameter("ruleCode");
		String ruleName = request.getParameter("ruleName");
		String risk = request.getParameter("risk");
		String isEnable = request.getParameter("isEnabled");
		String rule = request.getParameter("rule");
		String ruleConditionHTML = request.getParameter("ruleConditionHTML");
		String makerComment  = request.getParameter("makerComment");
		String CRPRuleFor = request.getParameter("CRPRuleFor");
		String tableNames = "";
		String[] arrTablesDisplayNames = CommonUtil.splitString(objects, "|");
		for(int i = 0; i < arrTablesDisplayNames.length; i++){
			String[] arrTableDetails = CommonUtil.splitString(arrTablesDisplayNames[i], "^");
			if(arrTableDetails.length > 0){
				tableNames = tableNames + arrTableDetails[0];
				
				if(i != arrTablesDisplayNames.length-2){
					tableNames = tableNames +",";
				}
			}
		}
		
		String userCode = authentication.getPrincipal().toString();
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String remoteAddr = request.getRemoteAddr();
		Map<String,Object>output = customerRiskProfilingService.saveCustomerRiskProfileRules(tableNames,ruleId,ruleCode,ruleName,risk,isEnable,rule,ruleConditionHTML,userCode,userRole,remoteAddr,makerComment,CRPRuleFor);
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CUSTOMER RISK RULES", "INSERT", "Module Accessed");
		return (String) output.get("MESSAGE");
	}
	
	//for updating crp rules...updateCRPRule
	@RequestMapping(value="/updateCRPRule", method=RequestMethod.GET)
	public String updateReport(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String message;
		String ruleID = request.getParameter("ruleID");
		String userCode = authentication.getPrincipal().toString();
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String remoteAddr = request.getRemoteAddr();
		request.setAttribute("BUSINESSOBJECTS", customerRiskProfilingService.getAllBusinessObject(userCode,userRole,remoteAddr));
		request.setAttribute("LOGGEDUSER", authentication.getPrincipal().toString());
		if(ruleID != null && ruleID.trim().length() > 0){
			request.setAttribute("ruleID", ruleID);
			return "CustomerRiskProfiling/updateRule";
		}else{
			message = "Rule ID not found. Create a new report.";
			commonService.auditLog(authentication.getPrincipal().toString(), request, "CUSTOMER RISK RULES", "UPDATE", "Data Updated");
			return "redirect:customerRiskProfiling";
		}
	}
	
	//FOR GETTING DETAILS OF RULES..
	@RequestMapping(value="/getCRPRulesDetails", method=RequestMethod.POST)
	public @ResponseBody String getCRPRulesDetails(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String value = "";
		String ruleID = request.getParameter("ruleID");
		String section = request.getParameter("section");
		String userCode = authentication.getPrincipal().toString();
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String remoteAddr = request.getRemoteAddr();
		request.setAttribute("LOGGEDUSER", authentication.getPrincipal().toString());
		value = customerRiskProfilingService.getCRPRulesDetails(ruleID, section,userCode,userRole,remoteAddr);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CUSTOMER RISK RULES", "SEARCH", "Module Accessed");
		return value;
	}
	
	//getting selected object 
	@RequestMapping(value="/CRPobjectToSelect", method=RequestMethod.POST)
	public @ResponseBody String objectToSelect(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String ruleID = request.getParameter("ruleID");
		String objectName = request.getParameter("objectName");
		/*System.out.println("object by client = "+objectName);*/
		String userCode = authentication.getPrincipal().toString();
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String remoteAddr = request.getRemoteAddr();
		String selectObjects = customerRiskProfilingService.CRPobjectToSelect(ruleID,userCode,userRole,remoteAddr);
		/*System.out.println("obj = = "+selectObjects);*/
		String [] objArr = selectObjects.split(",");
		request.setAttribute("LOGGEDUSER", authentication.getPrincipal().toString());
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CUSTOMER RISK RULES", "SEARCH", "Module Accessed");
		if(Arrays.asList(objArr).contains(objectName)){
			return "y";
		}else{
			return "N";
		}
	}
	
	//for validating rules
	@RequestMapping(value="/validateCRPRules", method=RequestMethod.POST)
	public @ResponseBody Map<String,Object> validateCRPRules(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		Map<String,Object>output = new HashMap<String,Object>();
		String rule = request.getParameter("rule");
		String ruleID = request.getParameter("ruleID");
		String userCode = authentication.getPrincipal().toString();
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String remoteAddr = request.getRemoteAddr();
		output = customerRiskProfilingService.validateCRPRules(rule,ruleID,userCode,userRole,remoteAddr);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CUSTOMER RISK RULES", "SEARCH", "Module Accessed");
		return output;
	}
	
		/*new functions for new functionality */
	
	@RequestMapping(value="/createNewCRPRule", method=RequestMethod.GET)
	public String createNewCRPRule(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String userCode = authentication.getPrincipal().toString();
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String remoteAddr = request.getRemoteAddr();
		request.setAttribute("BUSINESSOBJECTS", customerRiskProfilingService.getAllBusinessObject(userCode,userRole,remoteAddr));
		request.setAttribute("ruleID", customerRiskProfilingService.createNewRuleId(userCode,userRole,remoteAddr));
		/*if(message != null && message != ""){
			request.setAttribute("message", message);
			message = "";
		}*/
		
		request.setAttribute("LOGGEDUSER", authentication.getPrincipal().toString());
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CUSTOMER RISK RULES", "INSERT", "Module Accessed");
		return "CustomerRiskProfiling/newCRPRule";
	}
	//for updating crp rules...updateCRPRule
	@RequestMapping(value="/updateRule", method=RequestMethod.GET)
	public String updateRule(HttpServletRequest request, HttpServletResponse response, 
		Authentication authentication) throws Exception{
		String message;
		String ruleID = request.getParameter("ruleID");
		String CRPRuleStatus = request.getParameter("CRPRuleStatus");
		String userCode = authentication.getPrincipal().toString();
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String remoteAddr = request.getRemoteAddr();
		request.setAttribute("BUSINESSOBJECTS", customerRiskProfilingService.getAllBusinessObject(userCode,userRole,remoteAddr));
		if(ruleID != null && ruleID.trim().length() > 0){
			request.setAttribute("ruleID", ruleID);
			request.setAttribute("CURRENTROLECODE",(String) request.getSession(false).getAttribute("CURRENTROLE"));
			request.setAttribute("CRPRuleStatus", CRPRuleStatus);
			return "CustomerRiskProfiling/updateCRPRule";
		}else{
			message = "Rule ID not found. Create a new report.";
			commonService.auditLog(authentication.getPrincipal().toString(), request, "CUSTOMER RISK RULES", "UPDATE", "Data Updated");
			return "redirect:customerRiskProfiling";
		}
	}
	
	
	//FOR GETTING DETAILS OF RULES..
		@RequestMapping(value="/getRuleDetails", method=RequestMethod.POST)
		public @ResponseBody Map<String,Object> getRuleDetails(HttpServletRequest request, HttpServletResponse response, 
				Authentication authentication) throws Exception{
			String ruleID = request.getParameter("ruleID");
			String CRPRuleStatus = request.getParameter("CRPRuleStatus");
			String userCode = authentication.getPrincipal().toString();
			String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
			String remoteAddr = request.getRemoteAddr();
			Map<String,Object> details =  customerRiskProfilingService.getRuleDetails(ruleID,CRPRuleStatus,userCode,userRole,remoteAddr);
			commonService.auditLog(authentication.getPrincipal().toString(), request, "CUSTOMER RISK RULES", "SEARCH", "Module Accessed");
			return details;
		}
		
		
		@RequestMapping(value = "/saveRules", method=RequestMethod.POST)
		public @ResponseBody String saveRules(HttpServletRequest request, HttpServletResponse response, 
				Authentication authentication) throws Exception{
			String objects = request.getParameter("objects");
			String ruleId = request.getParameter("ruleID");
			String ruleCode = request.getParameter("ruleCode");
			String ruleName = request.getParameter("ruleName");
			String risk = request.getParameter("risk");
			String isEnable = request.getParameter("isEnabled");
			String rule = request.getParameter("rule");
			String ruleConditionHTML = request.getParameter("ruleConditionHTML");
			String makerComments  = request.getParameter("makerComments");
			String CRPRuleFor = request.getParameter("CRPRuleFor");
			
			
			String tableNames = "";
			
			/*String[] arrTablesDisplayNames = CommonUtil.splitString(objects, "|");
			for(int i = 0; i < arrTablesDisplayNames.length; i++){
				String[] arrTableDetails = CommonUtil.splitString(arrTablesDisplayNames[i], "^");
				if(arrTableDetails.length > 0){
					tableNames = tableNames + arrTableDetails[0];
					
					if(i != arrTablesDisplayNames.length-2){
						tableNames = tableNames +",";
					}
				}
			}*/
			
			String userCode = authentication.getPrincipal().toString();
			String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
			String remoteAddr = request.getRemoteAddr();
			Map<String,Object>output = customerRiskProfilingService.saveCustomerRiskProfileRules(tableNames,ruleId,ruleCode,ruleName,risk,isEnable,rule,ruleConditionHTML,userCode,userRole,remoteAddr,makerComments,CRPRuleFor);
			
			commonService.auditLog(authentication.getPrincipal().toString(), request, "CUSTOMER RISK RULES", "INSERT", "Module Accessed");
			return (String) output.get("MESSAGE");
		}
		
		@RequestMapping(value="/getTableColumns", method=RequestMethod.POST)
		public @ResponseBody Map<String,String> getTableColumns(HttpServletRequest request, HttpServletResponse response, 
				Authentication authentication) throws Exception{
			String objectTableName = request.getParameter("objectName");
			String userCode = authentication.getPrincipal().toString();
			String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
			String remoteAddr = request.getRemoteAddr();
			request.setAttribute("LOGGEDUSER", authentication.getPrincipal().toString());
			commonService.auditLog(authentication.getPrincipal().toString(), request, "CUSTOMER RISK RULES", "SEARCH", "Module Accessed");
			//System.out.println(customerRiskProfilingService.getTableObjectColumns(objectTableName));
			return customerRiskProfilingService.getTableColumns(objectTableName,userCode,userRole,remoteAddr);
		}
		
		
		@RequestMapping(value = "/getTableColumnValue", method=RequestMethod.POST)
		public @ResponseBody Map<String,String> getTableColumnValue(HttpServletRequest request, HttpServletResponse response, 
				Authentication authentication) throws Exception{
			String tableName = request.getParameter("tableName");
			String columnName = request.getParameter("columnName");
			String userCode = authentication.getPrincipal().toString();
			String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
			String remoteAddr = request.getRemoteAddr();
			request.setAttribute("LOGGEDUSER", authentication.getPrincipal().toString());
			commonService.auditLog(authentication.getPrincipal().toString(), request, "CUSTOMER RISK RULES", "SEARCH", "Module Accessed");
			return customerRiskProfilingService.getTableColumnValues(tableName,columnName,userCode,userRole,remoteAddr);
		}
		
		//for changing status of a rule  
		
		@RequestMapping(value = "/openModelForChanginRuleStatus", method=RequestMethod.POST)
		public String openModelForChanginRuleStatus(HttpServletRequest request, HttpServletResponse response, 
				Authentication authentication) throws Exception{
			String ruleID = request.getParameter("ruleID");
			String userCode = authentication.getPrincipal().toString();
			String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
			String remoteAddr = request.getRemoteAddr();
			String CRPRuleStatus = request.getParameter("CRPRuleStatus");
			Map<String,Object> details =  customerRiskProfilingService.getRuleDetails(ruleID,CRPRuleStatus,userCode,userRole,remoteAddr);
			request.setAttribute("CRPRULEDETAILS", details);
			request.setAttribute("UNQID", otherCommonService.getElementId());
			request.setAttribute("submitButton", request.getParameter("submitButton"));
			commonService.auditLog(authentication.getPrincipal().toString(), request, "CUSTOMER RISK RULES", "OPEN", "Module Accessed");
			return "CustomerRiskProfiling/changeStatus";
			//customerRiskProfilingService.getTableColumnValues(tableName,columnName,userCode,userRole,remoteAddr);
		}
		
		@RequestMapping(value = "/CRPRuleStatusChange", method=RequestMethod.POST)
		public @ResponseBody String CRPRuleStatusChange(HttpServletRequest request, HttpServletResponse response, 
				Authentication authentication) throws Exception{
			String ruleID = request.getParameter("ruleID");
			String comment = request.getParameter("comment");
			String CRPRuleStatus = request.getParameter("status");
			String userCode = authentication.getPrincipal().toString();
			String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
			String remoteAddr = request.getRemoteAddr();
			
			commonService.auditLog(authentication.getPrincipal().toString(), request, "CUSTOMER RISK RULES", "UPDATE", "Module Accessed");
			return  customerRiskProfilingService.CRPRuleStatusChange(ruleID,comment,CRPRuleStatus,userCode,userRole,remoteAddr);
		}

}



package com.quantumdataengines.app.compass.controller.reports;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.quantumdataengines.app.compass.otherservice.OtherCommonService;
import com.quantumdataengines.app.compass.service.CommonService;
import com.quantumdataengines.app.compass.service.master.GenericMasterService;
import com.quantumdataengines.app.compass.service.reports.ReportWizardService;
import com.quantumdataengines.app.compass.util.CommonUtil;

@Controller
@RequestMapping(value="/admin")
public class ReportWizardController {
	
//	private static Logger log = LoggerFactory.getLogger(ReportWizardController.class);
	@Autowired
	private ReportWizardService reportWizardService;
	@Autowired
	private CommonService commonService;
	@Autowired
	private OtherCommonService otherCommonService;
	@Autowired
	private GenericMasterService genericMasterService; 
	
	@RequestMapping(value="/reportWizard", method=RequestMethod.GET)
	public String reportWizard(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String moduleType = request.getParameter("moduleType");
		request.setAttribute("MODULETYPE", moduleType);
		System.out.println(moduleType);
		request.setAttribute("UNQID", otherCommonService.getElementId());
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		request.setAttribute("MASTERSEARCHFRAME", genericMasterService.getModuleParameters(moduleType, 
				authentication.getPrincipal().toString(), userRole, request.getRemoteAddr()));

		commonService.auditLog(authentication.getPrincipal().toString(), request, "REPORTS", "OPEN", "Module Accessed");
		return "ReportWizard/index";
	}
	
	@RequestMapping(value="/createNewReport", method=RequestMethod.GET)
	public String createNewReport(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		request.setAttribute("BUSINESSOBJECTS", reportWizardService.getAllBusinessObject());
		request.setAttribute("reportID", reportWizardService.createNewReportId());
		if(message != null && message != ""){
			request.setAttribute("message", message);
			message = "";
		}
		request.setAttribute("LOGGEDUSER", authentication.getPrincipal().toString());
		commonService.auditLog(authentication.getPrincipal().toString(), request, "REPORTS", "OPEN", "Module Accessed");
		return "ReportWizard/reportWizard";
	}
	
	@RequestMapping(value="/setReportParameters", method=RequestMethod.GET)
	public String setReportParameters(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String noOfParam = request.getParameter("l_strNoOfParameters");
		String reportId = request.getParameter("l_strReportID");
		String paramIndex = request.getParameter("paramIndex");
		
		request.setAttribute("paramIndex", paramIndex);
		request.setAttribute("noOfParam", noOfParam);
		request.setAttribute("reportId", reportId);
		
		request.setAttribute("RECORDS", reportWizardService.fetchReportBuilderParameters(reportId, paramIndex));
		request.setAttribute("ALLRECORDS", reportWizardService.fetchReportBuilderParameters(reportId, null));
		commonService.auditLog(authentication.getPrincipal().toString(), request, "REPORTS", "OPEN", "Module Accessed");
		return "ReportWizard/SetManageParameters";
	}
	
	
	@RequestMapping(value="/deleteReportParameters", method=RequestMethod.GET)
	public String deleteReportParameters(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String selected = request.getParameter("selected");
		String reportId = request.getParameter("reportId");
		String noOfParam = request.getParameter("noOfParam");
		
		request.setAttribute("noOfParam", noOfParam);
		request.setAttribute("reportId", reportId);
		
		reportWizardService.deleteReportParameters(selected, reportId);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "REPORTS", "DELETE", "Data Deleted");
		return "redirect:setReportParameters?l_strNoOfParameters="+noOfParam+"&l_strReportID="+reportId;
	}
	
	@RequestMapping(value="/saveReportParameters", method=RequestMethod.POST)
	public String saveReportParameters(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String noOfParam = request.getParameter("noOfParam");
		String reportId = request.getParameter("reportId");
		String parameterIndex = request.getParameter("parameterIndex");
		String parameterLabel = request.getParameter("parameterLabel");
		String parameterType = request.getParameter("parameterType");
		String isMandatory = request.getParameter("isMandatory");
		String defaultValueType = request.getParameter("defaultValueType");
		String defaultValue = request.getParameter("defaultValue");
		String userCode = authentication.getPrincipal().toString();
		
		request.setAttribute("noOfParam", noOfParam);
		request.setAttribute("reportId", reportId);
		
		reportWizardService.saveUpdateReportParameters(noOfParam, reportId, parameterIndex, userCode, parameterLabel, 
												parameterType, isMandatory, defaultValueType, defaultValue);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "REPORTS", "INSERT", "Data Saved");
		return "redirect:setReportParameters?l_strNoOfParameters="+noOfParam+"&l_strReportID="+reportId;
	}
	
	@RequestMapping(value="/getAllObjectColumns", method=RequestMethod.POST)
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
		request.setAttribute("LOGGEDUSER", authentication.getPrincipal().toString());
		commonService.auditLog(authentication.getPrincipal().toString(), request, "REPORTS", "OPEN", "Module Accessed");
		return reportWizardService.getBusinessObjectsDetails(listObject);
	}
	
	@RequestMapping(value="/createJoinForm", method=RequestMethod.POST)
	public @ResponseBody String createJoinForm(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		List<String> listObject = new ArrayList<String>();
		String objectsForJoin = request.getParameter("objectsForJoin");
		String[] arrTablesDisplayNames = CommonUtil.splitString(objectsForJoin, "|");
		for(int i = 0; i < arrTablesDisplayNames.length; i++){
			String[] arrTableDetails = CommonUtil.splitString(arrTablesDisplayNames[i], "^");
			if(arrTableDetails.length > 0){
				listObject.add(arrTableDetails[0]);
			}
		}
		request.setAttribute("LOGGEDUSER", authentication.getPrincipal().toString());
		commonService.auditLog(authentication.getPrincipal().toString(), request, "REPORTS", "OPEN", "Module Accessed");
		return reportWizardService.formJoinField(listObject);
	}
	
	@RequestMapping(value="/getObjectColumns", method=RequestMethod.POST)
	public @ResponseBody String getObjectColumns(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String objectName = request.getParameter("objectName");
		request.setAttribute("LOGGEDUSER", authentication.getPrincipal().toString());
		commonService.auditLog(authentication.getPrincipal().toString(), request, "REPORTS", "OPEN", "Module Accessed");
		return reportWizardService.getObjectColumns(objectName);
	}
	
	@RequestMapping(value="/buildJoin", method=RequestMethod.POST)
	public @ResponseBody String buildJoin(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String returnString = "";
		String value = request.getParameter("value");
		String[] arrRowData = CommonUtil.splitString(value, "|");
		for(int rowIndex = 0; rowIndex < arrRowData.length; rowIndex++){
			String[] arrColData = CommonUtil.splitString(arrRowData[rowIndex], "^");
			if(arrColData.length == 9){
				if(rowIndex == 0){
					returnString = returnString+arrColData[0]+" "+arrColData[1]+" ";
				}else{
					returnString = returnString+" "+arrColData[1]+" ";
				}
				if(!arrColData[1].equalsIgnoreCase("AND") && !arrColData[1].equalsIgnoreCase("OR")){
					returnString = returnString+arrColData[2]+" ON ";
				}
				returnString = returnString+" "+arrColData[3]+" "+arrColData[4]+" ";
				
				if(arrColData[7].trim().length() > 0){					
					String[] strArr = CommonUtil.splitString(arrColData[3], ".");
					String objectName = strArr[0];
					String colName = strArr[1];					
					String dataType = reportWizardService.getColumnsDatatype(objectName, colName);
					
					if(dataType.contains("DATE") || dataType.contains("TIMESTAMP")){
						returnString = returnString+" TO_TIMESTAMP('"+arrColData[7]+"','DD/MM/YYYY') ";
					}else if(dataType.contains("NUMBER")){
						returnString = returnString + arrColData[7];
					}else
						returnString = returnString + " '"+arrColData[7]+"'";
				}else{
					if(arrColData[6].trim().length() > 0){
						returnString = returnString+" (( "+arrColData[6]+ " * "+arrColData[5]+")/100 )";
					}else{
						returnString = returnString+arrColData[5];
					}
				}
			}
		}
		request.setAttribute("LOGGEDUSER", authentication.getPrincipal().toString());
		commonService.auditLog(authentication.getPrincipal().toString(), request, "REPORTS", "OPEN", "Module Accessed");
		return returnString;
	}
	
	@RequestMapping(value="/createSetConditionForm", method=RequestMethod.POST)
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
		request.setAttribute("LOGGEDUSER", authentication.getPrincipal().toString());
		commonService.auditLog(authentication.getPrincipal().toString(), request, "REPORTS", "OPEN", "Module Accessed");
		return reportWizardService.createSetConditionForm(listObject, noOfParams);
	}
	
	@RequestMapping(value="/buildCondition", method=RequestMethod.POST)
	public @ResponseBody String buildCondition(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String returnString = "";
		String value = request.getParameter("value");
		String[] arrRowData = CommonUtil.splitString(value, "|");
		for(int rowIndex = 0; rowIndex < arrRowData.length; rowIndex++){
			String[] arrColData = CommonUtil.splitString(arrRowData[rowIndex], "^");
			if(arrColData.length == 12){
				String[] strArr = CommonUtil.splitString(arrColData[3], ".");
				String dataType = "";
				if(strArr.length == 2){
					String objectName = strArr[0];
					String colName = strArr[1];					
					dataType = reportWizardService.getColumnsDatatype(objectName, colName);
				}
				
				
				returnString = returnString +" "+ arrColData[0] +" "+ arrColData[1] +" "+ arrColData[3] +" "+ arrColData[4]+" ";
				
				if(arrColData[6].trim().length() > 0){
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
				}
				
				returnString = returnString +" "+ arrColData[10]+" ";
			}
		}
		request.setAttribute("LOGGEDUSER", authentication.getPrincipal().toString());
		commonService.auditLog(authentication.getPrincipal().toString(), request, "REPORTS", "OPEN", "Module Accessed");
		return returnString;
	}
	
	@RequestMapping(value="/builtReportColumnForm", method=RequestMethod.POST)
	public @ResponseBody String builtReportColumnForm(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String reportColumns = request.getParameter("reportColumns");
		String objectsForReport = request.getParameter("objects");
		List<String> listObject = new ArrayList<String>();
		String[] arrTablesDisplayNames = CommonUtil.splitString(objectsForReport, "|");
		for(int i = 0; i < arrTablesDisplayNames.length; i++){
			String[] arrTableDetails = CommonUtil.splitString(arrTablesDisplayNames[i], "^");
			if(arrTableDetails.length > 0){
				listObject.add(arrTableDetails[0]);
			}
		}
		List<Map<String, String>> selectedColumnList = new Vector<Map<String, String>>();
		String[] arrColumns = CommonUtil.splitString(reportColumns, ",");
		for(String column : arrColumns){
			String[] arrColumn = CommonUtil.splitString(column, ".");
			if(arrColumn.length == 2){
				Map<String, String> objectMap = new HashMap<String, String>();
				objectMap.put("OBJECT", arrColumn[0]);
				objectMap.put("FIELD", arrColumn[1]);
				selectedColumnList.add(objectMap);
			}
		}
		request.setAttribute("LOGGEDUSER", authentication.getPrincipal().toString());
		commonService.auditLog(authentication.getPrincipal().toString(), request, "REPORTS", "OPEN", "Module Accessed");
		return reportWizardService.createReportColumnForm(listObject, selectedColumnList);
	}
	
	@RequestMapping(value="/buildReportColumns", method=RequestMethod.POST)
	public @ResponseBody String buildReportColumns(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String returnString = "";
		String value = request.getParameter("value");
		String[] arrRowData = CommonUtil.splitString(value, "|");
		for(int rowIndex = 0; rowIndex < arrRowData.length; rowIndex++){
			String[] arrColData = CommonUtil.splitString(arrRowData[rowIndex], "^");
			if(arrColData.length == 5){
				if(!arrColData[0].equals("NONE")){
					returnString = returnString + arrColData[0] + "(" + arrColData[2] +")";
				}else{
					returnString = returnString + arrColData[2]+"";
				}
				if(arrColData[3].trim().length() > 0){
					returnString = returnString + " AS \"" + arrColData[3].trim()+"\"";
				}
			}
			if(rowIndex < arrRowData.length-2)
				returnString = returnString + ", ";
		}
		request.setAttribute("LOGGEDUSER", authentication.getPrincipal().toString());
		commonService.auditLog(authentication.getPrincipal().toString(), request, "REPORTS", "OPEN", "Module Accessed");
		return returnString;
	}
	
	@RequestMapping(value="/createSetAggregateConditionForm", method=RequestMethod.POST)
	public @ResponseBody String createSetAggregateConditionForm(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String objectsForAggregateConditions = request.getParameter("objectsForAggregateConditions");
		String noOfParams = request.getParameter("noOfParams");
		List<String> listObject = new ArrayList<String>();
		String[] arrTablesDisplayNames = CommonUtil.splitString(objectsForAggregateConditions, "|");
		for(int i = 0; i < arrTablesDisplayNames.length; i++){
			String[] arrTableDetails = CommonUtil.splitString(arrTablesDisplayNames[i], "^");
			if(arrTableDetails.length > 0){
				listObject.add(arrTableDetails[0]);
			}
		}
		request.setAttribute("LOGGEDUSER", authentication.getPrincipal().toString());
		commonService.auditLog(authentication.getPrincipal().toString(), request, "REPORTS", "OPEN", "Module Accessed");
		return reportWizardService.createSetAggregateConditionForm(listObject, noOfParams);
	}
	
	@RequestMapping(value="/buildAggregateCondition", method=RequestMethod.POST)
	public @ResponseBody String buildAggregateCondition(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String GroupString = " GROUP BY ";
		String HavingString = "";
		String group = request.getParameter("group");
		String having = request.getParameter("having");
		
		String[] arrGroupRowData = CommonUtil.splitString(group, "|");
		for(int rowGroupIndex = 0; rowGroupIndex < arrGroupRowData.length; rowGroupIndex++){
			String[] arrGroupColData = CommonUtil.splitString(arrGroupRowData[rowGroupIndex], "^");
			if(arrGroupColData.length == 3){
				if(rowGroupIndex == arrGroupRowData.length-1)
					GroupString = GroupString + " "+arrGroupColData[1]+", ";
				else
					GroupString = GroupString + " "+arrGroupColData[1]+" ";
			}
		}
		
		String[] arrHavingRowData = CommonUtil.splitString(having, "|");
		for(int rowHavingIndex = 0; rowHavingIndex < arrHavingRowData.length; rowHavingIndex++){
			String[] arrGroupColData = CommonUtil.splitString(arrHavingRowData[rowHavingIndex], "^");			
			if(arrGroupColData.length == 9){
				if(rowHavingIndex == 0){
					HavingString = HavingString + " HAVING ";
				}else{
					HavingString = HavingString + arrGroupColData[0]+" ";
				}				
				
				if(arrGroupColData[1].equalsIgnoreCase("NONE")){
					HavingString = HavingString + arrGroupColData[3]+" ";
				}else{
					HavingString = HavingString + arrGroupColData[1] +" ("+ arrGroupColData[3] +") ";
				}
				
				HavingString = HavingString + arrGroupColData[4] +" ";
				
				if(arrGroupColData[6].trim().length() > 0){
					if(arrGroupColData[5].equalsIgnoreCase("DATE")){
						HavingString = HavingString+" TO_TIMESTAMP('"+arrGroupColData[6]+"','DD/MM/YYYY') ";
					}else if(arrGroupColData[5].equalsIgnoreCase("NUMBER")){
						HavingString = HavingString + arrGroupColData[6]+" ";
					}else
						HavingString = HavingString + " '"+arrGroupColData[6]+"' ";
				}else if(arrGroupColData[7].trim().length() > 0){
					HavingString = HavingString + " "+arrGroupColData[7]+" ";
				}
				
			}
		}
		request.setAttribute("LOGGEDUSER", authentication.getPrincipal().toString());
		commonService.auditLog(authentication.getPrincipal().toString(), request, "REPORTS", "OPEN", "Module Accessed");
		return GroupString+HavingString;
	}
	
	@RequestMapping(value="/getColumnsDatatype", method=RequestMethod.POST)
	public @ResponseBody String getColumnsDatatype(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String value = request.getParameter("value");
		String[] strArr = CommonUtil.splitString(value, ".");
		request.setAttribute("LOGGEDUSER", authentication.getPrincipal().toString());
		if(strArr.length == 2){
			String object = strArr[0];
			String column = strArr[1];
			return reportWizardService.getColumnsDatatype(object, column);
		}else
			commonService.auditLog(authentication.getPrincipal().toString(), request, "REPORTS", "OPEN", "Module Accessed");
			return "";
	}
	
	@RequestMapping(value="/saveReport", method=RequestMethod.POST)
	public @ResponseBody String saveReport(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String returnText = "";
		String LOGGEDUSER = authentication.getPrincipal().toString();
		String objects = request.getParameter("objects");
		String joinDetails = request.getParameter("joinDetails");
		String reportColumns = request.getParameter("reportColumns");
		String conditionDetails = request.getParameter("conditionDetails");
		String aggregateConditionDetails = request.getParameter("aggregateConditionDetails");
		String reportId = request.getParameter("reportId");
		String reportCode = request.getParameter("reportCode");
		String reportName = request.getParameter("reportName");
		String reportHeader = request.getParameter("reportHeader");
		String reportFooter = request.getParameter("reportFooter");
		String isEnable = request.getParameter("isEnable");
		String joinHtml = request.getParameter("joinHtml");
		String reportHtml = request.getParameter("reportHtml");
		String ConHtml = request.getParameter("ConHtml");
		String aggrConHtml = request.getParameter("aggrConHtml");
		String objectConDetails = request.getParameter("objectConDetails");
		String noOfParams = request.getParameter("noOfParams");
		
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
		
		returnText = reportWizardService.saveReport(tableNames, joinDetails, reportColumns, conditionDetails, 
				aggregateConditionDetails, reportId, reportCode, reportName, reportHeader, reportFooter, isEnable, LOGGEDUSER, 
				objectConDetails, joinHtml, reportHtml, ConHtml, aggrConHtml, noOfParams);
		
		request.setAttribute("LOGGEDUSER", authentication.getPrincipal().toString());
		commonService.auditLog(authentication.getPrincipal().toString(), request, "REPORTS", "INSERT", "Data Saved");
		return returnText;
	}
	
	@RequestMapping(value="/updateReport", method=RequestMethod.GET)
	public String updateReport(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String reportID = request.getParameter("reportID");
		request.setAttribute("BUSINESSOBJECTS", reportWizardService.getAllBusinessObject());
		request.setAttribute("LOGGEDUSER", authentication.getPrincipal().toString());
		if(reportID != null && reportID.trim().length() > 0){
			request.setAttribute("reportID", reportID);
			return "ReportWizard/updateReport";
		}else{
			message = "Report ID not found. Create a new report.";
			commonService.auditLog(authentication.getPrincipal().toString(), request, "REPORTS", "UPDATE", "Data Updated");
			return "redirect:reportWizard";
		}
	}
	
	String message;
	
	@RequestMapping(value="/objectToSelect", method=RequestMethod.POST)
	public @ResponseBody String objectToSelect(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String reportID = request.getParameter("reportID");
		String objectName = request.getParameter("objectName");
		String selectObjects = reportWizardService.getObjectSelected(reportID);
		request.setAttribute("LOGGEDUSER", authentication.getPrincipal().toString());
		commonService.auditLog(authentication.getPrincipal().toString(), request, "REPORTS", "OPEN", "Module Accessed");
		if(selectObjects.contains(objectName)){
			return "y";
		}else{
			return "n";
		}
		
	}
	
	@RequestMapping(value="/getReportDetails", method=RequestMethod.POST)
	public @ResponseBody String getReportDetails(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String value = "";
		String reportID = request.getParameter("reportID");
		String section = request.getParameter("section");
		request.setAttribute("LOGGEDUSER", authentication.getPrincipal().toString());
		value = reportWizardService.getReportDetails(reportID, section);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "REPORTS", "OPEN", "Module Accessed");
		return value;
	}
	
	@RequestMapping(value = "/getBuiltReportData")
    public ModelAndView getBuiltReportData(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception
    {
	ModelAndView modelAndView = new ModelAndView("/ReportBuilder/jsp/BottomFrame");
	String username = authentication.getPrincipal().toString();
	
	String builtCondition = request.getParameter("builtCondition");
	String reportId = request.getParameter("l_strReportID");
	String noOfParameters = request.getParameter("l_strNoOfParameters");
	int intNoOfParameters = 0;
	
	try{
		intNoOfParameters = Integer.parseInt(noOfParameters);
	}catch(Exception e){}
	
	HashMap<String,String> hashMap = new HashMap();
	//System.out.println("builtCondition before:  "+builtCondition);
	for(int i=1; i<=intNoOfParameters;i++){
		// builtCondition = builtCondition.replaceAll("@param"+i, request.getParameter("@param"+i));
		hashMap.put(("@param"+i),(String)request.getParameter("@param"+i));
	}
	System.out.println("builtCondition in controller after:  "+builtCondition);
	
	Map<String, Object> model = new HashMap<String, Object>();
    try{
    //System.out.println("Before DB call in getReportPDFFiles  ");	
	HashMap<String,Object> l_HMReportData = reportWizardService.builReportData(username, builtCondition, reportId, noOfParameters, hashMap);
	model.put("reportData", l_HMReportData);
	model.put("builtCondition", builtCondition);
	request.setAttribute("builtCondition", builtCondition);
	request.setAttribute("reportData", l_HMReportData);
	request.setAttribute("l_strReportID", reportId);
	request.setAttribute("l_strNoOfParameters", noOfParameters);
	request.setAttribute("LOGGEDUSER", authentication.getPrincipal().toString());
    }
	catch(Exception e)
	{
		System.out.println("The exception in getTestReportData in Controller is: "+e.toString());
		e.printStackTrace();
	}
    commonService.auditLog(authentication.getPrincipal().toString(), request, "REPORTS", "OPEN", "Module Accessed");
    return modelAndView;
 }

}

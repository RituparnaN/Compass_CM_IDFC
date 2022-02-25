package com.quantumdataengines.app.compass.controller.reports;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileReader;
import java.io.InputStream;
import java.io.StringWriter;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.IOUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.quantumdataengines.app.compass.otherservice.OtherCommonService;
import com.quantumdataengines.app.compass.service.CommonService;
import com.quantumdataengines.app.compass.service.reports.ReportsGenericService;

@Controller
@RequestMapping(value="/common")
public class ReportsGenericController {
	private Logger log = LoggerFactory.getLogger(ReportsGenericController.class);
	
	@Autowired
	private OtherCommonService otherCommonService;
	@Autowired
	private ReportsGenericService reportsGenericService;
	@Autowired
	private CommonService commonService;
	@Value("${compass.aml.config.recordsCountPerSheetInExcel}")
	private String recordsCountPerSheetInExcel;

	@RequestMapping(value = "/getListOfReports")
	public ModelAndView getListOfReports(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication)
    throws Exception
    {
	ModelAndView modelAndView = new ModelAndView("/Reports/index");
	String viewType = request.getParameter("viewType") == null ? "ALL":(String)request.getParameter("viewType");
	String userCode = authentication.getPrincipal().toString();
	String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
	Collection collection = reportsGenericService.getListOfReports(request.getParameter("group"), userCode, userRole);
	request.setAttribute("UNQID", otherCommonService.getElementId());
	request.setAttribute("RESULT", collection);
	request.setAttribute("group", request.getParameter("group"));
	request.setAttribute("viewType", viewType);
	commonService.auditLog(authentication.getPrincipal().toString(), request, "REPORTS", "OPEN", "Module Accessed");
	return modelAndView;
    }

	@RequestMapping(value = "/getListOfSpecificReports")
	public ModelAndView getListOfSpecificReports(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication)
    throws Exception
    {
	ModelAndView modelAndView = new ModelAndView("/Reports/index");
	String viewType = request.getParameter("viewType") == null ? "ALL":(String)request.getParameter("viewType");
	String userCode = authentication.getPrincipal().toString();
	String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
	Collection collection = reportsGenericService.getListOfReports(request.getParameter("group"), userCode, userRole);
	request.setAttribute("UNQID", otherCommonService.getElementId());
	request.setAttribute("RESULT", collection);
	request.setAttribute("group", request.getParameter("group"));
	request.setAttribute("viewType", viewType);
	commonService.auditLog(authentication.getPrincipal().toString(), request, "REPORTS", "OPEN", "Module Accessed");
	return modelAndView;
    }
	
	@RequestMapping(value = "/getListOfReportBenchMarks")
	public ModelAndView getListOfReportBenchMarks(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication)
    throws Exception
    {
	ModelAndView modelAndView = new ModelAndView("/Reports/ReportBenchMarksList");
	String userCode = authentication.getPrincipal().toString();
	String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
	
	String group = request.getParameter("group");
	String reportId = request.getParameter("reportId");
	String viewType = request.getParameter("viewType") == null ? "ALL":(String)request.getParameter("viewType");
	Map<String, Object> benchMarkList = reportsGenericService.getListOfReportBenchMarks(group, reportId, userCode, userRole, viewType);
	String reportName = reportsGenericService.getReportName(group, reportId, userCode, userRole);
	
	request.setAttribute("resultData", benchMarkList);
	request.setAttribute("reportId", reportId);
	request.setAttribute("group", group);
	request.setAttribute("reportName", reportName);
	request.setAttribute("UNQID", request.getParameter("id"));
	request.setAttribute("viewType", viewType);
	commonService.auditLog(authentication.getPrincipal().toString(), request, "REPORTS", "OPEN", "Module Accessed");
    return modelAndView;
    }
	
	@RequestMapping(value = "/getReportBenchMarkDetails")
	public ModelAndView getReportBenchMarkDetails(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication)
    throws Exception
    {
	ModelAndView modelAndView = new ModelAndView("/Reports/ReportBenchMarkDetails");
	String userCode = authentication.getPrincipal().toString();
	String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
	String group = request.getParameter("group");
	String reportId = request.getParameter("reportId");
	String reportSerialNo = request.getParameter("reportSerialNo");
	
	String viewType = request.getParameter("viewType") == null ? "ALL":(String)request.getParameter("viewType");
	List<Map<String, Object>> searchFrameList = reportsGenericService.getReportBenchMarkDetails(group, reportId, reportSerialNo, userCode, userRole, viewType);
	String reportName = reportsGenericService.getReportName(group, reportId, userCode, userRole);
	
	request.setAttribute("MASTERSEARCHFRAME", searchFrameList);
	request.setAttribute("group", group);
	request.setAttribute("reportId", reportId);
    request.setAttribute("reportName", reportName);
	request.setAttribute("reportSerialNo", request.getParameter("reportSerialNo"));
    request.setAttribute("UNQID", request.getParameter("id"));
	request.setAttribute("viewType", viewType);
	commonService.auditLog(authentication.getPrincipal().toString(), request, "REPORTS", "OPEN", "Module Accessed");
    return modelAndView;
    }
	
	@RequestMapping(value = "/saveReportBenchMarkParameters", method=RequestMethod.POST)
	public @ResponseBody String saveReportBenchMarkParameters(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication)
    throws Exception
    {
		Map<String, String> paramMap = new LinkedHashMap<String, String>();
		Map<String, String> paramTempMap = new LinkedHashMap<String, String>();
		Map<String, String> fullParamTempMap = new LinkedHashMap<String, String>();
		
		String moduleType = request.getParameter("moduleType");
		
		String group = request.getParameter("group");
		String reportId = request.getParameter("reportId");
	    String reportSerialNo = request.getParameter("reportSerialNo");
	    String viewType = request.getParameter("viewType") == null ? "ALL":(String)request.getParameter("viewType");
	    String configurationComments = request.getParameter("configurationComments");
	    List<String> inputParams = new ArrayList<String>();
	    //List<String> allParams = new ArrayList<String>();
	    
		Map<String, String[]> formData =  request.getParameterMap();
		Iterator<String> itr = formData.keySet().iterator();
		while (itr.hasNext()) {
			String tempParamName = itr.next();
			String tempParamValue = formData.get(tempParamName)[0];
			if(!"moduleType".equals(tempParamName) && !"bottomPageUrl".equals(tempParamName)
			   && !"reportId".equals(tempParamName) && !"reportSerialNo".equals(tempParamName)
			   && !"viewType".equals(tempParamName) && !"id".equals(tempParamName)
			   && !"formData".equals(tempParamName) && !"group".equals(tempParamName)
			   && !"configurationComments".equals(tempParamName)){
				fullParamTempMap.put(tempParamName, tempParamValue);
			}
			if(!"moduleType".equals(tempParamName) && !"bottomPageUrl".equals(tempParamName)
			   && !"reportId".equals(tempParamName) && !"reportSerialNo".equals(tempParamName)
			   && !"viewType".equals(tempParamName) && !"id".equals(tempParamName)
			   && !"formData".equals(tempParamName)&& !"group".equals(tempParamName)
			   && !"1_FromDate".equals(tempParamName)&& !"2_ToDate".equals(tempParamName)
			   && !"configurationComments".equals(tempParamName)){
				paramTempMap.put(tempParamName, tempParamValue);
			}
		}
		
		List<String> paramKeyList = new Vector<String>(paramTempMap.keySet());
		List<String> fullParamKeyList = new Vector<String>(fullParamTempMap.keySet());
		
		Collections.sort(paramKeyList, new Comparator<String>(){
			@Override
			public int compare(String str1, String str2) {
				return  (Integer.parseInt(str1.substring(0, str1.indexOf("_")))) - Integer.parseInt(str2.substring(0, str2.indexOf("_")));
			}
		});
		
		for(String paramName : fullParamKeyList) {
			String paramValue = formData.get(paramName)[0];
			paramMap.put(paramName, paramValue);
		}
				
		for(String paramName : paramKeyList) {
			String paramValue = formData.get(paramName)[0];
			//paramMap.put(paramName, paramValue);
			inputParams.add(paramName.substring(paramName.indexOf("_")+1)+":"+paramValue.toString());
		}
		
		String inputParameter = "";
		
		for(String s : inputParams){
			inputParameter += s+"!^! "; 
		}
			
		
		
		ModelAndView modelAndView = new ModelAndView("/Reports/ReportBenchMarksList");
		
		String userCode = authentication.getPrincipal().toString();
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String ipAdress = request.getRemoteAddr();
		
		String result = "";
		
		/*		
  		Boolean isSaved = reportsGenericService.saveReportBenchMarkParameters(reportId, reportSerialNo, paramMap, userCode, 
							userRole, ipAdress, inputParameter);
		*/
		result = reportsGenericService.saveReportBenchMarkParameters(reportId, reportSerialNo, paramMap, userCode, 
				userRole, ipAdress, inputParameter, configurationComments);
		/*
		if(isSaved)
			result = "Saved successfully.";
		else if(!isSaved)
			result = "Error while saving.";
		*/	
	    //Map<String, Object> benchMarkList = reportsGenericService.getListOfReportBenchMarks(request.getParameter("reportId"), userRole, viewType);
	    
		request.setAttribute("moduleType", moduleType);
		//request.setAttribute("resultData", benchMarkList);
		request.setAttribute("reportSerialNo", reportSerialNo);
		request.setAttribute("group", group);
		request.setAttribute("reportId", request.getParameter("reportId"));
		request.setAttribute("UNQID", request.getParameter("id"));
		request.setAttribute("viewType", viewType);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "REPORTS", "INSERT", "Data Saved");
	    return result;
    }
	
	@RequestMapping(value = "/deleteReportBenchMarkParameters")
	public ModelAndView deleteReportBenchMarkParameters(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication)
    throws Exception
    {
	ModelAndView modelAndView = new ModelAndView("/Reports/ReportBenchMarksList");

	String userCode = authentication.getPrincipal().toString();
	String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
	String ipAdress = request.getRemoteAddr();
	
	String reportSerialNo = request.getParameter("reportSerialNo");
	String group = request.getParameter("group");
	String reportId = request.getParameter("reportId");
	String viewType = request.getParameter("viewType") == null ? "ALL":(String)request.getParameter("viewType");
	String requestType = "DELETE";

	reportsGenericService.deleteReportBenchMarkParameters(reportId, reportSerialNo, requestType, userCode, userRole, ipAdress);
    
    //Map<String, Object> benchMarkList = reportsGenericService.getListOfReportBenchMarks(request.getParameter("reportId"), userRole, viewType);

	//request.setAttribute("resultData", benchMarkList);
	request.setAttribute("reportSerialNo", reportSerialNo);
	request.setAttribute("group", group);
	request.setAttribute("reportId", request.getParameter("reportId"));
	request.setAttribute("UNQID", request.getParameter("id"));
	request.setAttribute("viewType", viewType);
	commonService.auditLog(authentication.getPrincipal().toString(), request, "REPORTS", "DELETE", "Data Deleted");
    return modelAndView;
    }
	
	@RequestMapping(value = "/generateReportWithBenchMarks")
	public ModelAndView generateReportWithBenchMarks(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		//ModelAndView modelAndView = new ModelAndView("/Reports/ReportResult");
		ModelAndView modelAndView = null;
		
		Map<String, String> paramMap = new LinkedHashMap<String, String>();
		Map<String, String> paramTempMap = new LinkedHashMap<String, String>();
		String resultMessage = "No. Of Reports Generated : ";
		String userCode = authentication.getPrincipal().toString();
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String ipAdress = request.getRemoteAddr();
		String logReportGeneration = "Successful";
		
		String group = request.getParameter("group");
		String reportId = request.getParameter("reportId");
		String reportSerialNo = request.getParameter("reportSerialNo");
		String viewType = request.getParameter("viewType") == null ? "ALL":(String)request.getParameter("viewType");
		String generationType = request.getParameter("generationType") == null ? "exportData":(String)request.getParameter("generationType");
		ArrayList<String> inputParameter = new ArrayList<String>();
	    
		Map<String, String[]> formData =  request.getParameterMap();
		Iterator<String> itr = formData.keySet().iterator();
		while (itr.hasNext()) {
			String tempParamName = itr.next();
			String tempParamValue = formData.get(tempParamName)[0];
			if(!"moduleType".equals(tempParamName) && !"bottomPageUrl".equals(tempParamName)
			   && !"reportId".equals(tempParamName) && !"reportSerialNo".equals(tempParamName)
			   && !"viewType".equals(tempParamName) && !"id".equals(tempParamName)
			   && !"formData".equals(tempParamName) && !"generationType".equals(tempParamName) 
			   && !"reportType".equals(tempParamName)&& !"group".equals(tempParamName)){
				paramTempMap.put(tempParamName, tempParamValue);
			}
		}
		
		List<String> paramKeyList = new Vector<String>(paramTempMap.keySet());
		
		Collections.sort(paramKeyList, new Comparator<String>(){
			@Override
			public int compare(String str1, String str2) {
				return  (Integer.parseInt(str1.substring(0, str1.indexOf("_")))) - Integer.parseInt(str2.substring(0, str2.indexOf("_")));
			}
		});
		
		for(String paramName : paramKeyList) {
			String paramValue = formData.get(paramName)[0];
			paramMap.put(paramName, paramValue);
			inputParameter.add(paramName+": "+"\t"+paramValue+"\t"+"\t"+"\t"+"\t");
		}

		logReportGeneration = reportsGenericService.logReportGenerationRequest(userCode, userRole, ipAdress, generationType, reportId, inputParameter.toString());
    	System.out.println("logReportGenerationRequest:  "+logReportGeneration);
    	
		int resultCount = 0;
		Map<String, Object> model = new HashMap<String, Object>();
	    try
	    {
	    	long startGetData = new Date().getTime();
	    	Map<String,Object> l_HMReportData = (HashMap<String,Object>)reportsGenericService.generateReportWithBenchMarks(group, reportId, reportSerialNo, paramMap, generationType, userCode, userRole, ipAdress);
		
	    	long endGetData = new Date().getTime();
	    	long diff = (endGetData - startGetData)/1000;
			if(generationType.equalsIgnoreCase("exportPDF")){
				startGetData = new Date().getTime();
				response.setContentType("application/pdf");
				response.setHeader("Content-Disposition", "attachment;fileName="+l_HMReportData.get("reportName")+".pdf");
				model.put(PdfView.PDF_LIST_KEY, l_HMReportData);
				endGetData = new Date().getTime();
				diff = (endGetData - startGetData)/1000;
		   	    System.out.println(diff+" sec taken to generate and download PDF file data");
			}else if(generationType.equalsIgnoreCase("exportExcel")){
				/*
				response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
				response.setHeader("Content-Disposition", "attachment;fileName="+l_HMReportData.get("reportName")+".xlsx");
				model.put(ExcelView.EXCEL_LIST_KEY, l_HMReportData);
				*/
				startGetData = new Date().getTime();
				// ExcelViewNew excelViewNew = new ExcelViewNew();
		        /*
				response.setContentType("APPLICATION/OCTET-STREAM");
				String disHeader = "Attachment;Filename=\""+l_HMReportData.get("reportName")+".xlsx"+"\"";
		        response.setHeader("Content-disposition", disHeader);
		        */
				/*
		        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
				response.setHeader("Content-Disposition", "attachment;fileName="+l_HMReportData.get("reportName")+".xlsx");
				*/
				//ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
				// byteArrayOutputStream = excelViewNew.buildExcelDocument(l_HMReportData, inputParameter, Integer.parseInt(recordsCountPerSheetInExcel), request, response);
				// String filePath = excelViewNew.buildExcelDocument(l_HMReportData, inputParameter, Integer.parseInt(recordsCountPerSheetInExcel), request, response);
		        /*
				byte[] bytes = IOUtils.toByteArray(fileInputStream);
		        fileInputStream.close();
		        new File(fileInputStream);
		        
				response.setContentType("APPLICATION/OCTET-STREAM");
		        String disHeader = "Attachment;Filename=\""+l_HMReportData.get("reportName")+".xlsx"+"\"";
		        response.setHeader("Content-disposition", disHeader);
		        byteArrayOutputStream.write(bytes);
		        response.setContentLength(bytes.length);
		        byteArrayOutputStream.writeTo(response.getOutputStream());
		        byteArrayOutputStream.flush();
		        byteArrayOutputStream.close();
		        */
				/*
				response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
		        String disHeader = "Attachment;Filename=\""+l_HMReportData.get("reportName")+".xlsx"+"\"";
		        response.setHeader("Content-disposition", disHeader);
		        */
		        /*
		        byteArrayOutputStream.writeTo(response.getOutputStream());
		        byteArrayOutputStream.flush();
		        byteArrayOutputStream.close();
		        */
/*				
				response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
		        String disHeader = "Attachment;Filename=\""+l_HMReportData.get("reportName")+".xlsx"+"\"";
		        response.setHeader("Content-disposition", disHeader);
		        
		        FileInputStream inputStream = new FileInputStream(new File(filePath));
				ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
		        byteArrayOutputStream.write(IOUtils.toByteArray(inputStream));
		        inputStream.close();

		        File inputFilePath = new File(filePath);
				System.out.println("Before : "+inputFilePath.exists());

		        if(inputFilePath.exists())
		        inputFilePath.delete();
		        
		        System.out.println("After : "+inputFilePath.exists());
		        
		        byteArrayOutputStream.writeTo(response.getOutputStream());
		        byteArrayOutputStream.flush();
		        byteArrayOutputStream.close();
		        */
		        
		        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
				response.setHeader("Content-Disposition", "attachment;fileName="+l_HMReportData.get("reportName")+".xlsx");
				model.put(ExcelView.EXCEL_LIST_KEY, l_HMReportData);

		        /*
		        String fileContent = "";
		        BufferedWriter bufferedWriter = null;
				StringWriter stringWriter = null;
				
				BufferedReader bufferedReader = null;
				File inputFilePath = new File(filePath);
					
				bufferedReader = new BufferedReader(new FileReader(inputFilePath));
				String currentLine;
				while ((currentLine = bufferedReader.readLine()) != null) {
					fileContent = fileContent + currentLine + System.getProperty("line.separator");
				}
				bufferedReader.close();
				
				stringWriter = new StringWriter();
				bufferedWriter = new BufferedWriter(stringWriter);
				bufferedWriter.write(fileContent);
				
				bufferedWriter.flush();
		        String fileData = stringWriter.toString();
		        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
		        String disHeader = "Attachment;Filename=\""+l_HMReportData.get("reportName")+".xlsx"+"\"";
		        response.setHeader("Content-disposition", disHeader);
		        ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
		        byteArrayOutputStream.write(fileData.getBytes());
		        response.setContentLength(fileData.length());
		        byteArrayOutputStream.writeTo(response.getOutputStream());
		        byteArrayOutputStream.flush();
		        byteArrayOutputStream.close();
		        bufferedWriter.close();

		        System.out.println("Before : "+inputFilePath.exists());

		        if(inputFilePath.exists())
		        inputFilePath.delete();
		        
		        System.out.println("After : "+inputFilePath.exists());
		        */
		        /*
		        OutputStream out = response.getOutputStream();
				IOUtils.copy(fileInputStream, out);
				out.flush();
			    out.close();
			    fileInputStream.close();
			    */
				endGetData = new Date().getTime();
				diff = (endGetData - startGetData)/1000;
		   	    System.out.println(diff+" sec taken to generate and download excel file data");
			}else if(generationType.equalsIgnoreCase("exportCSV")){
				String COMMA_DELIMITER = "\",\"";
				String NEW_LINE_SEPARATOR = "\n";
				String result = "";
				String[] l_Headers = (String[])l_HMReportData.get("Header");
			    ArrayList<HashMap<String, String>> l_al = (ArrayList<HashMap<String, String>>)l_HMReportData.get("ReportData");
			    HashMap<String, String> hashMap = new HashMap<String, String>();
			    String fileName = l_HMReportData.get("reportName")+".csv";
			    
				BufferedWriter bufferedWriter = null;
				StringWriter stringWriter = null;
				try{
					boolean first = true;
					boolean last = false;
					stringWriter = new StringWriter();
					bufferedWriter = new BufferedWriter(stringWriter);
					
					for(int i=0; i < l_Headers.length; i++)
				    {
						if(i == l_Headers.length - 1) last = true; 
						result = getCVSformatData(l_Headers[i]);
						if (first) {
							bufferedWriter.write("\""+result+COMMA_DELIMITER);
			            }
						else if(last){
							bufferedWriter.write(result+"\"");
						}
						else {
							bufferedWriter.write(result+COMMA_DELIMITER);
						}
				        first = false;
				    }
					bufferedWriter.newLine();
					
					for(int i=0; i < l_al.size(); i++)
					{
				        hashMap = (HashMap<String, String>)l_al.get(i);
				        first = true;
				        last = false;
					    for(int j=0; j < l_Headers.length; j++){
					    	if(j == l_Headers.length - 1) last = true; 
					    	result = getCVSformatData(hashMap.get(l_Headers[j]));
					    	if (first) {
								bufferedWriter.write("\""+result+COMMA_DELIMITER);
				            }
							else if(last){
								bufferedWriter.write(result+"\"");
							}
							else {
								bufferedWriter.write(result+COMMA_DELIMITER);
							}
					        first = false;
					    }
					    bufferedWriter.newLine();
					}
					
					bufferedWriter.flush();
			        String fileStringData = stringWriter.toString();
			        
			        response.setContentType("APPLICATION/OCTET-STREAM");
			        String disHeader = "Attachment;Filename=\""+fileName+"\"";
			        
			        response.setHeader("Content-disposition", disHeader);
			        ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
			        byteArrayOutputStream.write(fileStringData.getBytes());
			        //response.setContentLength(fileStringData.length());
			        //response.setContentLength(new Long(fileStringData.length()).intValue() + 9);
			        byteArrayOutputStream.writeTo(response.getOutputStream());
			        byteArrayOutputStream.flush();
			        byteArrayOutputStream.close();
			        bufferedWriter.close();
				}catch(Exception e){
					e.printStackTrace();
				}
			}else if(generationType.equalsIgnoreCase("showReport")){
				request.setAttribute("SEARCHRESULT", reportsGenericService.getReportData(group, reportId, reportSerialNo, paramMap, 
			    		 generationType,  userCode,  userRole, ipAdress));
				/*System.out.println("RESULT = "+reportsGenericService.getReportData(group, reportId, reportSerialNo, paramMap, 
    		 generationType,  userCode,  userRole, ipAdress));*/
			}
	
			model.put("reportId", reportId);
			model.put("startDate", "");
			model.put("endDate", "");
			model.put("inputParameter", inputParameter);
			if((Boolean) l_HMReportData.get("Success")){
				Cookie c = new Cookie("fileDownload","true");
				c.setPath("/");
				c.setSecure(false);
				response.addCookie(c);
		    }
	    }
	    catch(Exception e){
	    	resultMessage = "Error while generating "+generationType+" reports for: "+reportId;
	    	log.error("Error while generating "+generationType+" reports for: "+reportId+". The error is : "+e.toString());
	    	System.out.println("Error while generating "+generationType+" reports for: "+reportId+". The error is : "+e.toString());
	    	e.printStackTrace();
	    }
	    
	    // resultMessage = resultMessage + resultCount;
	    
	    request.setAttribute("Result", resultCount);
	    request.setAttribute("resultMessage", resultMessage);
	    request.setAttribute("group", group);
		request.setAttribute("reportId", request.getParameter("reportId"));
		request.setAttribute("reportSerialNo", reportSerialNo);
		request.setAttribute("UNQID", request.getParameter("id"));
		request.setAttribute("viewType", viewType);
		request.setAttribute("generationType", generationType);
		
		if(generationType.equalsIgnoreCase("exportPDF"))
			modelAndView = new ModelAndView(new PdfView(), model);
		else if(generationType.equalsIgnoreCase("exportExcel"))
			modelAndView = new ModelAndView(new ExcelView(), model);
		else if(generationType.equalsIgnoreCase("showReport"))
			modelAndView = new ModelAndView("Reports/SearchBottomPage");
	    commonService.auditLog(authentication.getPrincipal().toString(), request, "REPORTS", "DOWNLOAD", "File Downloaded");
		return modelAndView;
    }
	
	@RequestMapping(value="/fetchDetailsToResetReportColumns",method=RequestMethod.GET)
	public String fetchDetailsToResetReportColumns(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		String reportId = request.getParameter("reportId");
		String userCode = authentication.getPrincipal().toString();
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
				
		request.setAttribute("DATALIST", reportsGenericService.fetchDetailsToResetReportColumns(reportId, userCode, userRole));
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("reportId", reportId);
		request.setAttribute("userId", userCode);

		commonService.auditLog(authentication.getPrincipal().toString(), request, "REPORTS", "READ", "Module Accessed");
		return "Reports/ResetReportColumns";
	}
	@RequestMapping(value="/resetReportColumns",method=RequestMethod.POST)
	public @ResponseBody String resetReportColumns(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		String reportId = request.getParameter("reportId");
		String userCode = authentication.getPrincipal().toString();
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String fulldata = request.getParameter("fullData");
		//String allCheckbox = request.getParameter("allCheckbox");
		//String allColName = request.getParameter("allColName");
		//String allAliasName = request.getParameter("allAliasName");
		//String allColIndex = request.getParameter("allColIndex");
		
		reportsGenericService.resetReportColumns(reportId, userCode, userRole, fulldata);
		//request.setAttribute("DATALIST", reportsGenericService.fetchDetailsToResetReportColumns(reportId, userId));
		//request.setAttribute("UNQID", otherCommonService.getElementId());
		//request.setAttribute("reportId", reportId);
		//request.setAttribute("userId", userId);

		commonService.auditLog(authentication.getPrincipal().toString(), request, "REPORTS", "UPDATE", "Module Accessed");
		return "Reseted successfully";
	}
	
	@RequestMapping(value = "/generateReportXML", method=RequestMethod.POST)
	public @ResponseBody String generateReportXML(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception {
		String l_strReportType = request.getParameter("reportType");
		String l_strReportMonth = request.getParameter("reportingMonth");
		String l_strReportYear = request.getParameter("reportingYear");
		String l_strBatchType = request.getParameter("BatchType");
		String l_strOriginalBatchID = request.getParameter("OriginalBatchID");
		String l_strReasonOfRevision = request.getParameter("ReasonOfRevision");
		String l_strReportFile = request.getParameter("reportFileName");
		String l_strNoOfLines = request.getParameter("noOfLines");
		String userCode = authentication.getPrincipal().toString();
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String l_strMessage = "";
		//System.out.println(l_strReportType+","+l_strReportMonth+","+ l_strReportYear+","+l_strReportFile+","+l_strBatchType+","+l_strOriginalBatchID+","+l_strReasonOfRevision+","+l_strNoOfLines+","+userId);
		//ModelAndView mv = new ModelAndView("/IndianRegulatoryReport/GenerateRegulatoryReport/GenerateReport");
		ModelAndView mv = new ModelAndView("RegulatoryReports/India/GenerateRegulatoryReport/GenerateReport");
		l_strMessage = reportsGenericService.generateReportXML(l_strReportType, l_strReportMonth, l_strReportYear, l_strReportFile, l_strBatchType, l_strOriginalBatchID, l_strReasonOfRevision, l_strNoOfLines, userCode, userRole);
		mv.addObject("message", l_strMessage);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "REPORTS", "DOWNLOAD", "File Downloaded");
		return l_strMessage;
	}
	
	@RequestMapping(value = "/generateAndDownLoadXML")
	public void generateAndDownLoadXML(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception {
		String l_strReportType = request.getParameter("reportType");
		String l_strReportMonth = request.getParameter("reportingMonth");
		String l_strReportYear = request.getParameter("reportingYear");
		String l_strBatchType = request.getParameter("BatchType");
		String l_strOriginalBatchID = request.getParameter("OriginalBatchID");
		String l_strReasonOfRevision = request.getParameter("ReasonOfRevision");
		String l_strReportFile = request.getParameter("reportFileName");
		String l_strNoOfLines = request.getParameter("noOfLines");
		String userCode = authentication.getPrincipal().toString();
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String l_strMessage = "";
		l_strMessage = reportsGenericService.generateReportXML(l_strReportType, l_strReportMonth, l_strReportYear, l_strReportFile, l_strBatchType, l_strOriginalBatchID, l_strReasonOfRevision, l_strNoOfLines, userCode, userRole);

		SimpleDateFormat simpleDateFormat = new SimpleDateFormat("ddMMyyyyHHmm");
		String dateString = simpleDateFormat.format(new Date());
		
		String tableName = "";
		String fileName = "";
		if(l_strReportType.equals("CTR")){
			tableName = "TB_CTR_FILEGENERATION";
			fileName = "CTR_ARF_BAUCB01878_C0000001_"+dateString+".xml";
		}else if(l_strReportType.equals("NTR")){
			tableName = "TB_NTR_FILEGENERATION";
			fileName = "NTR_ARF_BAUCB01878_C0000001_"+dateString+".xml";
		}else if(l_strReportType.equals("CCR")){
			tableName = "TB_CCR_FILEGENERATION";
			fileName = "CCR_CRF_BAUCB01878_C0000001_"+dateString+".xml";
		}
		List<String> fileData = reportsGenericService.getReportFileData(tableName, userCode, userRole);
		BufferedWriter bufferedWriter = null;
		StringWriter stringWriter = null;
		try{
			stringWriter = new StringWriter();
			bufferedWriter = new BufferedWriter(stringWriter);
			
			for (String lineString : fileData) {
				bufferedWriter.write(lineString);
				bufferedWriter.newLine();
			}
			
			bufferedWriter.flush();
	        String fileStringData = stringWriter.toString();
	        
	        response.setContentType("APPLICATION/OCTET-STREAM");
	        String disHeader = "Attachment;Filename=\""+fileName+"\"";
	        
	        response.setHeader("Content-disposition", disHeader);
	        ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
	        byteArrayOutputStream.write(fileStringData.getBytes());
	        response.setContentLength(fileStringData.length());
	        byteArrayOutputStream.writeTo(response.getOutputStream());
	        byteArrayOutputStream.flush();
	        byteArrayOutputStream.close();
	        bufferedWriter.close();
		}catch(Exception e){
			e.printStackTrace();
		}
		commonService.auditLog(authentication.getPrincipal().toString(), request, "REPORTS", "DOWNLOAD", "File Downloaded");
	}
	@RequestMapping(value = "/generateRegReportData", method=RequestMethod.POST)
	public @ResponseBody String generateRegReportData(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception {
		String l_strReportType = request.getParameter("reportType");
		String l_strReportMonth = request.getParameter("reportingMonth");
		String l_strReportYear = request.getParameter("reportingYear");
		String userCode = authentication.getPrincipal().toString();
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String l_strMessage = "";
		//ModelAndView mv = new ModelAndView("/IndianRegulatoryReport/GenerateRegulatoryReport/GenerateReport");
		ModelAndView mv = new ModelAndView("RegulatoryReports/India/GenerateRegulatoryReport/GenerateReport");
		l_strMessage = reportsGenericService.generateRegReportData(l_strReportType, l_strReportMonth, l_strReportYear, userCode, userRole);
		mv.addObject("message", l_strMessage);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "REPORTS", "DOWNLOAD", "File Downloaded");
		return l_strMessage;
	}
	
	@RequestMapping(value = "/chooseReportFile")
	public ModelAndView chooseReportFile(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception {
		//ModelAndView mv = new ModelAndView("/IndianRegulatoryReport/GenerateRegulatoryReport/ChooseReportFile");
		ModelAndView mv = new ModelAndView("RegulatoryReports/India/GenerateRegulatoryReport/ChooseReportFile");
		String reportType = request.getParameter("reportType");
		String reportingMonth = request.getParameter("reportingMonth");
		String reportingYear = request.getParameter("reportingYear");
		String userCode = authentication.getPrincipal().toString();
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("ReportFileList", reportsGenericService.chooseReportFile(reportType, reportingMonth, reportingYear, userCode, userRole));
		commonService.auditLog(authentication.getPrincipal().toString(), request, "REPORTS", "OPEN", "Module Accessed");
		return mv;
	}

	
	@RequestMapping(value = "/regMISReportData")
	public ModelAndView regMISReportData(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception {
		String reportType = request.getParameter("reportType");
		String reportingMonth = request.getParameter("reportingMonth");
		String reportingYear = request.getParameter("reportingYear");
		String batchType = request.getParameter("batchType");
		String originalBatchID = request.getParameter("originalBatchID");
		String reasonOfRevision = request.getParameter("reasonOfRevision");
		
		String reportedDate = request.getParameter("reportedDate");
		String recordsCount = request.getParameter("recordsCount");
		String actionType = request.getParameter("actionType");
		String userCode = authentication.getPrincipal().toString();
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String l_strMessage = "Data updated successfully";
		HashMap<String,Object> reportData = new HashMap<String,Object>();
		//ModelAndView mv = new ModelAndView("/IndianRegulatoryReport/GenerateRegulatoryReport/GenerateMISReport");
		ModelAndView mv = new ModelAndView("RegulatoryReports/India/GenerateRegulatoryReport/GenerateMISReport");
		try {
			reportData = reportsGenericService.RegMISReportData(reportType, reportingMonth, reportingYear, batchType, reportedDate, recordsCount, originalBatchID, reasonOfRevision, actionType, userCode, userRole);
		}
		catch(Exception exp){
			System.out.println("Error while updating/fetching regReport MIS data");
			l_strMessage = "Error while updating/fetching regReport MIS data";
		}
		mv.addObject("message", l_strMessage);
		request.setAttribute("reportData", reportData);
		request.setAttribute("reportType", reportType);
		request.setAttribute("reportingMonth", reportingMonth);
		request.setAttribute("reportingYear", reportingYear);
		request.setAttribute("batchType", batchType);
		request.setAttribute("recordsCount", recordsCount);
		request.setAttribute("reportedDate", reportedDate);
		request.setAttribute("originalBatchID", originalBatchID);
		request.setAttribute("reasonOfRevision", reasonOfRevision);
		request.setAttribute("actionType", actionType);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "REPORTS", "OPEN", "Module Accessed");
		return mv;
	}

	@RequestMapping(value = "/getConsolidatedReports", method=RequestMethod.GET)
	public ModelAndView getConsolidatedReports(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication)
    throws Exception
    {
	ModelAndView modelAndView = new ModelAndView("/Reports/ConsolidatedReportsTabView");
	String userCode = authentication.getPrincipal().toString();
	String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
	
	request.setAttribute("UNQID", otherCommonService.getElementId());
	request.setAttribute("group", request.getParameter("group"));
	request.setAttribute("viewType", request.getParameter("viewType") == null ? "ALL":(String)request.getParameter("viewType"));
	request.setAttribute("LOGGEDUSER", authentication.getPrincipal().toString());
	commonService.auditLog(authentication.getPrincipal().toString(), request, "REPORTS", "OPEN", "Module Accessed");
	return modelAndView;
    }

	@RequestMapping(value = "/getConsolidatedReportTabView") 
	public ModelAndView getConsolidatedReportTabView(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception {
	ModelAndView mv = new ModelAndView("/Reports/ConsolidatedReportsBottomPage");
	String fromDate = request.getParameter("FromDate");
	String toDate = request.getParameter("ToDate");
	String reportFrequency = request.getParameter("ReportFrequency");
	String userCode = authentication.getPrincipal().toString();
	String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
	
	Map<String, Object> mainMap = reportsGenericService.getConsolidatedReportTabView(fromDate, toDate, userCode, userRole, reportFrequency);
	request.setAttribute("ConsolidatedReportsData", mainMap);
	request.setAttribute("FromDate", fromDate);
	request.setAttribute("ToDate", toDate);
	request.setAttribute("ReportFrequency", reportFrequency);
	commonService.auditLog(authentication.getPrincipal().toString(), request, "REPORTS", "OPEN", "Module Accessed");
    return mv;
    }
	
	private String dateFormat(String a_strDate)
    {
		return a_strDate;
    }
	
	private String getCVSformatData(String inputString) 
	{
        String result = inputString;
        if (result != null && result.contains("\"")) {
            result = result.replace("\"", "\"\"");
        }
        return result;
    }

	@RequestMapping(value="/staffMonitoringReports", method=RequestMethod.GET)
	public String staffReports(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String moduleType = request.getParameter("moduleType");
		String userCode = authentication.getPrincipal().toString();
		String userRole = request.getSession(false).getAttribute("CURRENTROLE") == null ? "N.A.":request.getSession(false).getAttribute("CURRENTROLE").toString();
		request.setAttribute("MODULETYPE", moduleType);
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("USERROLE", userRole);
		request.setAttribute("STAFFREPORTSLIST", reportsGenericService.getListOfReports("STAFF", userCode, userRole));
		commonService.auditLog(authentication.getPrincipal().toString(), request, "Staff Monitoring Reports", "OPEN", "Module Accessed");
		return "StaffMonitoringReports/index";
	}
	
	@RequestMapping(value="/getStaffReportParams", method=RequestMethod.POST)
	public String getReportParams(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String reportId = request.getParameter("reportId");
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		request.setAttribute("REPORTPARAMS", reportsGenericService.getStaffReportParams(reportId, authentication.getPrincipal().toString(), userRole, request.getRemoteAddr()));
		commonService.auditLog(authentication.getPrincipal().toString(), request, "Staff Monitoring Reports", "SEARCH", "Module Accessed");
		return "StaffMonitoringReports/ReportParamsPage";
	}	
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/getStaffMonitoringReportsData", method=RequestMethod.POST)
	public String getStaffMonitoringReportsData(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String reportId = "";
		String fromDate = "";
		String toDate = "";
		String userCode = authentication.getPrincipal().toString();
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String ipAddress =  request.getRemoteAddr();
	
		Map<String, String> paramDataMap = new LinkedHashMap<String, String>();
		Map<String, String> paramTempMap = new LinkedHashMap<String, String>();

		Map<String, String[]> formData =  request.getParameterMap();
		reportId = formData.get("reportId")[0];
		
		Iterator<String> itr = formData.keySet().iterator();
		while (itr.hasNext()) {
			String tempParamName = itr.next();
			String tempParamValue = formData.get(tempParamName)[0];
			if("reportId".equals(tempParamName)){
				reportId = tempParamValue;
			}else {	
				paramTempMap.put(tempParamName, tempParamValue);
			}	
			if(tempParamName.contains("FromDate"))
				fromDate = tempParamValue;
			if(tempParamName.contains("ToDate"))
				toDate = tempParamValue;
		}
		
		//System.out.println("repId"+reportId+" fromDt = "+fromDate+" toDate = "+toDate);
		//System.out.println("paramTempMap"+paramTempMap);
		List<String> paramKeyList = new Vector<String>(paramTempMap.keySet());
		//System.out.println(paramKeyList);
		
		Collections.sort(paramKeyList, new Comparator<String>(){
			@Override
			public int compare(String str1, String str2) {
				//System.out.println("str1 = "+Integer.parseInt(str1.substring(0, str1.indexOf("_"))));
				//System.out.println("str2 = "+Integer.parseInt(str2.substring(0, str2.indexOf("_"))));
				return  (Integer.parseInt(str1.substring(0, str1.indexOf("_")))) - Integer.parseInt(str2.substring(0, str2.indexOf("_")));
			}
		});
		
		for(String paramName : paramKeyList) {
			String paramValue = formData.get(paramName)[0];
			paramDataMap.put(paramName, paramValue);
		}		
		
		/* Solution 2
		Map<String, String> paramDataMap = new LinkedHashMap<String, String>();
		
		Enumeration<String> paramEnum = request.getParameterNames();
		System.out.println("paramEnum = "+request.getParameterNames());
		while (paramEnum.hasMoreElements()) {
			String paramName = paramEnum.nextElement();
			String paramValue = request.getParameter(paramName);
			System.out.println(paramName+" "+paramValue);
			paramDataMap.put(paramName, paramValue);
		}
		
		
		Map<String, String[]> paramMap = request.getParameterMap();
		System.out.println("paramMap= "+paramMap);
		reportId = paramMap.get("reportId")[0];
		fromDate = paramMap.get("FromDate")[0];
		toDate = paramMap.get("ToDate")[0];
		*/
		
		/* Solution 1
		  Map<String, String> paramDataMap = new LinkedHashMap<String, String>();
		Map<String, String[]> paramMap = request.getParameterMap();
		System.out.println("paramMap = "+request.getParameterMap());
		
		reportId = paramMap.get("reportId")[0];
		fromDate = paramMap.get("FromDate")[0];
		toDate = paramMap.get("ToDate")[0];
		
		paramMap.remove("reportId");
		System.out.println("paramMap after removing reportid = "+paramMap);
		
		Iterator itr = paramMap.keySet().iterator();
		while(itr.hasNext()){
			Object paramNameObj = itr.next();
			String[] paramValueArr = (String[]) paramMap.get(paramNameObj);
			System.out.println("paramValueArr = "+paramValueArr);
			String paramName = (String) paramNameObj;
			
			String paramValue = "";
			
			for(int i = 0; i < paramValueArr.length; i++){
				paramValue = paramValue + paramValueArr[i];
				
				if(paramValueArr.length != (i+1))
					paramValue = paramValue+",";
			}
			paramDataMap.put(paramName, paramValue);
			
		}*/
		//System.out.println("paramDataMap sol3 = "+paramDataMap+" fromDate = "+fromDate+" toDate = "+toDate+" reportId = "+reportId);
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("REPORTID", reportId);
		request.setAttribute("FROMDATE", fromDate);
		request.setAttribute("TODATE", toDate);
		request.setAttribute("REPORTSDATA", reportsGenericService.getStaffMonitoringReportsData(reportId, paramDataMap, userCode, userRole, ipAddress));
		commonService.auditLog(authentication.getPrincipal().toString(), request, "Staff Monitoring Reports", "SEARCH", "Module Accessed");
		return "StaffMonitoringReports/SearchBottomPage";
	}
}

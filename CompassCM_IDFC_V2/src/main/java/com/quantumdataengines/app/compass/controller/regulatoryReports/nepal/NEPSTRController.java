package com.quantumdataengines.app.compass.controller.regulatoryReports.nepal;

import java.io.BufferedWriter;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.io.StringWriter;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;
import java.util.Iterator;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import com.quantumdataengines.app.compass.service.CommonService;
import com.quantumdataengines.app.compass.service.regulatoryReports.nepal.NepalSTRService;

@Controller
@RequestMapping(value="/common")
public class NEPSTRController {
private static final Logger log = LoggerFactory.getLogger(NEPSTRController.class);
	
	@Autowired
	private NepalSTRService nepalSTRService ;
	@Autowired
	private CommonService commonService;
	
	@RequestMapping(value="/nepalSTR", method=RequestMethod.GET)
	public String nepalSTR(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		String caseNo = request.getParameter("caseNo");
		String userCode = authentication.getPrincipal().toString();
		String ipAddress = request.getRemoteAddr();
		String CURRENTROLE = request.getSession(false) != null ? (String) request.getSession(false).getAttribute("CURRENTROLE") : "";

		request.setAttribute("caseNo", caseNo);
		request.setAttribute("RECORD", nepalSTRService.fetchNepalSTRData(caseNo, userCode, ipAddress, CURRENTROLE));
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "NEPAL_STR", "READ", "Module Accessed");
		return "RegulatoryReports/Nepal/STR/NEPAL_STR";
	}
	
		
	@RequestMapping(value="/saveNEPAL_STR", method=RequestMethod.POST)
	public  String saveNEPAL_STR(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		String caseNo = request.getParameter("caseNo");
		String userCode = authentication.getPrincipal().toString();
		Map<String, String> paramMap = new HashMap<String, String>();
		
		Enumeration enumObj =  request.getParameterNames();
		while(enumObj.hasMoreElements()){
			String paramName = (String) enumObj.nextElement();
			String paramValue = request.getParameter(paramName);
			paramMap.put(paramName, paramValue);	
		}
		request.setAttribute("caseNo", caseNo);
		nepalSTRService.saveNEPAL_STR(paramMap, caseNo, userCode);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "NEPAL_STR", "INSERT", "Data Saved");
		return "redirect:nepalSTR?caseNo="+caseNo;
	}
	
	@RequestMapping(value="/exportXMLNEPAL_STR")
	public ModelAndView exportXMLNEPAL_STR(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String caseNo = request.getParameter("caseNo");
		String userCode = authentication.getPrincipal().toString();
		String ipAddress = request.getRemoteAddr();
		String CURRENTROLE = request.getSession(false) != null ? (String) request.getSession(false).getAttribute("CURRENTROLE") : "";
		// Map<String, Object> nepalSTRXMLFileDetails = new HashMap<String, Object>();
		Map<String, Object> nepalSTRXMLFileDetails = nepalSTRService.getNepalSTRXMLFileContent(caseNo, userCode, ipAddress, CURRENTROLE);
		String l_strXmlFileName = (String) nepalSTRXMLFileDetails.get("FILENAME");
		HashMap l_HMXMlFileContent = (HashMap) nepalSTRXMLFileDetails.get("FILECONTENT");
		BufferedWriter bufferedWriter = null;
		StringWriter stringWriter = null;

		try{

		String l_strLineContent = "";
		stringWriter = new StringWriter();
		bufferedWriter = new BufferedWriter(stringWriter);

		Iterator<String> iterator = l_HMXMlFileContent.keySet().iterator();
		while (iterator.hasNext()) {
			String key = iterator.next().toString();
			String value = (String)l_HMXMlFileContent.get(key);
			//l_strLineContent = l_strLineContent+value+"\n";
			bufferedWriter.write(value);
			bufferedWriter.newLine();

		}
		bufferedWriter.flush();
        String fileData = stringWriter.toString();
        response.setContentType("APPLICATION/OCTET-STREAM");
        String disHeader = "Attachment;Filename=\""+l_strXmlFileName+"\"";
        response.setHeader("Content-disposition", disHeader);
        ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
        byteArrayOutputStream.write(fileData.getBytes());
        response.setContentLength(fileData.length());
        byteArrayOutputStream.writeTo(response.getOutputStream());
        byteArrayOutputStream.flush();
        byteArrayOutputStream.close();
        bufferedWriter.close();
		}
        catch (IOException e) {
        	log.error("Error occured : "+e.getMessage());
            e.printStackTrace();
        }
        catch (Exception e) {
        	log.error("Error occured : "+e.getMessage());
            e.printStackTrace();
        }	
		commonService.auditLog(authentication.getPrincipal().toString(), request, "NEPALSTR", "DOWNLOAD", "STR XML File Downloaded");
        return null;
	}

}

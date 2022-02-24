package com.quantumdataengines.app.compass.controller.regulatoryReports.sriLanka;

import java.io.BufferedWriter;
import java.io.ByteArrayOutputStream;
import java.io.StringWriter;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.quantumdataengines.app.compass.service.CommonService;
import com.quantumdataengines.app.compass.service.regulatoryReports.sriLanka.SLIEFTService;

@Controller
@RequestMapping(value="/common")
public class SLIEFTController {
	
	@Autowired
	private SLIEFTService slIEFTService;
	@Autowired
	private CommonService commonService;
	
	@Value("${compass.aml.config.schemaName}")
	private String schemaName;
	
	@RequestMapping(value="/generateSLIEFTReportingFile", method=RequestMethod.GET)
	public void generateSLIEFTReportingFile(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String reportType = request.getParameter("reportType");
		String reportingFileType = request.getParameter("reportingFileType");
		String fortNightOfReporting = request.getParameter("1_FORTNIGHTOFMONTH");
		String monthOfReporting = request.getParameter("2_MONTHOFYEAR");
		String yearOfReporting = request.getParameter("3_YEAROFREPORTING");
		String thresholdAmount = request.getParameter("4_THRESHOLDAMOUNT");
		String userId = authentication.getPrincipal().toString();
		String l_strMessage = "";
		
		l_strMessage = slIEFTService.generateSLIEFTReportingFile(reportType, reportingFileType, fortNightOfReporting, monthOfReporting, yearOfReporting, thresholdAmount, userId);
		
		SimpleDateFormat simpleDateFormat = new SimpleDateFormat("ddMMyyyyHHmm");
		String dateString = simpleDateFormat.format(new Date());
		
		String tableName = "";
		String fileName = "";
		if(reportingFileType.equalsIgnoreCase("TEXT")){
			if(reportType.equals("SLCTR")){
				tableName = schemaName+"TB_SLCTR_TEXTFILEGENERATION";
				fileName = "CTR_"+dateString+".txt";
			}else if(reportType.equals("SLIEFT")){
				tableName = schemaName+"TB_SLIEFT_TEXTFILEGENERATION";
				fileName = "EFT_IN_"+dateString+".txt";
			}else if(reportType.equals("SLOEFT")){
				tableName = schemaName+"TB_SLOEFT_TEXTFILEGENERATION";
				fileName = "EFT_OUT_"+dateString+".txt";
			}
		}
		else {
			if(reportType.equals("SLCTR")){
				tableName = schemaName+"TB_SLCTR_XMLFILEGENERATION";
				fileName = "CTR_"+dateString+".xml";
			}else if(reportType.equals("SLIEFT")){
				tableName = schemaName+"TB_SLIEFT_XMLFILEGENERATION";
				fileName = "EFT_IN_"+dateString+".xml";
			}else if(reportType.equals("SLOEFT")){
				tableName = schemaName+"TB_SLOEFT_XMLFILEGENERATION";
				fileName = "EFT_OUT_"+dateString+".xml";
			}
		}
		List<String> fileData = slIEFTService.getSLRegReportFileData(tableName);
		
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
		commonService.auditLog(authentication.getPrincipal().toString(), request, "SLIEFT", "INSERT", "SLIEFT Generated :"+l_strMessage);
	}
}

package com.quantumdataengines.app.compass.controller.reports;

import java.io.BufferedInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.MalformedURLException;
import java.nio.file.Files;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.FileUtils;
import org.apache.commons.io.IOUtils;
import org.apache.poi.xslf.usermodel.XMLSlideShow;
import org.apache.poi.xslf.usermodel.XSLFSlideMaster;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.quantumdataengines.app.compass.service.master.GenericMasterService;
import com.quantumdataengines.app.compass.service.reports.PPTReportsService;

@Controller
@RequestMapping(value="/common")
public class PPTReportsController {
	
	@Autowired
	private GenericMasterService genericMasterService;
	
	
	@Autowired
	private PPTReportsService pptReportsService;
	
	@RequestMapping(value = "/pptReportGeneration")
	public String getPPTReportsPage(HttpServletRequest request, HttpServletResponse response, Authentication authentication)throws Exception{
		String moduleType = "pptReportGeneration";
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		request.setAttribute("MASTERSEARCHFRAME", genericMasterService.getModuleParameters(moduleType, 
				authentication.getPrincipal().toString(), userRole, request.getRemoteAddr()));
		
		return "Reports/PPTReport/index";
	}
	
	@RequestMapping(value = "/getPPTReportData")
	public String getPPTReportData(HttpServletRequest request, HttpServletResponse response, Authentication authentication)throws Exception{
		String fromDate = request.getParameter("1_FROMDATE");
		String toDate = request.getParameter("2_TODATE");
		String userCode = authentication.getPrincipal().toString();
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String ipAdress = request.getRemoteAddr();
		Map<String,String> paramValues = new HashMap<String,String>();
		paramValues.put("FROMDATE",fromDate );
		paramValues.put("TODATE",toDate );
		paramValues.put("USERCODE",userCode );
		paramValues.put("USERROLE",userRole );
		paramValues.put("IPADRESS",ipAdress );
		Map<String,Object> reportData = pptReportsService.getPPTReportData(paramValues);
		request.setAttribute("DATA", reportData);
		
		return "Reports/PPTReport/searchBottomPage";
	}
	
	@RequestMapping(value = "/downloadPPTReport")
	public  void downloadPPTReport(HttpServletRequest request, HttpServletResponse response, Authentication authentication) {
		ModelAndView modelAndView = null;
		String fromDate = request.getParameter("1_FROMDATE");
		String toDate = request.getParameter("2_TODATE");
		String userCode = authentication.getPrincipal().toString();
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String ipAdress = request.getRemoteAddr();
		Map<String,String> paramValues = new HashMap<String,String>();
		paramValues.put("FROMDATE",fromDate );
		paramValues.put("TODATE",toDate );
		paramValues.put("USERCODE",userCode );
		paramValues.put("USERROLE",userRole );
		paramValues.put("IPADRESS",ipAdress );
		Map<String,Object> reportData = pptReportsService.downloadPPTReport(paramValues);
		boolean PPTFileCreated = (Boolean) reportData.get("PPTCREATED");
		if(PPTFileCreated){
			File file = (File) reportData.get("File");
			try{
				InputStream in = new BufferedInputStream(new FileInputStream(file));
				 byte[] bytes = IOUtils.toByteArray(in);
				response.setContentType("APPLICATION/OCTET-STREAM");
		        String disHeader = "Attachment;Filename=\""+file.getName();
		        response.setHeader("Content-disposition", disHeader);
		        ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
		        byteArrayOutputStream.write(bytes);
		        response.setContentLength(bytes.length);
		        byteArrayOutputStream.writeTo(response.getOutputStream());
		        byteArrayOutputStream.flush();
		        byteArrayOutputStream.close();
		       // System.out.println("sent already"+file.toURI().toString());
		        if(file.exists()){
		        	//System.out.println("\n sent already \n"+file.toURI().toString());
		        	file.delete();
		        }
			}catch(Exception e){
				System.out.println("error in ex = "+e.getMessage());
				request.setAttribute("message","Error while downloading. "+e.getMessage());
			}
		}else{
			request.setAttribute("message","File Not created ");
		
		}
		
		
		
		//return null;
	}

}

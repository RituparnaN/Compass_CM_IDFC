package com.quantumdataengines.app.compass.service.reports;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.poi.xslf.usermodel.SlideLayout;
import org.apache.poi.xslf.usermodel.XMLSlideShow;
import org.apache.poi.xslf.usermodel.XSLFSlide;
import org.apache.poi.xslf.usermodel.XSLFSlideLayout;
import org.apache.poi.xslf.usermodel.XSLFSlideMaster;
import org.apache.poi.xslf.usermodel.XSLFTextShape;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.quantumdataengines.app.compass.dao.reports.PPTReportsDAO;
import com.quantumdataengines.app.compass.util.pptutility.PPTTableUtility;

@Service
public class PPTReportsServiceImpl implements PPTReportsService {
	
	
	@Autowired
	private PPTReportsDAO pptReportsDAO;
	
	@Autowired
	private PPTTableUtility pptTableUtility;
	

	@Override
	public Map<String, Object> getPPTReportData(Map<String, String> paramValues) {
		return pptReportsDAO.getPPTReportData(paramValues);
	}


	@Override
	public Map<String, Object> downloadPPTReport(Map<String, String> paramValues) {
		boolean pptCreated = true;
		Map<String,Object>result = new HashMap<String,Object>();
		File file = null;
		Map<String,Object> data = pptReportsDAO.getPPTReportData(paramValues);
		XMLSlideShow ppt = new XMLSlideShow();
		XSLFSlideMaster slideMaster = ppt.getSlideMasters().get(0);
		XSLFSlideLayout titleAndContentLayout = slideMaster.getLayout(SlideLayout.TITLE_ONLY);
		XSLFSlide slide1 = ppt.createSlide(titleAndContentLayout);
		XSLFTextShape title = slide1.getPlaceholder(0);
		
		//first slide 
		title.setText("Reporting");
		Map<String,Object> reportStats = (Map<String, Object>) data.get("REPORTSTATS"); 
		List<String> firstSlideTableHeaders = (List<String>) reportStats.get("COLUMNNAME");
		List<List<String>> firstSlideTableData = (List<List<String>>) reportStats.get("TABLEBODYDATA");
		pptTableUtility.createTable(slide1,firstSlideTableHeaders,firstSlideTableData);
		
		//second slide alerts
		XSLFSlide slide2 = ppt.createSlide(titleAndContentLayout);
		XSLFTextShape title2 = slide2.getPlaceholder(0);
		title2.setText("Alert Details");
		Map<String,Object> alertDetails = (Map<String, Object>) data.get("ALERTDETAILS");
		List<String> secondSlideTableHeaders = (List<String>) alertDetails.get("COLUMNNAME");
		List<List<String>> secondSlideTableData = (List<List<String>>) alertDetails.get("TABLEBODYDATA");
		pptTableUtility.createTable(slide2,secondSlideTableHeaders,secondSlideTableData);
		
		//third slide branch wise alert
		XSLFSlide slide3 = ppt.createSlide(titleAndContentLayout);
		XSLFTextShape title3 = slide3.getPlaceholder(0);
		title3.setText("Branch Wise Alert");
		Map<String,Object> branchWisealertDetails = (Map<String, Object>) data.get("BRANCHWISEALERTDETAILS");
		List<String> thirdSlideTableHeaders = (List<String>) branchWisealertDetails.get("COLUMNNAME");
		List<List<String>> thirdSlideTableData = (List<List<String>>) branchWisealertDetails.get("TABLEBODYDATA");
		pptTableUtility.createTable(slide3,thirdSlideTableHeaders,thirdSlideTableData);
		
		
		
		
		
		//fourth slide customer risk rating
		XSLFSlide slide4 = ppt.createSlide(titleAndContentLayout);
		XSLFTextShape title4 = slide4.getPlaceholder(0);
		title4.setText("Customer Risk Rating");
		Map<String,Object> customerRiskDetails = (Map<String, Object>) data.get("CUSTOMERRISKDETAILS");
		List<String> fourthSlideTableHeaders = (List<String>) customerRiskDetails.get("COLUMNNAME");
		List<List<String>> fourthSlideTableData = (List<List<String>>) customerRiskDetails.get("TABLEBODYDATA");
		pptTableUtility.createTable(slide4,fourthSlideTableHeaders,fourthSlideTableData);
		
		
		try {
			//File file = new File("C:\\APPFOLDER\\DOC\\example1.ppt");
			file = File.createTempFile("Reporting", ".pptx");
			FileOutputStream out = new FileOutputStream(file);
			ppt.write(out);
			//System.out.println("Presentation created successfully");
			out.close();
		} catch (FileNotFoundException e) {
			pptCreated = false;
			System.out.println("error = "+e.getMessage());
			e.printStackTrace();
		} catch (Exception e) {
			pptCreated = false;
			System.out.println("error = "+e.getMessage());
			e.printStackTrace();
		}
		
		result.put("File",file);
		result.put("PPTCREATED",pptCreated);
		return result;
	}
	
	private void createSlide(){
		
	}
	
	
	
	
	

}

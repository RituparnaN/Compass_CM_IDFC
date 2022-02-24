package com.quantumdataengines.app.compass.controller.caseWorkFlow;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.itextpdf.text.BaseColor;
import com.itextpdf.text.Chunk;
import com.itextpdf.text.Document;
import com.itextpdf.text.Element;
import com.itextpdf.text.Font;
import com.itextpdf.text.PageSize;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.Phrase;
import com.itextpdf.text.Rectangle;
import com.itextpdf.text.pdf.BaseFont;
import com.itextpdf.text.pdf.CMYKColor;
import com.itextpdf.text.pdf.PdfContentByte;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;
import com.quantumdataengines.app.compass.otherservice.OtherCommonService;
import com.quantumdataengines.app.compass.service.CommonService;
import com.quantumdataengines.app.compass.service.caseWorkFlow.AmlCaseWorkFlowService;
import com.quantumdataengines.app.compass.service.caseWorkFlow.RoboScanService;
import com.quantumdataengines.app.compass.service.entityTracer.EntityTracerService;
import com.quantumdataengines.app.compass.service.master.GenericMasterService;
import com.quantumdataengines.app.compass.service.scanning.OnlineScanningService;


@Controller
@RequestMapping("/amlCaseWorkFlow")
public class RoboScanController {
	
	@Autowired
	private CommonService commonService;
	@Autowired
	private OtherCommonService otherCommonService;
	
	@Autowired
	private AmlCaseWorkFlowService amlCaseWorkFlowService;
	
	@Autowired
	private RoboScanService roboScanService;
	
	@Autowired
	private GenericMasterService genericMasterService;
	
	@Autowired
	private EntityTracerService entityTracerService;
	
	@Autowired
	private OnlineScanningService onlineScanningService;
	
	@Value("${compass.aml.paths.segoeUISemiboldPath}")
	private String segoeUISemiboldPath;
	
	@Value("${compass.aml.paths.rpaRepositoryPath}")
	private String rpaRepositoryPath;
	
	
	@RequestMapping(value="/roboscanDetails", method=RequestMethod.GET)
	public String roboscanDetails(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		String CURRENTROLE = request.getSession(false) != null ? (String) request.getSession(false).getAttribute("CURRENTROLE") : "";
		//String page = "AMLCaseWorkFlow/Roboscan";
			
		String caseNos = request.getParameter("CaseNos");
		String caseStatus = request.getParameter("CaseStatus");
		String flagType = request.getParameter("FlagType") == null ? "N":request.getParameter("FlagType");
		String userCode = authentication.getPrincipal().toString();
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String parentFormId = request.getParameter("formId");
		String ipAddress = request.getRemoteAddr();
		 
		List<String> roboscanConfigDetails = roboScanService.getRoboscanConfigDetails(userRole);
		//System.out.println("roboscanConfigDetails = "+roboscanConfigDetails);
		
		Map<String, Object> roboscanData =  roboScanService.fetchRoboscanData(caseNos, userCode, ipAddress, CURRENTROLE);
		//System.out.println("SECTION ONE= "+roboscanData.get("roboScanSectionTen"));
		
		request.setAttribute("ROBOSCAN_CONFIG", roboscanConfigDetails);

		request.setAttribute("HEADER", roboscanData.get("HEADER"));
		request.setAttribute("SECTION1ALERTDETAILS", roboscanData.get("SECTION1ALERTDETAILS"));
		request.setAttribute("SECTION2KYC", roboscanData.get("SECTION2KYC"));
		request.setAttribute("SECTION3RTSCAN", roboscanData.get("SECTION3RTSCAN"));
		request.setAttribute("SECTION4TXNDETAILS", roboscanData.get("SECTION4TXNDETAILS"));
		request.setAttribute("SECTION5ACCPROFILE", roboscanData.get("SECTION5ACCPROFILE"));
		request.setAttribute("SECTION6LINK", roboscanData.get("SECTION6LINK"));
		request.setAttribute("SECTION7PASTHISTORY", roboscanData.get("SECTION7PASTHISTORY"));
		request.setAttribute("SECTION8RLTDPARTY", roboscanData.get("SECTION8RLTDPARTY"));
		request.setAttribute("SECTION9RINGSIDEVIEW", roboscanData.get("SECTION9RINGSIDEVIEW"));
		request.setAttribute("SECTION10CUSTCASEHISTORY", roboscanData.get("SECTION10CUSTCASEHISTORY"));
		request.setAttribute("SECTION11USERCOMMENTS", roboscanData.get("SECTION11USERCOMMENTS"));
		request.setAttribute("SECTION12ACTIONS", roboscanData.get("SECTION12ACTIONS"));
		request.setAttribute("OPTION", roboscanData.get("OPTION"));
		request.setAttribute("CaseNos", request.getParameter("CaseNos"));
		request.setAttribute("CaseStatus", request.getParameter("CaseStatus"));
		request.setAttribute("FlagType", flagType);
		request.setAttribute("parentFormId", parentFormId);
		request.setAttribute("LOGGEDUSER", userCode);
		request.setAttribute("GROUPOFLOGGEDUSER", userRole);
		request.setAttribute("LOGGED_USER_REGION", "India");
		request.setAttribute("CASECOMMENTDETAILS", amlCaseWorkFlowService.getCaseCommentDetails(caseNos, 
				caseStatus, userCode, userRole, ipAddress));
		request.setAttribute("UNQID", otherCommonService.getElementId());

		String moduleValue = request.getParameter("CaseNos");
		//String moduleHeader = "Roboscan Details";

		/*Map<String, Object> mainMap = genericMasterService.getModuleDetails(moduleCode, moduleValue, 
				authentication.getPrincipal().toString(), CURRENTROLE, request.getRemoteAddr());
		writeRPARepositoryDetailsToPDF(mainMap, request.getParameter("CaseNos"), userCode, userRole, ipAddress);
		writeRPARepositoryDetailsToExcel(mainMap, request.getParameter("CaseNos"), userCode, userRole, ipAddress);
		request.setAttribute("MODULEDETAILS", mainMap);
		request.setAttribute("moduleCode", moduleCode);
		request.setAttribute("moduleValue", moduleValue);
		request.setAttribute("detailPage", detailPage);
		request.setAttribute("moduleHeader", moduleHeader);*/
		request.setAttribute("UNQID", otherCommonService.getElementId());
		commonService.auditLog(authentication.getPrincipal().toString(), request, "ROBOSCAN", "SEARCH", moduleValue+" details viewed in tab");
		return "AMLCaseWorkFlow/Roboscan/Roboscan";
		
		/*String moduleCode = "rpaRepositoryDetails";
		String moduleValue = request.getParameter("CaseNos");
		String detailPage = "FraudCaseWorkFlow/Roboscan";
		String moduleHeader = "Roboscan Details";
		
		Map<String, Object> mainMap = genericMasterService.getModuleDetails(moduleCode, moduleValue, 
				authentication.getPrincipal().toString(), CURRENTROLE, request.getRemoteAddr());
		writeRPARepositoryDetailsToPDF(mainMap, request.getParameter("CaseNos"), userCode, userRole, ipAddress);
		writeRPARepositoryDetailsToExcel(mainMap, request.getParameter("CaseNos"), userCode, userRole, ipAddress);
		request.setAttribute("MODULEDETAILS", mainMap);
		request.setAttribute("moduleCode", moduleCode);
		request.setAttribute("moduleValue", moduleValue);
		request.setAttribute("detailPage", detailPage);
		request.setAttribute("moduleHeader", moduleHeader);
		request.setAttribute("UNQID", otherCommonService.getElementId());
		commonService.auditLog(authentication.getPrincipal().toString(), request, moduleCode, "SEARCH", moduleValue+" details viewed in tab");
		return detailPage;*/
	}
	
	@RequestMapping(value = "/getEntityLinkedDetails", method=RequestMethod.POST) 
	public String getEntityLinkedDetailsTabView(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception {
		String userCode = authentication.getPrincipal().toString();
		String accountNumber = request.getParameter("accountNo");
		String customerId = request.getParameter("CustomerId");
		String customerName = request.getParameter("CustomerName");
		String fromDate = request.getParameter("fromDate");
		String toDate = request.getParameter("toDate");
		String staticLink = request.getParameter("staticLink");
		String transactionLink = request.getParameter("transactionLink");
		// String minLinks = request.getParameter("MinLinks");
		String counterAccountNo = request.getParameter("CounterAccountNo");
		String counterAccountGroup = request.getParameter("CounterAccountGroup");
		int levelCount = 0;
		String message = "";
		try{
			levelCount = Integer.parseInt(request.getParameter("levelCount"));
		}catch(NumberFormatException e){
			message = "Enter a valid number for level count";
		}
		String productCode = request.getParameter("ProductCode");
		
		int minLinks = 0;
		boolean isStaticLink = false;
		boolean isTransactionLink = false;
		/*System.out.println(accountNumber);
		System.out.println("ControllerParamPassingToService= "+accountNumber+", "+customerId+", "+customerName+", "+fromDate+", "+toDate+", "+isStaticLink+", "+isTransactionLink+", "+
	    		minLinks+", "+counterAccountNo+", "+levelCount+", "+productCode+", "+counterAccountGroup);
	    */
		/*
		try{
			minLinks = Integer.parseInt(request.getParameter("MinLinks"));
		}catch(NumberFormatException e){
			message = "Enter a valid number for min links";
		}*/
			
		if(staticLink != null && staticLink.equalsIgnoreCase("Y"))
			isStaticLink = true;
		if(transactionLink != null && transactionLink.equalsIgnoreCase("Y"))
			isTransactionLink = true;
	    
		Map<String, Object> mainMap = entityTracerService.getLinkedTracer(accountNumber, customerId, customerName, 
				fromDate, toDate, isStaticLink, isTransactionLink, minLinks, counterAccountNo, levelCount, productCode, 
				counterAccountGroup);
		request.setAttribute("EntityTracerData", mainMap);
		//request.setAttribute("EXCULDEDPRODUCTCODE", EntityTracerService.getExcludedProductCodes());
		request.setAttribute("EXCULDEDPRODUCTCODE", productCode);
		request.setAttribute("FromDate", fromDate);
		request.setAttribute("ToDate", toDate);
		request.setAttribute("AccountNumber", accountNumber);
		request.setAttribute("CustomerId", customerId);
		request.setAttribute("CustomerName", customerName);
		request.setAttribute("StaticLink", staticLink);
		request.setAttribute("TransactionLink", transactionLink);
		request.setAttribute("MinLinks", request.getParameter("MinLinks"));
		request.setAttribute("CounterAccountNo", counterAccountNo);
		request.setAttribute("CounterAccountGroup", counterAccountGroup);
		request.setAttribute("LevelCount", request.getParameter("LevelCount"));
		request.setAttribute("Message", message);
		
		/*
		System.out.println("ControllerReturningParam= "+accountNumber+", "+customerId+", "+customerName+", "+fromDate+", "+toDate+", "+isStaticLink+", "+isTransactionLink+", "+
	    		minLinks+", "+counterAccountNo+", "+levelCount+", "+productCode+", "+counterAccountGroup);
	    System.out.println("mainMap= "+mainMap);
		*/
		commonService.auditLog(authentication.getPrincipal().toString(), request, "ENTITY TRACER", "SEARCH", "Module Accessed");
		request.setAttribute("UNQID", otherCommonService.getElementId());
	    return "AMLCaseWorkFlow/Roboscan/RoboscanEntityLinkTracerModal";
    }
	
	@RequestMapping(value = "/getEntityLinkedHorizontalGraph", method=RequestMethod.POST) 
	public String getEntityLinkedHorizontalGraph(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception {
		String userCode = authentication.getPrincipal().toString();
		String accountNumber = request.getParameter("accountNo");
		String customerId = request.getParameter("CustomerId") == null ? "":request.getParameter("CustomerId");
		String customerName = request.getParameter("CustomerName") == null ? "":request.getParameter("CustomerId");
		String fromDate = request.getParameter("fromDate");
		String toDate = request.getParameter("toDate");
		String staticLink = request.getParameter("staticLink");
		String transactionLink = request.getParameter("transactionLink");
		String minLinks = request.getParameter("MinLinks")== null ? "0":request.getParameter("MinLinks");
		String counterAccountNo = request.getParameter("CounterAccountNo") == null ? "":request.getParameter("CounterAccountNo");
		String counterAccountGroup = request.getParameter("CounterAccountGroup") == null ? "":request.getParameter("CounterAccountGroup");
		String levelCount = request.getParameter("LevelCount");
		String productCode = request.getParameter("ProductCode");
		//String view = request.getParameter("view");		
		
		request.setAttribute("EXCULDEDPRODUCTCODE", productCode);
		request.setAttribute("FromDate", fromDate);
		request.setAttribute("ToDate", toDate);
		request.setAttribute("AccountNumber", accountNumber);
		request.setAttribute("CustomerId", customerId);
		request.setAttribute("CustomerName", customerName);
		request.setAttribute("StaticLink", staticLink);
		request.setAttribute("TransactionLink", transactionLink);
		request.setAttribute("MinLinks", request.getParameter("minLinks"));
		request.setAttribute("CounterAccountNo", counterAccountNo);
		request.setAttribute("CounterAccountGroup", counterAccountGroup);
		request.setAttribute("LevelCount", request.getParameter("levelCount"));
		request.setAttribute("UNQID", otherCommonService.getElementId());
		commonService.auditLog(authentication.getPrincipal().toString(), request, "ENTITY TRACER", "OPEN", "Module Accessed");
		//System.out.println("calling horizontal");
		return "AMLCaseWorkFlow/Roboscan/Roboscan_EntityTracerHorizontalGraphView";
	}
	
	@RequestMapping(value = "/getEntityLinkedVerticalGraph", method=RequestMethod.POST) 
	public String getEntityLinkedVerticalGraph(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception {
		String userCode = authentication.getPrincipal().toString();
		String accountNumber = request.getParameter("accountNo");
		String customerId = request.getParameter("CustomerId") == null ? "":request.getParameter("CustomerId");
		String customerName = request.getParameter("CustomerName") == null ? "":request.getParameter("CustomerId");
		String fromDate = request.getParameter("fromDate");
		String toDate = request.getParameter("toDate");
		String staticLink = request.getParameter("staticLink");
		String transactionLink = request.getParameter("transactionLink");
		String minLinks = request.getParameter("MinLinks")== null ? "0":request.getParameter("MinLinks");
		String counterAccountNo = request.getParameter("CounterAccountNo") == null ? "":request.getParameter("CounterAccountNo");
		String counterAccountGroup = request.getParameter("CounterAccountGroup") == null ? "":request.getParameter("CounterAccountGroup");
		String levelCount = request.getParameter("LevelCount");
		String productCode = request.getParameter("ProductCode");
		//String view = request.getParameter("view");
		
		request.setAttribute("EXCULDEDPRODUCTCODE", productCode);
		request.setAttribute("FromDate", fromDate);
		request.setAttribute("ToDate", toDate);
		request.setAttribute("AccountNumber", accountNumber);
		request.setAttribute("CustomerId", customerId);
		request.setAttribute("CustomerName", customerName);
		request.setAttribute("StaticLink", staticLink);
		request.setAttribute("TransactionLink", transactionLink);
		request.setAttribute("MinLinks", request.getParameter("minLinks"));
		request.setAttribute("CounterAccountNo", counterAccountNo);
		request.setAttribute("CounterAccountGroup", counterAccountGroup);
		request.setAttribute("LevelCount", request.getParameter("levelCount"));
		request.setAttribute("UNQID", otherCommonService.getElementId());
		commonService.auditLog(authentication.getPrincipal().toString(), request, "ENTITY TRACER", "OPEN", "Module Accessed");
		//System.out.println("calling vertical");
		return "AMLCaseWorkFlow/Roboscan/Roboscan_EntityTracerVerticalGraphView";		
	}
	
	@RequestMapping(value = "/getEntityLinkedDetailsGraphView", method=RequestMethod.GET) 
	public @ResponseBody Map<String, Object> getEntityLinkedDetailsGraphView(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception {
		//System.out.println("getEntityLinkedDetailsGraphView");
		String userCode = authentication.getPrincipal().toString();
		String accountNumber = request.getParameter("AccountNumber");
		String customerId = request.getParameter("CustomerId");
		String customerName = request.getParameter("CustomerName");
		String fromDate = request.getParameter("FromDate");
		String toDate = request.getParameter("ToDate");
		String staticLink = request.getParameter("StaticLink");
		String transactionLink = request.getParameter("TransactionLink");
		// String minLinks = request.getParameter("MinLinks");
		String counterAccountNo = request.getParameter("CounterAccountNo");
		String counterAccountGroup = request.getParameter("CounterAccountGroup") == null ? "":request.getParameter("CounterAccountGroup");
		// String levelCount = request.getParameter("LevelCount");
		String productCode = request.getParameter("ProductCode");
		String message = "";
		
		int minLinks = 0;
		int levelCount = 0;
		boolean isStaticLink = false;
		boolean isTransactionLink = false;
		
		try{
			minLinks = Integer.parseInt(request.getParameter("MinLinks"));
		}catch(NumberFormatException e){
			message = "Enter a valid number for min links";
		}
		
		try{
			levelCount = Integer.parseInt(request.getParameter("LevelCount"));
		}catch(NumberFormatException e){
			message = "Enter a valid number for level count";
		}
		
		if(staticLink != null && staticLink.equalsIgnoreCase("y"))
			isStaticLink = true;
		if(transactionLink != null && transactionLink.equalsIgnoreCase("y"))
			isTransactionLink = true;
		
		Map<String, Object> mainMap = entityTracerService.getLinkedTracerForGraph(accountNumber, customerId, customerName, 
				fromDate, toDate, isStaticLink, isTransactionLink, minLinks, counterAccountNo, levelCount, productCode, 
				counterAccountGroup);
		//System.out.println("graph data = "+mainMap);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "ENTITY TRACER", "OPEN", "Module Accessed");
	    return mainMap;
    }
	
	@RequestMapping(value="/getRoboscanScreeningDetails", method=RequestMethod.GET)
	public @ResponseBody Map getRoboscanScreeningDetails(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		String roboscanCaseNo = request.getParameter("roboscanCaseNo");
		Map<String,String> roboscanScreeningDetails = roboScanService.getRoboscanScreeningDetails(roboscanCaseNo);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "SCREENING", "OPEN", "Module Accessed");
		return roboscanScreeningDetails;
	}
	
	@RequestMapping(value = "/showViewMatchesForm", method=RequestMethod.POST)
	public String showViewMatchesForm(HttpServletRequest request, HttpServletResponse response, Authentication authentication){
		String strUsercode = authentication.getPrincipal().toString();
		Vector vecListOfFile = onlineScanningService.getFileNames("file|"+strUsercode);
		request.setAttribute("FileName",vecListOfFile);
		request.setAttribute("UNQID", otherCommonService.getElementId());
		commonService.auditLog(authentication.getPrincipal().toString(), request, "SCANNING", "OPEN", "Module Accessed");
		return "AMLCaseWorkFlow/Roboscan/showViewMatchesForm";
	}
	
	
	private void writeRPARepositoryDetailsToPDF(Map<String, Object> mainMap, String caseNo, 
			String userCode, String userRole, String ipAddress){
			Document document = null;
			PdfWriter writer = null;
			OutputStream file = null;
			try{
				SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy hh:mm:ss a");
				BaseFont base = BaseFont.createFont(segoeUISemiboldPath, BaseFont.WINANSI, true);
				String rpaRepositoryPDFFolder = rpaRepositoryPath+File.separator+caseNo;
				File rpaRepositoryPDFFile = new File(rpaRepositoryPDFFolder);
				if(!rpaRepositoryPDFFile.exists()){
					rpaRepositoryPDFFile.mkdir();
				}
	 
				@SuppressWarnings("unchecked")
				List<String> tabNames = (List<String>) mainMap.get("TABNAMES");
				
				@SuppressWarnings("unchecked")
				HashMap<String, String> tabDisplay = (HashMap<String, String>) mainMap.get("TABDISPLAY");
							
				for(int i = 0; i < tabNames.size(); i++){
					String rpaRepositoryPDF = rpaRepositoryPath+File.separator+caseNo+File.separator+tabNames.get(i)+".pdf";
					file = new FileOutputStream(rpaRepositoryPDF);
					document = new Document();
		            writer = PdfWriter.getInstance(document, file);
		            
		            document.addAuthor(userCode);
		            document.addCreationDate();
		            document.setPageSize(PageSize.A4);
		            document.addCreator("Compass AML");
		            document.addTitle("RPA Repository");
		            document.addSubject("RPA Repository generated from Compass for case no : "+caseNo);            
		            document.setMargins(15, 15, 15, 15);
		            document.setMarginMirroringTopBottom(true);
		 
		            document.open();                        
		            
		            PdfContentByte canvas = writer.getDirectContent();
		            Rectangle rect = new Rectangle(10, 10, 585, 832);
		            rect.setBorder(Rectangle.BOX);
		            rect.setBorderWidth(0.5f);
		            canvas.setColorStroke(BaseColor.DARK_GRAY);
		            canvas.rectangle(rect);            
		            canvas.stroke();
		            
		            
		            Paragraph paragraph = new Paragraph("RPA Repository", new Font(base, 12f, Font.NORMAL));
		            document.add(paragraph);
		            
		            paragraph = new Paragraph("for Compass case no : "+caseNo+" generated by "+userCode+" on "+sdf.format(new Date()), new Font(base, 5f, Font.NORMAL));
		            document.add(paragraph);
		
		            Font blackFont = new Font(base, 6f, Font.NORMAL);
		            blackFont.setColor(BaseColor.BLACK);
		            
		            Font redFont = new Font(base, 6f, Font.NORMAL);
		            redFont.setColor(BaseColor.RED);
		            
		            Font greenFont = new Font(base, 6f, Font.NORMAL);
		            greenFont.setColor(new CMYKColor(0.86f, 0.00f, 0.60f, 0.45f));
		            
		            Font blueFont = new Font(base, 6f, Font.NORMAL);
		            blueFont.setColor(BaseColor.BLUE);
		            
		            document.add(Chunk.NEWLINE);
		            document.add(Chunk.NEWLINE);
		            //document.add(new Paragraph(tabNames.get(i), new Font(base, 10f, Font.NORMAL)));
		            
		            Chunk underline = new Chunk(""+tabNames.get(i)+"");
		            underline.setUnderline(0.1f, -2f); //0.1 thick, -2 y-location
		            document.add(underline);

					//@SuppressWarnings("unchecked")
		            //List<String> tabData = (List<String>) mainMap.get(""+i+"");
		            
					List<Map<String, String>> dataList = (List<Map<String,String>>) mainMap.get(Integer.toString(i));
					//System.out.println(dataList);
					
					//List<HashMap<String,String>> dataList = new ArrayList<HashMap<String,String>>();
					//HashMap<String, String> dataMap = new HashMap<String, String>();
					//System.out.println(dataList.size());
					
		            if("D".equals(tabDisplay.get(Integer.toString(i)))){
		            	//System.out.println("D = "+tabData);
		            	PdfPTable customerInfoTable = new PdfPTable(4);
		            	//customerInfoTable.getDefaultCell().setBorder(2);
		                customerInfoTable.setSpacingBefore(10f);
		                //customerInfoTable.setWidths(new int[]{20, 25, 5, 20, 25,5});            
		                customerInfoTable.setWidthPercentage(100.0f);

		                
						for (Map<String,String> dataMap: dataList) {
						  for (Map.Entry<String,String> e:dataMap.entrySet()) {
						    String key = e.getKey();
						    String value = e.getValue();
						    // System.out.println("key"+key);
						    // System.out.println("value"+value);
						    
			                customerInfoTable.addCell(key.replaceAll("app.common.", ""));
			                customerInfoTable.addCell(value);
			                //customerInfoTable.addCell("|");
			                }
						}
						document.add(customerInfoTable);
		                
		                 document.close();
			        	 file.flush();
			        	 file.close();

		            }
		           
		           else if("T".equals(tabDisplay.get(Integer.toString(i)))){
		        	   //System.out.println("T = "+tabData);
		        	   
		        	   document.add(Chunk.NEWLINE);
		        	   document.add(Chunk.NEWLINE);
		        	   
		        	    PdfPTable transactionDetailsTable = new PdfPTable(2);
		        	   //PdfPTable transactionDetailsTable = new PdfPTable(dataList.get(0).entrySet().size());
		        	  
		        	   //c2.setHorizontalAlignment(Element.ALIGN_CENTER);
		               //transactionDetailsTable.addCell(c2);
		        	   
		               boolean isfirstRow = true;
		               int loopCount = 0;
		               for (Map<String,String> dataMap: dataList) {
		            	    document.add(Chunk.NEWLINE);
		            	    Chunk underlineTransactionNo = new Chunk("TransactionNo = "+dataMap.get("app.common.TRANSACTIONNO")+"");
		            	    underlineTransactionNo.setUnderline(0.1f, -2f); //0.1 thick, -2 y-location
		   	                document.add(underlineTransactionNo);

			        	    transactionDetailsTable = new PdfPTable(2);
			        	    transactionDetailsTable.setWidthPercentage(100.0f);
			        	    // PdfPCell c2 = new PdfPCell(new Phrase("Serial No"));
			        	    PdfPCell c2 = new PdfPCell();
			        	    PdfPCell c3 = new PdfPCell();

		       				for (Map.Entry<String,String> e:dataMap.entrySet()) {
						    String key = e.getKey();
						    String value = e.getValue();
					    	//c2.setColspan(key.length());

						    c2 = new PdfPCell(new Phrase(key.replaceAll("app.common.", "")));
					    	c3 = new PdfPCell(new Phrase(value));
					    	c2.setHorizontalAlignment(Element.ALIGN_LEFT);
					    	c3.setHorizontalAlignment(Element.ALIGN_LEFT);
			                transactionDetailsTable.addCell(c2);
			                transactionDetailsTable.addCell(c3);
			               // transactionDetailsTable.setHeaderRows(loopCount);
						  }
			       		document.add(transactionDetailsTable);
		               }
			               	
			        	 document.close();
			        	 file.flush();
			        	 file.close();
		           }
				}
			}catch(Exception e){
				e.printStackTrace();
			}finally{
		         try {
		        	 document.close();
		        	 file.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}
	
	private void writeRPARepositoryDetailsToExcel(Map<String, Object> mainMap, String caseNo, 
			String userCode, String userRole, String ipAddress){
		OutputStream file = null;
		try{
			
			String rpaRepositoryFolder = rpaRepositoryPath+File.separator+caseNo;
			File rpaRepositoryExcelFile = new File(rpaRepositoryFolder);
			if(!rpaRepositoryExcelFile.exists()){
				rpaRepositoryExcelFile.mkdir();
			}
			@SuppressWarnings("unchecked")
			List<String> tabNames = (List<String>) mainMap.get("TABNAMES");
			
			@SuppressWarnings("unchecked")
			HashMap<String, String> tabDisplay = (HashMap<String, String>) mainMap.get("TABDISPLAY");
						
			for(int i = 0; i < tabNames.size(); i++){
				if("T".equals(tabDisplay.get(Integer.toString(i)))){
					String rpaRepositoryExcel = rpaRepositoryPath+File.separator+caseNo+File.separator+tabNames.get(i)+".xls";
					file = new FileOutputStream(rpaRepositoryExcel);
					
					HSSFWorkbook workbook = new HSSFWorkbook();
					HSSFSheet sheet = workbook.createSheet("FirstSheet");  
					
					List<Map<String, String>> dataList = (List<Map<String,String>>) mainMap.get(Integer.toString(i));
					
					//System.out.println("rpaRepositoryExcel:  "+rpaRepositoryExcel);
					
					int mapCount = 0;
	       			int loopCount = 0;
	       			for (Map<String,String> dataMap: dataList) {
					  //HSSFRow rowhead = sheet.createRow(mapCount);
	       				//System.out.println("dataList : "+dataList+"  e:dataMap.entrySet() "+dataMap.entrySet().size()); 
					  if(mapCount == 0){
					  HSSFRow rowhead = sheet.createRow(mapCount);
					  for (Map.Entry<String,String> e:dataMap.entrySet()) {
					    String key = e.getKey();
					    rowhead.createCell(loopCount++).setCellValue(key.replaceAll("app.common.", ""));
					  }
					  }
					  //System.out.println("mapCount :  "+mapCount);
					  int columnCount = 0;
 			          HSSFRow row = sheet.createRow(++mapCount);
				      for (Map.Entry<String,String> e:dataMap.entrySet()) {
					    String value = e.getValue();
		    			row.createCell(columnCount++).setCellValue(value);
				      }
					}
	       			FileOutputStream fileOut = new FileOutputStream(rpaRepositoryExcel);
		            workbook.write(fileOut);
		            fileOut.close();
				}
				
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
	         try {
	        	 file.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	}

}

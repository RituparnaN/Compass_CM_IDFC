package com.quantumdataengines.app.compass.controller.reports;

import java.io.FileInputStream;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Vector;
import java.sql.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.ClientAnchor;
import org.apache.poi.ss.usermodel.CreationHelper;
import org.apache.poi.ss.usermodel.Drawing;
import org.apache.poi.ss.usermodel.FillPatternType;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.Picture;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.ss.usermodel.ClientAnchor.AnchorType;
import org.apache.poi.util.IOUtils;
import org.apache.poi.xssf.usermodel.XSSFFont;
import org.apache.poi.xssf.usermodel.XSSFSheet;

public class MultiSheetExcelViewChartSummary extends AbstractExcelView {
	
	public String imageUrl = "";
	
	
//	public MultiSheetExcelViewChart(String imageUrl) {
//		this.imageUrl = imageUrl;
//	}
	@Override
	protected void buildExcelDocument(Map<String, Object> model, Workbook workbook, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		 	String imgId=request.getParameter("imageId");
	 		//System.out.println("image Id: "+imgId);
		 	String dEFAULTVALUECHART = "";
		 	String t_RESIDUALRISK = "";
		 	String rl_RESIDUALRISK = "";
		 	String ra_RESIDUALRISK = "";
		 	String wb_RESIDUALRISK = "";
	 		String rESIDUALRISK = "";
	 		String aSSESSMENTWISECAT = "";
	 		String bl_IR = "";
	 		String bl_IC = "";
	 		double a_TOTALWEIGHTEDSCOREIR = 0.0;
	 		double a_TOTALWEIGHTEDSCOREIC = 0.0;
	 		double s_TotalTresuryIR = 0.0;
	 		double s_TotalTresuryIC = 0.0;
	 		double s_TotalRetailLiabiltiesIR = 0.0;
	 		double s_totalRetailLiabiltiesIC = 0.0;
	 		double s_TotalRetailAssetsIR = 0.0;
	 		double s_TotalRetailAssetsIC = 0.0;
	 		double s_TotalWholesaleIR = 0.0;
	 		double s_TotalWholesaleIC = 0.0;
	 		String url = "jdbc:oracle:thin:@localhost:1521/xe";
	        String user = "COMAML_CM";
	        String pass = "ORACLE";
	 	        
	        Connection con = null;
	        
	        try {
	 
	            DriverManager.registerDriver(
	                new oracle.jdbc.OracleDriver());
	 
	            con = DriverManager.getConnection(url, user, pass);
	            Statement st = con.createStatement();
	            String sql = "SELECT DEFAULTVALUECHART, T_RESIDUALRISK, RL_RESIDUALRISK, RA_RESIDUALRISK, WB_RESIDUALRISK, RESIDUALRISK, ASSESSMENTWISECAT, BL_IR, BL_IC, "
	            		+ "A_TOTALWEIGHTEDSCOREIR, A_TOTALWEIGHTEDSCOREIC, TOTALTRESURYIR, TOTALTRESURYIC, "
	            		+ "TOTALRLIR, TOTALRLIC, TOTALRAIR, TOTALRAIC, TOTALWBIR, TOTALWBIC FROM TB_IMAGEDATASUMMARY WHERE IMAGEID = '"+imgId+"'";
	            ResultSet m = st.executeQuery(sql);
	            while(m.next()) {
	            	dEFAULTVALUECHART = m.getString("DEFAULTVALUECHART");
	            	t_RESIDUALRISK = m.getString("T_RESIDUALRISK");
	            	rl_RESIDUALRISK = m.getString("RL_RESIDUALRISK");
	            	ra_RESIDUALRISK = m.getString("RA_RESIDUALRISK");
	            	wb_RESIDUALRISK = m.getString("WB_RESIDUALRISK");
	            	rESIDUALRISK = m.getString("RESIDUALRISK");
	            	aSSESSMENTWISECAT = m.getString("ASSESSMENTWISECAT");
	            	bl_IR = m.getString("BL_IR");
	            	bl_IC = m.getString("BL_IC");
	            	a_TOTALWEIGHTEDSCOREIR = m.getDouble("A_TOTALWEIGHTEDSCOREIR");
	            	a_TOTALWEIGHTEDSCOREIC = m.getDouble("A_TOTALWEIGHTEDSCOREIC");
	            	s_TotalTresuryIR = m.getDouble("TOTALTRESURYIR");
	            	s_TotalTresuryIC = m.getDouble("TOTALTRESURYIC");
	            	s_TotalRetailLiabiltiesIR = m.getDouble("TOTALRLIR");
	            	s_totalRetailLiabiltiesIC = m.getDouble("TOTALRLIC");
	            	s_TotalRetailAssetsIR = m.getDouble("TOTALRAIR");
	            	s_TotalRetailAssetsIC = m.getDouble("TOTALRAIC");
	            	s_TotalWholesaleIR = m.getDouble("TOTALWBIR");
	            	s_TotalWholesaleIC = m.getDouble("TOTALWBIC");
	            }
	            con.close();
	        }
	        catch (Exception ex) {
	            System.err.println(ex);
	        }
	        
	        String base64ImageDefaultValueChart = null;
	        String base64ImageT_ResidualRisk = null;
	        String base64ImageRL_ResidualRisk = null;
	        String base64ImageRA_ResidualRisk = null;
	        String base64ImageWB_ResidualRisk = null;
	        String base64ImageResidualRisk = null;
	        String base64ImageBL_IR = null;
	        String base64ImageBL_IC = null;
	        String base64ImageAssessment = null;
	        
	        byte[] imageBytesDefaultValueChart = null;
	        byte[] imageBytesT_ResidualRisk = null;
	        byte[] imageBytesRL_ResidualRisk = null;
	        byte[] imageBytesRA_ResidualRisk = null;
	        byte[] imageBytesWB_ResidualRisk = null;
	        byte[] imageBytesResidualRisk = null;
	        byte[] imageBytesBL_IR = null;
	        byte[] imageBytesBL_IC = null;
	        byte[] imageBytesAssessment = null;
	        
	        try {
	        	
	        	//System.out.println("A_RESIDUALRISK: "+a_RESIDUALRISK);
	        	//System.out.println("A_ASSESSMENTWISECAT: "+a_ASSESSMENTWISECAT);
	        	//System.out.println("A_TOTALWEIGHTEDSCOREIR: "+a_TOTALWEIGHTEDSCOREIR);
	        	//System.out.println("A_TOTALWEIGHTEDSCOREIC: "+a_TOTALWEIGHTEDSCOREIC);
	        	
	        	base64ImageDefaultValueChart = dEFAULTVALUECHART.split(",")[1];
	        	imageBytesDefaultValueChart = javax.xml.bind.DatatypeConverter.parseBase64Binary(base64ImageDefaultValueChart);
	        	
	        	base64ImageT_ResidualRisk = t_RESIDUALRISK.split(",")[1];
	        	imageBytesT_ResidualRisk = javax.xml.bind.DatatypeConverter.parseBase64Binary(base64ImageT_ResidualRisk);
	        	
	        	base64ImageRL_ResidualRisk = rl_RESIDUALRISK.split(",")[1];
	        	imageBytesRL_ResidualRisk = javax.xml.bind.DatatypeConverter.parseBase64Binary(base64ImageRL_ResidualRisk);
	        	
	        	base64ImageRA_ResidualRisk = ra_RESIDUALRISK.split(",")[1];
	        	imageBytesRA_ResidualRisk = javax.xml.bind.DatatypeConverter.parseBase64Binary(base64ImageRA_ResidualRisk);
	        	
	        	base64ImageWB_ResidualRisk = wb_RESIDUALRISK.split(",")[1];
	        	imageBytesWB_ResidualRisk = javax.xml.bind.DatatypeConverter.parseBase64Binary(base64ImageWB_ResidualRisk);
	        	
	        	base64ImageResidualRisk = rESIDUALRISK.split(",")[1];
	        	imageBytesResidualRisk = javax.xml.bind.DatatypeConverter.parseBase64Binary(base64ImageResidualRisk);
	        	
	        	base64ImageBL_IR = bl_IR.split(",")[1];
	        	imageBytesBL_IR = javax.xml.bind.DatatypeConverter.parseBase64Binary(base64ImageBL_IR);
	        	
	        	base64ImageBL_IC = bl_IC.split(",")[1];
	        	imageBytesBL_IC = javax.xml.bind.DatatypeConverter.parseBase64Binary(base64ImageBL_IC);
	        	
	        	base64ImageAssessment = aSSESSMENTWISECAT.split(",")[1];
	        	imageBytesAssessment = javax.xml.bind.DatatypeConverter.parseBase64Binary(base64ImageAssessment);
	        }
	 	    catch(Exception e) {
	 	    	//System.out.println("no image data found for risk Assessment report generation");
	 	    }
	 	    
		List<String> tabOrder = (List<String>) model.get("TABORDER");
		String filename = (String) model.get("FILENAME");
		if(!filename.isEmpty()) {
			response.setContentType("application/vnd.ms-excel");
		    response.setHeader("Content-Disposition", "attachment; fileName=\""+filename+".xlsx\"");
		}
		
		List<String> tabNames = new Vector<String>();
		if(tabOrder != null){
			tabNames = tabOrder;
		}else{
			Iterator<String> itr = model.keySet().iterator();
			while (itr.hasNext()) {
				String sheetName = itr.next();
				tabNames.add(sheetName);
			}
		}		
		
		for (String sheetName : tabNames) {
			Sheet sheet = workbook.createSheet(sheetName);
			sheet.getProtect();
			
		

			//HEADER STYLE
			CellStyle headerStyle = workbook.createCellStyle();
			headerStyle.setFillForegroundColor(IndexedColors.RED.getIndex());
			headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND); 
			Font fontHeader = workbook.createFont();
			fontHeader.setBold(true);
			fontHeader.setColor(HSSFColor.HSSFColorPredefined.WHITE.getIndex());
			headerStyle.setFont(fontHeader);
			
			//COMPONENT TITLE STYLE
			CellStyle titleStyle = workbook.createCellStyle();
			titleStyle.setFillForegroundColor(IndexedColors.YELLOW.getIndex());
			titleStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND); 
			
			//COMPONENT TITLE TOTAL BG WITH BOLD FONT STYLE
			CellStyle boldFontNoBg = workbook.createCellStyle();
			boldFontNoBg.setFillForegroundColor(IndexedColors.YELLOW.getIndex());
			boldFontNoBg.setFillPattern(FillPatternType.SOLID_FOREGROUND); 
			Font boldFont = workbook.createFont();
			boldFont.setBold(true);
			boldFontNoBg.setFont(boldFont);
			
			//TOTAL BACKGROUND STYLE
			CellStyle totalBg = workbook.createCellStyle();
			totalBg.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
			totalBg.setFillPattern(FillPatternType.SOLID_FOREGROUND); 
			
			//LOW BG STYLE
			CellStyle lowBg = workbook.createCellStyle();
			lowBg.setFillForegroundColor(IndexedColors.LIGHT_GREEN.getIndex());
			lowBg.setFillPattern(FillPatternType.SOLID_FOREGROUND);
			
			//LOW BG WITH BOLD FONT STYLE
			CellStyle lowBoldBg = workbook.createCellStyle();
			lowBoldBg.setFillForegroundColor(IndexedColors.LIGHT_GREEN.getIndex());
			lowBoldBg.setFillPattern(FillPatternType.SOLID_FOREGROUND);
			Font fontHeaderLow = workbook.createFont();
			fontHeaderLow.setBold(true);
			lowBoldBg.setFont(fontHeaderLow);
			
			//MEDIUM BG STYLE
			CellStyle mediumBg = workbook.createCellStyle();
			mediumBg.setFillForegroundColor(IndexedColors.LIGHT_YELLOW.getIndex());
			mediumBg.setFillPattern(FillPatternType.SOLID_FOREGROUND);
			
			//medium BG WITH BOLD FONT STYLE
			CellStyle mBoldBg = workbook.createCellStyle();
			mBoldBg.setFillForegroundColor(IndexedColors.LIGHT_YELLOW.getIndex());
			mBoldBg.setFillPattern(FillPatternType.SOLID_FOREGROUND);
			Font fontHeaderMed = workbook.createFont();
			fontHeaderMed.setBold(true);
			mBoldBg.setFont(fontHeaderMed);
			
			//HIGH BG STYLE
			CellStyle highBg = workbook.createCellStyle();
			highBg.setFillForegroundColor(IndexedColors.CORAL.getIndex());
			highBg.setFillPattern(FillPatternType.SOLID_FOREGROUND);
			
			//High BG WITH BOLD FONT STYLE
			CellStyle hBoldBg = workbook.createCellStyle();
			hBoldBg.setFillForegroundColor(IndexedColors.CORAL.getIndex());
			hBoldBg.setFillPattern(FillPatternType.SOLID_FOREGROUND);
			Font fontHeaderHigh = workbook.createFont();
			fontHeaderHigh.setBold(true);
			hBoldBg.setFont(fontHeaderHigh);
			
			//Bold Grey WITH BOLD FONT STYLE
			CellStyle boldGrey = workbook.createCellStyle();
			boldGrey.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
			boldGrey.setFillPattern(FillPatternType.SOLID_FOREGROUND);
			Font fontHeaderGr = workbook.createFont();
			fontHeaderGr.setBold(true);
			boldGrey.setFont(fontHeaderGr);
			
			//Bold Yellow WITH BOLD FONT STYLE
			CellStyle boldYellow = workbook.createCellStyle();
			boldYellow.setFillForegroundColor(IndexedColors.YELLOW.getIndex());
			boldYellow.setFillPattern(FillPatternType.SOLID_FOREGROUND);
			Font fontHeaderYl = workbook.createFont();
			fontHeaderYl.setBold(true);
			boldYellow.setFont(fontHeaderYl);
			
			//BOLD FONT STYLE
			CellStyle boldText = workbook.createCellStyle();
			boldText.setFillForegroundColor(IndexedColors.WHITE.getIndex());
			boldText.setFillPattern(FillPatternType.SOLID_FOREGROUND);
			Font boldT = workbook.createFont();
			boldT.setBold(true);
			boldText.setFont(boldT);
			
			//

			
			@SuppressWarnings("unchecked")
			HashMap<String, ArrayList<ArrayList<String>>> mainMap = (HashMap<String, ArrayList<ArrayList<String>>>) model
					.get(sheetName);
			ArrayList<ArrayList<String>> listResultHeader = mainMap.get("listResultHeader");
			ArrayList<ArrayList<String>> listResultData = mainMap.get("listResultData");
			
			
			if((sheet.getSheetName().equals("TREASURY") && listResultData.size() == 0) 
					|| (sheet.getSheetName().equals("RETAIL LIABILITIES") && listResultData.size() == 0) 
					|| (sheet.getSheetName().equals("RETAIL ASSETS") && listResultData.size() == 0) 
					|| (sheet.getSheetName().equals("WHOLESALE BANKING") && listResultData.size() == 0)){
				
					//System.out.println("Sheet name passes condition: "+sheet.getSheetName());		
					//System.out.println("listResultData size: "+listResultData.size());
					
					Row row;
					Cell cell;
					
					row = sheet.createRow(0);
					cell = row.createCell(0);
					cell.setCellValue("SRNO");
					cell.setCellStyle(headerStyle);
					cell = row.createCell(1);
					cell.setCellValue("CATEGORY");
					cell.setCellStyle(headerStyle);
					cell = row.createCell(2);
					cell.setCellValue("WEIGHT");
					cell.setCellStyle(headerStyle);
					cell = row.createCell(3);
					cell.setCellValue("SCORE");
					cell.setCellStyle(headerStyle);
					cell = row.createCell(4);
					cell.setCellValue("RESULT");
					cell.setCellStyle(headerStyle);
					
					row = sheet.createRow(1);
					cell = row.createCell(0);
					cell.setCellValue("");
					cell.setCellStyle(titleStyle);
					cell = row.createCell(1);
					cell.setCellValue("Inherent Risk");
					cell.setCellStyle(titleStyle);
					cell = row.createCell(2);
					cell.setCellValue("");
					cell.setCellStyle(titleStyle);
					cell = row.createCell(3);
					cell.setCellValue("0");
					cell.setCellStyle(boldGrey);
					cell = row.createCell(4);
					cell.setCellValue("LOW");
					cell.setCellStyle(lowBoldBg);
					
					row = sheet.createRow(2);
					cell = row.createCell(0);
					cell.setCellValue("1");
					cell = row.createCell(1);
					cell.setCellValue("customer");
					cell = row.createCell(2);
					cell.setCellValue("30%");
					cell = row.createCell(3);
					cell.setCellValue("0");
					cell = row.createCell(4);
					cell.setCellValue("LOW");
					cell.setCellStyle(lowBg);

					row = sheet.createRow(3);
					cell = row.createCell(0);
					cell.setCellValue("2");
					cell = row.createCell(1);
					cell.setCellValue("geography");
					cell = row.createCell(2);
					cell.setCellValue("25%");
					cell = row.createCell(3);
					cell.setCellValue("0");
					cell = row.createCell(4);
					cell.setCellValue("LOW");
					cell.setCellStyle(lowBg);
					
					row = sheet.createRow(4);
					cell = row.createCell(0);
					cell.setCellValue("3");
					cell = row.createCell(1);
					cell.setCellValue("products and services");
					cell = row.createCell(2);
					cell.setCellValue("25%");
					cell = row.createCell(3);
					cell.setCellValue("0");
					cell = row.createCell(4);
					cell.setCellValue("LOW");
					cell.setCellStyle(lowBg);
					
					row = sheet.createRow(5);
					cell = row.createCell(0);
					cell.setCellValue("4");
					cell = row.createCell(1);
					cell.setCellValue("transactions");
					cell = row.createCell(2);
					cell.setCellValue("10%");
					cell = row.createCell(3);
					cell.setCellValue("0");
					cell = row.createCell(4);
					cell.setCellValue("LOW");
					cell.setCellStyle(lowBg);
					
					row = sheet.createRow(6);
					cell = row.createCell(0);
					cell.setCellValue("5");
					cell = row.createCell(1);
					cell.setCellValue("delivery channels");
					cell = row.createCell(2);
					cell.setCellValue("10%");
					cell = row.createCell(3);
					cell.setCellValue("0");
					cell = row.createCell(4);
					cell.setCellValue("LOW");
					cell.setCellStyle(lowBg);
					
					row = sheet.createRow(7);
					cell = row.createCell(0);
					cell.setCellValue("");
					cell.setCellStyle(titleStyle);
					cell = row.createCell(1);
					cell.setCellValue("Internal Control");
					cell.setCellStyle(titleStyle);
					cell = row.createCell(2);
					cell.setCellValue("");
					cell.setCellStyle(titleStyle);
					cell = row.createCell(3);
					cell.setCellValue("0");
					cell.setCellStyle(boldGrey);
					cell = row.createCell(4);
					cell.setCellValue("EFFECTIVE");
					cell.setCellStyle(lowBoldBg);
					
					row = sheet.createRow(8);
					cell = row.createCell(0);
					cell.setCellValue("6");
					cell = row.createCell(1);
					cell.setCellValue("Governance & Management Oversight");
					cell = row.createCell(2);
					cell.setCellValue("10%");
					cell = row.createCell(3);
					cell.setCellValue("0");
					cell = row.createCell(4);
					cell.setCellValue("EFFECTIVE");
					cell.setCellStyle(lowBg);
					
					row = sheet.createRow(9);
					cell = row.createCell(0);
					cell.setCellValue("7");
					cell = row.createCell(1);
					cell.setCellValue("Customer Due Diligence & Risk Management");
					cell = row.createCell(2);
					cell.setCellValue("25%");
					cell = row.createCell(3);
					cell.setCellValue("0");
					cell = row.createCell(4);
					cell.setCellValue("EFFECTIVE");
					cell.setCellStyle(lowBg);
					
					row = sheet.createRow(10);
					cell = row.createCell(0);
					cell.setCellValue("8");
					cell = row.createCell(1);
					cell.setCellValue("Transactions Monitoring");
					cell = row.createCell(2);
					cell.setCellValue("10%");
					cell = row.createCell(3);
					cell.setCellValue("0");
					cell = row.createCell(4);
					cell.setCellValue("EFFECTIVE");
					cell.setCellStyle(lowBg);
					
					row = sheet.createRow(11);
					cell = row.createCell(0);
					cell.setCellValue("9");
					cell = row.createCell(1);
					cell.setCellValue("Internal Quality Assurance and Compliance Testing");
					cell = row.createCell(2);
					cell.setCellValue("10");
					cell = row.createCell(3);
					cell.setCellValue("0");
					cell = row.createCell(4);
					cell.setCellValue("EFFECTIVE");
					cell.setCellStyle(lowBg);
					
					row = sheet.createRow(12);
					cell = row.createCell(0);
					cell.setCellValue("10");
					cell = row.createCell(1);
					cell.setCellValue("Name/Sanctions Screening");
					cell = row.createCell(2);
					cell.setCellValue("10%");
					cell = row.createCell(3);
					cell.setCellValue("0");
					cell = row.createCell(4);
					cell.setCellValue("EFFECTIVE");
					cell.setCellStyle(lowBg);
					
					row = sheet.createRow(13);
					cell = row.createCell(0);
					cell.setCellValue("11");
					cell = row.createCell(1);
					cell.setCellValue("Training");
					cell = row.createCell(2);
					cell.setCellValue("15%");
					cell = row.createCell(3);
					cell.setCellValue("0");
					cell = row.createCell(4);
					cell.setCellValue("EFFECTIVE");
					cell.setCellStyle(lowBg);
					
					row = sheet.createRow(14);
					cell = row.createCell(0);
					cell.setCellValue("12");
					cell = row.createCell(1);
					cell.setCellValue("Foreign Correspondent Banking Relationships");
					cell = row.createCell(2);
					cell.setCellValue("5%");
					cell = row.createCell(3);
					cell.setCellValue("0");
					cell = row.createCell(4);
					cell.setCellValue("EFFECTIVE");
					cell.setCellStyle(lowBg);
					
					row = sheet.createRow(15);
					cell = row.createCell(0);
					cell.setCellValue("13");
					cell = row.createCell(1);
					cell.setCellValue("Internal Audit");
					cell = row.createCell(2);
					cell.setCellValue("10%");
					cell = row.createCell(3);
					cell.setCellValue("0");
					cell = row.createCell(4);
					cell.setCellValue("EFFECTIVE");
					cell.setCellStyle(lowBg);
					
					row = sheet.createRow(16);
					cell = row.createCell(0);
					cell.setCellValue("14");
					cell = row.createCell(1);
					cell.setCellValue("Reporting Requirements");
					cell = row.createCell(2);
					cell.setCellValue("5%");
					cell = row.createCell(3);
					cell.setCellValue("0");
					cell = row.createCell(4);
					cell.setCellValue("EFEECTIVE");
					cell.setCellStyle(lowBg);
					
					
					
					
					int noOfColumns = sheet.getRow(0).getLastCellNum();
					try {
			
				 		InputStream baseimageDefaulValue = new FileInputStream("C:\\APPFOLDER\\resources\\CM_MatrixHeatChart\\AssessmentWise\\ResidualRisk.png");
				 		byte[] bytesDefaultValue = IOUtils.toByteArray(baseimageDefaulValue);
				 		int pictureDefaultValue = workbook.addPicture(bytesDefaultValue, Workbook.PICTURE_TYPE_PNG);
				 		
				 		//chart
				 		int pictureDefaultValueChart = workbook.addPicture(imageBytesDefaultValueChart, Workbook.PICTURE_TYPE_PNG);
				 		 
				 		CreationHelper helper = workbook.getCreationHelper();
				 		
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				 		Drawing drawingDefaultValue = sheet.createDrawingPatriarch();
				 		ClientAnchor anchorBaseDefaultValue = helper.createClientAnchor();		 		
				 		ClientAnchor anchorChartDefaultValue = helper.createClientAnchor();		 		
				 		//base image 
				 			anchorBaseDefaultValue.setCol1(noOfColumns+6);
				 			anchorBaseDefaultValue.setRow1(1);
				 			anchorBaseDefaultValue.setCol2(noOfColumns+11);
				 			anchorBaseDefaultValue.setRow2(11); 
						   //CHART IMAGE
				 			anchorChartDefaultValue.setCol1(noOfColumns+7);
				 			anchorChartDefaultValue.setRow1(2); 
				 			anchorChartDefaultValue.setCol2(noOfColumns+11);
				 			anchorChartDefaultValue.setRow2(10); 				   
				 		 //Creates a picture
				 			anchorBaseDefaultValue.setAnchorType(AnchorType.DONT_MOVE_AND_RESIZE);//set anchor type
				 			anchorChartDefaultValue.setAnchorType(ClientAnchor.AnchorType.DONT_MOVE_AND_RESIZE);
						 
						 
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				 		 Picture createBaseDefaultValue = drawingDefaultValue.createPicture(anchorBaseDefaultValue, pictureDefaultValue);
				 		 Picture createChartDefaultValue = drawingDefaultValue.createPicture(anchorChartDefaultValue, pictureDefaultValueChart);

					}
					catch(Exception e) {
						e.printStackTrace();
					}
								

			}
			
		else{
			
			///////////////////////
			if((sheet.getSheetName().equals("TREASURY") && listResultData.size() != 0) 
					|| (sheet.getSheetName().equals("RETAIL LIABILITIES") && listResultData.size() != 0) 
					|| (sheet.getSheetName().equals("RETAIL ASSETS") && listResultData.size() != 0) 
					|| (sheet.getSheetName().equals("WHOLESALE BANKING") && listResultData.size() != 0)){

			
			//System.out.println("Sheet name NOT passes condition: "+sheet.getSheetName());
			
			
			//System.out.println("listResultData size: "+listResultData.size());

			String[] l_Headers = {};
			for (ArrayList<String> listHeader : listResultHeader) {
				l_Headers = new String[listHeader.size()];
				for (int i = 0; i < listHeader.size(); i++) {
					l_Headers[i] = listHeader.get(i);
				}
			}

			//sheet.setDefaultColumnWidth((int) l_Headers.length);

			int currentRow = 1;
			Row row;
			Cell cell;
			
			
			
			row = sheet.createRow(1);
			cell = row.createCell(0);
			cell.setCellValue("");
			cell.setCellStyle(titleStyle);
			cell = row.createCell(1);
			cell.setCellValue("Inherent Risk");
			cell.setCellStyle(titleStyle);
			cell = row.createCell(2);
			cell.setCellValue("");
			cell.setCellStyle(titleStyle);
			
			//sheet.getSheetName().equals("RETAIL LIABILITIES") sheet.getSheetName().equals("RETAIL ASSETS") sheet.getSheetName().equals("WHOLESALE BANKING")
			
			if(sheet.getSheetName().equals("TREASURY")){  
			cell = row.createCell(3);
			cell.setCellValue(s_TotalTresuryIR);
			cell.setCellStyle(boldGrey);			
			cell = row.createCell(4);
			cell.setCellValue(s_TotalTresuryIR);
			cell.setCellStyle(titleStyle);	
			}
			
			if(sheet.getSheetName().equals("RETAIL LIABILITIES")){  
			cell = row.createCell(3);
			cell.setCellValue(s_TotalRetailLiabiltiesIR);
			cell.setCellStyle(boldGrey);			
			cell = row.createCell(4);
			cell.setCellValue(s_TotalRetailLiabiltiesIR);
			cell.setCellStyle(titleStyle);	
			}
			
			if(sheet.getSheetName().equals("RETAIL ASSETS")){  
			cell = row.createCell(3);
			cell.setCellValue(s_TotalRetailAssetsIR);
			cell.setCellStyle(boldGrey);			
			cell = row.createCell(4);
			cell.setCellValue(s_TotalRetailAssetsIR);
			cell.setCellStyle(titleStyle);	
			}
			
			if(sheet.getSheetName().equals("WHOLESALE BANKING")){  
			cell = row.createCell(3);
			cell.setCellValue(s_TotalWholesaleIR);
			cell.setCellStyle(boldGrey);			
			cell = row.createCell(4);
			cell.setCellValue(s_TotalWholesaleIR);
			cell.setCellStyle(titleStyle);	
			}
			
			
			

			for (int i = 0; i < l_Headers.length; i++) {
				Cell header0 = getCell(sheet, 0, i);
				setText(header0, l_Headers[i]);
				header0.setCellStyle(headerStyle);
			}
			
			

			for (ArrayList<String> listResult : listResultData) {
				currentRow++;
				row = sheet.createRow(currentRow);
				
				int currentCol = 0;
				for (String strResult : listResult) {
					
					
					if(currentRow == 6){
						currentRow++;
						Row row1 = sheet.createRow(currentRow);
						cell = row1.createCell(0);
						cell.setCellValue("");
						cell.setCellStyle(titleStyle);
						cell = row1.createCell(1);
						cell.setCellValue("Internal Control");
						cell.setCellStyle(titleStyle);
						cell = row1.createCell(2);
						cell.setCellValue("");
						cell.setCellStyle(titleStyle);
						
						if(sheet.getSheetName().equals("TREASURY")){  
						cell = row1.createCell(3);
						cell.setCellValue(s_TotalTresuryIC);
						cell.setCellStyle(boldGrey);			
						cell = row1.createCell(4);
						cell.setCellValue(s_TotalTresuryIC);
						cell.setCellStyle(titleStyle);	
						}
							
						if(sheet.getSheetName().equals("RETAIL LIABILITIES")){  
						cell = row1.createCell(3);
						cell.setCellValue(s_totalRetailLiabiltiesIC);
						cell.setCellStyle(boldGrey);			
						cell = row1.createCell(4);
						cell.setCellValue(s_totalRetailLiabiltiesIC);
						cell.setCellStyle(titleStyle);	
						}
							
						if(sheet.getSheetName().equals("RETAIL ASSETS")){  
						cell = row1.createCell(3);
						cell.setCellValue(s_TotalRetailAssetsIC);
						cell.setCellStyle(boldGrey);			
						cell = row1.createCell(4);
						cell.setCellValue(s_TotalRetailAssetsIC);
						cell.setCellStyle(titleStyle);	
						}
							
						if(sheet.getSheetName().equals("WHOLESALE BANKING")){  
						cell = row1.createCell(3);
						cell.setCellValue(s_TotalWholesaleIC);
						cell.setCellStyle(boldGrey);			
						cell = row1.createCell(4);
						cell.setCellValue(s_TotalWholesaleIC);
						cell.setCellStyle(titleStyle);	
						}
						
					}
										
					row.createCell(currentCol).setCellValue(strResult);
					currentCol++;
				}
				
			}
			
			int noOfColumns = sheet.getRow(0).getLastCellNum();

			
            for (int i = 1; i == 1 ; i++) {
					row = sheet.getRow(i);
    				System.out.println("inside first row");
    			for(int j = 0; j < noOfColumns; j++){
    				if(j == 4){
    					cell = row.getCell(j);
   					
    					// ***** TO CONVERT CELL INTO DOUBLE FIRST CONVERT INTO STRING THEN CONVERT INTO DOUBLE *****
    					double cellData = Double.parseDouble(cell.toString());

    					if(cellData <= 2){
    						cell.setCellValue("LOW");
    						cell.setCellStyle(lowBoldBg);
    					}
    					else if(cellData > 2 && cellData <= 5){
    						cell.setCellValue("MEDIUM");
    						cell.setCellStyle(mBoldBg);
    					}
    					else{
    						cell.setCellValue("HIGH");
    						cell.setCellStyle(hBoldBg);
    					}
    				}       				
    			}           			
    		}
            
            for (int i = 7; i == 7 ; i++) {
					row = sheet.getRow(i);
    				System.out.println("inside first row");
    			for(int j = 0; j < noOfColumns; j++){
    				if(j == 4){
    					cell = row.getCell(j);
   					
    					// ***** TO CONVERT CELL INTO DOUBLE FIRST CONVERT INTO STRING THEN CONVERT INTO DOUBLE *****
    					double cellData = Double.parseDouble(cell.toString());

    					if(cellData <= 2){
    						cell.setCellValue("EFFECTIVE");
    						cell.setCellStyle(lowBoldBg);
    					}
    					else if(cellData > 2 && cellData <= 5){
    						cell.setCellValue("NEED IMPROVEMENT");
    						cell.setCellStyle(mBoldBg);
    					}
    					else{
    						cell.setCellValue("NO CONTROL");
    						cell.setCellStyle(hBoldBg);
    					}
    				}       				
    			}           			
    		}
						
            for (int i = 2; i <= 6 ; i++) {
    			row = sheet.getRow(i);
    			for(int j = 0; j < noOfColumns; j++){
    				if(j == 4){
    					cell = row.getCell(j);

    					if(cell.getStringCellValue().equals("LOW")){
    						cell.setCellStyle(lowBg);
    					}
    					else if(cell.getStringCellValue().equals("MEDIUM")){
    						cell.setCellStyle(mediumBg);
    					}
    					else{
    						cell.setCellStyle(highBg);
    					}

    				}
    				
    			}           			
    		}
    
    		
    for (int i = 8; i <= 16 ; i++) {
		row = sheet.getRow(i);
		for(int j = 0; j < noOfColumns; j++){
			if(j == 4){
				cell = row.getCell(j);

				if(cell.getStringCellValue().equals("LOW")){
					cell.setCellValue("EFFECTIVE");
					cell.setCellStyle(lowBg);
				}
				else if(cell.getStringCellValue().equals("MEDIUM")){
					cell.setCellValue("NEED IMPROVEMENT");
					cell.setCellStyle(mediumBg);
				}
				else{
					cell.setCellValue("NO CONTROL");
					cell.setCellStyle(highBg);
				}

			}
			
		}           			
	}			
			
	int totalRows=currentRow;
			
	try {
				
		if(sheet.getSheetName().equals("TREASURY")){
		 	InputStream baseimageResidualRisk = new FileInputStream("C:\\APPFOLDER\\resources\\CM_MatrixHeatChart\\AssessmentWise\\ResidualRisk.png");
		 	byte[] bytesResidualRisk = IOUtils.toByteArray(baseimageResidualRisk);
			int pictureResidualRiskBase = workbook.addPicture(bytesResidualRisk, Workbook.PICTURE_TYPE_PNG);		 		
	 		//chart
		 	int pictureT_ResidualRiskChart = workbook.addPicture(imageBytesT_ResidualRisk, Workbook.PICTURE_TYPE_PNG);		 		 
		 	CreationHelper helper = workbook.getCreationHelper();		 		
			Drawing drawingResidualRisk = sheet.createDrawingPatriarch();
	 		ClientAnchor anchorBaseResidualRisk = helper.createClientAnchor();		 		
	 		ClientAnchor anchorChartResidualRisk = helper.createClientAnchor();		 		
	 		//base image 
	 		   anchorBaseResidualRisk.setCol1(noOfColumns+6);
			   anchorBaseResidualRisk.setRow1(1);
			   anchorBaseResidualRisk.setCol2(noOfColumns+11);
			   anchorBaseResidualRisk.setRow2(11); 
			   //CHART IMAGE
			   anchorChartResidualRisk.setCol1(noOfColumns+7);
			   anchorChartResidualRisk.setRow1(2); 
			   anchorChartResidualRisk.setCol2(noOfColumns+11);
			   anchorChartResidualRisk.setRow2(10); 				   
	 		 //Creates a picture
			 anchorBaseResidualRisk.setAnchorType(AnchorType.DONT_MOVE_AND_RESIZE);//set anchor type
			 anchorChartResidualRisk.setAnchorType(ClientAnchor.AnchorType.DONT_MOVE_AND_RESIZE);				 

			 Picture createBaseResidualRisk = drawingResidualRisk.createPicture(anchorBaseResidualRisk, pictureResidualRiskBase);
		 	 Picture createChartResidualRisk = drawingResidualRisk.createPicture(anchorChartResidualRisk, pictureT_ResidualRiskChart);
			}
		
		if(sheet.getSheetName().equals("RETAIL LIABILITIES")){
		 	InputStream baseimageResidualRisk = new FileInputStream("C:\\APPFOLDER\\resources\\CM_MatrixHeatChart\\AssessmentWise\\ResidualRisk.png");
		 	byte[] bytesResidualRisk = IOUtils.toByteArray(baseimageResidualRisk);
			int pictureResidualRiskBase = workbook.addPicture(bytesResidualRisk, Workbook.PICTURE_TYPE_PNG);		 		
	 		//chart
		 	int pictureRL_ResidualRiskChart = workbook.addPicture(imageBytesRL_ResidualRisk, Workbook.PICTURE_TYPE_PNG);		 		 
		 	CreationHelper helper = workbook.getCreationHelper();		 		
			Drawing drawingResidualRisk = sheet.createDrawingPatriarch();
	 		ClientAnchor anchorBaseResidualRisk = helper.createClientAnchor();		 		
	 		ClientAnchor anchorChartResidualRisk = helper.createClientAnchor();		 		
	 		//base image 
	 		   anchorBaseResidualRisk.setCol1(noOfColumns+6);
			   anchorBaseResidualRisk.setRow1(1);
			   anchorBaseResidualRisk.setCol2(noOfColumns+11);
			   anchorBaseResidualRisk.setRow2(11); 
			   //CHART IMAGE
			   anchorChartResidualRisk.setCol1(noOfColumns+7);
			   anchorChartResidualRisk.setRow1(2); 
			   anchorChartResidualRisk.setCol2(noOfColumns+11);
			   anchorChartResidualRisk.setRow2(10); 				   
	 		 //Creates a picture
			 anchorBaseResidualRisk.setAnchorType(AnchorType.DONT_MOVE_AND_RESIZE);//set anchor type
			 anchorChartResidualRisk.setAnchorType(ClientAnchor.AnchorType.DONT_MOVE_AND_RESIZE);				 

			 Picture createBaseResidualRisk = drawingResidualRisk.createPicture(anchorBaseResidualRisk, pictureResidualRiskBase);
		 	 Picture createChartResidualRisk = drawingResidualRisk.createPicture(anchorChartResidualRisk, pictureRL_ResidualRiskChart);
			}
		
		if(sheet.getSheetName().equals("RETAIL ASSETS")){
		 	InputStream baseimageResidualRisk = new FileInputStream("C:\\APPFOLDER\\resources\\CM_MatrixHeatChart\\AssessmentWise\\ResidualRisk.png");
		 	byte[] bytesResidualRisk = IOUtils.toByteArray(baseimageResidualRisk);
			int pictureResidualRiskBase = workbook.addPicture(bytesResidualRisk, Workbook.PICTURE_TYPE_PNG);		 		
	 		//chart
		 	int pictureRA_ResidualRiskChart = workbook.addPicture(imageBytesRA_ResidualRisk, Workbook.PICTURE_TYPE_PNG);		 		 
		 	CreationHelper helper = workbook.getCreationHelper();		 		
			Drawing drawingResidualRisk = sheet.createDrawingPatriarch();
	 		ClientAnchor anchorBaseResidualRisk = helper.createClientAnchor();		 		
	 		ClientAnchor anchorChartResidualRisk = helper.createClientAnchor();		 		
	 		//base image 
	 		   anchorBaseResidualRisk.setCol1(noOfColumns+6);
			   anchorBaseResidualRisk.setRow1(1);
			   anchorBaseResidualRisk.setCol2(noOfColumns+11);
			   anchorBaseResidualRisk.setRow2(11); 
			   //CHART IMAGE
			   anchorChartResidualRisk.setCol1(noOfColumns+7);
			   anchorChartResidualRisk.setRow1(2); 
			   anchorChartResidualRisk.setCol2(noOfColumns+11);
			   anchorChartResidualRisk.setRow2(10); 				   
	 		 //Creates a picture
			 anchorBaseResidualRisk.setAnchorType(AnchorType.DONT_MOVE_AND_RESIZE);//set anchor type
			 anchorChartResidualRisk.setAnchorType(ClientAnchor.AnchorType.DONT_MOVE_AND_RESIZE);				 

			 Picture createBaseResidualRisk = drawingResidualRisk.createPicture(anchorBaseResidualRisk, pictureResidualRiskBase);
		 	 Picture createChartResidualRisk = drawingResidualRisk.createPicture(anchorChartResidualRisk, pictureRA_ResidualRiskChart);
			}
		
		if(sheet.getSheetName().equals("WHOLESALE BANKING")){
		 	InputStream baseimageResidualRisk = new FileInputStream("C:\\APPFOLDER\\resources\\CM_MatrixHeatChart\\AssessmentWise\\ResidualRisk.png");
		 	byte[] bytesResidualRisk = IOUtils.toByteArray(baseimageResidualRisk);
			int pictureResidualRiskBase = workbook.addPicture(bytesResidualRisk, Workbook.PICTURE_TYPE_PNG);		 		
	 		//chart
		 	int pictureWB_ResidualRiskChart = workbook.addPicture(imageBytesWB_ResidualRisk, Workbook.PICTURE_TYPE_PNG);		 		 
		 	CreationHelper helper = workbook.getCreationHelper();		 		
			Drawing drawingResidualRisk = sheet.createDrawingPatriarch();
	 		ClientAnchor anchorBaseResidualRisk = helper.createClientAnchor();		 		
	 		ClientAnchor anchorChartResidualRisk = helper.createClientAnchor();		 		
	 		//base image 
	 		   anchorBaseResidualRisk.setCol1(noOfColumns+6);
			   anchorBaseResidualRisk.setRow1(1);
			   anchorBaseResidualRisk.setCol2(noOfColumns+11);
			   anchorBaseResidualRisk.setRow2(11); 
			   //CHART IMAGE
			   anchorChartResidualRisk.setCol1(noOfColumns+7);
			   anchorChartResidualRisk.setRow1(2); 
			   anchorChartResidualRisk.setCol2(noOfColumns+11);
			   anchorChartResidualRisk.setRow2(10); 				   
	 		 //Creates a picture
			 anchorBaseResidualRisk.setAnchorType(AnchorType.DONT_MOVE_AND_RESIZE);//set anchor type
			 anchorChartResidualRisk.setAnchorType(ClientAnchor.AnchorType.DONT_MOVE_AND_RESIZE);				 

			 Picture createBaseResidualRisk = drawingResidualRisk.createPicture(anchorBaseResidualRisk, pictureResidualRiskBase);
		 	 Picture createChartResidualRisk = drawingResidualRisk.createPicture(anchorChartResidualRisk, pictureWB_ResidualRiskChart);
			}
		}
			
		catch(Exception e) 
		{
			e.printStackTrace();	
		}
	 		
		  		
	}
			
			
			if(sheet.getSheetName().equals("RISK ASSESSMENT SUMMARY")){


				
				//System.out.println("Sheet name NOT passes condition: "+sheet.getSheetName());
				
				
				//System.out.println("listResultData size: "+listResultData.size());

				String[] l_Headers = {};
				for (ArrayList<String> listHeader : listResultHeader) {
					l_Headers = new String[listHeader.size()];
					for (int i = 0; i < listHeader.size(); i++) {
						l_Headers[i] = listHeader.get(i);
					}
				}

				//sheet.setDefaultColumnWidth((int) l_Headers.length);

				int currentRow = 2;
				Row row;
				Cell cell;
				
					
				row = sheet.createRow(0);
				cell = row.createCell(0);
				cell.setCellValue("SrNo");
				cell.setCellStyle(headerStyle);
				cell = row.createCell(1);
				cell.setCellValue("Risk Factor / Risk Component");
				cell.setCellStyle(headerStyle);
				cell = row.createCell(2);
				cell.setCellValue("Weight");
				cell.setCellStyle(headerStyle);
				
				cell = row.createCell(3);
				cell.setCellValue("Tresury");
				cell.setCellStyle(headerStyle);
				sheet.addMergedRegion(new CellRangeAddress(0, 0, 3, 4));
				
				cell = row.createCell(5);
				cell.setCellValue("Retail Liabilities");
				cell.setCellStyle(headerStyle);
				sheet.addMergedRegion(new CellRangeAddress(0, 0, 5, 6));
				
				cell = row.createCell(7);
				cell.setCellValue("Retail Assets");
				cell.setCellStyle(headerStyle);
				sheet.addMergedRegion(new CellRangeAddress(0, 0, 7, 8));
				
				cell = row.createCell(9);
				cell.setCellValue("Wholesale");
				cell.setCellStyle(headerStyle);
				
				
				cell = row.createCell(10);
				cell.setCellValue("Banking");
				cell.setCellStyle(headerStyle);
				//sheet.addMergedRegion(new CellRangeAddress(0, 0, 9, 10));
				
				
				

				for (int i = 0; i < l_Headers.length; i++) {
					Cell header0 = getCell(sheet, 1, i);
					setText(header0, l_Headers[i]);
					header0.setCellStyle(headerStyle);
				}
				
				
				int noOfColumns = sheet.getRow(0).getLastCellNum();
				

	            for (int i = 1; i == 1 ; i++) {
	            			row = sheet.getRow(i);
	            			for(int j = 0; j < noOfColumns; j++){
	            				//if(j == 4 || j == 6 || j == 8 || j == 10){
	            					cell = row.getCell(j);
	            					//System.out.println("INSIDE HEADER!!");

	            					if(cell.getStringCellValue().equals("SRNO")){
	            						cell.setCellValue("");
	            						cell.setCellStyle(headerStyle);
	            					}
	            					if(cell.getStringCellValue().equals("CATEGORY")){
	            						cell.setCellValue("");
	            						cell.setCellStyle(headerStyle);
	            					}
	            					if(cell.getStringCellValue().equals("WEIGHT")){
	            						cell.setCellValue("");
	            						cell.setCellStyle(headerStyle);
	            					}	            					
	            					if(cell.getStringCellValue().equals("T_SCORE") || cell.getStringCellValue().equals("RA_SCORE") || 
	            							cell.getStringCellValue().equals("RL_SCORE") || cell.getStringCellValue().equals("WB_SCORE")){
	            						cell.setCellValue("Score");
	            						cell.setCellStyle(titleStyle);
	            					}
	            					if(cell.getStringCellValue().equals("T_RESULT") || cell.getStringCellValue().equals("RA_RESULT") || 
	            							cell.getStringCellValue().equals("RL_RESULT") || cell.getStringCellValue().equals("WB_RESULT")){
	            						cell.setCellValue("Result");
	            						cell.setCellStyle(titleStyle);
	            					}
	            					
	            					
	            					

	            				//}
	            				
	            			}           			
	            		}
				
				
				
				
				row = sheet.createRow(2);
				cell = row.createCell(0);
				cell.setCellValue("");
				cell.setCellStyle(titleStyle);
				cell = row.createCell(1);
				cell.setCellValue("Inherent Risk");
				cell.setCellStyle(boldYellow);
				cell = row.createCell(2);
				cell.setCellValue("");
				cell.setCellStyle(titleStyle);
				cell = row.createCell(3);
				cell.setCellValue(s_TotalTresuryIR);
				cell.setCellStyle(boldGrey);
				cell = row.createCell(4);
				cell.setCellValue(s_TotalTresuryIR);
				cell.setCellStyle(totalBg);
				cell = row.createCell(5);
				cell.setCellValue(s_TotalRetailLiabiltiesIR);
				cell.setCellStyle(boldGrey);
				cell = row.createCell(6);
				cell.setCellValue(s_TotalRetailLiabiltiesIR);
				cell.setCellStyle(totalBg);
				cell = row.createCell(7);
				cell.setCellValue(s_TotalRetailAssetsIR);
				cell.setCellStyle(boldGrey);
				cell = row.createCell(8);
				cell.setCellValue(s_TotalRetailAssetsIR);
				cell.setCellStyle(totalBg);
				cell = row.createCell(9);
				cell.setCellValue(s_TotalWholesaleIR);
				cell.setCellStyle(boldGrey);
				cell = row.createCell(10);
				cell.setCellValue(s_TotalWholesaleIR);
				cell.setCellStyle(totalBg);	
				
				double totalIR = (s_TotalTresuryIR + s_TotalRetailLiabiltiesIR + s_TotalRetailAssetsIR + s_TotalWholesaleIR)/4;
				double totalIC = (s_TotalTresuryIC + s_totalRetailLiabiltiesIC + s_TotalRetailAssetsIC + s_TotalWholesaleIC)/4;
				
				/*
				row = sheet.getRow(18);
				cell = row.createCell(1);
				cell.setCellValue("Inherent Risk:- "+totalIR);
				cell = row.createCell(4);
				//sheet.addMergedRegion(new CellRangeAddress(totalRows+2, totalRows+2, 4, 5));
				cell.setCellValue("Inherent Risk:- "+totalIR);
				*/
				

				
				

				for (ArrayList<String> listResult : listResultData) {
					currentRow++;
					row = sheet.createRow(currentRow);
					
					int currentCol = 0;
					for (String strResult : listResult) {
						
						
						if(currentRow == 7){
							currentRow++;
							Row row1 = sheet.createRow(currentRow);
							cell = row1.createCell(0);
							cell.setCellValue("");
							cell.setCellStyle(titleStyle);
							cell = row1.createCell(1);
							cell.setCellValue("Internal Control");
							cell.setCellStyle(boldYellow);
							cell = row1.createCell(2);
							cell.setCellValue("");
							cell.setCellStyle(titleStyle);
							cell = row1.createCell(3);
							cell.setCellValue(s_TotalTresuryIC);
							cell.setCellStyle(boldGrey);
							cell = row1.createCell(4);
							cell.setCellValue(s_TotalTresuryIC);
							cell.setCellStyle(totalBg);
							cell = row1.createCell(5);
							cell.setCellValue(s_totalRetailLiabiltiesIC);
							cell.setCellStyle(boldGrey);
							cell = row1.createCell(6);
							cell.setCellValue(s_totalRetailLiabiltiesIC);
							cell.setCellStyle(totalBg);
							cell = row1.createCell(7);
							cell.setCellValue(s_TotalRetailAssetsIC);
							cell.setCellStyle(boldGrey);
							cell = row1.createCell(8);
							cell.setCellValue(s_TotalRetailAssetsIC);
							cell.setCellStyle(totalBg);
							cell = row1.createCell(9);
							cell.setCellValue(s_TotalWholesaleIC);
							cell.setCellStyle(boldGrey);
							cell = row1.createCell(10);
							cell.setCellValue(s_TotalWholesaleIC);
							cell.setCellStyle(totalBg);
							
						}
						
						
						
						row.createCell(currentCol).setCellValue(strResult);
						currentCol++;
					}
					
				}
				
				
				int totalRows=currentRow;
				System.out.println("totalRows: "+totalRows);
				
				row = sheet.createRow(totalRows+2);
				cell = row.createCell(1);
				cell.setCellValue("Inherent Risk: "+totalIR);
				cell.setCellStyle(boldText);
				cell = row.createCell(6);
				cell.setCellValue("Internal Control: "+totalIC);
				sheet.addMergedRegion(new CellRangeAddress(19, 19,  6, 8));
				cell.setCellStyle(boldText);
				
				
	            for (int i = 2; i == 2 ; i++) {
						row = sheet.getRow(2);
        				System.out.println("inside second row");
        			for(int j = 0; j < noOfColumns; j++){
        				if(j == 4 || j == 6 || j == 8 || j == 10){
        					cell = row.getCell(j);
       					
        					// ***** TO CONVERT CELL INTO DOUBLE FIRST CONVERT INTO STRING THEN CONVERT INTO DOUBLE *****
        					double cellData = Double.parseDouble(cell.toString());

        					if(cellData <= 2){
        						cell.setCellValue("LOW");
        						cell.setCellStyle(lowBoldBg);
        					}
        					else if(cellData > 2 && cellData <= 5){
        						cell.setCellValue("MEDIUM");
        						cell.setCellStyle(mBoldBg);
        					}
        					else{
        						cell.setCellValue("HIGH");
        						cell.setCellStyle(hBoldBg);
        					}
        				}       				
        			}           			
        		}
				
	            for (int i = 3; i <= 7 ; i++) {
        			row = sheet.getRow(i);
        			for(int j = 0; j < noOfColumns; j++){
        				if(j == 4 || j == 6 || j == 8 || j == 10){
        					cell = row.getCell(j);
       					
        					// ***** TO CONVERT CELL INTO DOUBLE FIRST CONVERT INTO STRING THEN CONVERT INTO DOUBLE *****
        					double cellData = Double.parseDouble(cell.toString());

        					if(cellData <= 2){
        						cell.setCellValue("LOW");
        						cell.setCellStyle(lowBg);
        					}
        					else if(cellData > 2 && cellData <= 5){
        						cell.setCellValue("MEDIUM");
        						cell.setCellStyle(mediumBg);
        					}
        					else{
        						cell.setCellValue("HIGH");
        						cell.setCellStyle(highBg);
        					}
        				}       				
        			}           			
        		}
	            
	            for (int i = 8; i == 8 ; i++) {
						row = sheet.getRow(i);
        				System.out.println("inside second row");
        			for(int j = 0; j < noOfColumns; j++){
        				if(j == 4 || j == 6 || j == 8 || j == 10){
        					cell = row.getCell(j);
       					
        					// ***** TO CONVERT CELL INTO DOUBLE FIRST CONVERT INTO STRING THEN CONVERT INTO DOUBLE *****
        					double cellData = Double.parseDouble(cell.toString());

        					if(cellData <= 2){
        						cell.setCellValue("EFFECTIVE");
        						cell.setCellStyle(lowBoldBg);
        					}
        					else if(cellData > 2 && cellData <= 5){
        						cell.setCellValue("NEED IMPROVEMENT");
        						cell.setCellStyle(mBoldBg);
        					}
        					else{
        						cell.setCellValue("NO CONTROL");
        						cell.setCellStyle(hBoldBg);
        					}
        				}       				
        			}           			
        		}
	            
	            
	            for (int i = 9; i <= totalRows ; i++) {
        			row = sheet.getRow(i);
        			for(int j = 0; j < noOfColumns; j++){
        				if(j == 4 || j == 6 || j == 8 || j == 10){
        					cell = row.getCell(j);
       					
        					// ***** TO CONVERT CELL INTO DOUBLE FIRST CONVERT INTO STRING THEN CONVERT INTO DOUBLE *****
        					double cellData = Double.parseDouble(cell.toString());

        					if(cellData <= 2){
        						cell.setCellValue("EFFECTIVE");
        						cell.setCellStyle(lowBg);
        					}
        					else if(cellData > 2 && cellData <= 5){
        						cell.setCellValue("NEED IMPROVEMENTS");
        						cell.setCellStyle(mediumBg);
        					}
        					else{
        						cell.setCellValue("NO CONTROL");
        						cell.setCellStyle(highBg);
        					}

        				}
        				
        			}           			
        		}
				
				
				
				/*
				
	            for (int i = 3; i <= 7 ; i++) {
        			row = sheet.getRow(i);
        			for(int j = 0; j < noOfColumns; j++){
        				if(j == 4 || j == 6 || j == 8 || j == 10){
        					cell = row.getCell(j);

        					if(cell.getStringCellValue().equals("LOW")){
        						cell.setCellStyle(lowBg);
        					}
        					else if(cell.getStringCellValue().equals("MEDIUM")){
        						cell.setCellStyle(mediumBg);
        					}
        					else{
        						cell.setCellStyle(highBg);
        					}

        				}
        				
        			}           			
        		}
	            
	            		
	            for (int i = 9; i <= 17 ; i++) {
        			row = sheet.getRow(i);
        			for(int j = 0; j < noOfColumns; j++){
        				if(j == 4 || j == 6 || j == 8 || j == 10){
        					cell = row.getCell(j);

        					if(cell.getStringCellValue().equals("LOW")){
        						cell.setCellValue("EFFECTIVE");
        						cell.setCellStyle(lowBg);
        					}
        					else if(cell.getStringCellValue().equals("MEDIUM")){
        						cell.setCellValue("NEED IMPROVEMENT");
        						cell.setCellStyle(mediumBg);
        					}
        					else{
        						cell.setCellValue("NO CONTROL");
        						cell.setCellStyle(highBg);
        					}

        				}
        				
        			}           			
        		}
				
	    		if(s_TotalTresuryIR <= 2){
	            for (int i = 2; i == 2 ; i++) {
        			row = sheet.getRow(i);       			
        			for(int j = 0; j < noOfColumns; j++){
        				if(j == 4){
        					cell = row.getCell(j);
        					cell.setCellValue("LOW");
        					cell.setCellStyle(lowBoldBg);
        					}

        				}
        				
        			}           			
        		}
	    		
	    		if(s_TotalTresuryIR > 2 && s_TotalTresuryIR <= 5){
		            for (int i = 2; i == 2 ; i++) {
	        			row = sheet.getRow(i);       			
	        			for(int j = 0; j < noOfColumns; j++){
	        				if(j == 4){
	        					cell = row.getCell(j);
	        					cell.setCellValue("MEDIUM");
	        					cell.setCellStyle(mBoldBg);
	        					}

	        				}
	        				
	        			}           			
	        		}
				
	    		if(s_TotalTresuryIR > 5){
		            for (int i = 2; i == 2 ; i++) {
	        			row = sheet.getRow(i);       			
	        			for(int j = 0; j < noOfColumns; j++){
	        				if(j == 4){
	        					cell = row.getCell(j);
	        					cell.setCellValue("HIGH");
	        					cell.setCellStyle(hBoldBg);
	        					}

	        				}
	        				
	        			}           			
	        		}
				
				
	    		if(s_TotalRetailLiabiltiesIR <= 2){
		            for (int i = 2; i == 2 ; i++) {
	        			row = sheet.getRow(i);       			
	        			for(int j = 0; j < noOfColumns; j++){
	        				if(j == 6){
	        					cell = row.getCell(j);
	        					cell.setCellValue("LOW");
	        					cell.setCellStyle(lowBg);
	        					}

	        				}
	        				
	        			}           			
	        		}
		    		
		    		if(s_TotalRetailLiabiltiesIR > 2 && s_TotalRetailLiabiltiesIR <= 5){
			            for (int i = 2; i == 2 ; i++) {
		        			row = sheet.getRow(i);       			
		        			for(int j = 0; j < noOfColumns; j++){
		        				if(j == 6){
		        					cell = row.getCell(j);
		        					cell.setCellValue("MEDIUM");
		        					cell.setCellStyle(mBoldBg);
		        					}

		        				}
		        				
		        			}           			
		        		}
					
		    		if(s_TotalRetailLiabiltiesIR > 5){
			            for (int i = 2; i == 2 ; i++) {
		        			row = sheet.getRow(i);       			
		        			for(int j = 0; j < noOfColumns; j++){
		        				if(j == 6){
		        					cell = row.getCell(j);
		        					cell.setCellValue("HIGH");
		        					cell.setCellStyle(hBoldBg);
		        					}

		        				}
		        				
		        			}           			
		        		}
		    		
		    		if(s_TotalRetailAssetsIR <= 2){
			            for (int i = 2; i == 2 ; i++) {
		        			row = sheet.getRow(i);       			
		        			for(int j = 0; j < noOfColumns; j++){
		        				if(j == 8){
		        					cell = row.getCell(j);
		        					cell.setCellValue("LOW");
		        					cell.setCellStyle(lowBoldBg);
		        					}

		        				}
		        				
		        			}           			
		        		}
			    		
			    		if(s_TotalRetailAssetsIR > 2 && s_TotalRetailAssetsIR <= 5){
				            for (int i = 2; i == 2 ; i++) {
			        			row = sheet.getRow(i);       			
			        			for(int j = 0; j < noOfColumns; j++){
			        				if(j == 8){
			        					cell = row.getCell(j);
			        					cell.setCellValue("MEDIUM");
			        					cell.setCellStyle(mBoldBg);
			        					}

			        				}
			        				
			        			}           			
			        		}
						
			    		if(s_TotalRetailAssetsIR > 5){
				            for (int i = 2; i == 2 ; i++) {
			        			row = sheet.getRow(i);       			
			        			for(int j = 0; j < noOfColumns; j++){
			        				if(j == 8){
			        					cell = row.getCell(j);
			        					cell.setCellValue("HIGH");
			        					cell.setCellStyle(hBoldBg);
			        					}

			        				}
			        				
			        			}           			
			        		}
			    		
			    		if(s_TotalWholesaleIR <= 2){
				            for (int i = 2; i == 2 ; i++) {
			        			row = sheet.getRow(i);       			
			        			for(int j = 0; j < noOfColumns; j++){
			        				if(j == 10){
			        					cell = row.getCell(j);
			        					cell.setCellValue("LOW");
			        					cell.setCellStyle(lowBoldBg);
			        					}

			        				}
			        				
			        			}           			
			        		}
				    		
				    		if(s_TotalWholesaleIR > 2 && s_TotalWholesaleIR <= 5){
					            for (int i = 2; i == 2 ; i++) {
				        			row = sheet.getRow(i);       			
				        			for(int j = 0; j < noOfColumns; j++){
				        				if(j == 10){
				        					cell = row.getCell(j);
				        					cell.setCellValue("MEDIUM");
				        					cell.setCellStyle(mBoldBg);
				        					}

				        				}
				        				
				        			}           			
				        		}
							
				    		if(s_TotalWholesaleIR > 5){
					            for (int i = 2; i == 2 ; i++) {
				        			row = sheet.getRow(i);       			
				        			for(int j = 0; j < noOfColumns; j++){
				        				if(j == 10){
				        					cell = row.getCell(j);
				        					cell.setCellValue("HIGH");
				        					cell.setCellStyle(hBoldBg);
				        					}

				        				}
				        				
				        			}           			
				        		}
				
				
				
				    		if(s_TotalTresuryIC <= 2){
					            for (int i = 8; i == 8 ; i++) {
				        			row = sheet.getRow(i);       			
				        			for(int j = 0; j < noOfColumns; j++){
				        				if(j == 4){
				        					cell = row.getCell(j);
				        					cell.setCellValue("EFFECTIVE");
				        					cell.setCellStyle(lowBoldBg);
				        					}

				        				}
				        				
				        			}           			
				        		}
					    		
					    		if(s_TotalTresuryIC > 2 && s_TotalTresuryIC <= 5){
						            for (int i = 8; i == 8 ; i++) {
					        			row = sheet.getRow(i);       			
					        			for(int j = 0; j < noOfColumns; j++){
					        				if(j == 4){
					        					cell = row.getCell(j);
					        					cell.setCellValue("NEED IMPROVEMENT");
					        					cell.setCellStyle(mBoldBg);
					        					}

					        				}
					        				
					        			}           			
					        		}
								
					    		if(s_TotalTresuryIC > 5){
						            for (int i = 8; i == 8 ; i++) {
					        			row = sheet.getRow(i);       			
					        			for(int j = 0; j < noOfColumns; j++){
					        				if(j == 4){
					        					cell = row.getCell(j);
					        					cell.setCellValue("NO CONTROL");
					        					cell.setCellStyle(hBoldBg);
					        					}

					        				}
					        				
					        			}           			
					        		}
								
								
					    		if(s_totalRetailLiabiltiesIC <= 2){
						            for (int i = 8; i == 8 ; i++) {
					        			row = sheet.getRow(i);       			
					        			for(int j = 0; j < noOfColumns; j++){
					        				if(j == 6){
					        					cell = row.getCell(j);
					        					cell.setCellValue("EFFECTIVE");
					        					cell.setCellStyle(lowBoldBg);
					        					}

					        				}
					        				
					        			}           			
					        		}
						    		
						    		if(s_totalRetailLiabiltiesIC > 2 && s_totalRetailLiabiltiesIC <= 5){
							            for (int i = 8; i == 8 ; i++) {
						        			row = sheet.getRow(i);       			
						        			for(int j = 0; j < noOfColumns; j++){
						        				if(j == 6){
						        					cell = row.getCell(j);
						        					cell.setCellValue("NEED IMPROVEMENT");
						        					cell.setCellStyle(mBoldBg);
						        					}

						        				}
						        				
						        			}           			
						        		}
									
						    		if(s_totalRetailLiabiltiesIC > 5){
							            for (int i = 8; i == 8 ; i++) {
						        			row = sheet.getRow(i);       			
						        			for(int j = 0; j < noOfColumns; j++){
						        				if(j == 6){
						        					cell = row.getCell(j);
						        					cell.setCellValue("NO CONTROL");
						        					cell.setCellStyle(hBoldBg);
						        					}

						        				}
						        				
						        			}           			
						        		}
						    		
						    		if(s_TotalRetailAssetsIC <= 2){
							            for (int i = 8; i == 8 ; i++) {
						        			row = sheet.getRow(i);       			
						        			for(int j = 0; j < noOfColumns; j++){
						        				if(j == 8){
						        					cell = row.getCell(j);
						        					cell.setCellValue("EFFECTIVE");
						        					cell.setCellStyle(lowBoldBg);
						        					}

						        				}
						        				
						        			}           			
						        		}
							    		
							    		if(s_TotalRetailAssetsIC > 2 && s_TotalRetailAssetsIC <= 5){
								            for (int i = 8; i == 8 ; i++) {
							        			row = sheet.getRow(i);       			
							        			for(int j = 0; j < noOfColumns; j++){
							        				if(j == 8){
							        					cell = row.getCell(j);
							        					cell.setCellValue("NEED IMPROVEMENT");
							        					cell.setCellStyle(mBoldBg);
							        					}

							        				}
							        				
							        			}           			
							        		}
										
							    		if(s_TotalRetailAssetsIC > 5){
								            for (int i = 8; i == 8 ; i++) {
							        			row = sheet.getRow(i);       			
							        			for(int j = 0; j < noOfColumns; j++){
							        				if(j == 8){
							        					cell = row.getCell(j);
							        					cell.setCellValue("NO CONTROL");
							        					cell.setCellStyle(hBoldBg);
							        					}

							        				}
							        				
							        			}           			
							        		}
							    		
							    		if(s_TotalWholesaleIC <= 2){
								            for (int i = 8; i == 8 ; i++) {
							        			row = sheet.getRow(i);       			
							        			for(int j = 0; j < noOfColumns; j++){
							        				if(j == 10){
							        					cell = row.getCell(j);
							        					cell.setCellValue("EFFECTIVE");
							        					cell.setCellStyle(lowBoldBg);
							        					}

							        				}
							        				
							        			}           			
							        		}
								    		
								    		if(s_TotalWholesaleIC > 2 && s_TotalWholesaleIC <= 5){
									            for (int i = 8; i == 8 ; i++) {
								        			row = sheet.getRow(i);       			
								        			for(int j = 0; j < noOfColumns; j++){
								        				if(j == 10){
								        					cell = row.getCell(j);
								        					cell.setCellValue("NEED IMPROVEMENT");
								        					cell.setCellStyle(mBoldBg);
								        					}

								        				}
								        				
								        			}           			
								        		}
											
								    		if(s_TotalWholesaleIC > 5){
									            for (int i = 8; i == 8 ; i++) {
								        			row = sheet.getRow(i);       			
								        			for(int j = 0; j < noOfColumns; j++){
								        				if(j == 10){
								        					cell = row.getCell(j);
								        					cell.setCellValue("NO CONTROL");
								        					cell.setCellStyle(hBoldBg);
								        					}

								        				}
								        				
								        			}           			
								        		}
				*/

				
				
				
				try {
					
					InputStream baseBL_IR = new FileInputStream("C:\\APPFOLDER\\resources\\CM_MatrixHeatChart\\AssessmentWise\\BankLevel_IR.png");
			 		byte[] bytesBL_IR = IOUtils.toByteArray(baseBL_IR);
			 		int pictureBL_IR_Base = workbook.addPicture(bytesBL_IR, Workbook.PICTURE_TYPE_PNG);
			 		
			 		InputStream baseBL_IC = new FileInputStream("C:\\APPFOLDER\\resources\\CM_MatrixHeatChart\\AssessmentWise\\BankLevel_IC.png");
			 		byte[] bytesBL_IC = IOUtils.toByteArray(baseBL_IC);
			 		int pictureBL_IC_Base = workbook.addPicture(bytesBL_IC, Workbook.PICTURE_TYPE_PNG);

			 		InputStream baseimageResidualRisk = new FileInputStream("C:\\APPFOLDER\\resources\\CM_MatrixHeatChart\\AssessmentWise\\S_BL_ResidualRisk.png");
			 		byte[] bytesResidualRisk = IOUtils.toByteArray(baseimageResidualRisk);
			 		int pictureResidualRiskBase = workbook.addPicture(bytesResidualRisk, Workbook.PICTURE_TYPE_PNG);
			 		
			 		InputStream baseimageAssessment = new FileInputStream("C:\\APPFOLDER\\resources\\CM_MatrixHeatChart\\AssessmentWise\\S_AssessmentWiseUnitLevelResidualRisk_og.png");
			 		byte[] bytesAssessment = IOUtils.toByteArray(baseimageAssessment);
			 		int pictureAssessmentBase = workbook.addPicture(bytesAssessment, Workbook.PICTURE_TYPE_PNG);
			 		
			 		
			 		
			 		
			 		//chart
			 		int pictureResidualRiskChart = workbook.addPicture(imageBytesResidualRisk, Workbook.PICTURE_TYPE_PNG);
			 		int pictureBL_IR = workbook.addPicture(imageBytesBL_IR, Workbook.PICTURE_TYPE_PNG);
			 		int pictureBL_IC = workbook.addPicture(imageBytesBL_IC, Workbook.PICTURE_TYPE_PNG);
			 		int pictureAssessmentChart = workbook.addPicture(imageBytesAssessment, Workbook.PICTURE_TYPE_PNG);
			 		 
			 		CreationHelper helper = workbook.getCreationHelper();
			 		
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			 		Drawing drawingResidualRisk = sheet.createDrawingPatriarch();
			 		ClientAnchor anchorBaseResidualRisk = helper.createClientAnchor();		 		
			 		ClientAnchor anchorChartResidualRisk = helper.createClientAnchor();		 		
			 		//base image 
			 		   anchorBaseResidualRisk.setCol1(1);
					   anchorBaseResidualRisk.setRow1(totalRows+4);
					   anchorBaseResidualRisk.setCol2(6);
					   anchorBaseResidualRisk.setRow2(totalRows+14); 
					   //CHART IMAGE
					   anchorChartResidualRisk.setCol1(2);
					   anchorChartResidualRisk.setRow1(totalRows+5); 
					   anchorChartResidualRisk.setCol2(6);
					   anchorChartResidualRisk.setRow2(totalRows+13); 				   
			 		 //Creates a picture
					 anchorBaseResidualRisk.setAnchorType(AnchorType.DONT_MOVE_AND_RESIZE);//set anchor type
					 anchorChartResidualRisk.setAnchorType(ClientAnchor.AnchorType.DONT_MOVE_AND_RESIZE);
					 
					 
					 ///////////////////////******************
					 
					 Drawing drawingResidualRisk1 = sheet.createDrawingPatriarch();
				 		ClientAnchor anchorBaseResidualRisk1 = helper.createClientAnchor();		 		
				 		ClientAnchor anchorChartResidualRisk1 = helper.createClientAnchor();		 		
				 		//base image 
				 		   anchorBaseResidualRisk1.setCol1(8);
						   anchorBaseResidualRisk1.setRow1(totalRows+4);
						   anchorBaseResidualRisk1.setCol2(13);
						   anchorBaseResidualRisk1.setRow2(totalRows+14); 
						   //CHART IMAGE
						   anchorChartResidualRisk1.setCol1(9);
						   anchorChartResidualRisk1.setRow1(totalRows+5); 
						   anchorChartResidualRisk1.setCol2(13);
						   anchorChartResidualRisk1.setRow2(totalRows+13); 				   
				 		 //Creates a picture
						 anchorBaseResidualRisk1.setAnchorType(AnchorType.DONT_MOVE_AND_RESIZE);//set anchor type
						 anchorChartResidualRisk1.setAnchorType(ClientAnchor.AnchorType.DONT_MOVE_AND_RESIZE);
						 
						 Drawing drawingResidualRisk2 = sheet.createDrawingPatriarch();
					 		ClientAnchor anchorBaseResidualRisk2 = helper.createClientAnchor();		 		
					 		ClientAnchor anchorChartResidualRisk2 = helper.createClientAnchor();		 		
					 		//base image 
					 		   anchorBaseResidualRisk2.setCol1(15);
							   anchorBaseResidualRisk2.setRow1(4);
							   anchorBaseResidualRisk2.setCol2(20);
							   anchorBaseResidualRisk2.setRow2(14); 
							   //CHART IMAGE
							   anchorChartResidualRisk2.setCol1(16);
							   anchorChartResidualRisk2.setRow1(5); 
							   anchorChartResidualRisk2.setCol2(20);
							   anchorChartResidualRisk2.setRow2(13); 				   
					 		 //Creates a picture
							 anchorBaseResidualRisk2.setAnchorType(AnchorType.DONT_MOVE_AND_RESIZE);//set anchor type
							 anchorChartResidualRisk2.setAnchorType(ClientAnchor.AnchorType.DONT_MOVE_AND_RESIZE);
					 
					
							 
					/////////////////////////////////////****************************		 
							 
					 
				 	Drawing drawingAssessmentWise = sheet.createDrawingPatriarch();
				 	ClientAnchor anchorBaseAssessmentWise = helper.createClientAnchor();		 		
				 	ClientAnchor anchorChartAssessmentWise = helper.createClientAnchor();		 		
				 	//base image 
				 		anchorBaseAssessmentWise.setCol1(15);
				 		anchorBaseAssessmentWise.setRow1(totalRows+4);
				 		anchorBaseAssessmentWise.setCol2(21);
				 		anchorBaseAssessmentWise.setRow2(totalRows+14); 
					//CHART IMAGE
				 		anchorChartAssessmentWise.setCol1(16);
				 		anchorChartAssessmentWise.setRow1(totalRows+5); 
				 		anchorChartAssessmentWise.setCol2(20);
				 		anchorChartAssessmentWise.setRow2(totalRows+13); 				   
				 	//Creates a picture
				 	anchorBaseAssessmentWise.setAnchorType(AnchorType.DONT_MOVE_AND_RESIZE);//set anchor type
				 	anchorChartAssessmentWise.setAnchorType(ClientAnchor.AnchorType.DONT_MOVE_AND_RESIZE);
					 
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			 		 Picture createBaseResidualRisk = drawingResidualRisk.createPicture(anchorBaseResidualRisk, pictureBL_IR_Base);
			 		 Picture createChartResidualRisk = drawingResidualRisk.createPicture(anchorChartResidualRisk, pictureBL_IR);
			 		 
			 		 
			 		 
			 		 
			 		 
			 		 Picture createBaseResidualRisk1 = drawingResidualRisk.createPicture(anchorBaseResidualRisk1, pictureBL_IC_Base);
			 		 Picture createChartResidualRisk1 = drawingResidualRisk.createPicture(anchorChartResidualRisk1, pictureBL_IC);
			 		 Picture createBaseResidualRisk2 = drawingResidualRisk.createPicture(anchorBaseResidualRisk2, pictureResidualRiskBase);
			 		 Picture createChartResidualRisk2 = drawingResidualRisk.createPicture(anchorChartResidualRisk2, pictureResidualRiskChart);
			 		 
			 		 
			 		 
			 		 
			 		 
			 		 
			 		 Picture createBaseAssessmentWise = drawingResidualRisk.createPicture(anchorBaseAssessmentWise, pictureAssessmentBase);
			 		 Picture createChartAssessmentWise = drawingResidualRisk.createPicture(anchorChartAssessmentWise, pictureAssessmentChart);
			 		//  }
				}
				catch(Exception e) {
					//System.out.println("error while inserting graph in report");
					e.printStackTrace();
				}
		 		
			  
			
				
			}
		
		
		
		
		//////////////////
		
		}
		
		}
	}
}

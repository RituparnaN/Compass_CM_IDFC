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
import org.apache.poi.ss.usermodel.ClientAnchor.AnchorType;
import org.apache.poi.util.IOUtils;
import org.apache.poi.xssf.usermodel.XSSFFont;
import org.apache.poi.xssf.usermodel.XSSFSheet;

public class MultiSheetExcelViewChartNew extends AbstractExcelView {
	
	public String imageUrl = "";
	
	
//	public MultiSheetExcelViewChart(String imageUrl) {
//		this.imageUrl = imageUrl;
//	}
	@Override
	protected void buildExcelDocument(Map<String, Object> model, Workbook workbook, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		 	String imgId=request.getParameter("imageId");
	 		System.out.println("image Id: "+imgId);
	 		String a_RESIDUALRISK = "";
	 		String a_ASSESSMENTWISECAT = "";
	 		double a_TOTALWEIGHTEDSCOREIR = 0.0;
	 		double a_TOTALWEIGHTEDSCOREIC = 0.0;
	 		String url = "jdbc:oracle:thin:@localhost:1521/XE";
	        String user = "COMAML_CM";
	        String pass = "ORACLE";
	 	        
	        Connection con = null;
	        
	        try {
	 
	            DriverManager.registerDriver(
	                new oracle.jdbc.OracleDriver());
	 
	            con = DriverManager.getConnection(url, user, pass);
	            Statement st = con.createStatement();
	            String sql = "SELECT A_RESIDUALRISK, A_ASSESSMENTWISECAT, A_TOTALWEIGHTEDSCOREIR, A_TOTALWEIGHTEDSCOREIC FROM TB_IMAGEDATA WHERE IMAGEID = '"+imgId+"'";
	            ResultSet m = st.executeQuery(sql);
	            while(m.next()) {
	            	a_RESIDUALRISK = m.getString("A_RESIDUALRISK");
	            	a_ASSESSMENTWISECAT = m.getString("A_ASSESSMENTWISECAT");
	            	a_TOTALWEIGHTEDSCOREIR = m.getDouble("A_TOTALWEIGHTEDSCOREIR");
	            	a_TOTALWEIGHTEDSCOREIC = m.getDouble("A_TOTALWEIGHTEDSCOREIC");
	            }
	            con.close();
	        }
	        catch (Exception ex) {
	            System.err.println(ex);
	        }
	        
	        String base64ImageResidualRisk = null;
	        String base64ImageAssessment = null;
	        byte[] imageBytesResidualRisk = null;
	        byte[] imageBytesAssessment = null;
	        
	        try {
	        	
	        	System.out.println("A_RESIDUALRISK: "+a_RESIDUALRISK);
	        	System.out.println("A_ASSESSMENTWISECAT: "+a_ASSESSMENTWISECAT);
	        	System.out.println("A_TOTALWEIGHTEDSCOREIR: "+a_TOTALWEIGHTEDSCOREIR);
	        	System.out.println("A_TOTALWEIGHTEDSCOREIC: "+a_TOTALWEIGHTEDSCOREIC);
	        	
	        	base64ImageResidualRisk = a_RESIDUALRISK.split(",")[1];
	        	imageBytesResidualRisk = javax.xml.bind.DatatypeConverter.parseBase64Binary(base64ImageResidualRisk);
	        	
	        	base64ImageAssessment = a_ASSESSMENTWISECAT.split(",")[1];
	        	imageBytesAssessment = javax.xml.bind.DatatypeConverter.parseBase64Binary(base64ImageAssessment);
	        }
	 	    catch(Exception e) {
	 	    	System.out.println("no image data found for risk Assessment report generation");
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
			
			//TOTAL BACKGROUND STYLE
			CellStyle totalBg = workbook.createCellStyle();
			totalBg.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
			totalBg.setFillPattern(FillPatternType.SOLID_FOREGROUND); 
			
			//LOW BG STYLE
			CellStyle lowBg = workbook.createCellStyle();
			lowBg.setFillForegroundColor(IndexedColors.LIGHT_GREEN.getIndex());
			lowBg.setFillPattern(FillPatternType.SOLID_FOREGROUND);
			
			//MEDIUM BG STYLE
			CellStyle mediumBg = workbook.createCellStyle();
			mediumBg.setFillForegroundColor(IndexedColors.LIGHT_YELLOW.getIndex());
			mediumBg.setFillPattern(FillPatternType.SOLID_FOREGROUND);
			
			//HIGH BG STYLE
			CellStyle highBg = workbook.createCellStyle();
			highBg.setFillForegroundColor(IndexedColors.CORAL.getIndex());
			highBg.setFillPattern(FillPatternType.SOLID_FOREGROUND);

			
			@SuppressWarnings("unchecked")
			HashMap<String, ArrayList<ArrayList<String>>> mainMap = (HashMap<String, ArrayList<ArrayList<String>>>) model
					.get(sheetName);
			ArrayList<ArrayList<String>> listResultHeader = mainMap.get("listResultHeader");
			ArrayList<ArrayList<String>> listResultData = mainMap.get("listResultData");

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
			cell = row.createCell(3);
			cell.setCellValue("");
			cell.setCellStyle(titleStyle);
			cell = row.createCell(4);
			cell.setCellValue("");
			cell.setCellStyle(titleStyle);
			cell = row.createCell(5);
			cell.setCellValue("");
			cell.setCellStyle(titleStyle);
			cell = row.createCell(6);
			cell.setCellValue("");
			cell.setCellStyle(titleStyle);

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
						cell = row1.createCell(3);
						cell.setCellValue("");
						cell.setCellStyle(titleStyle);
						cell = row1.createCell(4);
						cell.setCellValue("");
						cell.setCellStyle(titleStyle);
						cell = row1.createCell(5);
						cell.setCellValue("");
						cell.setCellStyle(titleStyle);
						cell = row1.createCell(6);
						cell.setCellValue("");
						cell.setCellStyle(titleStyle);
					}
					
					row.createCell(currentCol).setCellValue(strResult);
					currentCol++;
				}
				
			}
			
			int noOfColumns = sheet.getRow(0).getLastCellNum();
/*			
			for (int i = 0; i <= sheet.getLastRowNum(); i++) {
				  row = sheet.getRow(4);
				    cell = row.getCell(6);
				      System.out.println("DATA IN CELL: "+cell.getStringCellValue());
				}
			
			for (int cn = 0; cn < lastColumn; cn++) {
				  Cell c = row.getCell(cn, Row.RETURN_BLANK_AS_NULL);
				  if (c == null) {
				    // The spreadsheet is empty in this cell
				  } else {
				    // Do something useful with the cell's contents
				  }
				}*/
			
            row = sheet.getRow(4);
            cell = row.getCell(5);
            cell.setCellValue(a_TOTALWEIGHTEDSCOREIR);
            
            row = sheet.getRow(12);
            cell = row.getCell(5);
            cell.setCellValue(a_TOTALWEIGHTEDSCOREIC);
            
            
            row = sheet.getRow(4);
            cell = row.getCell(6);
            cell.setCellValue(a_TOTALWEIGHTEDSCOREIR);
           
            row = sheet.getRow(12);
            cell = row.getCell(6);
            cell.setCellValue(a_TOTALWEIGHTEDSCOREIC);
            
            
            if(a_TOTALWEIGHTEDSCOREIR <= 2){
            	for (int i = 2; i <= 6 ; i++) {
            			row = sheet.getRow(i);
            			for(int j = 0; j < noOfColumns; j++){
            				if(j == 6){
            					cell = row.getCell(j);
            					if(i == 4){
                        			cell.setCellValue("LOW");
            					}
            					else{
            						cell.setCellValue("");
            					}
                    			cell.setCellStyle(lowBg);
            				}
            				
            			}           			
            		}
            	}
            
            if(a_TOTALWEIGHTEDSCOREIR > 2 && a_TOTALWEIGHTEDSCOREIR <= 5){
            	for (int i = 2; i <= 6 ; i++) {
            			row = sheet.getRow(i);
            			for(int j = 0; j < noOfColumns; j++){
            				if(j == 6){
            					cell = row.getCell(j);
            					if(i == 4){
                        			cell.setCellValue("MEDIUM");
            					}
            					else{
            						cell.setCellValue("");
            					}
                    			cell.setCellStyle(mediumBg);
            				}
            				
            			}           			
            		}
            	}
            
            if(a_TOTALWEIGHTEDSCOREIR > 5){
            	for (int i = 2; i <= 6 ; i++) {
            			row = sheet.getRow(i);
            			for(int j = 0; j < noOfColumns; j++){
            				if(j == 6){
            					cell = row.getCell(j);
            					if(i == 4){
                        			cell.setCellValue("HIGH");
            					}
            					else{
            						cell.setCellValue("");
            					}
                    			cell.setCellStyle(highBg);
            				}
            				
            			}           			
            		}
            	}
            
            
            if(a_TOTALWEIGHTEDSCOREIC <= 2){
            	for (int i = 8; i <= 16 ; i++) {
        			row = sheet.getRow(i);
        			for(int j = 0; j < noOfColumns; j++){
        				if(j == 6){
        					cell = row.getCell(j);
        					if(i == 12){
                    			cell.setCellValue("EFFECTIVE");
        					}
        					else{
        						cell.setCellValue("");
        					}
                			cell.setCellStyle(lowBg);
        				}
        				
        			}
  			}
            }
            
            if(a_TOTALWEIGHTEDSCOREIC > 2 && a_TOTALWEIGHTEDSCOREIC <= 5){
            	for (int i = 8; i <= 16 ; i++) {
        			row = sheet.getRow(i);
        			for(int j = 0; j < noOfColumns; j++){
        				if(j == 6){
        					cell = row.getCell(j);
        					if(i == 12){
                    			cell.setCellValue("NEED IMPROVEMENT");
        					}
        					else{
        						cell.setCellValue("");
        					}
                			cell.setCellStyle(mediumBg);
        				}
        				
        			}
  			}
            }
            
            if(a_TOTALWEIGHTEDSCOREIC > 5){
            	for (int i = 8; i <= 16 ; i++) {
        			row = sheet.getRow(i);
        			for(int j = 0; j < noOfColumns; j++){
        				if(j == 6){
        					cell = row.getCell(j);
        					if(i == 12){
                    			cell.setCellValue("NO CONTROL");
        					}
        					else{
        						cell.setCellValue("");
        					}
                			cell.setCellStyle(highBg);
        				}
        				
        			}
  			}
            }
			
			
			for (int i = 2; i <= 6 ; i++) {
				  row = sheet.getRow(i);
	              cell = row.getCell(5);
	              cell.setCellStyle(totalBg);
			}
			
			for (int i = 8; i <= 16 ; i++) {
				  row = sheet.getRow(i);
	              cell = row.getCell(5);
	              cell.setCellStyle(totalBg);
			}



			
			//System.out.println("total rows: "+currentRow);
			
			int totalRows=currentRow;

			System.out.println("Total Column: "+noOfColumns);
			
			try {
				
				//if(sheet.getSheetName().equals("ASSESSSMENTWISE RISK RATING")){

		 		InputStream baseimageResidualRisk = new FileInputStream("C:\\APPFOLDER\\resources\\CM_MatrixHeatChart\\AssessmentWise\\ResidualRisk.png");
		 		byte[] bytesResidualRisk = IOUtils.toByteArray(baseimageResidualRisk);
		 		int pictureResidualRiskBase = workbook.addPicture(bytesResidualRisk, Workbook.PICTURE_TYPE_PNG);
		 		
		 		InputStream baseimageAssessment = new FileInputStream("C:\\APPFOLDER\\resources\\CM_MatrixHeatChart\\AssessmentWise\\AssessmentWiseUnitLevelResidualRisk.png");
		 		byte[] bytesAssessment = IOUtils.toByteArray(baseimageAssessment);
		 		int pictureAssessmentBase = workbook.addPicture(bytesAssessment, Workbook.PICTURE_TYPE_PNG);
		 		
		 		//chart
		 		int pictureResidualRiskChart = workbook.addPicture(imageBytesResidualRisk, Workbook.PICTURE_TYPE_PNG);
		 		int pictureAssessmentChart = workbook.addPicture(imageBytesAssessment, Workbook.PICTURE_TYPE_PNG);
		 		 
		 		CreationHelper helper = workbook.getCreationHelper();
		 		
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
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
				 
			 	Drawing drawingAssessmentWise = sheet.createDrawingPatriarch();
			 	ClientAnchor anchorBaseAssessmentWise = helper.createClientAnchor();		 		
			 	ClientAnchor anchorChartAssessmentWise = helper.createClientAnchor();		 		
			 	//base image 
			 		anchorBaseAssessmentWise.setCol1(noOfColumns+6);
			 		anchorBaseAssessmentWise.setRow1(12);
			 		anchorBaseAssessmentWise.setCol2(noOfColumns+12);
			 		anchorBaseAssessmentWise.setRow2(22); 
				//CHART IMAGE
			 		anchorChartAssessmentWise.setCol1(noOfColumns+7);
			 		anchorChartAssessmentWise.setRow1(13); 
			 		anchorChartAssessmentWise.setCol2(noOfColumns+11);
			 		anchorChartAssessmentWise.setRow2(21); 				   
			 	//Creates a picture
			 	anchorBaseAssessmentWise.setAnchorType(AnchorType.DONT_MOVE_AND_RESIZE);//set anchor type
			 	anchorChartAssessmentWise.setAnchorType(ClientAnchor.AnchorType.DONT_MOVE_AND_RESIZE);
				 
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		 		 Picture createBaseResidualRisk = drawingResidualRisk.createPicture(anchorBaseResidualRisk, pictureResidualRiskBase);
		 		 Picture createChartResidualRisk = drawingResidualRisk.createPicture(anchorChartResidualRisk, pictureResidualRiskChart);
		 		 //Picture createBaseAssessmentWise = drawingResidualRisk.createPicture(anchorBaseAssessmentWise, pictureAssessmentBase);
		 		 //Picture createChartAssessmentWise = drawingResidualRisk.createPicture(anchorChartAssessmentWise, pictureAssessmentChart);
		 		//  }
			}
			catch(Exception e) {
				System.out.println("error while inserting graph in report");
				e.printStackTrace();
			}
	 		
		}
	}
}

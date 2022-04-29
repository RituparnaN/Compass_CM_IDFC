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

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.ClientAnchor;
import org.apache.poi.ss.usermodel.CreationHelper;
import org.apache.poi.ss.usermodel.Drawing;
import org.apache.poi.ss.usermodel.Picture;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.ClientAnchor.AnchorType;
import org.apache.poi.util.IOUtils;
import org.apache.poi.xssf.usermodel.XSSFSheet;

public class MultiSheetExcelViewChart extends AbstractExcelView {
	
	public String imageUrl = "";
	
	
//	public MultiSheetExcelViewChart(String imageUrl) {
//		this.imageUrl = imageUrl;
//	}
	@Override
	protected void buildExcelDocument(Map<String, Object> model, Workbook workbook, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		 	String imgId=request.getParameter("imageId");
	 		System.out.println("image Id: "+imgId);
	 		String imageData = "";
	 		String url = "jdbc:oracle:thin:@localhost:1521/XE";
	        String user = "COMAML_CM";
	        String pass = "ORACLE";
	 
	        
	        Connection con = null;
	        
	        try {
	 
	            DriverManager.registerDriver(
	                new oracle.jdbc.OracleDriver());
	 
	            con = DriverManager.getConnection(url, user, pass);
	            Statement st = con.createStatement();
	            String sql = "SELECT IMAGEDATA FROM TB_IMAGEDATA WHERE IMAGEID = '"+imgId+"'";
	            ResultSet m = st.executeQuery(sql);
	            while(m.next()) {
	            	imageData = m.getString("IMAGEDATA");
	            }
	            con.close();
	        }
	        catch (Exception ex) {
	            System.err.println(ex);
	        }
	        
	        String base64Image = null;
	        byte[] imageBytes = null;
	        
	        try {
	        	
	        	System.out.println(imageData);
	        	
	        	base64Image = imageData.split(",")[1];
	        	imageBytes = javax.xml.bind.DatatypeConverter.parseBase64Binary(base64Image);
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
			//enable the locking features
	 	     //((XSSFSheet) sheet).enableLocking();
	 	     // fine tune the locking options (in this example we are blocking all operations on the cells: select, edit, etc.)
	 	     //((XSSFSheet) sheet).lockSelectLockedCells(true);
	 	    // ((XSSFSheet) sheet).lockSelectUnlockedCells(true);
			//System.out.println("Sheet Name: "+sheet);
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

			int currentRow = 0;

			for (int i = 0; i < l_Headers.length; i++) {
				Cell header0 = getCell(sheet, currentRow, i);
				setText(header0, l_Headers[i]);
			}

			for (ArrayList<String> listResult : listResultData) {
				currentRow++;
				Row row = sheet.createRow(currentRow);
				int currentCol = 0;
				for (String strResult : listResult) {
					row.createCell(currentCol).setCellValue(strResult);
					currentCol++;
				}
				
			}
			
			//System.out.println("total rows: "+currentRow);
			
			int totalRows=currentRow;
			
			//for (String sheetNameTest : tabNames) {
			//System.out.println("sheetNameTest="+sheetNameTest);
			//String name="RESIDUAL RISK RATING";
			//if(name.equals(sheetNameTest)) {
			//base image
			try {
				
				if(sheet.getSheetName().equals("RESIDUAL RISK RATING"))
		 		  {System.out.println("true");
		 		 InputStream baseimage = new FileInputStream("C:\\APPFOLDER\\resources\\CM_MatrixHeatChart\\HeatMap_BaseImage.png");
		 		//InputStream baseimage = new FileInputStream("C:\\Users\\kumar_comh5ib\\Downloads\\blank2.png");
		 		byte[] bytesBi = IOUtils.toByteArray(baseimage);
		 		int pictureBi = workbook.addPicture(bytesBi, Workbook.PICTURE_TYPE_PNG);
		 		//chart
		 		int pictureIdx = workbook.addPicture(imageBytes, Workbook.PICTURE_TYPE_PNG);
		 		
	
		 		
		 		//int pictureIdx1 = workbook.addPicture(imageBytes, Workbook.PICTURE_TYPE_PNG);
		 		 
		 		CreationHelper helper = workbook.getCreationHelper();
		 		Drawing drawing1 = sheet.createDrawingPatriarch();
		 		ClientAnchor anchorBi = helper.createClientAnchor();
		 		
		 		ClientAnchor anchor1 = helper.createClientAnchor();
		 		
		 		//create an anchor with upper left cell _and_ bottom right cell
		 		//base image 
		 		   anchorBi.setCol1(0); //Column B
				   anchorBi.setRow1(totalRows+3); //Row 3
				   anchorBi.setCol2(6); //Column C
				   anchorBi.setRow2(totalRows+13); //Row 4
				//base image ended
				   //CHART IMAGE
				   anchor1.setCol1(1); //Column B
				   anchor1.setRow1(totalRows+3); //Row 3
				   anchor1.setCol2(6); //Column C
				   anchor1.setRow2(totalRows+12); //Row 4
				
				   //CellStyle lockedCellStyle = wb.createCellStyle();
				  // lockedCellStyle.setLocked(true);
				   
		 		 //Creates a picture
				 anchorBi.setAnchorType(AnchorType.DONT_MOVE_AND_RESIZE);//set anchor type
				 anchor1.setAnchorType(ClientAnchor.AnchorType.DONT_MOVE_AND_RESIZE);
		 		 Picture pict = drawing1.createPicture(anchorBi, pictureBi);
		 		 Picture pict2 = drawing1.createPicture(anchor1, pictureIdx);
		 		  }
			}
		catch(Exception e) {
			System.out.println("error while inserting graph in report");
			e.printStackTrace();
		}
	 		
		}
	}
}

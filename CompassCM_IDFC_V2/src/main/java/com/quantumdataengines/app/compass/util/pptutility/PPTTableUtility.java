package com.quantumdataengines.app.compass.util.pptutility;


import org.springframework.stereotype.Component;


import org.apache.poi.util.IOUtils;
import org.apache.poi.xslf.usermodel.*;

import java.awt.*;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;


@Component
public class PPTTableUtility {
	
	//width :720
	//height :540
	
	 public void createTable(XSLFSlide slide,List<String>tableHeader,List<List<String>> tableBody){
	   /*slide:- current slide
		*tableHeader:-  Column Name of table (List) 
		*tableBody :- Table Data (List of List)
		*
		*
		* */
			
		 int colWidth = 600/tableHeader.size();
		 double rowHeight = 350/tableBody.size();
		 System.out.println(colWidth+"  "+rowHeight);
		 XSLFTable tbl = slide.createTable();
		 
		 tbl.setAnchor(new Rectangle(100,100,600,400));
		 XSLFTableRow headerRow = tbl.addRow();
		// tbl.setRowHeight(0, rowHeight);
		
		 
		 //for header
		 int colNum = 0;
		
		 for(String colName:tableHeader){
			 XSLFTableCell th = headerRow.addCell();
	         XSLFTextParagraph p = th.addNewTextParagraph();
	         XSLFTextRun r = p.addNewTextRun();
	         r.setText(colName);
	         r.setBold(true);
	         r.setFontColor(Color.BLACK);
	         th.setFillColor(new Color(79, 129, 189));
	         tbl.setColumnWidth(colNum, colWidth);  // all columns are equally sized
	         colNum++;
	          
		 }
		 
		 //for table body data 
		 int rowNum = 0;
		 for(List<String> row:tableBody){
			 XSLFTableRow tr = tbl.addRow();
             tr.setHeight(50);
             for(String cellValue:row){
            	 XSLFTableCell cell = tr.addCell();
                 XSLFTextParagraph p = cell.addNewTextParagraph();
                 XSLFTextRun r = p.addNewTextRun();
                 r.setText(cellValue);
                 if (rowNum % 2 == 0)
                     cell.setFillColor(new Color(208, 216, 232));
                 else
                     cell.setFillColor(new Color(233, 247, 244));
             }
             rowNum++;
            // tbl.setRowHeight(rowNum, rowHeight);
		 } 
	 }
	 
	 
	 public void createTable(XSLFSlide slide,List<List<String>> tableBody){
		 /* When no need to add header 
		  * 
		  * slide:- current slide 
		  * tableBody :- Table Data (List of List)
		  * */
		 XSLFTable tbl = slide.createTable();
		 tbl.setAnchor(new Rectangle(100,120,100,200));
		 int rowNum = 0;
		 for(List<String> row:tableBody){
			 XSLFTableRow tr = tbl.addRow();
             tr.setHeight(50);
             for(String cellValue:row){
            	 XSLFTableCell cell = tr.addCell();
                 XSLFTextParagraph p = cell.addNewTextParagraph();
                 XSLFTextRun r = p.addNewTextRun();
                 r.setText(cellValue);
                 if (rowNum % 2 == 0)
                     cell.setFillColor(new Color(208, 216, 232));
                 else
                     cell.setFillColor(new Color(233, 247, 244));
             }
             rowNum++;
		 } 
	 }

}

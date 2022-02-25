package com.quantumdataengines.app.compass.view;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;

public class ExcelView extends AbstractExcelView {
	
	public static final String EXCEL_LIST_KEY = "excelList";
	
    @Override
    protected void buildExcelDocument(Map<String, Object> model, Workbook workbook, HttpServletRequest request,
            HttpServletResponse response) throws Exception {
        Sheet sheet = workbook.createSheet("Report Details");

        @SuppressWarnings("unchecked")
    	HashMap<String,Object> l_HMReportData = (HashMap<String,Object>) model.get(EXCEL_LIST_KEY);
    	String[] l_Headers = (String[])l_HMReportData.get("Header");
        @SuppressWarnings("unchecked")
    	ArrayList<HashMap<String, String>> l_al = (ArrayList<HashMap<String, String>>)l_HMReportData.get("ReportData");
        HashMap<String, String> hashMap = new HashMap<String, String>();
        sheet.setDefaultColumnWidth((int) l_Headers.length);

        int currentRow = 0;
        
        for(int i=0; i < l_Headers.length; i++)
        {
            Cell header0 = getCell(sheet, currentRow, i);
            setText(header0, l_Headers[i]);
        }
        for(int i=0; i < l_al.size(); i++)
    	{
            currentRow++;
            Row row = sheet.createRow(currentRow);
            hashMap = (HashMap<String, String>)l_al.get(i);
    	    for(int j=0; j < l_Headers.length; j++)
    	    	row.createCell((int)j).setCellValue(hashMap.get(l_Headers[j]));
    	}
 
    }
 
}

package com.quantumdataengines.app.compass.controller.reports;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;


public class ExcelView extends AbstractExcelView
{
  public static final String EXCEL_LIST_KEY = "excelList";
  private Logger log = Logger.getLogger(getClass());

  protected void buildExcelDocument(Map<String, Object> model, Workbook workbook, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
	  System.out.println("in excel builder");
	log.debug("In ExcelView.buildExcelDocument...");
	@SuppressWarnings("unchecked")
	HashMap<String,Object> l_HMReportData = (HashMap<String,Object>) model.get(EXCEL_LIST_KEY);
	String reportId = (String)model.get("reportId");
	String reportName = (String)l_HMReportData.get("reportName");
    
	StringBuilder inputString = new StringBuilder();
	
	// String startDate = (model.get("startDate") != null && !((String)model.get("startDate")).equals("null"))?"StartDate: "+"\t"+(String)model.get("startDate")+"\t"+"\t"+"\t"+"\t":"";
    // String endDate = (model.get("endDate") != null && !((String)model.get("endDate")).equals("null"))?"EndDate: "+"\t"+(String)model.get("endDate"):"";
	String startDate = "";
	String endDate = "";
    if("AGEINGREPORT".equals(reportId)) {
    	startDate = "";
    	endDate = "";
    }
    
    ArrayList inputParameter = model.get("inputParameter") != null ? (ArrayList)model.get("inputParameter"):new ArrayList();
    for(int i=0; i < inputParameter.size(); i++)
    {
    	if( (i%2) != 0)
    		inputString.append("\n").append(inputParameter.get(i).toString()).append(" ");
    	else
    		inputString.append(inputParameter.get(i).toString()).append(" ");
    }
	String[] l_Headers = (String[])l_HMReportData.get("Header");
    @SuppressWarnings("unchecked")
	ArrayList<HashMap<String, String>> l_al = (ArrayList<HashMap<String, String>>)l_HMReportData.get("ReportData");
    //HashMap<String, String> hashMap = (HashMap<String, String>)l_al.get(0);
    HashMap<String, String> hashMap = new HashMap<String, String>();
    
	Sheet sheet = workbook.createSheet("Report Details");
    sheet.setDefaultColumnWidth((int) l_Headers.length);
    /*
    int currentRow = 0;
    Cell inputHeader1 = getCell(sheet, currentRow, 0);
    setText(inputHeader1, "Start Date : "+startDate);
    Cell inputHeader2 = getCell(sheet, currentRow, 1);
    setText(inputHeader2, "End Date : "+endDate);
    */
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
    inputString.append("\nPrint Date: ").append(sdf.format(new Date()));
    int currentRow = 0;    
    if(inputParameter.size() > 0 ){
    	Cell inputHeader3 = getCell(sheet, currentRow, 0);
    	//inputString.append("Report Name: ").append(reportName).append("\n");
    	setText(inputHeader3, "*IDFC First Bank Confidential"+System.lineSeparator()+"Report Name: "+reportName+"\nReport Parameters Are: "+inputString);
    }
    
    currentRow = 1;    
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
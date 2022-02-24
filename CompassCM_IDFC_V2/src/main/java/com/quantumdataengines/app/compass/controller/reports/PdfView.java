package com.quantumdataengines.app.compass.controller.reports;

import java.awt.Color;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.servlet.view.document.AbstractPdfView;

import com.lowagie.text.Document;
import com.lowagie.text.Element;
import com.lowagie.text.Font;
import com.lowagie.text.HeaderFooter;
import com.lowagie.text.PageSize;
import com.lowagie.text.Paragraph;
import com.lowagie.text.Phrase;
import com.lowagie.text.Rectangle;
import com.lowagie.text.pdf.PdfPCell;
import com.lowagie.text.pdf.PdfPTable;
import com.lowagie.text.pdf.PdfWriter;

public class PdfView extends AbstractPdfView
{
  public static final String PDF_LIST_KEY = "pdfList";
  private static final Logger log = LoggerFactory.getLogger(PdfView.class);
  
  private static final Color BORDER_COLOR = new Color(0xFF, 0xFF, 0xFF);
  private static final Color TOP_HEADER_BGCOLOR = new Color(0xFF, 0xFF, 0xFF);
//  private static final Color HEADER_BGCOLOR = new Color(0x99, 0x99, 0xFF);

	static int m_intStart=0;
	static int m_intEnd=0;
	static int m_intOffset=0;
	private Rectangle pageSize;
	private String headerMessage = "IDFC First Bank Confidential";
	private String footerMessage = "IDFC First Bank Confidential";
	
	protected void buildPdfDocument(Map<String, Object> model, Document doc, PdfWriter writer, HttpServletRequest req, HttpServletResponse resp) throws Exception
	{ 
	try {
	log.debug("In PdfView.buildPdfDocument...");
	String reportId = (String)model.get("reportId");
	@SuppressWarnings("unchecked")
	HashMap<String,Object> reportData = (HashMap<String,Object>) model.get(PDF_LIST_KEY);
	String[] l_Headers = (String[])reportData.get("Header");
    @SuppressWarnings("unchecked")
	ArrayList<HashMap<String, String>> l_al = (ArrayList<HashMap<String, String>>)reportData.get("ReportData");
    HashMap<String, String> hashMap = new HashMap<String, String>();
    String reportName = (String)reportData.get("reportName");
    if(reportData.get("reportHeader") != null)
    	headerMessage = (String)reportData.get("reportHeader");
    if(reportData.get("reportFooter") != null)
        footerMessage = (String)reportData.get("reportFooter");
	pageSize = new Rectangle(PageSize.A2);
	//pageSize.setBackgroundColor(new java.awt.Color(0x99, 0x99, 0x99));
	pageSize.setBackgroundColor(new java.awt.Color(0xFF, 0xFF, 0xFF));
	//pageSize.setBackgroundColor(new java.awt.Color(0xD6, 0xEB, 0x94));
	//pageSize.setBackgroundColor(new java.awt.Color(255, 159, 159));
	//doc=new Document(pageSize);
	doc.setPageSize(pageSize);
    String startDate = !((String)model.get("startDate")).equals("null")?"StartDate: "+"\t"+(String)model.get("startDate")+"\t"+"\t"+"\t"+"\t":"";
    String endDate = !((String)model.get("endDate")).equals("null")?"EndDate: "+"\t"+(String)model.get("endDate"):"";
    if(reportId.equals("AGEINGREPORT"))
    {
    	startDate = "";
    	endDate = "";
    }
    ArrayList inputParameter = model.get("inputParameter") != null ? (ArrayList)model.get("inputParameter"):new ArrayList();
    StringBuilder inputString = new StringBuilder();
    for(int i=1; i < inputParameter.size(); i++)
    {
    	if( (i%2) != 0)
    		inputString.append("\n").append(inputParameter.get(i).toString());
    	else
    		inputString.append(inputParameter.get(i).toString());
    }
    
    //Phrase phrase = new Phrase("*"+headerMessage+"\nPage ", new Font(5, Float.parseFloat("15"), Integer.parseInt("2"),new Color(0x99, 0x99, 0x99)));
	Phrase phrase = new Phrase("*"+headerMessage+"\n"+startDate+endDate, new Font(5, Float.parseFloat("15"), Integer.parseInt("2"),new Color(0x99, 0x99, 0x99)));
    Phrase phrase1=new Phrase("*"+footerMessage,new Font(5, Float.parseFloat("11"), Integer.parseInt("1"),new Color(0x99, 0x99, 0x99)));
    //Phrase phrase2=new Phrase("",new Font(5, Float.parseFloat("11"), Integer.parseInt("1"),new Color(0x99, 0x99, 0x99)));
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
    inputString.append("\nPrint Date: ").append(sdf.format(new Date()));
    if(inputParameter.size() > 0 )
    	phrase = new Phrase("*"+headerMessage+"\n"+"Report Name: "+reportName+"\n"+"Report Parameters Are: "+inputString, new Font(5, Float.parseFloat("15"), Integer.parseInt("2"),new Color(0x99, 0x99, 0x99)));
    	
    HeaderFooter header = new HeaderFooter(phrase, false);
    HeaderFooter footer = new HeaderFooter(phrase1, false);
	
	header.setAlignment(Element.ALIGN_LEFT);
    footer.setAlignment(Element.ALIGN_LEFT);
    doc.setHeader(header);
    doc.setFooter(footer);
	doc.open();
	if(l_al != null && l_al.size() > 0)
	{    
	PdfPTable table = new PdfPTable(l_Headers.length);
    table.setWidthPercentage(100);
    
    PdfPCell cell = new PdfPCell(new Paragraph(reportName));
    cell.setBorderColor(BORDER_COLOR);
    cell.setBackgroundColor(TOP_HEADER_BGCOLOR);
    cell.setColspan(l_Headers.length);
    table.addCell(cell);
    
    for(int i=0; i < l_Headers.length; i++)
    {
		Phrase myPhrase = new Phrase(l_Headers[i], new Font(Integer.parseInt("0"), Float.parseFloat("11"), Integer.parseInt("2"),new Color(0, 0, 0)));
		PdfPCell c=new PdfPCell(myPhrase);
		c.setHorizontalAlignment(Element.ALIGN_CENTER);
        table.addCell(c);
/*
		cell = new PdfPCell(new Paragraph(l_Headers[i]));
	    cell.setBorderColor(BORDER_COLOR);
	    cell.setBackgroundColor(HEADER_BGCOLOR);
	    table.addCell(cell);
*/
    }
    for(int i=0; i < l_al.size(); i++)
	{
	    hashMap = (HashMap<String, String>)l_al.get(i);
	    for(int j=0; j < l_Headers.length; j++)
	    {
	    	//Phrase myPhrase = new Phrase(hashMap.get(l_Headers[j]), new Font(Integer.parseInt("0"), Float.parseFloat("11"), Integer.parseInt("2"),new Color(0x99, 0x99, 0x99)));
	    	Phrase myPhrase = new Phrase(hashMap.get(l_Headers[j]), new Font(Integer.parseInt("0"), Float.parseFloat("11"), Integer.parseInt("2"),new Color(0, 0, 0)));
			PdfPCell c=new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Element.ALIGN_CENTER);
			table.addCell(c);
	        //table.addCell(hashMap.get(l_Headers[j]));
	    }
	}
    doc.add(table);
  }
    else
    {
    	String x="No Records To Display";
    	doc.add(new Paragraph(reportName));
		doc.add(new Paragraph(x));
		doc.newPage();
    }
 }
  catch(Exception e)
  {
	  log.error("Error in PDFView  "+e.toString());
	  System.out.println("Error in PDFView  "+e.toString());
	  e.printStackTrace();
  }
  }
}
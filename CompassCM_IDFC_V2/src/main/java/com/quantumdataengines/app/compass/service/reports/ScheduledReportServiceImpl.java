package com.quantumdataengines.app.compass.service.reports;

import java.io.File;
import java.io.FileOutputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.concurrent.TimeUnit;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import com.quantumdataengines.app.compass.dao.reports.ScheduledReportDAO;

@Service
public class ScheduledReportServiceImpl implements ScheduledReportService{
	
	/* Temorarily commented by Govind, has to be enabled once properties would be set */
	/*
	@Value("${report.scheduled.retainDays}")
	private String m_strReportRetainDays;
	
	@Value("${report.scheduled.path}")
	private String m_scheduledReportStaticPath;
	*/
	private String m_strReportRetainDays = "7";
	private String m_scheduledReportStaticPath = "";
	@Autowired
	private ScheduledReportDAO scheduledReportDAO;

	public void setScheduledReportDAO(ScheduledReportDAO scheduledReportDAO) {
		this.scheduledReportDAO = scheduledReportDAO;
	}
	
	/* Temorarily commented by Govind, has to be enabled once properties would be set */
	//@Scheduled(cron="${report.scheduler.cron}")
	public void generateReport(){
		String refScheduleReportPath = m_scheduledReportStaticPath+File.separator+"GeneratedScheduledReport";
		System.out.println("Searching for the output path : "+refScheduleReportPath);
		File rootSchedulePath = new File(refScheduleReportPath);
		if(!rootSchedulePath.exists()){
			rootSchedulePath.mkdir();
			System.out.println("Path Created : "+refScheduleReportPath);
		}
		List<HashMap<String, Object>> reportMainMap = scheduledReportDAO.getReportsToGenerate();
		if(reportMainMap.size() > 0){
			for(HashMap<String, Object> reportMap : reportMainMap){
				Workbook workbook = new SXSSFWorkbook();
				int l_intSeqNo = (Integer) reportMap.get("SEQNO");
				String l_strReportName = (String) reportMap.get("REPORTNAME");
				String l_strProcName = (String) reportMap.get("PROCEDURENAME");
				int l_intNoOfInputParam = (Integer) reportMap.get("NOOFINPUTPARAM");
				String l_strInputParams = (String) reportMap.get("INPUTPARAMS");
				int l_intNoOfOutputParam = (Integer) reportMap.get("NOOFOUTPUTPARAM");
				
				Map<String, Object> model = scheduledReportDAO.getReportData(l_strReportName, l_strProcName,
						l_intNoOfInputParam, l_strInputParams, l_intNoOfOutputParam);
				Iterator<String> itr = model.keySet().iterator();
				System.out.println("l_strReportName : "+l_strReportName+", l_strProcName : "+l_strProcName);
				while (itr.hasNext()) {
					String sheetName = itr.next();
					Sheet sheet = workbook.createSheet(sheetName);
					System.out.println("sheetName : "+sheetName);
					@SuppressWarnings("unchecked")
					HashMap<String, ArrayList<ArrayList<String>>> mainMap = (HashMap<String, ArrayList<ArrayList<String>>>) model
							.get(sheetName);
					ArrayList<ArrayList<String>> listResultHeader = mainMap.get("listResultHeader");
					ArrayList<ArrayList<String>> listResultData = mainMap.get("listResultData");
					System.out.println("listResultHeader size in service: "+listResultHeader.size());
					System.out.println("listResultData size in service: "+listResultData.size());
					String[] l_Headers = {};
					for (ArrayList<String> listHeader : listResultHeader) {
						l_Headers = new String[listHeader.size()];
						for (int i = 0; i < listHeader.size(); i++) {
							l_Headers[i] = listHeader.get(i);
						}
					}

					sheet.setDefaultColumnWidth((int) l_Headers.length);

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
				}
				String filePath = refScheduleReportPath +File.separator+ getFolderName();
				try{
				if(!(new File(filePath).exists())){
					new File(filePath).mkdirs();
				}
				FileOutputStream out = new FileOutputStream(new File(filePath+File.separator+l_intSeqNo+"_"+l_strReportName+".xlsx"));
			       workbook.write(out);
			       out.close();
				}catch(Exception e){
			     	e.printStackTrace();
			    }
			}
		}
		
		try{
			int l_intRetainDays = 10;
			try{
				l_intRetainDays = Integer.parseInt(m_strReportRetainDays);
			}catch(Exception e){}
			List<String> folderList = new ArrayList<String>();
			for(int i = 0; i < l_intRetainDays; i++){
				Calendar calender = Calendar.getInstance();
				calender.add(Calendar.DATE, (-1)*i);
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
				folderList.add(sdf.format(calender.getTime()));
			}
			
			File rootDir = new File(refScheduleReportPath);
			for(File existingFolder : rootDir.listFiles()){
				System.out.println("checking diecotory : "+existingFolder.getName());
				if(!folderList.contains(existingFolder.getName())){
					System.out.println("Deleting directory : "+existingFolder.getName());
					File subDir = new File(existingFolder.getAbsolutePath());
					for(File existingSubFolder : subDir.listFiles()){
						existingSubFolder.delete();
					}
					existingFolder.delete();
				}
			}
		}catch(Exception e){}
	}
	
	protected Cell getCell(Sheet sheet, int row, int col) {

		Row sheetRow = sheet.getRow(row);

		if (sheetRow == null) {

			sheetRow = sheet.createRow(row);

		}
		Cell cell = sheetRow.getCell(col);

		if (cell == null) {

			cell = sheetRow.createCell(col);

		}
		return cell;

	}
	protected void setText(Cell cell, String text) {

		cell.setCellType(Cell.CELL_TYPE_STRING);

		cell.setCellValue(text);

	}
	
	protected String getFolderName(){
		String folderName = "";
		try{
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
			folderName = sdf.format(new Date());
		}catch(Exception e){
			e.printStackTrace();
		}
		return folderName;
	}

	public List<Map<String, String>> getAllReportsDetails(String reportGroup) {
		return scheduledReportDAO.getAllReportsDetails(reportGroup);
	}
	
	public Map<String, Object> getReportBenchmarkDetails(String reportId){
		return scheduledReportDAO.getReportBenchmarkDetails(reportId);
	}
	
	public Map<String, String> getBenchmarkScheduleDetails(String userId, String reportId){
		return scheduledReportDAO.getBenchmarkScheduleDetails(userId, reportId);
	}
	
	public String saveOrUpdateReportBenchMark(String reportId, String userId, Map<String, String> paramMap){
		return scheduledReportDAO.saveOrUpdateReportBenchMark(reportId, userId, paramMap);
	}
	
	public void saveOrUpdateSchedulingDetailsForReport(String userId, String reportId, String schedulingFrequency, String generationDates){
		scheduledReportDAO.saveOrUpdateSchedulingDetailsForReport(userId, reportId, schedulingFrequency, generationDates);
	}
	
	public void deleteScheduling(String userId, String reportId){
		scheduledReportDAO.deleteScheduling(userId, reportId);
	}
	
	public void deleteBenchmark(String userId, String reportId){
		scheduledReportDAO.deleteBenchmark(userId, reportId);
	}
}

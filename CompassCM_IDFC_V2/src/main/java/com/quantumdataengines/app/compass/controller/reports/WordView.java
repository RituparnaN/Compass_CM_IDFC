package com.quantumdataengines.app.compass.controller.reports;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.xwpf.model.XWPFHeaderFooterPolicy;
import org.apache.poi.xwpf.usermodel.XWPFDocument;
import org.apache.poi.xwpf.usermodel.XWPFParagraph;
import org.apache.poi.xwpf.usermodel.XWPFRun;
import org.apache.poi.xwpf.usermodel.XWPFTable;

public class WordView extends AbstractWordView{

	@Override
	protected void buildWordDocument(Map<String, Object> model, XWPFDocument document, HttpServletRequest request, HttpServletResponse response) throws Exception {
		List<Map<String, String>> parameters = (List<Map<String, String>>) model.get("PARAMETERS");
		/*
        if(parameters != null && parameters.size() > 0){
        	int row = parameters.size() % 2 == 0 ? parameters.size() / 2 : (parameters.size()/2)+1;
        	
        	XWPFTable table = document.createTable(row, 4);
        	for(int i = 0; i < row; i++) {
        		Map<String, String> paramMap1 = parameters.get(i*2);
        		String key = paramMap1.keySet().iterator().next();
        		table.getRow(i).getCell(0).setText(key);
        		table.getRow(i).getCell(1).setText(paramMap1.get(key));
        				
        		if((i*2+1) < parameters.size()){
        			Map<String, String> paramMap2 = parameters.get(i*2+1);
        			key = paramMap2.keySet().iterator().next();
            		table.getRow(i).getCell(2).setText(key);
            		table.getRow(i).getCell(3).setText(paramMap2.get(key));
        		}
        	}
        }
        */
        List<String> paragraphs = (List<String>) model.get("PARAGRAPHS");
        
        for(int i = 0; i < paragraphs.size(); i++){
        	XWPFParagraph paragraph = document.createParagraph();
            XWPFRun run = paragraph.createRun();
            run.setText(paragraphs.get(i));
        }
	}

}

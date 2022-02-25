package com.quantumdataengines.app.compass.otherservice;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;


public class ConvertMessageProperties {

	public static void main(String[] args) {
		BufferedReader br = null;
		try{
			br = new BufferedReader(new FileReader("D:\\app_backup\\RITU\\message.properties"));
			
			String currentLine = "";
			while((currentLine = br.readLine()) != null){
				int lhs = currentLine.indexOf("=");
				
				if(lhs>0 && !currentLine.contains("Header") && !currentLine.contains("searchButton")){
					String left = currentLine.substring(0,lhs);
					String right = currentLine.substring(lhs+1);
					
					int dot = left.lastIndexOf(".");
					 if(dot > 0){
					String rightOfDot = left.substring(dot+1).toUpperCase();
					String leftOfDot = left.substring(0,dot);
					
					String finalLine = leftOfDot+"."+rightOfDot+"="+right;  
					
					System.out.println(finalLine);
					 }else{
						 System.out.println(left.toUpperCase()+"="+right);
					 }
				}else{
					System.out.println(currentLine);
				}
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			try {
				br.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		
	}

}

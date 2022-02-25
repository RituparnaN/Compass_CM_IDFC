package com.quantumdataengines.app.compass.util;

import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Component;

import com.quantumdataengines.app.compass.model.scanning.NoiseWordsModel;

@Component
public class CompassStringOperationUtil {
	
	public static String replaceNoiseWordForScanning(String sentace){
		NoiseWordsModel noiseWordModelObject = NoiseWordsModel.getInstance();
		List<String> stroedNoiseWordList = noiseWordModelObject.getNoiseWords();
		int noiseWordListSize = stroedNoiseWordList.size();
		String [] searchWordArray = new String [noiseWordListSize]; 
		String [] replacementArray = new String[noiseWordListSize];
		// System.out.println("searchWordArray: "+searchWordArray);
		
		//creating an replacement array with space 
		for(int i=0;i<noiseWordListSize;i++){
			replacementArray[i] = " ";
			searchWordArray[i] = stroedNoiseWordList.get(i);
		}
		/*for(String noiseWord:stroedNoiseWord){
			System.out.println("word in util =  "+noiseWord);
		}
		*/
		String result = StringUtils.replaceEachRepeatedly((" "+sentace.trim()+" "),searchWordArray,replacementArray);
		return result.trim();
	}
	
	public static void main (String[] args){
	
		String [] search = {" MY "," Name "};
		String [] replace = {" "," "};
		// String string = StringUtils.replaceEachRepeatedly(" OSAMA Pvt Ltd Bin Laden",search , replace);
		// System.out.println("String string = "+string);
	}
	

}

package com.quantumdataengines.app.compass.model.scanning;

import java.util.List;

public class NoiseWordsModel {
	
	private static NoiseWordsModel instance;
	private List<String> noiseWords;
	
	private NoiseWordsModel(){
		
	}
	
	synchronized public static NoiseWordsModel getInstance(){ 
	   if (instance == null){ 
	     instance = new NoiseWordsModel(); 
	   } 
	    return instance; 
	}

	public List<String> getNoiseWords() {
		return noiseWords;
	}

	public void setNoiseWords(List<String> noiseWords) {
		this.noiseWords = noiseWords;
	} 
	 
	 

}

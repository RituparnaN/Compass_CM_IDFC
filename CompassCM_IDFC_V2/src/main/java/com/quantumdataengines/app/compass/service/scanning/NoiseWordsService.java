package com.quantumdataengines.app.compass.service.scanning;

public interface NoiseWordsService {
	String saveNoiseWord(String noiseWord, String isEnabled, String userCode, String ipAddress);
	String updateNoiseWord(String noiseWordsList, String userCode, String ipAddress);
	boolean loadAllNoiseWordInMemory();
}
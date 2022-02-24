package com.quantumdataengines.app.compass.dao.scanning;

import java.util.List;

public interface NoiseWordsDAO {
	String saveNoiseWord(String noiseWord, String isEnabled, String userCode, String ipAddress);
	String updateNoiseWord(String noiseWordsList, String userCode, String ipAddress);
	List<String> loadAllNoiseWordInMemory();
}
package com.quantumdataengines.app.compass.service.scanning;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.quantumdataengines.app.compass.dao.scanning.NoiseWordsDAO;
import com.quantumdataengines.app.compass.dao.scanning.NoiseWordsDAOImpl;
import com.quantumdataengines.app.compass.model.scanning.NoiseWordsModel;
import com.quantumdataengines.app.compass.util.CompassStringOperationUtil;

@Service
public class NoiseWordsServiceImpl implements NoiseWordsService {
	
	private static final Logger log = LoggerFactory.getLogger(NoiseWordsServiceImpl.class);
	@Autowired
	private NoiseWordsDAO noiseWordsDAO;
	
	@Autowired
	private CompassStringOperationUtil compassStringOperationUtil;

	@Override
	public String saveNoiseWord(String noiseWord, String isEnabled, String userCode, String ipAddress) {
		String result = noiseWordsDAO.saveNoiseWord(noiseWord, isEnabled, userCode, ipAddress); 
		try{
			loadAllNoiseWordInMemory();
		}catch(Exception e){
			log.error("Error while updating stored noise word while inserting");
			e.printStackTrace();
		}
		return result;
	}

	@Override
	public String updateNoiseWord(String noiseWordsList, String userCode, String ipAddress) {
		String result = noiseWordsDAO.updateNoiseWord(noiseWordsList, userCode, ipAddress); 
		try{
			loadAllNoiseWordInMemory();
		}catch(Exception e){
			log.error("Error while updating stored noise word while updating");
			e.printStackTrace();
		}
		return result; 
	}

	@Override
	public boolean loadAllNoiseWordInMemory() {
		boolean isSuccessful = false;
		try{
			List<String> words = noiseWordsDAO.loadAllNoiseWordInMemory();
			isSuccessful = true;
			NoiseWordsModel noiseWordModelObject = NoiseWordsModel.getInstance();
			noiseWordModelObject.setNoiseWords(words);
		}catch(Exception e){
			log.error("Error while loading stored noise word");
			e.printStackTrace();
		}
		return isSuccessful;
	}
}
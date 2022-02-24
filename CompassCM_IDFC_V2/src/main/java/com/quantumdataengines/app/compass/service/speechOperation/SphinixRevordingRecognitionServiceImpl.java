package com.quantumdataengines.app.compass.service.speechOperation;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.net.URL;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;





import javax.sound.sampled.AudioFileFormat.Type;
import javax.sound.sampled.AudioFormat;
import javax.sound.sampled.AudioInputStream;
import javax.sound.sampled.AudioSystem;

import org.apache.commons.io.FilenameUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import edu.cmu.sphinx.api.Configuration;
import edu.cmu.sphinx.api.SpeechResult;
import edu.cmu.sphinx.api.StreamSpeechRecognizer;





import org.springframework.core.io.ResourceLoader;

@Service
public class SphinixRevordingRecognitionServiceImpl implements SphinixRevordingRecognitionService {
	
	@Autowired
    ResourceLoader resourceLoader;

	private static final String GRAMMAR_PATH =  "resource:/edu/cmu/sphinx/demo/dialog/";
		   
		    
	@Value("${compass.aml.paths.audioRecordingForRecognition}")
	private String audioRecordingFilePath;
	
	@Override
	public Map<String,String> intiRecognition(MultipartFile file,String userCode,String userRole,String ipAddress){
		Map<String,String>result = new LinkedHashMap<String,String>();
		String inputSpeechText = "";
		String outptText = "";
		String isCommand = "N";
		Map<String,Object> saveInfo = saveRecording(file,userCode);
		boolean saveFile =  (boolean) saveInfo.get("save");
		if(saveFile){
			String filePath = (String) saveInfo.get("filePath");
			inputSpeechText = convertRecordingIntoText(filePath);
			Map<String,String> operationResult = speechCommandOperation(inputSpeechText);
			outptText = operationResult.get("outputText");
			isCommand = operationResult.get("isCommand");
		}
		
		
		result.put("InputText", inputSpeechText);
		result.put("outputText", outptText);
		result.put("isCommand", isCommand);
		return result;
		
	}
	
	

	public Map<String,Object> saveRecording(MultipartFile file,String userCode){
		Map<String,Object> saveInfo =new  LinkedHashMap<String,Object>();
		boolean save = false;
		String filePath = "";
		try {
			byte[] bytes = file.getBytes();
			String rootPath = audioRecordingFilePath;
			File dir = new File(rootPath + File.separator);
			if (!dir.exists())
				dir.mkdirs();

			File serverFile = new File(dir.getAbsolutePath() + File.separator + userCode+".wav");
			BufferedOutputStream stream = new BufferedOutputStream(new FileOutputStream(serverFile));
			stream.write(bytes);
			stream.close();
			save = true;
			System.out.println("You successfully uploaded file=" + dir.getAbsolutePath());
			
			if(!serverFile.exists()){
				System.out.println("No file ");
				return null;
			}
				
			
		filePath = editAudioFormat(serverFile);
		} catch (Exception e) {
			System.out.println("Not uploading e = "+e.getMessage());
			e.printStackTrace();
		}
		
		
		saveInfo.put("save",save);
		saveInfo.put("filePath", filePath);
		
		return saveInfo;
	}
	
	public String convertRecordingIntoText(String fileUrl){
		Configuration configuration = new Configuration();
		configuration.setAcousticModelPath("resource:/edu/cmu/sphinx/models/en-us/en-us"); 
        configuration.setDictionaryPath("resource:/edu/cmu/sphinx/models/en-us/cmudict-en-us.dict"); 
        //configuration.setLanguageModelPath("resource:/edu/cmu/sphinx/models/en-us/en-us.lm.bin");
        
        configuration.setGrammarPath("resource:/edu/cmu/sphinx/demo/dialog/");
        configuration.setUseGrammar(true);
        configuration.setGrammarName("dialog");
       
	    String inputText = "";
	    try{
	    	StreamSpeechRecognizer recognizer = new StreamSpeechRecognizer(configuration);
	    	URL url = new URL("file:///"+fileUrl);
	    	
	    	
	    	System.out.println("----------------------------------------Starting----------------------------------------");
	    	recognizer.startRecognition(url.openStream());
	    	SpeechResult result;
	        while ((result = recognizer.getResult()) != null) {
	        		if(!result.getHypothesis().equals("<unk>"))
	        			inputText += result.getHypothesis()+" ";
	    	    System.out.format("Hypothesis: %s\n", result.getHypothesis());
	    	}
	    	recognizer.stopRecognition();
	    	System.out.println("----------------------------------------finish----------------------------------------");
	    	
	    }catch(Exception e){
	    	System.out.println("exception "+e.getMessage());
	    	e.printStackTrace();
	    }
		
		return inputText;
	}
	
	
	private Map<String,String> speechCommandOperation(String inputSpeechText) {
		Map<String,String> result = new HashMap<String,String>();
		String outputText = "";
		String isCommand = "N";
		
		inputSpeechText.toUpperCase();
		System.out.println("text = "+inputSpeechText);
		 if (inputSpeechText.startsWith("thank you please close")){
			 outputText += "Thanks for using Compass voice manager";
             
         }
		 else if (inputSpeechText.startsWith("how many alerts are there for the day")){
			 outputText += "Total 20 alerts have been generated for the day";
         }
		 else if (inputSpeechText.startsWith("how many suspicions have been filed in the day")){
			 outputText += "Total 6 suspicions have been filed in the day";
         }
		 else if (inputSpeechText.startsWith("who has closed maximum number of alerts")){
			 outputText += "AMLUser has closed maximum 12 alerts";
         }
		 else if (inputSpeechText.startsWith("how many reports are pending to be filed")){
			 outputText += "Cash Transaction report is yet to be filed, due date is 15th January, 2018";
			 outputText += "NTR report is yet to be filed, due date is 15th January, 2018";
			 outputText += "CBTR report is yet to be filed, due date is 15th January, 2018";
			 outputText += "As of now 4 STRs have been filed in this month, 3 has been approved but yet to be filed.";
         }else if(inputSpeechText.startsWith("open")){
        	 isCommand = "Y";
         }
		 else if(inputSpeechText.startsWith("my name is ravi")){
			 outputText += "Hello Ravi how are you";
		 }else{
			 outputText += "Sorry I did not understand.";
		 }
		 result.put("outputText", outputText);
		 result.put("isCommand",isCommand);
		return result;
	}
	
	
	
	
	
	
	
	
	public String editAudioFormat(File tempFile) {
		String rootPath = tempFile.getParent();
		String fileName = tempFile.getName();
		fileName = FilenameUtils.removeExtension(fileName);
		String fullPath = rootPath+ File.separator +fileName +"_formatted.wav";
	   try{ 
		   AudioInputStream wavStream = AudioSystem.getAudioInputStream(tempFile);
		   AudioFormat convertFormat = new AudioFormat(AudioFormat.Encoding.PCM_SIGNED,16000, 16,1,2,16000,false);
		   AudioInputStream converted = AudioSystem.getAudioInputStream(convertFormat, wavStream);
		   
		   System.out.println(" path =  "+fullPath);
		   AudioSystem.write(converted, Type.WAVE, new File(fullPath));
	    } 
	   catch (Exception e) {
	    	System.out.println("error = "+e.getMessage());
	        e.printStackTrace();
	    }
	   return fullPath;
	}
	
	
	
	 
	 
	
	
	

	

}

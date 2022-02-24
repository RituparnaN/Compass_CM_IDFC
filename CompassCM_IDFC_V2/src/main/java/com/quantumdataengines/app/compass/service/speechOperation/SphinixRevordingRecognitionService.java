package com.quantumdataengines.app.compass.service.speechOperation;

import java.util.Map;

import org.springframework.web.multipart.MultipartFile;

public interface SphinixRevordingRecognitionService {
	public Map<String,String> intiRecognition(MultipartFile file,String userCode,String userRole,String ipAddress);

}

package com.quantumdataengines.app.compass.controller.speechOperation;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.util.Iterator;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.quantumdataengines.app.compass.otherservice.OtherCommonService;
import com.quantumdataengines.app.compass.service.CommonService;
import com.quantumdataengines.app.compass.service.speechOperation.SphinixRevordingRecognitionService;

@Controller
@RequestMapping(value="/common")
public class SpeechOperation {
	@Autowired
	private CommonService commonService;
	@Autowired
	private OtherCommonService otherCommonService;
	
	@Autowired
	private SphinixRevordingRecognitionService sphinixRevordingRecognitionService;
	
	@RequestMapping(value = "/sphinixRecordingRecognition",method=RequestMethod.POST) 
	public @ResponseBody  Map<String,String> sphinixRecordingRecognition(MultipartHttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception {
		Map<String,String>result = null;
		Iterator<String> itrator = request.getFileNames();
		MultipartFile file = request.getFile(itrator.next());
		String userCode = authentication.getPrincipal().toString();
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String ipAddress = request.getRemoteAddr();
		if (!file.isEmpty()) {
			result = sphinixRevordingRecognitionService.intiRecognition(file,userCode,userRole,ipAddress);
		} else {
			System.out.println("file is empty");
		}
    	return result ;
    }

}

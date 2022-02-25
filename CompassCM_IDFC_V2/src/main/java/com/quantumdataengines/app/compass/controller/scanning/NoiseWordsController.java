package com.quantumdataengines.app.compass.controller.scanning;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.quantumdataengines.app.compass.otherservice.OtherCommonService;
import com.quantumdataengines.app.compass.service.CommonService;
import com.quantumdataengines.app.compass.service.scanning.NoiseWordsService;

@Controller
@RequestMapping(value="/common")
public class NoiseWordsController {
	
	@Autowired
	private CommonService commonService;
	@Autowired
	private OtherCommonService otherCommonService;
	@Autowired
	private NoiseWordsService noiseWordsService;
	
	
	@RequestMapping(value="/noiseWordsConfiguration", method=RequestMethod.GET)
	public String noiseWordsConfiguration(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String moduleType = request.getParameter("moduleType");
		request.setAttribute("MODULETYPE", moduleType);
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("USERROLE", request.getSession(false).getAttribute("CURRENTROLE") == null ? "N.A.":request.getSession(false).getAttribute("CURRENTROLE").toString());
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "Noise Words Configuration", "OPEN", "Module Accessed");
		return "NoiseWordsConfiguration/index";
	}
	
	@RequestMapping(value="/saveNoiseWord", method=RequestMethod.POST)
	public @ResponseBody String saveNoiseWord(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String noiseWord = request.getParameter("noiseWord");
		String isEnabled = request.getParameter("isEnabled");
		String userCode = authentication.getPrincipal().toString().replace(".", "");
		String ipAddress = request.getRemoteAddr();
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "Noise Words Configuration", "INSERT", "Noise Word Saved");
		return noiseWordsService.saveNoiseWord(noiseWord, isEnabled, userCode, ipAddress);
	}
	
	@RequestMapping(value="/updateNoiseWord", method=RequestMethod.POST)
	public @ResponseBody String updateNoiseWord(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String noiseWordsList = request.getParameter("noiseWordsList");
		String userCode = authentication.getPrincipal().toString().replace(".", "");
		String ipAddress = request.getRemoteAddr();
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "Noise Words Configuration", "UPDATE", "Noise Word Updated");
		return noiseWordsService.updateNoiseWord(noiseWordsList, userCode, ipAddress);
	}
}

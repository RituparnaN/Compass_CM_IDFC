package com.quantumdataengines.app.compass.controller;

import java.net.URLEncoder;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.quantumdataengines.app.compass.otherservice.OtherCommonService;
import com.quantumdataengines.app.compass.service.CommonService;
import com.quantumdataengines.app.compass.service.userNotes.UserNotesService;

@Controller
@RequestMapping(value="/common")
public class UserNotesController {
	
	@Autowired
	private CommonService commonService;
	
	@Autowired
	private UserNotesService userNotesService;
	
	@Autowired
	private OtherCommonService otherCommonService;
	
	private static final Logger log = LoggerFactory.getLogger(UserNotesController.class);
		
	// 05082019
	@RequestMapping(value="/openModalForNotes", method=RequestMethod.GET)
	public String openModalForNotes(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication)throws Exception{
		String currentRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String ipAddress = request.getRemoteAddr();
		String userCode = authentication.getPrincipal().toString().replace(".", "");
		
		request.setAttribute("CURRENTROLE", currentRole);
		request.setAttribute("USERCODE", userCode);
		request.setAttribute("SAVEDELETERESPONSE", request.getParameter("saveDeleteResponse"));
		request.setAttribute("UNQID", otherCommonService.getElementId());
		//System.out.println("response = "+request.getParameter("saveDeleteResponse"));
		
		List<Map<String, String>> notesData = userNotesService.getNotesData(userCode, currentRole, ipAddress);
		request.setAttribute("NOTESDATA", notesData);
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "NOTES", "OPEN", "Notes Modal Open");
		return "common/template/notesModal";
	}
	
	@RequestMapping(value="/saveUserNotes", method=RequestMethod.POST)
	public String saveUserNotes(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication)throws Exception{
		String currentRole = URLEncoder.encode((String) request.getSession(false).getAttribute("CURRENTROLE"), "UTF-8");
		String ipAddress = URLEncoder.encode(request.getRemoteAddr(), "UTF-8");
		String userCode = URLEncoder.encode(authentication.getPrincipal().toString().replace(".", ""), "UTF-8");
		String newNoteContent = request.getParameter("newNoteContent");
		String newNoteReminderDatetime = request.getParameter("newNoteReminderDatetime");
		//System.out.println("newNoteContent "+newNoteContent);
		
		String saveDeleteResponse = URLEncoder.encode(userNotesService.saveUserNotes(newNoteContent, newNoteReminderDatetime, userCode, currentRole, ipAddress), "UTF-8");
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "NOTES", "INSERT", "Notes Saved");
		//return commonService.saveUserNotes(newNoteContent, userCode, currentRole, ipAddress);
		return "redirect:openModalForNotes?userCode="+userCode+"&currentRole="+currentRole+"&ipAddress="+ipAddress+"&saveDeleteResponse="+saveDeleteResponse;
	}
	
	@RequestMapping(value="/deleteUserNotes", method=RequestMethod.POST)
	public String deleteUserNotes(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication)throws Exception{
		String currentRole = URLEncoder.encode((String) request.getSession(false).getAttribute("CURRENTROLE"), "UTF-8");
		String ipAddress = URLEncoder.encode(request.getRemoteAddr(), "UTF-8");
		String userCode = URLEncoder.encode(authentication.getPrincipal().toString().replace(".", ""), "UTF-8");
		String seqNoList = request.getParameter("seqNoList");
		//System.out.println("seqNoList in Controller = "+seqNoList);
		
		String saveDeleteResponse = URLEncoder.encode(userNotesService.deleteUserNotes(seqNoList), "UTF-8");
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "NOTES", "DELETE", "Notes Deleted");
		//return commonService.deleteUserNotes(seqNoList);
		return "redirect:openModalForNotes?userCode="+userCode+"&currentRole="+currentRole+"&ipAddress="+ipAddress+"&saveDeleteResponse="+saveDeleteResponse;
	}
}

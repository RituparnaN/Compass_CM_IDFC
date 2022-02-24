package com.quantumdataengines.app.compass.controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.quantumdataengines.app.compass.otherservice.OtherCommonService;
import com.quantumdataengines.app.compass.service.CommonService;
import com.quantumdataengines.app.compass.service.login.LoginService;
import com.quantumdataengines.app.compass.util.CompassEncryptorDecryptor;
import com.quantumdataengines.app.compass.util.ConfigurationsDetails;

@Controller
public class LoginController {
	private static final Logger log = LoggerFactory.getLogger(LoginController.class);
	private String error = "";
	private String message = "";
	
	@Autowired
	private ConfigurationsDetails configurationsDetails;
	@Autowired
	private CommonService commonService;
	@Autowired
	private CompassEncryptorDecryptor compassEncryptorDecryptor;
	@Autowired
	private LoginService loginService;
	@Autowired
	private OtherCommonService otherCommonService;
	
	@RequestMapping(value="/login", method=RequestMethod.GET)
	public String getLoginPage(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		log.debug("Opening login page...");
		request.setAttribute("error", error);
		request.setAttribute("message", message);
		request.setAttribute("institutions", configurationsDetails.getInstitutionsList());
		error = "";
		message = "";
		request.setAttribute("auth_key", request.getParameter("auth_key"));
		
		return "common/login";
	}
	
	@RequestMapping(value="/loginFailure", method=RequestMethod.POST)
	public String loginFailed(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		error = request.getAttribute("error") == null ? "" : (String) request.getAttribute("error");
		
		return "redirect:login";
	}
	
	@RequestMapping(value="/logoutSuccess/{code}", method=RequestMethod.GET)
	public String logoutSuccess(@PathVariable("code") String code, HttpServletRequest request, 
			HttpServletResponse response, Authentication authentication) throws Exception{
		
		//System.out.println("Out request.getRequestURI().contains  "+request.getRequestURI().contains("securityTesting"));
		//System.out.println("Out request.getRequestURI() "+request.getRequestURI());
		if(request.getRequestURI().contains("securityTesting") || request.getRequestURI().contains("raiseSuspicionFromPortal")){
			// System.out.println("In request.getRequestURI().contains  "+request.getRequestURI().contains("securityTesting"));
			return null;
		}
		else {
		String CURRENTROLE = request.getSession(false) != null ? (String) request.getSession(false).getAttribute("CURRENTROLE") : "";
		String sessionId = "";
			
		if(code.equals("4")){
			try{
				sessionId = request.getSession(false).getId();
				// System.out.println("sessionId : "+sessionId);
				loginService.updateLogoutTime(sessionId, "ROLE_"+CURRENTROLE);
			}catch(Exception e){}
			message = "You are forcefully logged out";
		}
		else if(code.equals("3"))
			message = "Your session has been expired";
		else if(code.equals("2"))
			error = "Error occurred while setting session";
		else if(code.equals("1")){
			try{
				sessionId = request.getSession(false).getId();
				// System.out.println("sessionId : "+sessionId);
				loginService.updateLogoutTime(sessionId, "ROLE_"+CURRENTROLE);
			}catch(Exception e){}
			message = "You are successfully logged out";
		}
		else
			message = "You are logged out";

		return "redirect:/login";
		}
	}
	
	@RequestMapping(value="/getHashtoken", method=RequestMethod.POST)
	public @ResponseBody String getHashtoken(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		
		return otherCommonService.getCSRFToken(request);
	}
	
	@RequestMapping(value="/changePassword", method=RequestMethod.POST)
	public @ResponseBody String changePassword(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		Map<String, String> systemParameters = commonService.initilizingDBSystemParameters();
		String passwordPattern = systemParameters.get("PASSWORDPATTERN");
		String passwordLength = systemParameters.get("PASSWORDLENGTH");
		boolean isValid = true;
		
		int minLength = 8;
		int maxLength = 32;
		try{
			minLength = Integer.parseInt(passwordLength.split(",")[0]);
			maxLength = Integer.parseInt(passwordLength.split(",")[1]);
		}catch(Exception e){}
		
		
		String message = "";
		String special = "~`!@#$%^&*()_-+=<,>.?/:'{[}]|";
		String capital = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
		String small = "abcdefghijklmnopqrstuvwxyz";
		String number = "0123456789";
		String userCode = (String) authentication.getPrincipal();
		String encOldPassword = request.getParameter("encOldPassword");
		String encNewPass = request.getParameter("encNewPass");
		encNewPass = encNewPass.replace(" ", "+");
		String oldCheck = request.getParameter("oldCheck");
		
		String newPassword = compassEncryptorDecryptor.decrypt(encNewPass);
			
		if("Y".equalsIgnoreCase(oldCheck)){
			encOldPassword = encOldPassword.replace(" ", "+");
			String oldPassword = compassEncryptorDecryptor.decrypt(encOldPassword);
			if(!loginService.dbAuthentication(userCode, oldPassword)){
				isValid = false;
				message =  "Current Password doesn't match";
			}
		}
		if((newPassword.length() < minLength || newPassword.length() > maxLength) && isValid){
			message =  "New password should be at least "+minLength+" long and maximum "+maxLength;
			isValid = false;
		}
		
		if(isValid){
			boolean isFound = false;
			message = "Password should contain at least";
			if(passwordPattern.indexOf("CAP") >= 0){
				for(int i = 0; i < capital.length(); i++){
					char passChar = capital.charAt(i);
					if(newPassword.indexOf(passChar) >= 0){
						isFound = true;
						break;
					}
				}
				if(!isFound){
					message =  message+"\nOne Uppercase letter";
					isValid = false;
				}
			}
			
			isFound = false;
			if(passwordPattern.indexOf("SML") >= 0){
				for(int i = 0; i < small.length(); i++){
					char passChar = small.charAt(i);
					if(newPassword.indexOf(passChar) >= 0){
						isFound = true;
						break;
					}
				}
				if(!isFound){
					message =  message+"\nOne Lowercase Letter";
					isValid = false;
				}
			}
			
			isFound = false;
			if(passwordPattern.indexOf("NUM") >= 0){
				for(int i = 0; i < number.length(); i++){
					char passChar = number.charAt(i);
					if(newPassword.indexOf(passChar) >= 0){
						isFound = true;
						break;
					}
				}
				if(!isFound){
					message =  message+"\nOne Numeric Character";
					isValid = false;
				}
			}
			
			isFound = false;
			if(passwordPattern.indexOf("SPL") >= 0){
				for(int i = 0; i < special.length(); i++){
					char passChar = special.charAt(i);
					if(newPassword.indexOf(passChar) >= 0){
						isFound = true;
						break;
					}
				}
				if(!isFound){
					message =  message+"\nOne Special character among "+special;
					isValid = false;
				}
			}
		}
		
		if(isValid){
			message = "";
			encNewPass = compassEncryptorDecryptor.encrypt(newPassword);
			message = loginService.changePassword(userCode, encNewPass);
		}
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "LOGIN", "UPDATE", "Password Updated");
		return message;
	}
	
	
	@RequestMapping(value="/resetAccountPassword", method=RequestMethod.POST)
	public String resetAccountPassword(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		Map<String, String> systemParameters = commonService.initilizingDBSystemParameters();
		String passwordPattern = systemParameters.get("PASSWORDPATTERN");
		String passwordLength = systemParameters.get("PASSWORDLENGTH");
		boolean isValid = true;
		
		int minLength = 8;
		int maxLength = 32;
		try{
			minLength = Integer.parseInt(passwordLength.split(",")[0]);
			maxLength = Integer.parseInt(passwordLength.split(",")[1]);
		}catch(Exception e){}
		
		
		String message = "";
		String special = "~`!@#$%^&*()_-+=<,>.?/:'{[}]|";
		String capital = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
		String small = "abcdefghijklmnopqrstuvwxyz";
		String number = "0123456789";
		String userCode = (String) authentication.getPrincipal();
		String newpassword = request.getParameter("newpassword");
		String encNewPass = newpassword.replace(" ", "+");
		
		String newPassword = compassEncryptorDecryptor.decrypt(encNewPass);
		
		if((newPassword.length() < minLength || newPassword.length() > maxLength) && isValid){
			message =  "New password should be at least "+minLength+" long and maximum "+maxLength;
			isValid = false;
		}
		
		if(isValid){
			boolean isFound = false;
			message = "Password should contain at least";
			if(passwordPattern.indexOf("CAP") >= 0){
				for(int i = 0; i < capital.length(); i++){
					char passChar = capital.charAt(i);
					if(newPassword.indexOf(passChar) >= 0){
						isFound = true;
						break;
					}
				}
				if(!isFound){
					message =  message+"</br> &#9679; One Uppercase letter";
					isValid = false;
				}
			}
			
			isFound = false;
			if(passwordPattern.indexOf("SML") >= 0){
				for(int i = 0; i < small.length(); i++){
					char passChar = small.charAt(i);
					if(newPassword.indexOf(passChar) >= 0){
						isFound = true;
						break;
					}
				}
				if(!isFound){
					message =  message+"</br> &#9679; One Lowercase letter";
					isValid = false;
				}
			}
			
			isFound = false;
			if(passwordPattern.indexOf("NUM") >= 0){
				for(int i = 0; i < number.length(); i++){
					char passChar = number.charAt(i);
					if(newPassword.indexOf(passChar) >= 0){
						isFound = true;
						break;
					}
				}
				if(!isFound){
					message =  message+"</br> &#9679; One Numeric character";
					isValid = false;
				}
			}
			
			isFound = false;
			if(passwordPattern.indexOf("SPL") >= 0){
				for(int i = 0; i < special.length(); i++){
					char passChar = special.charAt(i);
					if(newPassword.indexOf(passChar) >= 0){
						isFound = true;
						break;
					}
				}
				if(!isFound){
					message =  message+"</br> &#9679; One Special character among "+special;
					isValid = false;
				}
			}
		}
		
		if(isValid){
			message = "";
			encNewPass = compassEncryptorDecryptor.encrypt(newPassword);
			message = loginService.changePassword(userCode, encNewPass);
			message = message+" \nLogout and re-login";
		}
		
		request.setAttribute("message", message);
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "LOGIN", "UPDATE", "Account Password Reseted");
		return "common/resetPassword";
	}
}

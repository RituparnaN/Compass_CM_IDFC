package com.quantumdataengines.app.compass.util;

import java.sql.Time;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.authentication.AuthenticationServiceException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Component;

import com.quantumdataengines.app.compass.model.DomainUser;
import com.quantumdataengines.app.compass.otherservice.OtherCommonService;
import com.quantumdataengines.app.compass.service.CommonService;
import com.quantumdataengines.app.compass.service.login.LoginService;

@Component
public class CompassAuthenticationProvider implements AuthenticationProvider{

	private static final Logger log = LoggerFactory.getLogger(CompassAuthenticationProvider.class);
	@Autowired
	private LoginService loginService;	
	@Autowired
	private CommonService commonService;	
	@Autowired
    private HttpServletRequest request;
	@Autowired
	private CompassPasswordDecryptor desPasswordDec;
	@Autowired
	private OtherCommonService otherCommonService;
		
	@Override
	public Authentication authenticate(Authentication authentication)
			throws AuthenticationException {
		UsernamePasswordAuthenticationToken token = (UsernamePasswordAuthenticationToken) authentication;
		String userName = (String) authentication.getPrincipal();
		String userPass = (String) authentication.getCredentials();
		String auth_key = request.getParameter("auth_key");
		String hashToken = otherCommonService.getCSRFToken(request);
		//Uncomment below lines for encrypted username and password
		//userName = desPasswordDec.decrypt(userName, hashToken);
		//userPass = desPasswordDec.decrypt(userPass, hashToken);		
		//Reverted post QK Testings
		userName = desPasswordDec.decrypt(userName, hashToken);
		userPass = desPasswordDec.decrypt(userPass, hashToken);		
		String ipAdress = request.getRemoteHost();
		if(StringUtils.isNotEmpty(userName) && StringUtils.isNotBlank(userName)){
			if(StringUtils.isNotEmpty(userPass) && StringUtils.isNotBlank(userPass)){
				DomainUser domainUser = loginService.authenticateUser(userName, userPass, auth_key, request.getRemoteAddr());
				if(domainUser != null){
						boolean isValid = true;
						List<String> ipAddressForUser = domainUser.getAccessPoints();
						if(ipAddressForUser.size() == 0 || ipAddressForUser.contains(ipAdress)){
							isValid = true;							
						}else{
							isValid = false;
							throw new AuthenticationServiceException("User "+userName+
									" cannot login from this system ["+ipAdress+"]");
						}
						
						Time time = new Time(new Date().getTime());
						Time accessStartTime = new Time(getFormatedDate(domainUser.getAccessStartTime().toString()).getTime());
						Time accessEndTime = new Time(getFormatedDate(domainUser.getAccessEndTime().toString()).getTime());
						if(time.before(accessStartTime) || time.after(accessEndTime)){
							isValid = false;
							log.info("User "+domainUser.getFirstName()+" "+domainUser.getLastName()+
									" ["+domainUser.getUsername()+"] cannot access system at this time.");
							throw new AuthenticationServiceException("cannot access system at this time");
						}else{
							isValid = true;
						}
						
						if(domainUser.isAccountDeleted()){
							isValid = true;
						}else{
							throw new AuthenticationServiceException("Your account is deleted. Please contact administrator");
						}
						
						if(domainUser.isAccountDormant()){
							isValid = true;
						}else{
							throw new AuthenticationServiceException("Your account is dormant. Please contact administrator");
						}
						
						if(domainUser.isEnabled()){
							isValid = true;
						}else{
							throw new AuthenticationServiceException("Your account is disabled. Please contact administrator");
						}
						
						if(domainUser.isAccountNonExpired()){
							isValid = true;
						}else{
							throw new AuthenticationServiceException("Your account is expired. Please contact administrator");
						}
												
						if(domainUser.isAccountNonLocked()){
							isValid = true;
						}else{
							throw new AuthenticationServiceException("Your account is locked. Please contact administrator");
						}
												
						if(isValid){
							authentication = new UsernamePasswordAuthenticationToken(domainUser.getUsername(), 
									domainUser.getPassword(), domainUser.getAuthorities());
							token.setDetails(domainUser);
							log.info("User["+userName+"] authenticated");
						}
						
				}else{
					// throw new UsernameNotFoundException("Username Password didn't match");
					domainUser = loginService.getDomainUserDetails(userName);
					System.out.println(domainUser);
					if(!domainUser.isAccountDeleted()){
						throw new AuthenticationServiceException("Your account is deleted. Please contact administrator");
					}
					
					else if(!domainUser.isAccountDormant()){
						throw new AuthenticationServiceException("Your account is dormant. Please contact administrator");
					}
					
					else if(!domainUser.isEnabled()){
						throw new AuthenticationServiceException("Your account is disabled. Please contact administrator");
					}
					
					else if(!domainUser.isAccountNonExpired()){
						throw new AuthenticationServiceException("Your account is expired. Please contact administrator");
					}
											
					else if(!domainUser.isAccountNonLocked()){
						throw new AuthenticationServiceException("Your account is locked. Please contact administrator");
					}
					else {
						throw new UsernameNotFoundException("Login Failure");
					}
				}
			}else{
				DomainUser domainUser = loginService.getDomainUserDetails(userName);
				
				
				if(!domainUser.isAccountDeleted()){
					throw new AuthenticationServiceException("Your account is deleted. Please contact administrator");
				}
				
				else if(!domainUser.isAccountDormant()){
					throw new AuthenticationServiceException("Your account is dormant. Please contact administrator");
				}
				
				else if(!domainUser.isEnabled()){
					throw new AuthenticationServiceException("Your account is disabled. Please contact administrator");
				}
				
				else if(!domainUser.isAccountNonExpired()){
					throw new AuthenticationServiceException("Your account is expired. Please contact administrator");
				}
										
				else if(!domainUser.isAccountNonLocked()){
					throw new AuthenticationServiceException("Your account is locked. Please contact administrator");
				}
				else {
					throw new UsernameNotFoundException("Password should not be blank");
				}
			}
		}else{
			DomainUser domainUser = loginService.getDomainUserDetails(userName);
			
			
			if(!domainUser.isAccountDeleted()){
				throw new AuthenticationServiceException("Your account is deleted. Please contact administrator");
			}
			
			else if(!domainUser.isAccountDormant()){
				throw new AuthenticationServiceException("Your account is dormant. Please contact administrator");
			}
			
			else if(!domainUser.isEnabled()){
				throw new AuthenticationServiceException("Your account is disabled. Please contact administrator");
			}
			
			else if(!domainUser.isAccountNonExpired()){
				throw new AuthenticationServiceException("Your account is expired. Please contact administrator");
			}
									
			else if(!domainUser.isAccountNonLocked()){
				throw new AuthenticationServiceException("Your account is locked. Please contact administrator");
			}
			else {
				throw new UsernameNotFoundException("Username should not be blank");
			}
		}
		return authentication;
	}

	@Override
    public boolean supports(Class<? extends Object> authentication) {
        return (UsernamePasswordAuthenticationToken.class.isAssignableFrom(authentication));
    }
	
	public static Date getFormatedDate(String timeString){
		Calendar cal = Calendar.getInstance();
		Date date = null;
		int hour;
		int minute;
		int second;
		int firstColon;
		int secondColon;
		
		if (timeString == null) throw new java.lang.IllegalArgumentException();

		firstColon = timeString.indexOf(':');
		secondColon = timeString.indexOf(':', firstColon+1);
		if ((firstColon > 0) & (secondColon > 0) & 
		    (secondColon < timeString.length()-1)) {
		    hour = Integer.parseInt(timeString.substring(0, firstColon));
		    minute = Integer.parseInt(timeString.substring(firstColon+1, secondColon));
		    second = Integer.parseInt(timeString.substring(secondColon+1));	 
		    
		    cal.set(Calendar.HOUR_OF_DAY, hour);
		    cal.set(Calendar.MINUTE, minute);
		    cal.set(Calendar.SECOND, second);
		    date = cal.getTime();
		} else {
		    throw new java.lang.IllegalArgumentException();
		}
		return date;
	}
}

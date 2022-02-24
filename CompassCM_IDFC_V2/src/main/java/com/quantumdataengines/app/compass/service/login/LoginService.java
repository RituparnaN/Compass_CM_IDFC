package com.quantumdataengines.app.compass.service.login;

import java.util.Map;

import org.springframework.security.core.AuthenticationException;

import com.quantumdataengines.app.compass.model.DomainUser;

public interface LoginService {
	public DomainUser authenticateUser(String userCode, String password, String auth_key, String ipAddress) throws AuthenticationException;
	public boolean dbAuthentication(String userCode, String userPass) throws AuthenticationException;
	public String getUserRoleByPriority(String userCode);
	public Map<String, String> getRoleNameUrl(String roleId);
	public String changePassword(String userId, String password);
	public Map<String, String> changePasswordLog(String userCode);
	public void setSystemLoginLog(String userCode, String roldId, String ipAdress, String statusCode, String statusMessage, String sessionId, String browserInfo);
	public Map<String, String> getLastLogins(String userCode, String roleId, String ipAddress);
	public void updateLogoutTime(String sessionId, String role);
	public DomainUser getDomainUserDetails(String userCode) throws AuthenticationException;
	public boolean checkBrowserInfo(String ipAddress, String userCode, String sessionId, String browser);
}

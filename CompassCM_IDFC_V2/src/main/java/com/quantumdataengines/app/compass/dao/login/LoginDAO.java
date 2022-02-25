package com.quantumdataengines.app.compass.dao.login;

import java.util.Map;

import org.springframework.security.core.AuthenticationException;

import com.quantumdataengines.app.compass.model.DomainUser;
import com.quantumdataengines.app.compass.schema.LdapDetails;

public interface LoginDAO {
	public DomainUser getDomainUser(String userCode) throws AuthenticationException;
	public boolean dbAuthentication(String userCode, String userPass) throws AuthenticationException;
	public boolean msadAuthentication(String userCode, String userPass, LdapDetails ldapDetails) throws AuthenticationException;
	public boolean otherAuthentication(String userCode, String userPass, LdapDetails ldapDetails) throws AuthenticationException;
	public String getUserRoleByPriority(String userCode);
	public String getRoleNameUrl(String roleId);
	public String changePassword(String userId, String password);
	public Map<String, String> changePasswordLog(String userCode);
	public void setSystemLoginLog(String userCode, String roldId, String ipAdress, String statusCode, String statusMessage, String sessionId, String browserInfo);
	public Map<String, String> getLastLogins(String userCode, String roleId, String ipAddress);
	public void updateLogoutTime(String sessionId, String role);
	public boolean isDBAuthRequired(String userCode);
	public boolean isUserSSOAuthenticated(String l_strUserID, String l_strUserPassword, String ipAddress, 
			String auth_key, String sso_app_id, String sso_app_password, String sso_url);
	public boolean isUserWebServiceAuthenticated(String userCode, String userPass, String URL);
	public boolean checkBrowserInfo(String ipAddress, String userCode, String sessionId, String browser);
}

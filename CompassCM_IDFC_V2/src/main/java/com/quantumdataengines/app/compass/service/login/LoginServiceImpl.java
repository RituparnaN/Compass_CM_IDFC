package com.quantumdataengines.app.compass.service.login;

import java.util.HashMap;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.AuthenticationException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.quantumdataengines.app.compass.dao.login.LoginDAO;
import com.quantumdataengines.app.compass.model.DomainUser;
import com.quantumdataengines.app.compass.schema.Authentication;
import com.quantumdataengines.app.compass.schema.Configuration;
import com.quantumdataengines.app.compass.schema.LdapDetails;
import com.quantumdataengines.app.compass.schema.LdapProviderType;
import com.quantumdataengines.app.compass.schema.Provider;
import com.quantumdataengines.app.compass.util.UserContextHolder;

@Service
@Transactional()
public class LoginServiceImpl implements LoginService{

	private static final Logger log = LoggerFactory.getLogger(LoginServiceImpl.class);
	
	@Autowired
	private LoginDAO loginDAO;
	
	public void setLoginDAO(LoginDAO loginDAO) {
		this.loginDAO = loginDAO;
	}
	
	@Override
	public DomainUser authenticateUser(String userCode, String password, String auth_key, String ipAddress) throws AuthenticationException {
		DomainUser domainUser = null;
		Configuration configuration = UserContextHolder.getUserContext();
		Authentication authentication = configuration.getAuthentication();
		// domainUser = getDomainUser(userCode);
		if(loginDAO.isDBAuthRequired(userCode)){
			log.info("Overriding Default Authentication Provider for "+userCode+" : DB");
			if(dbAuthentication(userCode, password))
				domainUser = getDomainUser(userCode);
		}else{
			Provider authProvider = authentication.getProvider();
			log.info("Authentication Provider for "+userCode+" : "+authProvider.value());
			
			if(authProvider.value().equals(Provider.DATABASE.value())){
				if(dbAuthentication(userCode, password))
					domainUser = getDomainUser(userCode);
			}else if(authProvider.value().equals(Provider.LDAP.value())){
				LdapProviderType ldapProviderType = authentication.getLdapProvider().getProviderType();
				LdapDetails ldapDetails = authentication.getLdapProvider().getLdapDetails();
				log.info("LDAP Provider type : "+ldapProviderType.value());
				if(ldapProviderType.value().equals(LdapProviderType.MSAD.value())){
					if(msadAuthentication(userCode, password, ldapDetails))
						domainUser = getDomainUser(userCode);
				}else{
					if(otherAuthentication(userCode, password, ldapDetails))
						domainUser = getDomainUser(userCode);
				}
			}else if(authProvider.value().equals(Provider.SSO.value())){
				if(ssoAuthentication(userCode, password, auth_key, ipAddress, 
						authentication.getSsoProvider().getSsoDetails().getSsoAppId(), 
						authentication.getSsoProvider().getSsoDetails().getSsoAppPassword(), 
						authentication.getSsoProvider().getSsoDetails().getSsoURL()))
					domainUser = getDomainUser(userCode);
			}else if(authProvider.value().equals(Provider.WEBSERVICE.value())){
				if(webServiceAuthentication(userCode, password, authentication.getWebServiceProvider().getURL()))
					domainUser = getDomainUser(userCode);
			}else{
				log.error("No Auth provider is specified for "+userCode);
			}
		}
		return domainUser;
	}
	
	public DomainUser getDomainUser(String userCode) throws AuthenticationException{
		return loginDAO.getDomainUser(userCode);
	}
	
	@Override
	public DomainUser getDomainUserDetails(String userCode) throws AuthenticationException{
		return loginDAO.getDomainUser(userCode);
	}
	
	@Override
	public boolean dbAuthentication(String userCode, String userPass) throws AuthenticationException{
		return loginDAO.dbAuthentication(userCode, userPass);
	}
	
	private boolean msadAuthentication(String userCode, String userPass, LdapDetails ldapDetails) throws AuthenticationException{
		return loginDAO.msadAuthentication(userCode, userPass, ldapDetails);
	}
	
	private boolean otherAuthentication(String userCode, String userPass, LdapDetails ldapDetails) throws AuthenticationException{
		return loginDAO.otherAuthentication(userCode, userPass, ldapDetails);
	}
	
	private boolean ssoAuthentication(String userCode, String userPass, String auth_key, String ipAddress, String sso_app_id, String sso_app_password, String sso_url){
		return loginDAO.isUserSSOAuthenticated(userCode, userPass, ipAddress, auth_key, sso_app_id, sso_app_password, sso_url);
	}
	
	private boolean webServiceAuthentication(String userCode, String userPass, String URL){
		return loginDAO.isUserWebServiceAuthenticated(userCode, userPass, URL);
	}
	
	public String getUserRoleByPriority(String userCode){
		return loginDAO.getUserRoleByPriority(userCode);
	}
	
	public Map<String, String> getRoleNameUrl(String roleId){
		String roleName = loginDAO.getRoleNameUrl(roleId);
		Map<String, String> otherProfileDetails = new HashMap<String, String>();
		otherProfileDetails.put("roleName", roleName);
		otherProfileDetails.put("roleId", roleId);	
		if(roleId.equals("ROLE_ADMIN")){
			otherProfileDetails.put("url", "redirect:/admin");
		}else if(roleId.equals("ROLE_MLRO")){
			otherProfileDetails.put("url", "redirect:/mlro");
		}else if(roleId.equals("ROLE_MLROL1")){
			otherProfileDetails.put("url", "redirect:/mlroL1");
		}else if(roleId.equals("ROLE_MLROL2")){
			otherProfileDetails.put("url", "redirect:/mlroL2");
		}else if(roleId.equals("ROLE_AMLO")){
			otherProfileDetails.put("url", "redirect:/amlo");
		}else if(roleId.equals("ROLE_AMLUSER")){
			otherProfileDetails.put("url", "redirect:/amluser");
		}else if(roleId.equals("ROLE_AMLUSERL1")){
			otherProfileDetails.put("url", "redirect:/amluserL1");
		}else if(roleId.equals("ROLE_AMLUSERL2")){
			otherProfileDetails.put("url", "redirect:/amluserL2");
		}else if(roleId.equals("ROLE_AMLUSERL3")){
			otherProfileDetails.put("url", "redirect:/amluserL3");
		}else if(roleId.equals("ROLE_USER")){
			otherProfileDetails.put("url", "redirect:/user");
		}else if(roleId.equals("ROLE_ETL")){
			otherProfileDetails.put("url", "redirect:/etl");
		}else if(roleId.equals("ROLE_MAKER")){
			otherProfileDetails.put("url", "redirect:/maker");
		}else if(roleId.equals("ROLE_CHECKER")){
			otherProfileDetails.put("url", "redirect:/checker");
		}		
		return otherProfileDetails;
	}
	
	@Override
	public String changePassword(String userId, String password){
		return loginDAO.changePassword(userId, password);
	}
	
	@Override
	public Map<String, String> changePasswordLog(String userCode){
		return loginDAO.changePasswordLog(userCode);
	}
	
	@Override
	public void setSystemLoginLog(String userCode, String roldId, String ipAdress, String statusCode, String statusMessage, String sessionId, String browserInfo){
		loginDAO.setSystemLoginLog(userCode, roldId, ipAdress, statusCode, statusMessage, sessionId, browserInfo);
	}
	
	@Override
	public Map<String, String> getLastLogins(String userCode, String roleId, String ipAddress){
		return loginDAO.getLastLogins(userCode, roleId, ipAddress);
	}
	
	@Override
	public void updateLogoutTime(String sessionId, String role){
		loginDAO.updateLogoutTime(sessionId, role);
	}

	@Override
	public boolean checkBrowserInfo(String ipAddress, String userCode, String sessionId,
			String browser) {
		return loginDAO.checkBrowserInfo(ipAddress, userCode, sessionId, browser);
	}
}

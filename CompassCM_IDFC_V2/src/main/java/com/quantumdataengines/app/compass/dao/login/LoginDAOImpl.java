package com.quantumdataengines.app.compass.dao.login;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.Map;
import java.util.Vector;

import javax.naming.Context;
import javax.naming.NamingEnumeration;
import javax.naming.NamingException;
import javax.naming.directory.DirContext;
import javax.naming.directory.InitialDirContext;
import javax.naming.directory.SearchControls;
import javax.naming.directory.SearchResult;
import javax.naming.ldap.InitialLdapContext;
import javax.net.ssl.HttpsURLConnection;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.authentication.AuthenticationServiceException;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.stereotype.Repository;

import com.quantumdataengines.app.compass.model.DomainUser;
import com.quantumdataengines.app.compass.schema.LdapDetails;
import com.quantumdataengines.app.compass.util.CompassEncryptorDecryptor;
import com.quantumdataengines.app.compass.util.ConnectionUtil;

@Repository
public class LoginDAOImpl implements LoginDAO{
	
	private static final Logger log = LoggerFactory.getLogger(LoginDAOImpl.class);
	
	@Autowired
	private ConnectionUtil connectionUtil;
	@Autowired
	private CompassEncryptorDecryptor encdec;
	
	public void setConnectionUtil(ConnectionUtil connectionUtil) {
		this.connectionUtil = connectionUtil;
	}
	public void setEncdec(CompassEncryptorDecryptor encdec) {
		this.encdec = encdec;
	}


	@Override
	public DomainUser getDomainUser(String userCode) throws AuthenticationException {
		DomainUser domainUser = null;
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		System.out.println(userCode);
		try{
			preparedStatement = connection.prepareStatement(Query.GET_USER);

			preparedStatement.setString(1, userCode);
			resultSet = preparedStatement.executeQuery();
			if(resultSet.next()){
				domainUser = new DomainUser(resultSet.getString("USERCODE"), resultSet.getString("USERPASS"),
						new Boolean(resultSet.getString("ACCOUNTENABLE")), new Boolean(resultSet.getString("ACCOUNTEXPIRED")), 
						new Boolean(resultSet.getString("CREDENTIALEXPIRED")), new Boolean(resultSet.getString("ACCOUNTLOCKED")),
						getUserAuthorities(userCode), resultSet.getString("FIRSTNAME"), resultSet.getString("LASTNAME"),
						resultSet.getTimestamp("CREATIONTIME"), resultSet.getString("ACCESSPOINTS") != null ? Arrays.asList(resultSet.getString("ACCESSPOINTS").split(";")) : new ArrayList<String>(),
						java.sql.Time.valueOf(resultSet.getString("ACCESSSTARTTIME")), java.sql.Time.valueOf(resultSet.getString("ACCESSENDTIME")), 
						resultSet.getString("LABELDIRECTION"), resultSet.getString("LANGUAGE"), new Boolean(resultSet.getString("CHATENABLE")), 
						new Boolean(resultSet.getString("ACCOUNTDELETED")), new Boolean(resultSet.getString("ACCOUNTDORMANT")));
			}
		}catch(Exception e){
			log.error("Error while getting user details from database : "+e.getMessage());
			e.printStackTrace();
			throw new AuthenticationServiceException("Failed to retrieve details for User ["+userCode+"]");
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return domainUser;
	}
	
	private Collection<? extends GrantedAuthority> getUserAuthorities(String userCode){
		Collection<SimpleGrantedAuthority> listUserAuthorities = new Vector<SimpleGrantedAuthority>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareStatement(Query.AUTHORIZATION);
			preparedStatement.setString(1, userCode);
			resultSet = preparedStatement.executeQuery();
			while (resultSet.next()) {
				listUserAuthorities.add(new SimpleGrantedAuthority(resultSet.getString("ROLENAME")));
			}
		}catch(Exception e){
			log.error("Error while getting user details from database : "+e.getMessage());
			e.printStackTrace();
			throw new AuthenticationServiceException("Failed to retirve authorities for User ["+userCode+"]");
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return listUserAuthorities;
	}

	@Override
	public boolean dbAuthentication(String userCode, String userPass)
			throws AuthenticationException {
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareStatement(Query.AUTHENTICATION);
			preparedStatement.setString(1, userCode);
			preparedStatement.setString(2, encdec.encrypt(userPass));
			resultSet = preparedStatement.executeQuery();
			if(resultSet.next())
				return true;
			else
				return false;
		}catch(Exception e){
			log.error("Error while authenticating user through database : "+e.getMessage());
			e.printStackTrace();
			throw new AuthenticationServiceException("Failed to find the User ["+userCode+"]");
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
	}

	@Override
	public boolean msadAuthentication(String userCode, String userPass,
			LdapDetails ldapDetails) throws AuthenticationException {
		log.debug("User ["+userCode+"] is going to authentication through "+ldapDetails.getBaseDN().getValue()+
				" of "+ldapDetails.getLdapHostIP().getValue());
		Hashtable<String, Object> env = new Hashtable<String, Object>();
		env.put(Context.INITIAL_CONTEXT_FACTORY, "com.sun.jndi.ldap.LdapCtxFactory");
		env.put(Context.PROVIDER_URL, "ldap://"+ldapDetails.getLdapHostIP().getValue()+":"+ldapDetails.getLdapHostPort().getValue()+"/"+ldapDetails.getBaseDN().getValue());
		env.put(Context.SECURITY_AUTHENTICATION, "simple");
		env.put(Context.REFERRAL, "follow");
		env.put(Context.SECURITY_PRINCIPAL, ldapDetails.getDomain().getValue()+userCode);
		env.put(Context.SECURITY_CREDENTIALS, userPass);
		try {
			new InitialDirContext(env);
			return true;
		} catch (NamingException e) {
			log.error("Username Password didn't match for the user : "+userCode);
			e.printStackTrace();
			// throw new BadCredentialsException("Username Password didn't match");
			throw new BadCredentialsException("Login Failure");
		}
	}

	@Override
	public boolean otherAuthentication(String userCode, String userPass,
			LdapDetails ldapDetails) throws AuthenticationException {
		log.debug("User ["+userCode+"] is going to authentication through "+ldapDetails.getBaseDN().getValue()+" of "+ldapDetails.getLdapHostIP().getValue());
		Hashtable<String, Object> env = new Hashtable<String, Object>();
		env.put(Context.INITIAL_CONTEXT_FACTORY, "com.sun.jndi.ldap.LdapCtxFactory");
		env.put(Context.PROVIDER_URL, "ldap://"+ldapDetails.getLdapHostIP().getValue()+":"+ldapDetails.getLdapHostPort().getValue());
		env.put(Context.SECURITY_AUTHENTICATION, "simple");
		env.put(Context.REFERRAL, "follow");
		env.put(Context.SECURITY_PRINCIPAL, ldapDetails.getManager().getLdapUsername().getValue());
		env.put(Context.SECURITY_CREDENTIALS, ldapDetails.getManager().getLdapPassword().getValue());
		try {
			DirContext dirCtx = new InitialLdapContext(env, null);
			String searchFilter = "(&(objectClass=inetOrgPerson)(uid="+ userCode+")(userPassword="+encdec.hashedPassword(userPass, "sha")+"))";
			SearchControls searchControls = new SearchControls();
	        searchControls.setSearchScope(SearchControls.SUBTREE_SCOPE);
	        NamingEnumeration<SearchResult> results = dirCtx.search(ldapDetails.getBaseDN().getValue(), searchFilter, searchControls);
	        if(results.hasMoreElements()){
	             results.nextElement();
	             return true;
	        }else{
	        	return false;
	        }
		} catch (NamingException e) {
			log.error("Username Password didn't match for the user : "+userCode);
			e.printStackTrace();
			//throw new BadCredentialsException("Username Password didn't match");
			throw new BadCredentialsException("Login Failure");
		}
	}
	
	public String getUserRoleByPriority(String userCode){
		String roleId = "";
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareStatement(Query.LOGINPRIORITY);
			preparedStatement.setString(1, userCode);
			resultSet = preparedStatement.executeQuery();
			if(resultSet.next())
				roleId = resultSet.getString("ROLENAME");
		}catch(Exception e){
			log.error("Error while getting login pripority of user : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return roleId;
	}
	
	
	public String getRoleNameUrl(String roleId){
		String roleName = "";
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareStatement(Query.GETROLENAMEURL);
			preparedStatement.setString(1, roleId);
			resultSet = preparedStatement.executeQuery();
			if(resultSet.next())
				roleName = resultSet.getString("ROLEID");
		}catch(Exception e){
			log.error("Error while getting role name : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return roleName;
	}
	
	@Override
	public String changePassword(String userId, String password){
		String message = "";
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareStatement(Query.CHANGEPASSWORD);
			preparedStatement.setString(1, password);
			preparedStatement.setString(2, userId);
			preparedStatement.executeUpdate();
			message = "Password successfully changed";
			
			preparedStatement = connection.prepareStatement(Query.PASSWORDCHANGELOG);
			preparedStatement.setString(1, userId);
			preparedStatement.setString(2, password);
			preparedStatement.executeUpdate();
		}catch(Exception e){
			message = "Error while changing password";
			log.error("Error while changing password : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return message;
	}
	
	@Override
	public Map<String, String> changePasswordLog(String userCode){
		Map<String, String> passwordChangeMap = new HashMap<String, String>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareStatement(Query.GETPASSWORDCHANGELOG);
			preparedStatement.setString(1, userCode);
			resultSet = preparedStatement.executeQuery();
			if(resultSet.next()){
				passwordChangeMap.put("PASSWORDCHANGEDATE", resultSet.getString("PASSWORDCHANGEDATE"));
				passwordChangeMap.put("CHANGEDAYS", resultSet.getString("CHANGEDAYS"));
			}
		}catch(Exception e){
			log.error("Error occured while getting password change log : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return passwordChangeMap;
	}
	
	@SuppressWarnings("resource")
	public void setSystemLoginLog(String userCode, String roldId, String ipAdress, String statusCode, String statusMessage, String sessionId, String browserInfo){
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String queryString = "";
		int lockOutAttempt = 0;
		int inValidLoginCount = 0;
		try{
			preparedStatement = connection.prepareStatement(Query.SETSYSTEMLOGINLOG);
			preparedStatement.setString(1, userCode);
			preparedStatement.setString(2, roldId);
			preparedStatement.setString(3, ipAdress);
			preparedStatement.setString(4, statusCode);
			preparedStatement.setString(5, statusMessage);
			preparedStatement.setString(6, sessionId);
			preparedStatement.setString(7, browserInfo);
			// preparedStatement.executeUpdate();
			if(userCode != null ) {
				preparedStatement.executeUpdate();
			}
			
			if(statusCode.equalsIgnoreCase("N")){
				queryString = " SELECT A.PARAMETERVALUE "+
				              "   FROM TB_SYSTEMPARAMETERS A "+
				              "  WHERE A.PARAMETERNAME = 'LOCKOUTATTEMPT' ";
				preparedStatement = connection.prepareStatement(queryString);
				resultSet = preparedStatement.executeQuery();
				if (resultSet.next()) {
					lockOutAttempt = Integer.parseInt(resultSet.getString("PARAMETERVALUE"));
				}
				resultSet = null;
				queryString = " SELECT COUNT(*) COUNTVAL FROM ( "+
						      " SELECT * FROM ( "+
						      " SELECT * FROM TB_SYSTEMLOGINLOG "+
		                      "  WHERE USERCODE = ? "+
		                      "  ORDER BY LOGINDATETIME DESC "+
		                      " ) A WHERE ROWNUM <= ? "+
		                      " ) "+
		                      " WHERE LOGINSTATUS = 'N' "+
		                      " GROUP BY LOGINSTATUS ";
				preparedStatement = connection.prepareStatement(queryString);
				preparedStatement.setString(1, userCode);
				preparedStatement.setInt(2, lockOutAttempt);
				resultSet = preparedStatement.executeQuery();
				if (resultSet.next()) {
					inValidLoginCount = resultSet.getInt("COUNTVAL");
					//System.out.println("inValidLoginCount = "+inValidLoginCount);
				}
				if(inValidLoginCount >= lockOutAttempt){
					/*
					queryString = " UPDATE TB_USER A SET A.ACCOUNTENABLE = 'N', A.ACCOUNTLOCKED = 'Y' "+
					      		  "  WHERE A.USERCODE = ? ";
					*/      		  
					queryString = " UPDATE TB_USER A SET A.ACCOUNTLOCKED = 'Y' "+
				      		      "  WHERE A.USERCODE = ? ";
					preparedStatement = connection.prepareStatement(queryString);
					preparedStatement.setString(1, userCode);
					preparedStatement.executeUpdate();
				}
			}
			
			if(statusCode.equalsIgnoreCase("Y")){
				String query = "UPDATE TB_USER A SET LASTUSEDDATE = SYSTIMESTAMP "+
							   " WHERE A.USERCODE = ? ";
				preparedStatement = connection.prepareStatement(query);
				preparedStatement.setString(1, userCode);
				preparedStatement.executeUpdate();
			}
			
		}catch(Exception e){
			log.error("Error occurred while setting system login log : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
	}
	
	@Override
	public Map<String, String> getLastLogins(String userCode, String roleId, String ipAddress){
		Map<String, String> systemLoginLog = new HashMap<String, String>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		int count = 1;
		try{
			preparedStatement = connection.prepareStatement(Query.GETLASTLOGINTIME);
			preparedStatement.setString(1, userCode);
			preparedStatement.setString(2, roleId);
			preparedStatement.setString(3, "Y");
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()){
				if(count == 2){
					systemLoginLog.put("SUCCESSFULLOGINTIME", resultSet.getString("LASTLOGINTIME"));
					systemLoginLog.put("SUCCESSFULLOGINTIMEDIFF", resultSet.getString("TIMEDIFF"));
					systemLoginLog.put("SUCCESSFROMSYSTEM", ipAddress.equals(resultSet.getString("IPADDRESS")) ? "from this system" : "from "+resultSet.getString("IPADDRESS"));
				}
				count++;
			}
			
			preparedStatement = connection.prepareStatement(Query.GETLASTLOGINTIME);
			preparedStatement.setString(1, userCode);
			preparedStatement.setString(2, "NA");
			preparedStatement.setString(3, "N");
			resultSet = preparedStatement.executeQuery();
			if(resultSet.next()){
				systemLoginLog.put("FAILEDLOGINTIME", resultSet.getString("LASTLOGINTIME"));
				systemLoginLog.put("FAILEDLOGINTIMEDIFF", resultSet.getString("TIMEDIFF"));
				systemLoginLog.put("FAILEDFROMSYSTEM", ipAddress.equals(resultSet.getString("IPADDRESS")) ? "from this system" : "from "+resultSet.getString("IPADDRESS"));
			}
		}catch(Exception e){
			log.error("Error getting login log : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return systemLoginLog;
	}
	
	public void updateLogoutTime(String sessionId, String role){
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			role = role.replaceAll("ROLE_ROLE_", "ROLE_");
			preparedStatement = connection.prepareStatement(Query.UPDATELOGOUTIME);
			preparedStatement.setString(1, sessionId);
			preparedStatement.setString(2, role);
			preparedStatement.executeUpdate();
		}catch(Exception e){
			log.error("Error while updating logout time : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
	}
	@Override
	public boolean isDBAuthRequired(String userCode) {
		boolean isDBAuthRequired = false;
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareStatement("SELECT NVL(ISDBAUTHREQUIRED,'N') AS ISDBAUTHREQUIRED FROM TB_USER WHERE USERCODE = ?");
			preparedStatement.setString(1, userCode);
			resultSet = preparedStatement.executeQuery();
			if(resultSet.next())
				isDBAuthRequired = "Y".equals(resultSet.getString("ISDBAUTHREQUIRED")) ? true : false;
		}catch(Exception e){
			log.error("Error while updating logout time : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}		
		return isDBAuthRequired;
	}
	
	public boolean isUserSSOAuthenticated(String l_strUserID, String l_strUserPassword, String ipAddress, 
			String auth_key, String sso_app_id, String sso_app_password, String sso_url){
		boolean isAuthenticate = false;
		String resultStr = null;
		BufferedReader reader = null;
		
		String url = sso_url+"?app_id="+sso_app_id+"&app_pass="+sso_app_password+"&user_sess_string="+auth_key+"&user_ip="+ipAddress;
		System.out.println(url);
		try{
			URL urlObj = new URL(url);
			
			if(url.startsWith("https")){
				HttpsURLConnection connection = (HttpsURLConnection) urlObj.openConnection();
				connection.setRequestMethod("POST");
				
				connection.setDoOutput(true);
				DataOutputStream wr = new DataOutputStream(connection.getOutputStream());
				wr.writeBytes("");
				wr.flush();
				wr.close();

				int responseCode = connection.getResponseCode();
				System.out.println("Response Code : " + responseCode);
				
				reader = new BufferedReader(new InputStreamReader(connection.getInputStream()));
			}else{
				HttpURLConnection connection = (HttpURLConnection) urlObj.openConnection();
				connection.setRequestMethod("POST");
				
				connection.setDoOutput(true);
				DataOutputStream wr = new DataOutputStream(connection.getOutputStream());
				wr.writeBytes("");
				wr.flush();
				wr.close();

				int responseCode = connection.getResponseCode();
				System.out.println("Response Code : " + responseCode);
				
				reader = new BufferedReader(new InputStreamReader(connection.getInputStream()));
			}
			
			StringBuffer result = new StringBuffer();			
			String line = "";
			while ((line = reader.readLine()) != null) {
				result.append(line);
			}
			resultStr = new String(result);
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			if(reader != null)
				try {
					reader.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
		}
		
		log.warn("Place the the logic to determine the authentication status from String resultStr");
		
		/*
		 Place the the logic to determine the authentication status from String resultStr
		 */
		
		return isAuthenticate;
	}
	
	public boolean isUserWebServiceAuthenticated(String userCode, String userPass, String URL){
		boolean isAuthenticate = false;
		BufferedReader reader = null;
		String url = URL+"?param1="+userCode+"&param2="+userPass;
		System.out.println(url);
		try{
			
			URL urlObj = new URL(url);
			
			
			if(url.startsWith("https")){
				HttpsURLConnection connection = (HttpsURLConnection) urlObj.openConnection();
				connection.setRequestMethod("POST");
				
				connection.setDoOutput(true);
				DataOutputStream wr = new DataOutputStream(connection.getOutputStream());
				wr.writeBytes("");
				wr.flush();
				wr.close();

				int responseCode = connection.getResponseCode();
				System.out.println("Response Code : " + responseCode);
				
				reader = new BufferedReader(new InputStreamReader(connection.getInputStream()));
			}else{
				HttpURLConnection connection = (HttpURLConnection) urlObj.openConnection();
				connection.setRequestMethod("POST");
				
				connection.setDoOutput(true);
				DataOutputStream wr = new DataOutputStream(connection.getOutputStream());
				wr.writeBytes("");
				wr.flush();
				wr.close();

				int responseCode = connection.getResponseCode();
				System.out.println("Response Code : " + responseCode);
				
				reader = new BufferedReader(new InputStreamReader(connection.getInputStream()));
			}
			
			
			
			
			StringBuffer result = new StringBuffer();
			
			String line = "";
			while ((line = reader.readLine()) != null) {
				result.append(line);
			}
			
			String resultStr = new String(result);
			
			log.warn("Place the the logic to determine the authentication status from String resultStr");
			/*
			 Place the the logic to determine the authentication status from String resultStr
			 */
		    
		}catch(Exception e){
			log.error("Error while authentication of user : "+e.getMessage());
			e.printStackTrace();
		}finally{
			try {
				if(reader != null)
					reader.close();
			} catch (IOException e) { }
	    }
		return isAuthenticate;
	}
	
	public boolean checkBrowserInfo(String ipAddress, String userCode, String sessionId, String browser){
		boolean isValid = false;
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			String sql = "SELECT COUNT(*) FROM TB_SYSTEMLOGINLOG "+
						 " WHERE USERCODE = ? AND IPADDRESS = ? "+
					     "   AND BROWSERINFO = ? AND SESSIONID = ? ";
			sql = "SELECT COUNT(*) FROM TB_SYSTEMLOGINLOG "+
				  " WHERE USERCODE = ? AND IPADDRESS = ? "+
				  "   AND BROWSERINFO = ? AND SESSIONID = ? ";
		
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, userCode);
			preparedStatement.setString(2, ipAddress);
			preparedStatement.setString(3, browser);
			preparedStatement.setString(4, sessionId);
			resultSet = preparedStatement.executeQuery();
			if(resultSet.next()){
				if(resultSet.getInt(1) == 1){
					isValid = true;
				}
			}
		}catch(Exception e){
			log.error("Error while getting user details from database : "+e.getMessage());
			e.printStackTrace();
			throw new AuthenticationServiceException("Failed to retirve details for User ["+userCode+"]");
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return isValid;
	}
	
}

package com.quantumdataengines.app.compass.model;

import java.sql.Time;
import java.sql.Timestamp;
import java.util.Collection;
import java.util.List;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.User;

@SuppressWarnings("serial")
public class DomainUser extends User{
	private String firstName;
	private String lastName;
	private Timestamp accountCreationTime;
	private List<String> accessPoints;
	private Time accessStartTime;
	private Time accessEndTime;
	private boolean chatEnabled;
	private String labelDirection;
	private String languageCode;
	private boolean accountDeleted;
	private boolean accountDormant;
	
	public DomainUser(String username, String password, boolean enabled,
			boolean accountNonExpired, boolean credentialsNonExpired,
			boolean accountNonLocked,
			Collection<? extends GrantedAuthority> authorities,
			String firstName, String lastName, Timestamp accountCreationTime,
			List<String> accessPoints, Time accessStartTime, Time accessEndTime, String labelDirection, String languageCode, boolean chatEnabled, 
			boolean accountDeleted, boolean accountDormant) {
		super(username, password, enabled, accountNonExpired, credentialsNonExpired,
				accountNonLocked, authorities);
		this.firstName = firstName;
		this.lastName = lastName;
		this.accountCreationTime = accountCreationTime;
		this.accessPoints = accessPoints;
		this.accessStartTime = accessStartTime;
		this.accessEndTime = accessEndTime;
		this.labelDirection = labelDirection;
		this.languageCode = languageCode;
		this.chatEnabled = chatEnabled;
		this.accountDeleted = accountDeleted;
		this.accountDormant = accountDormant;
	}

	public String getFirstName() {
		return firstName;
	}

	public String getLastName() {
		return lastName;
	}

	public Timestamp getAccountCreationTime() {
		return accountCreationTime;
	}

	public List<String> getAccessPoints() {
		return accessPoints;
	}

	public Time getAccessStartTime() {
		return accessStartTime;
	}

	public Time getAccessEndTime() {
		return accessEndTime;
	}
	
	public String getLabelDirection() {
		return labelDirection;
	}

	public String getLanguageCode() {
		return languageCode;
	}
	public boolean isChatEnabled() {
		return chatEnabled;
	}
	
	public boolean isAccountDeleted() {
		return accountDeleted;
	}
	
	public boolean isAccountDormant() {
		return accountDormant;
	}

	@Override
	public String toString() {
		String toString = super.toString(); 
		toString = toString + "; Full Name : "+getFirstName()+" "+getLastName() +
				"; Account Created : "+getAccountCreationTime()+" System Access Time : "+
				getAccessStartTime()+" to "+getAccessEndTime()+" label direction "+getLabelDirection()+" and language "+getLanguageCode();
		return toString;
		}
}

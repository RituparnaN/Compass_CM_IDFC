package com.quantumdataengines.app.compass.listner;

import java.net.Socket;

import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;

import com.quantumdataengines.app.compass.util.ChatUserContextHolder;
import com.quantumdataengines.app.compass.util.SessionContextHolder;

public class CompassSessionListener implements HttpSessionListener{

	@Override
	public void sessionCreated(HttpSessionEvent event) {
		HttpSession session = event.getSession();
		SessionContextHolder.setSession(session.getId(), session);
	}

	@SuppressWarnings("deprecation")
	@Override
	public void sessionDestroyed(HttpSessionEvent event) {
		String sessionId = event.getSession().getId();
		String instituteName = (String) event.getSession().getAttribute("instituteName");
		
		String USERCODE = (String) event.getSession().getAttribute("USERCODE");
		if(instituteName != null && USERCODE != null){
			Socket userServerSocket = (Socket) ChatUserContextHolder.getUserContextDetails(instituteName, USERCODE, "SERVERSOCKET");
			Socket userClientSocket = (Socket) ChatUserContextHolder.getUserContextDetails(instituteName, USERCODE, "CLIENTSOCKET");
			Thread userThread = (Thread) ChatUserContextHolder.getUserContextDetails(instituteName, USERCODE, "THREAD");
			try{
				userClientSocket.close();
			}catch(Exception e){}
			try{
				userServerSocket.close();
			}catch(Exception e){}
			try{
				userThread.stop();
			}catch(Exception e){}
			ChatUserContextHolder.removeUserConttext(USERCODE, instituteName);
		}
		SessionContextHolder.removeSession(sessionId);
	}

}

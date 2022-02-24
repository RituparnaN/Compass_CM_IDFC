package com.quantumdataengines.app.compass.listner;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.net.ServerSocket;
import java.net.Socket;
import java.net.SocketException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.quantumdataengines.app.compass.dao.CommonDAO;
import com.quantumdataengines.app.compass.model.ChatMessage;
import com.quantumdataengines.app.compass.util.ChatMessageHolder;
import com.quantumdataengines.app.compass.util.ChatUserContextHolder;
import com.quantumdataengines.app.compass.util.ConfigurationsDetails;

@Component
public class ChatServerListner {
	private static final Logger log = LoggerFactory.getLogger(ChatServerListner.class);
	@Autowired
	private ConfigurationsDetails configurationsDetails;
	@Autowired
	private CommonDAO commonDAO;
	
	public ChatServerListner(){
		/*
		try{
			final ServerSocket serverSocket = new ServerSocket(8189);
			log.info("Chat server is up. Connect to "+serverSocket.getLocalSocketAddress().toString());
			checkSocket().start();
			Thread serverThread = new Thread(new Runnable() {
				@Override
				public void run() {
					while(true) {
						try{
							Socket socket = serverSocket.accept();					
							Runnable runnable = new ClientHandler(socket, configurationsDetails, commonDAO);
							Thread serverThread = new Thread(runnable);
							serverThread.start();
						}catch(Exception e){
							e.printStackTrace();
							log.error("Error while registering chat client : "+e.getMessage());
						}
					}
				}
			});
			serverThread.start();
		}catch(Exception e){
			e.printStackTrace();
			log.error("Error while creating chat server : "+e.getMessage());
		}
	  */	
	}
	
	public Thread checkSocket() throws Exception{
		ConfigurationsDetails configurationsDetails = new ConfigurationsDetails();
		final List<String> innstitutions = configurationsDetails.getInstitutionsList();
		Thread socketCheckThread = new Thread(new Runnable() {
			@SuppressWarnings("deprecation")
			@Override
			public void run() {
				while(true){
					try{
						for(String institution : innstitutions){
							Map<String, Map<String, Object>> getAllUserForInstitution = ChatUserContextHolder.getAllUserForInstitution(institution);
							if(getAllUserForInstitution != null){
								List<String> allUsers = new ArrayList<String>(getAllUserForInstitution.keySet());
								for(String user : allUsers){
									try{
										Map<String, Object> userDetails = getAllUserForInstitution.get(user);
										Socket userServerSocket = (Socket) userDetails.get("SERVERSOCKET");
										Socket userClientSocket = (Socket) userDetails.get("SERVERSOCKET");
										Thread thread = (Thread) userDetails.get("THREAD");
										if(!userServerSocket.isConnected()){
											try{
												userServerSocket.close();
											}catch(Exception e){}
											try{
												userClientSocket.close();
											}catch(Exception e){}
											try{
												thread.stop();
											}catch(Exception e){}
											ChatUserContextHolder.removeUserConttext(user, institution);
										}
									}catch(Exception e){e.printStackTrace();}
								}
							}
						}
						// Thread.sleep(5000);
						Thread.sleep(300000);
					}catch(Exception e){e.printStackTrace();}
				}
			}
		});
		return socketCheckThread;
	}
}

@Component
class ClientHandler implements Runnable{
	private static final Logger log = LoggerFactory.getLogger(ChatServerListner.class);
	CommonDAO commonDAO;
	ConfigurationsDetails configurationsDetails;
	Socket socket;
	BufferedReader br;
	PrintWriter out;
	
	public ClientHandler(){}
	
	public ClientHandler(Socket socket, ConfigurationsDetails configurationsDetails, CommonDAO commonDAO) {
		this.socket = socket;
		this.configurationsDetails = configurationsDetails;
		this.commonDAO = commonDAO;
	}
	
	@SuppressWarnings("deprecation")
	@Override
	public void run() {
		try{
			OutputStream outstream = socket.getOutputStream();
		    br = new BufferedReader(new InputStreamReader(socket.getInputStream()));	
		    out = new PrintWriter(outstream,true);
		    String message = "";
			while((message = br.readLine()) != null){
				try{
					System.out.println("Message in server : "+message);
					String[] messagePerser = message.split("%;%");
					if(messagePerser[0].equals("LOGIN")){
						log.info("Login request processing in chat server...");
						String institution = messagePerser[1];
						String userName = messagePerser[2];
						ChatUserContextHolder.setUserContextDetails(institution, userName, "STATUS", "A");
						ChatUserContextHolder.setUserContextDetails(institution, userName, "SERVERSOCKET", socket);
						log.info(userName+" logged into chat server");
					}
					
					if(messagePerser[0].equals("CHAT")){
						String institution = messagePerser[1];
						String userFrom = messagePerser[2];
						String userTo = messagePerser[3];
						String userFromName = messagePerser[4];
						String userToName = messagePerser[5];
						String chatWindowId = messagePerser[6];
						String messageId = messagePerser[7];
						String chatMessage = messagePerser[8];
						String sendTime = messagePerser[9];
						String receiveTime = getDate();
						
						Socket messageToSocket = (Socket) ChatUserContextHolder.getUserContextDetails(institution, userTo, "SERVERSOCKET");
						
						ChatMessage chatMessageObj = new ChatMessage();
						chatMessageObj.setChatWindowId(chatWindowId);
						chatMessageObj.setFromUser(userFrom);
						chatMessageObj.setToUser(userTo);
						chatMessageObj.setToUserName(userFromName);
						chatMessageObj.setMessageId(messageId);
						chatMessageObj.setMessageContent(chatMessage);
						chatMessageObj.setMessageSentDate(sendTime);
						chatMessageObj.setMessageReceiveDate(receiveTime);
						
						String jndiName = configurationsDetails.getConfigurationForInstitution(institution).getJndiDetails().getJndiName();
						
						if(messageToSocket != null && messageToSocket.isConnected()){
							chatMessageObj.setStatus("Message sent to "+userFromName);
							PrintWriter friendPW = new PrintWriter(messageToSocket.getOutputStream(),true);
							friendPW.println("CHATMESSAGE%;%"+institution+"%;%"+userFrom+"%;%"+userTo+"%;%"+userFromName+"%;%"+chatWindowId+"%;%"+messageId+"%;%"+chatMessage+"%;%"+sendTime+"%;%"+receiveTime);
							commonDAO.saveChatMessage(jndiName, chatWindowId, messageId, userFrom, userTo, chatMessage, "Y");
						}else{
							ChatMessageHolder.storeOfflineMessage(chatWindowId, messageId, chatMessageObj);
							chatMessageObj.setStatus("Message will be sent when "+userToName+" is online");
							commonDAO.saveChatMessage(jndiName, chatWindowId, messageId, userFrom, userTo, chatMessage, "N");
						}
					}
					
					if(messagePerser[0].equals("STATUS")){
						String institution = messagePerser[1];
						String userFrom = messagePerser[2];
						String status = messagePerser[3];
						String actualStatus = (String) ChatUserContextHolder.getUserContextDetails(institution, userFrom, "STATUS");
						if(actualStatus.equals("O")){
							if(status.equals("A")){
								log.info("Setting "+userFrom+" available...");								
							}else if(status.equals("B")){
								log.info("Setting "+userFrom+" busy...");
							}
							ChatUserContextHolder.setUserContextDetails(institution, userFrom, "STATUS", status);
						}else{
							if(status.equals("A")){
								log.info("Setting "+userFrom+" available...");
								ChatUserContextHolder.setUserContextDetails(institution, userFrom, "STATUS", status);
							}else if(status.equals("B")){
								log.info("Setting "+userFrom+" busy...");
								ChatUserContextHolder.setUserContextDetails(institution, userFrom, "STATUS", status);
							}else{
								log.info("Setting "+userFrom+" offline...");
								Socket serverSocket = (Socket) ChatUserContextHolder.getUserContextDetails(institution, userFrom, "SERVERSOCKET");
								Socket clientSocket = (Socket) ChatUserContextHolder.getUserContextDetails(institution, userFrom, "CLIENTSOCKET");
								Thread clientThread = (Thread) ChatUserContextHolder.getUserContextDetails(institution, userFrom, "THREAD");
								try{
									serverSocket.close();
								}catch(Exception e){}
								try{
									clientSocket.close();
								}catch(Exception e){}
																
								clientThread.stop();
								ChatUserContextHolder.removeUserConttext(userFrom, institution);
							}
						}						
					}					
					message = "";
				}catch(Exception e){
					e.printStackTrace();
					log.error("Error in chat server : "+e.getMessage());
				}
			}
			
		}catch(Exception e){
			if(e instanceof SocketException){
				if(e.getMessage().equals("socket closed")){
					log.warn("Socket exception (ingnore) \n"+e.toString());
				}else{
					e.printStackTrace();
				}
			}else{
				e.printStackTrace();
			}
		}
	}		
	
	public String getDate(){
		String strDate = "";
		try{
			SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
			strDate = sdf.format(new Date());
		}catch(Exception e){
			log.error("Error while formatting date : "+e.getMessage());
			e.printStackTrace();
		}
		return strDate;
	}
}

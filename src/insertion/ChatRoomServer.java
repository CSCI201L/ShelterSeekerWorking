package insertion;

import java.io.IOException;
import java.util.Vector;

import javax.websocket.OnClose;
import javax.websocket.OnError;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.ServerEndpoint;

@ServerEndpoint(value = "/chatroomServerEndpoint")
public class ChatRoomServer {

	private static Vector<Session> sessionVector = new Vector<Session>();
	
	@OnOpen
	public void open(Session session) {
		//System.out.println("Connection made!");
		sessionVector.add(session);
	}
	
	@OnMessage
	public void onMessage(String message, Session session) {
//		String username = (String) session.getUserProperties().get("username");
		String initialData = (String) session.getUserProperties().get("initialData");
		try {
			if(initialData == null) {
				session.getUserProperties().put("username", message.substring(0, message.indexOf("|")));
				session.getUserProperties().put("shelterID", message.substring(message.indexOf("|") + 1, 
					message.length()));
				session.getUserProperties().put("initialData", "true");
				//session.getBasicRemote().sendText(username + "nhas joined the conversation!");
			}
			else
			{
				String shelterID = message.substring(0, message.indexOf("|"));
				String messageContent = message.substring(message.indexOf("|") + 1, message.length());
				for(Session s : sessionVector) {
					if (((String)s.getUserProperties().get("shelterID")).equals(shelterID)) {
						s.getBasicRemote().sendText("@" + session.getUserProperties().get("username") 
							+ ": " + messageContent);
						System.out.println("Sending this message: " + messageContent);
					}
					else {
						System.out.println(shelterID);
						System.out.println(s.getUserProperties().get("shelterID"));
					}
				}
			}
		} catch (IOException ioe) {
			System.out.println("ioe: " + ioe.getMessage());
			close(session);
		}
	}
	
	@OnClose
	public void close(Session session) {
		//System.out.println("Disconnecting!");
		sessionVector.remove(session);
	}
	
	@OnError
	public void error(Throwable error) {
		System.out.println("Error!");
	}
}
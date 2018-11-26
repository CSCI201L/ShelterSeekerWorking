package retrieval;
import java.time.format.DateTimeFormatter;
import java.time.LocalDateTime;

public class Message {
	public int id;
	public String subject;
	public String body;
	public String recipient;
	public String sender;
	public Byte read = 0;
	public long timeSent = 0;
	public String isAvailabilityRequest;

	// Default constructor
	public Message() {
		this.subject = "";
		this.body = "";
		this.recipient = "";
		this.sender = "";
		this.id = 0;
	}

	//Constructor that actually sets values
	public Message(String subject, String body, String sender, String recipient) {
		this.subject = subject;
		this.body = body;
		this.sender = sender;
		this.recipient = recipient;
		this.id = 0;

		DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyyMMddHHmmss");
		LocalDateTime now = LocalDateTime.now();

		timeSent = Long.parseLong(dtf.format(now));
	}

	//Getters
	public String getSubject() {
		return subject;
	}

	public String getBody() {
		return body;
	}
	
	public String getBodyReadable() {
		if(body.length() >= 20) return body.substring(0, 20) + "...";
		else return body.substring(0,body.length() - 1) + "...";
	}

	public String getRecip() {
		return recipient;
	}

	public String getSender() {
		return sender;
	}

	public Byte getRead() {
		return read;
	}
	
	public int getID() {
		return id;
	}
	
	public void setID(int id) {
		this.id = id;
	}

	//Returns the timestamp as a printable string
	public String getTime() {

		String time = Long.toString(this.timeSent);
		String returnTime = "";

		for(int i = 0; i < time.length(); i++) {
			returnTime =  returnTime + time.charAt(i);
			if(i == 3 || i == 5) returnTime = returnTime + "/";
			if(i ==7) returnTime = returnTime + " ";
			if(i == 9 || i == 11) returnTime = returnTime + ":";
		}

		return returnTime;
	}
	//Getters

	//Parse into readable format for testing
	public String readable() {
		return "Message from " + getSender() + ": <br />" + getSubject() + ": <br />" + getBodyReadable() + "<br /> Sent at " + getTime();
	}

	//Set whether a message is read
	public void read() {
		this.read = 1;
	}
}
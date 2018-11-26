package retrieval;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


@WebServlet("/SendMessage")
public class SendMessage extends HttpServlet {
	private static final long serialVersionUID = 1L;
       

    public SendMessage() {
        super();
    }

	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		DBHelper db = (DBHelper) request.getSession().getAttribute("DBHelper");
		System.out.println("In SendMessage service");
		System.out.println(db.didConnect() + " is the connection status");
		String subject = request.getParameter("subject");
		String recip = request.getParameter("recipient");
		String body = request.getParameter("message");
		String sender = request.getParameter("sender");
		String isAvailabilityRequest = request.getParameter("isAvailabilityRequest");
		System.out.println("Availability Request? " + isAvailabilityRequest);
		System.out.println(recip);
		System.out.println(sender);
		System.out.println(subject);
		System.out.println(body);
		
		boolean test = db.unameExists(recip);
		System.out.println("Does the recipient exist? " + test);
		
		response.setContentType("text");
		PrintWriter out = response.getWriter();
		if (test == false) {
			out.println("recipientDoesntExist");
		} else if (test == true) {
			Message m = new Message(subject, body, sender, recip);
			m.isAvailabilityRequest = isAvailabilityRequest;
			db.sendMessage(m);
		}
	}

}

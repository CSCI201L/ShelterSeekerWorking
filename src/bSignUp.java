

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.util.Base64;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
//import javax.xml.bind.DatatypeConverter;
//
//import org.apache.commons.io.IOUtils;

import retrieval.DBHelper;
import retrieval.UserInfo;

/**
 * Servlet implementation class bSignUp
 */
@MultipartConfig(maxFileSize = 16177215)
@WebServlet("/bSignUp")
public class bSignUp extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public bSignUp() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		System.out.println("afsf");
		String username = request.getParameter("username");
		String email = request.getParameter("email");
		if (email ==null) {
			System.out.println("Unsuccessful transfer");
			RequestDispatcher dispatch = getServletContext().getRequestDispatcher("/userregister.jsp");
			try {
	    		dispatch.forward(request,response);
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (ServletException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			return;
		}
		String password = request.getParameter("password");
		int zipcode =Integer.parseInt( request.getParameter("zipcode"));
		String phone = request.getParameter("phone");
		String[] pets = request.getParameterValues("pets");
		String address = request.getParameter("address");
		String[] children = request.getParameterValues("children");
		String[] img = request.getParameterValues("image");
		String base64 = request.getParameter("base64");
		//System.out.println(base64 + "should be blob");
		byte[] decodedByte = null;
		if (!base64.equals("")) {
//			 decodedByte = DatatypeConverter.parseBase64Binary(base64);	 
		}else {
			System.out.println("blob empty");
		}
		//String decoded = Base64.getEncoder().encodeToString(decodedByte);

//		if (decoded.equalsIgnoreCase(base64)) {
//			System.out.println("Conversion wored");
//		}else {
//			System.out.println("Conversion failed because decoded is " + decoded);
//		}
		System.out.println("PRINTING SHIT");
		System.out.println("IMAGE STUFF");
//		for (String s: img) {
//			System.out.println(s);
//		}
		System.out.println("pets stuff");
		for (String s: pets) {
			System.out.println(s);
		}
		System.out.println("children stuff");
		for (String s: children) {
			System.out.println(s);
		}
		
		//img = "/" + img;
		//System.out.println("Image is " + img);
		UserInfo u = new UserInfo ();
		u.address = address;
		u.username = username;
		u.email = email;
		u.password = password;
		u.phoneNumber = phone;
		String path = "/userregister.jsp";
		boolean error = false;
		if (email.equals ("") || password.equals("") || username.equals("") ) {
			error = true;
		}
		if (DBHelper.userExists(email) && !error) {
			request.setAttribute("err", "User Already Exists");
		} else {
		System.out.println(pets);
		
		u.zipcode = zipcode;
		if (pets[0].equalsIgnoreCase("on")) {
			u.pets = 1;
		} else {
			u.pets = 0;
		}
		if (children[0].equalsIgnoreCase("on")) {
			u.kids = 1;
		} else {
			u.kids = 0;
		}
		u.isShelter = 0;
		
		 DBHelper db = new DBHelper("dne","dne");
			db.addNormalUser(u);
			db = new DBHelper(email,password);
		//db.addImage(username, decodedByte);
			//ADD HTTP SESSION HERE
			HttpSession session = request.getSession();
			session.setAttribute("DBHelper", db);
			if (db.didConnect()) {
				path = "/userhomepage.jsp";
			} else {
				request.setAttribute("err", "Creation Failed");
			}
		}
		RequestDispatcher dispatch = getServletContext().getRequestDispatcher(path);
    	
    	try {
    		dispatch.forward(request,response);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (ServletException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		System.out.println("afsf");
		String username = request.getParameter("username");
		String email = request.getParameter("email");
		if (email ==null) {
			System.out.println("Unsuccessful trnsfer");
			RequestDispatcher dispatch = getServletContext().getRequestDispatcher("/userregister.jsp");
			try {
	    		dispatch.forward(request,response);
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (ServletException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			return;
		}
		String password = request.getParameter("password");
		int zipcode =Integer.parseInt( request.getParameter("zipcode"));
		String phone = request.getParameter("phone");
		String[] pets = request.getParameterValues("pets");
		String address = request.getParameter("address");
		String[] children = request.getParameterValues("children");
		//String[] img = request.getParameterValues("image");
		String base64 = request.getParameter("base64");
		Part filePart = request.getPart("f");
		InputStream inputStream = null;
		if (filePart != null) {
			 
			inputStream = filePart.getInputStream();
		}
		byte[] decodedByte =null;

		if (inputStream==null) {
			System.out.println("FILEPART NOT READ");
		}else {
			System.out.println("inputstream should work");
		}
		//decodedByte =IOUtils.toByteArray(inputStream);	 
//		IOUtils.toByteArray(inputStream);
	//	String str = new sun.misc.BASE64Encoder().encode(decodedByte);

		
		//System.out.println(base64 + "should be blob");
//		if (!base64.equals("")) {
//			 decodedByte = DatatypeConverter.parseBase64Binary(base64);	 
//		}else {
//			System.out.println("blob empty");
//		}
		//String decoded = new String(Base64.getDecoder().decode(decodedByte));

//		if (decoded.equalsIgnoreCase(base64)) {
//			System.out.println("Conversion wored");
//		}else {
//			System.out.println("Conversion failed because decoded is ");
//		}
//		System.out.println("PRINTING SHIT");
		System.out.println("IMAGE STUFF");
//		for (String s: img) {
//			System.out.println(s);
//		}
		System.out.println("pets stuff");
		for (String s: pets) {
			System.out.println(s);
		}
		System.out.println("children stuff");
		for (String s: children) {
			System.out.println(s);
		}
		
		//img = "/" + img;
		//System.out.println("Image is " + img);
		UserInfo u = new UserInfo ();
		u.address = address;
		u.username = username;
		u.email = email;
		u.password = password;
		u.phoneNumber = phone;
		String path = "/userregister.jsp";
		boolean error = false;
		if (email.equals ("") || password.equals("") || username.equals("") ) {
			error = true;
		}
		if (DBHelper.userExists(email) && !error) {
			request.setAttribute("err", "User Already Exists");
		} else {
		System.out.println(pets);
		
		u.zipcode = zipcode;
		if (pets[0].equalsIgnoreCase("on")) {
			u.pets = 1;
		} else {
			u.pets = 0;
		}
		if (children[0].equalsIgnoreCase("on")) {
			u.kids = 1;
		} else {
			u.kids = 0;
		}
		u.isShelter = 0;
		
		 DBHelper db = new DBHelper("dne","dne");
			db.addNormalUser(u);
			db = new DBHelper(email,password);
			db.addImage(username, base64);
			//ADD HTTP SESSION HERE
			HttpSession session = request.getSession();
			session.setAttribute("DBHelper", db);
			if (db.didConnect()) {
				path = "/userhomepage.jsp";
			} else {
				request.setAttribute("err", "Creation Failed");
			}
		}
		RequestDispatcher dispatch = getServletContext().getRequestDispatcher(path);
    	
    	try {
    		dispatch.forward(request,response);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (ServletException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}	}

}

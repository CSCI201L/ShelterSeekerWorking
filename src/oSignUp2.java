

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import retrieval.DBHelper;
import retrieval.Shelter;
import retrieval.UserInfo;

/**
 * Servlet implementation class oSignUp2
 */
@WebServlet("/oSignUp2")
public class oSignUp2 extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public oSignUp2() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		String username = request.getParameter("username");
		String email = request.getParameter("email");
		String password = request.getParameter("password");
		System.out.println(email +"is the email");
		int zipcode =Integer.parseInt(request.getParameter("zipcode"));
		String phone = request.getParameter("phone");
		String children = request.getParameter("children");
		String pets = request.getParameter("pets");
		String pharmacy = request.getParameter("pharmacy");
		String grocery = request.getParameter("grocery");
		String laundromat = request.getParameter("laundromat");
		String address = request.getParameter("address");
		int capacity = Integer.parseInt(request.getParameter("capacity"));
		int occupants = Integer.parseInt(request.getParameter("occupants"));
		String bio = request.getParameter("bio");

		UserInfo u = new UserInfo();
		u.isShelter = 1;
		u.username = username;
		u.email = email;
		u.password = password;
		u.zipcode = zipcode;
		u.phoneNumber = phone;
		Shelter sh = new Shelter();
		sh.bio =  bio;
		sh.address = address;
		sh.capacity = capacity;
		sh.numStays = occupants;
		sh.phoneNumber = phone;
		sh.zipcode = zipcode;
		sh.availability = capacity - occupants;
		if (laundromat.equals("yes")) {
			sh.nearLaundromat = 1;
		}else {
			sh.nearLaundromat = 0; 
		}
		if (grocery.equals("yes")) {
			sh.nearGrocery = 1;
		}else {
			sh.nearGrocery = 0; 
		}
		if (pharmacy.equals("yes")) {
			sh.nearPharmacy = 1;
		}else {
			sh.nearPharmacy = 0; 
		}
		
		if (children.equals("yes")) {
			sh.kids = 1;
		}else {
			sh.kids = 0; 
		}
		if (pets.equals("yes")) {
			sh.pets = 1;
		}else {
			sh.pets = 0; 
		}
		DBHelper db = new DBHelper("guest","guest");
		db.createOrg(u, sh);
		//THIS SHOULD BE A VALID DBHELPER
		db = new DBHelper (email,password);
		String path = "/userregister.jsp";
		
		boolean error = false;
		if (email.equals ("") || password.equals("") || username.equals("") ) {
			error = true;
		}
		HttpSession session = request.getSession();
		session.setAttribute("DBHelper", db);
		if (!db.didConnect() && !error) {
			request.setAttribute("err", "User Already Exists");
			path = "/orgreg2.jsp";
		} else {
			path = "/orgstats.jsp";
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
		doGet(request, response);
	}

}

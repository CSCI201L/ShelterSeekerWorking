	

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import retrieval.DBHelper;
import retrieval.UserInfo;

/**
 * Servlet implementation class oSignUp1
 */
@WebServlet("/oSignUp1")
public class oSignUp1 extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public oSignUp1() {
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
		int zipcode =Integer.parseInt( request.getParameter("zipcode"));
		String phone = request.getParameter("phone");



		String path = "/userregister.jsp";
		boolean error = false;
		if (email.equals ("") || password.equals("") || username.equals("") ) {
			error = true;
		}
		if (DBHelper.userExists(email) && !error) {
			request.setAttribute("err", "User Already Exists");
			path = "/orgreg1.jsp";
		} else {
			path = "/orgreg2.jsp";
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

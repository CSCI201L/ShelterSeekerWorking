

import java.io.IOException;
import java.util.regex.Pattern;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import retrieval.DBHelper;

/**
 * Servlet implementation class bUpdateUser
 */
@WebServlet("/t")
public class bUpdateUser extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public bUpdateUser() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		String email = request.getParameter("new_email");
		String curr_password = request.getParameter("current_password");
		String new_password = request.getParameter("new_password");
		String zipcode = request.getParameter("new_zipcode");
		String phonenum = request.getParameter("new_phone");
		String kids=request.getParameter("children");
		String pet=request.getParameter("pets");
		int children=0;
		if(kids.length()>0) {
			 children = Integer.parseInt(kids);
		}
		int pets=0;
		if(pet.length()>0) {
			 pets=Integer.parseInt(pet);
		}
		//make sure they all are valid
		boolean error  = false;
		//check email
		String email_err = "";
		//System.out.println(email.length()+" kajfkl"+curr_password.length());
		boolean changeemail=false;
		if(email.length()>0) {
			if(!checkEmail(email)) {
				//System.out.println("fail email");
				email = "";
				email_err = "invalid email format";
				request.setAttribute("email_err","invalid email format");
			}
			
			if(curr_password.length()<1)
			{
				request.setAttribute("currpass_err","must enter password to change email");
				error = true;
			}
			changeemail=true;
		}
		boolean changepassword=false;
		if(!changeemail) 
		{
			if(curr_password.length()>0&&new_password.length()>0) {
				changepassword=true;
			}
			//System.out.println(curr_password.length()+new_password.length());
			if(curr_password.length()>0&&new_password.length()<1) 
			{
				request.setAttribute("newpass_err","need to enter new password to update");
				error=true;
			}
			
			if(curr_password.length()<1&&new_password.length()>0) {
				request.setAttribute("currpass_err","need to enter current password to update");
				error=true;
			}
		}
		//check zipcode
		String zip_err="";
		boolean changezip=false;
		//System.out.println(zipcode.length());
		int zip=0;
		if(zipcode.length()>0) {
			try {
				zip=Integer.parseInt(zipcode);
				if(zipcode.length()!=5) {
					zip_err="must enter valid zip code of 5 digits";
					request.setAttribute("zip_err","must enter valid zip code of 5 digits");
					error=true;
				}
				changezip=true;
			}catch(NumberFormatException e){
				zip_err="must enter vaild zip code that are numbers";
				request.setAttribute("zip_err","must enter valid zip code that are numbers");
				error=true;
			}
		}
		//check phone number
		String phone_error="";
		boolean changephone=false;
		//int phone=0;
		if(phonenum.length()>0) {
			changephone=true;
		}
		//change kids
		if("1".equals(kids)) {
			children=1;
		}
		else {
			children=0;
		}
		//change pets
		if("1".equals(pet)) {
			pets=1;
		}
		else {
			pets=0;
		}
//		//proceed to update settings
		DBHelper db =(DBHelper) request.getSession().getAttribute("DBHelper");
		
		//update the user instance in the class
		//update email 
		db.user.email=email;
		//if change password, update password
		if(changepassword) {
			db.user.password = new_password;
		}
		//if not change password
		else {
			db.user.password = curr_password;
		}
		//if change zip, update zip
		if(changezip) {
			db.user.zipcode=zip;
		}
		//if change phone, update phone
		if(changephone) {
			db.user.phoneNumber=phonenum;
		}
		//update kids/pets if so
		db.user.kids=children;
		db.user.pets=pets;
		//actually add to db
		db.updateUserSettings(db.user);
		
		//final redirection
		String path;
		if (error) {
			path = "/usersettings.jsp";
		} else {
			path = "/userhomepage.jsp";
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
	public static boolean checkEmail(String email) {
		String regex="^[a-zA-Z0-9_+&*-]+(?:\\."+ 
                "[a-zA-Z0-9_+&*-]+)*@" + 
                "(?:[a-zA-Z0-9-]+\\.)+[a-z" + 
                "A-Z]{2,7}$";
		Pattern pat= Pattern.compile(regex);
		if(email!=null)
			return pat.matcher(email).matches();
		else
			return false;
	}
}
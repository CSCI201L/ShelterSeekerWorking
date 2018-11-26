package insertion;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/searchResult")
public class searchResult extends HttpServlet {
	private static final long serialVersionUID = 1L;
       

    public searchResult() {
        super();
    }

	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			int shelterId = Integer.parseInt(request.getParameter("shelterId"));
			System.out.println("In search result service with shelterId = " + shelterId);
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/safeHands?user=root&password=root&useSSL=false");
			ps = conn.prepareStatement("SELECT * FROM shelterInfo WHERE id=?");
			ps.setInt(1, shelterId);
			rs = ps.executeQuery();
			Shelter shelter = new Shelter();
			rs.next();
			shelter.availability = rs.getInt("availability");
			shelter.bio = rs.getString("biography");
			shelter.id = rs.getInt("id");
			shelter.kids = rs.getInt("kids");
			shelter.pets = rs.getInt("pets");
			shelter.phoneNumber = rs.getString("phoneNumber");
			shelter.currentRating = rs.getDouble("currentRating");
			shelter.zipcode = rs.getInt("zipCode");
			shelter.nearPharmacy = rs.getByte("nearPharmacy");
			shelter.nearGrocery = rs.getByte("nearGrocery");
			shelter.nearLaundromat = rs.getByte("nearLaundromat");
			shelter.shelterName = rs.getString("own");
			request.setAttribute("availability", Integer.toString(shelter.availability));
			request.setAttribute("zipCode", Integer.toString(shelter.zipcode));
			request.setAttribute("phoneNumber", shelter.phoneNumber);
			request.setAttribute("kids", Integer.toString(shelter.kids));
			request.setAttribute("pets", Integer.toString(shelter.pets));
			request.setAttribute("bio", shelter.bio);
			request.setAttribute("currentRating", Double.toString(shelter.currentRating));
			request.setAttribute("nearPharmacy", shelter.nearPharmacy == 1 ? "Yes" : "No");
			request.setAttribute("nearGrocery", shelter.nearGrocery == 1 ? "Yes" : "No");
			request.setAttribute("nearLaundromat", shelter.nearLaundromat == 1 ? "Yes" : "No");
			request.setAttribute("shelterID", Integer.toString(shelterId));
			request.setAttribute("shelterName", shelter.shelterName);
			request.getRequestDispatcher("orgpublicprofile.jsp").forward(request, response);
			
		} catch (Exception e) {
			System.out.println(e.getMessage());
			System.out.println(e.getStackTrace());
		}
		
	}


}
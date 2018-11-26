package insertion;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/ChangeAvailability")
public class ChangeAvailability extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public ChangeAvailability() {
        super();
    }
    
	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/safeHands?user=root&password=root&useSSL=false");
			response.setContentType("text");
			PrintWriter out = response.getWriter();
			System.out.println("In ChangeAvailability service");
			String shelterName = request.getParameter("shelterName");
			int availabilityUpdate = Integer.parseInt(request.getParameter("availabilityUpdate"));
			
			ps = conn.prepareStatement("SELECT availability from shelterInfo where own=?");
			ps.setString(1, shelterName);
			rs = ps.executeQuery();
			rs.next();
			int currentAvailability = rs.getInt("availability");
			if (currentAvailability + availabilityUpdate < 0) {
				out.println("Invalid availabilityUpdate parameter");
				return;
			} else {
				ps = conn.prepareStatement("UPDATE shelterInfo SET availability=? where own=?");
				ps.setInt(1, currentAvailability + availabilityUpdate);
				ps.setString(2, shelterName);
				ps.execute();
			}
			System.out.println("Successfully updated shelter with name " + shelterName + 
				"to have availability " + (currentAvailability + availabilityUpdate));
			
		} catch (SQLException sqe) {
			System.out.println("sqe in ChangeAvailability: " + sqe.getMessage());
		} catch (ClassNotFoundException cnfe) {
			System.out.println("cnfe in ChangeAvailability: " + cnfe.getMessage());
		} catch (Exception e) {
			System.out.println("e in ChangeAvailability: " + e.getMessage());
		}
	}

}

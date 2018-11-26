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

@WebServlet("/GiveRating")
public class GiveRating extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public GiveRating() {
        super();
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/safeHands?user=root&password=root&useSSL=false");
			System.out.println("In GiveRating service");
			int shelterID = Integer.parseInt(request.getParameter("shelterID"));
			double rating = Double.parseDouble(request.getParameter("rating"));
			boolean newRating = false;
			
			ps = conn.prepareStatement("SELECT userID from users where email=?");
			ps.setString(1, request.getParameter("email"));
			rs = ps.executeQuery();
			rs.next();
			int userID = rs.getInt("userID");
			System.out.println(userID + " called GiveRating for shelter with id " + shelterID + " rating: " + rating);
			
			ps = conn.prepareStatement("SELECT numRatingGiven, currentRating from shelterInfo where id=?");
			ps.setInt(1, shelterID);
			rs = ps.executeQuery();
			rs.next();
			int numRatings = rs.getInt("numRatingGiven");
			double oldShelterRating = rs.getDouble("currentRating");
			
			// Check if this is a new rating
			ps = conn.prepareStatement("SELECT ratingID from ratings where userID=? and shelterID=?");
			ps.setInt(1, userID);
			ps.setInt(2, shelterID);
			rs = ps.executeQuery();
			if (!rs.next()) newRating = true;
			System.out.println("New Rating: " + newRating);
			
			double newShelterRating = -1;
			if (newRating) { // Case where user has not given yet this shelter a rating
				ps = conn.prepareStatement("INSERT INTO ratings(shelterID, userID, rating) values(?,?,?)");
				ps.setInt(1, shelterID);
				ps.setInt(2, userID);
				ps.setDouble(3, rating);
				ps.execute();
				
				newShelterRating = ((oldShelterRating * numRatings) + rating) / (numRatings + 1);
				ps = conn.prepareStatement("UPDATE shelterInfo SET numRatingGiven=?, currentRating=? where id=?");
				ps.setInt(1, numRatings + 1);
				ps.setDouble(2, newShelterRating);
				ps.setInt(3, shelterID);
				ps.execute();
			} else {
				if (ps != null) ps.close();		
				ps = conn.prepareStatement("SELECT rating FROM ratings where shelterID=? and userID!=?");
				ps.setInt(1, shelterID);
				ps.setInt(2, userID);
				rs = ps.executeQuery();
				double otherRatings = 0;
				while(rs.next()) {
					otherRatings += rs.getDouble("rating");
					System.out.println(otherRatings);
				}
				System.out.println(rating);
				System.out.println(numRatings);
				
				ps = conn.prepareStatement("UPDATE ratings SET rating=? where shelterID=? and userID=?");
				ps.setDouble(1, rating);
				ps.setInt(2, shelterID);
				ps.setInt(3, userID);
				ps.execute();
				
				newShelterRating = (otherRatings + rating) / numRatings;// ((oldShelterRating * (numRatings - 1)) + rating) / (numRatings);
				ps = conn.prepareStatement("UPDATE shelterInfo SET currentRating=? where id=?");
				ps.setDouble(1, newShelterRating);
				ps.setInt(2, shelterID);
				ps.execute();
			}
			
			response.setContentType("text");
			PrintWriter out = response.getWriter();
			out.println(newShelterRating);
		} catch (SQLException sqe) {
			System.out.println("sqe in GiveRating: " + sqe.getMessage());
		} catch (ClassNotFoundException cnfe) {
			System.out.println("cnfe in GiveRating: " + cnfe.getMessage());
		} catch (Exception e) {
			System.out.println("e in GiveRating: " + e.getMessage());
		}
		
		
	}


}
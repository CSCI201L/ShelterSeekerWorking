package insertion;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLEncoder;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import retrieval.DBHelper;

@WebServlet("/Search")
public class Search extends HttpServlet {
	private static final long serialVersionUID = 1L;
	static final String databaseUserName = "root";
	static final String databasePassword = "root";
	static final String databasePort = "3306";
	static final String databaseName = "safeHands";
	static final String googleAPIKey = "AIzaSyByHkT9nYExPGBdrF8go_Iep92WAnfloWk";
       
    public Search() {
        super();
    }

	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/safeHands?user=root&password=root&useSSL=false");
			String pharmacyNearby = request.getParameter("pharmacyNearby");
			String groceryNearby = request.getParameter("groceryNearby");
			String laundromatNearby = request.getParameter("laundromatNearby");
			String minRating = request.getParameter("minRating");
			String currentlyAvailable = request.getParameter("showAvailableOnly");
			int numKids = Integer.parseInt(request.getParameter("numKids"));
			int numPets = Integer.parseInt(request.getParameter("numPets"));
			String searcherAddress = request.getParameter("address");
			String searchByName = request.getParameter("searchByName");
			boolean doSearchByName = true;
			if (searchByName == "" || searchByName == null) doSearchByName = false;
			
			System.out.println("This user called search: " + request.getParameter("email"));
			try {
				ps = conn.prepareStatement("SELECT username from users where email=?");
				ps.setString(1, request.getParameter("email"));
				rs = ps.executeQuery();
				rs.next();
				String searcherUsername = rs.getString("username");
				System.out.println(searcherUsername);
				ps = conn.prepareStatement("SELECT * from userInfo where username=?");
				ps.setString(1, searcherUsername);
				rs = ps.executeQuery();
				rs.next();
				String userAddress = rs.getString("address");
				if (searcherAddress == "") searcherAddress = userAddress;
			} catch (Exception e) {
				System.out.println("Error finding user in search");
			}
			System.out.println(searcherAddress);
			
			String searchStatement = "SELECT s.* FROM users u, shelterInfo s where u.userID = s.id ";
			if(pharmacyNearby.equals("true")) searchStatement += " and nearPharmacy=1 ";
			if(groceryNearby.equals("true")) searchStatement += " and nearGrocery=1 ";
			if(laundromatNearby.equals("true")) searchStatement += " and nearLaundromat=1 ";
			if(currentlyAvailable.equals("true")) searchStatement += " and availability>0 ";
			if(doSearchByName) searchStatement += getAdditionalSearchStatement(searchByName);
			searchStatement += " and s.kids>=? ";
			searchStatement += " and s.pets >=? ";
			searchStatement += " and s.currentRating>=? ";
			ps = conn.prepareStatement(searchStatement);
			ps.setInt(1, numKids);
			ps.setInt(2, numPets);
			ps.setDouble(3, Double.parseDouble(minRating));
			
			System.out.println("Executing this query: " + searchStatement);
			rs = ps.executeQuery();
			ArrayList<Shelter> shelters = new ArrayList<Shelter>();
			
			while(rs.next()) {
				Shelter currentShelter = new Shelter();
				currentShelter.availability = rs.getInt("availability");
				currentShelter.bio = rs.getString("biography");
				currentShelter.id = rs.getInt("id");
				currentShelter.kids = rs.getInt("kids");
				currentShelter.pets = rs.getInt("pets");
				currentShelter.phoneNumber = rs.getString("phoneNumber");
				currentShelter.currentRating = rs.getDouble("currentRating");
				currentShelter.zipcode = rs.getInt("zipCode");
				currentShelter.shelterName = rs.getString("own");
				currentShelter.image = DBHelper.getImages(currentShelter.shelterName);
				shelters.add(currentShelter);
			}
			
			for(Shelter s : shelters) {
				URL url;
				try {
					url = new URL("https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial"
							+ "&origins=" + URLEncoder.encode(searcherAddress, "UTF-8") + "&destinations=" + 
							Integer.toString(s.zipcode) + "&key=" + googleAPIKey);
					System.out.println("URL: " + url);
					HttpURLConnection connection = (HttpURLConnection)url.openConnection();
					connection.setRequestMethod("GET");
				    connection.connect();
				    BufferedReader br = new BufferedReader(new InputStreamReader(connection.getInputStream()));
				    String line = br.readLine();
				    s.searchDistance = 0;
				    boolean distanceOnNextLine = false;
				    while (line != null) {
				    	if (distanceOnNextLine) {
				    		String distance = "";
				    		for(int i = 0; i < line.length(); i++) {
				    			if ((line.charAt(i) <= '9' && line.charAt(i) >= '0') || line.charAt(i) == '.') {
				    				distance += line.charAt(i);
				    			}
				    		}
				    		s.searchDistance = Double.parseDouble(distance);
				    		distanceOnNextLine = false;
				    	}
				    	if (line.contains("distance")) {
				    		distanceOnNextLine = true;
				    	}
				    	line = br.readLine();
				    }
				} catch (Exception e) {
					System.out.println("Error in google map API call: ");
					System.out.println(e.getMessage());
				}
			}
			
			
			Collections.sort(shelters, new Comparator<Shelter>() {	
				public int compare(Shelter lhs, Shelter rhs) {
			    	int result = (int)lhs.searchDistance - (int)rhs.searchDistance;
			    	if (result == 0) { // Same ZipCode, sort by rating
			    		if (lhs.currentRating > rhs.currentRating) result = -1;
			    		else result = 1;
			    	}
			    	return result;
				    // <0 = less than, >0 = greater than, 0 = equal
				}	
			});
			
	    	response.setContentType("text");
			PrintWriter out = response.getWriter();
			for(Shelter s : shelters) {
				out.println(s.id);
				out.println(s.shelterName);
				out.println(s.bio);
				if (!searcherAddress.equals("")) out.println(s.searchDistance);
				else out.println("Unknown");
//				out.println(s.image);
				System.out.println(s.id);
				System.out.println(s.shelterName);
				System.out.println(s.bio);
				System.out.println(s.searchDistance);
			}
	    	
		} catch (SQLException sqe) {
			System.out.println("sqe in search: " + sqe.getMessage());
		} catch (ClassNotFoundException cnfe) {
			System.out.println("cnfe in search: " + cnfe.getMessage());
		} catch (Exception e) {
			System.out.println("e in search: " + e.getMessage());
		}
	}
	
	private String getAdditionalSearchStatement(String s) {
		String additionalStatement = "and ( 0 ";
		char lastChar = ' ';
		String currentWord = "";
		for(int i = 0; i < s.length(); i++) {
			char currentChar = s.charAt(i);
			if (currentChar != ' ')
				currentWord += currentChar;
			else if (lastChar != ' ') {
				additionalStatement += " or LOWER(s.own) like '%" +  currentWord.toLowerCase() + "%' ";
				currentWord = "";
			}		
			else {
				currentWord = "";
			}
			lastChar = currentChar;		
		}
		if (currentWord != "" && additionalStatement.indexOf(currentWord.toLowerCase()) == -1) {
			additionalStatement += " or LOWER(s.own) like '%" +  currentWord.toLowerCase() + "%' ";
		}
		additionalStatement += " ) ";
		System.out.print("Adding this parameter to SQL statement: ");
		System.out.println(additionalStatement);
		return additionalStatement;
	}
}
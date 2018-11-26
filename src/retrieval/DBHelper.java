package retrieval;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.sql.Blob;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Date;

//import sun.misc.IOUtils;
//DBHelper u = new DBHELPER(....)
//u.updateUserInfo(UserInfo new);

public class DBHelper {
	public String email; //unique identifier
	public UserInfo user;
	public Connection conn = null;
	public Statement st = null;
	public ResultSet rs = null;
	public int userId = -1;
	public PreparedStatement ps = null;
	public Shelter shInfo = null;
	public static final String CLASS_NAME = "com.mysql.jdbc.Driver";
	public static final String CONNECTION_URL = "jdbc:mysql://localhost:3306/safeHands?user=root&password=root&useSSL=false";
	public DBHelper(String email, String password)  {
		this.email = email;
		this.user = new UserInfo();
		
		//login user to database using username and password
		//if success, populate UserInfo with values. and maintain email.
		//if connection fails, then set email to nothing
		
		try {
			Class.forName(CLASS_NAME);
			conn = DriverManager.getConnection(CONNECTION_URL); 
			
			String query = "SELECT * FROM users WHERE email=? AND pass=?";
			ps = conn.prepareStatement(query);		
			ps.setString(1, email);
			ps.setString(2, password);
			rs = ps.executeQuery();
			while (rs.next()) {
				this.userId = rs.getInt("userID");
				user.email = rs.getString("email");
				user.username = rs.getString("username");
				user.isShelter = rs.getByte("isShelter");
				user.password = password;
				updateUserInfo(user.username);
				user.id = this.userId;
				if (user.isShelter == 1) {
					System.out.println("A SHELTER!");
					shInfo = getShelterInfo(user.username);
					shInfo.owner=user.username;
				} else {
					System.out.println("NOT A SHELTER!");
					//user.address = rs.getString("address");
				}
				//now userObject will be fully updated
				//if it is a shelter, then shInfo will also be populated!
			}
		}catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			try {
				if (rs != null) {
					rs.close();
				}
				if (st != null) {
					st.close();
				}
				if (conn!= null) {
					conn.close();
				}
			} catch (SQLException sqle) {
				System.out.println("sqle closing streams: " + sqle.getMessage());
			}
		}
		
	
		//DUMMY - TO BE REPLACED LATER (just so I don't get a ton of errors)
		//END DUMMY
	}
	
	public void updateUserInfo (String username) {
		Connection conn1 = null;
		PreparedStatement ps1 = null;
		ResultSet rs1 = null;
		try {
			Class.forName(CLASS_NAME);
			conn1 = DriverManager.getConnection(CONNECTION_URL); 
			
			String query = "SELECT * FROM userInfo WHERE username=?";
			ps1 = conn1.prepareStatement(query);		
			ps1.setString(1, username);
			rs1 = ps1.executeQuery();
			while (rs1.next()) {
				user.zipcode = rs1.getInt("zipcode");
				user.kids = rs1.getInt("kids");
				user.pets = rs1.getInt("pets");
				user.address = rs1.getString("address");
				user.phoneNumber = rs1.getString("phoneNumber");
			}
		}catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			try {
				if (rs1 != null) {
					rs1.close();
				}
				if (ps1 != null) {
					ps1.close();
				}
				if (conn1!= null) {
					conn1.close();
				}
			} catch (SQLException sqle) {
				System.out.println("sqle closing streams: " + sqle.getMessage());
			}
		}
	}
	public Shelter getShelterInfo(String owner) {
		Shelter s = new Shelter();
		Connection conn1 = null;
		PreparedStatement ps1 = null;
		ResultSet rs1 = null;
		try {
			Class.forName(CLASS_NAME);
			conn1 = DriverManager.getConnection(CONNECTION_URL); 
			
			String query = "SELECT * FROM shelterInfo WHERE own=?";
			ps1 = conn1.prepareStatement(query);		
			ps1.setString(1, owner);
			rs1 = ps1.executeQuery();
			while (rs1.next()) {
				System.out.println("FOUND VALUES!");
				s.owner = rs1.getString("own");
				s.address = rs1.getString("address");
				s.zipcode = rs1.getInt("zipcode");
				s.kids = rs1.getInt("kids");
				s.pets = rs1.getInt("pets");
				s.phoneNumber = rs1.getString("phoneNumber");
				s.bio = rs1.getString("biography");
				s.numRatingGiven = rs1.getInt("numRatingGiven");
				s.nearGrocery = rs1.getByte("nearGrocery");
				s.nearPharmacy = rs1.getByte("nearPharmacy");
				s.nearLaundromat = rs1.getByte("nearLaundromat");
				s.currentRating = rs1.getDouble("currentRating");
				s.pageVisits = rs1.getInt("pageVisits");
				s.numStays = rs1.getInt("numStays");
				s.numPendingRequests = rs1.getInt("numPendingRequests");
				s.avgStayDuration = rs1.getDouble("avgStayDuration");	
			}
		}catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			try {
				if (rs1 != null) {
					rs1.close();
				}
				if (ps1 != null) {
					ps1.close();
				}
				if (conn1!= null) {
					conn1.close();
				}
			} catch (SQLException sqle) {
				System.out.println("sqle closing streams: " + sqle.getMessage());
			}
		}
		return s;
	}
	public boolean didConnect () {
		if (user.username.equals("")) {
			return false;
		} else {
			return true;
		}
	}
	
	//SIGN UP VARIOUS USERS ---
	public  String addNormalUser(UserInfo u) {
		//should sign up basic survivor
		String userId = "";

		Connection conn2 = null;
		PreparedStatement ps2 = null;
		ResultSet rs2 = null;
		try {
			Class.forName(CLASS_NAME);
			conn2 = DriverManager.getConnection(CONNECTION_URL); 
			
			String query = "INSERT INTO users(username,email,pass,isShelter) VALUES (?,?,?,?)";
			ps2 = conn2.prepareStatement(query);		
			ps2.setString(1, u.username);
			ps2.setString(2, u.email);
			ps2.setString(3, u.password);
			ps2.setByte(4, u.isShelter);
			ps2.executeUpdate();
		}catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			try {
				if (rs2 != null) {
					rs2.close();
				}
				if (ps2 != null) {
					ps2.close();
				}
				if (conn2!= null) {
					conn2.close();
				}
			} catch (SQLException sqle) {
				System.out.println("sqle closing streams: " + sqle.getMessage());
			}
		}
		 conn2 = null;
		 ps2 = null;
		 rs2 = null;
			//if isn't a shelter, create a table in userInfo
			
			if (u.isShelter==0) {

			 Connection conn3 = null;
			 PreparedStatement ps3 = null;
			 ResultSet rs3 = null;
			
				try {
					Class.forName(CLASS_NAME);
					conn3 = DriverManager.getConnection(CONNECTION_URL); 
					
					String query = "INSERT INTO userInfo(username,zipcode,address,kids,pets,phoneNumber) VALUES (?,?,?,?,?,?)";
					ps3 = conn3.prepareStatement(query);		
					ps3.setString(1, u.username);
					ps3.setInt(2, u.zipcode);
					ps3.setString(3, u.address);
					ps3.setInt(4, u.kids);
					ps3.setInt(5, u.pets);
					ps3.setString(6, u.phoneNumber);
					
					 ps3.executeUpdate();

				}catch (ClassNotFoundException e) {
					e.printStackTrace();
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}finally {
					try {
						if (rs2 != null) {
							rs2.close();
						}
						if (ps2 != null) {
							ps2.close();
						}
						if (conn2!= null) {
							conn2.close();
						}
					} catch (SQLException sqle) {
						System.out.println("sqle closing streams: " + sqle.getMessage());
					}
				
			}
		}
		return u.username;
		
	}
	public void createOrg (UserInfo u, Shelter s) {
		//should sign up organization user with isShelter = true by adding to userinfo table
		//should add entry to Shelter table. Both Should contain the same values
		String userId = addNormalUser(u);
		System.out.println(userId + " is the new id ");
		Connection conn2 = null;
		PreparedStatement ps2 = null;
		ResultSet rs2 = null;
		try {
			Class.forName(CLASS_NAME);
			conn2 = DriverManager.getConnection(CONNECTION_URL); 
			
			String query = "INSERT INTO shelterInfo(own,zipcode,address,kids,pets,phoneNumber," + 
					"biography,nearGrocery,nearPharmacy,nearLaundromat,availability) VALUES " + 
					"(?,?,?,?,?,?,?,?,?,?,?)";
			if (s.phoneNumber.equals("")) {
				s.phoneNumber="1";
			}
			ps2 = conn2.prepareStatement(query);		
			ps2.setString(1, userId);
			ps2.setInt(2, s.zipcode);
			ps2.setString(3, s.address);
			ps2.setInt(4, s.kids);
			ps2.setInt(5, s.pets);
			ps2.setString(6, s.phoneNumber);
			ps2.setString(7, s.bio);
			ps2.setByte(8, s.nearGrocery);
			ps2.setByte(9, s.nearPharmacy);
			ps2.setByte(10, s.nearLaundromat);
			ps2.setInt(11, s.availability);
			ps2.executeUpdate();
		}catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			try {
				if (rs2 != null) {
					rs2.close();
				}
				if (ps2 != null) {
					ps2.close();
				}
				if (conn2!= null) {
					conn2.close();
				}
			} catch (SQLException sqle) {
				System.out.println("sqle closing streams: " + sqle.getMessage());
			}
		}
	}
	
	/**
	 * Track clicks for each user
	 * @param u
	 * @param s
	 */
	public void trackAdd (int u, int s) {
		//should sign up organization user with isShelter = true by adding to userinfo table
		//should add entry to Shelter table. Both Should contain the same values

		Connection conn2 = null;
		PreparedStatement ps2 = null;
		ResultSet rs2 = null;
		try {
			Class.forName(CLASS_NAME);
			conn2 = DriverManager.getConnection(CONNECTION_URL); 
			
			String query = "INSERT INTO clicks(userID,shelterID,clicked) VALUES (?,?,UTC_DATE())";
			ps2 = conn2.prepareStatement(query);		
			ps2.setInt(1, u);
			ps2.setInt(2, s);
			ps2.executeUpdate();
		}catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			try {
				if (rs2 != null) {
					rs2.close();
				}
				if (ps2 != null) {
					ps2.close();
				}
				if (conn2!= null) {
					conn2.close();
				}
			} catch (SQLException sqle) {
				System.out.println("sqle closing streams: " + sqle.getMessage());
			}
		}
	}
	
	public ResultSet retrieveClicks(int sid, PrintWriter pw) {
		//should sign up organization user with isShelter = true by adding to userinfo table
		//should add entry to Shelter table. Both Should contain the same values

		Connection conn2 = null;
		PreparedStatement ps2 = null;
		ResultSet rs2 = null;
		try {
			Class.forName(CLASS_NAME);
			conn2 = DriverManager.getConnection(CONNECTION_URL); 
			
			String query = "SELECT userID as u, clicked as cks from clicks WHERE shelterID = ?";
			ps2 = conn2.prepareStatement(query);		
			ps2.setInt(1, sid);
			rs2 = ps2.executeQuery();
			pw.print("[");
			while(rs2.next()) {
				pw.print("{");
				pw.print("'user':'"+rs.getInt("u") + "',");
				pw.print("'time':'"+rs.getString("cks")+"'");
				pw.print("},");
			}
			pw.println("]");
			pw.flush();
		}catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			try {
				if (rs2 != null) {
					rs2.close();
				}
				if (ps2 != null) {
					ps2.close();
				}
				if (conn2!= null) {
					conn2.close();
				}
			} catch (SQLException sqle) {
				System.out.println("sqle closing streams: " + sqle.getMessage());
			}
		}
		return null;
	}
	
	public void retrievePlaces(int sid, PrintWriter pw) {
		Connection conn2 = null;
		PreparedStatement ps2 = null;
		ResultSet rs2 = null;
		try {
			Class.forName(CLASS_NAME);
			conn2 = DriverManager.getConnection(CONNECTION_URL); 
			
			String query = "SELECT u.zipcode as zip, c.clicked as cks from clicks as c, userInfo as u WHERE c.userID=u.id AND shelterID = ?";
			ps2 = conn2.prepareStatement(query);		
			ps2.setInt(1, sid);
			rs2 = ps2.executeQuery();
			pw.print("[");
			while(rs2.next()) {
				pw.print("{");
				pw.print("'zip':'"+rs.getInt("zip") + "',");
				pw.print("'time':'"+rs.getString("cks")+"'");
				pw.print("},");
			}
			pw.println("]");
			pw.flush();
		}catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			try {
				if (rs2 != null) {
					rs2.close();
				}
				if (ps2 != null) {
					ps2.close();
				}
				if (conn2!= null) {
					conn2.close();
				}
			} catch (SQLException sqle) {
				System.out.println("sqle closing streams: " + sqle.getMessage());
			}
		}
	}
	
	//TO BE USED ON SEARCH SHELTER PAGE --
	public ArrayList<Shelter> getShelters(){
		ArrayList<Shelter> res = new ArrayList<>();
		try {
			Class.forName(CLASS_NAME);
			conn = DriverManager.getConnection(CONNECTION_URL); 
			
			String query = "SELECT * FROM shelters";
			ps = conn.prepareStatement(query);
			rs = ps.executeQuery();
			while (rs.next()) {
				String tempId = rs.getString("userID");
				res.add(getShelterInfo(tempId));
			}
		}catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			try {
				if (rs != null) {
					rs.close();
				}
				if (st != null) {
					st.close();
				}
				if (conn!= null) {
					conn.close();
				}
			} catch (SQLException sqle) {
				System.out.println("sqle closing streams: " + sqle.getMessage());
			}
		}
		//populate res based on statement SELECT * FROM shelter 
		return res;
	}
	
	//MESSAGES PAGE --
	
	public boolean sendMessage (Message m) {
		//add m to messages table
		if(!unameExists(m.recipient)) {
			return false;
		} else {
			//send message here
			try {
				Class.forName(CLASS_NAME);
				conn = DriverManager.getConnection(CONNECTION_URL); 
				
				String query = "INSERT INTO messages(senderName,recipientName,timeSent,mSubject," + 
					"mContent,mRead,isAvailabilityRequest) VALUES (?,?,?,?,?,?,?)";
				Byte b = 0;
				ps = conn.prepareStatement(query);
				ps.setString(1, user.username);
				ps.setString(2, m.recipient);
				ps.setLong(3,m.timeSent);
				ps.setString(4, m.subject);
				ps.setString(5, m.body);
				ps.setByte(6, b);
				ps.setString(7, m.isAvailabilityRequest);
				ps.executeUpdate();
				
			}catch (ClassNotFoundException e) {
				e.printStackTrace();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}finally {
				try {
					if (rs != null) {
						rs.close();
					}
					if (st != null) {
						st.close();
					}
					if (conn!= null) {
						conn.close();
					}
				} catch (SQLException sqle) {
					System.out.println("sqle closing streams: " + sqle.getMessage());
					
				}
			}
			return true;			
		}
	}
	public ArrayList<Message> getMessages(){
		ArrayList<Message> res = new ArrayList<>();
		try {
			Class.forName(CLASS_NAME);
			conn = DriverManager.getConnection(CONNECTION_URL); 
			
			String query = "SELECT * FROM messages WHERE recipientName=?";
			ps = conn.prepareStatement(query);
			ps.setString(1, user.username);
			rs = ps.executeQuery();
			while (rs.next()) {
				Message m = new Message();
				m.id = rs.getInt("messageID");
				m.sender = rs.getString("senderName");
				m.recipient = user.username;
				m.subject = rs.getString("mSubject");
				m.body = rs.getString("mContent");
				m.read = rs.getByte("mRead");
				m.timeSent = rs.getLong("timeSent");
				m.isAvailabilityRequest = rs.getString("isAvailabilityRequest");
				res.add(m);
			}
		}catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			try {
				if (rs != null) {
					rs.close();
				}
				if (st != null) {
					st.close();
				}
				if (conn!= null) {
					conn.close();
				}
			} catch (SQLException sqle) {
				System.out.println("sqle closing streams: " + sqle.getMessage());
			}
		}
		return res;
	}
	public boolean readMessage (int id) {
		Message m = messageById(id);
		if(m.subject.equals("")) {
			//message exists
			return false;
		}
		Connection conn2 = null;
		PreparedStatement ps2 = null;
		try {
			Class.forName(CLASS_NAME);
			conn2 = DriverManager.getConnection(CONNECTION_URL); 
			
			String query = "UPDATE messages SET mRead=1 WHERE messageID=?";
			ps2 = conn2.prepareStatement(query);
			ps2.setInt(1, id);
			ps2.executeUpdate();
		}catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			try {
			
				if (ps2 != null) {
					ps2.close();
				}
				if (conn2!= null) {
					conn2.close();
				}
			} catch (SQLException sqle) {
				System.out.println("sqle closing streams: " + sqle.getMessage());
			}
		}
		return true;
	}
	public Message messageById (int id) {
		Message m = new Message ();
		Connection conn2 = null;
		PreparedStatement ps2 = null;
		ResultSet rs2 = null;
		try {
			Class.forName(CLASS_NAME);
			conn2 = DriverManager.getConnection(CONNECTION_URL); 
			
			String query = "SELECT * FROM messages WHERE messageID=?";
			ps2 = conn2.prepareStatement(query);
			ps2.setInt(1, id);
			rs2 = ps2.executeQuery();
			while (rs2.next()) {
				m.id = id;
				m.sender = rs2.getString("senderName");
				m.recipient = rs2.getString("recipientName");
				m.subject = rs2.getString("mSubject");
				m.body = rs2.getString("mContent");
				m.read = rs2.getByte("mRead");
				m.timeSent = rs2.getLong("timeSent");
			}
		}catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			try {
				if (rs2 != null) {
					rs2.close();
				}
				if (ps2 != null) {
					ps2.close();
				}
				if (conn2!= null) {
					conn2.close();
				}
			} catch (SQLException sqle) {
				System.out.println("sqle closing streams: " + sqle.getMessage());
			}
		}
		return m;
	}
	//updating Settings
	public void updateUserSettings(UserInfo user) {
		Connection conn2 = null;
		PreparedStatement ps2 = null;
		ResultSet rs2 = null;
		try {
			Class.forName(CLASS_NAME);
			conn2 = DriverManager.getConnection(CONNECTION_URL); 
			
			String query = "UPDATE users SET pass=?, email=? WHERE username=?";
			ps2 = conn2.prepareStatement(query);		
			ps2.setString(2, user.email);
			ps2.setString(1, user.password);
			ps2.setString(3, user.username);
			ps2.executeUpdate();
		}catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			try {
				if (rs2 != null) {
					rs2.close();
				}
				if (ps2 != null) {
					ps2.close();
				}
				if (conn2!= null) {
					conn2.close();
				}
			} catch (SQLException sqle) {
				System.out.println("sqle closing streams: " + sqle.getMessage());
			}
		}
		if (user.isShelter==0) {
		try {
			Class.forName(CLASS_NAME);
			conn2 = DriverManager.getConnection(CONNECTION_URL); 
			
			String query = "UPDATE userInfo SET zipcode=?, address=?, kids=?, pets=?, phoneNumber=? WHERE username=?";
			ps2 = conn2.prepareStatement(query);		
			ps2.setInt(1, user.zipcode);
			ps2.setString(2, user.address);
			ps2.setInt(3, user.kids);
			ps2.setInt(4, user.pets);
			ps2.setString(5, user.phoneNumber);
			ps2.setString(6, user.username);
			ps2.executeUpdate();
		}catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			try {
				if (rs2 != null) {
					rs2.close();
				}
				if (ps2 != null) {
					ps2.close();
				}
				if (conn2!= null) {
					conn2.close();
				}
			} catch (SQLException sqle) {
				System.out.println("sqle closing streams: " + sqle.getMessage());
			}
		}
		}
	}
	public void updateUserSettings(UserInfo user, Shelter s) {
		updateShelterSettings(s);
		updateUserSettings(user);
	}
	public void updateShelterSettings(Shelter s) {
		Connection conn1 = null;
		PreparedStatement ps1 = null;
		ResultSet rs1 = null;
		try {
			Class.forName(CLASS_NAME);
			conn1 = DriverManager.getConnection(CONNECTION_URL); 
			
			String query = "UPDATE shelterInfo SET zipcode=?, address =?, kids=?, pets=?, phoneNumber=?, biography=?,"
					+ " numRatingGiven=?, nearPharmacy=?, nearLaundromat=?, currentRating=?,"
					+ " pageVisits=?, numStays=?, numPendingRequests=?, avgStayDuration=? WHERE own=?";
			ps1 = conn1.prepareStatement(query);		
			ps1.setInt(1, s.zipcode);
			ps1.setString(2, s.address);
			ps1.setInt(3, s.kids);
			ps1.setInt(4, s.pets);
			ps1.setString(5, s.phoneNumber);
			ps1.setString(6, s.bio);
			ps1.setInt(7, s.numRatingGiven);
			ps1.setInt(8, s.nearGrocery);
			ps1.setInt(9, s.nearLaundromat);
			ps1.setDouble(10, s.currentRating);
			ps1.setInt(11, s.pageVisits);
			ps1.setInt(12, s.numStays);	
			ps1.setInt(13, s.numPendingRequests);			
			ps1.setDouble(14, s.avgStayDuration);	
			ps1.setString(15, s.owner);
			ps1.executeUpdate();

			
		}catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			try {
				if (rs1 != null) {
					rs1.close();
				}
				if (ps1 != null) {
					ps1.close();
				}
				if (conn1!= null) {
					conn1.close();
				}
			} catch (SQLException sqle) {
				System.out.println("sqle closing streams: " + sqle.getMessage());
			}
		}
	}
	
	//MISC. HELPER FUNCTIONS
	public static void visitShelter(String shelterOwner) {
		//user statement: 
		//UPDATE  shelterinfo SET visits = 
			//(SELECT visits FROM shelterinfo WHERE shelterId = shelterId)+1 
			// WHERE shelterId=shelterId'
			Connection conn1 = null;
			PreparedStatement ps1 = null;
			ResultSet rs1 = null;
			try {
				Class.forName(CLASS_NAME);
				conn1 = DriverManager.getConnection(CONNECTION_URL); 
				
				String query = "UPDATE shelterInfo SET pageVisits=pageVisits + 1 WHERE own=?";
				ps1 = conn1.prepareStatement(query);		
				ps1.setString(1, shelterOwner);		
				ps1.executeUpdate();

				
			}catch (ClassNotFoundException e) {
				e.printStackTrace();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}finally {
				try {
					if (rs1 != null) {
						rs1.close();
					}
					if (ps1 != null) {
						ps1.close();
					}
					if (conn1!= null) {
						conn1.close();
					}
				} catch (SQLException sqle) {
					System.out.println("sqle closing streams: " + sqle.getMessage());
				}
			}
		}
	public static boolean userExists(String username) {
		Connection conn2 = null;
		PreparedStatement ps2 = null;
		ResultSet rs2 = null;
		try {
			Class.forName(CLASS_NAME);
			conn2 = DriverManager.getConnection(CONNECTION_URL); 
			
			String query = "SELECT * FROM users WHERE username=?";
			ps2 = conn2.prepareStatement(query);		
			ps2.setString(1, username);
			rs2 = ps2.executeQuery();
			while(rs2.next()) {
				try {
					if (rs2 != null) {
						rs2.close();
					}
					if (ps2 != null) {
						ps2.close();
					}
					if (conn2!= null) {
						conn2.close();
					}
				} catch (SQLException sqle) {
					System.out.println("sqle closing streams: " + sqle.getMessage());
				}
					return true;
				
			}
		}catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			try {
				if (rs2 != null) {
					rs2.close();
				}
				if (ps2 != null) {
					ps2.close();
				}
				if (conn2!= null) {
					conn2.close();
				}
			} catch (SQLException sqle) {
				System.out.println("sqle closing streams: " + sqle.getMessage());
			}
		}
		//checks userInfo and sees if email exists in the table
		return false;
	}
	public static String getImages (String username) {
		byte [] b = null;
		Connection conn2 = null;
		PreparedStatement ps2 = null;
		ResultSet rs2 = null;
		try {
			Class.forName(CLASS_NAME);
			conn2 = DriverManager.getConnection(CONNECTION_URL); 
			
			String query = "SELECT * FROM images WHERE username=?";
			ps2 = conn2.prepareStatement(query);		
			ps2.setString(1, username);
			rs2 = ps2.executeQuery();
			while (rs2.next()) {
				System.out.println("PICS FOUND");
				//InputStream binaryStream = rs2.getBinaryStream("image");
				//b = IOUtils.toByteArray(binaryStream);
				//b = new byte[16384];
				String s = rs2.getString("image");
				return s;
				//				ByteArrayOutputStream buffer = new ByteArrayOutputStream();
//
//				int nRead;
//				while ((nRead = binaryStream.read(b, 0, b.length)) != -1) {
//				  buffer.write(b, 0, nRead);
//				}
//
//				b= buffer.toByteArray();
			}
				System.out.println("NO MORE PICS");
			
			}catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
//		} catch (IOException e) {
//			// TODO Auto-generated catch block
//			e.printStackTrace();
//		}
		}finally {
			try {
				if (rs2 != null) {
					rs2.close();
				}
				if (ps2 != null) {
					ps2.close();
				}
				if (conn2!= null) {
					conn2.close();
				}
			} catch (SQLException sqle) {
				System.out.println("sqle closing streams: " + sqle.getMessage());
			}
		}	
		
		return "";
	}
	public void addImage(String username, String base64) {
		Connection conn2 = null;
		PreparedStatement ps2 = null;
		ResultSet rs2 = null;
	//	File f = new File(path);
		try {
		//	FileInputStream fis = new FileInputStream(f);
		
		try {
			Class.forName(CLASS_NAME);
			conn2 = DriverManager.getConnection(CONNECTION_URL); 
			
			String query = "INSERT INTO images(username,image) VALUES (?,?)";
			ps2 = conn2.prepareStatement(query);		
			ps2.setString(1, username);
			ps2.setString(2,base64);
			 ps2.executeUpdate();
			
		}catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			try {
				if (rs2 != null) {
					rs2.close();
				}
				if (ps2 != null) {
					ps2.close();
				}
				if (conn2!= null) {
					conn2.close();
				}
			} catch (SQLException sqle) {
				System.out.println("sqle closing streams: " + sqle.getMessage());
			}
		}
		} catch (Exception e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
	}
	public boolean userExists(int id) {
		Connection conn2 = null;
		PreparedStatement ps2 = null;
		ResultSet rs2 = null;
		try {
			Class.forName(CLASS_NAME);
			conn2 = DriverManager.getConnection(CONNECTION_URL); 
			
			String query = "SELECT * FROM users WHERE userID=?";
			ps2 = conn2.prepareStatement(query);		
			ps2.setInt(1, id);
			rs2 = ps2.executeQuery();
			while(rs2.next()) {
				try {
					if (rs2 != null) {
						rs2.close();
					}
					if (ps2 != null) {
						ps2.close();
					}
					if (conn2!= null) {
						conn2.close();
					}
				} catch (SQLException sqle) {
					System.out.println("sqle closing streams: " + sqle.getMessage());
				}
					return true;
				
			}
		}catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			try {
				if (rs2 != null) {
					rs2.close();
				}
				if (ps2 != null) {
					ps2.close();
				}
				if (conn2!= null) {
					conn2.close();
				}
			} catch (SQLException sqle) {
				System.out.println("sqle closing streams: " + sqle.getMessage());
			}
		}
		//checks userInfo and sees if email exists in the table
		return false;
	}
	public boolean unameExists(String uname) {
		Connection conn2 = null;
		PreparedStatement ps2 = null;
		ResultSet rs2 = null;
		try {
			Class.forName(CLASS_NAME);
			conn2 = DriverManager.getConnection(CONNECTION_URL); 
			
			String query = "SELECT * FROM users WHERE username=?";
			ps2 = conn2.prepareStatement(query);		
			ps2.setString(1, uname);
			rs2 = ps2.executeQuery();
			while(rs2.next()) {
				try {
					if (rs2 != null) {
						rs2.close();
					}
					if (ps2 != null) {
						ps2.close();
					}
					if (conn2!= null) {
						conn2.close();
					}
				} catch (SQLException sqle) {
					System.out.println("sqle closing streams: " + sqle.getMessage());
				}
					return true;
				
			}
		}catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			try {
				if (rs2 != null) {
					rs2.close();
				}
				if (ps2 != null) {
					ps2.close();
				}
				if (conn2!= null) {
					conn2.close();
				}
			} catch (SQLException sqle) {
				System.out.println("sqle closing streams: " + sqle.getMessage());
			}
		}
		//checks userInfo and sees if email exists in the table
		return false;
	}
	
	/**
	 * Get the current rating as a json array
	 */
	public void retrieveRating(PrintWriter pw) {
		Connection conn2 = null;
		PreparedStatement ps2 = null;
		ResultSet rs2 = null;
		try {
			Class.forName(CLASS_NAME);
			conn2 = DriverManager.getConnection(CONNECTION_URL); 
			
			String query = "SELECT currentRating from shelterInfo where id = ?";
			ps2 = conn2.prepareStatement(query);		
			ps2.setInt(1, shInfo.id);
			rs2 = ps2.executeQuery();
			if (rs2.next()) {
				int rating = rs2.getInt("currentRating");
				String test = String.format("[{'time':'%s','rating':%d}]", new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()),rating);
				System.out.println(test);
				pw.println(String.format("[{'time':'%s','rating':%d}]", new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()),rating));
				pw.flush();
			} else {
				System.out.println(shInfo.id);
				pw.println("[]");
				pw.flush();
			}
		}catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			try {
				if (rs2 != null) {
					rs2.close();
				}
				if (ps2 != null) {
					ps2.close();
				}
				if (conn2!= null) {
					conn2.close();
				}
			} catch (SQLException sqle) {
				System.out.println("sqle closing streams: " + sqle.getMessage());
			}
		}
	}
	
	
	
}

<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
 <%@ page
	import="retrieval.DBHelper, retrieval.Message, retrieval.Mail,  javax.servlet.http.HttpServlet, javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse, retrieval.CompareMessageByReadAndTime,java.util.*"%>
<!DOCTYPE html>
<html>
<head>
<title>Shelter Seekers User Messages Page</title>
<head>
	<%
		String isShelter = "";
		System.out.println("In user Messages.jsp");
		String navOne = "<li><a href=\"userhomepage.jsp\">Search</a></li>";
		String navThree = "<li><a href=\"usersettings.jsp\">Settings</a></li>";
		String username = "";
		try {
			DBHelper db = (DBHelper) request.getSession().getAttribute("DBHelper");
			isShelter = db.user.isShelter.toString();
			username = db.user.username;
			if (isShelter.equals("1")) {
				navOne = "<li><a href=\"orgstats.jsp\">My Stats</a></li>";
				navThree = "<li><a href=\"orgsettings.jsp\">Settings</a></li>";
			}
		} catch (Exception e) {
			System.out.println(e);
		}
		
	%>
	<meta charset="ISO-8859-1">
	<script src="https://apis.google.com/js/platform.js" async defer></script>
	<script src="//ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js"></script>
  	<meta name="viewport" content="width=device-width, initial-scale=1">
  	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
  	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
  	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
  	<link href="https://fonts.googleapis.com/css?family=Nunito+Sans" rel="stylesheet">
  	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
	<style>
		 .navbar {
		 	background-color: #c5c1fe;
		 	border-color:#c5c1fe;
	      	margin-bottom: 0;
	      	border-radius: 0;
	      	color:white; 
	    }
		.navbar-default .navbar-brand {
		    color: white;
		}
		.navbar-default .navbar-nav>li>a {
		    color: white;
		}
		.navbar-default .navbar-nav>.active>a{
			color: grey; 
			background-color: white; 
		}
		.navbar-brand{
    		padding: 0px 15px;
    		margin-right: -15px;
		}
		.navbar-right{
			margin-right: 0px;
		}
	    body{
			background-image: linear-gradient(to right, #7a5ce5, #a490ea, #7a5ce5);
			font-family: 'Nunito Sans', sans-serif;
			color:white; 
			height: 100%; 
		}  
	    footer {
	      background-color: #c5c1fe;
	      color: white;
	      padding: 15px;
	      position: fixed;
		  bottom: 0;
		  width: 100%;
		  height: 5%; 
	   
		}
		
		.blueFont {
			color: blue;
			opacity:0.9;
			filter: grayscale(80%);
		}
		
		.segoe{
			font-size: 20px; 
		 	font-weight: 200; 
		 
		 }
		</style>
</head>
<body> 
<% 
	DBHelper db = (DBHelper) request.getSession().getAttribute("DBHelper");
	System.out.println(db.didConnect() + "is status");
	Mail mail = new Mail();
	ArrayList<Message> ms = db.getMessages();
	for (int i = 0; i < ms.size(); i++) {
		mail.addMessage(ms.get(i));
		System.out.println(ms.get(i).getID());
	}
	CompareMessageByReadAndTime comp = new CompareMessageByReadAndTime();
	mail.SortByReadAndTime(comp);
	ArrayList<Message> messages = mail.getMessages();
	System.out.println(messages.size() + "total messages");
 	
%>
	<nav class="navbar navbar-default">
	  <div class="container-fluid">
	  	<div class="navbar-header">
		 	<figure class="navbar-brand">
			  <img src="bed.png" style="width: 30px;height: 40px;">
			</figure>	
		</div>
	    <ul class="nav navbar-nav">
	   	 	<li><a style="font-size: 20px">Safe Hands</a></li>
	      <%=navOne %>
	      <li class="active"><a href="#">Messages</a></li>
	      <%=navThree %>
	    </ul>
	     <ul class="nav navbar-nav navbar-right">
        	<li><a class="navbar-brand" href="signin.jsp">Sign Out</a></li>
      	</ul>
	  </div>
	</nav>
	<div class="container-fluid text-center"> 
		<div class="col col-sm-6 ">
			<h3>Messages</h3>
			<div style="border: 1px double white; height:435px;" >
				<%
				//FIX THIS FORMAT LATER 
					out.println("<div>" + mail.getUnread() + " new messages.</div>");
				%>
				<br>
				<table class="table table-hover">
				<%
					out.println("<tbody>");
					
					for (int i = 0; i < messages.size(); i++) {
						if (messages.get(i).getRead() == 1) {
							out.println("<tr>" + "<td id ='" + messages.get(i).getID() + "'; onClick=\"openMessage('"
									+ messages.get(i).getID() + "');\">" + messages.get(i).readable());
						}
						if (messages.get(i).getRead() == 0) {
							out.println("<tr>" + "<td id ='" + messages.get(i).getID() + "'; onClick=\"openMessage('"
									+ messages.get(i).getID() + "');\">" + "<b>" + messages.get(i).readable() + "</b>");
						}
						out.println("</td>" + "</tr>");
						System.out.println("ID order: " + messages.get(i).getID());
					}
					out.println("</tbody");
	
				%>
				</table>
			</div>
		</div>
		<div class="col col-sm-6 ">
			<h3>New Message</h3>
			<div style="border: 1px double white;">
				<form onsubmit="defaultMessage();"><!--  method="post" action="Servlet"-->
				<div class="form-group" style="margin-top: 20px ;margin-left:20px;">
					<input style="width: 400px;"id="recipient" type="text" class="segoe blueFont" name="recipient" placeholder="Recipient" required>
				</div>
				<div class="form-group" style="margin-left:20px;">
					<input style="width: 400px;" id="subject" type="text" class="segoe blueFont" name="subject" placeholder="Subject" required>
				</div>
				<div class="form-group">
				  <textarea id="message" style="padding-left: 2px; width: 400px; margin-left: 20%"placeholder="Type message here.."class="form-control segoe blueFont" form="Sign-up" class = "segoe blueFont" name ="message" rows="8" required></textarea>
				</div>
				<input class="btn btn-lg btn-default" style="margin-bottom: 20px; margin-left:20px; width: 400px"  type="submit" value= "Send">
			</form>
			</div>
		</div>
		</div>
	<footer class="container-fluid text-center">
	  <p> © 2018 Safe Hands </p>
	</footer>
 	<script>
	function defaultMessage() {
		if (document.getElementById("recipient").value.length < 1) {
			alert("Please input a recipient.");
			return false;
		}
		if (document.getElementById("subject").value.length < 1) {
			alert("Please input a subject.");
			return false;
		}
		if (document.getElementById("message").value.length < 1) {
			alert("Please input a message body.");
			return false;
		}
		let testthing = true;
		var xhttp = new XMLHttpRequest();
		xhttp.open("POST", "SendMessage", true);
		xhttp.onreadystatechange = function () {
			let responseText = this.responseText;
			if (this.responseText == "recipientDoesntExist\n") {
				alert("The recipient does not exist!");
			}
		}
		xhttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
		xhttp.send("recipient=" + document.getElementById("recipient").value + 
			"&subject=" + document.getElementById("subject").value + 
			"&message=" + document.getElementById("message").value + 
			"&sender=" + "<%=username%>" + 
			"&isAvailabilityRequest=false");
	}
	function openMessage(id) {
		console.log(id);
		document.location.href = "http://localhost:8080/ShelterSeeker/openmessage.jsp?messageID=" + id;
	}
	</script>
</body>
</html> 
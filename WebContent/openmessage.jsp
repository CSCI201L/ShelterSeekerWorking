<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page
	import="retrieval.DBHelper, retrieval.Message, retrieval.Mail,  javax.servlet.http.HttpServlet, 
	javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse, 
	retrieval.CompareMessageByReadAndTime,java.util.*"%>
<!DOCTYPE html>
<html>
<head>
<title>Shelter Seekers Open Message</title>
<script src="https://apis.google.com/js/platform.js" async defer></script>
	<script src="//ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js"></script>
	<meta charset="utf-8">
  	<meta name="viewport" content="width=device-width, initial-scale=1">
  	<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css" integrity="sha384-MCw98/SFnGE8fJT3GXwEOngsV7Zt27NXFoaoApmYm81iuXoPkFOJwJ8ERdknLPMO" crossorigin="anonymous">
  	<script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js" integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49" crossorigin="anonymous"></script>
	<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/js/bootstrap.min.js" integrity="sha384-ChfqqxuZUCnJSK3+MXmPNIyE6ZbWh2IMqE241rYiqJxyMiZ6OW/JmZQ5stwEULTy" crossorigin="anonymous"></script>
	<style>
		#acceptButton {
			visibility: hidden;
		}
		#rejectButton {
			visibility: hidden;
		}
		#requestDecisionResult {
			visibility: hidden;
		}
	
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
		li {
			display: inline;
			float: left;
		}
		
		#top ul {
			list-style-type: none;
			margin: 0;
			padding: 0;
			overflow: hidden;
			background-color: blue;
		}
		
		li a {
			display: block;
			color: white;
			text-align: center;
			padding: 14px 16px;
			text-decoration: none;
		}
		
		.sender-image {
			border-radius: 50%;
		}
		
		</style>
		<%
		//REPLACE THIS WITH HTTPSESSION GLOBAL INSTANCE OF DB
		DBHelper db = (DBHelper) request.getSession().getAttribute("DBHelper");
		System.out.println(db.didConnect() + "is status");

		Mail mail = new Mail();

		ArrayList<Message> ms = db.getMessages();

		for (int i = 0; i < ms.size(); i++) {
			mail.addMessage(ms.get(i));
		}

		CompareMessageByReadAndTime comp = new CompareMessageByReadAndTime();
		mail.SortByReadAndTime(comp);

		ArrayList<Message> messages = mail.getMessages();
		int id = Integer.parseInt(request.getParameter("messageID"));
				//(Integer) session.getAttribute("messageID");
		
		Message m = new Message();

		for (int i = 0; i < messages.size(); i++) {
			
			if (messages.get(i).getID() == id) {
				m = messages.get(i);
				m.read();
				db.readMessage(id);
				break;
			}
			
		}
		String senderName = m.sender;
		String recipientName = m.recipient;
		String isAvailabilityRequest = m.isAvailabilityRequest;
	%>
</head>
<body onload="javascript:checkMessageType()">
	<nav class="navbar navbar-default">
  		<div class="container-fluid" style="padding-left: 0px;">
		    <div class="navbar-header">
		    	<button onClick = "goBack();" style="padding-top: 5px; padding-left: 10px; border:none; background-color:#c5c1fe; "> <img src="arrow.png" style="width:50px; height: 40px"> </button>
		    </div>
		    <div class="collapse navbar-collapse" id="myNavbar">
		       <ul class="nav navbar-nav navbar-right">
		        <li style="margin-top: 10px; font-size: 20px">Safe Hands</li>
		      </ul>
		    </div>
 		</div>
	</nav>
	<div class="container-fluid"> 
		<br>
		<div class="card bg-dark">
			<div class="card-body media">
				<img class="sender-image mr-3" src="http://www-scf.usc.edu/~csci201/images/jeffrey_miller.jpg" width="100" height="100">
				<div class="media-body">
					<h1 class="card-title">Subject: <% out.println(m.getSubject()); %></h1>
					<h3 class="card-subtitle">From: <% out.println(m.getSender()); %></h3>
				</div>
			</div>
		</div>
		<br>
		<div class="card bg-dark">
			<div class="card-body">
				<% out.print(m.getBody()); %>
				<p class="card-text" id="test"></p>
				<br>
			</div>
		</div>
	</div>
	<br />
	<br />
	<button type="button" class="btn btn-dark" id="acceptButton" onclick="javascript:acceptRequest();">Accept request</button>
	<button type="button" class="btn btn-dark" id="rejectButton" onclick="javascript:rejectRequest();">Reject request</button>
	<p id="requestDecisionResult"></p>
	<footer class="container-fluid text-center">
	  <p> © 2018 Safe Hands </p>
	</footer>
	<script>
	
		function goBack() {
			location.href = "usermessages.jsp";
		}

		function writeMessage() {
			location.href = "writemessage.jsp";
		}
		
		function acceptRequest() {
			var xhttp = new XMLHttpRequest();
			xhttp.open("POST", "ChangeAvailability", true);
			xhttp.onreadystatechange = function () {
				console.log("In openmessage.jsp's ChangeAvailability callback function")
			}
			xhttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
			xhttp.send("shelterName=" + "<%= recipientName%>" + 
				"&availabilityUpdate=-1");
			document.getElementById("acceptButton").remove();
			document.getElementById("rejectButton").remove();
			document.getElementById("requestDecisionResult").innerHTML = "Request accepted!";
			document.getElementById("requestDecisionResult").style.visibility = "visible";
		}
		
		function rejectRequest() {
			console.log("in reject request");
			document.getElementById("acceptButton").remove();
			document.getElementById("rejectButton").remove();
			document.getElementById("requestDecisionResult").innerHTML = "Request rejected!";
			document.getElementById("requestDecisionResult").style.visibility = "visible";
		}
		
		function checkMessageType() {
			if ("<%=isAvailabilityRequest%>" == "true") {
				document.getElementById("acceptButton").style.visibility = "visible";
				document.getElementById("rejectButton").style.visibility = "visible";
			}
		}
	</script>
</body>
</html>
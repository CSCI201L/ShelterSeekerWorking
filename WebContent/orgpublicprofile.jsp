<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page    
    import="retrieval.DBHelper, retrieval.Message, retrieval.Mail,  javax.servlet.http.HttpServlet, 
    javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse, 
    retrieval.CompareMessageByReadAndTime,java.util.*"%>
<!DOCTYPE html>
<html>
<head>
	<%String availability = (String)request.getAttribute("availability"); %>
	<%String zipCode = (String)request.getAttribute("zipCode"); %>
	<%String phoneNumber = (String)request.getAttribute("phoneNumber"); %>
	<%String kids = (String)request.getAttribute("kids"); %>
	<%String pets = (String)request.getAttribute("pets"); %>
	<%String bio = (String)request.getAttribute("bio"); %>
	<%String currentRating = (String)request.getAttribute("currentRating"); %>
	<%String nearPharmacy = (String)request.getAttribute("nearPharmacy"); %>
	<%String nearGrocery = (String)request.getAttribute("nearGrocery"); %>
	<%String nearLaundromat = (String)request.getAttribute("nearLaundromat"); %>
	<%String shelterID = (String)request.getAttribute("shelterID"); %>
	<%String shelterName = (String)request.getAttribute("shelterName"); %>
	<%
		DBHelper db = (DBHelper) request.getSession().getAttribute("DBHelper");
		System.out.println(db.didConnect() + " is status");
		String email = db.user.email;
		String user = db.user.username;
	%>
	
	<title>Shelter Seekers Organization Public Profile Page</title>
	<script src="https://apis.google.com/js/platform.js" async defer></script>
	<script src="//ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js"></script>
	<meta charset="utf-8">
  	<meta name="viewport" content="width=device-width, initial-scale=1">
  	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
  	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
  	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
  	<link href="https://fonts.googleapis.com/css?family=Nunito+Sans" rel="stylesheet">
	<style>
		#message {
			color: black;
		}
		#subject {
			color: black;
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
		#requestSpotSection {
			visibility: hidden;
		}
		#confirmRequestSent {
			visibility: hidden;
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
		.mainSection {
			margin-bottom: 80px;
		}
		
		</style>
		<script src="https://apis.google.com/js/platform.js" async defer></script>
</head>
<body>
	<nav class="navbar navbar-default">
	  <div class="container-fluid">
	  		<div class="navbar-header">
		 	<figure class="navbar-brand">
			  <img src="bed.png" style="width: 30px;height: 40px;">
			</figure>	
		</div>
	    <ul class="nav navbar-nav">
	   	 	<li><a style="font-size: 20px">Safe Hands</a></li>
	      <li><a href="userhomepage.jsp">Search</a></li>
	      <li><a href="usermessages.jsp">Messages</a></li>
	      <li><a href="usersettings.jsp">Settings</a></li>
	    </ul>
	     <ul class="nav navbar-nav navbar-right">
        	<li><a class="navbar-brand" href="signin.jsp">Sign Out</a></li>
      	</ul>
	  </div>
	</nav>
	<div class="mainSection">
		<div class="container-fluid">
			<img id="pic" src="http://www-scf.usc.edu/~csci201/images/jeffrey_miller.jpg" width="100" height="100">
			<div id="info">
			<h3>Shelter Information</h3><br>
			Availability: <%= availability %> <br>
			Zip Code: <%= zipCode %> <br>
			Phone Number: <%= phoneNumber %> <br>
			Biography: <%= bio %> <br>
			<div id="rating">
				Rating: <%= currentRating %> <br>
			</div>
			Pets? <%= pets %> <br>
			Children? <%= kids %> <br>
			Near a pharmacy? <%= nearPharmacy %> <br>
			Near a grocery store? <%= nearGrocery %> <br>
			Near a laundromat? <%= nearLaundromat %>  <br>
			</div>
			<br />
			<br />
			
			<button id="goToShelterChatRoom" onclick="goToShelterChatRoom();">Shelter Chat Room</button>
			<br />
			<br />
			<h4>Give this shelter a rating</h4>
			<input type="radio" id="criteriaMinRating1" name="criteriaMinRating" onclick="javascript:giveRatingOne();"/>
	        <label for="criteriaMinRating1"><span class="glyphicon glyphicon-star"></span></label>
	        <input type="radio" id="criteriaMinRating2" name="criteriaMinRating" onclick="javascript:giveRatingTwo();"/>
	        <label for="criteriaMinRating2"><span class="glyphicon glyphicon-star"></span><span class="glyphicon glyphicon-star"></span></label>
	        <input type="radio" id="criteriaMinRating3" name="criteriaMinRating" onclick="javascript:giveRatingThree();"/>
	        <label for="criteriaMinRating3"><span class="glyphicon glyphicon-star"></span><span class="glyphicon glyphicon-star"></span><span class="glyphicon glyphicon-star"></span></label>
	        <input type="radio" id="criteriaMinRating4" name="criteriaMinRating" onclick="javascript:giveRatingFour();"/>
	        <label for="criteriaMinRating4"><span class="glyphicon glyphicon-star"></span><span class="glyphicon glyphicon-star"></span><span class="glyphicon glyphicon-star"></span><span class="glyphicon glyphicon-star"></span></label>
	        <input type="radio" id="criteriaMinRating5" name="criteriaMinRating" onclick="javascript:giveRatingFive();"/>
	        <label for="criteriaMinRating5"><span class="glyphicon glyphicon-star"></span><span class="glyphicon glyphicon-star"></span><span class="glyphicon glyphicon-star"></span><span class="glyphicon glyphicon-star"></span><span class="glyphicon glyphicon-star"></span></label>
	        <br />
			<br />
	        <button id="requestSpot" onclick="clickRequestSpot();">Request a room</button>
			<br />
			<br />
			<div id="requestSpotSection">
				<form id="requestSpotForm" action="javascript:onRequestSpot();">
					Subject: <input type="text" id="subject" value="Requesting a shelter room" />
					<br />
					<br />
					Message:
					<textarea id="message" rows="10" cols="50" form="requestSpotForm">I would like to request a spot in your shelter.
					</textarea>
					<br />
					<br />
					<input type="submit" value="Send Message"/>
				</form>
			</div>
			<p id="confirmRequestSent">Your request has been sent!</p>
			
		</div>
	</div>
	<footer class="container-fluid text-center">
	  <p> © 2018 Safe Hands </p>
	</footer>
	<script>
	
	function goToShelterChatRoom() {
		sessionStorage.setItem('shelterID', <%=(String)request.getAttribute("shelterID")%>);
		sessionStorage.setItem('shelterName', "<%=(String)request.getAttribute("shelterName")%>");
		sessionStorage.setItem('username', "<%=user%>");
		document.location.href = "http://localhost:8080/ShelterSeeker/chat.jsp";
		
	}
	
	function giveRatingOne() {giveRating(1);}
	function giveRatingTwo() {giveRating(2);}
	function giveRatingThree() {giveRating(3);}
	function giveRatingFour() {giveRating(4);}
	function giveRatingFive() {giveRating(5);}
	
	function giveRating(rating) {
		var xhttp = new XMLHttpRequest();
		xhttp.open("POST", "GiveRating", true);
		xhttp.onreadystatechange = function () {
			let responseText = this.responseText;
			document.getElementById("rating").innerHTML = "Rating: " + responseText.trim();
		}
		xhttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
		xhttp.send("rating=" + rating + "&email=" + "<%=email%>" +
			"&shelterID=" + <%=(String)request.getAttribute("shelterID")%>);
	}
	
	function clickRequestSpot() {
		document.getElementById("requestSpotSection").style.visibility = "visible";
	}
	
	function onRequestSpot() {
		var xhttp = new XMLHttpRequest();
		xhttp.open("POST", "SendMessage", true);
		xhttp.onreadystatechange = function () {
			console.log("In orgpublicprofile's SendMessage callback function");
		}
		xhttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
		xhttp.send("subject=" + document.getElementById("subject").value + 
				"&recipient=" + "<%=shelterName%>" +
				"&message=" + document.getElementById("message").value +
				"&sender=" + "<%=user%>" +
				"&isAvailabilityRequest=true");
		
		document.getElementById("requestSpot").remove();
		document.getElementById("requestSpotSection").remove();
		document.getElementById("confirmRequestSent").style.visibility = "visible";
	}
	
	</script>
	
</body>
</html>
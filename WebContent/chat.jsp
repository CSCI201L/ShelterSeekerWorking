<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link href="https://fonts.googleapis.com/css?family=Quicksand" rel="stylesheet">
<script src="https://apis.google.com/js/platform.js" async defer></script>
<script src="https://apis.google.com/js/platform.js" async defer></script>
<script src="//ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js"></script>
<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
	<link href="https://fonts.googleapis.com/css?family=Nunito+Sans" rel="stylesheet">
<title>Chat Client</title>

<style>
	html, body{
			margin: 0;
   			height: 100%;
			font-family: 'Quicksand', sans-serif;
			background-image: linear-gradient(to right, #7a5ce5, #a490ea, #7a5ce5);
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
	.container {
	    border: 2px solid #dedede;
	    background-color: #f1f1f1;
	    border-radius: 5px;
	    margin: 5px 0;
	}
	
	.container::after {
	    content: "";
	    clear: both;
	    display: table;
	}
	
	.container img {
	    float: left;
	    max-width: 50px;
	    width: 100%;
	    margin-right: 10px;
	    border-radius: 50%;
	}
	.container img.right {
	    float: right;
	    margin-left: 10px;
	    margin-right:0;
	}
	.time-right {
	    float: right;
	    color: #aaa;
	}
	#chat{
		overflow: scroll; 
		border-color: white;
		border-radius: 5px;
		border-style: inset;
		height: 70%;
		width: 90%;
		margin: auto; 
		margin-top: 2%; 
		color: white; 
		
	}
	#formInput{
		width: 75%;
		height: 4%;
		margin-left: 5%; 
	}
	
	#title{
		margin-top: 2%;
		font-size: 30px; 
		text-align: center; 
	}
	input[type=text] {
	    padding: 5px 5px 5px 5px;
	}
	.column {
    float: left;
    padding: 10px;
	}
	.column.side {
    	width: 25%;
    	height: 100%; 
	}
	.column.middle {
	    width: 70%;
	    height: 100%;
	    border-right: 1px dotted white;
	}
	i{
		font-size:20px;
		text-align: center;
	}
</style>
</head>
<script>
	var socket;
	function connectToServer() {
		socket = new WebSocket("ws://localhost:8080/ShelterSeeker/chatroomServerEndpoint");
		var today = new Date();
		var iso = today.toLocaleTimeString('en-US');
		var time = iso.slice(0, 4) + " " + iso.slice(8,10);
		document.getElementById("title").innerHTML = "Welcome to " + sessionStorage.getItem('shelterName') + "'s chat room!";
		console.log(time);
		
		socket.onopen = function(event) {
			document.getElementById("chat").innerHTML += "You have successfully joined the conversation as " + sessionStorage.getItem('username');
			socket.send(sessionStorage.getItem('username') + "|" + sessionStorage.getItem('shelterID'));
		}
		
		socket.onmessage = function(event) {
			//document.getElementById("chat").innerHTML += sessionStorage.getItem('username') + " has joined the conversation";
			document.getElementById("chat").innerHTML += "<div id='mychat' class='container'> <img src='https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909__340.png'>" + time + " " + event.data + "</div>";
			//document.getElementById("users").innerHTML += "<img src='https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909__340.spng'>" + time + " " + event.data + "</div>";
		}
		
		
		socket.onclose = function(event) {
			document.getElementById("chat").innerHTML += document.getElementById("user").value + " has left the conversation at" + d.getHours() + ":" + d.getMinutes();
			//document.getElementById("chat").innerHTML += document.getElementById("user").value + " has left the conversation at" + d.getHours() + ":" + d.getMinutes();
		}
		
	}
	function sendMessage() {
		socket.send(sessionStorage.getItem('shelterID') + "|" + document.getElementById("formInput").value);
		return false;
	}
	function sendUserName(e) {
		//console.log("IN send user name");
		if(e.keyCode == 13){
			console.log("username = " + document.getElementById("user").value);
			socket.send(document.getElementById("user").value);
		}
	}
</script>
			
<body onload="connectToServer()">
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
	<div class="column middle">
		<div id="title">
		</div>
		<div id="chat"> 
		</div>
	
		<input style="color:grey;" id="formInput" type="text" name="message" placeholder="Type message here...">
		 <button style="width: 13%;" class="btn btn-md btn-default" id="submit" onClick="return sendMessage();">Send </button>
	
	</div>
	<div class="column side">
		<div id="rules">
			<br> 
			<p style="margin-top: 5%; font-weight: bold; text-align:center; font-size:20px"><ins>Chat Room Rules</ins></p>
			<i> Rule 1 </i> <br> Be positive and helpful to other users. <br><br>
			<i> Rule 2 </i> <br> Be respectful to Shelter administrators.	<br><br>
			<i> Rule 3 </i>  <br> Any signs of abuse will lead to expulsion from the chat room.<br><br>
			<i> Rule 4 </i> <br>	Do not share any personal information that you are not comfortable with.<br><br>
			<i> Rule 5 </i>  <br> Please call The National Domestic Violence Hotline at 1.800.799.SAFE. for any other concerns.<br><br>
		</div>
	</div>
	
	<footer class="container-fluid text-center">
	  <p> © 2018 Safe Hands </p>
	</footer>
</body>
</html>
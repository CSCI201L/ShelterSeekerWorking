<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page import="retrieval.DBHelper, retrieval.Message, retrieval.Mail,  javax.servlet.http.HttpServlet, javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse, retrieval.CompareMessageByReadAndTime,java.util.*"%>
    
<!DOCTYPE html>
<html>
<head>
	<title>Shelter Seekers User Settings</title>
	<head>
	<title>Shelter Seekers User Settings</title>
	<script src="https://apis.google.com/js/platform.js" async defer></script>
	<script src="https://apis.google.com/js/platform.js" async defer></script>
	<script src="//ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js"></script>
	<meta charset="utf-8">
  	<meta name="viewport" content="width=device-width, initial-scale=1">
  	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
  	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
  	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
  	<link href="https://fonts.googleapis.com/css?family=Nunito+Sans" rel="stylesheet">
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
		.navbar-brand{
    		padding: 0px 15px;
    		margin-right: -15px;
		}
		.navbar-right{
			margin-right: 0px;
		}
		input{
			color: gray
		}
		</style>
</head>
<%
	DBHelper db =(DBHelper) request.getSession().getAttribute("DBHelper");
	//String email=db.user.email;
	String emailerror=(String)request.getAttribute("email_err");
	if(emailerror==null){
		emailerror="";	
	}
	String currpassworderror=(String)request.getAttribute("currpass_err");
	if(currpassworderror==null){
		currpassworderror="";
	}
	String newpassworderror=(String)request.getAttribute("newpass_err");
	if(newpassworderror==null){
		newpassworderror="";
	}
	String ziperror=(String)request.getAttribute("zip_err");
	if(ziperror==null){
		ziperror="";
	}
	String phoneerror=(String)request.getAttribute("phone_err");
	if(phoneerror==null){
		phoneerror="";
	}
%>
<body> <!-- onload="defaultContactInfo();"> -->
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
	
	<div class="container-fluid"> 
	
	<form action="bUpdateUser" method="GET"><!-- <!-- onsubmit="return validate(); --"> -->
		<div class="col-lg-6">	
			<h1>Security Preferences</h1>
			<h3 class="blueFont">Update Email </h3>
		  	<div style="font-size: 16px" class="form-group">
		   	 	<label for="curr_email"> Current Email:</label><br>
		      	<input id="curr_email" type="text" readonly class="form-control-plaintext" value="<%=db.user.email %>">
				<br><label for="new_email">New Email:</label><br>
				<input id="new_email" type="text" name="new_email">
				<%= emailerror %>
			 </div>
			 <h3 class="blueFont">Update Password</h3>
			 <div style="font-size: 16px" class="form-group">
				<label for="curr_pass">Please re-enter your current password:</label><br>
				<input  id="curr_pass" type="text" name="current_password">
				<%= currpassworderror %>
				<br><label for="new_pass">New password:</label><br>
				<input  id="new_pass" type="text" name="new_password">
				<%= newpassworderror %>
			</div>
			<h3 class="blueFont">Update Number </h3>
			 <div  style="font-size: 16px" class="form-group">
				<label for="curr_num"> Current Phone Number:</label><br>
				<input  id="curr_num" type="text" readonly class="form-control-plaintext" value="<%=db.user.phoneNumber %>">
				<br><label for="new_phone">New Number:</label><br>
				<input  id="new_phone" type="tel" name="new_phone" placeholder="xxx-xxx-xxxx" pattern="[0-9]{3}-[0-9]{3}-[0-9]{4}">
				<%= phoneerror %>
			</div>
		</div>
		<div class="col-lg-6">	
			<h1>Personal Preferences</h1>
			<h3 class="blueFont" >Update Zipcode </h3>
			 <div style="font-size: 16px" class="form-group"> 
				 <label for="curr_zip"> Current Zipcode:</label><br>
				 <input type="text" readonly id="curr_zip" class="form-control-plaintext" value="<%=db.user.zipcode %>"> 
				 <br><label for="new_zipcode">New Zipcode:</label><br>
				<input id="new_zipcode" type="text" name="new_zipcode">
					<%= ziperror %>
			</div>
			<h3 class="blueFont" >Update Other</h3>
			<div style="font-size: 16px" class="form-check form-check-inline">
				Must allow children?
				 <label class="form-check-label">
					<input class="form-check-input" type="radio" name="children" value="1" required> Yes
				</label>
				 <label class="form-check-label">
					<input class="form-check-input"  type="radio" name="children" value="0"> No
				</label>
			</div>
			<div style="font-size: 16px" class="form-check form-check-inline">
				Must allow pets? 
				 <label class="form-check-label">
					<input class="form-check-input" type="radio" name="pets" value="1" required> Yes
				</label>
				 <label class="form-check-label">
					<input  class="form-check-input" type="radio" name="pets" value="0"> No
				</label>
			</div>
			
			<input class="btn btn-lg btn-default" type="submit" style="margin-top: 20px" value= "Update New Settings">
		</div>
	</form>
	</div>
	<footer class="container-fluid text-center">
	  <p> © 2018 Safe Hands </p>
	</footer>
	<script>
	function validate(){
		var x=document.getElementById("new_email").value;
			y=document.getElementById("curr_pass").value;
			z=document.getElementById("new_pass").value;
			email_errormessage=document.getElementById("email-error");
			curr_passerrormessage=document.getElementById("curr_pass-error");
			new_passerrormessage=document.getElementById("new_pass-error");
		if(x.length<1&&y.length<1){
			alert("emothu");
			email_errormessage.innerHTML="cant be empty";
			curr_passerrormessage.innerHTML="cant be empty";
			return false;
		}
		if(y.length<1&&z.length<1){
			alert("afs");
			curr_passerrormessage.innerHTML="cant be empty";
			new_passerrormessage.innerHTML="cant be empty";
			return false;
		}
	}
	function defaultContactInfo(){
		if(document.getElementById("org_info").value.length<1){
			document.getElementById("org_info").defaultValue="default info, change it";
		}
	}
 </script>	
</body>
</html> 
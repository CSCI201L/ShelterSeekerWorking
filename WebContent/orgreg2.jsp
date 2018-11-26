<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!-- sign up section onsubmit="return !!(validateEmail() & validateUsername() & validatePassword() & validateZip());" -->
<%
	String err = (String) request.getAttribute("err");
	if (err==null){
		err = "";
	}
	%>
<!DOCTYPE html>
<html>
<head>
	<title>Shelter Seekers User Register</title>
	<script src="https://apis.google.com/js/platform.js" async defer></script>
	<script src="//ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js"></script>
		<script src="https://apis.google.com/js/platform.js" async defer></script>
	<meta charset="utf-8">
  	<meta name="viewport" content="width=device-width, initial-scale=1">
  	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
  	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
  	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
  	<link href="https://fonts.googleapis.com/css?family=Nunito+Sans" rel="stylesheet">
	
	<style>
		 .navbar {
		 background-color: #c5c1fe;
	      margin-bottom: 0;
	      border-radius: 0;
	      border-color:#c5c1fe;
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
			font-size: 15px; 
		 	font-weight: 100; 
		 }
	</style>
</head>
<body>
	<nav class="navbar navbar-default">
  		<div class="container-fluid" style="padding-left: 0px;">
		    <div class="navbar-header">
		    	<button onClick = "redirectHome();" style="padding-top: 5px; padding-left: 10px; border:none; background-color:#c5c1fe; "> <img src="arrow.png" style="width:50px; height: 40px"> </button>
		    </div>
		    <div class="collapse navbar-collapse" id="myNavbar">
		       <ul class="nav navbar-nav navbar-right" style="margin-top: 10px; font-size: 20px">
		       	<li style="padding-right:15px; margin-top:-10px;"><img src="bed.png" style="width: 30px;height: 40px;"></li>
		        <li>Safe Hands</li>
		      </ul>
		    </div>
 		</div>
	</nav>
	<div class="container-fluid text-center"> 
		<h1>Registration Continued</h1>
		<div class="col col-sm-6 " style="margin-left: 25%;">
			<form style="border: 2px double white; text-align: center;" name="signup"  action="oSignUp2" method="POST" ><!-- method="POST" action ="Servlet" -->
				<h3 class = "blueFont">Shelter Info</h3> 
				<div class="form-group">
					<label style="margin-left: 15%" for="pic">Upload Picture:</label>
					<input id="pic" style="display: inline;" class="form-control-file" type="file"  name = "f" id="f" accept="image/*" required>
					<input type="text" id="base64" name="base64" hidden="true">
				</div>
				<p class = "segoe" style = "font-size: 20px; font-weight: bold;color: red"><%= err %></p>
				<div class="form-group">
					<label class="form-check-label" for="children">Do you allow children?</label>
					<input class="form-check-input" type="checkbox" id="children" name="children" value="yes" checked> Yes<br>
				</div>
				<div class="form-group">
					<label class="form-check-label" for="pets">Do you allow pets?</label>
					<input class="form-check-input" type="checkbox" id="pets" name="pets" value="yes" checked> Yes<br>
				</div>
				<div class="form-group">
					<label class="form-check-label" for="pharmacy">Is there a Pharmacy nearby?</label>
					<input class="form-check-input" type="checkbox" id="pharmacy" name="pharmacy" value="yes" checked> Yes<br>
				</div>
				<div class="form-group">
					<label class="form-check-label" for="grocery">Are you located near a Grocery?</label>
					<input class="form-check-input" type="checkbox" id="grocery" name="grocery" value="yes" checked> Yes<br>
				</div>
				<div class="form-group">
					<label class="form-check-label" for="laundromat">Are you located near a Laundromat?</label>
					<input class="form-check-input" type="checkbox" id="laundromat" name="laundromat" value="yes" checked> Yes<br>
				</div>
				<div class="form-group">
					<input  type="number" class = "segoe blueFont" name ="occupants" placeholder ="# of occupants" required> <br>
				</div>
				<div class="form-group">
					<input  type="number" class = "segoe blueFont" name ="capacity" placeholder ="Max Capacity #" required> <br>
				</div>
				<div class="form-group">
					<input  type="text" class = "segoe blueFont" name ="bio" style="width:300px;margin:10px" placeholder ="Tell us about your shelter!" required> <br>
				</div>
				<input type="hidden" name = "zipcode" value = "<%=(String) request.getParameter("zipcode")%>">
				<input type="hidden" name = "address" value = "<%=(String) request.getParameter("address")%>">
				<input type="hidden" name = "email" value = "<%=(String)request.getParameter("email")%>">
				<input type="hidden" name = "username" value = "<%=(String) request.getParameter("username")%>">
				<input type="hidden" name = "password" value = "<%=(String) request.getParameter("password")%>">
				<input type="hidden" name = "phone" value = "<%=(String) request.getParameter("phone")%>">
				<input type="submit" class ="btn btn-lg btn-default"  style="margin-bottom: 10px" value= "Sign-Up">
			</form>
		</div>
	</div>
	
	<footer class="container-fluid text-center">
	  <p> © 2018 Safe Hands </p>
	</footer>
	
	<script>
	function redirectHome(){
		location.href="signin.jsp";
	}
	//validate email
	function validateEmail(){
		var x=document.getElementById("email").value;
			unerrormessage=document.getElementById("email-error");
		if(!x.length){
			alert("lmao");
			unerrormessage.innerHTML="must have input";
			return false;
		}
		 if (!(/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(signup.email.value))){
			 alert("false");
			 unerrormessage.innerHTML="not valid, needs to contain @";
			 return false;
		 }
	}
	function readFile() {
		if ( this.files && this.files[0]){
			var FR = new FileReader();
			FR.addEventListener("load", function(e){
				document.getElementById("base64").value = e.target.result;
			//	document.getElementById("test").src = e.target.result;
			});
			
			FR.readAsDataURL(this.files[0]);
		}
	}
	
	document.getElementById("f").addEventListener("change", readFile);
	//validate username
	function validateUsername(){
		var x=document.getElementById("un").value;
			unerrormessage=document.getElementById("un-error");
		if(!x.length){
			alert("lmao");
			unerrormessage.innerHTML="must have input";
			return false;
		}
	}
	//validate password
	function validatePassword(){
		var x=document.getElementById("pwd").value;
			unerrormessage=document.getElementById("pw-error");
		if(!x.length){
			alert("lmao");
			unerrormessage.innerHTML="must have input";
			return false;
		}
	}
	//validate zip code
	function validateZip(){
		var x=document.getElementById("zip").value;
			errormessage=document.getElementById("zip-error");
		if(x.length<5){
			alert("af");
			errormessage.innerHTML="input is too short. zip must be 5 numbers";
			return false;
		}
		if(x.length>5){
			errormessage.innerHTML="input is too long. zip must be 5 numbers";
			return false;
		}if(isNaN(x)){
			errormessage.innerHTML="zip must be numbers";
			return false;
		}
	}
	
/* 	var x = document.getElementById("loc");
 	function getLocation() {
	    if (navigator.geolocation) {
	        navigator.geolocation.getCurrentPosition(showPosition, showError);
	    } else {
	        x.innerHTML = "Geolocation is not supported by this browser.";
	    }
	}
	
	function showPosition(position) {
	    var latlon = position.coords.latitude + "," + position.coords.longitude;
	    var img_url = "https://maps.googleapis.com/maps/api/staticmap?center="
	    +latlon+"&zoom=14&size=400x300&key=AIzaSyBu-916DdpKAjTmJNIgngS6HL_kDIKU0aU";
	    document.getElementById("mapholder").innerHTML = "<img src='"+img_url+"'>";
	} */
	
	
	</script>
	
	
	
	
	
</body>
</html> 
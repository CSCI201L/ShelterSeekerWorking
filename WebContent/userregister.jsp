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
	    body {
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
		.segoe {
			font-size: 20px;
			font-weight: 200;
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
	<p class = "segoe" style = "font-size: 20px; font-weight: bold;color: red"><%= err %></p>
	<h1 style="text-align: center">Registration</h1>
	<div class="container-fluid text-center"> 
		<div class="col col-sm-6 " style="margin-left: 25%;">
			<form style="border: 2px double white; text-align: center;" name="signup"  action="bSignUp" method="GET" ><!-- method="POST" action ="Servlet" -->
			<h3 class="blueFont">Please enter your information below: </h3>
			<div class="form-group">
				<input id="email" type="email" class = "segoe blueFont" name ="email" placeholder ="Email" required> <br>
			</div>
			<div class="form-group">
				<input id="un" type="text" class = "segoe blueFont" name ="username" placeholder ="Username" required> <br>
			</div>
			<div class="form-group">
				<input id="pwd" type="text" class = "segoe blueFont" name ="password" placeholder ="Password" required> <br>
			</div>
			<div class="form-group">
				<input id="zip" type="text"class = "segoe blueFont" name ="zipcode" placeholder ="Zipcode" required > <br>
			</div>
			<div class="form-group">
				<input id="zip" type="text"class = "segoe blueFont" name ="phone" placeholder ="Phone Number" required > <br>
			</div>
			<h3 class="blueFont">Please upload a profile picture: </h3>
			<div class="form-group">
				<input style="margin-left:40%" type="file" name="f" id="f" accept="image/*" required>
				<input type="text" id="base64" name="base64" hidden="true">
			</div>
			<h3 class="blueFont">Personal Preferences</h3>
			<div class="checkbox">
				<p>Are you looking for shelters that allow children?</p>
				<input type="checkbox" name="children" checked> Yes<br>
			</div>
			<div class="checkbox">
				<p >Are you looking for shelters that allow pets?</p>
				<input type="checkbox" name="pets" value="yes" checked> Yes<br>
			</div>
			<input type="submit" class="btn btn-lg btn-default" style="margin-bottom: 20px" value= "Sign-Up">
			<br>
		</form>
		</div>
	</div>
	
	<footer class="container-fluid text-center">
		<p> © 2018 Safe Hands </p>
	</footer>
	
	<script>
	function findLocation(){
		//find location using geoLocation
		if (navigator.geolocation) {
			  console.log('Geolocation is supported!');
			}
			else {
			  console.log('Geolocation is not supported for this Browser/OS.');
			}	
		var lat;
		var lon;
		var geoSuccess = function(position) {
		    startPos = position;
		    document.getElementById('startLat').innerHTML = startPos.coords.latitude;
		    document.getElementById('startLon').innerHTML = startPos.coords.longitude;

		  };
		 	
		  	console.log(document.getElementById("f").value);
		 	console.log("HERE", navigator.geolocation.getCurrentPosition(geoSuccess));
			lat = document.getElementById('startLat').innerHTML;
			lon = document.getElementById('startLon').innerHTML; 
		 	console.log(lat);
		 	console.log(lon);
			
		 	const xhttp = new XMLHttpRequest();
		 	var URL = "http://api.geonames.org/findNearestAddressJSON?lat=" + document.getElementById('startLat').innerHTML + "&lng=" + document.getElementById('startLon').innerHTML +"&username=dhan";
		 	//var URL = "http://maps.googleapis.com/maps/api/geocode/json?latlng=" + document.getElementById('startLat').innerHTML + ","+ document.getElementById('startLon').innerHTML+",7.3553838&sensor=true"
		 	var request = createCORSRequest("get", URL);
		 	if (request){
		 	    request.onload = function() {
	//				console.log("RESPONSE" ,this.responseText);
		 	    };
		 	    request.onreadystatechange = function() {
					console.log("RESPONSE" ,this.responseText);
					var info = JSON.parse(this.responseText);
					var address = info.address.streetNumber + " " +info.address.street+ ", " +info.address.placename + " " + info.address.adminCode1 + " " +info.address.postalcode;
					console.log("Address ", address);
					document.getElementById("location").value = address;
					document.getElementById("zipcode").value = info.address.postalcode;

				};
		 	    request.send();
		 	}
		 	/*		 	xhttp.open("GET", URL, false);
				xhttp.onreadystatechange = function() {
					console.log("RESPONSE" ,this.responseText);

				};
				xhttp.setRequestHeader("Content-Type","application/x-www-urlencoded");
				xhttp.send(); */
		 	//user Geolocation API
		
	}
	
	function createCORSRequest(method, url){
	    var xhr = new XMLHttpRequest();
	    if ("withCredentials" in xhr){
	        xhr.open(method, url, true);
	    } else if (typeof XDomainRequest != "undefined"){
	        xhr = new XDomainRequest();
	        xhr.open(method, url);
	    } else {
	        xhr = null;
	    }
	    return xhr;
	}
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
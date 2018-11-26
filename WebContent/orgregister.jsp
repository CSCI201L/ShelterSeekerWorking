<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<title>Shelter Seekers Org Register</title>
	<script src="https://apis.google.com/js/platform.js" async defer></script>
</head>
<body>
	<div id="top"> 
	
	</div>
	
	<div id="middle"> 
	
		<div id="Sign-Up">
		<!-- sign up section -->
		<form name="signup" onsubmit="return !!(validateEmail() & validateUsername() & validatePassword() & validateZip());"><!-- method="POST" action ="Servlet" -->
			Organization Sign-Up <br/>
			<input id="email" type="text" name ="email" placeholder ="Email" > <span id="email-error"></span>
			<br/>
			<input id="un" type="text" name ="username" placeholder ="Username" > <span id="un-error"></span>
			<br/>
			<input id="pwd" type="text" name ="password" placeholder ="Password" > <span id="pw-error"></span>
			<br/>
			<input id="zip" type="text" name ="zipcode" placeholder ="Zipcode" > <span id="zip-error"></span>
			<br/>
			Does your shelter allow children?
			<br/>
			<input type="radio" name="children" value="yes"> Yes<br>
			<input type="radio" name="children" value="no"> No<br>
			Does your shelter allow pets?
			<br/>
			<input type="radio" name="pets" value="yes"> Yes<br>
			<input type="radio" name="pets" value="no"> No<br>
			Is your shelter located five miles from a pharmacy?
			<br/>
			<input type="radio" name="pets" value="yes"> Yes<br>
			<input type="radio" name="pets" value="no"> No<br>
			<input type="submit" value= "Sign-Up">
		</form>
	  	</div>
	<!-- <button id="loc" onclick="getLocation()">Find my Location</button>	  	
	  <div id="myLoc"></div> -->	
	</div>
	
	<div id="bottom"> 
	
	</div>
	
	<script>
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
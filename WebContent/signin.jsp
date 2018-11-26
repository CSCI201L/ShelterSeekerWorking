<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
	String err = (String) request.getAttribute("err");
	if (err==null){
		err = "";
	}

%>
<html>
	<head>
	<script src="https://apis.google.com/js/platform.js" async defer></script>
	<script src="//ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js"></script>
	<meta charset="utf-8">
  	<meta name="viewport" content="width=device-width, initial-scale=1">
  	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
  	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
  	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
	<link href="https://fonts.googleapis.com/css?family=Nunito+Sans" rel="stylesheet">
	
	<style>
		h3{
			margin: 30px;
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
		.btn-space {
		    margin: 20px;
		}
	</style>
	<title>Shelter Seekers Sign-In</title>
	</head>
<body>
	<div class="jumbotron text-center" style="background-image: radial-gradient(#dedbfd, #c5c1fe)">
		<h1 style="color: white; font-weight: bold;">Welcome to Safe Hands
	  	<img src="bed.png" style="width: 50px;height: 60px; margin-bottom: 20px;"> 
	  	</h1>
	  	<p style="color: gray;">We're here to help</p> 
	</div>
	  
	  <div class="container-fluid text-center"> 
			<div class="row">
				<div class="col-sm-6">
					<h2>New to Safe Hands?</h2>
					<h3>No Problem! Please select an option below:  </h3>
					<button type="button" class="btn btn-default btn-lg btn-space" onclick="redirectGuestSign()">Continue as Guest</button>
					<h3>Register Now as</h3>
					<button type="button" class="btn btn-default btn-lg btn-space" onclick="redirectRegister()">New User</button>
	  				<button type="button" class="btn btn-default btn-lg btn-space" onclick="redirectShelter()">New Shelter</button>
			</div>
			<div class="col-sm-6">	
		 		<h2>Already have an account?</h2>
		 		<h3>Sign in</h3>
				<form action="vSignIn" method="GET"><!-- method="POST" action ="Servlet" -->
					<div class="form-group">
						<input id="un" type="text" name ="email" style = "color: black; font-size:18px" placeholder ="email" required>
					</div>
					<div class="form-group">	
						<input id="pwd" type="text" name ="password" style = "color: black; font-size:18px"  placeholder ="password" required>
					</div>
					<div class="checkbox">
				      <label style = "font-size:18px;"><input type="checkbox"> Remember me</label>
				    </div>
				 	 <input class="btn btn-md btn-default" type="submit" value= "Sign-In">
					
				</form>
				<p class = "segoe" style = "font-size: 20px; font-weight: bold;color: red"><%= err %></p>
	  		</div>	
		</div>
	</div>

</body>
	
	
	
	<script>
	//redirect to register function
	function redirectRegister(){
		location.href="userregister.jsp";
	}
	//redirect to Sign function
	function redirectGuestSign(){
		var servletName = "vSignIn";
		
		var form = $('<form action="' + servletName + '" method="GET">' +
                '<input type="text" name="email" value="guest" />' +
                 '<input type="text" name="password" value="guest" />' +
                                                      '</form>');
		$('body').append(form);
		form.submit();  
	}
	//redirect to shelter function
	function redirectShelter(){
		location.href="orgreg1.jsp";
	}
	</script>
	
</body>
</html>
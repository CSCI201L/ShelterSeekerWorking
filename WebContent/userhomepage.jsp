<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page    
    import="retrieval.DBHelper, retrieval.Message, retrieval.Mail,  javax.servlet.http.HttpServlet, 
    javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse, 
    retrieval.CompareMessageByReadAndTime,java.util.*"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
  	<meta name="viewport" content="width=device-width, initial-scale=1">
  	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
  	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
  	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
	<link href="https://fonts.googleapis.com/css?family=Nunito+Sans" rel="stylesheet">
	<%
		String email = "";
		String address = "";
		String guest = (String)request.getAttribute("guest");
		String navTwo = "<li><a href=\"usermessages.jsp\">Messages</a></li>";
		String navThree = "<li><a href=\"usersettings.jsp\">Settings</a></li>";
		try {
			DBHelper db = (DBHelper)request.getSession().getAttribute("DBHelper");
			address = db.user.address;
			email = db.user.email;
			if (guest.equals("true")) {
				navTwo = "";
				navThree = "";
				address = "";
			}
			System.out.println(db.didConnect() + " is status");
		} catch (Exception e) {
			System.out.println(e);
		}
	%>
	<title>Shelter Seeker User Home Page</title>
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
		.navbar-brand{
    		padding: 0px 15px;
    		margin-right: -15px;
		}
		.navbar-right{
			margin-right: 0px;
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
		#numKidsSection {
			visibility: hidden;
		}
		#numPetsSection {
			visibility: hidden;
		}
		#searchLoading {
			visibility: hidden;
		}
		#searchYieldedNoResults {
			visibility: hidden;
		}
		
		.btn-dark {
			background-color: #A9A9A9;
			margin-left: 40%;
		}
		
		#searchForm {
			margin: auto;
			width: 90%;
			border: 3px solid orange;
			padding: 10px;
			margin-top: 20px;
			border-radius: 20px;
		}
		#searchFormTitle {
			text-align: center;
			text-decoration: underline;
		}
		
		#resultsTableSection {
			margin: auto;
			border: 3px solid orange;
			width: 90%;
			margin-top: 20px;
			visibility: hidden;
			padding: 20px;
			border-radius: 20px;
			margin-bottom: 6%;
		}
		
		input[type='radio']:after {
	        width: 15px;
	        height: 15px;
	        border-radius: 15px;
	        top: -2px;
	        left: -1px;
	        position: relative;
	        background-color: #d1d3d1;
	        content: '';
	        display: inline-block;
	        visibility: visible;
	    }
	
	    input[type='radio']:checked:after {
	        width: 15px;
	        height: 15px;
	        border-radius: 15px;
	        top: -2px;
	        left: -1px;
	        position: relative;
	        background-color: #ffa500;
	        content: '';
	        display: inline-block;
	        visibility: visible;
	    }
	    
	    input[type='checkbox']:after {
	        width: 15px;
	        height: 15px;
	        top: -2px;
	        left: -1px;
	        position: relative;
	        background-color: #d1d3d1;
	        content: '';
	        display: inline-block;
	        visibility: visible;
	    }
	
	    input[type='checkbox']:checked:after {
	        width: 15px;
	        height: 15px;
	        top: -2px;
	        left: -1px;
	        position: relative;
	        background-color: #ffa500;
	        content: '';
	        display: inline-block;
	        visibility: visible;
	    }
	    
	    th {
	    	text-align: center;
	    }
	</style>
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
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
	      		<li class="active" id="navSearch"><a href="#">Search</a></li>
	      		<%=navTwo %>
	      		<%=navThree %>
	    	</ul>
	     	<ul class="nav navbar-nav navbar-right">
        		<li><a class="navbar-brand" href="signin.jsp">Sign Out</a></li>
      		</ul>
  		</div>
	</nav>
	
	<div id="searchForm">
		<h4 id="searchFormTitle">Search for Shelters</h4>
		<form action="javascript:onSearch();">
			<div class="form-group row">
		     	<label class="col-sm-4 col-form-label">I want to only see shelters that accept kids.</label>
		     	<div class="col-sm-1">
		     		<input type="radio" id="criteriaKidsYes" name="criteriaKids" onclick="javascript:showNumKidsSection();"/>
		     		<label for="criteriaKidsYes">Yes</label>
		     	</div>
		     	<div class="col-sm-1">
		     		<input type="radio" id="criteriaKidsNo" name="criteriaKids" onclick="javascript:hideNumKidsSection();"/>
		        	<label for="criteriaKidsNo">No</label>
		        </div>
		        <div id="numKidsSection">
			        <label class="col-sm-1 col-form-label">How many kids?</label>
			        <div class="col-sm-2">
			       		<input class="form-control" type="text" id="criteriaNumKids">
					</div>
		        </div>
		     </div>
	        
	        <div class="form-group row">
		        <label class="col-sm-4 col-form-label">I want to only see shelters that allow for pets.</label>
		        <div class="col-sm-1">
			        <input type="radio" id="criteriaPetsYes" name="criteriaPets" onclick="javascript:showNumPetsSection();"/>
			     	<label for="criteriaPetsYes">Yes</label>
		     	</div>
		     	<div class="col-sm-1">
			     	<input type="radio" id="criteriaPetsNo" name="criteriaPets" onclick="javascript:hideNumPetsSection();"/>
			        <label for="criteriaPetsNo">No</label>
		        </div>
		        <div id="numPetsSection">
			        <label class="col-sm-1 col-form-label">How many pets?</label>
			        <div class="col-sm-2">
			       		<input class="form-control" type="text" id="criteriaNumPets">
					</div>
		        </div>
	        </div>
	
	        <div class="form-group row">
		        <label class="col-sm-4 col-form-label">I want to only see shelters that are near these resources:</label>
		        <div class="col-sm-2">
		        	<div class="form-check">
		        		<input class="form-check-input" type="checkbox" id="criteriaPharmacy"/>
		        		<label class="form-check-label" for="criteriaPharmacy">Pharmacy</label>
		        	</div>
		        </div>
		        <div class="col-sm-2">
		        	<div class="form-check">
		        		<input class="form-check-input" type="checkbox" id="criteriaGrocery"/>
		        		<label class="form-check-label" for="criteriaGrocery">Grocery</label>
		        	</div>
		        </div>
		        <div class="col-sm-2">
		        	<div class="form-check">
		        		<input class="form-check-input" type="checkbox" id="criteriaLaundromat"/>
		        		<label class="form-check-label" for="criteriaLaundromat">Laundromat</label>
		        	</div>
		        </div>
	        </div>
	        
	        <div class="form-group row"> 
	       		<div class="col-sm-12">
		        	<label>I want to only see shelters that have at least this Average User Rating: </label>
		       	</div>
		        <div class="col-sm-12">
			        <input type="radio" id="criteriaMinRating1" name="criteriaMinRating"/>
			        <label for="criteriaMinRating1"><span class="glyphicon glyphicon-star"></span></label>
			        <input type="radio" id="criteriaMinRating2" name="criteriaMinRating"/>
			        <label for="criteriaMinRating2"><span class="glyphicon glyphicon-star"></span><span class="glyphicon glyphicon-star"></span></label>
			        <input type="radio" id="criteriaMinRating3" name="criteriaMinRating"/>
			        <label for="criteriaMinRating3"><span class="glyphicon glyphicon-star"></span><span class="glyphicon glyphicon-star"></span><span class="glyphicon glyphicon-star"></span></label>
			        <input type="radio" id="criteriaMinRating4" name="criteriaMinRating"/>
			        <label for="criteriaMinRating4"><span class="glyphicon glyphicon-star"></span><span class="glyphicon glyphicon-star"></span><span class="glyphicon glyphicon-star"></span><span class="glyphicon glyphicon-star"></span></label>
			        <input type="radio" id="criteriaMinRating5" name="criteriaMinRating"/>
			        <label for="criteriaMinRating5"><span class="glyphicon glyphicon-star"></span><span class="glyphicon glyphicon-star"></span><span class="glyphicon glyphicon-star"></span><span class="glyphicon glyphicon-star"></span><span class="glyphicon glyphicon-star"></span></label>
	        	</div>
	        </div>
	        
	        <div class="form-group row">
		        <label class="col-sm-4 col-form-label">I want to only see shelters that currently have availability.</label>
		     	<div class="col-sm-1">
		     		<input type="radio" id="criteriaAvailableYes" name="criteriaAvailable"/>
		     		<label for="criteriaAvailableYes">Yes</label>
		     	</div>
		     	<div class="col-sm-1">
		     		<input type="radio" id="criteriaAvailableNo" name="criteriaAvailable" />
		        	<label for="criteriaAvailableNo">No</label>
		        </div>
	        </div>
	        
	        <div class="form-group row">
	        	<label class="col-sm-4 col-form-label" for="criteriaAddress">Search by Address<span class="glyphicon glyphicon-map-marker"></span></label>
	        	<div class="col-sm-8">
	        		<input class="form-control" type="text" id="criteriaAddress" value="<%=address %>" />
	        	</div>
	        </div>
	        
	        <div class="form-group row">
	        	<label class="col-sm-4 col-form-label" for="criteriaSearchByName">Search by Shelter name (optional)</label>
	        	<div class="col-sm-8">
	        		<input class="form-control" type="text" id="criteriaSearchByName" />
	        	</div>
	        </div>
	        
	    	<button class="btn btn-dark" type="submit">Search for shelters near your location</button>	    	
	    </form>
	</div> 
	
	<div id="resultsTableSection">
		<h4 id="searchLoading">Loading...</h4>
	    <h4 id="searchYieldedNoResults">No shelters match the input criteria.</h4>
		<table id="searchResultsTable">
			<thead>
				<tr>
					<th>Shelter Name</th>
					<th>Shelter Info</th>
					<th>Distance from you to Shelter (miles)</th>
				</tr>
			</thead>
			<tbody>
			
			</tbody>
		</table>		
	</div>
	
	<div id="bottom">
	<footer class="container-fluid text-center">
	  <p> © 2018 Safe Hands </p>
	</footer>
	</div>
	
	<script>
	var prevNumSearchResults;
	
	function onSearch() {
		let parameters = "email=" + "<%=email%>";
		let numKids = 0;
		if (document.getElementById("criteriaKidsYes").checked) {
			if (isNaN(document.getElementById("criteriaNumKids").value) || 
					document.getElementById("criteriaNumKids").value.includes(".") ||
					document.getElementById("criteriaNumKids").value.includes("-")) {
				alert("Please enter a valid number of kids.");
				return;
			} else {
				numKids = document.getElementById("criteriaNumKids").value;
			}
		}
		parameters += "&numKids=" + numKids;
		
		let numPets = 0;
		if (document.getElementById("criteriaPetsYes").checked) {
			if (isNaN(document.getElementById("criteriaNumPets").value) || 
					document.getElementById("criteriaNumPets").value.includes(".") ||
					document.getElementById("criteriaNumPets").value.includes("-")) {
				alert("Please enter a valid number of pets.");
				return;
			} else {
				numPets = document.getElementById("criteriaNumPets").value;
			}
		}
		parameters += "&numPets=" + numPets;
		if (document.getElementById("criteriaPharmacy").checked)
			parameters += "&pharmacyNearby=true";
		else
			parameters += "&pharmacyNearby=false";
		
		if (document.getElementById("criteriaGrocery").checked)
			parameters += "&groceryNearby=true";
		else
			parameters += "&groceryNearby=false";
		
		if (document.getElementById("criteriaLaundromat").checked)
			parameters += "&laundromatNearby=true";
		else
			parameters += "&laundromatNearby=false";
		
		if (document.getElementById("criteriaMinRating1").checked) 
			parameters += "&minRating=1";
		else if (document.getElementById("criteriaMinRating2").checked)
			parameters += "&minRating=2";
		else if (document.getElementById("criteriaMinRating3").checked)
			parameters += "&minRating=3";
		else if (document.getElementById("criteriaMinRating4").checked)
			parameters += "&minRating=4";
		else if (document.getElementById("criteriaMinRating5").checked)
			parameters += "&minRating=5";
		else 
			parameters += "&minRating=0";
		
		if (document.getElementById("criteriaAvailableYes").checked)
			parameters += "&showAvailableOnly=true";
		else parameters += "&showAvailableOnly=false";
		
		if (document.getElementById("criteriaAddress").value == "")
			parameters += "&address=" + "";
		else parameters += "&address=" + document.getElementById("criteriaAddress").value;
		
		parameters += "&searchByName=" + document.getElementById("criteriaSearchByName").value;
		
		var xhttp = new XMLHttpRequest();
		xhttp.open("POST", "Search", true);
		xhttp.onreadystatechange = function () {
			document.getElementById("searchLoading").style.visibility = "hidden";
			
			// Put the response in an array format
			let responseText = this.responseText;
			let responseArray = []
			let currentStr = ""
			for(let i = 0; i < responseText.length; i++) {
				if (responseText[i] != "\n") {
					currentStr += responseText[i];
				}
				else {
					responseArray.push(currentStr);
					currentStr = "";
				}
			}
			
			// Clear the search results table
			let table = document.getElementById("searchResultsTable").getElementsByTagName('tbody')[0];
			for(let i = prevNumSearchResults; i > 0; i--) {
				try {
					table.deleteRow(-1);
				}
				catch(error) {
					continue;
				}
			}
			
			if (responseArray.length == 0) {
				document.getElementById("searchYieldedNoResults").style.visibility = "visible";
				document.getElementById("searchResultsTable").style.visibility = "hidden";
				return;
			}
			else {
				document.getElementById("searchYieldedNoResults").style.visibility = "hidden";
				document.getElementById("searchResultsTable").style.visibility = "visible";
			}
			
			// Put the retrieved search results into the table
			let numVariablesPerResponse = 4;
			for(let i = 0; i < responseArray.length; i+=4) {
				let row = table.insertRow();
				row.style.height="60px";
				for(let j = 0; j < numVariablesPerResponse; j++) {
					if (j % numVariablesPerResponse == 0) continue;
					let currentCell = row.insertCell();
					if (j % numVariablesPerResponse == 1) currentCell.style.width = "200px";
					else if (j % numVariablesPerResponse == 2) currentCell.style.width ="450px";
					/* else if (j % numVariablesPerResponse == 3) {
						currentCell.innerHTML = "img src= " + "width=\"100\" height=\"100\"";
					} */
					else currentCell.style.width ="250px";
					if (j % numVariablesPerResponse != 4) currentCell.innerHTML = responseArray[i + j];
					currentCell.style.borderTop = "1px solid orange";
					currentCell.style.textAlign = "center";
					
					if ("<%=guest%>" != "true") {
						currentCell.addEventListener('click', function() {
							loadSearchResult(responseArray[i]);
						});
					}
				}
				
			}
			
			prevNumSearchResults = responseArray.length / 3;
		}
		xhttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
		xhttp.send(parameters);
		document.getElementById("searchLoading").style.visibility = "visible";
		document.getElementById("searchResultsTable").style.visibility = "hidden";
		document.getElementById("resultsTableSection").style.visibility = "visible";
	}
	
	function loadSearchResult(shelterId) {
		console.log(shelterId);
		document.location.href = "http://localhost:8080/ShelterSeeker/searchResult?shelterId=" + 
				shelterId;
	}
	
	function showNumKidsSection() {
		document.getElementById("numKidsSection").style.visibility = "visible";
	}
	
	function hideNumKidsSection() {
		document.getElementById("numKidsSection").style.visibility = "hidden";
	}
	
	function showNumPetsSection() {
		document.getElementById("numPetsSection").style.visibility = "visible";
	}
	
	function hideNumPetsSection() {
		document.getElementById("numPetsSection").style.visibility = "hidden";
	}
	</script>
</body>
</html>
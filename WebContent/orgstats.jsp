<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page    
    import="retrieval.DBHelper, retrieval.Message, retrieval.Mail,  javax.servlet.http.HttpServlet, 
    javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse, 
    retrieval.CompareMessageByReadAndTime,java.util.*,retrieval.Shelter"%>
<!DOCTYPE html>
<html>
 <head>
    <title>Shelter Seeker User Home Page</title>
   <script src="https://apis.google.com/js/platform.js" async defer></script>
	<script src="//ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js"></script>
	<meta charset="utf-8">
  	<meta name="viewport" content="width=device-width, initial-scale=1">
  	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
  	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
  	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
  	<link href="https://fonts.googleapis.com/css?family=Nunito+Sans" rel="stylesheet">
  	
  	<script src="http://d3js.org/d3.v3.min.js" charset="utf-8"></script>
    <script type="text/javascript" src="http://cdnjs.cloudflare.com/ajax/libs/lodash.js/3.1.0/lodash.min.js"></script>
    <script type="text/javascript" src="http://cdnjs.cloudflare.com/ajax/libs/moment.js/2.9.0/moment.min.js"></script>
    <script type="text/javascript" src="http://cdnjs.cloudflare.com/ajax/libs/highlight.js/8.4/highlight.min.js"></script>
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
    <script src="https://cdn.plot.ly/plotly-latest.min.js"></script>
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
		</style>
    
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
	      <li><a href="orgstats.jsp">My Stats</a></li>
	      <li><a href="usermessages.jsp">Messages</a></li>
	      <li class="active"><a href="orgsettings.jsp">Settings</a></li>
	    </ul>
	     <ul class="nav navbar-nav navbar-right">
        	<li><a class="navbar-brand" href="signin.jsp">Sign Out</a></li>
      	</ul>
	  </div>
	</nav>
	<div class="container-fluid"> 
        <div> Rating: </div>
        <div id='click-series'></div>
        <div id='interest-map'></div>
        <div id='pie-charts' style="display:flex">
        <div id='pie-chart-1'></div>
        <div id='pie-chart-2'></div>
        <div id='pie-chart-3'></div>
        <div id='pie-chart-4'></div>
        </div>
    </div>
    <footer class="container-fluid text-center">
	  <p> © 2018 Safe Hands </p>
	</footer>
  <script type="text/javascript">
        <% DBHelper dbh = (DBHelper) request.getSession().getAttribute("DBHelper");
			Shelter sh = dbh.shInfo;
		%>
		
		fetch("ClickRetriever?q=clicks&here=<%= sh.id %>", {"method":"GET"}).then(resp => resp.json()).then(plotCallback);
		
        // [{date:new Date('2013-01-01'),n:120,n3:200},...]
        /* Generate random times between two dates */
        function unpack(rows, key) {
  			return rows.map(function(row) { return row[key]; });
		}
        
        function plotCallback(rows){
            var trace1 = {
              type: "scatter",
              mode: "lines",
              name: 'Clicks',
              x: unpack(rows, 'time'),
              y: unpack(rows, 'Clicks'),
              line: {color: '#17BECF'}
            }
			var data = [trace1];
            var layout = {
              title: 'Clicks per Day',
            };
			Plotly.newPlot('click-series', data, layout);
		}
    
        </script>
         <script type="text/javascript">
        Plotly.d3.csv('https://raw.githubusercontent.com/plotly/datasets/master/2014_us_cities.csv', function(err, rows){
        
            var cityName = unpack(rows, 'name'),
                cityPop = unpack(rows, 'pop'),
                cityLat = unpack(rows, 'lat'),
                cityLon = unpack(rows, 'lon'),
                color = [,"rgb(255,65,54)","rgb(133,20,75)","rgb(255,133,27)","lightgrey"],
                citySize = [],
                hoverText = [],
                scale = 50000;
        
            for ( var i = 0 ; i < cityPop.length; i++) {
                var currentSize = cityPop[i] / scale;
                var currentText = cityName[i] + " pop: " + cityPop[i];
                citySize.push(currentSize);
                hoverText.push(currentText);
            }
        
            var data = [{
                type: 'scattergeo',
                locationmode: 'USA-states',
                lat: cityLat,
                lon: cityLon,
                hoverinfo: 'text',
                text: hoverText,
                marker: {
                    size: citySize,
                    line: {
                        color: 'black',
                        width: 2
                    },
                }
            }];
        
            var layout = {
                title: 'Regional Interest',
                showlegend: false,
                geo: {
                    scope: 'usa',
                    projection: {
                        type: 'albers usa'
                    },
                    showland: true,
                    landcolor: 'rgb(217, 217, 217)',
                    subunitwidth: 1,
                    countrywidth: 1,
                    subunitcolor: 'rgb(255,255,255)',
                    countrycolor: 'rgb(255,255,255)'
                },
            };
        
            Plotly.plot('interest-map', data, layout, {showLink: false});
        
        });
        </script>
 <script>
</script>
     <script>
        function signOut() {
            document.location.href = "http://localhost:8080/CSCI201-Project/signin.jsp";
        }
    </script>
    
    <script>
        var ratings = [];
        
		function plotRating(){
			fetch("ClickRetriever?q=currRating&here=<%= sh.id %>", {"method":"GET"}).then(resp=>resp.json()).then(json => ratings.concat(json)).then(plotRatingCallback);
		}
		
		window.setInterval(plotRating, 5000);
		
		
	    // [{date:new Date('2013-01-01'),n:120,n3:200},...]
	    /* Generate random times between two dates */
	    function unpack(rows, key) {
				return rows.map(function(row) { return row[key];});
		}
	    
	    function plotRatingCallback(rows){
	    	console.log(rows);
	        var trace1 = {
	          type: "scatter",
	          mode: "lines",
	          name: 'Rating',
	          x: unpack(rows, 'time'),
	          y: unpack(rows, 'rating'),
	          line: {color: '#17BECF'}
	        }
	
			var data = [trace1];
	
	        var layout = {
	          title: 'Ratings over Time',
	        };
	
			Plotly.newPlot('rating-over-time', data, layout);
		}
	
	        
        </script>
</body>
 </html>
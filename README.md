Shelter Seeker
Team Members: Kartik Mahajan (kmahajan@usc.edu), Tyler Luk (tylerluk@usc.edu), Eric Ye (eye@usc.edu), Pavle Medvidov (medvidov@usc.edu), Stacy Tran (stacytra@usc.edu), Will Borie (borie@usc.edu)

Current Bugs: In this version of the code, all of the features that we set out to implement
in our documentation were achieved at a level of basic functionality. There is still some
styling that needs to be applied and there are a few minor bugs with the database front-end
connection.

Run Instructions:

Step 1: Extract the zip file into an Eclipse Workspace. 
The folder should extract as a dynamic web project and the following folders should be visible:
Src
Build
Extra
Jars
WebContent
Step 2: Set up the build path
Add the following to the build path (all located in Jars directory):
Geoip2-1.12.0.jar
Mysql-connector-java-5.4.16.jar
Ensure the following libraries are used (should already be there):
JRE System Library
Web App Libraries
Apache Tomcat v9.0
Step 3: Set up the SQL database
Open the database.sql file and copy the contents
By your method of choice (mySQL Workbench most common) paste the code into a query. Run the query to create the safeHands schema.
Ensure at database at port localhost:3306. Username=root. Password=root
Step 4: Test SQL connection and basic functionality
Go to src->back_end test
Run the sql statements and ensure they finish without error
Run DBTester to ensure Database functionality works. Any errors can be pinpointed
Step 5: Set up back-end server
Run the function messageServer.java under src.
Allow the thread to run in the background.
Step 6: Deploy the app!
Go to WebContent->signin.jsp
Run this using Tomcat.
If all other tests were followed, this should run without error.

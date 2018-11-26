USE  shelterSeeker;

INSERT INTO Users (
	username,
    email,
    pass,
    isShelter) 
    VALUES ('shelter1', 'will.borie@gmail.com','password1', 1);
    
INSERT INTO shelterInfo (id,zipcode,kids,pets,phoneNumber,biography,
    numRatingGiven,nearGrocery,nearPharmacy,nearLaundromat,
    currentRating, pageVisits,numStays,numPendingRequests,avgStayDuration,
    availability) 
    values(1,90089,2,3,1234567890,'This is my first shelter for testing',
    0,1,0,0,0,0,0,0,0,10);
    
INSERT INTO Users (username,email,pass,isShelter) VALUES
('Survivor1','borie@usc.edu','password1',0);

INSERT INTO userInfo(id,zipcode,kids,pets,phoneNumber) VALUES
(2,94301,1,2,0987654321);

INSERT INTO Users (
	username,
    email,
    pass,
    isShelter) 
    VALUES ('shelter2', 'will.borie1@gmail.com','password1', 1);
    
INSERT INTO shelterInfo (id,zipcode,kids,pets,phoneNumber,biography,
    numRatingGiven,nearGrocery,nearPharmacy,nearLaundromat,
    currentRating, pageVisits,numStays,numPendingRequests,avgStayDuration,
    availability) 
    values(3,20027,2,3,1234567890,'This is my second shelter for testing',
    0,1,0,0,3.74,0,0,0,0,10);
    
INSERT INTO Users (
	username,
    email,
    pass,
    isShelter) 
    VALUES ('shelter3', 'will.borie2@gmail.com','password1', 1);
    
INSERT INTO shelterInfo (id,zipcode,kids,pets,phoneNumber,biography,
    numRatingGiven,nearGrocery,nearPharmacy,nearLaundromat,
    currentRating, pageVisits,numStays,numPendingRequests,avgStayDuration,
    availability) 
    values(4,20027,2,3,1234567890,'This is my third shelter for testing',
    0,1,0,0,1.5,0,0,0,0,10);


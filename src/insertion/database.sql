DROP DATABASE IF EXISTS safeHands;
CREATE DATABASE safeHands;
USE safeHands;
CREATE TABLE users (
	userID INT(11) PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(255) NOT NULL UNIQUE,
    email VARCHAR(255) UNIQUE NOT NULL,
    pass VARCHAR(255) NOT NULL,
    isShelter BIT NOT NULL DEFAULT 0
    );
CREATE TABLE userInfo (
	id INT(11) PRIMARY KEY AUTO_INCREMENT,		
    username VARCHAR (255) NOT NULL UNIQUE,
    zipcode INT(5),
    address VARCHAR (255),
    kids INT(3),
    pets INT(3),
    phoneNumber VARCHAR(255),
	FOREIGN KEY (id) REFERENCES users(userID),
    foreign key (username) REFERENCES users(username)
);

CREATE TABLE messages (
	messageID INT(11) PRIMARY KEY AUTO_INCREMENT,
    senderName VARCHAR (255) NOT NULL,
    recipientName VARCHAR (255) NOT NULL,
    timeSent INT (11) NOT NULL,
    mSubject VARCHAR (255) NOT NULL,
    mContent TEXT NOT NULL,
	mRead BIT NOT NULL DEFAULT 0,
    FOREIGN KEY (senderName) REFERENCES users(username),
    FOREIGN KEY (recipientName) REFERENCES users(username)
    
);

CREATE TABLE shelterInfo (
	id INT (11) PRIMARY KEY auto_increment,
    own VARCHAR (255) UNIQUE NOT NULL,
    zipcode INT(5),
    address VARCHAR (255) NOT NULL,
    kids INT(3),
    pets INT(3),
    phoneNumber INT(15) NOT NULL,
    biography TEXT,
    numRatingGiven INT(11),
    nearGrocery BIT NOT NULL DEFAULT 0,	
    nearPharmacy BIT NOT NULL DEFAULT 0,
    nearLaundromat BIT NOT NULL DEFAULT 0,
    currentRating DOUBLE (3,2) DEFAULT 5, 
    pageVisits INT (11) NOT NULL DEFAULT 0,
    numStays INT (11) NOT NULL DEFAULT 0,
    numPendingRequests INT (11) NOT NULL DEFAULT 0,
    avgStayDuration DOUBLE (8,2) NOT NULL DEFAULT 0,
    availability INT(11),
    FOREIGN KEY (id) REFERENCES users(userId),
    FOREIGN KEY (own) REFERENCES users(username)
);

CREATE TABLE images (
	id INT (11) PRIMARY KEY auto_increment,
    username VARCHAR (255),
    image LONGBLOB,    
    FOREIGN KEY (username) REFERENCES users(username)
);

CREATE TABLE clicks (
	clickID int PRIMARY KEY auto_increment,
	userID int not null,
	shelterID not null,
	clicked date,
	FOREIGN KEY (userID) REFERENCES users(userId),
	FOREIGN KEY (shelterID) REFERENCES shelterInfo(id)
);
/*********************************************************
*	Original Author:    Emmanuel Galvan                
*	Date Created:       02/04/2022                    
*	Version:            0.0                            
*	Date Last Modified: 02/04/2022                    
*	Modified by:        Emmanuel Galvan                
*	
*	Modification log:  
*	
*	 Version 0.0 - 10/08/2021 -- ADDED database, added user and database user, also created all tables from PROJECT1
*
*
**********************************************************/
use master;
go
DROP DATABASE IF EXISTS disk_inventoryeg;
go
CREATE DATABASE disk_inventoryeg;
go
IF SUSER_ID('diskUsereg') IS NULL
	CREATE LOGIN diskUsereg
	WITH PASSWORD = 'Pa$$w0rd', 
	DEFAULT_DATABASE = disk_inventoryeg;
use disk_inventoryeg;
go
CREATE USER diskUsereg;
ALTER ROLE db_datareader
	ADD MEMBER diskUsereg;
go

-- CREATE LOOKUP TABLES
CREATE TABLE disk_type (
	disk_type_id		INT NOT NULL IDENTITY PRIMARY KEY,
	description			VARCHAR(20) NOT NULL
); -- CD< DVD, Vinyl, 8track, cassette
CREATE TABLE genre (
	genre_id			INT NOT NULL IDENTITY PRIMARY KEY,
	description			VARCHAR(20) NOT NULL
); -- POP< HIP-HOP, Country
CREATE TABLE status (
	status_id			INT NOT NULL IDENTITY PRIMARY KEY,
	description			VARCHAR(20) NOT NULL
); -- Available, Onload
CREATE TABLE borrower (
	borrower_id			INT NOT NULL IDENTITY PRIMARY KEY,
	fname				NVARCHAR(60) NOT NULL,
	lname				NVARCHAR(60) NOT NULL,
	phone_number		VARCHAR(15) NOT NULL
);
CREATE TABLE disk (
	disk_id				INT NOT NULL IDENTITY PRIMARY KEY,
	disk_name			NVARCHAR(60) NOT NULL,
	release_date		DATE NOT NULL,
	status_id			INT NOT NULL REFERENCES status(status_id),
	disk_type_id		INT NOT NULL REFERENCES disk_type(disk_type_id),
	genre_id			INT NOT NULL REFERENCES genre(genre_id)
);
CREATE TABLE disk_has_borrower (
	disk_has_borrower_id	INT NOT NULL IDENTITY PRIMARY KEY,
	disk_id					INT NOT NULL REFERENCES disk(disk_id),
	borrower_id				INT NOT NULL REFERENCES borrower(borrower_id),
	borrowed_date			DATETIME2 NOT NULL,
	returned_date			DATETIME2 NOT NULL,
);
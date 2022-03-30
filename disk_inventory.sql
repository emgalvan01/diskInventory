/*********************************************************
*	Original Author:    Emmanuel Galvan                
*	Date Created:       02/25/2022                    
*	Version:            4.0                            
*	Date Last Modified: 03/30/2022                    
*	Modified by:        Emmanuel Galvan                
*	
*	Modification log:  
*	
*	 Version 0.0 - 02/04/2021 -- ADDED database, added user and database user, also created all tables from PROJECT1
*	 Version 1.0 - 03/11/2022 -- ADDED Insert statements
*	 Version 2.0 - 03/18/2022 -- ADDED SELECT statemtents to display wanted information. Also created a VIEW
*	 Version 3.0 - 03/28/2022 -- ADDED stored procs to ins in try/catch for error handling. Grant exe to user DiskUserEG (disk_has_borrower)
*	 Version 4.0 - 03/30/2022 -- ADDED stored procs, ins, update, delete for disk and borrower
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
	returned_date			DATETIME2 NULL,
);

INSERT INTO genre
	(description)
VALUES
	('POP'),
	('HIP-HOP'),
	('Country'),
	('R&B'),
	('Soul');

INSERT INTO status
	(description)
VALUES
	('Available'),
	('On loan'),
	('Damageed'),
	('Missing'),
	('Unavailable');


INSERT INTO disk_type
	(description)
VALUES
	('CD'),
	('Vinyl'),
	('DVD'),
	('8Track'),
	('Cassette');

INSERT INTO borrower
	(fname, lname, phone_number)
VALUES
	('Rocket', 'Raccoon', '111-111-1111'),
	('Scott', 'Lang', '222-222-2222'),
	('Bill', 'Ray', '333-333-3333'),
	('Hank', 'Pym', '444-444-4444'),
	('Cassy', 'Lang', '555-555-5555'),
	('Peter', 'Parker', '666-666-6666'),
	('Natasha', 'Romanof', '777-777-7777'),
	('Tony', 'Stark', '888-888-8888'),
	('Peter', 'Quil', '999-999-9999'),
	('Steve', 'Rogers', '111-222-0000'),
	('Bucky', 'Barns', '111-333-0000'),
	('Nick', 'Fury', '111-444-0000'),
	('May', 'Parker', '111-555-0000'),
	('Happy', 'Hogan', '111-666-0000'),
	('James', 'Rhodes', '111-777-0000'),
	('Wanda', 'Maximoff', '111-888-0000'),
	('Clint', 'Barton', '111-999-0000'),
	('Kate', 'Bishop', '222-000-0000'),
	('Yelena', 'Bolova', '222-111-0000'),
	('Bruce', 'Banner', '222-222-0000'),
	('Phil', 'Coulson', '222-333-0000');

DELETE borrower
WHERE borrower_id = 21;

INSERT INTO disk
	(disk_name, release_date, status_id, disk_type_id, genre_id)
VALUES
	('Scorpion', '06/29/2018', 1, 1, 2)
	,('The Melodic Blue', '09/27/2021', 2, 1, 2)
	,('Dharma', '01/14/2022', 2, 2, 1)
	,('Dawn FM', '01/07/2022', 1, 2, 4)
	,('VICE VERSA', '06/25/2021', 1, 4, 2)
	,('Swimming', '08/03/2018', 4, 3, 4)
	,('Starboy', '11/25/2016', 5, 3, 4)
	,('Future Nostalgia', '03/25/2021', 1, 2, 1)
	,('Thank Me Later', '05/05/2010', 5, 1, 2)
	,('Sour', '05/21/2021', 3, 2, 1)
	,('Views', '04/05/2016', 3, 1, 2)
	,('An Evening With Silk Sonic', '03/05/2021', 2, 5, 5)
	,('Certified Lover Boy', '09/03/2021', 2, 1, 2)
	,('Take Care', '11/15/2011', 1, 1, 2)
	,('Human', '06/27/2021', 1, 4, 1)
	,('2014 Forest Hills Drive', '12/09/2014', 3, 5, 4)
	,('Center Point Road', '03/03/2019', 4, 5, 3)
	,('Dangerous: The Double Album', '12/31/2019', 4, 5, 3)
	,('American Teen', '02/02/2017', 5, 2, 4)
	,('Justice', '03/19/2021', 1, 1, 1);

UPDATE disk
SET disk_name = 'DIVIDE', release_date = '03/03/2017'
WHERE disk_id = 15;

INSERT INTO disk_has_borrower
	(borrower_id, disk_id, borrowed_date, returned_date)
VALUES
	(1, 1, '01/21/2021', '01/30/2021')
	,(3, 4, '01/20/2022', '01/24/2022')
	,(3, 5, '02/15/2022', '02/21/2022')
	,(2, 8, '03/01/2022', '03/07/2022')
	,(5, 9, '12/3/2022', NULL)
	,(5, 15, '02/25/2022', '03/04/2022')
	,(5, 15, '03/04/2022', '03/11/2022')
	,(6, 20, '01/18/2022', '01/24/2022')
	,(11, 14, '01/30/2022', '02/04/2022')
	,(5, 7, '02/28/2022', NULL)
	,(15, 12, '03/05/2022', NULL)
	,(13, 16, '02/04/2022', '01/05/2022')
	,(14, 18, '01/01/2022',  NULL) --
	,(13, 16, '01/02/2022', '01/03/2022')
	,(6, 4, '02/20/2022', '02/28/2022')
	,(17, 1, '03/02/2022', '03/09/2022')
	,(8, 19, '03/10/2022', NULL) 
	,(10, 2, '03/04/2022', NULL)
	,(11, 3, '03/08/2022', NULL)
	,(10, 13, '03/01/2022', NULL);

SELECT borrower_id as Borrower_id, disk_id as Disk_id, CAST(borrowed_date as date) as Borrowed_date, returned_date as Return_date
FROM disk_has_borrower
WHERE returned_date IS NULL;

USE disk_inventoryeg;
GO

SELECT 'Disk Name'=disk_name, 'Release Date'=convert(varchar, release_date, 101), 'Type'=disk_type.description, 'Genre'=genre.description, 'Status'=status.description
FROM disk
JOIN disk_type
	ON disk.disk_type_id = disk_type.disk_type_id
JOIN genre
	ON disk.genre_id = genre.genre_id
JOIN status
	ON disk.status_id = status.status_id
ORDER BY disk_name;

SELECT 'Last'=lname, 'First'=fname, 'Disk Name'=disk_name, 'Borrowed Date'=convert(varchar, borrowed_date, 23), 'Return Date'=convert(varchar, returned_date, 23)
FROM disk_has_borrower
JOIN borrower
	ON disk_has_borrower.borrower_id = borrower.borrower_id
JOIN disk
	ON disk_has_borrower.disk_id = disk.disk_id
ORDER BY lname;

SELECT 'Disk Name'=disk_name, 'Times Borrowed'=count(*)
FROM disk_has_borrower
JOIN disk
	ON disk_has_borrower.disk_id = disk.disk_id
GROUP BY disk_name
HAVING COUNT(*) > 1
ORDER BY disk_name;

SELECT 'Disk Name'=disk_name, 'Borrowed Date'=	convert(varchar, borrowed_date, 23), 'Returned Date'=returned_date, 'Last Name'=lname, 'First Name'=fname
FROM disk
JOIN disk_has_borrower
	ON disk.disk_id = disk_has_borrower.disk_id
JOIN borrower
	ON borrower.borrower_id = disk_has_borrower.borrower_id
WHERE returned_date IS NULL
ORDER BY disk_name;

USE disk_inventoryeg;
GO

CREATE VIEW View_Borrower_No_Loans
AS
	SELECT borrower_id, lname, fname
	FROM borrower
	WHERE borrower_id NOT IN
		(SELECT DISTINCT borrower_id FROM disk_has_borrower);
GO
SELECT 'Last Name'=lname, 'First Name'=fname 
FROM View_Borrower_No_Loans;

SELECT 'Last Name'=lname, 'First Name'=fname, 'Disks Borrowed'=COUNT(disk_id)
FROM disk_has_borrower
JOIN borrower
	ON borrower.borrower_id = disk_has_borrower.borrower_id
GROUP BY lname, fname
HAVING COUNT(*) > 1
ORDER BY lname, fname;

-- Push to github
USE disk_inventoryeg;
DROP PROC IF EXISTS sp_ins_disk_has_borrower;
go
CREATE PROC sp_ins_disk_has_borrower
	@borrower_id int, @disk_id int, @borrowed_date datetime2, @returned_date datetime2 = NULL
AS
BEGIN TRY
	INSERT INTO disk_has_borrower
		(borrower_id, disk_id, borrowed_date, returned_date)
	VALUES
		(@borrower_id, @disk_id, @borrowed_date, @returned_date);
END TRY
BEGIN CATCH
	PRINT 'An error occured,';
	PRINT 'Message: ' + CONVERT(VARCHAR(200), ERROR_MESSAGE());
END CATCH
go

GRANT EXEC ON sp_ins_disk_has_borrower TO diskUsereg;
go
sp_ins_disk_has_borrower 1, 1, '03/27/2022', '03/28/2022'
go
sp_ins_disk_has_borrower 4, 5, '03/27/2022'
go
sp_ins_disk_has_borrower 44, 5, '03/27/2022'
go

DROP PROC IF EXISTS sp_upd_disk_has_borrower;
go
CREATE PROC sp_upd_disk_has_borrower
	@disk_has_borrower_id int, @borrower_id int, @disk_id int, @borrowed_date datetime2, @returned_date datetime2 = NULL
AS
BEGIN TRY
	UPDATE disk_has_borrower
	SET borrower_id = @borrower_id,
		disk_id = @disk_id,
		borrowed_date = @borrowed_date,
		returned_date = @returned_date
	WHERE disk_has_borrower_id = @disk_has_borrower_id;
END TRY
BEGIN CATCH
	PRINT 'An error occured,';
	PRINT 'Message: ' + CONVERT(VARCHAR(200), ERROR_MESSAGE());
END CATCH
go
GRANT EXEC ON sp_upd_disk_has_borrower TO diskUsereg;
go
declare @today datetime2 = getdate();
exec sp_upd_disk_has_borrower 11, 2, 3, '03/03/2022', @today;
go
sp_upd_disk_has_borrower 11, 2, 3, '03/19/2022';
go

DROP PROC IF EXISTS sp_ins_disk;
GO
CREATE PROC sp_ins_disk
	@disk_name nvarchar(60), @release_date date, @status_id int, @disk_type_id int, @genre_id int
AS
	BEGIN TRY
		INSERT disk
			(disk_name, release_date, status_id, disk_type_id, genre_id)
		VALUES
			(@disk_name, @release_date, @status_id, @disk_type_id, @genre_id);
	END TRY
	BEGIN CATCH
		PRINT 'An error occured,';
		PRINT 'Message: ' + CONVERT(VARCHAR(200), ERROR_MESSAGE());
	END CATCH
GO
-- Add grant permissions
GRANT EXECUTE ON sp_ins_disk TO diskUsereg;
GO
EXEC sp_ins_disk 'LEGENDADDY', '03/25/2022', 1, 1, 2
GO -- No error
EXEC sp_ins_disk 'LEGENDADDY', '03/25/2022', 1, 1, NULL
GO -- Controlled Error

DROP PROC IF EXISTS sp_upd_disk;
GO
CREATE PROC sp_upd_disk
	@disk_id int, @disk_name nvarchar(60), @release_date date, @status_id int, @disk_type_id int, @genre_id int
AS
	BEGIN TRY
		UPDATE disk
		SET disk_name = @disk_name, 
			release_date = @release_date,
			status_id = @status_id,
			disk_type_id = @disk_type_id,
			genre_id = @genre_id 
		WHERE disk_id = @disk_id;
	END TRY
	BEGIN CATCH
		PRINT 'An error occured,';
		PRINT 'Message: ' + CONVERT(VARCHAR(200), ERROR_MESSAGE());
	END CATCH
GO
-- Add grant permissions
GRANT EXECUTE ON sp_upd_disk TO diskUsereg;
GO
EXEC sp_upd_disk 1, 'Scorpion Deluxe', '06/29/2018', 1, 1, 2
GO -- No Error
EXEC sp_upd_disk 1, 'Scorpion Deluxe', '06/29/2018', NULL, 1, 2
GO -- Controlled error

DROP PROC IF EXISTS sp_del_disk;
GO
CREATE PROC sp_del_disk
	@disk_id int
AS
	BEGIN TRY
		DELETE FROM [dbo].[disk]
			  WHERE disk_id = @disk_id;
	END TRY
	BEGIN CATCH
		PRINT 'An error occured,';
		PRINT 'Message: ' + CONVERT(VARCHAR(200), ERROR_MESSAGE());
	END CATCH
GO

GRANT EXECUTE ON sp_del_disk TO diskUsereg;
GO
EXEC sp_del_disk 20; -- No error
GO
EXEC sp_del_disk 3; -- Controlled Error
GO

DROP PROC IF EXISTS sp_ins_borrower;
GO
CREATE PROC sp_ins_borrower
	@fname NVARCHAR(60), @lname NVARCHAR(60), @phone_number VARCHAR(15)
AS
	BEGIN TRY
		INSERT INTO borrower
			(fname, lname, phone_number)
		VALUES
			(@fname, @lname, @phone_number)
	END TRY
	BEGIN CATCH
		PRINT 'An error occured,';
		PRINT 'Message: ' + CONVERT(VARCHAR(200), ERROR_MESSAGE());
	END CATCH
GO

GRANT EXECUTE ON sp_ins_disk TO diskUsereg;
GO
EXEC sp_ins_borrower'Star', 'FOX', '919-919-999'
GO -- No error
EXEC sp_ins_borrower'Star', NULL, '919-919-999'
GO -- Controlled Error

DROP PROC IF EXISTS sp_upd_borrower;
GO
CREATE PROC sp_upd_borrower
	@borrower_id int, @fname NVARCHAR(60), @lname NVARCHAR(60), @phone_number VARCHAR(15)
AS
	BEGIN TRY
		UPDATE borrower
		SET fname = @fname, 
			lname = @lname,
			phone_number = @phone_number
		WHERE borrower_id = @borrower_id;
	END TRY
	BEGIN CATCH
		PRINT 'An error occured,';
		PRINT 'Message: ' + CONVERT(VARCHAR(200), ERROR_MESSAGE());
	END CATCH
GO

GRANT EXECUTE ON sp_ins_disk TO diskUsereg;
GO
EXEC sp_upd_borrower 22, 'Star', 'Fox', '919-919-999'
GO -- No error
EXEC sp_upd_borrower 22, 'Star', NULL, '919-919-999'
GO -- Controlled Error

DROP PROC IF EXISTS sp_del_borrower;
GO
CREATE PROC sp_del_borrower
	@borrower_id int
AS
	BEGIN TRY
		DELETE FROM [dbo].[borrower]
		WHERE borrower_id = borrower_id;
	END TRY
	BEGIN CATCH
		PRINT 'An error occured,';
		PRINT 'Message: ' + CONVERT(VARCHAR(200), ERROR_MESSAGE());
	END CATCH
GO

GRANT EXECUTE ON sp_del_borrower TO diskUsereg;
GO
EXEC sp_del_borrower 20; -- No error
GO
EXEC sp_del_borrower 3; -- Controlled Error
GO

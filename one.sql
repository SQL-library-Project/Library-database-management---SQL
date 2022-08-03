create database Team4FinalProject



Use Team4FinalProject;
GO

--------------------- Creating Author Table -------------------------------------
CREATE TABLE AUTHOR (
  authorId INT NOT NULL PRIMARY KEY , 
  author_firstName  varchar(40) NOT NULL,
  author_lastName varchar(40)  NOT NULL
)
Go

--------------------- Creating address Table ------------------------------------------
Create Table address(
addressId int NOT NULL PRIMARY KEY,
postalCode int Not null,
street varchar(40) not null,
city varchar(40) not null,
state varchar(40) not null,
country varchar(40) not null,
);
GO
--------------------- Creating Publisher Table ------------------------------------------
Create Table publisher(
publisherId int NOT NULL PRIMARY KEY,
PublisherName varchar(40) NOT NULL,

addressId int references dbo.address(addressId)
)
GO
--------------------- Creating Book Table ---------------------------------------------
Create Table book(
bookId int NOT NULL PRIMARY KEY,
title  varchar(40) NOT NULL,
language varchar(40) NOT NULL,
categoryName varchar(40) NOT NULL,
publisherId int references dbo.publisher(publisherId)
)
GO
--------------------- Creating Book Author Table -------------------------------------
CREATE TABLE bookAuthor(
bookId int references dbo.book(bookId) ,
authorId int references dbo.author(authorId),
primary key (bookId, authorId)
)
GO
------------------------------  Creating a Person table ---------------------------------------------
create table person(
	personId int not null primary key identity,
	firstName varchar(20),
	lastName varchar(20),
	email varchar(40) not null,
	phoneNumber varchar(20) unique,	
	addressId int null references address(addressId),
	PersonType varchar(20) not null
		constraint chk_PersonType check(PersonType in ('Student', 'Faculty', 'Library Staff'))
)
go

------------------------------  Creating a book borrow table ---------------------------------------------
go
Create Table BorrowBook(
borrowId int NOT NULL PRIMARY KEY,

bookId int references dbo.book(bookId),
personId int references dbo.person(personId),

checkInTime  datetime NULL,
CheckOutTime datetime NULL,
)
GO
--------------------------- creating StudySpace_Category table --------------------------------------------------- 
create table StudySpace_Category (
	StudySpace_CategoryID int not null primary key identity,
	categoryCapacity int,
	categoryName varchar(20)
		constraint chk_spaceCategoryName check(categoryName in ('Group', 'Graduate', 'Colab', 'Video Conferencing'))
)
go
--------------------------- creating StudySpace table --------------------------------------------------------------- 
create table StudySpace (
	SpaceID int not null primary key identity,
	SpaceName varchar(10),
	categoryId int not null references StudySpace_Category(StudySpace_categoryID)
)
go
--------------------------- creating spacebooking table --------------------------------------------------------------- 
create table SpaceBooking (
	bookingId int not null primary key,
	duration int
	 constraint chk_duration check(duration between 1 and 4),
	startTime datetime default current_timestamp,	
	endTime as dateadd(hour, duration, startTime),
	PersonId int not null references Person(personId),
	spaceId int not null references StudySpace(spaceId),
)
go

--------------------------- creating Membership table --------------------------------------------------------------- 
CREATE TABLE MembershipPlans(
MembershipPlanID INT PRIMARY KEY,
MembershipCategory VARCHAR(20),
MembershipPrice MONEY
)
go
--------------------------- creating Membership Enrollment table --------------------------------------------------------------- 
create table membershipEnrollment (
	enrollmentId int not null primary key,
	membershipId int not null references membershipPlans(membershipPlanId),
	personId int not null references Person(personId),
	enrollmentDate datetime not null default current_timestamp,
	expiryDate as dateadd(year, 1, enrollmentDate)
)
go
------------------------------------------------- Table level constraints -------------------------------------------------------------------------------
----------------------------- Table level constraint : BorrowBook Table -------------------------
create function validateMember(@personId int)
Returns smallint
AS
Begin
Declare @count smallint = 0
select @count = COUNT(personId) from dbo.membershipEnrollment where personId = @personId  
and  GETDATE() between enrollmentDate and  expiryDate
return @count 
End
go

 ALTER TABLE dbo.BorrowBook ADD CONSTRAINT validating CHECK 
(dbo.validateMember(personId) = 1);
go

---------------------------- Table Level constarint : space booking table ----------------------------------
go
create function checkMembership (@personId int)
returns int
as
begin
	declare @count int = 0
	declare @date datetime = current_timestamp
	select @count  = count(enrollmentId)
	from membershipEnrollment
	where personId = @personId and membershipId = 2 and (@date between enrollmentDate and expiryDate)
	return @count;
end;
go
ALTER TABLE spaceBooking ADD CONSTRAINT chk_PremiumMember CHECK 
(dbo.checkMembership(personId) > 0);
go

------------------------------------------------ Triggers -------------------------------------------------------------------------------------------------
------- Trigger : Borrow book table : user cannot borrow book that has been already borrowed   -------------------------

Create trigger checkforBook
on dbo.BorrowBook
Instead Of insert
AS
begin
declare @count int  = 0
select @count = COUNT(bb.bookId) from inserted i left join dbo.BorrowBook bb on (bb.bookId = i.bookId) and (bb.CheckOutTime < GETDATE())
group by bb.bookId 
if(@count = 0)
begin
insert  dbo.BorrowBook(borrowId,bookId,personId,checkInTime,CheckOutTime)
	select borrowId,bookId,personId,checkInTime,CheckOutTime
	from inserted
return
end
if(@count > 0)
begin
print 'Book is not availble to borrow Now !!!'
return
end
end
go

--------- Trigger :  Space Booking Table : to check if space is available for booking ----------------------------------------------------------------------
go
create trigger tr_checkBookings
on SpaceBooking
instead of insert
as
begin
	declare @spaceId int
	declare @startTime datetime
	declare @endTime datetime
	declare @count int = 0

	select @spaceId = s.spaceId, @startTime = i.startTime, @endTime = i.endTime
	from StudySpace s
	join inserted i
	on i.spaceID = s.SpaceID

	if(@spaceId is null)
	begin
		print 'Invalid Space Id. Statement Terminated'
		return
	end

	select @count = count(bookingId)
	from spaceBooking
	where spaceId = @spaceId and ((startTime <= @startTime and endTime >= @startTime) 
	or (startTime <= @endTime and endTime >= @endTime)
	or (startTime <= @startTime and endTime >= @endTime))

	if(@count > 0)
	begin
		print 'Booking timming overlap. Statement terminated'
		return
	end

	insert into SpaceBooking(personId, spaceId,bookingId, startTime, duration)
	select personId, spaceId, bookingId, startTime, duration
	from inserted
end
go

---------------- Trigger : on Membership Enrollment: Updating membership with no duplicates ----------------------------------

go


create trigger tr_checkEnrollmentAlreadyExists 
on membershipEnrollment
instead of insert
as begin
	declare @enrollmentId int
	declare @newEnrollmentDate datetime = current_timestamp
	declare @membershipId int 

	select @enrollmentId = me.enrollmentId, @membershipId = i.membershipId
	from membershipEnrollment me
	join inserted i
	on i.personId = me.personId

	if(@enrollmentId is null)
	begin
		insert into membershipEnrollment(enrollmentId,membershipId, personId, enrollmentDate)
		select enrollmentId,membershipId, personId, enrollmentDate
		from inserted
	end;

	else
	begin
		update membershipEnrollment set membershipId = @membershipId, enrollmentDate = @newEnrollmentDate
		where enrollmentId = @enrollmentId
	end;
end;
go
----------------------------------------------------------------------- Insert data ------------------------------------------------------------------------------------

--- INSERTING TABLE TO AUTHOR TABLE

Insert dbo.AUTHOR values(1,'Ashley','Poston' );
INSERT DBO.AUTHOR VALUES(2, 'Danielle','Steel');
INSERT DBO.AUTHOR VALUES(3, 'Debbie','Macomber' );
INSERT DBO.AUTHOR VALUES(4, 'ANIKA','SCOTT');
INSERT DBO.AUTHOR VALUES(5, 'JANE','KUO');
INSERT DBO.AUTHOR VALUES(6, 'QuvenzhanE','WALLIS');
INSERT DBO.AUTHOR VALUES(7, 'JACK','CARR');
INSERT DBO.AUTHOR VALUES(8, 'RUTH','DRUART');
INSERT DBO.AUTHOR VALUES(9, 'STEVEN','BRUST');
INSERT DBO.AUTHOR VALUES(10, 'FRAN','WILDE');
INSERT DBO.AUTHOR VALUES(11, 'DANIEL','M.FORD');
INSERT DBO.AUTHOR VALUES(12, 'KATE','ELLIOTT');
iNSERT DBO.AUTHOR VALUES(13, 'CHRIS', 'BRADFORD');
iNSERT DBO.AUTHOR VALUES(14, 'Serena', 'Valentino');
iNSERT DBO.AUTHOR VALUES(15, 'Domee', 'Shi');
iNSERT DBO.AUTHOR VALUES(16, 'Shawn', 'Eagel');
iNSERT DBO.AUTHOR VALUES(17, 'Michael', 'Leviton');
iNSERT DBO.AUTHOR VALUES(18, 'Ali', 'Bahrampour');
iNSERT DBO.AUTHOR VALUES(19, 'Kate', 'Berube');
iNSERT DBO.AUTHOR VALUES(20, 'Mona', 'Lisa');

---- Inserting data to address table ------------

go
--- Penguin random house
Insert dbo.Address values(1,10019, 'Broadway', 'New York', 'NY', 'USA');
--- HarperCollins
Insert dbo.Address values(2,9411, '201 California st', 'San francisco', 'CA', 'USA');
--- Simon & Schuster
Insert dbo.Address values(3,10016, '1230 Avenue of americas', 'New York', 'NY', 'USA');
--- hachette book group
Insert dbo.Address values(4,10104, '1290 Avenue of americas', 'New York', 'NY', 'USA');
---- macmillan
Insert dbo.Address values(5,10108, '175 fifth avenue', 'New York', 'NY', 'USA');
--- scholastic 
Insert dbo.Address values(6,10012, '557 Broadway', 'New York', 'NY', 'USA');
-- Disney books
Insert dbo.Address values(7,10023, '125 WEST END AVENUE', 'New York', 'NY', 'USA');
--- Workman
Insert dbo.Address values(8,10022, '225 Varick Street', 'New York', 'NY', 'USA');
--- Union Square
Insert dbo.Address values(9,10003, '33 East 17th Street', 'New York', 'NY', 'USA');
---  abrams
Insert dbo.Address values(10,10007, '195 Broadway ', 'New York', 'NY', 'USA');
INSERT INTO address (addressId, postalCode,street,city,state,country)
VALUES
  (11,'9778','Ap #312-6617 Lobortis Avenue','Topeka','Connecticut','United States'),
  (12,'57657','Ap #965-8506 Enim Avenue','Lafayette','Vermont','United States'),
  (13,'76422','5249 Parturient St.','Omaha','Michigan','United States'),
  (14,'24482','P.O. Box 491, 3372 Pede, St.','Kaneohe','Missouri','United States'),
  (15,'51886','P.O. Box 585, 5012 Dapibus Street','Denver','Illinois','United States'),
  (16,'757234','736-7206 Suspendisse Road','Lewiston','Alaska','United States'),
  (17,'76212','P.O. Box 250, 9665 Amet St.','Lincoln','Vermont','United States'),
  (18,'32596021','184-1665 Nunc Avenue','Bangor','Idaho','United States'),
  (19,'723343','1234 Parturient St.','Norman','Oklahoma','United States'),
  (20,'8024','Ap #566-5475 Arcu Ave','Fort Wayne','Texas','United States')
Insert dbo.address values(21, 94133, '12354 presidio street', 'san Francisco', 'california', 'USA')
INSERT INTO address (addressId, postalCode,street,city,state,country)
VALUES
 (22,'11631','P.O. Box 929, 671 Viverra. Ave','Chicago','Kentucky','United States'),
  (23,'4365','141-9736 Et Ave','Allentown','Virginia','United States'),
  (24,'891712','Ap #763-1560 Ante. Avenue','Fresno','Maryland','United States'),
  (25,'0906','422-4432 Natoque St.','South Bend','Oregon','United States'),
  (26,'11919','358-9085 Luctus St.','Chattanooga','Kentucky','United States'),
  (27,'284454','Ap #519-6259 Nunc Avenue','Metairie','Kansas','United States'),
  (28,'8273','215-7251 Magna. Road','Rock Springs','Arkansas','United States'),
  (29,'72249','938-1570 Nonummy Av.','Flint','California','United States'),
  (30,'2026','525-8801 Ut, Rd.','Eugene','Nebraska','United States'),
  (31,'52314','Ap #224-3523 Elementum Rd.','Iowa City','Texas','United States'),
   (32,'18723','P.O. Box 822, 6094 Urna, Road','Grand Island','Montana','United States'),
  (33,'46319','9681 Blandit Rd.','Wilmington','Tennessee','United States'),
  (34,'50203','166-387 Amet St.','Gillette','Nebraska','United States'),
  (35,'3635','Ap #290-1426 Sed Av.','Fort Collins','Missouri','United States'),
  (36,'41525','P.O. Box 669, 1750 Consequat Street','Vancouver','Texas','United States');
go

--- inserting the data  to publisher table

Insert dbo.publisher values(1,'Penguin random house',1);
Insert dbo.publisher values(2,'HarperCollins',2);
Insert dbo.publisher values(3,'Simon & Schuster',3);
Insert dbo.publisher values(4,'hachett group', 4);
Insert dbo.publisher values(5,'macmillan', 5);
Insert dbo.publisher values(6,'scholastic', 6);
Insert dbo.publisher values(7,'Disney Books', 7);
Insert dbo.publisher values(8,'Workman', 8);
Insert dbo.publisher values(9,'Union Square',9);
Insert dbo.publisher values(10,'abrams',10);
go

------ Inserting to book table ------------------------
Insert dbo.book values(1, 'the dead romances', 'English', 'fiction', 1 );
Insert dbo.book values(2, 'the dead romances', 'English', 'fiction',1 );

Insert dbo.book values(3, 'the dead romances', 'Spanish', 'fiction', 1 );
Insert dbo.book values(4, 'the dead romances', 'Spanish', 'fiction', 1 );
------------------------------------------------------------------------------------
--- a2
Insert dbo.book values(5, 'Suspects', 'English', 'thriller', 1 );
Insert dbo.book values(6, 'Suspects', 'English', 'thriller', 1 );
Insert dbo.book values(7, 'Suspects', 'English', 'thriller',1 );
Insert dbo.book values(8, 'Suspects', 'English', 'thriller', 1 );

Insert dbo.book values(9, 'Suspects', 'Spanish', 'thriller', 1 );
Insert dbo.book values(10, 'Suspects', 'French', 'thriller', 1 );
Insert dbo.book values(11, 'Suspects', 'French', 'thriller', 1 );
-------------------------------------------------------------------------------------
--- a3
Insert dbo.book values(12, 'The Best Is Yet To Come', 'English', 'Romance', 1 );
Insert dbo.book values(13, 'The Best Is Yet To Come', 'chinese', 'Romance', 1 );
Insert dbo.book values(14, 'The Best Is Yet To Come', 'Spanish', 'Romance',1 );
-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------
---- a4
Insert dbo.book values(15, 'The Soviet Sisters', 'English', 'Fiction', 2 );
Insert dbo.book values(16, 'The Soviet Sisters', 'English', 'Fiction', 2 );
Insert dbo.book values(17, 'The Soviet Sisters', 'Taiwanese', 'Fiction', 2 );

Insert dbo.book values(18, 'The Soviet Sisters', 'English', 'Fiction', 2 );

Insert dbo.book values(19, 'The Soviet Sisters', 'Taiwanese', 'Fiction', 2 );
-----------------------------------------------------------------------------------------
---- a5
Insert dbo.book values(20, 'In the Beautiful Country', 'Taiwanese', 'Kids Stories', 2 );
Insert dbo.book values(21, 'In the Beautiful Country', 'eNGLISH', 'Kids Stories', 2 );
--------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
---- a6
Insert dbo.book values(22, 'Break an Egg', 'Spanish', 'Kids Stories', 3 );
Insert dbo.book values(23, 'Break an Egg', 'Spanish', 'Kids Stories', 3 );

Insert dbo.book values(24, 'Break an Egg', 'English', 'Kids Stories', 3 );
Insert dbo.book values(25, 'Break an Egg', 'English', 'Kids Stories', 3 );
Insert dbo.book values(26, 'Break an Egg', 'English', 'Kids Stories', 3 );
-------------------------------------------------------------------------------------------------
---- A7
Insert dbo.book values(27, 'THE TERMINAL LIST', 'Spanish', 'THRILLER', 3 );
Insert dbo.book values(28, 'THE TERMINAL LIST', 'Spanish', 'THRILLER', 3 );

Insert dbo.book values(29, 'THE TERMINAL LIST', 'ENGLISH', 'THRILLER', 3 );
Insert dbo.book values(30, 'THE TERMINAL LIST', 'ENGLISH', 'THRILLER', 3 );

-------------------------------------------------------------------------------------------------
--- a8

Insert dbo.book values(31, 'THE LAST HOURS IN PARIS', 'ENGLISH', 'HISTORICAL', 4 );
Insert dbo.book values(32, 'THE LAST HOURS IN PARIS', 'ENGLISH', 'HISTORICAL', 4 );
Insert dbo.book values(33, 'THE LAST HOURS IN PARIS', 'ENGLISH', 'HISTORICAL', 4 );
Insert dbo.book values(34, 'THE LAST HOURS IN PARIS', 'ENGLISH', 'HISTORICAL', 4 );
---------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
---- A9
Insert dbo.book values(35, 'TSALMOTH', 'ENGLISH', 'FANTASY', 5 );
--- A10
INSERT DBO.book VALUES(36, 'THE BOOK OF GEMS','ENGLISH', 'FANTASY',5)
--- A11
INSERT DBO.book VALUES(37,'THE WARDEN','FANTASY','ENGLISH', 5)
--- A12
INSERT DBO.book VALUES(38,'KEEPERS SIX','FANTASY','ENGLISH', 5)
---------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
---- A13
INSERT DBO.book VALUES(39,'HOSTAGE','THRILLER','ENGLISH', 6)
INSERT DBO.book VALUES(40,'YOUNG SAMURAI: THE WAY OF THE WARRIOR','NOVEL','ENGLISH', 6)
INSERT DBO.book VALUES(41,'YOUNG SAMURAI: THE RING OF EARTH','NOVEL','ENGLISH', 6)
INSERT DBO.book VALUES(42,'YOUNG SAMURAI: THE RING OF WATER','NOVEL','ENGLISH', 6)
INSERT DBO.book VALUES(43,'YOUNG SAMURAI: THE WAY OF THE SWORD','NOVEL','ENGLISH', 6)
INSERT DBO.book VALUES(44,'YOUNG SAMURAI: THE WAY OF THE DRAGON','NOVEL','ENGLISH', 6)
INSERT DBO.book VALUES(45,'YOUNG SAMURAI: THE RING OF FIRE','NOVEL','ENGLISH',  6)
INSERT DBO.book VALUES(46,'YOUNG SAMURAI: THE RING OF SKY','NOVEL','ENGLISH', 6)

INSERT DBO.book VALUES(47,'HOSTAGE','THRILLER','SPANISH', 6)
INSERT DBO.book VALUES(48,'YOUNG SAMURAI: THE WAY OF THE WARRIOR','NOVEL','SPANISH', 6)
INSERT DBO.book VALUES(49,'YOUNG SAMURAI: THE RING OF EARTH','NOVEL','SPANISH', 6)
INSERT DBO.book VALUES(50,'YOUNG SAMURAI: THE RING OF WATER','NOVEL','SPANISH', 6)
INSERT DBO.book VALUES(51,'YOUNG SAMURAI: THE RING OF WIND','NOVEL','SPANISH', 6)
INSERT DBO.book VALUES(52,'YOUNG SAMURAI: THE WAY OF THE SWORD','NOVEL','SPANISH', 6)
INSERT DBO.book VALUES(53,'YOUNG SAMURAI: THE WAY OF THE DRAGON','NOVEL','SPANISH',  6)
INSERT DBO.book VALUES(54,'YOUNG SAMURAI: THE RING OF FIRE','NOVEL','SPANISH', 6)
INSERT DBO.book VALUES(55,'YOUNG SAMURAI: THE RING OF SKY','NOVEL','SPANISH', 6)


--------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

-- A14
INSERT DBO.book VALUES(56,'A Tale of the Wicked Queen','comic','english', 7);
INSERT DBO.book VALUES(57,' A Tale of Beautys Prince','comic','english',  7);
INSERT DBO.book VALUES(58,' A Tale of the Sea Witch','comic','english',  7);
INSERT DBO.book VALUES(59,' The Odd Sisters: A Villains Novel','comic','english',7);
INSERT DBO.book VALUES(60,'  A Tale of the Dark Fairy ','comic','english', 7);
---------------------------------------------------------------------------------------------------
---A15
INSERT DBO.book VALUES(61,'Inside out','cartoon','english',  7);
INSERT DBO.book VALUES(62,'Incredibles 2','cartoon','english', 7);
INSERT DBO.book VALUES(63,'Toy Story 4','cartoon','english', 7);
INSERT DBO.book VALUES(64,'Luca','cartoon','english',  7);
INSERT DBO.book VALUES(65,'Soul','cartoon','english', 7);
INSERT DBO.book VALUES(66,'Turning Red','cartoon','english', 7);

INSERT DBO.book VALUES(67,'Inside out','cartoon','Spanish',7);
INSERT DBO.book VALUES(68,'Incredibles 2','cartoon','Russian', 7);
INSERT DBO.book VALUES(69,'Toy Story 4','cartoon','Canadian',  7);
INSERT DBO.book VALUES(70,'Luca','cartoon','Spanish',  7);
INSERT DBO.book VALUES(71,'Soul','cartoon','Spanish',  7);
INSERT DBO.book VALUES(72,'Turning Red','cartoon','Spanish', 7);

INSERT DBO.book VALUES(73,'Inside out','cartoon','english', 7);
INSERT DBO.book VALUES(74,'Incredibles 2','cartoon','english', 7);
INSERT DBO.book VALUES(75,'Toy Story 4','cartoon','english', 7);
INSERT DBO.book VALUES(76,'Luca','cartoon','english',  7);
INSERT DBO.book VALUES(77,'Soul','cartoon','english', 7);
INSERT DBO.book VALUES(78,'Turning Red','cartoon','english', 7);

-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------
---- -- A20

INSERT DBO.book VALUES(79,'Lunch BOX','cooking','english', 8);
INSERT DBO.book VALUES(80,'Beef it up','cooking','english', 8);
INSERT DBO.book VALUES(81,'Green Fire','cooking','english', 8);
INSERT DBO.book VALUES(82,'Just a Spritz','cooking','english', 8);
INSERT DBO.book VALUES(83,'Responsive Feeding','cooking','english', 8);

---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------
---A16

INSERT DBO.book VALUES(84,'Mushroom Magick','spiritual','english', 9);
INSERT DBO.book VALUES(85,'The Power of Hex','spiritual','english', 9);
INSERT DBO.book VALUES(86,'Witchs Brew','spiritual','english', 9);

INSERT DBO.book VALUES(87,'Mushroom Magick','spiritual','canadian', 9);
INSERT DBO.book VALUES(88,'The Power of Hex','spiritual','canadian', 9);
INSERT DBO.book VALUES(89,'Witchs Brew','spiritual','canadian', 9);

INSERT DBO.book VALUES(90,'Mushroom Magick','spiritual','russian', 9);
INSERT DBO.book VALUES(91,'The Power of Hex','spiritual','russian',  9);
INSERT DBO.book VALUES(92,'Witchs Brew','spiritual','russian', 9);

--- A17
INSERT DBO.book VALUES(93,'To be Honest','Humor','russian', 10);
---- A 18
INSERT DBO.book VALUES(94,'A pig in palace','Humor','english', 10);
INSERT DBO.book VALUES(95,'Monsters in the fog','Humor','english', 10);

INSERT DBO.book VALUES(99,'A pig in palace','Humor','russian',  10);
INSERT DBO.book VALUES(100,'Monsters in the fog','Humor','russian', 10);

-- a19
INSERT DBO.book VALUES(96,'Second banana','Humor','english',  10);
INSERT DBO.book VALUES(97,'First day of school','Humor','english',  10);
INSERT DBO.book VALUES(98,'hannah and sugar','Humor','english', 10);
go

---------------- adding the data to book author table
Insert dbo.bookAuthor values(1,1);Insert dbo.bookAuthor values(2,1);Insert dbo.bookAuthor values(3,1);Insert dbo.bookAuthor values(4,1);

Insert dbo.bookAuthor values(5,2);Insert dbo.bookAuthor values(6,2);Insert dbo.bookAuthor values(7,2);Insert dbo.bookAuthor values(8,2);Insert dbo.bookAuthor values(9,2);Insert dbo.bookAuthor values(10,2);Insert dbo.bookAuthor values(11,2);

Insert dbo.bookAuthor values(12,3);Insert dbo.bookAuthor values(13,3);Insert dbo.bookAuthor values(14,3);

Insert dbo.bookAuthor values(15,4);Insert dbo.bookAuthor values(16,4);Insert dbo.bookAuthor values(17,4);Insert dbo.bookAuthor values(18,4);Insert dbo.bookAuthor values(19,4);

Insert dbo.bookAuthor values(20,5);Insert dbo.bookAuthor values(21,5);

Insert dbo.bookAuthor values(22,6);Insert dbo.bookAuthor values(23,6);Insert dbo.bookAuthor values(24,6);Insert dbo.bookAuthor values(25,6);Insert dbo.bookAuthor values(26,6);

Insert dbo.bookAuthor values(27,7); Insert dbo.bookAuthor values(28,7); Insert dbo.bookAuthor values(29,7); Insert dbo.bookAuthor values(30,7);

Insert dbo.bookAuthor values(31,8); Insert dbo.bookAuthor values(32,8); Insert dbo.bookAuthor values(33,8); Insert dbo.bookAuthor values(34,8);

Insert dbo.bookAuthor values(35,9); Insert dbo.bookAuthor values(36,10); Insert dbo.bookAuthor values(37,11); Insert dbo.bookAuthor values(38,12);

Insert dbo.bookAuthor values(39,13);Insert dbo.bookAuthor values(40,13);Insert dbo.bookAuthor values(41,13);Insert dbo.bookAuthor values(42,13);Insert dbo.bookAuthor values(43,13);
Insert dbo.bookAuthor values(44,13);Insert dbo.bookAuthor values(45,13);Insert dbo.bookAuthor values(46,13);Insert dbo.bookAuthor values(47,13);Insert dbo.bookAuthor values(48,13);
Insert dbo.bookAuthor values(49,13);Insert dbo.bookAuthor values(50,13);Insert dbo.bookAuthor values(51,13);Insert dbo.bookAuthor values(52,13);Insert dbo.bookAuthor values(53,13);
Insert dbo.bookAuthor values(54,13);Insert dbo.bookAuthor values(55,13);


Insert dbo.bookAuthor values(56,14);Insert dbo.bookAuthor values(57,14);Insert dbo.bookAuthor values(58,14);Insert dbo.bookAuthor values(59,14);Insert dbo.bookAuthor values(60,14);

Insert dbo.bookAuthor values(61,15);Insert dbo.bookAuthor values(62,15);Insert dbo.bookAuthor values(63,15);Insert dbo.bookAuthor values(64,15);Insert dbo.bookAuthor values(65,15);
Insert dbo.bookAuthor values(66,15);Insert dbo.bookAuthor values(67,15);Insert dbo.bookAuthor values(68,15);Insert dbo.bookAuthor values(69,15);Insert dbo.bookAuthor values(70,15);
Insert dbo.bookAuthor values(71,15);Insert dbo.bookAuthor values(72,15);Insert dbo.bookAuthor values(73,15);Insert dbo.bookAuthor values(74,15);Insert dbo.bookAuthor values(75,15);
Insert dbo.bookAuthor values(76,15);Insert dbo.bookAuthor values(77,15);Insert dbo.bookAuthor values(78,15);

Insert dbo.bookAuthor values(79,20); Insert dbo.bookAuthor values(80,20);Insert dbo.bookAuthor values(81,20);Insert dbo.bookAuthor values(82,20);Insert dbo.bookAuthor values(83,20);

Insert dbo.bookAuthor values(84,16);Insert dbo.bookAuthor values(85,16);Insert dbo.bookAuthor values(86,16);Insert dbo.bookAuthor values(87,16);Insert dbo.bookAuthor values(88,16);
Insert dbo.bookAuthor values(89,16);Insert dbo.bookAuthor values(90,16);Insert dbo.bookAuthor values(91,16);Insert dbo.bookAuthor values(92,16);

Insert dbo.bookAuthor values(93,17);

Insert dbo.bookAuthor values(94,18);Insert dbo.bookAuthor values(95,18);Insert dbo.bookAuthor values(99,18);Insert dbo.bookAuthor values(100,18);

Insert dbo.bookAuthor values(96,19);Insert dbo.bookAuthor values(97,19);Insert dbo.bookAuthor values(98,19);

------ inserting data to Person table -------------- 
INSERT INTO person (firstName,lastName,email,phoneNumber, addressId, PersonType)
VALUES
  ('Summer','Palmer','sit@protonmail.edu','1-723-340-7378', 11, 'Student'),
  ('Randall','Moses','dis@outlook.org','(357) 214-6341', 12,'Student'),
  ('Pamela','Arnold','luctus@google.edu','1-183-428-0501', 13, 'Student'),
  ('Edan','Harrington','neque.non@yahoo.org','(647) 323-3666', 14, 'Student'),
  ('Vance','Daniels','donec.egestas.aliquam@aol.net','(731) 977-8833', 15,'Faculty'),
   ('Cyrus','Bush','in@google.com','(636) 220-5767', 16,'Faculty'),
  ('Kamal','Holt','ullamcorper.nisl@outlook.net','1-343-490-4084', 17,'Faculty'),
  ('Oleg','Hensley','justo.sit.amet@protonmail.edu','1-765-772-8352', 18,'Faculty'),
  ('Dexter','Foley','fringilla@outlook.ca','(287) 752-4447', 19,'Faculty'),
  ('Rowan','Guerrero','aliquam.adipiscing@outlook.edu','1-524-826-1294', 20,'Faculty'),
  ('JOSH', 'Reddy', 'josh123@gmail.com', '(234)779 9789', 21,'Faculty' ),
  ('Ravi', 'Reddy', 'Ravi@gmail.com', '(890)799 9789', 21,'Faculty' ),
  ('Vishnu', 'Reddy', 'vishnu@gmail.com', '(567)799 9789', 21,'Faculty' )

  INSERT INTO person (firstName,lastName,email,phoneNumber, addressId, PersonType)
VALUES
('George','Ware','eu@aol.com','1-586-528-9323', 1, 'Faculty'),
  ('Dana','Ball','libero.at.auctor@protonmail.com','1-528-153-7738', 12, 'Student'),
  ('Zeus','Day','neque.sed@icloud.org','1-832-596-1974', 11, 'Student'),
  ('Stewart','Dominguez','turpis.vitae@outlook.org','(425) 613-1353', 18, 'Faculty'),
  ('Germane','Tillman','magna.nam@google.com','(176) 688-6436', 20, 'Student'),
  ('Ravi', 'Reddy', 'Ravi@gmail.com', '(890)1234 9789', 21,'Faculty' );

  INSERT INTO person (firstName,lastName,email,phoneNumber, addressId, PersonType)
VALUES
  ('Armand','Norris','a.mi.fringilla@google.edu','1-437-475-1186', 22, 'Library Staff'),
  ('Adele','Valentine','dapibus.gravida@hotmail.org','(266) 727-2285',  23, 'Library Staff'),
  ('Molly','Jensen','lectus.nullam@aol.com','1-507-500-8146',  24, 'Library Staff'),
  ('Maia','Foreman','sem.molestie@protonmail.com','(711) 779-5540',  25, 'Library Staff'),
  ('Harrison','Snow','nam.ligula@google.ca','(344) 266-2651', 26, 'Library Staff'),
  ('Britanni','Hunt','cum.sociis@google.ca','1-823-424-1959', 27, 'Library Staff'),
  ('Sharon','Colon','viverra.maecenas@icloud.net','1-583-560-7017', 28, 'Library Staff'),
  ('Brenda','Pollard','in@yahoo.org','(871) 524-1862', 29, 'Library Staff'),
  ('Pascale','Castillo','commodo.ipsum@yahoo.ca','(520) 311-3478', 30, 'Library Staff'),
  ('Alfonso','Weiss','et@protonmail.edu','(644) 821-5878', 31, 'Library Staff'),
  ('Fletcher','Fuller','enim@protonmail.ca','(710) 229-0547', 32, 'Library Staff'),
  ('Zoe','Drake','leo@aol.couk','(155) 492-2245', 33, 'Library Staff'),
  ('Kellie','Rodriguez','proin.dolor@yahoo.couk','1-418-134-4591', 34, 'Library Staff'),
  ('Benedict','Manning','tristique@google.org','1-318-223-7787', 35, 'Library Staff'),
  ('Nadine','Chase','montes.nascetur@aol.couk','(242) 865-7455', 36, 'Library Staff');

------Insert to  Membership plans
INSERT INTO MembershipPlans VALUES(1, 'Basic', 50);
INSERT INTO MembershipPlans VALUES(2, 'Premium', 100);
------- insert to membership enrollment -------
insert into membershipEnrollment (enrollmentId,personId, membershipId)
values(1,1, 1);
insert into membershipEnrollment (enrollmentId,personId, membershipId)
values (2,2, 1);
insert into membershipEnrollment (enrollmentId,personId, membershipId)
values (3,5, 1);
insert into membershipEnrollment (enrollmentId,personId, membershipId)
values(4,3, 2);
insert into membershipEnrollment (enrollmentId,personId, membershipId)
values(5,4, 2);
insert into membershipEnrollment (enrollmentId,personId, membershipId)
values (6,6, 1);
insert into membershipEnrollment (enrollmentId,personId, membershipId)
values (7,8, 2);
insert into membershipEnrollment (enrollmentId,personId, membershipId)
values (8,7, 2);
insert into membershipEnrollment (enrollmentId,personId, membershipId)
values (9,9, 2);
insert into membershipEnrollment (enrollmentId,personId, membershipId)
values (10,10, 1);
insert into membershipEnrollment (enrollmentId,personId, membershipId)
values (11,11, 2);
insert into membershipEnrollment (enrollmentId,personId, membershipId)
values(12,12, 2);
 go

 -------- Insert data to book borrow -----------------
 ---- p1 ---- b:1,15,27
Insert dbo.BorrowBook(borrowId, bookId, personId,checkInTime,CheckOutTime) 
values(1,1,1,'2022-06-28 08:30:00.000','2022-07-28 08:30:00.000' );

Insert dbo.BorrowBook(borrowId, bookId, personId,checkInTime,CheckOutTime) 
values(5,15,1,'2022-06-28 08:30:00.000','2022-07-28 08:30:00.000' );

Insert dbo.BorrowBook(borrowId, bookId, personId,checkInTime,CheckOutTime) 
values(18,27,1,'2022-02-02 08:30:00.000','2022-03-28 08:30:00.000' );

---- p2 ------ B: 2 , 17, 28
Insert dbo.BorrowBook(borrowId, bookId, personId,checkInTime,CheckOutTime) 
values(2,2,2,'2022-06-28 08:30:00.000','2022-07-28 08:30:00.000' );

Insert dbo.BorrowBook(borrowId, bookId, personId,checkInTime,CheckOutTime) 
values(7,17,2,'2022-06-28 08:30:00.000','2022-07-28 08:30:00.000' );

Insert dbo.BorrowBook(borrowId, bookId, personId,checkInTime,CheckOutTime) 
values(19,28,2,'2022-02-02 08:30:00.000','2022-03-28 08:30:00.000' );
---- P3 ------ B:3 6 ,29
Insert dbo.BorrowBook(borrowId, bookId, personId,checkInTime,CheckOutTime) 
values(3,3,3,'2022-06-28 08:30:00.000','2022-07-28 08:30:00.000' );

Insert dbo.BorrowBook(borrowId, bookId, personId,checkInTime,CheckOutTime) 
values(11,6,3,'2022-07-28 08:30:00.000','2022-08-28 08:30:00.000' );

Insert dbo.BorrowBook(borrowId, bookId, personId,checkInTime,CheckOutTime) 
values(20,29,3,'2022-02-02 08:30:00.000','2022-03-28 08:30:00.000' );

---- P4 ------- B:4 7
Insert dbo.BorrowBook(borrowId, bookId, personId,checkInTime,CheckOutTime) 
values(4,4,4,'2022-06-28 08:30:00.000','2022-07-28 08:30:00.000' );

Insert dbo.BorrowBook(borrowId, bookId, personId,checkInTime,CheckOutTime) 
values(12,7,4,'2022-07-28 08:30:00.000','2022-08-28 08:30:00.000' );
----p5 ---- B:16, 10
Insert dbo.BorrowBook(borrowId, bookId, personId,checkInTime,CheckOutTime) 
values(6,16,5,'2022-06-28 08:30:00.000','2022-07-28 08:30:00.000' );

Insert dbo.BorrowBook(borrowId, bookId, personId,checkInTime,CheckOutTime) 
values(17,10,5,'2022-02-02 08:30:00.000','2022-03-28 08:30:00.000' );

------ p6 -------B 18
Insert dbo.BorrowBook(borrowId, bookId, personId,checkInTime,CheckOutTime) 
values(8,18,6,'2022-07-28 08:30:00.000','2022-08-28 08:30:00.000' );

------ p7 -------B 19
Insert dbo.BorrowBook(borrowId, bookId, personId,checkInTime,CheckOutTime) 
values(9,19,7,'2022-07-28 08:30:00.000','2022-08-28 08:30:00.000' );

------ p8 -------B 5, 11
Insert dbo.BorrowBook(borrowId, bookId, personId,checkInTime,CheckOutTime) 
values(10,5,8,'2022-07-28 08:30:00.000','2022-08-28 08:30:00.000' );

Insert dbo.BorrowBook(borrowId, bookId, personId,checkInTime,CheckOutTime) 
values(16,11,8,'2022-02-02 08:30:00.000','2022-03-28 08:30:00.000' );

---------------- p9 --------- b : 8,9
Insert dbo.BorrowBook(borrowId, bookId, personId,checkInTime,CheckOutTime) 
values(13,8,9,'2022-07-28 08:30:00.000','2022-08-28 08:30:00.000' );

Insert dbo.BorrowBook(borrowId, bookId, personId,checkInTime,CheckOutTime) 
values(14,9,9,'2022-07-28 08:30:00.000','2022-08-28 08:30:00.000' );

---------------- p10 --------- b : 12
Insert dbo.BorrowBook(borrowId, bookId, personId,checkInTime,CheckOutTime) 
values(15,12,10,'2022-02-02 08:30:00.000','2022-03-28 08:30:00.000' );

------  p 11 ------------ b:30
Insert dbo.BorrowBook(borrowId, bookId, personId,checkInTime,CheckOutTime) 
values(21,30,11,'2022-02-02 08:30:00.000','2022-03-28 08:30:00.000' );

Insert dbo.BorrowBook(borrowId, bookId, personId,checkInTime,CheckOutTime) 
values(24,21,11,'2022-02-02 08:30:00.000','2022-03-28 08:30:00.000' );
------  p 12 ------------ b:13,20
Insert dbo.BorrowBook(borrowId, bookId, personId,checkInTime,CheckOutTime) 
values(22,13,12,'2021-02-02 08:30:00.000','2021-03-28 08:30:00.000' );

Insert dbo.BorrowBook(borrowId, bookId, personId,checkInTime,CheckOutTime) 
values(23,20,12,'2021-02-02 08:30:00.000','2021-03-28 08:30:00.000' );

go
--------- Insert data to :  Study Space category 
go
insert into StudySpace_Category(categoryName, categoryCapacity) values ('Group', 6)
insert into StudySpace_Category(categoryName, categoryCapacity) values ('CoLab', 4)
insert into StudySpace_Category(categoryName, categoryCapacity) values ('Graduate', 3)
insert into StudySpace_Category(categoryName, categoryCapacity) values ('Video Conferencing', 6)
go

--------- Insert data to :  Study Space 
insert into StudySpace(spaceName, categoryId)
values ('coLab A', 2)
insert into StudySpace(spaceName, categoryId)
values ('coLab B', 2)
insert into StudySpace(spaceName, categoryId)
values ('coLab C', 2)
insert into StudySpace(spaceName, categoryId)
values ('coLab D', 2)
insert into StudySpace(spaceName, categoryId)
values ('coLab E', 2)
insert into StudySpace(spaceName, categoryId)
values ('Group 379', 1)
insert into StudySpace(spaceName, categoryId)
values ('Group 381', 1)
insert into StudySpace(spaceName, categoryId)
values ('Group 383', 1)
insert into StudySpace(spaceName, categoryId)
values ('Group 393', 1)
insert into StudySpace(spaceName, categoryId)
values ('Grad 479', 3)
insert into StudySpace(spaceName, categoryId)
values ('Grad 481', 3)
insert into StudySpace(spaceName, categoryId)
values ('Grad 483', 3)
insert into StudySpace(spaceName, categoryId)
values ('Grad 493', 3)
insert into StudySpace(spaceName, categoryId)
values ('conf L', 4)
insert into StudySpace(spaceName, categoryId)
values ('conf M', 4)
insert into StudySpace(spaceName, categoryId)
values ('conf N', 4)
insert into StudySpace(spaceName, categoryId)
values ('conf O', 4)
insert into StudySpace(spaceName, categoryId)
values ('conf p', 4)
insert into StudySpace(spaceName, categoryId)
values ('conf Q', 4)

insert into StudySpace(spaceName, categoryId)
values ('Grad 523', 3)
insert into StudySpace(spaceName, categoryId)
values ('Grad 525', 3)
insert into StudySpace(spaceName, categoryId)
values ('Grad 527', 3)
insert into StudySpace(spaceName, categoryId)
values ('Grad 529', 3)
insert into StudySpace(spaceName, categoryId)
values ('Grad 531', 3)
insert into StudySpace(spaceName, categoryId)
values ('Grad 533', 3)
insert into StudySpace(spaceName, categoryId)
values ('Grad 535', 3)
--------- Insert data to spacebooking ------------------------------

select * from SpaceBooking
 

insert into SpaceBooking(bookingId, duration, startTime, PersonId, spaceId)
values(101, 3, '2022-07-28 8:30', 8, 5)
insert into SpaceBooking(bookingId, duration, startTime, PersonId, spaceId)
values(103, 2, '2022-07-28 9:00', 9, 6)
insert into SpaceBooking(bookingId, duration, startTime, PersonId, spaceId)
values(104, 3, '2022-07-28 2:30', 8, 6)
insert into SpaceBooking(bookingId, duration, startTime, PersonId, spaceId)
values(105, 2, '2022-07-28 19:30', 9, 6)
insert into SpaceBooking(bookingId, duration, startTime, PersonId, spaceId)
values(106, 3, '2022-07-28 11:30', 8, 2)
insert into SpaceBooking(bookingId, duration, startTime, PersonId, spaceId)
values(107, 1, '2022-07-28 17:30', 3, 2)
insert into SpaceBooking(bookingId, duration, startTime, PersonId, spaceId)
values(108, 2, '2022-07-28 1:30', 9, 2)
insert into SpaceBooking(bookingId, duration, startTime, PersonId, spaceId)
values(109, 3, '2022-07-28 19:30', 3, 1)
insert into SpaceBooking(bookingId, duration, startTime, PersonId, spaceId)
values(110, 3, '2022-07-28 19:30', 7, 18)
insert into SpaceBooking(bookingId, duration, startTime, PersonId, spaceId)
values(111, 3, '2022-07-28 20:30', 8, 19)
insert into SpaceBooking(bookingId, duration, startTime, PersonId, spaceId)
values(112, 3, '2022-07-28 7:30', 3, 18)
insert into SpaceBooking(bookingId, duration, startTime, PersonId, spaceId)
values(113, 3, '2022-07-28 19:00', 7, 20)
insert into SpaceBooking(bookingId, duration, startTime, PersonId, spaceId)
values(114, 3, '2022-07-28 16:00', 9, 23)
insert into SpaceBooking(bookingId, duration, startTime, PersonId, spaceId)
values(115, 3, '2022-07-28 16:00', 4, 24)
insert into SpaceBooking(bookingId, duration, startTime, PersonId, spaceId)
values(116, 3, '2022-07-28 13:30', 8, 22)
insert into SpaceBooking(bookingId, duration, startTime, PersonId, spaceId)
values(117, 3, '2022-07-28 15:30', 3, 21)
insert into SpaceBooking(bookingId, duration, startTime, PersonId, spaceId)
values(120, 3, '2022-07-30 12:30', 4, 25)
insert into SpaceBooking(bookingId, duration, startTime, PersonId, spaceId)
values(121, 3, '2022-08-3 12:30', 11, 25)
insert into SpaceBooking(bookingId, duration, startTime, PersonId, spaceId)
values(122, 3, '2022-08-2 12:30', 12, 25)
insert into SpaceBooking(bookingId, duration, startTime, PersonId, spaceId)
values(123, 1, '2022-08-3 7:30', 3, 25)
insert into SpaceBooking(bookingId, duration, startTime, PersonId, spaceId)
values(125, 2, '2022-08-3 7:30', 12, 26)
go
--------------------------------------------- Coloumn level Functions -------------------------------------------------------------------------------------
--------- Gives the count of total spaces booked based on study space category

create function fn_calcCategoryBookings(@categoryId int)
returns int
as 
begin
	declare @totalBookings int = 0
	select @totalBookings = count(bookingId)
	from SpaceBooking sb
	inner join StudySpace ss
	on sb.spaceId = ss.SpaceID and ss.categoryId = @categoryId
	set @totalBookings = ISNULL(@totalBookings, 0)
	return @totalBookings;
end
go
alter table studySpace_Category 
add TotalBookings as (dbo.fn_calcCategoryBookings(studySpace_CategoryID))

select * from dbo.StudySpace_Category

------------------------------- Views ------------------------------------------------------------

------ get list of users and their membership expiry in months
create view UserMembershipInfo
AS
select p.personId,P.firstName,P.lastName, DATEDIFF(MM, GETDATE(),ME.expiryDate) as 'expires in' , MP.MembershipCategory
from dbo.membershipEnrollment ME full join dbo.MembershipPlans MP
on ME.membershipId = MP.MembershipPlanID full join dbo.person P
on P.personId = ME.personId
go

select * from UserMembershipInfo
go
-------- View : to check the count of Members in Basic and Premium membership plans
go
create view vwMembershipPlanCount
as
select mp.MembershipCategory, count(membershipId) as 'Number of persons purhcased'
from membershipEnrollment me
inner join MembershipPlans mp
on mp.MembershipPlanID = me.membershipId
group by MembershipCategory
go
select * from vwMembershipPlanCount
go

----- View  : Best 3 Borrowing books including ties
go
create view vw_Top3Books
as
select title, language, [Times borrowed]
from (
	select title, language, count(b.bookId) as [Times borrowed],
	rank() over(order by count(b.bookId) desc) as [ranking]
	from BorrowBook bb
	inner join book b
	on b.bookId = bb.bookId
	group by title, language
) as temp
where temp.[ranking] <= 3
go
select * from vw_Top3Books
go
--------------------------------------------------------------------------------
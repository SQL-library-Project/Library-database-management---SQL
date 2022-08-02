--- Using the database
Use Team4FinalPrj;
GO

--- Creating book table 

Create Table book(
bookId int NOT NULL PRIMARY KEY,

title  varchar(40) NOT NULL,
language varchar(40) NOT NULL,
categoryName varchar(40) NOT NULL,

isAvailable Bit,

publisherId int references dbo.publisher(publisherId)
)
GO

alter table dbo.book
drop column isAvailable;
go


go
select * from dbo.book;
go

----- False : 0 ; True : 1
--- inserting data to book table 
-- a1
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
INSERT DBO.book VALUES(42,'YOUNG SAMURAI: THE RING OF WIND','NOVEL','ENGLISH', 6)
INSERT DBO.book VALUES(43,'YOUNG SAMURAI: THE WAY OF THE SWORD','NOVEL','ENGLISH', 6)
INSERT DBO.book VALUES(44,'YOUNG SAMURAI: THE WAY OF THE DRAGON','NOVEL','ENGLISH', 6)
INSERT DBO.book VALUES(45,'YOUNG SAMURAI: THE RING OF FIRE','NOVEL','ENGLISH',  6)
INSERT DBO.book VALUES(46,'YOUNG SAMURAI: THE RING OF SKY','NOVEL','ENGLISH', 6)

INSERT DBO.book VALUES(47,'HOSTAGE','THRILLER','SPANISH', 'FALSE', 6)
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
---- no author -- A20

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

----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
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
--- SELECTING THE TABLE
SELECT * FROM dbo.book;
GO

--- Dropping the table
---DROP TABLE DBO.book;
---GO
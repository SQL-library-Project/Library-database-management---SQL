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

----- False : 0 ; True : 1
--- inserting data to book table 
-- a1
Insert dbo.book values(1, 'the dead romances', 'English', 'fiction', 'True', 1 );
Insert dbo.book values(2, 'the dead romances', 'English', 'fiction',  'True',1 );

Insert dbo.book values(3, 'the dead romances', 'Spanish', 'fiction', 'True', 1 );
Insert dbo.book values(4, 'the dead romances', 'Spanish', 'fiction', 'False', 1 );
------------------------------------------------------------------------------------
--- a2
Insert dbo.book values(5, 'Suspects', 'English', 'thriller','False', 1 );
Insert dbo.book values(6, 'Suspects', 'English', 'thriller','True', 1 );
Insert dbo.book values(7, 'Suspects', 'English', 'thriller','True', 1 );
Insert dbo.book values(8, 'Suspects', 'English', 'thriller','True', 1 );

Insert dbo.book values(9, 'Suspects', 'Spanish', 'thriller','True', 1 );
Insert dbo.book values(10, 'Suspects', 'French', 'thriller','False', 1 );
Insert dbo.book values(11, 'Suspects', 'French', 'thriller','False', 1 );
-------------------------------------------------------------------------------------
--- a3
Insert dbo.book values(12, 'The Best Is Yet To Come', 'English', 'Romance','True', 1 );
Insert dbo.book values(13, 'The Best Is Yet To Come', 'chinese', 'Romance','False', 1 );
Insert dbo.book values(14, 'The Best Is Yet To Come', 'Spanish', 'Romance', 'True',1 );
-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------
---- a4
Insert dbo.book values(15, 'The Soviet Sisters', 'English', 'Fiction','True', 2 );
Insert dbo.book values(16, 'The Soviet Sisters', 'English', 'Fiction','True', 2 );
Insert dbo.book values(17, 'The Soviet Sisters', 'Taiwanese', 'Fiction','True', 2 );

Insert dbo.book values(18, 'The Soviet Sisters', 'English', 'Fiction','True', 2 );

Insert dbo.book values(19, 'The Soviet Sisters', 'Taiwanese', 'Fiction','True', 2 );
-----------------------------------------------------------------------------------------
---- a5
Insert dbo.book values(20, 'In the Beautiful Country', 'Taiwanese', 'Kids Stories','True', 2 );
Insert dbo.book values(21, 'In the Beautiful Country', 'eNGLISH', 'Kids Stories','fALSE', 2 );
--------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
---- a6
Insert dbo.book values(22, 'Break an Egg', 'Spanish', 'Kids Stories','True', 3 );
Insert dbo.book values(23, 'Break an Egg', 'Spanish', 'Kids Stories','fALSE', 3 );

Insert dbo.book values(24, 'Break an Egg', 'English', 'Kids Stories','FALSE', 3 );
Insert dbo.book values(25, 'Break an Egg', 'English', 'Kids Stories','TRUE', 3 );
Insert dbo.book values(26, 'Break an Egg', 'English', 'Kids Stories','TRUE', 3 );
-------------------------------------------------------------------------------------------------
---- A7
Insert dbo.book values(27, 'THE TERMINAL LIST', 'Spanish', 'THRILLER','fALSE', 3 );
Insert dbo.book values(28, 'THE TERMINAL LIST', 'Spanish', 'THRILLER','TRUE', 3 );

Insert dbo.book values(29, 'THE TERMINAL LIST', 'ENGLISH', 'THRILLER','fALSE', 3 );
Insert dbo.book values(30, 'THE TERMINAL LIST', 'ENGLISH', 'THRILLER','TRUE', 3 );

-------------------------------------------------------------------------------------------------
--- a8

Insert dbo.book values(31, 'THE LAST HOURS IN PARIS', 'ENGLISH', 'HISTORICAL','TRUE', 4 );
Insert dbo.book values(32, 'THE LAST HOURS IN PARIS', 'ENGLISH', 'HISTORICAL','TRUE', 4 );
Insert dbo.book values(33, 'THE LAST HOURS IN PARIS', 'ENGLISH', 'HISTORICAL','TRUE', 4 );
Insert dbo.book values(34, 'THE LAST HOURS IN PARIS', 'ENGLISH', 'HISTORICAL','TRUE', 4 );
---------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
---- A9
Insert dbo.book values(35, 'TSALMOTH', 'ENGLISH', 'FANTASY','TRUE', 5 );
--- A10
INSERT DBO.book VALUES(36, 'THE BOOK OF GEMS','ENGLISH', 'FANTASY','TRUE',5)
--- A11
INSERT DBO.book VALUES(37,'THE WARDEN','FANTASY','ENGLISH', 'FALSE', 5)
--- A12
INSERT DBO.book VALUES(38,'KEEPERS SIX','FANTASY','ENGLISH', 'TRUE', 5)
---------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
---- A13
INSERT DBO.book VALUES(39,'HOSTAGE','THRILLER','ENGLISH', 'FALSE', 6)
INSERT DBO.book VALUES(40,'YOUNG SAMURAI: THE WAY OF THE WARRIOR','NOVEL','ENGLISH', 'FALSE', 6)
INSERT DBO.book VALUES(41,'YOUNG SAMURAI: THE RING OF EARTH','NOVEL','ENGLISH', 'FALSE', 6)
INSERT DBO.book VALUES(42,'YOUNG SAMURAI: THE RING OF WATER','NOVEL','ENGLISH', 'TRUE', 6)
INSERT DBO.book VALUES(42,'YOUNG SAMURAI: THE RING OF WIND','NOVEL','ENGLISH', 'TRUE', 6)
INSERT DBO.book VALUES(43,'YOUNG SAMURAI: THE WAY OF THE SWORD','NOVEL','ENGLISH', 'FALSE', 6)
INSERT DBO.book VALUES(44,'YOUNG SAMURAI: THE WAY OF THE DRAGON','NOVEL','ENGLISH', 'TRUE', 6)
INSERT DBO.book VALUES(45,'YOUNG SAMURAI: THE RING OF FIRE','NOVEL','ENGLISH', 'TRUE', 6)
INSERT DBO.book VALUES(46,'YOUNG SAMURAI: THE RING OF SKY','NOVEL','ENGLISH', 'FALSE', 6)

INSERT DBO.book VALUES(47,'HOSTAGE','THRILLER','SPANISH', 'FALSE', 6)
INSERT DBO.book VALUES(48,'YOUNG SAMURAI: THE WAY OF THE WARRIOR','NOVEL','SPANISH', 'FALSE', 6)
INSERT DBO.book VALUES(49,'YOUNG SAMURAI: THE RING OF EARTH','NOVEL','SPANISH', 'FALSE', 6)
INSERT DBO.book VALUES(50,'YOUNG SAMURAI: THE RING OF WATER','NOVEL','SPANISH', 'TRUE', 6)
INSERT DBO.book VALUES(51,'YOUNG SAMURAI: THE RING OF WIND','NOVEL','SPANISH', 'TRUE', 6)
INSERT DBO.book VALUES(52,'YOUNG SAMURAI: THE WAY OF THE SWORD','NOVEL','SPANISH', 'FALSE', 6)
INSERT DBO.book VALUES(53,'YOUNG SAMURAI: THE WAY OF THE DRAGON','NOVEL','SPANISH', 'TRUE', 6)
INSERT DBO.book VALUES(54,'YOUNG SAMURAI: THE RING OF FIRE','NOVEL','SPANISH', 'TRUE', 6)
INSERT DBO.book VALUES(55,'YOUNG SAMURAI: THE RING OF SKY','NOVEL','SPANISH', 'FALSE', 6)


--------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

-- A14
INSERT DBO.book VALUES(56,'A Tale of the Wicked Queen','comic','english', 'TRUE', 7);
INSERT DBO.book VALUES(57,' A Tale of Beautys Prince','comic','english', 'TRUE', 7);
INSERT DBO.book VALUES(58,' A Tale of the Sea Witch','comic','english', 'FALSE', 7);
INSERT DBO.book VALUES(59,' The Odd Sisters: A Villains Novel','comic','english', 'TRUE', 7);
INSERT DBO.book VALUES(60,'  A Tale of the Dark Fairy ','comic','english', 'TRUE', 7);
---------------------------------------------------------------------------------------------------
---A15
INSERT DBO.book VALUES(61,'Inside out','cartoon','english', 'TRUE', 7);
INSERT DBO.book VALUES(62,'Incredibles 2','cartoon','english', 'TRUE', 7);
INSERT DBO.book VALUES(63,'Toy Story 4','cartoon','english', 'TRUE', 7);
INSERT DBO.book VALUES(64,'Luca','cartoon','english', 'TRUE', 7);
INSERT DBO.book VALUES(65,'Soul','cartoon','english', 'False', 7);
INSERT DBO.book VALUES(66,'Turning Red','cartoon','english', 'TRUE', 7);

INSERT DBO.book VALUES(67,'Inside out','cartoon','Spanish', 'TRUE', 7);
INSERT DBO.book VALUES(68,'Incredibles 2','cartoon','Russian', 'TRUE', 7);
INSERT DBO.book VALUES(69,'Toy Story 4','cartoon','Canadian', 'TRUE', 7);
INSERT DBO.book VALUES(70,'Luca','cartoon','Spanish', 'TRUE', 7);
INSERT DBO.book VALUES(71,'Soul','cartoon','Spanish', 'False', 7);
INSERT DBO.book VALUES(72,'Turning Red','cartoon','Spanish', 'TRUE', 7);

INSERT DBO.book VALUES(73,'Inside out','cartoon','english', 'TRUE', 7);
INSERT DBO.book VALUES(74,'Incredibles 2','cartoon','english', 'TRUE', 7);
INSERT DBO.book VALUES(75,'Toy Story 4','cartoon','english', 'TRUE', 7);
INSERT DBO.book VALUES(76,'Luca','cartoon','english', 'TRUE', 7);
INSERT DBO.book VALUES(77,'Soul','cartoon','english', 'False', 7);
INSERT DBO.book VALUES(78,'Turning Red','cartoon','english', 'TRUE', 7);

-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------
---- no author -- A20

INSERT DBO.book VALUES(79,'Lunch BOX','cooking','english', 'TRUE', 8);
INSERT DBO.book VALUES(80,'Beef it up','cooking','english', 'false', 8);
INSERT DBO.book VALUES(81,'Green Fire','cooking','english', 'TRUE', 8);
INSERT DBO.book VALUES(82,'Just a Spritz','cooking','english', 'TRUE', 8);
INSERT DBO.book VALUES(83,'Responsive Feeding','cooking','english', 'TRUE', 8);

---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------
---A16

INSERT DBO.book VALUES(84,'Mushroom Magick','spiritual','english', 'TRUE', 9);
INSERT DBO.book VALUES(85,'The Power of Hex','spiritual','english', 'TRUE', 9);
INSERT DBO.book VALUES(86,'Witchs Brew','spiritual','english', 'TRUE', 9);

INSERT DBO.book VALUES(87,'Mushroom Magick','spiritual','canadian', 'TRUE', 9);
INSERT DBO.book VALUES(88,'The Power of Hex','spiritual','canadian', 'TRUE', 9);
INSERT DBO.book VALUES(89,'Witchs Brew','spiritual','canadian', 'TRUE', 9);

INSERT DBO.book VALUES(90,'Mushroom Magick','spiritual','russian', 'TRUE', 9);
INSERT DBO.book VALUES(91,'The Power of Hex','spiritual','russian', 'TRUE', 9);
INSERT DBO.book VALUES(92,'Witchs Brew','spiritual','russian', 'TRUE', 9);

----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--- A17
INSERT DBO.book VALUES(93,'To be Honest','Humor','russian', 'False', 10);
---- A 18
INSERT DBO.book VALUES(94,'A pig in palace','Humor','english', 'False', 10);
INSERT DBO.book VALUES(95,'Monsters in the fog','Humor','english', 'True', 10);

INSERT DBO.book VALUES(99,'A pig in palace','Humor','russian', 'True', 10);
INSERT DBO.book VALUES(100,'Monsters in the fog','Humor','russian', 'True', 10);

-- a19
INSERT DBO.book VALUES(96,'Second banana','Humor','english', 'True', 10);
INSERT DBO.book VALUES(97,'First day of school','Humor','english', 'True', 10);
INSERT DBO.book VALUES(98,'hannah and sugar','Humor','english', 'True', 10);

go
--- SELECTING THE TABLE
SELECT * FROM dbo.book;
GO

--- Dropping the table
---DROP TABLE DBO.book;
---GO
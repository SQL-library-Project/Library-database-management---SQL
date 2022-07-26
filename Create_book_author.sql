--- Using the database
Use Team4FinalPrj;
GO

---- creating book autor table 
CREATE TABLE bookAuthor(
bookId int references dbo.book(bookId) ,
authorId int references dbo.author(authorId),
primary key (bookId, authorId)
)
GO

---  DROPPING TABLE
---DROP TABLE dbo.bookAuthor;
GO

--- SELECTING THE TABLE
SELECT * FROM dbo.bookAuthor;
go

----- adding the data to book author table
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












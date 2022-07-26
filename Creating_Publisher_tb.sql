--- Using the database
Use Team4FinalPrj;
GO

--- Creating PUBLISHER TABLE
Create Table publisher(
publisherId int NOT NULL PRIMARY KEY,
PublisherName varchar(40) NOT NULL,

addressId int references dbo.address(addressId)
)
GO

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

--- SELECTING THE TABLE
SELECT * FROM dbo.publisher;
GO

--- Dropping the table
----DROP TABLE DBO.publisher;
GO
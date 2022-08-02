--- Using the database
Use Team4FinalPrj;
GO

--- Creating ADDRESS TABLE

Create Table address(

addressId int NOT NULL PRIMARY KEY,

postalCode int Not null,
street varchar(40) not null,
city varchar(40) not null,
state varchar(40) not null,
country varchar(40) not null,
);
GO

--- INSERTING DATA TO AUTHOR TABLE
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


Insert dbo.address values(21, 94133, '12354 presidio street', 'san Francisco', 'california', 'USA')

go

---  DROPPING TABLE
DROP TABLE DBO.address;
GO

--- SELECTING THE TABLE
SELECT * FROM dbo.address;
GO











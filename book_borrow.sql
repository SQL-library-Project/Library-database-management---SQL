--- Using the database
Use Team4FinalPrj;
GO

--- Creating ADDRESS TABLE

Create Table Book_borrow(

borrowid int NOT NULL PRIMARY KEY,

bookId int NOT NULL REFERENCES dbo.books(bookId), 
---PersonId int NOT NULL REFERENCES dbo.books(bookId),

Check_in_time datetime NOT NULL,
Check_out_time datetime NOT NULL,

);
GO


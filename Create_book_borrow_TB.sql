Use Team4FinalPrj;
GO


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

----------------------------- Table level constraint -------------------------
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

----- drop function validateMember;
-------------------------  Trigger : user cannot borrow book that has been already borrowed ----------------------------------------

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

drop trigger checkforBook;

---------------------------------------inserting data -----------------------------------------------------

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

select * from dbo.BorrowBook











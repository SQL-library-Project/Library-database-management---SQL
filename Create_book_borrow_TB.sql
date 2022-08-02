Use Team4FinalPrj;
GO

select * from dbo.AUTHOR;
select * from dbo.bookAuthor;
select * from dbo.book;
select * from dbo.publisher;
select * from dbo.address;
select * from dbo.BorrowBook;
select * from dbo.membershipEnrollment;
select * from dbo.person;

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

go
select * from dbo.BorrowBook;
go


Create trigger checkforBook
on dbo.BorrowBook
Instead Of insert
AS
begin
 declare @count int  = 0
-----select @count = COUNT(bookId) from dbo.BorrowBook bb where bb.bookId = inserted.bookId
print 'trigger is working'

select @count = COUNT(i.bookId) from inserted i left join dbo.BorrowBook bb on (bb.bookId = i.bookId) and (bb.CheckOutTime < GETDATE())
group by bb.bookId 

print @count

if(@count = 0)
begin
print 'in count 0'
insert  dbo.BorrowBook(borrowId,bookId,personId,checkInTime,CheckOutTime)
	select borrowId,bookId,personId,checkInTime,CheckOutTime
	from inserted
return
end

if(@count > 0)
begin
print 'Book is not availble to borrow'
return
end

end
go

drop trigger checkforBook;

select * from dbo.SpaceBooking




--------------------------------------------------------------------------------------------
Insert dbo.BorrowBook(borrowId, bookId, personId,checkInTime,CheckOutTime) 
values(4,3,11,'2022-06-28 08:30:00.000','2022-07-28 08:30:00.000' );
go

select * from dbo.BorrowBook;

SET IDENTITY_INSERT dbo.Person ON
Insert dbo.person(personId,firstName,lastName,email,phoneNumber,addressId,PersonType)
values(13, 'Vishnu', 'Reddy', 'vishnu@gmail.com', '(567)799 9789', 21,'Faculty' )
go










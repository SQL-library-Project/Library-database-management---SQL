-------- Creating views of books borrowed and user membership details --------------

select * from dbo.BorrowBook;
select * from dbo.membershipEnrollment;
select * from dbo.person;
select * from dbo.MembershipPlans;
go

----------- Getting persons membership status of each person --------------------------------------

create view UserMembershipInfo
AS
select p.personId,P.firstName,P.lastName, DATEDIFF(MM, GETDATE(),ME.expiryDate) as 'expires in' , MP.MembershipCategory
from dbo.membershipEnrollment ME full join dbo.MembershipPlans MP
on ME.membershipId = MP.MembershipPlanID full join dbo.person P
on P.personId = ME.personId
go

select * from UserMembershipInfo
go







-------------  book borrow trigger ------------------------------------------------------




--Create Statements
USE Team4FinalPrj;

/*
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

create table StudySpace_Category (
	StudySpace_CategoryID int not null primary key identity,
	categoryCapacity int,
	categoryName varchar(20)
		constraint chk_spaceCategoryName check(categoryName in ('Group', 'Graduate', 'Colab', 'Video Conferencing'))
)


create table StudySpace (
	SpaceID int not null primary key identity,
	SpaceName varchar(10),
	categoryId int not null references StudySpace_Category(StudySpace_categoryID)
)

create table SpaceBooking (
	bookingId int not null primary key,
	duration int
	 constraint chk_duration check(duration between 1 and 4),
	startTime datetime default current_timestamp,	
	endTime as dateadd(hour, duration, startTime),
	PersonId int not null references Person(personId),
	spaceId int not null references StudySpace(spaceId),
)
select * from membershipPlans

*/

-- Table level Checkconstraint to allow a person to book only if a person has a premium membership
create function checkMembership (@personId int)
returns int
as
begin
	declare @count int = 0
	select @count  = count(enrollmentId)
	from membershipEnrollment
	where personId = @personId and MembershipPlanID = 2
	return @count;
end;

ALTER TABLE spaceBooking ADD CONSTRAINT chk_PremiumMembership CHECK 
(dbo.checkMembership(personId) > 0);

-- Trigger to Check if the booking for the room already exists
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

-- Column level function to find number of bookings for each study space category category 
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

alter table studySpace_Category 
add TotalBookings as (dbo.fn_calcCategoryBookings(studySpace_CategoryID))

--Insert Statements
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
  ('Rowan','Guerrero','aliquam.adipiscing@outlook.edu','1-524-826-1294', 20,'Faculty')

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
  (20,'8024','Ap #566-5475 Arcu Ave','Fort Wayne','Texas','United States');

insert into StudySpace_Category(categoryName, categoryCapacity) values ('Group', 6)
insert into StudySpace_Category(categoryName, categoryCapacity) values ('CoLab', 4)
insert into StudySpace_Category(categoryName, categoryCapacity) values ('Graduate', 3)
insert into StudySpace_Category(categoryName, categoryCapacity) values ('Video Conferencing', 6)

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

select * from SpaceBooking
select * from MembershipEnrollment
select * from MembershipPlans
select * from StudySpace
select * from StudySpace_Category

insert into SpaceBooking(bookingId, duration, startTime, PersonId, spaceId)
values(102, 3, '2022-07-28 8:30', 8, 5)
insert into SpaceBooking(bookingId, duration, startTime, PersonId, spaceId)
values(103, 2, '2022-07-28 9:00', 9, 6)
insert into SpaceBooking(bookingId, duration, startTime, PersonId, spaceId)
values(104, 3, '2022-07-28 2:30', 8, 6)
insert into SpaceBooking(bookingId, duration, startTime, PersonId, spaceId)
values(105, 2, '2022-07-28 19:30', 9, 6)
insert into SpaceBooking(bookingId, duration, startTime, PersonId, spaceId)
values(106, 3, '2022-07-28 11:30', 8, 2)
insert into SpaceBooking(bookingId, duration, startTime, PersonId, spaceId)
values(107, 1, '2022-07-28 17:30', 10, 2)
insert into SpaceBooking(bookingId, duration, startTime, PersonId, spaceId)
values(108, 2, '2022-07-28 1:30', 9, 2)
insert into SpaceBooking(bookingId, duration, startTime, PersonId, spaceId)
values(109, 3, '2022-07-28 19:30', 10, 1)

insert into SpaceBooking(bookingId, duration, startTime, PersonId, spaceId)
values(110, 3, '2022-07-28 19:30', 7, 18)
insert into SpaceBooking(bookingId, duration, startTime, PersonId, spaceId)
values(111, 3, '2022-07-28 20:30', 8, 19)
insert into SpaceBooking(bookingId, duration, startTime, PersonId, spaceId)
values(112, 3, '2022-07-28 7:30', 6, 18)
insert into SpaceBooking(bookingId, duration, startTime, PersonId, spaceId)
values(113, 3, '2022-07-28 19:00', 7, 20)
insert into SpaceBooking(bookingId, duration, startTime, PersonId, spaceId)
values(114, 3, '2022-07-28 16:00', 9, 23)
insert into SpaceBooking(bookingId, duration, startTime, PersonId, spaceId)
values(115, 3, '2022-07-28 16:00', 10, 24)
insert into SpaceBooking(bookingId, duration, startTime, PersonId, spaceId)
values(116, 3, '2022-07-28 13:30', 8, 22)
insert into SpaceBooking(bookingId, duration, startTime, PersonId, spaceId)
values(117, 3, '2022-07-28 15:30', 6, 21)
insert into SpaceBooking(bookingId, duration, startTime, PersonId, spaceId)
values(118, 3, '2022-07-28 12:30', 6, 25)

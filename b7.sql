-- 1
use Chinook;

-- 2
create view View_Track_Details 
as
select t.TrackId, t.Name as Track_Name, a.Title as Album_Title, ar.Name as Artist_Name, t.UnitPrice
from Track t
join Album a on t.AlbumId = a.AlbumId
join Artist ar on a.ArtistId = ar.ArtistId
where t.UnitPrice > 0.99;

select * from View_Track_Details;

-- 3
create view View_Customer_Invoice 
as
select c.CustomerId, concat(c.LastName, ' ', c.FirstName) as FullName, c.Email, sum(i.Total) as Total_Spending, e.LastName as Support_Rep
from Customer c
join Invoice i on c.CustomerId = i.CustomerId
join Employee e on c.SupportRepId = e.EmployeeId
group by c.CustomerId, FullName, c.Email, e.LastName
having Total_Spending > 50;

select * from View_Customer_Invoice;

-- 4
create view View_Top_Selling_Tracks 
as
select t.TrackId, t.Name as Track_Name, g.Name as Genre_Name, sum(il.Quantity) as Total_Sales
from Track t
join InvoiceLine il on t.TrackId = il.TrackId
join Genre g on t.GenreId = g.GenreId
group by t.TrackId, t.Name, g.Name
having Total_Sales > 10;

select * from View_Top_Selling_Tracks;

-- 5
create index idx_Track_Name 
on Track (Name) using btree;

select * from Track
where Name like '%Love%';

explain analyze select * from Track
where Name like '%Love%';

-- 6
create index idx_Invoice_Total 
on Invoice (Total);

select * from Invoice
where Total between 20 and 100;

explain analyze select * from Invoice
where Total between 20 and 100;

-- 7
delimiter //
create procedure GetCustomerSpending (
    in CustomerId_in int,
    out TotalSpending decimal(10,2)
)
begin
    select coalesce(Total_Spending, 0) into TotalSpending
    from View_Customer_Invoice
    where CustomerId = CustomerId_in;
end //
delimiter ;
call GetCustomerSpending(1, @TotalSpending);
select @TotalSpending;

-- 8
delimiter //
create procedure SearchTrackByKeyword (
    in p_Keyword varchar(100)
)
begin
    select * from Track
    where Name like concat('%', p_Keyword, '%');
end //
delimiter ;
call SearchTrackByKeyword('lo');

-- 9
delimiter //
create procedure GetTopSellingTracks (
    in p_MinSales int,
    in p_MaxSales int
)
begin
    select * from View_Top_Selling_Tracks
    where Total_Sales between p_MinSales and p_MaxSales;
end //
delimiter ;
call GetTopSellingTracks(1, 10);

-- 10
drop view View_Track_Details;
drop view View_Customer_Invoice;
drop view View_Top_Selling_Tracks;

drop index idx_Track_Name on Track;
drop index idx_Invoice_Total on Invoice;

drop procedure GetCustomerSpending;
drop procedure SearchTrackByKeyword;
drop procedure GetTopSellingTracks;











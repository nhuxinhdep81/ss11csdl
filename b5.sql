-- 1 
use Chinook;
-- 2 khong can nop
-- 3
create view View_Album_Artist
as
	select a.AlbumId, a.title as Album_Title,  at.Name as Artist_Name
    from Album a 
    join Artist at on a.ArtistId = at.ArtistId;
    
-- 4
create view View_Customer_Spending
as
	select c.CustomerId, c.FirstName, c.LastName,c.Email, sum(i.total)
    from Customer c
    join invoice i on c.CustomerId = i.CustomerId
    group by c.CustomerId;
    
-- 5
create index dx_Employee_LastName on Employee(LastName);
explain analyze 
    select * from employee
    where LastName = 'King'
    
-- 6
delimiter //
create procedure GetTracksByGenre
(
	in GenreId_in int
)
begin

select t.TrackId, t.Name as TrackName, a.title as Album_Title, at.Name as Artist_name
from Artist at
join album a on at.ArtistId = a.ArtistId
join Track t on a.AlbumId = t.AlbumId
join Genre g on t.GenreID = g.GenreId
where g.GenreId = GenreId_in;
end //

delimiter //

call GetTracksByGenre(1);
drop procedure GetTracksByGenre


-- 7
delimiter //
create procedure GetTrackCountByAlbum
(
	in p_AlbumId int
)
begin 
select count(t.TrackId) as Total_Tracks
from Track t
where t.AlbumId = p_AlbumId
group by t.AlbumId;
end //
delimiter //

call GetTrackCountByAlbum(1);


-- 8
drop view View_Customer_Spending;
drop view View_Album_Artist;
drop index dx_Employee_LastName on Employee;
drop procedure GetTracksByGenre;
drop procedure GetTrackCountByAlbum;
















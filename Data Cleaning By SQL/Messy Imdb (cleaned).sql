Select * from imdb;

--------------------------------------------
-- Renaming wrong columns

EXEC sp_RENAME 'imdb.IMBD_title_ID' , 'title_id', 'COLUMN'
EXEC sp_RENAME 'imdb.Original_titl' , 'title', 'COLUMN'
EXEC sp_RENAME 'imdb.Genr' , 'genre', 'COLUMN'


--------------------------------------------
-- Delete null records and attributes

Select title_id From imdb 
Where title_id IS NULL;

Delete From imdb 
Where title_id IS NULL;

Alter Table imdb 
Drop Column column9;

-- Querying all unregesterd durations and fixing that by google search

SELECT title_id, title, Release_year, Duration FROM imdb 
WHERE ISNUMERIC(Duration) = 0 OR Duration not like '%[0-9]%';


Update imdb
Set Duration = 154
Where title_id = 'tt0110912'

Update imdb
Set Duration = 195
Where title_id = 'tt0108052'

Update imdb
Set Duration = 139
Where title_id = 'tt0137523'

Update imdb
Set Duration = 178
Where title_id = 'tt0120737'

Update imdb
Set Duration = 136
Where title_id = 'tt0133093'

Update imdb
Set Duration = 124
Where title_id = 'tt0080684'

Update imdb
Set Duration = 133
Where title_id = 'tt0073486'

--------------------------------------------
-- Unify release dates into a one format



Select title, Release_year From imdb 


Select title, Release_year From imdb 
Where ISDATE(Release_year) = 1 

Select title, Release_year From imdb 
Where Release_year not like '%[1-2][0-9][0-9][0-9]-[0-1][0-9]-[0-3][0-9]%'
----------------------------------------------
-- Two more rows with correct format but wrong dates!

Select title, Release_year From imdb 
Where ISDATE(Release_year) = 0 

----------------------------------------------
-- Exploring Solutions

if exists(select 1 from sys.views where name='ry' and type='v')
drop view ry;
go

Create View ry as 
Select title, release_year From imdb

Select * from ry


Select Case 
						When Release_year = '09 21 1972' Then '1972-09-21'
						When Release_year = '23 -07-2008' Then '2008-07-23'
						When Release_year = '22 Feb 04' Then '2004-02-22'
						When Release_year = '10-29-99' Then '1999-10-10'
						When Release_year = '23rd December of 1966 ' Then '1966-12-23'
						When Release_year = '01/16-03' Then '2003-01-16'
						When Release_year = '18/11/1976' Then '1976-11-18'
						When Release_year = '21-11-46' Then '1946-11-21'
						When Release_year = 'The 6th of marzo, year 1951' Then '1951-03-06'
						Else Release_year
						END 
From ry 

Update imdb 
Set Release_year = Case 
						When Release_year = '09 21 1972' Then '1972-09-21'
						When Release_year = '23 -07-2008' Then '2008-07-23'
						When Release_year = '22 Feb 04' Then '2004-02-22'
						When Release_year = '10-29-99' Then '1999-10-10'
						When Release_year = '23rd December of 1966 ' Then '1966-12-23'
						When Release_year = '01/16-03' Then '2003-01-16'
						When Release_year = '18/11/1976' Then '1976-11-18'
						When Release_year = '21-11-46' Then '1946-11-21'
						When Release_year = 'The 6th of marzo, year 1951' Then '1951-03-06'
						When Release_year = '1984-02-34' Then '1984-12-09'
						When Release_year = '1976-13-24' Then '1976-02-08'
						Else Release_year
						END 

Select * From imdb

----------------------
-- Unifying unlabeled Content_Rating

Select Distinct Content_Rating, Count(*) From imdb
Group by Content_Rating;

Select title, Content_Rating From imdb
Where Content_Rating = 'Unrated'

Select title, Content_Rating From imdb
Where Content_Rating = '#N/A'

Select title, Content_Rating From imdb
Where Content_Rating ='Approved'

Update imdb
Set Content_Rating = 'Not Avaialble'
Where Content_Rating ='Approved' or Content_Rating = '#N/A' or Content_Rating = 'Unrated'


------------------------------
-- Making the use of income column easier and adjust it

Select Income From imdb;

Select PARSENAME(Replace(Income, '$', '') , 1) 
From imdb 

EXEC sp_rename 'imdb.Income in $','Income_in_$', 'COLUMN' ;

Update imdb 
Set Income_in_$ = PARSENAME(Replace(Income_in_$, '$', '') , 1);


Select TITLE, Income_in_$ From imdb 
Where ISNUMERIC(Income_in_$) = 0


Update imdb
Set Income_in_$ =  48035783
Where ISNUMERIC(Income_in_$) = 0


Select title, income_in_$ from imdb
Where income_in_$ < 150000


Alter Table imdb
Alter Column income_in_$ bigint;

Select  Min(income_in_$), Max(income_in_$) From imdb;


-------------------------------
-- Score column modifications

Select title, Score From imdb
Where Score Not Like '[0-9].[0-9]'

Update imdb
Set Score = CASE
	   When Score like '9.' then '9.0'
	   When Score like '9,.0' then '9.0' 
	   When Score like '8,9f' then '8.9'
	   When Score like '08.9' then '8.9'
	   When Score like '8..8' then '8.8'
	   When Score like '8:8' then '8.8'
	   When Score like'++8.7' then '8.7'
	   When Score like '8.7.' then '8.7'
	   When Score like '8,7e-0' then '8.7'
	   When Score like '8,6' then '8.6'
	   Else Score 
	   END

Update imdb 
Set Score = 9.0
Where Score Not Like '[0-9].[0-9]'

-------------------------------------
-- Checking for Duplicates and the final product

Select distinct * from imdb 
Select * From imdb


-------------------------------------

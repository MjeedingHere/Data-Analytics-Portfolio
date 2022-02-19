Use Mjeefolio;

 -- Quick overview on the three tables
Select Top(20) * From Content;

Alter Table Content
Drop Column column1

Select Distinct Category From Content;

-- Replacing wrong values
Update Content
Set Category = Case 
						When Category = 'Animals' Then 'animals'
						When Category = '"animals"' Then 'animals'
						When Category = '"science"' Then 'science'
						When Category = '"food"' Then 'food'
						When Category = '"technology"' Then 'technology'
						When Category = '"technology"' Then 'technology'
						When Category = '"veganism"' Then 'veganism'
						When Category = '"dogs"' Then 'dogs'
						When Category = '"soccer"' Then 'soccer'
						When Category = '"cooking"' Then 'cooking'
						When Category = '"public speaking"' Then 'public speaking'
						When Category = '"studying"' Then 'studying'
						When Category = '"culture"' Then 'culture' 
						When Category = '"tennis"' Then 'tennis'

						Else Category
						END 


Select Category, Count(*)
From Content
Group By Category;



Select Top(20) * From Reactions;

Alter Table Reactions
Drop Column column1

Select Distinct Type From Reactions;

Select Top(20) * From ReactionTypes;

Alter Table ReactionTypes
Drop Column column1

Select Distinct Type,Sentiment 
From ReactionTypes
Order By Sentiment



-- Joining the Reactions table with Content table to get the contents that is being react on, 
-- then joining the resault with the last table to quantify the reactions and catagorize it into Sentiments and Score
Select r.Datetime, r.Type,
	   c.Category, 
	   rt.Sentiment, rt.Score into mergedAcc
From Reactions AS r
Left Join
	 Content AS c 
	 On r.Content_ID = c.Content_ID

Left Join
	 ReactionTypes AS rt on r.Type = rt.Type
;

-- Remove any reactions without scores

Select * 
From mergedAcc 
Where Score Is Null

Delete from mergedAcc
Where Score Is Null

Select * from mergedAcc

-- Notice the unnecessary details in the Datetime column (seconds - milliseconds)
select Cast(Datetime as smalldatetime) from mergedAcc

Alter Table mergedAcc
Add newDT smalldatetime;

Update mergedAcc
Set newDT = Cast(Datetime as smalldatetime)

Alter Table mergedAcc
Drop Column Datetime


-- Saving and checking the results then moving to Tableau
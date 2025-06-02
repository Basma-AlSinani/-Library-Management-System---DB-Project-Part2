use Library_Management_System
--===============Advanced Aggregations – Analytical Insight ======================
--HAVING for filtering aggregates
select M.Member_ID, M.F_Name + ' ' + M.L_Name AS MemberName, SUM(FP.Amount) AS TotalFines
from Member M
join Loan L On M.Member_Id=L.Member_Id
join Fine_Payment FP On L.Loan_ID=FP.Loan_ID
Group By M.Member_Id,M.F_Name,M.L_Name
Having SUM(FP.Amount)>20;

--===================================================================================
--Subqueries for complex logic
select Genre, Title, Price
from Book
where Price=(select MAX(price)
From Book B
where Genre = B.Genre);

--===================================================================================
--Members with loans but no fine
select DISTINCT M.Member_ID, M.F_Name + ' ' + M.L_Name AS MemberName
from Member M
Join Loan L On M.Member_ID = L.Member_ID
Left Join Fine_Payment FP ON L.Loan_ID = FP.Loan_ID
Where FP.Fine_Payment_Id IS NULL;

--===================================================================================
-- Genres with high average ratings
select B.Genre, AVG(R.Rating) AS AvgRating
From Book B
join Review R ON B.Book_ID=R.Book_ID
Group By B.Genre
having AVG(R.Rating)>3;
